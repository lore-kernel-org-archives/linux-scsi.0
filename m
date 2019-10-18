Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC48CA9EA4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D147121925
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442200AbfJRIRg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:17:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4728 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404271AbfJRIRd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 04:17:33 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AB99AEB39D75F81D4BA8;
        Fri, 18 Oct 2019 16:17:29 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 16:17:21 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <yanaijie@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH v5 00/13] scsi: core: fix uninit-value access of variable sshdr
Date:   Fri, 18 Oct 2019 16:24:18 +0800
Message-ID: <1571387071-28853-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1->v2: modify the comments suggested by Bart
v2->v3: fix bug in sr_do_ioctl
v3->v4: let "fix bug in sr_do_ioctl" be a separate patch
v4->v5: fix uninit-value access bug in callers, not in __scsi_execute

zhengbin (13):
  scsi: core: need to check the result of scsi_execute in
    scsi_report_opcode
  scsi: core: need to check the result of scsi_execute in
    scsi_test_unit_ready
  scsi: core: need to check the result of scsi_execute in
    scsi_report_lun_scan
  scsi: sr: need to check the result of scsi_execute in sr_get_events
  scsi: sr: need to check the result of scsi_execute in sr_do_ioctl
  scsi: scsi_dh_emc: need to check the result of scsi_execute in
    send_trespass_cmd
  scsi: scsi_dh_rdac: need to check the result of scsi_execute in
    send_mode_select
  scsi: scsi_dh_hp_sw: need to check the result of scsi_execute in
    hp_sw_tur,hp_sw_start_stop
  scsi: scsi_dh_alua: need to check the result of scsi_execute in
    alua_rtpg,alua_stpg
  scsi: scsi_transport_spi: need to check whether sshdr is valid in
    spi_execute
  scsi: cxlflash: need to check whether sshdr is valid in read_cap16
  scsi: ufs: need to check whether sshdr is valid in
    ufshcd_set_dev_pwr_mode
  scsi: ch: need to check whether sshdr is valid in ch_do_scsi

 drivers/scsi/ch.c                           | 6 ++++--
 drivers/scsi/cxlflash/superpipe.c           | 2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  | 6 ++++--
 drivers/scsi/device_handler/scsi_dh_emc.c   | 3 ++-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 6 ++++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 8 +++++---
 drivers/scsi/scsi.c                         | 2 +-
 drivers/scsi/scsi_lib.c                     | 3 +++
 drivers/scsi/scsi_scan.c                    | 3 ++-
 drivers/scsi/scsi_transport_spi.c           | 1 +
 drivers/scsi/sr.c                           | 3 ++-
 drivers/scsi/sr_ioctl.c                     | 6 ++++++
 drivers/scsi/ufs/ufshcd.c                   | 3 ++-
 13 files changed, 37 insertions(+), 15 deletions(-)

--
2.7.4

