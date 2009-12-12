From: Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] [SCSI] mptsas: Fix issue with chain pools allocation on katmai
Date: Sat, 12 Dec 2009 14:52:21 +0100
Message-ID: <1260625941-12179-1-git-send-email-agust@denx.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:39390 "HELO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933617AbZLMBiK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2009 20:38:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>, Kashyap Desai <kashyap.desai@lsi.com>, Eric Moore <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@suse.de>

Since commit 9d2e9d66a3f032667934144cd61c396ba49f090d
mptsas driver fails to allocate memory for the MPT chain buffers
for second LSI adapter on PPC440SPe Katmai platform:
...
ioc1: LSISAS1068E B3: Capabilities={Initiator}
mptbase: ioc1: ERROR - Unable to allocate Reply, Request, Chain Buffers!
mptbase: ioc1: ERROR - didn't initialize properly! (-3)
mptsas: probe of 0002:31:00.0 failed with error -3

This commit increased MPT_FC_CAN_QUEUE value but initChainBuffers()
doesn't differentiate between SAS and FC causing increased allocation
for SAS case, too. Later pci_alloc_consistent() fails to allocate
increased chain buffer pool size for SAS case.

Provide a fix by looking at the bus type and using appropriate
MPT_SAS_CAN_QUEUE value while calculation of the number of chain
buffers.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@suse.de>
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
1.6.2.5

