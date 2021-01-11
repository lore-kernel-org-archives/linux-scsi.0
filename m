Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AB1C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3712622252
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbhAKKI6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 05:08:58 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:6404 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbhAKKI6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 05:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610359737; x=1641895737;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iCnNnyN+m7TBfAn3oda6k76r+tp666TIF3dIGknFj1w=;
  b=kzA60HppGWtPIHwZZzcwNkiTmXIzZ5OV0MzxdyP2ULk4dx41Mp+b7FR7
   hk6VzuUZlLwgieozPTCRqivGUZmhw8zxNXlQx7p2vr8gDEPteL20U/e1+
   OCvNeSyNkJwdnm7dcVaorpP0DWbmdv2PtQd6OgvnU0fH6HGJlmbJqj5/O
   +XQQPnrATjZ8/suW0CruZ4Xu16sHak1R9plac8mWuI0FmLcZaS5WRFTc1
   lye22+X2x86uq3V9M4FymJO/+p3FsSX8CVPeVfbDUf+FzT9X/vx76HhJx
   1+WQDFhjjl05RKU82oJUx742IWni3DHXrTBqdOgC2TPCmzRrrjbdU88Gk
   A==;
IronPort-SDR: EdK7O3AQaCp97eYmyrOzC0MQe21E1hSlL6FqnVaUV6Z4nnsqSSzkouty+c0Akk3r4rEqVfYrQu
 Go93onDnDmPc58Bu33BcpxwefnfpIO89YzKJnR99IeDGmxfvffQG1cBtmpLYdkz5amGawn6U1K
 aDHHvQIYgwqUUxYiHcTbd0fDQ3zpFBlfLMs9CifZwqz9xa5sEboxBXVyeiFuWD1Pxib04kijZ0
 OMF1caHUtfEqbRa8pF66nrgpymVRXSk099cMKel3GR13eRa7T+TMGQOiZT5BBPIGpU3YG9yEND
 AU8=
