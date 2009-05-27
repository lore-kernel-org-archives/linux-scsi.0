From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
Date: Wed, 27 May 2009 12:11:11 +0300
Message-ID: <4A1D03AF.4010102@panasas.com>
References: <4A1C1331.8060304@panasas.com>	<20090527103637W.fujita.tomonori@lab.ntt.co.jp>	<4A1CF1C1.2000607@panasas.com> <20090527172616R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090527172616R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, rdreier@cisco.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/27/2009 11:26 AM, FUJITA Tomonori wrote:
> On Wed, 27 May 2009 10:54:41 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On 05/27/2009 04:36 AM, FUJITA Tomonori wrote:
>>> On Tue, 26 May 2009 19:05:05 +0300
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>
>>>> On 05/26/2009 06:31 PM, FUJITA Tomonori wrote:
>>>>> Can we just fix some drivers not to do the DMA with the sense buffer in
>>>>> scsi_cmnd? IIRC, there are only five or six drivers that do such.
>>>> This is not so.
>>>> All drivers that go through scsi_eh_prep_cmnd() will eventually DMA through
>>>> the regular read path. Including all the drivers that do nothing and let
>>>> scsi-ml do the REQUEST_SENSE
>>>>
>>>> Actually I have exact numbers, from the last time I did all that
>>> Hmm, we discussed this before, I think.
>>>
>> Sure we did I sent these patches. to summarize, 3 types of drivers:
>> 1. Only memcpy into sense_buffer				- 60%
>> 2. Use scsi_eh_prep_cmnd and DMA read into sense.
>> 2.1 Do nothing and scsi-ml does scsi_eh_prep_cmnd		- 30%
>> 3. Prepare DMA descriptors for sense_buffer before execution	- 10%
>>
>>> scsi-ml uses scsi_eh_prep_cmnd only via scsi_send_eh_cmnd(). There are
>>> some users of scsi_send_eh_cmnd in scsi-ml but only scsi_request_sense
>>> does the DMA in the sense_buffer of scsi_cmnd.
>>>
>> Also drivers use scsi_eh_prep_cmnd at interrupt time and proceed to
>> DMA into the sense_buffer.
>>
>>> Only scsi_error_handler() uses scsi_request_sense() and
>>> scsi_send_eh_cmnd() works synchronously. So scsi-ml can easily avoid
>>> the the DMA in the sense_buffer of scsi_cmnd if we have one sense
>>> buffer per scsi_host.
>> Not so. As James explained then, once you have a CHECK_CONDITION return, the
>> Q-per-host is frozen, yes. But as soon as you send the REQUEST_SENSE the 
>> target Q is unfrozen again and all in-flight commands can error, much before
>> the REQUEST_SENSE returns.
> 
> Hmm, I'm not sure what you mean.
> 
> Why is 'all in-flight commands can error' a problem? The sense_buffer
> per host is used by only scsi_eh kernel thread.

I agree, then the current situation has a problem.

Target has command A && B in Q.
- A returns CHECK_CONDITION, scsi_eh thread kicks in, sends a REQUEST_SENSE.
- Immediately command B returns with CHECK_CONDITION, Target Q is frozen again.
- message is queued for scsi_eh thread but that one is stuck waiting for the first
  REQUEST_SENSE to return, and the second-REQUEST_SENSE is never sent, target Q is
  frozen forever.

I guess all the drivers that support target queueing do not depend on scsi_eh
thread to issue the REQUEST_SENSE command. As I said, there are very few drivers
that do nothing and let scsi_eh take care of REQUEST_SENSE.

This will not however solve these drivers that might need many
concurrent sense buffers.

Boaz
