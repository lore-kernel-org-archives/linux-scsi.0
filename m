From: "Luiz Fernando N. Capitulino" <lcapitulino@prefeitura.sp.gov.br>
Subject: [PATCH] - qla1280.c warning fix.
Date: Tue, 13 Apr 2004 15:20:29 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040413152029.6d76d683.lcapitulino@prefeitura.sp.gov.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sampa7.prodam.sp.gov.br ([200.230.190.107]:24588 "EHLO
	sampa7.prodam.sp.gov.br") by vger.kernel.org with ESMTP
	id S263472AbUDMSWZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 14:22:25 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org


Hi,

 I'm getting this warning in -mm5 (and in the last ones):

drivers/scsi/qla1280.c:3124: warning: `qla1280_64bit_start_scsi' defined but not used

 The patch bellow fixes that:

diff -X dontdiff -Nparu a/drivers/scsi/qla1280.c a~/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	2004-03-11 14:20:48.000000000 -0300
+++ a~/drivers/scsi/qla1280.c	2004-04-13 14:56:24.000000000 -0300
@@ -3119,6 +3119,7 @@ qla1280_marker(struct scsi_qla_host *ha,
  * Returns:
  *      0 = success, was able to issue command.
  */
+#ifdef QLA_64BIT_PTR
 static int
 qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 {
@@ -3380,9 +3381,8 @@ qla1280_64bit_start_scsi(struct scsi_qla
 
 	return status;
 }
+#else /* !QLA_64BIT_PTR */
 
-
-#ifndef QLA_64BIT_PTR
 /*
  * qla1280_32bit_start_scsi
  *      The start SCSI is responsible for building request packets on

-- 
Luiz Fernando N. Capitulino
<lcapitulino@prefeitura.sp.gov.br>
<http://www.telecentros.sp.gov.br>
