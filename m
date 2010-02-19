From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [patch 8/9] ipr: add support for new IOASCs
Date: Fri, 19 Feb 2010 13:24:32 -0800
Message-ID: <4B7F0190.9040009@linux.vnet.ibm.com>
References: <20100219210900.066268168@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46202 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab0BSVYg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 16:24:36 -0500
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e4.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o1JLE2K8003112
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 16:14:02 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o1JLOYac1523838
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 16:24:34 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o1JLOXXm024755
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 19:24:34 -0200
In-Reply-To: <20100219210900.066268168@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

This patch adds support for new errors that can be received from adapters
using the next generation 64 bit IOA PCI interface chip.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-02-19 12:52:30.000000000 -0800
+++ b/drivers/scsi/ipr.c	2010-02-19 13:00:51.000000000 -0800
@@ -222,6 +222,20 @@ struct ipr_error_table_t ipr_error_table
 	"FFFE: Soft device bus error recovered by the IOA"},
 	{0x01088100, 0, IPR_DEFAULT_LOG_LEVEL,
 	"4101: Soft device bus fabric error"},
+	{0x01100100, 0, IPR_DEFAULT_LOG_LEVEL,
+	"FFFC: Logical block guard error recovered by the device"},
+	{0x01100300, 0, IPR_DEFAULT_LOG_LEVEL,
+	"FFFC: Logical block reference tag error recovered by the device"},
+	{0x01108300, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4171: Recovered scatter list tag / sequence number error"},
+	{0x01109000, 0, IPR_DEFAULT_LOG_LEVEL,
+	"FF3D: Recovered logical block CRC error on IOA to Host transfer"},
+	{0x01109200, 0, IPR_DEFAULT_LOG_LEVEL,
+	"4171: Recovered logical block sequence number error on IOA to Host transfer"},
+	{0x0110A000, 0, IPR_DEFAULT_LOG_LEVEL,
+	"FFFD: Recovered logical block reference tag error detected by the IOA"},
+	{0x0110A100, 0, IPR_DEFAULT_LOG_LEVEL,
+	"FFFD: Logical block guard error recovered by the IOA"},
 	{0x01170600, 0, IPR_DEFAULT_LOG_LEVEL,
 	"FFF9: Device sector reassign successful"},
 	{0x01170900, 0, IPR_DEFAULT_LOG_LEVEL,
@@ -278,12 +292,28 @@ struct ipr_error_table_t ipr_error_table
 	"3120: SCSI bus is not operational"},
 	{0x04088100, 0, IPR_DEFAULT_LOG_LEVEL,
 	"4100: Hard device bus fabric error"},
+	{0x04100100, 0, IPR_DEFAULT_LOG_LEVEL,
+	"310C: Logical block guard error detected by the device"},
+	{0x04100300, 0, IPR_DEFAULT_LOG_LEVEL,
+	"310C: Logical block reference tag error detected by the device"},
+	{0x04108300, 1, IPR_DEFAULT_LOG_LEVEL,
+	"4170: Scatter list tag / sequence number error"},
+	{0x04109000, 1, IPR_DEFAULT_LOG_LEVEL,
+	"8150: Logical block CRC error on IOA to Host transfer"},
+	{0x04109200, 1, IPR_DEFAULT_LOG_LEVEL,
+	"4170: Logical block sequence number error on IOA to Host transfer"},
+	{0x0410A000, 0, IPR_DEFAULT_LOG_LEVEL,
+	"310D: Logical block reference tag error detected by the IOA"},
+	{0x0410A100, 0, IPR_DEFAULT_LOG_LEVEL,
+	"310D: Logical block guard error detected by the IOA"},
 	{0x04118000, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9000: IOA reserved area data check"},
 	{0x04118100, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9001: IOA reserved area invalid data pattern"},
 	{0x04118200, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9002: IOA reserved area LRC error"},
+	{0x04118300, 1, IPR_DEFAULT_LOG_LEVEL,
+	"Hardware Error, IOA metadata access error"},
 	{0x04320000, 0, IPR_DEFAULT_LOG_LEVEL,
 	"102E: Out of alternate sectors for disk storage"},
 	{0x04330000, 1, IPR_DEFAULT_LOG_LEVEL,
@@ -348,6 +378,8 @@ struct ipr_error_table_t ipr_error_table
 	"Illegal request, commands not allowed to this device"},
 	{0x05258100, 0, 0,
 	"Illegal request, command not allowed to a secondary adapter"},
+	{0x05258200, 0, 0,
+	"Illegal request, command not allowed to a non-optimized resource"},
 	{0x05260000, 0, 0,
 	"Illegal request, invalid field in parameter list"},
 	{0x05260100, 0, 0,

