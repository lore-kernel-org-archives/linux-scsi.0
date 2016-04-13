From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [Lsf] LSF/MM Schedule and improving discard support
Date: Wed, 13 Apr 2016 09:51:04 -0700
Message-ID: <1460566264.2322.13.camel@linux.vnet.ibm.com>
References: <57067F19.3030404@sandisk.com>
	 <1460044289.2311.5.camel@linux.vnet.ibm.com> <570E6C55.1060003@sandisk.com>
	 <yq11t69wkcl.fsf@sermon.lab.mkp.net> <570E73D5.3010502@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:39414 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbcDMQvK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 12:51:10 -0400
Received: from localhost
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Wed, 13 Apr 2016 10:51:09 -0600
In-Reply-To: <570E73D5.3010502@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@fb.com>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>

On Wed, 2016-04-13 at 09:29 -0700, Bart Van Assche wrote:
> On 04/13/2016 09:21 AM, Martin K. Petersen wrote:
> > From a filesystem/ioctl perspective, BLKDISCARD is a hint. We
> > should not be
> > rounding off or aligning anything.
> 
> Hello Martin,
> 
> Today if a BLKDISCARD ioctl passes a non-aligned start and/or end 
> sector to the kernel then the block layer will submit invalid (non
> -aligned) REQ_DISCARD requests to the block driver the ioctl applies 
> to. This is not acceptable. Does the above mean that you are 
> proposing to fail such BLKDISCARD ioctls with an error code?

The answer would be of course not.  discard is a hint so malformed
discard gets ignored by the device and success is returned because you
can't oblige devices to obey hints (that's why they're called hints).

However, the problem of needing a mandatory discard for scrubbing
blocks is part of the fallocate discussion, I think.

James


