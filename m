Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F7E77113
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717191271; cv=none; b=gcPWKo5LvLdzs89/BGWSf1KUGFuy+EyrX7u7jZgEFtgdT7SVfHH0TjY7BMMgfVPLADUbS7eYV/101O8aMnYcTA5Z4JWETLHsYR2r2NXkdzSntfZrlNlyyF5ejD07acakoqpd4tSHgiyKxss/ZrhAm4QumiFCUv1BmCtueNOOV0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717191271; c=relaxed/simple;
	bh=RS404MaW/RRWkBNJVZPcTnWbwxOOHWs8vCjY74+uM3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=mIO7MNYhnMb9iajr7QrIDcDxuVxPUpDKI5eyimqxbAAO5VJS4kcrqw3YS+Xu4Rqb5Xw8+kBIu6Lcss8H52WZMY6bXZSBxtnI2hW2hq/jElzhmq5iekGzv4dfUnioGDNt3JIxVV5VJf+xLAGFrFbL99MisFAZvZfYTWtiDxaEYb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rQyAMHzt; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rQyAMHzt"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240531213427epoutp031d810a7139dbfe468f0891967e54a31d~UsFwNlmTU2046220462epoutp03a
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 21:34:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240531213427epoutp031d810a7139dbfe468f0891967e54a31d~UsFwNlmTU2046220462epoutp03a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717191267;
	bh=YTBytlr7ecZYCvMxUYhfydMV+Bi6kPS36xosbNeI0cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQyAMHztBoBoy+N/KsuluaMiAr3fQIOcfE3WmIS14oE2Umi1kwDGfOQYHI4e/adPw
	 bKm/c/ePk6zCEL6T7nB4U1ujXxfcImuttmElwDHxWRxvxarwpPeXu3dtxRtNYkvm77
	 FN45M9NGdrIAXADC5BmdFybiYFN55lHhiNKLhNx4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20240531213426epcas2p179b6939ef325166973d6f569e1389f10~UsFvcWJg-1103811038epcas2p1W;
	Fri, 31 May 2024 21:34:26 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.90]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Vrbwx5SH1z4x9Pp; Fri, 31 May
	2024 21:34:25 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	8F.35.09479.1624A566; Sat,  1 Jun 2024 06:34:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20240531213425epcas2p477d443427f706b999e81432393bfdc8a~UsFuHsr9v2198821988epcas2p49;
	Fri, 31 May 2024 21:34:25 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240531213425epsmtrp2573c90bc02eb722d9a6b605f38f9efd5~UsFuG7FVd0808808088epsmtrp2x;
	Fri, 31 May 2024 21:34:25 +0000 (GMT)
