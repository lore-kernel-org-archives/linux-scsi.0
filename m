Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB146FC5
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 05:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712552490; cv=none; b=Qw122MypM+ZoazA+VCapRXv957DTHyQA3/cYrtkx8TdnPtKXpu+juBLDeXoiNL+toMrMG/zRMG4dZsVrzdySX6UqUvszjt5KlzbceYLsXOJnxY0P5S8WYBOhzqxAjfc1ZYCkYqx3GYHuIqGJ0XyHV8KnSEI2Lf+E7e/sgjQgphE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712552490; c=relaxed/simple;
	bh=ja15TCw7SkQKcmsT8ZGixhM5TKWrOPMU8NqlC9QXBY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aS5V3WeZRY4tjlWKgKcmphTakL38thkS3gouz3hSmCJ8S2HFqUUwy+wL19ndHSNmCbZZuuOcWATdvHXYCoMAKX7KvuKTSrPFVlzjwq2aBFWec8uFeM9EqaXLMZlilHpNIruQqjG0FaTgHOZjgU5mssai2pCXjlG1gdl63c27rtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AfvXL+5u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AfvXL+5u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712552486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dqn+h5WVq4ajXurGecQKuk0SxWjZ9IvU4F1fayXtGk8=;
	b=AfvXL+5uR8EryuHPa6AyH6RKfbF9M6P2zF5gTTQG1HKAJM8LdYSgSwlTTRW8AO6nHlKJRV
	gpNo+i4TZ9TfeMWKHbTRDiyPBpTQZlp2/YBh8bRbX6/kq/wLH0jUofTufY5GLRMiKHR7mI
	W3fv2S5BCkwGyxLcuY2it9YQnt1a3VU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-RxxAQLrDOYqEmYmWFKBmkQ-1; Mon, 08 Apr 2024 01:01:22 -0400
X-MC-Unique: RxxAQLrDOYqEmYmWFKBmkQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B15785710B;
	Mon,  8 Apr 2024 05:01:22 +0000 (UTC)
Received: from kaapi.redhat.com (unknown [10.74.16.34])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 862FD200B09C;
	Mon,  8 Apr 2024 05:01:19 +0000 (UTC)
From: Prasad Pandit <ppandit@redhat.com>
To: Hannes Reinecke <hare@suse.com>
Cc: linux-scsi@vger.kernel.org,
	Prasad Pandit <pjp@fedoraproject.org>
Subject: [PATCH] scsi: aic7xxx: indent kconfig help text
Date: Mon,  8 Apr 2024 10:31:10 +0530
Message-ID: <20240408050110.3679890-1-ppandit@redhat.com>
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
leading spaces. Generally help text is indented by two
more spaces beyond the leading tab <\t> character.
It helps Kconfig parsers to read file without error.

Signed-off-by: Prasad Pandit <pjp@fedoraproject.org>
---
 drivers/scsi/aic7xxx/Kconfig.aic79xx | 75 ++++++++++-----------
 drivers/scsi/aic7xxx/Kconfig.aic7xxx | 97 ++++++++++++++--------------
 2 files changed, 87 insertions(+), 85 deletions(-)

diff --git a/drivers/scsi/aic7xxx/Kconfig.aic79xx b/drivers/scsi/aic7xxx/Kconfig.aic79xx
index 4bc53eec4c83..863f0932ef59 100644
--- a/drivers/scsi/aic7xxx/Kconfig.aic79xx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic79xx
@@ -8,79 +8,80 @@ config SCSI_AIC79XX
 	depends on PCI && HAS_IOPORT && SCSI
 	select SCSI_SPI_ATTRS
 	help
-	This driver supports all of Adaptec's Ultra 320 PCI-X
-	based SCSI controllers.
+	  This driver supports all of Adaptec's Ultra 320 PCI-X
+	  based SCSI controllers.
 
 config AIC79XX_CMDS_PER_DEVICE
 	int "Maximum number of TCQ commands per device"
 	depends on SCSI_AIC79XX
 	default "32"
 	help
