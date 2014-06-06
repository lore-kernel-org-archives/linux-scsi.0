From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] scsi_lib: removes ambiguous "Unhandled error code"
 messages.
Date: Fri, 6 Jun 2014 07:12:15 -0700
Message-ID: <20140606141215.GB9303@infradead.org>
References: <1402042235-7246-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaFFOMQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 10:12:16 -0400
Content-Disposition: inline
In-Reply-To: <1402042235-7246-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hch@infradead.org

On Fri, Jun 06, 2014 at 10:10:35AM +0200, Maurizio Lombardi wrote:
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
> This patch removes "Unhandled error code" and replaces "Unhandled sense code"
> with "Failing command with sense code:".
> 
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
