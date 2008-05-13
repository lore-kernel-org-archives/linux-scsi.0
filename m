From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Tue, 13 May 2008 20:35:10 +0300
Message-ID: <4829D14E.10909@panasas.com>
References: <200805021638.42972.bart.vanassche@gmail.com> <20080502153306.GB7376@infradead.org> <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com> <20080502155525.GA16353@infradead.org> <481DA2A4.10607@vlnb.net> <481DF822.7090905@panasas.com> <4829C653.9050205@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11433 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751228AbYEMRgn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 13:36:43 -0400
In-Reply-To: <4829C653.9050205@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Vladislav Bolkhovitin wrote:
> Boaz Harrosh wrote:
>> Vladislav Bolkhovitin wrote:
>>> Christoph Hellwig wrote:
>>>> On Fri, May 02, 2008 at 05:53:22PM +0200, Bart Van Assche wrote:
>>>>> Regarding scsi_execute_async(): I didn't know that this API is on its
>>>>> way out. What will it be replaced by, and when ?
>>>> blk_execute_rq/blk_execute_rq_nowait plus the block level helpers built
>>>> ontop to build requests.
>>> scsi_execute_async() is already a nice and simple helper function on top 
>>> blk_execute_rq_nowait(). What's the point then to remove it? Do you 
>>> consider that exposing scsi_execute_async() internals to its users is 
>>> better?
>>>
>> The problem with it is the use of sg list to *hack* in bio's. Which totally 
>> ignores/duplicates block layer mechanisms. There is pending a large patchset
>> that removes the use of scsi_execute_async from sg/sr and friends to use blk_map_*
>> members and directly call blk_execute_*. The original patchset was written by
>> Mike Christie but is now brought up to date by Tomo. It should be submitted soon I think.
>> If you need good example of usage check out bsg.c it maps user-space data in all kind
>> of combinations. If you have kernel space memory it is even simpler.
> 
> Thanks for pointing on it. But it still remained unclear for me what's 
> the point in the scsi_execute_async() removal. Function 
> scsi_req_map_sg() looks pretty simple and straightforward, so I don't 
> see how the overall code can be simplified.
> 

Well No, scsi_req_map_sg() is a complete hack. If you have user memory
or kernel memory you better go through blk_map_* which will take care of
device masks, alignment and all, where here the ULD does that. So you have
2 places of waisted code both at ULD to build the SG right, and here to
translate SG to BIO. Where at block layer you have one function call.
Try it out you see that not using scsi_execute_async() is much more simple 
at ULD then using it.
If you do mmap then Tomo has code for block layer to support that.

>>>>> Bart.
>>>> ---end quoted text---
>>>>
>> If you need any help, please feel free to ask.
>>

Boaz

