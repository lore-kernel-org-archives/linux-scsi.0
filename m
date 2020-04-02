Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F9BC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 08:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AC2020BED
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 08:53:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DbwoXh9O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387889AbgDBIxY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 04:53:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45650 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgDBIxX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2020 04:53:23 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200402085321euoutp0188bc4bdf6bdfb91950708e0c7868e6ba~B9LTmqHRY0152001520euoutp01V
        for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2020 08:53:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200402085321euoutp0188bc4bdf6bdfb91950708e0c7868e6ba~B9LTmqHRY0152001520euoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585817601;
        bh=noIPQJwUeNYKdvgAMKqlxK6zreTORgHBJZA/97U8MQ0=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=DbwoXh9OlFh4WNaNyzIqSAuw3pbEKG1KPjsvimGeNR+1ByL+nLp9XaGj8Nnf1litM
         xzcpbYMkiYlFGhx0LV0c4igG0NRTuV1SdUtqTTY+DHp+1F+sNAkytcSdWNHaS47yVp
         pk7T89Jjyt322CybTCgBPx8gYd6eqO9lD8Uu/l6A=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200402085321eucas1p1d0f2534ca211c8fec710c75c2db8d2ab~B9LTW2Tz72690726907eucas1p1u;
        Thu,  2 Apr 2020 08:53:21 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 69.AC.60679.108A58E5; Thu,  2
        Apr 2020 09:53:21 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200402085320eucas1p14a2efc09d96c00c8865db89f95b8c5e2~B9LSuLlSI2691626916eucas1p1n;
        Thu,  2 Apr 2020 08:53:20 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200402085320eusmtrp2646138768ca7a68583a05d1e36d0f0d0~B9LStgWGn1650316503eusmtrp2G;
        Thu,  2 Apr 2020 08:53:20 +0000 (GMT)
X-AuditID: cbfec7f4-0cbff7000001ed07-dc-5e85a8010185
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 68.1A.08375.008A58E5; Thu,  2
        Apr 2020 09:53:20 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200402085320eusmtip10eb97531ea5388264afc8a093e6c7864~B9LSXb5xA0077300773eusmtip1b;
        Thu,  2 Apr 2020 08:53:20 +0000 (GMT)
Subject: Re: [PATCH] scsi: hisi_sas: Fix build error without SATA_HOST
To:     John Garry <john.garry@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        chenxiang66@hisilicon.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <76d749f9-5676-a36f-4d94-80d71446e118@samsung.com>
Date:   Thu, 2 Apr 2020 10:53:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <855fee9e-ae2d-ca70-8630-df27a273e6f3@huawei.com>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRju2znbjqPJ8WjsRStpmF0gLQsZFpaQOYSoHxEhpJ3yoJKbsjNN
        Y4aas2FUTiNzmpmpMysv00xNqLxmgghGXjAsUzRrkTeyrNnOziT/Pd9z4Xle+AiMqhN6EnFq
        LaNR0/FykQRv6v7VvwdV6SP3TlVQiqH375CibLhJoLC8zBQqupsnBIrB1mKR4vpQs0hh7rEJ
        FGNL0/gRQvn5Xr1YmdVpFSpzy14h5dzUKK5csGw9KYyQHIpm4uOSGY1/8DlJ7J3ZW8JEozRl
        2axNRz8kOciFAPIA9N9sQzlIQlBkFYIHIwNiTqDIRQQlDSm8sICgsqhLvJbIyR7HecGMwPL6
        rYh/WBG8yO9EnMudPAb6J9UO7EGGw/xcG8aZMLISwfXGbowTRGQQGK/xJikZDLah2wIO46QP
        dBlsOIc3kWdg/mOHkPe4QW/hpIN3sfubZ4yOSRgpg9HJ+wIee8PVZ0WOMiBbxWBZtTp3H4XS
        umIhj91htqfRyW+G1RYuzAVqEPw1zDjTzxGY820i3nUQxvp/2zFhr9gFta3+PB0CGQ8HMY4G
        0hWGrW78CFfIaypw0lIwZFO82xfqKutEa7U5LY+wXCQ3rTvNtO4c07pzTP97SxFejWRMEquK
        YdgANXPJj6VVbJI6xu9CgsqC7P+oz9az2Ixa/5xvRySB5BulKbFZkZSQTmZTVe0ICEzuIQ25
        q4+kpNF06mVGkxClSYpn2HbkReBymXR/2ZezFBlDa5mLDJPIaNZUAeHimY7UFVYtS5wQGN1U
        I16ZT7dNaM0lH2pWdGG9eYWdISu2Du8tEViXn3riU3mwzniqIXCHf29DdMCS5qt44HTTduty
        dnjat/GojCC5IQz5tP3UhSWutjx+s7M+3TUt9EZUsofRV5Jb6x3+vS+QKUg7HqjXbbgioWWh
        TPlhelpXYJLjbCy9bzemYel/aICDI0MDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t/xu7oMK1rjDLZPVbO4fu0Ko8WiG9uY
        LDbtb2K1OLbjEZPF5V1z2Cy6r+9gs1h+/B+TxZ2vz1kcODwez93I7tFy5C2rx4RFBxg9Pj69
        xeLxeZNcAGuUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqR
        vl2CXsa0V/2sBRN5K34sL2lg/MDVxcjJISFgItHVdp8FxBYSWMooceNIehcjB1BcRuL4+jKI
        EmGJP9e62LoYuYBKXjNK3Lr4nRkkISzgJtG6ZhUjiC0i4CXx6eMeZpAiZoFljBLffnVAdRxi
        lFiz/w9YFZuAlcTEdogOXgE7iX/XpzCB2CwCKhJHO/6BXSEqECFxeMcsqBpBiZMzn4DFOYHq
        d7yYyA5iMwuoS/yZd4kZwhaXuPVkPhOELS/RvHU28wRGoVlI2mchaZmFpGUWkpYFjCyrGEVS
        S4tz03OLDfWKE3OLS/PS9ZLzczcxAqNv27Gfm3cwXtoYfIhRgINRiYe3IqMlTog1say4Mhfo
        QQ5mJRFexxmtcUK8KYmVValF+fFFpTmpxYcYTYGem8gsJZqcD0wMeSXxhqaG5haWhubG5sZm
        FkrivB0CB2OEBNITS1KzU1MLUotg+pg4OKUaGJ0m715jFf7Nd4fEt6MyV0/aegsUy0wTYta8
        33zR0Fwi9LLqGj72u4HX3fVEL6ZKNxbsEjkU9sjJqjb/+8yFX62S4xTW9KX9cnjxyvhRVuCT
        294Z+czPZmxL+lNouKzo4h1Bo9ObZS+F8z9cdDvhysv/rwyPb571Y9FRqZcsP5XKlogoMK1V
        OKfEUpyRaKjFXFScCAAL+YAL1AIAAA==
