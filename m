Received: from mail-dl1-f98.google.com (mail-dl1-f98.google.com [74.125.82.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3263833D4F0
	for <linux-scsi@vger.kernel.org>; Thu,  8 Jan 2026 06:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767854622; cv=none; b=qfrZ1LpyUlXkozGmtRiiVJW6ruiIx0v1kKGuC3gD6bhDnLC8OBqLqqKFhdOZ7aEPsmQKxDoGZHvCGRGhEOxd+TZcByC7KIgUlru4fgnrJyTleXPsOFvYSliq7QNkW/wlK5pSEijUlx3cgAtbHM6M3B984jH2aqUMrlKAT6KAHi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767854622; c=relaxed/simple;
	bh=ImYWes9RzLW7jZYyugbTJJDcav+gH48j/2LL5/t6sdg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=czz9DYLonORoLh6gZN5dEyEFzezM+Q7T271O5nqL3od8M7tx3tWufhOHSzGm2nvnXA0iSStvZlNoR1vq6ytESur7PvRTuDUWzTPudhuwarIj41LAO0/ZReufG3YTB3g1KBHk6UaEkldaoaLpgrgPXzkfK/as8O5YM6KpkcH2FEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=R/Gwguf3; arc=none smtp.client-ip=74.125.82.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="R/Gwguf3"
Received: by mail-dl1-f98.google.com with SMTP id a92af1059eb24-11f3e3f0cacso2958791c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 22:43:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767854614; x=1768459414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T39mSU9rO41dWx7zi2EzUyLIRccI3ncgf9JgMb14jLo=;
        b=FvfH3KchZCFfT7U/lMC07cE1TIENFws/cLke8YbArJMtsQ8AIPBBA6T8+vhdzRzH4c
         l/VFUc9KuoimCnhJ9naf7iIXMERV7YzAMhLXH/Cr8DvcdD+LzinfrKALIbq+Vnf5yPkF
         25cKSmCj1el8L7h3SKu+T/qgVRNyUyFpWEpEmG6g1Nu23BZXET++qLraYczmtdbvXUeK
         L7R9k4+hxQHbzZQTEtIO1dCX/Dzg/yJkmQMvJY5ZApgbDNmDz0xcd623ZgXmYfhvCzMU
         NjFVEpJFvuHW1wH3KBfMgfKElSvEIRoRqBVcH5KUGILkiFf3myO2jgjFFt6ECSrvnH1N
         Q+Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXsNABWMJCWqG9xWjeR2yqv5s0WGp+tEDwH5Ux9vlv0g7ImD7XyrNKnrHymHN0KrZ8KfRZ8QtGr54OK@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzr6EfAnw6vfDaGGxhSe7J0XnHqHojHmTDXXsBtXkRVVaAmeE6
	6T3fgR+Evzu4m8vICLTHpq/wlFFJCrpfoUDd8ICHp5hblKYuEtndy14GSEmN3Bs4svqI8fXrwuE
	PLbu7yU9TQPtz5RDQQpAvuw/qBXu/QhEAtVBiZKkr2udW6KryLCuUUTLGjF8t3syNUY3WnSFFAY
	ofVF58kHjUFOKsaNqNK4TWGQZzSEZX8TN6yYr8gP1tiTfLLQmk6+u0SkNGXkF3CMKTv6g3Qw5w7
	YNGRHyDNd2V18N9102K2eE=
X-Gm-Gg: AY/fxX4CLg1r1Al0iTPqJ98uW0x7OWJKuflrLineOkI/HALx67+k89QnNzf11y3pcJs
	XsjNxE5ivcrZTbdpa/tRgI+Xqnc/Y+uPvr48RwVBbSA47wPWm2LFbtFMzGcZkiFXmJfqnPoZKrL
	6UWqBvC94FMJkBp6UjdYzDQx9AhSF8fMD+FLWlBRpKYSoC6BFCGuVwKcgr0BuJAn+5p+NzSblhX
	UFLtq9ANJxqdfnQYTpzY0OsXN0VEcL5Zo2agExPWCou5NFqpaHOsRk8sVZxHd5mJOvEiAjxOmHQ
	P3PJcTmGVO7lJ4f/DDSRgqr8M2YZ2C0di05QmygJfNKqJrlMxHP71w89rb18Zwk+NVXhYXimrLk
	AxWyWVndG3MCEQSKJx9ic9MxN2whUTgmN6kg5BiYoT+RLpQ9CbgGTUMZS2H4BeRy0Ok/QxkhqpT
	C4d99kZyz/ptmuj2JR2g6zbXkabGjMJUJSI6Bnt1LiVeYbptQsI1U=
X-Google-Smtp-Source: AGHT+IGGVekeIzysBK98CQD9grdlPCT5i5N/4TjwLo76cIdxTHGWPgEPVslQoGpiqf8cX5M9tbr82vz8rOwr
X-Received: by 2002:a05:7022:791:b0:119:e56b:91ea with SMTP id a92af1059eb24-121f8b45fa0mr3681575c88.27.1767854614387;
        Wed, 07 Jan 2026 22:43:34 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-121f24a56d3sm1553329c88.8.2026.01.07.22.43.34
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jan 2026 22:43:34 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-12175e560b3so3283340c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 22:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1767854612; x=1768459412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T39mSU9rO41dWx7zi2EzUyLIRccI3ncgf9JgMb14jLo=;
        b=R/Gwguf3QFtBmiVDFYybZM867/XylF6Bo4K8UGiS+8fYeyOvZQMz6qIcdD0J00JX4F
         i5l4gOZGX7Af3kRB1SPAuqGGlKAvXgk0+hZFnlWUCfBaaZ5Q/D5ZD1aCTjfBoNfo+0PB
         0NGB4IZrSH6j3Z5y3z2xqiWM7kWAVWuLVK500=
X-Forwarded-Encrypted: i=1; AJvYcCV+w+HDWZ3bT1TaUF/8CemVm8y3+P7YpeLRNClHzcauHUATnJykNq4w+x5pltpOmHJhIAibt89YPjIK@vger.kernel.org
X-Received: by 2002:a05:7022:225:b0:11b:94ab:be03 with SMTP id a92af1059eb24-121f8adec5cmr3971840c88.20.1767854612285;
        Wed, 07 Jan 2026 22:43:32 -0800 (PST)
X-Received: by 2002:a05:7022:225:b0:11b:94ab:be03 with SMTP id a92af1059eb24-121f8adec5cmr3971824c88.20.1767854611685;
        Wed, 07 Jan 2026 22:43:31 -0800 (PST)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f243421esm13193731c88.2.2026.01.07.22.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 22:43:31 -0800 (PST)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Ding Hui <dinghui@sangfor.com.cn>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 2/2 v5.10] scsi: iscsi_tcp: Fix UAF during logout when accessing the shost ipaddress
Date: Wed,  7 Jan 2026 22:22:22 -0800
Message-Id: <20260108062222.670715-3-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260108062222.670715-1-shivani.agarwal@broadcom.com>
References: <20260108062222.670715-1-shivani.agarwal@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 6f1d64b13097e85abda0f91b5638000afc5f9a06 ]

