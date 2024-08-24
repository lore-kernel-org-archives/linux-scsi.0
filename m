Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F7E64A;
	Sat, 24 Aug 2024 08:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724489424; cv=none; b=GmGwROiwh1cz9enN2MTRb5oPM8d8QLe8cINWO6uubIz03+kKHGKlyKbAD4XVpF51gWfpBhNlLUuaHKdiEedTT1ppxUMezciBPWp3IH+B81AWOtqZ0LgFA0vY76w/JvLL3gM1K195gzQlat/JvG5NzxCIE8S6DEH1qACv+qF9X8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724489424; c=relaxed/simple;
	bh=ktjUn6JSbP8cOaxNgNKbBqIwbeWwCGeUPh0a450dJUY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WDod7IldnhgPPZhmwXyk2sasOs6uNXGXIevpcRuzFWl772C1XJ0P4+zKkESi+PLkY4uU7UbqJIHh61+LZvcgIhBOpanhIgjqxvONJuB8EGmi0j9Gd89jEALDUyRKasdVGZcqQvKVJNfBr3R1nc4DggcvihIoQMLAhvV563VHD9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WrVxw2Jpgz2CnLq;
	Sat, 24 Aug 2024 16:50:12 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 6327D1401F2;
	Sat, 24 Aug 2024 16:50:18 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 24 Aug
 2024 16:50:17 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <njavali@marvell.com>, <mrangankar@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<yuehaibing@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] scsi: bnx2i: Remove unused declarations
Date: Sat, 24 Aug 2024 16:47:24 +0800
Message-ID: <20240824084724.3647307-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Commit cf4e6363859d ("[SCSI] bnx2i: Add bnx2i iSCSI driver.") declared but
never implemented these.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/scsi/bnx2i/bnx2i.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index df7d04afce05..7030efee5c46 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -815,11 +815,6 @@ extern struct bnx2i_hba *get_adapter_list_head(void);
 struct bnx2i_conn *bnx2i_get_conn_from_id(struct bnx2i_hba *hba,
 					  u16 iscsi_cid);
 
-int bnx2i_alloc_ep_pool(void);
-void bnx2i_release_ep_pool(void);
-struct bnx2i_endpoint *bnx2i_ep_ofld_list_next(struct bnx2i_hba *hba);
-struct bnx2i_endpoint *bnx2i_ep_destroy_list_next(struct bnx2i_hba *hba);
-
 struct bnx2i_hba *bnx2i_find_hba_for_cnic(struct cnic_dev *cnic);
 
 struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic);
@@ -869,12 +864,6 @@ extern int bnx2i_arm_cq_event_coalescing(struct bnx2i_endpoint *ep, u8 action);
 
 extern int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep);
 
-/* Debug related function prototypes */
-extern void bnx2i_print_pend_cmd_queue(struct bnx2i_conn *conn);
-extern void bnx2i_print_active_cmd_queue(struct bnx2i_conn *conn);
-extern void bnx2i_print_xmit_pdu_queue(struct bnx2i_conn *conn);
-extern void bnx2i_print_recv_state(struct bnx2i_conn *conn);
-
 extern int bnx2i_percpu_io_thread(void *arg);
 extern int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
 				       struct bnx2i_conn *bnx2i_conn,
-- 
2.34.1

