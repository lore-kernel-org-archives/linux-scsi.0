From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] ipr: Inquiry IOA page 0xC4 during initialization.
Date: Fri, 30 Oct 2015 17:08:30 -0500
Message-ID: <5633EA5E.2040104@linux.vnet.ibm.com>
References: <1446223749-17416-1-git-send-email-krisman@linux.vnet.ibm.com>
 <1446223749-17416-3-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:58024 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030338AbbJ3WIf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 18:08:35 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 30 Oct 2015 18:08:34 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 10E506E8040
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 17:56:43 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UM8Vxd57737260
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 22:08:31 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UM8V3C006417
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 18:08:31 -0400
In-Reply-To: <1446223749-17416-3-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: wenxiong@linux.vnet.ibm.com

On 10/30/2015 11:49 AM, Gabriel Krisman Bertazi wrote:
> diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
> index 69257c4..f0238cc 100644
> --- a/drivers/scsi/ipr.h
> +++ b/drivers/scsi/ipr.h
> @@ -849,6 +849,16 @@ struct ipr_inquiry_page0 {
>  	u8 page[IPR_INQUIRY_PAGE0_ENTRIES];
>  }__attribute__((packed));
> 
> +struct ipr_inquiry_pageC4 {
> +	u8 peri_qual_dev_type;
> +	u8 page_code;
> +	u8 reserved1;
> +	u8 len;
> +	u8 cache_cap[4];
> +#define IPR_CAP_SYNC_CACHE		0x08
> +	u8 reserved2[20];
> +}__attribute__((packed));

This triggers a couple complaints from checkpatch. You need a space after the },
which checkpatch flags as an error and __packed is preferred to __attribute__((packed)),
which is flagged as a warning. There are a couple of other warnings that checkpatch
issues in this series, so you might want to take a look at them, fixup, and resend.
We should probably spin a follow up patch to fix up the __attribute__ usage in ipr.h,
since you were simply being consistent with that.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

