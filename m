From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] qla2xxx: double free bug in qla2x00_probe_one
Date: Fri, 16 Jan 2009 12:13:54 +0900
Message-ID: <6.0.0.20.2.20090116115911.06b02170@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:38885 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbZAPDii (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 22:38:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi.

I got double free bug at qla2x00_probe_one's error path and
kernel was panicked.
qla2x00_probe_one's probe_failed path is as follows:

 	qla2x00_free_que(ha, req, rsp);
 	qla2x00_free_device(base_vha);
 
qla2x00_free_device calls qla2x00_free_que through qla2x00_free_queues.
qla2x00_free_device frees the same pointer of req and rsp that is already 
freed by qla2x00_free_que.

Following patch fixes this problem.
Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.29-rc1.org/drivers/scsi/qla2xxx/qla_os.c linux-2.6.29-rc1.qla2x/drivers/scsi/qla2xxx/qla_os.c
--- linux-2.6.29-rc1.org/drivers/scsi/qla2xxx/qla_os.c	2009-01-15 15:37:31.000000000 +0900
+++ linux-2.6.29-rc1.qla2x/drivers/scsi/qla2xxx/qla_os.c	2009-01-16 11:52:47.000000000 +0900
@@ -1999,6 +1999,8 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 
 probe_failed:
 	qla2x00_free_que(ha, req, rsp);
+	ha->rsp_q_map[0] = NULL;
+	ha->req_q_map[0] = NULL;
 	qla2x00_free_device(base_vha);
 
 	scsi_host_put(base_vha->host);

