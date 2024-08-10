Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E0E347C7;
	Sat, 10 Aug 2024 03:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723259427; cv=none; b=mhAVnMx4Uu+thcmcm8gIQlZKwDyPWdouPp7BuhJ/C/rX5TYybvPsTvkHbAWIoeDJT4/FYxxUumWLKYnkcT3dEP7smf9ivQ1Ta2Vofp09eXuaBcz19WMLOXpFaJ4rIXO5dIb3Eyd+AFfBN8lNVMVDz8ETt5LXK3EAHNSYB0ti7r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723259427; c=relaxed/simple;
	bh=MLwNJcT0ae4bHFVBnGOIEWexZlgIrS5AoIYlPao+Evo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Rl+7hCRpFSpo9Ha4Zrkoj9wnbS2B75tS614dVtb+En4jGijku1Be9VPBDzMJKGOvAAzamxXwWwVEQ4DQxvSBydiYemY5Ypcs5tFA3PJXvOPUWtk20Op0MGV9OR9C9u4WRm95lSWIPsmB6OO/6HjcK2R1l/KiudLxV9oFmEDEF2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Wglyj72Snz1msch;
	Sat, 10 Aug 2024 11:05:33 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id BF986180042;
	Sat, 10 Aug 2024 11:10:20 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 10 Aug 2024 11:10:20 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <liyihang9@huawei.com>, <linuxarm@huawei.com>
Subject: [bug report] sas_phy hardreset/linkreset hang
Date: Sat, 10 Aug 2024 11:10:20 +0800
Message-ID: <20240810031020.1017662-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf100013.china.huawei.com (7.185.36.179)

When I do hardreset/linkreset on each sas_phy in my test machine:

[root@localhost ~]# echo 1 > /sys/class/sas_phy/phy-4:4/hard_reset
[root@localhost ~]# echo 1 > /sys/class/sas_phy/phy-4:4/link_reset
[root@localhost ~]# echo 1 > /sys/class/sas_phy/phy-4:5/hard_reset
[root@localhost ~]# echo 1 > /sys/class/sas_phy/phy-4:5/link_reset

There are calltrace like this:

