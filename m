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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBE3C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 08:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C9712078B
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 08:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="jyc8rN4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgGJILY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 04:11:24 -0400
Received: from mout.web.de ([212.227.17.12]:49261 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgGJILY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 04:11:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594368661;
        bh=zWhIWqfCmDxTGjMuULUDFC+ehkme1KzqUP/xhZCGJ9Y=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=jyc8rN4tsIXvFe9nsmr8L5jFkMAifoKc+x60GkqbftxOxpVoBEjYqgw/mu0Fqckak
         0QubrqGo+EklK6yG4vlJAwzTUh2VkesVF9Z4SBTJfc1tdjasIPkef8ko+gXB1QeNGs
         e1Q4VRo7yB9kdIXkfNkBhry76tWi/K/3slNQDN4I=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.129.239]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MQ6H9-1jz32s0gIF-005F7e; Fri, 10
 Jul 2020 10:11:01 +0200
Subject: Re: scsi: virtio_scsi: Remove unnecessary condition checks
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
 <9815ef2d-d0da-d197-49d7-83559d750ff1@web.de>
 <d052b441-cc4d-4b2b-1442-b1a30bed2fdb@redhat.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <39c76c43-cd5f-40cb-7225-e2e143f8c131@web.de>
Date:   Fri, 10 Jul 2020 10:11:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <d052b441-cc4d-4b2b-1442-b1a30bed2fdb@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:KrDYJSLOj6orqhKlBmXpRYOniDHXAICtpRQx/Oq4OB9mqj5Yhc/
 /fPb+t6hy6ADOyH+q5mPxAEGeU91mxKZtoESPTI4i14A085Myi1OaiSsF9EZerVDst76QNP
 92A11CAN5utSyNeDKLAU9riA9J2Pzs8xtS9mEfmGxfqPSouJNMIrpwNDr6JhSM6wYXFOn9P
 2m/erNeAyt6LazSlViBQA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:cFkFiyL49Dw=:CndEjmWHfQAU4nKBVIJA9W
 I2YVdifx7OyGrJI2AMuqMm6Cl0Rg3Z3BdDf0uk1U4RNLvyLCsgUAF81w3Qis0SqRNf0IVxUt/
 OHIo8lLsFWKVMhmoapaot94uDcHlUg3vz3HCDgi09nRg364cK8SAfe9ZBqiyayD+bksAXzNbO
 IjzibzXZZd0kzsBg9eqqUDsLXLCxTvd9MIK3e85RrAJXKiCygaoaMJf5cH7eQu0ks3TCHQsyu
 zKvYektto6Vm2wGpuiQymOGp2qkK/kMJLdvBgtC6SJ1QCox81H7WFFAGTaeEfdtCfAvWFpvjr
 PpYiGRPz/10hwDy2ICyjJqeutcoeFsvPXeAB/7jegc9lrxsOQzzF1+P4RoIq5LgWL3cCvcY6D
 EiRDXO46og5KqNOdeViBCOeRs/tbAHaBWqephYZQj2fNzQVO/NxLzpkC6nqyq4oPYg4zmda8/
 AtaNTGbQVdoZ3YNiS1qReJ/dRt+e4UCoPbOTGSID5qkpVSWWRBwNVVYSp/tIoUKVFBZdh2VFx
 1m2kjKxRgBuKllgLRQAohaWInyj9OunI34r4jOh9KVOd2xsY4Y+75EKYwRZL140lhgRH28Olv
 kMQdYT9Jm6BuP/7tL+cNwzXI4XqO0GkF9PP7huFhJ9sXUKzv+9IxYoDOh8iEHz7s4JvybPv4R
 2ZEflDhkHjFEkj/srBDXmOUdIsdHL++hHbtv2lVnxa4SckgsqgamnWuxNtrvZu5QWggkZ96Wl
 yI3lW5r7wcSXTt8MiimYE8nrArTlI1+bcDTWZhYDjA23q0wSRH5O/d82v1XnlWq6MAcgPcAsL
 oyi/6c8Jm3uFH0+KJULH9EdWd0O+Uhlqi58HKHZVqis2VoaO4UMOTmBL1gRRF/70fLoinTtMy
 WNvhlxgT53Yzige7JHef/lYrOiPEQfz1EUXy5ijsSyPVo0X3jh1AvhRc4XESCZ74rtXYixqoW
 J3kziuWhYDaBsyK+CFboDtqnTGx+FfjG5I/WMIf4yJL3BdMoVUmP7vscsULUe8VShy0vJ/+d8
 LoMLopBLi3KPrJry8lR7NCsjUID8x786EumAaBUfb8jiFGYR22r23rA8fIK/MwS0wGQ7G+3by
 tQOm3eH+T4eSrTNzAP64h5PHCoTpWWEqMprsj2Gi0VLmgvb+2/FZEAZtWQpvoydIY9LyMOp0s
 BeyavWxJqDm/0Z+vdWe5M/a+OTQoVx6gD2MyLmEmFY+nyDF+L43Wy/9RI0H347JCCtAtH3P4n
 WCnzxsBuK356JV+hJMqW4RJtBEgTiF5U4Zp8qaw==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> Can a bit more =E2=80=9Ccompliance=E2=80=9D (with the Linux coding styl=
e) matter here?
>
> No.

Please take another look at the corresponding software documentation.


>>> Having a single error loop is an advantage by itself.
>>
>> I do not see that a loop is involved in the implementation of the funct=
ion =E2=80=9Cinit=E2=80=9D.
>
> s/loop/label/ sorry.

Thanks for this information.

Can the development attention grow for corresponding implementation detail=
s
around the specifcation of efficient exception handling?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?id=3D42f82040ee66db13525dc6f14b855989=
0b2f4c1c#n465

Regards,
Markus
