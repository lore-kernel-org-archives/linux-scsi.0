From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/3] Improve block layer scheduling fairness
Date: Mon, 28 Mar 2016 14:48:02 -0700
Message-ID: <56F9A692.2090704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0064.outbound.protection.outlook.com ([157.56.110.64]:15333
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752548AbcC1VsJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2016 17:48:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@fb.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Recent tests revealed that on kernels with CONFIG_PREEMPT disabled and 
with kernel debugging options like CONFIG_PROVE_LOCKING enabled that 
block/SCSI/dm workloads with a high queue depth cause soft lockup 
complaints to appear. Avoid this by voluntarily giving up the CPU in 
time for such workloads. The patches in this series are:

0001-kernel-kthread.c-Avoid-CPU-lockups.patch
0002-block-Limit-work-processed-in-softirq-context.patch
0003-Avoid-that-I-O-completion-processing-triggers-lockup.patch
