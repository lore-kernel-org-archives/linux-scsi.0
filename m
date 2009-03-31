From: "Ross S. W. Walker" <RWalker@medallion.com>
Subject: Re: [Scst-devel] ISCSI-SCST performance
	(withalso IET and STGT	data)
Date: Tue, 31 Mar 2009 14:43:15 -0400
Message-ID: <E2BB8074E5500C42984D980D4BD78EF9029E3D0B@MFG-NYC-EXCH2.mfg.prv>
References: <49D10256.8030307@vlnb.net>	<e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>	<49D11096.3070804@vlnb.net><e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>
	<49D254E4.8050806@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <iscsitarget-devel-bounces@lists.sourceforge.net>
Content-class: urn:content-classes:message
In-Reply-To: <49D254E4.8050806@vlnb.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=iscsitarget-devel>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: iscsitarget-devel-bounces@lists.sourceforge.net
To: Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>
Cc: iscsitarget-devel@lists.sourceforge.net, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stgt@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Vladislav Bolkhovitin wrote:
> Bart Van Assche, on 03/30/2009 10:53 PM wrote:
> > =

> > Most applications do indeed use buffered I/O. Database software
> > however often uses direct I/O. It might be interesting to publish
> > performance results for both buffered I/O and direct I/O.
> =

> Yes, sure
> =

> > A quote from
> > the paper "Asynchronous I/O Support in Linux 2.5" by Bhattacharya e.a.
> > (Linux Symposium, Ottawa, 2003):
> > =

> > Direct I/O (raw and O_DIRECT) transfers data between a user buffer and
> > a device without copying the data through the kernel=92s buffer cache.
> > This mechanism can boost performance if the data is unlikely to be
> > used again in the short term (during a disk backup, for example), or
> > for applications such as large database management systems that
> > perform their own caching.
> =

> Please don't misread phrase "unlikely to be used again in the short =

> term". If you have read-ahead, all your cached data is *likely* to be =

> used "again" in the near future after they were read from storage, =

> although only once in the first read by application. The same is true =

> for write-back caching, where data written to the cache once for each =

> command. Both read-ahead and write back are very important for good =

> performance and O_DIRECT throws them away. All the modern HDDs have a =

> memory buffer (cache) at least 2MB big on the cheapest ones. =

> This cache is essential for performance, although how can it make any =

> difference if the host computer has, say, 1000 times more memory?
> =

> Thus, to work effectively with O_DIRECT an application has to be very =

> smart to workaround the lack of read-ahead and write back.

True, the application has to perform it's own read-ahead and write-back.

Kind of like how a database does it, or maybe the page cache on the
iSCSI initiator's system ;-)

> I personally consider O_DIRECT (as well as BLOCKIO) as nothing more than =

> a workaround for possible flaws in the storage subsystem. If O_DIRECT =

> works better, then in 99+% cases there is something in the storage =

> subsystem, which should be fixed to perform better.

That's not true, page cached I/O is broken into page sizes which limits
the I/O bandwidth of the storage hardware while imposing a higher CPU
overhead. Obviously page-cached I/O isn't ideal for all situations.

You could also have an amazing backend storage system with it's own
NVRAM cache. Why put the performance overhead onto the target system
when you can off-load it to the controller?

> To be complete, there is one case where O_DIRECT and BLOCKIO have an =

> advantage: both of them transfer data zero-copy. So they are good if =

> your memory is too slow comparing to storage (InfiniBand case, for =

> instance) and additional data copy hurts performance noticeably.

The bottom line which will always be true:

Know your workload, configure your storage to match.

The best storage solutions allow the implementor the most flexibility
in configuring the storage, which I think both IET and SCST do.

IET just needs to fix how it does it workload with CFQ which
somehow SCST has overcome. Of course SCST tweaks the Linux kernel to
gain some extra speed.

Vlad, how about a comparison of SCST vs IET without those kernel hooks?

-Ross

______________________________________________________________________
This e-mail, and any attachments thereto, is intended only for use by
the addressee(s) named herein and may contain legally privileged
and/or confidential information. If you are not the intended recipient
of this e-mail, you are hereby notified that any dissemination,
distribution or copying of this e-mail, and any attachments thereto,
is strictly prohibited. If you have received this e-mail in error,
please immediately notify the sender and permanently delete the
original and any copy or printout thereof.


---------------------------------------------------------------------------=
---
