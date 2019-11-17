Return-Path: <SRS0=Zq1p=ZJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FC0C432C3
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 06:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E72A420740
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 06:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfKQG0a convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 01:26:30 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:44428 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbfKQG0a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Nov 2019 01:26:30 -0500
Received: from [212.54.42.110] (helo=smtp7.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iWE0x-0007YD-OO; Sun, 17 Nov 2019 07:26:27 +0100
Received: from mail-wr1-f48.google.com ([209.85.221.48])
        by smtp7.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iWE0x-0006Gp-KN; Sun, 17 Nov 2019 07:26:27 +0100
Received: by mail-wr1-f48.google.com with SMTP id t1so15698555wrv.4;
        Sat, 16 Nov 2019 22:26:27 -0800 (PST)
X-Gm-Message-State: APjAAAUWyX6EW93DYvOqoWxmCGEel5fYnfh4NMFQs8x+XksIc3YihCTL
        2GVzWkcBMD94/QL978LkZHmtAfUsHZZ5mQ8RajM=
X-Google-Smtp-Source: APXvYqxVPDYgG0rtd2SAMq804Fa3hjTcRiN9UwNWppBNan2DkfOqvBDfT0xCY1HYbKOxsRt3pjk/p/eR6gG1eGXjsx8=
X-Received: by 2002:adf:e391:: with SMTP id e17mr4518946wrm.372.1573971987207;
 Sat, 16 Nov 2019 22:26:27 -0800 (PST)
MIME-Version: 1.0
References: <2bbb6359d542f5882be67c415ecc25ad2d9eeb5e.1573875417.git.fthain@telegraphics.com.au>
In-Reply-To: <2bbb6359d542f5882be67c415ecc25ad2d9eeb5e.1573875417.git.fthain@telegraphics.com.au>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Sun, 17 Nov 2019 07:26:16 +0100
X-Gmail-Original-Message-ID: <CACz-3rjHAyi6kMQ6j9YALLm1ApYrsqKiTnGNPUhxqqEuRJ9TjQ@mail.gmail.com>
Message-ID: <CACz-3rjHAyi6kMQ6j9YALLm1ApYrsqKiTnGNPUhxqqEuRJ9TjQ@mail.gmail.com>
Subject: Re: [PATCH] esp_scsi: Clear Transfer Count registers before PIO transfers
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-SourceIP: 209.85.221.48
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=cPSeTWWN c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=8981fWPbAAAA:8 a=-vbD31fikyHGdj6aEf8A:9 a=QEXdDO2ut3YA:10 a=o72u2rHnfW5qNJ_4I8LD:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

Op za 16 nov. 2019 om 04:36 schreef Finn Thain <fthain@telegraphics.com.au>:
>
> The zorro_esp driver uses both PIO and DMA transfers. If a failed DMA
> transfer happened to be followed by a PIO transfer, the TCLOW and TCMED
> registers would not get cleared. It is theoretically possible that the
> stale value from the transfer counter or the TCLOW/TCMED registers
> could then be used by the controller and the driver. Avoid that by
> clearing these registers before each PIO transfer.

Are you sure this is really needed?

The only place where the driver reads these registers is after a data
transfer. These are done using DMA on all Zorro boards, so I don’t
think there’s a risk of stale values from a PIO transfer there.

The only place the controller reads these registers is when a DMA
command is issued. The only place where that is done is in the
zorro_esp send_dma_command() functions. These all set both registers
explicitly before issuing the DMA command to the controller, so I
don’t think there’s a risk there either.

Kind regards,

Kars.
