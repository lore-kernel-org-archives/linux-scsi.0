From: Alan Stern <stern@rowland.harvard.edu>
Subject: Suggestion for aiding debugging of host removal
Date: Wed, 10 Dec 2003 10:02:22 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312100947550.775-100000@ida.rowland.org>
References: <20030709144410.GA3544@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:516 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262767AbTLJPCX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2003 10:02:23 -0500
In-Reply-To: <20030709144410.GA3544@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Mike:

I've got a question about host removal.  Once scsi_remove_host() has
returned, the host driver's module is free to unload from memory (assuming
the module's reference count is 0, which it normally is).  Hence it is a
mistake to access the host template in any way after that time.

But it looks like scsi_host_dev_release() can be called after
scsi_remove_host() has returned, and it uses shost->hostt.  There may be 
other uses as well.

Would it help flush out such illegal accesses if at some appropriate point 
shost->hostt was set to NULL, maybe near the end of scsi_remove_host()?

Alan Stern



