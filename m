Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760F1C47404
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 12:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47D7A20830
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 12:37:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YoYgJhi2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731633AbfILMhc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 08:37:32 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:36794 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731283AbfILMhc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2019 08:37:32 -0400
Received: by mail-io1-f47.google.com with SMTP id b136so54127236iof.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2019 05:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ba/oGUCd/as9CWRgyWo+aUAu4ppkvGP4MMOgYdJfLLI=;
        b=YoYgJhi2GRbiJ/hACXrrImTVS6g90hDiYar5Y4RenCA/cu6y0xKBrZjL5vkrrI2tBD
         Jf569f/DmMGmlDrKKyl9KQo8GWXqqmPkfWVeGkXXcXHpakSyaESZWgfXDPRdrDvqywrq
         0B1pY+t+O08WqiEuBubrlNYOJCjQtsfz65nyxZP9y81qlYuZw+lkuK/IhjesUSTX2P30
         ZUA3jenSDgQCC4VdOKccMJTBDxHT2V20Dy0pFEy+14EzSDTvvdXE3wtBEhq9it1QoCJH
         MR2I4SptmXJQR1y7SNZUCqxHPhvcLZaPM2P4H/WQnT6DxPi+zGmWZOXaLr3WSs6aQbZm
         J7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ba/oGUCd/as9CWRgyWo+aUAu4ppkvGP4MMOgYdJfLLI=;
        b=WiJsOx5CqBhoO1Ku9HWc6Z8+8hNWHN1nEVVRq+iV06JWK1GCs/1huljml8GW9C8gm4
         hQxZOu7ytlW1jbhLdzOtUWEpr2XE3lD910s/8TXE0H9Dt0ZbKunXqaIOfGPkjR5760qv
         0LVEH17Tk6jO9AbN1MBcN5r5x/3K5qGAn+PTpIdTtw/+OCac4ed2QgeZ567OyGHsRDyS
         N42DwJnkX65JG0fANBW6Zex1brEwCswfhzWKcyJs4Je4IsySOC+x4INFWdt/C+RhMApQ
         M01iCZCzZdlOzSparu5tfA3Y7sAkk1yohD4V7afuIdr9cMB80xz7tY9jLcYlVvE6DP/y
         0sgw==
X-Gm-Message-State: APjAAAXxPjVIlR4XBk/XOkGVhDNrIy6ImKouJJygMLuRMvAiKp5yB84z
        wJQjoFX5aVrHDBvU0DkNT/2zvcNeDkXGMv97c24=
X-Google-Smtp-Source: APXvYqyWYg9kCk0JIJf5kv0KSWgfTzl+RR8CroDur6k+jlmdbDg/kM2wYdQ9iWfIywwAq7C3MQgjY9fBEVej2u23VeE=
X-Received: by 2002:a02:7797:: with SMTP id g145mr43778102jac.60.1568291851943;
 Thu, 12 Sep 2019 05:37:31 -0700 (PDT)
MIME-Version: 1.0
References: <CA+PODjqrRzyJnOKoabMOV4EPByNnL1LgTi+QAKENP3NwUq5YCw@mail.gmail.com>
 <8A2392BA-EDD4-4F66-9F76-B43C8F6EA4FB@gmail.com>
In-Reply-To: <8A2392BA-EDD4-4F66-9F76-B43C8F6EA4FB@gmail.com>
From:   Andrey Melnikov <temnota.am@gmail.com>
Date:   Thu, 12 Sep 2019 15:37:20 +0300
Message-ID: <CA+PODjpG7NLTH8wp9qw08ACj4=8sUusmkZv6X7QWHtdbNJ1S0Q@mail.gmail.com>
Subject: Re: [RFC,v2] scsi: scan: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT
To:     Zhong Li <lizhongfs@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=D1=87=D1=82, 12 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 07:56, Zhong=
 Li <lizhongfs@gmail.com>:
>
>
> > On Aug 29, 2019, at 11:49 PM, Andrey Melnikov <temnota.am@gmail.com> wr=
ote:
> >
> > Hello.
> >
> > This patch break exposing individual RAID disks from adaptec raid
> > controller. I need access to this disc's for S.M.A.R.T monitoring.
>
> Hello Andrey,
>
> Do you have any more details about how/why it is broken?

adaptec report hidden luns with PQ=3D1, PDT=3D0 - now it skipped.

[   32.609143] scsi host6: aacraid
[   32.609566] scsi 6:0:0:0: Direct-Access     Adaptec  srv
  V1.0 PQ: 0 ANSI: 2
[   32.609881] scsi 6:0:1:0: Direct-Access     Adaptec  zbx
  V1.0 PQ: 0 ANSI: 2
[   32.639942] scsi 6:1:4:0: Direct-Access     ATA      WDC
WD2003FZEX-0 01.0 PQ: 1 ANSI: 5
[   32.640810] scsi 6:1:5:0: Direct-Access     ATA      WDC
WD2003FZEX-0 01.0 PQ: 1 ANSI: 5
[   32.641559] scsi 6:1:6:0: Direct-Access     ATA      WDC
WD2003FZEX-0 01.0 PQ: 1 ANSI: 5
[   32.642266] scsi 6:1:7:0: Direct-Access     ATA      WDC
WD2003FZEX-0 01.0 PQ: 1 ANSI: 5


> > Please find other way to workaround bugs in IBM/2145 controller.
>
