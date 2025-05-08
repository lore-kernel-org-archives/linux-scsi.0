Received: from mail-m32102.qiye.163.com (mail-m32102.qiye.163.com [220.197.32.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB5D2253B2;
	Thu,  8 May 2025 12:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708968; cv=none; b=MY0/zzSbSpgBcNwL9eFgeMw7jZlF2GuGPBZfANsc1dXeibleuhdT4EqzrV6OQ+mrlIO9hcRAhSG0A9S8XqlG0kKmMhceThmMrX9N3wo/vOBiwqOA52Gagl5xyjHQDQMI1e/SMTbm1ivGXUA79Ep3vE/A4LOoathqwTs+RsEFwEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708968; c=relaxed/simple;
	bh=5PDCbIC95j/ITD40mDOy1iMbEairxNDKkHP6w2tyA+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GOEM1tttbxur2oBjLoz2UPa+rETu7ZXTDo2qr6QTE28NTJPAEZ32iticuz3hdgA0XoG1YYXx+DfYH1cBLbSv6rujbApJ15GpPrUPjmJbue9QLj1lbnr+POiH72fTqUERUPjGpKSK76Dr4zLaifotM7heHI0dXB+q8bzEQwY+MYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sangfor.com.cn; spf=pass smtp.mailfrom=sangfor.com.cn; arc=none smtp.client-ip=220.197.32.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sangfor.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sangfor.com.cn
Received: from ubuntu.. (unknown [121.32.254.147])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1464cfa34;
	Thu, 8 May 2025 20:50:46 +0800 (GMT+08:00)
From: Zhu Wei <zhuwei@sangfor.com.cn>
To: don.brace@microchip.com,
	kevin.barnett@microchip.com
Cc: dinghui@sangfor.com.cn,
	zengzhicong@sangfor.com.cn,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Zhu Wei <zhuwei@sangfor.com.cn>
Subject: [PATCH] scsi: smartpqi: Fix the race condition between pqi_tmf_worker and pqi_sdev_destroy
Date: Thu,  8 May 2025 20:50:11 +0800
Message-ID: <20250508125011.3455696-1-zhuwei@sangfor.com.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZSx9KVhlNSh5KTE1NTUxMSFYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlKSUpVSElVSU5PVUpPTFlXWRYaDxIVHRRZQVlPS0hVSktJT09PSFVKS0
	tVSkJLS1kG
X-HM-Tid: 0a96aff2c9a309cekunm1464cfa34
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRg6Tgw5LjIMTg0qAU4oSgsj
	GA5PCzVVSlVKTE9NTEtDTU9MT0JMVTMWGhIXVQETDgweEjsIGhUcHRQJVRgUFlUYFUVZV1kSC1lB
	WUpJSlVISVVJTk9VSk9MWVdZCAFZQU5PSE03Bg++

There is a race condition between pqi_sdev_destroy and pqi_tmf_worker.
After pqi_free_device is released, pqi_tmf_worker will still use device.

kasan report:
[ 1933.765810] ==================================================================
[ 1933.771862] scsi 15:0:20:0: Direct-Access     ATA      WDC  WUH722222AL WTS2 PQ: 0 ANSI: 6
[ 1933.779190] BUG: KASAN: use-after-free in pqi_device_wait_for_pending_io+0x9e/0x600 [smartpqi]
[ 1933.779194] Read of size 4 at addr ffff88954c490480 by task kworker/2:2/518186
[ 1933.779201] CPU: 2 PID: 518186 Comm: kworker/2:2 Kdump: loaded Tainted: G     U     OE
			4.19.90-89.16.v2401.osc.sfc.6.11.1.0108.ky10.x86_64+debug #1
[ 1933.779203] Source Version: v6.11.1.0108+0~65323201.20250328
[ 1933.779205] Hardware name: SANGFOR S2122-S12L/ASERVER-P-2000, BIOS TYR.2.00.0100 05/18/2019
[ 1933.779213] Workqueue: events pqi_tmf_worker [smartpqi]
[ 1933.779216] Call Trace:
[ 1933.779225]  dump_stack+0x8b/0xb9
[ 1933.779239]  print_address_description+0x65/0x2b0
[ 1933.779249]  kasan_report+0x14b/0x290
[ 1933.779255]  pqi_device_wait_for_pending_io+0x9e/0x600 [smartpqi]
[ 1933.779264]  pqi_device_reset_handler+0x174f/0x1f30 [smartpqi]
[ 1933.779284]  process_one_work+0x65f/0x12d0
[ 1933.806306]  worker_thread+0x87/0xb50
[ 1933.806315]  kthread+0x2e9/0x3a0
[ 1933.806323]  ret_from_fork+0x1f/0x40
[ 1933.843994] Allocated by task 579094:
[ 1933.875361]  save_stack+0x19/0x80
[ 1933.892366]  kasan_kmalloc+0xa0/0xd0
[ 1933.892373]  kmem_cache_alloc+0xbb/0x1c0
[ 1933.892378]  getname_flags+0xba/0x500
[ 1933.892384]  user_path_at_empty+0x1d/0x40
[ 1933.892389]  vfs_statx+0xb9/0x140
[ 1933.892397]  __do_sys_newstat+0x77/0xd0
[ 1933.913179]  do_syscall_64+0xa4/0x430
[ 1933.913187]  entry_SYSCALL_64_after_hwframe+0x5c/0xc1
[ 1933.933381] Freed by task 579094:
[ 1933.933389]  save_stack+0x19/0x80
[ 1933.933392]  __kasan_slab_free+0x130/0x180
[ 1933.933396]  kmem_cache_free+0x78/0x1e0
[ 1933.933401]  filename_lookup+0x216/0x400
[ 1933.933405]  vfs_statx+0xb9/0x140
[ 1933.933407]  __do_sys_newstat+0x77/0xd0
[ 1933.933417]  do_syscall_64+0xa4/0x430
[ 1933.933432]  entry_SYSCALL_64_after_hwframe+0x5c/0xc1
[ 1933.956837]
[ 1933.956842] The buggy address belongs to the object at ffff88954c490000
                which belongs to the cache names_cache of size 4096
[ 1933.956845] The buggy address is located 1152 bytes inside of
                4096-byte region [ffff88954c490000, ffff88954c491000)
[ 1933.956851] The buggy address belongs to the page:
[ 1934.297352] page:ffffea0055312400 count:1 mapcount:0 mapping:ffff888100580f00
		index:0x0 compound_mapcount: 0
[ 1934.309566] flags: 0x57ffffc0008100(slab|head)
[ 1934.316370] raw: 0057ffffc0008100 0000000000000000 dead000000000200 ffff888100580f00
[ 1934.326518] raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
[ 1934.338191] page dumped because: kasan: bad access detected
[ 1934.346177]
[ 1934.350031] Memory state around the buggy address:
[ 1934.357220]  ffff88954c490380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 1934.366854]  ffff88954c490400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 1934.376474] >ffff88954c490480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 1934.386094]                    ^
[ 1934.391684]  ffff88954c490500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 1934.402601]  ffff88954c490580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 1934.412228] ==================================================================

Before pqi_sdev_destroy executes pqi_free_device, cancel the pqi_tmf_worker
of the corresponding device.

Fixes: 2d80f4054f7f ("scsi: smartpqi: Update deleting a LUN via sysfs")
Signed-off-by: Zhu Wei <zhuwei@sangfor.com.cn>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8a26eca4fdc9..102ed7501f08 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6581,6 +6581,8 @@ static void pqi_sdev_destroy(struct scsi_device *sdev)
 	struct pqi_scsi_dev *device;
 	int mutex_acquired;
 	unsigned long flags;
+	unsigned int lun;
+	struct pqi_tmf_work *tmf_work;
 
 	ctrl_info = shost_to_hba(sdev->host);
 
@@ -6607,6 +6609,8 @@ static void pqi_sdev_destroy(struct scsi_device *sdev)
 	mutex_unlock(&ctrl_info->scan_mutex);
 
 	pqi_dev_info(ctrl_info, "removed", device);
+	for (lun = 0, tmf_work = device->tmf_work; lun < PQI_MAX_LUNS_PER_DEVICE; lun++, tmf_work++)
+		cancel_work_sync(&tmf_work->work_struct);
 	pqi_free_device(device);
 }
 
-- 
2.43.0

