From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Tue, 28 Sep 2010 01:54:16 +0900
Message-ID: <4CA0CC38.5010804@fusionio.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:55674 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab0I0QyV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 12:54:21 -0400
In-Reply-To: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-09-28 01:41, Martin K. Petersen wrote:
> Mike Snitzer reported that he has access to a device that supports thin
> provisioning but does not use the Block Limits VPD page to indicate
> discard granularity. Instead it reports a huge (1MB) physical block
> size. That caused a bit of fallout in the topology stack which assumed a
> physical block size of 4KiB or less.

Fixing the overflow aside, I question the validity of setting the physical
block size to something larger than PAGE_SIZE as there's no way that that
could really work in the current kernel.

I would suggest doing something similar as we do with other 'invalid'
settings that we cannot honor, print a warning and drop the queue
limits to PAGE_SIZE.

-- 
Jens Axboe

