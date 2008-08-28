From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Kernel Summit Request for Discussion: The Future of Target mode
 and Cloud storage on Linux
Date: Thu, 28 Aug 2008 21:48:01 +0400
Message-ID: <48B6E4D1.3040608@vlnb.net>
References: <48ADC53B.6090501@vlnb.net> <48ADFAB7.5010201@cs.wisc.edu>	 <1219701570.13470.156.camel@haakon2.linux-iscsi.org>	 <48B59556.7050108@vlnb.net> <1219859977.22978.7.camel@mzhang-PC.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:39713 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755169AbYH1Rrf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 13:47:35 -0400
In-Reply-To: <1219859977.22978.7.camel@mzhang-PC.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: blackmagic02881@gmail.com
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>

Ming Zhang wrote:
>> I, personally, don't like an interface, like tgtadm, which tries to do 
>> all non-trivial configuration work from a single command line tool, 
>> because of the following 3 reasons:
>>
>> 1. It's a lot of effort to write and maintain such a tool, because it 
>> needs to be extensible to work with new modules and modes. For instance, 
>> iptables tool is 86K lines long. The whole netfilter code for all 
>> network protocols in the kernel is less that 50K lines long. Do we want 
>> such a code bloat (170% of code to configure) and dedicated team of 
>> maintainers to solve a fundamentally simple configuration task?
>>
>> 2. It assumes the stateless type of configuration, when each call 
>> configures exactly one thing without any side effects on already 
>> configured or future entries. This approach is good for cases like 
>> iptables, but for SCSI targets it's possible that several configuration 
>> steps require to be done in an atomic manner, like adding an iSCSI 
>> target and configuring its parameters.
>>
>> 3. It's hard to read 5+ parameters in one command line, so it's a lot 
>> easier to make a mistake there.
>>
>> So, I believe, a configuration interface should be rather /proc or /sys 
>> interface based. I don't think we should care much about backward 
>> compatibility with tgtadm, because the existing interface doesn't reach 
>> the state of being widely used. As I already mentioned, only ibmvscsi at 
>> the moment uses it, hardware for which is pretty rare.
> 
> forget about proc. configfs is better. but problem is how u configure
> user space target with configfs?

It doesn't matter much for me procfs or configfs or sysfs, although I 
definitely would prefer procfs, because it's already used by SCST, so no 
additional effort is needed. (The choice of procfs was purely for 
historical reasons; SCST was originally made for 2.4 kernels, where 
there were no other alternatives). But it doesn't relate to the choice 
of the fundamental approach "single utility for all possible parameters" 
vs "single entry for each parameter".

>> Thus, I would suggest that before making the further move we should also 
>> consider configuration interfaces of SCST and LIO and choose the best 
>> things from all 3.
> 
> 
>> Vlad
>>
>>
>> -------------------------------------------------------------------------
>> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
>> Build the coolest Linux based applications with Moblin SDK & win great prizes
>> Grand prize is a trip for two to an Open Source event anywhere in the world
>> http://moblin-contest.org/redirect.php?banner_id=100&url=/
>> _______________________________________________
>> Scst-devel mailing list
>> Scst-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 
> 

