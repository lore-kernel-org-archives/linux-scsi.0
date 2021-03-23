Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FE2C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 06:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B087F619B8
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 06:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCWGTx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 02:19:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13505 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhCWGT2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 02:19:28 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210323061926epoutp03bf3953f4e1654ef811d72e3ce5ced318~u5FQnEJ2L2001520015epoutp03L
        for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2021 06:19:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210323061926epoutp03bf3953f4e1654ef811d72e3ce5ced318~u5FQnEJ2L2001520015epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616480366;
        bh=SKrcQTE/ysf6LxiojAm0o8vsmAOmaMWJS3Szgq0wDhI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=AIATL6X1TStlRuqf8iERVRec5VaY/ULIcn31O0PZak+zZ/5/EE9QlUZk8JnU4gGWY
         jOGtG4ux87R/Jl+pR0wCuxjz+qTlWTcSFeDqh2Geat19nm4W5bi+rqzw8bHINpt5MM
         H26e7QeeIehve3QbM1D3Q5GXHXJ8y7zycS1Lp/U0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210323061925epcas2p133c997c26ae80f784ee83877347b4941~u5FPzbfVo1765817658epcas2p1n;
        Tue, 23 Mar 2021 06:19:25 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4F4Lmq2X4hz4x9Ps; Tue, 23 Mar
        2021 06:19:23 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-38-6059886bc2a2
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        02.1B.52511.B6889506; Tue, 23 Mar 2021 15:19:23 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v31 2/4] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     Bean Huo <huobean@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <1df7bb51dc481c3141cdcf85105d3a5b@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210323061922epcms2p739666492ebb458d70deab026d074caf4@epcms2p7>
Date:   Tue, 23 Mar 2021 15:19:22 +0900
X-CMS-MailID: 20210323061922epcms2p739666492ebb458d70deab026d074caf4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te1BUVRzH59y7e/eCs87lpQdUYi6DxnN3yV2PBo6S1mWQpHTGTWeCO3AF
        ZF/tBTIr20beysNpECPCgBEYnoHu8jR51CIlmbNmuUNGLUbUYMhjxgVlYllIp/++8znfc36/
        7++cQ+LufxA+ZKomndNrWBVNuApMg4EoNC3vrQTpYt56NFZpItC1nBsiNGn/kUAXpu04mmmt
        FaLJgUDU3d9PoIaxI+hMTSuBKkYMGCosNhLoSv+XOLKNzopQ9c8mDBUv5QqQadYNDQ0/BMjS
        XUGgsz91EqhuaAlDl433AMovaxLs2cBY7sQwlqJCjOkq/0XElFT3Aeb6500iJmv4uoB59MAq
        YIquNgBmtt2Xye07i8W5HlVFpHBsEqf34zSJ2qRUTXIkHXMo/pV4uUIqC5XtRDtoPw2r5iLp
        fQfiQl9NVS3HpP0yWVXGMopjeZ6W7I7QazPSOb8ULZ8eSXO6JJVOJtOF8ayaz9AkhyVq1btk
        Umm4fNmZoEopaszU/el90jY5gRtAj2cBcCEhtR2WzEyKCoAr6U51AphvvCUoACQpptzg004P
        h8eDioFPfiglHNqdomHr7XKRk4dB629NwKEJKgSW3fh1hXtS0XD+k0ah40ycmiFgvdlpgpQY
        Xsx9IHDqTbCjzrjCXajdcLTAuOp5ET6uLcSd2gvea5wSrel/zJdWPZ4w+/7IqscNjtl7Vrk3
        NPdMY079ETSOLgBHE5A6B+Bgl1XoXJDAu3ltK02IqVjY9U32ChdQAXDIZgKO8JDaBy8bfB0Y
        p4JhbdXfuAPjVCBs7ZY4Hf7wa6tgLZWhbVH0f41T62He4NP/eGfl+GpnW2GLvRUrAf7lzwZd
        /lyt8me1vgB4A9jA6Xh1MseH67Y/f7XtYOXBBzGd4LOp6bABgJFgAEASpz3FWUeUCe7iJPa9
        U5xeG6/PUHH8AJAvhzyP+3glapd/jCY9XiYPVyikO+VIrghH9EaxXjoW704ls+lcGsfpOP3a
        Pox08TFgwoboxdzQqIpvayYeT74g2Xzu422pzf7KLKkr5Hd8P1z1qdro+1A9JSTn7h+09371
        xs2QEIUl2146kzkWmyXsSQtblxPbHHDYcJh4NLIEpuZPvxYltskja7r/apbUl84cP94zF2cO
        XsiqjIaY99zixk3FfJ1UeUJiTqj5IO27a40de1HwmxWGpbY7ldLGCx7HvPzHLZZ1UVveVUy8
        f2zL1ghD3IDt9BO59nV7QMfJWxnz5O1Bw8Gq7DPn2XorHWl6yfdm3n4s6JC1t/3tjtTxhZYr
        Ld5lJ14+tTdUmaPcL9o16NLXa7noVv27l1fNcMeezVUH5LZ3bM1XvT803x0fzdccpQV8CisL
        wvU8+y/UjIjKeQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860
