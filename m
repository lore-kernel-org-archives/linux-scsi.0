From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 11/12] [SCSI] mpt2sas : Fix for panic happening because of improper memory allocation
Date: Tue, 20 Mar 2012 12:10:01 +0530
Message-ID: <201203200639.q2K6dTXH000677@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:34865 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754015Ab2CTGjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 02:39:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stable@vger.kernel.org, linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: jejb@kernel.org

The ioc->pfacts member in the IOC structure is getting set to zero
following a call to _base_get_ioc_facts due to the memset in that routine.
So if the ioc->pfacts was read after a host reset, there would be a NULL
pointer dereference. The routine _base_get_ioc_facts is called from context
of host reset.  The problem in _base_get_ioc_facts  is the size of  
Mpi2IOCFactsReply is 64, whereas the sizeof "struct mpt2sas_facts" is 60,
so there is a four byte overflow resulting from the memset.

Also, there is memset in _base_get_port_facts using the incorrect structure,
it should be "struct mpt2sas_port_facts" instead of Mpi2PortFactsReply.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
CC: stable@vger.kernel.org
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index b1688c2..c226b13 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3354,7 +3354,7 @@ _base_get_port_facts(struct MPT2SAS_ADAPTER *ioc, int port, int sleep_flag)
 	}
 
 	pfacts = &ioc->pfacts[port];
-	memset(pfacts, 0, sizeof(Mpi2PortFactsReply_t));
+	memset(pfacts, 0, sizeof(struct mpt2sas_port_facts));
 	pfacts->PortNumber = mpi_reply.PortNumber;
 	pfacts->VP_ID = mpi_reply.VP_ID;
 	pfacts->VF_ID = mpi_reply.VF_ID;
@@ -3396,7 +3396,7 @@ _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	}
 
 	facts = &ioc->facts;
-	memset(facts, 0, sizeof(Mpi2IOCFactsReply_t));
+	memset(facts, 0, sizeof(struct mpt2sas_facts));
 	facts->MsgVersion = le16_to_cpu(mpi_reply.MsgVersion);
 	facts->HeaderVersion = le16_to_cpu(mpi_reply.HeaderVersion);
 	facts->VP_ID = mpi_reply.VP_ID;
@@ -4273,7 +4273,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 		goto out_free_resources;
 
 	ioc->pfacts = kcalloc(ioc->facts.NumberOfPorts,
-	    sizeof(Mpi2PortFactsReply_t), GFP_KERNEL);
+	    sizeof(struct mpt2sas_port_facts), GFP_KERNEL);
 	if (!ioc->pfacts) {
 		r = -ENOMEM;
 		goto out_free_resources;
