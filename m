From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Recommended HBA management interfaces
Date: Tue, 21 Jul 2009 08:29:22 -0400
Message-ID: <4A65B4A2.70402@emulex.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A998698F@cosmail02.lsi.com> <4A609A55.9040404@linux.vnet.ibm.com> <6C678488C5CEE74F813A4D1948FD2DC7A99EFDC7@cosmail02.lsi.com> <4A64A20A.5080908@emulex.com> <6C678488C5CEE74F813A4D1948FD2DC7A99EFE16@cosmail02.lsi.com> <4A64C0BD.5040503@emulex.com> <6C678488C5CEE74F813A4D1948FD2DC7A99EFE88@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:62094 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZGUM31 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2009 08:29:27 -0400
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7A99EFE88@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Mukker, Atul wrote:
> The management protocol involves significant amount of binary data transfer involving multiple applications, so sysfs and friends are not useful for this particular application. But I gather from your (and Brian's) email that mid-layer SG extension should be used for this particular purpose.
> 
> As for asynchronous notifications, netlink seems to be the de-facto choice (or it's mid-layer extensions). But didn't you mention earlier, vmware would not support this?

I answered from a purely linux perspective.  VMware is not Linux. VMware 
attempts to emulate the linux driver/midlayer api's, but emulation is done in 
their own way, with their own semantics, for their own purposes.. Anyone that 
believes they just drop a linux driver into vmware and it works w/o change has 
a screw loose. It may appear to work, and some subsystems may be better than 
others, but there are very subtle and critical differences.  As for all the 
ancillary interfaces such as sysfs, sgio, and transports: a) they have a hard 
time keeping up with the pace of the linux kernel; b) many of the interfaces 
are anti their hypervisor management model. Dependence on user-space utils, 
sysfs, etc doesn't work with a cos-less environment.  Netlink and sockets 
opens up security holes, and hypervisor-level socket support brings all kinds 
of headaches and memory issues. Netlink is not supported. Sysfs isn't 
supported. Even portions of the transports/midlayer are only partially 
implemented.  Unfortunately, vmware interfaces need to be taken up with vmware.

-- james s
