Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454FEEE49A4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 03:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjIKDCP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Sep 2023 23:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjIKDCN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Sep 2023 23:02:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD977B0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2023 20:02:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC37BC433C8;
        Mon, 11 Sep 2023 03:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694401329;
        bh=Ta5rNiUkk5836kUgMYZ0cbyJtRdYmlBslDNwKIA8WEI=;
        h=From:To:Cc:Subject:Date:From;
        b=jx7Jl8gfeUVA8K3vRHi+C5YdNKB4RkY+/7Qo6uefSfK/BOHTVvspf/ihqMgCTfdMJ
         nWzc0UuX20lGYUO9BwAWy/ewdGhZDieUx7yXmjT+oZ7kh+pG0YuaIMmBG9ChperpI9
         3nroIkVppj4nlqHbb2fnoUlIoGVjdaQI0Yq2lPFhN5z2vPgFjsg9SXC4As9E1MDzoJ
         S1jvglhsZiyK2pwwgOOTglwwIsSo2RBY0UX8hImHIet0DI2Xk9PocPPw/MfpeVoOHF
         YXfouXtl8GFBNHOwXYg3IDdxGy9WwoXDLjY5kWokbCrlft44Wo2oXzuxDBr/QIuGgZ
         jQGTTLxdrv+UQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 00/10] scsi: pm8001: Bug fix and cleanup
Date:   Mon, 11 Sep 2023 12:01:57 +0900
Message-ID: <20230911030207.242917-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first patch of this series fixes an issue with IRQ setup which
prevents the controller from resuming after a system suspend.
The following patches are code cleanup without any functional changes.

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

 drivers/scsi/pm8001/pm8001_hwi.c  |  89 ++-------
 drivers/scsi/pm8001/pm8001_init.c | 322 +++++++++++++++---------------
 drivers/scsi/pm8001/pm8001_sas.h  |  11 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  |  59 ++----
 4 files changed, 202 insertions(+), 279 deletions(-)

-- 
2.41.0

