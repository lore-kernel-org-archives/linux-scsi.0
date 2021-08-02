Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD4DC4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AB6560F39
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhHBJC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:02:57 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6555 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbhHBJCs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 05:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627894957; x=1659430957;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Q0qi0MmsrsEfp9dtr19KJjoVUyafiktr3GhxDwTWet4=;
  b=TfEZ+2/YRmY9ay08BK4xGHYPGDNbXzCFvRKC8hinZqwGiQA8xkq50wMN
   pLtaNF6Ai9V+8hRNH+gMcTPoeWbTKX0LwkWonWW/k93qwT9vmkSSKJ0mv
   7EVtLJplZaY4QMyRA4rbEWV8t4ojqVnSaaf6krK/oMSlkloELBN8djrsi
   PSdSWO/nPiXaYksLPtcS3zNYW7rGUyeGF1XqPH/cz6pBD9EPnRrOoPHDp
   lQZeS+CmvyK9AtTR7O8od4/N+qsp+BxD/pcm3WFxLmiuG4rBuXt2hOi17
   OHhhhotUluZkXBzBh338WvLWMNKunVk1XXaKWc5BvkocqtvDiWIl3YYC6
   g==;
X-IronPort-AV: E=Sophos;i="5.84,288,1620662400"; 
   d="scan'208";a="180887615"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2021 17:02:33 +0800
IronPort-SDR: /7eJNYOEH7Dybwfr9k8mF9Vr6IC19A+HORD3feFg1oObAA437AyKYmyjONyb2YVrNNkEj49Y4n
 u/xj5ieaCPVldQCoxroinVrH4IBTe674E866IjTrx7DrSHX89JibD5Z7UecWr1iMmafdW8q08F
 KGqqQS3YtwoHr3UzldsrVla4+E/LuV5Z2V2ZOmGj0ITkytPFglr+zCb1fY2/Ya3Xwi158iw4tG
 HhEg7nIC/DdypovO7cPOQ5q3CLxI8kaND9wDqp+iU8cOD2RVbtDxnrus9+b9fEcvT68xjLWL/4
 WLsVefdGZtEaYOrR+OxGOh8s
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 01:40:08 -0700
IronPort-SDR: YJ1UWZNsR3Ufmh6thlc5JH78U2AyUnIaRmvgU9EsZWEMadN03/APgJ6mNSycLiOS0fo2SQMngD
 gZEPNLa+Bj98fVv1Ure0s+gE8CC8oN18wItY/QkpT6PRV8hFiI1EHmUWpZqPrLK/9CR/CVmU7v
 fxgB5LId0JLJL9NwUFrpUlJk5GxIUwQ6sKMlY34xLjAO8+tvpoK6hcrpYoURcxBHQi5goHv4Qb
 zYS9t+B9gkbRo+Ly4Vr3g1TqHkNNlSE6j/baQLIIfOYFk1htDIXQJcSLM/Q7+t1MPxgjhzM5mk
 jvg=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Aug 2021 02:02:33 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 0/7] libata cleanups and improvements
Date:   Mon,  2 Aug 2021 18:02:25 +0900
Message-Id: <20210802090232.1166195-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first three patches of this series cleanup libata-core code in the
area of device configuration (ata_dev_configure() function).
Patch 4 improves ata_read_log_page() handling to avoid unnecessary
warning messages and patch 5 adds an informational message on device
scan to advertize the features supported by a device.

Path 6 adds the new sysfs ahci device attribute ncq_prio_supported to
indicate that a disk supports NCQ priority. Patch 7 does the same for
the mpt3sas driver, adding the sas_ncq_prio_supported device attribute.

Damien Le Moal (7):
  libata: cleanup device sleep capability detection
  libata: cleanup ata_dev_configure()
  libata: cleanup NCQ priority handling
  libata: fix ata_read_log_page() warning
  libata: print feature list on device scan
  libahci: Introduce ncq_prio_supported sysfs sttribute
  scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs sttribute

 drivers/ata/libahci.c              |   1 +
 drivers/ata/libata-core.c          | 249 +++++++++++++++--------------
 drivers/ata/libata-sata.c          |  61 ++++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c |  20 +++
 include/linux/libata.h             |   5 +
 5 files changed, 191 insertions(+), 145 deletions(-)

-- 
2.31.1

