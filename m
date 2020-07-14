Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB19C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 22:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 637A7206D9
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 22:08:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TCOM6Q5K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgGNWId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 18:08:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31368 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727941AbgGNWIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 18:08:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594764511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=Eoga+Mdleam2+PFUQQVvh+tI5hcjfog78flkltDgmv4=;
        b=TCOM6Q5Kyrc0sDFRaqGcrpybJ/DD45D+woTWKxk13lRgac/CkLJqdBu9PRFcZvibcOZLsD
        g+R4hjyQGqLYczOO0Q2MiJZqFrmvyaR6+hxYidT8tud+tBDqEO81nFCGx1KQe3VWcUA27S
        MMdRPVtkBNxMjs9AXwXCcpqQ6BSv8JU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-tcRqVYBLNXq9aneVJyXS3Q-1; Tue, 14 Jul 2020 18:08:27 -0400
X-MC-Unique: tcRqVYBLNXq9aneVJyXS3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 457EC800685;
        Tue, 14 Jul 2020 22:08:26 +0000 (UTC)
Received: from loberhel7laptop.redhat.com (ovpn-113-229.phx2.redhat.com [10.3.113.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BC4E1992D;
        Tue, 14 Jul 2020 22:08:25 +0000 (UTC)
From:   Laurence Oberman <loberman@redhat.com>
To:     loberman@redhat.com, linux-scsi@vger.kernel.org,
        QLogic-Storage-Upstream@cavium.com, netdev@vger.kernel.org,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com
Subject: [PATCH net] qed: Disable "MFW indication via attention" SPAM every 5 minutes 
Date:   Tue, 14 Jul 2020 18:08:05 -0400
Message-Id: <1594764485-682-1-git-send-email-loberman@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is likely firmware causing this but its starting to annoy customers.
Change the message level to verbose to prevent the spam.
Note that this seems to only show up with ISCSI enabled on the HBA via the 
qedi driver.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index b7b974f..d853eb9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1193,7 +1193,8 @@ static int qed_int_attentions(struct qed_hwfn *p_hwfn)
 			index, attn_bits, attn_acks, asserted_bits,
 			deasserted_bits, p_sb_attn_sw->known_attn);
 	} else if (asserted_bits == 0x100) {
-		DP_INFO(p_hwfn, "MFW indication via attention\n");
+		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
+			   "MFW indication via attention\n");
 	} else {
 		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
 			   "MFW indication [deassertion]\n");
-- 
1.8.3.1

