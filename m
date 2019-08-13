Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9711EC32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 12:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C2F920874
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 12:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kj2QCgHK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfHMMTK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 08:19:10 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:45717 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbfHMMTJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 08:19:09 -0400
Received: by mail-qk1-f202.google.com with SMTP id k125so95948723qkc.12
        for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2019 05:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ey51rOQs6pREeIh9cdmyj66W3XNY9zI3cHQpc2k+3HQ=;
        b=Kj2QCgHK1EXGXCElMh+j+E+YRK/wfgittksUPJYKcCq2HTXcsAROuHGcD8lwzMPeKN
         FRuEY4ZJ4B5K6zrA1HwL334EfWDTWdX3NtetiJHeWa9GorOQdftb7ZFl6EKSx4u3xZc/
         7wihld+w2BBSts7l0IWFmsA8phk/UcL6zJVHc/saACvhutCrFbaf8mO23uze0QWnNBrq
         vYTou4ilb8mGMgPL02Xng92+rEko2PdVT7rfXODuJ6MfFN3kroS9fkNmsFz5YKN59B1J
         z/cX3txyE3JspEYroOPPq3rlFHs4ewel3KUPhHTQrUFBOOUrKm5bW9fgQpBKQKrxy7dA
         pBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ey51rOQs6pREeIh9cdmyj66W3XNY9zI3cHQpc2k+3HQ=;
        b=oXrstTQ4xXH7zkrIZbvxHOh8hL3zJtSYhVPjZqKnL/Lxh5ztQT9+h9eyBXvWkBN73J
         PBHMRYstYpDAtvcpsYZUuYvO93f263yV84dXot9lMznDNf++5lI87posJiUrRh5FIsiI
         Buot4EJIea/M2MSAMGtgViVwY/daRWwyliIbbmYHlgrSHabAYgMeDTBsYKD8YdoSAowP
         0RQhH1FzySGhBnwco4hXIzZPXD91pAxV6PW1YWUN5CODFQZt+zEAZtMgod4MfQd1VffY
         qS6u1sUuHQ3zwanw01KS1ZSgAXCV/bCWdZsKDKnwuV9KO2uSJtMBkrWuljzrPZlqn6r/
         +cUg==
X-Gm-Message-State: APjAAAWsOmsLyjvsSQ85mg9Z88Ud62n/djz+1WMbdog4yKfnDJDg1e+A
        b/oOu8Ut1eHZeKd1xkSW8rfG8cmRAdRLsQ==
X-Google-Smtp-Source: APXvYqx8Z3ce2Fq34vvTXoHfRI3jPxZxSV8ZFlwOArOAxzvMMWLUaLTe8i8AZbmoFtb4lXGU8fZ6nZcq2n3UrA==
X-Received: by 2002:a37:6844:: with SMTP id d65mr33008934qkc.398.1565698748030;
 Tue, 13 Aug 2019 05:19:08 -0700 (PDT)
Date:   Tue, 13 Aug 2019 13:16:58 +0100
In-Reply-To: <20190813121733.52480-1-maennich@google.com>
Message-Id: <20190813121733.52480-2-maennich@google.com>
Mime-Version: 1.0
References: <20180716122125.175792-1-maco@android.com> <20190813121733.52480-1-maennich@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH v2 01/10] module: support reading multiple values per modinfo tag
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

Similar to modpost's get_next_modinfo(), introduce get_next_modinfo() in
kernel/module.c to acquire any further values associated with the same
modinfo tag name. That is useful for any tags that have multiple
occurrences (such as 'alias'), but is in particular introduced here as
part of the symbol namespaces patch series to read the (potentially)
multiple namespaces a module is importing.

Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Martijn Coenen <maco@android.com>
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 kernel/module.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 5933395af9a0..a23067907169 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2481,7 +2481,8 @@ static char *next_string(char *string, unsigned long *secsize)
 	return string;
 }
 
-static char *get_modinfo(struct load_info *info, const char *tag)
+static char *get_next_modinfo(const struct load_info *info, const char *tag,
+			      char *prev)
 {
 	char *p;
 	unsigned int taglen = strlen(tag);
@@ -2492,13 +2493,25 @@ static char *get_modinfo(struct load_info *info, const char *tag)
 	 * get_modinfo() calls made before rewrite_section_headers()
 	 * must use sh_offset, as sh_addr isn't set!
 	 */
-	for (p = (char *)info->hdr + infosec->sh_offset; p; p = next_string(p, &size)) {
+	char *modinfo = (char *)info->hdr + infosec->sh_offset;
+
+	if (prev) {
+		size -= prev - modinfo;
+		modinfo = next_string(prev, &size);
+	}
+
+	for (p = modinfo; p; p = next_string(p, &size)) {
 		if (strncmp(p, tag, taglen) == 0 && p[taglen] == '=')
 			return p + taglen + 1;
 	}
 	return NULL;
 }
 
+static char *get_modinfo(const struct load_info *info, const char *tag)
+{
+	return get_next_modinfo(info, tag, NULL);
+}
+
 static void setup_modinfo(struct module *mod, struct load_info *info)
 {
 	struct module_attribute *attr;
-- 
2.23.0.rc1.153.gdeed80330f-goog

