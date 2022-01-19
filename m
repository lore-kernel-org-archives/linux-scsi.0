Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19007C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 23:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbiASXCc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 18:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234447AbiASXCc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 18:02:32 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC480C061574
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 15:02:31 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id r204so1080102iod.10
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 15:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LZeG24isbpRlHj7YRNZ2zngaKlsVhj7dibmT6b3JvTI=;
        b=j2gDWf10TYcgDCsPgkcaIkUtNjl8GYLu5qkJvlksqY1sVO0Mp9fNkVDtpkZNl3c4ni
         W0llW4Ry2zHGXj0PfOCCLV5o+1a+HIAHWBRyI2Km/Ri2W+XrelUlqqaZlSBtR1Xbk8zM
         Z7LJUZ7y2X/mAwsr+5cz5VdPo0Y4iR8Nr1b+lIc7ZiOyle8d5rCm8D2jczMHc8WxUWvH
         CIzNALBAPX+4CWIt4PIZyrk0T0yidAr+0yFHkJ805zUquDN0G0zlchZuc6fOKyWAF5CJ
         INgrJZLBE9abtCinByapBtUofmu8iyTW5lN1SbgmUU1eOyDGSMG0hEVBThhmRScWfmxY
         M+Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LZeG24isbpRlHj7YRNZ2zngaKlsVhj7dibmT6b3JvTI=;
        b=Fue4WOGXYXDFhlaJG4K4UOmD8t/CQUdl2XgiOjnw2e0Uqx46BOV9A89vRrHdSSEgN/
         SwBmS4cOWeZQxBVv8m86KtjDbGu9xnx0QTJ//VlThVQtVIcSRlIGFmcpSEYwKTVV0JGS
         CpFBQs4wkz79qzi2f92XH1pPLIK+dTASUqnr0OKEKtUE3Tl2gN0tDPjBdJyug7S8SD1G
         95onYEieUa4v9bNmeJSqir8fXuihu++Xz2UaGY9gJvxyLG3MwtAkbrGZWrHh6ITKGkHy
         i3/sXzUTPKug1037KoEw+4NP1H4RtUi/ZnwP1/6XZnCQADSpMsmscUOCgLRDbMNvR2O6
         OgiA==
X-Gm-Message-State: AOAM533c2GFsncHi/zseJR2HSJyb+aaCW7AnH+DB8sTqJmn5GmoRQ5yR
        GefyvJeol2M4KCCSq4jUalpQzrvmndzrVhfxJlg=
X-Google-Smtp-Source: ABdhPJyfqtRzvalq+VtGHnzohpG+ctFzB316jvAjzOtoVDQoqCg3L4pqRNFyq1vCxcnQ7rHYkmTZWC+hy6ONWWlFSa8=
X-Received: by 2002:a05:6602:2b10:: with SMTP id p16mr17094846iov.2.1642633351354;
 Wed, 19 Jan 2022 15:02:31 -0800 (PST)
MIME-Version: 1.0
References: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
 <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com> <CAFrqyV59OHp3mWLg87wuymJTBXG2i_QwZjUFNtrB4cpt98tgaw@mail.gmail.com>
 <yq1lezbk7v7.fsf@ca-mkp.ca.oracle.com> <CAFrqyV5O5u3_BsrOY_E2qfSNWfz5CS0-bymMDGPx00y-f5SezA@mail.gmail.com>
 <yq1tudzidng.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1tudzidng.fsf@ca-mkp.ca.oracle.com>
From:   Sven Hugi <hugi.sven@gmail.com>
Date:   Thu, 20 Jan 2022 00:02:20 +0100
Message-ID: <CAFrqyV6hhTDW9m+azsLGth+Jok=KFc+pkoGnTrsr5qDCazY-Kg@mail.gmail.com>
Subject: Re: Samsung t5 / t3 problem with ncq trim
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin

Thx, i will test that tomorow and send you the result.
Best case would be, that i got 2 bad SSDs and there is nothing to patch.
But 2 bad SSDs, in this case i should play in the lottery...

Anyways, we know that the t3 definitely does not have this issue...

Best regards

Sven Hugi

Am Mi., 19. Jan. 2022 um 23:38 Uhr schrieb Martin K. Petersen
<martin.petersen@oracle.com>:
>
>
> Sven,
>
> > The 850 had a problem with ncq trim, disks randomly died and got slow
> > af with linux.
>
> The NCQ quirk does not apply in your case since the drive is attached to
> Linux via UAS. The UAS-SATA bridge drive may or may not be using NCQ
> when talking to the drive; we have no way of knowing or influencing that
> decision, that's all internal to the drive. We only see what is
> presented on its external USB interface.
>
> I don't have a T5 so I don't know about that. But I do have a T3 and it
> does not report LBPME which is the SCSI way of saying the drive supports
> TRIM. So Linux isn't even going to attempt to TRIM the drive in this
> configuration.
>
> You are welcome to send the output of the following commands:
>
> # sg_inq /dev/sdN
>
> # sg_readcap -l /dev/sdN
>
> # sg_vpd -p bl /dev/sdN
>
> # sg_vpd -p lbpv /dev/sdN
>
> for your T5 so we can see what it reports. But with respect to the
> queued TRIM issue, there isn't really anything that can be done from the
> Linux side since this is all internal to the device.
>
> Had the mSATA drive been directly attached to a SATA controller and not
> a UAS-to-SATA bridge things would have been different. The special
> handling of the 850 in libata is meant to address the scenario where
> Linux is talking to the SATA drive directly. In that configuration the
> decision about whether to queue or not queue the DSM TRIM operation lies
> with Linux.
>
> --
> Martin K. Petersen      Oracle Linux Engineering



-- 
Sven Hugi

github.com/ExtraTNT
