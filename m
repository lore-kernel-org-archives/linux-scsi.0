From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/6] scsi: split scsi_nonblockable_ioctl
Date: Tue, 28 Oct 2014 10:05:32 +0100
Message-ID: <544F5C5C.3090104@acm.org>
References: <1414432746-12888-1-git-send-email-hch@lst.de> <1414432746-12888-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:34233 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaJ1JFh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2014 05:05:37 -0400
In-Reply-To: <1414432746-12888-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

On 10/27/14 18:59, Christoph Hellwig wrote:
> The calling conventions for this function where bad as it could return
> -ENODEV both for a device not currently online and a not recognized ioctl.
>
> Add a new scsi_ioctl_block_when_processing_errors function that wraps
> scsi_block_when_processing_errors with the a special case for the
> SG_SCSI_RESET ioctl command, and handle the SG_SCSI_RESET case itself
> in scsi_ioctl.  All callers of scsi_ioctl now must call the above helper
> to check for the EH state, so that the ioctl handler itself doesn't
> have to.

Hello Christoph,

I might be missing some background information here, but it's not clear 
to me why the function like scsi_block_when_processing_errors() was 
introduced some time ago. What if immediately after error handling has 
finished a new request is queued that kicks the error handler again 
before the caller of scsi_block_when_processing_errors() has finished 
the actions that should not occur concurrently with error handling ? Has 
it already been considered to introduce a mutex to serialize error 
handling and activity that should not occur concurrently with error 
handling ?

Thanks,

Bart.

