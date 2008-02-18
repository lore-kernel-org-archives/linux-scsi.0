From: Markus Naeher <MNAEHER@de.ibm.com>
Subject: Device rescan does not find all new devices
Date: Mon, 18 Feb 2008 13:31:58 +0100
Message-ID: <OF83B5268C.7E58DEB4-ONC12573F3.0042CD17-C12573F3.0044D81A@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:49087 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbYBRMcE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 07:32:04 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate8.de.ibm.com (8.13.8/8.13.8) with ESMTP id m1ICW0vb270742
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 12:32:00 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1ICW0nw2101350
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 13:32:00 +0100
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1ICW0Do022183
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 13:32:00 +0100
Received: from d12ml061.megacenter.de.ibm.com (d12ml061.megacenter.de.ibm.com [9.149.166.218])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m1ICW0JH022178
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 13:32:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello people ! 

I have an x86 SLES 10 system that is connected to some disks on two
EnterpriseStorageSystems (ESS) via two QLogic FibreChannel SCSI Adapters. 
Each adapter has one path to each disk, so I have a real multipathing
environment. 

Now, I have the need to re-configure the available disks during the system 
is
up and running. 
Up to now (and hopefully in future also), the only kind of 
re-configuration is
to add more disks. 

To be more exact, the system is started wth only the disks of ESS 1 
connected,
and the disks on ESS 2 need to be added later on. 
The disk layouts on both ESS's are identical. 

To make the new disks known to the system, I followed these instructions: 
http://www-941.ibm.com/collaboration/wiki/display/LinuxP/SCSI+-+Hot+add,+remove,+rescan+of+SCSI+devices
And this is the script I have created, acording to the above mentioned
instructions: 

for HOST in /sys/class/scsi_host/host? 
do 
  echo "- - -" > $HOST/scan 
done 

When I run this script, all new disks except one are detected. 
All new disks (except the missing one of course) are found by both pathes. 


In the syslog, there are many messages about the disks that were found, 
but none
(not even error messages) about the disk that was not found. 
When I then rebot the system, all disks are there, including the one that 
was not
found by the rescan.
Therefore I think my configuration is OK. 

The missing disk is always the first one (LUN 000). I have tested this by 
changing
the order of the disks on ESS 2. 
I have also repeated the test scenario with only one path per disk. 
In this testcase, I have divided the ESS's on the two Adapters (Adapter 1 
accesses
the disks on ESS 1, Adapter 2 those on ESS 2). 
Sadly, with no change in the result. 

I think the first thing I would need help with is how to further analyze 
the problem. 

Thanks and Regards, 
Markus
