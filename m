From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
Date: Fri, 20 Jun 2008 18:37:56 +0200
Message-ID: <485BDCE4.2010303@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0806201130390.2719-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48994 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYFTQkI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jun 2008 12:40:08 -0400
In-Reply-To: <Pine.LNX.4.44L0.0806201130390.2719-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Matthew Wilcox <matthew@wil.cx>, Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org, dsd@gentoo.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, vegardno@ifi.uio.no, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

Alan Stern wrote:
> New USB devices can appear at any time.  None are present when the 
> system is started; they are all detected dynamically by the khubd 
> thread.
> 
> While I'm not familiar with the details of any other hotpluggable 
> buses (like Firewire), I imagine much the same is true for them.

It's very similar with FireWire.  FireWire devices announce SBP-2 target
capability (if they have it) after they became ready.  The ieee1394 or
firewire core then scans or re-scans them in a process context.  Then
upper layer drivers like the SBP-2 driver are matched, bound, probed.

If SBP-2 targets went through a power state change, they typically first
power everything up (spin up media etc.) before they announce their
protocol capabilities, and this may of course take a while.  Before that
they just are inaccessible, and it is unknown whether they could become
candidates for access by upper layer drivers.
-- 
Stefan Richter
-=====-==--- -==- =-=--
http://arcgraph.de/sr/
