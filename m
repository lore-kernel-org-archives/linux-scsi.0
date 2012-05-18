From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [PATCH 3/3 V2] alua: backoff alua rtpg retry linearly vs.
 geometrically
Date: Fri, 18 May 2012 18:19:43 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B067C42@SACEXCMBX02-PRD.hq.netapp.com>
References: <1337364536-6425-1-git-send-email-revers@redhat.com>
 <1337364536-6425-4-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:23272 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966175Ab2ERSTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2012 14:19:45 -0400
In-Reply-To: <1337364536-6425-4-git-send-email-revers@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Rob Evers
> Sent: Friday, May 18, 2012 1:09 PM
> To: linux-scsi@vger.kernel.org
> Subject: [PATCH 3/3 V2] alua: backoff alua rtpg retry linearly vs. geometrically
> 
> Currently the backoff algorithm for when to retry alua rtpg
> requests progresses geometrically as so:
> 
> 2, 4, 8, 16, 32, 64... seconds.
> 
> This progression can lead to un-needed delay in retrying
> alua rtpg requests when the rtpgs are delayed.  A less
> aggressive backoff algorithm that is additive would not
> lead to such large jumps when delays start getting long, but
> would backoff linearly:
> 
> 2, 4, 6, 8, 10... seconds.
> 
> Signed-off-by: Martin George <marting@netapp.com>
> Signed-off-by: Rob Evers <revers@redhat.com>

Reviewed-by: Babu Moger <babu.moger@netapp.com>

> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 51d8cf6..7eb9dea 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -522,7 +522,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct
> alua_dh_data *h)
>  	unsigned char *ucp;
>  	unsigned err;
>  	bool rtpg_ext_hdr_req = 1;
> -	unsigned long expiry, interval = 1000;
> +	unsigned long expiry, interval = 0;
>  	unsigned int tpg_desc_tbl_off;
>  	unsigned char orig_transition_tmo;
> 
> @@ -625,7 +625,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct
> alua_dh_data *h)
>  	case TPGS_STATE_TRANSITIONING:
>  		if (time_before(jiffies, expiry)) {
>  			/* State transition, retry */
> -			interval *= 2;
> +			interval += 2000;
>  			msleep(interval);
>  			goto retry;
>  		}
> --
> 1.7.7.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
