From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Ksummit-2008-discuss] Kernel Summit Request for Discussion:
 The Future of Target mode and Cloud storage on Linux
Date: Thu, 21 Aug 2008 18:31:03 -0500
Message-ID: <48ADFAB7.5010201@cs.wisc.edu>
References: <48ADC53B.6090501@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50579 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbYHUXbd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2008 19:31:33 -0400
In-Reply-To: <48ADC53B.6090501@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: ksummit-2008-discuss@lists.linux-foundation.org, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>

snip

>> non overlapping code bases in the kernel is the right thing to do, so
>> what I'd like is for us to evolve the existing solution into something
>> that will work for both (by taking pieces of the out of SCST and placing
>> them into STGT).
>>

snip

> 
> James, you missed that SCST for a long time has support for implementing 
> backstorage devices in the user space. This is provided through 
> backstorage device handler called scst_user. You can find its interface 

Does scst support moving the scsi state machine there? I think that is 
what James meant by some of his comments, but I do not think this detail 
is too important. If you can, great one less todo item.

> 
> If all necessary pieces of STGT moved in the kernel, it would become 
> pretty much the same as SCST at the moment. 

In the top paragraph James is saying to move scst into stgt, so it seems 
like we can do the following:

1. You and with Nick battle each other about what are the best pieces of 
scst and his target and what should go upstream.

2. Do a ibm vscsi target for the new framework since that is the only 
upstream kernel target right now. For qla2xxx, we can forget the patches 
we sent qlogic and use what comes with the common framework since scst 
has one already.

3. Start sending patches for common code like scatterlist improvements 
and scatterlist memory reservations.

4. Send patches for new target infrastructure core code for review and 
cleanup. And send ibm vscsi target driver for an example and to make 
sure there are no functionality regressions. The latter should not be 
too hard because stgt does not have many features right? :)

5. When common code is merged and new core target infrastructure is 
through the review process we can just swap out the new code for stgt 
and name it whatever you want.

Tomo and I can handle trying to modify the new framework to support 
putting a scsi state machine in userspace and sharing that with kernel 
code. Right now the primary targets for stgt that users are deploying 
are are completely in userspace, so we do not have much to worry about. 
There are ibm vscsi users, but they are a lot smaller in number compared 
to iscsi. I would bet the ibmvscsi would prefer to use the kernel target 
we make too.

Our userspace tools will also be able to support both kernel space and 
userspace targets with little trouble so distros that have stgt will not 
notice any differences.

Surely this will be faster than writing all these mails and wasting time 
on this :)

I think James also said something about moving STGT in-kernel to get 
performance gains, but I do not think it means that we have to push 
exact code that sits in Tomo's git tree from usrspace into the kernel. 
If along the way we replace it with scst or Nick's code and we end up 
with a variant of scst or Nicks code that can still support userspace 
targets then I do not think any one is going to make long threads like 
these have resulted in :)

Will this work for everyone?
