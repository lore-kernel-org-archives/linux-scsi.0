From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Thu, 28 Oct 2004 07:37:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041028143734.GA16358@beaverton.ibm.com>
References: <20041027233321.GA842@astral.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:52404 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261317AbUJ1Oh7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 10:37:59 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id i9SEbq1p639248
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2004 10:37:52 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i9SEbqQU069894
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2004 08:37:52 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id i9SEbqBU010618
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2004 08:37:52 -0600
Content-Disposition: inline
In-Reply-To: <20041027233321.GA842@astral.ro>
List-Id: linux-scsi@vger.kernel.org
To: Catalin Muresan <catalin.muresan@astral.ro>
Cc: linux-scsi@vger.kernel.org, bogdan.luca@astral.ro

On Thu, Oct 28, 2004 at 02:33:21AM +0300, Catalin Muresan wrote:
> 
> 	Hi,
> 
> 	I have the hardware from the subject, the problem i have is that the
> scsi layer doesn't see any luns i made on the raid except LUN 0. here is an
> example:

LUN 0 didn't show up according to your log output and comments below.

> [root@zerg-b root]# cd /proc/scsi/qla2xxx/  
> [root@zerg-b qla2xxx]# cat 0
> QLogic PCI to Fibre Channel Host Adapter for IBM HS20:
>         Firmware version 3.02.30 IPX, Driver version 8.00.00b15-k

> SCSI Device Information:
> scsi-qla0-adapter-node=2000000d60d367e0;
> scsi-qla0-adapter-port=2100000d60d367e0;
> scsi-qla0-target-0=60003930000026b4;
> 
> SCSI LUN Information:
> (Id:Lun)  * - indicates lun is not registered with the OS.
> ( 0: 5): Total reqs 0, Pending reqs 0, flags 0x0*, 0:0:83 00

The adapter seems to think there is a target and lun 0.

Did anything show up on host 1?

> 	you can see that the driver has found the 5th LUN but scsi_scan
> doesn't se it when scanning, scsi_probe_and_add_lun for LUN 0 returns
> SCSI_SCAN_NO_RESPONSE instead of SCSI_SCAN_TARGET_PRESENT. I have added
> {"APPLE", "Xserve RAID", NULL, BLIST_SPARSELUN}, in scsi_devinfo.c so
> scsi_scan will try and perform a sparse scan on the LUNs but that doesn't
> help because scanning LUN 0 fails.

Yep.

> Oct 28 01:59:37 zerg-b kernel: scsi_scan_host_selected: <0:4294967295:4294967295:4294967295>
> Oct 28 01:59:37 zerg-b kernel: scsi scan: INQUIRY to host 0 channel 0 id 0 lun 0
> Oct 28 01:59:37 zerg-b kernel: scsi scan: 1st INQUIRY failed with code 0x10000

The 0x10000 is a DID_NO_CONNECT, generally the adapter can't talk to
the target at all.

It seem like the storage was seen, then went away and then came back.

Do you always get the same behaviour?

Are there other messages in your log? Just post the entire log without
the scsi logging on, from adapter load time to scan completion.

> 	storage is APPLE Xserve RAID, latest firmware with lun masking activated, for this node
> the 5th LUN is allowed. using add-single-device does the trick but i need a
> kernel to boot from FC. here is the output after 

> # echo "scsi add-single-device 0 0 0 5" > /proc/scsi/scsi

You can also use:

	echo "- - -" > /sys/class/scsi_host/host0/scan

-- Patrick Mansfield
