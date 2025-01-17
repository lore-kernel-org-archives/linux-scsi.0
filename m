Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A25722619
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 07:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737098181; cv=none; b=BiJYbbm+sZHrG0/b2qyvqKIn3ZONlNmOkEhpDS+6eK47Fe6TzK3v7bUemfFbPf+5Sv81Gy2noqR015bZMAf/056vRYYx26smNnEjTwhnobWy1KH9yQugnQW3sbiKTcfsK2DPDROf9x9LWr2HkrK5pzfLkXqXfRgGkSJCQA3/Kqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737098181; c=relaxed/simple;
	bh=/sj5ZgPm0dfC4CUCtdnrE3oxe4/zNEANnj2y/6OBdDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=gsKdZxnAdDIxowjhy5sOOofHDObjJYGJ9huQvk5Pz0FjES0v7hV/pHmEcew6QYX5U/bLAu35KYrqublcpHq4rj54r74yomZaih4CYs3V28tqZyepPIKq6lO52m0nbzNP39Dh9OMZIGQLyBv8NEnqUJKrPVGfAqLTFBvx1QleFnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mxE239R6; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mxE239R6"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250117071609epoutp01045c165347078ecf6ce1718788d8d30c~baZTwd2NZ2690526905epoutp01W
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 07:16:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250117071609epoutp01045c165347078ecf6ce1718788d8d30c~baZTwd2NZ2690526905epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1737098169;
	bh=Up4eoPAPUo53/0vYQjr9RuLTopWiBChT/5guU0m/EjE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=mxE239R6BCUrY48/X9i3802hUcH01/VY5xlGRWapCBSSNGFSvldL5q+mWtqJ8Ucag
	 bOkI2faN2YXktzRa6Xgzyax9w1pSf3jSpyEcN/BZYTiLzpsCa+2I1cd3EW8fGcwIXD
	 /zHNM2fEw3vfRBeL6G938wv/sYciFl4jJyUfSqgM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTP id
	20250117071609epcas1p151a7e8ffd69d299cf066ce635486c84d~baZTjODbz2042320423epcas1p1n;
	Fri, 17 Jan 2025 07:16:09 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.38.243]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4YZ9y06H57z4x9QC; Fri, 17 Jan
	2025 07:16:08 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
	epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	DB.24.21650.4B30A876; Fri, 17 Jan 2025 16:16:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20250117071604epcas1p44c7f7898b826ad8762cfdd79aa31bbf5~baZO-L2QG1952619526epcas1p4j;
	Fri, 17 Jan 2025 07:16:04 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250117071604epsmtrp1fc71cbf41e920ccba6ce6772346aacbd~baZO_dCI12030020300epsmtrp1x;
	Fri, 17 Jan 2025 07:16:04 +0000 (GMT)
