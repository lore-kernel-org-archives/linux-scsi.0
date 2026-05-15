Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EF6402BA8;
	Fri, 15 May 2026 08:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778834814; cv=none; b=BNtQLP79eh2COs1nOSZFS5ZhrudczRXP6+2Ys5Ip/34Zy0Wm/nWmGTYSIFqVl9CS2cIx9DY8SjqBm5g2Jy8zGycySdHdh2krS8hIqIOzFKZo1VyScHe/IKrvSXQD9alXUjh+fwsLa9oMQ6GYcMe4dVrR/OCxnlYQ283LCFXfd/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778834814; c=relaxed/simple;
	bh=rnnqN7HxGEw4FCS69XaeLgqlO/wqWBHpSdGC4nQz0d0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q75IB+B1fIe0drBAp0GaIEKIxSQ+y7F1Fj1RO95z/H/8ZTqgM41/3lRZt9t1jfhZ/Gy+PHbwFq3v06b7+oM5fdjAybkNe3nkvt/P07AD4GWOt4lbS+/fOCbEtqB6PV/omV+pEnaSZ/yb48V22mXr4wiS94+ogJivR7pVrih92yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=HVj34RAo; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="HVj34RAo"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=E84tU1m05aKSXYHci6HhqVcML8f99wx7Ym3RD299hQA=;
	b=HVj34RAosiRgUsE1WEeqOe2jrolC+5HGw9evcf9OR6si2sCUrzyND+OtMaZsjQyx2PhgfSGJi
	+5sIKfYyQ2+4/P5X2UGwyDk/5nxLMYsQtCxOG+TJxHU3v1XVvxVMfU1wQhK8p5HJy1CsKELDd4I
	/FnKdHhaMsYbjhac/d0FpBQ=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gH0wg3k5pz1T4MM;
	Fri, 15 May 2026 16:38:59 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 8EFF040572;
	Fri, 15 May 2026 16:46:43 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 15 May 2026 16:46:43 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v3 0/2] libsas: rediscover improvements for linkrate/sas_addr changes
Date: Fri, 15 May 2026 16:45:29 +0800
Message-ID: <20260515084531.866259-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100018.china.huawei.com (7.202.194.12)

When a device attached to an expander phy experiences a linkrate change
(e.g., due to cable reconnection or negotiation), the current code in
sas_rediscover_dev() treats it as "broadcast flutter" and takes no action
if the SAS address and device type remain unchanged.

This series is a new version based on John Garry's suggestion [1] to
check the linkrate and mark the device as gone and rediscover when
flutter occurs, replacing the previous v2 patch series that used lldd
callbacks.

The previous v2 approach added lldd_dev_info_update callback which John
commented as "seem fragile and too specialized" [2]. This v3 series adopts
a simpler approach that directly checks linkrate/sas_addr changes in
sas_rediscover_dev() and triggers rediscovery using libsas's standard
async discovery pattern.

This aligns with Jason Yan's earlier work [3] which was verified to
solve the linkrate change issue.

Changes from v2:
- Drop lldd_dev_info_update callback approach per John Garry's suggestion
- Drop hisi_sas specific changes (no longer needed without callback)
- Use libsas's async discovery pattern for rediscovery
- Add sas_addr change detection alongside linkrate change

[1] https://lore.kernel.org/linux-scsi/c4e4c99f-a13c-4e28-8650-48be1f96d7cf@oracle.com/
[2] https://lore.kernel.org/linux-scsi/28bd9d5b-f597-0aae-5340-bd951b2083aa@huawei.com/
[3] https://lore.kernel.org/linux-scsi/20190130082412.9357-6-yanaijie@huawei.com/

Your Name (2):
  scsi: libsas: refactor sas_ex_to_ata() using new helper
    sas_ex_to_dev()
  scsi: libsas: Add linkrate and sas_addr change detection in rediscover

 drivers/scsi/libsas/sas_expander.c | 44 ++++++++++++++++++++++++------
 drivers/scsi/libsas/sas_internal.h |  1 +
 2 files changed, 37 insertions(+), 8 deletions(-)

-- 
2.43.0

