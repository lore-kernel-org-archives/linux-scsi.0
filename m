Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB082C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 23:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344054AbiCGXuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344067AbiCGXuB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 18:50:01 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4D32A251
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646696940; x=1678232940;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RNDzHdZ/YIGJ8sZZaX99ahYNQGL40k6+UhSb398r3RA=;
  b=DSkNABh1meqNt6r08dlhuxXCSM7zo5pnKz+sBX40p3A+cN13vkKe2dt6
   JZ/DMN08KnS4GeAdfeFIbhrJnEuE0t4V+yVm4Af9G8VU3i0XRBV/+w2VY
   aUWVhvEo0zTqD5mivuxJja/eEmifcZJW1EMouOwnN9bpUsdchihmtMIWj
   uTtBdJrh4qtcHze63yYUHP899ScEbY7Djw4PzCtCWHrdeFcbt8vsIup/7
   okPULUjIJ7hmIBUACKH0YrbyzihYzm1fio0yb+8wktod6gbZdHKKgUj8Y
   HOopktoKqfmG/nhsFqzSLBfCkqooPq1QXFPvUjraiHzUDEFUTNJc4TeJ4
   A==;
X-IronPort-AV: E=Sophos;i="5.90,163,1643644800"; 
   d="scan'208";a="195659148"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2022 07:48:59 +0800
IronPort-SDR: Nz6eXl0ok8BUbG+vOlEaHPvSR4UuzU4WIG7IdsL4vQswtU0arO18CWw40jIo4L1ZECk/ht6cjv
 Iqvk737rSndjfyeSnsXoPg38IAkNZgzuDFETuE3rvH7P/01bghMMIrreR778PWcb1VntE6/8bD
 74Ejq13evp2WJhM1FTtjIloeDFvPjwvgZWURTPyNlpZPxeBPSLRhcAfcJTO/n4cYdS504r2iy/
 V6IY2GXKgoL03eJ8aRZ3L1mheO0W72HoAq0riXyEqp42/qu1IQWrHzrVWU+5baeUTJfIf/y6Uv
 raIalbM0aok1B6mjJlArIFtB
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:21:17 -0800
IronPort-SDR: pV47Sikyunb6F62xi6x2GsPK0R0V7T0GVQfbbwvI3AoQW7uwbzLKRxWLLMqxmc6o5l2hga4l1f
 5glJ432ecyka5Z+qIOC7BmtH6PIpH7b12gr/z4Lk2WVBcqSm5jgYuUajxp8V+SAk58yBsoSdXM
 FBrAJXbrcw9ukxKEvzrQelB3f2mYae+2GMZFPptiefnZVX93REx+xglJjdvfXHtoJXjZVJvEka
 BOkAufCVIpGderlNHJz7GMvjkex3zkmz3WPqHjHfj1wua9DncPAz5q4rGK1zo3XOxZ7BTePbgo
 nmY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:49:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KCFXp5FRgz1SHwl
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:48:58 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1646696938;
         x=1649288939; bh=RNDzHdZ/YIGJ8sZZaX99ahYNQGL40k6+UhSb398r3RA=; b=
        F/kNiHi4JFc6ksLGcVqWOEq1Pnn23n0lmUP/WxIJ3rEgoiELYZr7OdeeFVe4ogAy
        l0yKRZeYJsWi0Lih/jRuSmEfbPDm4IEvDtgIX9Z1Hzkvx4ogxswKOZuPyUIz/ZgN
        6iEXJFZJR16VgulnAyXtet0Ekwo8MHtHdWYw5qzMa72iGZ1P5VaBkUbK3rD7u2/q
        JUtRJNpuH7eK0EZYFS7npjLk3loRq3IwdaolaqMo7MgSc2dGll3EXSDrgQ8sZhMx
        nKwcpCVEp6Ks/Ts/iP5XVG8wuFsCPuq4CzPrSJ0P7gl3wcuM8uS0R6EVGuIo7krC
        RNEpUfzEmLw39N+9fwm3lw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id pFQZUoQkK9hz for <linux-scsi@vger.kernel.org>;
        Mon,  7 Mar 2022 15:48:58 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KCFXn0YZwz1Rvlx;
        Mon,  7 Mar 2022 15:48:56 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
Date:   Tue,  8 Mar 2022 08:48:49 +0900
Message-Id: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
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

Changes from v2:
* Reworked patch 5 to keep writel() calls. Sparse warnings are
  suppressed with a declaration fix.

Changes from v1:
* Reworked patch 1 to remove the TaskMID field type change and simplify
  _ctl_set_task_mid() code.

Damien Le Moal (5):
  scsi: mpt3sas: fix _ctl_set_task_mid() TaskMID check
  scsi: mpt3sas: Fix writel() use
  scsi: mpt3sas: fix ioc->base_readl() use
  scsi: mpt3sas: fix event callback log_code value handling
  scsi: mpt3sas: fix adapter replyPostRegisterIndex declaration

 drivers/scsi/mpt3sas/mpt3sas_base.c  | 32 ++++++++++++++--------------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 11 +++++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  6 +++---
 4 files changed, 26 insertions(+), 25 deletions(-)

--=20
2.35.1

