From: Mike Waychison <mikew@google.com>
Subject: [PATCH] qla2xxxx: Silence bogus warning for 'wrap'
Date: Fri, 30 Apr 2010 03:14:41 -0700
Message-ID: <1272622481-19802-1-git-send-email-mikew@google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13397 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab0D3Qwy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 12:52:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com
Cc: Mike Waychison <mikew@google.com>, linux-scsi@vger.kernel.org

The qla2xxx driver uses a port_id_t to mark the start of its enumerations.  gcc
is complaining that wrap.b24 may be used uninitialized, but this doesn't look
to be possible.  Silence it.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4229bb4..ea98b09 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2864,7 +2864,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 	sw_info_t	*swl;
 	int		swl_idx;
 	int		first_dev, last_dev;
-	port_id_t	wrap, nxt_d_id;
+	port_id_t	wrap = {}, nxt_d_id;
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp, *base_vha = pci_get_drvdata(ha->pdev);
 	struct scsi_qla_host *tvp;
-- 
1.7.0.1

