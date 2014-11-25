From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] megaraid_sas: Enable shared host tag map
Date: Tue, 25 Nov 2014 15:31:40 +0100
Message-ID: <20141125143140.GA32570@lst.de>
References: <1416843235-35947-1-git-send-email-hare@suse.de> <20141124153558.GA27364@lst.de> <547353F2.1040005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39446 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaKYObo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 09:31:44 -0500
Content-Disposition: inline
In-Reply-To: <547353F2.1040005@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, linux-scsi@vger.kernel.org, Webb Scales <webbnh@hp.com>, Don Brace <don.brace@pmcs.com>, Jens Axboe <axboe@kernel.dk>

On Mon, Nov 24, 2014 at 04:51:14PM +0100, Hannes Reinecke wrote:
> It is useful as is, as we'll be getting prefixed logging output :-)

Use the blk-mq code path if you care :)

> Which I didn't do yet as the driver is using a larger tag map than
> that one announced to the block layer.
> This is to facilitate internal command submission, which should
> always work independent on any tag starvation issues from the
> upper layers.

This is an "issue" for a lot of drivers.  blk-mq provides a reserved_tags
pool for that, which reserves a number of tags for internal use, those
must be allocated using blk_mq_alloc_request with the reserved argument
set to true.

The lockless hpsa patches expose this to SCSI, which I'm generally
fine with, but we need to find a way to transparently make this work
for the old code path, too.  This might be as simple as embedding a
second blk_queue_tag structure into the Scsi_Host, adding a constant
prefix to the tag and providing some wrappes in scsi that allow
allocating a struct request (or rather scsi_cmnd) for internal use.

