Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4912500B1;
	Tue, 14 Jan 2025 09:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736847496; cv=none; b=MoObuV1qGuYG/Tz+lYfQ2zAAdYHBAqhvvy2BIxl4cAmZt4FlBnKuXMTWeU698SAcLElmQtY3DATJY9h3FYIkUkPVPe2/NdLSr0Z9DLCtHlsc2q33HLWSXF7QjCRT4wrKYah+fqnUeGQ0nonFjCGP1yJPcxdNMYr4l4xDBMUyGrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736847496; c=relaxed/simple;
	bh=wprwv1OkpKu8x+PAWg3ek/L5o90PlY4LhKUF+OC+IOk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s+C+Qk7GWLudJlLtrJIToy5UetQaxQQjJLCjiFKzdlgX6JTQ8W/+FohaJ73HEfQitclpkSyCnw8oWPiw/a83wm+sDIrakWy1y5fG9zlO/wuHHxL+DEAmooFkqvqftkhrnpbvMMFXH+0p1+L43VJx0g6U2Ck0slvBleVkPrcMgcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rimnANU6; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rimnANU6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1736847494; x=1768383494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wprwv1OkpKu8x+PAWg3ek/L5o90PlY4LhKUF+OC+IOk=;
  b=rimnANU6Bk0fhyxxA8cqqX9pxeq1WnuOBU2fW2gdioEgsSAzJ+SNxE4b
   aGD4ZGZ0wwxI0fld+naU39oYfrp3Edo9owHDqC/PcMHHG7ew2nm2MQ+x3
   hLuL53dLRmvR+kmmYTPZ3PKGEINLd3ST3kYvQ7h0uwpxdMmxa5hOghJAU
   ddnfsSJqj3+SDNg1ux8iGVChXtZiozmX2HnvFkNh4pvU71YiDCfOCinyI
   eMBPdmPFCsnS8x/PnL+zYVV3uRCW2q7b4yNSUMobDDB5zqY6KdrPify0B
   Z7s7eJ/pCMHOslKcn88c2nEcaIUvL+YGrTgoWG51mme9O7JkFvVdmWEN9
   A==;
X-CSE-ConnectionGUID: xtu3SFj5TvCumkp7JUA++A==
X-CSE-MsgGUID: 20tO3Qg7Tqynve5sJUl8nw==
X-IronPort-AV: E=Sophos;i="6.12,313,1728921600"; 
   d="scan'208";a="35258389"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jan 2025 17:38:08 +0800
IronPort-SDR: 678622f4_bg9KJ40f3Z2GaN17IcoSIyQNUaGVPMjNwDTs7Zwx4LLSRc+
 dVFb+0tiFsjkjyyrfp/M8eRhwuMwv3mhfbbVo7A==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Jan 2025 00:40:20 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Jan 2025 01:38:07 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/2] scsi: ufs: hwmon: Add missing ABI documentation
Date: Tue, 14 Jan 2025 11:35:12 +0200
Message-Id: <20250114093512.151019-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250114093512.151019-1-avri.altman@wdc.com>
References: <20250114093512.151019-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit adds ABI documentation for the UFS hwmon driver, detailing
the sysfs attributes exposed by the driver. It includes the missing
temperature notification entries, that were added back in 2021.

The following sysfs attributes are documented:
- /sys/class/hwmon/hwmon*/temp*_input
- /sys/class/hwmon/hwmon*/temp*_crit
- /sys/class/hwmon/hwmon*/temp*_lcrit
- /sys/class/hwmon/hwmon*/temp*_enable

While at it, update a missing reference to the ufs ABI doc in the
MAINTAINERS file.

Fixes: e88e2d32200a ("scsi: ufs: core: Probe for temperature notification support")
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 .../ABI/testing/sysfs-driver-ufs-hwmon        | 31 +++++++++++++++++++
 MAINTAINERS                                   |  2 ++
 2 files changed, 33 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ufs-hwmon

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs-hwmon b/Documentation/ABI/testing/sysfs-driver-ufs-hwmon
new file mode 100644
index 000000000000..a27a108ffd28
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-ufs-hwmon
@@ -0,0 +1,31 @@
+What:		/sys/class/hwmon/hwmon*/temp*_input
+Date:		September 2021
+KernelVersion:	5.16
+Contact:	avri.altman@wdc.com
+Description:
+		Temperature input value in millidegrees Celsius.
+		Read-only.
+
+What:		/sys/class/hwmon/hwmon*/temp*_crit
+Date:		September 2021
+KernelVersion:	5.16
+Contact:	avri.altman@wdc.com
+Description:
+		Critical temperature value in millidegrees Celsius.
+		Read-only.
+
+What:		/sys/class/hwmon/hwmon*/temp*_lcrit
+Date:		September 2021
+KernelVersion:	5.16
+Contact:	avri.altman@wdc.com
+Description:
+		Lower critical temperature value in millidegrees Celsius.
+		Read-only.
+
+What:		/sys/class/hwmon/hwmon*/temp*_enable
+Date:		September 2021
+KernelVersion:	5.16
+Contact:	avri.altman@wdc.com
+Description:
+		Enable (1) or disable (0) this temperature sensor.
+		Read-write.
diff --git a/MAINTAINERS b/MAINTAINERS
index 838d3038e1ea..71a69551aee2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24070,6 +24070,8 @@ R:	Avri Altman <avri.altman@wdc.com>
 R:	Bart Van Assche <bvanassche@acm.org>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
+F:	Documentation/ABI/testing/sysfs-driver-ufs
+F:	Documentation/ABI/testing/sysfs-driver-ufs-hwmon
 F:	Documentation/devicetree/bindings/ufs/
 F:	Documentation/scsi/ufs.rst
 F:	drivers/ufs/core/
-- 
2.25.1

