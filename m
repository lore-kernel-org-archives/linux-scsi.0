Return-Path: <SRS0=+zlT=7O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C187C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 06:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3279C2074B
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 06:25:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kN8ltSrg";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="WOqjrU21"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgFAGZQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Jun 2020 02:25:16 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19060 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgFAGZQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2020 02:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590992715; x=1622528715;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y+3Yz5PnIvG3SiWxVBTnc4BdtYLDjwEv6Rg3KFPaP6k=;
  b=kN8ltSrgy1AAFqKEG6cE60Y6G7dkSxnrPDKrSaqYbINbr6XnK0hgERT3
   y8s1noHLFC/c+B+QPYB30V4afPcOJ9nlb0Ej1AXQSKh578dWT6EyGDlqZ
   Rmw6TR7VfW2MMc5/P7romD70GhbKhBAQXDnkwAoE/OtaDv5n0fXJN146Y
   VntIKaRcOK9lyRgIw9VXOA2ZOfch+jYZP5cLn7cewS4A1yAR3fsNfFsAo
   HVUQZ5whm/BMXM0yUTaNmXUrO6IVfNhRbZWh/RRx00CCYrbhqQCq+pjgI
   TKVH+BPPgcbG9q5Zvbxl8kizbc3VxMuIgg3kpMtR6twOdkGD62hy7VsPh
   A==;
IronPort-SDR: 7DjqpPTdIBbu7sINZt04Oo5/U+qGEibN04Ra6b+R07BLcRMod2XjM+BIGgfHucaCJV0MEY5b+j
 OhNzRr5sBIoAs7ZMvOpFVMOmfMrwinIj1xawsX1Tf2M5Mn5A1bC1RfG1gm8IYv+Le+qivMlW4f
 B19X0qpHD6gsmfbHCmcuZ7I7beCRiipVKEpyHCHTsXFz+sJ0VSMfVUgoomU0EcbHA2AL6pkdCM
 baWziwrzZu8PZxXYCWHEj5JwtRwHi6Nt2Iua4njE+1Pcb0i9SlRH/q0XNJDJBnNG13BLbwllCe
 qhM=
X-IronPort-AV: E=Sophos;i="5.73,459,1583164800"; 
   d="scan'208";a="248007011"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jun 2020 14:25:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzTeKiGXfZpXu6VnQcgecs6ttuy8vC1CYb0SYef7t+edgBR/0Gw8TaGHJ0di4PT8Uyms0jGIaC++2zWw9vbnXL4fb/QuomMjRs4OOwA2WKwaDiblfwl7oPU+DOqQa1Je5tUkfp1zs7CVD4omcy2ovh2lVP3DPfUPK3HdzZksxrz9W0jNVgw3NlLZN3n4GlUuBbJEkWkJ1ZUX7fusXG3Ee2rmCO872PeIBa7lqdqg2Vve3uX4gW7pLmN2B7RO2lPidlKmgfIzR2RwsGSYRjb5g+KcuHkl48W262A1OGQiyINYvmCxPSjU0Me+ewC70EBJ2PoF6vYKmgdHicrNxw2R3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gaQPAd2Drg2rmZonWxZ+dMaYyd4TxsKzyrsAVXcY/2g=;
 b=HktzKnNUciY2kknv1TXXug3zOAQKXBDDvOIsVdcwyP5IolvXy9dI215q4TOQtr+niAI72D0910ZfDqR1VziP2uDETuyMaZamzU6gMZgQgNCuYQmQEnCG/X+WijIk1n7BFzvfhTyFKziSvk16X46FZINwcCDTrKk8LW8MdVZ89aUmeV0entjIrBRXino2/BJnHIQSWeKjJPeVqFKXsW52tYOUwsm/Ljn9G+Sb6nEWEkjHpKJWzuu4gqFt8+/h9NHhbgeGpOS13kXVX8xKfLX4xaz2hFSNUxbpCHku/wiBbQhCqGYplYYP8SkcxSCJdDVdF1EfQ+i8hrvWbWZIlNL+5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gaQPAd2Drg2rmZonWxZ+dMaYyd4TxsKzyrsAVXcY/2g=;
 b=WOqjrU21kPCxGYG/M+XjDbqIyl5ZKYDUFltyCwVshCm6lLLAZsZUue5CxA4MFm2deKw6pNkr7Ou+JZJi+JAyW7lBddqtTrZWB3jr3z1oLbEc/oPpCldeppp/TkMCG+lPpDDE329uiQTFLJDp/oJDK/tM2LR2JK/aVghTJ7lYz+0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4655.namprd04.prod.outlook.com (2603:10b6:805:ad::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Mon, 1 Jun
 2020 06:25:13 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.022; Mon, 1 Jun 2020
 06:25:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 3/5] scsi: ufs: fix potential access NULL pointer while
 memcpy
