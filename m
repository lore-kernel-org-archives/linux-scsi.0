From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Block timeouts seem not to be working
Date: Thu, 11 Sep 2008 08:42:05 -0700
Message-ID: <20080911154205.GA1069@linux.vnet.ibm.com>
References: <1221145521.3330.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53952 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbYIKPmL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2008 11:42:11 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8BFg8KQ023724
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2008 11:42:08 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8BFg8ls226018
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2008 11:42:08 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8BFg7n7020112
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2008 11:42:08 -0400
Content-Disposition: inline
In-Reply-To: <1221145521.3330.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <Jens.Axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> I just noticed this with a rather finickey SAS system I have.  It's got
> a SATA DVD attached over an expander.  Periodically the DVD just hangs
> up, so we wait for the timeout and then send a phy reset which clears
> it.
> 
> What I'm seeing with the new block timer code is that the timer never
> expires.  I can dig some more into this, but if you wanted to test it as
> well, the timer code is easy to excite.  Just throw away one command in
> every 128 or so in the queuecommand routine of your favourite HBA
> driver.

I have not seen the case of the timer never expiring, but will look into
other test cases.

Mike C and I where seeing timeout issues (host staying in recovery state
or list debug bugon's) when running tests with timeouts set to 1 or 2
seconds. We are working with Jens to address this.  The issue we where
hitting appears related to the scsi_eh / scsi_done completion
synchronization.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
