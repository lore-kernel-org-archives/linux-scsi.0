Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49B326AC1;
	Tue, 18 Jun 2024 13:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718717348; cv=none; b=LwR6KT0IARKgqH5RaVHNwJt+NF1WciNgqI5tIYeae4fnd0kr10UCTvb0ZCncPiuiGj86TUNZJ3qasLLCClfnEmu4eHDIBrthXwC5FEoPj+AOXr4HZcvvCV+KctcrAm6IyHrh+jAUn0Ee2fmm8kN7bY2hVwJfxOSh+QBprm3eHng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718717348; c=relaxed/simple;
	bh=6CikAg2USWerGYoZ7lUcHeqLlHtbn8FaFf/1kvzWjg4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tSz0WxAPLkt6Drtd3l56ontOV4aOeWaVDlFHQAZdkE6e6SuD/amGBsJZFDzalF9ySI3ON7Htoo6U+LQPbheUCPYjSAOhvwNMZDNVTtYWUk3ApQ7TuYZb6mHmZDkVHTlbbf57zfV32Zge3J+xgsZ+1IyyTu9ZfEzdUP7CLoS0Yp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4W3SCh3PfCzwSTS;
	Tue, 18 Jun 2024 21:24:48 +0800 (CST)
Received: from kwepemi500008.china.huawei.com (unknown [7.221.188.139])
	by mail.maildlp.com (Postfix) with ESMTPS id 5746318007A;
	Tue, 18 Jun 2024 21:29:02 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 21:29:01 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <dlemoal@kernel.org>
CC: <cassel@kernel.org>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <john.g.garry@oracle.com>,
	<yanaijie@huawei.com>, <linux-kernel@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>, <liyihang9@huawei.com>,
	<chenxiang66@hisilicon.com>, <prime.zeng@huawei.com>
Subject: [bug report] scsi: SATA devices missing after FLR is triggered during HBA suspended
Date: Tue, 18 Jun 2024 21:29:00 +0800
Message-ID: <20240618132900.2731301-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500008.china.huawei.com (7.221.188.139)

Hi Damien,

I found out that two issues is caused by commit 0c76106cb975 ("scsi: sd:
Fix TCG OPAL unlock on system resume") and 626b13f015e0 ("scsi: Do not
rescan devices with a suspended queue").

The two issues as follows for the situation that there are ATA disks
connected with SAS controller:
(1) FLR is triggered after all disks and controller are suspended. As a
result, the number of disks is abnormal.
(2) After all disks and controller are suspended, and resuming all disks
again, the driver reference counting is not 0 (The value of "Used" in the
lsmod command output is not 0).

For the issue 1, After all disks and controller are suspended, FLR command
will resuming the controller and all sas ports. libsas layer will call
ata_sas_port_resume() to resume ata port and schedule EH to recover it.
In libata standard error handler ata_std_error_handler(), it will call ata
reset function, revalidate ATA devices and issue ATA device command
ATA_CMD_READ_NATIVE_MAX_EXT to read native max address. This command will
failed due to the controller enter suspend state again and libata disable
the device finally. The controller enter suspend state again because FLR
command completes and the runtime PM usage counter is 0.

In commit 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
and 626b13f015e0 ("scsi: Do not rescan devices with a suspended queue"),
use blk_queue_pm_only() to check the device request queue state, if the
device request queue is not running, the device will not be rescanned.
Therefore, the runtime PM usage counter of the controller will not
increase so that the controller enters the suspended state again.

For the issue 2, the cause is unknown.

How to solve these two issues?

regards,
Yihang

