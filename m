From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: RES: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Tue, 26 Aug 2014 10:47:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408261031090.1434-100000@iolanthe.rowland.org>
References: <1409001390.376.6.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42988 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755253AbaHZOrm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2014 10:47:42 -0400
In-Reply-To: <1409001390.376.6.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Alfredo Dal Ava Junior <alfredo.junior@eldorado.org.br>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 25 Aug 2014, Oliver Neukum wrote:

> On Mon, 2014-08-25 at 16:21 -0400, Alan Stern wrote:
> > On Mon, 25 Aug 2014, Alfredo Dal Ava Junior wrote:
> > 
> > > Well, it is causing problems anyway... from user perspective, it's a
> > > Linux compatibility issue, as it works "fine" on Windows. I'm not an
> > > expert, but I'm wondering that if usb-storage could set capacity as
> > > "UNDETERMINED"/ Zero (or keep using the readcapacity_10 as it as
> > with
> > > some flag signalizing it as inaccurate), EFI partition check would
> > be
> > > able to ignore size and look for secondary GPT where it really is.
> > 
> > Part of the problem is that usb-storage has no way to know that
> > anything strange is going on.  It's normal for READ CAPACITY(16) to
> > fail (this depend on the SCSI level), and it's normal for the READ
> > CAPACITY(10) to report a value less than 2 TB.
> 
> Just set US_FL_NEEDS_CAP16. If READ CAPACITY(16) fails in that case,
> it is clear that something is wrong. It must be set or READ CAPACITY(10)
> alone would be taken as giving a valid answer.

You have committed a mental layering violation.  :-)

US_FL_NEEDS_CAP16 is a usb-storage flag.  But the capacity
determination is made by the sd driver, which relies on the SCSI
try_rc_10_first flag.  If that flag isn't set, sd tries READ 
CAPACITY(16) and then falls back to READ CAPACITY(10) if an error 
occurs.  That's what happened here.

I don't think we want to add another SCSI flag to say that READ
CAPACITY(10) is unreliable.

> At that time we are sure that the drive will be unusable unless we
> determine the correct capacity, so we don't make matters worse if we
> crash it.

Given the difficulty of determining the true capacity, I see two
alternatives.  We could set the capacity to a ridiculously large value
(like 1 billion TB), or we could leave the capacity set to the low
value and disable the "block within bounds" checks.  Neither of these
is attractive and they both have issues of their own -- although the 
second is close to what Windows does.

(For example, udev often tries to read the last sectors of a new drive, 
looking for a GPT or RAID signature.  That won't work if the capacity 
is set to some random value.)

> Is there an easy way for Alfredo to determine what happens if we
> read beyond the end?

He could fiddle with sd_read_capacity().  Change sdkp->capacity to 
something bigger than the disk's actual size and then try reading 
beyond the actual end.

However, I don't see much point in this.  Any changes we make will have 
to work with every drive, not just Alfredo's.

Alan Stern

