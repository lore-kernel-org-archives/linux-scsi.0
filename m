From: Christoph Hellwig <hch@infradead.org>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
Date: Thu, 22 Jan 2015 08:50:18 -0800
Message-ID: <20150122165018.GA27377@infradead.org>
References: <1421600146.2080.8.camel@HansenPartnership.com>
 <54BC93C3.7010808@hitachi.com>
 <878ugzco8c.fsf@rustcorp.com.au>
 <1421683701.2080.25.camel@HansenPartnership.com>
 <871tmqcmau.fsf@rustcorp.com.au>
 <1421774615.2080.88.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1421774615.2080.88.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 20, 2015 at 09:23:35AM -0800, James Bottomley wrote:
> On Tue, 2015-01-20 at 11:15 +1030, Rusty Russell wrote:
> > James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> > > On Mon, 2015-01-19 at 16:21 +1030, Rusty Russell wrote:
> > >> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> > >> > (2015/01/19 1:55), James Bottomley wrote:
> > >> >> From: James Bottomley <JBottomley@Parallels.com>
> > >> >> 
> > >> >> After e513cc1 module: Remove stop_machine from module unloading,
> > >> >> module_refcount() is returning (unsigned long)-1 when called from within
> > >> >> a routine that runs in module_exit.  This is confusing the scsi device
> > >> >> put code which is coded to detect a module_refcount() of zero for
> > >> >> running within a module exit routine and not try to do another
> > >> >> module_put.  The fix is to restore the original behaviour of
> > >> >> module_refcount() and return zero if we're running inside an exit
> > >> >> routine.
> > >> >> 
> > >> >> Fixes: e513cc1c07e2ab93a4514eec9833e031df3e30bb
> > >> >> Reported-by: Bart Van Assche <bvanassche@acm.org>
> > >> >> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> > >> >> 
> > >> >
> > >> > Yes, this should be fixed as you said, since it must return "unsigned long" value.
> > >> 
> > >> But there are only three non-module callers:
> > >> 
> > >> drivers/scsi/scsi.c:1012:	if (module && module_refcount(module) != 0)
> > >> drivers/staging/lustre/lustre/obdclass/lu_object.c:1359:			LINVRNT(module_refcount(key->lct_owner) > 0);
> > >> include/linux/module.h:447:unsigned long module_refcount(struct module *mod);
> > >> kernel/debug/kdb/kdb_main.c:2026:		kdb_printf("%4ld ", module_refcount(mod));
> > >> kernel/module.c:775:unsigned long module_refcount(struct module *mod)
> > >> kernel/module.c:779:EXPORT_SYMBOL(module_refcount);
> > >> kernel/module.c:859:	seq_printf(m, " %lu ", module_refcount(mod));
> > >> kernel/module.c:911:	return sprintf(buffer, "%lu\n", module_refcount(mk->mod));
> > >> 
> > >> The first one I think should be eliminated, and the second one is simply
> > >> an assertion before calling module_put() (which should probably be
> > >> eliminated).  The others are just printing information.
> > >
> > > If you really want to insist on module_reference() returning -1 when the
> > > module is in it's exit phase, OK, but in that case, I think it should
> > > return a signed value, not an unsigned one.
> > 
> > Sure; I just didn't want to paper over the problem here.  And I'm not
> > sure we want to lose information, eg. in kgdb we're presumably looking
> > at it because something went wrong...
> > 
> > Thanks,
> > Rusty.
> > 
> > Subject: module: make module_refcount() a signed integer.
> > 
> > James Bottomley points out that it will be -1 during unload.  It's
> > only used for diagnostics, so let's not hide that as it could be a
> > clue as to what's gone wrong.
> > 
> > Cc: Jason Wessel <jason.wessel@windriver.com>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > 
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index ebfb0e153c6a..b653d7c0a05a 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -444,7 +444,7 @@ extern void __module_put_and_exit(struct module *mod, long code)
> >  #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code)
> >  
> >  #ifdef CONFIG_MODULE_UNLOAD
> > -unsigned long module_refcount(struct module *mod);
> > +int module_refcount(struct module *mod);
> >  void __symbol_put(const char *symbol);
> >  #define symbol_put(x) __symbol_put(VMLINUX_SYMBOL_STR(x))
> >  void symbol_put_addr(void *addr);
> > diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
> > index f191bddf64b8..7b40c5f07dce 100644
> > --- a/kernel/debug/kdb/kdb_main.c
> > +++ b/kernel/debug/kdb/kdb_main.c
> > @@ -2023,7 +2023,7 @@ static int kdb_lsmod(int argc, const char **argv)
> >  		kdb_printf("%-20s%8u  0x%p ", mod->name,
> >  			   mod->core_size, (void *)mod);
> >  #ifdef CONFIG_MODULE_UNLOAD
> > -		kdb_printf("%4ld ", module_refcount(mod));
> > +		kdb_printf("%4d ", module_refcount(mod));
> >  #endif
> >  		if (mod->state == MODULE_STATE_GOING)
> >  			kdb_printf(" (Unloading)");
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 3965511ae133..2387c98347c1 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -772,9 +772,9 @@ static int try_stop_module(struct module *mod, int flags, int *forced)
> >  	return 0;
> >  }
> >  
> > -unsigned long module_refcount(struct module *mod)
> > +int module_refcount(struct module *mod)
> >  {
> > -	return (unsigned long)atomic_read(&mod->refcnt) - MODULE_REF_BASE;
> > +	return atomic_read(&mod->refcnt) - MODULE_REF_BASE;
> >  }
> >  EXPORT_SYMBOL(module_refcount);
> >  
> > @@ -856,7 +856,7 @@ static inline void print_unload_info(struct seq_file *m, struct module *mod)
> >  	struct module_use *use;
> >  	int printed_something = 0;
> >  
> > -	seq_printf(m, " %lu ", module_refcount(mod));
> > +	seq_printf(m, " %i ", module_refcount(mod));
> >  
> >  	/*
> >  	 * Always include a trailing , so userspace can differentiate
> > @@ -908,7 +908,7 @@ EXPORT_SYMBOL_GPL(symbol_put_addr);
> >  static ssize_t show_refcnt(struct module_attribute *mattr,
> >  			   struct module_kobject *mk, char *buffer)
> >  {
> > -	return sprintf(buffer, "%lu\n", module_refcount(mk->mod));
> > +	return sprintf(buffer, "%i\n", module_refcount(mk->mod));
> >  }
> 
> Actually, I don't think this is enough.  Some Australian once came up
> with a guide to APIs, and lectured on it at length, one of which was
> that the name should be the obvious use and it is unexpected that a
> refcount would go negative.  I think we could raise it from -6 on the
> API scale to +3 if we add some documentation like below.

We'll also still need to change scsi_device_put to deal with
a negative refcount..
