From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
 count
Date: Wed, 05 Mar 2008 14:46:44 +0200
Message-ID: <47CE9634.6040501@panasas.com>
References: <47CD7C05.1080707@gmail.com> <20080305041914V.tomof@acm.org> <47CDDC31.4070806@gmail.com> <20080305092619Y.fujita.tomonori@lab.ntt.co.jp> <47CE72EF.7050302@panasas.com> <20080305123317.GI6704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080305123317.GI6704@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Tejun Heo <htejun@gmail.com>, Mike Galbraith <efault@gmx.de>, James.Bottomley@HansenPartnership.com, tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 05 2008 at 14:33 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Mar 05 2008, Boaz Harrosh wrote:
>> On Wed, Mar 05 2008 at 2:26 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>> On Wed, 05 Mar 2008 08:33:05 +0900
>>> Tejun Heo <htejun@gmail.com> wrote:
>>>
>>>> FUJITA Tomonori wrote:
>>>>> Hmm, does SCSI mid-layer need to care about how many bytes the block
>>>>> layer allocates? I don't think that extra_len is NOT good_bytes.
>>>>>
>>>>> I think that the block layer had better take care about it (fix
>>>>> __end_that_request_first?).
>>>> Yeah, probably calling completion functions w/o bytes count is the right
>>>> thing to do but what I was talking about was what could break when the
>>>> semantics of rq->data_len changed.  If we keep rq->data_len() ==
>>>> sum(sg), we keep it business as usual for all the rest except for the
>>>> device application layer if we don't we do the reverse and SCSI midlayer
>>>> completion was a good example, I think.
>>> sglist is a low-level I/O representation for device drivers. SCSI
>>> midlayer should not care about sglist. We should not fix SCSI midlayer
>>> for rq->data_len != sum(sg) change (so I can't agree with your
>>> diagrams in another mail).
>>>
>>> When if we change a rule, we need to fix something.
>>>
>>> If we keep rq->data_len == sum(sg), we need to fix the device
>>> application layer. If we keep rq->data_len == the true data length, we
>>> need to fix the low-level drivers.
>>>
>>> Now I'm fine with the commit e97a294ef6938512b655b1abf17656cf2b26f709
>>> since we are in -rc stages. But I plan to send a patch to revert it
>>> and fix this issue in the block layer. I'd like to test it in -mm for
>>> a while.
>> No this commit is a serious bug, and the only fix is like you suggested
>> in __end_that_request_first. This is because it breaks that scsi-ml loop
>> where scsi_bufflen() can be less then blk_rq_bytes(). In that case this 
>> commit is a data corruption.
>>
>>> Only sglist stuff in SCSI midlayer is scsi_req_map_sg now. As you
>>> know, we really want to remove it.
>>>
>>>
>>>> Things going the other way is fine with me but I at least want to hear a
>>>> valid rationale.  Till now all I got is "because that's the true size"
>>>> which doesn't really make much sense to me.
>>> Most of users of request structure care about only the real data
>>> length, don't care about padding and drain length. Why do they bother
>>> to use a helper function to get the real data length?
>>> --
>> Submitted is the right fix to this problem, as pointed out by TOMO.
>> Please test it solves the CD burning problem.
>> (The patch includes the revert of commit e97a294e)
>> ---
>> From: Boaz Harrosh <bharrosh@panasas.com>
>> Date: Wed, 5 Mar 2008 12:07:12 +0200
>> Subject: [PATCH] blk: missing add of padded bytes to io completion byte count
>>
>> the commit e97a294ef6938512b655b1abf17656cf2b26f709 was very wrong. This is
>> because scsi-ml supports the ability to split a request into smaller chunks,
>> in which case scsi_bufflen() is smaller then request length. Then at completion
>> time the remainder can be issued as a new scsi command. In that case the above
>> commit is a data corruption.
> 
> We needed something for -rc4, so it had to be rushed a bit...
> 
>> Also in this fix all users of block layer are taken care of, and not only
>> scsi devices.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
>> ---
>>  block/blk-core.c    |    4 ++++
>>  drivers/scsi/scsi.c |    2 +-
>>  2 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 2a438a9..37fcccc 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1549,6 +1549,9 @@ static int __end_that_request_first(struct request *req, int error,
>>  			     nr_bytes >> 9, req->sector);
>>  	}
>>  
>> +	if (nr_bytes >= blk_rq_bytes(req))
>> +		nr_bytes += req->extra_len;
>> +
>>  	total_bytes = bio_nbytes = 0;
>>  	while ((bio = req->bio) != NULL) {
>>  		int nbytes;
>> @@ -1616,6 +1619,7 @@ static int __end_that_request_first(struct request *req, int error,
>>  	if (!req->bio)
>>  		return 0;
>>  
>> +	BUG_ON(total_bytes >= blk_rq_bytes(req));
> 
> Make that a WARN_ON() first please. It's indeed a bug, but it wont be
> critical and it's not fair killing everything since this padding stuff
> is so fresh and may still need a tweak or two.
> 
> I'd be fine with making it a BUG_ON() post 2.6.25.
> 
Updated, you are absolutely right, thanks.

Will you commit below patch for 2.6.25? I know that, at the time, I have 
seen this scsi-ml-loop in action on a sata drive here in the lab, on an 
x86_64 machine. The current solution will silently corrupt data, which 
is very hard to find.

Boaz
---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Wed, 5 Mar 2008 12:07:12 +0200
Subject: [PATCH] blk: missing add of padded bytes to io completion byte count

the commit e97a294ef6938512b655b1abf17656cf2b26f709 was very wrong. This is
because scsi-ml supports the ability to split a request into smaller chunks,
in which case scsi_bufflen() is smaller then request length. Then at completion
time the remainder can be issued as a new scsi command. In that case the above
commit is a data corruption.

Also in this fix all users of block layer are taken care of, and not only
scsi devices.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 block/blk-core.c    |    4 ++++
 drivers/scsi/scsi.c |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2a438a9..c82e68a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1549,6 +1549,9 @@ static int __end_that_request_first(struct request *req, int error,
 			     nr_bytes >> 9, req->sector);
 	}
 
+	if (nr_bytes >= blk_rq_bytes(req))
+		nr_bytes += req->extra_len;
+
 	total_bytes = bio_nbytes = 0;
 	while ((bio = req->bio) != NULL) {
 		int nbytes;
@@ -1616,6 +1619,7 @@ static int __end_that_request_first(struct request *req, int error,
 	if (!req->bio)
 		return 0;
 
+	WARN_ON(total_bytes >= blk_rq_bytes(req));
 	/*
 	 * if the request wasn't completed, update state
 	 */
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e5c6f6a..fecba05 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -757,7 +757,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
-	good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len;
+	good_bytes = scsi_bufflen(cmd);
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
-- 
1.5.3.3

