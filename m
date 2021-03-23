Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD71C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 06:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20055619A0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 06:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbhCWGhz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 02:37:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55120 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCWGhb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 02:37:31 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210323063729epoutp04c302308ab4acf0dcaa2591e16aa3cb36~u5VBnKjIx1586015860epoutp04c
        for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2021 06:37:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210323063729epoutp04c302308ab4acf0dcaa2591e16aa3cb36~u5VBnKjIx1586015860epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616481449;
        bh=lruqVL8XvsAfgqWeSfk3X0rdps+iKONCYwK0odrW+tY=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=V1lY16+AERQkn1Fw/wg3WvQQsp28k+1PVOXzYKwoln/NjyzgRgCjAM3KMLCY1waeB
         cpRB8oAN9WxxdCozzxCuVi6Me4OjJzapmukJKtJSApm8xpIc2w1qjhKTAD4Snnw6dw
         du9F3+4aZbYOrJKZPY/yWtWQuNOQekGTGpIusrxw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210323063729epcas2p3381b3963d0935bafaaf531b83eb282fd~u5VA9kiCM0308003080epcas2p30;
        Tue, 23 Mar 2021 06:37:29 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.187]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4F4M9f6mw9z4x9QB; Tue, 23 Mar
        2021 06:37:26 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-f0-60598ca6676c
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        16.22.10621.6AC89506; Tue, 23 Mar 2021 15:37:26 +0900 (KST)
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
In-Reply-To: <f224bea78cf235ee94823528f07e28a6@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210323063726epcms2p28aadb16bb96943ade1d2b288bb634811@epcms2p2>
Date:   Tue, 23 Mar 2021 15:37:26 +0900
X-CMS-MailID: 20210323063726epcms2p28aadb16bb96943ade1d2b288bb634811
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te0xbVRzHc+693Ba07LYr7MAM4gVUYEALFs8MIDpYuuESzJbAZKY0cMPD
        0ja9RRFJVpHJ7OgYIYgjXTcZwgZsdTwLjDKKMqohOpl7EMZa94jEIC+NwhhKaXGL/33yPd/z
        +/2+58HFBQ/JQG6BUstolHIFTfoQPSPhkqjmqoPZosHBSOQw9ZBo8NMxDppZ/plEn88v42jR
        3OyFZmzhqH94mEStjgz0yVkziYzjOgwZqrtJ1Dn8NY7uTS1xUOOtHgxVr1USqGeJj67afwdo
        ot9IomM3LSRqubqGoa+6bwP0WX07kewvnbieJp04bsCkfQ13ONITjVeAdOhUO0daYR8ipAsP
        Jgnp8a5WIF3qCJJWXjmGpfu8o0jIZ+S5jCaYUeaocguUeYl02n7ZLpkkXiSOEu9Er9LBSnkR
        k0invJUetbtAsR6TDn5frihel9LlLEvHJCVoVMVaJjhfxWoTaUadq1CLxepoVl7EFivzonNU
        Ra+JRaJYybozW5H/ce8h9XBoycmu00AHnEF64M2F1Cvw11kTqQc+XAFlAfBCyz8cPeByeRQf
        PrZsdXm2Umlw9cc60sUCiobmaw0ctx4NJ53twMUktQPWj93d0IXUHvhnbZuXqyZOLZLw3Kjb
        BCke/KLyAeHm7bC3pXtD96aS4NTcvEd/Gf7dbMDd7Advt81yNnlu9LSnjhAemR73ePjQsTzg
        0QPg6MA85ubDsHtqBbiGgFQVgCN9k17uhRh44+glwh1yH3QO7XLJBBUGj9h/8NRJgfqqpo3A
        OBUJm7/8DXfZcSocmvtjXAipEPjNJLGZSnfpEef/jFO+8OjI4/90i+m+Z7IX4cVlM3YChDQ8
        OeiGp3o1POl1BuCtwJ9Rs0V5DBurFj99tR1g48FHpFpA7ex8tA1gXGADkIvTQl5FRma2gJcr
        /7CU0ahkmmIFw9qAZD1lDR7ol6Na/zFKrUwsiY2PF+2UIEl8LKK38ViRQyag8uRa5j2GUTOa
        zX0Y1ztQh8Ud+L7RvykmCXeklvU+F7LF6lVXyjtsKIH8BfOKekcZv3Dvm2G2oTMzxnQwCkSZ
        C+kJj0aEk/uma63JB/NOdvrxyy+OR+kT+i73awQ3tqwWmg2myuerCrcZ770blyq6ORawYI84
        +8IzWQPlUwqNLq6nKVbrmH7Jcctq372yX2+YDjuUBUWhd/iWCmH7ntfttrmKsmvY+VXrXdO5
        v4IfSp6t2Vt93iZMNjErQZ0DjiqJL1+29lPO5VJVwCl+XZlRkXHd+kfoR877beUd1rcvLE4f
        yOzKeqNG2W3HaiO/8x2uNwVt5/T9InCujsUUh4HElNnZNhvTlatzfptdkv8BQRNsvlwcgWtY
        +b8bkQqJeQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860
