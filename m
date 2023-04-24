Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C266BC77B7E
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Apr 2023 09:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjDXJau (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Apr 2023 05:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDXJar (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2023 05:30:47 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F3C1B9
        for <linux-scsi@vger.kernel.org>; Mon, 24 Apr 2023 02:30:45 -0700 (PDT)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230424093040epoutp0328ad40aa8ba74bcc2952d0b69e73955d~Y1PxAg7h-0432704327epoutp03W
        for <linux-scsi@vger.kernel.org>; Mon, 24 Apr 2023 09:30:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230424093040epoutp0328ad40aa8ba74bcc2952d0b69e73955d~Y1PxAg7h-0432704327epoutp03W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682328640;
        bh=5FBqK6KqrQlHJa+cIoHnvXCxj8PXUigt+MYbM0kM3/E=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=XJhjyZeVPARf+CVdmYmaf1M1QzKl1ivg/7RO59pT8pAdY0hAabcRuUfmLuhVMvvWh
         Rq2SQBsA7vb8vqLnXOyh8FzmT2TqdBk6vr3+I4noyX+TeNoYmBg2oLKKTTLsQCIhVT
         vqday939uArlbShwKInuZux1Xho9BKTecIMa5vBs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20230424093040epcas2p31651c23b998d6d989d0cda7085af32e6~Y1Pw0VnoI2945329453epcas2p3k;
        Mon, 24 Apr 2023 09:30:40 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.68]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Q4fxq5MvJz4x9Q5; Mon, 24 Apr
        2023 09:30:39 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.4A.22936.F3C46446; Mon, 24 Apr 2023 18:30:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20230424093039epcas2p2c34cdd6eb7105405d5d8d2a1a0f8c8e4~Y1Pvo6VDG0674606746epcas2p2A;
        Mon, 24 Apr 2023 09:30:39 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230424093039epsmtrp26c7eb12ee103b487ff33967643d99306~Y1PvoXQ3_2241822418epsmtrp2j;
        Mon, 24 Apr 2023 09:30:39 +0000 (GMT)
X-AuditID: b6c32a48-6d3fa70000005998-00-64464c3fceb5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BB.82.28392.A3C46446; Mon, 24 Apr 2023 18:30:34 +0900 (KST)
Received: from KORCO011456 (unknown [10.229.38.105]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230424093034epsmtip1bef02f30877165ad1d83176737b949a7~Y1PrOtA361010810108epsmtip1S;
        Mon, 24 Apr 2023 09:30:34 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <linux-scsi@vger.kernel.org>
In-Reply-To: <DM6PR04MB6575372C3F82509E9AE69466FC679@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v1] ufs: poll pmc until another pa request is
 completed
Date:   Mon, 24 Apr 2023 18:30:34 +0900
Message-ID: <003501d9768f$6bd06280$43712780$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJP9gJUoCjR96O/MrSEsAj5GtwPhAHiSdtdAqjpsnYCxZ6HCwKaINhtAXRO82mt8jePMA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmqa69j1uKwdyzGhYvf15ls+i+voPN
        gcnj8yY5j/YD3UwBTFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2
        Si4+AbpumTlA45UUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BeYFesWJucWleel6
        eaklVoYGBkamQIUJ2RndN40LPghU9Oy+wNbA+IGvi5GTQ0LAROLqlkPsXYxcHEICOxglWm78
        g3I+MUosO3OfEcL5zCix8OULZpiWYzdPMEMkdjFKnL26hgXCecko8WPrOVaQKjYBbYlpD3eD
        2SIC7hL/vl4F6+YUiJXY8OoHG4gtLBAo8e3lI3YQm0VAVeLWn3tgNq+ApcTy7V+ZIWxBiZMz
        n7CA2MxAM5ctfA11hYLEz6fLoOaHSbz7eYYJokZEYnZnG9h1EgKn2CX2PpzDAtHgIjF55X52
        CFtY4tXxLVC2lMTnd3uBDuIAsrMl9iwUgwhXSCye9haq1Vhi1rN2RpASZgFNifW79CGqlSWO
        3IK6jE+i4/Bfdogwr0RHmxBEo7LEr0mTGSFsSYmZN+9A7fSQuDPvDfMERsVZSH6cheTHWUh+
        mYWwdwEjyypGsdSC4tz01GKjAhN4VCfn525iBKc7LY8djLPfftA7xMjEwXiIUYKDWUmE16PU
        KUWINyWxsiq1KD++qDQntfgQoykw1CcyS4km5wMTbl5JvKGJpYGJmZmhuZGpgbmSOO/HDuUU
        IYH0xJLU7NTUgtQimD4mDk6pBqa5y9eKKTxU3vh7vqDx3cYIKTnTJdo5y7o1F9Tffnd+d+TT
        TKFn71zrf/xzZ38e7e7XsnxaHU+jRM2F2RobWfQvxzq2nH5t9PPkuR1vCkoXd8RNd7yw7frX
        qXcMeX9/Oebl8HjqMeaUYwU8uj6mU/40HJ70mlf4cc9O9rWtJydO0xK2bg+7leUQ2Tg1fp7/
        plmh5yNu2W+wWnmGb+vSsku5sk0lb46UK2mz7C1uUgkpvRy77FDIfV6Wvb80dzY8ebq3ppnf
        9uPbnx9uGsaxRbarzy/gOMj5YKvPz/1i3Y066zMtUx9wu8T7Kd70a/t0J3i5xKItK3LTv9z5
        7tmw0cNHO2ja4me21XGWzhcM//MosRRnJBpqMRcVJwIAKnuTWQAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSnK69j1uKweTVzBYvf15ls+i+voPN
        gcnj8yY5j/YD3UwBTFFcNimpOZllqUX6dglcGZtebmYsmMRXsfXoffYGxv9cXYycHBICJhLH
        bp5g7mLk4hAS2MEosX/7RxaIhKTEiZ3PGSFsYYn7LUdYIYqeM0qc6+5hA0mwCWhLTHu4mxXE
        FhHwlHiwaBcLRNEsZomHqy6AdXMKxEpsePUDqIGDQ1jAX+Le0iqQMIuAqsStP/fYQWxeAUuJ
        5du/MkPYghInZz4BO4IZaH7vw1ZGGHvZwtfMEAcpSPx8ugxqb5jEu59nmCBqRCRmd7YxT2AU
        moVk1Cwko2YhGTULScsCRpZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjBYa6ltYNx
        z6oPeocYmTgYDzFKcDArifB6lDqlCPGmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEk
        NTs1tSC1CCbLxMEp1cB0IXpG428ZvsvrjV8lftScGp6guONPZ9OvZvF1e66KxB3zF2v52381
        RTjD8vJ9IYNfS4t6JgmZNDteYu8yPrCt+kb/kY6vnOxvD+u6Hs17ZqfaHpLyJdNivQvPyqrK
        GEHnFYn6qlG1+p+tNtxec165kEPQ6MHdCfcfrc2rj68/pdPhYm2ZrNpc3vRJ8bZnpVflp9em
        V18mLFP9t3T6/m+fioovdDZ0dOYpX1/XxPMhmXtax5EIvaQZxbLclTZXl36f8/92ss7RyWry
        nzoPM/97Z8TP4nl5asq5W7naR54Ft9Uy2Prsd9yVbqt1Vz/2Zvraixb8L32ffv6iMyNcsYPH
        4ucJriiL35f2Mwl5nVdiKc5INNRiLipOBABI/X2D4gIAAA==
X-CMS-MailID: 20230424093039epcas2p2c34cdd6eb7105405d5d8d2a1a0f8c8e4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230419072745epcas2p47b29940fe7e50d947a29546a8e79abb9
References: <cpgsproxy5@samsung.com; stanley.chu@mediatek.com>
        <CGME20230419072745epcas2p47b29940fe7e50d947a29546a8e79abb9@epcas2p4.samsung.com>
        <1681888769-36587-1-git-send-email-kwmad.kim@samsung.com>
        <DM6PR04MB65758403CC6D31654A98BB43FC669@DM6PR04MB6575.namprd04.prod.outlook.com>
        <004101d97669$97c787e0$c75697a0$@samsung.com>
        <DM6PR04MB6575372C3F82509E9AE69466FC679@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > > Regarding 5.7.12.11 in Unipro v1.8, PA rejects sebsequent requests
> > > > following the first request from upper layer or remote.
> > > > In this situation, PA responds w/ BUSY in cases when they come
> > > > from upper layer and does nothing for the requests. So HCI doesn't
> > > > receive ind, a.k.a. indicator for its requests and an interrupt,
> > > > IS.UPMS isn't generated.
> > > >
> > > > When LINERESET occurs, the error handler issues PMC which is
> > > > recognized as a request for PA. If a host's PA gets or raises
> > > > LINERESET, and a request for PMC, this could be a concurrent
> > > > situation mentioned above. And I found that situation w/ my
> > environment.
> > > Can you please elaborate on how this concurrency can happen?
> > > My understanding is that both line reset indication and uic command
> > > are protected by host_lock?
> >
> > Yes and one thing I have to correct on the clause: 5.7.12.11 ->
> > 5.7.12.1.1
> >
> > And I=E2=80=99m=20talking=20about=20the=20situation=20w/=20some=20reque=
sts=20w/=20PACP.=0D=0A>=20OK.=20Thanks.=0D=0A>=20=0D=0A>=20However,=20Pleas=
e=20note=20that=20Clause=205.7.12.1.1=20=22Concurrency=20Resolution=22=20of=
=0D=0A>=20the=20unipro=20spec,=20is=20dealing=20with=20local-peer=20concurr=
ency.=20Not=202=20concurrent=0D=0A>=20local=20requests.=0D=0A>=20As=20such,=
=20I=20think=20you=20need=20to=20explain=20that=20this=20is=20not=20a=20hos=
t=20issue.=0D=0A>=20=0D=0A>=20Thanks,=0D=0A>=20Avri=0D=0A=0D=0AI=20talked=
=20with=20the=20experts=20on=20this=20again.=20They=20said=20the=20situatio=
n=20also=20includes=20'two=20local=20requests=20case'=0D=0Abecause=20they=
=20see=20'a=20local=20request'=20mentioned=20in=20the=20spec=20could=20be=
=20also=20PA_INIT.req=20form=20the=20local's=20upper=20layer.=0D=0A--=0D=0A=
=22A=20local=20request=20shall=20be=20rejected=20when=20the=20PA=20Layer=20=
is=20processing=20a=20local=20request=20or=20a=20peer=20request=202679=20fr=
om=20the=20peer=20Device.=22=0D=0A=0D=0ACould=20you=20explain=20more=20why=
=20you=20don't=20think=20it's=20the=20case?=0D=0A=0D=0AThanks.=0D=0AKiwoong=
=20Kim=0D=0A=0D=0A
