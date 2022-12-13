Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EC8C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 00:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbiLMAxD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 19:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbiLMAwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 19:52:49 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9B8E53
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 16:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670892765; x=1702428765;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xmgIncCOzlAOXgN2okMUIFQxJ4ybnbSTEIe0AuipE64=;
  b=fN2CNEMhSWA7GAGR6RlDD0RX1A9htTpeMP146pbqBok8Xt9ab+YxpT6I
   ElVQ9ZEyxCpOe8K7DdjB5SPyPtLctg5CVUnHiPmSf9o91qjD70apJ+ww1
   O7EET5xGrU7iwEZ3NSr36P3hMsnTQjjND+jfRa+JH/AOe3gSdSHmpk719
   fhX4pP3N+W3cjR6UHnvQ+vWjcHOudlWhP1gAe5ul+Aj5iEt4gfcnNUbnV
   bI2PIJZsPXFKVAO0Hz2OI0Jlk10F1GDCsquN0dO7GAKuXJbOgKj9j28Qh
   wqHmqrBGLo5ATm4cujbINDuoUHo7sqg6Vf4cVF3yOkZEBQ0CMykndwo4C
   g==;
X-IronPort-AV: E=Sophos;i="5.96,239,1665417600"; 
   d="scan'208";a="223646009"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Dec 2022 08:52:45 +0800
IronPort-SDR: coecd+IVrLzSA7IVVb5bnotCe8iGfLjKpQCNCxQAGwhw0QFLvyyWRKukXtbHdFDoWyglrs++NK
 zksCzE8DJfMnYaR0HxfQnLtOFkwO0XEmWfb2W0zJZuj82KJ9vy0lYlyP0fTW0Ezk4kiC4/txVe
 NKfftcodIYkaMJbL+omyqYJiYo6uK79bDa9Bhx2cQ+UUbqzB6gdddlzD2/GvqoskXmj+sxvxfG
 DkgnoktVLgXJiGkvFxVF8DA4UTxbLHTvirGpzp+gs57AW6i1yM8ceta+M6ldhDebtJygHycKDm
 nZ0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Dec 2022 16:11:09 -0800
IronPort-SDR: i89YCeZTvSCffmnAcjlG8qgIjQjbWwDi5OlzXqSR9KsTrFI95w0YdC+n86cCk5biiq7TkOOS+l
 918B/5XVk8jbYqRV/8rOxtGuM+M4mkyZbeqN4zlNCjwnUww7DLIqD8hprk6I9H531JM5Mnjmwf
 xtIStCdkkv8HdNK9H18Uodb/w0KAzAj22JRVtyP8VBr+TjgLg2QzLz+lsXRnGLVsmCpuaJyI4W
 iSpdo1Lxtz1YmbHtBw5gZ4vK/9uSBSEJ7ubOJ9VeK4nFux4Gn2C2Pfzj9N7V2b06ScUjs65316
 CWk=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Dec 2022 16:52:44 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 0/3] scsi: mpi3mr: fix issues found by KASAN
Date:   Tue, 13 Dec 2022 09:52:40 +0900
Message-Id: <20221213005243.2727877-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While I downloaded new firmware to eHBA-9600 on KASAN enabled kernel,
I observed three BUGs. This series addresses them.

Changes from v1:
* 2nd patch: Modified to use bitmap helper functions and number of bits
* 1st/3rd patches: Reflected a comment on the list and added Reviewed-by tags

Shin'ichiro Kawasaki (3):
  scsi: mpi3mr: fix alltgt_info copy size in mpi3mr_get_all_tgt_info
  scsi: mpi3mr: use number of bits to manage bitmap sizes
  scsi: mpi3mr: fix missing mrioc->evtack_cmds initialization

 drivers/scsi/mpi3mr/mpi3mr.h     | 10 +----
 drivers/scsi/mpi3mr/mpi3mr_app.c |  9 ++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 68 +++++++++++++-------------------
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  4 ++
 4 files changed, 42 insertions(+), 49 deletions(-)

-- 
2.37.1

