From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH 5/6] drivers/scsi/bnx2fc/bnx2fc_hwi.c: introduce
 missing kfree
Date: Fri, 1 Apr 2011 14:23:06 -0700
Message-ID: <1301692986.4340.2.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
References: <1301667827-20056-5-git-send-email-julia@diku.dk>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1301667827-20056-5-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Nithin Sujir <nsujir@broadcom.com>, Michael Chan <mchan@broadcom.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-04-01 at 07:23 -0700, Julia Lawall wrote: 
> Error handling code following a kmalloc should free the allocated data.
> 
> The semantic match that finds the problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> statement S;
> expression E;
> identifier f,f1,l;
> position p1,p2;
> expression *ptr != NULL;
> @@
> 
> x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
> ...
> if (x == NULL) S
> <... when != x
>      when != if (...) { <+...x...+> }
> (
> x->f1 = E
> |
>  (x->f1 == NULL || ...)
> |
>  f(...,x->f1,...)
> )
> ...>
> (
>  return \(0\|<+...x...+>\|ptr\);
> |
>  return@p2 ...;
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Thanks Julia. 

Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

> 
> ---
>  drivers/scsi/bnx2fc/bnx2fc_hwi.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> index 1b680e2..f756d5f 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> @@ -522,6 +522,7 @@ void bnx2fc_process_l2_frame_compl(struct bnx2fc_rport *tgt,
>  	fp = fc_frame_alloc(lport, payload_len);
>  	if (!fp) {
>  		printk(KERN_ERR PFX "fc_frame_alloc failure\n");
> +		kfree(unsol_els);
>  		return;
>  	}
>  
> @@ -547,6 +548,7 @@ void bnx2fc_process_l2_frame_compl(struct bnx2fc_rport *tgt,
>  				 */
>  				printk(KERN_ERR PFX "dropping ELS 0x%x\n", op);
>  				kfree_skb(skb);
> +				kfree(unsol_els);
>  				return;
>  			}
>  		}
> @@ -563,6 +565,7 @@ void bnx2fc_process_l2_frame_compl(struct bnx2fc_rport *tgt,
>  	} else {
>  		BNX2FC_HBA_DBG(lport, "fh_r_ctl = 0x%x\n", fh->fh_r_ctl);
>  		kfree_skb(skb);
> +		kfree(unsol_els);
>  	}
>  }
>  
> 
> 
