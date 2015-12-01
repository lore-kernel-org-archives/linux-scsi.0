From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 11/18] scsi_dh_alua: use flag for RTPG extended header
Date: Tue, 01 Dec 2015 11:13:18 +0100
Message-ID: <1448964798.3103.10.camel@suse.com>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
	 <1448961418-29013-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbbLAKNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 05:13:20 -0500
In-Reply-To: <1448961418-29013-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, 2015-12-01 at 10:16 +0100, Hannes Reinecke wrote:
> We should be using a flag when RTPG extended header is not
> supported, that saves us sending RTPG twice for older arrays.
>=20
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 15 +++++++--------
> =C2=A01 file changed, 7 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index ea626732..03f8190 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -59,8 +59,9 @@
> =C2=A0#define ALUA_FAILOVER_TIMEOUT		60
> =C2=A0#define ALUA_FAILOVER_RETRIES		5
> =C2=A0
> -/* flags passed from user level */
> +/* device handler flags */
> =C2=A0#define ALUA_OPTIMIZE_STPG		1
> +#define ALUA_RTPG_EXT_HDR_UNSUPP	2
> =C2=A0
> =C2=A0struct alua_dh_data {
> =C2=A0	int			group_id;
> @@ -134,8 +135,7 @@ static struct request *get_alua_req(struct scsi_d=
evice
> *sdev,
> =C2=A0 * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
> =C2=A0 * @sdev: sdev the command should be sent to
> =C2=A0 */
> -static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh=
_data
> *h,
> -			=C2=A0=C2=A0=C2=A0=C2=A0bool rtpg_ext_hdr_req)
> +static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh=
_data
> *h)
> =C2=A0{
> =C2=A0	struct request *rq;
> =C2=A0	int err =3D 0;
> @@ -148,7 +148,7 @@ static unsigned submit_rtpg(struct scsi_device *s=
dev,
> struct alua_dh_data *h,
> =C2=A0
> =C2=A0	/* Prepare the command. */
> =C2=A0	rq->cmd[0] =3D MAINTENANCE_IN;
> -	if (rtpg_ext_hdr_req)
> +	if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP))
> =C2=A0		rq->cmd[1] =3D MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
> =C2=A0	else
> =C2=A0		rq->cmd[1] =3D MI_REPORT_TARGET_PGS;
> @@ -490,7 +490,6 @@ static int alua_rtpg(struct scsi_device *sdev, st=
ruct
> alua_dh_data *h, int wait_
> =C2=A0	int len, k, off, valid_states =3D 0;
> =C2=A0	unsigned char *ucp;
> =C2=A0	unsigned err, retval;
> -	bool rtpg_ext_hdr_req =3D 1;
> =C2=A0	unsigned long expiry, interval =3D 0;
> =C2=A0	unsigned int tpg_desc_tbl_off;
> =C2=A0	unsigned char orig_transition_tmo;
> @@ -501,7 +500,7 @@ static int alua_rtpg(struct scsi_device *sdev, st=
ruct
> alua_dh_data *h, int wait_
> =C2=A0		expiry =3D round_jiffies_up(jiffies + h->transition_tmo * HZ)=
;
> =C2=A0
> =C2=A0 retry:
> -	retval =3D submit_rtpg(sdev, h, rtpg_ext_hdr_req);
> +	retval =3D submit_rtpg(sdev, h);
> =C2=A0	if (retval) {
> =C2=A0		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
> =C2=A0					=C2=A0=C2=A0&sense_hdr)) {
> @@ -521,10 +520,10 @@ static int alua_rtpg(struct scsi_device *sdev, =
struct
> alua_dh_data *h, int wait_
> =C2=A0		=C2=A0* The retry without rtpg_ext_hdr_req set
> =C2=A0		=C2=A0* handles this.
> =C2=A0		=C2=A0*/
> -		if (rtpg_ext_hdr_req =3D=3D 1 &&
> +		if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0sense_hdr.sense_key =3D=3D ILLEGAL_RE=
QUEST &&
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0sense_hdr.asc =3D=3D 0x24 && sense_hd=
r.ascq =3D=3D 0) {
> -			rtpg_ext_hdr_req =3D 0;
> +			h->flags |=3D ALUA_RTPG_EXT_HDR_UNSUPP;
> =C2=A0			goto retry;
> =C2=A0		}
> =C2=A0

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
