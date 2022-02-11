Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5A7C43219
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347711AbiBKHhT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347708AbiBKHhO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:14 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18991107
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565031; x=1676101031;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=xiP1M0lFxhMkb2FeSA/f5haQvFI94F08NJluHNNUbzw=;
  b=H6YceNxEjrDJ757efQ5SwJkREnnEVhdQZGZ0FRlijDyqcIdD5ZO/Zkka
   neaYgM/D/zjgnO58dfi5O9XryPojQmQsUhSdDeBIIPaKB2MMxMhM/sFI0
   K+S7YfIZIKYcRZVnB01r6CMV0V7JAo/nye0gvuzZjuoJ8UuI1fgymb+sC
   JHK3gFKbzG0r/BaeOwFKISVIuQk3TyT9pQYOXvuMcRrQojU/Pc7jRse4y
   MbkMJK82wnPZIHlh5vcIzFG0uA7nFqp7wJN/e4sD6VatuHXlgLV4ovAXQ
   FtnlmfuGfa44pRPDh0mDyKiobfXalS638OZmCyMa20HY1SSiC035uO/bO
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675123"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:11 +0800
IronPort-SDR: iJZhJ1ehsbcpf2YCeZEPnUPi3rDFvZYblIm5I/34yLOkA1vWlTuQRLXkzEMMcD2CE/urFXmuhh
 WZEMjOLattv7R3Br6e1D1JBMFS9wI2aiTOO7Ew0h9LCTvDFdejlSX9cisvPXB8txBswDCkqfJ3
 MTjUbMiHntcMZp09May6I38+O4v2XID7JGLKBbJ9P4ED2Q29UMlXSyoX8/dWLGB+EaGG/gbu6K
 fQxIJ5gqsOeScL2h7NMfCL+bNmckD4jdNrLZOxDIUkA2y5D/9kh3RFVZX+kxc9a6WMiuwBCfIx
 PNZyUqYSMU8lR8Pa40Z08K7w
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:00 -0800
IronPort-SDR: yE8nsoLMWS8iC1MDmK2MlZnpjkDj3p+PM3zPlEhRMEII5V11Ox9wVkQkh8TigP10NQhl0/uj2H
 wrAvBbd6B6ql5fo3RRNUCxPipvPXQ0KJa4wBMOinROjnv7ZDiBIKiz0Zx+DV28ukAH9RWgVaBY
 vTpfLsZq5AFMV0D0PMCZqmzRy7tmprCXCMkVoAMhfFFD8GG1Zmn0Gtf5gHpK/2Sng3Z+fT2Bha
 7j3c7BXqEaHwhcj0+EiU2Nu8KXdrpWnhdswmFlvMxaag2yRava9i5WemQpkivblap1bpTODM/A
 L8I=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:14 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56d2x1rz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:13 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565032; x=1647157033; bh=xiP1M0lFxhMkb2FeSA
        /f5haQvFI94F08NJluHNNUbzw=; b=PvLxM2w4faaNOmvM7sLf+tZxVKBg7qQfkq
        jOjmmGjBuJI/GuvJGWVHVOCzju1P6Ugxy8uBrs7fkKprv+rEPa1znbU8gHLQc3EP
        sjVEJwyZNaPnkk0LjXQa5NtPpaK/2TC+fKi/g3QsfpAr5xhtiLuov0A4RTJ2bNRk
        W9qLCBg39fDlUFU6tiufwHx/2bc4t5MUPn+uxNzmqDxWJbSWpFUUwwPL0yapn3CU
        FbOATKkKTJDtqSfX4fHHwUl+eSiNmB91SH5GJb/+2FfkI71PH3d52x7kRFg5yT9i
        GkH7ofHbS4nqsooEdBmUTrrLa4Jay3uekSe/WXQX4jVmqJBHy8jw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id w8qpfpv0MBht for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:12 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56c0434z1SHwl;
        Thu, 10 Feb 2022 23:37:11 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 05/24] scsi: pm8001: Remove local variable in pm8001_pci_resume()
Date:   Fri, 11 Feb 2022 16:36:45 +0900
Message-Id: <20220211073704.963993-6-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_pci_resume(), the use of the u32 type for the local variable
device_state causes a sparse warning:

warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype] device_state
    got restricted pci_power_t [usertype] current_state

Since this variable is used only once in the function, remove it and
use pdev->current_state directly. While at it, also add a blank line
after the last local variable declaration.

Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
index d8a2121cb8d9..4b9a26f008a9 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1335,13 +1335,13 @@ static int __maybe_unused pm8001_pci_resume(struc=
t device *dev)
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
 	u8 i =3D 0, j;
-	u32 device_state;
 	DECLARE_COMPLETION_ONSTACK(completion);
+
 	pm8001_ha =3D sha->lldd_ha;
-	device_state =3D pdev->current_state;
=20
-	pm8001_info(pm8001_ha, "pdev=3D0x%p, slot=3D%s, resuming from previous =
operating state [D%d]\n",
-		      pdev, pm8001_ha->name, device_state);
+	pm8001_info(pm8001_ha,
+		    "pdev=3D0x%p, slot=3D%s, resuming from previous operating state [D=
%d]\n",
+		    pdev, pm8001_ha->name, pdev->current_state);
=20
 	rc =3D pci_go_44(pdev);
 	if (rc)
--=20
2.34.1

