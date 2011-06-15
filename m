From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch 4/4] SCSI: target: off by one in tcm_loop_make_naa_tpg()
Date: Wed, 15 Jun 2011 09:42:44 -0700
Message-ID: <1308156164.20109.14.camel@haakon2.linux-iscsi.org>
References: <20110613201219.GK3583@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56103 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1FOQv2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 12:51:28 -0400
In-Reply-To: <20110613201219.GK3583@shale.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org, target-devel <target-devel@vger.kernel.org>

On Mon, 2011-06-13 at 23:12 +0300, Dan Carpenter wrote:
> There are TL_TPGS_PER_HBA elements in the ->tl_hba_tpgs[] array so
> this test is off by one.  Later when we take the pointer, it would
> be one past the end and we'd crash:
> 
> 	tl_tpg = &tl_hba->tl_hba_tpgs[tpgt];
> 	tl_tpg->tl_hba = tl_hba;
> 
> I think this can only be triggered by root.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Ok, so I had merged this patch some time ago into lio-core-2.6.git, but
did not make it to mainline.

I will include this patch along with your other bugfixes in a pull to
Linus for v3.0-rc4 soon.

Thanks Dan!

--nab

> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 7329d0e..4fedb58 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -1227,7 +1227,7 @@ struct se_portal_group *tcm_loop_make_naa_tpg(
>  	tpgt_str += 5; /* Skip ahead of "tpgt_" */
>  	tpgt = (unsigned short int) simple_strtoul(tpgt_str, &end_ptr, 0);
>  
> -	if (tpgt > TL_TPGS_PER_HBA) {
> +	if (tpgt >= TL_TPGS_PER_HBA) {
>  		printk(KERN_ERR "Passed tpgt: %hu exceeds TL_TPGS_PER_HBA:"
>  				" %u\n", tpgt, TL_TPGS_PER_HBA);
>  		return ERR_PTR(-EINVAL);

