From: Alan Stern <stern@rowland.harvard.edu>
Subject: Retry counters in sd.c
Date: Wed, 15 Aug 2007 11:19:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0708151108000.3895-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46586 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763478AbXHOPTo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 11:19:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James (or anyone else who can answer):

The retry counters in sd.c seem to be out of whack.  For example,
consider sd_read_capacity().  There's an explicit retry loop that runs
3 times, and inside it is a call to scsi_execute_req() with
SD_MAX_RETRIES (= 5) as an argument.  If for any reason the device is
not able to determine the media capacity -- other than medium not
present -- the code ends up sending the READ CAPACITY command a total
of 3*(5+1) = 18 times!  Isn't that a little excessive?  After all, if
the capacity couldn't be determined the first time, how likely is the
device to get it right on the eighteenth?

And that's not even taking into account the fact that
sd_read_capcity(), together with everything else under
sd_revalidate_disk(), gets called twice in a row during device
scanning.  (What's the reason for that, anyway?)  This makes for a 
total of 36 failed commands.

There are other examples of explicit outer loops combined with large 
retry arguments to scsi_execute_req(), but this one caught my eye 
because of the logs attached to Bugzilla #8885.  See especially the log 
attached to comment #22.

It seems to me that we should be able to get away with using 1 instead
of SD_MAX_RETRIES here, and probably in a few other places as well.  
There's not much point in having an inner retry loop if there's already
an outer loop.  Do you agree?

Alan Stern

