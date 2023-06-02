Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391BBC7EE2E
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jun 2023 16:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbjFBQj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jun 2023 12:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbjFBQjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2023 12:39:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FDE197;
        Fri,  2 Jun 2023 09:39:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1F8BB1FDF2;
        Fri,  2 Jun 2023 16:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1685723962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hUQHuivg+pTx9zDOLY7hB3+3Zv+Yz7oO049b7yXJKRk=;
        b=RZxuV7ccGTNaolK+1F92QgVexdQU9Km15f77w0CXDPMm/8ufxGQmO1sZLihXFHKLtmPToP
        Kk12BQBw5MtyfDCv4aA+O+Od1XU0S6WcWLwQYpKbQr2bC+zAi7yuMdgRbeY3NV4BuxbvC0
        Rs5whCzVDHTrk4BA47Foj74FNzJNwL0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B46D1133E6;
        Fri,  2 Jun 2023 16:39:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iFBcKjkbemSEDwAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 02 Jun 2023 16:39:21 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] scsi: sg: increase number of devices
Date:   Fri,  2 Jun 2023 18:38:44 +0200
Message-Id: <20230602163845.32108-3-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602163845.32108-1-mwilck@suse.com>
References: <20230602163845.32108-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Larger setups may need to allocate more than 32k sg devices, so
increase the number of devices to the full range of minor device
numbers.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 037f8c98a6d3..6c04cf941dac 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -71,7 +71,7 @@ static int sg_proc_init(void);
 
 #define SG_ALLOW_DIO_DEF 0
 
-#define SG_MAX_DEVS 32768
+#define SG_MAX_DEVS (1 << MINORBITS)
 
 /* SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type
  * of sg_io_hdr::cmd_len can only represent 255. All SCSI commands greater
-- 
2.40.1

