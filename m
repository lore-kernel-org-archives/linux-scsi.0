Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01B7C2D0ED
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C40BB20857
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgC0Qrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 12:47:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:41726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727549AbgC0Qrw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 12:47:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3B04EADE3;
        Fri, 27 Mar 2020 16:47:51 +0000 (UTC)
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 2/5] scsi: qla2xxx: check UNLOADING before posting async work
Date:   Fri, 27 Mar 2020 17:47:08 +0100
Message-Id: <20200327164711.5358-3-mwilck@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200327164711.5358-1-mwilck@suse.com>
References: <20200327164711.5358-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

qlt_free_session_done() tries to post async PRLO / LOGO, and
waits for the completion of these async commands. If UNLOADING
is set, this is doomed to timeout, because the async logout
command will never complete.

The only way to avoid waiting pointlessly is to fail posting
these commands in the first place if the driver is in UNLOADING state.
In general, posting any command should be avoided when the driver
is UNLOADING.

With this patch, "rmmod qla2xxx" completes without noticeable delay.

Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ce0dabb..eb25cf5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4933,6 +4933,9 @@ int qla2x00_post_async_##name##_work(		\
 {						\
 	struct qla_work_evt *e;			\
 						\
+	if (test_bit(UNLOADING, &vha->dpc_flags)) \
+		return QLA_FUNCTION_FAILED;	\
+						\
 	e = qla2x00_alloc_work(vha, type);	\
 	if (!e)					\
 		return QLA_FUNCTION_FAILED;	\
-- 
2.25.1

