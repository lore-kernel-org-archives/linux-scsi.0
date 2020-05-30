Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A3AC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 06:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E217B2074B
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 06:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="k2MLZLbh";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zCPe+Xvy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgE3GhY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 02:37:24 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6220 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgE3GhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 02:37:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590820642; x=1622356642;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vKZmDoetujZS09a2SidAgR6Yv9FT8RRxXectq1nwAp8=;
  b=k2MLZLbh5bCUWGBn2FjW0sYxB2DyQ+z1fcklG17LLTIAT54cZ5CW3Yrr
   EJUXHk9B/v/rBUR0BtPMU4oolqOLHio39u1+7LZWTgLq6JUGDBGuNolsy
   GkBg16AzlKgiMn0oBQzdN8vPdo8Fz8u0cCPwvnJujyQtOblmgz2IrgH4B
   zGp7ELNCr1BHRzJs0/bx72fz5AupbP551YdDV8MViw8jKS9cvqEK3vgAM
   mjLYJr9QvHuA6Exa85xrxGTlk4nVJ94pqVNdY2NyZgNVnZVPxBFqUhv/X
   GaLTvIx8raUvS2/7OP8E8HzcWJzQqlxXHOsfrmSXacKGnKXymn2kaHJC7
   g==;
IronPort-SDR: RZzKMOm+nqcJPMU6Kt4w4ZzQP19M619gK7K0pT0QXXG6RwKt9CI5+p8chRijhDNdKg+mVCWMhB
 hc7hhpCPbbFOMrkchMa6Tq1aNJLxAt3W4YGyiDtH3knbTR+nK7SKYJ1/27kyeCNQsRymbRJ6wL
 DQqDq1yooS5Q39g9n3uvayQH1XFw7kZjUdvOxo5D/hZgHYYjqVR1Qq1fwrTWfUfgTurADib+DT
 a4ZJFscLv11TfnxUyNJtWgYNe1bkC8xtlpCIZpW0PARrcJ7UxgilhxqaGmr/1OH0mLeqCzEltH
 Kk8=
