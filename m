From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] remove redundant BUG_ON
Date: Mon, 22 Jun 2009 11:02:58 -0500
Message-ID: <4A3FAB32.1020704@cs.wisc.edu>
References: <4A3FC2D7.60400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54027 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZFVQDm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Jun 2009 12:03:42 -0400
In-Reply-To: <4A3FC2D7.60400@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: abjoglek@cisco.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Roel Kluin wrote:
> sg_count is unsigned so if negative a wrap occurs and the second BUG_ON
> catches it.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index eabf365..c57cff4 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -260,7 +260,6 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
>  	char msg[2];
>  
>  	if (sg_count) {
> -		BUG_ON(sg_count < 0);
>  		BUG_ON(sg_count > FNIC_MAX_SG_DESC_CNT);
>  

I think they both could go. The shost sg tablesize is set to 
FNIC_MAX_SG_DESC_CNT and fnic uses scsi_dma_map, so the block and scsi 
layer should be doing the right thing. If we are worried about them, 
then maybe we should add BUG_ONs in the common code to check for all 
drivers.
