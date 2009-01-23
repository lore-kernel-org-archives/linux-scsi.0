From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: need help to merge (small) virtual scsi driver upstream.
Date: Fri, 23 Jan 2009 23:23:09 +0300
Message-ID: <497A272D.10802@vlnb.net>
References: <4974CED2.9000900@hw0.org> <20090121151113X.fujita.tomonori@lab.ntt.co.jp> <4976D280.5000506@hw0.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:62773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbZAWUXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2009 15:23:17 -0500
In-Reply-To: <4976D280.5000506@hw0.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Henrik Stokseth <henrik@hw0.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linux SCSI ML <linux-scsi@vger.kernel.org>, scst-devel <scst-devel@lists.sourceforge.net>


Henrik Stokseth, on 01/21/2009 10:45 AM wrote:
> FUJITA Tomonori wrote:
>>
>> From a quick look at the patch, your driver links requests to a list
>> and then the user-space daemon reads the requests via the special
>> character device file and sends the response back to kernel space.
>>
>> If I correctly understand what you want, there are some possible
>> alternatives, I guess.
>>
>> Note that I'm not sure 2) and 3) is acceptable to the SCSI maintainer.
>>
>>
>> 1) use iSCSI initiator and target on the same machine
>>
>> First, set up iSCSI target software supporting CD/DVD. For example,
>> you can use tgt (http://stgt.berlios.de), user-space program.
>>
>> Then you set up the iSCSI initiator to connect the target. Basically,
>> the iSCSI initiator works like a virtual hba as you like. The iSCSI
>> initiator and target communicate via tcp while your software
>> communicates via the special character device.
>>
>> If you go with this setup, all you need are already in mainline.

I'm not sure CDEmu's users would be happy to additionally learn how to 
setup and use both iSCSI target and initiator..

> It would be desirable for us to rely upon an interface already present
> in the mainstream kernel for practical reasons.
> 
> Pardon the dumb question but is it possible to talk to the TGT framework
> without using iSCSI?
> SCST has a nice user-space interface but I couldn't tell whether STGT
> had something similar (as documentation is pretty much non-existent).

If SCST was in the mainline kernel, the only thing you would need is to 
write a small glue layer between CDEmu and the user space interface, 
provided by scst_user module. There would be no need for any your 
additional kernel module. Then using scst_local module you would be able 
to use CDEmu facilities. Also you would be automatically able to use 
them on any remote initiator with any supported by SCST SCSI transport 
(iSCSI, Fibre Channel, etc..). STGT doesn't provide such possibility.

You can vote for SCST inclusion in the mainline kernel when in the next 
couple of months I will send its patches for the next iteration of the 
review and inclusion.

Vlad
