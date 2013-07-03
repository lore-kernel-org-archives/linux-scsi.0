From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: atomic write & T10 standards
Date: Wed, 03 Jul 2013 08:22:39 -0700
Message-ID: <1372864959.3601.37.camel@dabdike>
References: <51D4365C.1030008@redhat.com>
	  <20130703143844.14981.69152@localhost.localdomain>
	  <51D43B87.5090005@redhat.com> <1372863655.3601.19.camel@dabdike>
	 <51D43D6C.6050505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39122 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083Ab3GCPWm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 11:22:42 -0400
In-Reply-To: <51D43D6C.6050505@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Chris Mason <clmason@fusionio.com>, "Martin K. Petersen" <mkp@mkp.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2013-07-03 at 11:04 -0400, Ric Wheeler wrote:
> On 07/03/2013 11:00 AM, James Bottomley wrote:
> > On Wed, 2013-07-03 at 10:56 -0400, Ric Wheeler wrote:
> >> On 07/03/2013 10:38 AM, Chris Mason wrote:
> >>> Quoting Ric Wheeler (2013-07-03 10:34:04)
> >>>> As I was out walking Skeeter this morning, I was thinking a bit about the new
> >>>> T10 atomic write proposal that Chris spoke about some time back.
> >>>>
> >>>> Specifically, I think that we would see a value only if the atomic write was
> >>>> also durable - if not, we need to always issue a SYNCHRONIZE_CACHE command which
> >>>> would mean it really is not effectively more useful than a normal write?
> >>>>
> >>>> Did I understand the proposal correctly?  If I did, should we poke the usual T10
> >>>> posse to nudge them (David Black, Fred Knight, etc?)...
> >>> I don't think the atomic writes should be a special case here.  We've
> >>> already got the cache flush and fua machinery and should just apply it
> >>> on top of the atomic constructs...
> >>>
> >>> -chris
> >>>
> >> I should have sent this to the linux-scsi list I suppose, but wanted clarity
> >> before embarrassing myself :)
> > Yes, it is a better to have a wider audience
> 
> Adding in linux-scsi....
> 
> >
> >> If we have to use fua/flush after an atomic write, what makes it atomic?  Why
> >> not just use a normal write?
> >>
> >> It does not seem to add anything that write + flush/fua does?
> > It adds the all or nothing that we can use to commit journal entries
> > without having to worry about atomicity.  The guarantee is that
> > everything makes it or nothing does.
> 
> I still don't see the difference in write + SYNC_CACHE versus atomic write + 
> SYNC_CACHE.
> 
> If the write is atomic and not durable, it is not really usable as a hard 
> promise until after we flush it somehow.
> >
> > In theory, if we got ordered tags working to ensure transaction vs data
> > ordering, this would mean we wouldn't have to flush at all because the
> > disk image would always be journal consistent ... a bit like the old
> > soft update scheme.
> >
> > James
> >
> 
> Why not have the atomic write actually imply that it is atomic and durable for 
> just that command?

I don't understand why you think you need guaranteed durability for
every journal transaction?  That's what causes us performance problems
because we have to pause on every transaction commit.

We require durability for explicit flushes, obviously, but we could
achieve far better performance if we could just let the filesystem
updates stream to the disk and rely on atomic writes making sure the
journal entries were all correct.  The reason we require durability for
journal entries today is to ensure caching effects don't cause the
journal to lie or be corrupt.

James


