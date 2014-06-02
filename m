From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Mon, 02 Jun 2014 21:19:55 +0200
Message-ID: <4233989.Saca0ocOUr@wuerfel>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <Pine.LNX.4.64.1406021350030.19591@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1406021350030.19591-9YEB1lltEqivcGRMvF24k2I39yigxGEX@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, lftan-EIB2kfCEclfQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, coda-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org, codalist-/uMB558Y47wP4a1z8dhFYw@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Monday 02 June 2014 13:52:19 Joseph S. Myers wrote:
> On Fri, 30 May 2014, Arnd Bergmann wrote:
> 
> > a) is this the right approach in general? The previous discussion
> >    pointed this way, but there may be other opinions.
> 
> The syscall changes seem like the sort of thing I'd expect, although 
> patches adding new syscalls or otherwise affecting the kernel/userspace 
> interface (as opposed to those relating to an individual filesystem) 
> should go to linux-api as well as other relevant lists.

Ok. Sorry about missing linux-api, I confused it with linux-arch, which
may not be as relevant here, except for the one question whether we
actually want to have the new ABI on all 32-bit architectures or only
as an opt-in for those that expect to stay around for another 24 years.

Two more questions for you:

- are you (and others) happy with adding this type of stat syscall
  (fstatat64/fstat64) as opposed to the more generic xstat that has
  been discussed in the past and that never made it through the bike-
  shedding discussion?

- once we have enough buy-in from reviewers to merge this initial
  series, should we proceed to define rest of the syscall ABI
  (minus driver ioctls) so glibc and kernel can do the conversion
  on top of that, or should we better try to do things one syscall
  family at a time and actually get the kernel to handle them
  correctly internally?

	Arnd
