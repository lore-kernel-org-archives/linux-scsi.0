Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE432C433E8
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 08:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93A22206D8
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 08:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgGYIUv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jul 2020 04:20:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8821 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbgGYIUv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Jul 2020 04:20:51 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9AFC2BE19D4066F78E67;
        Sat, 25 Jul 2020 16:20:48 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Sat, 25 Jul 2020
 16:20:40 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <john.garry@huawei.com>, <yanaijie@huawei.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        <linuxarm@huawei.com>
Subject: [PATCH v2 0/2] scsi: libsas: An improvement on error handle and tidy-up
Date:   Sat, 25 Jul 2020 16:18:49 +0800
Message-ID: <1595665131-24543-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch introduces an improvement to reduce error handle time and a
tidy-up, including: 
- postreset() is deleted from sas_sata_ops. 
- Do not perform hard reset and delayed retry on a removed SATA disk. This
can effectively reduce the error handle duration of hot unplug a SATA disk
with traffic(reduce about 30s depending on the delay setting of libata). 

Both John garry and Jason Yan participated in the review of the solution
and provided good suggestions during the development.

Change since v1:
- Removed an unnecessary tag from subject.

Luo Jiaxing (2):
  scsi: libsas: delete postreset at sas_sata_ops
  scsi: libsas: check link status at ATA prereset() ops

 drivers/scsi/libsas/sas_ata.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

-- 
2.7.4

