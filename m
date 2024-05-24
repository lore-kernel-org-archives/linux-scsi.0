Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FAE79C8
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 01:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716515954; cv=none; b=nixjCkBBjUEZytxPcAPLyMn3vCPFjG8403m2Nb4kf9frbCF2lshG6LAJdyQgF3+EIiBO5/7F4sxzjrswar/Jx3r61sGIRnlZ2CSma29mnkcPfOEdTdYry5uyl7xMKPdG1c71hZ59ka91g9szJMfT/YLCEtip7lr6x6dvXzkAvPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716515954; c=relaxed/simple;
	bh=8HvXOKkqios4yzwlfe0hQTKvICnw8ZVW3mMRcplGCRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=GJuTPKGljj+vxJStrCRNJ/SCzjXxx21gmLAZ4QIXDHfWjJBtjsqdJ8Wsq5PoCu3hUNWdN/ekkPUAjNeoiDZkF4RMuffJ8KXu6ZKksxLLJH+zFnEfy+1Ygw1dwfStzaxq9GI4F+FT/0Ca6KVOoWikldYGmfiN3sV2+UtV7zTqx6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eUGIU/x4; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eUGIU/x4"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240524015908epoutp03d6009c90c6a5662af5802d318516fa92~SSikqeuYy0302403024epoutp031
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2024 01:59:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240524015908epoutp03d6009c90c6a5662af5802d318516fa92~SSikqeuYy0302403024epoutp031
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716515948;
	bh=Lc51D5b48Af/XQTwq2XFWVLT/g5JdkG0gRQi0KSFZYs=;
	h=From:To:Cc:Subject:Date:References:From;
	b=eUGIU/x4rpJ18TdxQtu955Ex+a4Ej/90jHUUIc6CjNxr3fQfAKDhRE7pi2DDIoCx+
	 1Q9jyOXFkkvEMek2pJewtZNRZnv8SQ4LC+bvRBjXnJq75idkmaLdcb6uK5TCIZq5B8
	 DJYDO6J+eWVeAc19KyQ8aOZTGdQWuY2uRLjSPWwM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTP id
	20240524015908epcas1p466445ee52a12daa12ceffe0f86919b88~SSikMFJbf2205322053epcas1p4M;
	Fri, 24 May 2024 01:59:08 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.38.249]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4VlpB35Vz3z4x9QK; Fri, 24 May
	2024 01:59:07 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
	epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	D2.9A.10158.B64FF466; Fri, 24 May 2024 10:59:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240524015907epcas1p2598a2ba8a81529b6639cff007fe9106b~SSijih1Oj0170501705epcas1p2T;
	Fri, 24 May 2024 01:59:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240524015907epsmtrp26cd1de8f56036ec4a4f8df6a7014b87d~SSijh1hrc0720707207epsmtrp2K;
	Fri, 24 May 2024 01:59:07 +0000 (GMT)
X-AuditID: b6c32a38-8e1ff700000027ae-47-664ff46bb858
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D7.D6.08924.B64FF466; Fri, 24 May 2024 10:59:07 +0900 (KST)
Received: from lee.. (unknown [10.253.100.232]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240524015907epsmtip1067e709a65e6b21fb946d5f0a5616f2d~SSijWM8Sg2280522805epsmtip1c;
	Fri, 24 May 2024 01:59:07 +0000 (GMT)
From: Chanwoo Lee <cw9316.lee@samsung.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	quic_nguyenb@quicinc.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chanwoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH v2] ufs:mcq:Fixing Error Output and cleanup for
 ufshcd_mcq_abort
