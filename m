From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Kernel Summit Request for Discussion: The Future of Target mode
 and Cloud storage on Linux
Date: Wed, 27 Aug 2008 21:51:55 +0400
Message-ID: <48B5943B.80707@vlnb.net>
References: <48ADC53B.6090501@vlnb.net> <48ADFAB7.5010201@cs.wisc.edu> <48AF0C75.4060204@vlnb.net> <48AF1789.6080803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:49140 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751068AbYH0Rv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2008 13:51:26 -0400
In-Reply-To: <48AF1789.6080803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>

Mike Christie wrote:
> Vladislav Bolkhovitin wrote:
>>> 3. Start sending patches for common code like scatterlist improvements 
>>> and scatterlist memory reservations.
>> What do you mean?
> 
> There were some nice functionality that Nick's target had and I thought 
> scst had too that could be more generic like the ability to reservre 
> memory for a scatterlist or basically make sure you can have a 
> scatterlist that is within a drivers/hardwares limits and can fullfill 
> the request. For exmaple if the target driver could only do X segments, 
> but the command was 8 MBs then we need a scatterlist with big segments, 
> and I thought you guys had nice to code to handle this. It is the same 
> thing that is needed by the SCSI upper layer drives when chaining is not 
> supported.
> 
> You should rip that out of the scst patch set or whatever Nicsk patchset 
> is called and get it in right away to make it easier to review the 
> target patches (less target code to argue about :)).

Yes, there is such code. Sure, it can be extracted and posted as a 
separate patch, so other drivers would be able to use it as well (it 
isn't SCSI specific, so, I think, should be put somewhere in drivers/base/).

But, in fact, so far we have not argued a bit of code. We argue 
fundamental principles, so extracting SGV cache or Nick's analog won't 
actually change anything.

>>> 4. Send patches for new target infrastructure core code for review and 
>>> cleanup. And send ibm vscsi target driver for an example and to make 
>>> sure there are no functionality regressions. The latter should not be 
>>> too hard because stgt does not have many features right? :)
>>>
>>> 5. When common code is merged and new core target infrastructure is 
>>> through the review process we can just swap out the new code for stgt 
>>> and name it whatever you want.
>>>
>>> Tomo and I can handle trying to modify the new framework to support 
>>> putting a scsi state machine in userspace and sharing that with kernel 
>>> code. Right now the primary targets for stgt that users are deploying 
>>> are are completely in userspace, so we do not have much to worry 
>>> about. There are ibm vscsi users, but they are a lot smaller in number 
>>> compared to iscsi. I would bet the ibmvscsi would prefer to use the 
>>> kernel target we make too.
>>>
>>> Our userspace tools will also be able to support both kernel space and 
>>> userspace targets with little trouble so distros that have stgt will 
>>> not notice any differences.
>> So, do you propose to start converting STGT to SCST? Do I understand you 
>> correctly?
> 
> Will we ever finish these threads if we go the other way where we 
> convert scst to stgt :) Yes, we will convert stgt to scst if that is how 
> you want to word it. I think when people are saying evolve the code they 
> do not mean that we have to force scst into stgt or the reverse. With 
> James allowing performance critical stuff in the kernel we can add 
> whatever is best. For the stgt functionalty that may not be support by 
> scst or whatever is going to go in, then yeah, Tomo and I can handle that.

What not clear to me are the reasons behind decision to use STGT as a 
base point for future development. AFAIK, the only valuable advantage it 
has over SCST is ibmvscsi target driver. And that's all. ISER target 
driver doesn't need any kernel support, so can happily live without 
STGT. Correct me, if I wrong.

Usually people, choosing the starting point of some consolidating 
project among several similar ones, choose one, which is the closest to 
what they ultimately want to see in the finish. Apparently, SCST is a 
lot closer to that, than STGT, correct? So, then, why the choice was 
done to start from STGT? Definitely, this choice will add a lot of 
effort without any return. Or, am I missing something? There is nothing 
personal in my questions, I'm caring only about amount of needed effort.

Vlad



