From: Aboo Valappil <aboo@aboo.org>
Subject: SCSITAP, Virtual SCSI HBA and user space SCSI initiators
Date: Fri, 13 Oct 2006 03:25:46 +1000
Message-ID: <452E7A9A.3000501@aboo.org>
References: <452E0A5C.6020001@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:6058 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S1750721AbWJLRZs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Oct 2006 13:25:48 -0400
Received: from [192.168.1.65] ([192.168.1.65])
	by localhost.localdomain (8.13.1/8.13.1) with ESMTP id k9CHKVB6030241
	for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2006 03:20:31 +1000
In-Reply-To: <452E0A5C.6020001@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am sending this again as the initial mail did not make it to the list.

Hi All,

I thought a lot about whether  I should write to mailing list about this 
or not. I have requested help from the list before to complete this. May 
be I am too crazy to develop something like this. When I think more and 
more about this, it will be really useful, mainly for educational 
purposes and it could be useful in other environments.

I like to know everyone's opinion on this. Please let me know your 
thoughts and suggestions and its inclusion in the main line Linux kernel.

I have developed a Virtual HBA (Around ~600 lines of code). It is a 
kernel module and works very well with 2.6.9 kernel. Basically it 
registers a HBA (LLD) to the SCSI Mid layer. It implements a linked list 
with all the SCSI commands queued from Mid layer. I registered  a 
character device driver. I ship out the SCSI commands off to user space 
via this character device. There is a user space application monitoring 
this character device looking for SCSI commands, process it and sends it 
back to the mid layer through this character interface.  At the moment, 
the interface to the Virtual HBA inside the kernel is through read/write 
and ioctls to the character device. I am trying to get rid of reading 
and writing of SCSI request_buffer through character device and use 
memmap/splice to avoid copying kernel buffer to user space(I am facing 
some challenges as the request_buffer is not a linear buffer, but a 
scatter gather buffer).

As I mentioned above, the HBA only transports the commands out side the 
kernel. But the real job is done by the user space tool. Now there is 
end less opportunity for this user space tool. It can impliment iSCSI, 
NDMP, local files, shared files across the network, etc. People can even 
write iSCSI initiator using Java! The advantage is that the main 
transport is done by user space application. Currently i have 
implemented a small scsi engine and it presents a file as a SCSI disk to 
the kernel. It works great.

The Kernel driver is ready. It will need some modifications (Like 
implimenting memap to avoid copying, integrating with sysfs/procfs, 
etc). I am thinking in different directions on what I should include in 
the driver. May be you guys can direct me in right direction. If you 
think, there is not much potential for this in the Linux kernel, I will 
stop working on this now as I already achieved what I wanted (Presenting 
a file as a SCSI disk).

Please let me know your thoughts and suggestions.

Background:
-------------

I wanted to make a NDMP (A protocol used to manage tapes and perform 
backup/resotre on NAS heads)  initiator for Linux (Just out of my 
interest).. I was not very good with doing stuff inside the kernel. 
First my idea was to modify the Cisco iSCSI initiator and make it for 
NDMP. But i found, it is too much of work + I already had a user space 
implimentation of NDMP procedures. So I thought of making a virtual HBA 
and expose the SCSI mid-layer to a user space application.

Thanks

Aboo



