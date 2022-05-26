Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7F6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 26 May 2022 00:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346056AbiEZACl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 20:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346014AbiEZACg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 20:02:36 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6192B1AE;
        Wed, 25 May 2022 17:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653523351; x=1685059351;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=64lrGvCgkkeZEmieoHxkWkgAxHiU8y5eeKEunXXtENg=;
  b=FLgGPlkXKNQBNKNKdZAV0kKfQdPBaP8u3+bHB93rMiKqQBS/s3L5gJY+
   TVrTo+8LiTrPrIrX2qUbf+haNNYka2yQ0h5bqxtwn58J0WFzgRwf1DxAt
   gUAjqZlfe46IfOGRTLtQmUl1bkbjYHpD1+9RgipyiXVp1aj21AupJVBVS
   VC23agfTAhypaf+LOe94uw8s6Pj2ykUAA/DsnYKJurfWIjfL307joSrKu
   mAIpwEgJwUpVdfwUkHn1aEoHy02VgHV2JX/+2tfl83EG7pkqzB76T6m0x
   LjJGx9/lFzB84zbj8IA0HNia9EbjMPF+kVF1X9LbKHJiBXwiOz9/QKko8
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,252,1647273600"; 
   d="scan'208";a="313451376"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 26 May 2022 08:02:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrnKEDpXnlB2xI07Zs7H3drdwV8k9o+30/+3HLKjdlru9Vb+oBH0ldUSsqJX1fPNOe61ZxPbNwtwbIWuh3Nj/Be/dmCNPdu5yqNrVMGE4lrGD136OHO2wJ+AmALkgSkvlJHsOtoKNpFosw9A6Gy8zXlKFFEUTSkYh0gGCYHBMZEnyBbmIJp23bUAMXo2S9DzbHpGtHDoB0qxNV9HmqEGUFIzj7QH5J9Bj4L225c4WR8CNktx0ixAf57gpIs2R4a6/YKVUv+Zu4zti2MeVOL/FNA3VJuMJKFQ7lH6rDx2SOB+R1xy7yhD6rRxfQd+KdwVx5nH2QCCyWhs6GHdE+H+zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64lrGvCgkkeZEmieoHxkWkgAxHiU8y5eeKEunXXtENg=;
 b=DNPMep13T9SbBZz9gKyujf6KBWCpneq5OmstZi5s4HWGzR9h8F8hPPiDd61p9bgfs9jR2k065jSyYW2d0XjPpiNFK69HLuRkOePHX4cU4ku+4UcVZUq/ZhyOucGPHg60QIYw+W1V0h+LWGaMRbVzqP54qBxPhFEfm3HudKlzibdcr51DRPgbj5Wab3Ak6Ms56VKWPjubLGy2l8L+cIxR+rju7GCFXYP1ceouBRp1PFh6bH6+FIAhJCtqZc3ngY0m1hvTNYo4F1by4/b4z0gOgcTGBUrdZG/Nq4LN+V/d7ahw4nUhqW4yzAh2ZS84tZ0xOyys730oYKLE0ttlq4mmRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64lrGvCgkkeZEmieoHxkWkgAxHiU8y5eeKEunXXtENg=;
 b=i1rTZJyuVw/FtHSde6lP/J1Vg4AC/9QAK6GQJmWPKwH58OiUWqKrH+tumWriz8bCgW45C4rHh2FJigbQQp0Qhl5BIF2UZtKDy6t0V0pRUQJWyZlbr1+D3dbXbqd4YhnveFm9fIAIREHka3oNLXzLizSePxeO4RpD3jOM13zoO4k=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BYAPR04MB4502.namprd04.prod.outlook.com (2603:10b6:a03:5a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.19; Thu, 26 May 2022 00:02:29 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7%3]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 00:02:29 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Omar Sandoval <osandov@osandov.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [ANNOUNCE] blktests under new maintainership
