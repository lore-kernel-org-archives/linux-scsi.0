Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228C1C77B73
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 10:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjFEKw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 06:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjFEKwu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 06:52:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11B9F2;
        Mon,  5 Jun 2023 03:52:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27AEC621F3;
        Mon,  5 Jun 2023 10:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9711C433D2;
        Mon,  5 Jun 2023 10:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685962366;
        bh=hhEiZotnE5l37OijnHBGngZ7eDqjAom5G7ToCUPfij8=;
        h=From:To:Cc:Subject:Date:From;
        b=eQJ9BG/n7b8rgsYZ2VHrruVahoOclFlyRIeACqI+QJFC6c7k23+3Uhrx8bVDzbegp
         kW6cRgKDjrbGja047esVC12p4R/9db17BNzO3bkKolNnvv9gWmNiJaRbb6aVHeBfmR
         qXCncJXMFCewVnJIAkDKqYakaZN4bVCw59B3yMwTdy++5A6Ur8EuHsenQn8vEyzvA6
         M7zCYaK1aQfXLjZcaF9CtnySzsgMgXAvBoFf8av3G6V+Mb9oO1P+UIoqtHifI5DmH0
         XICbPH3U6ULffmhR4v+/FIJePttCn87Eo4/1U2MLF50v0PXxN+oHX7jY3gz1KZq4ld
         Vg1xyFS1A+MWw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 0/3] Cleanups and improvements
Date:   Mon,  5 Jun 2023 19:52:41 +0900
Message-Id: <20230605105244.1045490-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Improve ata_change_queue_depth() to have its behavior with libsas
managed devices consistent with libata managed devices. Also add a
couple of simple cleanups to use defined helper functions instead of
open coding device flags checks.

Changes from v1:
 - Improved comments in the code changes introduced in patch 1
 - Fixed typos in the commit message of patch 2 and 3
 - Added Review tags from Hannes and John

Damien Le Moal (3):
  ata: libata-sata: Improve ata_change_queue_depth()
  ata: libata-eh: Use ata_ncq_enabled() in ata_eh_speed_down()
  ata: libata-scsi: Use ata_ncq_supported in ata_scsi_dev_config()

 drivers/ata/libata-eh.c   |  4 +---
 drivers/ata/libata-sata.c | 31 +++++++++++++++++++++----------
 drivers/ata/libata-scsi.c |  2 +-
 3 files changed, 23 insertions(+), 14 deletions(-)

-- 
2.40.1

