From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/6] scsi: split scsi_nonblockable_ioctl
Date: Wed, 05 Nov 2014 09:28:56 -0500
Message-ID: <yq1bnolen6f.fsf@sermon.lab.mkp.net>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
	<1414661229-15199-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28443 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaKEO3G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2014 09:29:06 -0500
In-Reply-To: <1414661229-15199-3-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Thu, 30 Oct 2014 10:27:05 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> The calling conventions for this function where bad as it
Christoph> could return -ENODEV both for a device not currently online
Christoph> and a not recognized ioctl.

s/where/were/

Christoph> Add a new scsi_ioctl_block_when_processing_errors function
Christoph> that wraps scsi_block_when_processing_errors with the a
Christoph> special case for the SG_SCSI_RESET ioctl command, and handle
Christoph> the SG_SCSI_RESET case itself in scsi_ioctl.  All callers of
Christoph> scsi_ioctl now must call the above helper to check for the EH
Christoph> state, so that the ioctl handler itself doesn't have to.

Nice cleanup!

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
