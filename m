Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C36C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D06ED21D7D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JPMkfn8l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfLRX61 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:58:27 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43549 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfLRX61 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 18:58:27 -0500
Received: by mail-wr1-f67.google.com with SMTP id d16so4117523wre.10
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 15:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O49Ag5VRDsphU4yxE3eesJgJKoIZb9gFWDdaiuAHDUQ=;
        b=JPMkfn8lL3Vj5Z5YxSgqps6EYFSCaIwuMTms4X5M3QkEJyZaGRFBK52Hgh5kWxFSUH
         UPWBsCpGakjuPIHvRmX2toRw0XEJMr/WNnqEhkHdzYqt7m/k6AIsezuLKfCKNFqFtCJ0
         6EKPif2bTC6cT9dSIVVBTmnqsianakFvybMovd/uTKhCTMjWsr9HBc3VXT4bcJMoGjWk
         Jie68P+jmIK8h0t9wDDUUf+FIPynFKelEd41rBqK2CnCGafVCXVRh0nkgPPb3x3oeJ4I
         +P4VzY/YM5dXLyC1YU1HSR/Ebc6Q17XqCdrYghTLyCGRUTEEU4kEW0kEyXB2epPgd0/R
         m6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O49Ag5VRDsphU4yxE3eesJgJKoIZb9gFWDdaiuAHDUQ=;
        b=FUngjsZKbz38gMto4a9auTlpfkhZ+8wcqe1aXWo5PTU+TuSuWw17PpK6rjB9lGK7qR
         EeDf6IsusEF39OtQKB4VEtDkhYLXRdBTKwRensJyPxvcM1o+Ft0lTdL6/C6MIuefDcYU
         0gY4PIqpS+GZa5r2VNODZZ7oeqtPNS81Przx2cFii0AE3yFeAgRV9BGmio9D445eqxz9
         CGeg0/m4wCwcAvS3SYZ0+OzQkuD7Eo3rBCpSlDIyWNFxh8s/dbpGtHVDJsTcnCVRduNv
         bg1ADhDBaAAnWUZnRFjIafYfn6JK8gPErn5b1mPmum8LgPTmUkTFSEWgP8b55hX3jMxh
         aveA==
X-Gm-Message-State: APjAAAUlL+39iHMyCsCkgO/leGn/D0uje71kT9dHDbapB9tg8SVTeiuF
        jFB6l67XHlYWg5Xkp/LRjLAmKrg8
X-Google-Smtp-Source: APXvYqw3afF4PdaWr4KNOKAM41Rzq7g17zuxHzOsvRjR04F5a/Hrx5mbISP9SKvJNHF2+UhBHmQajg==
X-Received: by 2002:adf:81e3:: with SMTP id 90mr5725742wra.23.1576713504690;
        Wed, 18 Dec 2019 15:58:24 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x11sm4240731wmg.46.2019.12.18.15.58.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Dec 2019 15:58:24 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 04/10] lpfc: Fix Fabric hostname registration if system hostname changes
Date:   Wed, 18 Dec 2019 15:58:02 -0800
Message-Id: <20191218235808.31922-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191218235808.31922-1-jsmart2021@gmail.com>
References: <20191218235808.31922-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are reports of multiple ports on the same system displaying
different hostnames in fabric FDMI displays.

Currently, the driver registers the hostname at initialization and
obtains the hostname via init_utsname()->nodename queried at the time
the FC link comes up. Unfortunately, if the machine hostname is updated
after initialization, such as via DHCP or admin command, the value
registered initially will be incorrect.

Fix by having the driver save the hostname that was registered with FDMI.
The driver then runs a heartbeat action that will check the hostname.
If the name changes, reregister the FMDI data.

The hostname is used in RSNN_NN, FDMI RPA and FDMI RHBA.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |  2 ++
 drivers/scsi/lpfc/lpfc_crtn.h    |  2 +-
 drivers/scsi/lpfc/lpfc_ct.c      | 48 +++++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  5 +++++
 drivers/scsi/lpfc/lpfc_init.c    |  2 +-
 5 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 935f98804198..04d73e2be373 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1223,6 +1223,8 @@ struct lpfc_hba {
 #define LPFC_POLL_HB	1		/* slowpath heartbeat */
 #define LPFC_POLL_FASTPATH	0	/* called from fastpath */
 #define LPFC_POLL_SLOWPATH	1	/* called from slowpath */
+
+	char os_host_name[MAXHOSTNAMELEN];
 };
 
 static inline struct Scsi_Host *
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index ee353c84a097..25d3dd39bc05 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -180,7 +180,7 @@ int lpfc_issue_gidft(struct lpfc_vport *vport);
 int lpfc_get_gidft_type(struct lpfc_vport *vport, struct lpfc_iocbq *iocbq);
 int lpfc_ns_cmd(struct lpfc_vport *, int, uint8_t, uint32_t);
 int lpfc_fdmi_cmd(struct lpfc_vport *, struct lpfc_nodelist *, int, uint32_t);
