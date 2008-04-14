From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/3 ver3] block layer extended-cdb support
Date: Mon, 14 Apr 2008 12:49:49 +0300
Message-ID: <480328BD.7050206@panasas.com>
References: <47F89948.9060503@panasas.com>	<20080412145152C.tomof@acm.org>	<4801CEAE.6030309@panasas.com> <20080414010112W.tomof@acm.org> <480239D2.3040206@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:30526 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751536AbYDNJuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2008 05:50:24 -0400
In-Reply-To: <480239D2.3040206@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

On Sun, Apr 13 2008 at 19:50 +0300, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Sun, Apr 13 2008 at 19:17 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>> On Sun, 13 Apr 2008 12:13:18 +0300
>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>> That's a ugly hack for me.
>>
>> Why do we have two separate systems to represent the command length?
>> If the command length is smaller than 16 bytes, we use cmd_len. If the
>> length is larger than 16 bytes, we use varlen_cdb_len?
>>
>> For me, as Jens proposed, having only cmd_len is the right way.
>>
>> And 'cdb' name is not appropriate for the block layer, I think.
>>
>> I agreed that changing the block layer and the scsi midlayer gradually
>> is a safe option. Shortly, I'll send patches to clean up the hack on
>> the top of your patchset.
>> --
> 
> Sorry TOMO, I was sending the ver2 patchset and only saw your mail in
> the middle, so anyway you have the latest I have now.
> 
> If it's ok with you I will squash your patches onto mine and add your
> sign-off-by. There is no use putting code in the tree that will be changed
> immediately after.
> 
> Please note that I'm a bit afraid to put code that has both length as one
> if you are more confident then me, I will take your word for it.
> 
> Thanks for helping out, as you can see I did it very safe, but with your
> help maybe it can finally go in. Thanks++
> 
> Boaz
> --
Maybe you mean something like below. I changed cdb => cmd and I use one
cmd_len. I think that "cdb" was a good name. Note that we have BLK_MAX_CDB
right there next to it. But if you don't like it then I don't mind to
change the name, I think it was James idea.

But please note!!!
I think having one cmd_len is DANGEROUS. And it forces a full code audit
to be sure, has with my approach we are much more safe. There, I said it.

---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Wed, 31 Oct 2007 14:56:09 +0200
Subject: [PATCH] block layer extended-command support

  - add ext_cmd to hold a large external cdb if needed. Allocation
    of buffer must be done by user and held until request execution
    is done.
  - Since there can be either a fix_length command up to 16 bytes
    or an external extended command but never both, we hold the two
    types in a union to save space. cmd_len > BLK_MAX_CDB signals
    an ext_cmd mode.
  - Use new rq_set_cmd() to set everything properly.
  - Use rq_get_cmd() to retrieve the command in a generic way.
  - Once all drivers and users convert to the new accessors the cmd[]
    16 bytes buffer can be discarded.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c       |    2 ++
 include/linux/blkdev.h |   25 ++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2a438a9..a2bf07f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -141,6 +141,8 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
+	rq->cmd_len = 0;
+	rq->ext_cmd = NULL;
 }
 
 static void req_bio_endio(struct request *rq, struct bio *bio,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6f79d40..0c4f5f5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -214,7 +214,13 @@ struct request {
 	 * when request is used as a packet command carrier
 	 */
 	unsigned int cmd_len;
-	unsigned char cmd[BLK_MAX_CDB];
+	union {
+		unsigned char cmd[BLK_MAX_CDB];
+		unsigned char *ext_cmd;/* an optional extended cdb.
+	                                   * points to a user buffer that must
+	                                   * be valid until end of request
+	                                   */
+	};
 
 	unsigned int data_len;
 	unsigned int extra_len;	/* length of alignment and padding */
@@ -484,6 +490,23 @@ enum {
 #define rq_is_sync(rq)		(rq_data_dir((rq)) == READ || (rq)->cmd_flags & REQ_RW_SYNC)
 #define rq_is_meta(rq)		((rq)->cmd_flags & REQ_RW_META)
 
+static inline void rq_set_cmd(struct request *rq, u8 *cmd, short cmd_len)
+{
+	rq->cmd_len = cmd_len;
+	if (cmd_len <= BLK_MAX_CDB)
+		memcpy(rq->cmd, cmd, cmd_len);
+	else
+		rq->ext_cmd = cmd;
+}
+
+static inline u8 *rq_get_cmd(struct request *rq)
+{
+	if (rq->cmd_len <= BLK_MAX_CDB)
+		return rq->cmd;
+	else
+		return rq->ext_cmd;
+}
+
 static inline int blk_queue_full(struct request_queue *q, int rw)
 {
 	if (rw == READ)
-- 
1.5.3.3

 



