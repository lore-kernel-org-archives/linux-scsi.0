Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422A0C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 01:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbiLLB5M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Dec 2022 20:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiLLB5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Dec 2022 20:57:10 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361B0D10C
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 17:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670810229; x=1702346229;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n9f1SgNTbnHGEr/6iwP3K6nkX4v+nMh3XiZZt1q+JHI=;
  b=E1XRtG6c3JR0x2uUsXiHZXPnG3Euk4EwGZW2hus05/UIBvpowSL6xe94
   cMm9XIwYSfBc4dwOCgHuUNkqALFZGUGJwSdCfI9RBJnZ2qUBSoPbBGwdx
   WYlK8Jq5lFDfxJfkSgqZsiZd/5m+BozVsXOS6GiDq0qwD/QJxlL8CdVOt
   +Nuk/yDoY57qeFCJplqMNB/kPq8XY19QsZrLDU1T2ocvy/1oeBkzJDW9p
   dmlo16U4m3CjnU8BpIduHK5REA74f+vltoPbyuVM+VT+F0iFWqnxXl7rN
   kPdHD96XJPMGWvjZy1IPL7hcOjUs0ELjr7R+SWgYvOlYFN2xMHx41JqCk
   w==;
X-IronPort-AV: E=Sophos;i="5.96,237,1665417600"; 
   d="scan'208";a="218660138"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2022 09:57:07 +0800
IronPort-SDR: YpPkcJXFkaREXzPRkjv78WWTOoAUWRBmY/70jh42Dzj8FLVzhMLQHMyg/mAItnJPI8emVjId4L
 B40A+6FH1tC12Bn4xYeJNl6TYMlkGEdoYWo46icJ1Tc7o7SOz5PWWY08hcIKwm+0cBjTETXzda
 dG0Kawe2fJNjeKhWh0IuMCBfvKXx1M3+eP/DZTpZsAERsuZ/hOhD5eBTocR2R7IsoKj7qM08Ev
 Cpjui0xgNoebI/TL8uOFnwQEebSRg6huYq7wJm4s+DnE2f4OF7KQofq1ySt9iwCOTnhKJZxnHR
 5l8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 17:15:33 -0800
IronPort-SDR: c81DCDhaBt/g8b93+LdX0LzatHbSICEYkJCACT+3TnlHVv4tC7TF43s8OpcdVctXrFNOS8vD/M
 WBUJ2Jb+8DSSNtl9kU4pjSXFyVOl3RzCoNbZj2Qiu0Eyb1O6paU6OfJmiG7iVV+hHfVZ/ICjoN
 /knQLcAlF9i3oE6x9amIjf5QercbWYG41bhs6UdGloI3ULzV/18qG9hxR6VsK4k95ir0O6s0S5
 ziwfBFSsRUqKFyzAZ+neZ2Go6T3CgAKJ+Uj3rCG/xblAd3Zmr9OvMF++jQ2KGEMokPJzhaBEnV
 Pck=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Dec 2022 17:57:07 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 0/3] scsi: mpi3mr: fix issues found by KASAN
Date:   Mon, 12 Dec 2022 10:57:03 +0900
Message-Id: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While I downloaded new firmware to eHBA-9600 on KASAN enabled kernel,
I observed three BUGs. This series addresses them.

Shin'ichiro Kawasaki (3):
  scsi: mpi3mr: fix alltgt_info copy size in mpi3mr_get_all_tgt_info
  scsi: mpi3mr: fix bitmap memory size calculation
  scsi: mpi3mr: fix missing mrioc->evtack_cmds initialization

 drivers/scsi/mpi3mr/mpi3mr_app.c |  9 ++++++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 25 ++++++++++---------------
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  4 ++++
 3 files changed, 22 insertions(+), 16 deletions(-)

-- 
2.37.1

