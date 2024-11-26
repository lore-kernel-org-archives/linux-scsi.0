Received: from bg1.exmail.qq.com (bg1.exmail.qq.com [114.132.67.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D150C17B506;
	Tue, 26 Nov 2024 11:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.132.67.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732621995; cv=none; b=ClGYV1skS3S7ZTIlg/etbaLQHut1UMQEZ7nwk0QrKQ5y5K2C/1JJyQnYrO3KG7lcgY2sxgvI92unpZOqUCnY2GfVa1zUWLnfeQGG2Bgp6yagOb5zSDHQjNb+5D7mLZaoyK+myvE+WrD5BeA5FqSZ72Wji4Dgde9J6V7Vxq/iubs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732621995; c=relaxed/simple;
	bh=QSLJPYKeKE/LW8VaQ2MUFPC8r6A3KNMXvW0CPu9ia88=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZOr5bX/hL1xy69sWbDkT+xvnd77cTDDt7ohL5F4atOkZ12kEx5+f/rS/dkmkmLxrX03NO+QngQl8m/LGzlXBngrIwH2I4z98bdm52QDmd8/eY3A8A/mj2m5bw5oXg4TP7Xd0hUVJYPpX2zyf7ghleuTK/ZxzbQaRnCsb89brQmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=mtHb6wYa; arc=none smtp.client-ip=114.132.67.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="mtHb6wYa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1732621857;
	bh=3IyYNYKhg9cg25HtN1zMBL24Lt/oEEdr6e1xvLsqY8c=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=mtHb6wYaBzsYhe9ymhPgOl1HEFRDpG4Pnykzth6TRCjDFffyZpAJ3F81OTjCr8yXP
	 aQb/33xlqvKoeWfVxY5nvtNLJCqnKzdCoHoBeidsv6t/snG0INXfDtITy0ChhNEojb
	 STxah+NRyDN+RJYbliNcqA3qvJX9WTdklcff3F8g=
X-QQ-mid: bizesmtpip2t1732621841t6aj03c
X-QQ-Originating-IP: neFej1rtBNIXVcsVuveykptdyWygG6LPVAwryrloF2U=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 26 Nov 2024 19:50:39 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10749667539244190580
From: Qiang Ma <maqianga@uniontech.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	axboe@kernel.dk,
	dwagner@suse.de,
	ming.lei@redhat.com,
	hare@suse.de
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiang Ma <maqianga@uniontech.com>
Subject: [PATCH] scsi: Don't wait for completion of in-flight requests
Date: Tue, 26 Nov 2024 19:50:08 +0800
Message-Id: <20241126115008.31272-1-maqianga@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: M/ypFxmAP/2/qKK9gOF+WhseRQBsRXYaKjMZzuJ8BIA8CMR4XsU6nzNQ
	rM6cOW8+clCH0QV0yXSbXNgKU9D7usICQuiG+Iiz4ipYL1AyIArop8Z5IH4YxW3+mlqigYz
	FSg4ggdhGoZJHBetGjZngL02/gdMw28fGdB6mW8kIyv0Q4c+xkiEi6bv7Plz3IRhDiHWjwL
	AVp72zSMtlYwOnx3MGHBagahKujmxro13I6wynnQZpBEVDaqBzosJf28ytWMdy+8/8vAugk
	q4fNVU4uXuAwX08u4Mfrb0vsvDGm7238pZgHWoGGW0Ojpx3Ojte7rrvd0FLw2CP+WQLbfnP
	YFF2CJnoUqtWfAWMbIjfKzaNSQSYfL1NrDqI79lDqB33yWptuG2o+A8ghtPHjql7kR5qqGA
	Iterta8UAvMt5G6106aJXOsZXN1wriLXDtYfKGyNGufiMpWOSaldglGPftI/eedKCbO8ZuP
	zhA9sgLkecZjMIVTEvwYlFBrGZkWuY+Fkj+EXyJuJp7NXqXqAuZOPxylh1ghYNNScz7j8ei
	dNjPOFd3RoscQsODgpaQXPUngs5pg5igaDVx3JDSFjesZ5h4q5jS7NdJci/S0vcknAkQXZQ
	SUN5mwWet2h1wqs8EFlKmiq3gD+NoEslrKLgKRdY9GXec4ypVYm1Jo5V2mdTRUpDbNc2d7t
	tFQAmSVhBGJBsRbsdKVcYuUJwPEYigyUq+BxUNG8ZwbOS5ysS0uQ7+QJB+S8rvSkOsA30db
	d0enLX6oVuSt9a+eCHf0C/c2WKmGDddwkhfiox9OK7N6QqQjx8KL7ekllCl5C8qm51An7Zd
	XJIxoxxKR514ps+Om3gz8mrDh+vAYLnR+oZdCvFfwYug6pN1dyx71yC2UfhJxDHvZC07Syt
	83J6TcDCLwN2mz9m4j5FJ3q8ypnWn8B1XdZohqSe/HdaK/CVnlkH61OpKx36wgLDfQOk3My
	XNZ9IVmmOAnVjbA==
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-RECHKSPAM: 0

Problem:
When the system disk uses the scsi disk bus, The main
qemu command line includes:
...
-device virtio-scsi-pci,id=scsi0 \
-device scsi-hd,scsi-id=1,drive=drive-virtio-disk
-drive id=drive-virtio-disk,if=none,file=/home/kvm/test.qcow2
...

The dmesg log is as follows::

[   50.304591][ T4382] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   50.377002][ T4382] kexec_core: Starting new kernel
[   50.669775][  T194] psci: CPU1 killed (polled 0 ms)
[   50.849665][  T194] psci: CPU2 killed (polled 0 ms)
[   51.109625][  T194] psci: CPU3 killed (polled 0 ms)
[   51.319594][  T194] psci: CPU4 killed (polled 0 ms)
[   51.489667][  T194] psci: CPU5 killed (polled 0 ms)
[   51.709582][  T194] psci: CPU6 killed (polled 0 ms)
[   51.949508][   T10] psci: CPU7 killed (polled 0 ms)
[   52.139499][   T10] psci: CPU8 killed (polled 0 ms)
[   52.289426][   T10] psci: CPU9 killed (polled 0 ms)
[   52.439552][   T10] psci: CPU10 killed (polled 0 ms)
[   52.579525][   T10] psci: CPU11 killed (polled 0 ms)
[   52.709501][   T10] psci: CPU12 killed (polled 0 ms)
[   52.819509][  T194] psci: CPU13 killed (polled 0 ms)
[   52.919509][  T194] psci: CPU14 killed (polled 0 ms)
[  243.214009][  T115] INFO: task kworker/0:1:10 blocked for more than 122 seconds.
[  243.214810][  T115]       Not tainted 6.6.0+ #1
[  243.215517][  T115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  243.216390][  T115] task:kworker/0:1     state:D stack:0     pid:10    ppid:2      flags:0x00000008
[  243.217299][  T115] Workqueue: events vmstat_shepherd
[  243.217816][  T115] Call trace:
[  243.218133][  T115]  __switch_to+0x130/0x1e8
[  243.218568][  T115]  __schedule+0x660/0xcf8
[  243.219013][  T115]  schedule+0x58/0xf0
[  243.219402][  T115]  percpu_rwsem_wait+0xb0/0x1d0
[  243.219880][  T115]  __percpu_down_read+0x40/0xe0
[  243.220353][  T115]  cpus_read_lock+0x5c/0x70
[  243.220795][  T115]  vmstat_shepherd+0x40/0x140
[  243.221250][  T115]  process_one_work+0x170/0x3c0
[  243.221726][  T115]  worker_thread+0x234/0x3b8
[  243.222176][  T115]  kthread+0xf0/0x108
[  243.222564][  T115]  ret_from_fork+0x10/0x20
...
[  243.254080][  T115] INFO: task kworker/0:2:194 blocked for more than 122 seconds.
[  243.254834][  T115]       Not tainted 6.6.0+ #1
[  243.255529][  T115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  243.256378][  T115] task:kworker/0:2     state:D stack:0     pid:194   ppid:2      flags:0x00000008
[  243.257284][  T115] Workqueue: events work_for_cpu_fn
[  243.257793][  T115] Call trace:
[  243.258111][  T115]  __switch_to+0x130/0x1e8
[  243.258541][  T115]  __schedule+0x660/0xcf8
[  243.258971][  T115]  schedule+0x58/0xf0
[  243.259360][  T115]  schedule_timeout+0x280/0x2f0
[  243.259832][  T115]  wait_for_common+0xcc/0x2d8
[  243.260287][  T115]  wait_for_completion+0x20/0x38
[  243.260767][  T115]  cpuhp_kick_ap+0xe8/0x278
[  243.261207][  T115]  cpuhp_kick_ap_work+0x5c/0x188
[  243.261688][  T115]  _cpu_down+0x120/0x378
[  243.262103][  T115]  __cpu_down_maps_locked+0x20/0x38
[  243.262609][  T115]  work_for_cpu_fn+0x24/0x40
[  243.263059][  T115]  process_one_work+0x170/0x3c0
[  243.263533][  T115]  worker_thread+0x234/0x3b8
[  243.263981][  T115]  kthread+0xf0/0x108
[  243.264405][  T115]  ret_from_fork+0x10/0x20
[  243.264846][  T115] INFO: task kworker/15:2:639 blocked for more than 122 seconds.
[  243.265602][  T115]       Not tainted 6.6.0+ #1
[  243.266296][  T115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  243.267143][  T115] task:kworker/15:2    state:D stack:0     pid:639   ppid:2      flags:0x00000008
[  243.268044][  T115] Workqueue: events_freezable_power_ disk_events_workfn
[  243.268727][  T115] Call trace:
[  243.269051][  T115]  __switch_to+0x130/0x1e8
[  243.269481][  T115]  __schedule+0x660/0xcf8
[  243.269903][  T115]  schedule+0x58/0xf0
[  243.270293][  T115]  schedule_timeout+0x280/0x2f0
[  243.270763][  T115]  io_schedule_timeout+0x50/0x70
[  243.271245][  T115]  wait_for_common_io.constprop.0+0xb0/0x298
[  243.271830][  T115]  wait_for_completion_io+0x1c/0x30
[  243.272335][  T115]  blk_execute_rq+0x1d8/0x278
[  243.272793][  T115]  scsi_execute_cmd+0x114/0x238
[  243.273267][  T115]  sr_check_events+0xc8/0x310 [sr_mod]
[  243.273808][  T115]  cdrom_check_events+0x2c/0x50 [cdrom]
[  243.274408][  T115]  sr_block_check_events+0x34/0x48 [sr_mod]
[  243.274994][  T115]  disk_check_events+0x44/0x1b0
[  243.275468][  T115]  disk_events_workfn+0x20/0x38
[  243.275939][  T115]  process_one_work+0x170/0x3c0
[  243.276410][  T115]  worker_thread+0x234/0x3b8
[  243.276855][  T115]  kthread+0xf0/0x108
[  243.277241][  T115]  ret_from_fork+0x10/0x20

ftrace finds that it enters an endless loop, code as follows:

if (percpu_ref_tryget(&hctx->queue->q_usage_counter)) {
	while (blk_mq_hctx_has_requests(hctx))
		msleep(5);
	percpu_ref_put(&hctx->queue->q_usage_counter);
}

Solution:
Refer to the loop and dm-rq in patch commit bf0beec0607d
("blk-mq: drain I/O when all CPUs in a hctx are offline"),
add a BLK_MQ_F_STACKING and set it for scsi, so we don't need
to wait for completion of in-flight requests  to avoid a potential
hung task.

Fixes: bf0beec0607d ("blk-mq: drain I/O when all CPUs in a hctx are offline")

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index adee6f60c966..0a2d5d9327fc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2065,7 +2065,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	tag_set->queue_depth = shost->can_queue;
 	tag_set->cmd_size = cmd_size;
 	tag_set->numa_node = dev_to_node(shost->dma_dev);
-	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
+	tag_set->flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_STACKING;
 	tag_set->flags |=
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
 	if (shost->queuecommand_may_block)
-- 
2.20.1