X-AuditID: b6c32a48-ea7ff70000002507-8d-665a42619b59
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	18.F6.07412.0624A566; Sat,  1 Jun 2024 06:34:24 +0900 (KST)
Received: from localhost.dsn.sec.samsung.com (unknown [10.229.54.230]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240531213424epsmtip26f28ca152e1f446c95d844ba27f85083~UsFt4LerI1505315053epsmtip2t;
	Fri, 31 May 2024 21:34:24 +0000 (GMT)
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche
	<bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, Minwoo Im <minwoo.im@samsung.com>,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>
Subject: [PATCH v2 2/2] ufs: mcq: Prevent no I/O queue case for MCQ
Date: Sat,  1 Jun 2024 06:22:44 +0900
Message-Id: <20240531212244.1593535-3-minwoo.im@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531212244.1593535-1-minwoo.im@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmhW6iU1SawYFfGhYP5m1js3j58yqb
	xbQPP5ktbh7YyWSxsZ/D4v7Wa4wWl3fNYbPovr6DzWL58X9MFs9OH2B24PK4fMXbY9qkU2we
	H5/eYvHo27KK0ePzJjmP9gPdTAFsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKzAv0
	ihNzi0vz0vXyUkusDA0MjEyBChOyM6Z3LGUt2MpZcbrrGnsD43X2LkZODgkBE4klZ84B2Vwc
	QgI7GCV2///MDOF8YpQ43NLDAuF8Y5S4dnENI0zLwe4msHYhgb2MEkfeakEU/WaUeHVlOlgR
	m4C6RMPUVywgtojAYkaJuav5QIqYBV4wSnxbOI8JJCEs4Cyxa88DsAYWAVWJrk9X2LoYOTh4
	BWwkNv+ohlgmL7H/4FlmEJtTwFbi/dbtYDavgKDEyZlPwOYzA9U0b50NdraEQCuHxI9vF1gh
	ml0kPszdBvWosMSr41ugbCmJz+/2skHY5RI/30yC+qxC4uCs22A3SAjYS1x7ngJiMgtoSqzf
	pQ8RVZY4cgtqK59Ex+G/7BBhXomONiGIGcoSHw8dYoawJSWWX3oNtcdD4tHB5UyQkJrAKNH5
	7zvbBEaFWUiemYXkmVkIixcwMq9iFEstKM5NTy02KjCBx29yfu4mRnAy1fLYwTj77Qe9Q4xM
	HIyHGCU4mJVEeH+lR6QJ8aYkVlalFuXHF5XmpBYfYjQFhvREZinR5HxgOs8riTc0sTQwMTMz
	NDcyNTBXEue91zo3RUggPbEkNTs1tSC1CKaPiYNTqoGpWTmUW0x4jsi0fu9406Jnp+ZbzGw5
	wXql+gzL2mlvlj7VDNYtlXY5/ztH+Oy/RaWe95/nz314fWv5Ux6/1JWX/BuKF/Wef3S6OKNC
	tzHfZfpHQ6WrXwPOPvx0kCNgl1tzy7yNU5x2GuU9Lmm+u2HXsjxnS5f9z1Ym9j20P/dx6eyl
	yqEzfhpFe+drpJkyXleNz1oaee/aYlHVaY4CHFWd62WDVRLzmvR378944Lp5v5ygrl6nzz3e
	I4fWqGt9e8vEFrngGNuFNNbF63/wmVRY9H0LvJsuNH/eRMsFG9XX7NrVsIGt9PP6H8Gqyw49
	fWSzeOuTnxevRD9cU5Dy9bqB+5KVizsyuRV+KDy7a18apMRSnJFoqMVcVJwIAHig4PkvBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWy7bCSvG6CU1SawczH1hYP5m1js3j58yqb
	xbQPP5ktbh7YyWSxsZ/D4v7Wa4wWl3fNYbPovr6DzWL58X9MFs9OH2B24PK4fMXbY9qkU2we
	H5/eYvHo27KK0ePzJjmP9gPdTAFsUVw2Kak5mWWpRfp2CVwZ0zuWshZs5aw43XWNvYHxOnsX
	IyeHhICJxMHuJiCbi0NIYDejxJLFZ5khEpIS+07fZIWwhSXutxxhhSj6ySixoO8AI0iCTUBd
	omHqKxaQhIjAYkaJJ+fegDnMAu8YJXbvmcAEUiUs4Cyxa88DsA4WAVWJrk9X2LoYOTh4BWwk
	Nv+ohtggL7H/IMRmTgFbifdbt4PZQkAlr3dPB7N5BQQlTs58wgJiMwPVN2+dzTyBUWAWktQs
	JKkFjEyrGCVTC4pz03OTDQsM81LL9YoTc4tL89L1kvNzNzGCg19LYwfjvfn/9A4xMnEwHmKU
	4GBWEuH9lR6RJsSbklhZlVqUH19UmpNafIhRmoNFSZzXcMbsFCGB9MSS1OzU1ILUIpgsEwen
	VAMTo/RNvq6QDX80bfZf4M3//MgzNWxpy7t1HrGlG4y6V8mFx1QKeDyX5vGVffVg19+go4+u
	pLJ0aoS9+vOoRnNyqKPF6cUlVZ9fT4ky5cy8YK/W7W5tnNCho/Q82Em8tk9qVemiIq21siJ6
	Wht42ZkP1J67Pu9o74HiOmPLPO6PbwR3Kv44mJK0bmtOb3y2U7vwb7O/NS+fftLld7b5z7tr
	inPm/u1GTa+YH4grSd04+dZbKFt5BhcDww5Px7n8n1QWrO86/FhA4+7qyf94ky8qFPP6XnB4
	8/fKDU+h82aPY3q4Zy308khPZrpfatu4o+jAM9MDupf1fNfd1NTW4pv1YbHWUdvc+Z+3vv51
	Y5oSS3FGoqEWc1FxIgBYj7eW7QIAAA==
X-CMS-MailID: 20240531213425epcas2p477d443427f706b999e81432393bfdc8a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531213425epcas2p477d443427f706b999e81432393bfdc8a
References: <20240531212244.1593535-1-minwoo.im@samsung.com>
	<CGME20240531213425epcas2p477d443427f706b999e81432393bfdc8a@epcas2p4.samsung.com>

If hba_maxq equals poll_queues, which means there are no I/O queues
(HCTX_TYPE_DEFAULT, HCTX_TYPE_READ), the very first hw queue will be
allocated as HCTX_TYPE_POLL and it will be used as the dev_cmd_queue.
In this case, device commands such as QUERY cannot be properly handled.

This patch prevents the initialization of MCQ when the number of I/O
queues is not set and only the number of POLL queues is set.

Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 46faa54aea94..4bcae410c268 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -179,6 +179,15 @@ static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * Device should support at least one I/O queue to handle device
+	 * commands via hba->dev_cmd_queue.
+	 */
+	if (hba_maxq == poll_queues) {
+		dev_err(hba->dev, "At least one non-poll queue required\n");
+		return -EOPNOTSUPP;
+	}
+
 	rem = hba_maxq;
 
 	if (rw_queues) {
-- 
2.34.1

