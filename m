Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96C7C2BB1D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 08:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7FE4206F7
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 08:29:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="R8GBg7KQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgCLI3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 04:29:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38986 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgCLI3K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 04:29:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id f7so5205376wml.4
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 01:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=6Gi/OdaICzktDVYOdA4WP8Yxk5qHZ7ClcZn2IAV7MBI=;
        b=R8GBg7KQD97Ni6hoo9Ft95VutYKqPZEHhOOu/KUGDJqTnNbNHVzEDj2xWS9gZtGLNU
         MWQD5HHpVjDK92t7XTeGeYdeAdJt8nmHEPZof4iHhPJyhAx6j6UJ3KSULc2Mpo3XNWGK
         6xgMxS6IWF6NNH/BvM1BdvCrKfTpMfyN3GuWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6Gi/OdaICzktDVYOdA4WP8Yxk5qHZ7ClcZn2IAV7MBI=;
        b=Y8ykDIJP9FJ99/FYSONyOnB5BEYQ2KkMqDmUt7qIQyuQ8VyTsqW956AL6u6v5GZkJx
         gtRTV2KggLtO0SizBI5YbYC0Fg/mGDFnCEeeifCea3jsu6Z4euaTJfkbpohNRQ1w/2MH
         XFe4bQJYwENp0S/Zs39eM/oVtTfNMGTfyNCZ5AKwK9d2i/2qP29Y6Sx92lQ5BdM+MOaz
         IoHWcqMjFYnHSafKhZ4reWZ2REpVPV048WhWbSk8Cqvskm/xgpX5o49Mg3YysubvInIa
         DCv7JpSYTqjLgWsBBYfLZmDPdYR13LQlIicGQNulkYPqj0ou3r98tt93vgJXnTwwTGxv
         /3XQ==
X-Gm-Message-State: ANhLgQ0sMqtlWM2M7ITl4N+0T5/4NU8LdNgGhKB+5uO7c9q33eZ/mhN+
        F0KLhfR03xhotpTc3dKukfl0fA==
X-Google-Smtp-Source: ADFU+vtCHQUivEzeVNBg44c15fYfAGGyq+UGBrf9KvX6uDgska35BTvtGoBYddK6mC5VuykR0oGPkw==
X-Received: by 2002:a7b:cc98:: with SMTP id p24mr3384547wma.29.1584001748507;
        Thu, 12 Mar 2020 01:29:08 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id v15sm7803460wrm.32.2020.03.12.01.29.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 01:29:07 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com, stable@vger.kernel.org,
        amit@kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1] mpt3sas: Fix kernel panic observed on soft HBA unplug
Date:   Thu, 12 Mar 2020 04:28:55 -0400
Message-Id: <1584001735-22719-1-git-send-email-sreekanth.reddy@broadcom.com>
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

This bug got introduced from below commit,
commit c666d3be99c000bb889a33353e9be0fa5808d3de
("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")

Fix:
Don't flush out the outstanding IOs from .remove() path in case of
ordered HBA removal since HBA will be still alive in this case and
it can complete the outstanding IOs. Flush out the outstanding IOs
only in case physical HBA hot unplug where their won't be any
communication with the HBA.

During shutdown also it is possible that HBA hardware can perform
DMA operations on those outstanding IO buffers which are completed
with DID_NO_CONNECT by the driver from .shutdown(). So same above fix
is applied in shutdown path as well.

Cc: stable@vger.kernel.org
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
v1:
    Update the patch description.

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

