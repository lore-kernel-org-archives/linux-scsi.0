From: Alan Stern <stern@rowland.harvard.edu>
Subject: SCSI state model, and "soft" host removal
Date: Thu, 1 May 2008 16:52:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0805011615430.2186-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42759 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759059AbYEAUw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 16:52:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James, Mike, or anyone else:

I've got a few questions regarding the state model and "soft" (i.e., 
notified) host removals.

First, concerning the SHOST_STATE_* values...  Although there is an
elaborate state machine which allows only selected transitions, and
although the value can be viewed and changed via sysfs -- nevertheless, 
the value is actually _used_ in only two places:

	scsi_host_get() fails if the state is SHOST_STATE_DEL,

	and ditto for scsi_dispatch_cmd().

Did I miss something?  This suggests that the state machinery may be a 
lot more complicated than truly necessary.  Should it be simplified?

(Side note: Back near the end of 2004 (?), there was an extended
discussion on the state model, eventually leading to the creation of
the SHOST_DEL_RECOVERY state.  I'm unable to locate that thread in an
email archive, which is a shame because it included some very nice
descriptions of the meaning of the various states and the allowed
transitions.  There isn't anything in Documentation/scsi with a
comparable explanation -- and there certainly ought to be.  Can you
locate those old email messages?)


Second, concerning soft host removal...  I have in mind a situation
where a user wants to unbind usb-storage from a device in a clean, safe
manner, without unplugging anything.  Existing commands should be
allowed to complete, caches should be flushed, and so on.  Is there any
way to do this?

It used to be that scsi_remove_host() would cancel all outstanding
commands.  Isn't that still true?  If so, is there any way to
accomplish what I want?

Thanks,

Alan Stern