Bug report and analysis from Ding Hui.

During iSCSI session logout, if another task accesses the shost ipaddress
attr, we can get a KASAN UAF report like this:

[  276.942144] BUG: KASAN: use-after-free in _raw_spin_lock_bh+0x78/0xe0
[  276.942535] Write of size 4 at addr ffff8881053b45b8 by task cat/4088
[  276.943511] CPU: 2 PID: 4088 Comm: cat Tainted: G            E      6.1.0-rc8+ #3
[  276.943997] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
[  276.944470] Call Trace:
[  276.944943]  <TASK>
[  276.945397]  dump_stack_lvl+0x34/0x48
[  276.945887]  print_address_description.constprop.0+0x86/0x1e7
[  276.946421]  print_report+0x36/0x4f
[  276.947358]  kasan_report+0xad/0x130
[  276.948234]  kasan_check_range+0x35/0x1c0
[  276.948674]  _raw_spin_lock_bh+0x78/0xe0
[  276.949989]  iscsi_sw_tcp_host_get_param+0xad/0x2e0 [iscsi_tcp]
[  276.951765]  show_host_param_ISCSI_HOST_PARAM_IPADDRESS+0xe9/0x130 [scsi_transport_iscsi]
[  276.952185]  dev_attr_show+0x3f/0x80
[  276.953005]  sysfs_kf_seq_show+0x1fb/0x3e0
[  276.953401]  seq_read_iter+0x402/0x1020
[  276.954260]  vfs_read+0x532/0x7b0
[  276.955113]  ksys_read+0xed/0x1c0
[  276.955952]  do_syscall_64+0x38/0x90
[  276.956347]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  276.956769] RIP: 0033:0x7f5d3a679222
[  276.957161] Code: c0 e9 b2 fe ff ff 50 48 8d 3d 32 c0 0b 00 e8 a5 fe 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
[  276.958009] RSP: 002b:00007ffc864d16a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  276.958431] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f5d3a679222
[  276.958857] RDX: 0000000000020000 RSI: 00007f5d3a4fe000 RDI: 0000000000000003
[  276.959281] RBP: 00007f5d3a4fe000 R08: 00000000ffffffff R09: 0000000000000000
[  276.959682] R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000020000
[  276.960126] R13: 0000000000000003 R14: 0000000000000000 R15: 0000557a26dada58
[  276.960536]  </TASK>
[  276.961357] Allocated by task 2209:
[  276.961756]  kasan_save_stack+0x1e/0x40
[  276.962170]  kasan_set_track+0x21/0x30
[  276.962557]  __kasan_kmalloc+0x7e/0x90
[  276.962923]  __kmalloc+0x5b/0x140
[  276.963308]  iscsi_alloc_session+0x28/0x840 [scsi_transport_iscsi]
[  276.963712]  iscsi_session_setup+0xda/0xba0 [libiscsi]
[  276.964078]  iscsi_sw_tcp_session_create+0x1fd/0x330 [iscsi_tcp]
[  276.964431]  iscsi_if_create_session.isra.0+0x50/0x260 [scsi_transport_iscsi]
[  276.964793]  iscsi_if_recv_msg+0xc5a/0x2660 [scsi_transport_iscsi]
[  276.965153]  iscsi_if_rx+0x198/0x4b0 [scsi_transport_iscsi]
[  276.965546]  netlink_unicast+0x4d5/0x7b0
[  276.965905]  netlink_sendmsg+0x78d/0xc30
[  276.966236]  sock_sendmsg+0xe5/0x120
[  276.966576]  ____sys_sendmsg+0x5fe/0x860
[  276.966923]  ___sys_sendmsg+0xe0/0x170
[  276.967300]  __sys_sendmsg+0xc8/0x170
[  276.967666]  do_syscall_64+0x38/0x90
[  276.968028]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  276.968773] Freed by task 2209:
[  276.969111]  kasan_save_stack+0x1e/0x40
[  276.969449]  kasan_set_track+0x21/0x30
[  276.969789]  kasan_save_free_info+0x2a/0x50
[  276.970146]  __kasan_slab_free+0x106/0x190
[  276.970470]  __kmem_cache_free+0x133/0x270
[  276.970816]  device_release+0x98/0x210
[  276.971145]  kobject_cleanup+0x101/0x360
[  276.971462]  iscsi_session_teardown+0x3fb/0x530 [libiscsi]
[  276.971775]  iscsi_sw_tcp_session_destroy+0xd8/0x130 [iscsi_tcp]
[  276.972143]  iscsi_if_recv_msg+0x1bf1/0x2660 [scsi_transport_iscsi]
[  276.972485]  iscsi_if_rx+0x198/0x4b0 [scsi_transport_iscsi]
[  276.972808]  netlink_unicast+0x4d5/0x7b0
[  276.973201]  netlink_sendmsg+0x78d/0xc30
[  276.973544]  sock_sendmsg+0xe5/0x120
[  276.973864]  ____sys_sendmsg+0x5fe/0x860
[  276.974248]  ___sys_sendmsg+0xe0/0x170
[  276.974583]  __sys_sendmsg+0xc8/0x170
[  276.974891]  do_syscall_64+0x38/0x90
[  276.975216]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

