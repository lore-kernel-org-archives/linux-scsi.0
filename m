Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCB1C47256
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 16:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E80206C0
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 16:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bTbUTMaY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ibDlQrYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgEBQF4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 12:05:56 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:44331 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728222AbgEBQFz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2020 12:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588435554; x=1619971554;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xNBcR2//G22j27sRwbubyERAith4zF/J0pnVDuKecDU=;
  b=bTbUTMaYrY1ecugyfShtd/JS6Zkj6bF1Qge9fr/CAmHlWuelIKvFnBTS
   UFmCC22OxkDxjsyGa3afSfhAS3wwWVt/IB/UqDuMJ+rIYEfW94H+IM8Nb
   uc7nFHbQxOAvhaDMgRVOwJTv3jMLKmvJGe3wioXqSo0etHgbeOIoLcfn8
   hiuuzFzDQFCruelYiHLZRGcNBPFEGdRNVL1/qIgBMtPDOePgz26uozNLu
   g6JPdliEW98cDsfNy1fR77OP3khUsKNOZmRSusRM9ETwlT1ftrjmYYEZT
   x32UdeleM5x7iHCKe6MaafMrvK1aMDEubKFagPDsOPVU6pCfIGSf922Nk
   A==;
IronPort-SDR: Il1spfjlUzFQRv3PvbJvlFyFAek2yhTbtdKwsw35YYQ2R65Le6Ds8Cx7KZbbUD4Z57BLWj62/x
 K1bkhKFx1VO19dAe5TtWK8Quk+Ajgz0RpWSLCFyK/3BKTW/B/6z2+sGSC3QwiA0hlkQemxgcmb
 KvcfXKuV8BT9Oetx3EmJBwauusI8gkl1NCQjMpUN8t1z2Ds5HB622pSKEeaZDWg768yMsh0his
 Cyd6zVLlEkqdSBD377uKYibFHhASnS008XJQBa/OaqRZoVZsZ+L6hPZ/eH3+MgzyW+UTiq84Hx
 CGI=
X-IronPort-AV: E=Sophos;i="5.73,343,1583164800"; 
   d="scan'208";a="141084371"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2020 00:05:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfMuTCXGAmfOnyIhSM0uHB/CaZ354f0lxHBXwVhvUjzrOzOeSAjyiK7qW9c6Az8p5cPKHQ/wRZ4NEBRj+A3G9zsyZhef0yFhbRNmZ9/oDD2C9ypXihXxE9aK+g6oZXNq0Qtrd85hb1dua7WaqzdrG7aq1m/s6rzP+Y5sXcWWudxHE2B7CZI0d2cClhIQEHNW3kdOnz0Bb5rtBcF41+0IN3q1FgZO5oX63spFtUM0TnXlCZE1a/PKOCz3vJAQXL2qKgwCeMSie1hG8kaJ5WhbE3x0UxvyofPnMOE07R7V8XgPxIfl71j+RV++yiVGE/aNh9iGb0btxRXFDZUNruE3bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zXmMO5Zpy02Ngq/eYIfJrkGb1pQt3gpzUPnWy/MHSA=;
 b=UnUz6nPKtFaPKHuXva/sLNLJzxjuT122JbKwGLydoqRx/kovzJWGL5BxABtqk+1Wui2r9pNPcVBxC41wHy6Lq3DIfRdSwdJFn72hLzppep3QrVNRjy+N1wzqCyZbuCzKeQG9ooyZjjzM0dOnF0LqG4Ygejrqo3gCGCc2KDaKqLY4JLj/itLcXVlFw6KUfceLMPDGLodHGsJv7UxLbWFH7Vy221RhX4H8Z6BjVc/joUZpcOXGHXumTtRu1UjY7AhFXrOqiMZJsQSAjLZKpiOXA2Xik52x1LQPNbEN4dZNXAVeWr/TAYas0iHcjHgDkVssM05HVwX4nAbydDIzqiAU+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zXmMO5Zpy02Ngq/eYIfJrkGb1pQt3gpzUPnWy/MHSA=;
 b=ibDlQrYvU4/PN2Khj//dro7uKdvOQGXU8UvyE9f0UEx6yfyFdTjQdISR9/q4XK9BfRaK22KpOWXoNRkMRXJcxgPlcHatrD5OHDydqLc9VGJov/lmsRuIdNaK8pAChFLNb+epj9fllRimx1sxfCDzPt1YrEo32ma5OgM9pd+RrPM=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5293.namprd04.prod.outlook.com (2603:10b6:805:f9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Sat, 2 May
 2020 16:05:49 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.2958.027; Sat, 2 May 2020
 16:05:49 +0000
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
Subject: RE: [PATCH v3 5/5] scsi: ufs: cleanup WriteBooster feature
Thread-Topic: [PATCH v3 5/5] scsi: ufs: cleanup WriteBooster feature
Thread-Index: AQHWH8Y8HwH/XjgDN0+LaZXQUAIptKiU9sHw
Date:   Sat, 2 May 2020 16:05:49 +0000
Message-ID: <SN6PR04MB4640099431C815833394022FFCA80@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200501143835.26032-1-stanley.chu@mediatek.com>
 <20200501143835.26032-6-stanley.chu@mediatek.com>
