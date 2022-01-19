Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B46C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 16:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356039AbiASQHC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 11:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237164AbiASQHB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 11:07:01 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9EEC061574
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 08:07:01 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id b1so2595848ilj.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 08:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I4tcqKiO0WTxHyFIZiMcLglADtD2vxcnCEHr5LIHLaI=;
        b=hXqSZP5J8iPmf/F74dJ3WRxB2menD4vJumXpZiv7/TP2VEM+pGQZsEGTqRnYpeuJN/
         j9ISQyuCJj/JjvvTHFnMqsx5UKa9oQVzJi8PcVAjtsoqc+Y2vaP7DhaUbXJzIsITUX9J
         +EnnvpuwaSq/Wp4Ri1wvRUkoIIWXh0tqSPO0FDqEOk29vMAewxNl/6WYNQv3SHvPAu/u
         ly5RZg4HLd1m5Hhrutx4p3+j6QoBGvml/HYaWun+HC+KNW/GTPkZTmZJzRTzrLYizmqX
         K5zgzP/ZLErPXYJP3EH6pkZKMi+iJFTS/7Eofa1ieix/SaZFw7Rw1rh5eqWLWbKH0smI
         JqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I4tcqKiO0WTxHyFIZiMcLglADtD2vxcnCEHr5LIHLaI=;
        b=ZXVmlGQARD9lvW6TdIOxVo5S4BRuf0lHg6UeOk+2tSlKC69sHc769PUz5iM+OdVDRG
         X9rfqQ2FBn6LPI5Lf0XOxIxFfe2jwy8Ncn4Qg0Awc0veZCMYoj61fkAS4Hh60J4KYMhs
         Dprsk7RpWGzhrxKr/znSlIvh2cf3EIv7xb0OaGDVf6vvasmSJ22awd8rrB3r90AG/gri
         1BcU3eKcRw1ldd/afiQaRbj6rdDJMWmfkbn3IYW5vR0MAcCAcR6kf21ym18Sr/GMVvVp
         8Vlfiom++rqM+u77ufkOevIpxd75AJ64LblKCZ2PbSjKqq6rasI3/3DJ5S7eDuySTGZ4
         AQTw==
X-Gm-Message-State: AOAM532LQBmsDpOlZFYATB2xrdB6bo078Ct5QpYyPuvUcQus7Il8LpoJ
        4d2h7ilB87NfixXTi/Km4OzF1w61gTkSPI2ygl/2V1GEbDY=
X-Google-Smtp-Source: ABdhPJy/3zdHj2znvMI8a8Cs8TdNVhXiO00TGUJflprmJkYObFJrITUl06zONw+riRQfwAw7toLWcF9P96KyYacfcdY=
X-Received: by 2002:a05:6e02:2167:: with SMTP id s7mr3128103ilv.266.1642608421000;
 Wed, 19 Jan 2022 08:07:01 -0800 (PST)
MIME-Version: 1.0
References: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
 <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com>
From:   Sven Hugi <hugi.sven@gmail.com>
Date:   Wed, 19 Jan 2022 17:06:49 +0100
Message-ID: <CAFrqyV59OHp3mWLg87wuymJTBXG2i_QwZjUFNtrB4cpt98tgaw@mail.gmail.com>
Subject: Re: Samsung t5 / t3 problem with ncq trim
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin

It seams, that those 2 ssds do not like ncq trim
In the mail i sent to linux-ide I included 4 lines of code for the
ata_device_blacklist in libata-core.c, but since Damien Le Moal
suggested to me to
write it to the maintainer of uas.c I didn't include those 4 lines...
(ht thinks, that i could be because of the usb-adapter on those ssds)
Those line where:

{ "Samsung Portable SSD T5",    NULL,   ATA_HORKAGE_NO_NCQ_TRIM |
                                        ATA_HORKAGE_ZERO_AFTER_TRIM, },
{ "Samsung Portable SSD T3",    NULL,   ATA_HORKAGE_NO_NCQ_TRIM |
                                        ATA_HORKAGE_ZERO_AFTER_TRIM, },

But because this seams not to work, i can just say, that those ssds
are suicidal, probably because of ncq trim.
I hope, that this helps you to understand, what the problem is...

Best regards

Sven Hugi

Am Mi., 19. Jan. 2022 um 04:20 Uhr schrieb Martin K. Petersen
<martin.petersen@oracle.com>:
>
>
> Sven,
>
> > So, it seams, that there is a problem with the samsung t5 and t3,
>
> What, specifically, is the problem?
>
> --
> Martin K. Petersen      Oracle Linux Engineering



-- 
Sven Hugi

github.com/ExtraTNT
