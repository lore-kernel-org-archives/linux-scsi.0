From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [patch] 2.6.10-rc1: SCSI aacraid warning
Date: Fri, 29 Oct 2004 07:45:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1099061134.13961.2.camel@markh1.pdx.osdl.net>
References: <Pine.LNX.4.58.0410221431180.2101@ppc970.osdl.org>
	 <20041029143712.GM6677@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:48807 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S263378AbUJ2Osw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 10:48:52 -0400
In-Reply-To: <20041029143712.GM6677@stusta.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2004-10-29 at 16:37 +0200, Adrian Bunk wrote:
> On Fri, Oct 22, 2004 at 03:05:13PM -0700, Linus Torvalds wrote:
> >...
> > Summary of changes from v2.6.9 to v2.6.10-rc1
> > ============================================
> >...
> > Mark Haverkamp:
> >...
> >   o aacraid: dynamic dev update
> >...
> 
> 
> This causes the following warning with a recent gcc:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/scsi/aacraid/aachba.o
> drivers/scsi/aacraid/aachba.c: In function `aac_scsi_cmd':
> drivers/scsi/aacraid/aachba.c:1140: warning: integer constant is too large for "long" type
> ...
> 
> <--  snip  -->
> 
> 
> The fix is simple:
> 
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> --- linux-2.6.10-rc1-mm2-full/drivers/scsi/aacraid/aachba.c.old	2004-10-29 16:16:52.000000000 +0200
> +++ linux-2.6.10-rc1-mm2-full/drivers/scsi/aacraid/aachba.c	2004-10-29 16:22:14.000000000 +0200
> @@ -1137,7 +1137,7 @@
>  		char *cp;
>  
>  		dprintk((KERN_DEBUG "READ CAPACITY command.\n"));
> -		if (fsa_dev_ptr[cid].size <= 0x100000000)
> +		if (fsa_dev_ptr[cid].size <= 0x100000000ULL)
>  			capacity = fsa_dev_ptr[cid].size - 1;
>  		else
>  			capacity = (u32)-1;

Sorry about that, I have it fixed in my working version.  I must have
forgotten to add it to the patch.


-- 
Mark Haverkamp <markh@osdl.org>

