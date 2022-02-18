Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79341C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiBRDQI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:16:08 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiBRDPu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:50 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9091BAC68
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154135; x=1676690135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3co+YfVmCl22mdl0oAzrKAatpfLkzp43oEFR53BRMyM=;
  b=cXzM1JwU2V0x0H3GsDHWl+Tm8Dh92zV1dFITYnHiNeWkfXR8dCM9buTJ
   XJlvHSI8nw4RDS0vVkOctpJ0zrtA9B7PbQrP0xZJzrCsABAozzGyoC7+Z
   H16llSiTAL49MNhEb4ZutGJ+SrD/UJX68vPAcDJpwoX9BnD4QCA5Dq1AG
   QnYofdqBEdwXp+FOF27Sm+rwK27dhsRnjZaNkgE6ATUN9Fg66MaLIFGsR
   bcwT68mFqS/Y5xRR6F9RLpm0gh+QeGeXIVkriFuEXZtHPWxtrH7JwwVdA
   wDSCvZ1/vRynxN4fG2nK9F2STWBzxWMmhZgHuEhVd/U0+LcK5EY6E/Ebi
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="192180431"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:35 +0800
IronPort-SDR: ZFW4XFhEQISesgzRbCkK88f0zltdTTPCiLvgsJJnaJjsqDRl/rl0S8q0OQqPNI2biE8N8mLGZL
 jFbtN6sMlelY4/ULNSHugrFWpKayhUvXhfwV3wNBw0OooZWISG55YUJ+2HVBVMGZnoYQcuKr2u
 kvrCBbKWuUOERaEFN0Tahm48U7P9iynKHN+iYe//nAnIW3j8z3knnmj7X4Hkx/5qI1qe9cX5Ie
 Kydjkvk1SjaZIRSfXD46C1mf2P4rxjPyH7/xkg0hLhss13cKpmi9FTkwE3WQw66z+0epXonQwb
 buYq2ti65lNKJoeqKMa4cewJ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:47:13 -0800
IronPort-SDR: y8RCpg9DJpDvB1AaWVTfjV0/Khd1FgYu/dE1KyaRAEtj13hHUPf7kFDZGs7bZEYZ3ca0OOjPDV
 TdkG/eyirs92OJ/mnFt4Xol+DWJGish+g97mvCDBfSQIqgvmXL18qDCWYRgYM/pINcWbMNFAUK
 qF1uYiEidwZKUHpTdkJv+2ANNsHvtBJuLgsoTOL5Z7xfuGRMEss6ux0s+6UYPqbGSracEDDC4P
 j2jmQ/taU2zDOQ/llA90XExe9RRH6kXk9WplH4lhSUiwN7TPm2ZHTQ84sG/RMwkkmKvdnZV5RR
 9Ws=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:35 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0GzV6Y5jz1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:34 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154134; x=1647746135; bh=3co+YfVmCl22mdl0oA
        zrKAatpfLkzp43oEFR53BRMyM=; b=k6ZY4vFf7B4gRrfnrJ0gGgC0O3m3kv9w9c
        Kzk+5s0wXvI0aeSisO5H7eWtBcVeE71BIpHlkF1nHLxLjI1Y0LJJ+VKHo6e5bCEU
        FhvOx31Npun9PW5c01LqVvINJbTIkb1kJUWokCdVgTj0BwZ3G5tVqTrPT97ky+Ec
        HCQ6Dh9kteAyxMYQr8XDFXtdPOL47ROCFNcnNE1BGzqxCFLAjWshpV4eEmH5+F6S
        K2GbQKM39nHSIfnxaCWa4L1HLSEjofAux/H1hrw53byZRy9Wv+V9RNvqq05KGbX6
        NVgeVKE+xPqPAz9UkPfn5gYqrQhqgb8MnMkh6/iZNrXbvp1CXdvw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Vtaanc2Zf4Tw for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:34 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0GzT3PYSz1Rwrw;
        Thu, 17 Feb 2022 19:15:33 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 31/31] scsi: pm8001: Fix pm8001_info() message format
Date:   Fri, 18 Feb 2022 12:14:45 +0900
Message-Id: <20220218031445.548767-32-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the driver messages more readable by adding a space after the
message prefix ":" and removing the extra space between function name
and line number.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm800=
1_sas.h
index 2aab357d9a23..d78e6690333f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -71,7 +71,7 @@
 #define PM8001_IOERR_LOGGING	0x200 /* development io err message logging=
 */
=20
 #define pm8001_info(HBA, fmt, ...)					\
-	pr_info("%s:: %s  %d:" fmt,					\
+	pr_info("%s:: %s %d: " fmt,					\
 		(HBA)->name, __func__, __LINE__, ##__VA_ARGS__)
=20
 #define pm8001_dbg(HBA, level, fmt, ...)				\
--=20
2.34.1

