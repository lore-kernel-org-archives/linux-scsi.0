Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2649C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Nov 2022 10:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbiKNKZP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Nov 2022 05:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbiKNKZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2022 05:25:09 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A17E1D0D0;
        Mon, 14 Nov 2022 02:25:08 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D5A6D411F8;
        Mon, 14 Nov 2022 10:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1668421504; x=
        1670235905; bh=z3JiUsrxPOCX2YvK+EQmubzwkInsJC8PzgFviu8qFUc=; b=o
        75gIccJMdps94CrvWEbghAGa4hlMsQB+HsBsgekuA0lJcM5VFv0L25if08RNasxp
        dejJ38VEx5i88hIaTCdyF6gLhjZnMoKZ92mMhCr9y0T/QyAyfLgaxglvAE/5PcjT
        91OmgmY4xMKpxy7UpjDchN1u2DeyELJn8IAIz2CGJo=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q8UhweDcKBXc; Mon, 14 Nov 2022 13:25:04 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A3F33403CB;
        Mon, 14 Nov 2022 13:25:04 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 14 Nov 2022 13:25:04 +0300
Received: from localhost (10.178.120.161) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Mon, 14 Nov
 2022 13:25:04 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: [PATCH v3 0/3] Make target send correct io limits
Date:   Mon, 14 Nov 2022 13:24:57 +0300
Message-ID: <20221114102500.88892-1-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.120.161]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently iblock always reports MAXIMUM TRANSFER LENGTH in 512b units
regardless of the LU block size.

Target block size:
  target:~ # fdisk -l /dev/nullb0
  Disk /dev/nullb0: 250 GiB, 268435456000 bytes, 65536000 sectors
  Units: sectors of 1 * 4096 = 4096 bytes
  Sector size (logical/physical): 4096 bytes / 4096 bytes
  I/O size (minimum/optimal): 4096 bytes / 4096 bytes

Initiator block size:
  initiator:~ # fdisk -l /dev/sdc
  Disk /dev/sdc: 250 GiB, 268435456000 bytes, 65536000 sectors
  Disk model: nullb0
  Units: sectors of 1 * 4096 = 4096 bytes
  Sector size (logical/physical): 4096 bytes / 4096 bytes
  I/O size (minimum/optimal): 4096 bytes / 131072 bytes

target max transfer length limit:
  target:~ # cat /sys/block/nullb0/queue/max_hw_sectors_kb
  128

So the maximum transfer length should be 128 * 1024 / 4096 = 32 blocks
But the target sends MTL in 512b units, so the initiators see 256 blocks
instead.

  initiator:~ # sg_inq -p 0xb0 /dev/sdc
  VPD INQUIRY: Block limits page (SBC)
    Maximum compare and write length: 1 blocks
    Optimal transfer length granularity: 1 blocks
    Maximum transfer length: 256 blocks
    Optimal transfer length: 32 blocks
    Maximum prefetch transfer length: 0 blocks [ignored]

This happens because MAXIMUM TRANSFER LENGTH field in VPD Block Limits
page is derived from dev->dev_attrib.hw_max_sectors which happens to be
in 512b units for iblock. This patch series fixes this issue and removes
some special-casing for other backstores.

Changes since v1:
Sinse the v1 patch series, some variables was renamed, the checkpatch
script was run and issues with debug logs was fixed, some refactoring
was done.

Changes since v2:
Since the v2 patch series, a kernel bot found some issues with building
a kernel for i386. The problem was that division 64 bit number make GCC
generate __udivdi3 which is missing on i386.

Anastasia Kovaleva (3):
  target: core: Send mtl in blocks
  target: core: make hw_max_sectors store the sectors amount in blocks
  target: core: Change the way target_xcopy_do_work sets restiction on
    max io

 drivers/target/target_core_configfs.c |  2 -
 drivers/target/target_core_file.c     |  1 -
 drivers/target/target_core_iblock.c   |  4 +-
 drivers/target/target_core_spc.c      |  6 +-
 drivers/target/target_core_xcopy.c    | 97 +++++++++++++++------------
 drivers/target/target_core_xcopy.h    |  2 +-
 include/target/target_core_base.h     |  1 -
 7 files changed, 62 insertions(+), 51 deletions(-)

-- 
2.38.1

