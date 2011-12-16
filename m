From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: Make UAS work on HS for devices with and
 without command tagging support
Date: Fri, 16 Dec 2011 16:44:21 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1112161638540.1537-100000@iolanthe.rowland.org>
References: <20111216213628.GA5509@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55957 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756672Ab1LPVoW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2011 16:44:22 -0500
In-Reply-To: <20111216213628.GA5509@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Fri, 16 Dec 2011, Sarah Sharp wrote:

> Ok, I think we just need to divide the tag address space equally between
> devices.  The devinfo can keep track of the pointers to the scsi_devices
> for each LUN, and what tag range each LUN has.  So if you have 255 tags
> available, and two LUNs, you can give one of them tag 1 to 122, and the
> other tags 123 to 254.

The block layer already does a lot of this work for you.  Look through
block/blk-tags.c and you'll see what I mean: You ought to be able to
assign the same blk_queue_tag to all the request queues for all the
LUNs in your device.  And you can call blk_queue_find_tag() to do the 
reverse mapping.

Alan Stern

