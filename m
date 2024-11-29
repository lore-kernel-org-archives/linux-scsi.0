Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6397019753F;
	Fri, 29 Nov 2024 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894356; cv=none; b=AKG4Dcl7k9YEuSe91JO1aZP5C7EdPIBwf16DPq9KzI3LudGHbUEKW/bQaiQn6fTKJQoy6aiXwaE/RoWq58chG0x03t3NRsHcBZX6war+U8CuAF3GN39+Vq6iZQXzBB8W79EVJOywKi+Yes2minbxqDy3OXSGv8LbKcTDnKEiXLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894356; c=relaxed/simple;
	bh=x5OeOfHpbzUP4XnRVrgznGbFNrXo76hwXTCk/rdNpJ4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BI0gSzOTIJQ6nljpjlwZuIz3tmIxpK/fd+9jBkX0mutavo2IGQilAN1pSNsWY1jf2+u9a9VmbI0IxocI75Um8X4R+nHr3im5TX5kxdLmXlhruKuzk1/3cx1cLNNnb+d+4ng92FoEO2WqrZkxKi1Fpegq6/cqqm/TCxWU68dwOEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=Yd5W4FNq; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=hHXo+c00; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="Yd5W4FNq";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="hHXo+c00"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com BDB6DE0008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1732894346; bh=HmKLTtCgr89EpuzSubaqIIUcVQZg1BjHSrlAlHKQ8T4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=Yd5W4FNqfV0KJN9F2N9cw7Jw33WRmAYMyFfQpeNt1zDUkS1udeAnjWsYVoBs1lYhc
	 xH+imdNjNrkjdg/YCxcqnuBVjZa6Vholt7z1vYJ+pJemLGDClSMfPUx5zkj5aeDA5D
	 6ClUqXTu4inVHSA9mlsehbBcAKA+kiU/09arfkhNG3k7dMB7gsA7igfIJPoCSRIKSf
	 1AMtnp+/zLeT9Z2+CIwcg2X/qFwuqnSOZLzyWHg7Fn9zUXs2Ae38XJkMBsQSnN+m2G
	 MSRQWRcg4+seuevTP78jvFFbEZYzzXMCR9DDc+/jca//fF5Rev+LVtSAlBTvF2Y2gR
	 lvbJBScMNnAMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1732894346; bh=HmKLTtCgr89EpuzSubaqIIUcVQZg1BjHSrlAlHKQ8T4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=hHXo+c00NusXVx47cbBYIfUdIbuKfnEQUxJuX8Jxfdu12T3PH90YW6M7zLVn/aMi9
	 Y4i/J5IaUhDeW5U+6mTjSgbqomy5O/zLK7ywE+VQ7SidgxcOWn2HWA7WdFyhKxuaqG
	 6Gx1qGnUuef1W1aicQWhEphXiWBA5SPhXOpTHO4wIgBsPGUwWUIAy2oyBmYbDAj/6X
	 EJ1W/MS+e2IdTcykEBj/LpMRYvks8t0ps6SWPIRCtRUAktXVXe0k1sJbyubxPH2Srz
	 Kw/J36OlBzEwSSiB3kDwFdslOzsmErD24UVfHTx02uh3ri2sPy+BfTgMFXVF87oezO
	 UzM9dP70JSQig==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <martin.petersen@oracle.com>, <bootc@bootc.net>, <bostroesser@gmail.com>,
	<michael.christie@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 05/10] target: Add log prefix to all tcm files
Date: Fri, 29 Nov 2024 18:30:51 +0300
Message-ID: <20241129153056.6985-6-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
In-Reply-To: <20241129153056.6985-1-a.kovaleva@yadro.com>
References: <20241129153056.6985-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-Exch-05.corp.yadro.com (172.17.10.109) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Add prefix for wrapper to log the exact fabric.

This patch was made automatically by this zsh script:

........................................................................
dir="/path/to/kernel/src/drivers/target"
prefix=""

