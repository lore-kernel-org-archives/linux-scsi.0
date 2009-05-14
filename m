From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/3] block: completion related functions cleanup
Date: Thu, 14 May 2009 16:54:31 +0300
Message-ID: <4A0C2297.5040001@panasas.com>
References: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:6045 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753392AbZENNyf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2009 09:54:35 -0400
In-Reply-To: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, Tejun Heo <tj@kernel.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 05/11/2009 11:56 AM, FUJITA Tomonori wrote:
> This is a minor cleanup on the completion releated functions. It is on
> the top of Tejun's unify request processing model patchset.
> 
> 

Hi Tomo, Jens, Tejun.

A small left-over from this grate cleanup work. I think it was Tejun's
patch that left this unused.

(Should go through block tree)

Here:
---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Thu, 14 May 2009 16:46:03 +0300
Subject: [PATCH] scsi_lib: remove unused variable assignment

The last request completion cleanup in scsi_lib left an unused
this_count assignment in scsi_io_completion().
(It was used before in a code segment that now uses blk_end_request_all())

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e410d66..f8600d6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -789,7 +789,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 */
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
-	this_count = blk_rq_bytes(req);
 
 	error = -EIO;
 
-- 
1.6.2.1
