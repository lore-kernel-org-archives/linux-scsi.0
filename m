From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: RES: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Mon, 25 Aug 2014 16:21:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408251613270.1385-100000@iolanthe.rowland.org>
References: <175058921e084d26ba362fa6ecd7351c@serv030.corp.eldorado.org.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <175058921e084d26ba362fa6ecd7351c-CWPHn/M7kmRpAIlDVkCwMZnVvqcnFG0x9MRKq5+/VYY@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alfredo Dal Ava Junior <alfredo.junior-peCLlicIkyA3OWu3QmcX+g@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 25 Aug 2014, Alfredo Dal Ava Junior wrote:

> Well, it is causing problems anyway... from user perspective, it's a
> Linux compatibility issue, as it works "fine" on Windows. I'm not an
> expert, but I'm wondering that if usb-storage could set capacity as
> "UNDETERMINED"/ Zero (or keep using the readcapacity_10 as it as with
> some flag signalizing it as inaccurate), EFI partition check would be
> able to ignore size and look for secondary GPT where it really is.

Part of the problem is that usb-storage has no way to know that
anything strange is going on.  It's normal for READ CAPACITY(16) to
fail (this depend on the SCSI level), and it's normal for the READ
CAPACITY(10) to report a value less than 2 TB.

Really there is only one way to know whether the actual capacity is 
larger than the reported capacity, and that is by trying to read blocks 
beyond the reported capacity -- a dangerous test that many drives do 
not like.  (And in most cases a futile test.  If a device doesn't 
support READ CAPACITY(16), how likely is it to support READ(16)?)

Yes, in theory you can believe the value in the partition table in 
preference to the reported capacity.  But what if that value is wrong?  
And how do you tell partition-manager programs what the capacity should 
be when they modify or set up the initial partition table?

Attaching the drive over a SATA connection when you want to partition
it isn't a very satisfactory solution.  After all, if you have a SATA
connection available then why would you be using a USB enclosure in the
first place?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
