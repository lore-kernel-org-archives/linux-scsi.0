From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: LSF/MM Schedule and improving discard support
Date: Wed, 13 Apr 2016 12:21:14 -0400
Message-ID: <yq11t69wkcl.fsf@sermon.lab.mkp.net>
References: <57067F19.3030404@sandisk.com>
	<1460044289.2311.5.camel@linux.vnet.ibm.com>
	<570E6C55.1060003@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48977 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbcDMQVc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 12:21:32 -0400
In-Reply-To: <570E6C55.1060003@sandisk.com> (Bart Van Assche's message of
	"Wed, 13 Apr 2016 08:57:09 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart,

Bart> There is something that should be discussed further, namely what
Bart> the behavior of the BLKDISCARD and BLKSECDISCARD ioctls should be
Bart> if the start and/or end sectors are not aligned on a discard
Bart> boundary. Should such requests fail with an error code, should the
Bart> non-aligned head and tail be zeroed or should the non-aligned
Bart> parts be left unmodified?

I think the problem with your changes is that they mix upward and
downward-facing behaviors.

>From a filesystem/ioctl perspective, BLKDISCARD is a hint. We should not be
rounding off or aligning anything. DM or the thin provisioned device may
or may not ignore parts of the request. Their business. And since
discard is there to alleviate write amplification, it absolutely should
never cause any media writing to happen.

BLKZEROOUT, on the other hand, needs to provide hard guarantees. It is
up to the filesystem or ioctl caller to indicate whether allocation or
deallocation is preferred in this case. And then that should get turned
into a mix of WRITE, WRITE SAME or DISCARD commands based on alignment,
granularity and discard_zeroes_data reported by the device.

Darrick has been trying to clean all this up and I would like to see the
explicit distinction between allocate(anchor), deallocate(discard/unmap)
and zeroout (write same, unmap) in the upward-facing interfaces. And
then have those interfaces use WRITE SAME, DISCARD and ANCHOR to
implement their functionality based on the parameters reported by the
underlying device.

-- 
Martin K. Petersen	Oracle Linux Engineering
