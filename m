From: Lukasz Kosewski <lkosewsk@nit.ca>
Subject: SCSI layer a stumbling block for true SATA hotplug
Date: Sat, 16 Jul 2005 19:14:11 -0400
Message-ID: <42D994C3.8090702@nit.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ptr-64-201-187-87.ptr.terago.ca ([64.201.187.87]:28601 "HELO
	mars.net-itech.com") by vger.kernel.org with SMTP id S261832AbVGPXOM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jul 2005 19:14:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jgarzik@pobox.com

Hello all,

I'm currently working on a project to get a true disk-hotplug subsystem 
working in libata, experimenting with Promise SATA150 Tx2 Plus and 
SATAII150 Tx2 Plus controllers.

I am very near a 'beta' release of my patches to this mailing list, 
however, I have hit a stumbling block in the SCSI layer, which I'm 
hoping someone can give me good suggestions for resolving.

The situation is as follows:
-> I unplug a disk from my controller.
-> An interrupt fires off telling me I've unplugged a disk.
-> I acknowledge the interrupt, add an entry to my workqueue to handle 
the bottom half.
-> Bottom half kicks in, I need to call "scsi_remove_device" in order to 
purge the information about this disk from the system.

HOWEVER, "scsi_remove_device", through a chain of functions, ends up 
calling sd_shutdown, which attempts to synchronize the SCSI cache for my 
disk.  Well... bad plan, I've just unplugged the disk, it's gone.

So the system gets dazed and confused and locks up, timing out waiting 
for the disk which isn't there.

If anyone has a suggestion as to a good (ie. acceptable by all parties) 
solution to this problem, I'd love to hear it.

Thanks in advance,

Luke Kosewski
