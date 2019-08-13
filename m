Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75DDC41517
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 12:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BF59206C2
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 12:20:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ev/tJDUd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbfHMMUB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 08:20:01 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:56196 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbfHMMT6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 08:19:58 -0400
Received: by mail-qt1-f202.google.com with SMTP id z93so17702208qtc.22
        for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2019 05:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1sx6hDgzysYx+a29qVca5WMwZUe5jwQTperKXSLoylQ=;
        b=Ev/tJDUdex0/lv/JEzhxy+49zAkreP6Jg29SndWS5FWZ830Oi1JZSSRe6lp9IrWOaH
         6Y3lgB/2sWKhybFHj3qjhywMystAxoTkuz47QmpUTVjzEPHZ1B/W01+B0ocg5FEHcqhy
         dqZgHcQ0db3rTby/urgNTYN2GhCDoaM3pbXCwRhT8ijr7jEhVYAnAX+PTXEd0AWwBUE4
         gHqeqaiQuCjuP6So/ndbq6iDBndo4FGwp7iSG4AayhQaOObt1T+F3tLAdFEBSwAvCbk6
         IV9N1j3fjk7oDLSc77o4LYwVb6/yy0myZelAKaLZ/iMGgbcy9AtCX+KchP5vb3ypKiyL
         /fOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1sx6hDgzysYx+a29qVca5WMwZUe5jwQTperKXSLoylQ=;
        b=pcpkCnKJB0nBSC7CRemZxSK1l8rM8C/9JBA64ZF923SyVsU7HgjCIeEA108T91oujN
         Z2PQxIotex5xeaq18hoYidY0/kE+x6yR9+wb7BxdBOhbS4qGc5NtrhnBjcAdLttydAVB
         cODOzOIXCy3CmRBYgAh+4bSlerz0xk2ycMarLxvaL/vmoaA4IM9Gk4M2vf4ph6TDb5PQ
         AoXvseHZieIdvzT7wiAgFFPOtNuRGeNbTIiFX46KGJvjl2c0Rvd+DugV/Obs89xkHonQ
         IH2ELWqateiEVi5fmrZqWeV6bQRh3xnQWnEEDFuZP2u3T+6JORW6o3cNzEkloON6tm99
         Cg3w==
X-Gm-Message-State: APjAAAVWq5YnzCdndRgXf0tPb1w9OzeSYpvdcFlcQr4IJ1k1RyQKBcP5
        kJcVyEi8J79mOlnDd46I1lErkfkEF8FmwA==
X-Google-Smtp-Source: APXvYqy7XJLCyeK2FSU9zmscKN5oO6sUvybZKuEqJl11qIfRvRwWVPlen7osQbA/oOuqUN0PwQXDX7FNDxzX0g==
X-Received: by 2002:ad4:5242:: with SMTP id s2mr3907894qvq.129.1565698796953;
 Tue, 13 Aug 2019 05:19:56 -0700 (PDT)
Date:   Tue, 13 Aug 2019 13:17:06 +0100
In-Reply-To: <20190813121733.52480-1-maennich@google.com>
Message-Id: <20190813121733.52480-10-maennich@google.com>
Mime-Version: 1.0
References: <20180716122125.175792-1-maco@android.com> <20190813121733.52480-1-maennich@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH v2 09/10] usb-storage: remove single-use define for debugging
From:   Matthias Maennich <maennich@google.com>
To:     linux-kernel@vger.kernel.org, maco@android.com
Cc:     kernel-team@android.com, maennich@google.com, arnd@arndb.de,
        geert@linux-m68k.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        jeyu@kernel.org, joel@joelfernandes.org,
        kstewart@linuxfoundation.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-modules@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, lucas.de.marchi@gmail.com,
        maco@google.com, michal.lkml@markovi.net, mingo@redhat.com,
        oneukum@suse.com, pombredanne@nexb.com, sam@ravnborg.org,
        sboyd@codeaurora.org, sspatil@google.com,
        stern@rowland.harvard.edu, tglx@linutronix.de,
        usb-storage@lists.one-eyed-alien.net, x86@kernel.org,
        yamada.masahiro@socionext.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

USB_STORAGE was defined as "usb-storage: " and used in a single location
as argument to printk. In order to be able to use the name
'USB_STORAGE', drop the definition and use the string directly for the
printk call.

Signed-off-by: Matthias Maennich <maennich@google.com>
---
 drivers/usb/storage/debug.h    | 2 --
 drivers/usb/storage/scsiglue.c | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/storage/debug.h b/drivers/usb/storage/debug.h
index 6d64f342f587..16ce06039a4d 100644
--- a/drivers/usb/storage/debug.h
+++ b/drivers/usb/storage/debug.h
@@ -29,8 +29,6 @@
 
 #include <linux/kernel.h>
 
-#define USB_STORAGE "usb-storage: "
-
 #ifdef CONFIG_USB_STORAGE_DEBUG
 void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *srb);
 void usb_stor_show_sense(const struct us_data *us, unsigned char key,
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 05b80211290d..df4de8323eff 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -379,7 +379,7 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 
 	/* check for state-transition errors */
 	if (us->srb != NULL) {
-		printk(KERN_ERR USB_STORAGE "Error in %s: us->srb = %p\n",
+		printk(KERN_ERR "usb-storage: Error in %s: us->srb = %p\n",
 			__func__, us->srb);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
-- 
2.23.0.rc1.153.gdeed80330f-goog