We can easily reproduce by two tasks:
1. while :; do iscsiadm -m node --login; iscsiadm -m node --logout; done
2. while :; do cat \
/sys/devices/platform/host*/iscsi_host/host*/ipaddress; done

            iscsid              |        cat
--------------------------------+---------------------------------------
|- iscsi_sw_tcp_session_destroy |
  |- iscsi_session_teardown     |
    |- device_release           |
      |- iscsi_session_release  ||- dev_attr_show
        |- kfree                |  |- show_host_param_
                                |             ISCSI_HOST_PARAM_IPADDRESS
                                |    |- iscsi_sw_tcp_host_get_param
                                |      |- r/w tcp_sw_host->session (UAF)
  |- iscsi_host_remove          |
  |- iscsi_host_free            |

Fix the above bug by splitting the session removal into 2 parts:

 1. removal from iSCSI class which includes sysfs and removal from host
    tracking.

 2. freeing of session.

During iscsi_tcp host and session removal we can remove the session from
sysfs then remove the host from sysfs. At this point we know userspace is
not accessing the kernel via sysfs so we can free the session and host.

Link: https://lore.kernel.org/r/20230117193937.21244-2-michael.christie@oracle.com
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Acked-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Shivani: The false parameter was not passed to iscsi_host_remove() because,
          in Linux 5.10.y, the default behavior of iscsi_host_remove() already
          assumes false.]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 drivers/scsi/iscsi_tcp.c | 11 +++++++++--
 drivers/scsi/libiscsi.c  | 38 +++++++++++++++++++++++++++++++-------
 include/scsi/libiscsi.h  |  2 ++
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index def9fac7aa4f..2a83bd5d834d 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -933,10 +933,17 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	if (WARN_ON_ONCE(session->leadconn))
 		return;
 
