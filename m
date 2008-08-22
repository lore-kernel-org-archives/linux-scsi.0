From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Ksummit-2008-discuss] Kernel Summit Request for Discussion:
 The Future of Target mode and Cloud storage on Linux
Date: Fri, 22 Aug 2008 22:59:01 +0400
Message-ID: <48AF0C75.4060204@vlnb.net>
References: <48ADC53B.6090501@vlnb.net> <48ADFAB7.5010201@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:33726 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752152AbYHVS6j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 14:58:39 -0400
In-Reply-To: <48ADFAB7.5010201@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, ksummit-2008-discuss@lists.linux-foundation.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>

Mike Christie wrote:
> snip
> 
>>> non overlapping code bases in the kernel is the right thing to do, so
>>> what I'd like is for us to evolve the existing solution into something
>>> that will work for both (by taking pieces of the out of SCST and placing
>>> them into STGT).
>>>
> 
> snip
> 
>> James, you missed that SCST for a long time has support for implementing 
>> backstorage devices in the user space. This is provided through 
>> backstorage device handler called scst_user. You can find its interface 
> 
> Does scst support moving the scsi state machine there? I think that is 
> what James meant by some of his comments, but I do not think this detail 
> is too important. If you can, great one less todo item.

Scst_user provides hooks for all the SCST core states. Some of them are 
optional, like for commands parsing, some are required, like for 
commands execution. Is it sufficient?

I would suggest you to look at fileio_tgt. It's a full functional SBC 
device emulator (more than full, actually, since it's also a test program).

>> If all necessary pieces of STGT moved in the kernel, it would become 
>> pretty much the same as SCST at the moment. 
> 
> In the top paragraph James is saying to move scst into stgt, so it seems 
> like we can do the following:
> 
> 1. You and with Nick battle each other about what are the best pieces of 
> scst and his target and what should go upstream.

We generally already agreed in Nick's iSCSI target over SCST core engine 
with some necessary modifications in it taken from LIO core.

> 2. Do a ibm vscsi target for the new framework since that is the only 
> upstream kernel target right now. For qla2xxx, we can forget the patches 
> we sent qlogic and use what comes with the common framework since scst 
> has one already.
> 
> 3. Start sending patches for common code like scatterlist improvements 
> and scatterlist memory reservations.

What do you mean?

> 4. Send patches for new target infrastructure core code for review and 
> cleanup. And send ibm vscsi target driver for an example and to make 
> sure there are no functionality regressions. The latter should not be 
> too hard because stgt does not have many features right? :)
> 
> 5. When common code is merged and new core target infrastructure is 
> through the review process we can just swap out the new code for stgt 
> and name it whatever you want.
> 
> Tomo and I can handle trying to modify the new framework to support 
> putting a scsi state machine in userspace and sharing that with kernel 
> code. Right now the primary targets for stgt that users are deploying 
> are are completely in userspace, so we do not have much to worry about. 
> There are ibm vscsi users, but they are a lot smaller in number compared 
> to iscsi. I would bet the ibmvscsi would prefer to use the kernel target 
> we make too.
> 
> Our userspace tools will also be able to support both kernel space and 
> userspace targets with little trouble so distros that have stgt will not 
> notice any differences.

So, do you propose to start converting STGT to SCST? Do I understand you 
correctly?

> Surely this will be faster than writing all these mails and wasting time 
> on this :)
> 
> I think James also said something about moving STGT in-kernel to get 
> performance gains, but I do not think it means that we have to push 
> exact code that sits in Tomo's git tree from usrspace into the kernel. 
> If along the way we replace it with scst or Nick's code and we end up 
> with a variant of scst or Nicks code that can still support userspace 
> targets then I do not think any one is going to make long threads like 
> these have resulted in :)
> 
> Will this work for everyone?

We need to agree at first which target's architecture we are going to 
use as a base in which we will incorporate the necessary additions from 
other targets. We with Nick have chosen SCST, now it's your, James and 
other interested people's turn. As I already wrote, STGT and its kernel 
part is too widely incompatible with SCST and choosing it as a base will 
lead to unneeded effort.

I would propose to return to this question after I submit SCST patches. 
Then we would see the code and decide, what's good in it and what's bad.

Vlad