X-CMS-MailID: 20200402085320eucas1p14a2efc09d96c00c8865db89f95b8c5e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200402073107eucas1p26691d5f9309a3d09b960081bbc0925cb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200402073107eucas1p26691d5f9309a3d09b960081bbc0925cb
References: <20200402063021.34672-1-yuehaibing@huawei.com>
        <CGME20200402073107eucas1p26691d5f9309a3d09b960081bbc0925cb@eucas1p2.samsung.com>
        <855fee9e-ae2d-ca70-8630-df27a273e6f3@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 4/2/20 9:30 AM, John Garry wrote:
> On 02/04/2020 07:30, YueHaibing wrote:
> 
> +
> 
>> If SATA_HOST is n, build fails:
>>
>> drivers/scsi/hisi_sas/hisi_sas_main.o: In function `hisi_sas_fill_ata_reset_cmd':
>> hisi_sas_main.c:(.text+0x2500): undefined reference to `ata_tf_to_fis'
>>
>> Select SATA_HOST to fix this.

Sorry for missing hisi_sas and thanks for fixing it.

>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Fixes: 7c594f0407de ("scsi: hisi_sas: add softreset function for SATA disk")
> 
> That's not right. SATA_HOST was only introduced recently in the ATA code. It would fix those kconfig changes.

Yes, this should be:

Fixes: bd322af15ce9 ("ata: make SATA_PMP option selectable only if any SATA host driver is enabled")

>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>   drivers/scsi/hisi_sas/Kconfig | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
>> index 90a17452a50d..13ed9073fc72 100644
>> --- a/drivers/scsi/hisi_sas/Kconfig
>> +++ b/drivers/scsi/hisi_sas/Kconfig
>> @@ -6,6 +6,7 @@ config SCSI_HISI_SAS
>>       select SCSI_SAS_LIBSAS
>>       select BLK_DEV_INTEGRITY
>>       depends on ATA
>> +    select SATA_HOST
> 
> That does not feel right.
> 
> SCSI_HISI_SAS depends on ATA, but SATA_HOST also depends on ATA, so it seems better to just depend on SATA_HOST (and omit explicit ATA dependency), rather than select it.

SATA_HOST config option is invisible to user so it needs to be
selected.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
