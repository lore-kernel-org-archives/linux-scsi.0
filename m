From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Wed, 27 Oct 2010 19:28:33 -0400
Message-ID: <4CC8B5A1.6080703@garzik.org>
References: <1287607774.10283.78.camel@haakon2.linux-iscsi.org> <20101021150840.GA24309@linux.vnet.ibm.com> <1288130914.5169.97.camel@haakon2.linux-iscsi.org> <1288132071.8283.689.camel@mulgrave.site> <1288132464.5169.112.camel@haakon2.linux-iscsi.org> <1288133450.8283.723.camel@mulgrave.site> <1288134048.5169.132.camel@haakon2.linux-iscsi.org> <1288134713.19649.11.camel@mulgrave.site> <1288135918.5169.149.camel@haakon2.linux-iscsi.org> <20101027075349.GA32585@gargoyle.fritz.box> <1288189658.4692.13.camel@mulgrave.site> <1288202802.5169.202.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45385 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0J0X2k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2010 19:28:40 -0400
In-Reply-To: <1288202802.5169.202.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Andi Kleen <ak@linux.intel.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>

On 10/27/2010 02:06 PM, Nicholas A. Bellinger wrote:
> On Wed, 2010-10-27 at 09:27 -0500, James Bottomley wrote:
>> On Wed, 2010-10-27 at 09:53 +0200, Andi Kleen wrote:
>>>> This sounds like a pretty reasonable compromise that I think is slightly
>>>> less risky for the LLDs with the ghosts and cob-webs hanging off of
>>>> them.
>>>
>>> They won't get tested either next release cycle. Essentially
>>> near nobody uses them.
>>>
>>>>
>>>> What do you think..?
>>>
>>> Standard linux practice is to simply push the locks down. That's a pretty
>>> mechanical operation and shouldn't be too risky
>>>
>>> With some luck you could even do it with coccinelle.
>>
>> Precisely ... if we can do the push down now as a mechanical
>> transformation we can put it in the current merge window as a low risk
>> API change.
>
> I disagree that touching every single legacy LLD's SHT->queuecommand()
> and failure paths in that code is a low rist change.

Think of changes like steps in a math proof.  You want to make a series 
of equivalent transformations such that, each transformation takes the 
code (proof) one step closer to your goal.

unlocked_qcmds does nothing but increase complexity, as opposed to an 
equivalent-transformation mechanical code change much more easily 
provable as correct (or broken). unlocked_qcmds is the type of 
transition step you always want to avoid if possible.  Conditional 
locking logic tends to be complexity at its worst... and in this case, 
it's all avoidable.

	Jeff