Thread-Topic: [ANNOUNCE] blktests under new maintainership
Thread-Index: AQHYcIVYnvGl4Kvq106xCPWiL6TmcK0wRrsA
Date:   Thu, 26 May 2022 00:02:29 +0000
Message-ID: <20220526000228.reo23naarna3hei3@shindev>
References: <Yo6rGhGdccNJXCe8@relinquished.localdomain>
In-Reply-To: <Yo6rGhGdccNJXCe8@relinquished.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea864c87-94cb-45ba-47d9-08da3eab064a
x-ms-traffictypediagnostic: BYAPR04MB4502:EE_
x-microsoft-antispam-prvs: <BYAPR04MB45020067F86C984348A5397BEDD99@BYAPR04MB4502.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Z0cu62xUgnA/iItxlak4YtbtdERKrDg8kcxFCcGFwkh0BjB9lbm6w2FHYsca5wSYWWYX1H+1cjAP18SzVlMIJfB9WWQr/oorK2VJ5kQTdo1r5bndoFxHC4lj5hPG/CHiQlkj/Vx9pECfToNF2ivp+uA/Lqn0gTEeBh+df1cGnSIS8zcIPGwZv4ItpDLGXoOCxSXbVi6U4orSaH4/mDeAQHT5LkBk96OgDhmDO47fJMUXjnrsDZtm1EKQ1B2yqVRKSQW8u5QYgOPfGzg2ukG4dsNe8esDpnRFVVfQH5wKQlywtaarCx9rRzfHA14tcUQzodSofcK3dp08Wxgj4MH2XvkBYA7BUDjybvrgKnWig6vm8kjmHnHAw14cPK5Oak1t1P3x8r+6AwerdOLFCigS2mRWawpkzAWj9sE2Z5MWS0dW4tKeGuC8ichCGhAnRiNBF0TdRPk2MC3ROASr3Fa4quQBIvAk5v6JotBQ03AZbDv/FfLnMEH3tXnze9WyVMcY3w9zkC0iic3YdfVkX525AarXMJI/V7MSIsmRLMnb08dFTVxYF6xwaKdiUUMysClbwuinrG/yyytf6gmo7j1y94FvMz7wE3EQe6In03lCn7ViaknP+bVTnkf2ox17T3pXY/NyyPGbM7RH82eG5ag5UUESsFP8SMyB9yhIWmpXhkhZ5/z+4EByzxKroZDIGUBp3qNJQy0uH66WEnK1srttg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(122000001)(66556008)(71200400001)(4326008)(76116006)(66946007)(86362001)(66476007)(6506007)(508600001)(64756008)(66446008)(8676002)(1076003)(186003)(6486002)(2906002)(33716001)(91956017)(44832011)(54906003)(8936002)(9686003)(82960400001)(38070700005)(4744005)(5660300002)(316002)(26005)(6512007)(6916009)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NnYz1JfWV8n3z7YB5hPOe3jac1j5m0Jb2wP8tvY3kxyvfrTa4aIRm4Jso1RQ?=
 =?us-ascii?Q?hXtMxp5ffUHCXZDE0vHlxjgYvbe8sEGtB45WYB8yfXNFVG3gbRTy9/+0UH9G?=
 =?us-ascii?Q?/lH+em9fbQ/0BoXI2LO8ffZ3+2mKbT1m7BBOZle1W8T2xFvWVw94R66kLwXI?=
 =?us-ascii?Q?T/n1Bf+f9OXefUFk+FnJC76hY7tmtjCt5bKdHXyIh/xQ8NKHpJRbDSanURFd?=
 =?us-ascii?Q?uklfzX4MYQtWiBE9U8ARDV7KEVeBQY+ughMeYw8HS+KIcl0NdPGjkrj7SCIf?=
 =?us-ascii?Q?IkXB1xbbZowQPPTb/OeCLKsY/2bkl9O0HHUM42PAYfgpk6fIc6Q3vBwP92aj?=
 =?us-ascii?Q?7+Qf8YX55EjyDpU38jdrS/YlV8TtLs3KZ5gweeFu6NOFTO7jySUVb8I5LTzx?=
 =?us-ascii?Q?Zbdhk6HKDamGrJpe1mUy8DGdNAb4Y5XeTRcY3ppkQTOR741dv4aqRRKDHPdJ?=
 =?us-ascii?Q?IKqyKKbMBSLDKVWvrB4ea0ouaTXRhBxbt5wneausFx94dfRgcmnb9l7AhOKy?=
 =?us-ascii?Q?LsdlCKhAZQPqtts/pt22S9Pip075XxctDnS2ShGUy62GrOVFbxVUOd0LgqE7?=
 =?us-ascii?Q?kKQsaIczS7jNllGCb8GuRPShLgXuX7w2FOALwvjkmTPsP3SldnKXDK7MUrlw?=
 =?us-ascii?Q?Pf42qqGYtjfCV7HS70PsVvf/n1O1Dd7U+wn1jiCIVBROxlhfndyuUDwDdH8/?=
 =?us-ascii?Q?coPzp5rgJzn9MgskHtFURmU3PGUCFXpk+e7rH+uPjITebFZ3WvtkVtLWODhV?=
 =?us-ascii?Q?5jvNUT6y/nlgTGhzo0Mnp9fakU0jAuHb1VPhpwU5Xio2NBmgC+pX+VcqSVgx?=
 =?us-ascii?Q?UnGyT4yPV1E6cXdtSm/nDCEX3GA8NTkNK/wwG1dXgOR4h40youvIAfyuRJFU?=
 =?us-ascii?Q?Fn2VIHwQuA3G04NBkwwwxKkfwSncjvf1pgSzAHKRtIVYZgLbBLe8plqjIPoi?=
 =?us-ascii?Q?XllhveqpV8KfM++5mArMTmKkb+KQeQm/GZ9toRLfziNyLsLulhrDlBnP6/kf?=
 =?us-ascii?Q?dmuDocY27PksG5a8sSNB8a9ks3z6mM/izjP3blkTDC+QGBWvc5hAWDJn1iav?=
 =?us-ascii?Q?Ru9umutBxRkl6y13vp0iyVcZl5W95sMyjGGdtJxGQVOiNbT7ahnW3whx3GEQ?=
 =?us-ascii?Q?oEGz6lfG6dNsY9vuq2LBbFX1LDUVYcTZ6xKl66Cu3msCgTEn4CQKsBCUmv5/?=
 =?us-ascii?Q?vvqpofvmF8o7KwvOYeNHvAcxC0CfvW+AFRSDcE6nhDwmvBeuu74c5byvHzLO?=
 =?us-ascii?Q?NTvJ5t+iH5gi+ask7ekLlu3xHKSYKeD4n2MtRk8oJUhWsKIzA6NcXsGBu/5b?=
 =?us-ascii?Q?p2HRr3fdaQPkr65g6M47YRVK/n2IQ4HXeRt7hti2PEI8KiXrqJ7rQw7I46rF?=
 =?us-ascii?Q?bKq4VJUjM2tbCbYdLndEpWaZRCjVwarR2tCZQVbHRLSu+cYLIcCoQtHsReZF?=
 =?us-ascii?Q?B3V0uEIgvJMdH6dwKsHKa0NDLTxvJ37jm0M51URO9kLAREuKGUTToG/EMmAT?=
 =?us-ascii?Q?HeAEQ0IAPd84JHQfmEFIEauw/L5EVhUpOB9mol8lZtFkw8vqTKnWbMlQCuJF?=
 =?us-ascii?Q?C5/HkalGcJvOXKg0a1CEx7UTKWB0UdWlwpBcP4uU/umhMCyCIL5jfmzbKMCH?=
 =?us-ascii?Q?1U8UZpZqItnSpF23TsDpg2v6u3JUKPVmWcpd6xYSpgWT+iwMeCwurvWvfWUz?=
 =?us-ascii?Q?O2G7cVx5fV93mZbcCbcD1tVxA1SmExgcRoLNFSKV7wQvJLnzTtvfzgkWRQ6Q?=
 =?us-ascii?Q?PiIl8yEJmIeoC8yQR0kxmGbVRPYtuxWhK+bjmGsKwyEh1DXlSB7R?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <547AFEFE8163ED43B482CE6A8418124A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea864c87-94cb-45ba-47d9-08da3eab064a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2022 00:02:29.1582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w8mcjXw12x+PVO/U2tDFcat8UD5caVDGlGJnKp5bO9zUB+2PjTPkygMIUSyI+hqDH8/e6fYEBnrIMxXu0qFbLg98OujDBdsWAtve4On2Yac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4502
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On May 25, 2022 / 15:18, Omar Sandoval wrote:
> Hi, everyone,
>=20
> I'm happy to announce that Shin'ichiro Kawasaki is taking over as
> maintainer of blktests. I haven't been working in the storage space for
> awhile, and I also haven't been very prompt to review or merge patches
> lately, so this should hopefully make things easier for everyone.

Omar, thank you very much for the announcement and your great work on the
blktests. This is my great opportunity to work on blktests improvement with
everyone. Will do my best for the Linux storage :)

--=20
Best Regards,
Shin'ichiro Kawasaki=
