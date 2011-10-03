From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: =?windows-1252?Q?Re=3A_Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD=92s?=
 =?windows-1252?Q?_in_scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5Ftype?=
 =?windows-1252?Q?=29?=
Date: Mon, 3 Oct 2011 10:25:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1110031008190.1882-100000@iolanthe.rowland.org>
References: <CADDb1s2bVY04G1fZ=3KwCagZHm_dOmLPxsUBKven7=iBo_nU-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADDb1s2bVY04G1fZ=3KwCagZHm_dOmLPxsUBKven7=iBo_nU-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amit Sahrawat <amit.sahrawat83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 3 Oct 2011, Amit Sahrawat wrote:

> Hi,
> 
> Please find the USB Analyzer - logs for '6' USB based Mass Storage
> devices attached.

Too bad the analyzer log presents only the response, not the command.

> So, only for one of the USB HDD(Seagate - Free Agent), the response
> obtained is correct.

I don't understand the format of the Seagate Free Agent MODE SENSE
data.  Maybe someone else can interpret it; here it is for reference:

SCSI Op(3) ADDR(4) Tag(0x00000004) SCSI CDB MODE SENSE(6)
_______| Data(
__ 000: 1C 00 00 00 86 0B 00 02 00 00 12 A1 9E B0 3C 01 00 1A 0A 00 01 00 00 00 00 00 00 0B B8 00 00 00 
__ 032: 00 00 00 00 1A 0A 00 01 00 00 00 00 00 00 0B B8 A2 06 00 00 00 00 00 00 78 20 55 53 42 32 2E 30 
__ 064: 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 7F FF 00 00 00 00 80 FA 0B C2 50 21 4E 41 30 42 
__ 096: 36 58 33 4C 00 30 00 00 00 32 43 46 45 39 42 00 70 F5 12 00 74 FF 00 00 00 00 00 00 00 00 00 00 
__ 128: 3C 00 00 0B B8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02 02 50 01 
__ 160: 46 72 65 65 41 67 65 6E 74 20 47 6F 46 6C 65 78 10 50 11 46 72 65 65 41 67 65 6E 74 20 47 6F 46)

For the other devices this seems clear enough.  In most of the cases,
the data doesn't include the Caching page.  The Samsung and Transcend
devices _do_ provide their Caching pages, and in both of them the data
says that write caching is disabled.  (In the Samsung case this is
wrong undoubtedly because of the JMicron bridge -- JMicron's firmware
is notoriously buggy.)

If you can suggest a robust way of determining whether or not a drive 
supports SAT (one which won't cause non-supporting devices to crash), 
it could be added.  In the meantime, I'm not sure what else we can do.

Would it make sense to assume write caching is present and enabled if 
the drive does not provide a Caching page?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
