From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch] SCSI: early detection of medium not present, updated
Date: Fri, 7 Dec 2007 10:51:37 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0712071049580.4209-100000@iolanthe.rowland.org>
References: <1196870792.11927.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34080 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750749AbXLGPvi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 10:51:38 -0500
In-Reply-To: <1196870792.11927.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Albert Lee <albertcc@tw.ibm.com>, Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>

On Wed, 5 Dec 2007, James Bottomley wrote:

> > For one thing, you've using retries to control both an outer loop and 
> > an inner loop -- meaning the total number of attempts could be on the 
> > order of retries**2.
> 
> Sort of; however, there should only really be one cc/ua before the TUR
> goes through.  Also, TUR produces almost no conditions that would be
> retryable in scsi_decide_disposition() and the scsi_execute sends it
> down with REQ_FAILFAST anyway, so it's really not used much.
> 
> > For another, why do you want to swallow a UNIT_ATTENTION?  Shouldn't 
> > that be up to the code calling scsi_test_unit_ready()?
> 
> No, that's a bug in the old code.  UA doesn't necessarily mean there's a
> media change.  It could be asserted for a whole host of reasons.  Until
> we get proper UA signalling, we need to resend the TUR so we get the
> correct media status and discard the UA (Even if the device is asserting
> UA for media change reasons, it will still give the correct sense code
> response to the following TUR).

Well then, the patch appears good.  I haven't been able to test it 
because it's based against a source tree I haven't got.  Can you 
provide an equivalent patch against 2.6.24-rc4?

Alan Stern

