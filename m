Return-Path: <SRS0=MIBM=WR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B1BC3A5A0
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 11:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBA98233A1
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 11:55:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fvP4kpUi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfHULzA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Aug 2019 07:55:00 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:39359 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbfHULy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2019 07:54:59 -0400
Received: by mail-vk1-f202.google.com with SMTP id d14so812378vka.6
        for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2019 04:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1sx6hDgzysYx+a29qVca5WMwZUe5jwQTperKXSLoylQ=;
        b=fvP4kpUiTDeOAM1Gx+QPDOJ+dMuDSS2EU+Qf3xyjOeZ1OMqyw8S2HuNqh2L1WfFnyb
         FeuC5CdM6/SLWr3fXuzLfN/8wnAGLWDPu7LVvGoOAcIxSD/ZCRb+dLPdA7XEQlab+bcD
         10FikUlJGJgGRTmQ7H5rdPq+3Ws9GiVMKv0WH8ecmzrepmYI5SvoYMpqk/0G2MZJ2Q58
         ZAC4oNOREnbOnqUHwIlTlAV8DfKjgMSZjdwsEAjqFEzYLYjGgewYELH75tCcRkE02Okq
         SNn0SGfZCwXykWndLAViRVK3iAUJheJ3LxCLNvTj6xgKFU4AnKyYPnUHIgXI4mJ0uoYU
         gJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1sx6hDgzysYx+a29qVca5WMwZUe5jwQTperKXSLoylQ=;
        b=rO9Pi8hXF6jiG3hKMiRjhfOjGf3BFRszDFam4XP3wNKZycaHBvnr7BgfjdghZQv3nl
         I/+8P+jbknSGlz8hs5wLP9L2jb5qe3CQ4vZB1R4Jb1YkLaZqEkxN19oSkK2e927gBN0R
         hZtM0JKYUixplHh8PFxtlbrwFPsEFULCuqDnK9EomLUUb2dd2W/1sYRs5Jt0Qonz5D12
         BxT/O5cRQiOXjFpvUflliIseDjiFJZCcro690xBePmNU/llTk0fRPWa7pPNaq2sAYc3/
         H30mQg/YbG3Rc5bY3cho8MOWwV13MF0Ab1XsBv52/fe7XGDhUzOgASuTPwveMfJszN+i
         qWSA==
X-Gm-Message-State: APjAAAVkUSvIcrOh5WBzK0NRjstw/9+08mcJNntKEh/XDbX5p2UyZwlG
        dgo+imiBO5CKCYUN5+RZWRJj1c9n4FG8Ow==
X-Google-Smtp-Source: APXvYqz1klnI+JicjlHSILwVmAgCMBCf8uFMIPRpnQgichxAflgOYiv3BtroQsjhW4E4Xnf31qNvx8RZAloorw==
X-Received: by 2002:a1f:db01:: with SMTP id s1mr5441690vkg.34.1566388498141;
 Wed, 21 Aug 2019 04:54:58 -0700 (PDT)
Date:   Wed, 21 Aug 2019 12:49:24 +0100
In-Reply-To: <20190821114955.12788-1-maennich@google.com>
Message-Id: <20190821114955.12788-10-maennich@google.com>
Mime-Version: 1.0
References: <20190813121733.52480-1-maennich@google.com> <20190821114955.12788-1-maennich@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH v3 09/11] usb-storage: remove single-use define for debugging
From:   Matthias Maennich <maennich@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com, arnd@arndb.de,
        geert@linux-m68k.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        jeyu@kernel.org, joel@joelfernandes.org,
        kstewart@linuxfoundation.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-modules@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, lucas.de.marchi@gmail.com,
        maco@android.com, maco@google.com, michal.lkml@markovi.net,
        mingo@redhat.com, oneukum@suse.com, pombredanne@nexb.com,
        sam@ravnborg.org, sspatil@google.com, stern@rowland.harvard.edu,
        tglx@linutronix.de, usb-storage@lists.one-eyed-alien.net,
        x86@kernel.org, yamada.masahiro@socionext.com
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

