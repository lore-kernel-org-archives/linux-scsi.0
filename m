From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Ksummit-2008-discuss] Kernel Summit Request for Discussion:
 The Future of Target mode and Cloud storage on Linux
Date: Fri, 22 Aug 2008 14:46:17 -0500
Message-ID: <48AF1789.6080803@cs.wisc.edu>
References: <48ADC53B.6090501@vlnb.net> <48ADFAB7.5010201@cs.wisc.edu> <48AF0C75.4060204@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53022 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbYHVTqf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 15:46:35 -0400
In-Reply-To: <48AF0C75.4060204@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>

Vladislav Bolkhovitin wrote:
>> 3. Start sending patches for common code like scatterlist improvements 
>> and scatterlist memory reservations.
> 
> What do you mean?

There were some nice functionality that Nick's target had and I thought 
scst had too that could be more generic like the ability to reservre 
memory for a scatterlist or basically make sure you can have a 
scatterlist that is within a drivers/hardwares limits and can fullfill 
the request. For exmaple if the target driver could only do X segments, 
but the command was 8 MBs then we need a scatterlist with big segments, 
and I thought you guys had nice to code to handle this. It is the same 
thing that is needed by the SCSI upper layer drives when chaining is not 
supported.

You should rip that out of the scst patch set or whatever Nicsk patchset 
is called and get it in right away to make it easier to review the 
target patches (less target code to argue about :)).


> 
>> 4. Send patches for new target infrastructure core code for review and 
>> cleanup. And send ibm vscsi target driver for an example and to make 
>> sure there are no functionality regressions. The latter should not be 
>> too hard because stgt does not have many features right? :)
>>
>> 5. When common code is merged and new core target infrastructure is 
>> through the review process we can just swap out the new code for stgt 
>> and name it whatever you want.
>>
>> Tomo and I can handle trying to modify the new framework to support 
>> putting a scsi state machine in userspace and sharing that with kernel 
>> code. Right now the primary targets for stgt that users are deploying 
>> are are completely in userspace, so we do not have much to worry 
>> about. There are ibm vscsi users, but they are a lot smaller in number 
>> compared to iscsi. I would bet the ibmvscsi would prefer to use the 
>> kernel target we make too.
>>
>> Our userspace tools will also be able to support both kernel space and 
>> userspace targets with little trouble so distros that have stgt will 
>> not notice any differences.
> 
> So, do you propose to start converting STGT to SCST? Do I understand you 
> correctly?

Will we ever finish these threads if we go the other way where we 
convert scst to stgt :) Yes, we will convert stgt to scst if that is how 
you want to word it. I think when people are saying evolve the code they 
do not mean that we have to force scst into stgt or the reverse. With 
James allowing performance critical stuff in the kernel we can add 
whatever is best. For the stgt functionalty that may not be support by 
scst or whatever is going to go in, then yeah, Tomo and I can handle that.
