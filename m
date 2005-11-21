From: Brian King <brking@us.ibm.com>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Mon, 21 Nov 2005 08:48:11 -0600
Message-ID: <4381DE2B.8060509@us.ibm.com>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <437E5E1E.2080902@torque.net> <438152BC.3060505@us.ibm.com> <200511211109.19490.kilian.cavalotti@lip6.fr>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:2263 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932321AbVKUOsR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 09:48:17 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jALEmDBs020553
	for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2005 09:48:13 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jALEmCZ8119996
	for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2005 09:48:13 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jALEmCYd018108
	for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2005 09:48:12 -0500
In-Reply-To: <200511211109.19490.kilian.cavalotti@lip6.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Kilian CAVALOTTI wrote:
> On Monday 21 November 2005 05:53, you wrote:
> 
>>I don't think slave_configure is the right place to be modifying
>>a scsi_host attribute. How about this patch instead? Only compile
>>tested.
> 
> 
> Patch applied on 2.6.15-rc2, and gives no better result:
> 
> # sg_readcap -16 -vv /dev/sdb
>     read capacity (16) cdb: 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
> READ CAPACITY 16 command error: Host_status=0x0b [DID_SOFT_ERROR]
> 
> dmesg output:
> --------------------------------------------------------------------------
> ACPI: PCI Interrupt 0000:05:04.0[A] -> GSI 106 (level, low) -> IRQ 25
> scsi3 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>         <Adaptec 3960D Ultra160 SCSI adapter>
>         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> 
>   Vendor: IFT       Model: A16U-G1410        Rev: 342J
>   Type:   Direct-Access                      ANSI SCSI revision: 05
> scsi3:A:4:0: Tagged Queuing enabled.  Depth 32
>  target3:0:4: Beginning Domain Validation
>  target3:0:4: wide asynchronous.
>  target3:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
>  target3:0:4: Ending Domain Validation
> sdc : very big device. try to use READ CAPACITY(16).
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 3 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 2 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 3 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 2 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 3 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 2 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 3 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 2 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 3 - Abort Tag Completed.
> sdc : READ CAPACITY(16) failed.
> sdc : status=0, message=00, host=7, driver=00
> sdc : use 0xffffffff as device size
> SCSI device sdc: 4294967296 512-byte hdwr sectors (2199023 MB)
> SCSI device sdc: drive cache: write back
> sdc : very big device. try to use READ CAPACITY(16).
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 2 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 3 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 2 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 3 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 2 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 3 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 2 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 3 - Abort Tag Completed.
> (scsi3:A:4:0): No or incomplete CDB sent to device.
> (scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi3:A:4:0): Abort Tag Message Sent
> (scsi3:A:4:0): SCB 2 - Abort Tag Completed.
> sdc : READ CAPACITY(16) failed.
> sdc : status=0, message=00, host=7, driver=00
> sdc : use 0xffffffff as device size
> SCSI device sdc: 4294967296 512-byte hdwr sectors (2199023 MB)
> SCSI device sdc: drive cache: write back
>  sdc: sdc1
> sd 3:0:4:0: Attached scsi disk sdc
> sd 3:0:4:0: Attached scsi generic sg3 type 0
> --------------------------------------------------------------------------
> 
> Does this mean the HBA has an hardware limit?

Quite possibly. Looking at ahc_linux_run_command in aic7xxx_osm.c it appears
that commands with a cdb length of > 12 are sent to the adapter in a different way.
Perhaps this method does not work on the card you have. 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
