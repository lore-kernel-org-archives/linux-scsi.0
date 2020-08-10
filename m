Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6231EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E5D2073A
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:06:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WvIJeMdx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgHJGGJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 02:06:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19129 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgHJGGH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 02:06:07 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200810060603epoutp043fe031626408f51e1cae8bf2327f10d5~p0wWLUzK02211922119epoutp04x
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2020 06:06:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200810060603epoutp043fe031626408f51e1cae8bf2327f10d5~p0wWLUzK02211922119epoutp04x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1597039563;
        bh=Y9L9KK+eQvKvTfNmlkU0/mLLhVSaiH7PAJjNJPSROcU=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=WvIJeMdxTgzJ7dEEkL1PHQ6AZYq98i5yVeYGlCx3dx8nT8UHGYKkkys052xPb27P8
         WjwZac31seDRfCgaHGuCTMrgK8b+RUGQTJjfegad/SoBfdgcxffUKr7j95SITs+RWU
         bqohV+lIYgStaaq/h3BkCkmIQbhuEtMRCRx1YEv0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200810060602epcas2p2703f010b22b3aec700a5c5402598a831~p0wViFDz00326603266epcas2p2C;
        Mon, 10 Aug 2020 06:06:02 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BQ57C6cPLzMqYkr; Mon, 10 Aug
        2020 06:05:59 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        FC.25.27441.7C3E03F5; Mon, 10 Aug 2020 15:05:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200810060559epcas2p1d6e8c7138602392da33cb00d1a1d8b3f~p0wSRuN0N2108421084epcas2p1Q;
        Mon, 10 Aug 2020 06:05:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200810060559epsmtrp2ff78d543095e4409d1bee7a61606e406~p0wSQxSpW1487014870epsmtrp2f;
        Mon, 10 Aug 2020 06:05:59 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-db-5f30e3c71b87
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.EC.08382.7C3E03F5; Mon, 10 Aug 2020 15:05:59 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200810060559epsmtip292b47e31e7fd3ced7434ea62b0ea12cf~p0wR-12Ny1054010540epsmtip2q;
        Mon, 10 Aug 2020 06:05:59 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <SN6PR04MB4640CCC89B4DE5F019145933FC470@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v1] ufs: change the way to complete fDeviceInit
Date:   Mon, 10 Aug 2020 15:05:58 +0900
Message-ID: <000c01d66edc$51757140$f46053c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQImCQ60VTggvVQVQny26bydLLCX8AGQ/QSvApaX4NWocGm+gA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmhe7xxwbxBn+6TCwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEZVjk5Ga
        mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0spJCWWJOKVAo
        ILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwNCwQK84Mbe4NC9dLzk/18rQwMDIFKgyISfj91mz
        ggOSFX/P3WRsYHwp0MXIySEhYCKxcNFJ5i5GLg4hgR2MEusOTWSEcD4xSjReX80E4XxjlFh8
        9RwrTMurE2uZQGwhgb2MEmcaOSGKXjBKLG1fwg6SYBPQlpj2cDcrSEJE4D6TxJGdD1hAEpwC
        sRLrzm0HmyQs4Cwx++QlsEksAqoSnb/mgtm8ApYSV27sZYWwBSVOznwC1ssMNHTZwtfMEFco
        SPx8ugysRkTASeL8uomsEDUiErM726BqTnBI/DtWDGG7SMz/f5QRwhaWeHV8CzuELSXx+d1e
        Ngi7XmLf1AawoyUEehglnu77B9VgLDHrWTuQzQG0QFNi/S59EFNCQFniyC2o0/gkOg7/ZYcI
        80p0tAlBNCpL/Jo0GWqIpMTMm3egtnpItL76yz6BUXEWkidnIXlyFpJnZiHsXcDIsopRLLWg
        ODc9tdiowBg5rjcxglOzlvsOxhlvP+gdYmTiYDzEKMHBrCTCa3dXP16INyWxsiq1KD++qDQn
        tfgQoykw2CcyS4km5wOzQ15JvKGpkZmZgaWphamZkYWSOG+x1YU4IYH0xJLU7NTUgtQimD4m
        Dk6pBibRP8LaMbcOSvV+ORR8dcon95nHv66Z9efD0n/vwvvZLqWtf+j959ul/KPGrI9C1rek
        hfTaN7oFO9oIPT9oeFOpe4XRTcPwwuclxkcldRJD+R2edNWfWRPBL6u1aqO1c9ThLXvr1NY9
        v1L0+Mef0vf3Vx9Yy8Zw6En7vDNzGw94qDUrzdijcUyxKoHTriQsQk/27uGCDR4uLo9D3Rs3
        T7YLm5u8dNsbecvjz9eLWi1wndweW7lNscHa2uWv5JF5d6OnKu7YcVTg/KfUotlbNh6c9zBV
        40B0Rt/GKPGJuo1ll/2q3y9/FDtz0t7IDQnOrL9qpKSu/kjjC7x4WLBur98P+XT5j+JpCtuX
        eTsrva5RYinOSDTUYi4qTgQAc/78GFYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSvO7xxwbxBtd6hS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEcVlk5Ka
        k1mWWqRvl8CVsebdf7aCfxIVj0/sYmxgXC7QxcjJISFgIvHqxFqmLkYuDiGB3YwSx+dvZIRI
        SEqc2PkcyhaWuN9yhBWi6BmjRNeWOWAJNgFtiWkPd4MlRATeMkncuX0ZatRLRolFR0+zgFRx
        CsRKrDu3nRXEFhZwlph98hITiM0ioCrR+WsumM0rYClx5cZeVghbUOLkzCdgvcxAG3oftjLC
        2MsWvmaGOElB4ufTZWD1IgJOEufXTWSFqBGRmN3ZxjyBUWgWklGzkIyahWTULCQtCxhZVjFK
        phYU56bnFhsWGOallusVJ+YWl+al6yXn525iBMekluYOxu2rPugdYmTiYDzEKMHBrCTCa3dX
        P16INyWxsiq1KD++qDQntfgQozQHi5I4743ChXFCAumJJanZqakFqUUwWSYOTqkGJq4rXxOY
        2ng/TFgpssLSS2/XvGmce5xfLAur1pu0RpSX1XjXisN32zuOym88ZDMjVzUhcGWKgOHVqskZ
        384k7Hxzq2TZhYU3zKamnu7NWCTrayj2/dqiGxevfsxczRpqyrBMcnfGnqDD7Y1JcclTz9kb
        Tcpb5fpPUPyRp2/yDu3Cs1df7tRUZtn2bpW4j3jug29nw9bebr/WpvfsXLWlZs7vRsaLZ4V/
        zwtfcPTl6ZLsRYdmTMyTDWI+cvaDttBjKeU5FU9Dijhn+Odq/Jmu6tGhe1Z/3QnOVbdfl37s
        LFl0VOr07+7JdZVyv0NXZGmJnfr40qvQqvm5RGaAJaeLm8NtrUlTvfmVqjYb7Gti6FNiKc5I
        NNRiLipOBAACI3NxOAMAAA==
