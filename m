Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77184C41514
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 20:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44E5E20840
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 20:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u5tsb3tT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfHMUQW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 16:16:22 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34280 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfHMUQV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 16:16:21 -0400
Received: by mail-ot1-f68.google.com with SMTP id c7so4473446otp.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2019 13:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UyUp+OqYNvHr6I8YI09IZ2rFvtcmnaGq+Mw13M6jPN8=;
        b=u5tsb3tTi1RR6zNjTfgZWL+OogXrZrPnWysy+aD045WOTKrJEAOdQ+FoeVDVShnWk8
         IUxR3CHP9QJCeKRIEu5zkDXbg533UBtKeFFvrT8aMs0H8udcayRxrdT1wNT0Q7DjM+sS
         mL7ptgRQR3Kx12kZaazSW3SAHUtuo7vVw4TkoT1AK64nHSlBLuaf+7EcyAJ5T6S5QZmR
         0bWGzUszfX/bI6keMRxfU+uUjHdXdUU/QzjKrIiA2xQ6qfej0kl/VN72xIxD8Mf/EjLz
         uehsPbPSUzPQEmNN3NMCxmwK4vIeJV4HWNcOe7l2n4qpKPfucbJ/Yfslg6NugGmdwR+m
         R1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UyUp+OqYNvHr6I8YI09IZ2rFvtcmnaGq+Mw13M6jPN8=;
        b=DB7/OURCcNjy1vWruTPeOm8zsWEnwxkdRX2+D6x/zKQ/qFMTXLMcZ3zvycSbtOB4IW
         GNCwDjwCtw8T1W1clX77nM9rin58DZOqZpPG+Jd/HySfdzkwW1muhHcI6GjStbBTA1IN
         flVSQc/mi+A92HS0y8j9CrRJC4rDSA+rURIgOI9RID/fuqAswiVfJillTagK0oFCZY39
         WMjgjWOMfUPlsQ/wURrYuRzCZjqwONOxvW5Kab2OBvyKCihaH8QAr0GlVw1V0ehTJqpo
         1GcQ4nnNHonmaZQUzNPlTDzrAhgi9B7zlOAblHuduzM4p5yiIxbD3DUIsxdi5lZmM/nZ
         0XAg==
X-Gm-Message-State: APjAAAWWGXAeOaCk7AED+yRg/kjhGzZXEaCmuqkrqUlTnWbsBxNjrE43
        CPpXSDxkgwoTIz16DTSkfa/S5Jp+3NgjZKMaaRw7NQ==
X-Google-Smtp-Source: APXvYqxxUtipoa1TnsBRCdHhtVbEni2JlDRwTgOYshKzIg8CEAX1O3Wj3b+RVL1fyBLVuGOUQHsFmCMdCl21V4krJY8=
X-Received: by 2002:a9d:6d06:: with SMTP id o6mr33264410otp.225.1565727380422;
 Tue, 13 Aug 2019 13:16:20 -0700 (PDT)
MIME-Version: 1.0
References: <20180716122125.175792-1-maco@android.com> <20190813121733.52480-1-maennich@google.com>
 <20190813121733.52480-6-maennich@google.com>
In-Reply-To: <20190813121733.52480-6-maennich@google.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 13 Aug 2019 13:15:44 -0700
Message-ID: <CAGETcx_LQDdnaU+3JVGw+6=DJ8tRoQ00+3rD2gOiHHkWomt8jg@mail.gmail.com>
Subject: Re: [PATCH v2 05/10] module: add config option MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS
To:     Matthias Maennich <maennich@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, maco@android.com,
        Android Kernel Team <kernel-team@android.com>, arnd@arndb.de,
        geert@linux-m68k.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, hpa@zytor.com,
        jeyu@kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        kstewart@linuxfoundation.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-modules@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, lucas.de.marchi@gmail.com,
        maco@google.com, michal.lkml@markovi.net, mingo@redhat.com,
        oneukum@suse.com, pombredanne@nexb.com, sam@ravnborg.org,
        sboyd@codeaurora.org, Sandeep Patil <sspatil@google.com>,
        stern@rowland.harvard.edu, tglx@linutronix.de,
        usb-storage@lists.one-eyed-alien.net, x86@kernel.org,
        yamada.masahiro@socionext.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Patrick Bellasi <patrick.bellasi@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Adrian Reber <adrian@lisas.de>,
        Richard Guy Briggs <rgb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 13, 2019 at 5:19 AM 'Matthias Maennich' via kernel-team
<kernel-team@android.com> wrote:
>
> If MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is enabled (default=n), the
> requirement for modules to import all namespaces that are used by
> the module is relaxed.
>
> Enabling this option effectively allows (invalid) modules to be loaded
> while only a warning is emitted.
>
> Disabling this option keeps the enforcement at module loading time and
> loading is denied if the module's imports are not satisfactory.
>
> Reviewed-by: Martijn Coenen <maco@android.com>
> Signed-off-by: Matthias Maennich <maennich@google.com>
> ---
>  init/Kconfig    | 14 ++++++++++++++
>  kernel/module.c | 11 +++++++++--
>  2 files changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index bd7d650d4a99..b3373334cdf1 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -2119,6 +2119,20 @@ config MODULE_COMPRESS_XZ
>
>  endchoice
>
> +config MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS
> +       bool "Allow loading of modules with missing namespace imports"
> +       default n
> +       help
> +         Symbols exported with EXPORT_SYMBOL_NS*() are considered exported in
> +         a namespace. A module that makes use of a symbol exported with such a
> +         namespace is required to import the namespace via MODULE_IMPORT_NS().
> +         This option relaxes this requirement when loading a module.

> While
> +         technically there is no reason to enforce correct namespace imports,
> +         it creates consistency between symbols defining namespaces and users
> +         importing namespaces they make use of.

I'm confused by this sentence. It sounds like it's the opposite of
what the config is doing? Can you please reword it for clarify?

-Saravana
