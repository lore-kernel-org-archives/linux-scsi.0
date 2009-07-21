From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Recommended HBA management interfaces
Date: Tue, 21 Jul 2009 10:59:17 -0400
Message-ID: <4A65D7C5.8050101@emulex.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A998698F@cosmail02.lsi.com> 	<4A609A55.9040404@linux.vnet.ibm.com> <6C678488C5CEE74F813A4D1948FD2DC7A99EFDC7@cosmail02.lsi.com> 	<4A64A20A.5080908@emulex.com> <6C678488C5CEE74F813A4D1948FD2DC7A99EFE16@cosmail02.lsi.com> 	<4A64C0BD.5040503@emulex.com> <6C678488C5CEE74F813A4D1948FD2DC7A99EFE88@cosmail02.lsi.com> 	<4A65B4A2.70402@emulex.com> <c268e4660907210648m347e9d9fqb95130cf066a21ba@mail.gmail.com> <6C678488C5CEE74F813A4D1948FD2DC7A99EFF96@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44679 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZGUO7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2009 10:59:22 -0400
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7A99EFF96@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: Drew <drew.kay@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

There's some interesting dichotomies in this question/response:

Drivers exist :
1) Within the ESX kernel for physical hardware, with ESX leveraging the api's 
  from the linux kernel/midlayer/etc in order to pick up linux drivers for 
device support in their kernel/hypervisor.  This was my discussion area. 
Management of this area wants to happen via VMware-based paradigms.

2) Within a guest OS for : a) emulated hardware   or   b) direct pci function 
passthru to the guest os.

3) VMware emulates a LSI adapter as a guest-os-to-hypervisor abstraction point 
(e.g 2a).  Thus LSI drivers could/can exist in both ESX and in the Guest OS 
simultaneously, and if the guest is running linux, both driver instances are 
effectively the linux driver.  Atul/LSI is trying very hard to make the one 
linux driver work in both environments.

Hope this helps.

-- james s


Mukker, Atul wrote:
> We _are_ talking about the "optimized" driver :-)
> 
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Drew
>> Sent: Tuesday, July 21, 2009 9:49 AM
>> To: linux-scsi@vger.kernel.org
>> Subject: Re: Recommended HBA management interfaces
>>
>>> VMware attempts to emulate the linux driver/midlayer api's, but
>> emulation is done
>>> in their own way, with their own semantics, for their own purposes..
>> Anyone
>>> that believes they just drop a linux driver into vmware and it works w/o
>>> change has a screw loose.
>> I must confess to some confusion James. I thought that VMware emulates
>> hardware and that outside of optimized drivers they don't get involved
>> in the higher layers of the guest OS.
>>
>>
>> --
>> Drew
>>
>> "Nothing in life is to be feared. It is only to be understood."
>> --Marie Curie
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
