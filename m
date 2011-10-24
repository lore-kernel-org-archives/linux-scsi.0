From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
Date: Tue, 25 Oct 2011 01:13:58 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1110250110310.19795@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net> <1319496149.2094.3.camel@Joe-Laptop> <CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com> <20111024225459.GB25654@redhat.com>
 <CAFLxGvwMEmjyifB-_Ms5Xd8iAr+GCVbYk0RX5Qxwev1nyXpFUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1187331723-1319498038=:19795"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvwMEmjyifB-_Ms5Xd8iAr+GCVbYk0RX5Qxwev1nyXpFUw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Joe Perches <joe@perches.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1187331723-1319498038=:19795
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 25 Oct 2011, richard -rw- weinberger wrote:

> On Tue, Oct 25, 2011 at 12:54 AM, Dave Jones <davej@redhat.com> wrote:
> > On Tue, Oct 25, 2011 at 12:50:08AM +0200, richard -rw- weinberger wrote:
> >
> >  > BTW: What about a checkpatch.pl rule to detect such a misuse of kmalloc()?
> >  > We could grep for "k[mzc]alloc(GFP_".
> >
> > Make sure to ignore bio_kmalloc (which has reverse argument order to kmalloc, ugh)
> >
> 
> Hmmm, maybe we should "fix" the argument order of bio_kmalloc().
> But as this function is exported we'd silently break some out-of-tree
> kernel modules....
> 
Or we could fix it noisily by renaming the function kmalloc_bio() and 
fixing the argument order. That will still break out-of-tree modules, but 
at least it won't break them silently...

Or we could introduce kmalloc_bio() with fixed argument order, fix all 
in-kernel users and mark bio_kmalloc() deprecated with a note that it'll 
go away by 3.6 or thereabouts...
I'd be happy to prepare a patch series doing that if it's wanted...?

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1187331723-1319498038=:19795--
