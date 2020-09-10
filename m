Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C2AC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A62020809
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:48:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dQHe9L8y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgIJHsu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 03:48:50 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63775 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgIJHss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 03:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599724127; x=1631260127;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JHen1lSmI3+ImkYB9Xgc1S6eSeibkPLLah0Z9SDMU2E=;
  b=dQHe9L8yefa3m7qnSddmt+DzYofxZFl6TEY9UvIjh5/ZxbVsoSBYanY6
   WvnJNJY18AHJMpRj0BJdujaxV1miSZMtsEbbhWK7mZoa1W5OeZU2ItNiD
   T7pht5f9PymYY9HDXlrUQSJJDCrCzPRi8verBmvxN+ZHFrzSRtXDSTY8j
   Ms5l1+CVmTuaIGR+1D2wripgHAygN8s1P4aCmo9n6OqGbgohBul+xmerk
   s3IbaagYSDoqK/ogrSveA6TLqPgYHKkfeFCgFwlOlVl+PzBG7c9xo0G2Z
   NKTmJ3isr+GTjkpx6+xSfYquYkbS9ZjkWd9EiZKuSGxZeHD0wpOvciEjW
   A==;
IronPort-SDR: fuCPtec1wfcGnaEkvy0now44kNog/oYMRmeST55/NRDZOaYlyRsOUvSGHFRbQD1XLKXFAGpIew
 wmZcf3ZqVROpynhl6o9Gpdaw2WBdafDb7zTHSaJxROmQHY7rfujvsYmHRvVUOPelcn52X/9hbA
 ywHMM4X6E3DPgt3GtZJGrp4xk2Frmw/iZAAjP4BRjexa+9FydSja876EhzIw8neVUAtR80RtOq
 Bv6T3E2ilkNerQBuEJMrzYR+XfqXueS6CUnC1S/FYlYtmpwXH8+yMXUGPGn2o5aNxlJ7qSoFGI
 9Vw=
X-IronPort-AV: E=Sophos;i="5.76,412,1592841600"; 
   d="scan'208";a="256599374"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2020 15:48:44 +0800
IronPort-SDR: foD3PA5flPh2N9A1fq8Qf7XEDWpZiA5UcjHboPFeLCURCFaPT0JlSjZeXnJuteCu1fVZ0T4HXD
 ymQ/EWRfWT/A==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 00:36:02 -0700
IronPort-SDR: fCLzOw57AfskGfrjEcWl2fiAwHvQAd+zGIB3MRoUWXt/d8RRF1Gfjmc/t6tsAF2nEgk2pvtioH
 SFmlFxxkvMkQ==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Sep 2020 00:48:44 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 0/3] Improve error handling
Date:   Thu, 10 Sep 2020 16:48:40 +0900
Message-Id: <20200910074843.217661-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A small series to improve command error hadling.

The first patch is a simple code cleanup. The second patch updates
asc/ascq sense codes list. Finally, the third patch adds zone resource
errors handling for zoned block deives to return BLK_STS_DEV_RESOURCE,
similarly to what the NVMe driver does for ZNS devices.

Changes form v1:
* Removed unnecessary temporary debug message in patch 3

Damien Le Moal (3):
  scsi: Cleanup scsi_noretry_cmd()
  scsi: update additional sense codes list
  scsi: handle zone resources errors

 drivers/scsi/scsi_error.c  |  4 +--
 drivers/scsi/scsi_lib.c    |  9 +++++++
 drivers/scsi/sense_codes.h | 54 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 64 insertions(+), 3 deletions(-)

-- 
2.26.2

