From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] megaraid_sas: Enable shared host tag map
Date: Tue, 25 Nov 2014 17:34:53 +0100
Message-ID: <20141125163453.GA2721@lst.de>
References: <1416843235-35947-1-git-send-email-hare@suse.de> <20141124153558.GA27364@lst.de> <547353F2.1040005@suse.de> <20141125143140.GA32570@lst.de> <cd290ec39c368c11217bcb4510c9ac71@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39747 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaKYQe6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 11:34:58 -0500
Content-Disposition: inline
In-Reply-To: <cd290ec39c368c11217bcb4510c9ac71@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org, Webb Scales <webbnh@hp.com>, Don Brace <don.brace@pmcs.com>, Jens Axboe <axboe@kernel.dk>

On Tue, Nov 25, 2014 at 08:33:28PM +0530, Kashyap Desai wrote:
> Just trying to understand your above comment. I see host template has new
> field called
> "reserved_tags" which is normally used by mid layer to reserved block tag
> pool for driver's internal use.
> What if driver is OK to manage internal pool without any blk tag
> dependency and do not expose actual max can queue of what FW can support.
> For example, in megaraid_sas driver FW expose max_fw_cmd = 1024 and driver
> keep some reserve (let's say 24 commands for internal use) and it just
> expose 1000 command for blk tags.  This will work for blk-mq and legacy
> blk driver. Let driver to manage whatever internal reserved it kept for
> and do not add any dependency with blk tag from above layer for those
> reserved pool.

The driver can of coure always just manage its internal tags, but that
means we need to duplicate a tag allocator in every driver.  In short
it works ok for now, but I'd rather solve the problem in a single place.
