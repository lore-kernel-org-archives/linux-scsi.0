Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB965C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 07:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D704610A1
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 07:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbhHTHFd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 03:05:33 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20629 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238658AbhHTHFY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 03:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629443085; x=1660979085;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n6gFA+7y+TftSYEl9+KGO/2iFsFKcWn30Vtzn6Mgqjk=;
  b=neE0uUryPn4oetxnML4NYpF1ac3JJn8pDLHTAh+c6mbElQDsn5DbqkfU
   aS3I2RGr0izTS7C9aSKjhTdAwEjYiqnPscGO3ZPBp5N7fZbxdfAmhMIZU
   jSPQl9woifGBvICWKpo0EN9R/ZNtg2xsPFMw2mpTiDeXc/brQtIAkSvrg
   L1Mkuqhj4v7JvnBSdD+/mfWanUHMKtHorjHnPUzilcWY0uHDarz8v7A4y
   Ez1SnUyKEPSdr6EnrQRmrOBE6a7geBHS9Ktvi1XvgaaWV714HtzAvBSnD
   Q0m7JBzRkozwLwkvqaDNxaWz6kQmYVnHBvXpv6eq0ixZPM/S/diLxjTW+
   g==;
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="182663594"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2021 15:04:35 +0800
IronPort-SDR: mt0dwWuaYG1v4zRm80RpFV4JBanMX3riZ5gdCNxy9TH52lrUDCnlWqZG/M19LVVzh/O0A7UvE3
 6o514LieFr6do4rYyL5wjljtRs3pKD7kS4oe/xoTO1l0CWbanGga+VozPywOwXTEjF4RUnmZ3S
 oz9VooAVAS5nJWOhADZHYygbk2/dMtXygrgWjEMuSvQyqTBo1iFM99Q2UfXtW7z/oL3kOc90GJ
 y1k3Cu3HAXxokGdTSRDdUcNPrhnGfbFEwbDAYZokorI4ZfysVUqYJI1x7Resm7VWFkx0m09X64
 CO/R0H7IVwdmCDX/AykQB0Xm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 23:39:56 -0700
IronPort-SDR: 97zK79OMlqglODkhXkL9GhBcYame8W2b39AAy/wv3Ec7TYO7tMnC+vgC46Qq+j0AU/xqrNxCxj
 csYZ7Qc/a6zurB/Aenw6jYpwwnHp7oHvM9/b3yxMNvOu5wNrj8YkmrDTc0onEpERrYsj9JgGDE
 Kec2ukHK45+Wt65TyMapO9j0TraW2xObPs8vTHTilL4urrjUJIn0DqbnOJzQF8g9n8+NAfJQJB
 7tz33UGDAKyS13jkDdWgn6kFsdX08QvmiY5TAe1frhUsrIT91CiqO1FQ3UEvPfS9XbfmC884fd
 HcE=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Aug 2021 00:04:36 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 0/3] Fixes for scsi_mode_sense/select()
Date:   Fri, 20 Aug 2021 16:02:52 +0900
Message-Id: <20210820070255.682775-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first patch in this series is the formet standalone patch titled
"scsi: fix scsi_mode_sense()". Patch 2 fixes similar buffer length
handling problems found in scsi_mode_select().
Patch 3 fixes the use of scsi_mode_sense() in sd.c to ensure that calls
are issued with a sensible buffer size for devices that explicitly
requested the use of MODE SENSE 10 (e.g. SATA drives on AHCI).

Changes from v2:
* Added patch 3

Changes from v1:
* Patch 1:
  - Added check on the buffer length not being larger than 65535 bytes
    for the MODE SENSE 10 case.
  - Automatically try MODE SENSE 10 for large requests even if the
    device does not have use_10_for_ms set
* Added patch 2

Damien Le Moal (3):
  scsi: fix scsi_mode_sense() buffer length handling
  scsi: fix scsi_mode_select() buffer length handling
  scsi: sd: fix sd_do_mode_sense() buffer length handling

 drivers/scsi/scsi_lib.c | 46 +++++++++++++++++++++++++----------------
 drivers/scsi/sd.c       |  7 +++++++
 2 files changed, 35 insertions(+), 18 deletions(-)

-- 
2.31.1

