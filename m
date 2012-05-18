From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [PATCH 2/3 V2] alua: retry alua rtpg extended header for
 illegal request response
Date: Fri, 18 May 2012 18:19:03 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B067C30@SACEXCMBX02-PRD.hq.netapp.com>
References: <1337364536-6425-1-git-send-email-revers@redhat.com>
 <1337364536-6425-3-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:13577 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932790Ab2ERSTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2012 14:19:05 -0400
In-Reply-To: <1337364536-6425-3-git-send-email-revers@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Rob Evers
> Sent: Friday, May 18, 2012 1:09 PM
> To: linux-scsi@vger.kernel.org
> Subject: [PATCH 2/3 V2] alua: retry alua rtpg extended header for illegal
> request response
> 
> Some storage arrays are known to return 'illegal request'
> when an rtpg extended header request is made.  T10 says the
> array should ignore the bit, and return the non-extended
> rtpg as the array doesn't support the request.  Working
> around this by retrying the rtpg request without the extended
> header bit set when the extended rtpg request results in
> illegal request.
> 
> Signed-off-by: Rob Evers <revers@redhat.com>

Reviewed-by: Babu Moger <babu.moger@netapp.com>

> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c |   26
> +++++++++++++++++++++++---
>  1 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 6a7efd3..51d8cf6 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -173,7 +173,8 @@ done:
>   * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
>   * @sdev: sdev the command should be sent to
>   */
> -static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data
> *h)
> +static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data
> *h,
> +			    bool rtpg_ext_hdr_req)
>  {
>  	struct request *rq;
>  	int err = SCSI_DH_RES_TEMP_UNAVAIL;
> @@ -184,7 +185,10 @@ static unsigned submit_rtpg(struct scsi_device
> *sdev, struct alua_dh_data *h)
> 
>  	/* Prepare the command. */
>  	rq->cmd[0] = MAINTENANCE_IN;
> -	rq->cmd[1] = MI_REPORT_TARGET_PGS |
> MI_EXT_HDR_PARAM_FMT;
> +	if (rtpg_ext_hdr_req)
> +		rq->cmd[1] = MI_REPORT_TARGET_PGS |
> MI_EXT_HDR_PARAM_FMT;
> +	else
> +		rq->cmd[1] = MI_REPORT_TARGET_PGS;
>  	rq->cmd[6] = (h->bufflen >> 24) & 0xff;
>  	rq->cmd[7] = (h->bufflen >> 16) & 0xff;
>  	rq->cmd[8] = (h->bufflen >>  8) & 0xff;
> @@ -517,6 +521,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct
> alua_dh_data *h)
>  	int len, k, off, valid_states = 0;
>  	unsigned char *ucp;
>  	unsigned err;
> +	bool rtpg_ext_hdr_req = 1;
>  	unsigned long expiry, interval = 1000;
>  	unsigned int tpg_desc_tbl_off;
>  	unsigned char orig_transition_tmo;
> @@ -527,7 +532,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct
> alua_dh_data *h)
>  		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
> 
>   retry:
> -	err = submit_rtpg(sdev, h);
> +	err = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
> 
>  	if (err == SCSI_DH_IO && h->senselen > 0) {
>  		err = scsi_normalize_sense(h->sense,
> SCSI_SENSE_BUFFERSIZE,
> @@ -535,6 +540,21 @@ static int alua_rtpg(struct scsi_device *sdev, struct
> alua_dh_data *h)
>  		if (!err)
>  			return SCSI_DH_IO;
> 
> +		/*
> +		 * submit_rtpg() has failed on existing arrays
> +		 * when requesting extended header info, and
> +		 * the array doesn't support extended headers,
> +		 * even though it shouldn't according to T10.
> +		 * The retry without rtpg_ext_hdr_req set
> +		 * handles this.
> +		 */
> +		if (rtpg_ext_hdr_req == 1 &&
> +		    sense_hdr.sense_key == ILLEGAL_REQUEST &&
> +		    sense_hdr.asc == 0x24 && sense_hdr.ascq == 0) {
> +			rtpg_ext_hdr_req = 0;
> +			goto retry;
> +		}
> +
>  		err = alua_check_sense(sdev, &sense_hdr);
>  		if (err == ADD_TO_MLQUEUE && time_before(jiffies,
> expiry))
>  			goto retry;
> --
> 1.7.7.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
