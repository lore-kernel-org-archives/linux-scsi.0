Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8243C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9227161969
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhCVIL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:11:26 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12205 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhCVILM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 04:11:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616400672; x=1647936672;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=M9B+T6NP4VTcZo6shen4nu9/vYqPVxrW2VIVN0TsWbk=;
  b=jKdQHZz8059OxhcLiZusgw+F9uX7BOweqHoZHWht9pdEL4h4NMLzRMkQ
   ZnPF3tIKD4G6MhMJAmRo0SYnHIVtglhqiItX2z//B8QTe8wRqZWgKsUAN
   8O4Jgm0k3pX5EeSz8+DLF0UmR2/QhvgYjDB2X9uUaJSdwEIfNcM7xTUrf
   sohLCncRZCsqHwKZ4H6C/9RjgztRyG+aGbmCcCYF9Qexa9mzySMBuOJfX
   j1gvWqokH25EtXQ/zXJ438hHsj4rUuFdOzEtGI4XF9cRyXkM23SUYEsA9
   pp36fIhs5gSrYnJ76NXFC4TXz/T1R28X7yw4olN9KlI54+tc1k1Vjfnld
   w==;
IronPort-SDR: mOeTO6Ar54t/p0w9l+fSSJfeS/x3zQgU2OWn8vMyJ9YS3KnN185Q9u95f0XnBhCr/wMs+/HJxM
 TyY9FbLuQeSkQloQP4Eleyo5cohG9AbunjxDTEvvPaBs7agjuGp2NBEcNirRe1vvRcpwvtIje/
 PwS/5DkDvjeCe+cUM3fzFdYxWKizXTo0syvsdhaRTE5liBQZ9ADzpaNKI6UJLUwpAql31TXf2f
 503OMk1ACYhDEfUraCBDe1WPSgF31WL7WzdR59qgl34eQvWzpSXzwsw+AkCbHetq50YcpdYlGo
 kEk=
X-IronPort-AV: E=Sophos;i="5.81,268,1610380800"; 
   d="scan'208";a="162682951"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2021 16:11:12 +0800
IronPort-SDR: sDSMa56o7VRtuE4kXLwNkqTR2WF62ljVfWSLpne0lwURrOXAlGlQ8L4Ch6osU+PX5yX51Ke5B0
 pw05k2jhuf3ziSxePaIjIGRvyKw+GhzE/TAAZxasHjjW266fwzqBB8Ro4kFqDscXsk7c9/s3Q9
 ZFL2H6bX+irGTlDg4cAXe5zTm7wNopQnoG3ZfNPz8UYZKKqP6xOhnweGQvRGsdcSmktOElHm97
 kGTm2JqpYax8c6KtH9yeetT0EPd6UM24RUe9kvmO82qdcm9La4okZYPCPSostWoHli22FGWBLj
 k0GZTdPo3LvoIgKZrYZHqZsD
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 00:53:20 -0700
IronPort-SDR: JhqXmCR4eTIKFEtA/g+1Vqgq+iapDu+AMbdXp8fgIDhLH62IwpqF7hiV5hn9hodnCu0NU2CHNz
 0fQsWYh4i8yd5PKCM/iFHOjGQRqicpcK6iKQptutryMzWEAv4m/6noLDtGbl8JemMRdFDKR/y3
 L81p1Ei+C5ojQdFB4V77013nUVBRXPs/p58lX0XZ5+dAbgWu5JD1FbS2xYNVdZ56E8fv/TH6IK
 vrx94jbenn7oSbf/d2NhDxc7A2TsXw3zHuJzl+Up2J/xf7dBLFYjnFc/qugCHFs0+gvEmXW2VM
 3OA=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Mar 2021 01:11:07 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v6 00/10] Add Host control mode to HPB
Date:   Mon, 22 Mar 2021 10:10:34 +0200
Message-Id: <20210322081044.62003-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v5 -> v6:
 - attend CanG's comments
 - rebase on Daejun's v31

v4 -> v5:
 - attend Daejun's comments
 - Control the number of inflight map requests

v3 -> v4:
 - rebase on Daejun's v25

v2 -> v3:
 - Attend Greg's and Can's comments
 - rebase on Daejun's v21

v1 -> v2:
 - attend Greg's and Daejun's comments
 - add patch 9 making host mode parameters configurable
 - rebase on Daejun's v19


The HPB spec defines 2 control modes - device control mode and host
control mode. In oppose to device control mode, in which the host obey
to whatever recommendation received from the device - In host control
mode, the host uses its own algorithms to decide which regions should
be activated or inactivated.

We kept the host managed heuristic simple and concise.

Aside from adding a by-spec functionality, host control mode entails
some further potential benefits: makes the hpb logic transparent and
readable, while allow tuning / scaling its various parameters, and
utilize system-wide info to optimize HPB potential.

This series is based on Samsung's V31 device-control HPB2.0 driver, see
msg-id: CGME20210322064159epcms2p6a4c7deed5f81eaa4f2a8340aaedb446c@epcms2p6
in lore.kernel.org.

This version was tested on Galaxy S20, and Xiaomi Mi10 pro.
Your meticulous review and testing is mostly welcome and appreciated.

Thanks,
Avri

Avri Altman (10):
  scsi: ufshpb: Cache HPB Control mode on init
  scsi: ufshpb: Add host control mode support to rsp_upiu
  scsi: ufshpb: Add region's reads counter
  scsi: ufshpb: Make eviction depends on region's reads
  scsi: ufshpb: Region inactivation in host mode
  scsi: ufshpb: Add hpb dev reset response
  scsi: ufshpb: Add "Cold" regions timer
  scsi: ufshpb: Limit the number of inflight map requests
  scsi: ufshpb: Add support for host control mode
  scsi: ufshpb: Make host mode parameters configurable

 Documentation/ABI/testing/sysfs-driver-ufs |  84 +++-
 drivers/scsi/ufs/ufshcd.h                  |   2 +
 drivers/scsi/ufs/ufshpb.c                  | 547 ++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h                  |  39 ++
 4 files changed, 635 insertions(+), 37 deletions(-)

-- 
2.25.1

