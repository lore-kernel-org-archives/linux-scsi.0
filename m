Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1D8331A5C
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 10:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770806586; cv=none; b=QojhjGoJSHGBfjKHfWsvl240vpAUFnkWIJVAbUj3xXGsGEu0ioyt6p45NaS7D3ExK+Y2FD3oFCSbTflHYwv2sCMWP04KlJTkhvodvB/zTEcS2Lfjxv2w1jt1Es0k8nwr2yU7pRffmNPqVgX88qYckuVsiLu7KsGmvOvuK1jPbjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770806586; c=relaxed/simple;
	bh=oiXlhEhSc3ODva3u3zw7qVJD6DIHZKiA1TeIN5Pbl3g=;
	h=Mime-Version:Subject:From:To:Message-ID:Date:Content-Type:
	 References; b=hsMlh9oG5MLcCTZwfL4HucZGr6D8Rcn+M2ML7tJak+zTmIJEKdHB1zQILa5ENrecTqkXFjCHhnkY+7TFjrCr8lOjIxmaoBECpB95EjmdcwK3I7on8p0SEGH9WyQBVJ30fqC0ES+sIpkaXsyNHeVzugeCiQ/8t5CKDOTMunXLGUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EeF4nGas; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EeF4nGas"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260211104302epoutp040436297673fb45cb5d1a67e3c30b36fd~TKzRoV7LE3010530105epoutp04V
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 10:43:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260211104302epoutp040436297673fb45cb5d1a67e3c30b36fd~TKzRoV7LE3010530105epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770806582;
	bh=P+9bSnNZidIRKl52K0MBBcXgyVJ+kSFTX+XtpHnd3Yg=;
	h=Subject:Reply-To:From:To:Date:References:From;
	b=EeF4nGasbJeruH95F1ZNbXzmz4Lz3e0c0aFLq/Lg3hJbLM6UF2gUvOOvjxnUr98oy
	 247qeqUD74V8BbLij2UWpiMFfrxrpOb1ilMHPSPHvGvkIJjiXOOTPuot58I6AcZVAt
	 7lG4yiScAsatilYMnXacgxV9wy/F7F3CoP1BB7cM=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260211104302epcas2p3a848ce2458cf0c333708e558c74b3147~TKzRH2tmS3086330863epcas2p3i;
	Wed, 11 Feb 2026 10:43:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4f9w4j72zCz2SSKb; Wed, 11 Feb
	2026 10:43:01 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: core: Reset urgent_bkops_lvl to allow runtime PM
 power mode
Reply-To: wone.jung@samsung.com
Sender: Won Jung <wone.jung@samsung.com>
From: Won Jung <wone.jung@samsung.com>
To: ALIM AKHTAR <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jinyoung Choi
	<j-young.choi@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01770806581968.JavaMail.epsvc@epcpadp2new>
Date: Wed, 11 Feb 2026 15:01:05 +0900
X-CMS-MailID: 20260211060105epcms2p6631646c964afae761c5d8b93db5a476d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260211060105epcms2p6631646c964afae761c5d8b93db5a476d
References: <CGME20260211060105epcms2p6631646c964afae761c5d8b93db5a476d@epcms2p6>

This patch ensures that UFS Runtime PM can achieve power saving
after System PM suspend by resetting hba->urgent_bkops_lvl.
It also modifies ufshcd_bkops_exception_event_handler to avoid
setting urgent_bkops_lvl when status is 0, which helps maintain
optimal power management.

On UFS devices supporting UFSHCD_CAP_AUTO_BKOPS_SUSPEND,
a BKOPS exception event can lead to a situation
where UFS Runtime PM can't enter low-power mode states even
after the BKOPS exception has been resolved.

BKOPS exception with bkops status 0 occurs, the driver logs:
"ufshcd_bkops_exception_event_handler:
device raised urgent BKOPS exception for bkops status 0"

When a BKOPS exception occurs, `ufshcd_bkops_exception_event_handler()`
reads the BKOPS status and sets `hba->urgent_bkops_lvl` to
BKOPS_STATUS_NO_OP(0). This allows the device to perform Runtime PM
without changing the UFS power mode.
(`__ufshcd_wl_suspend(hba, UFS_RUNTIME_PM)`)

During system PM suspend, `ufshcd_disable_auto_bkops()` is called,
disabling auto bkops. After UFS System PM Resume,
when runtime PM attempts to suspend again,
`ufshcd_urgent_bkops()` is invoked. Since `hba->urgent_bkops_lvl`
remains at BKOPS_STATUS_NO_OP(0), `ufshcd_enable_auto_bkops()`
is triggered.

However, in `ufshcd_bkops_ctrl()`,
the driver compares the current BKOPS status with
`hba->urgent_bkops_lvl`, and only enables auto bkops
if `curr_status >= hba->urgent_bkops_lvl`.
Since both values are 0, the condition is met

As a result, `__ufshcd_wl_suspend(hba, UFS_RUNTIME_PM)` skips power mode
transitions and remains in an active state, preventing power saving even
though no urgent BKOPS condition exists.

Signed-off-by: wone.jung <wone.jung@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 604043a7533d..e2d3e834ccba 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5959,6 +5959,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 
 	hba->auto_bkops_enabled = false;
 	trace_ufshcd_auto_bkops_state(hba, "Disabled");
+	hba->urgent_bkops_lvl = BKOPS_STATUS_PERF_IMPACT;
 	hba->is_urgent_bkops_lvl_checked = false;
 out:
 	return err;
@@ -6062,7 +6063,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 	 * impacted or critical. Handle these device by determining their urgent
 	 * bkops status at runtime.
 	 */
-	if (curr_status < BKOPS_STATUS_PERF_IMPACT) {
+	if ((curr_status > BKOPS_STATUS_NO_OP) && (curr_status < BKOPS_STATUS_PERF_IMPACT)) {
 		dev_err(hba->dev, "%s: device raised urgent BKOPS exception for bkops status %d\n",
 				__func__, curr_status);
 		/* update the current status as the urgent bkops level */
-- 
2.17.1
