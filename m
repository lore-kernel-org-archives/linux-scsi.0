Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BC44E9C1F
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 20:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791836260; cv=none; b=ag7tm9e2xrglw+OMNK2/Diraf5D/anocDf8kzHM2rIKADqIymgx0xbAMfQkdfM4wkePT9IObsICRLN8uj6V5EjtIvPPbMJYA9m/USg7QuPOH/glnPtzl26K5O4h9ppwji4mLzt59/SEipQbUZ1lkUcCba0qXBGlcB1ORZlokVos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791836260; c=relaxed/simple;
	bh=61iS9+1SVarRvVuZi7tPbmlBK6P9VGdigJkR9+V6iRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OoCBx9sRrwyebNN5/nLGEZy2SHATIAe+KP+20hIc9Y4As0PkVNS4WQCWreTJzyR7bfCeUV+OM8lktjYvMWfJIlDnO2KPHeR+cbZ/W7MiXMTW6DVki517fgq8IkOlQLmd/zzZ3sew0cGATaGU5UW4YuBHMHgbjNUSWIF1WXYYdto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6D/XXfM; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6D/XXfM"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93ece7a73b9so296758685a.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 13:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791836255; x=1792441055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VoYcMQ1EmcXpMmCHSpOUdX1vSVFqCCRRNJZGecYdkWc=;
        b=L6D/XXfMYjPrzZZiAJb6FfXCbpYGYsrvv+vnXBLFv7GrkJaomCxXTUydt+sazhaSLS
         55nsiZbXoPkPJCTgq/M2ftjUePmNPirQCnQYEBrI9h1tE7shv0FyyKZE6rcAjZE8+LIS
         pToV/KzqKJUbyKGcuAeVvJMJJ2BcCqDbgEPRAEjeYZEurlcsg/Q+0KwPlCurd0Bhmmln
         pumXs8beTkZ4jhPuwigt4HVpMeA3uS9/fKRwCS96L4HUPLFOjc7vMPYdQIJqQy114xNL
         nVbpJyVD7/zLvrhW8FRwnhat56rjytZK1VHNG5H738vTWrWncBgAcYx9fZWcMfVHL2YC
         cZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791836255; x=1792441055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VoYcMQ1EmcXpMmCHSpOUdX1vSVFqCCRRNJZGecYdkWc=;
        b=rYbvw1omrqNJXuztNqRxbpotiX82hJ5TANkbMIm48POPqFJ4dn07u0jA+yKFKLpaJO
         FBwL00Dw6T4EtIR4S58VjJ04/aJLKXVvgQzl21UWUpPzn7AF92/B1EvLlWvbeTVv9/iD
         LW3codI4dkbvOqx1/AY1WG1UlxoqJBc8cFG3RMsYOhYPqjPJhQyFTywpnUuxjg1k43r3
         MY0c+BzWfqJsIx04vNGTuZJID5twn6d93vK19tCJVcRTMvG2GVZD2La7TcbLA8vdFgrq
         kfTpxTItlIQzn34Pr9bvB+njyf1fH113dZxuB47HLlaDe0IhRZO5MG4FlFm6onZZFhEE
         Ik3w==
X-Forwarded-Encrypted: i=1; AKwUvBzoh2UJST5NfY+WKfW/5jcGxF1fI4bW241A2VyL7ZecbM9L88HoDzwpxECb17QBm2D53iQwWxGJehqL@vger.kernel.org
X-Gm-Message-State: AFq9FYJGm1QRWIqek4JjPXhQfSffT9AMUvpxni6qvs2QBulXzhgCuoOP
	a/n0Tq68E9VwMjAxN5M2dAuxNJs7X6L9eePKjJwUE/rXcZnWnS70Ry6H
