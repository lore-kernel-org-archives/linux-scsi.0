From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [LSF/VM TOPIC] Handling of invalid requests in virtual HBAs
Date: Tue, 13 Apr 2010 21:09:45 +0400
Message-ID: <4BC4A559.4090806@vlnb.net>
References: <4BB45632.5020700@suse.de> <4BC099C5.9090704@vlnb.net> <4BC431C8.9020800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:63721 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab0DMRJv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2010 13:09:51 -0400
In-Reply-To: <4BC431C8.9020800@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf10-pc@lists.linuxfoundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hannes Reinecke, on 04/13/2010 12:56 PM wrote:
> Vladislav Bolkhovitin wrote:
>> Hello Hannes,
>>
>> Hannes Reinecke, on 04/01/2010 12:15 PM wrote:
>>> Hi all,
>>>
>>> [Topic]
>>> Handling of invalid requests in virtual HBAs
>>>
>>> [Abstract]
>>> This discussion will focus on the problem of correct request handling
>>> with virtual HBAs.
>>> For KVM I have implemented a 'megasas' HBA emulation which serves as a
>>> backend for the
>>> megaraid_sas linux driver.
>>> It is now possible to connect several disks from different (physical)
>>> HBAs to that
>>> HBA emulation, each having different logical capabilities wrt
>>> transfersize,
>>> sgl size, sgl length etc.
>>>
>>> The goal of this discussion is how to determine the 'best' capability
>>> setting for the
>>> virtual HBA and how to handle hotplug scenarios, where a disk might be
>>> plugged in
>>> which has incompatible settings from the one the virtual HBA is using
>>> currently.
>> If I understand correctly, you need to allow several KVM guests to share
>> the same physical disks?
>>
> No, the other way round: A KVM guest is using several physical disks,
> each of which coming via a different HBA (eg sda from libata, sdb from lpfc
> and the like).
> So each request queue for the physical disks could be having different
> capabilities, while being routed through the same virtual HBA in the
> KVM guest.
> 
> The general idea for the virtual HBA is that scatter-gather lists
> could be passed directly from the guest to the host (as opposed to
> abstract single I/O blocks only like virtio).
> But the size and shape of the sg lists is different for devices
> coming from different HBAs, so we have two options here (this is
> all done on the host side; the guest will only see one HBA):
> 
> a) Adjust the sg list to match the underlying capabilities of
>    the device. Has the drawback that we defeat the elevator
>    mechanism in the guest side as the announced capabilities
>    there do _not_ match the capabilities on the host :-(
> b) Adjust the HBA capabilities to the lowest common denominator
>    of all physical devices presented to the guest.
>    While this would save us from adjusting the sg lists,
>    it still has the drawback the disk hotplugging won't
>    work, as we can't readjust the HBA parameters in the
>    guest after it's been created.
> 
> Neither of which is really appealing.

Why only a single virtual HBA should be used? Why not to have a 
dedicated virtual HBA for each physical HBA? This way you wouldn't
have problems with capabilities and the need to have lowest common 
denominator. Basically, it's a matter of another struct 
scsi_host_template with possibly the same shared callback functions..

> My idea here would be to move all required capabilities
> to the device/request queue.
> That would neatly solve this issue once and for all.
> And even TGT, LIO-target, and SCST would benefit from this
> methinks.
> 
> But this is exactly the discussion I'd like to have at LSF,
> to see which approach is best or favoured.
> 
> And yes, I am perfectly aware that for a 'production'
> system one would be using a proper target emulator
> like LIO-target or SCST for this kind of setup.
> But first I have to convince the KVM/Qemu folks to
> actually include the megasas emulation.
> Which they won't until the above problem is solved.

LIO doesn't support 1 to many pass-through devices sharing, so SCST in 
the only option.

Vlad
