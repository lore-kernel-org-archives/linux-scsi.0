From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with	blk_rq_map_kern_sgl()
Date: Wed, 01 Apr 2009 20:17:05 +0300
Message-ID: <49D3A191.2040000@panasas.com>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>	 <1238593472-30360-15-git-send-email-tj@kernel.org>	 <49D39DBC.3000206@panasas.com> <1238605538.3318.63.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:31800 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752705AbZDARTK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 13:19:10 -0400
In-Reply-To: <1238605538.3318.63.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On 04/01/2009 08:05 PM, James Bottomley wrote:
> On Wed, 2009-04-01 at 20:00 +0300, Boaz Harrosh wrote:
>> On 04/01/2009 04:44 PM, Tejun Heo wrote:
>>> Impact: hack removal
>>>
>>> SCSI needs to map sgl into rq for kernel PC requests; however, block
>>> API didn't have such feature so it used its own rq mapping function
>>> which hooked into block/bio internals and is generally considered an
>>> ugly hack.  The private function may also produce requests which are
>>> bigger than queue per-rq limits.
>>>
>>> Block blk_rq_map_kern_sgl().  Kill the private implementation and use
>>> it.
>>>
>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> James, TOMO
>>
>> what happened to Tomo's patches that removes all this after fixing up
>> all users (sg.c)?
>>
>> I thought that was agreed and done? What is left to do for that to go
>> in.
> 
> They couldn't go in because they would break libosd.  You were going to
> send patches to fix libosd so it no longer relied on the exported
> function ... did that happen and I missed it?
> 

That's not related. I'm asking about the scsi ULD patches and finally the
patch to scsi_lib.c. libosd only conflicts with the very last patch to block
layer. I don't see how that prevents the cleanups to scsi?

And BTW, I did send RFC patches that removes usage of blk_rq_append_bio() and
did not receive any comments

> James
> 
> 

Boaz
