Return-Path: <SRS0=MIBM=WR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8BCC3A5A0
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 11:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8135E2339E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 11:54:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sL78SFBJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfHULyc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Aug 2019 07:54:32 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:51405 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbfHULyc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2019 07:54:32 -0400
Received: by mail-vs1-f73.google.com with SMTP id 125so619415vsr.18
        for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2019 04:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rT0KSU6kg1U7KAakAlt0j+Yalj1dCKE373XdhjaHS/Y=;
        b=sL78SFBJ7FLQgHM0KvFFBQfHGyZBRIG9AKMMPahPrreho6GZ7q/hi1HXcChLC7EStO
         Ojrr18OFXwtTmjjJGN2mirgUwSuhnghkVNaYnBO9OFrTnLuS2GdPAaYBmv4cqljzY8Jl
         EbcPdMJPRYjW4xTocUDZ0DUWLHN7qa3uA82NvUxR8jbI+KfBdv4C/qi0yrz6m1JKUJV3
         APKYs3B0H/xC+dXi9Or4SKjhuHehlV48wcTBTXAIe4N3IU/1KA+PGO9xSwfC//sr9iTR
         13qg8sPQBD24vebJsBEVWuh2b3IIdnKFAhy7luPXgP+dREwvWqQStxe9jGj+9mGONgEh
         OHkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rT0KSU6kg1U7KAakAlt0j+Yalj1dCKE373XdhjaHS/Y=;
        b=XF4lGWkhQ2RvzTNpJP7MoPjg7rKxyeA7pr4zqLJO56MHe7bHREy8kfJaYWw4kD68vI
         LAdL9PzguKktzsIhf0eSwPJYe01JEt2EqOGSwdjhFYUGXEq7yxZdUuDBEIJ/kjYUoJXP
         3ci7enoixKRDywYBUznFIkzljm80lB3N2RUdTf4ozeozg1eKioLqVtXv25dIiacZEUxe
         0PYDdFQ49VJ6KTcUYrT0XRbimgJ2l5PbVjwPSCK29+BJKATO2UttfAD7MDFwUm3VndE/
         aChXF7OgIwq7fv8Fr037mckuiOochaM3WmBiiIvlxYsWI6A2rkJvih4CYLDdRSHlWgtV
         Xi7Q==
X-Gm-Message-State: APjAAAV7ULLueJS2HIjq9aDCy3/UKEkLKPFVvFJfLJTuseuc1oGm23/p
        yqtjpn0+K/6i7YNfHMnQosJMGmYLtjvl+A==
X-Google-Smtp-Source: APXvYqwJa5MMHL1L/Kpr0qJVI9N7n4kQrm4ogFR+PTqANm6lE14ye/6fboCOGimHuOIQftsP5yUiGv+IVJhNKw==
X-Received: by 2002:ab0:5fd4:: with SMTP id g20mr2062332uaj.111.1566388470706;
 Wed, 21 Aug 2019 04:54:30 -0700 (PDT)
Date:   Wed, 21 Aug 2019 12:49:21 +0100
In-Reply-To: <20190821114955.12788-1-maennich@google.com>
Message-Id: <20190821114955.12788-7-maennich@google.com>
Mime-Version: 1.0
References: <20190813121733.52480-1-maennich@google.com> <20190821114955.12788-1-maennich@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH v3 06/11] export: allow definition default namespaces in
 Makefiles or sources
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
        x86@kernel.org, yamada.masahiro@socionext.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        Ingo Molnar <mingo@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To avoid excessive usage of EXPORT_SYMBOL_NS(sym, MY_NAMESPACE), where
MY_NAMESPACE will always be the namespace we are exporting to, allow
exporting all definitions of EXPORT_SYMBOL() and friends by defining
DEFAULT_SYMBOL_NAMESPACE.

For example, to export all symbols defined in usb-common into the
namespace USB_COMMON, add a line like this to drivers/usb/common/Makefile:

  ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=USB_COMMON

That is equivalent to changing all EXPORT_SYMBOL(sym) definitions to
EXPORT_SYMBOL_NS(sym, USB_COMMON). Subsequently all symbol namespaces
functionality will apply.

Another way of making use of this feature is to define the namespace
within source or header files similar to how TRACE_SYSTEM defines are
used:
  #undef DEFAULT_SYMBOL_NAMESPACE
  #define DEFAULT_SYMBOL_NAMESPACE USB_COMMON

Please note that, as opposed to TRACE_SYSTEM, DEFAULT_SYMBOL_NAMESPACE
has to be defined before including include/linux/export.h.

If DEFAULT_SYMBOL_NAMESPACE is defined, a symbol can still be exported
to another namespace by using EXPORT_SYMBOL_NS() and friends with
explicitly specifying the namespace.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Martijn Coenen <maco@android.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 include/linux/export.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/export.h b/include/linux/export.h
index 8e12e05444d1..1fb243abdbc4 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -166,6 +166,12 @@ struct kernel_symbol {
 #define __EXPORT_SYMBOL ___EXPORT_SYMBOL
 #endif
 
+#ifdef DEFAULT_SYMBOL_NAMESPACE
+#undef __EXPORT_SYMBOL
+#define __EXPORT_SYMBOL(sym, sec)				\
+	__EXPORT_SYMBOL_NS(sym, sec, DEFAULT_SYMBOL_NAMESPACE)
+#endif
+
 #define EXPORT_SYMBOL(sym) __EXPORT_SYMBOL(sym, "")
 #define EXPORT_SYMBOL_GPL(sym) __EXPORT_SYMBOL(sym, "_gpl")
 #define EXPORT_SYMBOL_GPL_FUTURE(sym) __EXPORT_SYMBOL(sym, "_gpl_future")
-- 
2.23.0.rc1.153.gdeed80330f-goog

