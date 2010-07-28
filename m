From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 20:17:28 +0400
Message-ID: <4C505818.1080504@vlnb.net>
References: <20100727165627.GA474@lst.de>	 <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com>	 <4C4FE58C.8080403@kernel.org> <4C4FE860.7000903@suse.de>	 <4C5036BC.30709@vlnb.net>  <4C503D50.4010006@suse.de> <1280327839.30808.188.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:58572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab0G1QRX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2010 12:17:23 -0400
In-Reply-To: <1280327839.30808.188.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <teheo@suse.de>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

James Bottomley, on 07/28/2010 06:37 PM wrote:
> On Wed, 2010-07-28 at 16:23 +0200, Tejun Heo wrote:
>> Hello,
>>
>> On 07/28/2010 03:55 PM, Vladislav Bolkhovitin wrote:
>>>> The only benefit of doing it in the block layer, and probably the
>>>> reason why it was done this way at all, is making use of advanced
>>>> ordering features of some devices - ordered tag and linked commands.
>>>> The latter is deprecated and the former is fundamentally broken in
>>>> error handling anyway.
>>>
>>> Why? SCSI provides ACA and UA_INTLCK which provide all needed
>>> facilities for errors handling in deep ordered queues.
>>
>> I don't remember all the details now but IIRC what was necessary was
>> earlier write failure failing all commands scheduled as ordered.  Does
>> ACA / UA_INTLCK or whatever allow that?
>
> No.  That requires support for QErr ... which is in the same mode page.
>
> The real reason we have difficulty is that BUSY/QUEUE_FULL can cause
> reordering in the issue queue, which is a driver problem and not in the
> SCSI standards.

BTW, I for long time wandering why low level drivers should process 
BUSY/QUEUE_FULL and perform adjusting the queue depth. Isn't it common 
for the drivers, so should be performed on the higher (SCSI) level? This 
level would provide facility to prevent reordering, if needed, and the 
driver would communicate with it in a transparent level.

I mean the following. A driver always deals with a single command at 
time. It either sends the command to the device, or sends command's 
status/sense from the device to the SCSI level. Then SCSI level decides 
if to send another command to the driver or perform necessary recovery, 
eg, adjusting queue depth or using ACA restarting the QUEUE_FULL'ed command.

In this architecture there would not be needed to update all the drivers 
to provide ordering guarantees and ACA based recovery as it seems needed 
now.

Or, am I missing something?

Thanks,
Vlad
