Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E92C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 09:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC4464FDA
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 09:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhCKJEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 04:04:12 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:13009 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhCKJDt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 04:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615453429; x=1646989429;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AWl26UQozjatNQn8DEcthBc8lMSVN+ULkVZTW7nRUu0=;
  b=OljHudHPVwXuC7EMUJczxruHnfx2IMPT5aJ0A3kacSp2qVQS0Oe2CAmy
   BMaFo+6NeVsU4+nhuikapTs8/4jnQh4fnOuvsLMO+0QToTgiSj28w8+Jr
   tiMSWqEwFjus81PnfZBQOyZc7C/ARCCbo2gu1gskPbXaSVgzUTP9HMNji
   rwFLZUcCl+C/govuVvgJ2La9qRA/FA50fJYM7t4Ft69b+bY32FZSQKD7C
   ihzRAaosl6YfIzLNEMpsI4cQAc//in2trIWKDY0niwyjhjuWgF8eW782P
   Z7hFuPIW0GD5/W+4sMd4HboeBBtjPNtRNms6yJ2XYBJzPR0FxQbdgGDjx
   Q==;
IronPort-SDR: xmo3TX9tTj4PcgC6x/xawHgiPeLYxp7N2D1VtQxm+pRphRDeO3pbFn44TsbhjEIBSzdHq9Lfv1
 G/GdKPuhk71ryr6QUCVezxtLdw2LeoCpFik43GRZyMf1dCSvF3H5WgAd+kEE9IQq/T5muq/owc
 7bPVTnNaUN5ytP/a/2JtITOSJdmsujCo7YGub8Iu6dO2wOgCAh4fejVwankxfN9WKWR5MvOaNu
 9D0C2psNKknVJ8yx+H2efbykIIieX3w0B8JkEHA839JO/01CIMq5j9L5hexeDzX2gX2LFXIwRS
 v0U=
X-IronPort-AV: E=Sophos;i="5.81,239,1610380800"; 
   d="scan'208";a="272586095"
Received: from mail-dm3nam07lp2042.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.42])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2021 17:03:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUoWqe2Ts54QASQDIpncfvrBayIu/GHGekkZ5d/11cA4ZayAOQz2ISYov0pCtcDyhhTUdBEiMdgoV3/joEtvY090MQT2w4Inw5jxyQAzGsEuebP+JTz9UhIQnVQHh83duR7lbCc0BDlhMV3naerK6y2YYofBr92oCD4dZMEiz16uhv6MpwqTrrUuEvqObTeoiTNfwmwhfg4GSizNkiFyc7oy/ptWdBkrWFNH5D4q1YjoZX1XeyIsEjrJLVAT3xQ7bOhX9TMaF7RQ7zck72eJKXzmf7xqKsS/tOMwA6wEO9jqCnNJQPN5nxk6Hbk6OybtCcjtBTZZIQGmhReJ4mhEOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJlhEkiKulqm6QBX/z+L9xWWG30CQ2WjPjWnlpGfDSg=;
 b=RKy751VkjWiY0G9kztHV8+LpRb6rxpegzOrpUwLBT3OkpvHhkBztEgYh0ermjlJ3nclSt8aBsLoB1r+3E71Xzx0fLLbQAG7JaF9e599DRnr3ZkY50qXDUxXVKFeFIon7BYWNseKmBIbnVfROEs0uQQ31OyaA1EeMDGFlm9eNE+ah/lSsDOJ3uNfFISn6D810ZlNGtjwoTWrhQsh9rBcsezXcd6lameoUVtvm9GyncM5/m5E8ght5A/niCaOuyIVDIFeMzyBL5iUGe32wDOCiQXyYOvgm96oAdvjUuCZmQaoPsW0BNVBEhxYOXiAQdlAYf7UwyeUR0bIy0ONYsw7QMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJlhEkiKulqm6QBX/z+L9xWWG30CQ2WjPjWnlpGfDSg=;
 b=yQtpXuNmeWKRJgxog7jaoNu3Rb5e5PubEIW1hc2BOGfKAkpdqpaJ1fMsHPcr7OQ8ghXpGptw2vb19L76oeA63qlVNkvja7M7B/sw5q+UMvw8j/pTeESvDKtY6SC9UOtqgF3CT39v8B9lhxVzxY8WSWbhMyIwlNHmJqMsjNKCkoM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6795.namprd04.prod.outlook.com (2603:10b6:5:24f::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Thu, 11 Mar 2021 09:03:47 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.039; Thu, 11 Mar 2021
 09:03:47 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v5 05/10] scsi: ufshpb: Region inactivation in host mode
