Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076921F9406
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2024 07:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728546155; cv=none; b=oo80fnL2CkHITS5AwGYbbqWKRKslCDnU63jdwAjiRfKc+JBAl0/Lfef8qXaDfcmimSU4Bt2V4N5zU/1vrRhMld+AexB3GVR3D1xejHejiG8ojTdysNlrmoYzEcpv5Fvf+kj8BIfwdCg7w7Az2j6FNwmx7g4sEfw/ucUYRVdeGEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728546155; c=relaxed/simple;
	bh=WTtjtG47vymHfMOTZHiAGXAiV8ozOqMHl1YVg0JFja8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=pUPDES0TWgSa+q8L1Y8kHBHXI0Motz/648Z2yAm6HqCpxMlPecOb1J14S/Z/IilHqlYti+0VYMFnVfhEbrR/1Ui5TNwdNEYSa3v59c17u+j0DqcCQ1SzW13aeLDXwCkZW91BBKI9CzGozQqa7k5Y7CmXJH3cLCL+/SWPX8+IDUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BUzUcLh7; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BUzUcLh7"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241010074230epoutp04b72a257fca0dc4da78bf9a70de5cc843~9B5Druq3y2066120661epoutp04N
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2024 07:42:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241010074230epoutp04b72a257fca0dc4da78bf9a70de5cc843~9B5Druq3y2066120661epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728546151;
	bh=RUnIJ9K+YQ0p0ZcKfT070l16YRpaY6+jaXV37dAh/TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUzUcLh7X15eaLtUc1OnMGqtyZn1J1uvmZUCZr8Q3CXsJy3ihXhW4an8Yu1BhpYyt
	 PjGG2e8UoboAdOC2+E19jd0k1/m45iBMQU4Rhdtn37MHBFun5bOpjIi3S+nwd1sFQB
	 55kvsC0i/JtsiDK1ERueMXXTsCXZ7T1cXdLHuX00=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20241010074230epcas2p2fb966134b612c96d455b45a68a9bc639~9B5DUnjhC2794227942epcas2p2Y;
	Thu, 10 Oct 2024 07:42:30 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.68]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XPMD55Nn6z4x9Py; Thu, 10 Oct
	2024 07:42:29 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	D3.33.09776.56587076; Thu, 10 Oct 2024 16:42:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20241010074229epcas2p31ecc33731a96be7958cdd93908a1ce86~9B5CEiaNl3202132021epcas2p39;
	Thu, 10 Oct 2024 07:42:29 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241010074229epsmtrp1f6956eac7e1c699b95675d828e9a8a49~9B5CDek_80182601826epsmtrp1X;
	Thu, 10 Oct 2024 07:42:29 +0000 (GMT)
X-AuditID: b6c32a47-d53fa70000002630-e2-6707856566ef
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	44.55.08227.56587076; Thu, 10 Oct 2024 16:42:29 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [10.229.95.126]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241010074228epsmtip2c8730b7f4dd4d673d12d86dc231b3010~9B5B0Hrfi1861218612epsmtip2m;
	Thu, 10 Oct 2024 07:42:28 +0000 (GMT)
From: SEO HOYOUNG <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, sh425.lee@samsung.com,
	quic_nguyenb@quicinc.com, cpgs@samsung.com, h10.kim@samsung.com,
	grant.jung@samsung.com, junwoo80.lee@samsung.com, wkon.kim@samsung.com
