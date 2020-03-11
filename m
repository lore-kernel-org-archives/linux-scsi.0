Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E62CC18E5A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 10:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6416E21D7E
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 10:37:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dsY+/MsB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgCKKhJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 06:37:09 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39973 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgCKKhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 06:37:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id t24so964041pgj.7
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2020 03:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zDAtGZZlnMl0nThiIiOP76Uq+16Zqz24GZvrNhqC2vY=;
        b=dsY+/MsBt2iIGklM4BYJHdvvl/3P5lxTQo7dEML4wIcJ5OwCA/ZT/ilZbXJBuojPHD
         que491N0rlKv/g1op+AaBWzoLHZwxeMmc/8lP+zaX7reNzfjUbzUlOES96zAsgqLN4Wu
         TbwTXyp5hpVER9ECiK0S512Vf6YDib45g7sGI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zDAtGZZlnMl0nThiIiOP76Uq+16Zqz24GZvrNhqC2vY=;
        b=biPfq1gUbyKgxxk/T92LmAKh6KOSsE4c00XR2U3GeLKBl4aYaJY7lv+Yh4wV1u1Xvu
         VTd4Z7wDuutTz6cVCRa+w670uSrR2BAYwzij9IT4KzwqYDfbpSqHCG8kncIMj2hbdclx
         jpDDsDMRw5DI6pxqjoYggM7hP9J/vlTStlEl3LalWA1rIdrJ69KqBQGoMDuaigrbU/xk
         x9txbqpCgcfhtHe6FzKtvv0+n2Po4V7D7dLJ/t/uI0pbtM8FlKO1rOi3J4f81LEs1QA0
         QJRAmgLmeTw25LNdVr+7WC+C+zsNNj/80ATG8OrWxZDIHrX6UnWI8jYHjltg6Rusf8S3
         6lSA==
X-Gm-Message-State: ANhLgQ0GrYKblvwb2NYEeqy5Y9UbgD7zQ4nOEBDFRPPJ3avvrOf0y5/o
        dLUA14/txOmhBAGakF70rzG86Q==
X-Google-Smtp-Source: ADFU+vvNPQ1qsX7n2U3cijoD2VYGzq2zDqlEBEbY82LByWfqG8NCc62qAiwBkAu6hBRj9M5TBs6FBg==
X-Received: by 2002:a63:82c2:: with SMTP id w185mr2331272pgd.382.1583923028194;
        Wed, 11 Mar 2020 03:37:08 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z3sm51156004pfz.155.2020.03.11.03.37.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Mar 2020 03:37:07 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com, stable@vger.kernel.org,
        amit@kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
Date:   Wed, 11 Mar 2020 06:36:53 -0400
Message-Id: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Generic protection fault type kernel panic is observed when user
performs soft(ordered) HBA unplug operation while IOs are running
on drives connected to HBA.

When user performs ordered HBA removal operation then kernel calls
PCI device's .remove() call back function where driver is flushing out
all the outstanding SCSI IO commands with DID_NO_CONNECT host byte and
also un-maps sg buffers allocated for these IO commands.
But in the ordered HBA removal case (unlike of real HBA hot unplug)
HBA device is still alive and hence HBA hardware is performing the
DMA operations to those buffers on the system memory which are already
unmapped while flushing out the outstanding SCSI IO commands
and this leads to Kernel panic.

Fix:
Don't flush out the outstanding IOs from .remove() path in case of
ordered HBA removal since HBA will be still alive in this case and
it can complete the outstanding IOs. Flush out the outstanding IOs
only in case physical HBA hot unplug where their won't be any
communication with the HBA.

Cc: stable@vger.kernel.org
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 778d5e6..04a40af 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -9908,8 +9908,8 @@ static void scsih_remove(struct pci_dev *pdev)
 
 	ioc->remove_host = 1;
 
-	mpt3sas_wait_for_commands_to_complete(ioc);
-	_scsih_flush_running_cmds(ioc);
+	if (!pci_device_is_present(pdev))
+		_scsih_flush_running_cmds(ioc);
 
 	_scsih_fw_event_cleanup_queue(ioc);
 
@@ -9992,8 +9992,8 @@ static void scsih_remove(struct pci_dev *pdev)
 
 	ioc->remove_host = 1;
 
-	mpt3sas_wait_for_commands_to_complete(ioc);
-	_scsih_flush_running_cmds(ioc);
+	if (!pci_device_is_present(pdev))
+		_scsih_flush_running_cmds(ioc);
 
 	_scsih_fw_event_cleanup_queue(ioc);
 
-- 
1.8.3.1

