Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A2EC3526B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B311523B74
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387601AbgLRUon (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgLRUon (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 15:44:43 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E06CC0617A7;
        Fri, 18 Dec 2020 12:44:03 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608324240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CxPbrQoekOQMAqNnjDM8DzaYm86184Fh4brCwrCo5Os=;
        b=CwZdtYpyaQqiw4FALDIJc3uZFSaZ+klOu7RQY2Yvj/A0gD7YZcf1XM0CNs+IEefva37XYq
        cSjMHfyeTDSs5BP6pjgbN/bm0OMf9JlUQJ9cXW5/HPr+23P68qezwA7c+w3WOP+aM46ju/
        YDgQ3AzldGbd3Emv5iKlU9IXdWn7+YMHOJHD+Uo6vPK1oFBb8ZhxR+ZcVEK+DvPYXcHhP3
        a95zawc0FBK7+NlXQwpD+05zTTTkfcc6a6dqrlW4myRAC9bKtTNh9UmYMW0Msqtk/e1hSv
        xqrXWLcE7RsGo2z4CaL1FPT3B0yyztxHccSUgGRHVXh8OI9uzRYjn0J6xwnpSA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608324240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CxPbrQoekOQMAqNnjDM8DzaYm86184Fh4brCwrCo5Os=;
        b=SLGy1BP4IjF7B+ffx4Fojpj3zwXWPyQnyVy+1moGtBNiEM4glLd0AmMMWY1KPbTNkK2ILD
        MvDlw12IbqeRzNCQ==
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH 01/11] Documentation: scsi: libsas: Remove notify_ha_event()
Date:   Fri, 18 Dec 2020 21:43:44 +0100
Message-Id: <20201218204354.586951-2-a.darwish@linutronix.de>
In-Reply-To: <20201218204354.586951-1-a.darwish@linutronix.de>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ->notify_ha_event() hook has long been removed from the libsas event
interface.

Remove it from documentation.

Fixes: 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some cleanup")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: stable@vger.kernel.org
Cc: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 Documentation/scsi/libsas.rst | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index 7216b5d25800..f9b77c7879db 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -189,7 +189,6 @@ num_phys
 The event interface::
 
 	/* LLDD calls these to notify the class of an event. */
-	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
 	void (*notify_port_event)(struct sas_phy *, enum port_event);
 	void (*notify_phy_event)(struct sas_phy *, enum phy_event);
 
-- 
2.29.2