Date: Fri, 24 May 2024 10:59:04 +0900
Message-Id: <20240524015904.1116005-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdljTQDf7i3+awftDGhYP5m1js3j58yqb
	xbQPP5ktZpxqY7XY2M9hcXnXHDaL7us72CyWH//HZDH1xXF2B06Py1e8PaZNOsXm8fHpLRaP
	iXvqPPq2rGL0+LxJzqP9QDdTAHtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKzAr3i
	xNzi0rx0vbzUEitDAwMjU6DChOyM6Q+WMRe8E664uc+ugfEPfxcjB4eEgInE933GXYycHEIC
	OxglWl/7djFyAdmfGCWuP5/ADOF8Y5R4dreTEaQKpGHLus3sEIm9jBJX+k+xQ7Q/YZToWO4J
	MpVNQEvi9jFvkLCIwENGif63gSA2s4CGxJ+2i2wgtrBAkET7hIVgrSwCqhLfTu8Cs3kFbCV+
	HDvJDLFLXmL/wbPMEHFBiZMzn7BAzJGXaN46G+w4CYG37BLb726FanCROH31KguELSzx6vgW
	dghbSuLzu71sEA3NjBIL3xyH6p7AKPHl4202iCp7iebWZjaQD5gFNCXW79KH2MYn8e5rDysk
	uHglOtqEIKpVJOZ0nWODmf/xxmNWCNtD4tqdVlZImMRKtHR/Z5/AKDcLyQ+zkPwwC2HZAkbm
	VYxiqQXFuempxYYFJvBoTM7P3cQIToxaFjsY5779oHeIkYmD8RCjBAezkghv9ErfNCHelMTK
	qtSi/Pii0pzU4kOMpsBQncgsJZqcD0zNeSXxhiaWBiZmRiYWxpbGZkrivGeulKUKCaQnlqRm
	p6YWpBbB9DFxcEo1MCny/Tox4WOq61lmd/sPJ9I0lq5Mufl2ne0Mloa7Sg9Od/XNkuAozt3w
	MiEqPjDD6vOvW0vNr9/5wHt6T+XkH8uSWc2y5jG4n0iW/PClYs/9N/pTjvlGxH9aaqO6W5Hh
	7b2yZ2sWTXq4YHL0/j/LxK8e33BenCv4xqZ703c9vToj71bqHIcuu7STqq75XY9evLvaHukg
	Ezsn+sPnjZ7mW9ZLNhgFbVRtXq6iIrpqPlvCM42jLekLv9ycVWlcGvVPIN9n3sqLjQ6LNzwU
	MuHZGFob586y+i6zzTM9hua7XitZz+3vit4ekbnC7osha0J/jI3TmhObPIssPk148bT9/0ou
	68x5X1Zx3e+LjFdw/SCqxFKckWioxVxUnAgA5Xcm5xUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsWy7bCSnG72F/80gzPLRSwezNvGZvHy51U2
	i2kffjJbzDjVxmqxsZ/D4vKuOWwW3dd3sFksP/6PyWLqi+PsDpwel694e0ybdIrN4+PTWywe
	E/fUefRtWcXo8XmTnEf7gW6mAPYoLpuU1JzMstQifbsErozpD5YxF7wTrri5z66B8Q9/FyMn
	h4SAicSWdZvZuxi5OIQEdjNK7FrVyw6RkJLYvf88WxcjB5AtLHH4cDFIWEjgEaPEoVnWIGE2
	AS2J28e8QVpFBF4ySvy+t4gJpIZZQEPiT9tFNhBbWCBA4v3jRWA2i4CqxLfTu8DG8wrYSvw4
	dpIZYpW8xP6DZ5kh4oISJ2c+YYGYIy/RvHU28wRGvllIUrOQpBYwMq1ilEwtKM5Nzy02LDDM
	Sy3XK07MLS7NS9dLzs/dxAgOYS3NHYzbV33QO8TIxMF4iFGCg1lJhDd6pW+aEG9KYmVValF+
	fFFpTmrxIUZpDhYlcV7xF70pQgLpiSWp2ampBalFMFkmDk6pBqbYa6clajfIhqzxCrzEr6nU
	tIFjZZrg2ZnCXwJ/fRO5MX+pvng1d1fqw4XT5CMWbtrNfr5uQpWwJjPv25JlR2tfXDu/PHva
	CpbzbTee/b0h8V58X9y2HVaME+12iM1xfzr30RpJZSeRtAVPFj4u679z6MRnoWv5cV+/vzNW
	M0zxmXv0W4BC83vF5MJj4izXTHlD17FJ3glWfXA66s2feRoFSyat0WZfn9U2y/+qSKjs9j3/
	4ren2+r3+5otXzL/cJ6yUu52tvjwbRcEi46yHezw3fpgdvDruEVqBqz6+pu/XmNZOuFHUWdh
	9P7HnG/Onq4I7YxxSZ7ufH6x0fo/xzJ1mtZmtnasuzq15My0Be+FlViKMxINtZiLihMB94Vy
	GtACAAA=
X-CMS-MailID: 20240524015907epcas1p2598a2ba8a81529b6639cff007fe9106b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240524015907epcas1p2598a2ba8a81529b6639cff007fe9106b
References: <CGME20240524015907epcas1p2598a2ba8a81529b6639cff007fe9106b@epcas1p2.samsung.com>

An error unrelated to ufshcd_try_to_abort_task is being output and
can cause confusion. So, I modified it to output the result of abort
fail.
  * dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);

And for readability,I modified it to return immediately instead of 'goto'.

Fixes: f1304d442077 ("scsi: ufs: mcq: Added ufshcd_mcq_abort()")
Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>

---
v1->v2:
 - Change title and description
 - Change all 'goto out' statements into 'return FAILED'.
 - Add 'return SUCCESS' at the end.
   v1 : https://patchwork.kernel.org/project/linux-scsi/patch/20240523002257.1068373-1-cw9316.lee@samsung.com/
---
 drivers/ufs/core/ufs-mcq.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 005d63ab1f44..8944548c30fa 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -634,20 +634,20 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct ufs_hw_queue *hwq;
 	unsigned long flags;
-	int err = FAILED;
+	int err;
 
 	if (!ufshcd_cmd_inflight(lrbp->cmd)) {
 		dev_err(hba->dev,
 			"%s: skip abort. cmd at tag %d already completed.\n",
 			__func__, tag);
-		goto out;
+		return FAILED;
 	}
 
 	/* Skip task abort in case previous aborts failed and report failure */
 	if (lrbp->req_abort_skip) {
 		dev_err(hba->dev, "%s: skip abort. tag %d failed earlier\n",
 			__func__, tag);
-		goto out;
+		return FAILED;
 	}
 
 	hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
@@ -659,7 +659,7 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 		 */
 		dev_err(hba->dev, "%s: cmd found in sq. hwq=%d, tag=%d\n",
 			__func__, hwq->id, tag);
-		goto out;
+		return FAILED;
 	}
 
 	/*
@@ -667,18 +667,17 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	 * in the completion queue either. Query the device to see if
 	 * the command is being processed in the device.
 	 */
-	if (ufshcd_try_to_abort_task(hba, tag)) {
+	err = ufshcd_try_to_abort_task(hba, tag);
+	if (err) {
 		dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
 		lrbp->req_abort_skip = true;
-		goto out;
+		return FAILED;
 	}
 
-	err = SUCCESS;
 	spin_lock_irqsave(&hwq->cq_lock, flags);
 	if (ufshcd_cmd_inflight(lrbp->cmd))
 		ufshcd_release_scsi_cmd(hba, lrbp);
 	spin_unlock_irqrestore(&hwq->cq_lock, flags);
 
-out:
-	return err;
+	return SUCCESS;
 }
-- 
2.34.1

