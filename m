Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C4BC001DF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jul 2023 01:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjGVBlM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 21:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGVBlL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 21:41:11 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C7871721;
        Fri, 21 Jul 2023 18:41:10 -0700 (PDT)
Received: from thinkpad-p16sg1.corp.microsoft.com (unknown [167.220.83.99])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4D005236FE14;
        Fri, 21 Jul 2023 18:41:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4D005236FE14
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1689990069;
        bh=hlalfOAh675uEo4Jafv9Q9FFSSyZ0FvKFtA0M9RnTVE=;
        h=From:To:Cc:Subject:Date:From;
        b=BmFumFmioLwIMPm7/6TdNR7bdL8o57B1Q+GCIXv+i87v/Hdrv9yYeIi8eoeAGmENi
         MKzHhkcbKfTNXq1QUEqQ91sNjGlXd05lB7x2qxPeHDIlwUVbJvN3eB3Y7lCI/UwTia
         wNPN+999xORorUK/UI9M0egaCnJ8JOB3TxLj/EKw=
From:   Shyam Saini <shyamsaini@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        linux-scsi@vger.kernel.org, shyamsaini@linux.microsoft.com
Subject: [RFC, PATCH 0/1] Replay Protected Memory Block (RPMB) driver
Date:   Fri, 21 Jul 2023 18:40:36 -0700
Message-Id: <20230722014037.42647-1-shyamsaini@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi everyone,

This is yet another attempt to come up with an RPMB API for the kernel.
This patch is based on patch 1 of last submission except few minor changes.
The last discussion of this was in the thread:

  Subject: [PATCH  v2 1/4] rpmb: add Replay Protected Memory Block (RPMB) subsystem
  Date: Tue,  5 Apr 2022 10:37:56 +0100 [thread overview]
  Message-ID: <20220405093759.1126835-2-alex.bennee@linaro.org>

The patch provides a simple RPMB driver. This is a RFC version and this
single driver can't be used by its own. It would require further work to
make use of API's provided by this driver.

Changes since the last posting:
  drop RPMB char driver
  drop virtio rpmb frontend driver
  drop rpmb: add RPBM access tool
  Rename get_write_count to get_write_counter
  Make return type for rpmb_set_key() function explicit

Alex Bennée (1):
  rpmb: add Replay Protected Memory Block (RPMB) driver

 MAINTAINERS           |   7 +
 drivers/Kconfig       |   1 +
 drivers/Makefile      |   2 +
 drivers/rpmb/Kconfig  |  11 ++
 drivers/rpmb/Makefile |   7 +
 drivers/rpmb/core.c   | 439 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/rpmb.h  | 182 +++++++++++++++++
 7 files changed, 649 insertions(+)
 create mode 100644 drivers/rpmb/Kconfig
 create mode 100644 drivers/rpmb/Makefile
 create mode 100644 drivers/rpmb/core.c
 create mode 100644 include/linux/rpmb.h

-- 
2.34.1

