From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] end-to-end data and metadata corruption
 detection
Date: Wed, 1 Feb 2012 12:41:31 -0500
Message-ID: <20120201174131.GD16796@shiny>
References: <38C050B3-2AAD-4767-9A25-02C33627E427@oracle.com>
 <4F2147BA.6030607@itwm.fraunhofer.de>
 <yq1k44e1pn6.fsf@sermon.lab.mkp.net>
 <4F217F0C.6030105@itwm.fraunhofer.de>
 <yq1y5sovcyw.fsf@sermon.lab.mkp.net>
 <4F283F7A.4020905@itwm.fraunhofer.de>
 <CAF3hT9AgVpcZkGLkr4EH4x4heNFgxNykM4Mp3V_C-RBSwJh7mA@mail.gmail.com>
 <20120201164521.GY16796@shiny>
 <1328115175.2768.11.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1328115175.2768.11.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Gregory Farnum <gregory.farnum-OZUH0SiS3Izby3iVrkZq2A@public.gmane.org>, Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 01, 2012 at 10:52:55AM -0600, James Bottomley wrote:
> On Wed, 2012-02-01 at 11:45 -0500, Chris Mason wrote:
> > On Tue, Jan 31, 2012 at 11:28:26AM -0800, Gregory Farnum wrote:
> > > On Tue, Jan 31, 2012 at 11:22 AM, Bernd Schubert
> > > <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org> wrote:
> > > > I guess we should talk to developers of other parallel file systems and see
> > > > what they think about it. I think cephfs already uses data integrity
> > > > provided by btrfs, although I'm not entirely sure and need to check the
> > > > code. As I said before, Lustre does network checksums already and *might* be
> > > > interested.
> > > 
> > > Actually, right now Ceph doesn't check btrfs' data integrity
> > > information, but since Ceph doesn't have any data-at-rest integrity
> > > verification it relies on btrfs if you want that. Integrating
> > > integrity verification throughout the system is on our long-term to-do
> > > list.
> > > We too will be said if using a kernel-level integrity system requires
> > > using DIO, although we could probably work out a way to do
> > > "translation" between our own integrity checksums and the
> > > btrfs-generated ones if we have to (thanks to replication).
> > 
> > DIO isn't really required, but doing this without synchronous writes
> > will get painful in a hurry.  There's nothing wrong with letting the
> > data sit in the page cache after the IO is done though.
> 
> I broadly agree with this, but even if you do sync writes and cache read
> only copies, we still have the problem of how we do the read side
> verification of DIX.  In theory, when you read, you could either get the
> cached copy or an actual read (which will supply protection
> information), so for the cached copy we need to return cached protection
> information implying that we need some way of actually caching it.

Good point, reading from the cached copy is a lower level of protection
because in theory bugs in your scsi drivers could corrupt the pages
later on.

But I think even without keeping the crcs attached to the page, there is
value in keeping  the cached copy in lots of workloads.  The database is
going to O_DIRECT read (with crcs checked) and then stuff it into a
database buffer cache for long term use.  Stuffing it into a page cache
on the kernel side is about the same.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
