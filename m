From: Joe Perches <joe@perches.com>
Subject: [PATCH next 10/16] drivers/scsi: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:23:56 -0700
Message-ID: <3507174cc441fe502402e4e85e372eacb01a1f0c.1284435710.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jing Huang <huangj@brocade.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bfa/rport.c        |    4 +++-
 drivers/scsi/pcmcia/nsp_debug.c |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c   |    4 ++--
 drivers/scsi/qla4xxx/ql4_nx.c   |    2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/rport.c b/drivers/scsi/bfa/rport.c
index 9b4c2c9..803f29e 100644
--- a/drivers/scsi/bfa/rport.c
+++ b/drivers/scsi/bfa/rport.c
@@ -2068,7 +2068,9 @@ bfa_fcs_rport_aen_post(struct bfa_fcs_rport_s *rport,
 	wwn_t           rpwwn = rport->pwwn;
 	char            lpwwn_ptr[BFA_STRING_32];
 	char            rpwwn_ptr[BFA_STRING_32];
-	char           *prio_str[] = { "unknown", "high", "medium", "low" };
+	static const char * const prio_str[] = {
+		"unknown", "high", "medium", "low"
+	};
 
 	wwn2str(lpwwn_ptr, lpwwn);
 	wwn2str(rpwwn_ptr, rpwwn);
diff --git a/drivers/scsi/pcmcia/nsp_debug.c b/drivers/scsi/pcmcia/nsp_debug.c
index 3c6ef64..dbd567c 100644
--- a/drivers/scsi/pcmcia/nsp_debug.c
+++ b/drivers/scsi/pcmcia/nsp_debug.c
@@ -147,7 +147,7 @@ static void show_phase(struct scsi_cmnd *SCpnt)
 {
 	int i = SCpnt->SCp.phase;
 
-	char *ph[] = {
+	static const char * const ph[] = {
 		"PH_UNDETERMINED",
 		"PH_ARBSTART",
 		"PH_SELSTART",
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index c5ac876..7525e95 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -327,8 +327,8 @@ unsigned qla82xx_crb_hub_agt[64] = {
 };
 
 /* Device states */
-char *qdev_state[] = {
-	 "Unknown",
+static const char * const qdev_state[] = {
+	"Unknown",
 	"Cold",
 	"Initializing",
 	"Ready",
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 5d4a382..77ee640 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -332,7 +332,7 @@ static unsigned qla4_8xxx_crb_hub_agt[64] = {
 };
 
 /* Device states */
-static char *qdev_state[] = {
+static const char * const qdev_state[] = {
 	"Unknown",
 	"Cold",
 	"Initializing",
-- 
1.7.3.rc1
