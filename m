From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/4] scsi: scsi_dh_alua: allow I/O in target port
 unavailable and standby states
Date: Tue, 11 Jul 2017 11:18:28 +0200
Message-ID: <b6e97d03-0e1b-df2a-70e2-3247833f3aac@suse.de>
References: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <1499726857-7875-2-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499726857-7875-2-git-send-email-mauricfo@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/11/2017 12:47 AM, Mauricio Faria de Oliveira wrote:
> According to SPC-4 (5.15.2.4.5 Unavailable state), the unavailable
> state may (or may not) transition to other states (e.g., microcode
> downloading or hardware error, which may be temporary or permanent).
> 
> But, scsi_dh_alua currently fails I/O requests early on once that
> state occurs (in alua_prep_fn()) preventing path checkers in such
> function path to actually check if I/O still fails or now works.
> 
> And that prevents a path activation (alua_activate()) which could
> update the PG state if it eventually recovered to an active state,
> thus resume I/O. (This is also the case with the standby state.)
> 
> This might cause device-mapper multipath to fail all paths to some
> storage system that moves the controllers to the unavailable state
> for firmware upgrades, and never recover regardless of the storage
> system doing upgrades one controller at a time and get them online.
> 
> Then I/O requests are blocked indefinitely due to queue_if_no_path
> but the underlying individual paths are fully operational, and can
> be verified as such through other function paths (e.g., SG_IO):
> 
>     # multipath -l
>     mpatha (360050764008100dac000000000000100) dm-0 IBM,2145
>     size=40G features='2 queue_if_no_path retain_attached_hw_handler'
>     hwhandler='1 alua' wp=rw
>     |-+- policy='service-time 0' prio=0 status=enabled
>     | |- 1:0:1:0 sdf 8:80  failed undef running
>     | `- 2:0:1:0 sdn 8:208 failed undef running
>     `-+- policy='service-time 0' prio=0 status=enabled
>       |- 1:0:0:0 sdb 8:16  failed undef running
>       `- 2:0:0:0 sdj 8:144 failed undef running
> 
>     # strace -e read \
>         sg_dd blk_sgio=0 \
>         if=/dev/sdj of=/dev/null bs=512 count=1 iflag=direct \
>         2>&1 | grep 512
>     read(3, 0x3fff7ba80000, 512) = -1 EIO (Input/output error)
> 
>     # strace -e ioctl \
>         sg_dd blk_sgio=1 \
>         if=/dev/sdj of=/dev/null bs=512 count=1 iflag=direct \
>         2>&1 | grep 512
>     ioctl(3, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[10]=[28, 00, 00, 00,
>     00, 00, 00, 00, 01, 00], <...>) = 0
> 
> So, allow I/O to paths of PGs in unavailable/standby state, so path
> checkers can actually check them.
> 
> Also, schedule a recheck when unavailable/standby state is detected
> (in alua_check_sense()) to update pg->state, and quiet further SCSI
> error messages (in alua_prep_fn()).
> 
> Once a path checker eventually detects a working/active state again,
> the PG state is normally updated on path activation (alua_activate(),
> as it schedules a recheck), thus I/O requests are no longer failed.
> 
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
> 
> ---
> v2:
> - also add support for standby state to alua_check_sense(), alua_prep_fn()
>   (Bart Van Assche <Bart.VanAssche@sandisk.com>)
> 
>  drivers/scsi/device_handler/scsi_dh_alua.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index c01b47e5b55a..a1cf3d6aa853 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -431,6 +431,26 @@ static int alua_check_sense(struct scsi_device *sdev,
>  			alua_check(sdev, false);
>  			return NEEDS_RETRY;
>  		}
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0b) {
> +			/*
> +			 * LUN Not Accessible - target port in standby state.
> +			 *
> +			 * Do not retry, so failover to another target port occur.
> +			 * Schedule a recheck to update state for other functions.
> +			 */
> +			alua_check(sdev, true);
> +			return SUCCESS;
> +		}
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0c) {
> +			/*
> +			 * LUN Not Accessible - target port in unavailable state.
> +			 *
> +			 * Do not retry, so failover to another target port occur.
> +			 * Schedule a recheck to update state for other functions.
> +			 */
> +			alua_check(sdev, true);
> +			return SUCCESS;
> +		}
>  		break;
>  	case UNIT_ATTENTION:
>  		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
> @@ -1057,6 +1077,8 @@ static void alua_check(struct scsi_device *sdev, bool force)
>   *
>   * Fail I/O to all paths not in state
>   * active/optimized or active/non-optimized.
> + * Allow I/O to paths in state unavailable/standby
> + * so path checkers can actually check them.
>   */
>  static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
>  {
> @@ -1072,6 +1094,9 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
>  	rcu_read_unlock();
>  	if (state == SCSI_ACCESS_STATE_TRANSITIONING)
>  		ret = BLKPREP_DEFER;
> +	else if (state == SCSI_ACCESS_STATE_UNAVAILABLE ||
> +		 state == SCSI_ACCESS_STATE_STANDBY)
> +		req->rq_flags |= RQF_QUIET;
>  	else if (state != SCSI_ACCESS_STATE_OPTIMAL &&
>  		 state != SCSI_ACCESS_STATE_ACTIVE &&
>  		 state != SCSI_ACCESS_STATE_LBA) {
> 
NACK.

The whole _point_ of having device handlers is to _avoid_ I/O errors
during booting.

And the ALUA checker is prepared to handle this situation properly.
The directio checker of course doesn't know about this, but then no-one
expected the directio checker to work with ALUA.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
