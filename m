Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AEBC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 21:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53AFB60FDA
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 21:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhHJVFY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 17:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232739AbhHJVFN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 17:05:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 216AE60E09;
        Tue, 10 Aug 2021 21:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628629490;
        bh=C9XBDAJhXG+Rn8ZoatuMyt7pr8cmprWx13pjHSQveVo=;
        h=Date:From:To:Cc:Subject:From;
        b=I/wE/F/TPJo5nPASsKpzfqi6kRfsDyGVgwUvtu1SNYrjx3u0uWGF+5cFyVO+Iw7FL
         Zpz81Q6hMJ2ibs+nDTDxkw1UAFH4axgXqvsKMrUMthjbaFnebPEHj3z0Di5SZms8MP
         tbxcmiuDAkHGZqdhEOF7rMWh08625ku6s57Faytx+g2rGlsXmxP2Dn6oeHS51lkHqf
         iA8NsoRbEVlVuujpP2AB65KdQDSdcIJhoDTKkbIgB6xlDkF73dYN051gb88d4EiUi/
         Dm2buvPvfrwStr0QbMdcWmowzMf/g5D17cvI/0DbvZUzHlI8rHUEGeN85oPrK1fs3z
         ZV6gMDhC2g0OQ==
Date:   Tue, 10 Aug 2021 16:07:41 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: smartpqi: Replace one-element array with
 flexible-array member
Message-ID: <20210810210741.GA58765@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code a bit according to the use of a flexible-array member
in struct pqi_event_config instead of a one-element array, and use the
struct_size() helper.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

This issue was found with the help of Coccinelle and audited and fixed,
manually.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi.h      | 2 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index f340afc011b5..70eca203d72f 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -415,7 +415,7 @@ struct pqi_event_config {
 	u8	reserved[2];
 	u8	num_event_descriptors;
 	u8	reserved1;
-	struct pqi_event_descriptor descriptors[1];
+	struct pqi_event_descriptor descriptors[];
 };
 
 #define PQI_MAX_EVENT_DESCRIPTORS	255
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c1f0f8da9fe2..f9107127bd6e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4740,8 +4740,7 @@ static int pqi_create_queues(struct pqi_ctrl_info *ctrl_info)
 }
 
 #define PQI_REPORT_EVENT_CONFIG_BUFFER_LENGTH	\
-	(offsetof(struct pqi_event_config, descriptors) + \
-	(PQI_MAX_EVENT_DESCRIPTORS * sizeof(struct pqi_event_descriptor)))
+	struct_size((struct pqi_event_config *)0, descriptors, PQI_MAX_EVENT_DESCRIPTORS)
 
 static int pqi_configure_events(struct pqi_ctrl_info *ctrl_info,
 	bool enable_events)
-- 
2.27.0

