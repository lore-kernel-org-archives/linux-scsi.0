From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: This patch triggers a bad gcc bug (was Re: [PATCH] force
 inlining of some byteswap operations)
Date: Fri, 15 Apr 2016 17:20:37 -0500
Message-ID: <20160415222037.wu4n6w2yedxdzfle@treble>
References: <570E37A9.2050503@redhat.com>
 <20160413123607.3y3v5esq3myto4kc@treble>
 <20160413151500.tate3u6trg4agugo@treble>
 <1460566509.2322.14.camel@HansenPartnership.com>
 <20160413171058.24tnvvquvnipnwnd@treble>
 <570FB742.2010309@redhat.com>
 <20160414155708.upka6phfvwpbp6zw@treble>
 <570FCEB7.1070200@redhat.com>
 <20160415054518.GA28079@gmail.com>
 <20160415134745.wxb73xemv2tqib5m@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160415134745.wxb73xemv2tqib5m@treble>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi <linux-scsi@vger.kernel.org>, jamborm@gcc.gnu.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 15, 2016 at 08:47:45AM -0500, Josh Poimboeuf wrote:
> On Fri, Apr 15, 2016 at 07:45:19AM +0200, Ingo Molnar wrote:
> > 
> > * Denys Vlasenko <dvlasenk@redhat.com> wrote:
> > 
> > > > In fact, the following patch seems to fix it:
> > > > 
> > > > diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> > > > index bf66ea6..56b9e81 100644
> > > > --- a/include/scsi/scsi_transport_fc.h
> > > > +++ b/include/scsi/scsi_transport_fc.h
> > > > @@ -796,7 +796,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
> > > >  	return result;
> > > >  }
> > > >  
> > > > -static inline u64 wwn_to_u64(u8 *wwn)
> > > > +static __always_inline u64 wwn_to_u64(u8 *wwn)
> > > >  {
> > > >  	return get_unaligned_be64(wwn);
> > > >  }
> > > 
> > > It is not a guarantee.
> > 
> > Of course it's a workaround - but is there any deterministic way to turn off this 
> > GCC bug (by activating some GCC command line switch), or do we have to live with 
> > objtool warning about this GCC?
> 
> I don't think we know yet if there's a reliable way to turn the bug off.
> 
> Also, according to the gcc guys, this bug won't always result in a
> truncated function, and may sometimes just make some inline function
> call sites disappear:
> 
>   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646#c14
> 
> though I haven't been able to confirm that experimentally.  But if it's
> true, that means that objtool won't be able to detect all cases of the
> bug and some function calls may just silently disappear!
> 
> There's a lot of activity in the bug now, so hopefully they'll be able
> to tell us soon if there's a reliable way to avoid it and/or detect it.
> 
> BTW, Denys posted a workaround patch for the qla2xxxx code:
> 
>   https://lkml.kernel.org/r/1460716583-15673-1-git-send-email-dvlasenk@redhat.com

Martin Jambor wrote a succinct summary of the conditions needed for this
bug:

  "This bug can occur when an inlineable function containing a call to
  __builtin_constant_p, which checks a parameter or a value it
  references and a (possibly indirect) caller of the function actually
  passes a constant, but stores it using a type of a different size."

So to prevent it from happening elsewhere in the kernel, it sounds like
we'd have to either remove all uses of __builtin_constant_p() or disable
inlining completely.

There's also no reliable way to detect the bug has occurred, though
objtool will detect it in cases when the function gets truncated.

-- 
Josh
