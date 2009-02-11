From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Wed, 11 Feb 2009 18:55:00 +0200
Message-ID: <499302E4.9010309@panasas.com>
References: <1227043498.4949.21.camel@ogier>	<1234365225.24194.3.camel@ogier>	<4992F98B.1060401@panasas.com> <20090212013215L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:3742 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756535AbZBKQzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 11:55:09 -0500
In-Reply-To: <20090212013215L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com, sven@linux.vnet.ibm.com, futjita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> On Wed, 11 Feb 2009 18:15:07 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> James Smart wrote:
>>> Trying to kick-start this again...  
>>> I've updated the prior RFC with the comments from Seokmann,
>>> SvenFujita, and Boaz. I would still like review on the
>>> blk_xxx completion calls in the std and error paths.
>>>
>>> It currently expects that blk_end_request() has been updated
>>> by Fujita's patch to incorporate blk_end_bidi_request()
>>> functionality :
>>> http://marc.info/?l-linux-scsi&m=122785157116659&w=2
>>>
>> I did not accept this patch and it did not go in right?
> 
> I think that Jens has not merged mine or yours. I don't care about
> either but I still think that it's better to kill
> blk_end_bidi_request(). It's really confusing API.
> 
> 
>> I still don't like it, it's a performance regression.
> 
> Hmm, I've not seen the figures. Please show the figures if you insist
> a performance regression.
> 

Come on man. this discussion all over again. You do a loop to find
information that was in a CPU register 10 cycles before. That is
plain bad programing, and just a cover up of bad API.

In my book it is: Someone got lazy.

> It's about a bidi request. We already have tons of loops, memory
> allocations, etc in the path. Do you think that adding one more loop
> leads to a notable performance regression?
> 
> Well, if you say that it's hacky then I would agree. But your patch
> using ~0 is hacky too.

It is an hack if used by an outside user, because it assumes knowledge
of block-internals. It is much less of an hack if done by block-internals
which knows for sure that this has no side effects.

But I agree that this is not clean. The clean solution is to add an extra
parameter to blk_end_request() and change all callers.

Or even cleaner is to add a new request->residual member and leave
request->data_len be in peace. Then change the few users that care
about residual, and one caller that sets it. I'll prepare a patch.

Boaz
