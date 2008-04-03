From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/3 ver2] block layer extended-cdb support
Date: Thu, 03 Apr 2008 21:32:06 +0300
Message-ID: <47F522A6.3080806@panasas.com>
References: <47E92672.1040208@panasas.com>  <47E92934.6040903@panasas.com> <1207240982.3048.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5282 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753162AbYDCSdL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 14:33:11 -0400
In-Reply-To: <1207240982.3048.45.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

James Bottomley wrote:
> On Tue, 2008-03-25 at 18:32 +0200, Boaz Harrosh wrote:
>> - add varlen_cdb and varlen_cdb_len to hold a large user cdb
>>   if needed. They start as empty. Allocation of buffer must
>>   be done by user and held until request execution is done.
>> - Since there can be either a fix_length command up to 16 bytes
>>   or a variable_length, larger then 16 bytes, commands but never
>>   both, we hold the two types in a union to save space. The
>>   presence of varlen_cdb_len and cmd_len==0 signals a varlen_cdb
>>   mode.
>> - Please use added rq_{set,get}_varlen_cdb() to set every thing
>>   up in a way that will not confuse drivers that do not support
>>   varlen_cdb's.
>> - Note that this patch does not add any size to struct request
>>   since the unsigned cmd_len is split here to 2 ushorts, which
>>   is more then enough.
> 
> My first observation is that the block stuff all looks a bit
> misnamed ... it's not about variable length commands it's about getting
> block to accept packet commands larger than BLK_MAX_CDB, be they SCSI
> OSD commands or ATA taskfiles.
> 
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  block/blk-core.c       |    2 ++
>>  include/linux/blkdev.h |   27 +++++++++++++++++++++++++--
>>  2 files changed, 27 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 2a438a9..70d32f7 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -141,6 +141,8 @@ void rq_init(struct request_queue *q, struct request *rq)
>>  	rq->end_io = NULL;
>>  	rq->end_io_data = NULL;
>>  	rq->next_rq = NULL;
>> +	rq->varlen_cdb_len = 0;
>> +	rq->varlen_cdb = NULL;
> 
> possibly s/varlen/large/
> 
>>  }
>>  
>>  static void req_bio_endio(struct request *rq, struct bio *bio,
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 6f79d40..f829571 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -213,8 +213,15 @@ struct request {
>>  	/*
>>  	 * when request is used as a packet command carrier
>>  	 */
>> -	unsigned int cmd_len;
>> -	unsigned char cmd[BLK_MAX_CDB];
>> +	unsigned short cmd_len;
>> +	unsigned short varlen_cdb_len;  /* length of varlen_cdb buffer */
>> +	union {
>> +		unsigned char cmd[BLK_MAX_CDB];
>> +		unsigned char *varlen_cdb;/* an optional variable-length cdb.
>> +	                                   * points to a user buffer that must
>> +	                                   * be valid until end of request
>> +	                                   */
> 
> again s/varlen/large/
> 
>> +	};
>>  
>>  	unsigned int data_len;
>>  	unsigned int extra_len;	/* length of alignment and padding */
>> @@ -484,6 +491,22 @@ enum {
>>  #define rq_is_sync(rq)		(rq_data_dir((rq)) == READ || (rq)->cmd_flags & REQ_RW_SYNC)
>>  #define rq_is_meta(rq)		((rq)->cmd_flags & REQ_RW_META)
>>  
>> +static inline void rq_set_varlen_cdb(struct request *rq, u8 *cdb, short cdb_len)
>> +{
>> +	rq->cmd_len = 0; /* Make sure legacy drivers don't get confused */
>> +	rq->varlen_cdb_len = cdb_len;
>> +	rq->varlen_cdb = cdb;
>> +}
>> +
>> +/* If ! a varlen_cdb than return NULL */
>> +static inline u8 *rq_get_varlen_cdb(struct request *rq)
>> +{
>> +	if (!rq->cmd_len && rq->varlen_cdb_len)
>> +		return rq->varlen_cdb;
>> +	else
>> +		return NULL;
>> +}
> 
> These accessors look wrong ... I think what we want is rq_get_cdb and
> rq_set_cdb that handles both <= BLK_MAX_CDB by simply a memcpy and >
> BLK_MAX_CDB by setting up the large_cdb pointer.  That way we can
> accessorize the whole lot and the drivers don't have to care about what
> BLK_MAX_CDB is set to (it simply becomes an internal convenience of
> block ... and possibly allows us to eliminate the request carries
> command data entirely).
> 
>>  static inline int blk_queue_full(struct request_queue *q, int rw)
>>  {
>>  	if (rw == READ)
> 
> James
> 
> 

Thanks James for your review.

With taking Benny's comments into account also, perhaps this is what you meant
(untested, for review, third patch is missing still)

Boaz
---
>From 1da591a5ef9697f37604721bfe437a2609bb8217 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Wed, 31 Oct 2007 14:56:09 +0200
Subject: [PATCH] block layer extended-cdb support

  - add ext_cdb and ext_cdb_len to hold a large external cdb
    if needed. They start as empty. Allocation of buffer must
    be done by user and held until request execution is done.
  - Since there can be either a fix_length command up to 16 bytes
    or an external extended command but never both, we hold the two
    types in a union to save space. The presence of ext_cdb_len!=0
    and cmd_len==0 signals an ext_cdb mode.
  - Use new rq_set_cdb() to set everything up in a way that will
    not confuse drivers that do not support extended cdb's.
  - Use rq_get_cdb()/rq_get_cdb_len() to retrieve command and length
    in a generic way.
  - Once all drivers and users convert to the new accessors the cmd[]
    16 bytes buffer can be discarded.
  - Note that this patch does not add any size to struct request
    since the unsigned cmd_len is split here to 2 ushorts, which
    is more then enough.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c       |    2 ++
 include/linux/blkdev.h |   41 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2a438a9..cc9a790 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -141,6 +141,8 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
+	rq->ext_cdb_len = 0;
+	rq->ext_cdb = NULL;
 }
 
 static void req_bio_endio(struct request *rq, struct bio *bio,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6f79d40..2f87c9d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -213,8 +213,15 @@ struct request {
 	/*
 	 * when request is used as a packet command carrier
 	 */
-	unsigned int cmd_len;
-	unsigned char cmd[BLK_MAX_CDB];
+	unsigned short cmd_len;
+	unsigned short ext_cdb_len;  /* length of ext_cdb buffer */
+	union {
+		unsigned char cmd[BLK_MAX_CDB];
+		unsigned char *ext_cdb;/* an optional extended cdb.
+	                                   * points to a user buffer that must
+	                                   * be valid until end of request
+	                                   */
+	};
 
 	unsigned int data_len;
 	unsigned int extra_len;	/* length of alignment and padding */
@@ -484,6 +491,36 @@ enum {
 #define rq_is_sync(rq)		(rq_data_dir((rq)) == READ || (rq)->cmd_flags & REQ_RW_SYNC)
 #define rq_is_meta(rq)		((rq)->cmd_flags & REQ_RW_META)
 
+static inline void rq_set_cdb(struct request *rq, u8 *cdb, short cdb_len)
+{
+	if (cdb_len <= BLK_MAX_CDB) {
+		memcpy(rq->cmd, cdb, cdb_len);
+		rq->cmd_len = cdb_len;
+		rq->ext_cdb_len = 0;
+	}
+	else {
+		rq->cmd_len = 0; /*Make sure legacy drivers don't get confused*/
+		rq->ext_cdb_len = cdb_len;
+		rq->ext_cdb = cdb;
+	}
+}
+
+static inline u8 *rq_get_cdb(struct request *rq)
+{
+	if (!rq->cmd_len && rq->ext_cdb_len)
+		return rq->ext_cdb;
+	else
+		return rq->cmd;
+}
+
+static inline unsigned short rq_get_cdb_len(struct request *rq)
+{
+	if (!rq->cmd_len && rq->ext_cdb_len)
+		return rq->ext_cdb_len;
+	else
+		return rq->cmd_len;
+}
+
 static inline int blk_queue_full(struct request_queue *q, int rw)
 {
 	if (rw == READ)
-- 
1.5.3.3

