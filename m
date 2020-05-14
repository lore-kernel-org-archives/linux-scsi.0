Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6068CC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 19:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3318220675
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 19:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589483099;
	bh=QPNcbDPqW5es24Ngar7Yc7ohZ/hI+cUNrl2795G1f5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sxF6/B+oe/la5ilhDm1Qd6yPs/lp+tMZTedEb0zUXnw71tZXIj6chl7xeFXLaIACF
	 GRAhrpgwfDrrgMcFRsdg8yJSY2bPbqM/J+h/XugzF3l/A0IJR3LZ2qZ8DZ5J5QeqA/
	 POx98tJY7enK0QZewU7zw4vo9A/PhZADDNPwHKa0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgENSyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 14:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728939AbgENSyX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 May 2020 14:54:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 278D5206DC;
        Thu, 14 May 2020 18:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482463;
        bh=QPNcbDPqW5es24Ngar7Yc7ohZ/hI+cUNrl2795G1f5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qAh0CEBa3mo8Yv1+JfHuQ8LS1+Lvg+qTciOMbfj5rZxRDizksZZ8eAX+ZPuM4z/7Y
         ZRiv1G2cXdVm5NPawjs3hSxjp+b0Pe2F3PuQ5AoanOIh23sr1K0ymnfCkWAnkwTKzd
         qRLmKi4SkRBGwCRiCTZcsZhQAKbdB6MYzG6RAWtQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/31] scsi: qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV
Date:   Thu, 14 May 2020 14:53:49 -0400
Message-Id: <20200514185413.20755-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185413.20755-1-sashal@kernel.org>
References: <20200514185413.20755-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 45a76264c26fd8cfd0c9746196892d9b7e2657ee ]

In NPIV environment, a NPIV host may use a queue pair created by base host
or other NPIVs, so the check for a queue pair created by this NPIV is not
correct, and can cause an abort to fail, which in turn means the NVME
command not returned.  This leads to hang in nvme_fc layer in
nvme_fc_delete_association() which waits for all I/Os to be returned, which
is seen as hang in the application.

Link: https://lore.kernel.org/r/20200331104015.24868-3-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bef9faea5eeeb..ac5d2d34aeeae 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3077,7 +3077,7 @@ qla24xx_abort_command(srb_t *sp)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108c,
 	    "Entered %s.\n", __func__);
 
-	if (vha->flags.qpairs_available && sp->qpair)
+	if (sp->qpair)
 		req = sp->qpair->req;
 
 	if (ql2xasynctmfenable)
-- 
2.20.1

