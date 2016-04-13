From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Lsf] LSF/MM Schedule and improving discard support
Date: Wed, 13 Apr 2016 12:43:39 -0400
Message-ID: <yq1twj5v4qs.fsf@sermon.lab.mkp.net>
References: <57067F19.3030404@sandisk.com>
	<1460044289.2311.5.camel@linux.vnet.ibm.com>
	<570E6C55.1060003@sandisk.com> <yq11t69wkcl.fsf@sermon.lab.mkp.net>
	<570E73D5.3010502@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28735 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcDMQnv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 12:43:51 -0400
In-Reply-To: <570E73D5.3010502@sandisk.com> (Bart Van Assche's message of
	"Wed, 13 Apr 2016 09:29:09 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@fb.com>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> Today if a BLKDISCARD ioctl passes a non-aligned start and/or end
Bart> sector to the kernel then the block layer will submit invalid
Bart> (non-aligned) REQ_DISCARD requests to the block driver the ioctl
Bart> applies to.

I do not know what you mean by "invalid".

A device that implements UNMAP can freely ignore any parts of a request
block range that are not aligned to its internal allocation units.

>From SBC: "An unmap request with a number of logical blocks that is not
a multiple of this value (OPTIMAL UNMAP GRANULARITY) may result in unmap
operations on fewer LBAs than requested." and "An unmap request with a
starting LBA that is not optimal may result in unmap operations on fewer
LBAs than requested."

The same is true for SATA which has no way report granularity and
alignment at all.

Nowhere does it say that a request that is not an aligned multiple of
any reported granularity should be considered "invalid" or rejected by
the storage.

-- 
Martin K. Petersen	Oracle Linux Engineering
