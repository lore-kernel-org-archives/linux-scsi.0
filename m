Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42BCC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D5365001
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbhCPIcP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 04:32:15 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:57701 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbhCPIcM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 04:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615883532; x=1647419532;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vB+GjnMVsWzt8zXAmqN4C7mP9WS1bVk/XGNXHfHoUuE=;
  b=X+A9vIXOzFoqH4KnpLR/0kn1jVwuawsy4TKBN2vgs+i/7j3k14Srs+tF
   QDidGyva8lR5d/CLHZokUsnm/QcpVr4ST7S3y470fKbCBzWizc5x4LWRL
   HLIK8K4qJtLlhIFkoEamUQA21gIagiZhNEliTRxJU/E2DIY/yRI26fvc8
   uGOLiu7c5Li+bM3I4hpZ79AhrEIsxkUM/TOxkyMHhQxdnWiBnLEysxoo9
   qaxcpEeCauIm7aR1WW6XXUFuSqXMs7/uaALxjmS/CxHfqO6OFZsjYK6M6
   lF/5zAWHgPboDAiHQ0xAIqglxFhKgHUEGCuUPtVm47FAxfkHD4d5Zr2Jt
   w==;
IronPort-SDR: 0xn7W0cftMULqxNY+lutSZoLf49VDlq2dhrqoY0wlose9AIq9vWxp7lrea0KQLODiCYXwjW0cY
 evBDcL2WbKmsglKzSvhdq23zMDmpR6C27NcCIN8c+Ue3dn19LM+0oejrKv0GbEWZ1ROcXcJHde
 PFlBDqCr+zXwDVAoLnpd2paXPJ57NM5zjbYIHJ4SDLOnJvlzDStWf90yF+lLtRhCPKtAS+ZhGB
 RBzZ5hKXinA4eyp1/kyAbdlKOl3/gTE2v/RflGas2qJeXSTCmD05Qc+Ycx4sJ01KQjv+U6n5xQ
 4Ro=
