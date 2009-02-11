From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Wed, 11 Feb 2009 20:16:00 +0200
Message-ID: <499315E0.4010700@panasas.com>
References: <4992F98B.1060401@panasas.com>	<20090212013215L.fujita.tomonori@lab.ntt.co.jp>	<499302E4.9010309@panasas.com> <20090212021447X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:13934 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756748AbZBKSQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 13:16:07 -0500
In-Reply-To: <20090212021447X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com, sven@linux.vnet.ibm.com

FUJITA Tomonori wrote:
> On Wed, 11 Feb 2009 18:55:00 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>> It's about a bidi request. We already have tons of loops, memory
>>> allocations, etc in the path. Do you think that adding one more loop
>>> leads to a notable performance regression?
>>>
>>> Well, if you say that it's hacky then I would agree. But your patch
>>> using ~0 is hacky too.
>> It is an hack if used by an outside user, because it assumes knowledge
>> of block-internals. It is much less of an hack if done by block-internals
>> which knows for sure that this has no side effects.
>>
>> But I agree that this is not clean. The clean solution is to add an extra
>> parameter to blk_end_request() and change all callers.
> 
> I don't agree.
> 
> 
>> Or even cleaner is to add a new request->residual member and leave
>> request->data_len be in peace. Then change the few users that care
>> about residual, and one caller that sets it. I'll prepare a patch.
> 
> Yeah, it's clean but I'm not sure Jens would accept such patch since
> fattening request struct leads to a notable performance regression.

OK, then give up, a proper comment next to blk_end_bidi_request()
that says:
"... can be used with any requests, in case of uni-requests the
second length will be ignored"

Actual FC code changes is:
-	blk_end_request(req, err, req_len);
+	blk_end_bidi_request(req, err, req_len, rsp_len);

That is not so hard to understand. There are much more complicated
things in kernel then that simple thing.

Boaz
