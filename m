Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B1FC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE238206C3
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:14:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JHuP3Bmg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="d/Sf7uUC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgGHMOL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:14:11 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:32809 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgGHMOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594210451; x=1625746451;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=A8/9mKasT5jqO3YHIIUbBra5SaKzJDzWBSfzSp0hyfk=;
  b=JHuP3Bmgm9oXZlFgIXUgaz++Q2C++hwexm0m39Be15OW6/Vj7jkEhArE
   wsF68rFvJy+yigSJ9niyYXM4klEFC71EC5wfccklsqQO6ITtUQPRwmO9m
   JyLX93/tUliNyX96duBoSff8jdg8Mxo/yZ5lGj7dwlqNjifr4jv3s8AMe
   BkZRt5n5vttdimgNK8PUbxB0rrH+nrgDFCfDQFQ0mqeJ1Iurg5HVH4Jk2
   EtQd89oO1bGKJElcuElut70aLj/x8gAlmXmCWikOLVGoAXeX/OZ5zFmuw
   yHv+L2tcQI8Hwjix9lTXcJOwgxolakwhr2y0j9uc6s9kDhfP8SnZG3sW5
   g==;
IronPort-SDR: RWTVlJIxNZ0xDRMSN668/SW+D0Y6GpqncStgAKeI4TgIIN5Hr/WKaO7sZZ3G5ikWqqfgS7sWoX
 inbyMoZ/GX1ljXRivftB+IGNDlO/dGGHhELiyjzjWVITLelkVCKevDTgf0ZyCGlPO+W85iQ+Tu
 rGKa5hcS5JsSvwhNAzWOO9IGiDCjMEphF6l6OVapMVw321F2xzGzxOeL03GZnfZWDFvR3vob5c
 9y3eBGal/ojAUV3I0EKnicS89qC3VXPc+4Igjnyv0gTXjyQWV/22k20v1pV603R2DL6nu3Mtzm
 uoo=
X-IronPort-AV: E=Sophos;i="5.75,327,1589212800"; 
   d="scan'208";a="142091342"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2020 20:14:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTY27u0ejvfr8p4xAKjNIMjQfNxGQv0rN2HqxUB7TdZcn/As8jVi7zomQIZT7AVMLaI+QdPxFadutotNwx3emt56QsG6nXklk4kFb/9JRNX78kCi9iYLh8O3Oc3pByRZ418EDvYmNrycuZ5bnnAn56FX4IdPlAPC6o9S36E7HUQ/jFb+ckHt3d3dmXNEEsE8TKCm6M2rNUKL+X4I2mIp81nttatdC8vEot5AOAu1/kRjoLvUb69H3WrkuL0gfSYdUKIaPIbz7Qymuxel6MMDgTivPTU2kfQ6xL/g5RMrhZwDdfn+rTYOKoANGgXJuYUEnFARHCn+jsMGIkYt1yJxPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzgNl5huZwVI200HmZtCkF1u3EtHrgQBriaYGGpsiLc=;
 b=Q2aM4GKtRqEE37ILs+o932p96uHWrW1jpnmiNJSrJz3N7Gyo4Hg5WDWyOHK/scpSO1kUgwBDAvJMrYsQ/gqPgrfEZkvB7VbBhQ2NaAVCAx+dJ1bhwDKO5K4H586F/SlgACWVTsLi4kB0JdTw6sLk/BfhLtWIgS+10C5jXIPCvqAMQjX6Xt+KqXNMxgM8Nglg1s5DCbSWbRYuwrMBG0Yp94c7ayaFiAk/HIXQyKbX1/rE5SyS8kk4ijkHq2jS8ZODLatJOcp4neslONnUxTa13iw/3yWyQ1hrK5QHx9lIe3IZbvyB9mujCR3W4FRTGjwYP/4lGjEGGU2Oqjq4rg3M+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzgNl5huZwVI200HmZtCkF1u3EtHrgQBriaYGGpsiLc=;
 b=d/Sf7uUCxcooWlvPqlhSMXLiqafNgJn5RUkwIH5c+NzJCvH18GCv9awwGkZqnJizmktUIaLEznbmvm1vRwrs4a8C+GUpucOWoMx2OUZP6PbnCHOBEpoq8s+KdtVkBkrBTwRccWRyD+SSR2Xf3yTFzQZI9vrhIU/IoYQQj3c8XRM=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB3888.namprd04.prod.outlook.com
 (2603:10b6:805:50::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Wed, 8 Jul
 2020 12:14:08 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3153.031; Wed, 8 Jul 2020
 12:14:08 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Lee Jones <lee.jones@linaro.org>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/30] scsi: libfc: fc_disc: trivial: Fix spelling mistake
 of 'discovery'
