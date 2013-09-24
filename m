From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2] tcm_fc: Convert to per-cpu command map pre-allocation of ft_cmd
Date: Tue, 24 Sep 2013 20:33:25 +0000
Message-ID: <1380054805-2729-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:54803 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3IXUuX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Sep 2013 16:50:23 -0400
Received: by mail-ob0-f180.google.com with SMTP id wm4so5529043obc.39
        for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2013 13:50:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: Open-FCoE devel <devel@open-fcoe.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@daterainc.com>, Mark Rustad <mark.d.rustad@intel.com>, Robert Love <robert.w.love@intel.com>, Kent Overstreet <kmo@daterainc.com>

From: Nicholas Bellinger <nab@daterainc.com>

This patch converts tcm_fc to use transport_init_session_tags()
pre-allocation logic for struct ft_cmd descriptors using per-cpu
session tag pooling in order to effectively avoid memory allocation
+ release for each received I/O.

It adds percpu_ida_alloc() in ft_recv_cmd() to obtain an tag and
locate ft_cmd from se_sess->sess_cmd_map[], and percpu_ida_free()
in ft_free_cmd() to release the tag based upon se_cmd->map_tag id.

It also uses a TCM_FC_DEFAULT_TAGS value of 512, that puts the
per se_sess->sess_cmd_map allocation at ~360K on 64-bit.

v2 changes:

  - Handle possible tag < 0 failure with GFP_ATOMIC

Cc: Mark Rustad <mark.d.rustad@intel.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/tcm_fc/tcm_fc.h   |    1 +
 drivers/target/tcm_fc/tfc_cmd.c  |   18 ++++++++++++++----
 drivers/target/tcm_fc/tfc_sess.c |    3 ++-
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 0dd54a4..752863a 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -22,6 +22,7 @@
 #define FT_NAMELEN 32		/* length of ASCII WWPNs including pad */
 #define FT_TPG_NAMELEN 32	/* max length of TPG name */
 #define FT_LUN_NAMELEN 32	/* max length of LUN name */
+#define TCM_FC_DEFAULT_TAGS 512	/* tags used for per-session preallocation */
 
 struct ft_transport_id {
 	__u8	format;
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 0e5a1cae..479ec56 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -28,6 +28,7 @@
 #include <linux/configfs.h>
 #include <linux/ctype.h>
 #include <linux/hash.h>
+#include <linux/percpu_ida.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -89,16 +90,18 @@ static void ft_free_cmd(struct ft_cmd *cmd)
 {
 	struct fc_frame *fp;
 	struct fc_lport *lport;
+	struct se_session *se_sess;
 
 	if (!cmd)
 		return;
+	se_sess = cmd->sess->se_sess;
 	fp = cmd->req_frame;
 	lport = fr_dev(fp);
 	if (fr_seq(fp))
 		lport->tt.seq_release(fr_seq(fp));
 	fc_frame_free(fp);
+	percpu_ida_free(&se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
 	ft_sess_put(cmd->sess);	/* undo get from lookup at recv */
-	kfree(cmd);
 }
 
 void ft_release_cmd(struct se_cmd *se_cmd)
@@ -432,14 +435,21 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 {
 	struct ft_cmd *cmd;
 	struct fc_lport *lport = sess->tport->lport;
+	struct se_session *se_sess = sess->se_sess;
+	int tag;
 
-	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
-	if (!cmd)
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, GFP_ATOMIC);
+	if (tag < 0)
 		goto busy;
+
+	cmd = &((struct ft_cmd *)se_sess->sess_cmd_map)[tag];
+	memset(cmd, 0, sizeof(struct ft_cmd));
+
+	cmd->se_cmd.map_tag = tag;
 	cmd->sess = sess;
 	cmd->seq = lport->tt.seq_assign(lport, fp);
 	if (!cmd->seq) {
-		kfree(cmd);
+		percpu_ida_free(&se_sess->sess_tag_pool, tag);
 		goto busy;
 	}
 	cmd->req_frame = fp;		/* hold frame during cmd */
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4859505..ae52c08 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -210,7 +210,8 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 	if (!sess)
 		return NULL;
 
-	sess->se_sess = transport_init_session();
+	sess->se_sess = transport_init_session_tags(TCM_FC_DEFAULT_TAGS,
+						    sizeof(struct ft_cmd));
 	if (IS_ERR(sess->se_sess)) {
 		kfree(sess);
 		return NULL;
-- 
1.7.10.4

