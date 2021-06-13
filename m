Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51304C48BDF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ECEC611C0
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhFMKW6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 06:22:58 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:16720 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbhFMKW5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 06:22:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623579667; x=1655115667;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YpPjVK2F9uOZuNgD4X/n13M2a4k9D2kIYTbs73FIz18=;
  b=KhwW3lUqyq1D4P1zEvFgb+CdJTcfaCV+5N3fgE5efk5/p2wL4eW+Wq+k
   Qn5oAHlqNXGEEwpiy/pXdLnM4X+HH32+/dTmY9EQAijnUTBcrzhOLD3NM
   rydwwS3rTbjhTIOjn/bnUVs3yQBHix12xRHa/sZlRBQBnD2hb/1y7YUie
   yN4BRIWnkxBq2896JgEbnLXprC+jA9TPJeMSYZSxq0jDpt3vXoBzmxlty
   XGM9bUP92xoGNRKIFQKlbh6AoWeXYNKR7VB9zDDUFwCgmTJZU8wdwAdld
   acCxq3a4mq55IaouHdl4g88rVrZuSwdx+4GoHd0+V/Pc1dr+gaxQzx5GC
   Q==;
IronPort-SDR: W81W2S2Smv1m7lWEePHeaCF8Yboe92XIC9/8Soa2wYdDA1RN7HskugcSCQ7JSN4vH2pRshnNEp
 uyfZHOaB0ZCBgYaWIxGguEJsVP1oQQ7uxOooMn7fgMU4dbB2vNmkiVmV07DaTN0Cl4Njvy2/4S
 xDeo8oYWCwYd+eB+p8bsdZTvl195lHCOkQ4doKZclVTTfqoN+K1oGWpGzOuWTlvXg1YPRHKrW1
 8xoNFsGodb9ic7LHfge6rTnZY4hD7hgytGG9/lJ5xVo13gpiv8eaIl9pm0cT2cmXE7p1moyT7z
 ekE=
X-IronPort-AV: E=Sophos;i="5.83,271,1616428800"; 
   d="scan'208";a="275527443"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2021 18:21:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSJaFmlfAVtoLXQR6RK++s6YzoVC7C4+w+yHtyxhw7RheBmvQFojpkTY/ZxC0wbfIsdPy21qpAgEhSAeOYwaGWy/ixhlgtkGUyIYKB+Xm6nxqDzv6TFABcE9AsyZBkdZ/sLolUfrW5Z+LVQ0UXQtJyskJn24sJVpYblBriqKI/94DA5GZY6op7B4s3TBNAUuWY75FU7J5njYQYeO7eZcxUsT29pTgU24sDe93OTKENamVfigm1ukfbgor478yc8Jqfu73jZu3Gq7rXLiufw39rsmDOfwyGcKuZm2B7ZUZCEoNUNr2/do8ygTGl47ue68ovFqPeJjHaFOsAWmvCPx2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkE+YOHH8QNuB9n+LUxbcXsHfMi0cc1iXFACF5Fq3cw=;
 b=KLE01enJYv478XvNOsXyan4bFHfbkCp4Exc1LGCtRilRd+AHvDCL2YvtM+bNi9kSu5OVZkFN20CdpjXuXy6vIzH06cnO326h+jhf/Oj1ubSjH3mtnaq4W6fluXwIBBUbxSGRKwrPDJs8UDRxDnBCpqM4emrwp01sC2Jk3YEOlJFes6kzKGYo7JVb5eIRjbgPOGuL9EoYRLgbcMO89BfeYpcuPrEpVtBcoZ1N8SpB/mngrwp0Qv95MzMBbmsnk/xDhEimBMU+8hjJpxZcaimE0EXU85a7BungNuP7HvsVVwAxaNsc1f1DfGj03wzqAE4lgNZzMoN/KRF6f41Wm9wslg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkE+YOHH8QNuB9n+LUxbcXsHfMi0cc1iXFACF5Fq3cw=;
 b=R5usnPqW3Tveuz4g8gAERNUZGJw2qbhKAOEUU6jS5sL25/i0LOHuj7gWMRIUwV32mKmC4F4ETrOtuwcK3SlE9zNpez1AneZ2DdyFH5ohycdk7Yxbsmq0I6K0Tsgkt+Gm2y3SGP655fVSBKaLri9FQuJtqNaZmT1EKTZml17Qv24=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1098.namprd04.prod.outlook.com (2603:10b6:4:45::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.22; Sun, 13 Jun 2021 10:20:53 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0%9]) with mapi id 15.20.4219.025; Sun, 13 Jun 2021
 10:20:53 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "yohan.joung@sk.com" <yohan.joung@sk.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "d_hyun.kwon@samsung.com" <d_hyun.kwon@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "j-young.choi@samsung.com" <j-young.choi@samsung.com>,
        "jaemyung.lee@samsung.com" <jaemyung.lee@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "jh.i.park@samsung.com" <jh.i.park@samsung.com>,
        "jieon.seol@samsung.com" <jieon.seol@samsung.com>,
        "keosung.park@samsung.com" <keosung.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "sungjun07.park@samsung.com" <sungjun07.park@samsung.com>,
        "jaeyoung21.choi@sk.com" <jaeyoung21.choi@sk.com>
