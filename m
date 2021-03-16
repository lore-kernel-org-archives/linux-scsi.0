Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AEE5C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DFFB65001
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 08:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbhCPIez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 04:34:55 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:57892 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhCPIeo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 04:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615883684; x=1647419684;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kULNo8PAAwsswxq22ejQk/1LIqjTlz0YDM+ns0KH3PM=;
  b=rUORWwTkn69IsoH30pfyJ/BNnyong9WOijTSXU+WrN1SctYP0uAs6wy6
   EW6ltf0LOk8clDKosNqQwzmaFt6ssSl/FNIBi3pMPN6190fwjWGF6a8Dy
   0mMCQuHZh6moR4pN/drzpgKFSQIETDr852av6FQBmnkl1YIiVczCxFNhj
   O8FE1s2F4iCyhidKKAoB9vmWFzPnUkHmVz1/o7/XhPWDuYaTxBqPDEw5S
   MdfYqdKEQtydqXLNYahzjdVVfiu+78E84b/0ZfqzIkBYksincTMms4AMK
   d3O1cUpVHLT/G3qHS6x0HhqEqGhPOmlhjhA+c3gIAqP1PwgzgL0DArflo
   A==;
IronPort-SDR: HjzVyhetgzpHqYtTyg8j/QKF2mGh7sr5SujmdyAoYANOEohYL9CWIjMs1mgTnn3pGssqjLG4fp
 6VNjByDS8dG+MwwgJN+TNK8QHlcczIlZKh2WY0HKu+VOc7idHui991v2uTaQRm0idKVoRRoMkj
 qL0C3iwBGzzD2ydD0R3cZHNcAvF5BIXh1PS6/FJB5wvpo4B/5OE5B7oGs4R7q3pTkyZf65GOu9
 FnFRzfkiQpl6WvLvR70oTba5ScYAFIRxXlzwpo2U7LgbhqgakkBqTP9p8tBvET/5YUDCV/JL7q
 2mw=
