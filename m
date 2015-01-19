From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
Date: Mon, 19 Jan 2015 14:18:59 +0900
Message-ID: <54BC93C3.7010808@hitachi.com>
References: <1421600146.2080.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1421600146.2080.8.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

(2015/01/19 1:55), James Bottomley wrote:
> From: James Bottomley <JBottomley@Parallels.com>
> 
> After e513cc1 module: Remove stop_machine from module unloading,
> module_refcount() is returning (unsigned long)-1 when called from within
> a routine that runs in module_exit.  This is confusing the scsi device
> put code which is coded to detect a module_refcount() of zero for
> running within a module exit routine and not try to do another
> module_put.  The fix is to restore the original behaviour of
> module_refcount() and return zero if we're running inside an exit
> routine.
> 
> Fixes: e513cc1c07e2ab93a4514eec9833e031df3e30bb
> Reported-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> 

Yes, this should be fixed as you said, since it must return "unsigned long" value.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Just one comment below;

> diff --git a/kernel/module.c b/kernel/module.c
> index 3965511..c33a113 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -774,7 +774,12 @@ static int try_stop_module(struct module *mod, int flags, int *forced)
>  
>  unsigned long module_refcount(struct module *mod)
>  {
> -	return (unsigned long)atomic_read(&mod->refcnt) - MODULE_REF_BASE;
> +	unsigned long ret = atomic_read(&mod->refcnt);
> +
> +	if (ret == 0)

This would better be "if (unlikely(ret == 0))".

Thank you,

> +		/* ref is already zero (probably in module exit) */
> +		return 0;
> +	return ret - MODULE_REF_BASE;
>  }
>  EXPORT_SYMBOL(module_refcount);
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
