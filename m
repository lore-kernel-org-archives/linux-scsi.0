From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: [Question] Calling request_firmware under the spinlocks in file
 advansys.c
Date: Tue, 13 Sep 2016 14:48:40 +0530
Message-ID: <57D7C470.5070505@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

In the file drivers/scsi/advansys.c we are calling function AdvISR at 2 instances
[in the function advansys_reset and advansys_interrupt] while holding spinlock.
Function AdvISR eventually calls request_firmware following this sequence of
routines: 

AdvISR -> adv_async_callback -> AdvResetChipAndSB -> AdvInitAsc3550Driver ->
request_firmware

According to the definition of request_firmware it should be called from user
context where sleeping is allowed. And usually sleeping under the spin lock is
not allowed. Is it really necessary to call AdvISR under spinlocks here? Are
we taking care of sleeping related concern of request_firmware or am I
overlooking something here?

Thank you.

-- 
Vaishali
