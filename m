From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally attached
 PHYs)
Date: Sat, 22 Oct 2005 11:26:53 +0200
Message-ID: <435A05DD.7040003@s5r6.in-berlin.de>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>	 <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>	 <20051020170330.GA16458@lst.de>  <4357F7DE.7050004@adaptec.com> <1129852879.30258.137.camel@bluto.andrew> <43583A53.2090904@pobox.com> <435929FD.4070304@adaptec.com> <43593100.5040708@pobox.com> <43593884.7000800@adaptec.com> <4359395B.9030402@pobox.com> <43593FE1.7020506@adaptec.com> <4359440E.2050702@pobox.com> <43595275.1000308@adaptec.com> <435959BE.5040101@pobox.com> <43595CA6.9010802@adaptec.com> <43596070.3090902@pobox.com> <43596859.3020801@adaptec.com> <43596F16.7000606@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:27852 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751329AbVJVJ3r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 05:29:47 -0400
In-Reply-To: <43596F16.7000606@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Luben Tuikov <luben_tuikov@adaptec.com>, andrew.patterson@hp.com, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, Linus Torvalds <torvalds@osdl.org>

Jeff Garzik wrote:
> Luben Tuikov wrote:
>>>>> Examples are DMA boundary and s/g limit, 
>>>>> among others.  When confronted with this, you proposed an 
>>>>> additional hardware information struct which duplicates 
>>>>> Scsi_Host_Template.
>>>>
>>>> I told you -- I have this in the struct asd_ha_struct and it was merely
>>>> a downplay that I didn't include the same thing in struct 
>>>> sas_ha_struct.
>>
>> Here is the commit in question:
>> http://linux.adaptec.com/sas/git/?p=linux-2.6-sas.git;a=commit;h=785747ddc631f7618d728a377346965f7db2256a 
> 
> This effectively illustrates the wrong thing to do:  duplicating 
> information that's already in Scsi_Host_Template.
> 
> Just use Scsi_Host_Template in the LLDD and see where that goes.

Will cmd_per_lun, sg_tablesize, max_sectors, dma_boundary, 
use_clustering ever have to be adjusted specifically for a SAS hardware?

Obviuosly none of this is required _at the moment_. IOW neither the 
introduction of a sas_ha_hw_profile nor a pass-through of 
scsi_host_template down to SAS interconnect drivers is required right 
now. So why do one or the other now? Isn't it a sensible rule to not 
solve problems now which do not exist yet?

(I guess Luben only introduced sas_ha_hw_profile to demonstrate that 
there will never be an absolute requirement for scsi_host_template --- 
in its present form --- to be visible in a SAS transport layer <-> SAS 
interconnect driver interface. And there are certainly more alternatives 
to these two approaches.)
-- 
Stefan Richter
-=====-=-=-= =-=- =-==-
http://arcgraph.de/sr/
