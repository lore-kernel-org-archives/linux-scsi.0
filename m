Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C05FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 23:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbiBXXbc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiBXXbb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 18:31:31 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5C02399D2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645745460; x=1677281460;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n2RwNwsjFOgtrCAZgCGl+IMKDMb+pbzVSDBukc6MadY=;
  b=k+0vrZ2ja6NTRnbfASqkilfAJ+58BgPyFTWVXPhD5x5OxIXmxNmwQVi5
   f+q5UMfIqTRPAq1YbipZyBukJ8+IgcLYrgcyiWDcPaffaUL0BSLui45Jf
   YFODBJyUcNaPqExj146DdfuMnTSO5h3wvFaDJjtCFlLYmIjGoOUcItFQg
   WOFWDQgzDY8zT5QECbbPS9UjbRBjqSpOKXSEUlyIUvPKHPPsjRAZSwx1c
   FzzOvF4DLyI9tyU/9zIs3zpZFAan3r7jvtruqj8x8IgIff3Uxfo1JLpEG
   TT8WFbGbPB2Yk3hoVcqfU5OCJqtzgLeVdUDN7eQ1kwKOqJVFywycOI3FM
   A==;
X-IronPort-AV: E=Sophos;i="5.90,134,1643644800"; 
   d="scan'208";a="192821969"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 07:30:59 +0800
IronPort-SDR: 7R5/VQ/0Xi7A7J53XCBaIeOpp8vr3pZchT9zKv8kQ9RFyanN2naLkduwFmYVEhAt4ikQEJsTO5
 cpe8zFQPe294Yl72nmK540bpZt/GM7pyqIsbMA5o3GYzT3zRdBaLfiNrHWLRBY3dWftlt5Pm3t
 ViCqCRK8PTBoyUSOY/UnQPC3P9GJ/3l+/bU7RIjcEslxfi0yENnqNRlEC7DOepvB+0IJU6SGb1
 lH3/uZHsFw7qGQYJlWiWCm0VBGfyjf7j7pAfbtFqp16ZJaGWQwsekbmf4jx+MlggRhIbUEaDY8
 bL8OamLQT/kmc+184q1uOCud
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:02:29 -0800
IronPort-SDR: vE1Oh5w47WwTY7ffC+n4zQi3zYuvG3MX91N+C8x6KMFLwwGtSQH0GNGHBQE1niKSPM2AMoIaH0
 aLcgCkIFAtXP79JKUHaB5skVJZJ69JAVT2CspfhQmdvctDYGPCUvwQGM4SLvSyOEEzYPMq2jrc
 efpDmWvXbukRTMxVdg3ZATzZX33IHNMDkZGhOrfFUmOj2vu6OnDX1BqJ3ibCJRCVBz/qKCX822
 EI4T8Sf5lYdWKTvfbI5MIfNaojhurPGNvCqVKro3IlmEMdLOS350N5+9P2ns0Q3nFWxTrJQtG/
 oBs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:31:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4Tg71mjvz1SHwl
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:30:59 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1645745458;
         x=1648337459; bh=n2RwNwsjFOgtrCAZgCGl+IMKDMb+pbzVSDBukc6MadY=; b=
        m9kF55Mg++jMfMRjf6N1+uJGNgX1Z4vhsbKissl3PryoErGBpH4H4q9E5OyPHZPP
        /xtd90ybfptG88qjqzQBqlRPxKz+oI1cctwlnMiiq59EAv9mbDXiAI/zsfy07UEG
        6HFykfy3nSrNJyeV/8iiCs0EfZBKZ3AiJwnFo9y+azDOKxxwdeVuCvgGtzM8OXaM
        SSLWxkQ43qbnvkKeqfj+ftPoZSYOblTNTaJNLb0sCiT/d9nqy3d4XdgzhYTp2X2b
        OmP6GbeYbTnNluYe2dGzFhnh3RtxD4/c4CnhiYxQCa1/PhjUz5gM10ukLA3kAujd
        gTI2Ktc1CUqkVpNMRSOiyg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NT0Uh1Wj811r for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 15:30:58 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4Tg56bP9z1Rvlx;
        Thu, 24 Feb 2022 15:30:57 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v2 0/5] Fix mpt3sas driver sparse warnings
Date:   Fri, 25 Feb 2022 08:30:51 +0900
Message-Id: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
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

Changes from v1:
* Reworked patch 1 to remove the TaskMID field type change and simplify
  _ctl_set_task_mid() code.

Damien Le Moal (5):
  scsi: mpt3sas: fix _ctl_set_task_mid() TaskMID check
  scsi: mpt3sas: Fix writel() use
  scsi: mpt3sas: fix ioc->base_readl() use
  scsi: mpt3sas: fix event callback log_code value handling
  scsi: mpt3sas: fix adapter replyPostRegisterIndex handling

 drivers/scsi/mpt3sas/mpt3sas_base.c  | 60 ++++++++++++++++------------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 11 ++---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  6 +--
 3 files changed, 43 insertions(+), 34 deletions(-)

--=20
2.35.1

