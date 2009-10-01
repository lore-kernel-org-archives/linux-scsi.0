From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Fibre Channel pass-through for sending arbitrary FC and SCSI
 commands
Date: Thu, 1 Oct 2009 10:18:49 -0400
Message-ID: <4AC4BA49.6020705@emulex.com>
References: <da0ca6030909302225g6009092bh960a2e09f2cdeadd@mail.gmail.com> <4AC44DC5.4060106@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:65484 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbZJAOSs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 10:18:48 -0400
In-Reply-To: <4AC44DC5.4060106@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: G S <gogman69-linuxscsi@yahoo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Joe Eykholt wrote:
> G S wrote:
>   
>> Howdy,
>>
>> The Linux "sg" (SCSI pass-through) can be used to send arbitrary SCSI
>> commands to SCSI target devices.
>>
>> But "sg" doesn't give me access to the transport layer details, such
>> as constructing my own FCP_CMND and receiving FCP_RSP IU's.
>>
>> Is there FC pass-thru in Linux (2.6) SCSI stack, that allows me to
>> construct my own transport frames and payloads?
>>     
>
> There's /dev/bsg* that gives lets you send ELS and CT frames, but not
> just any FC frames.   You need to configure it under the "Block layer"
> kconfig menu.  And perhaps not all HBAs support it.   See source
> block/bsg.c for details.
>
>   
Although, to date, transport-specific command formats have largely been 
confined to the LLDs, I don't know why we couldn't extend the bsg 
commands to include something that requests an FCP command execution.  
You may still have to wait for individual drivers to support such a 
thing (just like the els/ct), but technically, there's no issue.

The downside to this is - any side-band command has the opportunity to 
change the scsi state of the device, and do so outside of the knowledge 
of the class driver. So any such use is "at your own risk".    Consider 
scenarios: a) your fcp command clears a CA condition that the class 
driver needs to be aware of; or b) app is busy reading tape device, 
sideband FCP-based rewind command comes in, repositions tape, app is 
unaware of rewind, things get all confused. Even worse if FC-cmd is a 
write as tape writes dictate tape records and filemarks, etc.

>> If not, is there vendor (eg. QLogic and Emulex) provided IOCTL module
>> that allows application to interface directly to the HBA driver for
>> doing FC pass-through?
>>     
>
> I don't know that.
>
> 	Joe
>
>   
Vendor-provided ioctls are an evil that are not allowed upstream, and 
thus typically not allowed in distros either. However, as distro 
products must be supportable, when the kernel doesn't have the necessary 
infrastructure, the rules get relaxed, although with great debate 
first.  Vendors can provide out-of-kernel drivers, but this is very 
costly for the vendor - there's dislike from the community, there's 
lack-of-support from distros, and a yet another driver stream that must 
be supported.  Thus, the best option if you desire this feature, is to 
add the bsg request type indicated above.

-- james s