Cc: SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [PATCH v3 1/2] scsi: ufs: core: check asymmetric connected lanes
Date: Thu, 10 Oct 2024 16:52:28 +0900
Message-Id: <e82b4b65b5f6501a687c624dd06e5c362e160f32.1728544727.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1728544727.git.hy50.seo@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUwbZRzOe3dcD0zJrdvklYytnErGkkLLaHkh4Ja44G3TCDo3BRN2oWch
	lLbpFUQXtW7jYxuhI0M+CuwDBQPMEZBChY3QTmFjZhFwbvIxZ4ZozZiwKQgTsOU63X/P7/k9
	v9+T5/2gcNl1MpTKNlh4s4HTM2QQ0XU5UqPgCyU6ZemVCHTndBeJPIs3SOT6+RiBKmcXceRx
	R6Kl5TYJWh4fDkCtn94hUMOtLgz1LB/BkOPWVwT6sfMbAo321JHoxE0niT4fXMHQJ78NSlDj
	ygyBvhyZJ3bK2NHv97InG/oBu9BWQrJzv4wRbPnFD9myzhbAPuzYzBb3n8BSqLScxCye0/Jm
	OW/INGqzDbokZu/rGS9mqDVKlUIVj+IYuYHL5ZOYXS+nKJKz9d4kjDyf0+d5qRROEJjoFxLN
	xjwLL88yCpYkhjdp9aY4U5TA5Qp5Bl2UgbckqJTKGLVXeDAnq6XOhZkWJQWr1qkAK3CSx0Eg
	BelYONTXA46DIEpGOwF0z5VgYvEAwIrWL0ixmAewZs6OPx4pnZ/xNy4BOOSwEmLxN4CltjrM
	pyLprfD8gHtt1wa6HocNZ24DXwOnI+DDySbCh9fTu2HPPx0BPkzQz8NLYwtrw1I6DbrbKwnR
	bgtssD5a4wNpBOdmVwNEzTp4tWaKEHdugUcctbjPDNJXKHi3qc0fbxcsnJ70L1oPfx/slIg4
	FHpsRV5MebEA7ecOibNW7wnU2v2a7dA+XQx8GpyOhG090aL8Wfj1mN82GJZcXvarpdDa/si/
	UQpLimQizcBv68f9NISuWr1Is/BGvwOcBOH2J7LYn8hi/9/2LMBbwNO8ScjV8UKMaft/F5xp
	zO0Aaw9720tOUD0zG+UGGAXcAFI4s0GqOBegk0m13Hvv82ZjhjlPzwtuoPaedDkeujHT6P0Z
	BkuGKjZeGavRqOJi1Mo4JkR6u7BeK6N1nIXP4XkTb348h1GBoVZMT1bY2ner3wibY8C+A1HT
	vVV/NB8+Gr6j2ab0RNsu3MefeuWmLvX8c4FysAcq/zwkmbjuKv+1zmZZqWpkKzwTzIQxsO/U
	6tZjxfM7ZUkFybMYlTzkWvKcjuw+eMGccP+zM66RjMnqLk+36oPhzR0/1I7wTftD3rRfzS9p
	tYxFvDvuXHo7cX8ZVzSWe804qQrX6N8KQevUwSwN4hd2gHbdT2qD/Z2qj8uvaUZXs5vvxlzM
	N4elK3qnhinq3tn56f705MpnUuX3qoMOD6yQZZqNzHeV+5b/2rRn5gBZY0wdDx5daXy1IGFT
	4/SDdEVao+Ijx+zAam/YUYcu5LXugT6OIYQsTrUNNwvcv96wSDhhBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXje1lT3dYPURLosH87axWbz8eZXN
	4uDDThaLaR9+Mlu8PKRp8evvenaLv7cvslqsXvyAxWLRjW1MFrv+NjNZbL2xk8Xi5pajLBaX
	d81hs+i+voPNYvnxf0wWU18cZ7dY+u8ti8XmS99YHIQ8Ll/x9piw6ACjx/f1HWweH5/eYvGY
	uKfOo2/LKkaPz5vkPNoPdDMFcERx2aSk5mSWpRbp2yVwZayac5Cp4Cd7xf+GJ6wNjDvYuhg5
	OSQETCR6vr0Fsrk4hAR2M0q8aXrPApGQkPi/uIkJwhaWuN9yhBXEFhL4xijR8T4QxGYT0JBY
	c+wQE0iziMBmZon/m/rAipgF1CQ+310GNkhYwFNi159NYHEWAVWJvbe+gw3lFYiSOLRxGtQy
	eYlFDb/B4pwCFhIfP/yHWmYucezAb2aIekGJkzOfsEDMl5do3jqbeQKjwCwkqVlIUgsYmVYx
	SqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgRHl5bWDsY9qz7oHWJk4mA8xCjBwawkwqu7
	kDVdiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+3170pQgLpiSWp2ampBalFMFkmDk6pBqbYN+9N
	mblNTj5dOGkl576/pw/6PpF6o/Tl3q0PoanNRTwJl7Zuaw25X+fgd6rupY1umLwgz+KNcw9f
	r0l+/MAoNnq7UUf1i6tyrLeWtX7appkSfEyw65fXQ/0PuTqW/PO4JnkG7SwsvPpFe/4sv5dr
	joW9+McY2SxV9l7Fb7qf7b9HOxuO9C3L5Or6uJKt2GH5zYXizpsmvF756UfbdcdpF7+4bzGJ
	CtjNxnRt7dVzq6OSbujYz+5qm5Oyw8WzT/PK7yUzrdfMbynbzHnv2iIzfeslcxK5nAV//jRe
	fZWz7HDyrVs997e2nviWsS1ngvyq5uO26yU0exr6xaoijCxFjk17JDy9YfIGQyarnoZgJZbi
	jERDLeai4kQAVDbNax0DAAA=
X-CMS-MailID: 20241010074229epcas2p31ecc33731a96be7958cdd93908a1ce86
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241010074229epcas2p31ecc33731a96be7958cdd93908a1ce86
References: <cover.1728544727.git.hy50.seo@samsung.com>
	<CGME20241010074229epcas2p31ecc33731a96be7958cdd93908a1ce86@epcas2p3.samsung.com>

Performance problems may occur if there is a problem with the
asymmetric connected lane such as h/w failure.
Currently, only check connected lane for rx/tx is checked if it is not 0.
But it should also be checked if it is asymmetrically connected.

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 24a32e2fd75e..387eec6f19ef 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4540,6 +4540,14 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 		return -EINVAL;
 	}
 
+	if (pwr_info->lane_rx != pwr_info->lane_tx) {
+		dev_err(hba->dev, "%s: asymmetric connected lanes. rx=%d, tx=%d\n",
+			__func__,
+				pwr_info->lane_rx,
+				pwr_info->lane_tx);
+		return -EINVAL;
+	}
+
 	/*
 	 * First, get the maximum gears of HS speed.
 	 * If a zero value, it means there is no HSGEAR capability.
-- 
2.26.0

