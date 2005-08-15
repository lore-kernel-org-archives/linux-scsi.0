From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 4/4] cciss 2.4: fixes a warning from cciss_scsi.c during compile
Date: Tue, 16 Aug 2005 01:55:49 +0400
Message-ID: <20050815215549.GA27758@mipter.zuzino.mipt.ru>
References: <20050815212425.GE12760@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.202]:15277 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S964990AbVHOVrK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 17:47:10 -0400
Received: by wproxy.gmail.com with SMTP id i2so1072217wra
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 14:47:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20050815212425.GE12760@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: marcelo.tosatti@cyclades.com, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Aug 15, 2005 at 04:24:25PM -0500, mikem wrote:
> This patch fixes a warning during compile.

> --- lx2431-p003/drivers/block/cciss_scsi.c
> +++ lx2431/drivers/block/cciss_scsi.c
> @@ -220,8 +220,7 @@ scsi_cmd_stack_free(int ctlr)
>  		printk( "cciss: %d scsi commands are still outstanding.\n",
>  			CMD_STACK_SIZE - stk->top);
>  		// BUG();
> -		printk("WE HAVE A BUG HERE!!! stk=0x%08x\n",
> -			(unsigned int) stk);
> +		printk("WE HAVE A BUG HERE!!! stk=0x%p\n", stk);

If we have a BUG() here why it's commented out? If we don't, remove
printk() together with BUG().

