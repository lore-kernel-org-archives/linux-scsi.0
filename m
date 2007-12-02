From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch] SCSI: early detection of medium not present, updated
Date: Sun, 2 Dec 2007 15:02:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0712021458120.4185-100000@netrider.rowland.org>
References: <1196615429.32348.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:3348 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754411AbXLBUCV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2007 15:02:21 -0500
In-Reply-To: <1196615429.32348.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Albert Lee <albertcc@tw.ibm.com>, Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>

On Sun, 2 Dec 2007, James Bottomley wrote:

> Actually, the night train is a good place to do coding.  I know this
> compiles, but could someone check it out?  It's the form I think we
> should do, since the ASC/ASCQ codes for esoteric conditions which we
> might eventually check for are different for CDs and removable discs.

This part is puzzling:

> +	/* try to eat the UNIT_ATTENTION if there are enough retries */
> +	do {
> +		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
> +					  timeout, retries);
> +	} while ((driver_byte(result) & DRIVER_SENSE) &&
> +		 sshdr && sshdr->sense_key == UNIT_ATTENTION &&
> +		 --retries);

For one thing, you've using retries to control both an outer loop and 
an inner loop -- meaning the total number of attempts could be on the 
order of retries**2.

For another, why do you want to swallow a UNIT_ATTENTION?  Shouldn't 
that be up to the code calling scsi_test_unit_ready()?

Alan Stern

