Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B5F227586;
	Tue, 10 Dec 2024 05:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809322; cv=none; b=CYhdQEZNUPrSNem/XEb9YmuecFhp8wcGoVc/wgEsIlcIc6nXqpA5RVlA/qsyocRLb5GFRj6A386VliRJC9/oXG6J0XvnPwY8WphgmxbQXXwMFZCFGlcoeGZK+b84WHSQYdcORcwjqov99S5OemBMKViIecw+CGzBEegWnsW+Uys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809322; c=relaxed/simple;
	bh=vnI6oV2IOEBJDB7cr15+QsQC5zROnqgDjJXFFolGBhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPc4xOhd62zy7m45MrLHD+91Hu9Jjjb9L4jdISb1S/DRbgAwFdUzHpr94iKJdnodL/4Sh3QjVXCHFmgvN4vSyy3ETqGYU5SgzLO4Q8EjhrU02RRhdmO3/CNBJbJzvlIfpGElLU4gkN7BdKd7nbtY98QzdR/LwTnhN9fdMdkzWxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HFKtCLIt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HFKtCLIt"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9MLtEY018470;
	Tue, 10 Dec 2024 05:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9b7d+qyvkKmlZann7
	J+1XFkGmFtpdtEdxyDOAxkGRuc=; b=HFKtCLItxw+KCK/uI1qeGE3R6e6tNmeAI
	qIUNQueHcNFM6zsGep6lJ9UwqgGMwlrMwQWK7wyhaDFmA02y5OS13cv3M5wsmh9f
	4oVdoaluCLgI57+Q1UpWnhpaomo4cS/9pShC7kELqlSEr/70/DJSho7+axxDjuCl
	fc/2gd8QeO7yFmyvHgWlWtEr20KdgQ+rLZM0CKPj3r/8qwfuWG5Co3H0l/VwNKNI
	NCvmbaxYBxtnLda1MDjkhbdHJ9kthkSLF8YMD0D30biH/+6ppRd6b4KzFZg8H6Hr
	drQ+klz8LDzvPwZZqx8imiqzVo4XXdRzb2BvfdZGqrrqfyBpQ1cZg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cbsq4jjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 05:41:55 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA4trxY017369;
	Tue, 10 Dec 2024 05:41:55 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43d3d1hu7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 05:41:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BA5frog65601834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 05:41:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48BBD20043;
	Tue, 10 Dec 2024 05:41:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8C4E20040;
	Tue, 10 Dec 2024 05:41:52 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.63.197.14])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Dec 2024 05:41:52 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.5.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 438FC60AF0;
	Tue, 10 Dec 2024 16:41:47 +1100 (AEDT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fbarrat@linux.ibm.com, ukrishn@linux.ibm.com,
        manoj@linux.ibm.com, clombard@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH 2/2] scsi/cxlflash: Deprecate driver
Date: Tue, 10 Dec 2024 16:40:55 +1100
Message-ID: <20241210054055.144813-3-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210054055.144813-1-ajd@linux.ibm.com>
References: <20241210054055.144813-1-ajd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZpxFikb_j4vs-7Bvs-T4OsDSdT_Ho2Al
X-Proofpoint-GUID: ZpxFikb_j4vs-7Bvs-T4OsDSdT_Ho2Al
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=625 adultscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 impostorscore=0
 suspectscore=0 spamscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412100039

We intend to remove the cxlflash driver in an upcoming release. It is
already marked as Obsolete in MAINTAINERS.

The cxlflash driver has received minimal maintenance for some time, and
the CAPI Flash hardware that uses it is no longer commercially available.

Add a warning message on probe and change Kconfig to label the driver as
deprecated and not build the driver by default.

Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
 drivers/scsi/cxlflash/Kconfig | 6 ++++--
 drivers/scsi/cxlflash/main.c  | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/Kconfig b/drivers/scsi/cxlflash/Kconfig
index 5533bdcb0458..c424d36e89a6 100644
--- a/drivers/scsi/cxlflash/Kconfig
+++ b/drivers/scsi/cxlflash/Kconfig
@@ -4,10 +4,12 @@
 #
 
 config CXLFLASH
-	tristate "Support for IBM CAPI Flash"
+	tristate "Support for IBM CAPI Flash (DEPRECATED)"
 	depends on PCI && SCSI && (CXL || OCXL) && EEH
 	select IRQ_POLL
-	default m
 	help
+	  The cxlflash driver is deprecated and will be removed in a future
+	  kernel release.
+
 	  Allows CAPI Accelerated IO to Flash
 	  If unsure, say N.
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 60d62b93d624..62806f5e32e6 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3651,6 +3651,8 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	int rc = 0;
 	int k;
 
+	dev_err_once(&pdev->dev, "DEPRECATION: cxlflash is deprecated and will be removed in a future kernel release\n");
+
 	dev_dbg(&pdev->dev, "%s: Found CXLFLASH with IRQ: %d\n",
 		__func__, pdev->irq);
 
-- 
2.47.1

