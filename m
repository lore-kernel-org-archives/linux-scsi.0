From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: optimal io size / custom alignment
Date: Mon, 22 Jun 2015 10:32:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1506221029260.1799-100000@iolanthe.rowland.org>
References: <CAGnHSE=DGa24TPox8wp4k264jnXjMOq7kzf-tCRf1eJt9kN0ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGnHSE=DGa24TPox8wp4k264jnXjMOq7kzf-tCRf1eJt9kN0ZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 21 Jun 2015, Tom Yan wrote:

> I was not saying RAIDs are virtual devices. I just mentioned it
> because I saw things like virtio-blk or zram use blk_queue_io_opt().
> 
> I know they all use VPDs, but the main point is whether those hardware
> RAIDs or so are handled by sd_mod, and whether those "transfer
> lengths" info are still important when it's just a simple drive. To me
> they look like to be of different nature. That's why I think it's
> inappropraite that they use the same "variable" / "file" to report
> because that makes tools like fdisk have trouble determining when does
> those values really matters.
> 
> In fact, (maybe I am just unlucky :P) VPDs of all my devices are to
> some extent broken. I just found out today my Intel 530 SSD connecting
> directly to SATA also reports totally garbage values for TRIM : (
> 
> To be honest the UAS thing doesn't really affect me a lot, I mostly
> use gdisk now (which doesn't care about i/o size AFAIK). I can also
> disable uas with the quirk so that VPDs are skipped when I really need
> fdisk for msdos/mbr. It's just I think that it kind of reveal a
> problem that has to be dealt with sooner or later, though you can
> optimistically think that vendors would do better on VPDs in the
> future.

Regardless of all these issues, it is clear that a lot of devices don't 
implement the VPD data correctly.  Therefore the information in the 
kernel will often be wrong.

And consequently, fdisk needs to offer the user an option to override 
the default partition-alignment setting.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
