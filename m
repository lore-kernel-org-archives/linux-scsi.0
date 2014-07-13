From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 06/10] sd: don't use scsi_setup_blk_pc_cmnd for discard requests
Date: Sun, 13 Jul 2014 10:35:37 -0400
Message-ID: <yq14myl1g3q.fsf@sermon.lab.mkp.net>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
	<1404048881-19526-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44834 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaGMOfp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 10:35:45 -0400
In-Reply-To: <1404048881-19526-7-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Sun, 29 Jun 2014 15:34:37 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Simplify handling of discard requests by setting up the
Christoph> command directly instead of initializing request fields and
Christoph> then calling scsi_setup_blk_pc_cmnd to propagate the
Christoph> information into the command.

Would be nice to add a comment similar to the WRITE SAME one. Something
like:

/* 
 * Initially __data_len is set to the amount of data that needs to be
 * transferred to the target. This amount depends on whether WRITE SAME
 * or UNMAP is being used. After the scatterlist has been mapped by
 * scsi_init_io() we set __data_len to the size of the area to be
 * discarded on disk. This allows us to report completion on the full
 * amount of blocks described by the request.
 */

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
