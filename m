From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Wed, 4 Jun 2014 17:03:47 +0200
Message-ID: <201406041703.47592.arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<5011138.W0gbOc20Qp@wuerfel> <20140603213802.GH14410@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20140603213802.GH14410@dastard>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, coda-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, codalist-ySnCqBnJi5yMVn35/9/JlcWGCVk0P7UB@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lftan-EIB2kfCEclfQT0dZR+AlfA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 03 June 2014, Dave Chinner wrote:
> On Tue, Jun 03, 2014 at 04:22:19PM +0200, Arnd Bergmann wrote:
> > On Monday 02 June 2014 14:57:26 H. Peter Anvin wrote:
> > > On 06/02/2014 12:55 PM, Arnd Bergmann wrote:
> > The possible uses I can see for non-ktime_t types in the kernel are:
> > * inodes need 96 bit timestamps to represent the full range of values
> >   that can be stored in a file system, you made a convincing argument
> >   for that. Almost everything else can fit into 64 bit on a 32-bit
> >   kernel, in theory also on a 64-bit kernel if we want that.
> 
> Just ot be pedantic, inodes don't need 96 bit timestamps - some
> filesystems can *support up to* 96 bit timestamps. If the kernel
> only supports 64 bit timestamps and that's all the kernel can
> represent, then the upper bits of the 96 bit on-disk inode
> timestamps simply remain zero.

I meant the reverse: since we have file systems that can store
96-bit timestamps when using 64-bit kernels, we need to extend
32-bit kernels to have the same internal representation so we
can actually read those file systems correctly.

> If you move the filesystem between kernels with different time
> ranges, then the filesystem needs to be able to tell the kernel what
> it's supported range is.  This is where having the VFS limit the
> range of supported timestamps is important: the limit is the
> min(kernel range, filesystem range). This allows the filesystems
> to be indepenent of the kernel time representation, and the kernel
> to be independent of the physical filesystem time encoding....

I agree it makes sense to let the kernel know about the limits
of the file system it accesses, but for the reverse, we're probably
better off just making the kernel representation large enough (i.e.
96 bits) so it can work with any known file system. We need another
check at the user space boundary to turn that into a value that the
user can understand, but that's another problem.

	Arnd

------------------------------------------------------------------------------
Learn Graph Databases - Download FREE O'Reilly Book
"Graph Databases" is the definitive new guide to graph databases and their 
applications. Written by three acclaimed leaders in the field, 
this first edition is now available. Download your free book today!
http://p.sf.net/sfu/NeoTech