-	Specify the number of commands you would like to allocate per SCSI
-	device when Tagged Command Queueing (TCQ) is enabled on that device.
+	  Specify the number of commands you would like to allocate per SCSI
+	  device when Tagged Command Queueing (TCQ) is enabled on that device.
 
-	This is an upper bound value for the number of tagged transactions
-	to be used for any device.  The aic7xxx driver will automatically
-	vary this number based on device behavior.  For devices with a
-	fixed maximum, the driver will eventually lock to this maximum
-	and display a console message indicating this value.
+	  This is an upper bound value for the number of tagged transactions
+	  to be used for any device.  The aic7xxx driver will automatically
+	  vary this number based on device behavior.  For devices with a
+	  fixed maximum, the driver will eventually lock to this maximum
+	  and display a console message indicating this value.
 
-	Due to resource allocation issues in the Linux SCSI mid-layer, using
-	a high number of commands per device may result in memory allocation
-	failures when many devices are attached to the system.  For this reason,
-	the default is set to 32.  Higher values may result in higher performance
-	on some devices.  The upper bound is 253.  0 disables tagged queueing.
+	  Due to resource allocation issues in the Linux SCSI mid-layer, using
+	  a high number of commands per device may result in memory allocation
+	  failures when many devices are attached to the system.  For this
+	  reason, the default is set to 32. Higher values may result in higher
+	  performance on some devices. The upper bound is 253. 0 disables
+	  tagged queueing.
 
-	Per device tag depth can be controlled via the kernel command line
-	"tag_info" option.  See Documentation/scsi/aic79xx.rst for details.
+	  Per device tag depth can be controlled via the kernel command line
+	  "tag_info" option.  See Documentation/scsi/aic79xx.rst for details.
 
 config AIC79XX_RESET_DELAY_MS
 	int "Initial bus reset delay in milli-seconds"
 	depends on SCSI_AIC79XX
 	default "5000"
 	help
-	The number of milliseconds to delay after an initial bus reset.
-	The bus settle delay following all error recovery actions is
-	dictated by the SCSI layer and is not affected by this value.
+	  The number of milliseconds to delay after an initial bus reset.
+	  The bus settle delay following all error recovery actions is
+	  dictated by the SCSI layer and is not affected by this value.
 
-	Default: 5000 (5 seconds)
+	  Default: 5000 (5 seconds)
 
 config AIC79XX_BUILD_FIRMWARE
 	bool "Build Adapter Firmware with Kernel Build"
 	depends on SCSI_AIC79XX && !PREVENT_FIRMWARE_BUILD
 	help
-	This option should only be enabled if you are modifying the firmware
-	source to the aic79xx driver and wish to have the generated firmware
-	include files updated during a normal kernel build.  The assembler
-	for the firmware requires lex and yacc or their equivalents, as well
-	as the db v1 library.  You may have to install additional packages
-	or modify the assembler Makefile or the files it includes if your
-	build environment is different than that of the author.
+	  This option should only be enabled if you are modifying the firmware
+	  source to the aic79xx driver and wish to have the generated firmware
+	  include files updated during a normal kernel build.  The assembler
+	  for the firmware requires lex and yacc or their equivalents, as well
+	  as the db v1 library.  You may have to install additional packages
+	  or modify the assembler Makefile or the files it includes if your
+	  build environment is different than that of the author.
 
 config AIC79XX_DEBUG_ENABLE
 	bool "Compile in Debugging Code"
 	depends on SCSI_AIC79XX
 	default y
 	help
-	Compile in aic79xx debugging code that can be useful in diagnosing
-	driver errors.
+	  Compile in aic79xx debugging code that can be useful in diagnosing
+	  driver errors.
 
 config AIC79XX_DEBUG_MASK
 	int "Debug code enable mask (16383 for all debugging)"
 	depends on SCSI_AIC79XX
 	default "0"
 	help
