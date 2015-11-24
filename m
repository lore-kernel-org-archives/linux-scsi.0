From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH] qla2xxx: Fix regression introduced by configFS changes
Date: Tue, 24 Nov 2015 12:20:15 -0500
Message-ID: <1448385615-18246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:10364 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753744AbbKXSAL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 13:00:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, nab@linux-iscsi.org, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com

this patch fixes following regression

 # targetcli
 [Errno 13] Permission denied: '/sys/kernel/config/target/qla2xxx/21:00:00:0e:1e:08:c7:20/tpgt_1/enable'

Fixes: 2eafd72939fd ("target: use per-attribute show and store methods")
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 3ba2e95..81af294 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -902,7 +902,7 @@ static ssize_t tcm_qla2xxx_tpg_fabric_prot_type_show(struct config_item *item,
 	return sprintf(page, "%d\n", tpg->tpg_attrib.fabric_prot_type);
 }
 
-CONFIGFS_ATTR_WO(tcm_qla2xxx_tpg_, enable);
+CONFIGFS_ATTR(tcm_qla2xxx_tpg_, enable);
 CONFIGFS_ATTR_RO(tcm_qla2xxx_tpg_, dynamic_sessions);
 CONFIGFS_ATTR(tcm_qla2xxx_tpg_, fabric_prot_type);
 
-- 
1.7.7

