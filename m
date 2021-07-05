Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63ED6C07E98
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 06:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49617613C9
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 06:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhGEGtP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 02:49:15 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:3648 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhGEGtO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 02:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625467599; x=1657003599;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7tc3DD2XeZDyQQukaAGOZhIhHtQkuJZVQADFdZlSYvc=;
  b=rq3Y6TAnFVJ2CAW6qSLVjQ9MkZ0+9YVxE+Fu/737R2xF3c6PFLwGkADS
   rbvs4pgRciX7b45EOxfa6WIHstIqCwEcWOUDNKT3VbQ8sPlOYroYx8BiA
   X9gD3Zv976LbdCI2kK0SxRkOFGm9Gv2uXP9oC2zrP/2I87sLiXHRw2M7Z
   ZCcd4fyKPUH9GQFoDAue35fhE5+ZUW78Pq/VtDPvjgRKiYy1PtpBE1uWg
   jMQrrivqU6oVOz/AoytHBF2klun7Dvt3vKzI7B9rxgxuNKSliRO7iW85U
   oC2iouMK2PVzpb2EMAepYfx7tXa2cVGfYy+ym22/K/S2BHXxZcO6nXiLK
   Q==;
IronPort-SDR: Zf7Liaq+z38ps169jBy6MaXf1g3SWwdknC5hYPQR6ErDs6ZcFk7LccubR07KBTv6jVml9+Vb0J
 az6BAxxNe+PpRA33MWNTa520gD3pd/QiT2K9fZLp0KhfAQbTQGP8J3oaQqyCOwf0R1+QFB9Tnd
 S/t/i8gnWIw/4eD+c56j+KLaHOmRyhPZNjVuwn9OqKJnvT7zQI2YLUi+9lOO9Z/Hf7aMWMq+qJ
 G5wbPyOjDls7K2oKiCt5Z55cTfTM4Sx3eDqi7ahNVYq5QXUlC7mWeoZt80nz/XJBct1hy/lUd4
 udI=
X-IronPort-AV: E=Sophos;i="5.83,325,1616428800"; 
   d="scan'208";a="174285583"
Received: from mail-sn1anam02lp2045.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.45])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2021 14:46:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3G+B5BGxWa8+GYfKiYDx23cGAaCaFpO6nyPEy/dF+iI7nuvf4WUqido9K3Vc5EPs7E0wTFy/eTNDzc6t5wAT1nhF8B4A4ITkDKwYWRxHyuBRDL6i1qXMqDDeVEh04FHaGH7kAb1D//a8y1PnJGxnmTYRo+l0bT6cXYvtOLj8Wy6tfzf+efPgxD2TmzsM3hHq1zUm3m5QqWR4ptAvqieN8n/e3si7mjWv6uFpqPWpu59bAcl6OKD5WrfuGusNMn0T1+sZpmvEITIh0217BP6YwHjLeoe0KseWP35gvTwBz7MXdgU/hsy9jJQ/unMapqYcD/pBZ2SQ7Q6N6YN0jv9nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHG3hpxpUyNA7g+n8hQWR7ZF8HFfPtdzUtGrIuihrXU=;
 b=lHx9Ar0Pt8cLvKHzAQ47MVnyGCFbeDgvJOwhxY5CAii/+XUI6ljZJ1AP+7OcgkrHqne3G0jdCGxX4kqhlG94RTEbsBtFZRxXSFPuZ+I0kxgHGY+n3CWw9jSSWiQsvusgrceJxMMhDLpr5ESeaQid9nwBhx8j0Q8Lxs3EVqLwSVLMraoavAQuM9Hsbfaqk/IEW7qb0QDraGqwqmgt2mIgYRrSPEJBae7d93wXuBW+zx8w/EZnNCApK6maUNnX2CBRG1N6lSolQaONNXau117VAuyUlEHy8UA2JXc4sdPPZkEq5vQCE3cd7hcmh4kacbIBKhjhx3MW9/2+LlPS5GQOyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHG3hpxpUyNA7g+n8hQWR7ZF8HFfPtdzUtGrIuihrXU=;
 b=gU1vM6QxxHnOUVg0Vr5Bhg5wwmzK5xtAi6zpXzAsgx1FDu/cIw0XaN/cJqH99Hu6/9v5Ttqk0bq02LB22hs3B2EFBROfOmwjsnSQvxLEDVtsTZzbh+B4/JqbS1naQw6e7GSExk4/Fz/bmgXC8MuLEo61nMSGQVB3ywuk0Z3hQYk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4028.namprd04.prod.outlook.com (2603:10b6:5:b6::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.22; Mon, 5 Jul 2021 06:46:28 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 06:46:28 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 10/21] ufs: Remove ufshcd_valid_tag()
