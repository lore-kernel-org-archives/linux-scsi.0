Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EF8C4321E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Oct 2022 12:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiJNMCL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 08:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiJNMCJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 08:02:09 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7881958FC;
        Fri, 14 Oct 2022 05:02:04 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1740241222;
        Fri, 14 Oct 2022 12:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1665748920; x=
        1667563321; bh=zxet0cNNuLaiguDSEFmESG/wM7UPlb6kMP1WMKehw0Y=; b=C
        fynOT+wP6+mORn2sIHFBDJ69MSNjKn4FmByR8sbv/QQKsgzXiBArdBDwuoSBsI6w
        kDI1Zc8hr1BYmVZyRQXmEbWNLghW7opSQa6+uxJ1mFH+g5xlYqswlTmetKXehO1U
        z1x6LkwSoPMEfq8S20uNHB2Q/f/2MrL1j4J8EWwo5Q=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PvBb5ZBSdH1d; Fri, 14 Oct 2022 15:02:00 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 535C741237;
        Fri, 14 Oct 2022 15:01:01 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 14 Oct 2022 15:01:01 +0300
Received: from localhost (10.199.23.220) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 14 Oct
 2022 15:01:00 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: [PATCH v2 0/3] Make target send correct io limits
Date:   Fri, 14 Oct 2022 15:00:53 +0300
Message-ID: <20221014120056.33738-1-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.23.220]
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

The last time this patch set was sent, a kernel bot found some issues
with building a kernel for i586 and m68k using a cross-compiler. I tried
to reproduce this issues locally but didn't succeed. Even with given
configs all things are built correctly without errors. For m68k I used
m68k-linux-gnu-gcc version 11.2.0, for i586 I used
i586-unknown-linux-gnu-gcc version 8.3.0. It would be great if you could
share the kernel bot's cross-compilers.

Anastasia Kovaleva (3):
  target: core: Send mtl in blocks
  target: core: make hw_max_sectors store the sectors amount in blocks
  target: core: Change the way target_xcopy_do_work sets restiction on
    max io

 drivers/target/target_core_configfs.c |  2 -
 drivers/target/target_core_file.c     |  1 -
 drivers/target/target_core_iblock.c   |  4 +-
 drivers/target/target_core_spc.c      |  6 +-
 drivers/target/target_core_xcopy.c    | 96 ++++++++++++++-------------
 drivers/target/target_core_xcopy.h    |  2 +-
 include/target/target_core_base.h     |  1 -
 7 files changed, 59 insertions(+), 53 deletions(-)

-- 
2.30.2

