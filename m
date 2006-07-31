From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH] Fix scsi/scsi_transport.h compile error
Date: Mon, 31 Jul 2006 09:43:25 +0200
Message-ID: <200607310943.25384.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:1774 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S964814AbWGaHlE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 03:41:04 -0400
Received: from  ([::ffff:212.65.3.74] HELO siso-eb-i34d.silicon-software.de) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.9) with (DHE-RSA-AES256-SHA encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2006 09:40:58 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>

scsi_transport.h defines the inline function scsi_transport_device_data()
that dereferences a pointer of "struct scsi_device *". Since the struct is
not known by the header this might break compilation.

Include scsi/scsi_device.h to not rely on users doing the correct magic
include order.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit 2ce61cfef5642b3a7414d2f430acf179f50f7228
tree 4d9c48a499dd47028bf28dfdd931c501efc32db3
parent 788fd16e408ca6c1008829d52bca9f13cbec64ce
author Rolf Eike Beer <eike-kernel@sf-tec.de> Mon, 31 Jul 2006 09:08:09 +0200
committer Rolf Eike Beer <beer@siso-eb-i34d.silicon-software.de> Mon, 31 Jul 2006 09:08:09 +0200

 include/scsi/scsi_transport.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index cca1d49..3c18baa 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -22,6 +22,7 @@ #define SCSI_TRANSPORT_H
 
 #include <linux/transport_class.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
 
 struct scsi_transport_template {
 	/* the attribute containers */
