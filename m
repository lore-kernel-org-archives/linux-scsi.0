Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE4D9C4CEC5
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7F3D2084F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="G7QQ7PKb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388230AbfIMNF0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:26 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38513 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfIMNF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:26 -0400
Received: by mail-pl1-f193.google.com with SMTP id w10so2119680plq.5
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6bJJhskxZy1dIvhDoO5hXBSBZjyiy4EkGZwUvULphPk=;
        b=G7QQ7PKbH945uzjLINmpcNNrdPRzPpgIZMsO9LJmRgQT/HcguUynEbh/OZAuSTVceT
         XlaE6ZHbpIkLomtMbD1Sk7K4zFRhRsEZQeSz/cPcb+lw4vx75SLSz7KjN3QwmszvjZRI
         OLb7iAju3Vlez2wS92Ti/1lsVatbG58YlwI6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6bJJhskxZy1dIvhDoO5hXBSBZjyiy4EkGZwUvULphPk=;
        b=dOOgvag51zgucwTF0ZMVwYcfTJZe1ZYnhuE9oIhm0PLcU/I0stHoYBGYsvDoFIudT4
         BjtYRCICpVUKidHK7OVJclg6hgLA69TOdR4E23S55RTuJ77jqFwNGMJaq/Ex8xDUgUDt
         4ZKk8cZ1GidSBUoLPR2oyHwfh+8OOZqmHJVoypiceWq8AgiYI5zt4UOkkH9cZMBc73uH
         95C95hOAz81SgsaI8hwhkKktm0HG8N7eKYDS+RdYYJV4lKKvM5jogckxC/IhiJMDolCS
         z3dZlB736qH8tN2lecYWtm3RM8nO+MaUBQPOuH7emENgt1dskdGfpyv91yvibGSkJJwK
         T8uw==
X-Gm-Message-State: APjAAAWNwCUDtKWxt4F7VpR7e2U+7pUP5v4y4WuLBYIjpwzVmALXTEFV
        GQ4xpsnkLEAN47zWB+QHOsxVGw==
X-Google-Smtp-Source: APXvYqxnNRvXqkuyxzHgYWEtiMMZUxBjc8TsBkCEFBLlRxxV6Q82ClsNTuUyVCQI+jBui1G+3YiLHg==
X-Received: by 2002:a17:902:bd97:: with SMTP id q23mr2826003pls.259.1568379925329;
        Fri, 13 Sep 2019 06:05:25 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:24 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 11/13] mpt3sas: Reject NVMe Encap cmnds to unsupported HBA
Date:   Fri, 13 Sep 2019 09:04:48 -0400
Message-Id: <1568379890-18347-12-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If any faulty application issues an NVMe Encapsulated commands to HBA
which doesn't support NVMe protocol then driver should return the
command as invalid with below message.

"HBA doesn't supports NVMe. Hence rejecting NVMe Encapsulated request."

Otherwise below page fault kernel panic will be observed while building
the PRPs as their is no PRP pools allocated for the HBA which doesn't
support NVMe drives.

RIP: 0010:_base_build_nvme_prp+0x3b/0xf0 [mpt3sas]
Call Trace:
 _ctl_do_mpt_command+0x931/0x1120 [mpt3sas]
 _ctl_ioctl_main.isra.11+0xa28/0x11e0 [mpt3sas]
 ? prepare_to_wait+0xb0/0xb0
 ? tty_ldisc_deref+0x16/0x20
 _ctl_ioctl+0x1a/0x20 [mpt3sas]
 do_vfs_ioctl+0xaa/0x620
 ? vfs_read+0x117/0x140
 ksys_ioctl+0x67/0x90
 __x64_sys_ioctl+0x1a/0x20
 do_syscall_64+0x60/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 9267ffe..3b72a24 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -785,6 +785,18 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	case MPI2_FUNCTION_NVME_ENCAPSULATED:
 	{
 		nvme_encap_request = (Mpi26NVMeEncapsulatedRequest_t *)request;
+		if (!ioc->pcie_sg_lookup) {
+			dtmprintk(ioc, ioc_info(ioc,
+			    "HBA doesn't supports NVMe. Hence rejecting NVMe Encapsulated request.\n"
+			    ));
+
+			if (ioc->logging_level & MPT_DEBUG_TM)
+				_debug_dump_mf(nvme_encap_request,
+				    ioc->request_sz/4);
+			mpt3sas_base_free_smid(ioc, smid);
+			ret = -EINVAL;
+			goto out;
+		}
 		/*
 		 * Get the Physical Address of the sense buffer.
 		 * Use Error Response buffer address field to hold the sense
-- 
1.8.3.1