References: <f224bea78cf235ee94823528f07e28a6@codeaurora.org>
        <1df7bb51dc481c3141cdcf85105d3a5b@codeaurora.org>
        <e9b912bca9fd48c9b2fd76bea80439ae@codeaurora.org>
        <20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p5>
        <20210322065410epcms2p431f73262f508e9e3e16bd4995db56a4b@epcms2p4>
        <75df140d2167eadf1089d014f571d711a9aeb6a5.camel@gmail.com>
        <d6a032261a642a4afed80188ea4772ee@codeaurora.org>
        <20210323053731epcms2p70788f357b546e9ca21248175a8884554@epcms2p7>
        <20210323061922epcms2p739666492ebb458d70deab026d074caf4@epcms2p7>
        <CGME20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On 2021-03-23 14:19, Daejun Park wrote:
>>> On 2021-03-23 13:37, Daejun Park wrote:
>>>>> On 2021-03-23 12:22, Can Guo wrote:
>>>>>> On 2021-03-22 17:11, Bean Huo wrote:
>>>>>>> On Mon, 2021-03-22 at 15:54 +0900, Daejun Park wrote:
>>>>>>>> +       switch (rsp_field->hpb_op) =7B
>>>>>>>>=20
>>>>>>>> +       case HPB_RSP_REQ_REGION_UPDATE:
>>>>>>>>=20
>>>>>>>> +               if (data_seg_len =21=3D DEV_DATA_SEG_LEN)
>>>>>>>>=20
>>>>>>>> +                       dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>>>>>>>=20
>>>>>>>> +                                =22%s: data seg length is not
>>>>>>>> same.=5Cn=22,
>>>>>>>>=20
>>>>>>>> +                                __func__);
>>>>>>>>=20
>>>>>>>> +               ufshpb_rsp_req_region_update(hpb, rsp_field);
>>>>>>>>=20
>>>>>>>> +               break;
>>>>>>>>=20
>>>>>>>> +       case HPB_RSP_DEV_RESET:
>>>>>>>>=20
>>>>>>>> +               dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>>>>>>>=20
>>>>>>>> +                        =22UFS device lost HPB information during
>>>>>>>> PM.=5Cn=22);
>>>>>>>>=20
>>>>>>>> +               break;
>>>>>>>=20
>>>>>>> Hi Deajun,
>>>>>>> This series looks good to me. Just here I have one question. You
>>>>>>> didn't
>>>>>>> handle HPB_RSP_DEV_RESET, just a warning.  Based on your SS UFS,=20
>>>>>>> how
>>>>>>> to
>>>>>>> handle HPB_RSP_DEV_RESET from the host side? Do you think we shoud
>>>>>>> reset host side HPB entry as well or what else?
>>>>>>>=20
>>>>>>>=20
>>>>>>> Bean
>>>>>>=20
>>>>>> Same question here - I am still collecting feedbacks from flash
>>>>>> vendors
>>>>>> about
>>>>>> what is recommanded host behavior on reception of HPB Op code 0x2,
>>>>>> since it
>>>>>> is not cleared defined in HPB2.0 specs.
>>>>>>=20
>>>>>> Can Guo.
>>>>>=20
>>>>> I think the question should be asked in the HPB2.0 patch, since in
>>>>> HPB1.0 device
>>>>> control mode, a HPB reset in device side does not impact anything in
>>>>> host side -
>>>>> host is not writing back any HPB entries to device anyways and HPB
>>>>> Read
>>>>> cmd with
>>>>> invalid HPB entries shall be treated as normal Read(10) cmd without
>>>>> any
>>>>> problems.
>>>>=20
>>>> Yes, UFS device will process read command even the HPB entries are
>>>> valid or
>>>> not. So it is warning about read performance drop by dev reset.
>>>=20
>>> Yeah, but still I am 100% sure about what should host do in case of
>>> HPB2.0
>>> when it receives HPB Op code 0x2, I am waiting for feedbacks.
>>=20
>> I think the host has two choices when it receives 0x2.
>> One is nothing on host.
>> The other is discarding all HPB entries in the host.
>>=20
>> In the JEDEC HPB spec, it as follows:
>> When the device is powered off by the host, the device may restore L2P=
=20
>> map
>> data upon power up or build from the host=E2=80=99s=20HPB=20READ=20comma=
nd.=0D=0A>>=20=0D=0A>>=20If=20some=20UFS=20builds=20L2P=20map=20data=20from=
=20the=20host's=20HPB=20READ=20commands,=20we=20=0D=0A>>=20don't=0D=0A>>=20=
have=20to=20discard=20HPB=20entries=20in=20the=20host.=0D=0A>>=20=0D=0A>>=
=20So=20I=20thinks=20there=20is=20nothing=20to=20do=20when=20it=20receives=
=200x2.=0D=0A>=20=0D=0A>But=20in=20HPB2.0,=20if=20we=20do=20nothing=20to=20=
active=20regions=20in=20host=20side,=20host=20can=20=0D=0A>write=0D=0A>HPB=
=20entries=20(which=20host=20thinks=20valid,=20but=20actually=20invalid=20i=
n=20device=20=0D=0A>side=20since=0D=0A>reset=20happened)=20back=20to=20devi=
ce=20through=20HPB=20Write=20Buffer=20cmds=20(BUFFER=20ID=20=0D=0A>=3D=200x=
2).=0D=0A>My=20question=20is=20that=20are=20all=20UFSs=20OK=20with=20this?=
=0D=0A=0D=0AYes,=20it=20must=20be=20OK.=0D=0A=0D=0APlease=20refer=20the=20f=
ollowing=20the=20HPB=202.0=20spec:=0D=0A=0D=0AIf=20the=20HPB=20Entries=20se=
nt=20by=20HPB=20WRITE=20BUFFER=20are=20removed=20by=20the=20device,=0D=0Afo=
r=20example,=20because=20they=20are=20not=20consumed=20for=20a=20long=20eno=
ugh=20period=20of=20time,=0D=0Athen=20the=20HPB=20READ=20command=20for=20th=
e=20removed=20HPB=20entries=20shall=20be=20handled=20as=20a=0D=0Anormal=20R=
EAD=20command.=0D=0A=0D=0AThanks,=0D=0ADaejun=0D=0A=0D=0A>Thanks,=0D=0A>Can=
=20Guo.=0D=0A>=20=0D=0A>>=20=0D=0A>>=20Thanks,=0D=0A>>=20Daejun=0D=0A>>=20=
=0D=0A>>>=20Thanks,=0D=0A>>>=20Can=20Guo.=0D=0A>>>=20=0D=0A>>>>=20=0D=0A>>>=
>=20Thanks,=0D=0A>>>>=20Daejun=0D=0A>>>>=20=0D=0A>>>>>=20Please=20correct=
=20me=20if=20I=20am=20wrong.=0D=0A>>>>=20=0D=0A>>>>=20=0D=0A>>>>=20=0D=0A>>=
>>>=20Thanks,=0D=0A>>>>>=20Can=20Guo.=0D=0A>>>>>=20=0D=0A>>>>>=20=0D=0A>>>>=
>=20=0D=0A>>>=20=0D=0A>>>=20=0D=0A>>>=20=0D=0A>=20=0D=0A>=20=0D=0A>=20=20
