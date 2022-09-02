Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5B6ECAAD5
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Sep 2022 15:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbiIBPTz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Sep 2022 11:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235922AbiIBPTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2022 11:19:30 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3027C4AD5B
        for <linux-scsi@vger.kernel.org>; Fri,  2 Sep 2022 07:52:18 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id s7so2655815wro.2
        for <linux-scsi@vger.kernel.org>; Fri, 02 Sep 2022 07:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=vT12WjiAInI7Lcjts5MEkYbQ521nhvXexq63yVl3jIw=;
        b=RXlCahQIcJ/VdQ4G4Rw6q1c2WcM4wewzYSnmK3vT6vKSFAtBukzsTSy08e5H5z7D3t
         +L4TMpBbrTY7Nqo2f+jtAYOZ71dajpr48gOPFtibbwneFZ5xYDVLRtq6Fk1Dv1dLsrGf
         KiWJ7Uj09yUTegf3C/a9WZSNBWmoNDQz6N/zUMC3XYE0ToYr4eGP6enxGkb4fDZOscrO
         KU0F6gh/JbrS0ebUbnuJPdWssSxm9cYayM+gvU1AuWRFcCP+bBNX8RUUs0oOLJwW3qMY
         fHuDzfdtJLVYP/G1xozYamGK7ekLdcjp0JeB2+us2U4cnPU4GZQTCoBwJUSZC3gy5hlZ
         IOtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=vT12WjiAInI7Lcjts5MEkYbQ521nhvXexq63yVl3jIw=;
        b=CK9APV78Zi9gDTFid9UktMoewgYTAh4XLlX4P1ZEwlEgMVptFZmflYKbhEi1h5BMvb
         mkGORbBt93VXZ1nErCs10XqMudLjEEtxdt3mIMAG/esTcJxdG7tCXoBX8cswKUa8ZrVN
         EmOQzY9oxoqYwotyWPDEvTAwXAgJGCZcbq/u5LmQyVwkEolm4qbeuVoP1JTKWruo8yVf
         Rd57vIp0pbsJO/fchqH2euGSAkWPUaQX9+H919ih3mjxQL0tEkZvHtM91XqJ2qsjhhnf
         yAZmXbT7Vav14+k5r5EExN4YePsmCJ2oCiVQSk7B6VRRt6es+/5zudrk8x8A2b4opPyn
         rTGw==
X-Gm-Message-State: ACgBeo15BUV3UOwIpa0miS+8DUgKVEuPbPI34yvm1cby8jQ3USv6Q7wq
        Fa/66nlxScO1n0xq4Ebfyhk=
X-Google-Smtp-Source: AA6agR4cNbIQ8/QHGzNiT4n6e3BSXZ+re1SthNfKZEUQh5V8GzYdEd9/2ymQm/IaePn51vC3VJ1ZUA==
X-Received: by 2002:a05:6000:1d82:b0:220:5f9b:9a77 with SMTP id bk2-20020a0560001d8200b002205f9b9a77mr17587906wrb.622.1662130322254;
        Fri, 02 Sep 2022 07:52:02 -0700 (PDT)
Received: from [10.176.234.249] ([137.201.254.41])
        by smtp.googlemail.com with ESMTPSA id o21-20020a05600c4fd500b003a32297598csm9608904wmq.43.2022.09.02.07.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 07:52:01 -0700 (PDT)
Message-ID: <ea43b861ac1c7b87a11934d2e5606fa37b2ae7fe.camel@gmail.com>
Subject: Re: [PATCH v3] scsi: ufs: Increase the maximum data buffer size
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "yohan.joung@sk.com" <yohan.joung@sk.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Date:   Fri, 02 Sep 2022 16:52:00 +0200
In-Reply-To: <6263c2a5-e7b6-c9e5-69e8-b6d93604d82d@acm.org>
References: <20220726225232.1362251-1-bvanassche@acm.org>
         <55fce3baaabf4e33aeaccbe5b4e1f145@sk.com>
         <6263c2a5-e7b6-c9e5-69e8-b6d93604d82d@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-08-03 at 09:23 -0700, Bart Van Assche wrote:
> On 8/2/22 16:40, yohan.joung@sk.com=C2=A0wrote:
> > Is it possible by adding only max_sector to increase the data
> > buffer size?
>=20
> Yes.
>=20
> > I think the data buffer will split to 512 KiB, because the sg_table
> > size is SG_ALL
>=20
> I don't think so. With this patch applied, the limits supported by
> the=20
> UFS driver are as follows:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.sg_tablesize=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D SG_ALL,=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 /* 128 */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.max_segment_size=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D PRDT_DATA_BYTE_COUNT_MAX, /* 256
> KiB*/
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.max_sectors=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D (1 << 20) /=
 SECTOR_SIZE,=C2=A0 /* 1 MiB
> */
>=20
> So the maximum data buffer size is min(max_sectors * 512,
> sg_tablesize *=20
> max_segment_size) =3D min(1 MiB, 128 * 256 KiB) =3D 1 MiB. On a system
> with=20
> 4 KiB pages, the data buffer size will be 128 * 4 KiB =3D 512 MiB if
> none=20
> of the pages involved in the I/O are contiguous.
>=20
> Bart.


Bart,=20

This change just increases the shost->max_sectors limit from 501KB to
1Mb, but the final value will be overridden by the optimal transfer
length defined in the VPD, right?

Kind regards,
Bean
