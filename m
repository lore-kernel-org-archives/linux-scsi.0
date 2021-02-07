Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85A5C433E9
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A53E064E5A
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBGLkr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:40:47 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12477 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhBGLkW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:40:22 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DYRx03xKvzjKnb;
        Sun,  7 Feb 2021 19:38:12 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:23 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 00/32] spin lock usage optimization for SCSI drivers
Date:   Sun, 7 Feb 2021 19:36:31 +0800
Message-ID: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace spin_lock_irqsave with spin_lock in hard IRQ of SCSI drivers.
There are no function changes, but may speed up if interrupt happen
too often.

Xiaofei Tan (32):
  scsi: 53c700: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: ipr: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: lpfc: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: qla4xxx: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: BusLogic: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: a100u2w: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: a2091: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: a3000: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: aha1740: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: bfa: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: esp_scsi: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: gvp11: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: hptiop: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: ibmvscsi: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: initio: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: megaraid: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: mac53c94: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: mesh: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: mvumi: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: myrb: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: myrs: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: ncr53c8xx: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: nsp32: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: pmcraid: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: pcmcia: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: qlogicfas408: Replace spin_lock_irqsave with spin_lock in hard
    IRQ
  scsi: qlogicpti: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: sgiwd93: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: stex: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: vmw_pvscsi: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: wd719x: Replace spin_lock_irqsave with spin_lock in hard IRQ
  scsi: advansys: Replace spin_lock_irqsave with spin_lock in hard IRQ

 drivers/scsi/53c700.c                     |  5 ++--
 drivers/scsi/BusLogic.c                   |  5 ++--
 drivers/scsi/a100u2w.c                    |  5 ++--
 drivers/scsi/a2091.c                      |  5 ++--
 drivers/scsi/a3000.c                      |  5 ++--
 drivers/scsi/advansys.c                   |  5 ++--
 drivers/scsi/aha1740.c                    |  5 ++--
 drivers/scsi/bfa/bfad.c                   | 20 ++++++-------
 drivers/scsi/esp_scsi.c                   |  5 ++--
 drivers/scsi/gvp11.c                      |  5 ++--
 drivers/scsi/hptiop.c                     |  5 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c            |  5 ++--
 drivers/scsi/initio.c                     |  5 ++--
 drivers/scsi/ipr.c                        | 21 ++++++-------
 drivers/scsi/lpfc/lpfc_sli.c              | 49 +++++++++++++------------------
 drivers/scsi/mac53c94.c                   |  5 ++--
 drivers/scsi/megaraid.c                   | 10 +++----
 drivers/scsi/megaraid/megaraid_sas_base.c |  5 ++--
 drivers/scsi/mesh.c                       |  5 ++--
 drivers/scsi/mvumi.c                      |  7 ++---
 drivers/scsi/myrb.c                       | 20 +++++--------
 drivers/scsi/myrs.c                       | 15 ++++------
 drivers/scsi/ncr53c8xx.c                  |  5 ++--
 drivers/scsi/nsp32.c                      |  5 ++--
 drivers/scsi/pcmcia/sym53c500_cs.c        |  5 ++--
 drivers/scsi/pmcraid.c                    |  8 ++---
 drivers/scsi/qla4xxx/ql4_isr.c            | 15 ++++------
 drivers/scsi/qlogicfas408.c               |  5 ++--
 drivers/scsi/qlogicpti.c                  |  5 ++--
 drivers/scsi/sgiwd93.c                    |  5 ++--
 drivers/scsi/stex.c                       | 16 +++++-----
 drivers/scsi/vmw_pvscsi.c                 |  4 +--
 drivers/scsi/wd719x.c                     |  7 ++---
 33 files changed, 122 insertions(+), 175 deletions(-)

-- 
2.8.1

