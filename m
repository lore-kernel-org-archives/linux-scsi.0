From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 07/17] be2iscsi: Fix the kernel panic in blkiopoll disable
 mode
Date: Tue, 02 Oct 2012 22:40:38 -0500
Message-ID: <506BB3B6.4000306@cs.wisc.edu>
References: <da282c92-f339-43bc-a13f-28e13a2420a3@CMEXHTCAS1.ad.emulex.com> <79ADB278-10C0-401F-9E5E-F40B32502EC6@cs.wisc.edu> <ebf16d13-360f-459e-8164-d30db3c7023f@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58754 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab2JCDks (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2012 23:40:48 -0400
In-Reply-To: <ebf16d13-360f-459e-8164-d30db3c7023f@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "John, Sony" <Sony.John-N@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Kallickal, Jayamohan" <Jayamohan.Kallickal@Emulex.Com>

On 10/02/2012 06:51 PM, John, Sony wrote:
>> Creating UNBOUND WQ for each EQ in the driver.
>> What is the benefit of doing this vs per hba like before?
> EQ's are created based on the NUM_CPU in the machine. Notification for task completion comes on an EQ. There could be multiple entries in the EQ that need to be processed and driver iterates the list of entries on that EQ does the required processing and then re-arms EQ for further interrupts. The issue with per hba WQ was it was not possible to get the EQ on which the interrupt has come. 
> 
> In the new infrastructure a single_thread WQ is assigned to each EQ that is created. The EQ structure ptr is passed as the device data structure while registering the interrupts. When interrupts comes, driver can just queue_work for that  EQ from the interrupt handler.
> 

Why not? Maybe I am not understanding you. You can allocate a
workqueue_struct per hba, but embed a work struct in each be_queue_info.
Then do:

queue_work(phba->wq, &eq->work_cqs);

You would then keep

+  INIT_WORK(&pbe_eq->work_cqs, beiscsi_process_all_cqs);

in your patch and in the the work function for the eq->work_cqs you
would get the eq like you wanted.

You also then do not have to worry about too many workqueues being made
and you do not have to use WQ_UNBOUND as a work around.



>> Why WQ_UNBOUND? It seems other drivers prefer it the other way.
> The intention of using the flag WQ_UNBOUND was to have a single_work_queue across all cores for each EQ created.  Default implementation of "alloc_workqueue"  is creating  workqueue per core, in driver EQ creation depends on NUM_CPU and based on that too many workqueues will be created which can be counter productive.  This scenario is hit only in blk_iopoll disable mode and the latest kernel it is always enabled. So used the WQ_UNBOUND flag to make is as single thread.
> 
> Thanks
> Sony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

