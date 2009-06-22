From: "Abhijeet Joglekar (abjoglek)" <abjoglek@cisco.com>
Subject: RE: [PATCH] remove redundant BUG_ON
Date: Mon, 22 Jun 2009 11:15:08 -0700
Message-ID: <9E88C8678BF34240A8C61D4078A3D251017146FC@xmb-sjc-23e.amer.cisco.com>
References: <4A3FC55E.80108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15856 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZFVSPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2009 14:15:06 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4A3FC55E.80108@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

> -----Original Message-----
> From: Roel Kluin [mailto:roel.kluin@gmail.com] 
> Sent: Monday, June 22, 2009 10:55 AM
> To: Abhijeet Joglekar (abjoglek)
> Cc: linux-scsi@vger.kernel.org; Andrew Morton
> Subject: [PATCH] remove redundant BUG_ON
> 
> sg_count is unsigned. If negative, a wrap causes the second 
> BUG_ON to trigger.
> 
> scsi_dma_map may return -ENOMEM, sg_count should be int to catch that.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Please use this one instead.
> 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c 
> b/drivers/scsi/fnic/fnic_scsi.c index eabf365..22a7cd5 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -260,7 +260,6 @@ static inline int 
> fnic_queue_wq_copy_desc(struct fnic *fnic,
>  	char msg[2];
>  
>  	if (sg_count) {
> -		BUG_ON(sg_count < 0);
>  		BUG_ON(sg_count > FNIC_MAX_SG_DESC_CNT);
>  
>  		/* For each SGE, create a device desc entry */ 
> @@ -344,7 +343,7 @@ int fnic_queuecommand(struct scsi_cmnd 
> *sc, void (*done)(struct scsi_cmnd *))
>  	struct fnic *fnic;
>  	struct vnic_wq_copy *wq;
>  	int ret;
> -	u32 sg_count;
> +	int sg_count;
>  	unsigned long flags;
>  	unsigned long ptr;
>  
>

Roel,

The fix looks good. If dma_map_sg() would have failed, bad things would
happen since sg_count was u32. Good catch!

It will be better to change the sg_count parameter passed to
fnic_queue_wq_copy_desc to int too, so that it is consistent between the
2 functions. Do you want to add that to your patch or you want me to
send a patch for that?

The BUG_ON(sg_count < 0) can be dropped even though sg_count is an int
now, since fnic_queuecommand() checks for sg_count less than zero after
call to dma_map_sg.

Thanks
-- abhijeet