-void lpfc_fdmi_num_disc_check(struct lpfc_vport *);
+void lpfc_fdmi_change_check(struct lpfc_vport *vport);
 void lpfc_delayed_disc_tmo(struct timer_list *);
 void lpfc_delayed_disc_timeout_handler(struct lpfc_vport *);
 
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 1b4dbb28fb41..58b35a1442c1 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1511,7 +1511,7 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
 	if (strlcat(symbol, tmp, size) >= size)
 		goto buffer_done;
 
-	scnprintf(tmp, sizeof(tmp), " HN:%s", init_utsname()->nodename);
+	scnprintf(tmp, sizeof(tmp), " HN:%s", vport->phba->os_host_name);
 	if (strlcat(symbol, tmp, size) >= size)
 		goto buffer_done;
 
@@ -2000,14 +2000,16 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 
 /**
- * lpfc_fdmi_num_disc_check - Check how many mapped NPorts we are connected to
+ * lpfc_fdmi_change_check - Check for changed FDMI parameters
  * @vport: pointer to a host virtual N_Port data structure.
  *
- * Called from hbeat timeout routine to check if the number of discovered
- * ports has changed. If so, re-register thar port Attribute.
+ * Check how many mapped NPorts we are connected to
+ * Check if our hostname changed
+ * Called from hbeat timeout routine to check if any FDMI parameters
+ * changed. If so, re-register those Attributes.
  */
 void
-lpfc_fdmi_num_disc_check(struct lpfc_vport *vport)
+lpfc_fdmi_change_check(struct lpfc_vport *vport)
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_nodelist *ndlp;
@@ -2020,17 +2022,41 @@ lpfc_fdmi_num_disc_check(struct lpfc_vport *vport)
 	if (!(vport->fc_flag & FC_FABRIC))
 		return;
 
+	ndlp = lpfc_findnode_did(vport, FDMI_DID);
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+		return;
+
+	/* Check if system hostname changed */
+	if (strcmp(phba->os_host_name, init_utsname()->nodename)) {
+		memset(phba->os_host_name, 0, sizeof(phba->os_host_name));
+		scnprintf(phba->os_host_name, sizeof(phba->os_host_name), "%s",
+			  init_utsname()->nodename);
+		lpfc_ns_cmd(vport, SLI_CTNS_RSNN_NN, 0, 0);
+
+		/* Since this effects multiple HBA and PORT attributes, we need
+		 * de-register and go thru the whole FDMI registration cycle.
+		 * DHBA -> DPRT -> RHBA -> RPA  (physical port)
+		 * DPRT -> RPRT (vports)
+		 */
+		if (vport->port_type == LPFC_PHYSICAL_PORT)
+			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA, 0);
+		else
+			lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DPRT, 0);
+
+		/* Since this code path registers all the port attributes
+		 * we can just return without further checking.
+		 */
+		return;
+	}
+
 	if (!(vport->fdmi_port_mask & LPFC_FDMI_PORT_ATTR_num_disc))
 		return;
 
+	/* Check if the number of mapped NPorts changed */
 	cnt = lpfc_find_map_node(vport);
 	if (cnt == vport->fdmi_num_disc)
 		return;
 
-	ndlp = lpfc_findnode_did(vport, FDMI_DID);
-	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
-		return;
-
 	if (vport->port_type == LPFC_PHYSICAL_PORT) {
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RPA,
 			      LPFC_FDMI_PORT_ATTR_num_disc);
@@ -2618,8 +2644,8 @@ lpfc_fdmi_port_attr_host_name(struct lpfc_vport *vport,
 	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
 	memset(ae, 0, 256);
 
-	snprintf(ae->un.AttrString, sizeof(ae->un.AttrString), "%s",
-		 init_utsname()->nodename);
+	scnprintf(ae->un.AttrString, sizeof(ae->un.AttrString), "%s",
+		  vport->phba->os_host_name);
 
 	len = strnlen(ae->un.AttrString, sizeof(ae->un.AttrString));
 	len += (len & 3) ? (4 - (len & 3)) : 4;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 85ada3deb47d..dcc8999c6a68 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -28,6 +28,7 @@
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/lockdep.h>
+#include <linux/utsname.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -3315,6 +3316,10 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		lpfc_sli4_clear_fcf_rr_bmask(phba);
 	}
 
+	/* Prepare for LINK up registrations */
+	memset(phba->os_host_name, 0, sizeof(phba->os_host_name));
+	scnprintf(phba->os_host_name, sizeof(phba->os_host_name), "%s",
+		  init_utsname()->nodename);
 	return;
 out:
 	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6298b1729098..633ca46b0e4b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1362,7 +1362,7 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 	if (vports != NULL)
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			lpfc_rcv_seq_check_edtov(vports[i]);
-			lpfc_fdmi_num_disc_check(vports[i]);
+			lpfc_fdmi_change_check(vports[i]);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
-- 
2.13.7