for file in $dir/**/*.c; do
        if [[ "$file" == *"tcm_fc"* ]]; then
                prefix="tcm_fc"
        elif [[ "$file" == *"cxgbit"* ]]; then
                prefix="cxgbit"
        elif [[ "$file" == *"loopback"* ]]; then
                prefix="loopback"
        elif [[ "$file" == *"sbp"* ]]; then
                prefix="sbp"
	elif [[ "$file" == *"iscsi_target_configfs"* ]]; then
		prefix="iscsi configfs"
	elif [[ "$file" == *"iscsi"* ]]; then
                prefix="iscsi"
        elif [[ "$file" == *"remote"* ]]; then
                prefix="remote"
        elif [[ "$file" == *"iblock"* ]]; then
                prefix="iblock"
        elif [[ "$file" == *"file"* ]]; then
                prefix="file"
        elif [[ "$file" == *"pscsi"* ]]; then
                prefix="pscsi"
        elif [[ "$file" == *"rd"* ]]; then
                prefix="rd"
	elif [[ "$file" == *"target_core_configfs"* ]]; then
		prefix="core configfs"
	elif [[ "$file" == *"core_xcopy"* ]]; then
		prefix="core xcopy"
	elif [[ "$file" == *"core_user"* ]]; then
		prefix="core user"
        else
                prefix="core"
        fi
        line="\n\n#define TARGET_PREFIX \"$prefix\""
        sed -i '/#include[^\n]*/,$!b;//{x;//p;g};//!H;$!d;x;s//&'"$line"'/' $file
done
........................................................................

You may not check it manually.

Note: Tne only place where I have manually added prefix is cxgbit_main.c
because of #ifdef directive.

Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c           | 2 ++
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c          | 2 ++
 drivers/target/iscsi/cxgbit/cxgbit_main.c         | 2 ++
 drivers/target/iscsi/cxgbit/cxgbit_target.c       | 2 ++
 drivers/target/iscsi/iscsi_target.c               | 2 ++
 drivers/target/iscsi/iscsi_target_auth.c          | 2 ++
 drivers/target/iscsi/iscsi_target_configfs.c      | 2 ++
 drivers/target/iscsi/iscsi_target_datain_values.c | 2 ++
 drivers/target/iscsi/iscsi_target_device.c        | 2 ++
 drivers/target/iscsi/iscsi_target_erl0.c          | 2 ++
 drivers/target/iscsi/iscsi_target_erl1.c          | 2 ++
 drivers/target/iscsi/iscsi_target_erl2.c          | 2 ++
 drivers/target/iscsi/iscsi_target_login.c         | 2 ++
 drivers/target/iscsi/iscsi_target_nego.c          | 2 ++
 drivers/target/iscsi/iscsi_target_nodeattrib.c    | 2 ++
 drivers/target/iscsi/iscsi_target_parameters.c    | 2 ++
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  | 2 ++
 drivers/target/iscsi/iscsi_target_stat.c          | 2 ++
 drivers/target/iscsi/iscsi_target_tmr.c           | 2 ++
 drivers/target/iscsi/iscsi_target_tpg.c           | 2 ++
 drivers/target/iscsi/iscsi_target_transport.c     | 2 ++
 drivers/target/iscsi/iscsi_target_util.c          | 2 ++
 drivers/target/loopback/tcm_loop.c                | 2 ++
 drivers/target/sbp/sbp_target.c                   | 2 ++
 drivers/target/target_core_alua.c                 | 2 ++
 drivers/target/target_core_configfs.c             | 2 ++
 drivers/target/target_core_device.c               | 2 ++
 drivers/target/target_core_fabric_configfs.c      | 2 ++
 drivers/target/target_core_fabric_lib.c           | 2 ++
 drivers/target/target_core_file.c                 | 2 ++
 drivers/target/target_core_hba.c                  | 2 ++
 drivers/target/target_core_iblock.c               | 2 ++
 drivers/target/target_core_pr.c                   | 2 ++
 drivers/target/target_core_pscsi.c                | 2 ++
 drivers/target/target_core_rd.c                   | 2 ++
 drivers/target/target_core_sbc.c                  | 2 ++
 drivers/target/target_core_spc.c                  | 2 ++
 drivers/target/target_core_stat.c                 | 2 ++
 drivers/target/target_core_tmr.c                  | 2 ++
 drivers/target/target_core_tpg.c                  | 2 ++
 drivers/target/target_core_transport.c            | 2 ++
 drivers/target/target_core_ua.c                   | 2 ++
 drivers/target/target_core_user.c                 | 2 ++
 drivers/target/target_core_xcopy.c                | 2 ++
 drivers/target/tcm_fc/tfc_cmd.c                   | 2 ++
 drivers/target/tcm_fc/tfc_conf.c                  | 2 ++
 drivers/target/tcm_fc/tfc_io.c                    | 2 ++
 drivers/target/tcm_fc/tfc_sess.c                  | 2 ++
 drivers/target/tcm_remote/tcm_remote.c            | 2 ++
 49 files changed, 98 insertions(+)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index 036e275de088..3d5445247f94 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -25,6 +25,8 @@
 #include "cxgbit.h"
 #include "clip_tbl.h"
 
