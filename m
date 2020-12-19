Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB4FC4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 02:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C16A23BB5
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 02:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgLSC4A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 21:56:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12723 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgLSCz7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 21:55:59 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201219025516epoutp029066dc75f1c713ccd99c8e390b833213~R-qKh3Tzn2031520315epoutp02y
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 02:55:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201219025516epoutp029066dc75f1c713ccd99c8e390b833213~R-qKh3Tzn2031520315epoutp02y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608346516;
        bh=Yua3vSUatIANspjD6Z+sa9HaBd9uyCEGeh+e8yxri1A=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=IKabyVUexGeig9G5KuRyMps8MA5wMpZSrRMDfcsH5+1J6uBBB8GRlCXbmcpqXPK7m
         5q+seOUJhguUS+82VfzP+ZnQcuIel/Y/P566Yqg9NccIDN06olmZdD5SaJJXFX84D4
         bvFbLzCPgoebgSeiqNPu+P8XrvZukTbeNk/qWa0U=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201219025515epcas2p2ad0b969934d0b5f4ad88f5916998a2c0~R-qKGSMhs2681526815epcas2p2D;
        Sat, 19 Dec 2020 02:55:15 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4CyVhd0V73zMqYkY; Sat, 19 Dec
        2020 02:55:13 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        8A.36.52511.09B6DDF5; Sat, 19 Dec 2020 11:55:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20201219025511epcas2p1852c452447f2f525e2b6fa2fee49a4b2~R-qGW_8R91212112121epcas2p1q;
        Sat, 19 Dec 2020 02:55:11 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201219025511epsmtrp2e27d506c1d25896b4e3f31d0b3a3a930~R-qGWXt5U3094930949epsmtrp2N;
        Sat, 19 Dec 2020 02:55:11 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-26-5fdd6b904062
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.D4.13470.F8B6DDF5; Sat, 19 Dec 2020 11:55:11 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201219025511epsmtip2c8a23c8b82489e945225da54686baa42~R-qGI9ePd3075130751epsmtip2J;
        Sat, 19 Dec 2020 02:55:11 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <linux-scsi@vger.kernel.org>
