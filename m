From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Improve code for detecting errors near the end of a CD
Date: Fri, 14 Oct 2005 22:36:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0510142203230.24065-100000@netrider.rowland.org>
References: <43505229.8010502@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:27917 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S1751043AbVJOCgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 22:36:50 -0400
In-Reply-To: <43505229.8010502@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 15 Oct 2005, Douglas Gilbert wrote:

> Alan,
> In include/scsi/scsi_eh.h there are several helper functions
> to aid processing SCSI errors. This includes SCSI sense data
> descriptor format (which won't be needed for DVD/HD/BD for
> some time with a (2**32 * 2048) byte maximum using existing
> fixed sense data format). However there is
> scsi_get_sense_info_fld() to fetch the info field.
> 
> sd, st and sg have been converted to use these helpers,
> where appropriate.
> 
> MMC-4 does not mention that the valid bit needs to
> be set on a MEDIUM/HARDWARE error and I have seen
> real life examples of this. [So it's poorly defined
> if one gets a medium error on lba 0.] You may also like to
> consider deferred errors which can occur according to
> MMC-4.

Thanks for the comments.  It will be easiest to start with this patch and 
then add others on top.  I wouldn't mind writing another update to use 
scsi_get_sense_info_fld and friends.

I'm not familiar with the MMC standards and it will take some time to get 
up to speed on MMC-4.  I just downloaded the draft standard, and it's not 
obvious where (if anywhere) it describes the sense data values.

As for deferred errors, I don't know the proper way of handling them.  It 
would be better for someone else to take care of it.

Alan Stern

