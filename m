Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37647372EC0;
	Wed, 22 Apr 2026 07:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776843977; cv=none; b=WuLh81wGlS0gBnxdBttQXu4OdqoOHVjsFgUvD/5D70BB3BDX/vSwwdXYcR0meItxW+Q82fXwJmoVRAG3N4XuhCVjKE4sIhw7SQHIPfJ/oBlD5E++usaS6ylWa5Yr9UJVDvuQ6TbR3Clf9NqMXiVZhozO+1Zq0f8ijguDVQXbSsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776843977; c=relaxed/simple;
	bh=7JUbXwObYN0jPiym74bhNHfFK49qnNlVIxpBiQBgrgI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PugPlztOsWKgrSOQO0vZbA0jbPrUF8W1EA3x9TWaeE322NeYaysWrgcuPnMLiDkZNJFdZRSMsNRPzKpXivDBeC/zQqJLXDyXNW5qdTn+it6C5QRJ00shFQPWK7IcqsMhHfc04zdN2OoEISv0QFrio+3nBBJl+Sw2AbmwnYa0o4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from spam.asrmicro.com (localhost [127.0.0.2] (may be forged))
	by spam.asrmicro.com with ESMTP id 63M7Llnl043760;
	Wed, 22 Apr 2026 15:21:47 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 63M7L0Xs043561
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Wed, 22 Apr 2026 15:21:00 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Wed, 22 Apr 2026 15:21:03
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: ufs: core: call hibern8 notify when hibern8 cmd failed
Date: Wed, 22 Apr 2026 15:21:02 +0800
Message-ID: <20260422072102.1204886-1-hongjiefang@asrmicro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: exch01.asrmicro.com (10.1.24.121) To exch02.asrmicro.com
 (10.1.24.122)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 63M7Llnl043760

The vendor hibern8 notify callback always can be executed in the
PRE_CHANGE phase of hibern8 enter/exit. But it cannot be executed
in the POST_CHANGE phase if the hibern8 cmd fails.

When the hibern8 cmd fails, the vendor hibern8 notify callback
should still have the opportunity to execute.

Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
---
 drivers/ufs/core/ufshcd.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9ceb6d6d479d..02091e72f8db 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4500,9 +4500,8 @@ int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
 			__func__, ret);
-	else
-		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER,
-								POST_CHANGE);
+
+	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER, POST_CHANGE);
 
 	return ret;
 }
@@ -4526,12 +4525,12 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
 			__func__, ret);
 	} else {
-		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
-								POST_CHANGE);
 		hba->ufs_stats.last_hibern8_exit_tstamp = local_clock();
 		hba->ufs_stats.hibern8_exit_cnt++;
 	}
 
+	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT, POST_CHANGE);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
-- 
2.25.1

