From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Wed, 07 Sep 2005 10:16:36 -0500
Message-ID: <1126106196.4823.16.camel@mulgrave>
References: <Pine.LNX.4.44L0.0507261008540.4746-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:43915 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932166AbVIGPQj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 11:16:39 -0400
In-Reply-To: <Pine.LNX.4.44L0.0507261008540.4746-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2005-07-26 at 10:12 -0400, Alan Stern wrote:
> This patch (as542) fixes a few loose ends left by Mike's patches.  It adds 
> a declaration for the new scsi_host_set_state routine, adds an allowed 
> transition from the SHOST_RECOVERY state to the SHOST_CANCEL state, and 
> avoids returning an uninitialized value in __scsi_add_device.

The first part (external declaration) is already in.

The second (allow RECOVERY->CANCEL) isn't really an answer.  The correct
thing, I suppose, is to have scsi_remove_host() wait for the error
handler to finish if the state transition cannot be accomodated
(otherwise the error handler will try to transition ->RUNNING part way
through the removal).

The third (don't allow uninitialised return from __scsi_add_device) is
correct, but the return is universally ignored (the only actual user
being ipr).  Unfortunately, now I look at this, ipr gets it wrong too.
This API currently returns an sdev with an incremented refcount.  If you
ignore the return, as ipr does, you're leaking refcounts.  So, since the
only user gets it wrong all the time, I'd vote for modifying the API not
to return a device.

James


