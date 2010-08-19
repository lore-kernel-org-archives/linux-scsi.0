From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC PATCHSET block#for-2.6.36-post] block: convert to
 REQ_FLUSH/FUA
Date: Fri, 20 Aug 2010 00:56:37 +0900
Message-ID: <20100820005446D.fujita.tomonori@lab.ntt.co.jp>
References: <1282141587.3035.6.camel@mulgrave.site>
	<20100820003348C.fujita.tomonori@lab.ntt.co.jp>
	<20100819154133.GA21155@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100819154133.GA21155@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: hch@lst.de
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, tj@kernel.org, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Thu, 19 Aug 2010 17:41:33 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Aug 20, 2010 at 12:37:14AM +0900, FUJITA Tomonori wrote:
> > I think that I reverted it with the discard and flush conversion. No
> > idea why the code exists in the current git.
> 
> Given that this:
> 
> > -		if (scmd->request->cmd_flags & REQ_HARDBARRIER)
> 
> line is attributed to a merge commit by Jens in Linus' current git
> tree it might have been a merge error of some sorts.

Yeah, looks like so.

Anyway, we can remove the workaround safely now.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 20 Aug 2010 00:47:45 +0900
Subject: [PATCH] fix the merge error of UNIT_ATTENTION workaround removal

The commit e96f6abe02fc3320d669985443e8c68ff8e83294 reverted the
commit 77a4229719e511a0d38d9c355317ae1469adeb54, UNIT_ATTENTION
workaround for barriers with the barrier and discard FS request
conversion. But due to a merge error, the workaround still exists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_error.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1de30eb..5743196 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -320,20 +320,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 				    "changed. The Linux SCSI layer does not "
 				    "automatically adjust these parameters.\n");
 
-		if (scmd->request->cmd_flags & REQ_HARDBARRIER)
-			/*
-			 * barrier requests should always retry on UA
-			 * otherwise block will get a spurious error
-			 */
-			return NEEDS_RETRY;
-		else
-			/*
-			 * for normal (non barrier) commands, pass the
-			 * UA upwards for a determination in the
-			 * completion functions
-			 */
-			return SUCCESS;
-
+		return NEEDS_RETRY;
 		/* these three are not supported */
 	case COPY_ABORTED:
 	case VOLUME_OVERFLOW:
-- 
1.6.5

