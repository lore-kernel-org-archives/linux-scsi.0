Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEA5C47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 07:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF7E1206D5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 07:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZLO259zZ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OsRuotv9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgEHHfs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 03:35:48 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:29947 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgEHHfs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 03:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588923347; x=1620459347;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X5zpXGzypz+RUfEDSxNZYpScsSgg3HpAUCUhb3mVpSY=;
  b=ZLO259zZWrPTgN7ERiVlX6M8w1rKuHctpNbjDwK37WvdTEA2RvRcHy/6
   o8gUEj8UThIi8RvJD2n/obkoYuOKn1Pnm3opDpuS4Y9RkDwbCIztuzBpB
   joUm/wCOKJvTtLwPP8j5F52Apt9aMZi3nibTE17snPruqNJVxBYerVbb+
   TpPvKA4tBpC2nx9/3HJZMI8gse9bx+Zg2WV8D86eCq/DI9mf8i0L4tmSe
   d2PgWqb99ivKyC7dJW5nZd2a3m6ObE9jccppLndN8e57rJGhjjyAor40i
   Jrt6jxn3kXEenFmJewMBIhiZnCIw+h2+eih8Kjw4XXbhxU+CeJJHCHpe1
   A==;
IronPort-SDR: mLiukl/iEaDcfyte3dnKMYBvtGRzRm51497jfvfleyY+qgdm4+myOPsp0fmwGGje6F83QA4zoB
 c/6XHtXciHK1eP+cep56GwFKy/Mdfadcv2pPRXUnP60InCK3dK05YX6vkoj6MZn6+qe9B1/ol/
 G3FrVLIRX979rujqDAVch9PRCz4AhzDyy+BQ0pMrsVpXfStHTbAFmukU/G6CbzlPMuRZ/TTdsz
 o4AkfxQluKbbQiLDqa3ZqilYDLE8xxTIb3VLp0X1uJ0b+5vBRHrHQB+IV8GAwgmpwESq+JpEeB
 Ec8=