-	Bit mask of debug options that is only valid if the
-	CONFIG_AIC79XX_DEBUG_ENABLE option is enabled.  The bits in this mask
-	are defined in the drivers/scsi/aic7xxx/aic79xx.h - search for the
-	variable ahd_debug in that file to find them.
+	  Bit mask of debug options that is only valid if the
+	  CONFIG_AIC79XX_DEBUG_ENABLE option is enabled.  The bits in this mask
+	  are defined in the drivers/scsi/aic7xxx/aic79xx.h - search for the
+	  variable ahd_debug in that file to find them.
 
 config AIC79XX_REG_PRETTY_PRINT
 	bool "Decode registers during diagnostics"
 	depends on SCSI_AIC79XX
 	default y
 	help
-	Compile in register value tables for the output of expanded register
-	contents in diagnostics.  This make it much easier to understand debug
-	output without having to refer to a data book and/or the aic7xxx.reg
-	file.
+	  Compile in register value tables for the output of expanded register
+	  contents in diagnostics.  This make it much easier to understand debug
+	  output without having to refer to a data book and/or the aic7xxx.reg
+	  file.
diff --git a/drivers/scsi/aic7xxx/Kconfig.aic7xxx b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
index f0425145a5f4..8f87f2d8ba9f 100644
--- a/drivers/scsi/aic7xxx/Kconfig.aic7xxx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
@@ -8,84 +8,85 @@ config SCSI_AIC7XXX
 	depends on (PCI || EISA) && HAS_IOPORT && SCSI
 	select SCSI_SPI_ATTRS
 	help
-	This driver supports all of Adaptec's Fast through Ultra 160 PCI
-	based SCSI controllers as well as the aic7770 based EISA and VLB
-	SCSI controllers (the 274x and 284x series).  For AAA and ARO based
-	configurations, only SCSI functionality is provided.
+	  This driver supports all of Adaptec's Fast through Ultra 160 PCI
+	  based SCSI controllers as well as the aic7770 based EISA and VLB
+	  SCSI controllers (the 274x and 284x series).  For AAA and ARO based
+	  configurations, only SCSI functionality is provided.
 
-	To compile this driver as a module, choose M here: the
-	module will be called aic7xxx.
+	  To compile this driver as a module, choose M here: the
+	  module will be called aic7xxx.
 
 config AIC7XXX_CMDS_PER_DEVICE
 	int "Maximum number of TCQ commands per device"
 	depends on SCSI_AIC7XXX
 	default "32"
 	help
-	Specify the number of commands you would like to allocate per SCSI
-	device when Tagged Command Queueing (TCQ) is enabled on that device.
+	  Specify the number of commands you would like to allocate per SCSI
+	  device when Tagged Command Queueing (TCQ) is enabled on that device.
 
-	This is an upper bound value for the number of tagged transactions
-	to be used for any device.  The aic7xxx driver will automatically
-	vary this number based on device behavior.  For devices with a
-	fixed maximum, the driver will eventually lock to this maximum
-	and display a console message indicating this value.
+	  This is an upper bound value for the number of tagged transactions
+	  to be used for any device.  The aic7xxx driver will automatically
+	  vary this number based on device behavior.  For devices with a
+	  fixed maximum, the driver will eventually lock to this maximum
+	  and display a console message indicating this value.
 
-	Due to resource allocation issues in the Linux SCSI mid-layer, using
-	a high number of commands per device may result in memory allocation
-	failures when many devices are attached to the system.  For this reason,
-	the default is set to 32.  Higher values may result in higher performance
-	on some devices.  The upper bound is 253.  0 disables tagged queueing.
+	  Due to resource allocation issues in the Linux SCSI mid-layer, using
+	  a high number of commands per device may result in memory allocation
+	  failures when many devices are attached to the system.  For this
+	  reason, the default is set to 32.  Higher values may result in higher
+	  performance on some devices. The upper bound is 253. 0 disables tagged
+	  queueing.
 
