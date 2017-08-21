From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 1/2] scsi: Move scsi_cmd->jiffies_at_alloc initialization to
 allocation time
Date: Mon, 21 Aug 2017 17:40:14 -0500
Message-ID: <e605bd0d-b193-0a7c-a7f3-63d7cc49e9b9@linux.vnet.ibm.com>
References: <1502902815.3305.22.camel@abdul.in.ibm.com>
 <1502904072.2421.3.camel@wdc.com>
 <2f686064-3e32-df8d-134f-962b5181da9d@linux.vnet.ibm.com>
 <1502985161.2615.8.camel@wdc.com>
 <71fb9c1b-9f3f-acdc-8bb5-aa1240aea763@linux.vnet.ibm.com>
 <1503092473.2622.17.camel@wdc.com>
 <0f7e2114-eba1-f149-ea80-d32d8b6d212a@linux.vnet.ibm.com>
 <1503094414.2622.21.camel@wdc.com>
 <f4ec8576-f4d7-4be3-0f38-c1a9d7ef4251@linux.vnet.ibm.com>
 <21928108-3a20-577e-99c8-6da05637c158@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36575 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754035AbdHUWkU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Aug 2017 18:40:20 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7LMcmA0074670
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2017 18:40:19 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cg3uj4mun-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2017 18:40:19 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Mon, 21 Aug 2017 16:40:19 -0600
In-Reply-To: <21928108-3a20-577e-99c8-6da05637c158@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "sachinp@linux.vnet.ibm.com" <sachinp@linux.vnet.ibm.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>

This second version also sets up jiffies_at_alloc in scsi_init_request.
This has been tested without the second patch in the series and
I've confirmed I now see the following in the logs after booting:

[  121.718088] sd 1:2:0:0: timing out command, waited 120s
[  121.798081] sd 1:2:1:0: timing out command, waited 120s

Without this patch I was never seeing these messages, indicating
the retry timer code wasn't working. Also, after seeing these
messages, I've confirmed there are no longer any hung tasks
in the kernel with sysrq-w, while before, without this patch,
I would see hung tasks for the scsi_report_opcodes calls which
were getting retried forever.

8<

Move the initialization of scsi_cmd->jiffies_at_alloc to allocation
time rather than prep time. Also ensure that jiffies_at_alloc
is preserved when we go through prep. This lets us send retries
through prep again and not break the overall retry timer logic
in scsi_softirq_done.

Suggested-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

Index: linux-2.6.git/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.git.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.git/drivers/scsi/scsi_lib.c
@@ -1154,6 +1154,7 @@ void scsi_init_command(struct scsi_devic
 	void *buf = cmd->sense_buffer;
 	void *prot = cmd->prot_sdb;
 	unsigned int unchecked_isa_dma = cmd->flags & SCMD_UNCHECKED_ISA_DMA;
+	unsigned long jiffies_at_alloc = cmd->jiffies_at_alloc;
 
 	/* zero out the cmd, except for the embedded scsi_request */
 	memset((char *)cmd + sizeof(cmd->req), 0,
@@ -1164,7 +1165,7 @@ void scsi_init_command(struct scsi_devic
 	cmd->prot_sdb = prot;
 	cmd->flags = unchecked_isa_dma;
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
-	cmd->jiffies_at_alloc = jiffies;
+	cmd->jiffies_at_alloc = jiffies_at_alloc;
 
 	scsi_add_cmd_to_list(cmd);
 }
@@ -2016,6 +2017,7 @@ static int scsi_init_request(struct blk_
 	if (!cmd->sense_buffer)
 		return -ENOMEM;
 	cmd->req.sense = cmd->sense_buffer;
+	cmd->jiffies_at_alloc = jiffies;
 
 	if (scsi_host_get_prot(shost)) {
 		sg = (void *)cmd + sizeof(struct scsi_cmnd) +
@@ -2119,6 +2121,7 @@ static int scsi_init_rq(struct request_q
 	if (!cmd->sense_buffer)
 		goto fail;
 	cmd->req.sense = cmd->sense_buffer;
+	cmd->jiffies_at_alloc = jiffies;
 
 	if (scsi_host_get_prot(shost) >= SHOST_DIX_TYPE0_PROTECTION) {
 		cmd->prot_sdb = kmem_cache_zalloc(scsi_sdb_cache, gfp);
