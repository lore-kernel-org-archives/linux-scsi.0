From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for potential
 bio leak"
Date: Wed, 10 Jun 2009 11:45:14 +0300
Message-ID: <4A2F729A.1060101@panasas.com>
References: <4A2E645F.9090008@panasas.com>	<20090610080039B.fujita.tomonori@lab.ntt.co.jp>	<4A2F6B8E.8060700@panasas.com> <20090610172956C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:7548
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757669AbZFJIpO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 04:45:14 -0400
In-Reply-To: <20090610172956C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 06/10/2009 11:29 AM, FUJITA Tomonori wrote:
> On Wed, 10 Jun 2009 11:15:10 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
>> That is a violation of block API. All block drivers must call
>> blk_end_request().
> 
> Where can I find a documentation about it?
> 

No documentation

> If not, can you stop claiming a new rule?
> 

The fact that ALL block drivers call it for proper service of ALL ULDS,
does it not make it a rule?

> If you want to propose a new rule, you need to fix the existing users
> first.
> 

Sorry I missed them. I couldn't even imagine that there will be any.
Will send patches, sorry.

> 
>> If they do not, then they can not for example be
>> called from inside Kernel. They relay on special bsg behavior
>> that always uses map_user.
> 
> Of course, we send SMP requests only via BSG. SMP is the first reason
> why we invented BSG.
> 

Of course what? Show me the big fat comment that says:
  only use from BSG!!! other wise broken block driver.

> 
<snip>
> 
> You don't need SAS hardware to play with blk_rq_map_user() and
> blk_rq_unmap_user(). All you need to do is writing a module that play
> with these functions.
> 
> 
>> I do believe you that there is no leak, I just want to understand why?
>> And any way, all "BSG SMP" drivers must be fixed to call blk_end_request().
>> They can not be dependent on the specific ULD that calls them.

Boaz
