Return-Path: <SRS0=5ueY=ZC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111CFC43331
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 09:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DADC1207FA
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 09:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfKJJZg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 04:25:36 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:46728 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726617AbfKJJZg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Nov 2019 04:25:36 -0500
X-Greylist: delayed 1428 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Nov 2019 04:25:35 EST
Received: from [212.54.42.110] (helo=smtp7.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iTj6Q-0007eX-7D; Sun, 10 Nov 2019 10:01:46 +0100
Received: from mail-wm1-f47.google.com ([209.85.128.47])
        by smtp7.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iTj6Q-0001M6-3L; Sun, 10 Nov 2019 10:01:46 +0100
Received: by mail-wm1-f47.google.com with SMTP id c17so10280096wmk.2;
        Sun, 10 Nov 2019 01:01:45 -0800 (PST)
X-Gm-Message-State: APjAAAVTeSzHmryaI+wLoepgkrvQggIuUMLM2Zfh4+5eZqFDoimnZ7nD
        h5wuqq07u+sJbhnczDvR13KChMiwAGw+yP+vzSQ=
X-Google-Smtp-Source: APXvYqwuC6GaN6ATcqRAZjZ70igl0t9NjQ0rLMv5v8s70pHp/vIDO18KiEYxFjaudcG3+bQNsnQ6XF4FCIXpcpWZf+k=
X-Received: by 2002:a7b:c84b:: with SMTP id c11mr14347252wml.158.1573376505832;
 Sun, 10 Nov 2019 01:01:45 -0800 (PST)
MIME-Version: 1.0
References: <CACz-3rh9ZCyU1825yU8xxty5BGrwFhpbjKNoWnn0mGiv_h2Kag@mail.gmail.com>
 <20191109191400.8999-1-jongk@linux-m68k.org> <1573330351.3650.4.camel@linux.ibm.com>
 <6b914b12-cbc7-6fe6-7cba-3e89b2f6f19b@gmail.com>
In-Reply-To: <6b914b12-cbc7-6fe6-7cba-3e89b2f6f19b@gmail.com>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Sun, 10 Nov 2019 10:01:58 +0100
X-Gmail-Original-Message-ID: <CACz-3rjUh8tcShX5OPi+37JvF8PqG-8AEf5uMQHjMynSaVa1gw@mail.gmail.com>
Message-ID: <CACz-3rjUh8tcShX5OPi+37JvF8PqG-8AEf5uMQHjMynSaVa1gw@mail.gmail.com>
Subject: Re: [PATCH] zorro_esp: increase maximum dma length to 65536 bytes
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     James Bottomley <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.128.47
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=cPSeTWWN c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=pGLkceISAAAA:8 a=JbkMkhRZQ_9swjeIGgcA:9 a=W5WeqUbvGoA5kzlh:21 a=4r4QAPJ9YRGA_bOO:21 a=QEXdDO2ut3YA:10
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Michael,

Op zo 10 nov. 2019 om 03:36 schreef Michael Schmitz <schmitzmic@gmail.com>:
> All of the old board-specific drivers used a max transfer length of
> 0x1000000, only the fastlane driver used 0xfffc.

Yes, I also found this when checking the old drivers.

> That lower limit might
> be due to a DMA limitation on the fastlane board. We could accommodate
> the different limit for this board by using a board-specific
> dma_length_limit() callback...

Yes, I think that's the best idea for now. Oktagon also used to have a
different limit but that was never ported to the new ESP core.

> > case for any of the cards the zorro_esp drives, it might be better to
> > lower the max length to 61440 (64k-4k) so the residual is a page.
>
> For the benefit of keeping the code simple, and avoid retesting the
> fastlane board, that might indeed be the better solution.

But it's slower... :-P

Also, I may be adding another board-specific version for the Blizzard
12x0 IV to enable 24-bit transfers, like the am53c974 driver does, in
a later patch.

Kind regards,

Kars.
