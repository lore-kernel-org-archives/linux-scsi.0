From: Rob Landley <rob@landley.net>
Subject: What still uses the block layer?
Date: Thu, 11 Oct 2007 20:11:21 -0500
Message-ID: <200710112011.22000.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35594
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbXJMTJm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Oct 2007 15:09:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

My impression from asking questions on the linux-scsi mailing list is that the 
scsi upper/middle/lower layers doesn't use the block layer described in 
Documentation/block/*.

For example, the scsi guys say:
http://marc.info/?l=linux-scsi&m=118633268527856&w=2

Instead of using the block layer, SCSI reinvents this particular wheel itself.  
There's a scsi "upper layer" that provides /dev nodes, scsi low-level 
drivers, and a gigantic glue layer in between call the "scsi midlayer" that's 
something like a networking stack, and is responsible for losing track of all 
your devices so that the one SATA disk hardwired into your laptop might be 
sda or sdc depending on whether or not you had a USB key plugged in when you 
booted up.  Anyway, the block layer isn't between any of these three, that I 
can tell.

Now that IDE disks have been rerouted through the scsi layer, SATA goes 
through the scsi layer, USB goes through the scsi layer, firewire goes 
through the scsi layer...  What's left?  It seems like everything but 
ramdisks have now been routed through the scsi layer.  My laptop hasn't got a 
single SCSI device but it also hasn't got any block devices that don't show 
up as scsi.

So what's still using the block layer?  How do the scsi layers and the block 
layer relate?  I'm confused!  (This is normal for me, but still...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
