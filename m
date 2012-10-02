From: "John, Sony" <Sony.John-N@Emulex.Com>
Subject: RE: [PATCH 07/17] be2iscsi: Fix the kernel panic in blkiopoll
 disable mode
Date: Tue, 2 Oct 2012 23:51:57 +0000
Message-ID: <ebf16d13-360f-459e-8164-d30db3c7023f@CMEXHTCAS1.ad.emulex.com>
References: <da282c92-f339-43bc-a13f-28e13a2420a3@CMEXHTCAS1.ad.emulex.com>
 <79ADB278-10C0-401F-9E5E-F40B32502EC6@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:39826 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab2JBXwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 19:52:02 -0400
In-Reply-To: <79ADB278-10C0-401F-9E5E-F40B32502EC6@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Kallickal, Jayamohan" <Jayamohan.Kallickal@Emulex.Com>



-----Original Message-----
From: Michael Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Saturday, September 29, 2012 9:32 AM
To: John, Sony
Cc: linux-scsi@vger.kernel.org; Kallickal, Jayamohan
Subject: Re: [PATCH 07/17] be2iscsi: Fix the kernel panic in blkiopoll disable mode


On Sep 28, 2012, at 8:32 PM, John Soni Jose <sony.john-n@emulex.com> wrote:

> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> 
> Fix kernel panic issue while running IO in blk_iopoll disable mode.

>What was the bug exactly?
The task completion notification comes on an EQ.  In existing code getting EQ  from the workQ was not proper, because of which the kernel panic used to happen.

> Creating UNBOUND WQ for each EQ in the driver.
>What is the benefit of doing this vs per hba like before?
EQ's are created based on the NUM_CPU in the machine. Notification for task completion comes on an EQ. There could be multiple entries in the EQ that need to be processed and driver iterates the list of entries on that EQ does the required processing and then re-arms EQ for further interrupts. The issue with per hba WQ was it was not possible to get the EQ on which the interrupt has come. 

In the new infrastructure a single_thread WQ is assigned to each EQ that is created. The EQ structure ptr is passed as the device data structure while registering the interrupts. When interrupts comes, driver can just queue_work for that  EQ from the interrupt handler.

>Why WQ_UNBOUND? It seems other drivers prefer it the other way.
The intention of using the flag WQ_UNBOUND was to have a single_work_queue across all cores for each EQ created.  Default implementation of "alloc_workqueue"  is creating  workqueue per core, in driver EQ creation depends on NUM_CPU and based on that too many workqueues will be created which can be counter productive.  This scenario is hit only in blk_iopoll disable mode and the latest kernel it is always enabled. So used the WQ_UNBOUND flag to make is as single thread.

Thanks
Sony
