Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF80C2D0DA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 16:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A3352075E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 16:09:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ScQxjOe9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfLYQJh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 11:09:37 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43328 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfLYQJh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Dec 2019 11:09:37 -0500
Received: by mail-pf1-f196.google.com with SMTP id x6so11018772pfo.10
        for <linux-scsi@vger.kernel.org>; Wed, 25 Dec 2019 08:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=u/nDjlcbflgCCSGswkR/Gb0OiK0a4gLM34d62PDnrA4=;
        b=ScQxjOe94We9p7R1WNUxeCMsZH6iEsiDolSRhlzsmgOyoh7pNg+IodoyDXjokBc7YT
         ZvZrlBcJlXWRjp6YvM4Feq0Mc68Y2f7UUqxequD7AhtqsTuuTxIZgaUze43QGSWZdBhZ
         X/Ce1/JQOErMznpm+pf4EeSgnquLnuoHruLncaax9TZXKjpSCB7UGESBlP97SrTpIKkH
         mZkb4qSPRpy07yUB3DBA5RNy6Sb5Qq0KVVJ6iZVplFE+gGMtnkXzdfrOLitbLC+qEHcH
         mwKQtCR13McnNxth5yHS0OfCZPOW3QehnK0sggOI7oZKsqW3pr035qD4QzX2sfQ8qba4
         GnXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=u/nDjlcbflgCCSGswkR/Gb0OiK0a4gLM34d62PDnrA4=;
        b=Qd41punkQ2R3e0foFZY4DDv/shz0Zh3C1klBYmgwlHSfcFsh+XNkydg/11YtWF/q9Z
         CfQrxPDB5D6CN00QH80VAJps1wer2VL96jOpawb7xv/XnA5Gfe0HQ9+PW+xKbVvetA3Y
         NLifwDfWuLKdas0Fb4rbJrMQvd4HKOjYVUh+lB9xJj9yZcB+Fb/y7Q99pUZXzftQZwM8
         pLF3X9WTDRfC15OSJfTeO5I1johXvpcpWNY9/OdJh0DnVk3P6SGXDaS0fwvi4U0PYfll
         TZlba3d7qHvIOwMCNHTVJ3v56xFZbVXCNiXxS2LIGYwfVsR29N5wM0/28ss5KA1esbYO
         cbnQ==
X-Gm-Message-State: APjAAAWK8dQA2caFGNFUWbseaYM9NpTkl2mUA1f7RdiOFEIqioVCjVAN
        b1GfrrwbrdRcxXI7MCgJxB8=
X-Google-Smtp-Source: APXvYqxLtawnyWLUEExMyv9wCaQszMm3X85ubS8Sv1LqB5C6dZ/eQFI+yuP91QA9WM03+wwZkAPACA==
X-Received: by 2002:a63:4850:: with SMTP id x16mr45118018pgk.334.1577290176828;
        Wed, 25 Dec 2019 08:09:36 -0800 (PST)
Received: from [192.168.1.47] (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id b21sm34173874pfp.0.2019.12.25.08.09.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Dec 2019 08:09:36 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH v2 32/32] elx: efct: Tie into kernel Kconfig and build
 process
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20191224210151.GA19657@ubuntu-m2-xlarge-x86>
Date:   Wed, 25 Dec 2019 08:09:34 -0800
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com, dwagner@suse.de,
        bvanassche@acm.org, Ram Vegesna <ram.vegesna@broadcom.com>,
        clang-built-linux@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <19A235FE-7C54-4AB5-8F58-938E7BAD1BE5@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-33-jsmart2021@gmail.com>
 <20191224210151.GA19657@ubuntu-m2-xlarge-x86>
To:     Nathan Chancellor <natechancellor@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 24, 2019, at 1:01 PM, Nathan Chancellor =
<natechancellor@gmail.com> wrote:
>=20
> On Fri, Dec 20, 2019 at 02:37:23PM -0800, James Smart wrote:
>> This final patch ties the efct driver into the kernel Kconfig
>> and build linkages in the drivers/scsi directory.
>>=20
>> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
>> Signed-off-by: James Smart <jsmart2021@gmail.com>
>=20
> Hi James,
>=20
> The 0day bot reported a few new clang warnings with this series. Would
> you mind fixing them in the next version? I've attached how I would
> resolve them inline, feel free to use them or fix the warnings in a
> different way.
>=20

Hi Nathan,

I will gladly take care of them

=E2=80=94 james=
