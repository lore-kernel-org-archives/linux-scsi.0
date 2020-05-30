Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCEFC433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 06:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10F6620897
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 06:56:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eEoI1YkY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="DsqNdAMT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgE3G4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 02:56:45 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:28175 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728990AbgE3G4k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 02:56:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590821801; x=1622357801;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EarOTOUKj6gRNhwycipsPamYRsQcPCm6CJMMI9c0oVM=;
  b=eEoI1YkYNDVKZuqnkGVH2GWEZFM5aH1V+7LucSHI8WIDtK3hKlzcERU6
   CkZ72fDy0q4Enk5K0ItwcX+vv5ojbVaUSqBZm/KUZBbff0xP5ReIE0SoP
   jBtSUZy+HiLDHZ8POWYQUATDRF2swYPYQrRw0IiIJ9et1ShuO70P1F+x7
   Nh2/JuZhyDyigKY9kBjhGaJdu52iUvuq5leITKB4abHFE2WM8adh4/Vke
   Cl5C+RkDJzUPiLyXHqCDUzwXNQMULLCk+HQoDOQwtsB5K1qX59Rvu9TR8
   KAbeQ8jUYyBct6YuF2WnDPyf6U7GgftHjmulXcbvUg7bd3TXolsjpZ4F+
   Q==;
IronPort-SDR: qce4qSZpAjJVPYDLVVl9NZ6Wlcg8OV/UpLxdJJ9IGu08OlDYnx7SSL3T6jjqUFz5Ju1U94FQbi
 W4EZDOeGCc39WRl9BED1a88hOLtsmS1QwlubrNHLwmwSuX6fq3XPZu8GUBD7nKK2I8pz5U3Zs7
 bKd98qtmaI2xaIw3EmavfZtfB6T8vIOoHgHKselMAOhtSERuLeHZoCUprXsW3e7afqtpcNYNXs
 3gZuv1S74A8xaEogxRkqYhDr8geJ7JVFhx7enRk6KoZE+hUzbIvahRNX0cbzIf5HoVVI4NdxVa
 q7k=
