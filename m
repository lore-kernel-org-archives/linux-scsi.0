Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6125467C
	for <linux-scsi@vger.kernel.org>; Tue,  9 Apr 2024 06:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712644149; cv=none; b=NLAxYMZctr2+GFiibPr5HxGR4iI/aVlGGbCSNnm9ha6h1/M+a4oqCBDqDbGg8nDS+cGRkMHaHpnSb41t1DqPCREw8nHj0JySpSTDhCBAVjk7U8pxL/xj7V+48YX9bZPlSSD+zgKwezJ2MIdU+j8DHwjPh2Z/bcwRV7NQySLr8xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712644149; c=relaxed/simple;
	bh=UmDlrk1i+RMSfD/tJiOYDcJ8LF6YOPmpFpFE87wkG4M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=uzY4+CaoM1hAKhcFZeoXyHr+gDVRlExSBz8mGnycDY6jxxSaVwQ1M5vCyDtW4J/jTfWdVIQdk+7WBpAOHpXVpMQVeeUa+CZ9V6guJ0Nvr74Bdv+IYxDa4bd32UA7vSBJKSMl+i6JuatXK1TLjnf8ZFG8OiqxMiLfcg2RyDdtaC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=k/7fDCQA; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="k/7fDCQA"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240409062903epoutp041261308dc15bb96695d64842c1adc02f~EiMZfPMiD2817528175epoutp04i
	for <linux-scsi@vger.kernel.org>; Tue,  9 Apr 2024 06:29:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240409062903epoutp041261308dc15bb96695d64842c1adc02f~EiMZfPMiD2817528175epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1712644143;
	bh=YKAjm+LxcsKnsBUvA6/M6OF+fJCqDS4hlgTXCY/y274=;
	h=From:To:Cc:Subject:Date:References:From;
	b=k/7fDCQAEdR+C3oBiuhASflgCP4vgVbLBI4bzlvJSKvcTJPb8FgBxaWYlvt+oGyIA
	 lz5ZQsENHsa3BjycdV0o9HJEOWBUdM1BciRp/sEiJEFge5oIdG2BqIsGbcVOQWQt4Y
	 6eoy/JujypjK6Jw5UEzk2KvCySSTYMB5d7QUyQ8o=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20240409062903epcas2p303f6762b6cec181ebf85fc85e2a708df~EiMZBSP2H0920309203epcas2p3X;
	Tue,  9 Apr 2024 06:29:03 +0000 (GMT)
