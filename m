Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45DEBC7EE2F
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 01:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjFEBcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Jun 2023 21:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjFEBcP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jun 2023 21:32:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA0DCA;
        Sun,  4 Jun 2023 18:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FB5160BDB;
        Mon,  5 Jun 2023 01:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA54C433EF;
        Mon,  5 Jun 2023 01:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685928733;
        bh=0ao2xJ5/RlPizmJ4riWiu1eLJI5sj68Dx4f7Wb0pyJ4=;
        h=From:To:Cc:Subject:Date:From;
        b=M9IQb1ySQrOhYyVxoqJH/ad0LyGoDr+0ZIf6+A9nCCyiufUKLyBChmLhrfSh/BsW9
         7i4sTkGwkzxnU8J5yqqx6edXmyJiQunwKdhG5W4Jkxnxvp7MCJhb5eDlWZ0cCUVaPY
         Ghk/ogF/et6WQNzfeW5UIpJ5T9/WOr2ZXczyLKoP8SlyWCZetBFiU1/W3cESMC3njM
         bXFZ4uS3HXLfR021vZmJqFqLhu8vG8UN10TnAkNKr9cBfsNSPnFDYD7yGnwNet6qs8
         np5lW5ZcSyT/mLdNd2KqzQlSSFqtVxcjebBBY9MyxT1NpE8kuS4Y/mdpjVC1mmT+yj
         Bl1b4AIk9CAuw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 0/3] Cleanups and improvements
Date:   Mon,  5 Jun 2023 10:32:09 +0900
Message-Id: <20230605013212.573489-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Improve ata_change_queue_depth() to have its behavior consistent for
libsas managed devices with libata managed devices. Also add a couple of
simple cleanups to use defined helper functions instead of open coding
device flags checks.

Damien Le Moal (3):
  ata: libata-sata: Improve ata_change_queue_depth()
  ata: libata-eh: Use ata_ncq_enabled() in ata_eh_speed_down()
  ata: libata-scsi: Use ata_ncq_supported in ata_scsi_dev_config()

 drivers/ata/libata-eh.c   |  4 +---
 drivers/ata/libata-sata.c | 25 +++++++++++++++----------
 drivers/ata/libata-scsi.c |  2 +-
 3 files changed, 17 insertions(+), 14 deletions(-)

-- 
2.40.1

