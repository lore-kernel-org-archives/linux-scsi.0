From: Alan Stern <stern@rowland.harvard.edu>
Subject: Problems with sr_get_events
Date: Sun, 8 Apr 2012 09:24:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204080858300.11397-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:58056 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755350Ab2DHNYd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Apr 2012 09:24:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Tejun:

There are several closely related issues involving sr_get_events().

The first may just be confusion on my part.  You've got a 
cd->ignore_get_event flag, whose name seems to mean that the result 
from sr_get_events() should be ignored.  But the result isn't ignored 
entirely; only the DISK_EVENT_MEDIA_CHANGE bit is cleared.

Furthermore, if you really do intend to ignore the result from 
sr_get_events() then why call it in the first place?  Or does the flag 
actually mean that you want to ignore the media-change bit from 
get_events while still using the other bits?

Finally, the GET_EVENT_STATUS_NOTIFICATION command is not present in 
all versions of SCSI, and not all drives support it.  sr_get_events() 
should check for an ILLEGAL_REQUEST sense key and stop sending the 
command if it is found.  Maybe a new flag will be needed for this.

Alan Stern

