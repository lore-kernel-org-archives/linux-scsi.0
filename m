Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F14C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 09:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB66B224F9
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 09:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbhAKJVl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 04:21:41 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:40824 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbhAKJVk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 04:21:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610357815; x=1641893815;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7Z2FL0GSzJNUiOJPBj95Mh1nkFLthVv/8KTKk3EYt4o=;
  b=RBXU1kYKJ9BwNMToZix1+cc3tG7UpKKNt81cINXOE+QZjphmCWlxrICt
   ifVBTXh56ozTa1/jmsI09gSVq3IKzQVS99HeZwLY4X1jdrKTxgxVvF8+s
   2zsVdGdk1slkSiVuCrUXQIGXV3Oy5C0XE2ID10A5vXv5mVThy2o+cxzR7
   naRc043vMrc2+wu2U4mjR4SeXx/v3YuYWo5XZZUzO05P8vl+/NOSu0r37
   v+SwXZwEmtvHZbnUuftoVj6LUzQgaoBINrLhbXt6ybBy0244GqKpXNhcJ
   NDlF4l6p6OSWlQnQl8U5U9M1+6a8tvbzD1AfCJMS1t6NmqzuUl2eMF3De
   Q==;
IronPort-SDR: T/kk4JeuL1+HU2yQysOGf3fwTRK1nDvsWmUL4sOxawzqh2mUesTFTB5E0e8PTzy/SPmHFqe+aF
 wpcRTzN+0MDEX71ml9UWQ3hLyT2VNh1F3j9fObXLGiE8rTptlXNY8WHW08DV3IFVODKGoxqNSn
 2cbDdw9oiI+0Me27o6opUq+60scChxVwUfPOY8u1DvoFoUhUA1r62F1OCfykArDCiVGLDi7Q2C
 57bhw/g/FGXkkQ456RyZ0iGfJ3j58+1Gn8ZJGN6B+Fkpy/6gG9Pqb7d997P4rvfp7kYrW02SN7
 Qoo=
