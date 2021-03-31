Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F5EC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 20:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91CD8610A2
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 20:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbhCaUMc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 16:12:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236451AbhCaUL7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 16:11:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617221517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=I7Whh4cMOyjs7GRPcHRCS6NqA57GnRYz/h3h7Pna008=;
        b=JQyMWpWhdtIFEH2nd17M8M5jsPXM3jD3HzQ0Ex6uiLPUBFS8slHWHn+cgnVnReCVZrRYU1
        E9dCRt6ZUjPpT3GFX2cIgeuIWXNobYTHt+bEUp/7pmRR+ggChzbikJc1jRtpjLC6BcPEKm
        yVXJUjtuMa3Bda2Fb+LRZ2uxQj4pWSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-ocdMZAKpMR2h62k_D50mUw-1; Wed, 31 Mar 2021 16:11:55 -0400
X-MC-Unique: ocdMZAKpMR2h62k_D50mUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDAC58189CB;
        Wed, 31 Mar 2021 20:11:54 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC31D6A8FA;
        Wed, 31 Mar 2021 20:11:54 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     hare@suse.de
Subject: [PATCH] scsi_dh_alua: remove check for ASC 24h when ILLEGAL_REQUEST returned on RTPG w/extended header
Date:   Wed, 31 Mar 2021 16:11:54 -0400
Message-Id: <20210331201154.20348-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some arrays return ILLEGAL_REQUEST with ASC 00h if they don't support the
extended header, so remove the check for INVALID FIELD IN CDB.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e42390333c6e..c4c2f23cf79f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -587,10 +587,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		 * even though it shouldn't according to T10.
 		 * The retry without rtpg_ext_hdr_req set
 		 * handles this.
+		 * Note:  some arrays return a sense key of ILLEGAL_REQUEST
+		 * with ASC 00h if they don't support the extended header.
 		 */
 		if (!(pg->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
-		    sense_hdr.sense_key == ILLEGAL_REQUEST &&
-		    sense_hdr.asc == 0x24 && sense_hdr.ascq == 0) {
+		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
 			pg->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
 			goto retry;
 		}
-- 
2.20.1

