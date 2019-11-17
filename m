Return-Path: <SRS0=Zq1p=ZJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674C8C432C3
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 06:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49C782075C
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 06:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbfKQG35 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 01:29:57 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:44696 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbfKQG35 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Nov 2019 01:29:57 -0500
Received: from [212.54.42.110] (helo=smtp7.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iWE4J-0007l2-8z; Sun, 17 Nov 2019 07:29:55 +0100
Received: from mail-wr1-f46.google.com ([209.85.221.46])
        by smtp7.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iWE4J-0006tw-54; Sun, 17 Nov 2019 07:29:55 +0100
Received: by mail-wr1-f46.google.com with SMTP id s5so15732774wrw.2;
        Sat, 16 Nov 2019 22:29:55 -0800 (PST)
X-Gm-Message-State: APjAAAU3vgOrRMPuUlcEkwzCGIiU5z0Y0WCvCJmUWOFZpLU1Hnf7dloN
        uiyMEzIQDWOsfOmDwj1C8WOckIEYy2YIKebIWlc=
X-Google-Smtp-Source: APXvYqyFMzuM1pPgk4XlPud09E/GOi9t1wSuSwcleGfGzmW3DbfeeHqHBUjg0ssMjg8BJSIjjnxVL+ybT5uM4+zkGgE=
X-Received: by 2002:adf:ea8d:: with SMTP id s13mr23994205wrm.366.1573972194665;
 Sat, 16 Nov 2019 22:29:54 -0800 (PST)
MIME-Version: 1.0
References: <2bbb6359d542f5882be67c415ecc25ad2d9eeb5e.1573875417.git.fthain@telegraphics.com.au>
 <CACz-3rjHAyi6kMQ6j9YALLm1ApYrsqKiTnGNPUhxqqEuRJ9TjQ@mail.gmail.com>
In-Reply-To: <CACz-3rjHAyi6kMQ6j9YALLm1ApYrsqKiTnGNPUhxqqEuRJ9TjQ@mail.gmail.com>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Sun, 17 Nov 2019 07:29:43 +0100
X-Gmail-Original-Message-ID: <CACz-3rhGZ7SiYMOWv8ER7u8pzx=pxq9k4sQjJQqh4Qrn+74C2A@mail.gmail.com>
Message-ID: <CACz-3rhGZ7SiYMOWv8ER7u8pzx=pxq9k4sQjJQqh4Qrn+74C2A@mail.gmail.com>
Subject: Re: [PATCH] esp_scsi: Clear Transfer Count registers before PIO transfers
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.221.46
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=cPSeTWWN c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=tBb2bbeoAAAA:8 a=d8rZ9vRRgRfmWEAI3WsA:9 a=QEXdDO2ut3YA:10 a=win4SnVEMkUA:10 a=Oj-tNtZlA1e06AYgeCfH:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Op zo 17 nov. 2019 om 07:26 schreef Kars de Jong <jongk@linux-m68k.org>:
> The only place the controller reads these registers is when a DMA
> command is issued.

The only time it does this, I mean.
