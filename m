Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA7AEC3F2C6
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C81AD22522
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgCJQbI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:31:08 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35842 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727265AbgCJQbI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:31:08 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 16DE65EE380EC62AB3CC;
        Wed, 11 Mar 2020 00:30:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:23 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v2 00/24] scsi: enable reserved commands for LLDDs 
Date:   Wed, 11 Mar 2020 00:25:26 +0800
Message-ID: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is v2 of original series from Hannes, which I'm hijacking for the
moment:
https://patchwork.kernel.org/cover/10967071/

And the background:

Quite some drivers use internal commands for various purposes, most
commonly sending TMFs or querying the HBA status.
While these commands use the same submission mechanism than normal
I/O commands, they will not be counted as outstanding commands,
requiring those drivers to implement their own mechanism to figure
out outstanding commands.
This patchset enables the use of reserved tags for the SCSI midlayer,
enabling LLDDs to rely on the block layer for tracking outstanding
commands.
More importantly, it allows LLDD to request a valid tag from the block
layer without having to implement some tracking mechanism within the
driver. This removes quite some hacks which were required for some
drivers (eg. fnic or snic).

Finally:

As I see, there is no dependency on this series to go into the kernel now.
And we need it for [0].

Note: [0] also depends on [1]

[0] https://lore.kernel.org/linux-block/1583409280-158604-1-git-send-email-john.garry@huawei.com/T/#t
[1] https://lore.kernel.org/linux-block/20191014015043.25029-1-ming.lei@redhat.com/

Differences to v1:
- Make scsi_{get, put}_reserved_cmd() for Scsi host
	- Previously we separate scsi_{get, put}_reserved_cmd() for sdev
	  and scsi_host_get_reserved_cmd() for the host
- Fix how Scsi_Host.can_queue is set in the virtio-scsi change
- Drop Scsi_Host.use_reserved_cmd_q
- Drop scsi_is_reserved_cmd()
	- It was unused
	- But keep blk_mq_rq_is_reserved()
- Add support in libsas and associated HBA drivers
	- Allocate reserved command in slow task
	- Switch hisi_sas to use reserved Scsi command
- Reorder the series a little
- Some tidying

Hannes Reinecke (22):
  scsi: add 'nr_reserved_cmds' field to the SCSI host template
  scsi: allocate separate queue for reserved commands
  blk-mq: Implement blk_mq_rq_is_reserved()
  scsi: Add scsi_{get, put}_reserved_cmd()
  csiostor: use reserved command for LUN reset
  scsi: add scsi_cmd_from_priv()
  virtio_scsi: use reserved commands for TMF
  scsi: add host tagset busy iterator
  fnic: use reserved commands
  fnic: use scsi_host_tagset_busy_iter() to traverse commands
  hpsa: move hpsa_hba_inquiry after scsi_add_host()
  hpsa: use reserved commands
  hpsa: use blk_mq_tagset_busy_iter() to traverse outstanding commands
  hpsa: drop refcount field from CommandList
  snic: use reserved commands
  snic: use tagset iter for traversing commands
  aacraid: move scsi_add_host()
  aacraid: use private commands
  aacraid: replace cmd_list with scsi_host_tagset_busy_iter()
  aacraid: use scsi_host_tagset_busy_iter() to traverse outstanding
    commands
  dpt_i2o: drop cmd_list usage
  scsi: drop scsi command list

John Garry (2):
  scsi: libsas: aic94xx: hisi_sas: mvsas: pm8001: Allocate Scsi_cmd for
    slow task
  scsi: hisi_sas: Use libsas slow task SCSI command

 block/blk-mq.c                         |  13 +
 drivers/scsi/aacraid/aachba.c          | 125 ++--
 drivers/scsi/aacraid/aacraid.h         |   6 +-
 drivers/scsi/aacraid/comminit.c        |  28 +-
 drivers/scsi/aacraid/commsup.c         | 134 ++--
 drivers/scsi/aacraid/linit.c           | 300 ++++----
 drivers/scsi/csiostor/csio_init.c      |   3 +-
 drivers/scsi/csiostor/csio_scsi.c      |  49 +-
 drivers/scsi/dpt_i2o.c                 |  23 +-
 drivers/scsi/fnic/fnic_scsi.c          | 917 +++++++++++--------------
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  13 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |   5 +-
 drivers/scsi/hosts.c                   |  27 +
 drivers/scsi/hpsa.c                    | 313 ++++-----
 drivers/scsi/hpsa.h                    |   1 -
 drivers/scsi/hpsa_cmd.h                |   1 -
 drivers/scsi/libsas/sas_expander.c     |   3 +-
 drivers/scsi/libsas/sas_init.c         |  36 +-
 drivers/scsi/mvsas/mv_sas.c            |   2 +-
 drivers/scsi/pm8001/pm8001_hwi.c       |   4 +-
 drivers/scsi/pm8001/pm8001_sas.c       |   4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c       |   4 +-
 drivers/scsi/scsi.c                    |   1 -
 drivers/scsi/scsi_lib.c                |  80 ++-
 drivers/scsi/scsi_scan.c               |   1 -
 drivers/scsi/snic/snic.h               |   2 +-
 drivers/scsi/snic/snic_main.c          |   2 +
 drivers/scsi/snic/snic_scsi.c          | 502 +++++++-------
 drivers/scsi/virtio_scsi.c             | 107 ++-
 include/linux/blk-mq.h                 |   2 +
 include/scsi/libsas.h                  |   4 +-
 include/scsi/scsi_cmnd.h               |  14 +-
 include/scsi/scsi_device.h             |   1 -
 include/scsi/scsi_host.h               |  14 +-
 34 files changed, 1346 insertions(+), 1395 deletions(-)

-- 
2.17.1

