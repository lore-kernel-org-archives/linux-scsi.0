Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A439AC38145
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Sep 2022 13:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbiIBNj5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Sep 2022 09:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbiIBNjO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2022 09:39:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025E862DF
        for <linux-scsi@vger.kernel.org>; Fri,  2 Sep 2022 06:17:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F08D15BEB0;
        Fri,  2 Sep 2022 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662124550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Exfpnhe1ZreKehgq548yhjMxcYHX24htiQMYJTJZFl0=;
        b=JlKr5otO5obcC0dbGpvmWMpd1AifjDvaBJyPkQELe7FQFi2htsfpH+ZOSOEOVli4XaPpls
        dL8bKCLaU7pOsS/qXTQoZMdHRoFdgGNfIPFZltQVvlhoTSkymbyC5wHoU1CbhSvAaiWlbe
        IsScCvOpaqGUAqsyEX0hwuxpJR4gO+c=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ACA2E1330E;
        Fri,  2 Sep 2022 13:15:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cZiFKAYCEmMbfAAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 02 Sep 2022 13:15:50 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     "George, Martin" <Martin.George@netapp.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi: scsi_transport_fc: use %u for dev_loss_tmo
Date:   Fri,  2 Sep 2022 15:15:19 +0200
Message-Id: <20220902131519.16513-1-mwilck@suse.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

dev_loss_tmo is an unsigned value. Using "%d" as output format
causes irritating negative values to be shown in sysfs.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index a2524106206db..df4aa4a5f83c4 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1170,7 +1170,7 @@ static int fc_rport_set_dev_loss_tmo(struct fc_rport *rport,
 	return 0;
 }
 
-fc_rport_show_function(dev_loss_tmo, "%d\n", 20, )
+fc_rport_show_function(dev_loss_tmo, "%u\n", 20, )
 static ssize_t
 store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
-- 
2.37.1

