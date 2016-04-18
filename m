From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: This patch triggers a bad gcc bug (was Re: [PATCH] force
 inlining of some byteswap operations)
Date: Mon, 18 Apr 2016 08:22:33 -0500
Message-ID: <20160418132233.c5cythzwdiclhld2@treble>
References: <1454615136-32308-2-git-send-email-dvlasenk@redhat.com>
 <570FCEB7.1070200@redhat.com>
 <20160415054518.GA28079@gmail.com>
 <148417843.qlNmZC1Fkn@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148417843.qlNmZC1Fkn@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Apr 16, 2016 at 09:42:37AM +0200, Arnd Bergmann wrote:
> On Friday 15 April 2016 07:45:19 Ingo Molnar wrote:
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
> > 
> > Which, by the way, is pretty cool!
> 
> I have done a patch for the asm-generic/unaligned handling recently that
> reworks the implementation to avoid an ARM specific bug (gcc uses certain
> CPU instructions that require aligned data when we tell it that unaligned
> data is not).
> 
> It changes the code enough that the gcc bug might not be triggered any more,
> aside from generating far superior code in some cases.

I tried this patch, but unfortunately it doesn't make the gcc bug go
away.

-- 
Josh
