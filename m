From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: bio_integrity_verify() bug causing READ verify to be silently skipped
Date: Fri, 03 Jan 2014 15:09:40 -0500
Message-ID: <yq1sit4zv23.fsf@sermon.lab.mkp.net>
References: <1387858826.5567.236.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1387858826.5567.236.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Mon, 23 Dec 2013 20:20:26 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

nab> Given that bio_integrity_verify() is using bio_for_each_segment(),
nab> the loop starts from the updated bio->bi_idx, and not a zero value,
nab> which ends up skipping individual bio segment calls to
nab> bi->verify_fn().

That's botched. Verify is meant to be called with the completed bytes
before the index is tampered with.


nab> The following patch changes bio_integrity_verify() to use
nab> bio_for_each_segment_all() instead of bio_for_each_segment() to
nab> ensure that the segment walk always starts from zero, regardless of
nab> the current bio->bi_idx value after bio_advance().

That breaks partial completion, though. I'll take a look at Kent's
changes...

-- 
Martin K. Petersen	Oracle Linux Engineering