+#define TARGET_PREFIX "cxgbit"
+
 static void cxgbit_init_wr_wait(struct cxgbit_wr_wait *wr_waitp)
 {
 	wr_waitp->ret = 0;
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index 3fd56f1484d8..e981f2175f98 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -5,6 +5,8 @@
 
 #include "cxgbit.h"
 
+#define TARGET_PREFIX "cxgbit"
+
 static void
 cxgbit_set_one_ppod(struct cxgbi_pagepod *ppod,
 		    struct cxgbi_task_tag_info *ttinfo,
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_main.c b/drivers/target/iscsi/cxgbit/cxgbit_main.c
index 4e8097002679..4ab4b8a4c639 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_main.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_main.c
@@ -14,6 +14,8 @@
 #include "cxgb4_dcb.h"
 #endif
 
+#define TARGET_PREFIX "cxgbit"
+
 LIST_HEAD(cdev_list_head);
 /* cdev list lock */
 DEFINE_MUTEX(cdev_list_lock);
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 826b951ed7c2..cff4bfb16810 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -13,6 +13,8 @@
 #include <target/target_core_fabric.h>
 #include "cxgbit.h"
 
+#define TARGET_PREFIX "cxgbit"
+
 struct sge_opaque_hdr {
 	void *dev;
 	dma_addr_t addr[MAX_SKB_FRAGS + 1];
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 0ad150d92805..c67ac066a7c9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -44,6 +44,8 @@
 
 #include <target/iscsi/iscsi_transport.h>
 
+#define TARGET_PREFIX "iscsi"
+
 static LIST_HEAD(g_tiqn_list);
 static LIST_HEAD(g_np_list);
 static DEFINE_SPINLOCK(tiqn_lock);
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 8308a1947605..509528c19dfe 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -18,6 +18,8 @@
 #include "iscsi_target_nego.h"
 #include "iscsi_target_auth.h"
 
+#define TARGET_PREFIX "iscsi"
+
 static char *chap_get_digest_name(const int digest_type)
 {
 	switch (digest_type) {
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index c0f63c51a6cc..7082a7ef0a00 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -28,6 +28,8 @@
 #include "iscsi_target.h"
 #include <target/iscsi/iscsi_target_stat.h>
 
+#define TARGET_PREFIX "iscsi configfs"
+
 
 /* Start items for lio_target_portal_cit */
 
diff --git a/drivers/target/iscsi/iscsi_target_datain_values.c b/drivers/target/iscsi/iscsi_target_datain_values.c
index 57e887945de4..1f067841ff4a 100644
--- a/drivers/target/iscsi/iscsi_target_datain_values.c
+++ b/drivers/target/iscsi/iscsi_target_datain_values.c
@@ -17,6 +17,8 @@
 #include "iscsi_target.h"
 #include "iscsi_target_datain_values.h"
 
+#define TARGET_PREFIX "iscsi"
+
 struct iscsi_datain_req *iscsit_allocate_datain_req(void)
 {
 	struct iscsi_datain_req *dr;
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index 466f27c93ca3..f197593ec641 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -17,6 +17,8 @@
 #include "iscsi_target_tpg.h"
 #include "iscsi_target_util.h"
 
+#define TARGET_PREFIX "iscsi"
+
 void iscsit_determine_maxcmdsn(struct iscsit_session *sess)
 {
 	struct se_node_acl *se_nacl;
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index c34a04b7e91f..48cdb2ba971d 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -23,6 +23,8 @@
 #include "iscsi_target_util.h"
 #include "iscsi_target.h"
 
+#define TARGET_PREFIX "iscsi"
+
 /*
  *	Used to set values in struct iscsit_cmd that iscsit_dataout_check_sequence()
  *	checks against to determine a PDU's Offset+Length is within the current
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 91b36e46181d..88d5671666b2 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -26,6 +26,8 @@
 #include "iscsi_target_erl2.h"
 #include "iscsi_target.h"
 
+#define TARGET_PREFIX "iscsi"
+
 #define OFFLOAD_BUF_SIZE	32768U
 
 /*
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index b28cf293b9be..aa8aef890ee2 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -22,6 +22,8 @@
 #include "iscsi_target_erl2.h"
 #include "iscsi_target.h"
 
+#define TARGET_PREFIX "iscsi"
+
 /*
  *	FIXME: Does RData SNACK apply here as well?
  */
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 1ba5af73aa01..c289c886231e 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -35,6 +35,8 @@
 
 #include <target/iscsi/iscsi_transport.h>
 
+#define TARGET_PREFIX "iscsi"
+
 static struct iscsi_login *iscsi_login_init_conn(struct iscsit_conn *conn)
 {
 	struct iscsi_login *login;
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 523b780211b3..2af5ca83ab67 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -28,6 +28,8 @@
 #include "iscsi_target.h"
 #include "iscsi_target_auth.h"
 
+#define TARGET_PREFIX "iscsi"
+
 #define MAX_LOGIN_PDUS  7
 
 void convert_null_to_semi(char *buf, int len)
diff --git a/drivers/target/iscsi/iscsi_target_nodeattrib.c b/drivers/target/iscsi/iscsi_target_nodeattrib.c
index 7a2a92d7d7bb..59cf9809ec9d 100644
--- a/drivers/target/iscsi/iscsi_target_nodeattrib.c
+++ b/drivers/target/iscsi/iscsi_target_nodeattrib.c
@@ -16,6 +16,8 @@
 #include "iscsi_target_util.h"
 #include "iscsi_target_nodeattrib.h"
 
+#define TARGET_PREFIX "iscsi"
+
 static inline char *iscsit_na_get_initiatorname(
 	struct iscsi_node_acl *nacl)
 {
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 9c2c70de8d75..9eae01538696 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -14,6 +14,8 @@
 #include "iscsi_target_util.h"
 #include "iscsi_target_parameters.h"
 
+#define TARGET_PREFIX "iscsi"
+
 int iscsi_login_rx_data(
 	struct iscsit_conn *conn,
 	char *buf,
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index e60d69199504..4194935b7aa6 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -17,6 +17,8 @@
 #include "iscsi_target_tpg.h"
 #include "iscsi_target_seq_pdu_list.h"
 
+#define TARGET_PREFIX "iscsi"
+
 #ifdef DEBUG
 static void iscsit_dump_seq_list(struct iscsit_cmd *cmd)
 {
diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
index 367c6468b8e1..91f8e1f6f912 100644
--- a/drivers/target/iscsi/iscsi_target_stat.c
+++ b/drivers/target/iscsi/iscsi_target_stat.c
@@ -21,6 +21,8 @@
 #include "iscsi_target_util.h"
 #include <target/iscsi/iscsi_target_stat.h>
 
+#define TARGET_PREFIX "iscsi"
+
 #ifndef INITIAL_JIFFIES
 #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
 #endif
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index 0382ec46c68d..eda3622e2437 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -27,6 +27,8 @@
 #include "iscsi_target_util.h"
 #include "iscsi_target.h"
 
+#define TARGET_PREFIX "iscsi"
+
 u8 iscsit_tmr_abort_task(
 	struct iscsit_cmd *cmd,
 	unsigned char *buf)
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 566132ab601e..c18f368976ac 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -22,6 +22,8 @@
 
 #include <target/iscsi/iscsi_transport.h>
 
+#define TARGET_PREFIX "iscsi"
+
 struct iscsi_portal_group *iscsit_alloc_portal_group(struct iscsi_tiqn *tiqn, u16 tpgt)
 {
 	struct iscsi_portal_group *tpg;
diff --git a/drivers/target/iscsi/iscsi_target_transport.c b/drivers/target/iscsi/iscsi_target_transport.c
index 0658388e9518..8896e4b08753 100644
--- a/drivers/target/iscsi/iscsi_target_transport.c
+++ b/drivers/target/iscsi/iscsi_target_transport.c
@@ -4,6 +4,8 @@
 #include <linux/module.h>
 #include <target/iscsi/iscsi_transport.h>
 
+#define TARGET_PREFIX "iscsi"
+
 static LIST_HEAD(g_transport_list);
 static DEFINE_MUTEX(transport_mutex);
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 04eb268b9bc9..01d74ae5fa96 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -28,6 +28,8 @@
 #include "iscsi_target_util.h"
 #include "iscsi_target.h"
 
+#define TARGET_PREFIX "iscsi"
+
 extern struct list_head g_tiqn_list;
 extern spinlock_t tiqn_lock;
 
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 0664c09de0b8..6d0e7be756d7 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -37,6 +37,8 @@
 
 #include "tcm_loop.h"
 
+#define TARGET_PREFIX "loopback"
+
 #define to_tcm_loop_hba(hba)	container_of(hba, struct tcm_loop_hba, dev)
 
 static struct kmem_cache *tcm_loop_cmd_cache;
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 4d551eefa4a6..868ddda4dcf3 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -27,6 +27,8 @@
 
 #include "sbp_target.h"
 
+#define TARGET_PREFIX "sbp"
+
 /* FireWire address region for management and command block address handlers */
 static const struct fw_address_region sbp_register_region = {
 	.start	= CSR_REGISTER_BASE + 0x10000,
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 1caddbc73631..00900189a00d 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -29,6 +29,8 @@
 #include "target_core_alua.h"
 #include "target_core_ua.h"
 
+#define TARGET_PREFIX "core"
+
 static sense_reason_t core_alua_check_transition(int state, int valid,
 						 int *primary, int explicit);
 static int core_alua_set_tg_pt_secondary_state(
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c30a8687e4c3..aaef72e44b7b 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -40,6 +40,8 @@
 #include "target_core_rd.h"
 #include "target_core_xcopy.h"
 
+#define TARGET_PREFIX "core configfs"
+
 #define TB_CIT_SETUP(_name, _item_ops, _group_ops, _attrs)		\
 static void target_core_setup_##_name##_cit(struct target_backend *tb)	\
 {									\
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index ea94ceabfadb..1d54579ecca2 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -36,6 +36,8 @@
 #include "target_core_pr.h"
 #include "target_core_ua.h"
 
+#define TARGET_PREFIX "core"
+
 static DEFINE_MUTEX(device_mutex);
 static DEFINE_IDR(devices_idr);
 
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index f4db86c41790..dec8f25c04d0 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -34,6 +34,8 @@
 #include "target_core_alua.h"
 #include "target_core_pr.h"
 
+#define TARGET_PREFIX "core"
+
 #define TF_CIT_SETUP(_name, _item_ops, _group_ops, _attrs)		\
 static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf) \
 {									\
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 36b6301808fe..b22b9448f027 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -31,6 +31,8 @@
 #include "target_core_internal.h"
 #include "target_core_pr.h"
 
+#define TARGET_PREFIX "core"
+
 
 static int sas_get_pr_transport_id(
 	struct se_node_acl *nacl,
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 902e68447c24..fd3719cac493 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -29,6 +29,8 @@
 
 #include "target_core_file.h"
 
+#define TARGET_PREFIX "file"
+
 static inline struct fd_dev *FD_DEV(struct se_device *dev)
 {
 	return container_of(dev, struct fd_dev, dev);
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 0edb17711a52..48dab83e5be3 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -26,6 +26,8 @@
 
 #include "target_core_internal.h"
 
+#define TARGET_PREFIX "core"
+
 static LIST_HEAD(backend_list);
 static DEFINE_MUTEX(backend_mutex);
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 60a07baa9729..8d71a0f5033e 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -34,6 +34,8 @@
 #include "target_core_iblock.h"
 #include "target_core_pr.h"
 
+#define TARGET_PREFIX "iblock"
+
 #define IBLOCK_MAX_BIO_PER_TASK	 32	/* max # of bios to submit at a time */
 #define IBLOCK_BIO_POOL_SIZE	128
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 8b97beffbf64..879624812573 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -29,6 +29,8 @@
 #include "target_core_pr.h"
 #include "target_core_ua.h"
 
+#define TARGET_PREFIX "core"
+
 /*
  * Used for Specify Initiator Ports Capable Bit (SPEC_I_PT)
  */
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 4f300d366edc..24e080254c6f 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -33,6 +33,8 @@
 #include "target_core_internal.h"
 #include "target_core_pscsi.h"
 
+#define TARGET_PREFIX "pscsi"
+
 static inline struct pscsi_dev_virt *PSCSI_DEV(struct se_device *dev)
 {
 	return container_of(dev, struct pscsi_dev_virt, dev);
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index cd14fcb4b0f8..6e3547847bcc 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -25,6 +25,8 @@
 
 #include "target_core_rd.h"
 
+#define TARGET_PREFIX "rd"
+
 static inline struct rd_dev *RD_DEV(struct se_device *dev)
 {
 	return container_of(dev, struct rd_dev, dev);
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 37164a9f7d32..86b9a0bc6e90 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -24,6 +24,8 @@
 #include "target_core_ua.h"
 #include "target_core_alua.h"
 
+#define TARGET_PREFIX "core"
+
 static sense_reason_t
 sbc_check_prot(struct se_device *, struct se_cmd *, unsigned char, u32, bool);
 static sense_reason_t sbc_execute_unmap(struct se_cmd *cmd);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 671d0e3122e6..ce59b5f02ef0 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -25,6 +25,8 @@
 #include "target_core_ua.h"
 #include "target_core_xcopy.h"
 
+#define TARGET_PREFIX "core"
+
 static void spc_fill_alua_data(struct se_lun *lun, unsigned char *buf)
 {
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index b0495d87e951..62daf04865c4 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -27,6 +27,8 @@
 
 #include "target_core_internal.h"
 
+#define TARGET_PREFIX "core"
+
 #ifndef INITIAL_JIFFIES
 #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
 #endif
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 0a5a09d63b48..db3b0467105d 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -23,6 +23,8 @@
 #include "target_core_alua.h"
 #include "target_core_pr.h"
 
+#define TARGET_PREFIX "core"
+
 int core_tmr_alloc_req(
 	struct se_cmd *se_cmd,
 	void *fabric_tmr_ptr,
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 5af85cd960ef..3f0b53032aeb 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -30,6 +30,8 @@
 #include "target_core_pr.h"
 #include "target_core_ua.h"
 
+#define TARGET_PREFIX "core"
+
 extern struct se_device *g_lun0_dev;
 static DEFINE_XARRAY_ALLOC(tpg_xa);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3d6d0e525bd0..13fddd94a792 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -40,6 +40,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/target.h>
 
+#define TARGET_PREFIX "core"
+
 static struct workqueue_struct *target_completion_wq;
 static struct workqueue_struct *target_submission_wq;
 static struct kmem_cache *se_sess_cache;
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index faa7a3ffec68..11d50a1da03c 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -22,6 +22,8 @@
 #include "target_core_pr.h"
 #include "target_core_ua.h"
 
+#define TARGET_PREFIX "core"
+
 sense_reason_t
 target_scsi3_ua_check(struct se_cmd *cmd)
 {
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 5d4804b9f851..c8f66ef7411b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -30,6 +30,8 @@
 
 #include <linux/target_core_user.h>
 
+#define TARGET_PREFIX "core user"
+
 /**
  * DOC: Userspace I/O
  * Userspace I/O
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 2404572beb57..971299330a98 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -30,6 +30,8 @@
 #include "target_core_ua.h"
 #include "target_core_xcopy.h"
 
+#define TARGET_PREFIX "core xcopy"
+
 static struct workqueue_struct *xcopy_wq;
 
 static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 2372f08b91c3..ad494b36d503 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -25,6 +25,8 @@
 
 #include "tcm_fc.h"
 
+#define TARGET_PREFIX "tcm_fc"
+
 /*
  * Dump cmd state for debugging.
  */
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 56b5e8947d1a..2fd6ed19fbf9 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -33,6 +33,8 @@
 
 #include "tcm_fc.h"
 
+#define TARGET_PREFIX "tcm_fc"
+
 static LIST_HEAD(ft_wwn_list);
 DEFINE_MUTEX(ft_lport_lock);
 
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 852c2bccf759..bfee5d9bfd87 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -34,6 +34,8 @@
 
 #include "tcm_fc.h"
 
+#define TARGET_PREFIX "tcm_fc"
+
 /*
  * Deliver read data back to initiator.
  * XXX TBD handle resource problems later.
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 92748e94ec29..725a3b0c9568 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -27,6 +27,8 @@
 
 #include "tcm_fc.h"
 
+#define TARGET_PREFIX "tcm_fc"
+
 #define TFC_SESS_DBG(lport, fmt, args...) \
 	target_debug("host%u: rport %6.6x: " fmt, (lport)->host->host_no, (lport)->port_id, ##args)
 
diff --git a/drivers/target/tcm_remote/tcm_remote.c b/drivers/target/tcm_remote/tcm_remote.c
index fe88c27f1b58..b978b831c6c1 100644
--- a/drivers/target/tcm_remote/tcm_remote.c
+++ b/drivers/target/tcm_remote/tcm_remote.c
@@ -17,6 +17,8 @@
 
 #include "tcm_remote.h"
 
+#define TARGET_PREFIX "remote"
+
 static inline struct tcm_remote_tpg *remote_tpg(struct se_portal_group *se_tpg)
 {
 	return container_of(se_tpg, struct tcm_remote_tpg, remote_se_tpg);
-- 
2.40.3

