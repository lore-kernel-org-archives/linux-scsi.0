From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 2/2] loopback: Enable TFO->complete_irq for fast-path ->scsi_done
Date: Fri, 22 May 2015 07:57:26 +0000
Message-ID: <1432281446-31080-3-git-send-email-nab@daterainc.com>
References: <1432281446-31080-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35136 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbbEVIAH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 04:00:07 -0400
Received: by obcus9 with SMTP id us9so7847659obc.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 01:00:06 -0700 (PDT)
In-Reply-To: <1432281446-31080-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Go ahead and enable TFO->complete_irq for testing with loopback
LLD code, and avoid the extra fast-path queue_work() context
switch if no se_cmd special case handling requirements exist.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
CC: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index bd9d11a..562906a 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1229,6 +1229,7 @@ static struct configfs_attribute *tcm_loop_wwn_attrs[] = {
 static const struct target_core_fabric_ops loop_ops = {
 	.module				= THIS_MODULE,
 	.name				= "loopback",
+	.complete_irq			= true,
 	.get_fabric_name		= tcm_loop_get_fabric_name,
 	.tpg_get_wwn			= tcm_loop_get_endpoint_wwn,
 	.tpg_get_tag			= tcm_loop_get_tag,
-- 
1.9.1

