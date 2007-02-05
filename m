From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: megaraid_sas : Error message from SYNC CACHE cmd fills up kernel log
Date: Mon, 5 Feb 2007 15:14:13 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E82298ED151@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:54434 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964930AbXBEWO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 17:14:29 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, hch@lst.de, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>


MegaRAID (MR) SAS Adapter FW is exposing VDs (Logical Disks) with WCE
enabled in Mode
Sense command for drives that are configured as WriteBack by the user.
When
the VDs are exported as Write Back drives, OS is sending "Synchronize
Cache" command to the drives frequently.  Per SCSI Spec, this command is
an
optional command and MR firmware is rejecting this command as
unsupported.
User is advised to enable "Write back" only when battery is available
(in Adapter)
The FW does flush cache periodically.

Looks like OS do not like rejecting the command on a boot
volume and so adding the following event message to the event log each
time the
call is failed.  These messages are flooded by OS and is causing
annoyance to
the user.
Message from the log :

Jan 12 17:58:06 linux kernel: FAILED
Jan 12 17:58:07 linux kernel:   status = 1, message = 00, host = 0,
driver
= 08
Jan 12 17:58:07 linux kernel:   <6>sd: Current: sense key: Illegal
Request
Jan 12 17:58:07 linux kernel:     Additional sense: Invalid command
operation code

1. Shouldn't the OS stop sending the sync cache cmd 
if it sees it is "Failed" with "Invalid Command" in sense info ?   

2. Is there a way by which LLD can stop the OS from sending the SYNC cmd
down?

Thanks,

Sumant
