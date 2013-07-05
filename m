From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: atomic write & T10 standards
Date: Fri, 5 Jul 2013 15:34:34 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402953E2C50F@G9W0745.americas.hpqcorp.net>
References: <51D4365C.1030008@redhat.com>
 <20130703143844.14981.69152@localhost.localdomain>
 <51D43B87.5090005@redhat.com> <1372863655.3601.19.camel@dabdike>
 <51D43D6C.6050505@redhat.com> <1372864959.3601.37.camel@dabdike>
 <51D442DD.8000001@redhat.com> <1372865829.3601.41.camel@dabdike>
 <51D4466E.8040408@redhat.com>
 <20130703155400.14981.4222@localhost.localdomain>
 <51D46E1F.1090501@redhat.com> <51D4E96A.6040002@vlnb.net>
 <51D56BE3.8000607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:42841 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab3GEPfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jul 2013 11:35:47 -0400
In-Reply-To: <51D56BE3.8000607@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>, Vladislav Bolkhovitin <ml@vlnb.net>
Cc: Chris Mason <clmason@fusionio.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <mkp@mkp.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The proposed SCSI atomic commands - WRITE ATOMIC, READ ATOMIC, WRITE SCATTERED, and READ GATHERED - all include FUA (force unit access) bits, just like other WRITE and READ commands.  Also, the SYNCHRONIZE CACHE command affects atomic writes just like non-atomic writes.

With the FUA bit set to zero (don't force), if logical block data from an atomic write is stuck in a volatile write cache (not yet written to the medium), then:
a) reads before a power loss return all of the logical block data from that atomic write; and
b) reads after a power loss return none of the logical block data from that atomic write.

Someone using a drive with a volatile write cache without setting FUA to one or using SYNCHRONIZE CACHE is accepting that any number of writes (atomic or non-atomic) may be lost on power loss.  A common example use case is video editing.  Before power loss, the atomic promises are honored; reads won't return part of the logical block data from an atomic write.  After power loss, some of those writes will appear to never have happened.  The atomic writes that were written to medium must have completely been written to medium, though - power loss is not an excuse to break atomicity.

---
Rob Elliott    HP Server Storage



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Ric Wheeler
> Sent: Thursday, 04 July, 2013 7:35 AM
> To: Vladislav Bolkhovitin
> Cc: Chris Mason; James Bottomley; Martin K. Petersen; linux-
> scsi@vger.kernel.org
> Subject: Re: atomic write & T10 standards
> 
> On 07/03/2013 11:18 PM, Vladislav Bolkhovitin wrote:
> > Ric Wheeler, on 07/03/2013 11:31 AM wrote:
> >>>> Journals are normally big (128MB or so?) - I don't think that this is
> unique to xfs.
> >>> We're mixing a bunch of concepts here.  The filesystems have a lot of
> >>> different requirements, and atomics are just one small part.
> >>>
> >>> Creating a new file often uses resources freed by past files.  So
> >>> deleting the old must be ordered against allocating the new.  They are
> >>> really separate atomic units but you can't handle them completely
> >>> independently.
> >>>
> >>>> If our existing journal commit is:
> >>>>
> >>>> * write the data blocks for a transaction
> >>>> * flush
> >>>> * write the commit block for the transaction
> >>>> * flush
> >>>>
> >>>> Which part of this does and atomic write help?
> >>>>
> >>>> We would still need at least:
> >>>>
> >>>> * atomic write of data blocks & commit blocks
> >>>> * flush
> > No necessary.
> >
> > Consider a case, when you are creating many small files in a big directory.
> Consider
> > that every such operation needs 3 actions: add new directory entry, get
> free space and
> > write data there. If 1 atomic write (scattered) command is used for each
> operation and
> > you order them between each other, if needed, in some way, e.g. by using
> ORDERED SCSI
> > attribute or queue draining, you don't need any intermediate flushes. Only
> one final
> > flush would be sufficient. In case of crash simply some of the new files
> would
> > "disappear", but everything would be fully consistent, so the only needed
> recovery
> > would be to recreate them.
> 
> The worry I have is that we then have this intermediate state where we have
> sent
> the array down a scattered IO which is marked as atomic. Can we trust the
> array
> to lose all of those parts on power failure or lose none of them before we
> send
> down a queue flush of some kind?
> 
> Not to mention we still end up having to persist a broader range of data than
> we
> would otherwise need.
> 
> Even worse nightmare would be sending down atomic scattered write A,
> followed by
> atomic scattered write B, ...., scattered atomic write Y - all without a sync
> followed by a crash. What semantics or ordering promises do we have in this
> case
> if the power drops? Is there a promise that they are durable in the sequence
> sent to the target, or could we end up with a write B and not a write A after a
> crash?
> 
> >
> >> The catch is that our current flush mechanisms are still pretty brute force
> and
> >> act across either the whole device or in a temporal (everything flushed
> before
> >> this is acked) way.
> >>
> >> I still see it would be useful to have the atomic write really be atomic and
> >> durable just for that IO - no flush needed.
> >>
> >> Can you give a sequence for the use case for the non-durable atomic
> write that
> >> would not need a sync?
> > See above.
> 
> Your above example still had a flush (or use of ORDERED SCSI commands).
> 
> >
> >> Can we really trust all devices to make something atomic
> >> that is not durable :) ?
> > Sure, if application allows that and the atomicity property itself is durable,
> why not?
> >
> > Vlad
> >
> > P.S. With atomic writes there's no need in a journal, no?
> 
> Durable and atomic are not the same - we need to make sure that the
> specification is clear and that the behaviours are uniform (mandated) if we
> can
> make use of them. We have been burnt in the past by things like the TRIM
> command
> leaving stale data for example by some vendor and not others (leading to an
> update of the spec :))
> 
> I think that you would need to have durability between the atomic writes in
> order to do away with the journal.
> 
> Ric
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
