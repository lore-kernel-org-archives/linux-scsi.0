Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D1EC433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57D1C64F21
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581523AbhCBS5x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:57:53 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:18622 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241729AbhCBNbV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:31:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614691880; x=1646227880;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=geDaw/ej7e94nG9rcAUGZvgQPXgEy2UARyY+T9z+3SQ=;
  b=LZH+6qp4rpf2NHV999J0yUMdwuNWOYp1pCUIczBCMjZE3KKaPektBwXq
   v5Rxl+XlCOvO6qOkZJmxtYq6+SnUV/bD28ReEXN/h2wZyp0oG/I81EQUG
   7FSgIaXZK55sSD8XnMTltC4/i92ysgkvn2lhQ8FdTN8T8sUcrTlYtogax
   dvktL+zcgT5ACpbNhjiqyIvKzS60QbBlE0/t1QJIS1bnYO0RxWQXeeGiV
   FjF4LvUnaayzOtSjG5S1yGC2Ce/T5CBSNnuB+ha8Pju5BZKZC+hxtaGnZ
   FAIHqI/rHrkNZ4190bdHVt1njPye0SF/JIBnaINLlnG9A9JFeGxDvUE9J
   Q==;
IronPort-SDR: naKEzHOxExTgvEFR4hMpXAfv3aWBb06T+qLRvj0xB6EXH/TkX8Se7K7feEWsd2YVF5EcRXpG0D
 xss2mwHD8K3iH/Inn5TK2la815aQWAi0HdJdgdkvpE/A32NqaWEwipbFaUTt8zP5K6EZ3URks1
 m6fS5sSyN87q290xmfz+6UzZY4ZV41XmUschyjn2fDAX/E7Wvzm/26UkKFOvJ+v6st5gyK5jtf
 R41PJK7d0IxnM6dFY1x4wMq/yzvx5+OrQjaPeOVR5ReRIoQhljdCJy0Qp7OTzgrSfH2lv3y4jf
 sbQ=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="161146204"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 21:25:48 +0800
IronPort-SDR: 3rdKSQPJZfOeHE/wZ7k7hZhXs7ygpQe0JEUKxWYRx315tBN0TJrjB+SWSwrE78NcA7MDFg7yR8
 w1xihyRM05+Z0R7GsBUoOJwJs43NeFxLr5x/heb46wWHOCKz4x0WXx0f3YK2tzdK8usboB/fLy
 pIW3+AxZS62rRNUqlacFc07WJrcFlnXvdbgqLvnzH05AQ3xso1kHoOJs0okJoAQc6xNLiL5wB4
 XbvMbuuJo+8gwRpIj+DinsvR3n1YQK161h7yqNHQyAd7orbLA6r9VcV/epVZ5TasK+yV2QwSmC
 APx6kHsbDwXe1NdHOPNCvEY5
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 05:07:03 -0800
IronPort-SDR: 2LL1tBjxvjjVFK+KymTOyqNVzwXZL0wQUWx9hklrQSFsqELG0hTsgKIQ/61HBttDuO9L/A++0a
 t+wVb3lZsI6CHeQ6GU72Oz+MbRrxrA9MA/VE9eb8v5coqXwp8mkv9oWjJAcfa4j3P0LO0zr8Yy
 F68hbEwEQi7AvnYQdGSFOYekJlXpb0AR5pB75htfy6N0RA0EcHUQf44fPp0XBuKXgTSLsToMwK
 duRnzdA/NaOrOuV+/Qo3XrH7O8na+0dvba79FdImp2fjnlQ39PWYG2z+NJdaGLN6Sow451d/1h
 buk=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2021 05:25:44 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v5 00/10] Add Host control mode to HPB
Date:   Tue,  2 Mar 2021 15:24:53 +0200
Message-Id: <20210302132503.224670-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v4 -> v5:
 - attend Daejun's comments
 - Control the number of inflight map requests

v3 -> v4:
 - rebase on Daejun's v25

v2 -> v3:
 - Attend Greg's and Can's comments
 - rebase on Daejun's v21

v1 -> v2:
 - attend Greg's and Daejun's comments
 - add patch 9 making host mode parameters configurable
 - rebase on Daejun's v19


The HPB spec defines 2 control modes - device control mode and host
control mode. In oppose to device control mode, in which the host obey
to whatever recommendation received from the device - In host control
mode, the host uses its own algorithms to decide which regions should
be activated or inactivated.

We kept the host managed heuristic simple and concise.

Aside from adding a by-spec functionality, host control mode entails
some further potential benefits: makes the hpb logic transparent and
readable, while allow tuning / scaling its various parameters, and
utilize system-wide info to optimize HPB potential.

This series is based on Samsung's V25 device-control HPB2.0 driver, see
msg-id: 20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8
in lore.kernel.org.

This version was tested on Galaxy S20, and Xiaomi Mi10 pro.
Your meticulous review and testing is mostly welcome and appreciated.

Thanks,
Avri

Avri Altman (10):
  scsi: ufshpb: Cache HPB Control mode on init
  scsi: ufshpb: Add host control mode support to rsp_upiu
  scsi: ufshpb: Add region's reads counter
  scsi: ufshpb: Make eviction depends on region's reads
  scsi: ufshpb: Region inactivation in host mode
  scsi: ufshpb: Add hpb dev reset response
  scsi: ufshpb: Add "Cold" regions timer
  scsi: ufshpb: Limit the number of inflight map requests
  scsi: ufshpb: Add support for host control mode
  scsi: ufshpb: Make host mode parameters configurable

 Documentation/ABI/testing/sysfs-driver-ufs |  74 +++
 drivers/scsi/ufs/ufshcd.h                  |   2 +
 drivers/scsi/ufs/ufshpb.c                  | 555 ++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h                  |  39 ++
 4 files changed, 646 insertions(+), 24 deletions(-)

-- 
2.25.1

