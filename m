From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
Date: Mon, 19 Jan 2015 08:08:21 -0800
Message-ID: <1421683701.2080.25.camel@HansenPartnership.com>
References: <1421600146.2080.8.camel@HansenPartnership.com>
	 <54BC93C3.7010808@hitachi.com> <878ugzco8c.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878ugzco8c.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-01-19 at 16:21 +1030, Rusty Russell wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> > (2015/01/19 1:55), James Bottomley wrote:
> >> From: James Bottomley <JBottomley@Parallels.com>
> >> 
> >> After e513cc1 module: Remove stop_machine from module unloading,
> >> module_refcount() is returning (unsigned long)-1 when called from within
> >> a routine that runs in module_exit.  This is confusing the scsi device
> >> put code which is coded to detect a module_refcount() of zero for
> >> running within a module exit routine and not try to do another
> >> module_put.  The fix is to restore the original behaviour of
> >> module_refcount() and return zero if we're running inside an exit
> >> routine.
> >> 
> >> Fixes: e513cc1c07e2ab93a4514eec9833e031df3e30bb
> >> Reported-by: Bart Van Assche <bvanassche@acm.org>
> >> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> >> 
> >
> > Yes, this should be fixed as you said, since it must return "unsigned long" value.
> 
> But there are only three non-module callers:
> 
> drivers/scsi/scsi.c:1012:	if (module && module_refcount(module) != 0)
> drivers/staging/lustre/lustre/obdclass/lu_object.c:1359:			LINVRNT(module_refcount(key->lct_owner) > 0);
> include/linux/module.h:447:unsigned long module_refcount(struct module *mod);
> kernel/debug/kdb/kdb_main.c:2026:		kdb_printf("%4ld ", module_refcount(mod));
> kernel/module.c:775:unsigned long module_refcount(struct module *mod)
> kernel/module.c:779:EXPORT_SYMBOL(module_refcount);
> kernel/module.c:859:	seq_printf(m, " %lu ", module_refcount(mod));
> kernel/module.c:911:	return sprintf(buffer, "%lu\n", module_refcount(mk->mod));
> 
> The first one I think should be eliminated, and the second one is simply
> an assertion before calling module_put() (which should probably be
> eliminated).  The others are just printing information.

If you really want to insist on module_reference() returning -1 when the
module is in it's exit phase, OK, but in that case, I think it should
return a signed value, not an unsigned one.

James