References: <1df7bb51dc481c3141cdcf85105d3a5b@codeaurora.org>
        <e9b912bca9fd48c9b2fd76bea80439ae@codeaurora.org>
        <20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p5>
        <20210322065410epcms2p431f73262f508e9e3e16bd4995db56a4b@epcms2p4>
        <75df140d2167eadf1089d014f571d711a9aeb6a5.camel@gmail.com>
        <d6a032261a642a4afed80188ea4772ee@codeaurora.org>
        <20210323053731epcms2p70788f357b546e9ca21248175a8884554@epcms2p7>
        <CGME20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On 2021-03-23 13:37, Daejun Park wrote:
>>> On 2021-03-23 12:22, Can Guo wrote:
>>>> On 2021-03-22 17:11, Bean Huo wrote:
>>>>> On Mon, 2021-03-22 at 15:54 +0900, Daejun Park wrote:
>>>>>> +       switch (rsp_field->hpb_op) =7B
>>>>>>=20
>>>>>> +       case HPB_RSP_REQ_REGION_UPDATE:
>>>>>>=20
>>>>>> +               if (data_seg_len =21=3D DEV_DATA_SEG_LEN)
>>>>>>=20
>>>>>> +                       dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>>>>>=20
>>>>>> +                                =22%s: data seg length is not
>>>>>> same.=5Cn=22,
>>>>>>=20
>>>>>> +                                __func__);
>>>>>>=20
>>>>>> +               ufshpb_rsp_req_region_update(hpb, rsp_field);
>>>>>>=20
>>>>>> +               break;
>>>>>>=20
>>>>>> +       case HPB_RSP_DEV_RESET:
>>>>>>=20
>>>>>> +               dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>>>>>=20
>>>>>> +                        =22UFS device lost HPB information during
>>>>>> PM.=5Cn=22);
>>>>>>=20
>>>>>> +               break;
>>>>>=20
>>>>> Hi Deajun,
>>>>> This series looks good to me. Just here I have one question. You
>>>>> didn't
>>>>> handle HPB_RSP_DEV_RESET, just a warning.  Based on your SS UFS, how
>>>>> to
>>>>> handle HPB_RSP_DEV_RESET from the host side? Do you think we shoud
>>>>> reset host side HPB entry as well or what else?
>>>>>=20
>>>>>=20
>>>>> Bean
>>>>=20
>>>> Same question here - I am still collecting feedbacks from flash=20
>>>> vendors
>>>> about
>>>> what is recommanded host behavior on reception of HPB Op code 0x2,
>>>> since it
>>>> is not cleared defined in HPB2.0 specs.
>>>>=20
>>>> Can Guo.
>>>=20
>>> I think the question should be asked in the HPB2.0 patch, since in
>>> HPB1.0 device
>>> control mode, a HPB reset in device side does not impact anything in
>>> host side -
>>> host is not writing back any HPB entries to device anyways and HPB=20
>>> Read
>>> cmd with
>>> invalid HPB entries shall be treated as normal Read(10) cmd without=20
>>> any
>>> problems.
>>=20
>> Yes, UFS device will process read command even the HPB entries are=20
>> valid or
>> not. So it is warning about read performance drop by dev reset.
>=20
>Yeah, but still I am 100% sure about what should host do in case of=20
>HPB2.0
>when it receives HPB Op code 0x2, I am waiting for feedbacks.

I think the host has two choices when it receives 0x2.
One is nothing on host.
The other is discarding all HPB entries in the host.=20

In the JEDEC HPB spec, it as follows:
When the device is powered off by the host, the device may restore L2P map
data upon power up or build from the host=E2=80=99s=20HPB=20READ=20command.=
=0D=0A=0D=0AIf=20some=20UFS=20builds=20L2P=20map=20data=20from=20the=20host=
's=20HPB=20READ=20commands,=20we=20don't=0D=0Ahave=20to=20discard=20HPB=20e=
ntries=20in=20the=20host.=0D=0A=0D=0ASo=20I=20thinks=20there=20is=20nothing=
=20to=20do=20when=20it=20receives=200x2.=0D=0A=0D=0AThanks,=0D=0ADaejun=0D=
=0A=0D=0A>Thanks,=0D=0A>Can=20Guo.=0D=0A>=20=0D=0A>>=20=0D=0A>>=20Thanks,=
=0D=0A>>=20Daejun=0D=0A>>=20=0D=0A>>>=20Please=20correct=20me=20if=20I=20am=
=20wrong.=0D=0A>>=20=0D=0A>>=20=0D=0A>>=20=0D=0A>>>=20Thanks,=0D=0A>>>=20Ca=
n=20Guo.=0D=0A>>>=20=0D=0A>>>=20=0D=0A>>>=20=0D=0A>=20=0D=0A>=20=0D=0A>=20=
=20
