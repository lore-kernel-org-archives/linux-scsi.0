From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: 11 Oct 2004 15:12:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097525576.2031.173.camel@mulgrave>
References: <Pine.LNX.4.44L0.0410111558460.21084-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:21735 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269217AbUJKUNA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 16:13:00 -0400
In-Reply-To: <Pine.LNX.4.44L0.0410111558460.21084-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2004-10-11 at 15:03, Alan Stern wrote:
> The problem arises when a command completes.  In the notified ejection 
> case, if the LLD tries to call the scsi_done routine for a completed 
> command which was submitted before scsi_remove_host and which the SCSI 
> core has already cleaned up, it will cause an oops.  Since the LLD has no 
> way to tell whether the core has cleaned up a command or not, its only 
> choice is to fail _every_ command starting shortly before it calls 
> scsi_remove_host.

This is the remove implies cancel issue that was discussed earlier.  I
thought the proposal was to have a remove that wouldn't automatically
cancel all the commands? ... although I don't think I've seen any code
for that case yet.

James


