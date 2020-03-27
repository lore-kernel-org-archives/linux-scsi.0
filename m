Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1ACC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 10:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0EAD20578
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 10:36:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="A4rMZT23"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgC0KgG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 06:36:06 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45043 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgC0KgG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 06:36:06 -0400
Received: by mail-ot1-f65.google.com with SMTP id a49so9156167otc.11
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2020 03:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NoJNkqMuLLCwMgTCsahSJfCT5FPrUvQ7S5KH1RUQFzc=;
        b=A4rMZT23UajmeTlGKkeyk1OjAT6dSB3dl8IkmENirGI5y09hppTbbQla4iaFFf4/9P
         6E+BY2SdBrUyfXsfIFybTpimbR5xSmSwjqNQ99LBh2x+qL0xtX9TQPkaxJ23yhLs9ePh
         b9qXMUP3winXIzRmqfADydVCa1kbvk26eyMJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NoJNkqMuLLCwMgTCsahSJfCT5FPrUvQ7S5KH1RUQFzc=;
        b=DNbC1T6VQbo/HnVsQSTt4DhTvz9uO/LFlNJT+W0evbmgBSG41ShWeqBCQjROobRHWm
         KwX++I5rqn2qe/HGECYd5XSmfVPu/Tw/WRaJu2gQRKo1Na9bU52PMGq7LIcQXTsuUxQJ
         xCYaf5STCAcPqdzJlZunyqJSiam5Whlmk+LulWdqlARpl+ToeQA0bYq1eHm4Guh945Px
         eD22c+4+07JH2LSbsPF3oNgYCaSHBtazNSyDR/i8rn8P293gL+owG3X3QbZo89/1AtNF
         e3GPpOvqGJsg+r2uAv8gQAA9U6EQPWpllyA+91xgus9+QXbyAivD12AFqSnIIIA1ESFi
         z+rw==
X-Gm-Message-State: ANhLgQ3CvOIZrgKGmProSrh8JsFY3Xok9Z2soIVZrVHSv/4N3bGiR/jA
        +UyjAbbvv+tFKN4334aX81+sCdelre5B1Z+y79qoaA==
X-Google-Smtp-Source: ADFU+vuq2CFuwBV9iHb7DRW9+OLH1AV6U7OHpE8qyoaO7D4AiaAJl0QmjPL8cAOCQHtmtXtwAlj5TCY/9U3oCs3YsLo=
X-Received: by 2002:a9d:1920:: with SMTP id j32mr9323866ota.221.1585305365378;
 Fri, 27 Mar 2020 03:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com>
 <DF4PR8401MB12415ADC9760286F3930DBE4ABFB0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
 <CAK=zhgqWJs+Wbmgy9xp6WDRp2w5e+5BGD+R5mck-dVh5oOUQ0g@mail.gmail.com> <yq1bloiftvs.fsf@oracle.com>
In-Reply-To: <yq1bloiftvs.fsf@oracle.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Fri, 27 Mar 2020 16:05:54 +0530
Message-ID: <CAK=zhgoPd85MOpHzfgaRAk8j_mFdVqZU1dRXYFnJWDTHFhiiRg@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "amit@kernel.org" <amit@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 27, 2020 at 7:20 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Sreekanth,
>
> > In the unload path driver call sas_remove_host() API before releasing
> > the resources. This sas_remove_host() API waits for all the
> > outstanding IOs to be completed. So here, indirectly driver is waiting
> > for the outstanding IOs to be processed before releasing the HBA
> > resources.  So only in the cases where HBA is inaccessible (e.g. HBA
> > unplug case), driver is flushing out the outstanding commands to avoid
> > SCSI error handling over head and can quilkey complete the driver
> > unload operation.
>
> None of this is clear from the commit description. Please resubmit patch
> with a new description clarifying why and when it is safe to drop
> outstanding commands.

Martin,

Posted the patch with updated description.
https://patchwork.kernel.org/patch/11462107/

Thanks & Regards,
Sreekanth

>
> --
> Martin K. Petersen      Oracle Linux Engineering
