From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: [PATCH 1/2] replace sizeof sense_buffer with
 SCSI_SENSE_BUFFERSIZE
Date: Fri, 4 Jan 2008 23:05:42 +0900
Message-ID: <20080104230840K.tomof@acm.org>
References: <5dc13e4823ec8c254e5164a51249f05983fa00c2.tomof@acm.org>
	<20080103135905X.tomof@acm.org>
	<AE4F746F2AECFC4DA4AADD66A1DFEF01010A4697@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:47518 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYADOGD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jan 2008 09:06:03 -0500
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01010A4697@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mark_salyzyn@adaptec.com
Cc: tomof@acm.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jpfujita.tomonori@lab.ntt.co.jp

On Thu, 3 Jan 2008 11:10:04 -0500
"Salyzyn, Mark" <mark_salyzyn@adaptec.com> wrote:

> ACK on aacraid/ips/dpt_i2o bits. Inspected others, this patch IS inert.

Thanks!


> NitMeBeingStupidAndAddingARiderToTheBill: I know it was a grep/replace.
> If you need to respin because of Boaz and do not mind, do not hesitate
> to optimize (?) and instead do:
> 
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index 70f48a1..c6380c0 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -2298,7 +2298,6 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply,
> struct scsi_cmnd* cmd)
>  		// copy over the request sense data if it was a check
>  		// condition status
> -		if(dev_status == 0x02 /*CHECK_CONDITION*/) {
> -			u32 len = sizeof(cmd->sense_buffer);
> -			len = (len > 40) ?  40 : len;
> +		if (dev_status == 0x02 /*CHECK_CONDITION*/) {
> +			u32 len = (SCSI_SENSE_BUFFERSIZE > 40) ?  40 :
> SCSI_SENSE_BUFFERSIZE;
>  			// Copy over the sense data
>  			memcpy_fromio(cmd->sense_buffer, (reply+28) ,
> len);

I see. I'll do if I need to send an updated patch.
