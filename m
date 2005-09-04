From: Andreas Herrmann <aherrman@web.de>
Subject: Re: [PATCH 1/7] zfcp: introduce eh_timed_out handler
Date: Sun, 04 Sep 2005 12:34:39 +0200
Message-ID: <431ACDBF.3020001@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp07.web.de ([217.72.192.225]:21683 "EHLO smtp07.web.de")
	by vger.kernel.org with ESMTP id S1750707AbVIDK1k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Sep 2005 06:27:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, aherrman@de.ibm.com

On Sat, 2005-09-03 13:45:01, James Bottomley wrote:
   > But that's not what the patch does.  It short circuits the error
   > handler
   > globally, not just in the cable pulled case.

   > For any error induced timeout, you're going to follow this logic. In
   > particular, if the device itself actually has an issue and genuinely
   > needs to be reset, that's never going to happen.

Ok, I aggree. It is short-sighted to introduce the patch. I was
totally focusing on a multipath setup and the cable pull case.

Now there is still the question how do prevent the SCSI stack from
taking SCSI devices offline if dm-multipath is used.

The target should be to re-enable paths if they come up again.  But
this just works if the SCSI device is online. This is required for
instance by multipathd to succesfully check the paths (e.g. using TUR
checker).

To "short circuit the error handler globally" is wrong. So how about
changing error handling while running
scsi_unjam_host/scsi_eh_ready_devs.  The problem that I observed is
that the timed out scsi command is kept in work_q and not moved to
done_q before scsi_eh_offline_sdevs is called.  How about moving all
scsi commands to done_q if blk_noretry_request(scmd->reqeust) is true
before scsi_eh_offline_sdevs is called, e.g. changing
scsi_eh_ready_devs to something like:

	if (!scsi_device_online(...))
	   if (!scsi_eh_bus_device_reset(...))
	      if (!scsi_eh_bus_reset(...))
		 if (!scsi_eh_host_reset(...))
		    if (!scsi_eh_move_blk_noretry_requests(...))
		       scsi_eh_offline_sdevs(...);

or as an alternative perform the move from work_q to done_q in one
(which?) of the reset functions.

   > Is this really what you want to do?

No, I don't.


Regards,

Andreas

PS: sorry for using this alternate email account

