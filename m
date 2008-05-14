From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Wed, 14 May 2008 20:49:41 +0400
Message-ID: <482B1825.9050806@vlnb.net>
References: <200805021638.42972.bart.vanassche@gmail.com>	<20080502153306.GB7376@infradead.org>	<e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>	<20080502155525.GA16353@infradead.org>	<481DA2A4.10607@vlnb.net> <481DF822.7090905@panasas.com>	<4829C653.9050205@vlnb.net> <4829D14E.10909@panasas.com> <482B0C32.3010100@vlnb.net> <482B1582.7050709@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:47011 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887AbYENQto (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 12:49:44 -0400
In-Reply-To: <482B1582.7050709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, scst-devel@lists.sourceforge.net

Boaz Harrosh wrote:
> Vladislav Bolkhovitin wrote:
>> Boaz Harrosh wrote:
>>> Vladislav Bolkhovitin wrote:
>>>> Boaz Harrosh wrote:
>>>>> Vladislav Bolkhovitin wrote:
>>>>>> Christoph Hellwig wrote:
>>>>>>> On Fri, May 02, 2008 at 05:53:22PM +0200, Bart Van Assche wrote:
>>>>>>>> Regarding scsi_execute_async(): I didn't know that this API is on its
>>>>>>>> way out. What will it be replaced by, and when ?
>>>>>>> blk_execute_rq/blk_execute_rq_nowait plus the block level helpers built
>>>>>>> ontop to build requests.
>>>>>> scsi_execute_async() is already a nice and simple helper function on top 
>>>>>> blk_execute_rq_nowait(). What's the point then to remove it? Do you 
>>>>>> consider that exposing scsi_execute_async() internals to its users is 
>>>>>> better?
>>>>>>
>>>>> The problem with it is the use of sg list to *hack* in bio's. Which totally 
>>>>> ignores/duplicates block layer mechanisms. There is pending a large patchset
>>>>> that removes the use of scsi_execute_async from sg/sr and friends to use blk_map_*
>>>>> members and directly call blk_execute_*. The original patchset was written by
>>>>> Mike Christie but is now brought up to date by Tomo. It should be submitted soon I think.
>>>>> If you need good example of usage check out bsg.c it maps user-space data in all kind
>>>>> of combinations. If you have kernel space memory it is even simpler.
>>>> Thanks for pointing on it. But it still remained unclear for me what's 
>>>> the point in the scsi_execute_async() removal. Function 
>>>> scsi_req_map_sg() looks pretty simple and straightforward, so I don't 
>>>> see how the overall code can be simplified.
>>>>
>>> Well No, scsi_req_map_sg() is a complete hack. If you have user memory
>>> or kernel memory you better go through blk_map_* which will take care of
>>> device masks, alignment and all, where here the ULD does that. So you have
>>> 2 places of waisted code both at ULD to build the SG right, and here to
>>> translate SG to BIO. Where at block layer you have one function call.
>>> Try it out you see that not using scsi_execute_async() is much more simple 
>>> at ULD then using it.
>>> If you do mmap then Tomo has code for block layer to support that.
>> Seems, I'm starting understanding you. You mean that all ULDs (User 
>> Level Devices, i.e. sg, st, etc.) deal with user supplied buffers, i.e. 
>> pointers to virtually continuous memory, which at the moment it has to 
>> convert to SG vector, which then will be translated to BIOs for the 
>> corresponding LDD by scsi_execute_async() (and then back to SG vector on 
>> the queuecommand() time). So, it will be simpler to supply that buffer 
>> pointer directly to block functions. Correct?
>>
>> But the problem is that in SCST in each data transfer 2 LDDs 
>> participate: one target and one backstorage (initiator). And the target 
>> LDD deals with SG vectors only. So, SCST never deals with buffers, it 
>> always deals with SG vectors and pass them between target LDDs and 
>> backstorage as necessary.
> 
> Where is that SG coming from? is it from Network stack? or is it an
> SG prepared by scsi-ml with call to blk_rq_map_sg()?

It's prepared by SCST core. A request comes from target LDD and reply 
finally sent there. Everything goes in the kernel mode only. It is 
simple pass-through, exactly as it sounds.

>> Thus, looks like for SCST in the pass-through mode there is no 
>> alternative to scsi_execute_async().
>>
> 
> Tomo what do you think is it logical to add a blk function that will
> accept an SG list and map it to a request. Like, for example, an SG 
> from Network? opposite of what blk_rq_map_sg does.
> 
>> Thanks,
>> Vlad
>>
> 
> Boaz
> 