X-IronPort-AV: E=Sophos;i="5.73,451,1583164800"; 
   d="scan'208";a="139170966"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2020 14:56:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdIUw+DKumY2vcYfh/GWXIBmnkhm8HWb6va96D4xfU8z2/bAGIYFth+opq/Ndwvp7L3RKn7MLtxpDIATtuVYF0gCEC856cn9UqGRW62KBdXuQpjZltYrsxpAxWGBZT/wHy0I9roAl89FX4JopuLr/CKSiy61/X8MsEKINCzYRabblJSdV6ie7S4BBHOpck2oXTq5jRxP1i1ptAx/j+8wMB/bBNiXaLDhAV3NvEYIQCNZFRVS/hAzS2pgJgHMczvzWBeEzix9VVDe/xQfGEVokQv7V29p1jS90GEZKoVlqOzbp6nXJ+rz5AoFxH9oTHTB0ZMKIydbew1+DvRIWoXHhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECrod+O6p+hB+acwSy25503rNOnQTH6YKdTo5/JMTM0=;
 b=b6/jn2hI5/0XrbCBNk15HmQLdwdNIGaMiqmw8voCqhbsUaOnR25IcHUErQOqGJt8IxQ/U63bnKLsNlsu7M+vlbkz1+pq4zTN/1fzggaslBdIcGBfUS268xjyuryZMOiJSSuXJcXrN694V/wNdTJar7zSEADFkDeBR0l+MOYoLhkbTXDDN0MoQEev06E7FN34dBO39TjV7HybnmgQ1u2OSSFoKyKU3cH4QpbGAPpzhUQ/52Shu5C7Hf2m/CVaeYYFo85nV93bChBdc6uM8oWzRMfbOrqv2cw8Mwuzpgs2ZuCu89y5SKqyFwr50KA5UlF7d5OGoZNOKhXvdUxvoCy65Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECrod+O6p+hB+acwSy25503rNOnQTH6YKdTo5/JMTM0=;
 b=DsqNdAMTPArWp/KjFnRiEfKOTNMTOtX898utwxTKZ+YQ7XsD8pnY2gIt3R1ebLADPAndKC2HVx1XhWYNbAC0nN1Me2PTq9l9YWwi7pjvsEob4ayhQjjDsH9xuQfKHpxB04D/zBCR5tTVnU22/c2otIYcbZYP0bi0WEHFepvsVHE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5470.namprd04.prod.outlook.com (2603:10b6:805:f9::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Sat, 30 May
 2020 06:56:37 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 06:56:37 +0000
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
Subject: RE: [PATCH v4 4/4] scsi: ufs: add compatibility with 3.1 UFS unit
 descriptor length
Thread-Topic: [PATCH v4 4/4] scsi: ufs: add compatibility with 3.1 UFS unit
 descriptor length
Thread-Index: AQHWNdgFtKmSldcTVEG4bGVs4/ouSqjALopA
Date:   Sat, 30 May 2020 06:56:37 +0000
Message-ID: <SN6PR04MB46404D5B77121B367C17AEA2FC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200529164054.27552-1-huobean@gmail.com>
 <20200529164054.27552-5-huobean@gmail.com>
In-Reply-To: <20200529164054.27552-5-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0a925188-7166-43e3-cd57-08d80466990c
x-ms-traffictypediagnostic: SN6PR04MB5470:
x-microsoft-antispam-prvs: <SN6PR04MB5470996E8406422753EA12C1FC8C0@SN6PR04MB5470.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 041963B986
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n5kfLV3gKRtikfiqS8nMln/k40J+pMzmgVzbMAWwIWmtOV11bUZFUBsGakh3P8F7JeSOPJnhaaN6SMUztt8OoGNqn1uRIGwr7FdpcJcHZ56GIGp7/QKXuCozMb3pyE4vI1vU8oo3VKmixGK/ajUyoslDpZL8EpAo+dm9tHAsknfrpJWZF1T+V9kANJZkETCMfCQ06ieQqhxd5gP0CG75BPqNeRzkaNjglbzZ2Hz7d38MJv0F8rhpS5ws+Fv6bXcUXv0z9Wn+OYCG6NgO7yALVUCkE4EDxzLi0VAGABURwIy6wjrVk80yyPdv89NcfCVRMG/Fqyv7pcgcyfbv+IdfkItJGhOEeBFYmSqDpPm0Fxel+8qH6o+onrtEGB4GOCJ5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(66556008)(66946007)(76116006)(66446008)(66476007)(52536014)(2906002)(26005)(6506007)(83380400001)(64756008)(71200400001)(316002)(478600001)(54906003)(186003)(8676002)(86362001)(7696005)(8936002)(110136005)(55016002)(7416002)(33656002)(4326008)(9686003)(5660300002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vzPmXnmIe/ILLgnTl36Olwy1Dax/htQcgrgwQFQCM8lhUhZd87DkSH1SiaM61wVkzy4huJ0YXxkQN3XbXgbJoDaBuSDLlrOEUoXsWSjq7m9sfA5JdHg+L8LGo9bKPl5tBnYvA8COzk2lkn+DCJGlUITdAncTd9lq7uxESu4XCKFwpageNtxGVX1YguuBuIg4A7dgcmVvcPX4baQg6CJ6dR1VzXPWMNzCp6I1r3dH8yXY0tOfetNj0MNlxDnHKfNcqAB8plFKQOd4lr3rSnLNi+JqKpiBDsjJBDMaiG9JHZbhyuLNUnluMlcNVGCENdWUslwq7JdqOBejGDH5axtnV1ti/TMCjQYixKqfyilD/EHkOwt7+YXJ/Uy5XSQcxW+aoXU3GJeu/6o4ahqSH8wIk1DFjVU+H2GIcd3lvLLLgZoyutOY51dGNJ7m9zWkibQGCKT6HwEvEc18jQ+f2o7zMWQ/ap6lUmj0ONH860QRm0U=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a925188-7166-43e3-cd57-08d80466990c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2020 06:56:37.2274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a9Vo2zCKCdNe2PAJ3TZZynZ5Ct4kQ/nL/+nELrrVCOsXMCint+p9Elk2ohn46EW5KiAZS0I02YvOO8ZRBfQtoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5470
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> For UFS 3.1, the normal unit descriptor is 10 bytes larger
> than the RPMB unit, however, both descriptors share the same
> desc_idn, to cover both unit descriptors with one length, we
> choose the normal unit descriptor length by desc_index.
This is not what your code is doing.
For RPMB - desc size will not be 0x2d but remain 256.

Your strategy is still correct IMO - if you assign the larger size,
The device will not reply with error, but with the proper buffer.

You can also rely that reading the rpmb unit descriptor will not happen bef=
ore
Reading regular luns, because this is happening in the first slave_alloc.
=20
Hence, I think you can drop the extra if, and just add the comment.

Thanks,
Avri=20

>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs.h    |  1 +
>  drivers/scsi/ufs/ufshcd.c | 11 ++++++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 6548ef102eb9..332ae09e6238 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -63,6 +63,7 @@
>  #define UFS_UPIU_MAX_UNIT_NUM_ID       0x7F
>  #define UFS_MAX_LUNS           (SCSI_W_LUN_BASE +
> UFS_UPIU_MAX_UNIT_NUM_ID)
>  #define UFS_UPIU_WLUN_ID       (1 << 7)
> +#define UFS_RPMB_UNIT          0xC4
>=20
>  /* WriteBooster buffer is available only for the logical unit from 0 to =
7 */
>  #define UFS_UPIU_MAX_WB_LUN_ID 8
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 951e52babf65..3cdc585d0095 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3070,11 +3070,16 @@ void ufshcd_map_desc_id_to_length(struct
> ufs_hba *hba, enum desc_idn desc_id,
>  EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
>=20
>  static void ufshcd_update_desc_length(struct ufs_hba *hba,
> -                                     enum desc_idn desc_id,
> +                                     enum desc_idn desc_id, int desc_ind=
ex,
>                                       unsigned char desc_len)
>  {
>         if (hba->desc_size[desc_id] =3D=3D QUERY_DESC_MAX_SIZE &&
> -           desc_id !=3D QUERY_DESC_IDN_STRING)
> +           desc_id !=3D QUERY_DESC_IDN_STRING && desc_index !=3D
> UFS_RPMB_UNIT)
> +               /* For UFS 3.1, the normal unit descriptor is 10 bytes la=
rger
> +                * than the RPMB unit, however, both descriptors share th=
e same
> +                * desc_idn, to cover both unit descriptors with one leng=
th, we
> +                * choose the normal unit descriptor length by desc_index=
.
> +                */
>                 hba->desc_size[desc_id] =3D desc_len;
>  }
>=20
> @@ -3141,7 +3146,7 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
>                 goto out;
>         }
>=20
> -       ufshcd_update_desc_length(hba, desc_id,
> +       ufshcd_update_desc_length(hba, desc_id, desc_index,
>                                   desc_buf[QUERY_DESC_LENGTH_OFFSET]);
>=20
>         /* Check wherher we will not copy more data, than available */
> --
> 2.17.1

