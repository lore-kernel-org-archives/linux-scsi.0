Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364DBC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EB50206B6
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lbPUSeph"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgEOKan (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:30:43 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:1761 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbgEOKam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538642; x=1621074642;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o7LukU2Qt8mBDptZ6K08cMj4vRtNghwuVW5bvll2xw4=;
  b=lbPUSephByH+N8NI+TVZYx/PqmXBWIVBRaohQifHdopDpa5UzH0GeXQE
   jaDv/+tnIRFk7xj4hcWgHZs2t6lZNUTEq9j05Sj0ocNHZHLY9FyTO0cm6
   /rAPoQNGLg+EJ9v32qPJzOZv6lGSRESnULjjrUIYfvlOM/bRq4I0zB/5H
   w3ZEZ4XMgYm/xBEGo2J7bBm4DwxCXFFCM+S+Bd20j2EgG9kxWkA8sJp6u
   QAS9RIO+FiL0rs/iKToQ4BxLct2nQz5sYP/xN0rZzW3KbOcQu87EJAhwE
   N7UUgqv1fOk047OcRDhibCKV8t6yWR99R8FaompyBFQf/CbfVUqP4Fvc1
   A==;
IronPort-SDR: zvVBI/EeaLCDA0F1PyfpYSz1CiAjUxkqyzwubb4Gh0m8VK18yDYQ819ZTLkJGKT7sk0h/IiFTI
 PlVAb2yUQ7+bPU5WltOiovXs2/3HGafvWNM2D1bypXaEnEOJZ3PxQWaS6KrozlJqFoJY6Bpfes
 EBQZIiaPJOcv3+/i6ql32wd3JkCRgBJDbntO0dsyrNlTGGGq7Mki0WjUMYIEVWyo+lGnYyFiBn
 YCDuCmKrhPoC9olD7RCCll8Q9duGWQVjAykwgaVSS6xmLTzKK9FOOzkQv8kHrNHQMSEVbU9URW
 /wk=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="142113510"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:30:42 +0800
IronPort-SDR: Fwb0ab/VyHwp3+SPJdPAXnMiJ/e5lb1aLJoKyKJfub6NepU/3pmQeVBXlVvFVmaLKTJjbL+9mc
 OdPH2cGjJTjdTivV81PJ3KHap2PyMjQWQ=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:20:53 -0700
IronPort-SDR: i4ERIrb89w98U8sW9N+c2RKf5lovbDNHYGTpqcap92I4qeW0Wfeb8XXGmZ2Z+prwUMnCH9X4+6
 YBWrAAVbZHNg==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:30:38 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [RFC PATCH 00/13] scsi: ufs: Add HPB Support
Date:   Fri, 15 May 2020 13:30:01 +0300
Message-Id: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NAND flash-based storage devices, needs to translate the logical
addresses of the IO requests to its corresponding physical addresses of
the flash storage.  As the internal SRAM of the storage device cannot
accommodate the entire L2P mapping table, the device can only partially
load the L2P data it needs based on the incoming LBAs. As a result,
cache misses - which are more frequent in random read access, can result
in serious performance degradation.  To remedy the above, UFS3.1 offers
the Host Performance Booster (HPB) feature, which uses the host’s system
memory as a cache for L2P map data. The basic concept of HPB is to
cache L2P mapping entries in host system memory so that both physical
block address (PBA) and logical block address (LBA) can be delivered in
HPB read command.  Not to be confused with host-managed-FTL, HPB is
merely about NAND flash cost reduction.

HPB, by its nature, imposes an interesting question regarding the proper
location of its components across the storage stack. On Init it requires
to detect the HPB capabilities and parameters, which can be only done
from the LLD level.  On the other hand, it requires to send scsi
commands as part of its cache management, which preferably should be
done from scsi mid-layer,  and compose the "HPB_READ" command, which
should be done as part of scsi command setup path.
Therefore, we came up with a 2 module layout: ufshpb in the ufs driver,
and scsi_dh_ufshpb under scsi device handler.

The ufshpb module bear 2 main duties. During initialization, it reads
the hpb configuration from the device. Later on, during the scan host
phase, it attaches the scsi device and activates the scsi hpb device
handler.  The second duty mainly concern supporting the HPB cache
management. The scsi hpb device handler will perform the cache
management and send the HPB_READ command. The modules will communicate
via the standard device handler API: the handler_data opaque pointer,
and the set_params op-mode.

This series has borrowed heavily from a HPB implementation that was
published as part of the pixel3 code, authored by:
Yongmyung Lee <ymhungry.lee@samsung.com> and
Jinyoung Choi <j-young.choi@samsung.com>.

We kept some of its design and implementation details. We made some
minor modifications to adopt the latest spec changes (HPB1.0 was not
close when the driver initially published), and also divide the
implementation between the scsi handler and the ufs modules, instead of
a single module in the original driver, which simplified the
implementation to a great deal and resulted in far less code. One more
big difference is that the Pixel3 driver support device managed mode,
while we are supporting host managed mode, which reflect heavily on the
cache management decision process.

Many thanks to Damien Le Moal for his insightful comments.


Avri Altman (13):
  scsi: ufs: Add HPB parameters
  scsi: ufshpb: Init part I - Read HPB config
  scsi: scsi_dh: Introduce scsi_dh_ufshpb
  scsi: ufs: ufshpb: Init part II - Attach scsi device
  scsi: ufs: ufshpb: Disable HPB if no HPB-enabled luns
  scsi: scsi_dh: ufshpb: Prepare for L2P cache management
  scsi: scsi_dh: ufshpb: Add ufshpb state machine
  scsi: dh: ufshpb: Activate pinned regions
  scsi: ufshpb: Add response API
  scsi: dh: ufshpb: Add ufshpb_set_params
  scsi: Allow device handler set their own CDB
  scsi: dh: ufshpb: Add prep_fn handler
  scsi: scsi_dh: ufshpb: Add "Cold" subregions timer

 drivers/scsi/device_handler/Makefile         |    1 +
 drivers/scsi/device_handler/scsi_dh_ufshpb.c | 1480 ++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c                      |    5 +-
 drivers/scsi/sd.c                            |    9 +
 drivers/scsi/ufs/Kconfig                     |   13 +
 drivers/scsi/ufs/Makefile                    |    1 +
 drivers/scsi/ufs/ufs.h                       |   16 +
 drivers/scsi/ufs/ufshcd.c                    |   12 +
 drivers/scsi/ufs/ufshcd.h                    |   11 +
 drivers/scsi/ufs/ufshpb.c                    |  610 +++++++++++
 drivers/scsi/ufs/ufshpb.h                    |   28 +
 include/scsi/scsi_dh_ufshpb.h                |   67 ++
 12 files changed, 2251 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/device_handler/scsi_dh_ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h
 create mode 100644 include/scsi/scsi_dh_ufshpb.h

-- 
2.7.4

