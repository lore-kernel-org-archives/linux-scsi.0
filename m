Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6C8C3F2D7
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 13:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C5C32072A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 13:14:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JdjU1TJg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nTnG/ER4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgCENOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 08:14:04 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:43048 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgCENOD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 08:14:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583414045; x=1614950045;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x9zGvDeOpV6YKeb9Xxm/GxjNUdXQBfik0BSRBvwZ+v4=;
  b=JdjU1TJg8Pw2f6Llcj9c/DqgCYb9BzCvnnYn2FmKek8UcKk6x/EZocR+
   7uxWKQ1+rLNy9t7RJngTLpyRnAWKC1FUxD1ibbSy1/N7iX9mqo+H80LvJ
   Zh8y4XAdxBahSXcHtoHTWrRGnXKNaLFOkwBvL2OTBVb1Na7DsaWeeueeA
   +mA2AI0kVNx/m4q+lP4BzFzVj2yH3GNmXUUc3z1w9wB8cLFA23n2ykPcr
   FUJyBl+G8bWvsv9uIvuLCVhmA0wDI+yTKy4ydN6kfhL50Fqiz3m4/2x/s
   mTyTedvCCi2cDaeOgqQLmFV9aV4PWhGAPGj1nunaKDablJqvLGEiK/Qtv
   Q==;
IronPort-SDR: xCiIAfIIVW1NWbpx+Ydj0fIUN7KAJM57jvx9Qsmre2wK18IrQz2Dk5BLgPTcViVrbPJF7ZAIFn
 H6Iv4LAPyvsS3cxfU4SWYHpak7Le9lr7vkjT2KnmSIkT3BE/pcrf6Jw5ud4P4BC842sq/H7ZK7
 m5FrgrZD47DvE2iNeqkayFtSQe/qLSIvhkuueR6CQNnbcrlmiN7Tl6aiWNfVkkdwq/DtEJGHcL
 c6GIbUB8MZuCITD+b96Xyxbthy8scl+hyUAkDPQYra1n+29qNpS9b83IhHPN2WnQ/JCOHKwBwe
 o9I=
X-IronPort-AV: E=Sophos;i="5.70,518,1574092800"; 
   d="scan'208";a="135970325"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2020 21:14:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHVin89DqoW61pK2KBkppewgoD0wIneeIuxGqbjVs1+DaOJ629dZscqqMiQNFLsYxD7xuQPotpGINm7wAznPTcLH0pVJne88Fvl+M++3AmwgLzHN98ki0DQQnoq9KhZKcRc6vDoGLNj6ObhQvWUZxq26+xlkh2RXoexsjebyLKYoE93DbikJRU/O17TBg2j+yOS9ucvfvmnqfyVKV7qNeBoATvOmH47GHbf9BOTG1iXr40dtZz9/KAnBgpGVkWrNfjo2piPhUbJK+kQpDvnWqyeLanKnpuouUT6Z/56AenuCXCH6C04U6a+SyEwquCpBu2Y9tAVZfJ+koFsIqH8u+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gJ1IZk6gMA5g7dZREBXQN5OiOEbqyDrbb+DzYlj6o8=;
 b=nsnPprbXMVGTu6VZ9gPdRAAEEZf5xhQ6ljPoagrclhTh+fHOoFk9s5uDpuKTCix8RTuaFrOpj4Lo7bHP/7/J/XmJH5EFQxVxge2TsTKchav4wCRLT+A0kjLz9sTaY+ZUSFBMmGqz0/1zVtO9YN6Yptyu/eNvAqCvTOZTZgNnWGb2UEBNkvSUf15KTKdNhsUoGy6ZDY8azfrbMWomod6pNOxJv4E5/dRgWYioOZBREqZnJ1PDRGNTolehPU8VqAu089jr1ENnloYaKZpT/RffXEjeNztzzmwoEjEdI3eYUgnBLosNjHHCbgPIiyc47MTrb+jChIlNrYnXpM7t2Fz1JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gJ1IZk6gMA5g7dZREBXQN5OiOEbqyDrbb+DzYlj6o8=;
 b=nTnG/ER4/AUEBgKwT4mGyoXgsB2ov89aHrt1L9ZjmhzpBV6rPPT3zUfIgD6zgV57b3rpl4XM0sysG5oynA+fXoX0QVtdVp6gd+OOw9GQeRp34fuZvPKoaxt6aI3S6oNYnXw07Od6C/dKIyn4Ix4g8lTXBE7fJMa7GEjhPFyKzeo=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (2603:10b6:208:1e1::17)
 by MN2PR04MB6800.namprd04.prod.outlook.com (2603:10b6:208:1e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Thu, 5 Mar
 2020 13:14:01 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 13:14:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v1 4/4] scsi: ufs-mediatek: remove delay for host enabling
