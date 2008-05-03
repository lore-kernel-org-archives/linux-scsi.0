From: Alan Stern <stern@rowland.harvard.edu>
Subject: Discussion: soft unbinding
Date: Sat, 3 May 2008 12:03:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0805031148530.16732-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:4357 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753093AbYECQDj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 12:03:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

When talking about "soft" unbinding, the main question seems to be: How 
soft?

It would be easy, for instance, to change usb-storage so that unbinding
would wait until the current command was finished.  But clearly one
wants to do more: Give the upper-level SCSI drivers a chance to
shutdown cleanly and issue their FLUSH CACHE commands, wait for all
pending commands to complete, and so on.

It's the "wait for pending commands to complete" part that is hard.  
Some commands have relatively long timeouts.  Error handler operations
have no timeouts.  Commands submitted through sg can have effectively
infinite timeouts.  So how long should we wait?

Should there be a scsi_soft_remove_host() routine that accepts a
timeout value?  It would remove the devices under the host and wait
until the timeout expires (if necessary) before aborting all pending
commands.  Unlike scsi_remove_host(), it would really abort these
commands as though they had timed out, instead of simply cancelling
them.  It would guarantee that when it returned, no commands were still
running on the host and no more commands would be submitted.

This would essentially be a standardized version of the special code 
Stefan has put into the sbp2 and firewire-sbp2 drivers.

Alan Stern

