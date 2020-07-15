Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110A1C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 08:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2AB420936
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 08:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SvshDLgy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgGOIKG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 04:10:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44881 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727871AbgGOIKE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 04:10:04 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200715081001epoutp017148b09960b57c9f619460e95cbfb32e~h3rKI_QXw2778327783epoutp01i
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 08:10:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200715081001epoutp017148b09960b57c9f619460e95cbfb32e~h3rKI_QXw2778327783epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594800601;
        bh=Bd3G0GecD7yF+wJXC0OW6GCJUv0k+fkChRRrKxDYycE=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=SvshDLgydzSAjJNj/eYp8L7WVG3gREjD/L0LtyekP10E/m9nmPgCF7iW9sUYgqXjv
         FD1crvpcGXz8C2NwF4/v+a79UiUOCIr+pxobM9L8uhqQI1ESbNr8JMmQi1Y8RLsKGM
         mqpmJPRdjRJmAGVPBE2BJTwV1TaHgKOwNPep4zxM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200715081000epcas2p1a4bc532700c4641f508ab7fd005fd76a~h3rJesS9E1536915369epcas2p1I;
        Wed, 15 Jul 2020 08:10:00 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B696F476YzMqYkj; Wed, 15 Jul
        2020 08:09:57 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        F0.67.27013.5D9BE0F5; Wed, 15 Jul 2020 17:09:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200715080956epcas2p34e2bb44abbfe8dfb7dfcc3325bdc78fb~h3rFtDrU61446014460epcas2p37;
        Wed, 15 Jul 2020 08:09:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200715080956epsmtrp1e214ed1ed881a0ab1d373bda06eaa3db~h3rFsUwVj3077630776epsmtrp1m;
        Wed, 15 Jul 2020 08:09:56 +0000 (GMT)
X-AuditID: b6c32a48-d35ff70000006985-44-5f0eb9d59237
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.3A.08303.4D9BE0F5; Wed, 15 Jul 2020 17:09:56 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200715080956epsmtip15e563ce8c43b7db5e99989726dc9cade~h3rFbs1rv0726707267epsmtip1Y;
        Wed, 15 Jul 2020 08:09:56 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <SN6PR04MB46407E21E411B7E785C3B3C1FC680@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v3 2/2] ufs: change the way to complete fDeviceInit
Date:   Wed, 15 Jul 2020 17:09:56 +0900
Message-ID: <01f501d65a7f$53aab090$fb0011b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHu1pDNEI1WArg19xfehYJkuPyuggIodicAAU/VsrgCNqJMqaip2GAA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmme7VnXzxBme2slo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MFl13bzBa
        LP33lsWB1+PyFW+Py329TB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAIyrHJiM1
        MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoZCWFssScUqBQ
        QGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgaFhgV5xYm5xaV66XnJ+rpWhgYGRKVBlQk7Giekn
        mAr2y1Qs29bK2MA4QbSLkZNDQsBEYsrE66xdjFwcQgI7GCUuzG5hh3A+MUpsvfSaDcL5zChx
        5vpbRpiWH3PfMUEkdgElTvxjAkkICbxglPj6Tw7EZhPQlpj2cDfYXBGB+0wSR3Y+YOli5ODg
        FIiVeDFBAKRGWMBb4lPnVVYQm0VAVWLtvG4WEJtXwFJiz6lPjBC2oMTJmU/A4sxAM5ctfM0M
        cYSCxM+ny8B6RQTcJGZdgogzC4hIzO5sg6o5wSGxfxo/hO0icXHbJ1YIW1ji1fEt7BC2lMTL
        /jYou15i39QGsJslBHoYJZ7u+wf1sbHErGftjCD3MwtoSqzfpQ9iSggoSxy5BXUan0TH4b/s
        EGFeiY42IYhGZYlfkyZDDZGUmHnzDtQmD4nDN7ezTmBUnIXkyVlInpyF5JlZCHsXMLKsYhRL
        LSjOTU8tNiowQY7rTYzg1KzlsYNx9tsPeocYmTgYDzFKcDArifDycPHGC/GmJFZWpRblxxeV
        5qQWH2I0BQb7RGYp0eR8YHbIK4k3NDUyMzOwNLUwNTOyUBLnfWd1IU5IID2xJDU7NbUgtQim
        j4mDU6qBKe/u1LWP2k58rHjBE9fbph57UcfyibloBn9uwCGRI1OW2saZzj5rKbZMqWX3Et2z
        hevP7rHdbS7M4f1s2v/ISEb5fadjJBjPTlv0+Iuyn0R8Z8ipelMjiZDJ8d/2Cfju4H24putT
        R6c8O3uNmaNPmU/0U9Xv0sFH94ntZ7L05+lsEeFXZ1GZ4rV6Dt9dnfWt5m2uVfaS/458F41b
        ual7rhLn7IW6gknzmy+tiNKXfrKp5dFWsZUC3BpxkYdm95W+P/9z+n1ujys7mje71UgwOjNe
        XGd7rHSfr7xQW5ydB+/xkgZdN7E953aLP/t04RD3oqJDr3UWCL+6plmXocjiPvNW9NFXj3dZ
        bvhtGSmsxFKckWioxVxUnAgA/f01ylYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSnO6VnXzxBpMnqlo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MFl13bzBa
        LP33lsWB1+PyFW+Py329TB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoEr4+LimWwFrTIVt7YfYWpgvCTSxcjJISFgIvFj7jsmEFtIYAejxOdbfhBxSYkT
        O58zQtjCEvdbjrB2MXIB1TxjlPh7cBtYA5uAtsS0h7vBEiICb5kk7ty+zARRtZpJ4l/bcfYu
        Rg4OToFYiRcTBEAahAW8JT51XmUFsVkEVCXWzutmAbF5BSwl9pz6xAhhC0qcnPkELM4MtKD3
        YSsjjL1s4WtmiIsUJH4+XQY2R0TATWLWJYg4s4CIxOzONuYJjEKzkIyahWTULCSjZiFpWcDI
        sopRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzgetbR2MO5Z9UHvECMTB+MhRgkOZiUR
        Xh4u3ngh3pTEyqrUovz4otKc1OJDjNIcLErivF9nLYwTEkhPLEnNTk0tSC2CyTJxcEo1MK1g
        vJru9UYxi+lrpc9ddd1MFoMD99jXMUT5iFXKPrkjfzkp/rQL/6578hHuMkli1hNV/7xSSDqy
        7qDDDQ+TNycP9i7iyeb6/K1Iae4x3691D3x9Jy549ZvJbs+VF8orDZdHimw7svnid9ftRfbV
        0X2Xvq279lHmyOWquXLR/u2nDzzS60rcx1ik4JCzYFtG65QDHizBVofu1K1L3tVQHyHZYreh
        4k7ZNhmDv9NlOKb3smR4Cihv2Me/4g/f1rp5EhZWBtmF9yfdUj/w6OMpYaXlV63jGnpzBYU6
        +O/096sZc05zsTpl7iC9n+PGrR9zpKo1me4tV3n+9fZ8wa2nZPvz37tvVpat/DtNPmCmrhJL
        cUaioRZzUXEiAIiYPtc2AwAA
