Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5DF6C7EE22
	for <linux-scsi@archiver.kernel.org>; Mon,  8 May 2023 16:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbjEHQea (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 May 2023 12:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbjEHQea (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2023 12:34:30 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DB25BA9
        for <linux-scsi@vger.kernel.org>; Mon,  8 May 2023 09:34:28 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64115e652eeso35896336b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 May 2023 09:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1683563668; x=1686155668;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1Tk4XWz8iaqgpxV5gm9QBNaJcVTmlVz7vbHxrYtoOo=;
        b=YAy6M8vvkLZQWKEIJ4Vke0Wm54roAoG2FVhGvQkJLZYHi77OVauWCQ7AAvwsUH6TdN
         OSM5ZzkZHFKlaRX4wxZOHOxBhStaQ8TxfO/ekxRiVxBiVdp2DSwirStdfg1Qy1z/aajE
         mKyR3/K4uuN9RwOjbazb2vDf69ZOAPgSp29rLLlXQr7B2xC1hiG/KYt5nGZdJ0aCZ7ZC
         uO5wLakrvID3SEFpZ/ijLUMdu+cvDqmQUsFthFHPWmpI4T8V8bSJUY2m9gZPaaNSLcga
         HcoI52lvSW0sGTje2DdVjm60GKInSeBJGe5U+NcLu92rAW7tXE7TFBMi7r80qXqsKjge
         xXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683563668; x=1686155668;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n1Tk4XWz8iaqgpxV5gm9QBNaJcVTmlVz7vbHxrYtoOo=;
        b=RccjibkIhgiPGmKtaumEZgQKb9UQOWXvRX6IzJ3rAITQAMHd9xOzzbo+Usbp8jfutU
         qsrSiZd2HC+lMQg/fRTYBHu0dCk+scDuP5E2M2cPzHxv5CfLddbrtTS0qrSAjaz5ulw/
         BQX4g9BW29bgoUjoSe6rCNXKk03jWMbuFfYpBS+OiK/YP50lRRDyIrEtvf6kkT5PP4uN
         B7jdmbJwJWm+fKq7gM4+gr4aoX/fTKNE733nHHh14IpYfixMrT/V4q6UPMPYhH1j9ilM
         MvuhPotbV23WDCduxWDRzFJ6xaYi+r753mQxbVGZXrzg2hPZQKANAdRKCfL52ZsC1Ip4
         gLBQ==
X-Gm-Message-State: AC+VfDwuQ0+3TaScW+k1QiTBZWlix/aLFZcydowPTZ36fC6IhmuOz8m3
        io0MbIfvzS0rjusvrbMyQ5a6Fg==
X-Google-Smtp-Source: ACHHUZ7vOsGldD0/lXdPrYEGnmQSw5dycILq7eMldGOZ3O4YZ3X37SZhZlIyUyFUwy6HcTr8uijbPw==
X-Received: by 2002:a17:902:ec8c:b0:1a9:80a0:47ef with SMTP id x12-20020a170902ec8c00b001a980a047efmr20601608plg.20.1683563667445;
        Mon, 08 May 2023 09:34:27 -0700 (PDT)
Received: from smtpclient.apple ([2600:1700:6970:bea0:404a:e54c:de77:5140])
        by smtp.gmail.com with ESMTPSA id y19-20020a170902b49300b001ac741db80csm2849834plr.88.2023.05.08.09.34.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 May 2023 09:34:26 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH] scsi: sd: Avoid sending an INQUIRY if the page is not
 supported
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <20230508100930.GA9720@t480-pf1aa2c2.fritz.box>
Date:   Mon, 8 May 2023 09:34:15 -0700
Cc:     linux-scsi@vger.kernel.org,
        Seamus Connor <sconnor@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7C02DE30-DBA7-45E5-A16C-02C75C670E9F@purestorage.com>
References: <20230505204950.21645-1-brian@purestorage.com>
 <20230508100930.GA9720@t480-pf1aa2c2.fritz.box>
To:     Benjamin Block <bblock@linux.ibm.com>
X-Mailer: Apple Mail (2.3731.500.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On May 8, 2023, at 3:09 AM, Benjamin Block <bblock@linux.ibm.com> =
wrote:
>=20
> On Fri, May 05, 2023 at 01:49:50PM -0700, Brian Bunker wrote:
>> When SCSI devices are discovered the function sd_read_cpr gets =
called.
>> This call results in an INQUIRY to page 0xb9. This VPD page is called
>> regardless of whether the target has advertised this page as =
supported.
>>=20
>> Instead of just sending this INQUIRY page, first check to see if that
>> page is in the supported pages. This will avoid sending requests to
>> targets which do not support the page. The error is unexpected on the
>> target and leads to questions. I am not sure what percentage of SCSI
>> devices support this page, but this will eliminate at least one
>> request to the target in the discovery phase for all that do not. The
>> function added could also have potential users besides this specific
>> one.
>>=20
>> Signed-off-by: Brian Bunker <brian@purestorage.com>
>> Reviewed-by: Seamus Connor <sconnor@purestorage.com>
>> Reviewed-by: Krishna Kant <krishna.kant@purestorage.com>
>> ---
>> drivers/scsi/scsi.c        | 40 =
++++++++++++++++++++++++++++++++++++++
>> drivers/scsi/sd.c          |  4 +++-
>> include/scsi/scsi_device.h |  1 +
>> 3 files changed, 44 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index 09ef0b31dfc0..9265b3d6a18f 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -356,6 +356,46 @@ static int scsi_get_vpd_size(struct scsi_device =
*sdev, u8 page)
>> return result;
>> }
>>=20
>> +/**
>> + * scsi_vpd_page_supported - Check if a VPD page is supported on a =
SCSI device
>> + * @sdev: The device to ask
>> + * @page: Check existence of this Vital Product Data page
>> + *
>> + * Functions which explicitly request a given VPD page
>> + * should first check whether that page is among the
>> + * supported VPD pages. This will avoid targets returning
>> + * unnecessary errors which can cause confusion. -EINVAL is
>> + * returned if the page is not supported and 0 if it is.
>> + */
>> +int scsi_vpd_page_supported(struct scsi_device *sdev, u8 page)
>> +{
>> + const struct scsi_vpd *vpd;
>> + uint16_t page_len;
>=20
> Probably rather `u16` as per kernel-style.

Sure. This can easily be done.
>=20
>> + int ret =3D -EINVAL;
>=20
> Been wondering, whether it would make sense to have two different =
error
> levels here. One for the case where the page is not found in the loop
> that searches within page 0, and one for when page 0 is not present =
when
> we try to dereference the RCU protected pointer.
>=20
> That way we could have a safe fallback. If the page is there, we use =
its
> data, if it is not, we blindly send the INQUIRY like we do today.
>=20
> Not sure whether this is a bit too paranoid.. VPD page 0 is mandatory
> after all.

That could be done, but the problem would still exist for the PURE =
target.
We don=E2=80=99t support the page 0xb9, and we don=E2=80=99t advertise =
we do in the response
to VPD 0. This approach would still lead to the INQUIRY being sent to =
devices
who don=E2=80=99t support it, don=E2=80=99t expect it, and report an =
unexpected error. What I am
trying to avoid is the INQUIRY being sent to devices who don=E2=80=99t =
invite it.

Thanks,
Brian
>=20
>> + int pos =3D 0;
>> +
>> + rcu_read_lock();
>> + vpd =3D rcu_dereference(sdev->vpd_pg0);
>> + if (!vpd)
>> + goto out;
>> +
>> + page_len =3D get_unaligned_be16(&vpd->data[2]);
>> +
>> + /*
>> + * The first supported page starts at byte 4 in the buffer.
>> + * Read from that byte to the last dictated by page_len above.
>> + */
>> + for (pos =3D 4; pos < page_len + 4; ++pos) {
>> + if (vpd->data[pos] =3D=3D page)
>> + ret =3D 0;
>> + }
>> +
>> +out:
>> + rcu_read_unlock();
>> + return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(scsi_vpd_page_supported);
>> +
>> /**
>>  * scsi_get_vpd_page - Get Vital Product Data from a SCSI device
>>  * @sdev: The device to ask
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 1624d528aa1f..0304b7d60747 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -3127,7 +3127,9 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
>> */
>> buf_len =3D 64 + 256*32;
>> buffer =3D kmalloc(buf_len, GFP_KERNEL);
>> - if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb9, buffer, =
buf_len))
>> + if (!buffer ||
>> +    scsi_vpd_page_supported(sdkp->device, 0xb9) ||
>=20
> Wouldn't it make sense to do this before the allocation? If it really
> turns out to be unsupported, that seems like a waste.
>=20
>> +    scsi_get_vpd_page(sdkp->device, 0xb9, buffer, buf_len))
>> goto out;
>>=20
>> /* We must have at least a 64B header and one 32B range descriptor */
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index f10a008e5bfa..359cd8b94312 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -431,6 +431,7 @@ extern int scsi_mode_select(struct scsi_device =
*sdev, int pf, int sp,
>>    struct scsi_sense_hdr *);
>> extern int scsi_test_unit_ready(struct scsi_device *sdev, int =
timeout,
>> int retries, struct scsi_sense_hdr *sshdr);
>> +extern int scsi_vpd_page_supported(struct scsi_device *sdev, u8 =
page);
>> extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned =
char *buf,
>>     int buf_len);
>> extern int scsi_report_opcode(struct scsi_device *sdev, unsigned char =
*buffer,
>=20
> --=20
> Best Regards, Benjamin Block        /        Linux on IBM Z Kernel =
Development
> IBM Deutschland Research & Development GmbH    /   =
https://www.ibm.com/privacy
> Vors. Aufs.-R.: Gregor Pillen         /         Gesch=C3=A4ftsf=C3=BChru=
ng: David Faller
> Sitz der Ges.: B=C3=B6blingen     /    Registergericht: AmtsG =
Stuttgart, HRB 243294

