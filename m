From: Oliver Neukum <oneukum@suse.de>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 11:16:49 +0100
Message-ID: <1389953809.21408.7.camel@linux-fkkt.site>
References: <Pine.LNX.4.44L0.1401161125080.1109-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaAQKQu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 05:16:50 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401161125080.1109-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Todd E Brandt <todd.e.brandt@linux.intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2014-01-16 at 11:59 -0500, Alan Stern wrote:
> Since the START-STOP and TEST UNIT READY (or REQUEST SENSE or
> whatever)  
> commands are likely to take a long time, they should all be carried
> out
> asynchronously with respect to the resume procedure.  I don't know
> what
> the best way is to implement this.  But it is important to guarantee
> that in the RPM_ACTIVE case, the START-STOP command gets sent to the
> disk before any other commands.  (This isn't an issue in the 
> RPM_SUSPENDED case, as the block layer will prevent requests being 
> sent out unless they have the REQ_PM flag set.)
> 
> Does this plan sound reasonable to everyone?  Are there important
> aspects I haven't considered (such as interactions between the SCSI
> and
> ATA layers)?

The START-STOP may result in an error. What do you do in that case?

	Regards
		Oliver


