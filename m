Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0149EC32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 12:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB2E020679
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 12:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a214pvbW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfHNMyk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 08:54:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40693 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbfHNMyf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 08:54:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id c3so2731485wrd.7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 05:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/HqwVHo+/VGU/O3Ao2yHcSMYTRRkF5dGkjofFJ4lQDI=;
        b=a214pvbWsUYqE7gFah0NDcz7JM2UYBy76uQcdIF2EkF002SXmrJWUGewBWbFk/2SA+
         YUtGYjT48o6iTu5GykHi2ODU4FThxYcbsQdQc0xdD7uHoB8yf+oispewNpo8rzLPOUio
         S67e2fNzvfOzCGAN9Y6qxipWccwRr5vHIR8ykTNcwP3KsJhc3d9k17Tds78XuI66px6+
         D8rNX2s/Jnk2pVrAQoCAj5Am5Y/TyHPkOKoTomK0JdBDMU0ioLWBdoNAlfKE3cTYNcsP
         rKem4Pk+x1q2rKdqQ87as+E/PkdUnfo7GDTHbDBG7fkMACdUIM/tx9rjyww93IMEH/TV
         8lGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/HqwVHo+/VGU/O3Ao2yHcSMYTRRkF5dGkjofFJ4lQDI=;
        b=UGgbGw4ZIA5ND51pMsNBHV0aPA/41V+p2JCKXsAAGW0qJ2iZ418sW2jvu2NFo0gsTU
         pwfwyN4aflkHiq7giT7auLj7jalHs3/pEWZm1jB6Pv+z7GALVy+m0Ac/hRgTDxxk7hPb
         2wK7VX/ZLLNw48eeiJt8bEnhGhpDcuz7+mFhqzo87qipbMQ3vPXK1wbNVIXCCstDlVOg
         3vu8ZLTGD0B2ms/QCA4XL8RXp+M2/6fZ5ykNYYzR6fFURTAHw/gDhGIhRWuI4/DGdRRn
         ZBKKbYsf8hRzfX+s7vPOH9Te57tvFhJN4lzV9lqgmIKP6U+A3GPS3Xl+3ZID95xsDbUi
         aRgA==
X-Gm-Message-State: APjAAAV6Xcl5/9Ck7aCeIqMD3fFkd/7KNZII+8i+stb67YIVseBznRFy
        wIg/ePYw3/eAOHISterIvmWNfg==
X-Google-Smtp-Source: APXvYqxkrHVC6b0ZSbTKxO4CqracBUS6OzqIGTAg1coGZhxQ2Dg7Lj2RxDEodMoA9y4fuBbu63dSdw==
X-Received: by 2002:adf:d1b4:: with SMTP id w20mr46171829wrc.301.1565787272814;
        Wed, 14 Aug 2019 05:54:32 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:e8f7:125b:61e9:733d])
        by smtp.gmail.com with ESMTPSA id n9sm163817113wrp.54.2019.08.14.05.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 05:54:32 -0700 (PDT)
Date:   Wed, 14 Aug 2019 13:54:27 +0100
From:   Matthias Maennich <maennich@google.com>
To:     Saravana Kannan <saravanak@google.com>
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
        Sandeep Patil <sspatil@google.com>, stern@rowland.harvard.edu,
        tglx@linutronix.de, usb-storage@lists.one-eyed-alien.net,
        x86@kernel.org, yamada.masahiro@socionext.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Patrick Bellasi <patrick.bellasi@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Adrian Reber <adrian@lisas.de>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH v2 05/10] module: add config option
 MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS
Message-ID: <20190814125427.GA72826@google.com>
References: <20180716122125.175792-1-maco@android.com>
 <20190813121733.52480-1-maennich@google.com>
 <20190813121733.52480-6-maennich@google.com>
 <CAGETcx_LQDdnaU+3JVGw+6=DJ8tRoQ00+3rD2gOiHHkWomt8jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGETcx_LQDdnaU+3JVGw+6=DJ8tRoQ00+3rD2gOiHHkWomt8jg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 13, 2019 at 01:15:44PM -0700, Saravana Kannan wrote:
>On Tue, Aug 13, 2019 at 5:19 AM 'Matthias Maennich' via kernel-team
><kernel-team@android.com> wrote:
>>
>> If MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is enabled (default=n), the
>> requirement for modules to import all namespaces that are used by
>> the module is relaxed.
>>
>> Enabling this option effectively allows (invalid) modules to be loaded
>> while only a warning is emitted.
>>
>> Disabling this option keeps the enforcement at module loading time and
>> loading is denied if the module's imports are not satisfactory.
>>
>> Reviewed-by: Martijn Coenen <maco@android.com>
>> Signed-off-by: Matthias Maennich <maennich@google.com>
>> ---
>>  init/Kconfig    | 14 ++++++++++++++
>>  kernel/module.c | 11 +++++++++--
>>  2 files changed, 23 insertions(+), 2 deletions(-)
>>
>> diff --git a/init/Kconfig b/init/Kconfig
>> index bd7d650d4a99..b3373334cdf1 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -2119,6 +2119,20 @@ config MODULE_COMPRESS_XZ
>>
>>  endchoice
>>
>> +config MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS
>> +       bool "Allow loading of modules with missing namespace imports"
>> +       default n
>> +       help
>> +         Symbols exported with EXPORT_SYMBOL_NS*() are considered exported in
>> +         a namespace. A module that makes use of a symbol exported with such a
>> +         namespace is required to import the namespace via MODULE_IMPORT_NS().
>> +         This option relaxes this requirement when loading a module.
>
>> While
>> +         technically there is no reason to enforce correct namespace imports,
>> +         it creates consistency between symbols defining namespaces and users
>> +         importing namespaces they make use of.
>
>I'm confused by this sentence. It sounds like it's the opposite of
>what the config is doing? Can you please reword it for clarify?

How about:

  Symbols exported with EXPORT_SYMBOL_NS*() are considered exported in
  a namespace. A module that makes use of a symbol exported with such a
  namespace is required to import the namespace via MODULE_IMPORT_NS().
  There is no technical reason to enforce correct namespace imports,
  but it creates consistency between symbols defining namespaces and
  users importing namespaces they make use of. This option relaxes this
  requirement and lifts the enforcement when loading a module.

-- 
Cheers,
Matthias