+	iscsi_session_remove(cls_session);
+	/*
+	 * Our get_host_param needs to access the session, so remove the
+	 * host from sysfs before freeing the session to make sure userspace
+	 * is no longer accessing the callout.
+	 */
+	iscsi_host_remove(shost);
+
 	iscsi_tcp_r2tpool_free(cls_session->dd_data);
-	iscsi_session_teardown(cls_session);
 
-	iscsi_host_remove(shost);
+	iscsi_session_free(cls_session);
 	iscsi_host_free(shost);
 }
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 59da5cc280a4..7e82ddce5031 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2892,17 +2892,32 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_setup);
 
-/**
- * iscsi_session_teardown - destroy session, host, and cls_session
- * @cls_session: iscsi session
+/*
+ * issi_session_remove - Remove session from iSCSI class.
  */
-void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
+void iscsi_session_remove(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = cls_session->dd_data;
-	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
 
 	iscsi_remove_session(cls_session);
+	/*
+	 * host removal only has to wait for its children to be removed from
+	 * sysfs, and iscsi_tcp needs to do iscsi_host_remove before freeing
+	 * the session, so drop the session count here.
+	 */
+	iscsi_host_dec_session_cnt(shost);
+}
+EXPORT_SYMBOL_GPL(iscsi_session_remove);
+
+/**
+ * iscsi_session_free - Free iscsi session and it's resources
+ * @cls_session: iscsi session
+ */
+void iscsi_session_free(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *session = cls_session->dd_data;
+	struct module *owner = cls_session->transport->owner;
 
 	iscsi_pool_free(&session->cmdpool);
 	kfree(session->password);
@@ -2920,10 +2935,19 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->discovery_parent_type);
 
 	iscsi_free_session(cls_session);
-
-	iscsi_host_dec_session_cnt(shost);
 	module_put(owner);
 }
+EXPORT_SYMBOL_GPL(iscsi_session_free);
+
+/**
+ * iscsi_session_teardown - destroy session and cls_session
+ * @cls_session: iscsi session
+ */
+void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
+{
+	iscsi_session_remove(cls_session);
+	iscsi_session_free(cls_session);
+}
 EXPORT_SYMBOL_GPL(iscsi_session_teardown);
 
 /**
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index fa00e2543ad6..dd9b2bc1aea7 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -401,6 +401,8 @@ extern int iscsi_target_alloc(struct scsi_target *starget);
 extern struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *, struct Scsi_Host *shost,
 		    uint16_t, int, int, uint32_t, unsigned int);
+void iscsi_session_remove(struct iscsi_cls_session *cls_session);
+void iscsi_session_free(struct iscsi_cls_session *cls_session);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
 extern int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
-- 
2.43.7