[11120.011166] INFO: task kworker/u256:4:873271 blocked for more than 120 seconds.
[11120.024091] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11120.031885] task:kworker/u256:4  state:D stack:0     pid:873271 tgid:873271 ppid:2      flags:0x00000208
[11120.041327] Workqueue: 0000:74:02.0_event_q sas_phy_event_worker [libsas]
[11120.048099] Call trace:
[11120.050535]  __switch_to+0xec/0x138
[11120.054013]  __schedule+0x2f8/0x1108
[11120.057576]  schedule+0x3c/0x108
[11120.060793]  schedule_preempt_disabled+0x2c/0x50
[11120.065392]  __mutex_lock.constprop.0+0x2b0/0x618
[11120.070078]  __mutex_lock_slowpath+0x1c/0x30
[11120.074335]  mutex_lock+0x40/0x58
[11120.077638]  device_del+0x48/0x3d0
[11120.081030]  __scsi_remove_device+0x12c/0x178
[11120.085371]  scsi_remove_target+0x1b4/0x240
[11120.089538]  sas_rphy_remove+0x8c/0x98
[11120.093273]  sas_rphy_delete+0x20/0x40
[11120.097008]  sas_destruct_devices+0x64/0xa8 [libsas]
[11120.101960]  sas_deform_port+0x174/0x1b0 [libsas]
[11120.106651]  sas_phye_loss_of_signal+0x24/0x38 [libsas]
[11120.111861]  sas_phy_event_worker+0x38/0x68 [libsas]
[11120.116816]  process_one_work+0x148/0x390
[11120.120812]  worker_thread+0x338/0x450
[11120.124547]  kthread+0x120/0x130
[11120.127763]  ret_from_fork+0x10/0x20
[11120.131344] INFO: task bash:922413 blocked for more than 120 seconds.
[11120.143396] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11120.151190] task:bash            state:D stack:0     pid:922413 tgid:922413 ppid:913722 flags:0x00000200
[11120.160629] Call trace:
[11120.163067]  __switch_to+0xec/0x138
[11120.166540]  __schedule+0x2f8/0x1108
[11120.170102]  schedule+0x3c/0x108
[11120.173318]  schedule_timeout+0x1a0/0x1d0
[11120.177313]  wait_for_completion+0x7c/0x168
[11120.181479]  __flush_workqueue+0x104/0x3e0
[11120.185560]  drain_workqueue+0xb8/0x168
[11120.189382]  __sas_drain_work+0x50/0x98 [libsas]
[11120.193985]  sas_drain_work+0x64/0x70 [libsas]
[11120.198419]  queue_phy_reset+0x98/0xe8 [libsas]
[11120.202936]  store_sas_hard_reset+0x5c/0xa0
[11120.207102]  dev_attr_store+0x20/0x40
[11120.210747]  sysfs_kf_write+0x4c/0x68
[11120.214398]  kernfs_fop_write_iter+0x120/0x1b8
[11120.218835]  vfs_write+0x32c/0x3f0
[11120.222226]  ksys_write+0x70/0x108
[11120.225622]  __arm64_sys_write+0x24/0x38
[11120.229531]  invoke_syscall+0x50/0x128
[11120.233268]  el0_svc_common.constprop.0+0xc8/0xf0
[11120.237955]  do_el0_svc+0x24/0x38
[11120.241259]  el0_svc+0x38/0xd8
[11120.244304]  el0t_64_sync_handler+0xc0/0xc8
[11120.248471]  el0t_64_sync+0x1a4/0x1a8
[11120.252121] INFO: task bash:922470 blocked for more than 121 seconds.
[11120.264169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11120.271963] task:bash            state:D stack:0     pid:922470 tgid:922470 ppid:913722 flags:0x00000200
[11120.281402] Call trace:
[11120.283840]  __switch_to+0xec/0x138
[11120.287317]  __schedule+0x2f8/0x1108
[11120.290879]  schedule+0x3c/0x108
[11120.294093]  schedule_preempt_disabled+0x2c/0x50
[11120.298691]  __mutex_lock.constprop.0+0x2b0/0x618
[11120.303378]  __mutex_lock_slowpath+0x1c/0x30
[11120.307633]  mutex_lock+0x40/0x58
[11120.310936]  queue_phy_reset+0x70/0xe8 [libsas]
[11120.315456]  store_sas_link_reset+0x5c/0xa0
[11120.319626]  dev_attr_store+0x20/0x40
[11120.323274]  sysfs_kf_write+0x4c/0x68
[11120.326929]  kernfs_fop_write_iter+0x120/0x1b8
[11120.331358]  vfs_write+0x32c/0x3f0
[11120.334746]  ksys_write+0x70/0x108
[11120.338137]  __arm64_sys_write+0x24/0x38
[11120.342045]  invoke_syscall+0x50/0x128
[11120.345780]  el0_svc_common.constprop.0+0xc8/0xf0
[11120.350467]  do_el0_svc+0x24/0x38
[11120.353771]  el0_svc+0x38/0xd8
[11120.356816]  el0t_64_sync_handler+0xc0/0xc8
[11120.360983]  el0t_64_sync+0x1a4/0x1a8

My test machine was running kernel v6.11-rc1 with driver libsas/hisi_sas,
and this issue is very difficult to trigger.

In my machine there are some disks attached to SAS controller.

[root@localhost ~]# lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    0   1.7T  0 disk 
sdb           8:16   0   1.5T  0 disk 
sdc           8:32   0   3.6T  0 disk 
sdd           8:48   0   1.7T  0 disk 
sde           8:64   0 447.1G  0 disk 
sdf           8:80   0   3.6T  0 disk 
sdg           8:96   0   3.6T  0 disk 
sdh           8:112  0   3.6T  0 disk 
nvme0n1     259:0    0 745.2G  0 disk 
├─nvme0n1p1 259:1    0   600M  0 part /boot/efi
├─nvme0n1p2 259:2    0     1G  0 part /boot
├─nvme0n1p3 259:3    0     4G  0 part [SWAP]
├─nvme0n1p4 259:4    0    70G  0 part /
└─nvme0n1p5 259:5    0 669.6G  0 part /home

According to my understanding, this issue involves multiple layers, such
as the SCSI core, libsas, and LLDD driver(hisi_sas driver).

Thanks,

Yihang.

