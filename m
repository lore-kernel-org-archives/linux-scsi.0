From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] unsolicited sense in 2.6.0-test5 usb-storage.ko
Date: Wed, 10 Sep 2003 17:03:12 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309101700230.1579-100000@ida.rowland.org>
References: <1063227068.3669.129.camel@patehci2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:32772 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265730AbTIJVDP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 17:03:15 -0400
In-Reply-To: <1063227068.3669.129.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On 10 Sep 2003, Pat LaVarre wrote:

> A contributing factor seems to be usb/storage injecting an unsolicited
> request sense injected as if it were an auto sense, despite bCSWStatus =
> x00 Passed.

> CONFIG_USB_STORAGE_DEBUG=y gives contrasting dmesg traces.
> 
> For the unhappy sgp_dd we have 8 = Di < Hi = x40 = 64:

> For the happy sg_dd we have Di = Hi = 8:

The reason for the unsolicited REQUEST-SENSE is that usb-storage expects
that certain commands will never yield a short transfer, so if they do it
must mean something has gone wrong, even if Status = 0.  READ-CAPACITY is
one of those commands.  Since sgp_dd asked for a 64-byte READ-CAPACITY, it
gets what it deserves.

Alan Stern

