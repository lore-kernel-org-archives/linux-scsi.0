From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Badness in device_release at drivers/base/core.c:84
Date: Fri, 1 Aug 2003 16:27:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030801232721.GA5249@beaverton.ibm.com>
References: <20030801182207.GA3759@blazebox.homeip.net> <20030801144455.450d8e52.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030801144455.450d8e52.akpm@osdl.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Diffie <diffie@blazebox.homeip.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

Andrew Morton [akpm@osdl.org] wrote:
> This patch should fix the oops.
> 
> As for why the proc reading code was unable to locate the HBA: dunno, but
> this is a first step.
> 
> Or maybe you don't have any adaptec controllers in the machine?
> 
> (jejb, please apply..)
> 
> 
>  25-akpm/drivers/scsi/aic7xxx_old/aic7xxx_proc.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/aic7xxx_old/aic7xxx_proc.c~aic7xxx_old-oops-fix drivers/scsi/aic7xxx_old/aic7xxx_proc.c
> --- 25/drivers/scsi/aic7xxx_old/aic7xxx_proc.c~aic7xxx_old-oops-fix	Fri Aug  1 14:41:14 2003
> +++ 25-akpm/drivers/scsi/aic7xxx_old/aic7xxx_proc.c	Fri Aug  1 14:41:20 2003
> @@ -92,7 +92,7 @@ aic7xxx_proc_info ( struct Scsi_Host *HB
>  
>    HBAptr = NULL;
>  
> -  for(p=first_aic7xxx; p->host != HBAptr; p=p->next)
> +  for(p=first_aic7xxx; p && p->host != HBAptr; p=p->next)
>      ;
>  
>    if (!p)

Is this really the right thing to add. The only purpose of these few lines
is a poor sanity check as down further in the code a pointer to the
structure is already present in hostdata. 

Adding the "p" is an indication that this drivers list got corrupted some
where.

I agree it may be better than an oops, but what else is invalid?

You need to have adaptec controllers in the system to get a procfs node
to read / write, but this error could be related to the node not getting
cleaned up correctly on a remove which a patch has previously been
posted.

-andmike
--
Michael Anderson
andmike@us.ibm.com
