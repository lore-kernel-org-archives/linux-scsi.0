Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEAAC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 07:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiGLH7y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiGLH7s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 03:59:48 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA4824F04;
        Tue, 12 Jul 2022 00:59:47 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id p11so117539pgr.12;
        Tue, 12 Jul 2022 00:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=HhXF/f+tupsvKDdwkiCFSc88Rl/3LeEEO8n8dKCnlfM=;
        b=dzAR3oIv2NKSkhluYyxrGpYP+aqyiRcCAewQCKvji71/3X1s1NaUPz974KEPb9tD5S
         tzsIHo4vCnGQBUsiNmVerBFYamlm53CgCmY1s5nw3866sg2ffmYhfUts2s+oOKA9Q8dY
         Id3lMBmTOH1GfRNuVImHYtUzn+3F6pEGqFjC+8/4gtUS7mRBc/4odZCETX65Xw9A5flW
         gGab8SCyEpXc2jws8m8ZAgLo5xWTjPSbOvE2y9ExQigpi7tbFIQs5LSWO5o091p+jMQz
         xgk+Jm6VMFDrIU3XFmiAhFGghk5/7qprm89kx4lnVEMmVXnFEeeMxMPQt5cTpsha6QIb
         ElHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=HhXF/f+tupsvKDdwkiCFSc88Rl/3LeEEO8n8dKCnlfM=;
        b=fl0vH05JYxh0UsFKJp9WMTqPiXFA5Hw4XXAKszdR4ELaAXgDOI1uXUfBUP1Ltb98gr
         0lSptb4ft6c9j8mFVYOHCsCc2HUWDZFD+MPfyk7AiKcFUJUBgh6lbM2OChJXfMpg6VLK
         gw84qDTVEuCiHwDMRibXmxJx5BWd3rXDLNM+PF3xRPPVLf7ts8zO7WiVutvCWuZLs7GY
         x8EtTRHbnnz+3eheFeUFbZWYKFkZhWIiqW96dQSWzTMaVWDWSYiuDS+wqcnATe77CWtN
         1xxM+aQS1RgEOR9Xulk73oa6nIWOLG+dnO/GRMgAbogudho3l5yu8zYUBEN3DETxy58q
         YMLw==
X-Gm-Message-State: AJIora/9/iykcEmUKn0zuDsv+rSPvdFXiOXY/iItcykjyvZ4f4THQsTR
        wSgr2j2GX6sygHjGNpzvoSuGsjhIWBU=
X-Google-Smtp-Source: AGRyM1sSY5DRv83tYJl2jURi0VF3hAU4q6xxBSQma7vIpJR27Nxgt+h8R1sACjOmPlj7UrDmGlmHXA==
X-Received: by 2002:a63:6e08:0:b0:40c:7557:c4aa with SMTP id j8-20020a636e08000000b0040c7557c4aamr19734439pgc.356.1657612786676;
        Tue, 12 Jul 2022 00:59:46 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902ecc700b0016c454598b5sm3893526plh.167.2022.07.12.00.59.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jul 2022 00:59:46 -0700 (PDT)
Subject: Re: [PATCH v1 3/4] scsi - convert mvme146_scsi.c to platform device
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <20220709001019.11149-1-schmitzmic@gmail.com>
 <20220709001019.11149-4-schmitzmic@gmail.com>
 <CAK8P3a0FndsCkCrgXdai8=2oX5yWrMLArDHN5mA90AL4N7pmRw@mail.gmail.com>
 <CAMuHMdXapPSOBzSNTLy_RJV=RLq-6hcf-XFtvfSe-g=PrcAhEw@mail.gmail.com>
 <fb5f0f5d-e144-3f5b-9e46-6e22d8a3ca60@gmail.com>
 <CAMuHMdVYpQCVhti34y-bNwn-nOFaN7w-xM-SBZbHh+oDwbRndw@mail.gmail.com>
 <a4a3908a-29c5-fe2e-4c58-eed59133d39f@gmail.com>
 <f565782c-6463-d962-13ce-01c5f0d160e7@gmail.com>
 <CAMuHMdXMvQ+c=zm8W2AFnSfqxHUGbDEBXNUYBYx1CXH7GTBGpg@mail.gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <16add96f-7ab9-af7c-6f7e-aaa0f6adbaac@gmail.com>
Date:   Tue, 12 Jul 2022 19:59:42 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXMvQ+c=zm8W2AFnSfqxHUGbDEBXNUYBYx1CXH7GTBGpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Geert,

thanks - v2 sent with these edits just now.

Cheers,

	Michael


Am 12.07.2022 um 18:57 schrieb Geert Uytterhoeven:
> Hi Michael,
>
> On Tue, Jul 12, 2022 at 5:27 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> I just realized the commit message subject for this patch needs
>> correcting. Will that mess up your workflow (assuming I retain the
>> subject line for the announcement mail)?
>
> Np, I'm used to editing subject lines all the time ;-)
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
>
