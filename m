From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: bio_integrity_verify() bug causing READ verify to be silently
 skipped
Date: Thu, 16 Jan 2014 21:20:47 -0800
Message-ID: <1389936047.5567.721.camel@haakon3.risingtidesystems.com>
References: <1387858826.5567.236.camel@haakon3.risingtidesystems.com>
	 <yq1sit4zv23.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40918 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaAQFTH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 00:19:07 -0500
In-Reply-To: <yq1sit4zv23.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, kmo@daterainc.com

On Fri, 2014-01-03 at 15:09 -0500, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> 
> nab> Given that bio_integrity_verify() is using bio_for_each_segment(),
> nab> the loop starts from the updated bio->bi_idx, and not a zero value,
> nab> which ends up skipping individual bio segment calls to
> nab> bi->verify_fn().
> 
> That's botched. Verify is meant to be called with the completed bytes
> before the index is tampered with.
> 
> 
> nab> The following patch changes bio_integrity_verify() to use
> nab> bio_for_each_segment_all() instead of bio_for_each_segment() to
> nab> ensure that the segment walk always starts from zero, regardless of
> nab> the current bio->bi_idx value after bio_advance().
> 
> That breaks partial completion, though. I'll take a look at Kent's
> changes...
> 

Ping..?  Any updates on a proper bugfix for this..?

--nab

