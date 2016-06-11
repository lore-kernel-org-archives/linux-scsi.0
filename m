From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Sat, 11 Jun 2016 07:06:49 -0400
Message-ID: <yq11t44f0hi.fsf@sermon.lab.mkp.net>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
	<20160610131901.GA28570@redhat.com>
	<yq160tgfoqr.fsf@sermon.lab.mkp.net> <575BE182.5010304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51279 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbcFKLHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jun 2016 07:07:03 -0400
In-Reply-To: <575BE182.5010304@suse.de> (Hannes Reinecke's message of "Sat, 11
	Jun 2016 12:01:38 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Because we're checking the wrong limit.

The original code checked that the request was smaller than both
max_sectors and max_hw_sectors so it would have failed here as well.

Hannes> blk_queue_get_max_sectors() is checking limits.max_sectors(),
Hannes> but the requests are already fully formed and can extend up to
Hannes> limits.max_hw_sectors().

We should not be issuing REQ_TYPE_FS requests larger than max_sectors.
How did we get here?

-- 
Martin K. Petersen	Oracle Linux Engineering
