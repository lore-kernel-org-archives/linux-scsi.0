From: Bart Van Assche <bvanassche@acm.org>
Subject: Reducing I/O latency
Date: Thu, 17 May 2012 16:39:39 +0000
Message-ID: <4FB529CB.7050507@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:47625 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967087Ab2EQQjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 12:39:44 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by relay04ant.iops.be (Postfix) with ESMTP id D690361B90A6
	for <linux-scsi@vger.kernel.org>; Thu, 17 May 2012 18:39:42 +0200 (CEST)
Received: from relay04ant.iops.be ([127.0.0.1])
	by localhost (bdell029.dcn.iops.be [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id vTq+Q3RZBebV for <linux-scsi@vger.kernel.org>;
	Thu, 17 May 2012 18:39:41 +0200 (CEST)
Received: from [192.168.3.246] (cust-147-89-110-94.dyn.as47377.net [94.110.89.147])
	by relay04ant.iops.be (Postfix) with ESMTP id D993E61B90A2
	for <linux-scsi@vger.kernel.org>; Thu, 17 May 2012 18:39:39 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

Recently I have been looking for opportunities to reduce command
processing latency in the Linux SCSI initiator stack. I've noticed the
following:
- In drivers/scsi/scsi.c memory for the SCSI command and the SCSI sense
  data are allocated separately. Would it be a good idea to combine
  scsi_host_cmd_pool.cmd_slab and scsi_host_cmd_pool.sense_slab into a
  single kmem_cache or would this break something ?
- While running an I/O workload that was using eight LUNs (two hosts
  with four LUNs each) I noticed huge lock contention on the spinlock in
  scsi_host_cmd_pool.cmd_slab. Has anyone already tried to modify the
  code in drivers/scsi/scsi.c such that there is one pool per LUN
  instead of one pool for all LUNs of all hosts ? Note: the
  scsi_sg_pools array in drivers/scsi/scsi_lib.c is also shared over
  all LUNs.

Thanks,

Bart.
