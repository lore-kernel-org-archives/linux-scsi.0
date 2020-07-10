Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2474C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 07:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F3E206A5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 07:40:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="T36YuZLu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgGJHkd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 03:40:33 -0400
Received: from mout.web.de ([217.72.192.78]:51103 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbgGJHkc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 03:40:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594366814;
        bh=YOGMwdQg22m0AVjzIfGqr6DmFrX7EG+OknGlPZqcceA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=T36YuZLuf7CaI3XX/chbrl1dDhwuYbGlhVrEQRZSGCGpZcNKNvxXAmttML3+D8xSV
         pmbRR9hhubaddvvbE5ctktJvxD9WP66dU/emrU5gc/aTI6JSqsJwwtyxoFGRJGSHLd
         jQUaiYR/zcCfyKYVCVf6vDX/YZNvlFH3Cv4pbUBY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.129.239]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MfHfy-1kEBlc0vQg-00OlG9; Fri, 10
 Jul 2020 09:40:14 +0200
Subject: Re: [PATCH] scsi: virtio_scsi: Remove unnecessary condition checks
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Xianting Tian <xianting_tian@126.com>,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <a197f532-7020-0d8e-21bf-42bb66e8daec@web.de>
 <e87746e6-813e-7c0e-e21e-5921e759da5d@redhat.com>
 <8eb9a827-45f1-e71c-0cbf-1c29acd8e310@web.de>
 <58e3feb8-1ffb-f77f-cf3a-75222b3cd524@redhat.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <9815ef2d-d0da-d197-49d7-83559d750ff1@web.de>
Date:   Fri, 10 Jul 2020 09:40:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <58e3feb8-1ffb-f77f-cf3a-75222b3cd524@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:H8jRkEuxmFhJoweumit1bJASWj0xwrFWXFh6DmSCubIoPH3av1E
 pozjVfA/mj6yEs7sAOso53Mi+xc1WIVDXq/OwZaxP1J/gFj+iNilf8CCoIVPlMLSnhSpquz
 v9/phQHhsrkGqiJTO1Xp7xFZywV34zlfPW7JHXZU6BdLYo3u/G5y8Rk3C32eONZ5AzW5Yg5
 JLFkNEPFzpYfYp0vtiEtA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bQb8xpUkZxA=:iEu722ESegI1ZL7n+l7u4Z
 tY5RxAI3bSO6R1rSM7etQpgB50IS69C8u8YJqAhov80LAw2VlXYtZA7tzTtNp1zVplMeG8elo
 4Np1DaPa3TVtkk3GNLjhxTSylUxCZDTVJQK8bMFVroEg3WRp8GbnW1QJCDG5+x8UnpRKT4v8S
 z+s5aUMU8Dp+vtdrsTbWWCGssoYm7TBaaCsprotpvf2ae4M3YeWiasQ3lfsBwaBJlSKru9STC
 Zj7xXQOWyIKvtCIIWK6eEN6QAKkafnWA3iVTx4TAxq9bIkfyaslOxCpyGXVlbiSesVhb6Ru9+
 GjxyXaea8FCp6Y5jOkUGJX836vJdV+W7uZ/qdtBCL42f0rGQvnSKSaX6ui4k3Yq2izkvASMgo
 Rp6h//A/13tJQSAhWcD/Z2zwqQtOf1YF+42I6LXYnQdVF/Wf74rxr5/SOpsIUvMK1XUqy20gF
 MOvVC610ewNh4bxJ8Vd3Qt9tghtFcpvobyUtzw3z19+bv2JPmL5EaNSyoPZJsAULw1uPAhhAJ
 Ezwc7mHS4NYEjG9E+1Tl2x7XJjcbIKjqytZex0kyc/3GzaVvRWrRnxfDaLK7q5e6PNDLWS2B2
 qhG/ln9UhQHr3VWsQ0i1VPnd2v3f+klWl9WnyrTRgmjt3r/4wsQBSK8BXuLP+4tFfHxNRVqF/
 5B5vuZO88QAgy3/0oXX2d6CYaHLquJEVEO1fu/d4/Y1ZvapNG6EMEZpy5DQiS7rSvu8ieMhaM
 cBIXlxddhVQ9ytZrpL+FAozNGskEJODPsGaBuCfJxz3oNDGJlLxM5Mi4sQSAFnBh52BuMef65
 q5dL4A2gcLOG+Sy6817V3+GeTCoWtIL1353vXOMr+PMQ44vL4+MSaN5WrQGnzjlABZ2of9U+o
 NbuWdaRc2O4prA9A+MQLTLguiGR/Scd3Mkzl1a4tRhSdI71EAT45JgNBBZ2GeyBt1EdWTAGkF
 BXlMxf+MFhkkWs/SiEl3SH00fw73+LWYI2VTYOmtUHkPTTybziWjlCf1/O/uJLLc2Grsp+RvC
 Dp7etfe6FPSwXVQdL9/WJ/PviGncxYGdKTrguKgjTw/NEes2S1V6pAnbaOOrhL2nLZTJhumi1
 EX3cIGw8boKDI3BMBieBxyE9A4ay6PiYvq/IWCc8/j7l4j7ZyyQJ/RFF5CSkY9hGakzK6jk6u
 oJhGfQU9mQbeO7E6/lj9U4FUNUGRpiDgi7eRCGKvuEueUu3fuAbLhJ4EfOKU3/mHhOEVRV1g8
 whudaqSqP6EMMraijpg1fUawRaPiB+BxaI1oO/w==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/drivers/scsi/virtio_scsi.c?id=3D42f82040ee66db13525dc6f14b8559890b2f4c1c#=
n980
>>
>>  	if (!virtscsi_cmd_cache) {
>>  		pr_err("kmem_cache_create() for virtscsi_cmd_cache failed\n");
>> -		goto error;
>> +		return -ENOMEM;
>>  	}
>
> Could be doable, but I don't see a particular benefit.

Can a bit more =E2=80=9Ccompliance=E2=80=9D (with the Linux coding style) =
matter here?


> Having a single error loop is an advantage by itself.

I do not see that a loop is involved in the implementation of the function=
 =E2=80=9Cinit=E2=80=9D.


>> destroy_pool:
>> 	mempool_destroy(virtscsi_cmd_pool);
>> 	virtscsi_cmd_pool =3D NULL;
>> destroy_cache:
>> 	kmem_cache_destroy(virtscsi_cmd_cache);
>> 	virtscsi_cmd_cache =3D NULL;
>> 	return ret;
>
> ... while there's no advantage in this.

I propose again to improve the affected exception handling another bit
by using appropriate labels.
Will further software improvements be achieved by a corresponding patch se=
ries?

Regards,
Markus
