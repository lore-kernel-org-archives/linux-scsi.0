From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Mon, 25 Aug 2014 10:44:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408251037370.1385-100000@iolanthe.rowland.org>
References: <20140824150439.GA3453@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34161 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932863AbaHYOoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2014 10:44:15 -0400
In-Reply-To: <20140824150439.GA3453@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Tiziano Bacocco <tiziano.bacocco@gmail.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Sun, 24 Aug 2014, Christoph Hellwig wrote:

> On Fri, Aug 22, 2014 at 01:29:32PM -0400, Alan Stern wrote:
> > > Other than this, I'm fine with the code ... you can add the acked by
> > > from me when we resolve the above question.
> > 
> > Okay.  It's true that this issue is only tangentially related to the 
> > main point of the patch.  It could be removed and addressed later.
> 
> Just make it a separate patch and send it along..

All right.  But I still want to know first whether the patch really
fixes the original problem.

Tiziano, do you intend to test this patch?

James, can you explain how the INQUIRY command in scsi_probe_lun()  
managed to work back in the days when multi-lun SCSI-2 devices were
common?  sdev->scsi_level doesn't get set when sdev is allocated, so it
initially contains 0, so the LUN bits won't get filled in when the
first INQUIRY command is sent.  Then how could the target know which
logical unit the INQUIRY was meant for?

Alan Stern

