From: Chris Mason <clmason@fusionio.com>
Subject: Re: atomic write & T10 standards
Date: Wed, 3 Jul 2013 11:54:00 -0400
Message-ID: <20130703155400.14981.4222@localhost.localdomain>
References: <51D4365C.1030008@redhat.com>
 <20130703143844.14981.69152@localhost.localdomain>
 <51D43B87.5090005@redhat.com> <1372863655.3601.19.camel@dabdike>
 <51D43D6C.6050505@redhat.com> <1372864959.3601.37.camel@dabdike>
 <51D442DD.8000001@redhat.com> <1372865829.3601.41.camel@dabdike>
 <51D4466E.8040408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47490 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab3GCPyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 11:54:03 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 037759A06C6
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2013 09:54:03 -0600 (MDT)
In-Reply-To: <51D4466E.8040408@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <mkp@mkp.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Quoting Ric Wheeler (2013-07-03 11:42:38)
> On 07/03/2013 11:37 AM, James Bottomley wrote:
> > On Wed, 2013-07-03 at 11:27 -0400, Ric Wheeler wrote:
> >> On 07/03/2013 11:22 AM, James Bottomley wrote:
> >>> On Wed, 2013-07-03 at 11:04 -0400, Ric Wheeler wrote:
> >>>> Why not have the atomic write actually imply that it is atomic and durable for
> >>>> just that command?
> >>> I don't understand why you think you need guaranteed durability for
> >>> every journal transaction?  That's what causes us performance problems
> >>> because we have to pause on every transaction commit.
> >>>
> >>> We require durability for explicit flushes, obviously, but we could
> >>> achieve far better performance if we could just let the filesystem
> >>> updates stream to the disk and rely on atomic writes making sure the
> >>> journal entries were all correct.  The reason we require durability for
> >>> journal entries today is to ensure caching effects don't cause the
> >>> journal to lie or be corrupt.
> >> Why would we use atomic writes for things that don't need to be
> >> durable?
> >>
> >> Avoid a torn page write seems to be the only real difference here if
> >> you use the atomic operations and don't have durability...
> > It's not just about torn pages: Journal entries are big complex beasts.
> > They can be megabytes big (at least on xfs).  If we can guarantee all or
> > nothing atomicity in the entire journal entry write it permits a more
> > streaming design of the filesystem writeout path.
> >
> > James
> >   
> >
> 
> Journals are normally big (128MB or so?) - I don't think that this is unique to xfs.

We're mixing a bunch of concepts here.  The filesystems have a lot of
different requirements, and atomics are just one small part.

Creating a new file often uses resources freed by past files.  So
deleting the old must be ordered against allocating the new.  They are
really separate atomic units but you can't handle them completely
independently.

> 
> If our existing journal commit is:
> 
> * write the data blocks for a transaction
> * flush
> * write the commit block for the transaction
> * flush
> 
> Which part of this does and atomic write help?
> 
> We would still need at least:
> 
> * atomic write of data blocks & commit blocks
> * flush

Yes.  But just because we need the flush here doesn't mean we need the
flush for every single atomic write.

-chris

