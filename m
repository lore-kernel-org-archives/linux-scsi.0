Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B26B156C7A
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 10:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717152594; cv=none; b=jS7fVx3/O+Iw6goEx1Qi3KIfkr1pOmYiIfovc/V+CVhFfycyCoZzQhcwAHLIbcq8WcgmyGW4P+dOFOGtlDDQq+oVrt37zN1I4M3jwmQkUHtf4GkCIQD3PEkJx7lzNpvCNPn2Utg+D0S+OqzA5B/f+Q5iYIQWSjDwrHjfeNIcIn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717152594; c=relaxed/simple;
	bh=AFfAKnNNAElMu/x0QLDxcvTX9NDDzFCEKVCESmX8MV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rNubvyMbrN0l9sNqGZR0ljoFMT3hd2GI6hzn6l9DDovIZkdUTN8TOFFQKh0Y2Wqhu1zkIQh7doGB49MeTvBXfG+lGpW9hTWuD7ojhqzun3b5zpLTd09hUvSGGlhIlKCHOhj/FXRyiqKLnerkZIMc9YMgrquuKdg6ZIcp+MnU3Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XBfEqcw9; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XBfEqcw9"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240531104949epoutp02bdae1360ed010acf0699eb79de8559a5~UjS6m-yH92291222912epoutp02g
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 10:49:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240531104949epoutp02bdae1360ed010acf0699eb79de8559a5~UjS6m-yH92291222912epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717152589;
	bh=BGq1tc1rCx1x4oD1ebKrvH6uQdBdZBm2UNu+DAj5ACw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBfEqcw9fElHblHEk5B/tnF+GyS6jzH0PrK4stQOv4oAUYs4W1o2XwpPWRFcyGFqf
	 vpzOPQsDXh7pAmsa7eHhPhM1Ox9xqg5VVbhhwqAJNaWJ4w8FZiT12nKlxnP+bf1HfH
	 ivjIfswcOIJYJMu89CDa3FoXXk8WDlYXLbi6LybU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240531104949epcas2p2e10debed7765c7eb03c80682b2efdd59~UjS6TCWri0395903959epcas2p2x;
	Fri, 31 May 2024 10:49:49 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.70]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VrKd82PrWz4x9Py; Fri, 31 May
	2024 10:49:48 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	8F.A3.09479.C4BA9566; Fri, 31 May 2024 19:49:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20240531104947epcas2p1cd477921c1cd307d84f9ffc25b2c08a8~UjS5Ppb1x1681016810epcas2p13;
	Fri, 31 May 2024 10:49:47 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240531104947epsmtrp1a4cee3fbfef7de34ed8140bdbface15a~UjS5OtW2k2848028480epsmtrp11;
	Fri, 31 May 2024 10:49:47 +0000 (GMT)
