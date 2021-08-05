Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4B9C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 06:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0563A61050
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 06:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhHEGgC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 02:36:02 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:18384 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhHEGgB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 02:36:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628145347; x=1659681347;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1mC1jv4AnmuLHSweHyjPT9qCK5jwKZdPgFGLWXnfw4Q=;
  b=jGT27xdQZjinuEPbHYy2aFEoD2MUwMx0QVEGjwt6aaheInkbJH2bm05A
   zQHX/yGt9DoOLt+hF/wWPSQi6eFTIAlpd2qhlPrhQYZ+vYi363Iiw1i1D
   SORGAxZzL+lOtXEdiurqKbLU26K8a0/l1rfEawl+AjL4c/ydO9NDbg4pF
   gO8udAHP5pQ3mO8lfxSvrCiSRI1eosov7ltjLkDXCWRCaKrqgTsIDiqxj
   FNeSVG6nQMzorz6IIqD/ZT/PV9JcAmGje/Jmbz6nIM11xwk4huLrInBMH
   xsKVVzgQ0aKQiP/n+Ip/zCZ2WRwcppCvby3MKwfjwlo34IG9PnRCIujnq
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,296,1620662400"; 
   d="scan'208";a="280215639"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2021 14:35:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OorktE2eepOXT5GWq2qR0vaB40SQ69wKIVWYeqlRqaV+PhLoWFe3+cwfxVWRbVNsbmGbwt+QdrihHnHWAhlc3JRU/yLCyvIeFWYAEOtpbXH3bVtRn5HTlLnDLDjgSTl1lqJcViTZbegsxIcNWREX+I9iRaDwLPXHldODIz9QXaP837NWqAMNz+Uk52mNH2jPedGRCgNIh8/WR1JRSizRTRHGkzsWF33uxgR/RHzMGyBhQFYonZKLUVEcGFOXkp+KNpxB46XMp1mdOc8ci6VtCB0zX2UTUoc7uOrBqB2YaarfW711DU+OsgWAb0/h2pZz7QmU7jTxApItWfALosCYAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAMYT9uYkzdYowMlnHbiYm+P5kNC0WYp0Yk7404EveE=;
 b=DFYjPg8ovPI96aVFJdF7Z9CCOMrqPeCQ2AjYQWG15TbVxxBDMUcvis/jQFaM4fchAU0eyxjcE/4gQL4RbU89SDyBtZ9nF8moKjC3Px0hekqkEFQQ0R4jUQXVTO1eyf4EtnauXyhblfueWFKquQVTrPDQeQixDCG8zTv++ucaaW8sdkPI5V68T/HlSJCRJLYKNe5WzqjGXxwvQGA1U97NNAleGpyDWhA7G+GZuH3bR/dLZGf1ze7UAns6TNo0J/AvwkCI+xClUtaLbpylr5+hnLZ0Lj3dCyr0aJZ/oF99eZ4Jim8OUNd3FS0lKej9MSKlEDVWvrZ+1IG7+LzWXFAocg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAMYT9uYkzdYowMlnHbiYm+P5kNC0WYp0Yk7404EveE=;
 b=h0p/9VJ21x0tYAxKQse5Hde4vmoCSgMb9dLHD9T9YGJ2PXYvh3au8rhz0Z/CejER7THtXXwo8/X5gOP8IUCiigoNFT81jVFK6TiCpGvI48pi6vrMvFLyfV9Ax1eF9JkiQm6IpRA5w7aHh4SPqbFnpKdJ9050uzNHOkc2OOlXx+M=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1132.namprd04.prod.outlook.com (2603:10b6:3:a4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.26; Thu, 5 Aug 2021 06:35:44 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%7]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 06:35:44 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 2/2] scsi: ufs: Add lu_enable sysfs node
Thread-Topic: [PATCH v1 2/2] scsi: ufs: Add lu_enable sysfs node
Thread-Index: AQHXiV2VphT64o2uAUWAn60TCQgVQatkdSMw
Date:   Thu, 5 Aug 2021 06:35:44 +0000
Message-ID: <DM6PR04MB657589C9EE72DD8B4F62C6BDFCF29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210804182128.458356-1-huobean@gmail.com>
 <20210804182128.458356-3-huobean@gmail.com>