Thread-Topic: [PATCH 10/21] ufs: Remove ufshcd_valid_tag()
Thread-Index: AQHXbr3pDv5CHVQeGUGFucgjqmDRHasz9OVg
Date:   Mon, 5 Jul 2021 06:46:27 +0000
Message-ID: <DM6PR04MB65756A3574F7857C2217BCAEFC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-11-bvanassche@acm.org>
In-Reply-To: <20210701211224.17070-11-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fe90589-0b1d-48b8-c6fc-08d93f809d7b
x-ms-traffictypediagnostic: DM6PR04MB4028:
x-microsoft-antispam-prvs: <DM6PR04MB40289F6ADEBB97B39DD13870FC1C9@DM6PR04MB4028.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /7WC9wFKRZMv92qIsHc33nAfX2jq3lMr2NOSnAFvO8ZB3OmrIIduhtfF6u+s4GqDVgfgvLNTADNq/27SRuVmioyx46T5zuqJNZZrZXHAgCQ57d5ABYhFEq4S7hhLHCBMBm6drMF8bng1DyLWnt7s2bIX+oOzoEzqa0VQi1s7uoYKaC7PDmMRtMksHRTsMkuk2yMS+FAHqAaUNRrMhqSbuvOnBVJ2PEZyaduxYCTb6n3AdK5hBLTDANtj5gEQ+TgPK4QKrUVzGzUGnudD/m2fl+bIiRdf+u8iz1YHfBZEvAPDZKa1m3zLKjSS36DNyEdlFZbsopl6kFUZRY0NhLrXTDkNzvzvbp0Haxtm9+f6InA+SeV4rg/XdhE//FzX4DKk2/o9NoRzstf7QTa4EqV3L8a1enuXiyiakFDC95XuHi2upqDrVdHMR8/cHYi0QMtpgNClIiKzRfXfx0kpFIgtInW2+kxqDEIPyd1+1Ry1KmxeMqSXbN4gWnw/U1H5sTye3T6r7gftD73carpYE9yLrKhANDoAnXLvOyT6QBwJmW6W1esvdT7drpqB9k4mCEaNiED3rS0TEVWLOrVURzr/AoTgBnouvg1+aw+j7CzrZgm0l0NXqk+rpXwkfEJqJgICPQW8ss2P/iAHsOm6eecGcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(110136005)(316002)(7696005)(2906002)(54906003)(122000001)(4326008)(52536014)(71200400001)(38100700002)(5660300002)(9686003)(86362001)(55016002)(33656002)(7416002)(8676002)(26005)(66476007)(83380400001)(186003)(478600001)(66446008)(64756008)(66946007)(8936002)(76116006)(66556008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pK/csJNk0F1DpEwIrQfycKdakMc3sm4sZQoKc9CiNvz73jPBskTkxYo3pqyd?=
 =?us-ascii?Q?AMXfDgJSMvEMqe0+k1LhCNP5aJSatcNNDMiSeEn/C498d1+twIQ/ojeVMk2/?=
 =?us-ascii?Q?jec9k48Jl2eeHD/n06YDB+BdL/p2CBJeadMwAt+QJ7YkBpqN20Kv52BdcR3u?=
 =?us-ascii?Q?p/BcCbdxg1Jg+sVn8jq7PZZNmSxvb6qJwFrYuOy8sqSX8EhH9KK2vAXpGtc0?=
 =?us-ascii?Q?CgiVkOL3HpKCHcDEfovtId5TNgbTRzXeF67z4NEuzLfJyMV7lmkMss2kivDC?=
 =?us-ascii?Q?eSm0xiubmXc7twx7VFJVf9kxyj71tL6a3IWXlqREkVTjNrQD+JpV1jtxBkr1?=
 =?us-ascii?Q?mdoWcEu3rdZDjFWbKJqrUpMVxBi7Z9w1ANlgCrs93wko/r3IhAHm7dNIuQFc?=
 =?us-ascii?Q?PsIKnPr1Ti4UmyCa1/zzGKfct90xgtcSvhUFe781Q7r+xLyLHPhSmHwLCNWR?=
 =?us-ascii?Q?SotMhGeycksnLuis5XrFo86UEIfzCxsn1mSI/TAHO9aQ4pTD+X9dAimHb+JX?=
 =?us-ascii?Q?Bcu67v4pGHRrh3rp/Ws0woykoJVoy4aTycBGZGoE07wzp2NghOY7ggqdQFXa?=
 =?us-ascii?Q?qQWIGfwG+sSd1v78e8IDc3ziksB3ZIvE+vGI+cRK1+kPPnMI5QrcqKP7PaYO?=
 =?us-ascii?Q?M+auhJunA2eRir/MjdfzcbA0hfQWgw5KIbSWZQHsMJrFHOMMhK2qplwEewi6?=
 =?us-ascii?Q?amfUyiYexS5QMleO4JkpDeuJILRQkfwYn226/RejMfjOyeKawj1x8Gqpajs8?=
 =?us-ascii?Q?DcjFKlzdO6bX/Uc4/TMMkCAb5So8JalU+jkQRbSXCqPsCKT5WiXIntdVK6x6?=
 =?us-ascii?Q?oZvZf0KW4C71cgapARBb+GpjcECP3vk85SbLNeV3fB8JHWBMYxey7Yzc4QXe?=
 =?us-ascii?Q?Hz9inh2liuljVZghG5UNliaEJ7czlAsQ8tI3k9tsoM57Cul33q3/NtYXYQac?=
 =?us-ascii?Q?/rPz/PRzeAhHDjS3RURiytRM3CvcYCQXLzuRJsYSlxPmWws7LI/+nCIjS7S+?=
 =?us-ascii?Q?CvazSaxup7TTcoU/0S8AJ91deZmb5s5Crjx7Ht8c9CaNMJhTqF5ruFxSwnV4?=
 =?us-ascii?Q?vUw03fnfaqggHjtRwaQqclVwh+jOOdFwZUb7QRN0Ij6tvS/qRBj6uoV09B1n?=
 =?us-ascii?Q?NrAmKgw0Ovv0M/zmSHh+mMxjHJZQ4XWdDKRYSBrlcmYVND2kCAzq97/M+M/U?=
 =?us-ascii?Q?Vml+UI08rkVwU1MxPmrMSOqLuJX9HLRy3Cn/oJAi9yszm+5FzqzRViMOE9Yg?=
 =?us-ascii?Q?3AbQdxfyFJaav+PUxqVn6v3xqasImv0CPDN7IKGxMHPOISWpcLuOHhZferaq?=
 =?us-ascii?Q?tgdyCggfjAEs2RgVHp6pQpMW?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe90589-0b1d-48b8-c6fc-08d93f809d7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2021 06:46:27.8989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g5RDF9GWX/+n3NLBliO2htikwB0ik9IKQO20smiGsfNRu+g+dDwaXS5maz3YRktwiwclkkjm8gPdsnzWGSrb4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> scsi_add_host() allocates shost->can_queue tags. ufshcd_init() sets
