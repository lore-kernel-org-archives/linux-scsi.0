Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A8FC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CDD120706
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgHRMsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:48:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:49570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbgHRMsX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 08:48:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1F62AADF2;
        Tue, 18 Aug 2020 12:48:47 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH v6 4/6] drbd: code cleanup by using sendpage_ok() to check page for kernel_sendpage()
Date:   Tue, 18 Aug 2020 20:47:34 +0800
Message-Id: <20200818124736.5790-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818124736.5790-1-colyli@suse.de>
References: <20200818124736.5790-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In _drbd_send_page() a page is checked by following code before sending
it by kernel_sendpage(),
        (page_count(page) < 1) || PageSlab(page)
If the check is true, this page won't be send by kernel_sendpage() and
handled by sock_no_sendpage().

This kind of check is exactly what macro sendpage_ok() does, which is
introduced into include/linux/net.h to solve a similar send page issue
in nvme-tcp code.

This patch uses macro sendpage_ok() to replace the open coded checks to
page type and refcount in _drbd_send_page(), as a code cleanup.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/block/drbd/drbd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index cb687ccdbd96..55dc0c91781e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1553,7 +1553,7 @@ static int _drbd_send_page(struct drbd_peer_device *peer_device, struct page *pa
 	 * put_page(); and would cause either a VM_BUG directly, or
 	 * __page_cache_release a page that would actually still be referenced
 	 * by someone, leading to some obscure delayed Oops somewhere else. */
-	if (drbd_disable_sendpage || (page_count(page) < 1) || PageSlab(page))
+	if (drbd_disable_sendpage || !sendpage_ok(page))
 		return _drbd_no_send_page(peer_device, page, offset, size, msg_flags);
 
 	msg_flags |= MSG_NOSIGNAL;
-- 
2.26.2