X-IronPort-AV: E=Sophos;i="5.73,451,1583164800"; 
   d="scan'208";a="143173541"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2020 14:37:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7Kn7+DBAiFqmb9fN6UigR4329cpWBhZTCWVaoBt9ggApXv/yubj8eITjpFYKC2HYtUxVlAWxF7rKlo7UkboyUR44v69MD7aZobTQIBl9kDr/XeNm8yUFDfUqEBq4ZyvtKhcpyC73E1+2rxe1Pd58I3e4Nho3bTKs7Y5lyEgb09VQWNcqpZFO7woZ1mbRnvUUN0/pkiz6XM5K0Wp9cANaS//II2tZsog09//Qo2AS/Q23LTZDvnwAKpJ8I8d0EPg8pfxKys4ZVcVEeGjf6SVBh1ooGyVAUryMTpueothF4IamTCNkpyW2t+WkkF+04qAdvqkSQi3e11hYJzct8OPQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqLYPsF/1Dzt5seBHARCOgo8jAX1bvj8Djq3RG/osQc=;
 b=BJCCRJKOFPzJWgS3OtpZ6L+FViQDmVKfhoDI3PwuO3tf5OHMGOAoJ+QHfgQESf0oH1MuhuaPT8unQRnoqHsArATEVGX5hICQAz/axMXQ97l9x3HpnnkIZC57HkE965GNropB02+rjtU7Gp5f+tVdwIyp6SrQaqgri5B7PlI+HyLgxUWCo+XKyCV1GXvTSGTyGKHi3IXJ1165NiM5jG4xumakqCTaIM745GM2cty/YmnmeW9+5jCBO1/vh+sabq1fwHnOZEg5t92FElMRJGyJjsoTEMonM0omyNXslRvi/PnS+GVFx2aFR+DCmoBwbm+wHRBR4fE4LeenMNEPFRKbEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqLYPsF/1Dzt5seBHARCOgo8jAX1bvj8Djq3RG/osQc=;
 b=zCPe+XvyZ5MYpK3LgsYzci3pKcd2jdJjDRRU48GEiW84CkQykjHCBRZoJs2OBK8myBViNOVRjY6cXfkG6qEQnmPcIr0umV4EgveAP+L3I5pi/jcvdJztGG6bpccbog/3MIMUX1xIAqkjOEU5f0o5wHP4Hx1eSfWLqj9offe9Tp4=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3966.namprd04.prod.outlook.com (2603:10b6:805:48::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Sat, 30 May
 2020 06:37:18 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 06:37:17 +0000
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
Subject: RE: [PATCH v4 3/4] scsi: ufs: cleanup ufs initialization path
Thread-Topic: [PATCH v4 3/4] scsi: ufs: cleanup ufs initialization path
Thread-Index: AQHWNdgCsIABuGsXkk2fMroO5+7VNKjAJaYw
Date:   Sat, 30 May 2020 06:37:17 +0000
Message-ID: <SN6PR04MB464078AE07966E53FFB237F5FC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200529164054.27552-1-huobean@gmail.com>
 <20200529164054.27552-4-huobean@gmail.com>
In-Reply-To: <20200529164054.27552-4-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 35b3608b-997a-4f0c-92f5-08d80463e5ea
x-ms-traffictypediagnostic: SN6PR04MB3966:
x-microsoft-antispam-prvs: <SN6PR04MB39663B74DD1377A1446DE081FC8C0@SN6PR04MB3966.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1002;
x-forefront-prvs: 041963B986
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d4R7njqeG38B0DFxTRxW9drk3Vv93lG7ziu0SgdH5tRGbw9kM3fyZNDPkUg0FvSIFWPgLA1POaoAz50I7hqX4hq9Ty4W8ohrGPJkGlT9pNGBcY0tKdiBydEi1YLTW2ZGG51FqUUmehZqnjeGoPoitCPI8D0Jf5YazVg42AWxz1dQ/+mVAKPSUq2tzbfLHlWRfN2aG8a5I4RgTvJH1BaRhsM5ftXlhgPLob1nSxuSsty3aAQbjtdVh/uvP9d6wEbH6inU5WdYop20xe9m/8Nv9rRYhOlqiTsxwGhxkDtKzZm8IuCCl9dj1iFBqOUt9mGjNmMPXzy/Qod3vTY9dg6rYTsEHNtaKMBeN5kjlfJ5TYCDjyTAxJmE3kzlXWRgi/91
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(5660300002)(76116006)(8676002)(33656002)(26005)(55016002)(9686003)(83380400001)(186003)(316002)(478600001)(8936002)(4326008)(54906003)(110136005)(86362001)(7416002)(66476007)(52536014)(66446008)(71200400001)(2906002)(7696005)(6506007)(66946007)(64756008)(66556008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: rDIICjLgjqWNzbjt4ggr6lkQIjNVZaimyqUs7WDGqR3r8K2/Q/LMvZIHEEMYLiiWYeJv5RA1VVK2I9WL0nhqs/ENxhTW2POhQwVqm+ogLf6x/ZKwd2QQQTHk47RzuktbskcXCCP8zr6wriQYWO6UTs/LhZwl0lVLfkUXmr1BbA3B5wCUIbBYEYU9o1Jal6kTzZeS5S6ZPuU7yZDvovcFOsuNrXOEyqfXl/45fGotHTxrwt/CQ4QQ22gwQtAiW858XiurXxHirHxV10q9k7S6H5YmeRVE+5xl5mqbz1/XD2uFs7hVrXM+FfHxBja2oK+enY1qGQXhDaRfTNtQe8u42ftr99yUeYVbYCaDC/PqGwNdyzMVy6wNw7hxu2/mx9VSrIDERsMKVPGEOBeMgjmdrrojZRUCAjvZxoEFqWjZS7i1F/qdoUo54GTM44i3mcnDreavdMtelh6kCgkPO4Rkh9ZpcPYLJAn2FkCzhZULWdY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b3608b-997a-4f0c-92f5-08d80463e5ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2020 06:37:17.6405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tk6gasdtiF9y7gWK7uB/LFHS88cunGVzEh0G0SeF3M9IRosr8e0U3UDpNXZNx+o2RAv42NmCGWLkkngyeY/8KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3966
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -       case QUERY_DESC_IDN_RFU_0:
> -       case QUERY_DESC_IDN_RFU_1:
You forgot to check that desc_id < QUERY_DESC_IDN_MAX

> +       if (desc_id =3D=3D QUERY_DESC_IDN_RFU_0 || desc_id =3D=3D
> QUERY_DESC_IDN_RFU_1)
>                 *desc_len =3D 0;
> -               break;
> -       default:
> -               *desc_len =3D 0;
> -               return -EINVAL;
> -       }
> -       return 0;
> +       else
> +               *desc_len =3D hba->desc_size[desc_id];
>  }
>  EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
>=20
> +static void ufshcd_update_desc_length(struct ufs_hba *hba,
> +                                     enum desc_idn desc_id,
> +                                     unsigned char desc_len)
> +{
> +       if (hba->desc_size[desc_id] =3D=3D QUERY_DESC_MAX_SIZE &&
> +           desc_id !=3D QUERY_DESC_IDN_STRING)
> +               hba->desc_size[desc_id] =3D desc_len;
> +}
> +
>  /**
>   * ufshcd_read_desc_param - read the specified descriptor parameter
>   * @hba: Pointer to adapter instance
> @@ -3168,16 +3105,11 @@ int ufshcd_read_desc_param(struct ufs_hba
> *hba,
>         if (desc_id >=3D QUERY_DESC_IDN_MAX || !param_size)
>                 return -EINVAL;
>=20
> -       /* Get the max length of descriptor from structure filled up at p=
robe
> -        * time.
> -        */
> -       ret =3D ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
> -
> -       /* Sanity checks */
> -       if (ret || !buff_len) {
> -               dev_err(hba->dev, "%s: Failed to get full descriptor leng=
th",
> -                       __func__);
> -               return ret;
> +       /* Get the length of descriptor */
> +       ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
> +       if (!buff_len) {
> +               dev_err(hba->dev, "%s: Failed to get desc length", __func=
__);
> +               return -EINVAL;
>         }
>=20
>         /* Check whether we need temp memory */
The first time we are reading the descriptor, we no longer can rely on its =
true size.
So for this check, buff_len is 256 and kmalloc will always happen.=20
Do you think that this check is still relevant?

/* Check whether we need temp memory */
        if (param_offset !=3D 0 || param_size < buff_len) {
                desc_buf =3D kmalloc(buff_len, GFP_KERNEL);
                if (!desc_buf)
                        return -ENOMEM;
        } else {
                desc_buf =3D param_read_buf;
                is_kmalloc =3D false;
        }


> @@ -3209,6 +3141,9 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
>                 goto out;
>         }
>=20
> +       ufshcd_update_desc_length(hba, desc_id,
> +                                 desc_buf[QUERY_DESC_LENGTH_OFFSET]);
> +
>         /* Check wherher we will not copy more data, than available */
>         if (is_kmalloc && param_size > buff_len)
>                 param_size =3D buff_len;
And here, we might want to update buff_len to hold the true descriptor size=
,
Before checking the copy-back buffer.

Thanks,
Avri