X-AuditID: b6c32a35-093de70000005492-a8-678a03b4e411
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D7.9F.23488.4B30A876; Fri, 17 Jan 2025 16:16:04 +0900 (KST)
Received: from sh043lee-960XFH.. (unknown [10.253.98.183]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250117071604epsmtip17ffe2c7ea7f2f14a3dc5d5e48a0f2e51~baZO0wG7P0507505075epsmtip1b;
	Fri, 17 Jan 2025 07:16:04 +0000 (GMT)
From: Seunghui Lee <sh043.lee@samsung.com>
To: linux-scsi@vger.kernel.org
Cc: Seunghui Lee <sh043.lee@samsung.com>
Subject: [PATCH] scsi: ufs: core: Fix error return with query response
Date: Fri, 17 Jan 2025 16:16:00 +0900
Message-ID: <20250117071600.19369-1-sh043.lee@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsWy7bCmge4W5q50g8sTLCy6r+9gs2j6s4/F
	gcmjb8sqRo/Pm+QCmKKybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1Nt
	lVx8AnTdMnOAxisplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCswK9IoTc4tL89L1
	8lJLrAwNDIxMgQoTsjNONSxiLljHXvHi22q2BsYmti5GTg4JAROJzy+/MnYxcnEICexglDjx
	YwIThPOJUWLJ/bfsEM43RolrbSdYYVqOXVzOBpHYyygxb+oCqP73jBL/Xv5kAaliE9CSmL5p
	CxOILSIgJ7F5+VewOLOAhsTLhglgy4UF3CTWTJsNVsMioCrR8KWXEcTmFbCSuLxpFjvENnmJ
	xTuWM0PEBSVOznwCNUdeonnrbGaQxRIC/ewSLa1zoc5zkfgwbwdUs7DEq+NboGwpiZf9bewQ
	Dc2MEm0NIBeBOBMYJV4seMUEUWUv0dzaDHQeB9AKTYn1u/QhtvFJvPvawwoSlhDglehoE4Ko
	VpZ4+WgZVKekxJL2W8wQtofExMevwJ4REoiVWHxyMeMERrlZSH6YheSHWQjLFjAyr2IUSy0o
	zk1PLTYsMITHZXJ+7iZGcMLSMt3BOPHtB71DjEwcjIcYJTiYlUR40353pAvxpiRWVqUW5ccX
	leakFh9iNAWG6kRmKdHkfGDKzCuJNzSxNDAxMzKxMLY0NlMS572wrSVdSCA9sSQ1OzW1ILUI
	po+Jg1OqgSlm/awVy5t1N65ccoJX83aCrlbVbb8fC2q8LboXHJm2di1724bUi355a4zOXX/0
	XLnL+Wv7YZ7A7z4aTNX7Jk1J/LX5woK5v4SfKCTwu9/ft7HLN4R/6aJpDXuWSim9WjsnrMj1
	0rlVfxKjsrJ07paZrD5o5mtqNlNKSP7asdvdqW6nwk9fPtdfJpIhKnw0uEzBYIK7UqBN867j
	jnO+T01fMl9c76FMyrs/7F593Y1T3/Veb1xyx8P1V0VxYJhpdtZryUtecgsvTG5Om3mjViHk
	dO4+P2bd5gOP94n+4NJSj/aK3naVo+fmRa1r/3yPdF0Uu9gqanh+16moYOVXEZwCtWeeirk9
	VXJp3ysqIKrEUpyRaKjFXFScCAAMbkm/4QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42LZdlhJTncLc1e6wc0eeYvu6zvYLJr+7GNx
	YPLo27KK0ePzJrkApigum5TUnMyy1CJ9uwSujFMNi5gL1rFXvPi2mq2BsYmti5GTQ0LAROLY
	xeVANheHkMBuRokpVy8wQiQkJRY/egiU4ACyhSUOHy6GqHnLKLH3bz8LSA2bgJbE9E1bmEBs
	EQE5ic3Lv4LFmQU0JF42TABbICzgJrFm2mywGhYBVYmGL71g83kFrCQub5rFDrFLXmLxjuXM
	EHFBiZMzn0DNkZdo3jqbeQIj3ywkqVlIUgsYmVYxSqYWFOem5yYbFhjmpZbrFSfmFpfmpesl
	5+duYgQHlZbGDsZ335r0DzEycTAeYpTgYFYS4U373ZEuxJuSWFmVWpQfX1Sak1p8iFGag0VJ
	nHelYUS6kEB6YklqdmpqQWoRTJaJg1Oqgal4FeeT3QZMZlq/nvpIPl6QPP3n/q/8C6YL2nsc
	uut/0q7EZ9es3w3+6t9Ft9t2TG/bmfvjakGYUfS94gbzQJGW9UdEbTXt4r69jdYN9mQMfPH3
	E7uVw9PotWdzbyUtO1DV/X/x52cO0mwcQQLe4WtNmbsLPtQ92KfDJL/36+Lt/ofKos8XRL+7
	sj3mb8wJf3MvuYrLDM1vn8v2b9PjUxZ39vvUMEVePOpzRLf37sCl03+d4b45yYk/4GHb3cCH
	/te3Tr68d5vc+sXSIQG2V+b9+brbeOEfOdWnXfU+rVUrPp7dqO3875LPrQ3zqrMElhSFuh56
	YPT3bClvmVCv5PFd75ollR82/1jN/OGg4AUlluKMREMt5qLiRAAH2YvdmQIAAA==
X-CMS-MailID: 20250117071604epcas1p44c7f7898b826ad8762cfdd79aa31bbf5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250117071604epcas1p44c7f7898b826ad8762cfdd79aa31bbf5
References: <CGME20250117071604epcas1p44c7f7898b826ad8762cfdd79aa31bbf5@epcas1p4.samsung.com>

There is currently no mechanism to return error from query responses.
Return the error and print the corresponding error message with it.

Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9c26e8767515..6b27ea1a7a1b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3118,8 +3118,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case UPIU_TRANSACTION_QUERY_RSP: {
 		u8 response = lrbp->ucd_rsp_ptr->header.response;
 
-		if (response == 0)
+		if (response == 0) {
 			err = ufshcd_copy_query_response(hba, lrbp);
+		} else {
+			err = -EINVAL;
+			dev_err(hba->dev, "%s: unexpected response %x\n",
+					__func__, resp);
+		}
 		break;
 	}
 	case UPIU_TRANSACTION_REJECT_UPIU:
-- 
2.43.0

