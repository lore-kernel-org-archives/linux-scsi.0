From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2] scsi/bfa: use designated initializers
Date: Wed, 29 Mar 2017 13:55:09 -0700
Message-ID: <20170329205509.GA39525@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This has been updated now that struct bfa_fcs_mod_s was dropped.
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 29 ++++++++++++++++++++---------
 drivers/scsi/bfa/bfa_modules.h   | 12 ++++++------
 2 files changed, 26 insertions(+), 15 deletions(-)

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
Pixel Security
