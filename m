From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3 ver2] block layer extended-cdb support
Date: Sun, 06 Apr 2008 14:05:32 +0300
Message-ID: <47F8AE7C.4040901@panasas.com>
References: <47E92672.1040208@panasas.com> <47E92934.6040903@panasas.com> <1207240982.3048.45.camel@localhost.localdomain> <47F522A6.3080806@panasas.com> <20080404114614.GJ29686@kernel.dk> <47F89948.9060503@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:41604 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYDFLHN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Apr 2008 07:07:13 -0400
In-Reply-To: <47F89948.9060503@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Sun, Apr 06 2008 at 12:35 +0300, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Fri, Apr 04 2008 at 14:46 +0300, Jens Axboe <jens.axboe@oracle.com> wrote:
>> On Thu, Apr 03 2008, Boaz Harrosh wrote:
>>>  static void req_bio_endio(struct request *rq, struct bio *bio,
>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>>> index 6f79d40..2f87c9d 100644
>>> --- a/include/linux/blkdev.h
>>> +++ b/include/linux/blkdev.h
>>> @@ -213,8 +213,15 @@ struct request {
>>>  	/*
>>>  	 * when request is used as a packet command carrier
>>>  	 */
>>> -	unsigned int cmd_len;
>>> -	unsigned char cmd[BLK_MAX_CDB];
>>> +	unsigned short cmd_len;
>>> +	unsigned short ext_cdb_len;  /* length of ext_cdb buffer */
>>> +	union {
>>> +		unsigned char cmd[BLK_MAX_CDB];
>>> +		unsigned char *ext_cdb;/* an optional extended cdb.
>>> +	                                   * points to a user buffer that must
>>> +	                                   * be valid until end of request
>>> +	                                   */
>>> +	};
>> Why not just something ala
>>
>>         unsigned short cmd_len;
>>         unsigned char __cmd[BLK_MAX_CDB];
>>         unsigned char *cmd;
>>
>> and then have rq_init() do
>>
>>         rq->cmd = rq->__cmd;
>>
>> and just have a function for setting up a larger ->cmd and adjusting
>> ->cmd_len in the process?
>>
>> Then rq_set_cdb() would be
>>
>> static inline void rq_set_cdb(struct request *rq, u8 *cdb, short cdb_len)
>> {
>>         rq->cmd = cdb;
>>         rq->cmd_len = cdb_len;
>> }
>>
>> and rq_get_cdb() plus rq_get_cdb_len() could just go away.
>>
> 
> Because this way it is dangerous if large commands are issued to legacy
> drivers. In scsi-land we have .cmd_len at host template that will govern if
> we are allow to issue larger commands to the driver. In block devices we do
> not have such a facility, and the danger is if such commands are issued through
> bsg or other means, even by malicious code. What you say is the ideal and it
> is what I've done for scsi, but for block devices we can not do that yet.
> With the way I did it here, Legacy drivers will see zero length command and
> will do the right thing, from what I've seen.
> 
> Boaz
>

I forgot to say.
With the proposed way, we are saving the space of the pointer. And the final outcome
of eventually eliminating the buffer, is the same.

Let me summarize.
- support extended, arbitrary large commands by introducing the notion that cdb space
  can be pointed to not carried.
- Eventually transition all block drivers and users to the new system, for all commands
  not just large ones.
- Do so without introducing any extra cost or instability, but also let the transition
  be done gradually, and not at once, (hence more stability).

I have thought about that long and hard, my first patch of the matter was 18 month ago.
I still think this is the smoothest way to go, and not that ugly, really.

Boaz
