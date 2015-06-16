From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: optimal io size / custom alignment
Date: Wed, 17 Jun 2015 03:26:20 +0800
Message-ID: <CAGnHSEkBXevNmrL7NFO=nKekZdZE6KtzjGvA8sM=onjUfd8KHQ@mail.gmail.com>
References: <CAGnHSE=gtd2WVcxOBoyfqnp3QtT4RHfK356GHastBbiK5mtmFA@mail.gmail.com>
	<20150615133154.GV1992@ws.net.home>
	<CAGnHSEm6wDq_EjJXYwqV2Tt2868DbR0bNRYvevhN1AM4qJpaPw@mail.gmail.com>
	<yq1zj3zfuna.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1zj3zfuna.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 17 June 2015 at 01:08, Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> The two values have nothing to do with each other. They just happen to
> be the same in your case (65535 is the maximum block count for the WRITE
> SAME(10) command).
>
> Your device sets the transfer length granularity to 1 logical block and
> the optimal transfer length to 65535 logical blocks. If it then reports
> a 4096-byte physical block size in response to READ CAPACITY(16) then
> it's clearly on crack.
>
> There's only so much we can do about devices that report garbage.

All drives I have are flash drives so none of them reports 4k physical
sectors. But it does seems possible in the case I linked. The thing is
these VPDs/transfer lengths are probably provided by the USB to
ATA(/SCSI?) bridges. I can't judge if they are wrong to set the
lengths that way but it seem to be a common practice. I have two USB
devices provide the SBC-2 (Block limit VPD), one is a SanDisk Extreme
USB (SDCZ80), another an Intel X25-M Gen1 on an ASMedia SATA adapter,
and both of them set the Optimal transfer length. The usb-storage
driver does not read vpd so it won't be a thing, but the the uas
driver does.

> Also, the kernel only reports things. It is up to Karel to decide
> whether to sanity check the values before he uses them.

I just feel like the kernel shouldn't bind values from totally
different source (raid stripe vs vpd limit) to the same variable. I
don't know if what else would make use of this variable but by only
considering the fdisk case, it seems the scsi disk driver should be
the one who should stop binding.

> The best fix, of course, is to complain to the manufacturer of your
> broken widget and hope for a firmware upgrade.

This is simply too idealistic especially when it seems that this issue
mostly happens on USB bridges. I am not even sure if the SCSI
standards has anything to say about this practice.

> Failing that, adjust your partitions manually.

Yeah that's why I said fdisk should allow custom alignment.

On 17 June 2015 at 01:08, Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>> "Tom" == Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
> Tom> From the adapter/drive I have, it is the same as the "Maximum
> Tom> transfer length" and they seem to be simply limits of SCSI "WRITE
> Tom> SAME (10/16)" command:
>
> The two values have nothing to do with each other. They just happen to
> be the same in your case (65535 is the maximum block count for the WRITE
> SAME(10) command).
>
> Tom> [tom@localhost ~]$ sudo sg_inq -p 0xb0 /dev/sdb VPD INQUIRY: Block
> Tom> limits page (SBC) Maximum compare and write length: 0 blocks
> Tom> Optimal transfer length granularity: 1 blocks Maximum transfer
> Tom> length: 65535 blocks Optimal transfer length: 65535 blocks
>
> Your device sets the transfer length granularity to 1 logical block and
> the optimal transfer length to 65535 logical blocks. If it then reports
> a 4096-byte physical block size in response to READ CAPACITY(16) then
> it's clearly on crack.
>
> There's only so much we can do about devices that report garbage.
>
> Also, the kernel only reports things. It is up to Karel to decide
> whether to sanity check the values before he uses them.
>
> I would probably err on the side of trusting the physical block size
> reporting more than anything seeded from the Block Limits VPD. And in
> this case, assuming the alignment offset is reported to be 0, I guess
> one could entertain aligning to the nearest 4K boundary. But on the
> other hand it'll quickly get hairy to have to maintain this kind of
> heuristics.
>
> The best fix, of course, is to complain to the manufacturer of your
> broken widget and hope for a firmware upgrade. Failing that, adjust your
> partitions manually.
>
> Tom> The thing is, why any io/transfer size/length should be considered
> Tom> when it comes to partition alignment? From what I understand,
> Tom> partition alignment is only to make sure partition starts at
> Tom> physical boundaries of the disk because of the mismatch between
> Tom> logicial sector (512 bytes) and physical sectors (4096 bytes) or
> Tom> pages/erase blocks of SSDs.
>
> For RAID it makes a big difference to ensure the partition is aligned on
> a stripe boundary.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
