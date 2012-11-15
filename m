From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target/iblock: Fix double iblock_complete_cmd callback
 bug
Date: Thu, 15 Nov 2012 05:49:22 -0500
Message-ID: <20121115104922.GA28956@infradead.org>
References: <1352404739-22881-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352404739-22881-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 08, 2012 at 07:58:59PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch fixes a double completion bug where ibr->pending = 2 usage
> plus the extra callback to iblock_complete_cmd() invoked after bio
> submission in iblock_execute_rw() can interfere with the normal
> bio->bi_done() -> iblock_bio_done() -> iblock_complete_cmd() completion
> path, causing a double target_complete_cmd() call to occur.

How so exactly?  Please provide an explanation, and preferably a test
case.

> Also drop the bio_cnt >= IBLOCK_MAX_BIO_PER_TASK rolling call to
> iblock_submit_bios() to avoid the exception case where outstanding
> bios completing via iblock_bio_done() are not accounted for when
> returning returning non zero from iblock_execute_rw().

This will cause deadlocks when we can't allocate enough bios for
a too large request.