X-Gm-Gg: AYBFou14p/VAu+t705p2bwnU0BUIajL/VuFHCT2k7F2GuGShHg4fGfZf43k0FPCorps
	YCHAJLW3RpumAy9NfX97WqjUmk+evVSATMLak/7K2ep9Sz6FrS6cN5rBiJvUlSNntybzkadRzaU
	Eeth0/FJ+hcQDWOmJzNAEaG+DSgT9fH7zKvO7xA+urm0Y+W//y4dclBlcdTnkjIApc9SecqJ42I
	KSQaZtW4p3NUuoL1W+Um9b7IVQnyJqQHYqQfh5+cjWcBonZ3I5EPO+pah15ernwjriK8awErGmv
	KJvzjuJ3xav5VaiOA4B7fs0tE0r+s1DQY6Ixqrix5+q+nlqpZ8J3gDOaLtCt1DLVVR1N5w9utnB
	nA3IcD4QcE9QgdrBAgTXVAPaWR5rDlDi2SbOPr3JJXYbfr3LEVF2lu6DA/TG/n3m6+U9n6oOKJM
	v7xRACUZG8FXYpJAOiBS7ZOiubXG7rFV0Q/hmCx+LEuCwBsgIY/CM3IOSQVyppDvL2nZHVZKtAy
	tDThJ5+agNm0PY864yVYU9A
X-Received: by 2002:a05:620a:471f:b0:93e:62a3:f845 with SMTP id af79cd13be357-93ebd0a24f7mr1687923985a.8.1791836254568;
        Mon, 12 Oct 2026 13:17:34 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5086fe3sm69139485a.37.2026.10.12.13.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 13:17:34 -0700 (PDT)
From: Dingisoul <dingiso.kernel@gmail.com>
To: dingiso.kernel@gmail.com
Cc: James.Bottomley@HansenPartnership.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	mkp@kernel.org,
	loberman@redhat.com
Subject: Re: [BUG] scsi: st: use-after-free race between st_remove() and st_open()/scsi_tape_get()
Date: Mon, 12 Oct 2026 16:17:30 -0400
Message-Id: <20261012201730.1853897-1-dingiso.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261007211520.1428497-1-dingiso.kernel@gmail.com>
References: <20261007211520.1428497-1-dingiso.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Laurence,

Adding you to Cc as requested. Quoting the original report below for
reference; let me know if you'd like anything else re-tested.

Best,
Dingisoul

