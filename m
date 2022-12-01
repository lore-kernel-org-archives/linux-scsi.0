Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A6BC43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 14:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiLAOFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 09:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiLAOE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 09:04:58 -0500
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6F0A5191;
        Thu,  1 Dec 2022 06:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1669903489;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=KMmrymso6RGjDkYBGOZ13Mhdy02M0I3meAzkE2PuEuM=;
    b=eUw3jwsqYSSgU0JEe5yxaePj+S26Z/3GnzyYzxmUbBGOLuS7/VlKBmm2s8I7Z+156x
    vd0wH0VpJ2qhtxBv7eD02ybZVz79URRL2qty/gCBDhYZikY8IOTH67qxisV+VYaK5PPi
    d9IwSvHV7frbfCi14jyEaahmNYVWcdzqcGzI7l+s7bEBXz9ptzZTRaLQ/PdqnsZOHVGH
    9nTDLEAjLBxj2yYSwHwW/30993Gav+7Hlv+dR1ag8jat0bfr8ww4gPduQq0afdomqNB4
    A1+5cKhrR74Gh7Qm7B8Cq0EAOKuISVTSsMEuDIc74uUvGwLVFB7IRv2Mu4RzgZqgxLQG
    VJXQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD2QzemV2tdlNlNRZBXiUw="
X-RZG-CLASS-ID: mo01
Received: from blinux.micron.com
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id z9cfbfyB1E4mHoT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 1 Dec 2022 15:04:48 +0100 (CET)
From:   Bean Huo <beanhuo@iokpp.de>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        daejun7.park@samsung.com, quic_cang@quicinc.com,
        quic_nguyenb@quicinc.com, quic_xiaosenh@quicinc.com,
        quic_richardp@quicinc.com, quic_asutoshd@quicinc.com, hare@suse.de
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/7] ufs: bsg: Let result in struct ufs_bsg_reply be signed int
Date:   Thu,  1 Dec 2022 15:04:31 +0100
Message-Id: <20221201140437.549272-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221201140437.549272-1-beanhuo@iokpp.de>
References: <20221201140437.549272-1-beanhuo@iokpp.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

According to the comments in struct ufs_bsg_reply and its usage, the
result should be signed int, not __u32.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 include/uapi/scsi/scsi_bsg_ufs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index d55f2176dfd4..64b0cb33e549 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -95,7 +95,7 @@ struct ufs_bsg_reply {
 	 * msg and status fields. The per-msgcode reply structure
 	 * will contain valid data.
 	 */
-	__u32 result;
+	int result;
 
 	/* If there was reply_payload, how much was received? */
 	__u32 reply_payload_rcv_len;
-- 
2.25.1

