Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EFD26562C
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 18:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745433188; cv=none; b=FfbZgDoM2iCgESbWsUDz5OZyFwS6afh+86NY772s2sWsbSuHv2fyv/l7C/YeBiRJz2FIUo5kafI6Ugs20yUP5asXG6Ju644j4ZRM07SK5IcKTL6ygLSPlfT/XP26lIimvYs1Wg3g3Y7JpLCN51MNuR2sfCJ/KQfw8PG+7zOtgg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745433188; c=relaxed/simple;
	bh=n0xt0EwP5kUz+i3RaH/wuQlIapQKYFjYfIh5C7n3hIE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l+HIgxSsSRhMNaJFBRtNS1LslWGdMc6gufUGVYVDb9YXn5piSvsyTWtW5X0ielJqPmTRZYiAkZVlvcV527vbV0yy9oSJI0PFdJkksq0SmBrCVGkeNPqcMuVy3ZgCDBR5PREipOyX3XkTOguJcnJgneSxr/MDbJ5ICk5tIN9+QKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=uyc03by5; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="uyc03by5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1745433188; x=1776969188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n0xt0EwP5kUz+i3RaH/wuQlIapQKYFjYfIh5C7n3hIE=;
  b=uyc03by5LRxMPk6GluodOggELif2I8rrrSSN9w7zb9V90Vw3/Z0nkrNK
   iveKS5VaRkP4n5GZWAFtaGuHAimpr0uART8HRPQqTzdpdqHrPkiy1yKsG
   zkJXC3Z0ZnwWEi/AFQDGzXm32pwTv7jkIYxmAfTlY8QGaGDDfAnPB38dG
   YuZMR6bdersZRCNRVyxsc4woStTyG8g1+LuJWl/OPZuyj+Yh9kGGvvi1M
   +3OBPS+1KjVQohIsHze/EPUDJ3qgjJQK2inhR8XdVazl0RFuWgWGBI7++
   ekBzff0S28IBYIfQdIv7GQ4oiczED3HrtR9SdLUhGb1zHxuE+Lpb/nB7Y
   g==;
X-CSE-ConnectionGUID: whCUM/FPRpqRy+T/Tuj6Xw==
X-CSE-MsgGUID: B3/WCib2Q2G84vT2Q+gSrw==
X-IronPort-AV: E=Sophos;i="6.15,233,1739862000"; 
   d="scan'208";a="40821228"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Apr 2025 11:33:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 23 Apr 2025 11:32:36 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.44 via Frontend
 Transport; Wed, 23 Apr 2025 11:32:35 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <hch@infradead.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<joseph.szczypek@hpe.com>, <POSWALD@suse.com>, <cameron.cumberland@suse.com>,
	Yi Zhang <yi.zhang@redhat.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 5/5] smartpqi: update driver version to 2.1.34-035
Date: Wed, 23 Apr 2025 13:32:29 -0500
Message-ID: <20250423183229.538572-6-don.brace@microchip.com>
X-Mailer: git-send-email 2.49.0.391.g4bbb303af6
In-Reply-To: <20250423183229.538572-1-don.brace@microchip.com>
References: <20250423183229.538572-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Update driver version to  2.1.34-035.

Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index e8abfc56d0f0..a7ab87220c0c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -32,11 +32,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"2.1.30-031"
+#define DRIVER_VERSION		"2.1.34-035"
 #define DRIVER_MAJOR		2
 #define DRIVER_MINOR		1
-#define DRIVER_RELEASE		30
-#define DRIVER_REVISION		31
+#define DRIVER_RELEASE		34
+#define DRIVER_REVISION		35
 
 #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
-- 
2.49.0.391.g4bbb303af6