X-CMS-MailID: 20200810060559epcas2p1d6e8c7138602392da33cb00d1a1d8b3f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200807070119epcas2p198639f0b065c97baf2b9bae231ec137b
References: <CGME20200807070119epcas2p198639f0b065c97baf2b9bae231ec137b@epcas2p1.samsung.com>
        <1596783176-183741-1-git-send-email-kwmad.kim@samsung.com>
        <SN6PR04MB4640CCC89B4DE5F019145933FC470@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Currently, UFS driver checks if fDeviceInit is cleared at several
> > times, not period. This patch is to wait its completion with the
> > period, not retrying.
> > Many device vendors usually provides the specification on it with just
> > period, not a combination of a number of retrying and period. So it
> > could be proper to regard to the information coming from device
> > vendors.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim=40samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c =7C 31 +++++++++++++++++++------------
> >  1 file changed, 19 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 092480a..c508931 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > =40=40 -4148,7 +4148,8 =40=40 EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode)=
;
> >   */
> >  static int ufshcd_complete_dev_init(struct ufs_hba *hba)  =7B
> > -       int i;
> > +       u32 dev_init_compl_in_ms =3D 1500;
> Please make the threshold a define.  Otherwise, your code looks fine.
> Recently we started to introduce the use of ktime convention and operator=
s
> for such use cases.
> Would you consider using it as well?
>=20
> Thanks,
> Avri
Got it

Thanks.
Kiwoong Kim
>=20
> > +       unsigned long timeout;
> >         int err;
> >         bool flag_res =3D true;
> >
> > =40=40 -4161,20 +4162,26 =40=40 static int ufshcd_complete_dev_init(str=
uct
> > ufs_hba
> > *hba)
> >                 goto out;
> >         =7D
> >
> > -       /* poll for max. 1000 iterations for fDeviceInit flag to clear =
*/
> > -       for (i =3D 0; i < 1000 && =21err && flag_res; i++)
> > -               err =3D ufshcd_query_flag_retry(hba,
> > UPIU_QUERY_OPCODE_READ_FLAG,
> > -                       QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
> > +       /* Poll fDeviceInit flag to be cleared */
> > +       timeout =3D jiffies + msecs_to_jiffies(dev_init_compl_in_ms);
> > +       do =7B
> > +               err =3D ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_F=
LAG,
> > +                                       QUERY_FLAG_IDN_FDEVICEINIT, 0, =
&flag_res);
> > +               if (=21flag_res)
> > +                       break;
> > +               usleep_range(5000, 10000);
> > +       =7D while (time_before(jiffies, timeout));
> >
> > -       if (err)
> > +       if (err) =7B
> >                 dev_err(hba->dev,
> > -                       =22%s reading fDeviceInit flag failed with erro=
r %d=5Cn=22,
> > -                       __func__, err);
> > -       else if (flag_res)
> > +                               =22%s reading fDeviceInit flag failed w=
ith
> error %d=5Cn=22,
> > +                               __func__, err);
> > +       =7D else if (flag_res) =7B
> >                 dev_err(hba->dev,
> > -                       =22%s fDeviceInit was not cleared by the device=
=5Cn=22,
> > -                       __func__);
> > -
> > +                               =22%s fDeviceInit was not cleared by th=
e
> device=5Cn=22,
> > +                               __func__);
> > +               err =3D -EBUSY;
> > +       =7D
> >  out:
> >         return err;
> >  =7D
> > --
> > 2.7.4

