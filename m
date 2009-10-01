From: Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] mptsas: Fix issue with chain pools allocation on katmai
Date: Thu,  1 Oct 2009 11:57:35 +0200
Message-ID: <1254391055-7321-1-git-send-email-agust@denx.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:38033 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbZJAJ5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 05:57:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>

After commit 9d2e9d66 mptsas driver fails to allocate
memory for the MPT chain buffers for second adapter on
PPC440SPe Katmai platform:
...
ioc1: LSISAS1068E B3: Capabilities={Initiator}
mptbase: ioc1: ERROR - Unable to allocate Reply, Request, Chain Buffers!
mptbase: ioc1: ERROR - didn't initialize properly! (-3)
mptsas: probe of 0002:31:00.0 failed with error -3

This commit increased MPT_FC_CAN_QUEUE value but initChainBuffers()
doesn't differentiate between SAS and FC causing increased allocation
for SAS case, too. Later pci_alloc_consistent() fails to allocate
increased chain buffer pool size for SAS case.
This patch is an attempt to fix it.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/message/fusion/mptbase.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 610e914..b6992b7 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4330,6 +4330,8 @@ initChainBuffers(MPT_ADAPTER *ioc)
 
 	if (ioc->bus_type == SPI)
 		num_chain *= MPT_SCSI_CAN_QUEUE;
+	else if (ioc->bus_type == SAS)
+		num_chain *= MPT_SAS_CAN_QUEUE;
 	else
 		num_chain *= MPT_FC_CAN_QUEUE;
 
-- 
1.5.6.3

