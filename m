Return-Path: <SRS0=8r17=5U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB40C2BA18
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Apr 2020 09:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ADA4206C3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Apr 2020 09:00:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="CWwAiRbS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgDDJAr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Apr 2020 05:00:47 -0400
Received: from mout.web.de ([217.72.192.78]:47967 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgDDJAr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 4 Apr 2020 05:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1585990808;
        bh=6AZNLBH442OJ8odjJvTTvY0h4k6dpRK0RBQlSly1moE=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=CWwAiRbS5oMBV7raoZQUBcLgFaDdoagCNIO4MF5k4X5QWwMD82+bqY26t5Eindwzd
         1zOFHMnSy5WlfdOsb9qUamIqpMX610aRV4vF/4tlAcOZFi2dhFkb13mR38gNI9m+QH
         4VFQonBOAvhY0IkQQT9/T+FRuIR4+OPX+JW86F5E=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.132.181.229]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M89z3-1j7ojZ1egD-00vkAy; Sat, 04
 Apr 2020 11:00:08 +0200
To:     Alex Dewar <alex.dewar@gmx.co.uk>, Hannes Reinecke <hare@suse.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Remove unnecessary NULL checks before
 kfree
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <f90372e4-f0f7-7775-5144-0d3684116be1@web.de>
Date:   Sat, 4 Apr 2020 11:00:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vZGcnRyqXOMIW9kJ5OPJxCBJCj/uHsX7pcmL2u8A0L1gUeRAbkg
 n+AQFwA1ngD/SO91jLCDlZ0Giau0UpFSYC1SMlFl/zZ0UoJnQm7PJrmvp6S/1Fj102xlDoh
 2N+xmnECXcaKOYYxPDvHoHVlCbJ9jlcr6kLcBrQxPN7ooQOfws8nV/RuLBlnYNEzZs0ws09
 XeIa72DGpsezllVtNIuJQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:51lskV8xcJM=:XlJVRhoVzCYSkiJDjTD8P0
 i3VKTJoPM741eK0WVFNHqlLroLONDPehrlE50iJ65+vVJcnI4ZQr+5Lv/lErHx9xauawys5g/
 uDrxHfFtub8oM8RNdRVZE+1uo3MJNCZQcXJNzozRx6jLSPpW2mQg21jKjHQpepTRIh/QFzEAz
 qb2BApTrwkSTqxU3mve6a8qbRJg75ug0pgAMVAsW52wou4PR2c2CrohynsauvVzAdIjfVc3D5
 bAiA3kqTlFOdy1X+QjTZ6u53pqxRjKLZi+FMK9pZdmpclOpGa7p2iu/W6Uj844SoPps+ISxfU
 oLMvxBXRvPTs6E9LFTqiBNHSY/dbn7k0LdOvpf4hQdekdFz+BjDFRU9loa/ZcbGeVYBH97DBx
 CV1qxX508f8JOI7+3OdKxGNXW9kiWNbuM2bTGsMq1E6u18TyMl7HfVh6WpCD+MTUX6cEIGluu
 Ex0KK96hDFttoE1iNyD/dVIiVjN1yvviBth9/ek/QrdBzjPQLZZjmJVrtarJYaSMQ2AqgM1Ta
 dluMhzbFJUMcY1HO8gL1hQnptXHXPPE6Ec3CQyEIYv4bGj+iKzs7WNSEBYmYkoqcMZcsPSM7S
 Y1Mm05ccClfnG/Cv5UiTFdGxSzivyZy1XGuDtCcZ9DIi7NDTuy+pGJAW1jn7HqGYM3BZOB5Gs
 p/dn8071hhzBXrZ8qzEPhNyl3gfEFudcm9YAiZrmx81tn/UBPg+0E/9NSiiKoKW12r5Q9FVO3
 0eC3MnpmvU9AEXnycs4Mx30UQyzm7YqytDAy0c0e3RSAxP2omb9NdxJPPU1IOGTptoCdO2FAe
 04fSM7FDGhCkSg8aI4eR4+DmhOpVvoukZccvmATXHOZCg1c4PcvZ/irVS6yTJve6yhziGntrg
 OjXy+maB21atz1t+OoIRqb9qFQuolWpXt3fAU4OHBTYPCU73MIMeYYiQwhp6eWUz1Fc4VOJCe
 jtSRXAlmsvWuO1670ZtNHtOcLv5j2PWK0pLEQvVDUqOhuC9xkg7NNiy6ODfhj8pltqbpKoGq1
 uFpDm1ef6fzS3iRy/WrDhy8Ierva0XWMTw6SP+PKPjckgTBJQl3qwKhUw1yYaPpXzjn9IiuFI
 3UnD7ewioBxSAN/7+iJq6gnvCMDD67dPH5Vz4sckyt5ptYy4X7DNcD0OwwGglo4ETVu8rQWhY
 JJkLknpGxlSschFRbbK45xBOVY/+FkMzGDQo8uGLO4FzlT3uqQ+5bWRqj7KHvLoOYh51uXpVh
 sbeUakNxEruhMah8s
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> There are a number of places in the aic7xxx driver where a NULL check is
> performed before a kfree(). However, kfree() already performs NULL check=
s
> so this is unnecessary. Remove the checks.

I suggest to reconsider the distribution of recipients also for this patch
according to the fields =E2=80=9CCc=E2=80=9D and =E2=80=9CTo=E2=80=9D.


Do you find a previous update suggestion like =E2=80=9CSCSI-aic7...: Delet=
e unnecessary
checks before the function call "kfree"=E2=80=9D interesting?
https://lore.kernel.org/linux-scsi/54D3E057.9030600@users.sourceforge.net/
https://lore.kernel.org/patchwork/patch/540593/
https://lkml.org/lkml/2015/2/5/650

Regards,
Markus