Received: from epsmgec2p1-new.samsung.com (unknown [182.195.36.102]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VDGJG3Y9Qz4x9Pq; Tue,  9 Apr
	2024 06:29:02 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmgec2p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	72.8D.19141.E20E4166; Tue,  9 Apr 2024 15:29:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20240409062901epcas2p3eb8f13336c2dbf978db1ce980a75b3cb~EiMXepqxq0194201942epcas2p3Z;
	Tue,  9 Apr 2024 06:29:01 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240409062901epsmtrp1203ba6f78a3f5d92493156ea82a160bf~EiMXdY1792484624846epsmtrp1I;
	Tue,  9 Apr 2024 06:29:01 +0000 (GMT)
X-AuditID: b6c32a4d-b17ff70000004ac5-a5-6614e02eae36
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	1B.01.19234.D20E4166; Tue,  9 Apr 2024 15:29:01 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [10.229.95.126]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240409062901epsmtip2e5072f3afef8a44148be70d054233380~EiMXN24kW0249702497epsmtip2n;
	Tue,  9 Apr 2024 06:29:01 +0000 (GMT)
From: SEO HOYOUNG <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, sh425.lee@samsung.com,
	quic_nguyenb@quicinc.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [PATCH v2] scsi: ufs: core: changing the status to check inflight
Date: Tue,  9 Apr 2024 15:32:54 +0900
Message-Id: <20240409063254.145363-1-hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsWy7bCmma7eA5E0gx+zJC0ezNvGZvHy51U2
	i4MPO1kspn34yWzx8pCmxd/bF1ktVi9+wGKx6MY2JoutN3ayWNzccpTF4vKuOWwW3dd3sFks
	P/6PyWLqi+PsFkv/vWVx4Pe4fMXbY8KiA4we39d3sHl8fHqLxWPinjqPvi2rGD0+b5LzaD/Q
	zRTAEZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0
	upJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwLxArzgxt7g0L10vL7XEytDAwMgU
	qDAhO+Ptzp0sBQ84K271vGBtYJzG0cXIySEhYCLx4fsyti5GLg4hgT2MEuf+PWOEcD4xSvRM
	X8oK5yydfYwRpuXOxS5mEFtIYCejxOMpJRBFPxglltx9ywaSYBPQkFhz7BATiC0icJlJ4s8y
	MxCbWUBN4vPdZSwgtrCAl8SL8yAbODlYBFQl7p94AmbzClhJfO3aygKxTF5iUcNvJoi4oMTJ
	mU9YIObISzRvnc0MUTOVQ+LoF0sI20Xi1tzJ7BC2sMSr41ugbCmJl/1tQDYHkF0sMWthNcjN
	EgINjBKHZs+CqjGWmPWsnRGkhllAU2L9Ln2IcmWJI7egtvJJdBz+C1XNK9Gw8TfURF6JjjYh
	iLCSxJm5t6HCEhIHZ+dAhD0kuptXQwMtVmLvnN9sExgVZiF5axaSt2YhnLCAkXkVo1RqQXFu
	emqyUYGhbl5qOTyGk/NzNzGCk7KW7w7G1+v/6h1iZOJgPMQowcGsJMIbbCqYJsSbklhZlVqU
	H19UmpNafIjRFBjYE5mlRJPzgXkhryTe0MTSwMTMzNDcyNTAXEmc917r3BQhgfTEktTs1NSC
	1CKYPiYOTqkGptashhv5CxMnSU1u8onxeNB0MyzoaMDshE92D1WyztUEl//btmrbmolvOwRt
	p3CZzSxPLg9p0+y6ubxl4qwPB+2u7j1qm99X17b0xzzOtVGzX6gore2yUciZFpd67ZmU9hHl
	B++CfY1Odu/PdfzZWJZ1yVPNLYJ36QEryZl5cXcXSO0sF7v08d/W230HZjJ/fj1Fx97GcZr7
	ge/N3JcKq62/tK7yU5oev+rqDyZn64taR6w29/32m78qtbFt55+Vpd+Zn1vt0zK9KHaw+e+y
	4ov1UefZ56mbfFF7PyvCmJWzTXwG752NiceXRkotYf2jJG17//XeIzI6EyY4u9uGpl/7kSB2
	/p/mr4nW3TPfXVViKc5INNRiLipOBAAoyFYPUwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSvK7uA5E0gzn31CwezNvGZvHy51U2
	i4MPO1kspn34yWzx8pCmxd/bF1ktVi9+wGKx6MY2JoutN3ayWNzccpTF4vKuOWwW3dd3sFks
	P/6PyWLqi+PsFkv/vWVx4Pe4fMXbY8KiA4we39d3sHl8fHqLxWPinjqPvi2rGD0+b5LzaD/Q
	zRTAEcVlk5Kak1mWWqRvl8CV8XbnTpaCB5wVt3pesDYwTuPoYuTkkBAwkbhzsYu5i5GLQ0hg
	O6PEgx1vWCESEhL/FzcxQdjCEvdbjrBCFH1jlHj9ZT8LSIJNQENizbFDTCAJEYGnTBInDoGM
	4uRgFlCT+Hx3GViRsICXxIvzS8GmsgioStw/8QTM5hWwkvjatZUFYoO8xKKG30wQcUGJkzOf
	sEDMkZdo3jqbeQIj3ywkqVlIUgsYmVYxiqYWFOem5yYXGOoVJ+YWl+al6yXn525iBEeCVtAO
	xmXr/+odYmTiYDzEKMHBrCTCG2wqmCbEm5JYWZValB9fVJqTWnyIUZqDRUmcVzmnM0VIID2x
	JDU7NbUgtQgmy8TBKdXApC+0/2OFfb79ru7pmrrNPis+fjqTvftrhJppq0PqZ+2GmVIfd7nn
	81tv3s4VW3f+fVFzgabMU33FxT+/Fhw4ZFmqnjFBU/7fvOMb3m/VTjM+Vxpku3M5U/Al/xlZ
	q9gqPfjKhL+u431evyJ8fkyY8fwvtxLNMlQ6XSpfeM1MSZ/04+0Um8Bj++v36R7oZpZS3uYS
	c185+OPEPZMetDEW3++8PLPm5aSghqUnZ/u6zvHQOia/ViP266SO5KX2HLMqDxh/TXz+aOkO
	iUtG67nzj3A0KiQqPw176xr469OtbYdUL1Yxfnuw1W7O1MmXL74yOxGdyZP8v/PQ1svrbBJz
	N/e8/h/PemtyiLcD/zOzTCWW4oxEQy3mouJEALrzX0bzAgAA
X-CMS-MailID: 20240409062901epcas2p3eb8f13336c2dbf978db1ce980a75b3cb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240409062901epcas2p3eb8f13336c2dbf978db1ce980a75b3cb
References: <CGME20240409062901epcas2p3eb8f13336c2dbf978db1ce980a75b3cb@epcas2p3.samsung.com>

ufshcd_cmd_inflight() is used to check whether or not a command is
in progress.
Make it skip commands that have already completed by changing the
!blk_mq_request_started(rq) check into blk_mq_rq_state(rq)
!= MQ_RQ_IN_FLIGHT.
We cannot rely on lrbp->cmd since lrbp->cmd is not cleared when
a command completes.

v1 -> v2: convert the two return statements into a single return statement
And modified comment of commit

Link: https://lore.kernel.org/linux-scsi/20230517223157.1068210-3-bvanassche@acm.org/
Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 21429eec1b82..c940f52d9003 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3082,16 +3082,7 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
  */
 bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd)
 {
-	struct request *rq;
-
-	if (!cmd)
-		return false;
-
-	rq = scsi_cmd_to_rq(cmd);
-	if (!blk_mq_request_started(rq))
-		return false;
-
-	return true;
+	return cmd && (blk_mq_rq_state(scsi_cmd_to_rq(cmd)) == MQ_RQ_IN_FLIGHT);
 }
 
 /*
-- 
2.26.0

