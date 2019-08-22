Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C9AC3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 09:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EC7C2339F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 09:19:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T2pMI6y+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733170AbfHVJTL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 05:19:11 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:43541 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733152AbfHVJTK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2019 05:19:10 -0400
Received: by mail-wr1-f46.google.com with SMTP id y8so4668007wrn.10
        for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2019 02:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=8fMTG6N2j/TMUB2P1ujx2DtHjddT/TmmdRfnCuZ9XY0=;
        b=T2pMI6y+G8IKrsK8J/v9Hw6Ze7VNU1QAegTQBtAa7YoAqIMV7jl4rsOxqLr2uKv+7E
         qU8OpzWDLx9aa2GeALCMNY10DH8xUmpEvSQpL0ayo6EJseiHy6wUP019c/nCCacrOqhB
         QB+3d2H2f0vEl7LtOw9XPlAwhFizRTqjD3JcaH9+n+VKUvYDS9r4fRpDwq0+iXaszL13
         J3sknRZdTSR9IJXI8txUWEFdl9+uB5tH3eqzTb0H6t3MUJTXPo1J+pZxj4+FMYBI1PHv
         B9TvUD/P3C3CaL5RpMtkMMjLBIWW2hdg5F7iwFp/hNbtITgX9r32GojgJ+PW0XbAEkM3
         Pdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=8fMTG6N2j/TMUB2P1ujx2DtHjddT/TmmdRfnCuZ9XY0=;
        b=YlbcWp/Um3blmZKZ/tqc6wpy1g/ZyJ3OlQS4COIXd8uh3wRIV3hsVzQMqTLRI/vvjH
         EocrMe3qqOehYwMFJvGbCkLdwyFADuQ4V3DYpdOyotYMS98EJXye9bltWHIDNBc31OcS
         FlMJk59N+cYLodVYl3m/cS2ABkgQAy3dZx2/Qm0CANeeyLq6wKT3U/by09cMQS4jhCpl
         AaLfYN/dIp/Cnc3BdGOUgdvt1inONAjjQq9UcP1eJUCftfB4K8c02vGMCFv6o9a4c9eb
         qunYE+KRctNq+EznSJ6h/xEdymECbXM6Qd2R6c70OXxr+gjXhI3rE1BwT0ph1pKf/Bjd
         0A1Q==
X-Gm-Message-State: APjAAAVXPl7uxZF8accFKwl5BS9azp9qAJOqQ8cR1cczxxvBN4rEEIVh
        IE4WOhSEzPu6YcvuywouDPP4ig==
X-Google-Smtp-Source: APXvYqzPaTB9as2RdUevNC/gvIlaqvXJBR28ZGeYWGl/cnFEEuvQi+58LrWHZHhwnpFu/CiJ7AkAEg==
X-Received: by 2002:a5d:4101:: with SMTP id l1mr4986587wrp.202.1566465543440;
        Thu, 22 Aug 2019 02:19:03 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:e8f7:125b:61e9:733d])
        by smtp.gmail.com with ESMTPSA id 4sm46118162wro.78.2019.08.22.02.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 02:19:02 -0700 (PDT)
Date:   Thu, 22 Aug 2019 10:18:58 +0100
From:   Matthias Maennich <maennich@google.com>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Martijn Coenen <maco@android.com>, cocci@systeme.lip6.fr,
        kernel-janitors@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-modules@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        kernel-team@android.com, usb-storage@lists.one-eyed-alien.net,
        x86@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jessica Yu <jeyu@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Martijn Coenen <maco@google.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Oliver Neukum <oneukum@suse.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sandeep Patil <sspatil@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [v2 08/10] scripts: Coccinelle script for namespace dependencies
Message-ID: <20190822091858.GA60652@google.com>
References: <20190813121733.52480-9-maennich@google.com>
 <1c4420f4-361c-7358-49d9-87d8a51f7920@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1c4420f4-361c-7358-49d9-87d8a51f7920@web.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 15, 2019 at 03:50:38PM +0200, Markus Elfring wrote:
>> +generate_deps_for_ns() {
>> +    $SPATCH --very-quiet --in-place --sp-file \
>> +	    $srctree/scripts/coccinelle/misc/add_namespace.cocci -D ns=$1 $2
>> +}
>
>* Where will the variable “srctree” be set for the file “scripts/nsdeps”?
>

$srctree is defined by kbuild in the toplevel Makefile.

>* Would you like to support a separate build directory for desired adjustments?
>

No, as the purpose of this script is to directly patch the kernel
sources where applicable.

>* How do you think about to check error handling around such commands?
>
>

spatch emits a descriptive message on error. I will add a 'set
-e' to the script so that it aborts on errors.

>> +generate_deps() {
>…
>> +        for source_file in $mod_source_files; do
>> +            sed '/MODULE_IMPORT_NS/Q' $source_file > ${source_file}.tmp
>…
>
>I suggest to assign the name for the temporary file to a variable
>which should be used by subsequent commands.

I somehow don't agree that this is an improvement to the code as the
variable would likely be something like ${source_file_tmp}. Sticking to
${source_file}.tmp does express the intent of a temporary file next to
the original source file and the reader of the code does not need to
reason about the value of ${source_file_tmp}.

Cheers,
Matthias
