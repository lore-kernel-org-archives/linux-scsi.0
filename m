From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/5]  arcmsr: Modify ARC-1214 IO Behavior
Date: Fri, 30 Nov 2012 09:18:21 +0000
Message-ID: <1354267101.2259.11.camel@dabdike.int.hansenpartnership.com>
References: <BFB9B1E1DD3748D895CE90958A9D95CA@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41256 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206Ab2K3JSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Nov 2012 04:18:25 -0500
In-Reply-To: <BFB9B1E1DD3748D895CE90958A9D95CA@arecaaebe11fae>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: NickCheng <nick.cheng@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@kernel.org

On Fri, 2012-11-16 at 19:56 +0800, NickCheng wrote:
> From: Nick Cheng <nick.cheng@areca.com.tw>
> 
> Modify ARC-1214 IO behavior to make up for HW seldom malfunction.
> Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>

This still isn't right.  I said you could ignore most of the warnings
(like lines over 80 characters), but you have a lot of this:


> -			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
> acb->host->host_no);
> +			pr_notice("arcmsr%d: memory mapping"
> +				"region fail\n", acb->host->host_no);

I'm agnostic on whether you split a print, in spite of the warning but I
do tend to prefer longer lines, since they avoid the mistake you made
quite a few times, which is not leaving a space between the separate
words in the split string.  This will produce a message like

arcmsr1: memory mappingregion fail

Plus this indentation


> -		if (readl(&acb->pmuC->outbound_doorbell) & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
> -			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, &acb->pmuC->outbound_doorbell_clear);/*clear interrupt*/=0A=
> +		if (readl(&acb->pmuC->outbound_doorbell) &
> +			ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
>    +		writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
> +				&acb->pmuC->outbound_doorbell_clear);

Is being changed from correctly indented to incorrectly indented (writel
needs another tab).

James