X-IronPort-AV: E=Sophos;i="5.81,251,1610380800"; 
   d="scan'208";a="272962782"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2021 16:34:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yk7p0c8MI7hm1+g1GC7RnkyxoI4gTD1eAKDV72mNJK4V8FuJvGiVQ2mWqJaMZbzBbsue/cz2XLf0OXtLsicki4o26gTNovvTWGeBh1O80MWkuWl2y7X6zu1xbbtBHP485cru/vqL9MCeyCL4SlUX2YLQm9HxB01G97foc6aBe5qS/J3Xi+4PcvdyHElTflfaslj2Ga6/wsy0FBlvoPnayZdZFVKB5vBA5xClJi9S2zvjyIXYGm8dIzjKVCD6i+xa6SKIBS6flccwTXXJc9YdpkQCurbzGeTQRkbGuP5HjQb/9nJJ0PUN3wvHbDyWgR6hnWi7l/kqZ0+rq9dq+T76oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7WPth5DCOeuVmpUbde44JPwx0aMBukTTP7aPCnA52I=;
 b=jfqcvBy3z+XWE4SppNC6MevinCPDkeB84tSCjho6umYfeDUtp7C8Xa814nhRHQCi5t49gXA3tr5dgnoUMNwrGUn1NB8j/CgCC1vTp4PZtlhy3wnjOviNhrDUymB+bYyVjp3Hqi1J7Xy5i/LtvCVYcgIEeupAOU+ps3T6IL2a/frK/25eminPM/qrCk2vHBxBOdQtNlBhNlB3u71TJ3dmBVuUPaBlH/XTOCEinCGNNoihTkNr4etUI3OVQSNdqg4kU4ZjOF2T++BVpkHzbbBQMltYSaBHR/VHjxBzm9Kqo6PxHtu0tsVBm7R0Dq6fwgCi78knYmalMv/gofExGuGdDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7WPth5DCOeuVmpUbde44JPwx0aMBukTTP7aPCnA52I=;
 b=c2IQN6gKTeXiXDK/V4IzejqXF+JXPm9OAduRv85FiUA6T4G3bCARXsxRM5qf3SEcr4XKVTrSTV63lvy3jLKVsj5S6wGr+uIFR1bfyEvDp8riUTA8yS1mKDjMn0PYhKLeH5gpAKLYVDZAIiKpjfDVZE2gIIefbj1k6F7vqHB5TEo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6511.namprd04.prod.outlook.com (2603:10b6:5:1bf::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Tue, 16 Mar 2021 08:34:42 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 08:34:42 +0000
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
Subject: RE: [PATCH v5 04/10] scsi: ufshpb: Make eviction depends on region's
 reads
Thread-Topic: [PATCH v5 04/10] scsi: ufshpb: Make eviction depends on region's
 reads
Thread-Index: AQHXD2enfl0FRI4liUichXYuitc7NaqEzBqAgAGTPPA=
Date:   Tue, 16 Mar 2021 08:34:42 +0000
Message-ID: <DM6PR04MB6575FA572C9B325099B7F92CFC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-5-avri.altman@wdc.com>
 <7cf2ce1235075c2925561d180b1bd233@codeaurora.org>
In-Reply-To: <7cf2ce1235075c2925561d180b1bd233@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 82f80b77-9764-4a5e-6be7-08d8e85658eb
x-ms-traffictypediagnostic: DM6PR04MB6511:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB651136F846038295D400DBB3FC6B9@DM6PR04MB6511.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FQvtc6aYG+KSPy2OZsz+iSKC3ZxKga0iRk8OoDOnPTFLk5BV5LqdVsoTHFatmuWOugsMm6hpBRj8kv1vSyFn1Xqt2SLvyJoCq7regA/gf2CHmRdWkFMgyZ44GDpVlefGUnGZIyWL3KgFzpo+9EhTd4ulW2oS0Fx7jAfvclyjKiXjXef1kjLXNTpt/R/n0DoyJsrnEAdeC9VWLWTu7+IjtpC9wc0mj6P1776TE6mFNx5KDWDGguswIhTtF064qmL+l6wzthMCT3znLAdA/hJ2ZtQ03JDe0TAPTFosMpZK17CnUnupD5hF8temusjNv9sEiLLqOQy9CqsBCR0WrsOZGztPHXvCV6/8xxYcxO58qDaAX04rDQqwt06wLgtFfsc2+2kGyFCa6nmPbBvu0I8TwwEvJHXBKUkQdbEOP3PcOxQpkR1LXgFDUO+oTdpCCwqgIsFM1gRTnVZaMQ9YIsGvlydFbKt/pSISQcpW3nIymPBdDt7XSX+JkmMFmi+DOzQvtm9u4+iLqZnu2AsQCMMrCOD1nJWkQcYHxZi/bGSZj6edBKnrArZZBF+zGY+8NvCT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(7696005)(52536014)(6506007)(8676002)(9686003)(66556008)(4326008)(71200400001)(54906003)(7416002)(55016002)(4744005)(2906002)(66476007)(8936002)(83380400001)(5660300002)(316002)(186003)(86362001)(6916009)(66946007)(64756008)(26005)(76116006)(478600001)(66446008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uumJ4RXsSaqWlUHIwlpT8TLbOQ5CJUEuTu9dg04JlRJNTPydcej7s24zGsk3?=
 =?us-ascii?Q?/tdbTWIejDjywRCKmvmhmhODjpWLMXNbjh/Y3v2uxnUpWdpdONJInCYRPK2a?=
 =?us-ascii?Q?T3tAXhu1eeMPG7tMMxjCsr4CSIwOgC/6UUqcK/52a24uM1ZuY4mquJ+wEeY3?=
 =?us-ascii?Q?OvbZ85dV/16yO9F2K2oqfDrcXs2w2JLjFEMe+5t/P47KrOOc+pmBOeZTxam1?=
 =?us-ascii?Q?waPijzM8D+RazE+yMrzBmaUNxpuDUOncxgtNwvQVsnQApLXPAAHrLNetWg7e?=
 =?us-ascii?Q?5gg5QPQKDq7Bq3gleQGJuc8v7H758qAHL41tRR2ITHM6XEYma2wldO7KjEWT?=
 =?us-ascii?Q?9Ub9y7YLgsoTuR5Sn9x4XFjxU2r05CSd6hxAr6fyKPACYMDqzuTSSVRgialL?=
 =?us-ascii?Q?dpacgWiKnCNdyZhdn+zCh6m6bjVCkxIKGB7ZzKNpdQbkncjrhEt8VpDem+49?=
 =?us-ascii?Q?xMfbXTt0dkoIn9E6dcuiZI2jv6980efYVYi9DJXiNQ122WP544ZXJg4Cg/vo?=
 =?us-ascii?Q?Rj1Y7hxOpNbtiNwwKU0iQ6pPTOHeUaOO6cF9v5CzIaJJQmZ6jteK4ofLsIo7?=
 =?us-ascii?Q?6lRgpVPAC0d8pCZgNkVMq4noqFnwO0CuZHMFbAzSJDSy0new2HVf9ZSMjoaf?=
 =?us-ascii?Q?xSB5SUWpn9zp9mFUJL1q2l5+G8p0EIMW+GyNUfNcArT7QUXxahseyHvVBpz+?=
 =?us-ascii?Q?j4yNB6BQKIcZHNSd/DUzZLwa3bgXW5irsCyE6mGvWVVPe44hwr5j9uGgdXGg?=
 =?us-ascii?Q?2cMR9poTpAE5+zY0+WaMVeyZtgeAySxw15PAlK51HXryZk4CmejJIn4oSeY3?=
 =?us-ascii?Q?Zm3ydYUkNcv0ZnIhqpoU3Ebw3rKph5M3kxkWk7QfvPWD8u6QjIlNb41AAoJ+?=
 =?us-ascii?Q?bR7AvYOmjVD5zLi5uzRf6YcwNYXCuPo6+FTbUum3yj2C9IQZicFwqES+HA4g?=
 =?us-ascii?Q?HkcOTFF4Pgpc3klR5NDqpG89R8lP2lpr5L5G8mWKWStfyJ/soVtkzGRM2mBi?=
 =?us-ascii?Q?oOACUD2e3qJ4z+c53XsN0PaKCOtku0k3htQ2y6SC4h8GArFNeUHrJNeL/L4x?=
 =?us-ascii?Q?mTXmwK+5cqJkt5r2lYQE3fiEC7e/xe+EvyulXvYgREKxBmtm987n678ULs/q?=
 =?us-ascii?Q?/78UspulxcU7GkvDJzDRYWg2YaKCsMtmfOFVLOUrREdh68AOUlbu77oPnUMJ?=
 =?us-ascii?Q?+vx+zb9w2XcbSIQnXzaNrMqbCCpc0ocs46gsmZahLgYqykHUsCswbSxsHqlm?=
 =?us-ascii?Q?aB59jfRaUGu94lTS6QisnFZ3w0bwfbvCvcoP5tRUdhUJnPHpMn95DCOCkeWP?=
 =?us-ascii?Q?MSgge5LIjp3spw/jnxm5VJ0x?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f80b77-9764-4a5e-6be7-08d8e85658eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 08:34:42.8066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rIecMfXsHExzrX1IEeVPumnNfyyO/kVwVw6tG13kQadjn+yvR5nBQcf8vo22EGIypb+iaKiu+ctYoIuHSt26iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6511
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >       int ret =3D 0;
> > @@ -1263,6 +1271,16 @@ static int ufshpb_add_region(struct ufshpb_lu
> > *hpb, struct ufshpb_region *rgn)
> >                        * because the device could detect this region
> >                        * by not issuing HPB_READ
> >                        */
> > +
> > +                     /*
> > +                      * in host control mode, verify that the entering
> > +                      * region has enough reads
> > +                      */
>=20
> Maybe merge the new comments with the original comments above?
Done.

Thanks,
Avri

> Thanks,
> Can Guo.
