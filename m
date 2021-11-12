Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28349C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 12:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BBF460F70
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 12:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhKLMJt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Nov 2021 07:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbhKLMJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Nov 2021 07:09:43 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B602BC061203;
        Fri, 12 Nov 2021 04:06:52 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id c4so8345834pfj.2;
        Fri, 12 Nov 2021 04:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MIyRtrqfmfv9Q70WA5OuleW3S97RwfmhJIbO/13nPI0=;
        b=eUrb7nENr9K/JwpH4dsIeY4/ml8fLrNKUXppJa64u3i+7roPNJxy6uMNnHS2YadqUZ
         yCPkY8CybmqjnJT6khQDAItloHqXM9bZZUIkOdyMYTXVK5m/36NwK9b+FLviishKTAIO
         YYkRqV+0h3lAmwuQgRtb+P4tkD3JnOCdy4yY9kZx/kG+Q3jVoPT/vSqlN7FP/5HtMBDQ
         bF/KmXFYQpClbh1z0IYOwhDQmY35nM+9i1KzpdMYL/6e4EjeOlfMYXpmeP+fqyejc+lE
         S7Gh16ymepXekxve8I7zwHXpMASvM5Ckjgc2m9yXaEGq8hN9bjmfWRmkFbDtISNIgNml
         s8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MIyRtrqfmfv9Q70WA5OuleW3S97RwfmhJIbO/13nPI0=;
        b=QmMGqb8A9SKjJWwdxDPtH0oiTJpnWh1JdLs+jtnO8hSXAmAGAkAbKy2nwiSiFBO517
         PJQjSMYHVeA0xWcth6ipXJPT/bb6o4LJJwgHwZTki3ko0g0o7ZqsV19UMyI8vkK5VGrL
         x8CigZ10grSNVZo5gL1V+bHbwa6v2aIjz8Wg3H4wCp+8ISa6RWVRJzr1djxrxYtHUtt5
         YQT5ESMO72a61Is3DaAP1FC0yiAZXSpqM0/sUveyXrMkpVnltj6A/NZdHIOEt0ZamcyJ
         iMAqJNHxeIec1eJlfEY8+ikZlZTeRXQS18C91gOGvmcZ23yVFTRShvBKsmt99/KhUmIj
         ha8g==
X-Gm-Message-State: AOAM532c9C+Yq+/oAhUWE7e6EX8cKe/TS7K7lhKIkdl77iAfm8QwYIGN
        ErrjYPRuhfUJkXfMwLPlBkdl+4L2prr3JDqfQcbSWQ==
X-Google-Smtp-Source: ABdhPJx8ypXWbxfOJRQS60YeMql/1h8CczQ/+31wcaOfd4KGWHLiyyGTBRhCBrI4M6Pm9qh361QThQ==
X-Received: by 2002:a63:5c13:: with SMTP id q19mr9459006pgb.350.1636718812226;
        Fri, 12 Nov 2021 04:06:52 -0800 (PST)
Received: from fanta-arch.localdomain ([148.163.172.142])
        by smtp.gmail.com with ESMTPSA id f15sm7058837pfe.171.2021.11.12.04.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 04:06:51 -0800 (PST)
From:   Letu Ren <fantasquex@gmail.com>
To:     skashyap@marvell.com, jhasan@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Letu Ren <fantasquex@gmail.com>,
        Zheyu Ma <zheyuma97@gmail.com>, Wende Tan <twd2.me@gmail.com>
Subject: [PATCH] scsi: qedf: Fix a UAF bug in __qedf_probe
Date:   Fri, 12 Nov 2021 20:06:41 +0800
Message-Id: <20211112120641.16073-1-fantasquex@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In __qedf_probe, if `qedf->cdev` is NULL which means
qed_ops->common->probe() failed, then the program will goto label err1,
scsi_host_put() will free `lport->host` pointer. Because the memory `qedf`
points to is allocated by libfc_host_alloc(), it will be freed by
scsi_host_put(). However, the if statement below label err0 only checks
whether qedf is NULL but doesn't check whether the memory has been freed.
So a UAF bug occurred.

There are two ways to get to the statements below err0. the first one is
described as before. `qedf` should be set to NULL. The second way is goto
`err0` directly. In this way `qedf` hasn't been changed and it has the
initial value `NULL`. So the program wont't go to the if statement in any
situation.

The KASAN logs are as follows:

[    2.312969] BUG: KASAN: use-after-free in __qedf_probe+0x5dcf/0x6bc0
[    2.312969]
[    2.312969] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[    2.312969] Call Trace:
[    2.312969]  dump_stack_lvl+0x59/0x7b
[    2.312969]  print_address_description+0x7c/0x3b0
[    2.312969]  ? __qedf_probe+0x5dcf/0x6bc0
[    2.312969]  __kasan_report+0x160/0x1c0
[    2.312969]  ? __qedf_probe+0x5dcf/0x6bc0
[    2.312969]  kasan_report+0x4b/0x70
[    2.312969]  ? kobject_put+0x25d/0x290
[    2.312969]  kasan_check_range+0x2ca/0x310
[    2.312969]  __qedf_probe+0x5dcf/0x6bc0
[    2.312969]  ? selinux_kernfs_init_security+0xdc/0x5f0
[    2.312969]  ? trace_rpm_return_int_rcuidle+0x18/0x120
[    2.312969]  ? rpm_resume+0xa5c/0x16e0
[    2.312969]  ? qedf_get_generic_tlv_data+0x160/0x160
[    2.312969]  local_pci_probe+0x13c/0x1f0
[    2.312969]  pci_device_probe+0x37e/0x6c0

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
Co-developed-by: Wende Tan <twd2.me@gmail.com>
Signed-off-by: Wende Tan <twd2.me@gmail.com>
---
 drivers/scsi/qedf/qedf_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 42d0d941dba5..3ea552acd82a 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3683,11 +3683,6 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 err1:
 	scsi_host_put(lport->host);
 err0:
-	if (qedf) {
-		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC, "Probe done.\n");
-
-		clear_bit(QEDF_PROBING, &qedf->flags);
-	}
 	return rc;
 }
 
-- 
2.33.1

