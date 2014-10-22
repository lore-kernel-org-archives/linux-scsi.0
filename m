From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH 1/1] SCSI-QLA2XXX: Deletion of unnecessary
 checks before the function call "vfree"
Date: Wed, 22 Oct 2014 20:55:32 +0200
Message-ID: <5447FDA4.4020106@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <cocci-bounces@systeme.lip6.fr>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
List-Unsubscribe: <https://systeme.lip6.fr/mailman/options/cocci>,
 <mailto:cocci-request@systeme.lip6.fr?subject=unsubscribe>
List-Archive: <https://systeme.lip6.fr/pipermail/cocci>
List-Post: <mailto:cocci@systeme.lip6.fr>
List-Help: <mailto:cocci-request@systeme.lip6.fr?subject=help>
List-Subscribe: <https://systeme.lip6.fr/mailman/listinfo/cocci>,
 <mailto:cocci-request@systeme.lip6.fr?subject=subscribe>
Sender: cocci-bounces@systeme.lip6.fr
Errors-To: cocci-bounces@systeme.lip6.fr
To: "James E. J. Bottomley" <JBottomley@parallels.com>, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
List-Id: linux-scsi@vger.kernel.org

>> If you are convinced that dropping the null tests is a good idea, then you 
>> can submit the patch that makes the change to the relevant maintainers and 
>> mailing lists.

>From ff44962f88ac2dae9324e30819629da4fb33f0ff Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 22 Oct 2014 20:40:31 +0200
Subject: [PATCH] SCSI-QLA2XXX: Deletion of unnecessary checks before the
 function call "vfree"

A semantic patch approach was proposed with the subject "[PATCH with
Coccinelle?] Deletion of unnecessary checks before specific function calls"
on 2014-03-05.
https://lkml.org/lkml/2014/3/5/344
http://article.gmane.org/gmane.comp.version-control.coccinelle/3513/

This patch pattern application was repeated with the help of the software
"Coccinelle 1.0.0-rc22" on the source files for Linux 3.17.1. An extract
of the automatically generated update suggestions is shown here.

It was determined that the affected source code places call functions
which perform input parameter validation already. It is therefore not
needed that a similar safety check is repeated at the call site.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/qla2xxx/qla_attr.c |  6 ++----
 drivers/scsi/qla2xxx/qla_init.c | 18 ++++++------------
 drivers/scsi/qla2xxx/qla_os.c   |  6 ++----
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 82b92c4..95c4c09 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -175,10 +175,8 @@ qla2x00_sysfs_write_fw_dump_template(struct file *filp,
struct kobject *kobj,
 	uint32_t size;

 	if (off == 0) {
-		if (ha->fw_dump)
-			vfree(ha->fw_dump);
-		if (ha->fw_dump_template)
-			vfree(ha->fw_dump_template);
+		vfree(ha->fw_dump);
+		vfree(ha->fw_dump_template);

 		ha->fw_dump = NULL;
 		ha->fw_dump_len = 0;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a4dde7e..8da3d4f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5256,8 +5256,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t
*srisc_addr,
 	if (!IS_QLA27XX(ha))
 		return rval;

-	if (ha->fw_dump_template)
-		vfree(ha->fw_dump_template);
+	vfree(ha->fw_dump_template);
 	ha->fw_dump_template = NULL;
 	ha->fw_dump_template_len = 0;

@@ -5307,8 +5306,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t
*srisc_addr,

 default_template:
 	ql_log(ql_log_warn, vha, 0x0168, "Using default fwdump template\n");
-	if (ha->fw_dump_template)
-		vfree(ha->fw_dump_template);
+	vfree(ha->fw_dump_template);
 	ha->fw_dump_template = NULL;
 	ha->fw_dump_template_len = 0;

@@ -5342,8 +5340,7 @@ default_template:

 failed_template:
 	ql_log(ql_log_warn, vha, 0x016d, "Failed default fwdump template\n");
-	if (ha->fw_dump_template)
-		vfree(ha->fw_dump_template);
+	vfree(ha->fw_dump_template);
 	ha->fw_dump_template = NULL;
 	ha->fw_dump_template_len = 0;
 	return rval;
@@ -5559,8 +5556,7 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t
*srisc_addr)
 	if (!IS_QLA27XX(ha))
 		return rval;

-	if (ha->fw_dump_template)
-		vfree(ha->fw_dump_template);
+	vfree(ha->fw_dump_template);
 	ha->fw_dump_template = NULL;
 	ha->fw_dump_template_len = 0;

@@ -5609,8 +5605,7 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t
*srisc_addr)

 default_template:
 	ql_log(ql_log_warn, vha, 0x0178, "Using default fwdump template\n");
-	if (ha->fw_dump_template)
-		vfree(ha->fw_dump_template);
+	vfree(ha->fw_dump_template);
 	ha->fw_dump_template = NULL;
 	ha->fw_dump_template_len = 0;

@@ -5644,8 +5639,7 @@ default_template:

 failed_template:
 	ql_log(ql_log_warn, vha, 0x017d, "Failed default fwdump template\n");
-	if (ha->fw_dump_template)
-		vfree(ha->fw_dump_template);
+	vfree(ha->fw_dump_template);
 	ha->fw_dump_template = NULL;
 	ha->fw_dump_template_len = 0;
 	return rval;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index db3dbd9..0f9c378 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3676,10 +3676,8 @@ qla2x00_free_fw_dump(struct qla_hw_data *ha)
 		dma_free_coherent(&ha->pdev->dev,
 		    EFT_SIZE, ha->eft, ha->eft_dma);

-	if (ha->fw_dump)
-		vfree(ha->fw_dump);
-	if (ha->fw_dump_template)
-		vfree(ha->fw_dump_template);
+	vfree(ha->fw_dump);
+	vfree(ha->fw_dump_template);

 	ha->fce = NULL;
 	ha->fce_dma = 0;
-- 
2.1.2
