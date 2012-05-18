From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [PATCH 1/3 V2] alua: implement 'implied transition timeout'
Date: Fri, 18 May 2012 18:17:55 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B067C1E@SACEXCMBX02-PRD.hq.netapp.com>
References: <1337364536-6425-1-git-send-email-revers@redhat.com>
 <1337364536-6425-2-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:64706 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932754Ab2ERSR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2012 14:17:57 -0400
In-Reply-To: <1337364536-6425-2-git-send-email-revers@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Rob Evers
> Sent: Friday, May 18, 2012 1:09 PM
> To: linux-scsi@vger.kernel.org
> Subject: [PATCH 1/3 V2] alua: implement 'implied transition timeout'
> 
> During alua transitions, an array can return transitioning
> status in response to rtpg requests.  These requests get
> retried for a maximum of 60 seconds by default before timing
> out.  Sometimes this timeout isn't sufficient to allow the
> array to complete the transition.  T10-spc4 addresses this
> under 'Report Target Port Groups' command.
> 
> This update retrieves the timeout value from the storage
> array if available and retries the transitioning rtpgs
> for up to the 'implied transitioning timeout' value
> 
> Signed-off-by: Rob Evers <revers@redhat.com>

Reviewed-by: Babu Moger <babu.moger@netapp.com>

> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c |   41
> ++++++++++++++++++++++++---
>  include/scsi/scsi.h                        |    2 +
>  2 files changed, 38 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 04c5cea..6a7efd3 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -46,13 +46,16 @@
>  #define TPGS_SUPPORT_OFFLINE		0x40
>  #define TPGS_SUPPORT_TRANSITION		0x80
> 
> +#define RTPG_FMT_MASK			0x70
> +#define RTPG_FMT_EXT_HDR		0x10
> +
>  #define TPGS_MODE_UNINITIALIZED		 -1
>  #define TPGS_MODE_NONE			0x0
>  #define TPGS_MODE_IMPLICIT		0x1
>  #define TPGS_MODE_EXPLICIT		0x2
> 
>  #define ALUA_INQUIRY_SIZE		36
> -#define ALUA_FAILOVER_TIMEOUT		(60 * HZ)
> +#define ALUA_FAILOVER_TIMEOUT		60
>  #define ALUA_FAILOVER_RETRIES		5
> 
>  struct alua_dh_data {
> @@ -63,6 +66,7 @@ struct alua_dh_data {
>  	unsigned char		inq[ALUA_INQUIRY_SIZE];
>  	unsigned char		*buff;
>  	int			bufflen;
> +	unsigned char		transition_tmo;
>  	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
>  	int			senselen;
>  	struct scsi_device	*sdev;
> @@ -123,7 +127,7 @@ static struct request *get_alua_req(struct scsi_device
> *sdev,
>  	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT
> |
>  			 REQ_FAILFAST_DRIVER;
>  	rq->retries = ALUA_FAILOVER_RETRIES;
> -	rq->timeout = ALUA_FAILOVER_TIMEOUT;
> +	rq->timeout = ALUA_FAILOVER_TIMEOUT * HZ;
> 
>  	return rq;
>  }
> @@ -180,7 +184,7 @@ static unsigned submit_rtpg(struct scsi_device *sdev,
> struct alua_dh_data *h)
> 
>  	/* Prepare the command. */
>  	rq->cmd[0] = MAINTENANCE_IN;
> -	rq->cmd[1] = MI_REPORT_TARGET_PGS;
> +	rq->cmd[1] = MI_REPORT_TARGET_PGS |
> MI_EXT_HDR_PARAM_FMT;
>  	rq->cmd[6] = (h->bufflen >> 24) & 0xff;
>  	rq->cmd[7] = (h->bufflen >> 16) & 0xff;
>  	rq->cmd[8] = (h->bufflen >>  8) & 0xff;
> @@ -514,8 +518,14 @@ static int alua_rtpg(struct scsi_device *sdev, struct
> alua_dh_data *h)
>  	unsigned char *ucp;
>  	unsigned err;
>  	unsigned long expiry, interval = 1000;
> +	unsigned int tpg_desc_tbl_off;
> +	unsigned char orig_transition_tmo;
> +
> +	if (!h->transition_tmo)
> +		expiry = round_jiffies_up(jiffies +
> ALUA_FAILOVER_TIMEOUT * HZ);
> +	else
> +		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
> 
> -	expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT);
>   retry:
>  	err = submit_rtpg(sdev, h);
> 
> @@ -551,7 +561,28 @@ static int alua_rtpg(struct scsi_device *sdev, struct
> alua_dh_data *h)
>  		goto retry;
>  	}
> 
> -	for (k = 4, ucp = h->buff + 4; k < len; k += off, ucp += off) {
> +	orig_transition_tmo = h->transition_tmo;
> +	if ((h->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && h-
> >buff[5] != 0)
> +		h->transition_tmo = h->buff[5];
> +	else
> +		h->transition_tmo = ALUA_FAILOVER_TIMEOUT;
> +
> +	if (orig_transition_tmo != h->transition_tmo) {
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: transition timeout set to %d seconds\n",
> +			    ALUA_DH_NAME, h->transition_tmo);
> +		expiry = jiffies + h->transition_tmo * HZ;
> +	}
> +
> +	if ((h->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
> +		tpg_desc_tbl_off = 8;
> +	else
> +		tpg_desc_tbl_off = 4;
> +
> +	for (k = tpg_desc_tbl_off, ucp = h->buff + tpg_desc_tbl_off;
> +	     k < len;
> +	     k += off, ucp += off) {
> +
>  		if (h->group_id == (ucp[2] << 8) + ucp[3]) {
>  			h->state = ucp[0] & 0x0f;
>  			valid_states = ucp[1];
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index f34a5a8..c6f0974 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -161,6 +161,8 @@ struct scsi_cmnd;
>  #define MI_REPORT_PRIORITY   0x0e
>  #define MI_REPORT_TIMESTAMP  0x0f
>  #define MI_MANAGEMENT_PROTOCOL_IN 0x10
> +/* value for MI_REPORT_TARGET_PGS ext header */
> +#define MI_EXT_HDR_PARAM_FMT  0x20
>  /* values for maintenance out */
>  #define MO_SET_IDENTIFYING_INFORMATION 0x06
>  #define MO_SET_TARGET_PGS     0x0a
> --
> 1.7.7.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