In-Reply-To: <20210804182128.458356-3-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f8d0e8d-875a-4b71-8517-08d957db4090
x-ms-traffictypediagnostic: DM5PR04MB1132:
x-microsoft-antispam-prvs: <DM5PR04MB1132C22105F9493A4DC103A2FCF29@DM5PR04MB1132.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:341;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oG7FxCTDETTQCu//vmc6tlQDnitkdzlsTA1ULCu463balA+n+eNJlIh7c1v1KxECXjEftpR5sepc728pzZbMVlbHJVSCzjAS862FMdafPmR1dqG67IbXddlEGwwXFRzRlCL8ogDuqVBT+Zjzj4jgrQ1DAyQXVLGuODWL3kkCeoWD1/DFi588W9u/hmYtUpfi4etPVbUvxbxr6HE43qO8AD+ZaonCmCB5FXmQzVZnRnt+rrSGb2HWO4skxYDm00SHnUwPdgUQPCQXfpLDcE/x046bdcY090U0rNikmN1i9lpRpDF3yKcI5JyJhIKZiUVCm2c0Hf+YidLmOaeCVsLIg5XBi9mV5SZeQ8WiXFtSyQyaI80oQr9DEAbS2dwzfYWLsL4Tt0Sx+PUwhVtK40E42Pn3HS/iOYq4NVWP53E0jYUmNvS4UVuU3Fh48Bp5PEwVOxp8l77QbBiVbt/CRNORhRlzAvCPu8iOcVApTT40tUAt+Ajk1irlhlynDKmO+4AZ9T+MJXWIf9AP1x1qCa3jiH93oActwy0mJUfkpeIhEGKTd31xCeNxYNYcBlcnIgRAyFpDV5xl+dFRF5reWp/exD4QrTe3CXNan6YQt5rj1D1lqB8q1OkzL+s7w/B3GaDhQeZOJODwhs4N1XxayFnOkRfwR8A+54ERsaNtsfyagrJHtKVKrl/Q8Iuq5s/K27L2+UlXU6T0Fxcw+bXAzwTEN2hBT7OrcPnHj8Jq1o2tPTg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(52536014)(122000001)(76116006)(66476007)(186003)(478600001)(66556008)(71200400001)(9686003)(66946007)(64756008)(66446008)(316002)(54906003)(921005)(38100700002)(110136005)(2906002)(7416002)(38070700005)(55016002)(7696005)(5660300002)(33656002)(86362001)(8676002)(83380400001)(4326008)(26005)(6506007)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/lZiKPaxGiGInLqrf4Q7+T07V7bVOXjcgehIGRlU6cdqo8XyB4tBdYBC3w6K?=
 =?us-ascii?Q?Drtkmo31RVKgF2yLFen0I9vbNqleFOjFNv41uShM9/aEhGohu55bSRRzoiuz?=
 =?us-ascii?Q?HOu08XAvm4s582Hm7cvvhk7u3XQRoIIpwFj6HtqAaGrY4MiE/AnQ3+mskjaB?=
 =?us-ascii?Q?8zIV4hGker7U8yxqj0+2TgtEGfSJ0yyelV5aX/YMHWexs2lSMZkDaLQ6hd9n?=
 =?us-ascii?Q?vHg88f1FOFgxktwFi4IDPdKqalNPp3B6jHSEsoPp1fGhrKQVymojW1Nx5tOB?=
 =?us-ascii?Q?y4x76NE0mOVQosf/y4i1RaIGNfB7fYTryGBEnKL2vl/cWRCJYnpwtsChuW32?=
 =?us-ascii?Q?ApGIplVFF5gZo681U0EYY205Qf2CgUanZHuUAUrULV0KdV4ZaKpNw4m/0moF?=
 =?us-ascii?Q?wA24O9XtHV56SB1hxGih2OMgXkSmG7yT4Tt9dz3bLoBytcGzrKo7Mce9ucTm?=
 =?us-ascii?Q?6fvYY3m2ZcBtvisZ2z/Nwsum00p3skNijjrEwBkPtszB82fu/t9CV6z4i5ur?=
 =?us-ascii?Q?9k3v94ZbRzjZgIZCAVN02GqZOb5WagpIRcEPRldtD+nk+g0M04lfvIqvG3O3?=
 =?us-ascii?Q?EGW4rbeLz9gdZ9ioP01n3lzqj8fFwAJ+K1hQ6bBgEkTgZ9aRyDao9u9jqTnt?=
 =?us-ascii?Q?cw8AetmEGLRpMitAcUwe/a67A0jMIidIpLfDvhLjcn4N0neJplKOTJvafs/z?=
 =?us-ascii?Q?SaLkuACqk+xdHcUDVPeqEtdPqGGAq1tSdMqOe7XohY4lN3goxGPH5Sw7sx7k?=
 =?us-ascii?Q?1GWJACckkxyAO9cKnte/KupwtFVFkTcLB2uKWYUN3LUChlA3mHUKOEmM7FAA?=
 =?us-ascii?Q?p/1ZDcKc/U5FBA7aqwT2I4B1HdgdulFqVZ4eoJ/3DB5TQHIoVekKMwtOJl5N?=
 =?us-ascii?Q?tK6o9hqsr23hSTqd0H9YTZOjP1tBCrG6O5xBgPsgegTtbkRAhetp+g32i8f2?=
 =?us-ascii?Q?v7oBh6C8DO/VcMiFNGP3+/r36g1WDcstfuPDnm1pf4IS1Y8jxTy/menaxpHr?=
 =?us-ascii?Q?Pu8MmAsC94R1A7Qmfp5x3C6fTg09BTXQibTqyBu7tWeBfny4fxy9PyoHSGYs?=
 =?us-ascii?Q?UVt/yegHKuVpjW8qvQr7OshsAEk6V0OVusPvyZkcPdCxptzFSTmgDRWc7IMo?=
 =?us-ascii?Q?Poz6UERaC5bH7dMU+3RKVpWT7f0YUk2RapYmJOzP8wHa7LFHy1wus5OPO1LZ?=
 =?us-ascii?Q?xNfUVtKSep0XNXadMq8VhHIi0Y4fTd1u4kBSGT1/Yy7Yt8RrvtnUrzvfgAD4?=
 =?us-ascii?Q?qRj6+eMzEyxPqd2vYHuWvYU3TpUR8PE99UtyeW6tcMwT6nb8UKk4Km/Na5sk?=
 =?us-ascii?Q?oUnApiTGT85njj54+Vld3BWX?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8d0e8d-875a-4b71-8517-08d957db4090
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 06:35:44.1397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Obg8L/KQXh/SphglscC7kd9p28rPzWEXjflBku5uovYpJw0Qdg8bqc/jU+HrAgi4QJfLZDc4tHwxp0Vrmc8C+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Bean Huo <beanhuo@micron.com>
>=20
> We need to check HPB being enabled on which LU from the userspace tool,
> so, add lu_enable sysfs node.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Tested-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufs-sysfs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index 08fe037069bc..5c405ff7b6ea 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -1163,6 +1163,7 @@ static DEVICE_ATTR_RO(_pname)
>  #define UFS_UNIT_DESC_PARAM(_name, _uname, _size)                      \
>         UFS_LUN_DESC_PARAM(_name, _uname, UNIT, _size)
>=20
> +UFS_UNIT_DESC_PARAM(lu_enable, _LU_ENABLE, 1);
>  UFS_UNIT_DESC_PARAM(boot_lun_id, _BOOT_LUN_ID, 1);
>  UFS_UNIT_DESC_PARAM(lun_write_protect, _LU_WR_PROTECT, 1);
>  UFS_UNIT_DESC_PARAM(lun_queue_depth, _LU_Q_DEPTH, 1);
> @@ -1181,8 +1182,8 @@
> UFS_UNIT_DESC_PARAM(hpb_pinned_region_start_offset,
> _HPB_PIN_RGN_START_OFF, 2);
>  UFS_UNIT_DESC_PARAM(hpb_number_pinned_regions,
> _HPB_NUM_PIN_RGNS, 2);
>  UFS_UNIT_DESC_PARAM(wb_buf_alloc_units, _WB_BUF_ALLOC_UNITS, 4);
>=20
> -
>  static struct attribute *ufs_sysfs_unit_descriptor[] =3D {
> +       &dev_attr_lu_enable.attr,
>         &dev_attr_boot_lun_id.attr,
>         &dev_attr_lun_write_protect.attr,
>         &dev_attr_lun_queue_depth.attr,
> --
> 2.25.1