-	Per device tag depth can be controlled via the kernel command line
-	"tag_info" option.  See Documentation/scsi/aic7xxx.rst for details.
+	  Per device tag depth can be controlled via the kernel command line
+	  "tag_info" option.  See Documentation/scsi/aic7xxx.rst for details.
 
 config AIC7XXX_RESET_DELAY_MS
 	int "Initial bus reset delay in milli-seconds"
 	depends on SCSI_AIC7XXX
 	default "5000"
 	help
-	The number of milliseconds to delay after an initial bus reset.
-	The bus settle delay following all error recovery actions is
-	dictated by the SCSI layer and is not affected by this value.
+	  The number of milliseconds to delay after an initial bus reset.
+	  The bus settle delay following all error recovery actions is
+	  dictated by the SCSI layer and is not affected by this value.
 
-	Default: 5000 (5 seconds)
+	  Default: 5000 (5 seconds)
 
 config AIC7XXX_BUILD_FIRMWARE
 	bool "Build Adapter Firmware with Kernel Build"
 	depends on SCSI_AIC7XXX && !PREVENT_FIRMWARE_BUILD
 	help
-	This option should only be enabled if you are modifying the firmware
-	source to the aic7xxx driver and wish to have the generated firmware
-	include files updated during a normal kernel build.  The assembler
-	for the firmware requires lex and yacc or their equivalents, as well
-	as the db v1 library.  You may have to install additional packages
-	or modify the assembler Makefile or the files it includes if your
-	build environment is different than that of the author.
+	  This option should only be enabled if you are modifying the firmware
+	  source to the aic7xxx driver and wish to have the generated firmware
+	  include files updated during a normal kernel build.  The assembler
+	  for the firmware requires lex and yacc or their equivalents, as well
+	  as the db v1 library.  You may have to install additional packages
+	  or modify the assembler Makefile or the files it includes if your
+	  build environment is different than that of the author.
 
 config AIC7XXX_DEBUG_ENABLE
 	bool "Compile in Debugging Code"
 	depends on SCSI_AIC7XXX
 	default y
 	help
-	Compile in aic7xxx debugging code that can be useful in diagnosing
-	driver errors.
+	  Compile in aic7xxx debugging code that can be useful in diagnosing
+	  driver errors.
 
 config AIC7XXX_DEBUG_MASK
-        int "Debug code enable mask (2047 for all debugging)"
-        depends on SCSI_AIC7XXX
-        default "0"
-        help
-	Bit mask of debug options that is only valid if the
-	CONFIG_AIC7XXX_DEBUG_ENABLE option is enabled.  The bits in this mask
-	are defined in the drivers/scsi/aic7xxx/aic7xxx.h - search for the
-	variable ahc_debug in that file to find them.
+	int "Debug code enable mask (2047 for all debugging)"
+	depends on SCSI_AIC7XXX
+	default "0"
+	help
+	  Bit mask of debug options that is only valid if the
+	  CONFIG_AIC7XXX_DEBUG_ENABLE option is enabled.  The bits in this mask
+	  are defined in the drivers/scsi/aic7xxx/aic7xxx.h - search for the
+	  variable ahc_debug in that file to find them.
 
 config AIC7XXX_REG_PRETTY_PRINT
-        bool "Decode registers during diagnostics"
-        depends on SCSI_AIC7XXX
+	bool "Decode registers during diagnostics"
+	depends on SCSI_AIC7XXX
 	default y
-        help
-	Compile in register value tables for the output of expanded register
-	contents in diagnostics.  This make it much easier to understand debug
-	output without having to refer to a data book and/or the aic7xxx.reg
-	file.
+	help
+	  Compile in register value tables for the output of expanded register
+	  contents in diagnostics.  This make it much easier to understand debug
+	  output without having to refer to a data book and/or the aic7xxx.reg
+	  file.
-- 
2.44.0

