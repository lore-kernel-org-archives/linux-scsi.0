From: "Haofeng Kou" <haofengk@ptu.promise.com>
Subject: About Tasklet in the ISR
Date: Wed, 10 Jul 2002 19:01:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F6A3AFC9BCD92E48B79C14E4AAAEA20F263CC7@nonamea.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a linux driver for my SCSI card. I write the ISR code as 2
parts: top half and bottom half, then want to use the tasklet instead of
the bh. My method is:

1>	tasklet_init(&Task_Name, Task_Fun, data); execute at the
beginning of the driver.
2> 	tasklet_schedule(&Task_Name); execute in the top half, after the
top half finish its work. 

My issue is once there is a hardware interrupt happen, the th begin to
run then call the tasklet_schedule, but the Task_Fun function never be
called and the th keep the status of being called again and again. 

So the tasklet's task(Task_Name) never run after it is scheduled. Anyone
know sth about this situation?



Thanks,
