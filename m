From: Greg Stark <gsstark@mit.edu>
Subject: Re: [PATCH] scsi/sata write barrier support
Date: 01 Mar 2005 10:55:27 -0500
Message-ID: <87r7izz7gw.fsf@stark.xeocode.com>
References: <20050127120244.GO2751@suse.de> <87acpxurwf.fsf@stark.xeocode.com>
	<20050222071340.GC2835@suse.de> <874qg4v81q.fsf@stark.xeocode.com>
	<20050301084741.GD12295@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from stark.xeocode.com ([216.58.44.227]:49545 "EHLO
	stark.xeocode.com") by vger.kernel.org with ESMTP id S261956AbVCAPzk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 10:55:40 -0500
In-Reply-To: <20050301084741.GD12295@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Greg Stark <gsstark@mit.edu>, Linux Kernel <linux-kernel@vger.kernel.org>, Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

Jens Axboe <axboe@suse.de> writes:

> > What about a non-journaled fs, or at least a meta-data-only-journaled fs?
> > Journaled FS's don't mix well with transaction based databases since they're
> > basically doing their own journaling anyways.
> 
> Only works on ext3 and reiserfs currently.

Does it work in resierfs with data=writeback or ext3 with tune2fs's
journal_data_writeback?

What I'm wondering is whether it only kicks in when the journal gets
synchronized or whether it kicks in whenever you call fsync even if no
journaling is involved.

Writeback mode isn't really necessary, Postgres makes every effort to use
fdatasync or equivalent so no metadata changes are really necessary. So the
question is also, do the filesystems initiate a cache flush even if no
metadata changes are being synchronized?

-- 
greg

