From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 08 Aug 2005 00:15:06 +0200
Message-ID: <42F687EA.2020601@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0508071408370.32668-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:38585 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1753024AbVHGWPY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Aug 2005 18:15:24 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508071408370.32668-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>

Alan Stern wrote:
> Anyhow, I'm not so concerned about releasing resources associated with the
> host.  The LLD can handle that easily enough by first flagging the HBA
> as not accessible, then waiting for current I/O to terminate, then
> calling scsi_remove_host.  The resources can be released any time after
> the current I/O is finished; it doesn't matter whether the host is removed
> before or after.

What do you mean by "flagging the HBA as not accessible"?

In case you refer to scsi_block_requests(), this is taboo before any
device is being removed from a host, or at least before high-level
drivers are being detached from any device. scsi_remove_device() or
--- if there are still devices present on a host and have high-level
drivers attached --- scsi_remove_host() itself will cause I/O. If
this I/O was blocked, scsi_remove_*() would be sitting in a deadlock.

> The only resource that matters for this discussion is associated with the
> LLD itself, not with any of its hosts: the host template.  Once the SCSI
> core has released all references to the template, it can't call the LLD
> any more.  The problem is that the LLD has no way to know when all the
> references have been dropped.  This suggests that the entire problem could
> be solved by adding a kref to struct scsi_host_template.

Why should the LLD care if the core might want to access it after the
LLD made the prescribed API calls for host removal? It is the core's
responsibility that it never enters the host again after these API
calls were invoked.
-- 
Stefan Richter
-=====-=-=-= =--- --===
http://arcgraph.de/sr/
