Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7E71F940D
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2024 07:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728546157; cv=none; b=SYCr/Zb9xQpa+tosePBUZiTDuGUUMDWxr6lUwzkN55h1514fFtHUjJE15C6vZ0FxYq+tufXBw57cbCb4vwoqyA2uczV0akjrx0MkvebNS+92OEDv1kd6dpK5/2NIJMUVufjb29cxKywHPn150eLwDHgYB+hxhR2UZqaG/U7igZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728546157; c=relaxed/simple;
	bh=eN7X38t2A1GojgdAPRHihJ4Ptnr5GRtZho/F6GVYf/A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Mqz+wGuVFIX5khWLYabU53WzBYYsIz/CRonIngGwmFJqzY3eea+z66BOQvwJ7xuwgeeOvoabeK3ApER+vxil/v/7pxhEJd3YcY+y+TUmkoheQ+WIgklpaNXLSw/HrHzs3J+no6MYhsv3B7Heb8/R2EiqvF95AQyjOeq1R4M8ivU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=aknj+M7/; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aknj+M7/"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241010074233epoutp02988fe649808126d0cc241f997f40d0d4~9B5GeKXH30661706617epoutp02C
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2024 07:42:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241010074233epoutp02988fe649808126d0cc241f997f40d0d4~9B5GeKXH30661706617epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728546154;
	bh=MzEcKQEMsBaalWP6NqvxH0uESA4d9gCI95r0v9wBPL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aknj+M7/vH0uSksbrpD++qjxTBXo6n6OkvTTgrm/EEXLNpIkNyfgEAB+3ILat8kEc
	 iLE64J1lXAwSBosUe0mcyzjyGGih5uZJHMO92LiA4ZjJwTmNoT6QQsFx4llOgnq1Cz
	 sShbZQWeiAQ69svjk8o+mL6V/VMlIgqi/AEJ/+t0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20241010074233epcas2p3acb07484c15b6e0c38e1dde3118a2d01~9B5F2pXhn1443414434epcas2p3I;
	Thu, 10 Oct 2024 07:42:33 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.101]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XPMD82cpSz4x9Pw; Thu, 10 Oct
	2024 07:42:32 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	B7.08.09396.86587076; Thu, 10 Oct 2024 16:42:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20241010074231epcas2p2d15a81d68b68d757039a56e8dd9cca3c~9B5Ea7cLF2794227942epcas2p2c;
	Thu, 10 Oct 2024 07:42:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241010074231epsmtrp1b66a5fe9757a26bc2cb4fc589383614c~9B5EaFOSz0182601826epsmtrp1b;
	Thu, 10 Oct 2024 07:42:31 +0000 (GMT)
X-AuditID: b6c32a45-671ff700000024b4-5d-670785688f42
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	03.76.08229.76587076; Thu, 10 Oct 2024 16:42:31 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [10.229.95.126]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241010074231epsmtip2f358f63f1a26e3804918b72c715ba9b0~9B5EJhQEq1882818828epsmtip2e;
	Thu, 10 Oct 2024 07:42:31 +0000 (GMT)
From: SEO HOYOUNG <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, sh425.lee@samsung.com,
	quic_nguyenb@quicinc.com, cpgs@samsung.com, h10.kim@samsung.com,
	grant.jung@samsung.com, junwoo80.lee@samsung.com, wkon.kim@samsung.com
Cc: SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [PATCH v3 2/2] scsi: ufs: core: reflect function execution result
 in return
