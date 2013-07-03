From: Chris Mason <clmason@fusionio.com>
Subject: Re: atomic write & T10 standards
Date: Wed, 3 Jul 2013 11:21:55 -0400
Message-ID: <20130703152155.14981.50017@localhost.localdomain>
References: <51D4365C.1030008@redhat.com>
 <20130703143844.14981.69152@localhost.localdomain>
 <51D43B87.5090005@redhat.com> <1372863655.3601.19.camel@dabdike>
 <51D43D6C.6050505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47167 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab3GCPV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 11:21:58 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 00AE79A06C4
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2013 09:21:58 -0600 (MDT)
In-Reply-To: <51D43D6C.6050505@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <mkp@mkp.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Quoting Ric Wheeler (2013-07-03 11:04:12)
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

Picture the atomic write as a building block, and something like an
fsmark workload:

Create N new files:

for (i = 0 ; i < N ; i++) {
	[ allocate inode, create directory entry, update bitmaps ]
	[ fua/flush ]
}

vs

for (i = 0 ; i < N ; i++) {
	[ allocate inode, create directory entry, update bitmaps ]
}

[ fua/flush ]

The atomic user should be able to choose between FUA/cache flush and
not.  In the specific O_DIRECT use case, I can't see how non-fua is a
good idea, but that's different from the generic case.

-chris

