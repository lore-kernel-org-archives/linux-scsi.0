From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [11/15] qla2xxx: Add login-retry-count override
Date: Sun, 14 Mar 2004 00:25:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082545.GA3458@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:33469 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263323AbUCNIXP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:23:15 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1667 04/03/01 15:40:41 andrew.vasquez@apc.qlogic.com +3 -0
  Add a module parameter to override the NVRAM's login retry count
  value.

 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    2 ++
 drivers/scsi/qla2xxx/qla_os.c   |    5 +++++
 3 files changed, 8 insertions(+)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/20_add_nvr_login_retry_cnt.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	Fri Mar 12 17:09:07 2004
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	Fri Mar 12 17:09:07 2004
@@ -65,6 +65,7 @@
 extern int displayConfig;
 extern int ql2xplogiabsentdevice;
 extern int ql2xintrdelaytimer;
+extern int ql2xloginretrycount;
 
 extern int ConfigRequired;
 
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:09:07 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:09:07 2004
@@ -1363,6 +1363,8 @@
 		ha->login_retry_count = ha->port_down_retry_count;
 	else if (ha->port_down_retry_count > (int)ha->login_retry_count)
 		ha->login_retry_count = ha->port_down_retry_count;
+	if (ql2xloginretrycount)
+		ha->login_retry_count = ql2xloginretrycount;
 
 	ha->binding_type = Bind;
 	if (ha->binding_type != BIND_BY_PORT_NAME &&
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:09:07 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:09:07 2004
@@ -110,6 +110,11 @@
 		"Signal mid-layer to perform scan after driver load: 0 -- no "
 		"signal sent to mid-layer.");
 
+int ql2xloginretrycount = 0;
+module_param(ql2xloginretrycount, int, 0);
+MODULE_PARM_DESC(ql2xloginretrycount,
+		"Specify an alternate value for the NVRAM login retry count.");
+
 /*
  * Proc structures and functions
  */
