Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F862BEC2C
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 01:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776647925; cv=none; b=d22UIXdtrpLqhW0Sv/mv1giPmFY8nI6JscJuHz9Wzy3cP/3a0TT3OOWmAYkuJQ7ju6kdJLBclRhMStQVzsQra0O9i6r7Jq8Q7u+UrGGG7ogs5fSIaWpAg8Hh+kYuHnTxTuAzW5b76Sg/p+j2t7hVgai1QfSRuffM1xYSatAo95E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776647925; c=relaxed/simple;
	bh=zYDcEQSgTp178jNC121tQFooVi/EY93qrgiGn32cl6k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kSkQoXonlOSZWawNYrbMrmlGGMRjq+R9xsvJwlb1Bd08YoReC8Y5jZlZFFAYaAJEO38xq+od5wBHx2132GtiVTEpC631RQwvPzjGyZ8/zJED5wbbJPN6XDkrxE9cNdsT4+mIPcl/jdeQMq386YhbDm90VOCYQF65cMEvldDJhvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BfVSFcPD; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BfVSFcPD"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8d583bfc415so361358585a.2
        for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2026 18:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776647921; x=1777252721; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BjC4uGghKA3IDlSxUu6ZtopGzDLEMo/LzF1YQKMzVb4=;
        b=BfVSFcPDrVH7PpbJksEGl/AExLSik2sbFj58MoUE0AcXw5QHi+dW0yBds0o73z5/GC
         E20wI9iq1ldZjphRUhbwLQO5UItr07864EgKVKZ2N4MX3l7MV3Sby3gxc79vDpCWeN/1
         rZpSwWzj6BEir4FVD0infu40tN/0j/Vjk5QX1kCA1wG0O5detdR5S7YG7BqRbYZHJpgQ
         Rf4C3haQFwK8rhCyfkhJALnzYyz/0O2Z5AnCIm067CyH0kUExoBHYG07ji3UmS8X7uBt
         M9uSbKzkpijSItzmMNBJfxtzKQ9hx00Lu0TZoTrfFQyHCADzVJUax+xX/M20baP1eP9L
         CIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776647921; x=1777252721;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BjC4uGghKA3IDlSxUu6ZtopGzDLEMo/LzF1YQKMzVb4=;
        b=cziJVH0MSIOhatdk+d5OyOPfYBn3ckM0X/EGavwNjDC6y79Kqs6NPDkIXxbRmaYx3+
         2VjGE0ewshAqa9unsjCR1la7NgubeGcB7s5ZznVcT4NvhimKKYk1ztedbvcIh7DAFy+l
         G2o4c5tZbjC9VTfJfrqPbAd/QTk1KBpjvJFbv8QsVP75Qi9tkp05luIoZzHqVOT8c3US
         3lY6MGoHp0wi7hj5q7cnqLM8EeQiEOpYE2vHHwL7Qx+I6UUsDGOkuDk2XzxqdHkXs0A9
         vtSpXiaaX/boXGe6jw55CmC8T+l8oKWR3PmX+mtl8hIsjgSfjKo8Gc/OHceccz2bwOgo
         Ty+w==
X-Gm-Message-State: AOJu0YxOeP7x9kmoXqKdUtTSZ6NbkmbEVNPXLqdhC/3E4pbvqcZkmYsV
	jA9Tg8hiZmn7pYsRQ28ZSZvw5HuTcrMIdh0Yh8sI11cgHBxfJ+GWoa4Hr+ufqw==
X-Gm-Gg: AeBDiesyK6eRu+xKUZMh93fWiPJU8cnL4UkbhmoXU53lTsELJ6lZ7PWitoHGAYzeO5M
	LvoCd2RvyHRUvqnpJ/iENc3WxF4YMRihc7JOyJ3ffUdha64z7nayIvjqbPEdh97EKop423IU49N
	p1QOrhQNkwkCAMbpFFDfxBvaRRvKXz9dpjCpva52TQj3l5vx5FzFArxGvDkiMWCaUIkmncq8UbX
	O91GgOm5D+xGQ1TQd19YXTRnhEqJcaHaKz2adQiat+qSbg3Nq5CdnTHtPizwsDuQJkAfewxuzVL
	2KUgq1qmLuWZhexADKC8FZjd6KxUFBqxWSEs+ksdwXnKA+C9PxjqO2WTQgFp+lNLa3gkENZB0yL
	TSQg76Mamje5IYNhh5iTxgnl6uoV72xTGGS/6PP/lkyZlmdszDUaeEcp+Ea81pP/xO/tlWfsmvl
	hwshioxU0iq/cFNTGV5skwQCaUHYJmWsCjKrhU34Qz2BH0LqSAZI66EP5BWc8=
