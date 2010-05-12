From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 12 May 2010 11:09:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1005121056520.1962-100000@iolanthe.rowland.org>
References: <4BEAA583.1090805@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47936 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751113Ab0ELPJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 11:09:46 -0400
In-Reply-To: <4BEAA583.1090805@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <mlord@pobox.com>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>

On Wed, 12 May 2010, Mark Lord wrote:

> The sticky part is that hdparm explicitly asked for sense data.
> 
> But the results were marked as "no sense data".  Many of the commands
> sent by hdparm _require_ "sense data" (ATA register values) in order
> to see the results.  The USB driver appears to ignore that request
> when it sees good device status from the original command.  Bug.

This sounds like it is a bug in the SCSI midlayer, not in usb-storage.  

There is no mechanism for the midlayer to tell low-level drivers like
usb-storage that sense data must be returned.  The documentation in
include/scsi/scsi_cmnd.h merely states that the sense buffer should be
filled when CHECK CONDITION is received for the original command.  
Ditto for Documentation/scsi/scsi_mid_low_api.txt.  Hence if sense data
is needed even in the absence of CHECK CONDITION, the midlayer must
explicitly send a command to retrieve it.

What mechanism does hdparm use to submit its I/O requests, and how does 
it indicate that it requires sense data?

Alan Stern

