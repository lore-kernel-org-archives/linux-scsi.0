Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C565CC38145
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Sep 2022 18:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiIGS6m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Sep 2022 14:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIGS6l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2022 14:58:41 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC379BB54;
        Wed,  7 Sep 2022 11:58:40 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287Fs4H6029981;
        Wed, 7 Sep 2022 11:58:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=F1hzJbniAzywxQLlvTqR1dazPBueINohET1FrhunXHg=;
 b=BzYMFFw8wFQ5u6jEW1ybpN/vKaD5InvTfInU121N6zp6RHApAEtBF++kbxvkTz7Ok4Lu
 hCe9M1+hWftlUcyNM4idsSpxTWcAFma8z1hTa5SwI18gN2rMpq7Sa9iZh1Asm94WrVP5
 A0md2cnc3Dg9MDtJqtaF8jNMspfm24dK+JIM6HbW0qnLnLaEvzaaWyoXu5o1F+kiErFm
 dYwbWy+jUl4SuGJ2ys701sallHnoOvB7vibj7mlujQN0GFeGMp2v5uM73zqNlKpaXGFA
 +73mJ4rXOYHpc/EVXAtQFwPRd74SVVgbZrleqsctqo51E/ZO6BPjRirzK21IqDlk5N9P jg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3jen9wu344-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 11:58:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 7 Sep
 2022 11:58:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 7 Sep 2022 11:58:35 -0700
Received: from dut6246.localdomain (unknown [10.112.88.36])
        by maili.marvell.com (Postfix) with ESMTP id 937713F7054;
        Wed,  7 Sep 2022 11:58:35 -0700 (PDT)
Received: by dut6246.localdomain (Postfix, from userid 0)
        id 7064F228060; Wed,  7 Sep 2022 11:58:35 -0700 (PDT)
From:   Arun Easi <aeasi@marvell.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Martin Petersen <martin.petersen@oracle.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        James Bottomley <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Arun Easi <aeasi@marvell.com>
Subject: [PATCH v2 0/1] Tracing: Compile error with qla2xxx
Date:   Wed, 7 Sep 2022 11:57:44 -0700
Message-ID: <20220907185745.14382-1-aeasi@marvell.com>
X-Mailer: git-send-email 2.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tL3na6sVdoJSMPFjocZOt4wnNUikNPdN
X-Proofpoint-GUID: tL3na6sVdoJSMPFjocZOt4wnNUikNPdN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Steve, et.al,

Please find a patch to fix compile error coming from qla2xxx driver
when CONFIG_TRACING is disabled.

Hi Martin,

Please apply this patch to the SCSI tree once Steve approves it. Here
is a link to the discussion:
    https://lore.kernel.org/linux-scsi/YxdZ%2F9XOsWilvVSd@debian/T/#m6efb601ed65c907124a03cfd5f3f38f1eb8c5925

Changes from V1:
    * Incorporated Steve's review comments (change to inline etc.)

Regards,
-Arun

Arun Easi (1):
  tracing: Fix compile error in trace_array calls when TRACING is
    disabled

 include/linux/trace.h | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

-- 
2.9.5

base-commit: efca52749564601de2045eb71dbe756b7bade4e8
