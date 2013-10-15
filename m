From: Praveen Murali <pmurali@logicube.com>
Subject: eSATA Drive Detection issues on mvsas
Date: Mon, 14 Oct 2013 17:18:27 -0700
Message-ID: <525C89D3.5090008@logicube.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o142.mxlogic.net ([208.65.145.65]:38050 "EHLO
	p01c12o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab3JOA0z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Oct 2013 20:26:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
   I have couple of external drives (Western Digital and Seagate) that 
have an eSATA interface. My Linux box with a Marvell HBA (9445) running 
Ubuntu 12.04 with 3.2.48 kernel doest not seem to detect the drive. I 
tried with the latest upstream kernel and it behaves the same. But both 
the drives detect fine if I enter the mvsas BIOS during bootup. So I 
have hooked up a SATA analyzer and this is what I found
- When I tried to detect the drives in the mvsas BIOS, all the ATA 
commands that the bios issues have the port multiplier byte set to 0.
- If I bootup my Linux system and then connect the drives, the first 
IDENTIFY command has the port multiplier set to 0 (this one is 
successful) and the subsequent IDENTIFY command has port multiplier set 
to 1 (this one fails).
- If I connect any other SATA drives I have to the HBA, all the ATA 
commands have port multiplier set to 1 but they detects and work fine.

Just to rule out the port-multiplier possibility I changed the following 
line in drivers/scsi/libsas/sas_ata.c - fucntion sas_ata_qc_issue()

ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);

to

ata_tf_to_fis(&qc->tf, 0, 0, (u8*)&task->ata_task.fis);

now all my drives seem to detect just fine. I believe, the eSATA 
interface on these external drives is a port multiplier, which is why 
the command fails. Also, the normal drives ignore this field thats why 
they work fine with port multiplier being set to either 0 or 1.

Question(s): Are my above assumtions correct? If so, what is the 
reasoning behind setting the port multiplier to 1 by default in libsas 
layer?

Thanks,
Praveen



