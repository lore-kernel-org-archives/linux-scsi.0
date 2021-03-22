Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B764C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 09:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FE3861924
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 09:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhCVJpp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 05:45:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32892 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhCVJpl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 05:45:41 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210322094538epoutp03692a368cad761f29fa240336b53903f9~uoQAzLU170590405904epoutp03Z
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 09:45:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210322094538epoutp03692a368cad761f29fa240336b53903f9~uoQAzLU170590405904epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616406338;
        bh=7dGuIZecdaBruMcYMM8KkjPLba2vJ5qoLGcy5+CwqwI=;
        h=Subject:Reply-To:From:To:In-Reply-To:Date:References:From;
        b=illUY39ddH1ocboKjAwf+8RaWXQD0uetK7M1CPONK0QU9WN217O3XUCY+6twgJpqR
         OFQF+XcieXvANtLFxFw/v/BPc0JuQ+i9EgfWMZwES8C9vqp4+bS1u1MapjY6/2YVrW
         0oscd5Of0PFX8h/Fw0mBzfZplEsOReDzBiy66oqc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210322094537epcas2p16586f412839dc719e4af12d377deb4ce~uoP-8fvai0799307993epcas2p1r;
        Mon, 22 Mar 2021 09:45:37 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.184]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4F3qPC30X7z4x9Q8; Mon, 22 Mar
        2021 09:45:35 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-6b-6058673fac5b
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6D.40.56312.F3768506; Mon, 22 Mar 2021 18:45:35 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v31 2/4] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
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
In-Reply-To: <75df140d2167eadf1089d014f571d711a9aeb6a5.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210322094534epcms2p5b2c0e5b18307f98a17bb385ee64bdc2c@epcms2p5>
Date:   Mon, 22 Mar 2021 18:45:34 +0900
X-CMS-MailID: 20210322094534epcms2p5b2c0e5b18307f98a17bb385ee64bdc2c
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALsWRmVeSWpSXmKPExsWy7bCmua59ekSCwfVlwhYP5m1js9jbdoLd
        4uXPq2wW0z78ZLb4tH4Zq8XLQ5oWuw4eZLNY9SDconnxejaLOWcbmCx6+7eyWWw+uIHZ4vGd
        z+wWi25sY7Lo/9fOYrHts6DF8ZPvGC0u75rDZtF9fQebxfLj/5gslm69yWjROX0Ni4OYx+Ur
        3h6X+3qZPHbOusvuMWHRAUaP/XPXsHu0nNzP4vHx6S0Wj74tqxg9Pm+S82g/0M0UwBXVwGiT
        WJSckVmWqpCal5yfkpmXbqsUGuKma6GkkJFfXGKrFG1oYaRnaGmqZ2KpZ2Qea2VoYGBkqqSQ
        l5ibaqtUoQvVraRQlFwAVF2SWlxSlJqcChQqciguSUxP1StOzC0uzUvXS87PVVIoS8wpBepT
        0rezyUhNTEktUkh4wpjRsHYbS8F03oply1axNDB+5exi5OCQEDCRaDgU1sXIxSEksINR4tWd
        v8wgcV4BQYm/O4S7GDk5hAW8Jf5cmMoGYgsJKEmsvziLHSKuJ3Hr4RpGEJtNQEdi+on77CBz
        RAROskv8fnufCSQhIcArMaP9KQuELS2xfflWRpD5nALuEg+faEOENSR+LOtlhrBFJW6ufssO
        Y78/Np8RwhaRaL13FqpGUOLBz91QcUmJY7s/QK2ql9h65xcjyA0SAj2MEod33mKFSOhLXOvY
        CHYDr4CvRNOy7WALWARUJTb3f4Ua6iKx6tNCMJtZQFti2cLX4HBgFtCUWL9LHxJUyhJHbrHA
        fNWw8Tc7OptZgE+i4/BfuPiOeU+gTlOTWPdzPRPEGBmJW/MYJzAqzUKE8ywka2chrF3AyLyK
        USy1oDg3PbXYqMAIOZY3MYJzgZbbDsYpbz/oHWJk4mA8xCjBwawkwtsSHpEgxJuSWFmVWpQf
        X1Sak1p8iLEK6OGJzFKiyfnAbJRXEm9oZmBkZmpsYmxsamJKtrCpkZmZgaWphamZkYWSOG+x
        wYN4IYH0xJLU7NTUgtQimOVMHJxSDUxyNWtvCk3WNFS1y1X7EejGrnEwoeaW1LSou7kl/swf
        t+fXB/eynQiPPepcmnfg2vf9x3eb2W50KljFs3J/2M2wUl6P5er156fNzL/783ucxpyWOx0b
        Gr0CJWVv88Zn3zmpGVL9VMjE7YsMO2elc9qRsOXWs7vZ2R3Ofjwy2dirtuhop3TLlX1J5ndb
        tMLlt0W8qXHe/+/h9+5jXVppJaHFiYeOz/SRjj73pPzwzO+cAr/PnK3nexMS0WYrceLf4fDk
        cEZ+gTt+lWlOrIwalmvZXZWd/hhyfWxUXvafZWHHwk+KTT4bOp/e/3C8oz/+cd/fN1tqL58r
        /L7wlZjJ8zpRIZO16911Uo5tbiu+rsRSnJFoqMVcVJwIACWzs0LTBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860
References: <75df140d2167eadf1089d014f571d711a9aeb6a5.camel@gmail.com>
        <20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p5>
        <20210322065410epcms2p431f73262f508e9e3e16bd4995db56a4b@epcms2p4>
        <CGME20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

>On Mon, 2021-03-22 at 15:54 +0900, Daejun Park wrote:
>> +       switch (rsp_field->hpb_op) =7B
>>=20
>> +       case HPB_RSP_REQ_REGION_UPDATE:
>>=20
>> +               if (data_seg_len =21=3D DEV_DATA_SEG_LEN)
>>=20
>> +                       dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>=20
>> +                                =22%s: data seg length is not
>> same.=5Cn=22,
>>=20
>> +                                __func__);
>>=20
>> +               ufshpb_rsp_req_region_update(hpb, rsp_field);
>>=20
>> +               break;
>>=20
>> +       case HPB_RSP_DEV_RESET:
>>=20
>> +               dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>=20
>> +                        =22UFS device lost HPB information during
>> PM.=5Cn=22);
>>=20
>> +               break;
>=20
>Hi Deajun,
>This series looks good to me. Just here I have one question. You didn't

Thanks.

>handle HPB_RSP_DEV_RESET, just a warning.  Based on your SS UFS, how to
>handle HPB_RSP_DEV_RESET from the host side? Do you think we shoud
>reset host side HPB entry as well or what else?

In the JEDEC HPB spec, it as follows:

When the device is powered off by the host, the device may restore L2P map
data upon power up or build from the host=E2=80=99s=20HPB=20READ=20command.=
=0D=0A=0D=0ASo=20I=20think=20there=20is=20nothing=20to=20do,=20because=20UF=
S=20can=20build=20from=20host's=0D=0Acommand.=20Moreover,=20in=20the=20case=
=20of=20the=20HPB=20read=20with=20invalid=20information=20by=0D=0Adev=20res=
et,=20it=20just=20processed=20as=20normal=20read.=0D=0A=0D=0AThanks,=0D=0AD=
aejun=0D=0A>=20=0D=0A>=20=0D=0A>Bean=0D=0A>=20=0D=0A>=20=0D=0A>=20=0D=0A>=
=20=20
