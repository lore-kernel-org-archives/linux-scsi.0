Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E958C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 10:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiBXKMI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 05:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbiBXKMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 05:12:06 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAD717A92
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645697496; x=1677233496;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XPY3G3y4GxNnPiAJ3NsSmzyXudU7m5HrXYjmEpz2kwA=;
  b=NMsaYs0NjRQosMWT+JvvAC5F+mCcfOUNg78WXpn8gNO+gFKOURDnFYM+
   RmLBA9a2kHhzmYJG63jXs1Ww7x8f957Jo5QsTeCN5UQChClqi/hDuUF5E
   +Ub4/L1eoL535DbOqgjwNG6zdGIGyJ5++Ri5nRMAhtQy/ELZ4zBWjGOQO
   NuhDaAR6CSq70hPRr+GQ0OsBlyOYeYAiym3xs4/eY1jRtgL1oEYddrpoZ
   TTgUMBmiGUrSlwsQuOvTbQxYPXtOTyRC4VLbjIh9brJJSIIgvRKMm+DAp
   BecQs2AQeqajt6AK3l22zKPp8mUdg9ojNQ37OlbM8gWp3a8WK6bxLjo8g
   w==;
X-IronPort-AV: E=Sophos;i="5.88,393,1635177600"; 
   d="scan'208";a="297965108"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2022 18:11:34 +0800
IronPort-SDR: KLumPtSWHWGzAAXkfWgaU1YQXLpdnRbiwhP6vSyLzKpG5WotUfKe1f4/4NzExtqUR8ip8Q1YWx
 aTjn8P54sZjzVapJNPOh88Orb71jYRr4iS/GqTDOgGu+hg3T8Aihkz0nT3XryfqwfjJa7Lh8DE
 R8iZMo0IU9ErMy4eWXKiL1oUvZ8q1SxuMtSSiRgHMPs2pES7y+/jsBH4/uogVUArjqfK5lkRFE
 Z5AdUG9yfty7awUsw1nFHFWKGwX8J6aXmXiNpvsfGIOOX9knTWG/rHlIVTWtPxLiOBs4p7H9GF
 kygAxqt8EM9WPLRef0xqIL+B
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 01:43:04 -0800
IronPort-SDR: FdSBsP+TQzDsXL9VwwyN66a1FEwUpOcdrYJmiqVC+zML2ej4FbfAE6zkt5lzuNdYNFOfxjrkIt
 ON3pXhmyQkMfh5wuPpYxOlQKMwTSn7RdYCo2AbM7wmNuMXLbyWi1QiXy4RESsp6MsUDE/NI5UH
 LIrm2KiOPU9peD0DrcqfzXqjAjaTq4hMSlaehoRmbfc2KguM9Feuvunmfzn5Pnn0udOggZkxv1
 076ShSVGjVX+PGCXVoVhqDxKxQUcllhVOnNfX5XpRueABm1Vlrz//uUxYSYOchbthDiiLs6JPe
 6eU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 02:11:34 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K47wk0zTLz1SHwl
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:34 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1645697493;
         x=1648289494; bh=XPY3G3y4GxNnPiAJ3NsSmzyXudU7m5HrXYjmEpz2kwA=; b=
        p0NFpszLWmLio3MCKSh3TwE7X3kKPhIT33wifHmTMuG3z9o2DbWTM39ctsAc802L
        BFhsY9O9XZgePR13ll/lYhV8vkfR0iRue2ZbojydOiF26m73651lv+zL6oxvxDcQ
        cKpwyznEzhmRBpLh57+mniQWWcHySLT/Jz3qRgOqRpwNH3V+LofQPQf50vhok1UU
        Ghrmx2x8Kmf9vY9nX0YK1gchgMzAjUIDhZ+MLJjPfRSsUPVuDAF2iiY3jh1MU5kv
        e+7yuqHwQoEWBPy8W9/ivEKKT22ZQTiw+U/M1wrUJLaWuk85r1caGbHaICumWZSV
        AG4kIHPgyr94gFaSpuCjhw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id y0Q2v_ncYrW6 for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 02:11:33 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K47wh5PQqz1Rvlx;
        Thu, 24 Feb 2022 02:11:32 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 0/5] Fix mpt3sas driver sparse warnings
Date:   Thu, 24 Feb 2022 19:11:24 +0900
Message-Id: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series fix (remove) all sparse warnings generated when compiling
the mpt3sas driver. All warnings are related to __iomem access and
endianness.

The series was tested on top of Martin's 5.18/scsi-staging branch with a
9400-8i HBA with direct attached iSAS and SATA drives. The fixes need
careful review by the maintainers as there is no documentation clearly
explaning the proper endianness of the values touched.

Damien Le Moal (5):
  scsi: mpt3sas: fix Mpi2SCSITaskManagementRequest_t TaskMID handling
  scsi: mpt3sas: Fix writel() use
  scsi: mpt3sas: fix ioc->base_readl() use
  scsi: mpt3sas: fix event callback log_code value handling
  scsi: mpt3sas: fix adapter replyPostRegisterIndex handling

 drivers/scsi/mpt3sas/mpi/mpi2_init.h |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 60 ++++++++++++++++------------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  3 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  6 +--
 4 files changed, 40 insertions(+), 31 deletions(-)

--=20
2.35.1

