Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5754C3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 10:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B3E92078E
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 10:37:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="G8BFCIrI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="EaFmLF4d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgEDKh4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 06:37:56 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:11257 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgEDKhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 06:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588588676; x=1620124676;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YtcvFyIT0huslY20lGsT4TivCHLd2S4XYfuuCCT+mqI=;
  b=G8BFCIrIz5VsadtwIYtA5Y2yzjiIDYz0rXLUOTsE8eCCbdHRMvD/uE1c
   y9ot8ksuptJ7Tel3w89LwnDm4BQiBluqfKDqxTsSWUHp8dnDdz/EAzaJy
   6bLYRa/W6l9uX0G2NI9rgE6LGyjLPAy+60sFpIoGH43o2ybqlltEFUQ4q
   w02dndOiydh8ECBGT6PZDvhvwKv8ILlbD6pEBTWIiE52EZS3I8d+nofoX
   TUOffXfbldeAmTD9IZGzG41Jb36E3R6T/N/OZ3wkCDjT4VLLQaGOxBhyl
   kfRtdASM3f1p+NzXuQJ8jeUVD7eeo2kvnV3JLHl7Ja26GU5G/gcAMvUkP
   A==;
IronPort-SDR: bEwr/AM4EbxKbCf4E537pWyhn5pegHvYCqSYYHRaYcCMIQOt990L9Hca+wQ/i2AnvJpUlUBvdU
 y/neGob+Q+EF1jPAJCGBRic+YetAoBUIUA3gc5Yeh2MRsbI1Ngfcl/4AaSsuk4jGzmfOr5yvVI
 nsQDP1AtPT1VYt14XidS/7rkmVo7fMZI10OEckwwq7xRfAF+3FMKgNO1RqmsYxnbiIa1xyvxYo
 mHz1gKbAcsPkAt+i1ePgwYYBecnuymiKSsnIKi8cKU7CpvDRtcHKlmFuw0xM6TCp+/iKlyk2NE
 aqM=
X-IronPort-AV: E=Sophos;i="5.73,351,1583164800"; 
   d="scan'208";a="141207765"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 04 May 2020 18:37:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jm8QkHeBkMgpGQTOM+MolKuBZYl0sWERNh4RBEJWbVwd18TXokkxauTaxYszWaBVRD7FyrWZXPV3q4JUHFhYRDL4qt3g1kskJR0eBeWXZV6nWcPlaQXUOjtRTqojvcJiVd93Ki4nfdwU/H4jx7SfQQYRL5cNOwx3lb+4GtIbVE7QGQQhzZC8nBLcP7ihKE83t8q2UzHO/xN/qCyAIWuBXAaDZG7PadyIOpPq2/5CaxXsySXGNu4nDAWOXBwZaFPfN9zDoUWVoPDBQjxIWM/nFlqtP53N9dkqm+D+se4vwk0OYhSav5UqQmz7vovv4AFSRcshGSXAEH1G3KZmasL7rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkycn9leYbJdoMtVOEJrpHFImJC1uBicN9TjNATUKfw=;
 b=P1JqGLQkFnsVt7sdpLiZkvdu+2oYXqFEz1cVbJXKqgHMnxVN8FbB1ueBvtnVe4dBwRBqnRoOF0CdyQf/UbMIRdDI9Kwttn6gdzS39rO4acbshWAfDRGZABYhpqZsLIy/+yxmiYxKF4hejmXnUS165R0+eofJ6E3KwYV8Y+1xUkt8aA4k8f6/jBFszCGvpyLf8bM/kMvQY1/v1nVg/7AS6Zyx/yCgg3ijtRZH49Oi9zetUXLldQAKnVVE46TrfD+lfPA4CKO1VhFt29ZcS50spvAIeZgTAqNGMDBtH7zs9cNl/o4idefH1livsMAgsscs+OX7wCnVZPZZYyr0X5LJIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkycn9leYbJdoMtVOEJrpHFImJC1uBicN9TjNATUKfw=;
 b=EaFmLF4dXkpDxmBdq4EkRhb9Coi5273PujgS6MCtZzV6NrDhNXTyTnugo36gJNRq1lqRqcD2dHKTDYE7R4iRy1V8mKplG4Sh+GIHh/nHBQSOKmmKsx859E1wHtCDL9kpG0z4q8NraQDKPsVd8SiR3MWFhjqTAvmul2HugX2zfWI=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BYAPR04MB5815.namprd04.prod.outlook.com (2603:10b6:a03:105::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Mon, 4 May
 2020 10:37:52 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1%6]) with mapi id 15.20.2958.029; Mon, 4 May 2020
 10:37:52 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
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
Subject: RE: [PATCH v5 1/8] scsi: ufs: enable WriteBooster on some pre-3.1 UFS
 devices
Thread-Topic: [PATCH v5 1/8] scsi: ufs: enable WriteBooster on some pre-3.1
 UFS devices
Thread-Index: AQHWIT7Rzk4bO01K2UKDHMRnVyvfCKiXtsRw
Date:   Mon, 4 May 2020 10:37:52 +0000
Message-ID: <BYAPR04MB4629F2C00ABAB512DB833232FCA60@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200503113415.21034-1-stanley.chu@mediatek.com>
 <20200503113415.21034-2-stanley.chu@mediatek.com>