In-Reply-To: <DM6PR04MB65754CF9B01B346840FF98A2FCC30@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v1 0/2] permit vendor specific timeouts for PMC
Date:   Sat, 19 Dec 2020 11:55:11 +0900
Message-ID: <003701d6d5b2$5e51c340$1af549c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFiMmxnDaundZ2X3VLN7B1rjjoWDAOO/xRKAhWrwviqudokoA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsWy7bCmqe6E7LvxBsu6NC1e/rzKZtF9fQeb
        A5PH501yHu0HupkCmKJybDJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1Nt
        lVx8AnTdMnOAxisplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCgwNC/SKE3OLS/PS
        9ZLzc60MDQyMTIEqE3IyLn9ex1hwgaNi+fd+5gbGq2xdjJwcEgImEhN6DrCA2EICOxgl1jyJ
        62LkArI/MUo8e/uQEcL5xijxe3MvUxcjB1jHvX+8EPG9jBJH/i6CKnrBKNF9eiPYKDYBbYlp
        D3ezgtgiAu4S/75eZQaxOQViJb49/A9WIwwUn3mqHyzOIqAqce/YG7CTeAUsJdZf/MUIYQtK
        nJz5BKyeGWjmsoWvmSHOVpD4+XQZ1HwniZs3u5ghakQkZne2MYMcJCFwjF1i7/MFUH+6SOy8
        8B6qWVji1fEt7BC2lMTnd3uhauol9k1tYIVo7mGUeLrvHyNEwlhi1rN2RpD3mQU0Jdbv0oeE
        hLLEkVtQt/FJdBz+yw4R5pXoaBOCaFSW+DVpMtQQSYmZN+9AbfWQ+PL+PesERsVZSL6cheTL
        WUi+mYWwdwEjyypGsdSC4tz01GKjAhPkuN7ECE55Wh47GGe//aB3iJGJg/EQowQHs5IIb+iD
        2/FCvCmJlVWpRfnxRaU5qcWHGE2B4T6RWUo0OR+YdPNK4g1NjczMDCxNLUzNjCyUxHlDV/bF
        CwmkJ5akZqemFqQWwfQxcXBKNTDNc+ua6bn5ScgtpY/iF42e3TWcvld4YU7OnukcYSsfWpU4
        GksHS254/epsGMfR4JoJGz2jp5fMY1a8fltRf3Fqk6XOkX0McrM0eKTu6wdHmi/dvOpc26Ef
        W3hV5Cf55LrvtTQ6y1CpPfFD7fJ9Qdeq1gX/iLjy5FinxLVAbzHbZ/sW3LkXdDpllUHwo4Nn
        ble+sa37eXPyD7ebmgZb/n9usFJ+aLolKzAlZdemuSWXXEWP7I411n7x5s9V2zvzZFZc9frd
        HWIiMIe9W0r7y7cXE8XKbSbbCAq23ms5/sTxsK3AK6WpFTGbxZfJ60p0PTYU2W+6o3veiwsu
        Gv/YNjN/urZqgeP7YyZnjqpvFfrQqMRSnJFoqMVcVJwIAD4BBIcCBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSvG5/9t14g00N+hYvf15ls+i+voPN
        gcnj8yY5j/YD3UwBTFFcNimpOZllqUX6dglcGQvO9jMXXOSouHh/EXsD4wW2LkYODgkBE4l7
        /3i7GLk4hAR2M0rM3vyZsYuREyguKXFi53MoW1jifssRVoiiZ4wSBw4eAkuwCWhLTHu4mxXE
        FhHwlHiwaBcLRNFtRonO1f3MIAlOgViJbw//s4DYwgLuEjNPQcRZBFQl7h17wwZi8wpYSqy/
        +IsRwhaUODnzCVg9M9CC3oetjDD2soWvmSEuUpD4+XQZ1GIniZs3u5ghakQkZne2MU9gFJqF
        ZNQsJKNmIRk1C0nLAkaWVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwWGupbmDcfuq
        D3qHGJk4GA8xSnAwK4nwhj64HS/Em5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs
        1NSC1CKYLBMHp1QDU9xh+5pbu6fW6b9KnNHbt9XIS/H3hXlfi/TfbV67e06EjgO7S0rHzlPc
        e/OUXwfv3Vp8/tnFg82S2+xzZ8Sn/bCcH8lnkXbJwmOXocCkdfMWfrqkeXLzksWmvpEsHspL
        a01FU6qv6HttnxZ9MaqRq97X1uhhT1CQ6uOVspaHzVT/C6QU2HJeE9dhCFJL54tzUG55Xmz+
        oePcj1dr7y/gyy2osOTYtuCg5/WLUozbi3KiRQ54ydZpTDzyi9H/4taTWmp12a6BXcmCuZ/P
        KW94y7f2xZ4NUoFlnbFTOidO0DwU1XTQ+d2XIxefs0cs+ruH72LY+k0Htuy7p7fivZ1ocPTC
        6zmOqhZBC1TuVs1ZpcRSnJFoqMVcVJwIAM/x71DiAgAA
X-CMS-MailID: 20201219025511epcas2p1852c452447f2f525e2b6fa2fee49a4b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201218074142epcas2p4c5f276e54ff896b8e990303376a15154
References: <CGME20201218074142epcas2p4c5f276e54ff896b8e990303376a15154@epcas2p4.samsung.com>
        <cover.1608276380.git.kwmad.kim@samsung.com>
        <DM6PR04MB65754CF9B01B346840FF98A2FCC30@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > There are some attribute settings before power mode change in ufshcd.c
> > that should be variant per vendor.
> But you've added a quirk, which is not what your commit log say.
> If indeed unipro allows to skip/set values other than default - add the
> appropriate vop.
> Otherwise, if it's just a non-standard behavior of exynos - then your
> patch is appropriate, But you need to reword your commit log: both here
> and in your 1/2 patch.
>=20
> Also, you forgot to remove the gerrit change-id.
>=20
> Thanks,
> Avri

You're right and for change-id, there might be something wrong in my local =
branch.
Anyway thanks =21


Thanks.
Kiwoong Kim

> >
> > Kiwoong Kim (2):
> >   ufs: add a quirk for vendor specifics before pmc
> >   ufs: ufs-exynos: apply vendor specifics for three timeouts
> >
> >  drivers/scsi/ufs/ufs-exynos.c =7C  8 +++++++-
> >  drivers/scsi/ufs/ufshcd.c     =7C 40 +++++++++++++++++++++------------=
----
> ---
> >  drivers/scsi/ufs/ufshcd.h     =7C  6 ++++++
> >  3 files changed, 34 insertions(+), 20 deletions(-)
> >
> > --
> > 2.7.4


