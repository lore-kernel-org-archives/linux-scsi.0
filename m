From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: IDs
Date: Mon, 6 Jan 2003 18:13:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030106181355.A11268@beaverton.ibm.com>
References: <UTC200301070000.h0700lx20735.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <UTC200301070000.h0700lx20735.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Tue, Jan 07, 2003 at 01:00:47AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-kernel@one-eyed-alien.net, zwane@holomorphy.com

Andries -

On Tue, Jan 07, 2003 at 01:00:47AM +0100, Andries.Brouwer@cwi.nl wrote:

> Maybe I should ask you to explain more in detail what purpose
> you have in mind. If I read your code and hear you talking
> it sounds like you would like to have a string identifying
> the device. But in many cases no such string exists.

Yes, but where one exists we can use it. Any recent SCSI disk should end
up with a unique value in (what is currently) sdev->name. We can tell if
the id sdev->name should be unique by looking at the first byte (it is not
unique if the value is 'Z', SCSI_UID_UNKNOWN).

> Moreover, what precisely is "the device"?
> If I have a Compact Flash card reader and read CF cards,
> is the device the reader? Or the card? Or the combination?
> If I have an Imation FlashGo! reader, and insert a SmartMedia
> adapter, and read a SmartMedia card, is the device the reader,
> the reader plus adapter, the card?

The scsi_device, whatever it represents. For removable media, we should
either make sure sdev->name has a value for this storage such that we know
the id is not unique, or we should check (and export to sysfs) the
sdev->removable flag. I haven't checked what currently gets put into
sdev->name for CF cards (or even if removable is properly set).

> If the device is the reader, then it will have a different size,
> partitioning and contents each time we see it.
> If the device is the card, then we need a different driver
> each time we see it.
> 
> What do you want to recognize with this ID, and why?
> 

For use with device naming/persistence.

For devices with a unique ID, we can always give them the same name;
non-unique ID's can be named based on their location
(host/channel/target/lun).

-- Patrick Mansfield
