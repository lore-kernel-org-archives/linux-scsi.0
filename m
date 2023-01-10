Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00489C5479D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Jan 2023 01:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjAJBzo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjAJBzm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 20:55:42 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A593813F76
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 17:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673315740; x=1704851740;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PP6aBljpJFcyVC7Z021lhlqAEieWgTDChKGf1/C1pi0=;
  b=hg4S0WnoY5jHJn376s4+DN2VjlYEblRT8tlVd23jh8gOwF3ftQj9i+aw
   /+kbqeDMzzJzSJ1wX5WRmp/jpWiL7svX4AWMR6PHiwOnb8nJ9Rg+fA1W6
   43PrvKkJvvFpP3cl6PsSWieOj4xUmagdXx9d9HaDmEe0qqjaX4oIJDkjA
   nhHuWBKW8NKtpJPdPbc0Q5TfdKnhDmXk1Jia5NwxazppM+J1YxbfeV+/1
   5CzLF5npAH4M/uWfViZ5vKNIwGL6i+LB/5zplAGDPS7UBNZlzpM/EFgTm
   nthTDfj8V7BdfoNCU/+xizkDWdyc/VifG+3sfHEsOm58CdHHV1fvFGmaS
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665417600"; 
   d="scan'208";a="324698277"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2023 09:55:39 +0800
IronPort-SDR: yzV/Qq/3DNOFqTRgIebmZm3sCVpWdyDwHt1FeOZdXb/ZmrQv0xVCNLV5nq7E/AmGox+YVB2FtG
 NmdQ7z295dxLvw0d1nih5PdZGdQ9Qou/uTROm8mxu72twxlZuZkg0l0RE2GbT5vaToLOQ09yDM
 rixNK3HkLhfN6wkGQ6QBMtznK2JOGB/xQuYb4neABsecy5b/X68H7Wwi11w+ryPnf4bHr8VtVc
 y9MeMQXkQge3U406UuOR0XBJUuuM/w5CxLTuO6gojQFmlTi31YqtT/yx9NyoEqlBuAWAJGE8bO
 +rs=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jan 2023 17:07:45 -0800
IronPort-SDR: c9gcBu/BQ1w6z33nTxIQiBnxF6sRnFb+E/XUZApdiR1uyYDYjy7I3T1Oomyfo7aCxDhNcEe2zK
 fLme073P8h/OSvZankdePIiLpW1yVB4YLDjkeiLKKTFfudIiE+qoMK2AX9h4zV1vNGv7g9Cdg+
 8avWxNsVDSOVb01y4ogdNmf1rSynBJvcOmDMQJbc27lJnZLjAEKw9izL0EWsTKFpao2VqeQHOH
 qX94wMUB1Y9ksrreQM71POdAF1cpD9lDoiPcPf1nWyQaRipTCLltMqG1Yb1Y9WZa7/Vfq31iAU
 15g=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Jan 2023 17:55:39 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 0/5] scsi: mpi3mr: fix issues found by KASAN
Date:   Tue, 10 Jan 2023 10:55:33 +0900
Message-Id: <20230110015538.201332-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While I downloaded new firmware to eHBA-9600 on KASAN enabled kernel, I observed
three BUGs. During patch review for the BUG fixes, two more related issues were
found. The first two patches address the two issues found during review, and the
last three patches address the three BUGs respectively.

Changes from v2:
* Added 1st and 2nd patches to address issues found during review
* 3rd patch: changed fix approach per comment on the list
* Added Acked-by and Reviewed-by tags

Changes from v1:
* 2nd patch: Modified to use bitmap helper functions and number of bits
* 1st/3rd patches: Reflected a comment on the list and added Reviewed-by tags

Shin'ichiro Kawasaki (5):
  scsi: mpi3mr: remove unnecessary memcpy
  scsi: mpi3mr: fix calculation of valid entry length in alltgt_info
  scsi: mpi3mr: fix alltgt_info copy size
  scsi: mpi3mr: use number of bits to manage bitmap sizes
  scsi: mpi3mr: fix missing mrioc->evtack_cmds initialization

 drivers/scsi/mpi3mr/mpi3mr.h     | 10 +----
 drivers/scsi/mpi3mr/mpi3mr_app.c | 18 +++------
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 68 +++++++++++++-------------------
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  4 ++
 4 files changed, 39 insertions(+), 61 deletions(-)

-- 
2.38.1