> Hi Kernel Maintainers,
>
> I hit the following report while testing current upstream kernel:
>
> KASAN: slab-use-after-free in st_open
>
> on commit: a90ee4305c4a (2026-10-06)
>
> Root cause: st_remove() drops the device's last reference, and only
> afterwards removes it from st_index_idr:
>
>     static void st_remove(struct scsi_device *SDp)
>     {
>         struct device *dev = &SDp->sdev_gendev;
>         struct scsi_tape *tpnt = dev_get_drvdata(dev);
>         int index = tpnt->index;
>         ...
>         mutex_lock(&st_ref_mutex);
>         kref_put(&tpnt->kref, scsi_tape_release);  /* may kfree(tpnt) right here */
>         mutex_unlock(&st_ref_mutex);
>         spin_lock(&st_index_lock);
>         idr_remove(&st_index_idr, index);          /* too late: tpnt may already be freed */
>         spin_unlock(&st_index_lock);
>     }
>
> Meanwhile scsi_tape_get() -- called from st_open() on every open of a
> tape device node -- looks the device up by the same index and takes its
> own reference:
>
>     static struct scsi_tape *scsi_tape_get(int dev)
>     {
>         struct scsi_tape *STp = NULL;
>
>         mutex_lock(&st_ref_mutex);
>         spin_lock(&st_index_lock);
>
>         STp = idr_find(&st_index_idr, dev);  /* can still find the freed tpnt */
>         if (!STp) goto out;
>
>         kref_get(&STp->kref);                /* UAF write */
>         ...
>     }
>
>     static int st_open(struct inode *inode, struct file *filp)
>     {
>         ...
>         if (!(STp = scsi_tape_get(dev))) {
>         ...
>
> Between st_remove()'s mutex_unlock(&st_ref_mutex) and its own
> spin_lock(&st_index_lock), tpnt is already freed but still reachable
> through st_index_idr. A concurrent st_open() racing in that window takes
> both locks in scsi_tape_get(), finds the stale idr entry, and calls
> kref_get() on the freed tpnt.
>
> We used scsi_debug (ptype=1, emulating a tape LUN) to avoid needing real
> tape hardware.
>
> The reproducer and .config files are here.
> https://gist.github.com/dingiso/b33f8c01a47bfcbb902d3f21a4877feb
>
> I'm happy to test debug patches or provide additional information.
>
> [   23.212502] ==================================================================
> [   23.212506] BUG: KASAN: slab-use-after-free in st_open (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:252 ./include/linux/refcount.h:283 ./include/linux/refcount.h:366 ./include/linux/refcount.h:383 ./include/linux/kref.h:45 drivers/scsi/st.c:254 drivers/scsi/st.c:1291)
> [   23.212537] Write of size 4 at addr ffff888009854a1c by task repro/315
> [   23.212541] 
> [   23.212551] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   23.212554] Call Trace:
> [   23.212556]  <TASK>
> [   23.212558]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
> [   23.212566]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
> [   23.212591]  kasan_report (mm/kasan/report.c:595)
> [   23.212602]  kasan_check_range (mm/kasan/generic.c:186 mm/kasan/generic.c:200)
> [   23.212607]  st_open (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:252 ./include/linux/refcount.h:283 ./include/linux/refcount.h:366 ./include/linux/refcount.h:383 ./include/linux/kref.h:45 drivers/scsi/st.c:254 drivers/scsi/st.c:1291)
> [   23.212623]  chrdev_open (fs/char_dev.c:411)
> [   23.212645]  do_dentry_open (fs/open.c:996)
> [   23.212651]  vfs_open (fs/open.c:1101)
> [   23.212656]  path_openat (fs/namei.c:4837 fs/namei.c:5000)
> [   23.212669]  do_file_open (fs/namei.c:5029)
> [   23.212693]  do_sys_openat2 (fs/open.c:1417 (discriminator 1))
> [   23.212702]  __x64_sys_openat (fs/open.c:1423 fs/open.c:1439 fs/open.c:1434 fs/open.c:1434)
> [   23.212712]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
> [   23.212719]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
> [   23.212755] 
> [   23.212756] Allocated by task 325:
> [   23.212758]  kasan_save_stack (mm/kasan/common.c:57)
> [   23.212764]  kasan_save_track (mm/kasan/common.c:78)
> [   23.212768]  __kasan_kmalloc (mm/kasan/common.c:409 mm/kasan/common.c:426)
> [   23.212773]  __kmalloc_cache_noprof (./include/linux/kasan.h:263 mm/slub.c:5563)
> [   23.212778]  st_probe (./include/linux/slab.h:991 ./include/linux/slab.h:1312 drivers/scsi/st.c:4376)
> [   23.212783]  really_probe (drivers/base/dd.c:628 drivers/base/dd.c:706)
> [   23.212788]  __driver_probe_device (drivers/base/dd.c:868)
> [   23.212793]  driver_probe_device (drivers/base/dd.c:898)
> [   23.212798]  __device_attach_driver (drivers/base/dd.c:1026)
> [   23.212803]  bus_for_each_drv (drivers/base/bus.c:500)
> [   23.212807]  __device_attach (drivers/base/dd.c:1098)
> [   23.212811]  device_initial_probe (drivers/base/dd.c:1153)
> [   23.212816]  bus_probe_device (drivers/base/bus.c:620)
> [   23.212821]  device_add (drivers/base/core.c:3776)
> [   23.212826]  scsi_sysfs_add_sdev (drivers/scsi/scsi_sysfs.c:1427)
> [   23.212830]  scsi_add_lun (drivers/scsi/scsi_scan.c:1138 (discriminator 1))
> [   23.212834]  scsi_probe_and_add_lun (drivers/scsi/scsi_scan.c:1311)
> [   23.212838]  __scsi_scan_target (drivers/scsi/scsi_scan.c:1805)
> [   23.212841]  scsi_scan_channel (drivers/scsi/scsi_scan.c:1895 drivers/scsi/scsi_scan.c:1870)
> [   23.212845]  scsi_scan_host_selected (drivers/scsi/scsi_scan.c:1924)
> [   23.212849]  scsi_scan_host (drivers/scsi/scsi_scan.c:2089 drivers/scsi/scsi_scan.c:2077)
> [   23.212852] sdebug_driver_probe (drivers/scsi/scsi_debug.c:9618) scsi_debug
> [   23.212875]  really_probe (drivers/base/dd.c:628 drivers/base/dd.c:706)
> [   23.212879]  __driver_probe_device (drivers/base/dd.c:868)
> [   23.212883]  driver_probe_device (drivers/base/dd.c:898)
> [   23.212887]  __device_attach_driver (drivers/base/dd.c:1026)
> [   23.212891]  bus_for_each_drv (drivers/base/bus.c:500)
> [   23.212895]  __device_attach (drivers/base/dd.c:1098)
> [   23.212900]  device_initial_probe (drivers/base/dd.c:1153)
> [   23.212905]  bus_probe_device (drivers/base/bus.c:620)
> [   23.212909]  device_add (drivers/base/core.c:3776)
> [   23.212914] sdebug_add_host_helper (drivers/scsi/scsi_debug.c:8843) scsi_debug
> [   23.212937] add_host_store (drivers/scsi/scsi_debug.c:8878 drivers/scsi/scsi_debug.c:8105) scsi_debug
> [   23.212954]  kernfs_fop_write_iter (fs/kernfs/file.c:345)
> [   23.212960]  vfs_write (fs/read_write.c:595 fs/read_write.c:687)
> [   23.212964]  ksys_write (fs/read_write.c:739)
> [   23.212968]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
> [   23.212973]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
> [   23.212977] 
> [   23.212978] Freed by task 325:
> [   23.212980]  kasan_save_stack (mm/kasan/common.c:57)
> [   23.212984]  kasan_save_track (mm/kasan/common.c:78)
> [   23.212989]  kasan_save_free_info (mm/kasan/generic.c:584)
> [   23.212993]  __kasan_slab_free (mm/kasan/common.c:264 mm/kasan/common.c:296)
> [   23.212997]  kfree (./include/linux/kasan.h:235 mm/slub.c:2748 mm/slub.c:6509 mm/slub.c:6802)
> [   23.213000]  st_remove (./include/linux/kref.h:65 drivers/scsi/st.c:4512)
> [   23.213004]  device_release_driver_internal (drivers/base/dd.c:1349 drivers/base/dd.c:1372)
> [   23.213009]  bus_remove_device (drivers/base/bus.c:664)
> [   23.213014]  device_del (drivers/base/core.c:3965)
> [   23.213018]  __scsi_remove_device (drivers/scsi/scsi_sysfs.c:1499)
> [   23.213021]  scsi_forget_host (drivers/scsi/scsi_scan.c:2115)
> [   23.213025]  scsi_remove_host (drivers/scsi/hosts.c:182)
> [   23.213031] sdebug_driver_remove (drivers/scsi/scsi_debug.c:9631) scsi_debug
> [   23.213052]  device_release_driver_internal (drivers/base/dd.c:1349 drivers/base/dd.c:1372)
> [   23.213057]  bus_remove_device (drivers/base/bus.c:664)
> [   23.213061]  device_del (drivers/base/core.c:3965)
> [   23.213065]  device_unregister (drivers/base/core.c:4006)
> [   23.213070] sdebug_do_remove_host (drivers/scsi/scsi_debug.c:8917) scsi_debug
> [   23.213089] add_host_store (drivers/scsi/scsi_debug.c:8110) scsi_debug
> [   23.213109]  kernfs_fop_write_iter (fs/kernfs/file.c:345)
> [   23.213113]  vfs_write (fs/read_write.c:595 fs/read_write.c:687)
> [   23.213117]  ksys_write (fs/read_write.c:739)
> [   23.213121]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
> [   23.213126]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
> Best,
> Dingisoul