> shost->can_queue to hba->nutrs. In other words, we know that tag values
> will be in the range [0, hba->nutrs). Hence remove the checks that
> verify that blk_get_request() returns a tag in this range. This check
> was introduced by commit 14497328b6a6 ("scsi: ufs: verify command tag
> validity").
>=20
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

>  static int ufshcd_abort(struct scsi_cmnd *cmd)
>  {
> -       struct Scsi_Host *host;
> -       struct ufs_hba *hba;
> +       struct Scsi_Host *host =3D cmd->device->host;
> +       struct ufs_hba *hba =3D shost_priv(host);
> +       unsigned int tag =3D cmd->request->tag;
> +       struct ufshcd_lrb *lrbp =3D &hba->lrb[tag];
>         unsigned long flags;
> -       unsigned int tag;
>         int err =3D 0;
> -       struct ufshcd_lrb *lrbp;
>         u32 reg;
>=20
> -       host =3D cmd->device->host;
> -       hba =3D shost_priv(host);
> -       tag =3D cmd->request->tag;
> -       lrbp =3D &hba->lrb[tag];
lrbp is used below ?
if (lrbp->lun =3D=3D UFS_UPIU_UFS_DEVICE_WLUN) ...

Thanks,
Avri

> -       if (!ufshcd_valid_tag(hba, tag)) {
> -               dev_err(hba->dev,
> -                       "%s: invalid command tag %d: cmd=3D0x%p, cmd-
> >request=3D0x%p",
> -                       __func__, tag, cmd, cmd->request);
> -               BUG();
> -       }
> -
>         ufshcd_hold(hba, false);
>         reg =3D ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>         /* If command is already aborted/completed, return SUCCESS */
