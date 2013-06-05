From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: How to fix this sleep-inside-lock problem?
Date: Wed, 05 Jun 2013 17:54:22 +0200
Message-ID: <1370447662.26091.44.camel@br9vgx5g.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:49515 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3FEPy0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 11:54:26 -0400
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mpeschke@linux.vnet.ibm.com>;
	Wed, 5 Jun 2013 16:49:59 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id F0C6A17D8025
	for <linux-scsi@vger.kernel.org>; Wed,  5 Jun 2013 16:55:40 +0100 (BST)
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r55FsChR49938488
	for <linux-scsi@vger.kernel.org>; Wed, 5 Jun 2013 15:54:12 GMT
Received: from d06av04.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r55FsMg6005158
	for <linux-scsi@vger.kernel.org>; Wed, 5 Jun 2013 09:54:22 -0600
Received: from [9.152.224.75] (dyn-9-152-224-75.boeblingen.de.ibm.com [9.152.224.75])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id r55FsMTD005131
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 5 Jun 2013 09:54:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I would like to ask for advice, prior to submitting a patch for our lldd
zfcp, or alternatively for common code.

Someone reported this warning and function call stack:

BUG: sleeping function called from invalid context at kernel/workqueue.c:2752
in_atomic(): 1, irqs_disabled(): 1, pid: 360, name: zfcperp0.0.1700
CPU: 1 Not tainted 3.9.3+ #69
Process zfcperp0.0.1700 (pid: 360, task: 0000000075b7e080, ksp: 000000007476bc30)
<snip>
Call Trace:
([<00000000001165de>] show_trace+0x106/0x154)
 [<00000000001166a0>] show_stack+0x74/0xf4
 [<00000000006ff646>] dump_stack+0xc6/0xd4
 [<000000000017f3a0>] __might_sleep+0x128/0x148
 [<000000000015ece8>] flush_work+0x54/0x1f8
 [<00000000001630de>] __cancel_work_timer+0xc6/0x128
 [<00000000005067ac>] scsi_device_dev_release_usercontext+0x164/0x23c
 [<0000000000161816>] execute_in_process_context+0x96/0xa8
 [<00000000004d33d8>] device_release+0x60/0xc0
 [<000000000048af48>] kobject_release+0xa8/0x1c4
 [<00000000004f4bf2>] __scsi_iterate_devices+0xfa/0x130
 [<000003ff801b307a>] zfcp_erp_strategy+0x4da/0x1014 [zfcp]
 [<000003ff801b3caa>] zfcp_erp_thread+0xf6/0x2b0 [zfcp]
 [<000000000016b75a>] kthread+0xf2/0xfc
 [<000000000070c9de>] kernel_thread_starter+0x6/0xc
 [<000000000070c9d8>] kernel_thread_starter+0x0/0xc

Apparently, the ref_count for some scsi_device drops down to zero,
triggering device removal through execute_in_process_context(), while
the lldd error recovery thread iterates through a scsi device list.
Unfortunately, execute_in_process_context() decides to immediately
execute that device removal function, instead of scheduling asynchronous
execution, since it detects process context and thinks it is safe to do
so. But almost all calls to shost_for_each_device() in our lldd are
inside spin_lock_irq, even in thread context. Obviously, schedule()
inside spin_lock_irq sections is a bad idea.

Does it make sense to teach execute_in_process_context() to run a
function asynchronously when irqs are disabled, as inside a
spin_lock_irq section? If so, is the addition of an irqs_disabled()
check sufficient?

Or is it preferable to change the lldd to use __shost_for_each_device()
with shost->host_lock? (hoping that doesn't result in locking order
issues with host_lock inside our lldd erp_lock...)

Other suggestions?

The problem has been introduced when our LUN related data was moved to
the midlayer (commit b62a8d9b45b971a67a0f8413338c230e3117dff5) back in
2010.


Thanks,
Martin

