From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi/bfa: use designated initializers
Date: Fri, 16 Dec 2016 17:05:15 -0800
Message-ID: <20161217010515.GA140673@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:35562 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935612AbcLQBFR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2016 20:05:17 -0500
Received: by mail-pf0-f179.google.com with SMTP id i88so16310434pfk.2
        for <linux-scsi@vger.kernel.org>; Fri, 16 Dec 2016 17:05:17 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/bfa/bfa_fcs.c       | 15 +++++++++++----
 drivers/scsi/bfa/bfa_fcs_lport.c | 29 ++++++++++++++++++++---------
 drivers/scsi/bfa/bfa_modules.h   | 12 ++++++------
 3 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 1e7e139d71ea..f8f76501af90 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -39,10 +39,17 @@ struct bfa_fcs_mod_s {
 #define BFA_FCS_MODULE(_mod) { _mod ## _modinit, _mod ## _modexit }
 
 static struct bfa_fcs_mod_s fcs_modules[] = {
-	{ bfa_fcs_port_attach, NULL, NULL },
-	{ bfa_fcs_uf_attach, NULL, NULL },
-	{ bfa_fcs_fabric_attach, bfa_fcs_fabric_modinit,
-	  bfa_fcs_fabric_modexit },
+	{
+		.attach = bfa_fcs_port_attach,
+	},
+	{
+		.attach = bfa_fcs_uf_attach,
+	},
+	{
+		.attach = bfa_fcs_fabric_attach,
+		.modinit = bfa_fcs_fabric_modinit,
+		.modexit = bfa_fcs_fabric_modexit
+	},
 };
 
 /*
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 4ddda72f60e6..64860c730ec9 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -90,15 +90,26 @@ static struct {
 	void		(*offline) (struct bfa_fcs_lport_s *port);
 } __port_action[] = {
 	{
-	bfa_fcs_lport_unknown_init, bfa_fcs_lport_unknown_online,
-			bfa_fcs_lport_unknown_offline}, {
-	bfa_fcs_lport_fab_init, bfa_fcs_lport_fab_online,
-			bfa_fcs_lport_fab_offline}, {
-	bfa_fcs_lport_n2n_init, bfa_fcs_lport_n2n_online,
-			bfa_fcs_lport_n2n_offline}, {
-	bfa_fcs_lport_loop_init, bfa_fcs_lport_loop_online,
-			bfa_fcs_lport_loop_offline},
-	};
+		.init = bfa_fcs_lport_unknown_init,
+		.online = bfa_fcs_lport_unknown_online,
+		.offline = bfa_fcs_lport_unknown_offline
+	},
+	{
+		.init = bfa_fcs_lport_fab_init,
+		.online = bfa_fcs_lport_fab_online,
+		.offline = bfa_fcs_lport_fab_offline
+	},
+	{
+		.init = bfa_fcs_lport_n2n_init,
+		.online = bfa_fcs_lport_n2n_online,
+		.offline = bfa_fcs_lport_n2n_offline
+	},
+	{
+		.init = bfa_fcs_lport_loop_init,
+		.online = bfa_fcs_lport_loop_online,
+		.offline = bfa_fcs_lport_loop_offline
+	},
+};
 
 /*
  *  fcs_port_sm FCS logical port state machine
diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
index 53135f21fa0e..640621b4c3da 100644
--- a/drivers/scsi/bfa/bfa_modules.h
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -79,12 +79,12 @@ enum {
 									\
 	extern struct bfa_module_s hal_mod_ ## __mod;			\
 	struct bfa_module_s hal_mod_ ## __mod = {			\
-		bfa_ ## __mod ## _meminfo,				\
-		bfa_ ## __mod ## _attach,				\
-		bfa_ ## __mod ## _detach,				\
-		bfa_ ## __mod ## _start,				\
-		bfa_ ## __mod ## _stop,					\
-		bfa_ ## __mod ## _iocdisable,				\
+		.meminfo = bfa_ ## __mod ## _meminfo,			\
+		.attach = bfa_ ## __mod ## _attach,			\
+		.detach = bfa_ ## __mod ## _detach,			\
+		.start = bfa_ ## __mod ## _start,			\
+		.stop = bfa_ ## __mod ## _stop,				\
+		.iocdisable = bfa_ ## __mod ## _iocdisable,		\
 	}
 
 #define BFA_CACHELINE_SZ	(256)
-- 
2.7.4


-- 
Kees Cook
Nexus Security
