Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A264DC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 14:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AE4B61AED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 14:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbhG0OIA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 10:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237118AbhG0OHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 10:07:50 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD8FC061383
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 07:07:45 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id h14so7418559wrx.10
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 07:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=gy+H1N9N6DR0ftnDTJGoy9DwqVrX41262Xlh40A7Ya8=;
        b=Mxa5j3eGmHvyLHKN4YdxCEffE2iV+FC/unO5E/jQn7RJ6rHOSAJ+Dlypqlv4+hfkFN
         agxfpgfeXedaMl3aYhCKKe6Fh5J94PD0e7Sn4BHKqWvyWMK+oaVY16l5m0ChRdNaLqfV
         KC5Eek5fXit+a4JMEDzBG+F5xTDLpZrhL+T61L3enQjBM6Bjdap7Py5GOfFFdF9qxRtl
         lphOdkznh10eoh1uAp8B7QXIh1z0hXkMV0jCwqeEADSdY9gRWc7BQ+0QuMOWqcM6mrRF
         6XnARPy9eiAOu9K/gEd9Dz/QMlohLah8m8hk5gIryv5rUJByEISkDVX2Ea0BJrViWGJW
         IjLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=gy+H1N9N6DR0ftnDTJGoy9DwqVrX41262Xlh40A7Ya8=;
        b=T6vjAEA1Va3ZIqXjumurQaJwNMRSmxtI35jPC2h2XHBkU8oxeDXkbQFuCXDc3cMQJK
         t5NtWRzL7O55u1kNOYK6gBOJz6lyKKP9FrmUG9TW61SKC5MlwIgv057yjGY4eW7P/kru
         aAiopr4XTvj+z2PDTsQVSUMy4zBEdZ1hTgVznabKTDU6oseSuVjCsCXTxsImvV8yyIxc
         ndBqiHs2vQZvxF706WB/o1Er767au+d5CD4hyOIktJBgSfq4lE/w+kn47TGxvQTbfA0e
         uN8UxmqE8H++Bw873y0FgCLFGWtBiwslMNWODIEpwO/CAxiSWMTLfU7CZaVLQshV4G6L
         QVVg==
X-Gm-Message-State: AOAM533A38mVFjduIBjvHHSPOEGlq2JbdT9YwPfDnSD/P01Rs8FZFA/A
        hJVGOOFDs7NhpaHxl2woelq6bg==
X-Google-Smtp-Source: ABdhPJyljXyXETDqZYAlbw22CtgEl9gmEpP+h9Jqw2EFewal2uuu3n89OW+dwrv8RCXg0TTm/xeCHg==
X-Received: by 2002:adf:cf07:: with SMTP id o7mr24567946wrj.216.1627394864054;
        Tue, 27 Jul 2021 07:07:44 -0700 (PDT)
Received: from [192.168.61.233] ([37.162.12.50])
        by smtp.gmail.com with ESMTPSA id g16sm4298272wro.63.2021.07.27.07.07.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 07:07:43 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v3 1/4] block: Add concurrent positioning ranges support
From:   Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <DM6PR04MB7081B7619AAD7EB4236DACA8E7E89@DM6PR04MB7081.namprd04.prod.outlook.com>
Date:   Tue, 27 Jul 2021 16:07:41 +0200
Cc:     Hannes Reinecke <hare@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F59D5B88-5CEF-4A61-A8AC-9FF572A462DC@linaro.org>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-2-damien.lemoal@wdc.com>
 <751621a5-a35b-c799-439c-8982433a6be5@suse.de>
 <DM6PR04MB7081141B64D9501BDA876433E7E89@DM6PR04MB7081.namprd04.prod.outlook.com>
 <0ec2ea13-208f-1a5e-7b11-37317b5e56b8@suse.de>
 <DM6PR04MB7081B7619AAD7EB4236DACA8E7E89@DM6PR04MB7081.namprd04.prod.outlook.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
X-Mailer: Apple Mail (2.3445.104.11)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> Il giorno 26 lug 2021, alle ore 13:33, Damien Le Moal =
<Damien.LeMoal@wdc.com> ha scritto:
>=20
> On 2021/07/26 17:47, Hannes Reinecke wrote:
>> On 7/26/21 10:30 AM, Damien Le Moal wrote:
>>> On 2021/07/26 16:34, Hannes Reinecke wrote:
>> [ .. ]
>>>> In principle it looks good, but what would be the appropriate =
action
>>>> when invalid ranges are being detected during revalidation?
>>>> The current code will leave the original ones intact, but I guess =
that's
>>>> questionable as the current settings are most likely invalid.
>>>=20
>>> Nope. In that case, the old ranges are removed. In =
blk_queue_set_cranges(),
>>> there is:
>>>=20
>>> +		if (!blk_check_ranges(disk, cr)) {
>>> +			kfree(cr);
>>> +			cr =3D NULL;
>>> +			goto reg;
>>> +		}
>>>=20
>>> So for incorrect ranges, we will register "NULL", so no ranges. The =
old ranges
>>> are gone.
>>>=20
>>=20
>> Right. So that's the first concern addressed.
>=20
> Not that at the scsi layer, if there is an error retrieving the ranges
> informations, blk_queue_set_cranges(q, NULL) is called, so the same =
happen: the
> ranges set are removed and no range information will appear in sysfs.
>=20

As a very personal opinion, silent failures are often misleading when
trying to understand what is going wrong in a system.  But I guess
this is however the best option.

Thanks,
Paolo

>>=20
>>>> I would vote for de-register the old ones and implement an error =
state
>>>> (using an error pointer?); that would signal that there _are_ =
ranges,
>>>> but we couldn't parse them properly.
>>>> Hmm?
>>>=20
>>> With the current code, the information "there are ranges" will be =
completely
>>> gone if the ranges are bad... dmesg will have a message about it, =
but that's it.
>>>=20
>> So there will be no additional information in sysfs in case of =
incorrect=20
>> ranges?
>=20
> Yep, there will be no queue/cranges directory. The drive will be the =
same as a
> single actuator one.
>=20
>> Hmm. Not sure if I like that, but then it might be the best option =
after=20
>> all. So you can add my:
>=20
> Nothing much that we can do. If we fail to retrieve the ranges, or the =
ranges
> are incorrect, access optimization by FS or scheduler is not really =
possible.
> Note that the drive will still work. Only any eventual optimization =
will be
> turned off.
>=20
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>=20
> Thanks !
>=20
>>=20
>> Cheers,
>>=20
>> Hannes
>>=20
>=20
>=20
> --=20
> Damien Le Moal
> Western Digital Research