X-IronPort-AV: E=Sophos;i="5.73,366,1583164800"; 
   d="scan'208";a="246093381"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 08 May 2020 15:35:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEOWaOn+FPnuWU2vJPnzlx+kbEmcXnejBNF0xJbEPnIWRXHEJqUF7cGR43YB91Hqn5pg+0wz1tVApgzPpCkBtkkHIcGwXpXtt+sUaUr8RPv/JZLFWSz47k+7FLZkhkONpeEtTFzrHA18B4pDTncrQVkQtt6PGmGe5GAveMh1UQdG9X4l8WEAKGtsDSRFT/7mzUGEU1y6S8ea26eWKdc50YhSDt8x3ACcI1npS/Wb8dSkyeJDMr+nUTGpnxbsaSudhr3mYEabgqmkim0HVrE6+aWMbPQTssN0+UJCvzkmcDLBpbckP6X0RiwWKHXL6NnKiQwqJmnn1avWZ4nCgkA9WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+8ELw6aHoSUiZfVKYmdXzmRh2+/ZAIWp8FU0p5Ri+0=;
 b=nT1/bYuQAM1QCh5UtJFnaIPAlXDPLkwbAGwJw3LwxPkOZVwVwu2PYZiaCmwsyypFkOwfYyS3YU76EZf/GSZkHAoVhAS2iEFL+hAyixyIEKFbenOr7KXlQJOx4JK1P7Tt8/0jnOaKQBiHyCK+/V4kErc5ZB/F1slT6Tw0+zF7+2s6fsCSyM3znyDskiEWIhYJUS76sItDCSMapW2q8C6s4x2x+34hvYAKfPyJXFIzIBi47DP45Bu67k4X5RZ8F3lqMVc4ACl0KNuiPyMJTla5ThXe+bDy3mMq9nyESebWrtdclXGhgxdhvYrQzSi1LpK/vui0jeQRMZfMFXs86XX2UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+8ELw6aHoSUiZfVKYmdXzmRh2+/ZAIWp8FU0p5Ri+0=;
 b=OsRuotv9E5gR3yUCEBL8IIyBjS7IDG8sN8vuCo6BV6KYvFejfFPvzzXcxsZ4glD3qxztaTozlGs08v8vS2EdBgyeGkQkO3FVakx57XdGE2jNoQVNtE1EZ8CZ6stkygD3H7UAVDuO/OrdGgfeuWy+38pJ9zsphK5B3V43bjeJkpE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4845.namprd04.prod.outlook.com (2603:10b6:805:b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Fri, 8 May
 2020 07:35:44 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.2958.032; Fri, 8 May 2020
 07:35:43 +0000
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
Subject: RE: [PATCH v7 1/8] scsi: ufs: enable WriteBooster on some pre-3.1 UFS
 devices
Thread-Topic: [PATCH v7 1/8] scsi: ufs: enable WriteBooster on some pre-3.1
 UFS devices
Thread-Index: AQHWJN904L6sndOEuECiOw2U04WYjqidzIYw
Date:   Fri, 8 May 2020 07:35:43 +0000
Message-ID: <SN6PR04MB4640F483F0821F76DF6C344AFCA20@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200508022141.10783-1-stanley.chu@mediatek.com>
 <20200508022141.10783-2-stanley.chu@mediatek.com>
In-Reply-To: <20200508022141.10783-2-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 481c8c9f-8e28-45ef-feb6-08d7f3226aa3
x-ms-traffictypediagnostic: SN6PR04MB4845:
x-microsoft-antispam-prvs: <SN6PR04MB48459F38A8756AF880879A0BFCA20@SN6PR04MB4845.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 039735BC4E
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WLcD/kILk2XNVkIfjc6iuQA3EkaGRvG4yIccRjx+1Pg/Jl9HIcFrEcaHGEyqJ8PhI+2ztRO04jMc/xLwBvx+cBw72mOo/xPzPst8cjjWKBKG8BQrxR1i4JvAtd+j8KF3DfBB0Hsa3aGQqEwkpyHeWRgdX/gZ/CwJ63CDBkvhufzdG246b9NCc6LljSbywAWbNaNfnBIq/2NTcKxpFNIxqp/l1QaPmNGcPvocSJJpv4EZ41/DR5GV8opGS99UzbZeHO+am9ZvF/UPlSeyJyN96fOxakgnqMhrEYFJeSqzRMNFDG6Afg6NrdtX6PXLSmilbMeHJX0KP8VFYnf14r16FT1oLHs15wAKqqK0y9tHdbZo1wkW4i5rciC4sg53PBMxqztf1QwTKLB99XH72m9ksGX4SCg6Bl5GRqQhoh7E52Rw2IRoLESTENRbBuzLp/NUHa3ezNkphZ4rEyc90n7FjKvYx4mmQ1GWv+q0aFEPScm7WP50hSyvw4qZlEp8ox7ghTd78LBYxCBk7msWnPfK9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(33430700001)(54906003)(66556008)(7416002)(316002)(478600001)(76116006)(66946007)(7696005)(5660300002)(33440700001)(83300400001)(186003)(8936002)(83280400001)(83310400001)(83320400001)(83290400001)(8676002)(86362001)(66476007)(66446008)(26005)(71200400001)(4744005)(33656002)(55016002)(52536014)(9686003)(64756008)(4326008)(6506007)(110136005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bgmRUCOp0IPIHtvfLkfdX7av0az+TjvVWuDfdmF/MLFlqgiwcDTXazUC0hJX7Gw4XI85VBxRtdWaoFDJMipQnOX32ApsZVAZh7WpDCpqyMZoNkoaKNiJXRD6+6oChBhAyHAPf+iFnT7REuG/OnhwQm7zqOJ9DQEEAjaCWfkh71NrWFl6bfeKqSX27LhrmBL4fazKSQ+m6hvV/2cJ6lXmNaj/nk1pgQpVkwvZFln/7ou+jp36OjZypZC1jQLLaFNpIIbPsqL+kfHIIdrPVNkYMmRcHTfQ3HFNEGPpubxsLCuKEOGd7GLUCL105EwBmTy1lppoNb2nnQChFlGspYSpzRX7shf6YLOiOIgWllA0IwxUyRX4pD4VMYatFIHavsXendLJlcXzQQeBtwc0ojvVFlnY1vsFXhHW/5+2zNXqw6Cn/KRThYdMwDLayn9+Uz8PKsuY4y7jcGYdVi/022UAMilMS/J6VSCFH3DrjA4VpNo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 481c8c9f-8e28-45ef-feb6-08d7f3226aa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2020 07:35:43.8825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QzoYbvvQQKPpsFcTsqtk+8DFZE++iXZ5NvLoYGhNMNz6TrPtuK+ekaqTx4ib95cd1JiRzT1Xe/bgXeiljL5oDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4845
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> WriteBooster feature can be supported by some pre-3.1 UFS devices
> by upgrading firmware.
>=20
> To enable WriteBooster feature in such devices, introduce a device
> quirk to relax the entrance condition of ufshcd_wb_probe() to allow
> host driver to check those devices' WriteBooster capability.
>=20
> WriteBooster feature can be available if below all conditions are
> satisfied,
>=20
> 1. Host enables WriteBooster capability
> 2. UFS 3.1 device or UFS pre-3.1 device with quirk
>    UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES enabled
> 3. The device descriptor shall have
>    DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP field
> 4. WriteBooster support is specified in above field
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
