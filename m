Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34832C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 03:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbjFHDLH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 23:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjFHDLF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 23:11:05 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507881FCC;
        Wed,  7 Jun 2023 20:11:04 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id 006d021491bc7-558a7faa989so86307eaf.1;
        Wed, 07 Jun 2023 20:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686193863; x=1688785863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVv0WmiPBkvHnpM4wciZoOdFpdVlJtYuVG+P5KmWvKs=;
        b=C2lqtC4kb8IueyvNg14bgzJHz7IijFzuVhv9wlLXnU2hAk9DJ0dppZHWl08ts7w8pv
         1m4a0OIDx9G3L+LyTricAgAwd19PGPd6N3MgstC0/Feco0Bcx/uSHzphmQ0j1Houm5t7
         M+KM3LpR+opun8YDCQOY++L3xSzb5N6Ut6EJGuQn+oNJHwFBxu35+2rV6BUzHlOnRaF3
         nJC9ZSF5VaBfYCDZaPuP0GZy3zESZojZ+WLGt97FNMU3cSNVgEsAiSNOCE0tbw/kUugx
         MEZSSpE7A+/JkQeAz2W52oumObzUVKQiq3il4wEEsbU2SocEpikFz24wmEGETDGnP62s
         yJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686193863; x=1688785863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TVv0WmiPBkvHnpM4wciZoOdFpdVlJtYuVG+P5KmWvKs=;
        b=A/XdOF4wlHk/1U2CflsAkWmJr3ikniDXYSMar8rMN1goaEMpySfSWvPOWJOGg4wzuA
         jJ6O1YTLwkDlaXlpKkHNKja74iINy2Y29vQ+TP00eNwSpHnRylXEX/wznY31nWoY6QUJ
         4Okd0ysS3fN1lt3RIuT4u4vEiVdjDV8YSHONDWq8bCjmxHcTyxX2oZeTnUH6L000nXX9
         schCe/lqCwsb5vtLwIo6/XJOc8NA/FQWvEYLLPeE801zr4ntt0YeRc5zI3nCvrGg1lZ5
         LUckG7SXAvsGf+iytrMdEP0hAA6QhwSIdU31Kt4rHoWgDZ15HNGs7HtqYnl0PJ6LnVsa
         6Tmg==
X-Gm-Message-State: AC+VfDxZ6sd3PeqHz5WlGAJ6MKXnTZ7d8YBOo1KY2XDCgZ5SIYr+BKrU
        /Q6z1Es7wnYCXy0LWTkvWEFMhX1Rk+mVrM/cj3hcWwm+
X-Google-Smtp-Source: ACHHUZ6Sv2lxD1fsTeKj0IaYTHigGZ8yfJkKVDQYKsCYl7c9pS43hNKwJai62DnwlJSBvdrky1os2wKAXk4VGSwutnI=
X-Received: by 2002:a05:6358:611a:b0:129:cbc5:95ca with SMTP id
 26-20020a056358611a00b00129cbc595camr1750336rws.16.1686193862688; Wed, 07 Jun
 2023 20:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230606051217.2064-1-iecedge@gmail.com> <ZICP8GFjPSu7rOjv@infradead.org>
In-Reply-To: <ZICP8GFjPSu7rOjv@infradead.org>
From:   Jianlin Lv <iecedge@gmail.com>
Date:   Thu, 8 Jun 2023 11:10:50 +0800
Message-ID: <CAFA-uR9C0hu0o6C5b-3B0i7xBVUTJ+BbuYRYp10jAEUD+1gp3A@mail.gmail.com>
Subject: Re: [PATCH] scsi: sd: support specify probe type of build-in driver
To:     Christoph Hellwig <hch@infradead.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, paulmck@kernel.org,
        bp@suse.de, peterz@infradead.org, will@kernel.org,
        rdunlap@infradead.org, kim.phillips@amd.com, rostedt@goodmis.org,
        wyes.karny@amd.com, jianlv@ebay.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 7, 2023 at 10:10=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Tue, Jun 06, 2023 at 05:12:17AM +0000, Jianlin Lv wrote:
> > When SCSI disks are located on different SCSI hosts within a system,
> > asynchronous detection can lead to non-deterministic SCSI disk names.
>
> Yes, as can various other conditions.  Your code better be able to deal
> with that.

Could you give an example about "other conditions" ?

Jianlin