In-Reply-To: <20200501143835.26032-6-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2a00:a040:188:8f6c:c15d:86e6:9e1d:ec73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ebccf45d-1abc-4e64-43db-08d7eeb2ae6e
x-ms-traffictypediagnostic: SN6PR04MB5293:
x-microsoft-antispam-prvs: <SN6PR04MB529374AA43FADC02B6B01F42FCA80@SN6PR04MB5293.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 039178EF4A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 01LXZStgbLGol2C6TkPSCIzNVJS/mVzWxsguvTwbept5BShp88hCYLKBMM0L/zP1wnh2CCVu7DgKxiqQwvZdIZ/O4b/heaMjqY5+tM5roo8889IgrhNUf9Xvv6ONOZErU9Vf+TdYBhmEDrOi7hv1ei4tL7MFseylBp5dlJBa0R4QjMw4of6wGzeRlfsv/yXV0JGqgwvHluwoabVfQbBHDu/WI23Hm5gx+f9FUkXKGG8nDUDFeQI0hYYh2SyfrDm9aIH6mlcLVMTeK2lQ0q82baPvqZFtDQUFIIuQN+oYLfD61OERvSlY5hxmQJoAM47utwQqSr4rzvqz/FjLJ0DDBTgDaK/dJBu584GXGZfdaD+7pHEYNABSnqQdXby77KT7i1NQO2wK33BlCF4KxnP4NoKOTjGVdl+Ww3qrhVoCsO2nOwPvIlHyavqYSrG4q+o+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(4326008)(86362001)(478600001)(7416002)(5660300002)(6506007)(2906002)(186003)(7696005)(9686003)(55016002)(52536014)(4744005)(64756008)(66556008)(66476007)(66946007)(66446008)(76116006)(8676002)(54906003)(33656002)(110136005)(71200400001)(316002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: f8KZye80L3A+i3CYpc/WhHWDfQadBo32Ofuc0KAqjhT9HzFwK3mze8txrKT8w/FCtNpkl02F1EglHIvqpsJ4vFU6LC7zj6JLMZIRgzgWFM0EYiWLBcDJX8KPQMeo/uSafhuuCVZkf2HriizNdxbiTx1LgpVYSn2xJOGjUJK9TqJoTjSHfmDksNeXd1VEn+1/2bhoxm1mY9v60T0T0MYhAL7gbnTH3MXtT/i2uUFLTshtzeTdXZDdT0voTCIpIulhnuPM+SYAUWt1EXF4ki68c3JqKMvUouxkIA12UahJr74ZebK50fpVjJoefNZ562wmdb6yB7oyxOz9WwdBwSsKK4ZUTLO4Yr50DJUewd6bBejL+VUUDpf7UhrejsvNOTraJ1gPPnlmbXW1PQ1FQ0TQCyksbDFiDKk1DHs9JwDKsfCdCJLyVv7Pcxob9OFPZHx7YYsZHFhWfyA6wpsrlKRoo57TWb/0gmPDli7Dg3G7l9siiUA6pqHmhJl2qMzovVfePlE815UBsMV0OMNTs73jvPb3I9vTakXFynmRVM8i0dazXd0LHP5IDdswo6EBuCPkPSblB6ZVjP5R2cqPSbC6dV0doTxHS3ynKd3nFOJ6UVJSxVbPIk/Ek6TB+PLYACg8Y4xrQT9dGKy/5RCfLreNbhteHfBEOcFXbXTR/RIPylHRlasUculnAyCv3KaxYc44W1t1+hZpPj4FGcA/HEGbppbX/uus18HYFsWx/hklJ6FTWw9t8KaOjxEtfTCdld+uFD7moLSt5CSQpvzB1jRYMlEwuQ6BszrQenR3c769Hhz5HGG4g+w4u2U8J/54JlOx8rPdQXd5lR8VS5OrW3YCRLnjIv6ldMdRkv/dF6Q0rXM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebccf45d-1abc-4e64-43db-08d7eeb2ae6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2020 16:05:49.2416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CHPQ3hpYm5SlKD7DAyzk4pdJoQFW42JkCCJzUkYFrGyR8AIbVp7hDDiH/mEhIBhZUIbO/PmNxHVCr+yaxzMgRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5293
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Small cleanup as below items,
>=20
> 1. Use ufshcd_is_wb_allowed() directly instead of ufshcd_wb_sup()
>    since ufshcd_wb_sup() just returns the result of
>    ufshcd_is_wb_allowed().
>=20
> 2. In ufshcd_suspend(), "else if (!ufshcd_is_runtime_pm(pm_op))
>    can be simplified to "else" since both have the same meaning.
>=20
> This patch does not change any functionality.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
