Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF235821C
	for <linux-scsi@vger.kernel.org>; Thu, 21 Mar 2024 11:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711020299; cv=none; b=O0A/3+6YJ6dvLPLym5ZbBitPAJ/noTkMyMs04aT1RXAaVFbkRZfUv93VRoISOg/gswbBH1wSLkPYjRASqhsso6ZoXFpGvrRg2ue7aq4x2/KjxyHfSmF+yoU+KM9Cu4Knjzw6QdcGa6BcW0l9j96gyu1pNLS8zSUMgBtrQ+KGbQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711020299; c=relaxed/simple;
	bh=vxFAVBLiUKJIj1bj0i6YA1pMJRxUQFxLA1RcEnest8E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AwoMOyiZMVxkTQm476f88954G/8IthwXUy1GvCc5aH6z9EEP7w4Vo10fd1yxqGSiunWmqh04rB4DSMt4xK6EmEZd5rIl1+QYMW9SfIKJ0/3V9ZO58Vj8tHSTPGShzeu7HTmYlLiM9HPgXEDD+sTm2eHiKz5QUOkapWCzLrKiu2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EVX7BjVN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EVX7BjVN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711020296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ac9UvT/S9w6LbHxFoGYKOuJ8nuY7rQnT47SPtuGSLnk=;
	b=EVX7BjVNDJSAjpM7rS/p46qCL/kWjBbDqlD8mQJPF5/0AKHu/vLEaTjJVQgY6tIrouphr+
	b26Rgdk4aQ83ktZVOSRwf/Zlclph3eYf533FGaFCy15J90g7c18qannJviJZ+ZA2OpRq6K
	lod9bDrOR3e2JeX/M+Zo86ARqJ/db+Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-vIKu1wwfPEy98mdiyKdr-w-1; Thu, 21 Mar 2024 07:24:50 -0400
X-MC-Unique: vIKu1wwfPEy98mdiyKdr-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45B01800265;
	Thu, 21 Mar 2024 11:24:50 +0000 (UTC)
Received: from kaapi.redhat.com (unknown [10.67.24.5])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A24CD2166B33;
	Thu, 21 Mar 2024 11:24:47 +0000 (UTC)
From: Prasad Pandit <ppandit@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	Nilesh Javali <njavali@marvell.com>,
	Arnd Bergmann <arnd@kernel.org>,
	Prasad Pandit <pjp@fedoraproject.org>
Subject: [PATCH] scsi: qla2xxx: indent help text
Date: Thu, 21 Mar 2024 16:54:38 +0530
Message-ID: <20240321112438.1759347-1-ppandit@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Prasad Pandit <pjp@fedoraproject.org>

Fix indentation of config option's help text by adding
leading spaces. Generally help text is indented by couple
of spaces more beyond the leading tab <\t> character.
It helps Kconfig parsers to read file without error.

Signed-off-by: Prasad Pandit <pjp@fedoraproject.org>
---
 drivers/scsi/Kconfig         |  4 ++--
 drivers/scsi/qla2xxx/Kconfig | 42 +++++++++++++++++++-----------------
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9ce27092729c..a9704b05ce10 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -53,7 +53,7 @@ config SCSI_ESP_PIO
 
 config SCSI_NETLINK
 	bool
-	default	n
+	default n
 	depends on NET
 
 config SCSI_PROC_FS
@@ -313,7 +313,7 @@ config ISCSI_TCP
 
 config ISCSI_BOOT_SYSFS
 	tristate "iSCSI Boot Sysfs Interface"
-	default	n
+	default n
 	help
 	  This option enables support for exposing iSCSI boot information
 	  via sysfs to userspace. If you wish to export this information,
diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index a584708d3056..a8b4314bfd6e 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -7,29 +7,29 @@ config SCSI_QLA_FC
 	select FW_LOADER
 	select BTREE
 	help
-	This qla2xxx driver supports all QLogic Fibre Channel
-	PCI and PCIe host adapters.
+	  This qla2xxx driver supports all QLogic Fibre Channel
+	  PCI and PCIe host adapters.
 
-	By default, firmware for the ISP parts will be loaded
-	via the Firmware Loader interface.
+	  By default, firmware for the ISP parts will be loaded
+	  via the Firmware Loader interface.
 
-	ISP               Firmware Filename
-	----------        -----------------
-	21xx              ql2100_fw.bin
-	22xx              ql2200_fw.bin
-	2300, 2312, 6312  ql2300_fw.bin
-	2322, 6322        ql2322_fw.bin
-	24xx, 54xx        ql2400_fw.bin
-	25xx              ql2500_fw.bin
+	  ISP               Firmware Filename
+	  ----------        -----------------
+	  21xx              ql2100_fw.bin
+	  22xx              ql2200_fw.bin
+	  2300, 2312, 6312  ql2300_fw.bin
+	  2322, 6322        ql2322_fw.bin
+	  24xx, 54xx        ql2400_fw.bin
+	  25xx              ql2500_fw.bin
 
-	Upon request, the driver caches the firmware image until
-	the driver is unloaded.
+	  Upon request, the driver caches the firmware image until
+	  the driver is unloaded.
 
-	Firmware images can be retrieved from:
+	  Firmware images can be retrieved from:
 
-		http://ldriver.qlogic.com/firmware/
+	        http://ldriver.qlogic.com/firmware/
 
-	They are also included in the linux-firmware tree as well.
+	  They are also included in the linux-firmware tree as well.
 
 config TCM_QLA2XXX
 	tristate "TCM_QLA2XXX fabric module for QLogic 24xx+ series target mode HBAs"
@@ -38,13 +38,15 @@ config TCM_QLA2XXX
 	select BTREE
 	default n
 	help
-	Say Y here to enable the TCM_QLA2XXX fabric module for QLogic 24xx+ series target mode HBAs
+	  Say Y here to enable the TCM_QLA2XXX fabric module for QLogic 24xx+
+	  series target mode HBAs.
 
 if TCM_QLA2XXX
 config TCM_QLA2XXX_DEBUG
 	bool "TCM_QLA2XXX fabric module DEBUG mode for QLogic 24xx+ series target mode HBAs"
 	default n
 	help
-	Say Y here to enable the TCM_QLA2XXX fabric module DEBUG for QLogic 24xx+ series target mode HBAs
-	This will include code to enable the SCSI command jammer
+	  Say Y here to enable the TCM_QLA2XXX fabric module DEBUG for
+	  QLogic 24xx+ series target mode HBAs.
+	  This will include code to enable the SCSI command jammer.
 endif
-- 
2.44.0

