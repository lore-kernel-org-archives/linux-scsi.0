Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D582749C1;
	Mon,  3 Aug 2026 02:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785722743; cv=none; b=d8gPU53kBXexrmgTzitX9TUBo9FPlJX22MvWSPiHl4kU0DFceX2s3rOdzyRxjhkDJ+MdpBgxoZZafP1sTq2uSMVMGVPNPXvrWwK6BEo4NRZ/OzjQ3qZ2qjvLg2/5kxm160Afm2qKSShtQ9d73Ef38CACO2A0I0pC3AoXv28vFyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785722743; c=relaxed/simple;
	bh=LHB2oPVix5ronZO0vIoBsoLzLG2dtl87+jj2GayAMd8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ElKs62LUSBp2ko3pAQgb7G1THaiFi8e7S6Jl2PrkWnEsBtk8zZcGAH9NhatrZrQaQEOW/mEzgP6kdpepKmn9tRnan93ANYZmt/APt9yikTqtErPlKWna8hbD1EW2DXbW9FlQ3NyeZ6lbs+O0EPIAqQpIoQaCqCY4qvoNIMzMUUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=TiFswjWI; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="TiFswjWI"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=POKnxoFlhoS5O9g3sUBog497LPRKeDDA8EXtBtgA1iI=;
	b=TiFswjWIzOgZaO3EMHuIBjqhibMqXpM5P2spXK90a7laQ/7dGsKqygkWWSZJW4+XS2BhBxlri
	hCSjo1etx8jvsj6d6Zhu7Tdyc82skZj3WYYXDaKC4o5j/v9B2bFFnbl2YI2DUgHrmUMMiAEPhAg
	xWiUqfwsp3rI/qFfm1O52lQ=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hD0By34NLz12LG8;
	Mon,  3 Aug 2026 09:56:10 +0800 (CST)
Received: from kwepemp100003.china.huawei.com (unknown [7.202.195.218])
	by mail.maildlp.com (Postfix) with ESMTPS id 8FF694056E;
	Mon,  3 Aug 2026 10:05:37 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100003.china.huawei.com (7.202.195.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 10:05:37 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 10:05:36 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v3 0/2] scsi: libsas: Support spinup notification for SAS devices
Date: Mon, 3 Aug 2026 10:05:34 +0800
Message-ID: <20260803020536.546544-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemp500015.china.huawei.com (7.202.195.9)

When a SAS device is in the Active_Wait or Idle_Wait power state, it
returns NOT_READY with ASC/ASCQ = 0x04/0x11 (notify (enable spinup)
required), indicating that a NOTIFY(ENABLE SPINUP) primitive is needed to
trigger media spinup.

Without handling this condition, the SCSI mid-layer will indefinitely retry
the command with ACTION_DELAYED_RETRY, resulting in the disk never spinning
up and becoming unusable. A typical manifestation is:

  sd 4:0:9:0: [sde] Spinning up disk...
  ...not responding...
  sd 4:0:9:0: [sde] Sense Key : Not Ready
  sd 4:0:9:0: [sde] Add. Sense: Logical unit not ready, notify (enable spinup) required

To resolve this, the SAS controller needs to send a NOTIFY(ENABLE SPINUP)
primitive to the target phy, which transitions the device out of the
waiting state and allows normal spinup to proceed.

This patch series addresses the issue entirely within the SAS transport
layer (libsas), reusing the existing phy event framework, without modifying
the generic SCSI mid-layer. This addresses the review feedback from
John Garry on v2.

Changes in v3 (addressing John Garry's review on v2):
- Move spinup notification from scsi_host_template to libsas. Reuse
  the existing phy event framework: add PHYE_NOTIFY_ENABLE_SPINUP
  and lldd_notify_enable_spinup callback.
- Sense detection in sas_ssp_task_response() covers all SAS LLDDs.

Changes in v2 (addressing Sashiko AI review on v1):
- Add softirq context documentation to spinup_notify in
  scsi_host.h
- Defer sl_notify_ssp() to ordered workqueue, fixing
  msleep-in-atomic bug, preventing RMW races on SL_CONTROL, and
  deduplicating concurrent callbacks via queue_work()

Xingui Yang (2):
  scsi: libsas: Add PHYE_NOTIFY_ENABLE_SPINUP phy event for
    ASC/ASCQ=0x04/0x11
  scsi: hisi_sas: Add lldd_notify_enable_spinup callback for SAS devices

 drivers/scsi/hisi_sas/hisi_sas_main.c | 11 +++++++
 drivers/scsi/libsas/sas_internal.h    |  2 ++
 drivers/scsi/libsas/sas_phy.c         | 12 +++++++
 drivers/scsi/libsas/sas_scsi_host.c   | 45 +++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_task.c        |  2 ++
 include/scsi/libsas.h                 |  9 ++++++
 6 files changed, 81 insertions(+)

-- 
2.43.0

