Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAFEC38142
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 06:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjA0GfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 01:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjA0GfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 01:35:07 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD7939BA2
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2023 22:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674801303; x=1706337303;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nwKznvD6dbKI35zvKvqJtPOUBjGHohPyaViEME9Pg7E=;
  b=rDw25AvBII6/4ChV69KcTS9VpxPSr3+hgIN3Wz4t9a7mATcQrKdGl/n5
   BHGWjxNFOah/yayIlo+QdRu6CSWWGYB7fCcqZULJHoeMPweCG4efs+NwM
   +uwlrMaQiBifasZXLpXfEmD1O4bCqQMEbBrrj7bNv7q89b2dQspKpgnIm
   FMr8ZVrscXNZgMk6s7qKru5dkmzwqTZ8IR0QTSGpa8qUD9Rpp6fqbTpeM
   5hkfOr00xxNlRlNCuhcAmOBi6wlrNU4Egs/6EKmuSmH8UG58ZzXbthuM+
   P02j11q0x0u9uIMDF5sRKWKkz6sDV0HZCx0W4YIbFPfxxDGNVbtrVGpIb
   g==;
X-IronPort-AV: E=Sophos;i="5.97,250,1669046400"; 
   d="scan'208";a="221934993"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2023 14:35:02 +0800
IronPort-SDR: twFs8XEs8rjE5FGHAuH818SVkkeCudxgjYNC+gwJqK025PHE0ON3kpyUihg6t2B8WN2+3wezqD
 jiS0eN9IIJZlrK6exQrgnPOy7ai915kg/HMcheETNcfNNiL/XAviutiPg5smeLOYEqdgF28wvC
 uhCnnaUKtct0sqAmGzWZwlJ2P21qCH/4F+MK6Gp9ik8rJmAb/Q8d3cfSer1LBKybLq0ostmk1F
 XW0d2CjhCCxRexbVoTQEBatEq/GNEc1nrhkP3R/GHfkyQMsrJ3Srxhxm/GhSVQ+www4WQQvUgv
 +Us=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Jan 2023 21:46:47 -0800
IronPort-SDR: 4rpYdo1DnNQyG7TtEF3cxFL0w+6THb8eySndlWfwMz+Tl+y40EjVpwZnz+VxWkQ3+eFCZcOWY1
 32tt6BqnWWV7KI/TtBDz8hHdd5UgIYFcn1Svvd1ofz3e8KO/32I2hjJ8UEBdTrpHvZ2Ojoqb8e
 PNx0XCLyf4ctIh/U3aE4RsZ25yqxKj8baV6A4MAFwdkjWG1q21+Q664ByqIIrXfGeYwknbJ6Qa
 3R6XmFzBjpRtJxG7wYoHPv+Yzvb6zIAx8fTuK3KBYIr1diDqXRJ7a643fsgeS83QIeI9zmt6FA
 Xc0=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 26 Jan 2023 22:35:01 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 0/5] scsi: mpi3mr: fix issues found by KASAN
Date:   Fri, 27 Jan 2023 15:34:55 +0900
Message-Id: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While I downloaded new firmware to eHBA-9600 on KASAN enabled kernel, I observed
three BUGs. The first three patches resolve one of the BUGs and related two more
issues found during the review. The following two patches resolve the two left
BUGs respectively.

Changes from v3:
* Moved 1st patch to 3rd to resolve a compiler warning

Changes from v2:
* Added 1st and 2nd patches to address issues found during review
* 3rd patch: changed fix approach per comment on the list
* Added Acked-by and Reviewed-by tags

Changes from v1:
* 2nd patch: Modified to use bitmap helper functions and number of bits
* 1st/3rd patches: Reflected a comment on the list and added Reviewed-by tags

Shin'ichiro Kawasaki (5):
  scsi: mpi3mr: fix calculation of valid entry length in alltgt_info
  scsi: mpi3mr: fix alltgt_info copy size
  scsi: mpi3mr: remove unnecessary memcpy
  scsi: mpi3mr: use number of bits to manage bitmap sizes
  scsi: mpi3mr: fix missing mrioc->evtack_cmds initialization

 drivers/scsi/mpi3mr/mpi3mr.h     | 10 +----
 drivers/scsi/mpi3mr/mpi3mr_app.c | 18 +++------
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 68 +++++++++++++-------------------
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  4 ++
 4 files changed, 39 insertions(+), 61 deletions(-)

-- 
2.38.1