X-IronPort-AV: E=Sophos;i="5.79,338,1602518400"; 
   d="scan'208";a="157140980"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2021 18:07:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4yJfQrdBCtbEQgCJ5+yDY/4hRC+VTfzoT1iMzdphvnF5iNqS7FvW06CztcHktyNwefLoKTbD4b5gYkyxqmZz6gIjm9dTdrI03lG2yTqJkmu4yUton1GtpugAR0A26hxeoyrg3V1CDT6/lW3A3Nag6fc7u25ciTU7PcMqmRCr8v7o39VtvsJ4zAdfPw9/i4Hom5QSZyaQvl+SWtFIHjXO0fw2ACQeaLi6qEIftooAjqmPjvEfcIpuztoUMzpjX8+3sItEiONiStM6y2JIBpLufWdL/Tpjc8lOYHKyEWCHXvtoCJUXz/mBZcjMYsTCwj+aWWpVOz1upzcoTmVS2DP/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfmKTTCelo4SeNdhCLK4y+EL0gSG8j9rDLSAdtz8XMs=;
 b=WkhqozXFzJ9sgLNqX475L8Q+Zu8ae+IsUsVwbeNaWgoqTCe6DMa+rFgSTMLbkS41+zn9BfvMkPX0olzB92XymeOr7Zpf2AxEu/nmHo3YEptCQEN3ml7+p+04Z/T+iTug4JRroAZr2GQ1J8AfbiKsQfnpAU220ImbENgFlR6iZgH87tPk3NXM0T4JuVIHtHPICvnzKC5ysWLWqYLY7X3ELc+ZG+cyxUSBiDxkyXH+DKnPGefia2qILXZ1FBoCMz4N1HMsAari14rVWMpHKZxKxotlpYc73FYNEbU5hdvJu+mAAh5vprwHzuQj7Z10f6e6AqIIJuk69ro2PRqFA6Rbhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfmKTTCelo4SeNdhCLK4y+EL0gSG8j9rDLSAdtz8XMs=;
 b=Hkr/Ni7InJ1gGDHVQ/XMz5CaecmUbegXbQtsx47kL30i64eKlfYY362FG9UhnDV+R+0zoLZ0P0haz4ls/9YbDQfljI7Wy2sx6OmkCi3RakuRLGF75Hbuj0mic2Nov3ZIgH34sCWBuz+lRPuqFVsBVG3BDjvRF7TgNis+9unLvdw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4155.namprd04.prod.outlook.com (2603:10b6:5:a3::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Mon, 11 Jan 2021 10:07:50 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 10:07:50 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
CC:     "cang@codeaurora.org" <cang@codeaurora.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Jaegeuk Kim <jaegeuk@google.com>
Subject: RE: [PATCH v3] scsi: ufs: WB is only available on LUN #0 to #7
Thread-Topic: [PATCH v3] scsi: ufs: WB is only available on LUN #0 to #7
Thread-Index: AQHW6AB4DC+JktXf6kWECxPVufZm26oiMutw
Date:   Mon, 11 Jan 2021 10:07:50 +0000
Message-ID: <DM6PR04MB6575AE5E44E55342A7A66F4AFCAB0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210111095927.1830311-1-jaegeuk@kernel.org>
In-Reply-To: <20210111095927.1830311-1-jaegeuk@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4ca61204-3379-4744-6be3-08d8b618c0db
x-ms-traffictypediagnostic: DM6PR04MB4155:
x-microsoft-antispam-prvs: <DM6PR04MB4155F1079FA975C12E65A424FCAB0@DM6PR04MB4155.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /yyhd0ENJHKAlRCWY6JfWzicynaFSy75OW0BLn0Aej7pLuMPUvHBjJvKir+dCzUS+uzzJrHaPOZeS8Rgpt7R0t7ztzpBVclkYVnuHiorNHbKHJEHk+rxFRSEhcb9O+11CvnF2RlwrY0NAtk1usikshcasRGEU+jsMq4tykB0j3FJaM/2IcDuNKeruhXSG7A9twmqSP4TYspwynMWurdjnqJI0zGFvtXeQF1TfnP2Zttg3I7qoYM/LZrJPiO3gKHMoGzVnSyrrH5/2CaxXl7koIZBM+e9QVC6x2G2C3Y/206naYODUk8A+oCC3H6P4PI62vB6cEh8QzEl9weizIMNnkEMKk4fjb6p0e37fr1HkplOu4/2t8ybx4QciveM5iEX7hFmhqj79D+t9G1CUVi7yEpInNQO+S2bfFypvmUq88U/MgXq7r4wwwbbbmhYroTD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(66446008)(7416002)(76116006)(55016002)(9686003)(6506007)(66476007)(5660300002)(66556008)(52536014)(86362001)(54906003)(110136005)(4326008)(66946007)(64756008)(4744005)(186003)(71200400001)(7696005)(26005)(8936002)(478600001)(8676002)(2906002)(316002)(33656002)(131093003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iPnF2RayxSedO5xnmtDQobSyGXcanTIYvd1G8X7ICSwQMcZF+8+brSGso1yv?=
 =?us-ascii?Q?o1KqemnmJMZg8htOhXYay+7z5JSCu4r3r/ruzb1p/IhejOO19FPpvAxBsYMD?=
 =?us-ascii?Q?skCePyvKVXS5VjAsy/EyW5Mnhd7dh8Ifo4TWftOzlWsVqZXMIc9qd2X7/92u?=
 =?us-ascii?Q?AhK/7DUsIFs45pGRibh5Qz30u9mmnD3rBSvrrMswntGgGQGGGRoeN0QxW0Lj?=
 =?us-ascii?Q?ueobY68nhgvEUAbB/KIp5gj0C9qXUx3aiUPISJ3dE38dNW9pAFK/atbhaOQP?=
 =?us-ascii?Q?rYj15FQeu0cuPSDNkaFrMNF7i0d+mEE+DIRCqeP4h/eWEg8eKU7iZ37O1f17?=
 =?us-ascii?Q?HOE3Erqp9VJOCpN3bxqcho5k0JpjzOeomD/VqjJq0IhlS64wgZwekjtANeZL?=
 =?us-ascii?Q?Vn8o/x1nVgIougNa8pf/XHwfhLyJSMfl8DaBe6dH/RKQtuq5AQdWLJcResXU?=
 =?us-ascii?Q?QLmaGI+AKtHqqROp1PtEzKAutRCuCtjyPgnYgPuAqVDzwyvo3AopMkEP/1zs?=
 =?us-ascii?Q?5wxVz6KQlKnraJGz8omtMDT92cjfdjUbrWPX0Luy00t+AJ5Ddk6J5LvBxKkx?=
 =?us-ascii?Q?9o1BKSUqtgMmeaKB8dEcF4NGKMBZDsPjnRfWKJd3LdMoZ+Ot8E551bXdzpIa?=
 =?us-ascii?Q?w1CL1o/WJc6KHGswtLJHLgIKDjKWW4eEBL7rMgLirnelxfI+3j9IkMvBz/j3?=
 =?us-ascii?Q?1NDKsbaJfFcIaQtwHufnnYivSIU4cb8I3RLJ2DFSYmvh5LkX9KhYkHFVYN0s?=
 =?us-ascii?Q?ZpDJ6vnlKk4HsziGNVA6/OxbJBO6Dy/8hr25yIb6ntW/ymNXXnau8ecmCGvC?=
 =?us-ascii?Q?Q+hpGs0WiE/mPh5CrrwhahuuNHgdKVTUqlzcM/RRKRx9enII6swfgwg11aiV?=
 =?us-ascii?Q?Ewe0mb79kCLmeE8Qg0aq4lXCnfnfPqL22Gu/8UsdaG2Vb1y+wz5DHkiKTaHi?=
 =?us-ascii?Q?wAuIor7SorM95AjgEcck85P0spV474L9dsN9ih1aWrM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ca61204-3379-4744-6be3-08d8b618c0db
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 10:07:50.2676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BCrCWFSwnZXzHyGM5FdVnV6u2VreZKPkdCQt70xH9irb3MA4tkXd47Fj1CUbT/bi3H4pSK1J+GwG8EbQewcEVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4155
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> From: Jaegeuk Kim <jaegeuk@google.com>
>=20
> Kernel stack violation when getting unit_descriptor/wb_buf_alloc_units fr=
om
> rpmb lun. The reason is the unit descriptor length is different per LU.
>=20
> The lengh of Normal LU is 45, while the one of rpmb LU is 35.
>=20
> int ufshcd_read_desc_param(struct ufs_hba *hba, ...)
> {
>         param_offset=3D41;
>         param_size=3D4;
>         buff_len=3D45;
>         ...
>         buff_len=3D35 by rpmb LU;
>=20
>         if (is_kmalloc) {
>                 /* Make sure we don't copy more data than available */
>                 if (param_offset + param_size > buff_len)
>                         param_size =3D buff_len - param_offset;
>                         --> param_size =3D 250;
>                 memcpy(param_read_buf, &desc_buf[param_offset], param_siz=
e);
>                 --> memcpy(param_read_buf, desc_buf+41, 250);
>=20
> [  141.868974][ T9174] Kernel panic - not syncing: stack-protector: Kerne=
l
> stack is corrupted in: wb_buf_alloc_units_show+0x11c/0x11c
>         }
> }
>=20
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