Thread-Topic: [PATCH v5 05/10] scsi: ufshpb: Region inactivation in host mode
Thread-Index: AQHXD2erjujwThfcjE6SijSHmiAch6p+gBiAgAALj9A=
Date:   Thu, 11 Mar 2021 09:03:47 +0000
Message-ID: <DM6PR04MB65757E2F546C185A1687CFD4FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-6-avri.altman@wdc.com>
 <8c2b310299c0ca57bfd445cfca87fb28@codeaurora.org>
In-Reply-To: <8c2b310299c0ca57bfd445cfca87fb28@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 21791542-5a9e-482c-34f5-08d8e46c948d
x-ms-traffictypediagnostic: DM6PR04MB6795:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB6795431947D403AAEC52AD46FC909@DM6PR04MB6795.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XXIQQ7AZwlsx2FuAswAAti6hHxwDmJmr7zZnLkRUJeYuOfmd/IENbTByCL3muQmn9A3Cd88ahEpuB+Uj6VkcZL4EGeSwOPovGalI4snfFZFgaI9UKmI6V2KqNoMSzpLbjPKUhatZ0vNhkY8rk3+Eg9r7842drgd6l1ezwgQVhLR6pnozIXvZjnZk8T5uAE+244PYfGlomqxi5rDkfTFQkBpgbwlA1cqoYGdu53VCPWsIcizsf6+wfiQ5T0xMiszeqXnvrKjnCjKmdP56qohQSFye9tYm2YvUApi0zOzJprGhTSBQ+137J1o8pWOBw56lsSa0caTH+p8yx8WXxyNC8LGkrbItwsFvrheCX25msXoMWtHI0OqErvD6opeFoWqyqa0Mzf5Mz958ooFoVoXY0r8zfwo6Ldi36ObjpzQyK6MyqLinXwAPpGP0mrpDeR5ro9tZPtJsh1H67LBXURHJKzttU7HgL7cpSYiuJEPShVLryHQYsyQBEmhBaDX0ScUBWpqhGMYJIZhivChQ9fgTonOjRcLGK1Cge11Fxu3/4wQl+l4JP7faGYji11DQk4Ax
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(9686003)(186003)(26005)(66446008)(64756008)(7696005)(316002)(8936002)(55016002)(86362001)(33656002)(53546011)(6916009)(5660300002)(2906002)(6506007)(478600001)(76116006)(71200400001)(54906003)(8676002)(52536014)(4326008)(7416002)(66946007)(66556008)(66476007)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eQYUn1qSnpyjzMAN2IlYEYVz+PKvTrWO8bkMfbOCWVTc0Gf6OgZbzPY9Lyrq?=
 =?us-ascii?Q?yZCDtI2zMCf52a76WWRjks+2wct9R70fNXyvf5M24vxtWR4fOuomQhiFyx4e?=
 =?us-ascii?Q?OzRVelwX/w4qPQClQrjfg1IKf0wqJesuRjmfKxg5MjnjYHpPKnvRKxRXSV9A?=
 =?us-ascii?Q?XknKGZLfI42sqea83SEF0I+BU0SIs/cY7YNWuKKfQaPHRder3tSBQVaWvn/2?=
 =?us-ascii?Q?PfIpGrwSvFlxADRjMkW6DyK6g80I+oQXjZewAsZETfL9xTrvCRuU/VKD6zXB?=
 =?us-ascii?Q?zQGzRPL7PTvy3hAMmjywce6GvujqnypYZP++QX/0uNXMaCSp1dggTO8mNwlh?=
 =?us-ascii?Q?sdNZoukeXi4J/WH+GF/LeDORwo757niOaf3wdf4XyGktJEAtcPFt609kCfIr?=
 =?us-ascii?Q?vK+NvFyv/psLSnKN5MhTkxsg/sNcOFoKRXKCDX6W7FgsX6T2WLdcBNIiAwYN?=
 =?us-ascii?Q?3A2f7R0BWvqWegvyFUMUe9z3mrRE39Cuj/e/yan7nry6E+YcmzCGWEqiarZ8?=
 =?us-ascii?Q?55S3ZUqsZZLmkRZmT6NTvTMX9+LlVSsNzPuC0kdfbWFYEPW0vkfwRsaZcsD1?=
 =?us-ascii?Q?HLZTVOIAgqf3p5mLpQ4dhKjmEchFeCfPpqH8I6bTsIR/8/gBUQSaRdb08YOY?=
 =?us-ascii?Q?NAJNRa5QPi86EslWNZVdf9sAQHsB9iE/hbsyRCQan5YU498WHHKfvNbUqrMu?=
 =?us-ascii?Q?Lm5qt9ETrF2TMxZJ2RG+HdXqwv6NId0ksyTvR7BZ+EYqde5dd79QvnDUwb8F?=
 =?us-ascii?Q?iqMbFVoAtHB+nqA/jkaR++uYHhJP/ZvkvMPhZJ+75R+jwzqaFARDaPWFyK/+?=
 =?us-ascii?Q?lyp1W7N2G8grv2CNy2fakK/LT6CJUGJwxTAbfw9whPLJ+RB9BI/Bd3O5cHKG?=
 =?us-ascii?Q?KCnRupNNk8dXv8q7O86GisCdhvEdjtVzf8EQzJhg5lyjZEFRcD50nPWW6EDP?=
 =?us-ascii?Q?TMDGcjFtxYSjlMRspxvYEJuET/dQ4SwwcDbQID5Op49WfjDh8a+3Wv+vsHxk?=
 =?us-ascii?Q?h+kA0cORhHrurWqd9/GfEuZ4gzFwgnYb+Jbys6CVNPvMdpgDuiIA7eQOCnNa?=
 =?us-ascii?Q?VBCxsbBZXd44EtZyfOavVY+TP+BYmHpp8EVfSWPEG9d6SZHTmnMyPMYW1yqS?=
 =?us-ascii?Q?VWgEcnRmUY4EaJ8Mboa83Ip6UbX1wjmFjpq5mGgTWYS3wRq/1kkTruNdnwpf?=
 =?us-ascii?Q?RsAWFYXik0DhA+DM1JH7EuaNZbXw1Yg8ripAKhvYbuvYYUZrRitUy8d6eOiJ?=
 =?us-ascii?Q?7GDOr63hLSozyX8VxXcAKs7Z6qtx+OHyrnDexAjsuq51XZuWATSFy0SjPeRK?=
 =?us-ascii?Q?jWm+BWi5X9wAdbUG7qSsBhLl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21791542-5a9e-482c-34f5-08d8e46c948d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 09:03:47.1722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ga6pKEqL2TBNIR16HSzzckC4KtHDd8Q7hyHbEAni38bOzOs2fwskokg12Uco2+Jv2JvgKAD/pS3f/242kkI+7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6795
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On 2021-03-02 21:24, Avri Altman wrote:
> > I host mode, the host is expected to send HPB-WRITE-BUFFER with
>=20
> In host mode,
Done.

> >  static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
> >  {
> >       return ufshpb_issue_umap_req(hpb, NULL);
> > @@ -1115,6 +1122,10 @@ static void __ufshpb_evict_region(struct
> > ufshpb_lu *hpb,
> >       struct ufshpb_subregion *srgn;
> >       int srgn_idx;
> >
> > +
>=20
> No need of this blank line.
Done.

Thanks,
Avri

>=20
> Regards,
> Can Guo.