Thread-Topic: [PATCH v4 3/5] scsi: ufs: fix potential access NULL pointer
 while memcpy
Thread-Index: AQHWN11kesoGcNEhCkK5z/BoKlc8lajDQ7UQ
Date:   Mon, 1 Jun 2020 06:25:12 +0000
Message-ID: <SN6PR04MB4640741E1DC89A927F8A60A5FC8A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200531150831.9946-1-huobean@gmail.com>
 <20200531150831.9946-4-huobean@gmail.com>
In-Reply-To: <20200531150831.9946-4-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eb7e7aec-7489-4fcf-854c-08d805f48aa6
x-ms-traffictypediagnostic: SN6PR04MB4655:
x-microsoft-antispam-prvs: <SN6PR04MB4655838B25A0E6EBCEE292D0FC8A0@SN6PR04MB4655.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0421BF7135
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: irc7MH4dcvQeOjnFZPDKHBp8HM9osTMJr5Lht+BqAsexS2KCB3vmrLJ7uf5+rWcEC/3phfvEEIpCQB3B5exhowBv/Mbytm0JXSElxZ8BIvLnJjI8Dz2RIrNvl3ffR1mbp1udJ8aqJ4rvLOH/NV+J4eg1apcE11comau2sS6i3lt1e46KcIFvr8Nyzc2lMTtXcG76HyIISNXPxYX7TKRpnaO1v0E6hksSoDcohTa+n/72cq4sTBcsUGMidQGtOYika8kkRMRqAlWk495g8cMTvFHmPIr8rqcgsi14Gk9paVrXu7kJdGxgzI2Q9PFXpXr4BhIe4VlIZ3N9vhtMGAAAFpxtaRS4T3eJXL5DdqU5ygxcBSAerQxD7ez7il5ZccQj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(2906002)(66946007)(66476007)(66556008)(76116006)(7696005)(9686003)(83380400001)(26005)(55016002)(64756008)(6506007)(66446008)(5660300002)(186003)(4326008)(86362001)(8936002)(478600001)(7416002)(316002)(8676002)(52536014)(33656002)(71200400001)(54906003)(110136005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: J+mRvIlu6yFd5ma9EsWSu0Xs/V+d4GgxXqdGjYofsm6NWPyOVWi84vn3Cr9aaI7Pax2krUMn9DYjiHVJcu0iypxiI5C01DxRmZWO6flGhD/utQCBtN1SFnpvdLEkw+OXoM+/3iYgTk8HJZPiCtOcsmQa3TxlOp0409h7pi0l1DIY2JlUMmSea0BHqacUVusp+sBZhDn+KBQ+uTiFZn+psTCxwxXqd+gHBbeCEs0Yj46EJfZLBQDok6wFiLUNkIH+ksCQ8Ko5YY4XZs6eXMbaMqBQrEU80dNDQi9wr6+5iqf/RoSHKc/BuFtq3B+yd0QqMOoOSK/NIMYRXBbnm1Y+F7UKrrYDVS4l9CNIB51gcwmqx6LwJPIy1WAHSjq3aVVXQiGuP7qn8KLZpEyERBO4a2QIYPXCMVi6TbFEUHtZrlUNvenC21r5wqhc7d9ckzq9+ZAmfcqv8/d2Gmlj6bRQ3DaVUU+TNA+dz/fpy1WrE3E=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb7e7aec-7489-4fcf-854c-08d805f48aa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2020 06:25:12.7104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iqm6a70cVWfs/jsV/ISQAsvl4GMBSpmvOvwfogS50OS+XrbQyTUE2SEJ6k3Y2m9WmSGxhL37/wwd6eNZPlWjCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4655
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

> If param_offset is not 0, the memcpy length shouldn't be the
> true descriptor length.
>=20
> Fixes: a4b0e8a4e92b ("scsi: ufs: Factor out ufshcd_read_desc_param")
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f7e8bfefe3d4..bc52a0e89cd3 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3211,7 +3211,7 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
>=20
>         /* Check wherher we will not copy more data, than available */
>         if (is_kmalloc && param_size > buff_len)
> -               param_size =3D buff_len;
> +               param_size =3D buff_len - param_offset;
But Is_kmalloc is true if (param_offset !=3D 0 || param_size < buff_len)
So  if (is_kmalloc && param_size > buff_len) implies that param_offset is 0=
,
Or did I get it wrong?

Still, I think that there is a problem here because nowhere we are checking=
 that =20
param_offset + param_size < buff_len, which now can happen because of ufs-b=
sg.

Maybe you can add it and get rid of that is_kmalloc which is an awkward way=
 to test for valid values?

Thanks,
Avri
>=20
>         if (is_kmalloc)
>                 memcpy(param_read_buf, &desc_buf[param_offset], param_siz=
e);
> --
> 2.17.1

