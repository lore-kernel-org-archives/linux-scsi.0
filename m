From: Ingo Molnar <mingo@kernel.org>
Subject: Re: This patch triggers a bad gcc bug (was Re: [PATCH] force
 inlining of some byteswap operations)
Date: Fri, 15 Apr 2016 07:45:19 +0200
Message-ID: <20160415054518.GA28079@gmail.com>
References: <1454615136-32308-2-git-send-email-dvlasenk@redhat.com>
 <20160413033649.7r3msnmo3trtq47z@treble>
 <570E37A9.2050503@redhat.com>
 <20160413123607.3y3v5esq3myto4kc@treble>
 <20160413151500.tate3u6trg4agugo@treble>
 <1460566509.2322.14.camel@HansenPartnership.com>
 <20160413171058.24tnvvquvnipnwnd@treble>
 <570FB742.2010309@redhat.com>
 <20160414155708.upka6phfvwpbp6zw@treble>
 <570FCEB7.1070200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33610 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbcDOFpZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 01:45:25 -0400
Content-Disposition: inline
In-Reply-To: <570FCEB7.1070200@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi <linux-scsi@vger.kernel.org>


* Denys Vlasenko <dvlasenk@redhat.com> wrote:

> > In fact, the following patch seems to fix it:
> > 
> > diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> > index bf66ea6..56b9e81 100644
> > --- a/include/scsi/scsi_transport_fc.h
> > +++ b/include/scsi/scsi_transport_fc.h
> > @@ -796,7 +796,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
> >  	return result;
> >  }
> >  
> > -static inline u64 wwn_to_u64(u8 *wwn)
> > +static __always_inline u64 wwn_to_u64(u8 *wwn)
> >  {
> >  	return get_unaligned_be64(wwn);
> >  }
> 
> It is not a guarantee.

Of course it's a workaround - but is there any deterministic way to turn off this 
GCC bug (by activating some GCC command line switch), or do we have to live with 
objtool warning about this GCC?

Which, by the way, is pretty cool!

Thanks,

	Ingo
