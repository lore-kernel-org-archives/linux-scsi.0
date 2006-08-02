From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2/5] ipr: Handle new SAS error codes
Date: Wed, 02 Aug 2006 14:57:44 -0500
Message-ID: <200608021957.k72JvjqD010768@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57770 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932198AbWHBT5q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 15:57:46 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k72JvkX6008269
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 15:57:46 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k72JvkP2246408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 15:57:46 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k72Jvjvm010814
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 15:57:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Add definitions for some SAS error codes that can be
logged by ipr SAS adapters.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_sas_errors drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sas_errors	2006-08-02 13:34:19.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-08-02 14:48:23.000000000 -0500
@@ -175,6 +175,8 @@ struct ipr_error_table_t ipr_error_table
 	"Qualified success"},
 	{0x01080000, 1, 1,
 	"FFFE: Soft device bus error recovered by the IOA"},
+	{0x01088100, 0, 1,
+	"4101: Soft device bus fabric error"},
 	{0x01170600, 0, 1,
 	"FFF9: Device sector reassign successful"},
 	{0x01170900, 0, 1,
@@ -225,6 +227,8 @@ struct ipr_error_table_t ipr_error_table
 	"3109: IOA timed out a device command"},
 	{0x04088000, 0, 0,
 	"3120: SCSI bus is not operational"},
+	{0x04088100, 0, 1,
+	"4100: Hard device bus fabric error"},
 	{0x04118000, 0, 1,
 	"9000: IOA reserved area data check"},
 	{0x04118100, 0, 1,
@@ -273,6 +277,14 @@ struct ipr_error_table_t ipr_error_table
 	"9091: Incorrect hardware configuration change has been detected"},
 	{0x04678000, 0, 1,
 	"9073: Invalid multi-adapter configuration"},
+	{0x04678100, 0, 1,
+	"4010: Incorrect connection between cascaded expanders"},
+	{0x04678200, 0, 1,
+	"4020: Connections exceed IOA design limits"},
+	{0x04678300, 0, 1,
+	"4030: Incorrect multipath connection"},
+	{0x04679000, 0, 1,
+	"4110: Unsupported enclosure function"},
 	{0x046E0000, 0, 1,
 	"FFF4: Command to logical unit failed"},
 	{0x05240000, 1, 0,
@@ -297,6 +309,8 @@ struct ipr_error_table_t ipr_error_table
 	"9031: Array protection temporarily suspended, protection resuming"},
 	{0x06040600, 0, 1,
 	"9040: Array protection temporarily suspended, protection resuming"},
+	{0x06288000, 0, 1,
+	"3140: Device bus not ready to ready transition"},
 	{0x06290000, 0, 1,
 	"FFFB: SCSI bus was reset"},
 	{0x06290500, 0, 0,
@@ -319,6 +333,16 @@ struct ipr_error_table_t ipr_error_table
 	"3150: SCSI bus configuration error"},
 	{0x06678100, 0, 1,
 	"9074: Asymmetric advanced function disk configuration"},
+	{0x06678300, 0, 1,
+	"4040: Incomplete multipath connection between IOA and enclosure"},
+	{0x06678400, 0, 1,
+	"4041: Incomplete multipath connection between enclosure and device"},
+	{0x06678500, 0, 1,
+	"9075: Incomplete multipath connection between IOA and remote IOA"},
+	{0x06678600, 0, 1,
+	"9076: Configuration error, missing remote IOA"},
+	{0x06679100, 0, 1,
+	"4050: Enclosure does not support a required multipath function"},
 	{0x06690200, 0, 1,
 	"9041: Array protection temporarily suspended"},
 	{0x06698200, 0, 1,
@@ -331,6 +355,10 @@ struct ipr_error_table_t ipr_error_table
 	"9072: Link not operational transition"},
 	{0x066B8200, 0, 1,
 	"9032: Array exposed but still protected"},
+	{0x066B9100, 0, 1,
+	"4061: Multipath redundancy level got better"},
+	{0x066B9200, 0, 1,
+	"4060: Multipath redundancy level got worse"},
 	{0x07270000, 0, 0,
 	"Failure due to other device"},
 	{0x07278000, 0, 1,
_