X-IronPort-AV: E=Sophos;i="5.81,251,1610380800"; 
   d="scan'208";a="272962565"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2021 16:32:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYk+rfFshEiZee37fr2ur0L3+Ja5VLzSnyrZCQMoQuGXPaOs9dq41ZF3msjSm7NvA6O5sNlepommZ8NUVpuaKH7BLEiD6+//QlPznPIGvK+YJAk+CMUdO3n71A09bm/KaIn92ewydeB8WhvIvomEMds8WV8WpkEz1C3R0WGvctZzGNqX7g7ic8yL7pEXMu4sm43bKUgiSku7tKrz/PyG2AvNpwnVw3KCdnRmvrrZZbLneFIEqYf2B5cc0nMZC6l3pq3GDjUP0CgxuHNrfiHAooSZk0jDDmahyMIRhCnKWAJWTvTQywKzH3B0WO33aEFCzHp0lchSTNhpd2rFuKsN7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upTBf8ia+UnjGjdQkboDibSXeGCFRB2w+nCWJ20Pbzo=;
 b=F6UXbbLu6idIsxu55plpkArgtdid6OzpvnKzn1nehiTztLnr4TQvSjwzRm/mf2979/scvyDzz/aj8Jrgy9ypONuyDYNrkS3CTO3enQ7v8D6+vXj8jvmGU6XqLcXHEa1bszux6MWNvV0hq+4+xcWflJIPhSIsMx8bce9YGM1ae3InX1eN9+N9W/72Idnznyxqpfwv51Hrw60YkmKBfpoCVwmHj4Idl66s8mO+7OIC+f42ccnDHo2z5qvc3vBqDpMyxnlLBVurfcepCRWPqaqvYKwBcnItiQBjZCMkFXK1ygs8zoDvDX9MNDgBWsVkxy5AjFt2xzXa4S1qYv2t1ObqzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upTBf8ia+UnjGjdQkboDibSXeGCFRB2w+nCWJ20Pbzo=;
 b=RgGqWJIg83HC9NYkWAYAaHWizHkNlgPZ+2Ybs3/TywqHMy1/bwhGex5OT0fbcj1dmEb1K62xL7uLNnqL0MWnmg/t5MX0PN9q8sXEmkSA+xz/HOCO4L49JaDLOWqmgEWMDnYqb+KUeJRGe0WN1iRnMGvXw0+uW1dQ8d1LREq7x4w=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6511.namprd04.prod.outlook.com (2603:10b6:5:1bf::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Tue, 16 Mar 2021 08:32:10 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 08:32:10 +0000
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
Subject: RE: [PATCH v5 08/10] scsi: ufshpb: Limit the number of inflight map
 requests
Thread-Topic: [PATCH v5 08/10] scsi: ufshpb: Limit the number of inflight map
 requests
Thread-Index: AQHXD2e6DWAKegtAn0e36hwDoDJuGKqEzEgAgAGSiwA=
Date:   Tue, 16 Mar 2021 08:32:09 +0000
Message-ID: <DM6PR04MB65755CF477FC3C10AADB9006FC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-9-avri.altman@wdc.com>
 <b71279bee1cc9b2ffba5e4f8c90fdce9@codeaurora.org>
In-Reply-To: <b71279bee1cc9b2ffba5e4f8c90fdce9@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e9b270d0-60ac-497c-5b39-08d8e855fdcd
x-ms-traffictypediagnostic: DM6PR04MB6511:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB65111324F8F776E7DB51600CFC6B9@DM6PR04MB6511.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lFaXd1K4ZftgDu2/43xht4rxwMHC7/ZFWVLb5r3jU0wUZZ+rwl17GxCM0DB9WBDRplpcp0fBDKddhB+8uYih3E5eXyx6TwRfSQ+M/XnMgKRPqoT1At84nXGURFrV7cshqm7Lc9ZgfB3jinBphNF3+5vd+GeZgOTFn2Y11gn4DM2BJH1lhDx4X6Mapi1Bi8lM0O/C/Oh3op+XvGZpxdtsLxlHfm50DF47CspzCL0pkfPQM5WaANdtt1xFfLsi7+VBRP+dIQ8AGST7wCSZSsGAfI+Toei505IwBLTDqVFCHxe0z7zwe+fkJybf6Wy11C/SDBeKi7pUNyDuQzJze18ynXYnRRM3ZFO2pXPEVuIOd96yWaYj7gePj6IeQBGmHuOYTScqabl/eNxbYLRIBSHOCV5b5Jqfyv10ZDt9KLu10HkRMGsgXCSoZ/KPaTYqW98MflLvVS6GDWSD8Q73Yns873C3en5jvSJolj6SfI6yR0mb96VVm+F2m/KKGorviGnxYtZHrpWlUcCxTB4Dfu1QVD91aeRbIajP0qmC7TB+t+u7RtoNMzx5faFvuW0xDUU8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(7696005)(52536014)(6506007)(8676002)(9686003)(66556008)(4326008)(71200400001)(54906003)(7416002)(55016002)(2906002)(66476007)(53546011)(8936002)(83380400001)(5660300002)(316002)(186003)(86362001)(6916009)(66946007)(64756008)(26005)(76116006)(478600001)(66446008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?O6Ko6ttAiNMnMuCfvocDk5FIzICuMzOAESY3CmW0wZdG2LNz8tzMp1nvfofR?=
 =?us-ascii?Q?pYJSjlTZb9wJNprDxFGYGi98n0K+bVy44QQEltiAjL+jeQ9Q6bnc9BrzBna0?=
 =?us-ascii?Q?dy7meaOJnX1xkoZ5RmEM3uRSTPKEhgppki0tzq7BZuRwgjSnjlQvXOViOdoG?=
 =?us-ascii?Q?v675kcCGB1XZEIAnj0T7qX2huB2+liwv39LQrd21tZmC10rMpwA4D6Zv6eZL?=
 =?us-ascii?Q?gPYeXYVz63XVHVe+ARr6mgto7IiV0iy/7J8UaXW2vA6gIvoIS5coimXgUFMc?=
 =?us-ascii?Q?zdO+c7740giefty1grhtzgj8BVNTMymT6XPI8atCVEJVej+ko34U0iTBqqJp?=
 =?us-ascii?Q?fZcd3f8hrbmicggCkfRqyww8u0tHyiWyu2s6oWc98v1FOLt2fMUYX39OB/lP?=
 =?us-ascii?Q?WU0g2LmGYcjyg44uVoTU8YB7JE40VJxuwvoNcpQAGfa21greHocQhK8bFogB?=
 =?us-ascii?Q?wivP+DAhZSpW2Rp+KTuwbddQG6uaDljRHHL7LvFiSU62q7kAY1FVw/ONYwuz?=
 =?us-ascii?Q?PrqBANf247rbH8/8kVoKaq33KL8fXINfqjTgT8rxhIVJeIWg8/C9YAhfZnP6?=
 =?us-ascii?Q?fRtef0bLH3PbR5FGoDsq7cWh8B2M6jRXqFIAlW70Z09I9n2QAyWhRcpMhD+x?=
 =?us-ascii?Q?v/Do43EAlZ5mJylTGOb7zbP1HvuwWtsrBACY7iasMm/cMNynJGrSlwnkIBH/?=
 =?us-ascii?Q?Uykv/9A/Jx5mHmqS5d7mF8gxPxc2H5ahbGtS3qjZh/GRONgXs2B5O23K6N80?=
 =?us-ascii?Q?hOlvMDJR+osNZ8alKDqH/ksnK9E7GMVMevDGXrF2q/GuJL6689a4BSPaDlnF?=
 =?us-ascii?Q?r7QmLoLSE2SFxQtTu4RA8oHj0+kr5D84yEWXS8ascggYQq6Q05/zJgkmxz1u?=
 =?us-ascii?Q?k1eJElBWFYq3USSuVewpKwvobxCJH/GNO1MsSYOW1IEjL6XapJprMyGA3rfH?=
 =?us-ascii?Q?ldxe2hvPEv0Wg0BjHrgoE4FnS4meRD1UBgzZil4x8FoUVbntLm7dZLD9xb6C?=
 =?us-ascii?Q?jcRSFDNKIoInV8jBAM17jrmUI6mVqD++yNfXrqIRqBfXAfMvpNtLio265Ptt?=
 =?us-ascii?Q?X5+dsfOmZ9uBvMZriic2Ah7TQlXPXPfNrLpw8RgWzyWUvLbLPncolacP0Kl2?=
 =?us-ascii?Q?mOvyuJZgxFdBhxJMybxT0oh2UtGrxU5SaTMPnxG1gnBy3QOvYLsz2238UlxI?=
 =?us-ascii?Q?oM8MChzxRatVmlAY/P/di2wvJhpjANBuqxY1yXebwAsBIUEI2Md1ZC36wDOA?=
 =?us-ascii?Q?tziPUzFAhtdeT5p+G5ShpaWPqs9ZIkXUWN9PLqhMVzjMQCNPGaMv7TRVh2Fl?=
 =?us-ascii?Q?Av92JOm2XOjwa6f1q9SWzPKm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b270d0-60ac-497c-5b39-08d8e855fdcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 08:32:09.8941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XIw/8JjMvqzTsgoQCzCeo5IJzzJDn7IAHeMCFrRBR5CwYdBaQdRnwlNKXoDVBBDXUquNaHt1VmLvKV//qFiUyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6511
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> On 2021-03-02 21:25, Avri Altman wrote:
> > in host control mode the host is the originator of map requests. To not
>=20
> in -> In
Done.

>=20
> Thanks,
> Can Guo.
>=20
> > flood the device with map requests, use a simple throttling mechanism
> > that limits the number of inflight map requests.
> >
> > Signed-off-by: Avri Altman <avri.altman@wdc.com>
> > ---
> >  drivers/scsi/ufs/ufshpb.c | 11 +++++++++++
> >  drivers/scsi/ufs/ufshpb.h |  1 +
> >  2 files changed, 12 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> > index 89a930e72cff..74da69727340 100644
> > --- a/drivers/scsi/ufs/ufshpb.c
> > +++ b/drivers/scsi/ufs/ufshpb.c
> > @@ -21,6 +21,7 @@
> >  #define READ_TO_MS 1000
> >  #define READ_TO_EXPIRIES 100
> >  #define POLLING_INTERVAL_MS 200
> > +#define THROTTLE_MAP_REQ_DEFAULT 1
> >
> >  /* memory management */
> >  static struct kmem_cache *ufshpb_mctx_cache;
> > @@ -750,6 +751,14 @@ static struct ufshpb_req
> > *ufshpb_get_map_req(struct ufshpb_lu *hpb,
> >       struct ufshpb_req *map_req;
> >       struct bio *bio;
> >
> > +     if (hpb->is_hcm &&
> > +         hpb->num_inflight_map_req >=3D THROTTLE_MAP_REQ_DEFAULT) {
> > +             dev_info(&hpb->sdev_ufs_lu->sdev_dev,
> > +                      "map_req throttle. inflight %d throttle %d",
> > +                      hpb->num_inflight_map_req, THROTTLE_MAP_REQ_DEFA=
ULT);
> > +             return NULL;
> > +     }
> > +
> >       map_req =3D ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN);
> >       if (!map_req)
> >               return NULL;
> > @@ -764,6 +773,7 @@ static struct ufshpb_req
> > *ufshpb_get_map_req(struct ufshpb_lu *hpb,
> >
> >       map_req->rb.srgn_idx =3D srgn->srgn_idx;
> >       map_req->rb.mctx =3D srgn->mctx;
> > +     hpb->num_inflight_map_req++;
> >
> >       return map_req;
> >  }
> > @@ -773,6 +783,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu
> > *hpb,
> >  {
> >       bio_put(map_req->bio);
> >       ufshpb_put_req(hpb, map_req);
> > +     hpb->num_inflight_map_req--;
> >  }
> >
> >  static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> > index b49e9a34267f..d83ab488688a 100644
> > --- a/drivers/scsi/ufs/ufshpb.h
> > +++ b/drivers/scsi/ufs/ufshpb.h
> > @@ -212,6 +212,7 @@ struct ufshpb_lu {
> >       struct ufshpb_req *pre_req;
> >       int num_inflight_pre_req;
> >       int throttle_pre_req;
> > +     int num_inflight_map_req;
> >       struct list_head lh_pre_req_free;
> >       int cur_read_id;
> >       int pre_req_min_tr_len;
