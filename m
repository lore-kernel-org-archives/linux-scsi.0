From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: status of block-integrity
Date: Tue, 07 Jan 2014 16:43:40 -0500
Message-ID: <yq1a9f7wjqr.fsf@sermon.lab.mkp.net>
References: <20131222192128.GA28532@infradead.org> <52C6D0DB.1050906@suse.de>
	<yq1wqigzvc1.fsf@sermon.lab.mkp.net>
	<20140107013646.GB10297@birch.djwong.org> <52CBAA1B.7000509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28442 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaAGVoO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2014 16:44:14 -0500
In-Reply-To: <52CBAA1B.7000509@suse.de> (Hannes Reinecke's message of "Tue, 07
	Jan 2014 08:17:47 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, chuck.lever@oracle.com, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Plus (as hch rightly pointed out) as there is no defined
Hannes> userland interface the question is why we bother with all the
Hannes> DIX stuff in the block layer.  

Because it catches problems in the path between block layer and HBA
ASIC? FWIW, we find more issues there than we do between initiator and
target.

API issues aside, another reason adoption has been slow is that very few
applications truly care about this stuff. The current approach in which
data is protected when the I/O is submitted by the filesystem is good
enough for most things. Saves the filesystem people the trouble of
dealing with it too.

In reality there are only a handful of applications that would actually
benefit from an explicit userland API. Mostly in the database
department. All the potential consumers of an interface I talked to
wanted to use aio so that's why we've focused our efforts there.

Both Darrick and I have been busy with other projects the last little
while. I'll start looking at this again when I'm done with copy
offload...

-- 
Martin K. Petersen	Oracle Linux Engineering
