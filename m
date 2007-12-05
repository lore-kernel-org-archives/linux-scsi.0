From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] SCSI: early detection of medium not present, updated
Date: Wed, 05 Dec 2007 18:06:32 +0200
Message-ID: <1196870792.11927.21.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0712021458120.4185-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33384 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750862AbXLEQGi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 11:06:38 -0500
In-Reply-To: <Pine.LNX.4.44L0.0712021458120.4185-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Albert Lee <albertcc@tw.ibm.com>, Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>


On Sun, 2007-12-02 at 15:02 -0500, Alan Stern wrote:
> On Sun, 2 Dec 2007, James Bottomley wrote:
> 
> > Actually, the night train is a good place to do coding.  I know this
> > compiles, but could someone check it out?  It's the form I think we
> > should do, since the ASC/ASCQ codes for esoteric conditions which we
> > might eventually check for are different for CDs and removable discs.
> 
> This part is puzzling:
> 
> > +	/* try to eat the UNIT_ATTENTION if there are enough retries */
> > +	do {
> > +		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
> > +					  timeout, retries);
> > +	} while ((driver_byte(result) & DRIVER_SENSE) &&
> > +		 sshdr && sshdr->sense_key == UNIT_ATTENTION &&
> > +		 --retries);
> 
> For one thing, you've using retries to control both an outer loop and 
> an inner loop -- meaning the total number of attempts could be on the 
> order of retries**2.

Sort of; however, there should only really be one cc/ua before the TUR
goes through.  Also, TUR produces almost no conditions that would be
retryable in scsi_decide_disposition() and the scsi_execute sends it
down with REQ_FAILFAST anyway, so it's really not used much.

> For another, why do you want to swallow a UNIT_ATTENTION?  Shouldn't 
> that be up to the code calling scsi_test_unit_ready()?

No, that's a bug in the old code.  UA doesn't necessarily mean there's a
media change.  It could be asserted for a whole host of reasons.  Until
we get proper UA signalling, we need to resend the TUR so we get the
correct media status and discard the UA (Even if the device is asserting
UA for media change reasons, it will still give the correct sense code
response to the following TUR).

James

