From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Tue, 10 Jun 2008 18:19:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806101816290.20539-100000@netrider.rowland.org>
References: <200806102206.26818.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:4464 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753889AbYFJWTd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 18:19:33 -0400
In-Reply-To: <200806102206.26818.chris2553@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Clayton <chris2553@googlemail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Tue, 10 Jun 2008, Chris Clayton wrote:

> What this has shown is that, when I plug in a usb-storage device, there seems 
> to be a delay between the usb/scsi/usb-storage drivers setting up the device 
> and my icon-showing script being run. Here is the snippet from the kernel log 
> file:

...
> Jun 10 20:27:45 upstairs kernel: [ 3200.815772] usb-storage: waiting for device 
> to settle before scanning
> Jun 10 20:27:50 upstairs kernel: [ 3205.817115] scsi 10:0:0:0: Direct-Access              
> USB Flash Memory 5.00 PQ: 0 ANSI: 0 CCS
...

You can eliminate this 5-second delay by adding

	options usb-storage delay_use=0

to /etc/modprobe.conf.  Of course, this will make the other delays just 
stand out that much more sharply...

Alan Stern

