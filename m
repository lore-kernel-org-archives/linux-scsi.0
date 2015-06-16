From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: optimal io size / custom alignment
Date: Tue, 16 Jun 2015 18:22:43 +0800
Message-ID: <CAGnHSE=L8qboO=JeCFmORgjibiqEqFzSPBMoJT8k0md9jTJU3g@mail.gmail.com>
References: <CAGnHSE=gtd2WVcxOBoyfqnp3QtT4RHfK356GHastBbiK5mtmFA@mail.gmail.com>
	<20150615133154.GV1992@ws.net.home>
	<CAGnHSEm6wDq_EjJXYwqV2Tt2868DbR0bNRYvevhN1AM4qJpaPw@mail.gmail.com>
	<20150616094320.GX1992@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150616094320.GX1992-xkT7n84Rsxv/9pzu0YdTqQ@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

I heard about that it matters for RAID but since I don't really know
about RAID so I can't comment.

I do wonder whether the scsi disk driver should derive minimum/optimal
i/o size from VPD at all then. It might still be "tolerable" if it's
the limit of WRITE SAME(10), but definitely not if it's that of WRITE
SAME (16):

[tom@localhost ~]$ sudo fdisk /dev/sdc

Welcome to fdisk (util-linux 2.26.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xccb261a9.

Command (m for help): p
Disk /dev/sdc: 29.2 GiB, 31376707072 bytes, 61282631 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 4294966784 bytes
Disklabel type: dos
Disk identifier: 0xccb261a9

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p):

Using default response p.
Partition number (1-4, default 1):
First sector (8388607-61282630, default 8388607):
Last sector, +sectors or +size{K,M,G,T,P} (8388607-61282630, default 61282630):

Created a new partition 1 of type 'Linux' and of size 25.2 GiB.

On 16 June 2015 at 17:43, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Jun 16, 2015 at 01:20:37PM +0800, Tom Yan wrote:
>> The thing is, why any io/transfer size/length should be considered
>> when it comes to partition alignment? From what I understand,
>> partition alignment is only to make sure partition starts at physical
>> boundaries of the disk because of the mismatch between logicial sector
>> (512 bytes) and physical sectors (4096 bytes) or pages/erase blocks of
>> SSDs.
>
> It's more complicated, the I/O limits are the most important for RAIDs
> where optimal I/O size is usually stripe size and you want to use it
> for partitions alignment for better performance (if you align to
> sector size then read/write on RAID maybe performed on more disks on
> unaligned partitions). And it's not only fdisk who cares, it's also
> important for mkfs.<type> (for example XFS align according to I/O limits).
>
> And because all this is mess and sometimes HW does not provide
> relevant information and because people use dd(1) to copy partition
> tables we have decided to use 1MiB granularity if possible. If 1MiB is
> useless then we use optimal_io_size, if undefined then minimal_io_size
> and if undefined then sector_size.
>
> http://people.redhat.com/msnitzer/docs/io-limits.txt
>
>
> Unfortunately the current code does not check if optimal_io_size makes
> sense, so thing like 33553920 for 4k device is blindly accepted ;-(
>
>     Karel
>
>
> --
>  Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>  http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
