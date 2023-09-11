Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A5FCA0ECB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 02:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238341AbjILCci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238253AbjILCcV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 22:32:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF1918D033
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 18:57:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C527C116B1;
        Mon, 11 Sep 2023 23:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694474867;
        bh=+ROc2+W3F+ndECwu2AQYo2nnVHje4D7vH2MzampKMe0=;
        h=From:To:Cc:Subject:Date:From;
        b=GkvhzDXPYoCxbMr3M6yXDC8A1HzX4ah/b7M0ysAg99wab0ELEyQ+H0W6I4cteI7Ho
         PdA6fqzgh75293DWhdCWFPZrX3pDvxI/WM7L6CheazKbNA42B0MvW/7ILBzezKS1pd
         IIA/e+2kLp+HAPBeBmvNjzqOaCtPJBxx+Y7/88Y0q6mGSNCY+nDkge6TNMYByiPrs9
         fCKmdqUErhflrYXPAVLiyU5CRLtEOHgGEejv4EveCIPOJc1aiA20L0uGlfJu42WmrN
         hCH/wNdkyu9FAButf4qlhzHvZhAdxNGBDeMuTPuc23mujqzcz/g851dtWHlDqiiw/I
         tditipmKt/SZA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH v2 00/10] scsi: pm8001: Bug fix and cleanup
Date:   Tue, 12 Sep 2023 08:27:35 +0900
Message-ID: <20230911232745.325149-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first patch of this series fixes an issue with IRQ setup which
prevents the controller from resuming after a system suspend.
The following patches are code cleanup without any functional changes.

Changes from v1:
 * Added Acked-by tag from Jack
 * Fixed patch 10 to avoid a sparse warning

Damien Le Moal (10):
  scsi: pm8001: Setup IRQs on resume
  scsi: pm8001: Introduce pm8001_free_irq()
  scsi: pm8001: Introduce pm8001_init_tasklet()
  scsi: pm8001: Introduce pm8001_kill_tasklet()
  scsi: pm8001: Introduce pm8001_handle_irq()
  scsi: pm8001: Simplify pm8001_chip_interrupt_enable/disable()
  scsi: pm8001: Remove pm80xx_chip_intx_interrupt_enable/disable()
  scsi: pm8001: Remove PM8001_USE_MSIX
  scsi: pm8001: Remove PM8001_USE_TASKLET
  scsi: pm8001: Remove PM8001_READ_VPD

 drivers/scsi/pm8001/pm8001_hwi.c  |  89 ++------
 drivers/scsi/pm8001/pm8001_init.c | 326 +++++++++++++++---------------
 drivers/scsi/pm8001/pm8001_sas.h  |  11 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  |  59 ++----
 4 files changed, 203 insertions(+), 282 deletions(-)

-- 
2.41.0

