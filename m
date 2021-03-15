Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD6EC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 07:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D6064E74
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 07:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhCOHmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 03:42:24 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:61422 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhCOHmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 03:42:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615794127; x=1647330127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jF12rWGeTIRbzNsanFmagHJc80PV2OHHDP9cF1bm8wI=;
  b=pmyLwbYyINjt9GmOqIBiBlcVJUwQ5dOdbB5ooBmFc9PyBoWuKGSJWVZm
   M9zWgXwUeazQcG9FcOlxNEWf2qnL0x+oHlHIEojL9K1FonYhfvilq7k1J
   2oe7qHofC6pWDyIqkLtVZ0oMI4Lg2dn+lFKczO9DlFa1qefg+5IbdiGc1
   6GWbAzICnrAF7xAuo0d9UEfZFpdQI+DFJ7ghBIfETmcXcnqSRyglNrjFn
   3GRgJIupn2PrAaLfmXLHAyNTOtA3LPS777MqptjV+89HkI1xol0KZcNDG
   aHFC6tkfydPEQAzPTNfoeIij+OcItxdhOZvOhTgtyGbjIJtfy+1i4G8ym
   w==;
IronPort-SDR: ArFNOFeCfPmFB6d66M+aDc8gmuvBr5RjvBRE58Ya+OhL+76/Dt9sO+y5xuzT5S6usU/S6oFP+3
 Y08C8Peve1Kws5spxd7JnBCydoXdNPCq3S36wMYxgBGYMAhU1Y6BwqRP29xNB++saHynJi0h6V
 ABNUWpgliGt93uWC3pz3gKHs1tEh9jOXucngOqRlJPpK9i8hCBNG/3lzkLU3Qd8MOjL9RUlWfC
 tXfSKsJ9j8rIF9HUSmEABSkYVXFq/yKSIif1exnQsbgN2uiE8Z+EPIJQdeg531NFH8nepo/qpE
 4Sc=
