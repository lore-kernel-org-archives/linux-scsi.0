Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FDAC07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 06:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76ECF6113C
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 06:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbhGTGEq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 02:04:46 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:15847 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbhGTGEn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jul 2021 02:04:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626763521; x=1658299521;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vIY6c3T0pZZeZEG3fUYiJqI8DPmPSxwFNfmGmc3lOwE=;
  b=l1qzulW4kEkWIQsm80/+vny5Xq9Eh7MDwBtGBOsbvWQGtZRlyvbnI0mB
   pcLzHnsUkk+2jyWqhU4YFF5ciuV4L40fSIEMWcY0UYLbkXzjujebLVn3X
   799n56LP7C/V2KAO+IP5QAAZ0gEtcMz53XytLDVmFBj1Z2eJ1y064/5S5
   XGjWauTRLEk4NRBTuqll804gn0EkBAm+JGi0d70RO/3ImUOQeK8zOUZVt
   1Z03WehHhFoOL1nJUpY7yJS+uK7/dc7hKXYT7HMO+uVl9xnhS7MHa2/tP
   Cd8czn4PqWEZlBn0EMeVvL6ka43F8lSqYSwT55vCDcow7Uof1xKkmV8BJ
   A==;
X-IronPort-AV: E=Sophos;i="5.84,254,1620662400"; 
   d="scan'208";a="179823423"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jul 2021 14:45:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPcXcZ41I+5HWF5eCiwRlPvb8UlXO9hMH7hHpR3Rx7F9f7ijCG5l+bUvAIxQxfzGAaF7ZLFIsPggex/P8owuvkUOnEOVV29x63aZzukNNOPUa3gbIUhJRmGBSF0kdvFDTm45ZKLzuEol1hlcLw+i3AtUJV5GOTRsA6yz1YHALwHMqYycmp1dGBK52shPCQxk+I5qYaYjWxceHUpNQjL2spTleB0sAk+vBqqHoecG/FPNZIH5MLe81UqHNHOnLO90Glcy3wimgsWYhtW/KGls1Uys3OxfOjCYFwWGtP8niyTRkTnRZX8MnQDjiJBJqXGOShthDxhpRIyuV82S7MX5cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JF6OER6tsSVJvtAwNuXwLS8/kdzVGyFj6MiodU/CKE=;
 b=G0UBNjysYpKbvkTG/PgQM2/hq93l4NDRVcL/US+3WWuIgRA0A3F0dsgvFkhmhQfbU11hhxGqt8V9/qgjrpY8KPfwXYzNGjgMbkqikroj7mg3DOoeieModVPxs1oU8K1crAbdmfB3NPm0X3T4aU9Cdk88c1vq7lW7AllqXnwkbg/GJI8Itcjeu+6EGm++Qj8KdgeGxyBM5dVgfXwvoEHp+yJ3pQ00R4cnynz7bXn0HWaN4TbrQRmBthqrSljuaVN7eVoKkImaos85BWGoAZnANOOmGQch8YtdUhgyaCCyDg/0kOCyOjz/RQ2MTtvd49dv9fKEBfv3/18M21Ur37GAbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JF6OER6tsSVJvtAwNuXwLS8/kdzVGyFj6MiodU/CKE=;
 b=mq7fRCcibQTl3NU9tLr7/BI6psn6RfV+dcKFQLpModEvBFK0q/l/hyKiNXu1uZPSpLwbFMFiOHQC+mykRPk6SuUDk1vhEV2RAkii0fYMiepP8TICEZ22gkRIl8GoGns+3hSXMHoX1Uj+sVrSVvHbMKF2R5j354uiMknaxDw/N8o=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4844.namprd04.prod.outlook.com (2603:10b6:5:1f::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.31; Tue, 20 Jul 2021 06:45:19 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 06:45:18 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH] scsi: ufs: Fix memory corruption by
 ufshcd_read_desc_param()
Thread-Topic: [PATCH] scsi: ufs: Fix memory corruption by
 ufshcd_read_desc_param()
