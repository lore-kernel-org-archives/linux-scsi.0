Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640BFC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 15:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiJQPA7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 11:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbiJQO77 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 10:59:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D46696D0;
        Mon, 17 Oct 2022 07:57:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C0A8134031;
        Mon, 17 Oct 2022 14:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666018517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc;
        bh=jTwL/T4HkHL8iKoj6Vj+ljbJU9UBePNtP7Jc/xS7RZk=;
        b=K9GSOMhkY/1TlU8TUHxxVvr0wT6acqz9NJz4Q4N0N1Seu6yt5/Gt5t5zh6BVuDwuU5apsS
        by/EayaSyJU4PD09AeLBtn1IZxN6tl+7NdHAb/+b/qop2ISOPz5eoWzoQn/gjseQZBVm9k
        bVUv094GfB2Bibd5uG2aFNTuIqKHbT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666018517;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc;
        bh=jTwL/T4HkHL8iKoj6Vj+ljbJU9UBePNtP7Jc/xS7RZk=;
        b=5CbRW0u8AVRIVmzJshsqZpLnRR0qLNjEAW5RFH5B80H7Zm+bgvgE3ZBAcMFRWmBl1FJhj6
        Z7CUGwtmuK+ACvDA==
Received: from lion.mk-sys.cz (unknown [10.163.29.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B370A2C141;
        Mon, 17 Oct 2022 14:55:17 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 93BCB6043B; Mon, 17 Oct 2022 16:55:17 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH v2] scsi: mpi3mr: select CONFIG_SCSI_SAS_ATTRS
To:     mpi3mr-linuxdrv.pdl@broadcom.com,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Message-Id: <20221017145517.93BCB6043B@lion.mk-sys.cz>
Date:   Mon, 17 Oct 2022 16:55:17 +0200 (CEST)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Starting with commit 42fc9fee116f ("scsi: mpi3mr: Add helper functions to
manage device's port"), kernel configured with CONFIG_SCSI_MPI3MR=m and
CONFIG_SCSI_SAS_ATTRS=n fails to build because modpost cannot find symbols
used in mpi3mr_transport.c:

  ERROR: modpost: "sas_port_alloc_num" [drivers/scsi/mpi3mr/mpi3mr.ko] undefined!
  ERROR: modpost: "sas_remove_host" [drivers/scsi/mpi3mr/mpi3mr.ko] undefined!
  ERROR: modpost: "sas_phy_alloc" [drivers/scsi/mpi3mr/mpi3mr.ko] undefined!
  ERROR: modpost: "sas_phy_free" [drivers/scsi/mpi3mr/mpi3mr.ko] undefined!
  ...

Select CONFIG_SCSI_SAS_ATTRS when CONFIG_SCSI_MPI3MR is enabled to prevent
inconsistent configs.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

v2: use select instead of depend
---
 drivers/scsi/mpi3mr/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpi3mr/Kconfig b/drivers/scsi/mpi3mr/Kconfig
index 8997531940c2..f48740cd5b95 100644
--- a/drivers/scsi/mpi3mr/Kconfig
+++ b/drivers/scsi/mpi3mr/Kconfig
@@ -4,5 +4,6 @@ config SCSI_MPI3MR
 	tristate "Broadcom MPI3 Storage Controller Device Driver"
 	depends on PCI && SCSI
 	select BLK_DEV_BSGLIB
+	select SCSI_SAS_ATTRS
 	help
 	MPI3 based Storage & RAID Controllers Driver.
-- 
2.38.0

