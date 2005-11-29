From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Device flags: use_10_for_rw and use_10_for_ms
Date: Tue, 29 Nov 2005 14:48:35 -0800
Message-ID: <20051129224835.GA7505@us.ibm.com>
References: <20051129200334.GB15804@suse.de> <Pine.LNX.4.44L0.0511291616470.18319-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:12439 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S964796AbVK2Wsp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 17:48:45 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jATMmjhk004403
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 17:48:45 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jATMoCnR098156
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 15:50:12 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jATMmiJX014496
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 15:48:44 -0700
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0511291616470.18319-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Nov 29, 2005 at 04:23:16PM -0500, Alan Stern wrote:

Alan -

Looking at the full log (with no patches) and your earlier patch, I'm
confused by two things.

First, the READ_10 command being sent after we get the ILLEGAL REQUEST.

Do you know how that READ_10 is sent? Is the upper layer add_disk() check
partition code retrying? Then I'd expect a READ_6. If it were already
prepped, I guess we can get another READ_10, but I thought that the
partition read/check code only issued one read at a time.

The scsi_check_sense() should not be allowing the retry, we have a "return
SUCCESS" there. If we did want to retry via scmd->retries, we might be
able to add code into scis_check_sense().

And:

How can the current scsi_lib.c scsi_io_completion() *ever* requeue after
an sd.c read/write has turned off use_10_for_rw in sd_rw_intr()?

That is, sd.c sd_rw_intr() gets ILLEGAL REQUEST, and clears use_10_for_rw,
this snippet:

		case ILLEGAL_REQUEST:
			if (SCpnt->device->use_10_for_rw &&
			    (SCpnt->cmnd[0] == READ_10 ||
			     SCpnt->cmnd[0] == WRITE_10))
				SCpnt->device->use_10_for_rw = 0;

Then it calls scsi_io_completion(), where we only requeue if use_10_for_rw
is still set, so we never requeue via this code path. That is why without
your patch we get an error output. Correct?!

So with the patch you posted earlier, all it does (in scsi_io_completion())
is set use_10_for_rw back to 1, and then requeue the IO.

If you remove (or move) that sd.c code, it seems you'll hit this, and
figure that you do not want to switch from 6 to 10 byte commands (and
perhaps back) at all.

Then we need a method so we don't switch: another bit or state set after
a successful read or write command (and I guess one for succesful mode
sense command). 

We need only check the do-not-switch flag if we get an ILLEGAL REQUEST. We
already have to check use_10_for_rw before every read or write request.

-- Patrick Mansfield