Thread-Topic: [PATCH 03/30] scsi: libfc: fc_disc: trivial: Fix spelling
 mistake of 'discovery'
Thread-Index: AQHWVR+pi6nQBSqyRkaYFJ9Wxo86QA==
Date:   Wed, 8 Jul 2020 12:14:08 +0000
Message-ID: <SN4PR0401MB35981798216DE34D9EF28FA69B670@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
 <20200708120221.3386672-4-lee.jones@linaro.org>
 <SN4PR0401MB35986D7CECA87EA6EB9CEFA99B670@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200708121209.GS3500@dell>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 801e000b-d130-4612-3a03-08d823386a65
x-ms-traffictypediagnostic: SN6PR04MB3888:
x-microsoft-antispam-prvs: <SN6PR04MB38887D30D14D3B185B80253C9B670@SN6PR04MB3888.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MoIgfi80l7n0LjaVWUB69E1WIgdCqz7Gp2zdMX0UXHIkncNW8iMA2AGtlLXhzKLEozJDLuJVRRV0F5aorKElCaTti+OuI3T8p/7Y6EuKGQlWR4WYgAAndqMDrl88ZLxhF+fXj671nUWfCx37Xr3RU3rrFbq+aHMP2nmsOeA7R9Xk+oN6ey10OxQsstA/bkbei87MFK4aKN3bniMN67a7Y6Hb4HSmYMJATTUdzPYHBcV7MXfm3Y4YbrR5pspPx4EUkgDbUWGTKvPUmImelRf4LSOYqUudeLbftBO+CFQTn9Eaei/KKZtxa/ryFHekOgd5PBd1gRPlAJXFOp+/idD9AQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(66946007)(91956017)(76116006)(6916009)(64756008)(478600001)(66476007)(66446008)(66556008)(53546011)(186003)(7696005)(6506007)(55016002)(52536014)(2906002)(9686003)(26005)(4326008)(5660300002)(71200400001)(86362001)(558084003)(8936002)(316002)(8676002)(33656002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: cu6rTAEyvmYX2y0EbNro36TyqXrx0hcn6UzgqHLPhnP3TLvECRGV///JU3uFgGe7MlU0sJoYSvtVN4u6lBBUOqZrdSQx5D6Y2LLz/2YZRcsuhQjPdKBCPLJBxBa64BHRTpMEhXkGfQy21Jdho6pdTtG8CIvH/lcx2VS9p8m6NrX8roluRITHM74rEz9+cvqicBMQSjiUmCNo/4YfyGyvvly2fkgmI3YyqWP4z9SVJOIfqWFu8cACl4kMsCbVlvGfhAJt76gZIV4yIQqvKfjxPJ4vgblq4Vo72i06OtwP2dxWSxOom03rI5avt5kQAlnyvi2mB7Oek2XOiqFllUAChU2b+0pZChyDxOM+b/LtsHh61T/dUdn1eohs7n8Yan6Ca7pKE3B6/59VOf8ofCVG4mh9EHpsPB+L2u+cJnTyOE0uFkCZZmP8shUwWjPvlO/x2S3cLWrSK6r684MCoWSz2n/4Ri2gz8wJeo842Du/KLCeP7Pwq3GGYlEk+p3alfpM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 801e000b-d130-4612-3a03-08d823386a65
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 12:14:08.2351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QALzV3pyxlfCchJ7UWHvA6sXq0LKCanYf44vuLIy2nzuwtHUaQZq0y+vwktGEj+f11hAp5kcsDp9usv+5QYZmdY6vfKXP2yHzsg0bC/00ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3888
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/07/2020 14:12, Lee Jones wrote:=0A=
> Obviously I'd be okay with that, but it will depend on whether his=0A=
> tree is able to be rebased.  Many public trees are unrebasable (if=0A=
> that's a word).=0A=
=0A=
Yeah but in this early stage SCSI usually is re-baseable.=0A=
