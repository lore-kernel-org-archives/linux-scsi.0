Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7891C04A94
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Aug 2023 15:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbjHLPc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Aug 2023 11:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbjHLPcy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Aug 2023 11:32:54 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475521706
        for <linux-scsi@vger.kernel.org>; Sat, 12 Aug 2023 08:32:57 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-522bd411679so3804380a12.0
        for <linux-scsi@vger.kernel.org>; Sat, 12 Aug 2023 08:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1691854375; x=1692459175;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JwnWLFinw653oNORKs4oXtvLbt2zukEGt8KGvHgfiqE=;
        b=GxrL/xwGoGAAZgQOKN5/zptPrlOzgbYeNVlWnVR+/Edj1v0XD9U15hIFQb28kLr+yB
         fqXgGeLP2IA5NmIxIY3nXFJLe5sw7AZYPLjQ8cYX5owk8MOIhDT/cP5leHKH4ZRRyVhA
         GNZPwYOCFklYE5b0uPNwzi2u3P0mYi3un5qWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691854375; x=1692459175;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JwnWLFinw653oNORKs4oXtvLbt2zukEGt8KGvHgfiqE=;
        b=MbQ/CVv+/Vwnq2atw81BamybljKWdEIgwlWrM6zbW1HqMWJg2CMxVukW+NZ/DQECPt
         U3fIlKKgYhlr3uU1L/MvE76DQl/pFhRwfGbGaeAXp82jdshMXL3Iwsr8Vw6lPwMlgLas
         xZkwPmWRIpwxHwftCECjGciQWApTCehDHEjesLLTlXmctrVfXb0GOsDlL8zZQXgVDvXk
         H1stPxhYnNLJhIgKelmoupwgaV0GR+LuuuNJNnfVt6xhtZT2Ir3EF0DkzgecKOONUxPp
         61APK2C2QDPbjZsS72QNZrJ/c41hkFEFt0ZZTFBg4jBN9NrVvx75OW0YnJRFujjt+Bxx
         E1KQ==
X-Gm-Message-State: AOJu0YyEw9v/pFqGIXokvgIuJrJtcatJ+JvZVIGaaAOaKJgM5S+ycNoK
        JFGC7PTngS6tRbxtvfldL7cVmDwo8BET09zEuY0N0F0V
X-Google-Smtp-Source: AGHT+IGAW4mvA3s32j/B3FrUNi3mYVxipipSQx12S2D81Wr8rOrs7AfZWnSYjWZNjU6MNRuS5luZSg==
X-Received: by 2002:aa7:dcda:0:b0:523:cc3d:9121 with SMTP id w26-20020aa7dcda000000b00523cc3d9121mr3777473edu.14.1691854375563;
        Sat, 12 Aug 2023 08:32:55 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id j5-20020aa7c405000000b005232cf13b02sm3385467edq.37.2023.08.12.08.32.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Aug 2023 08:32:54 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-52340d9187aso3791052a12.3
        for <linux-scsi@vger.kernel.org>; Sat, 12 Aug 2023 08:32:54 -0700 (PDT)
X-Received: by 2002:a50:ed06:0:b0:523:10fa:e132 with SMTP id
 j6-20020a50ed06000000b0052310fae132mr4112327eds.23.1691854373968; Sat, 12 Aug
 2023 08:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <4987ff9fa2467bc036759afac47b95c77a415963.camel@HansenPartnership.com>
In-Reply-To: <4987ff9fa2467bc036759afac47b95c77a415963.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 12 Aug 2023 08:32:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=whk-PxHDjEe_kNN-ZANc032cnYTd9unO8OBQqUq6C6fqw@mail.gmail.com>
Message-ID: <CAHk-=whk-PxHDjEe_kNN-ZANc032cnYTd9unO8OBQqUq6C6fqw@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 6.5-rc5
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 11 Aug 2023 at 23:45, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The short changelog is:

Hmm. Neither the shortlog nor the diffstat matches what I get, and you
also have a non-standard truncated pull-request format that doesn't
even show the expected top commit etc, so I think I'll just unpull and
wait for you to actually verify what you sent me and make a new pull
request that matches what the git contents are..

              Linus
