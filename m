From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_lib: replace ambiguous "Unhandled error code"
 messages.
Date: Mon, 26 May 2014 09:25:06 -0700
Message-ID: <20140526162506.GB18319@infradead.org>
References: <1401099204-18050-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaEZQZG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 May 2014 12:25:06 -0400
Content-Disposition: inline
In-Reply-To: <1401099204-18050-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, James.Bottomley@HansenPartnership.com

On Mon, May 26, 2014 at 12:13:24PM +0200, Maurizio Lombardi wrote:
> During IO with fabric faults, one generally sees several "Unhandled error
> code" messages in the syslog as shown below:
> 
> sd 4:0:6:2: [sdbw] Unhandled error code
> sd 4:0:6:2: [sdbw] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> sd 4:0:6:2: [sdbw] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
> end_request: I/O error, dev sdbw, sector 0
> 
> This comes from scsi_io_completion (in scsi_lib.c) while handling error
> codes other than DID_RESET or not deferred sense keys i.e. this is
> actually handled by the SCSI mid layer. But what gets displayed here is
> "Unhandled error code" which is quite misleading as it indicates
> something that is not addressed by the mid layer.
> 
> This patch replaces "Unhandled error code" with "Extended error description
> not available".

How about simple not setting description at all for this case?