Thread-Topic: [PATCH v1 4/4] scsi: ufs-mediatek: remove delay for host
 enabling
Thread-Index: AQHV8qOOFwhGQ/NXrkqa0GY3KGA/B6g5+fjg
Date:   Thu, 5 Mar 2020 13:14:00 +0000
Message-ID: <MN2PR04MB6991FAE18CCA3DACF2306E08FCE20@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200305040704.10645-1-stanley.chu@mediatek.com>
 <20200305040704.10645-5-stanley.chu@mediatek.com>
In-Reply-To: <20200305040704.10645-5-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a784fa61-0a70-48d7-e603-08d7c10711af
x-ms-traffictypediagnostic: MN2PR04MB6800:
x-microsoft-antispam-prvs: <MN2PR04MB68003A400B87D42A3C2013EFFCE20@MN2PR04MB6800.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(189003)(199004)(66946007)(55016002)(9686003)(66476007)(478600001)(66446008)(76116006)(4326008)(6506007)(64756008)(66556008)(5660300002)(316002)(7416002)(110136005)(26005)(81156014)(52536014)(54906003)(7696005)(86362001)(8676002)(4744005)(81166006)(2906002)(33656002)(8936002)(186003)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6800;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rweqDiZf+fl8gaiJHGzJlgHOV6PjdU0ntziKw3n6J5h4cMxiWVL2WiofqHtfduwVc5+E2TSfklSN4F8BkhS+B33Vhm/oevILxxSYrqbat5wfp9ITcZIN5NKA73wfrY9k4sl0E2a8T/MtFFaSGIs4U72UgTvqqa0esWR3vbUTj63pqr+HZMOVCmp1ACvaF3X/Sxbvot7wLzhfrMVy+L2TJhP7G7D4YwRfK+X82jgspnp1cmCrqlk1RjRtksHzLf7+JzX0iwwlK7tpOJBJnR2MUOm8Nml0088WlW7dD6fnZjr47KFYFNFPdsb5KAgMHqUSJ9LgJi6A9EVfWpp8ShXC3zjJU9MBEEDy89Ll1s6gWO8ZUmpXr09Ov9p2Vp/ln2XcKcjvQLvOvBPveivhf1SXmZW/SOy0M0sCMsgi0cOImrx2Vf4+Dx5UD9+QoxL8cDia
x-ms-exchange-antispam-messagedata: Cx+G9DPJKCE4T7PAoKSA1J4p2yxv6XhMb/Vdb4ZTBn5eSXOPiqQ2Gucb75ujdPb97/BuruObsHnxAzqEoaT7VG1+q19apdDZlyN+9Oalr03WNw+3j2Zr5feRLT7T38AuOHPiXV5wQh+2zE4OYuWaVA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a784fa61-0a70-48d7-e603-08d7c10711af
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 13:14:00.0393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y59bZ5xOdq3wbRc2ejWGEHZ0y+iUJRv5cPJLsBbI712Xy1bXMbDGWs216TOL8QZQslxEEpbJIrGAhC4FWmG78Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6800
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

>=20
>=20
> MediaTek platform and UFS controller do not require the delay
> for host enabling, thus remove it.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-media=
tek.c
> index 3b0e575d7460..ea3b5fd62492 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -258,6 +258,8 @@ static int ufs_mtk_init(struct ufs_hba *hba)
I would expect to set whatever is needed for your host controller
In ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE), and not here.

Thanks,
Avri

>         if (err)
>                 goto out_variant_clear;
>=20
> +       hba->hba_enable_delay_us =3D 0;
> +
>         /* Enable runtime autosuspend */
>         hba->caps |=3D UFSHCD_CAP_RPM_AUTOSUSPEND;
>=20
> --
> 2.18.0