X-IronPort-AV: E=Sophos;i="5.81,249,1610380800"; 
   d="scan'208";a="162130045"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 15 Mar 2021 15:42:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jENxUk1gDTKAoQu9W8A0VFU/YjS3PyMWeBGRO3hA7CVTeGqce7K1e4MoS67PPB0OeIxEbuGiBsm0O6R6+fA9zk0Ij1kzjYccJF7oqwktMW9+lP2jx4WKBUbxK7IvNPPpsjVZevCwU0kl6bwKdspbpVZduAcHrqOIA9YQ+s2DvWTcG9i1MH0wqFMFFhKm5lGy6FBN9Vor0h7Evh2flYQuHUg2egNramC2TITojyqLQYuWCzYRtD/TbJFwcDjobXlC7NRwK0D99fgAsFZZtd0F4Gv791KM9RfHjSo1mfj2373VV5hC24bHaHZWrfsvf8yOQSduOntBp1HhrXg++8pUGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nc2GUNzJj+GkA6rrTXv2Ep1irTB1xPNTTl9VDXgd0QA=;
 b=aHOgMED7WLYPoGvj0DAl5bRNIUa/SBdcaX/C44AB1ERbvCjaNNKkE2g75eil8Ew8MjpZuiZvhS1RuBQy58aMQea8R+JDQATg9tmntLdroKAzqZhAGuInSKvc65Q1apAegZpa1LS37546dkjJVQJ5Dn6pv6IukphkSFcfFVeE7MnKcB9s17OOyxTY/x/hbxmRcA3ap4PBxy9TMMjHBQ6D9s6WvywmI9yetZYbOnD4VtYJ8z0aiSHB/xy8IzPtcJg2Alg7a1rHSOp53OIyBWoZy6N0sQhxPmxhfA29i2cHQ28Ou307XseEGmBIZC1AumUiMLNgDRxS7vnugBH+O7ZCdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nc2GUNzJj+GkA6rrTXv2Ep1irTB1xPNTTl9VDXgd0QA=;
 b=Ipbnj+iBsvEqH08ATstdOn3j/nSLyijMr6lnkLEi35PWFzQ183IZvz0B9VVt6uql6xyFmz3mm1+UCxJ0Z6XkBIJXfVureKdKki7KxgsRPgffSnndP8d+RNkMyT7S3n3hoQH8pGOPqQpsh01U6tl7pUZGQixd/++t09OuEN4ILFA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5084.namprd04.prod.outlook.com (2603:10b6:5:16::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Mon, 15 Mar 2021 07:42:03 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 07:42:03 +0000
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
Subject: RE: [PATCH v5 06/10] scsi: ufshpb: Add hpb dev reset response
Thread-Topic: [PATCH v5 06/10] scsi: ufshpb: Add hpb dev reset response
Thread-Index: AQHXD2ex1y1f5g2rP02e5lIjKmzR26qEV78AgABmXTA=
Date:   Mon, 15 Mar 2021 07:42:03 +0000
Message-ID: <DM6PR04MB657550C10928D3FA748213DFFC6C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-7-avri.altman@wdc.com>
 <9d9237bc77332bd1f9ff17aaf98718a8@codeaurora.org>
In-Reply-To: <9d9237bc77332bd1f9ff17aaf98718a8@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f25a3590-7144-4ee4-cbaa-08d8e785d39b
x-ms-traffictypediagnostic: DM6PR04MB5084:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB5084081574CDC3A153E0B7ACFC6C9@DM6PR04MB5084.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6gUZJ1M9eMnNJiwUyxgs3bfpvx0lVZvDfe2Io/TIjK+oQVqA26AmCxMKKRdot21GP1/FmRqZfffqpwACjVFYBGHWguVoCLOskM57IZqo8Cyl4xsTvU74PsDNbF+S4dqhdIzaZOaNYsgi9qLcQsz8V4/xR32sgYNhJodufWj8pn4BEf0BdcINYYQG2znaOh/861/sQunK58n8ypt2ih55twFaa2i98WUKbnrWn1nj0s0pUf1Xz7sDr2TkV8wTkyK8C50VVw1egd14iflOhFtbUaeVv13NhejL5mNMkIQD5lp+P+fWK1qt/P+Ftqkhh+dHtaLSY1E9XcPpQYy/QHnD8K4lj39LxDvpRZuyF9bU/uTpVYUWFmf83QGviX0ylxhtnF6f0G6UJwvDdbSncLsWbf0xgGWWikqJ1gGwdGLHJGu/eI4Rg1arZ8iyx4oleIOcirbvGk+UBmJMIkhiNmrx4oWSkGuUtvbuSuDGzxjnoib4BgQgYbLDSoFkvbCfONlsiEfzd/H5H3ICjMAZm5DMcaGoY4gV4/CgUNBKq6I12ncOSHkwqlhOQdi6utKFKuOg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(4326008)(186003)(6916009)(55016002)(7416002)(9686003)(6506007)(7696005)(66946007)(26005)(4744005)(71200400001)(66556008)(66476007)(64756008)(316002)(66446008)(2906002)(76116006)(8676002)(5660300002)(52536014)(86362001)(8936002)(478600001)(54906003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?SLHUUapM+mJIVJRk+UnPSbmxMv80jwBziGOiMgggxsyVz3McxbrFesk28zRV?=
 =?us-ascii?Q?wE5aTbNzZUqUG4NPwqoWIVMiYV0OT7qFp8XDmzrWsX7Zx4bkcGv0XxqfqKHE?=
 =?us-ascii?Q?xJUsLsxjYE5fZZZPDjU+93E5fVeM+OdxsPN0viMXKLi2/mJMeeARTIjYy7qa?=
 =?us-ascii?Q?n9x0tjt3KwdI2zSSf2SQrP6PyeqkKar7mF5vg9waZhwTpAsh31+nJewkm3D9?=
 =?us-ascii?Q?bvsPtd8xGiH9ABa9G2M/+rv0rSgH+8myHSEY6YRXXl7Gtj1F/FHM5pgcFtbH?=
 =?us-ascii?Q?c4Ecmq0DNaI4yiu9oAFRswkpYNnL12yihergaP0z10ZIC0BD1Ja/JUN8n57I?=
 =?us-ascii?Q?mM4Z6HOOQ3qJA2rtI0cNSNlShKkXvVquCHVpiDiF0CZ3jVETafxSXL6C9ewk?=
 =?us-ascii?Q?Yc96Iwq53m05+++O+LejO4SH5n6V8pGKNTA6skl5bzp7zM3osH7OjVKUeCLc?=
 =?us-ascii?Q?iC0HfvoNCIBe4L2JCTblw2k7EjZ8VE0Ta6dJjm8Fe53ca9XMDx0I+Wru3fX1?=
 =?us-ascii?Q?2fJq3rO51CyjSPE7t1NY0chX//c4NTLL45ZH87p0++ypOBopnPLfrVSXLY4c?=
 =?us-ascii?Q?Qo/5Bj2j7mN+J3XXvbdvqyqt7ccjk4Wvq+QvsOG8fU0Xku6dUq2sLd8kWLox?=
 =?us-ascii?Q?E4UCnkhPAmewtx1h9ZOYbTzLK2SA9XXBii4/RFLUkknURuuPXu30NTmdpA2C?=
 =?us-ascii?Q?5ESNyY+/t2H59s+dynpLSxI3x6zYPnEDAxpq8K788zF11uo4/9+2l84PMViu?=
 =?us-ascii?Q?phogT2Gr0dklLFo+yMGsDPoKMdh2zjGMVf+3t8dI6yAleqrkKX0wKMI6+9DS?=
 =?us-ascii?Q?cyBuIBCLtZAGrRoOurSUVvhz2cZDs/inc78nKRkjQJF5QwmmyCjJl09AeozD?=
 =?us-ascii?Q?RvPRq6O1lE+ncAJTJXznzmVZr9gzOqjj+U7Aq0GwTFWqhhLcJBNoctHz0hcL?=
 =?us-ascii?Q?xQb862hwYbKiq2GbWJpD/UReh71xETK8H93sYUlik7AbZv1Fu2Qc+rMeRypr?=
 =?us-ascii?Q?+7LLO34ip+zwtY2Nxa3GCZA/Mf03baX1XatXFMCY8jNAocCYGNhD05HCiAXU?=
 =?us-ascii?Q?l5HLmeUdLPNwDeMTnt4ylU8JeRc2RXIFlC9cFEpiUcvismrNW4QqzDzATZKd?=
 =?us-ascii?Q?/BJl05cAw0d15FFNlyLCi0evnIDvgH7onZ26OXpgpkN0ZMCMe0muSFTKKjfv?=
 =?us-ascii?Q?0qsCCGi51pSBON0au02ORTlfy0K5mMzUb4m9aNYkOvoMq74sERlJ9keHW5+7?=
 =?us-ascii?Q?9Pz+WnO4gYAgWiGWSlTitUkoD/FVfelHkZA01ffFaynRtX4dPkKcQIL7mMI6?=
 =?us-ascii?Q?Xog=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f25a3590-7144-4ee4-cbaa-08d8e785d39b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 07:42:03.8739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: biHi1B4rk0E+OJ4VrCDl8hu1rHGINnrSEz/sKFLbFikmSCJZ91HxfwvyNCGIBFpVuUmh02HP1vfzWulMIpJ7JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5084
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +static void ufshpb_reset_work_handler(struct work_struct *work)
> > +{
> > +     struct ufshpb_lu *hpb;
>=20
>          struct ufshpb_lu *hpb =3D container_of(work, struct ufshpb_lu,
> ufshpb_lun_reset_work);
>=20
> > +     struct victim_select_info *lru_info;
>=20
>          struct victim_select_info *lru_info =3D &hpb->lru_info;
>=20
> This can save some lines.
Done.

Thanks,
Avri
>=20
> Thanks,
> Can Guo.
>=20
