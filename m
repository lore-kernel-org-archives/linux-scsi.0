From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/4] scsi: scsi_dh_alua: allow I/O in the target port
 unavailable state
Date: Thu, 13 Apr 2017 21:14:14 +0000
Message-ID: <1492118053.24345.20.camel@sandisk.com>
References: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
         <1491873481-23900-2-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:53193 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdDMVOX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2017 17:14:23 -0400
In-Reply-To: <1491873481-23900-2-git-send-email-mauricfo@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <512EE2940CFFFB4783DF2CB3F53C2AC5@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2017-04-10 at 22:17 -0300, Mauricio Faria de Oliveira wrote:
> According to SPC-4 (5.15.2.4.5 Unavailable state), the unavailable
> state may (or may not) transition to other states (e.g., microcode
> downloading or hardware error, which may be temporary or permanent
> conditions, respectively).
>=20
> But, scsi_dh_alua currently fails the I/O requests early once that
> state is established (in alua_prep_fn()), which provides no chance
> for path checkers going through that function path to really check
> whether the path actually still fails I/O requests or recovered to
> an active state.
>=20
> This might cause device-mapper multipath to fail all paths to some
> storage system that moves the controllers to the unavailable state
> for firmware upgrades, and never recover regardless of the storage
> system doing upgrades one controller at a time and get them online.
>=20
> Then I/O requests are blocked indefinitely due to queue_if_no_path
> but the underlying individual paths are fully operational, and can
> be verified as such through other function paths (e.g., SG_IO):
>=20
>     # multipath -l
>     mpatha (360050764008100dac000000000000100) dm-0 IBM,2145
>     size=3D40G features=3D'2 queue_if_no_path retain_attached_hw_handler'
>     hwhandler=3D'1 alua' wp=3Drw
>     |-+- policy=3D'service-time 0' prio=3D0 status=3Denabled
>     | |- 1:0:1:0 sdf 8:80  failed undef running
>     | `- 2:0:1:0 sdn 8:208 failed undef running
>     `-+- policy=3D'service-time 0' prio=3D0 status=3Denabled
>       |- 1:0:0:0 sdb 8:16  failed undef running
>       `- 2:0:0:0 sdj 8:144 failed undef running
>=20
>     # strace -e read \
>         sg_dd if=3D/dev/sdj of=3D/dev/null bs=3D512 count=3D1 iflag=3Ddir=
ect \
>         2>&1 | grep 512
>     read(3, 0x3fff7ba80000, 512) =3D -1 EIO (Input/output error)
>=20
>     # strace -e ioctl \
>         sg_dd if=3D/dev/sdj of=3D/dev/null bs=3D512 count=3D1 iflag=3Ddir=
ect \
>         blk_sgio=3D1 \
>         2>&1 | grep 512
>     ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=3D[28, 00, 00, 00,
>     00, 00, 00, 00, 01, 00], <...>) =3D 0
>=20
> So, allow I/O to target port (groups) in the unavailable state, so the
> path checkers can actually check them, and schedule a recheck whenever
> the unavailable state is detected so pg->state can be updated properly
> (and further SCSI IO error messages then silenced through alua_prep_fn())=
.
>=20
> Once a path checker eventually detects an active state again, the port
> group state will be updated by the path activation call, alua_activate(),
> as it schedules an alua_rtpg() check.
>=20
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/de=
vice_handler/scsi_dh_alua.c
> index c01b47e5b55a..5e5a33cac951 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -431,6 +431,20 @@ static int alua_check_sense(struct scsi_device *sdev=
,
>  			alua_check(sdev, false);
>  			return NEEDS_RETRY;
>  		}
> +		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x0c) {
> +			/*
> +			 * LUN Not Accessible - target port in unavailable state.
> +			 *
> +			 * It may (not) be possible to transition to other states;
> +			 * the transition might take a while or not happen at all,
> +			 * depending on the storage system model, error type, etc.
> +			 *
> +			 * Do not retry, so failover to another target port occur.
> +			 * Schedule a recheck to update state for other functions.
> +			 */
> +			alua_check(sdev, true);
> +			return SUCCESS;
> +		}
>  		break;
>  	case UNIT_ATTENTION:
>  		if (sense_hdr->asc =3D=3D 0x29 && sense_hdr->ascq =3D=3D 0x00) {
> @@ -1057,6 +1071,8 @@ static void alua_check(struct scsi_device *sdev, bo=
ol force)
>   *
>   * Fail I/O to all paths not in state
>   * active/optimized or active/non-optimized.
> + * Allow I/O to all paths in state unavailable
> + * so path checkers can actually check them.
>   */
>  static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
>  {
> @@ -1072,6 +1088,8 @@ static int alua_prep_fn(struct scsi_device *sdev, s=
truct request *req)
>  	rcu_read_unlock();
>  	if (state =3D=3D SCSI_ACCESS_STATE_TRANSITIONING)
>  		ret =3D BLKPREP_DEFER;
> +	else if (state =3D=3D SCSI_ACCESS_STATE_UNAVAILABLE)
> +		req->rq_flags |=3D RQF_QUIET;
>  	else if (state !=3D SCSI_ACCESS_STATE_OPTIMAL &&
>  		 state !=3D SCSI_ACCESS_STATE_ACTIVE &&
>  		 state !=3D SCSI_ACCESS_STATE_LBA) {

Hello Mauricio,

Please also add support for the "standby" state to both alua_check_sense()
and alua_prep_fn() while you are modifying these functions.

Thanks,

Bart.=