X-Received: by 2002:a05:620a:31a5:b0:8d6:874c:a763 with SMTP id af79cd13be357-8e791d87409mr1642431485a.49.1776647920610;
        Sun, 19 Apr 2026 18:18:40 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d64cbbdbsm725213085a.12.2026.04.19.18.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 18:18:39 -0700 (PDT)
From: Dingisoul <dingiso.kernel@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [BUG] null-ptr-deref in mptlan_remove()
Date: Sun, 19 Apr 2026 21:18:29 -0400
Message-Id: <20260420011829.176936-1-dingiso.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kernel maintainers,

We found a null-ptr-deref in mptlan_remove() on commit
8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb (Mar 18 2026).

Please see the details below.

In mptlan_remove, dev is assigned from ioc->netdev and calculates
priv. If dev is uninitialized, priv becomes an invalid pointer, 
causing a crash when used inside cancel_delayed_work_sync().

static void
mptlan_remove(struct pci_dev *pdev)
{
	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
	struct net_device	*dev = ioc->netdev; // dev is uninitialized.
	struct mpt_lan_priv *priv = netdev_priv(dev);
	cancel_delayed_work_sync(&priv->post_buckets_task);
	if(dev != NULL) {
		unregister_netdev(dev);
		free_netdev(dev);
	}
}

Root cause analysis:

In mptlan_probe, if mpt_register_lan_device fails for all ports,
ioc->netdev remians uninitialized. The function returns error code
-ENODEV, but both callsites of this function do not check the return
code and handle this error case.

static int
mptlan_probe(struct pci_dev *pdev)
{
	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
	struct net_device	*dev;
	int			i;

	for (i = 0; i < ioc->facts.NumberOfPorts; i++) {
		dev = mpt_register_lan_device(ioc, i);
		if (!dev) {
			continue; // ioc->netdev is NULL.
		}
	
		ioc->netdev = dev;

		return 0;
	}

	return -ENODEV;
}

int
mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, u8 cb_idx)
{
	MPT_ADAPTER	*ioc;

	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS)
		return -EINVAL;

	MptDeviceDriverHandlers[cb_idx] = dd_cbfunc;

	/* call per pci device probe entry point */
	list_for_each_entry(ioc, &ioc_list, list) {
		if (dd_cbfunc->probe)
			dd_cbfunc->probe(ioc->pcidev); // Callsite 1.
	 }

	return 0;
}

int
mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
{
        /* call per device driver probe entry point */
	for(cb_idx = 0; cb_idx < MPT_MAX_PROTOCOL_DRIVERS; cb_idx++) {
		if(MptDeviceDriverHandlers[cb_idx] &&
		  MptDeviceDriverHandlers[cb_idx]->probe) {
			MptDeviceDriverHandlers[cb_idx]->probe(pdev); // Callsite 2
		}
	}
}

The KASAN report for this bug is shown below:

[ T8493] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000168: 0000 [#1] SMP KASAN PTI
[ T8493] KASAN: null-ptr-deref in range [0x0000000000000b40-0x0000000000000b47]
[ T8493] CPU: 0 UID: 0 PID: 8493 Comm: bash Not tainted 7.0.0-rc4-00091-g8a30aeb0d1b4-dirty #71 PREEMPT(full)
[ T8493] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[ T8493] RIP: 0010:timer_is_static_object (kernel/time/timer.c:691)
[ T8493] Code: 90 90 90 90 90 90 90 90 0f 1f 44 00 00 41 57 41 56 53 48 89 fb 49 bf 00 00 00 00 00 fc ff df 4c 8d 77 08 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00 74 08 4c 89 f7 e8 2f cf 69 00 49 83 3e 00 74 04 31
[ T8493] RSP: 0018:ffff88810b787828 EFLAGS: 00010002
[ T8493] RAX: 0000000000000168 RBX: 0000000000000b38 RCX: 0000000000000001
[ T8493] RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000b38
[ T8493] RBP: ffffffff90a3a9c0 R08: 0000000000000003 R09: 0000000000000004
[ T8493] R10: dffffc0000000000 R11: ffffffff819006d0 R12: dffffc0000000000
[ T8493] R13: fffffffffffffffe R14: 0000000000000b40 R15: dffffc0000000000
[ T8493] FS:  00007f20bbc20740(0000) GS:ffff8880d355f000(0000) knlGS:0000000000000000
[ T8493] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ T8493] CR2: 000055ef66b31620 CR3: 0000000107c04000 CR4: 00000000000006f0
[ T8493] Call Trace:
[ T8493]  <TASK>
[ T8493]  debug_object_assert_init (lib/debugobjects.c:696 lib/debugobjects.c:1025)
[ T8493]  __timer_delete (./include/linux/list.h:975 ./include/linux/timer.h:147 kernel/time/timer.c:1379)
[ T8493]  work_grab_pending (kernel/workqueue.c:2080 kernel/workqueue.c:2173)
[ T8493]  __cancel_work (kernel/workqueue.c:4419)
[ T8493]  cancel_delayed_work_sync (kernel/workqueue.c:4436 kernel/workqueue.c:4522)
[ T8493]  mptlan_remove (drivers/message/fusion/mptlan.c:1433)
[ T8493]  mpt_detach (drivers/message/fusion/mptbase.c:?)
[ T8493]  pci_device_remove (./include/linux/pm_runtime.h:133 drivers/pci/pci-driver.c:504)
[ T8493]  device_release_driver_internal (drivers/base/dd.c:? drivers/base/dd.c:1284 drivers/base/dd.c:1307)
[ T8493]  unbind_store (drivers/base/bus.c:249)
[ T8493]  kernfs_fop_write_iter (fs/kernfs/file.c:352)
[ T8493]  vfs_write (fs/read_write.c:596 fs/read_write.c:688)
[ T8493]  ksys_write (fs/read_write.c:?)
[ T8493]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
[ T8493]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[ T8493] RIP: 0033:0x7f20bbd0e473
[ T8493] Code: 8b 15 21 2a 0e 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 18
[ T8493] RSP: 002b:00007ffe77315a08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[ T8493] RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007f20bbd0e473
[ T8493] RDX: 000000000000000d RSI: 0000564ac2f86da0 RDI: 0000000000000001
[ T8493] RBP: 0000564ac2f86da0 R08: 000000000000000a R09: 00007f20bbdf1be0
[ T8493] R10: 0000000000000080 R11: 0000000000000246 R12: 000000000000000d
[ T8493] R13: 00007f20bbdf26a0 R14: 000000000000000d R15: 00007f20bbded880
[ T8493]  </TASK>
[ T8493] Modules linked in:
[ T8493] ---[ end trace 0000000000000000 ]---
[ T8493] RIP: 0010:timer_is_static_object (kernel/time/timer.c:691)
[ T8493] Code: 90 90 90 90 90 90 90 90 0f 1f 44 00 00 41 57 41 56 53 48 89 fb 49 bf 00 00 00 00 00 fc ff df 4c 8d 77 08 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00 74 08 4c 89 f7 e8 2f cf 69 00 49 83 3e 00 74 04 31
[ T8493] RSP: 0018:ffff88810b787828 EFLAGS: 00010002
[ T8493] RAX: 0000000000000168 RBX: 0000000000000b38 RCX: 0000000000000001
[ T8493] RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000b38
[ T8493] RBP: ffffffff90a3a9c0 R08: 0000000000000003 R09: 0000000000000004
[ T8493] R10: dffffc0000000000 R11: ffffffff819006d0 R12: dffffc0000000000
[ T8493] R13: fffffffffffffffe R14: 0000000000000b40 R15: dffffc0000000000
[ T8493] FS:  00007f20bbc20740(0000) GS:ffff8880d355f000(0000) knlGS:0000000000000000
[ T8493] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ T8493] CR2: 000055ef66b31620 CR3: 0000000107c04000 CR4: 00000000000006f0
[ T8493] note: bash[8493] exited with irqs disabled
[ T8493] note: bash[8493] exited with preempt_count 1

Please let us know if you need any additional information.

Thanks.
