From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: optimal io size / custom alignment
Date: Sun, 21 Jun 2015 00:01:34 +0800
Message-ID: <CAGnHSE=DGa24TPox8wp4k264jnXjMOq7kzf-tCRf1eJt9kN0ZQ@mail.gmail.com>
References: <CAGnHSE=gtd2WVcxOBoyfqnp3QtT4RHfK356GHastBbiK5mtmFA@mail.gmail.com>
	<20150615133154.GV1992@ws.net.home>
	<CAGnHSEm6wDq_EjJXYwqV2Tt2868DbR0bNRYvevhN1AM4qJpaPw@mail.gmail.com>
	<yq1zj3zfuna.fsf@sermon.lab.mkp.net>
	<CAGnHSEkBXevNmrL7NFO=nKekZdZE6KtzjGvA8sM=onjUfd8KHQ@mail.gmail.com>
	<yq1d20vfimj.fsf@sermon.lab.mkp.net>
	<CAGnHSEnMgivXU_0gDaOkHFkbc=Ve8PaPR0ho8+VhdcUuNu89Gw@mail.gmail.com>
	<yq1a8vwenog.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1a8vwenog.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

I was not saying RAIDs are virtual devices. I just mentioned it
because I saw things like virtio-blk or zram use blk_queue_io_opt().

I know they all use VPDs, but the main point is whether those hardware
RAIDs or so are handled by sd_mod, and whether those "transfer
lengths" info are still important when it's just a simple drive. To me
they look like to be of different nature. That's why I think it's
inappropraite that they use the same "variable" / "file" to report
because that makes tools like fdisk have trouble determining when does
those values really matters.

In fact, (maybe I am just unlucky :P) VPDs of all my devices are to
some extent broken. I just found out today my Intel 530 SSD connecting
directly to SATA also reports totally garbage values for TRIM : (

To be honest the UAS thing doesn't really affect me a lot, I mostly
use gdisk now (which doesn't care about i/o size AFAIK). I can also
disable uas with the quirk so that VPDs are skipped when I really need
fdisk for msdos/mbr. It's just I think that it kind of reveal a
problem that has to be dealt with sooner or later, though you can
optimistically think that vendors would do better on VPDs in the
future.

On 19 June 2015 at 05:01, Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>> "Tom" == Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
> Tom> No I put it in the wrong way. What I meant was "sd vs md". For
> Tom> example, couldn't the scsi disk driver bind the value it reads from
> Tom> the VPD to another variable instead of "optimal i/o size", so that
> Tom> this value would be exclusively for RAID (and other virtual
> Tom> devices)?
>
> Who says that RAID is a virtual device? Hardware RAID controllers as
> well as SAS, iSCSI and Fibre Channel disk arrays all use the Block
> Limits VPD to communicate their preferred I/O size and alignment to
> us. As do enterprise disk drives.
>
> We deal with broken devices by blacklisting them. I suggest you try to
> find a way we can reliably identify your UAS devices. If there is a
> common pattern, we can entertain adding a workaround.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
