Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BB6C33C9C
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7782420872
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="qcUAZ4C0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKTW1l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 17:27:41 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:51248 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725819AbfKTW1j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 17:27:39 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E654F43D12;
        Wed, 20 Nov 2019 22:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1574288851; x=
        1576103252; bh=BUOgcCgUHGsp/FBw6h0eudYzsLfCg4Zgq+WxQ+kKXqo=; b=q
        cUAZ4C0EZ+rvGfRrk+HN0XVLP9EayZp+pETHp6VegRPvOH+tDqP5KIYeeYjsLpAk
        wS5N2KSUl78x4iUBSfyDx+kmL3HOAVxva4fhGSIvBgQxSeP4z2KxC30DdOinht8f
        MxdNoP2JjZWaJy4flMpGZxZNVT4S6mYwvRZ5oNbYuU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zLuLj2aVMzsi; Thu, 21 Nov 2019 01:27:31 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7713842004;
        Thu, 21 Nov 2019 01:27:31 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 Nov 2019 01:27:31 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 00/15] scsi: qla2xxx: Bug fixes
Date:   Thu, 21 Nov 2019 01:27:08 +0300
Message-ID: <20191120222723.27779-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Martin,

The patch series contains fixes for qla2xxx and solves two visible
issues:
  - Target port in N2N topology doesn't perform login if it has higher
    WWPN than initiator
  - ABORT TASK TMF leads to crash if it's received shortly after ACL of
    an initiator is deleted and there's active I/O from the initiator

It also contains reliability improvements and cleanups.

Unfortunately, there's still an issue the latest patch. The discard
works but ELS IOCB for LOGO is likely built incorrectly by
qla24xx_els_dcmd_iocb(). The issue can also be exposed when "1" is
written to fc_host/hostN/device/issue_logo file with logging turned on.

Changes since v1 (https://patchwork.kernel.org/cover/11141979/):
- Fixes target port in N2N mode were added (patches 5-11);
- Target port makes explicit LOGO on session teardown in the patch made
  by Quinn. Together with patch 1, it helps to immediately turn
  fc_remote_port to the Blocked stated on client side and avoids visibly
  stuck session;
- The last three patches address violation of FCP specification with
  regards to handling of ABTS-LS from ports that are not currently
  logged in.

Thank you,
Roman

Quinn Tran (1):
  scsi: qla2xxx: Use explicit LOGO in target mode

Roman Bolshakov (14):
  scsi: qla2xxx: Ignore NULL pointer in tcm_qla2xxx_free_mcmd
  scsi: qla2xxx: Initialize free_work before flushing it
  scsi: qla2xxx: Drop superfluous INIT_WORK of del_work
  scsi: qla2xxx: Change discovery state before PLOGI
  scsi: qla2xxx: Allow PLOGI in target mode
  scsi: qla2xxx: Don't call qlt_async_event twice
  scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length
  scsi: qla2xxx: Configure local loop for N2N target
  scsi: qla2xxx: Send Notify ACK after N2N PLOGI
  scsi: qla2xxx: Don't defer relogin unconditonally
  scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI
  scsi: qla2xxx: Add async mode for qla24xx_els_dcmd_iocb
  scsi: qla2xxx: Add debug dump of LOGO payload and ELS IOCB
  scsi: qla2xxx: Handle ABTS according to FCP spec for logged out ports

 drivers/scsi/qla2xxx/qla_attr.c    |  2 +-
 drivers/scsi/qla2xxx/qla_def.h     |  1 +
 drivers/scsi/qla2xxx/qla_gbl.h     |  2 +-
 drivers/scsi/qla2xxx/qla_init.c    | 21 ++++++---------
 drivers/scsi/qla2xxx/qla_iocb.c    | 42 ++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c     |  4 ---
 drivers/scsi/qla2xxx/qla_mbx.c     |  3 ++-
 drivers/scsi/qla2xxx/qla_target.c  | 34 ++++++++++++++++--------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  3 +++
 9 files changed, 73 insertions(+), 39 deletions(-)

-- 
2.24.0