Subject: RE: [PATCH v37 3/4] scsi: ufs: Prepare HPB read for cached sub-region
Thread-Topic: [PATCH v37 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: AddefoShGrvD08D4TZWSbfCJbPtUOgBvsB1Q
Date:   Sun, 13 Jun 2021 10:20:53 +0000
Message-ID: <DM6PR04MB65752E6128BD92A801221ECDFC329@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <29bb775275b941c08c3f3f0d835620fe@sk.com>
In-Reply-To: <29bb775275b941c08c3f3f0d835620fe@sk.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: sk.com; dkim=none (message not signed)
 header.d=none;sk.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38521a95-b5ed-4ef5-7ac1-08d92e54ecf5
x-ms-traffictypediagnostic: DM5PR04MB1098:
x-microsoft-antispam-prvs: <DM5PR04MB109868B30BBC8A6F716A874FFC329@DM5PR04MB1098.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ziqFdsL0T8o06EXH82YTEHxrri7IAgtuvOh0n1/gMLlHruT7MWnXnHDuV3fY4CeoODTvJWn5pWRP6BC9g/83Ry+7DhFHzFFX7FojEo1wCO1pH0BKvkvXqlHW5e4jT0lMTcgdJACca6g+/9Q2qlF2tE2eYdSYgjY7KVB9kLRPyBzdDuQ0T4msPz9svK0EuHWiB6+G+q4lWuOopF8k8S/ZmQsUYektr1J5rNO784unYD6I1GI6ePaxy+ib96sWtD626EcsKDoGbNqIYMKv6H7M9pfDeCdP1JG/M7nTBQH+H6qUrhjcFRMa1fwgHo3sgdZCqhaAoIhXUsBbeLbUKgkYWCH670QJw47lj+qs9Rqjj69qkzoJNb3Z+EeBM7aGUoRnbcX8D6BuRp9dOuaeaNnz+IOnfr45K62/UgIX/IhUkKpnp3BriFVfgkpMZ1R2r7V9dXcbwk7/uuGd78pE2oFLXy3Iey3wYOo6Erzv5uN9TmtWJzrGpDJsAd12/xbR0B/4SzniAvBo+6tjjI0/+n19oOK+KfyIjsHVqF9JEKaGMM+ADuab9SdfCYKhgedqUQVEBRuIXtECEIFU1ZoCFia/DnaoCjOD12/ssLAtrzqZLwM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(76116006)(316002)(66446008)(8936002)(6506007)(5660300002)(38100700002)(8676002)(86362001)(54906003)(7416002)(26005)(66556008)(122000001)(64756008)(66476007)(4744005)(478600001)(2906002)(66946007)(7696005)(186003)(33656002)(55016002)(52536014)(71200400001)(110136005)(4326008)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PryAA6Pankqd5MfZD9NVsWDCpGycxbvNVJzxKeKueEGgtk7nhVJAr4cLbDtS?=
 =?us-ascii?Q?azDkO9qyeufbh+58OtU5bXq0i19t+LJLGRNujRABNzc/C3XT5K2xHNxbpYJh?=
 =?us-ascii?Q?v2B+7iXzYhhnzMUDZ6TCWSVDrQ3opNX9oAMwLpJEbhNW3tEmW4Jl0g9wem2/?=
 =?us-ascii?Q?xhgQMVyNv6lC4XwITcGEiNRcASLGWpUkgirPa61RUFkHvqU7qgMQkODXoxxw?=
 =?us-ascii?Q?bd0a3s9SUYPtn/18135+HQwtzOeaET2vbE9/CDBbIoU5q8hatjtHFMwx1FgA?=
 =?us-ascii?Q?0xVlyLDDcc8kaMbb5SXMt1nPMEvuVg71lz9Si+9+ivLxe/NVt992kJRHFC8N?=
 =?us-ascii?Q?ydsh/xaYzZie3XOCRFYex5Oa7grn1X25UY3UnfGFlnUKhdVefyg6RivoLDDp?=
 =?us-ascii?Q?XhEelNBMcDb9mPUIAqEorCGWbIgxGZp7drlAInoBGU/dsa7BdWJWR9S6axNc?=
 =?us-ascii?Q?gzAEK0If0RcilF5O4peFyQgyupNg2t0EVAMIFDrXrRWnWxH2DA/jCBNa9jJb?=
 =?us-ascii?Q?nyqB57meMSCAmF98atR0WjFQl97PmvGnexH59mCv3suTWvGi5CjaoWfNnE4J?=
 =?us-ascii?Q?i3sLhxF9tFU0o52qq9ZTBFcDCI2oaP7ZDZsXyQbqE5/X+JtSQfCrQkL3cq8L?=
 =?us-ascii?Q?iJhkO8B5Q9nVn97lv9aaXAzVaV1UdRq/r2KwLheHPX8nDM6mHExXHybcsbRY?=
 =?us-ascii?Q?SLc33N/LxHf2/ykE8eZzN436O3ro/HifH9fh6btxVODwvkg2PJ1AUMudaD8D?=
 =?us-ascii?Q?jmk3KA2k3i2y6ypxONHYlDeNMEQ4YJgWOmNOfz7kuFHuACn7sISdg/D9zBCW?=
 =?us-ascii?Q?2bkedPOzLKVVzDzyNgGs11PD9f5jCXkjlX5ytjNk3/ep33HIpMtOntuaZAT4?=
 =?us-ascii?Q?aopT5SXt/8ga1eiDCVBh1+j1bf8cFSYGx5DL5WiNVXWBP3sooWRIhCyXP1vb?=
 =?us-ascii?Q?woFhPwJpFn+qi7LZVltMUkMy5UzseLiFeQWfIkWXYFajOQKT0DblIR6M0npF?=
 =?us-ascii?Q?q4Ia+xoNUNZPKmGw59s3U2bu5yRf12GcxM1K39pEwQ3Am53QEPBMnbJecocU?=
 =?us-ascii?Q?/UbAi5hApptcIxjkbus30CfmoQ3AOBosTgYVLw920js3FSfeC1VCiQY8QCPp?=
 =?us-ascii?Q?sVG+2OfNkT7lPoqGKPsTHHDcohido5oOOYcDbwko9XtiOdx2h3wriYPCy22+?=
 =?us-ascii?Q?G7PnPbrV6JEgkO/JHLhQX1u9K/o7WfL3i7Et3oMyh8RDy3qIi2Bu8Ioj9Ife?=
 =?us-ascii?Q?+ot1pSblUSazE364EvgE1AhoZk8w+59hFLUaPMv5Bytk6sCgHHFuBhWJXg1D?=
 =?us-ascii?Q?v3F/dHXQOQrS33lw58BAcm4h?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38521a95-b5ed-4ef5-7ac1-08d92e54ecf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2021 10:20:53.5395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ezjSvjy/n3tGTq4rIpXqIDqU2ACMXeLqVuQSrhN6u5feOCJE3jz8QZeO33Xt3fhoBBdcV4vCmEfGX/IayvwjmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1098
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >+      /*
> >+       * If the region state is active, mctx must be allocated.
> >+       * In this case, check whether the region is evicted or
> >+       * mctx allcation fail.
> >+       */
> >+      if (unlikely(!srgn->mctx)) {
> >+              dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> >+                      "no mctx in region %d subregion %d.\n",
> >+                      srgn->rgn_idx, srgn->srgn_idx);
> >+              return true;
> >+      }
> >+
> >+      if ((srgn_offset + cnt) > bitmap_len)
> >+              bit_len =3D bitmap_len - srgn_offset;
> >+      else
> >+              bit_len =3D cnt;
> >+
> >+      if (find_next_bit(srgn->mctx->ppn_dirty, bitmap_len,
> >+                        srgn_offset) < bit_len + srgn_offset)
> >+              return true;
> >+
>=20
> It seems unnecessary to search through bitmap_len
> How about searching by transfer size?
>=20
> if (find_next_bit(srgn->mctx->ppn_dirty,
>               bit_len + srgn_offset, srgn_offset) < bit_len + srgn_offset=
)
Isn't bit_len should be used for size, and not bit_len + srgn_offset ?

Thanks,
Avri

>=20
> Thanks
> Yohan
