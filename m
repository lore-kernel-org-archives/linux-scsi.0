Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C0EC3F2D2
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 17:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D31F207FD
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 17:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583428846;
	bh=N3h6q8tCGOh4BWQmsC7dtfhBTXK5drPci7XihK3wjb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=D35WB+OnpQJZxrrWve2HcJmhJr7ipY1PCrOMVT9hq5WrFmslVcAfca1fFg4RANk8B
	 s4LpAxmZsq7wTcRqw3CK5UWdag2z434wHOqvkh+/QY22jgxYsK9aORITyeu9+HeHnx
	 YliqNogWocPDfPY7ckXBsAjjm/ofiGelA17B6R2g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgCERUp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 12:20:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727813AbgCEROt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD7B724655;
        Thu,  5 Mar 2020 17:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428488;
        bh=N3h6q8tCGOh4BWQmsC7dtfhBTXK5drPci7XihK3wjb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhQxh7Fl1THNBX7IbjD1cjPTXUN+tnRtU+6BzTCX1NJGBVDx7f7XMCiHwCC8gVk9N
         PkCICv/eYb/VYyTt2feb7N6RmIf2FQM3gPM7DC9Xj/qLhX97uXmpKvKcmlS2EkQmNV
         TlSb/NTOcxNdFJM3RKY+N8/8OfV3Z2yy611FQKb4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Druzhinin <igor.druzhinin@citrix.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/58] scsi: libfc: free response frame from GPN_ID
Date:   Thu,  5 Mar 2020 12:13:44 -0500
Message-Id: <20200305171420.29595-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Igor Druzhinin <igor.druzhinin@citrix.com>

[ Upstream commit ff6993bb79b9f99bdac0b5378169052931b65432 ]

fc_disc_gpn_id_resp() should be the last function using it so free it here
to avoid memory leak.

Link: https://lore.kernel.org/r/1579013000-14570-2-git-send-email-igor.druzhinin@citrix.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Igor Druzhinin <igor.druzhinin@citrix.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_disc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 9c5f7c9178c66..2b865c6423e29 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -628,6 +628,8 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 out:
 	kref_put(&rdata->kref, fc_rport_destroy);
+	if (!IS_ERR(fp))
+		fc_frame_free(fp);
 }
 
 /**
-- 
2.20.1

