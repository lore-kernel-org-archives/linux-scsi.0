From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 31/33] Fusion: sg chaining support
Date: Mon, 16 Jul 2007 22:20:13 +0900
Message-ID: <200707161320.l6GDKDRP006750@mbox.iij4u.or.jp>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
	<11845792691073-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41594 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935AbXGPNUw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 09:20:52 -0400
In-Reply-To: <11845792691073-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, fujita.tomonori@lab.ntt.co.jp

From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 31/33] Fusion: sg chaining support
Date: Mon, 16 Jul 2007 11:47:45 +0200

> Cc: Eric.Moore@lsi.com
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/message/fusion/mptscsih.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index d356173..f087249 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -297,7 +297,7 @@ nextSGEset:
>  		v2 = sg_dma_address(sg);
>  		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
>  
> -		sg++;		/* Get next SG element from the OS */
> +		sg = sg_next(sg);	/* Get next SG element from the OS */
>  		psge += (sizeof(u32) + sizeof(dma_addr_t));
>  		sgeOffset += (sizeof(u32) + sizeof(dma_addr_t));
>  		sg_done++;
> @@ -318,7 +318,7 @@ nextSGEset:
>  		v2 = sg_dma_address(sg);
>  		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
>  		/*
> -		sg++;
> +		sg = sg_next(sg);
>  		psge += (sizeof(u32) + sizeof(dma_addr_t));
>  		*/
>  		sgeOffset += (sizeof(u32) + sizeof(dma_addr_t));
> -- 

We also need this change?

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index f087249..a3e6170 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -289,7 +289,7 @@ nextSGEset:
 	for (ii=0; ii < (numSgeThisFrame-1); ii++) {
 		thisxfer = sg_dma_len(sg);
 		if (thisxfer == 0) {
-			sg ++; /* Get next SG element from the OS */
+			sg = sg_next(sg); /* Get next SG element from the OS */
 			sg_done++;
 			continue;
 		}
-- 
1.4.3.2