In-Reply-To: <20200503113415.21034-2-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ee7ea914-50f8-428a-c6a3-08d7f0173303
x-ms-traffictypediagnostic: BYAPR04MB5815:
x-microsoft-antispam-prvs: <BYAPR04MB581506B1E998CB38F1B9268BFCA60@BYAPR04MB5815.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 03932714EB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xSye2/D+b21x9goO8VXasZUT0l8HvasbcLSBPHMlTge0FrH/CFERqZl852QweiNsOkSG8ONA0gUC3+xrP8bIft+S+Yp6Tv/S8VhwVJFwb43sSS1R1xhBbcTRRIopavBsAOUwPfWHwUZohdunq2upU7GWTiFLYwpe6a5t+0lgskVpc2ZEiFiLdZvrGX5mWSBcoZApNO1n+03L3atKGr4qfbi3KzVpMjRjpOTJl5nANVj0khCncigSlj2c+x3hZSLVVP8f2fSdXXqkrjpDkRbSX5pg+ccFjkA4m9tWiGGsDbchpbh0RbbksrTGH5mS9fvNs+kdsewa6NghMlzJmTRdUzFWuxWYjNKPBMX12LoOGJQgpJmBbSIgkAtmjE/scVT6y/spjJugrt1Etk5wjKEkBTJzKvJR7ovaq5CayxUN+lresUUg7QkZ7UpXPxHNI/kd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(64756008)(71200400001)(186003)(66946007)(9686003)(76116006)(26005)(52536014)(55016002)(8936002)(54906003)(110136005)(4326008)(316002)(478600001)(33656002)(6506007)(7696005)(66556008)(66446008)(66476007)(2906002)(5660300002)(8676002)(7416002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: //paPGaqyNUB8uO3eDL4MW8SmTw510WMt11D0YFdn+Er1s1fcw2yPjB5s8vQZLXY67LKjg+pP4sBl9xxsyC4j5W7lh8ov6hx8iKOc3mFWtMOLtpe8BcHVTkODiG3hq25BsunjIG/2OxSJasYw5iGtoZBwNlwTvbvUs/Sk+ukIq+PCgFbZTUT6MlG1CrDh3i6hf+Y/ls45M1c/YQa3dNleL9dWnVWje+AG8zUv+U/oJu0KO7/kHzts5kp5u79AcbYYUWgIz6sULKmqUGSrpXWKjjIeQavFx8AWVHxLpsN+V2Vi8r78gWYsoRd42Tev2bCd01iPl+Gmv9Gs76B2xcWokeZdn8AHnGHVWdBy0m7P9cNIWmx+rk86ukQX27T+prX505tQcTXeqsIE7XjhHFA0DaQ8ELRJNLa9I5sJrW9IdixsPyhfS+R10TfYQcqr1WXoNGAYQGFjxx7lTVG7XGp59bblunPZAMqMlMAHejxFkXzQZWUVtkwV5QsKIgUJ6t1Wxb1q4jEg5UyAz5pprwSKBRUumGcH/Ma7kAi7ZTtWYpSaw+K7MAzPLTLDMSM8tr8eSTDGns7ymrO3jVYp3JLgEhpB5EbTNdXT0BlYU0N9JC3aTq+CbNb5f2DjjxUNwJ8bMbDjuAJHdpTmFt/PAQWTOXZWcc2H2m9Axw6u9K2pxlDWRC36XhupnYGLnQ270S7zse1kQep8NLcZBGNVzXyydU9TCUpCnA82UYWI3hbw3qAz+OZIlTcomRx9nDlAKqsEHIbPtJZBy7J5BJv8JfFnqcLk3cKQwXYvCGyQyxJTu0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7ea914-50f8-428a-c6a3-08d7f0173303
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2020 10:37:52.5554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0azwE3QTOIOHDw9GsFQ5SYRtlRFQqTuZtUtMCpJhNR02QmTZdrzBSvWL0eFX0Q9zUC0/fRqf0lwaY9BoP61NXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5815
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>  static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
>  {
> +       if (!ufshcd_is_wb_allowed(hba))
> +               return;
> +
> +       if (hba->desc_size.dev_desc <=3D
> DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP)
Should be=20
DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4=20

> +               goto wb_disabled;
> +
>         hba->dev_info.d_ext_ufs_feature_sup =3D
>                 get_unaligned_be32(desc_buf +
>                                    DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP)=
;


>=20
>  static int ufs_get_device_desc(struct ufs_hba *hba)
> @@ -6862,10 +6890,6 @@ static int ufs_get_device_desc(struct ufs_hba
> *hba)
>=20
>         model_index =3D desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
>=20
> -       /* Enable WB only for UFS-3.1 */
> -       if (dev_info->wspecversion >=3D 0x310)
> -               ufshcd_wb_probe(hba, desc_buf);
> -
>         err =3D ufshcd_read_string_desc(hba, model_index,
>                                       &dev_info->model, SD_ASCII_STD);
>         if (err < 0) {
> @@ -6874,6 +6898,16 @@ static int ufs_get_device_desc(struct ufs_hba
> *hba)
>                 goto out;
>         }
>=20
> +       ufs_fixup_device_setup(hba);
I don't think you should "hide" ufs_fixup_device_setup inside ufs_get_devic=
e_desc.

Thanks,
Avri
