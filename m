From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Wed, 04 Jun 2014 21:24:42 +0200
Message-ID: <8770583.6XeZxCxOY8@wuerfel>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <201406041703.47592.arnd@arndb.de> <alpine.LFD.2.11.1406041308300.17310@knanqh.ubzr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.11.1406041308300.17310-fMhRO7WWcppj+hNMo8g0rg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Pitre <nicolas.pitre-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, coda-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, codalist-ySnCqBnJi5yMVn35/9/JlcWGCVk0P7UB@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lftan-EIB2kfCEclfQT0dZR+AlfA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 04 June 2014 13:30:32 Nicolas Pitre wrote:
> On Wed, 4 Jun 2014, Arnd Bergmann wrote:
> 
> > On Tuesday 03 June 2014, Dave Chinner wrote:
> > > Just ot be pedantic, inodes don't need 96 bit timestamps - some
> > > filesystems can *support up to* 96 bit timestamps. If the kernel
> > > only supports 64 bit timestamps and that's all the kernel can
> > > represent, then the upper bits of the 96 bit on-disk inode
> > > timestamps simply remain zero.
> > 
> > I meant the reverse: since we have file systems that can store
> > 96-bit timestamps when using 64-bit kernels, we need to extend
> > 32-bit kernels to have the same internal representation so we
> > can actually read those file systems correctly.
> > 
> > > If you move the filesystem between kernels with different time
> > > ranges, then the filesystem needs to be able to tell the kernel what
> > > it's supported range is.  This is where having the VFS limit the
> > > range of supported timestamps is important: the limit is the
> > > min(kernel range, filesystem range). This allows the filesystems
> > > to be indepenent of the kernel time representation, and the kernel
> > > to be independent of the physical filesystem time encoding....
> > 
> > I agree it makes sense to let the kernel know about the limits
> > of the file system it accesses, but for the reverse, we're probably
> > better off just making the kernel representation large enough (i.e.
> > 96 bits) so it can work with any known file system.
> 
> Depends...  96 bit handling may get prohibitive on 32-bit archs.
> 
> The important point here is for the kernel to be able to represent the 
> time _range_ used by any known filesystem, not necessarily the time 
> _precision_.
> 
> For example, a 64 bit representation can be made of 40 bits for seconds 
> spanning 34865 years, and 24 bits for fractional seconds providing 
> precision down to 60 nanosecs.  That ought to be plenty good on 32 bit 
> systems while still being cheap to handle.

I have checked earlier that we don't do any computation on inode
time stamps in common code, we just pass them around, so there is
very little runtime overhead. There is a small bit of space overhead
(12 byte) per inode, but that structure is already on the order of
500 bytes.

For other timekeeping stuff in the kernel, I agree that using some
64-bit representation (nanoseconds, 32/32 unsigned seconds/nanoseconds,
...) has advantages, that's exactly the point I was making earlier
against simply extending the internal time_t/timespec to 64-bit
seconds for everything.

	Arnd