Date: Thu, 10 Oct 2024 16:52:29 +0900
Message-Id: <300052382d9d03bf087d71201bd159805b8fd041.1728544727.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1728544727.git.hy50.seo@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmqW5GK3u6Qcd0fosH87axWbz8eZXN
	4uDDThaLaR9+Mlu8PKRp8evvenaLv7cvslqsXvyAxWLRjW1MFrv+NjNZbL2xk8Xi5pajLBaX
	d81hs+i+voPNYvnxf0wWU18cZ7dY+u8ti8XmS99YHIQ8Ll/x9piw6ACjx/f1HWweH5/eYvGY
	uKfOo2/LKkaPz5vkPNoPdDMFcERl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgr
	KeQl5qbaKrn4BOi6ZeYAfaKkUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAv0CtO
	zC0uzUvXy0stsTI0MDAyBSpMyM649dK6YAV7xe2WxAbGFrYuRk4OCQETiS2vDzJ1MXJxCAns
	YJQ4cvUgK4TziVHi95ErjBDON0aJ7hXXmGFaXm84DZXYC5Q4vx2q5QejxILlDxlBqtgENCTW
	HDsENlhEYC6zxKL598ASzAJqEp/vLmMBsYUFwiSW370CZrMIqEocntDJCmLzCkRJ/LmzhR1i
	nbzEoobfTCA2p4CFxMcP/6FqBCVOznzCAjFTXqJ562xmkGUSAic4JA6uboNqdpE49u841N3C
	Eq+OwwyVknjZD1LDAWQXS8xaWA3R28AocWj2LKgaY4lZz9oZQWqYBTQl1u/ShyhXljhyC2ot
	n0TH4b9Q1bwSDRt/Q03klehoE4IIK0mcmXsbKiwhcXB2DoTpIbF8g+oERsVZSF6ZheSVWQhb
	FzAyr2IUSy0ozk1PLTYqMITHbnJ+7iZGcKrWct3BOPntB71DjEwcjIcYJTiYlUR4dReypgvx
	piRWVqUW5ccXleakFh9iNAUG9ERmKdHkfGC2yCuJNzSxNDAxMzM0NzI1MFcS573XOjdFSCA9
	sSQ1OzW1ILUIpo+Jg1OqgUm3zee2+u1WS/WXR1WOzWiMW8m9Qkt5QivTvRnTHd8KCmxqYpUU
	dmae8z/sSkDPygNi0bOVlNftWz1VdmtxVdHBi+6LzBSs4x2my2gVsyfcmHS5/+EM6w8JQq23
	XT1U+ZN2KxT5t+pEXXqk573QPl20kmfLjdaNqZ6fzgta3++ctjNWc/7bzT3PreZqh3yKMVD8
	EfM/df579hLLBaUfJUuee1h3SV9Sv8UhtOul2hx9tT1crat3JEsFVQldfbq2IOsUw3fvGete
	lMY4zVo2KTLH2vf/io3HZKxqPW1sAz+YzuI/9GBe7gGFPNPmuvuP/OZf1bkk6j/f09O333Q7
	U13DsdQZzBU7TuUVCJ8JUWIpzkg01GIuKk4EANKds11eBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42LZdlhJXje9lT3dYOkNTYsH87axWbz8eZXN
	4uDDThaLaR9+Mlu8PKRp8evvenaLv7cvslqsXvyAxWLRjW1MFrv+NjNZbL2xk8Xi5pajLBaX
	d81hs+i+voPNYvnxf0wWU18cZ7dY+u8ti8XmS99YHIQ8Ll/x9piw6ACjx/f1HWweH5/eYvGY
	uKfOo2/LKkaPz5vkPNoPdDMFcERx2aSk5mSWpRbp2yVwZdx6aV2wgr3idktiA2MLWxcjJ4eE
	gInE6w2nGbsYuTiEBHYzSny6/JcFIiEh8X9xExOELSxxv+UIK0TRN0aJO1sOMIMk2AQ0JNYc
	O8QEkhAR2Mws8X9THytIgllATeLz3WVgk4QFQiSWT1oPNolFQFXi8IROsBpegSiJP3e2sENs
	kJdY1PAbrIZTwELi44f/YDVCAuYSxw78ZoaoF5Q4OfMJC8R8eYnmrbOZJzAKzEKSmoUktYCR
	aRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnBsaWnuYNy+6oPeIUYmDsZDjBIczEoi
	vLoLWdOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ84q/6E0REkhPLEnNTk0tSC2CyTJxcEo1MO3y
	82jpe3yaxaTSObrNKCDM3/ar0LXp8ScT/r/Plas7qyNY3Rq3SWqBVVfLkeqTp5dPW7Xpd9cy
	B4ldH1n+VFUv7j/LmSnAsnvxNc/CKfU3etNaDuRJXXVMPJyducLfZpqzF6uTlQ5H8iIlHyap
	nqupHxQ3pIl83MPFfvyAcFhA8aRd3CnK37tWnk583fXKvNLpou7eB3PY7eyD/tpff2pzzOnB
	x+uGW/bvNLVWlBOetKJgahfH04afJ0JzX703F5wqp7Sp8ukVzcuHGqd/ez2bQfmftYqP5PPu
	tT8e3OF6ZZXCm+Ds94s7xkrj8jRt8cjewBU/lIrCvNcl/WVpyduVq2Ea2zKhatvtCVGTlViK
	MxINtZiLihMBvDFz5xwDAAA=
X-CMS-MailID: 20241010074231epcas2p2d15a81d68b68d757039a56e8dd9cca3c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241010074231epcas2p2d15a81d68b68d757039a56e8dd9cca3c
References: <cover.1728544727.git.hy50.seo@samsung.com>
	<CGME20241010074231epcas2p2d15a81d68b68d757039a56e8dd9cca3c@epcas2p2.samsung.com>

If an error is returned in the power mode function, it is returned and
modified to cause failure in the UFS linkup.
If it is an asymmetric connected lane, the UFS init can fail because it is
an incorrect situation.

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 387eec6f19ef..1381eb7d506a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8587,7 +8587,8 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 		hba->dev_info.f_power_on_wp_en = flag;
 
 	/* Probe maximum power mode co-supported by both UFS host and device */
-	if (ufshcd_get_max_pwr_mode(hba))
+	ret = ufshcd_get_max_pwr_mode(hba);
+	if (ret)
 		dev_err(hba->dev,
 			"%s: Failed getting max supported power mode\n",
 			__func__);
-- 
2.26.0

