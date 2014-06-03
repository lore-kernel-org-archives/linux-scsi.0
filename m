From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Tue, 03 Jun 2014 16:22:19 +0200
Message-ID: <5011138.W0gbOc20Qp@wuerfel>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<7175692.dpgYFMbTaP@wuerfel> <538CF346.2070504@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <538CF346.2070504-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, coda-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, codalist-ySnCqBnJi5yMVn35/9/JlcWGCVk0P7UB@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lftan-EIB2kfCEclfQT0dZR+AlfA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Monday 02 June 2014 14:57:26 H. Peter Anvin wrote:
> On 06/02/2014 12:55 PM, Arnd Bergmann wrote:
> >>
> >> The bit that is really going to hurt is every single ioctl that uses a
> >> timespec.
> >>
> >> Honestly, though, I really don't understand the point with "struct
> >> inode_time".  It seems like the zeroeth-order thing is to change the
> >> kernel internal version of struct timespec to have a 64-bit time... it
> >> isn't just about inodes.  We then should be explicit about the external
> >> uses of time, and use accessors.
> > 
> > I picked these because they are fairly isolated from all other uses,
> > in particular since inode times are the only things where we really
> > care about times in the distant past or future (decades away as opposed
> > to things that happened between boot and shutdown).
> > 
> 
> If nothing else, I would expect to be able to set the system time to
> weird values for testing.  So I'm not so sure I agree with that...

I think John Stultz and Thomas Gleixner have already started looking
at how the timekeeping code can be updated. Once that is done, we should
be able to add a functional 64-bit gettimeofday/settimeofday syscall
pair. While I definitely agree this is one of the most basic things to
have, it's also not an area of the kernel that is easy to change.

> > For other kernel-internal uses, we may be better off migrating to
> > a completely different representation, such as nanoseconds since
> > boot or the architecture specific ktime_t, but this is really something
> > to decide for each subsystem.
> 
> Having a bunch of different time representations in the kernel seems
> like a real headache...

We already have time_t, ktime_t, timeval, timespec, compat_timespec,
clock_t, cputime_t, cputime64_t, tm, nanoseconds, jiffies, jiffies64,
and lots of driver or file system specific representations. I'm all for
removing a bunch of these from the kernel, but my feeling is that this is
one of the cases where we first have to add new ones in order to remove
those that are already there.
To complicate things further, we also have various times bases
(realtime/utc, realtime/tai, monotonic, monotonic_raw, boottime, ...),
and at least for the timespec values we pass around, it's not always
obvious which one is used, of if that's the right one.

We probably don't want to add a lot of new representations, and it's
possible that we can change most of the internal code we have to
ktime_t and then convert that to whatever user space wants at the
interfaces.

The possible uses I can see for non-ktime_t types in the kernel are:
* inodes need 96 bit timestamps to represent the full range of values
  that can be stored in a file system, you made a convincing argument
  for that. Almost everything else can fit into 64 bit on a 32-bit
  kernel, in theory also on a 64-bit kernel if we want that.
* A number of interfaces pass relative timespecs: nanosleep(), poll(),
  select(), sigtimedwait(), alarm(), futex() and probably more. There is
  nothing wrong with the use of timespec here, and it may be good to
  annotate that by using a new type (e.g. struct timeout) that is defined
  as compatible with the current timespec.
* For new user interfaces, we need a new type such as the
  __kernel_timespec64 I introduced, so it doesn't clash with the normal
  user timespec that may be smaller, depending on the libc.
* A lot of drivers will need new ioctl commands, and for drivers that
  just need time stamps (audio, v4l, sockets, ...) it may be more
  efficient and more correct to use a new timestamp_t (e.g. boot time
  64-bit nanoseconds) than __kernel_timespec64, which is not normally
  monotonic and requires a normalization step. If we end up introducing
  such a type in the user interface, we can also start using it in the
  kernel.

	Arnd

------------------------------------------------------------------------------
Learn Graph Databases - Download FREE O'Reilly Book
"Graph Databases" is the definitive new guide to graph databases and their 
applications. Written by three acclaimed leaders in the field, 
this first edition is now available. Download your free book today!
http://p.sf.net/sfu/NeoTech
