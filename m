From: jiangyiwen <jiangyiwen@huawei.com>
Subject: [dm-devel] [PATCH] dm-mpath: fix a tiny case which can cause an
 infinite loop
Date: Thu, 4 Feb 2016 10:08:02 +0800
Message-ID: <56B2B282.60400@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:24079 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbcBDCI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 21:08:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, xuejiufei@huawei.com, "Qijiang (Joseph, Euler)" <joseph.qi@huawei.com>, martin.petersen@oracle.com

When two processes submit WRTIE SAME bio simultaneously and
first IO return failed because of INVALID FIELD IN CDB, and
then second IO can enter into an infinite loop.
The problem can be described as follows:

process 1                              process 2
submit_bio(REQ_WRITE_SAME) and
wait io completion
                                       begin submit_bio(REQ_WRITE_SAME)
                                       -> blk_queue_bio()
                                         -> dm_request_fn()
                                           -> map_request()
                                             -> scsi_request_fn()
                                               -> blk_peek_request()
                                                 -> scsi_prep_fn()
In the moment, IO return and
sense_key with illegal_request,
sense_code with 0x24(INVALID FIELD IN CDB).
In this way it will set no_write_same = 1
in sd_done() and disable write same
                                       In sd_setup_write_same_cmnd()
                                       when find (no_write_same == 1)
                                       will return BLKPREP_KILL,
                                       and then in blk_peek_request()
                                       set error to EIO.
                                       However, in multipath_end_io()
                                       when find error is EIO it will
                                       fail path and retry even if
                                       device doesn't support WRITE SAME.

In this situation, when process of multipathd reinstate
path by using test_unit_ready periodically, it will cause
second WRITE SAME IO enters into an infinite loop and
loop never terminates.

In do_end_io(), when finding device doesn't support WRITE SAME and
request is WRITE SAME, return EOPNOTSUPP to applications.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: xuejiufei <xuejiufei@huawei.com>
---
 drivers/md/dm-mpath.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index cfa29f5..ad1602a 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1269,6 +1269,11 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (noretry_error(error))
 		return error;

+	/* do not retry in case of WRITE SAME not supporting */
+	if ((clone->cmd_flags & REQ_WRITE_SAME) &&
+			!clone->q->limits.max_write_same_sectors)
+		return -EOPNOTSUPP;
+
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);

-- 
1.8.4.3