X-AuditID: b6c32a48-105fa70000002507-42-6659ab4c65c0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	32.A0.07412.B4BA9566; Fri, 31 May 2024 19:49:47 +0900 (KST)
Received: from localhost.dsn.sec.samsung.com (unknown [10.229.54.230]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240531104947epsmtip1f0cac1e4fc578a96a482b59a3224bbe6~UjS5DSwHj0934709347epsmtip1K;
	Fri, 31 May 2024 10:49:47 +0000 (GMT)
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Minwoo Im
	<minwoo.im@samsung.com>, gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>
Subject: [PATCH 1/3] ufs: mcq: Add ufshcd_mcq_queue_cfg_addr helper
Date: Fri, 31 May 2024 19:38:19 +0900
Message-Id: <20240531103821.1583934-2-minwoo.im@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531103821.1583934-1-minwoo.im@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmma7P6sg0g3cz+CwezNvGZvHy51U2
	i2kffjJb3Dywk8liYz+Hxf2t1xgtLu+aw2bRfX0Hm8Xy4/+YLJ6dPsDswOVx+Yq3x7RJp9g8
	Pj69xeLRt2UVo8fnTXIe7Qe6mQLYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBfo
	FSfmFpfmpevlpZZYGRoYGJkCFSZkZ0z8PYu14Ax/Rdes1YwNjDN4uxg5OSQETCSmfbnG2MXI
	xSEksINRonnDZSjnE6PEoq//mUCqhAS+MUr8/B4J07F2x3IWiKK9jBK/bu9hhnB+M0p09K5m
	BqliE1CXaJj6igXEFhGoltjc/pcNpIhZoI9Jon32fFaQhLCAs8Slm08ZQWwWAVWJ/nUfwJp5
	BWwk2h69ZYNYJy+x/+BZsDingK1Ey/+TbBA1ghInZz4BW8AMVNO8dTbYFRICjRwSlz7cgGp2
	kTj4cSozhC0s8er4FnYIW0riZX8blF0u8fPNJEYIu0Li4KzbQL0cQLa9xLXnKSAms4CmxPpd
	+hBRZYkjt6C28kl0HP7LDhHmlehoE4KYoSzx8dAhqJ2SEssvvYa6xUPi4Zsv0HCbwChx/NpJ
	pgmMCrOQPDMLyTOzEBYvYGRexSiWWlCcm55abFRgAo/g5PzcTYzgdKrlsYNx9tsPeocYmTgY
	DzFKcDArifD+So9IE+JNSaysSi3Kjy8qzUktPsRoCgzqicxSosn5wISeVxJvaGJpYGJmZmhu
	ZGpgriTOe691boqQQHpiSWp2ampBahFMHxMHp1QDU/eRKa2H2tQDBD82sW/XENjTbv+G48nZ
	6qiykl9NzDZsq3/5vXNgTNiqYCvsPH92qvuE6BOsF0TPe21Lemr59vGH8sYlzIUbfKR3B0jw
	HA9IWs244+RZplxNWzY+lxP81rI8G2uT3vjMnBLydNm1e7FM0Zy95ab/cl9v37jbe+bxT/vD
	3Y9J7Qr5OIVxxq4vrK4HjATZP3q0Oekqbv81c9Uz68aDRy1b/3K9TKiSvu042eNuxvK4rtT5
	qTelHr7f/eHfFJeqLd+t/l2Y8el+5nLTt+v3ZZ6ztH5SKB21yL04dsHC0z9W/p4795ZCwJ1A
	p94HPrGCuy5yLwif2PRb0HZPcdKJsDTesuqbcQGa1kosxRmJhlrMRcWJAFmCxtcwBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWy7bCSnK736sg0g6ULzCwezNvGZvHy51U2
	i2kffjJb3Dywk8liYz+Hxf2t1xgtLu+aw2bRfX0Hm8Xy4/+YLJ6dPsDswOVx+Yq3x7RJp9g8
	Pj69xeLRt2UVo8fnTXIe7Qe6mQLYorhsUlJzMstSi/TtErgyJv6exVpwhr+ia9ZqxgbGGbxd
	jJwcEgImEmt3LGfpYuTiEBLYzSjxfcY0doiEpMS+0zdZIWxhifstR1ghin4ySrz/foMRJMEm
	oC7RMPUVC4gtIlAtsbn9LxtIEbPANCaJRbMguoUFnCUu3XwK1sAioCrRv+4DM4jNK2Aj0fbo
	LRvEBnmJ/QfPgsU5BWwlWv6fBIsLAdWsvvySBaJeUOLkzCdgNjNQffPW2cwTGAVmIUnNQpJa
	wMi0ilEytaA4Nz032bDAMC+1XK84Mbe4NC9dLzk/dxMjOPi1NHYw3pv/T+8QIxMH4yFGCQ5m
	JRHeX+kRaUK8KYmVValF+fFFpTmpxYcYpTlYlMR5DWfMThESSE8sSc1OTS1ILYLJMnFwSjUw
	Naee/SF9/eeu2wI2d7/sOaGz6o78XIFVMotudBt5fY4xP7zmf3JbxLaHa5j8NYzq58/a0erT
	cnBnhFHIA2srpR+3k2JenZE75Ncqkbtjp3Lwh12r+h9tPDGnV2CzwpS6Fp77Sg4VURPvrg5T
	e/VsTTIH+5/00iT3Gb/sWjcL3t5/Qd31UquvZX31mdKosO/LZ29JFbnAz2B67uGcCcXrTKcs
	SzlfOkve+H+upPn7EpY6je0/7ZVunJBO/jPxxhGnAy80VU/O0kvQbflar8SS17ygWGp+Wcul
	u3p3Ne4/i3Y/9qB/neU+vQdhMkd83fJcV+m+01b+smma1PWL1suNZW5qRYQvmMwxbW5w6/Z+
	BSWW4oxEQy3mouJEAIu0SmjtAgAA
X-CMS-MailID: 20240531104947epcas2p1cd477921c1cd307d84f9ffc25b2c08a8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531104947epcas2p1cd477921c1cd307d84f9ffc25b2c08a8
References: <20240531103821.1583934-1-minwoo.im@samsung.com>
	<CGME20240531104947epcas2p1cd477921c1cd307d84f9ffc25b2c08a8@epcas2p1.samsung.com>

This helper returns an offset address of MCQ queue configuration
registers.  This is a prep patch for the following patch.

Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 14 ++++++++++++++
 include/ufs/ufshcd.h       |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 52210c4c20dc..46faa54aea94 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -18,6 +18,7 @@
 #include <linux/iopoll.h>
 
 #define MAX_QUEUE_SUP GENMASK(7, 0)
+#define QCFGPTR GENMASK(23, 16)
 #define UFS_MCQ_MIN_RW_QUEUES 2
 #define UFS_MCQ_MIN_READ_QUEUES 0
 #define UFS_MCQ_MIN_POLL_QUEUES 0
@@ -116,6 +117,19 @@ struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 	return &hba->uhq[hwq];
 }
 
+/**
+ * ufshcd_mcq_queue_cfg_addr - get an start address of the MCQ Queue Config
+ * Registers.
+ * @hba: per adapter instance
+ *
+ * Return: Start address of MCQ Queue Config Registers in HCI
+ */
+unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_hba *hba)
+{
+	return FIELD_GET(QCFGPTR, hba->mcq_capabilities) * 0x200;
+}
+EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
+
 /**
  * ufshcd_mcq_decide_queue_depth - decide the queue depth
  * @hba: per adapter instance
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index df68fb1d4f3f..9e0581115b34 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1278,6 +1278,7 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val);
 void ufshcd_hba_stop(struct ufs_hba *hba);
 void ufshcd_schedule_eh_work(struct ufs_hba *hba);
 void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds);
+unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_hba *hba);
 u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
 void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
 unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
-- 
2.34.1