X-CMS-MailID: 20200715080956epcas2p34e2bb44abbfe8dfb7dfcc3325bdc78fb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053757epcas2p3416b0a10e4419015da549a9c4bfbf37f
References: <cover.1593753896.git.kwmad.kim@samsung.com>
        <CGME20200703053757epcas2p3416b0a10e4419015da549a9c4bfbf37f@epcas2p3.samsung.com>
        <08bc1641fdce941175596fe106fd5c02161683bf.1593753896.git.kwmad.kim@samsung.com>
        <SN6PR04MB46407E21E411B7E785C3B3C1FC680@SN6PR04MB4640.namprd04.prod.outlook.com>
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
> > I first added one device specific value regarding the information.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim=40samsung.com>
> I still think that this patch alone is fine, and you don't need its
> predecessor.
> The spec requires polling, so this is a form of a more-effective-polling:
> so be it.

If what you're mentioning 'effective' means being able to just wait for
some long time upon completion of being cleared, it's not proper in real
products because fDeviceInit latency usually has the biggest overhead of
steps run during boot and some companies often try to manage its latency
as KPI. The method like a combination of retrying and small delay make them
harder to make it.
Or if I understand what you meant, please let me know.

>=20
>=20
> > ---
> >  drivers/scsi/ufs/ufshcd.c =7C 36 ++++++++++++++++++++++++------------
> >  1 file changed, 24 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index b26f182..6c08ed2 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > =40=40 -208,6 +208,7 =40=40 static struct ufs_dev_fix ufs_fixups=5B=5D =
=3D =7B  =7D;
> >
> >  static const struct ufs_dev_value ufs_dev_values=5B=5D =3D =7B
> > +       =7BUFS_VENDOR_TOSHIBA, UFS_ANY_MODEL, DEV_VAL_FDEVICEINIT, 2000=
,
> > false=7D,
> >         =7B0, 0, 0, 0, false=7D,
> >  =7D;
> >
> > =40=40 -4162,9 +4163,12 =40=40 EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode=
);
> >   */
> >  static int ufshcd_complete_dev_init(struct ufs_hba *hba)  =7B
> > -       int i;
> > +       u32 dev_init_compl_in_ms =3D 1000;
> > +       unsigned long timeout;
> >         int err;
> >         bool flag_res =3D true;
> > +       bool is_dev_val;
> > +       u32 val;
> >
> >         err =3D ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG=
,
> >                 QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL); =40=40 -4175,20
> > +4179,28 =40=40 static int ufshcd_complete_dev_init(struct ufs_hba *hba=
)
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
> > +       is_dev_val =3D ufs_get_dev_specific_value(hba,
> > + DEV_VAL_FDEVICEINIT,
> > &val);
> > +       dev_init_compl_in_ms =3D (is_dev_val) ? val : 500;
> If you want dev_init_compl_in_ms to take its default 1,000, you should:
> dev_init_compl_in_ms =3D (=21is_dev_val) ? : val;
Got it.

>=20
> > +       timeout =3D jiffies + msecs_to_jiffies(dev_init_compl_in_ms);
> > +       do =7B
> > +               err =3D ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_F=
LAG,
> > +                                       QUERY_FLAG_IDN_FDEVICEINIT, 0, =
&flag_res);
> > +               if (=21flag_res)
> > +                       break;
> > +               usleep_range(5, 10);
> Per Grant's comment:
> usleep_range(5000, 10000);=20
Got it.

Thanks.
Kiwoong Kim

