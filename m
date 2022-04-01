Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B26C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 14:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348478AbiDAO5X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352604AbiDAOvA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 10:51:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB902B4492;
        Fri,  1 Apr 2022 07:42:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6C79B82510;
        Fri,  1 Apr 2022 14:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9403C36AE7;
        Fri,  1 Apr 2022 14:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824081;
        bh=3zdgk+amzkz5hnhB65s9Sk8Gho2/tyIKqasTtRUMeCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMLqYZEvuD0lKmfm8SEcdOHtC8MKMP/+EZXgfAfEbDDlY+pmI2/QnNmaKxoEI9k3n
         Iv55ImbpKQM7BmLlLAR5l3mSm03+jjnXA7X/eaFh+zc+ox0lN0Ytied/MfAnyhiexO
         5jVDGKiPweo4WCe1CKv3Te/aag8wZ+42emLXiRGozg6fWnUOMGJhPt3UFwfkNBzMQd
         ErbZ+gZY9o8H5wjeSphU7ksCJ7d6rYbX1Z8GZSFP9SnPZcnln9v1QSopeoy+AXUkXp
         7EKzjajj5z3WlLDMVBxxNgmVHguEhGE9BN78r8hsBXpf6voVPzKps0vO8qd+qRwvlQ
         vJamiE0HL68CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 78/98] scsi: libfc: Fix use after free in fc_exch_abts_resp()
Date:   Fri,  1 Apr 2022 10:37:22 -0400
Message-Id: <20220401143742.1952163-78-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 271add11994ba1a334859069367e04d2be2ebdd4 ]

fc_exch_release(ep) will decrease the ep's reference count. When the
reference count reaches zero, it is freed. But ep is still used in the
following code, which will lead to a use after free.

Return after the fc_exch_release() call to avoid use after free.

Link: https://lore.kernel.org/r/20220303015115.459778-1-niejianglei2021@163.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_exch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 841000445b9a..aa223db4cf53 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1701,6 +1701,7 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	if (cancel_delayed_work_sync(&ep->timeout_work)) {
 		FC_EXCH_DBG(ep, "Exchange timer canceled due to ABTS response\n");
 		fc_exch_release(ep);	/* release from pending timer hold */
+		return;
 	}
 
 	spin_lock_bh(&ep->ex_lock);
-- 
2.34.1

