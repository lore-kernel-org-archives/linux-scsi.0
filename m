From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: /proc/scsi/map
Date: Mon, 17 Jun 2002 09:54:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206171454.g5HEsu802593@localhost.localdomain>
References: <oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA29858
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2002 07:55:09 -0700
In-Reply-To: Message from Oliver Neukum <oliver@neukum.name>
   of "Mon, 17 Jun 2002 07:19:52 +0200." <200206170719.52136.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, David Brownell <david-b@pacbell.net>, Andries.Brouwer@cwi.nl, garloff@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sancho@dauskardt.de, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dougg@torque.net

oliver@neukum.name said:
>  These may be an exception. You usually want to get drivers involved
> even if only for synchronisation. Failing to do so has already let to
> problems with usb storage. 

I don't deny that there may be devices that need some type of vendor specific 
probe to get the information.

> That is the point. The driver knows best what kind of devices it works
> on. You can forget about the whole identification method business, if
> you go for the driver. In case of usb storage and firewire that data
> is already sitting there ready for taking. I suspect the same for
> fibrechannel. 

But, in SCSI, you can't.  Just for a simple device showing up as a SCSI disc 
(that's a real SCSI disc, attached say by parallel connectors), there are 
several potential ways to get a unique ID.  No one way works for all such 
disks, that is the nub of the problem.

I think, by driver, we may mean different things.  A scsi disc attaches like 
this:

   +----+
   | sd |
   +----+
      |
 +-------+
 | mid   |
 | layer |
 +-------+
     |
  +-----+
  | lld |
  +-----+
     |
 +--------+
 | real   |
 | device |
 +--------+

but the only piece that has disc specific logic is sd.  The lld is specific to 
the host adapter card (not shown), not the real device, so it is not the right 
element to probe for an ID.

In USB, things look slightly different:

   +----+
   | sd |
   +----+
      |
 +-------+
 | mid   |
 | layer |
 +-------+
     |
+---------+
| usb     |
| storage |
+---------+
     |
 +--------+
 | real   |
 | device |
 +--------+

Here, the usb-storage driver does know about the real device (and already has 
a huge exception table), so it has enough knowledge to probe for an identifier.

The thing I think is a bad idea is having to code the logic to look up a 
unique identifier (plus all the exceptions) in sd.  But for the pure SCSI 
stack, there's nowhere else to place it.  Even if you get usb-storage to 
supply an API for providing the id, it will be one of the few llds that can 
retrieve this, so it will become just another exception sd has to cope with.

James