Thread-Index: AQHXfPNyLhviYQj6iEKHnRE9Jql/nKtLartg
Date:   Tue, 20 Jul 2021 06:45:18 +0000
Message-ID: <DM6PR04MB657554CAD101CEC0FB71E68BFCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210719231127.869088-1-bvanassche@acm.org>
In-Reply-To: <20210719231127.869088-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e95c1992-0244-4e5a-1c56-08d94b49f089
x-ms-traffictypediagnostic: DM6PR04MB4844:
x-microsoft-antispam-prvs: <DM6PR04MB4844D243A2F83C779838613EFCE29@DM6PR04MB4844.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b1I06FrJpJHpfivzdazwPqP++NFZs3QDDKWqLzB5tuBnQ+lH5pTg97uh+ggM5pXN8+T19G1Mi2KLijCgsiTqW5vXF2qkfDCQOnJHoLYIAOi17UD8fEQeizxX9PzWPt5U6VsphAmI7zwOmbGIDrpPO2fz4+akqIf80Qwp8iJNamO6o143/NF2N+KxrjxgofZ0IegKlTxkqZ0l8vy+obQuAGz+6be/t4TiTme1BG6Pp9uyhfpKEkNgJ7eC/4Ec9JAYD7EMhddJfs28NA0Oe9UKrXlq7R+NrqpAtebsg9xun5KRx1wbje2JelD0AdtJE7jX0baV6SBfp9IyEJs41jSXms+XHCD+fzzFKHiAceKDjx2PwjWJ1j1+jazaoSHikjX62nnGcG8ut4bM2Lp9P8jGqWBahDKzHmp6bPOP+40zUxRcjmaQ0jiISWKFLmx7I1peNzpdbGO1icoslIdG321wtSu5xmR8R2cXwHjF39YJD28i1vp6qHJEdk0A1sFVIcl9QDTnEm6JEF6lbDneQlGvNrqJlTRtm2BrnzS+Pq8XifiUp1WmXV57v3ZWzr8STL0FqsG27yg3b3Cp2pXvG8xxdPkx1ecm7BpzFcIrPTRDkA/C5bVSONn8s1dUb7jG4T9V4lruiiUhAvTjWBNO1CKZEiNe3FFrUqmqsOgFgGApqI+8NK4LVNLf8lrENfWzysOqyU+tkoPshk6Em2FUVMiFAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(38100700002)(110136005)(122000001)(5660300002)(52536014)(83380400001)(2906002)(186003)(26005)(86362001)(4326008)(9686003)(66946007)(76116006)(316002)(66476007)(66556008)(64756008)(7696005)(33656002)(8676002)(66446008)(54906003)(6506007)(478600001)(55016002)(8936002)(71200400001)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jMd+MBqlYz/h1gPD9HObXOfsUI+c42SZHhm9nYxQwaY3EgYL6JYWUIn8efFl?=
 =?us-ascii?Q?yPLrUjkJKcXKCpLeIjdA8JLaEqwtByM95iE9T0He3o96RycL238hB50zma7v?=
 =?us-ascii?Q?WGz1ir9VrAympwfV6RCNuYdWR8Alkqmr04Wcou6+KuIxTzv+TpYpeipILyKn?=
 =?us-ascii?Q?/l1jqJTGnngiiGLsNAC55EHfW9iyTigImDTc9Sze7q8t6Jv6C3QYfdi8qMaD?=
 =?us-ascii?Q?55v4Z0AERHxnvxCb618ntknrQxj8BkjzIKzReyNCGJwtlhMzBGVyD6N4I4Pj?=
 =?us-ascii?Q?vUqo7csebGQ+xWFkGXKqQgLS6M7qJSh+emDxvaDBqh9WSQ/zHC/F62DMNgF6?=
 =?us-ascii?Q?ndQfCho+ms7xxyDIb4Eg1DJ/UajUK/jJbZ7sYqfYgB992+hHOUcWp+BUzO23?=
 =?us-ascii?Q?aEeFChOhXhtJyomQaxz4AOiar61L/+fXwGmkLO+dKcvhRZV05w/qvTsCWlce?=
 =?us-ascii?Q?7zhHsN9ZVbqvrs8p1/2KrQitCtFnX5yQ8d3MaqaZ3XqgojDZ0LNpjwUC7/bQ?=
 =?us-ascii?Q?s+/eQkrcd2MnxRu4MwOT51MkeBxvb5TN6eOzan+3S7PlhmwK3/hhybnaM15k?=
 =?us-ascii?Q?Xe30wxk6s7LGWzFSoazhKc/VeR1WStrtlkxIuzhQ8TiXdHZuznYxiGhJa793?=
 =?us-ascii?Q?cXIu6S5Cb0W3EBueBLdDIgx4KlZxEcmmxM/QLbkkXtSy0froJWDa7lNArBo0?=
 =?us-ascii?Q?/3S1PK1eeqoODKyEa7jduxI8zqVbVrJaZlOX44gTEkeVlw98Owe6hJb8n7wy?=
 =?us-ascii?Q?+2S+3qFt+rguNk9f3flevdnJZKju2wDx+KmNncE2utkYDPp3CokEcUg1dPMa?=
 =?us-ascii?Q?E9l1pI3ALLn/sqOs3dbtbTtIcH2gB6detr/fuLA2/bB8lLYbcgoe6bm8bBZF?=
 =?us-ascii?Q?9hy1C3q5mlV8UGTBU0L0UE5FSlPdPSl2ZRitw2D/fHcydk8bh+PTUMRQZ28X?=
 =?us-ascii?Q?AfoXg3rHyYjUKQcEA+c/hCJ8NmrhiImVePOYYPgn15TWsJvmIAtlHF7Bhvw0?=
 =?us-ascii?Q?S6mwsRHRubOAFkg0fxS+XopUb9u7TJUbKoBuvCmElHwV1kQ7cdFUiY+OEX6+?=
 =?us-ascii?Q?ap/DrIgd/D4C/HmctwuBf70soqGvKDZ8hEZQOGGMoCnBUFBIZlsWnp/8Z9i+?=
 =?us-ascii?Q?eGdhsLi/3QXMzb+6BUTqAufHbMLWKdCCePu8StnTWfcFCLza1UagFcx/KLZ8?=
 =?us-ascii?Q?Jj1bcWVKfIv2AUYUd1mabeb4SA7vQV6Z+slBhVyXs7oh/Sfd9TsffAX4qjXx?=
 =?us-ascii?Q?pSv9nLXwZNChdJ6xajyWQOWL9tmi5xnNjqC3R5tL/nR8QVmqFUVK+TymYfmi?=
 =?us-ascii?Q?n8tLSvP2iH0bb4IlR+Zra8LV?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e95c1992-0244-4e5a-1c56-08d94b49f089
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2021 06:45:18.9321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bnmom8WHonPkwVyDv9+rEknmEGu5F0tnK66dDE4Kd+0LZqbQ+JoT8q/P1tSXDJ6nAWVI8mgW6d6pj5Hso67fHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4844
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> If param_offset > buff_len then the memcpy() statement in
> ufshcd_read_desc_param() corrupts memory since it copies
> 256 + buff_len - param_offset bytes into a buffer with size buff_len.
> Since param_offset < 256 this results in writing past the bound of the ou=
tput
> buffer.
param_offset >=3D buff_len is tested in line 3381?

Thanks,
Avri

>=20
> Fixes: cbe193f6f093 ("scsi: ufs: Fix potential NULL pointer access during
> memcpy")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 89da2cf2c969..00502ffe9b4a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3365,7 +3365,9 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
>=20
>         if (is_kmalloc) {
>                 /* Make sure we don't copy more data than available */
> -               if (param_offset + param_size > buff_len)
> +               if (buff_len < param_offset)
> +                       param_size =3D 0;
> +               else if (param_offset + param_size > buff_len)
>                         param_size =3D buff_len - param_offset;
>                 memcpy(param_read_buf, &desc_buf[param_offset], param_siz=
e);
>         }