X-IronPort-AV: E=Sophos;i="5.79,338,1602518400"; 
   d="scan'208";a="261023902"
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.106])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2021 17:35:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xmq4GfVbQInGk52QsD9DNhVajd8rqTzqBy/TpOM5SHZQshvMV5iGy4mVDu1fzehdWH2UBKxWTTKJxSHEbZmYmFYu+w/WuAWtadT2kRIPLDSyr/4mF4FXYtDRWRdUJcmYC+seyhKCqbkKUkhvlAHcG/uF7UVcqgfKOiGlN99pUlvkYJ3hdNe0369ZVHcdxbMYPuncxl+CoINV9ygqHKBg70DRrNFYUmH4JR4B3lXD45+EXw81KyoWeFtQI57PWeEaJQXK9UbxmqAPbgoayvm8016RsutiEdfD6TksexE0K1gGWP2S9KzxcYFK13DUN/McCzFk/FH0m1I76ShpwfznfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+D2l9P1yZsvyjoLiizPEAZ1Gb/LES46JR35Mj8o2XVI=;
 b=lnfLD9d7ijnSOr97DvD+G9hSNoxFXXupscRXWjdPliojrC/gwG+PuMyjErSkkHilyyPamRHvXJrnrsCKr65TbyTy6hNrPFuaGSiVYz0C+yYnFp31b/wDM+RrXOLmcP+/xB6EWl5Vw4mIrnCuRp23SAnvS6Xl1xesQIb0I2S/AKlXHz9ydbqQp+LxTaFoyBw/X1jWhTo5ncMuhhEpKIG7BcQuaTSYvXlTbyzTNS0BXpP3/52OYj/7vODIDM4s7c5Z/rHhgdDvt1fPmk6Mitcy1QuAv2lBVLFiuqk4uhDP9pJY+YSvQ899U4XkRBhbcnb7HSHeh57alOZSOevoFBd6gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+D2l9P1yZsvyjoLiizPEAZ1Gb/LES46JR35Mj8o2XVI=;
 b=EfMvwtONFJXjfvT3FnMdko+Q1SBCqVm/R/7FI/KmVZrJsdyRS90kBcjuRHrdxTXqHDWgxtodrtAAPTdwOwemPo2akFQQ4QpOy8mkK+rsXiFXvntKHKWe2hu3GFk5sbmfyq5uXH0GwuPBst9DuwtzsArH4tfBqAC+jo+5mYBm4CE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1258.namprd04.prod.outlook.com (2603:10b6:4:43::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Mon, 11 Jan 2021 09:20:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 09:20:32 +0000
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
Subject: RE: [PATCH v2] scsi: ufs: WB is not allowed in RPMB_LUN
Thread-Topic: [PATCH v2] scsi: ufs: WB is not allowed in RPMB_LUN
Thread-Index: AQHW5/Z6dZTrRwC4TUaHBZ6S2NGpXaoiI5hA
Date:   Mon, 11 Jan 2021 09:20:32 +0000
Message-ID: <DM6PR04MB657566F1BB8C808EFBF9FBB9FCAB0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210111084756.1810924-1-jaegeuk@kernel.org>
In-Reply-To: <20210111084756.1810924-1-jaegeuk@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f24eb6b3-62b3-4b92-7e29-08d8b6122549
x-ms-traffictypediagnostic: DM5PR04MB1258:
x-microsoft-antispam-prvs: <DM5PR04MB12587975F567486865B41CB1FCAB0@DM5PR04MB1258.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d/N1+yalypIlQZtwIn7OTAV+rsjkAQLioyH55sfgXye0P1ZWdLiRMuqk+ZlEAc7m0CPfzzcs/Yg87q+k3pBDsAk6ovw/RWaIe0PTz3uM2/RTtfex5AqezmaC2bSxR4SefriyP2a62P5mNOhNwo1Pqe6w6DBnCAJFG7XYdeEWsh1CjAifnXudWhAgU3YN2X1a71L2ECtK6TSX01336wrl7i/mldJt4fqjETF1P3OzUR+7SllTbjNxc0XmJu32pqKwZMBO9rQ3pFDfZ3ffUeeXCWC94LuQXSOpG5RJbDAvkukhIC4+BuQ2WFmb5zsgn3iWbZl84jrqCh6jmcHo2mVe7mJcJuyucSYnhIueGJJiuCYO6C/yXk68OIQCtJypcDlVfNne/54bToEDHnDNcnOKnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(52536014)(8676002)(7696005)(76116006)(26005)(186003)(4326008)(6506007)(8936002)(110136005)(478600001)(316002)(54906003)(5660300002)(9686003)(55016002)(2906002)(7416002)(71200400001)(86362001)(4744005)(33656002)(66476007)(66556008)(64756008)(66446008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?M1mHica6yE3KYcJQZJkUHGl5VetpKCj+Oz+r+9VemCj877aZsq1AorStXF3f?=
 =?us-ascii?Q?BdI8bHFFDzvMJv7bZPnjheNSDiUROOgcZwDRSUwRvU3MVNy6g+i4/MSN/b5l?=
 =?us-ascii?Q?CbBLOsPSm7LTS+cpDnqYUHV2HYmcnj+QIfm5Pi2iC3ERjCQHENxptaUObPf0?=
 =?us-ascii?Q?vXHjTXrR4lSyezxXBlYz5bWTWXmY8kCyzE5BaF66Kwi+Y4mAgzvPqANhKao/?=
 =?us-ascii?Q?p8kSgKmJ7QcI+2LcdtVc4Dwjmc6sS3XwrQqDb4dVD1/lbRizUS/a9CU41RfN?=
 =?us-ascii?Q?SCCJyDOaMIduq3sferiw7J+EEA6DWN5ZxVo9vy/2wwrfQ0KoO0JDoq0pKHBj?=
 =?us-ascii?Q?UN5HzUQHg7s4g8I9ftkHM3n4E5jfyxt7O61Fr1W3TJKuo0nwHLGj7d2RBQn+?=
 =?us-ascii?Q?0ED8H1cWntj8nTDoukgCQpt3aoEmfq7hb0CtbTYbWPinz1a/itP9ACiYshn0?=
 =?us-ascii?Q?VkotL1pIjF8a8YR/SdfUU8Eme1nhvMOLC7PuTgIK5V5ohPqzJcBH+i8p3m4G?=
 =?us-ascii?Q?r4szrYMGlOttQMjN1hq+vwpYct9+L0xgW64ETTTkKTHRI/so8zgK/fWZMyB+?=
 =?us-ascii?Q?t6FHMKSYHP2lpAbIGliDhuzBwfs+yKJ5RRQMUziEeTgdqqZzOoJ9VSHUujG3?=
 =?us-ascii?Q?EdboLSpa6D2r1NY4ecm1V+1U4gz6oeZAMN+XdoFBSmsudKVq+++kO3O0RB4R?=
 =?us-ascii?Q?K7y4K8qnrMSPAwO4OPF1NJRa8NLLkQ78R5itfRjOxbZ7EQReBJ2Npmbo6M+/?=
 =?us-ascii?Q?Na5C8nZpM5aqGOryCMuVjzZAl2rQZVRHo8PIfE0157Jj+IohNrDmAgxFiURJ?=
 =?us-ascii?Q?wvGYwQyjUUx16e7u0pW+4rE/cRBWoa+KG2awVAkQ36LabsVPz6qwk0OWx/pf?=
 =?us-ascii?Q?ddeAx5IKwZG/oRskQikg2oEcyv2KdIYkSEGEbSq06WiRujzAPoWifByulnev?=
 =?us-ascii?Q?ujPYwQZ2dvWEB8TuAuS5ZeMDNa1cT5nIGiA6MYgbhK8=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f24eb6b3-62b3-4b92-7e29-08d8b6122549
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 09:20:32.3050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kRXCal/gMW39/q+D/moqbOmYzGgi4thazTHqvu6xTIy4Y8zIK+YA998Bpvx7SqK++5Uz6ADigX/gliKRNUAfcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1258
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>  static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_i=
nfo,
> -               u8 lun)
> +               u8 lun, u8 param_offset)
>  {
>         if (!dev_info || !dev_info->max_lu_supported) {
>                 pr_err("Max General LU supported by UFS isn't initialized=
\n");
>                 return false;
>         }
> -
> +       /* WB is not allowed in RPMB_WLUN */
/* wb is only allowed to either a sha*/
> +       if (param_offset =3D=3D UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS)
> +               return lun < dev_info->max_lu_supported;
I think here you should use UFS_UPIU_MAX_WB_LUN_ID and not dev_info->max_lu=
_supported.

Thanks,
Avri
