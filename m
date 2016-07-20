From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 2/3] xen-scsiback: One function call less in
 scsiback_device_action() after error detection
Date: Wed, 20 Jul 2016 07:26:31 +0200
Message-ID: <85b948e0-bf37-dff0-6792-77b5dacef9a0@suse.com>
References: <5307CAA2.8060406@users.sourceforge.net>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <59e51c7d-f7bb-c55f-d2fe-06dccfef6a99@users.sourceforge.net>
 <87e55a72-71ad-d0a1-b936-12565bbc6508@users.sourceforge.net>
 <fb5824ad-fb09-e471-7dc4-3e32564cc334@suse.com>
 <8806e9cb-4200-8154-7914-6735805dfbe0@users.sourceforge.net>
 <83b0b1e2-900b-eefc-160b-7d837730571c@suse.com>
 <18256bfc-c6f9-8802-8d7d-55766f0b3624@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbcGTF0e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2016 01:26:34 -0400
In-Reply-To: <18256bfc-c6f9-8802-8d7d-55766f0b3624@users.sourceforge.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>

On 20/07/16 07:10, SF Markus Elfring wrote:
>>>>> @@ -606,7 +606,7 @@ static void scsiback_device_action(struct vscsibk_pend *pending_req,
>>>>>  	tmr = kzalloc(sizeof(struct scsiback_tmr), GFP_KERNEL);
>>>>>  	if (!tmr) {
>>>>>  		target_put_sess_cmd(se_cmd);
>>>>> -		goto err;
>>>>> +		goto do_resp;
>>>>>  	}
>>>>
>>>> Hmm, I'm not convinced this is an improvement.
>>>>
>>>> I'd rather rename the new error label to "put_cmd" and get rid of the
>>>> braces in above if statement:
>>>>
>>>> -	if (!tmr) {
>>>> -		target_put_sess_cmd(se_cmd);
>>>> -		goto err;
>>>> -	}
>>>> +	if (!tmr)
>>>> +		goto put_cmd;
>>>>
>>>> and then in the error path:
>>>>
>>>> -err:
>>>> +put_cmd:
>>>> +	target_put_sess_cmd(se_cmd);
>>>
>>> I am unsure on the relevance of this function on such a source position.
>>> Would it make sense to move it further down at the end?
>>
>> You only want to call it in the first error case (allocation failure).
> 
> Thanks for your clarification.
> 
> I find that my update suggestion (from Saturday) is still appropriate
> in this case.
> https://lkml.org/lkml/2016/7/16/172

And I still think it isn't an improvement: Nack

>>>> +free_tmr:
>>>> 	kfree(tmr);
>>>
>>> How do you think about to skip this function call after a memory
>>> allocation failure?
>>
>> I think this just doesn't matter. If it were a hot path, yes. But trying
>> to do micro-optimizations in an error path is just not worth the effort.
> 
> Would you like to reduce also the amount of function calls in such special
> run-time situations?

I just don't care for the extra 2 or 3 nsecs. Readability is more
important here.

>> I like a linear error path containing all the needed cleanups best.
> 
> I would prefer to keep the discussed single function call within
> the basic block of the if statement.
> 
> Have we got different opinions about the shown implementation details?

Yes.


Juergen

