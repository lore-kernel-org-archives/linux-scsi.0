Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA73CC5517A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 20:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5291A208B3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 20:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="joh09mAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgKKUYf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 15:24:35 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:2470 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgKKUYf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 15:24:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605126275; x=1636662275;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+TT4iowGNmAQgAk14YRmZouamJuhZea9ISqlDmxz+9Q=;
  b=joh09mAgkuidbhRQGoi/6qJUCJ/VWUhMf+D+QqfELTC+hI1h830sm84t
   9Svl5b5FbCpD/7coDN/9FOQZh8ILzpvPKIOiZpvcxMNCMlOu0K3fhDp+u
   1mStCs6ypXz0VN/VYtXNzLfNFX8MoX5f5FCNXCd1hdUvxjbQF5LkmGy03
   wdTDEoHzyRIE+eqCUVqqivA937rXVQT2geHXt83O2QFQ5O8OWPUkjUl61
   Bvb2xo48bj4TSdn8u1xgim/91iCqBArq33mZmf9V7znDcp17altnlaJbv
   PzfAIU2kacplWxoKlNCvaGO71iFKWBU8Rb7eIEhSgfFF728+pOO2KxXtz
   Q==;
IronPort-SDR: +os/r0jFCP+22C/A4JJNpE3LFnijLb9cDFH2M9rPK2KW9fFk2yjY4evGmppcVKZKUqUBOYmhH7
 IQdQSe4yfW2nFLvpeVWbnfyX1lUUCYyHyc/5RyNqUIR6ELIeSk8Zs19OwUREkNYZGldjDzM/FL
 NjkFB0W5ri46d5eJ1smjsg2MfYlyQO3hAm4wV3Zbx5I3sWPyo3M9GrAlDlyLcrzaY/5aD4uFAq
 TK+GUSXuopCoTza3owXP9oTGknDcfAmcEPcEdA9axVTyx/Yd9gE0xr5uN9qRbaZMdDoFgEDq23
 Ac4=
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="95973016"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2020 13:24:34 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 11 Nov 2020 13:24:34 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 11 Nov 2020 13:24:33 -0700
Subject: [PATCH 0/3] smartpqi updates
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 11 Nov 2020 14:24:33 -0600
Message-ID: <160512621964.2359.14416010917893813538.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

This small set of changes consist of two minor bug fixes:
  * Remove an unbalanced call to pqi_ctrl_unbusy in the smp
    handler. There is not a call to pqi_ctrl_busy.
  * Correct driver rmmod hang when using HBA disks with
    write cache enabled. During removal, SCSI SYNCHRONIZE CACHE
    requests are blocked with SCSI_MLQUEUE_HOST_BUSY which cause
    the hang.
Also included is a version change.

---

Don Brace (3):
      smartpqi: correct driver removal with HBA disks
      smartpqi: correct pqi_sas_smp_handler busy condition
      smartpqi: update version to 1.2.16-012


 drivers/scsi/smartpqi/smartpqi_init.c          | 4 ++--
 drivers/scsi/smartpqi/smartpqi_sas_transport.c | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

--
Signature
