From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: PATCH: (as54) Fix hot-unplugging for sr.c
Date: Tue, 8 Jul 2003 15:29:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708222906.GF2232@beaverton.ibm.com>
References: <20030703221940.GA5983@beaverton.ibm.com> <Pine.LNX.4.44L0.0307071111240.838-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:9931 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S267775AbTGHWL4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2003 18:11:56 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307071111240.838-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> Mike:
> 
> This is the final version of my patch to fix hot-unplugging for the SCSI 
> cdrom driver.  It prevents the private data structure from being 
> deallocated until all references to it have been dropped, and it prevents 
> races between sr_block_open() and sr_remove().
> 
> The patch does assume, however, that it is legal to submit requests (via 
> scsi_ioctl, for example) for a device that is marked offline.
> 
> Similar changes may be needed for the sd, st, and sg drivers; I haven't 
> looked at them.
> 
> Alan Stern

Alan,
	This looks like it solves the problem for sr and could be
	replicated for other upper level drivers. The patch I created
	works a little differently in that the remove function is not
	called until opens drop to zero (if the device is open).

	I started a new thread for the cleanup patches I have been
	working on  because I have four patches in the series (
	including a refresh of your /proc/scsi fixups).

-andmike
--
Michael Anderson
andmike@us.ibm.com

