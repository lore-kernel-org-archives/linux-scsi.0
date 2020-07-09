Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C3AC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 05:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF8A82053B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 05:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BLXjG3xr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iXwmOR4+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgGIFQS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 01:16:18 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:1223 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgGIFQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 01:16:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594271791; x=1625807791;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5bmzxdNseWDWb+EYi6IfUVSqHlyVAjiXlar1aumKodI=;
  b=BLXjG3xrMmIDWbCNYLN9dIOsbP8O8XiQcJXkwQYy7b4xjUMWrWQw5W+A
   g8S2jiWMlgawuy4VI/r4gJ3rE+IxY4f1eqUZ9faVbGjoAF5Uql98P9Jvz
   sHl08L3sNNrn2I8wdF3wGSt369Dxrcgy/mG0+ZJwyRpEsmCd2JitLYvmU
   0Ge709LDlIO9YxWwDhv/H4pycA336G++w0+cju2hOm4GFy6Q8fqwuIVRf
   cI/Yb7Bl9PUVuZ8Bt9gGg8hX9Lid5xw3cuESQobD8zb2CEZAJ3L7jF9ao
   9U1K9K91ifbttjBSCELpOLy3+iSgvLPslbddISbY/NSEhYcOVibgDkIC6
   w==;
IronPort-SDR: 2NZO4gfEFYPFWbo+3L9LD7hlR1xAanfT5NZC7RVEhSrhm3CTi+5SLZ9N4zVT2TTc302ZaiR4y7
 tmYarLvYz7PDqH2/l3kfigT7KbX9ybCLI1zfeD/N/aDSrsMPXlxykalerGFuE0MuIUkrvDD02C
 j1a1EsAAkkeyk/jYEewAvGp7Zf7QBVvaE1D8AtzCV6XMjo0KgVrhiGwHI2CZtjf2r11NzYqnbc
 TgRmL/EuX7iL1NStK35N2AUCV/QuvDd0AB50q9esh0+N/JO+NvcpG2laoD3REK1tOP6OPNvLPh
 HI8=
X-IronPort-AV: E=Sophos;i="5.75,330,1589212800"; 
   d="scan'208";a="245012151"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2020 13:16:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X00KiSxR4lB+2l0j4keUSznvOlPHfsBSpei/a6PEF7sN3GOJNhGpSCBqdBJ6U4hurWCPFDNMw2cpkHE6s2wihXlXYG4chLlm0SaIEpzAw45h1SiRl5d/7xWs/5yqzeEc3OETOfhCdc0NvICwlh/9+Zj5ZXuM81L3A5G7Jn3JD8gKiIFyqt2G6H3kJtICZphbjgpNjsO2d/N4DVV57FsITMGft+k6eNV40yPW5No6fx97gdMiNqw2qzAnEanz/vJ8G6K/fX5C+zrD38mNAhlWJF52fCK7goWcv/qYIGxuJF7Dih3vaOtcRdwA3MyFK7Ymyp6591sl55s+ree1dtNLfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bmzxdNseWDWb+EYi6IfUVSqHlyVAjiXlar1aumKodI=;
 b=OBpjtjgX7XL7ZkmQ3VdhuAsEfndk7cI2XnxPBa6tYI+8A/i9O0OX+QnzQ3LGP/Q+1CXTCEqcONFKvLrli9+xPIbLh/wvhjU/pE9rICXYPXet6LFftDI0CdzhiRvE9Wpk+Pdb9EK+h8bPmrfxMQA7Yms3tCgrFW6v1G77hbB14twY3iprPVPTKjwhIItSKuuHcmelqOSK4K6XcVpoyfb8yyuR5dFZEnkbhBkApWHALJgBcOqwLf6ARjouZhEVixkh92CejLBg+8Aq2m7wg1Xml2iuVi+sd0R0a2I/wNP2DsQ2LD+Tfw7MGqZUA6enZfN8EPFjK6UGVI12WzrvB+8lag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bmzxdNseWDWb+EYi6IfUVSqHlyVAjiXlar1aumKodI=;
 b=iXwmOR4+Y2GRIGxSo9Vx7/vyc6W/k1nbmxbc4sLDIP8iJpiBj4AgcaPiR++46sx26EaFhPEWae2JXDGYV94C+9mKOn5B0TBlTobtcp0LhIOus/xMYgOhMxsEW8LqoXTXzHKPKgmEZGpmwfeXggpMDLc+ilY5II3z6HLwymwIXVM=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4960.namprd04.prod.outlook.com (2603:10b6:805:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 05:16:12 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.031; Thu, 9 Jul 2020
 05:16:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWUMe/HeWQynTPF0eBDwBI4Q2f4aj+XPoAgABhPNA=
Date:   Thu, 9 Jul 2020 05:16:12 +0000
Message-ID: <SN6PR04MB464097E646395C000C2DCAC3FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <963815509.21593732182531.JavaMail.epsvc@epcpadp2>
        <CGME20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4@epcms2p4>
 <231786897.01594251001808.JavaMail.epsvc@epcpadp1>
In-Reply-To: <231786897.01594251001808.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1cddac90-9cac-4927-c408-08d823c73279
x-ms-traffictypediagnostic: SN6PR04MB4960:
x-microsoft-antispam-prvs: <SN6PR04MB49605AC693E2E14F399EBB5BFC640@SN6PR04MB4960.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kCRnez6Id+50QjAPMdD9KSP06nycw/Eu7mi8iMCLVEOHqwAYkmLGR0+CV3lSqfukeGM9XLo7GRD+vrX/lCbckKI4i6XnbK1cyaRaq5OLKerJ2vODWWcOKoPrfJMVlizhvjuJ/o2R7BdMTfBt4GgvE6ECUNCiBw+ApG6SeBZ4A49UiJwp3XzwZnCseLU29n+VhmW/C2ALzHh0vqEomU+a6uBrq5LLSbR8/JIltEM4z4Ke5BEcUIkLDTBiI8fLzWyoh4992jX2KhJ3Tsxkz9if/9HJ0XgZB9JK3Fod9F2mdN0hI7zl8ZVYARxDJ3LE01Xo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(39850400004)(366004)(136003)(558084003)(83380400001)(8936002)(52536014)(7696005)(110136005)(54906003)(4326008)(2906002)(55016002)(316002)(9686003)(7416002)(71200400001)(5660300002)(66946007)(66556008)(86362001)(66446008)(66476007)(8676002)(33656002)(64756008)(76116006)(478600001)(6506007)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YBlbQuNqyK6E5hZ7Pmxr6P/8Ri9DzjvhDUzrZEur0lXso7i3WTnvlIkakEwhgD18hOVSOl8IHKgn2LvIwO2vp0r/ycqpnX0kgdzsORFjFs9z9PqDaM6g4WzZ9Hlg0gAbX/pIKKv+uA+JZnOYv0RWtLAbrl7eh+miwkoD07KQ0oyWa9qu5CYKTB3im1LEN/w8ChRiyYwbNGyfNgUBdW69tcWMV27EGl+6AOhZurLdX07QTlfddQ4ZHpf6UdZ5kLmwWz8UxT2m/GgghbTb/glGjM3OiiGxz7OKak8IOldbFe2J/QJDYdpDvdr8Wb9dGedARqEpVmyjdvFGY7JwFTxciQS3amKE6CAduR8VsSFz6Pz8QGQKe7Pz/GzGqdb/kJf7kQDq5zQRNjSDzCkeMcLxSXZxhF5Lfsm9UAJcmJWjKEJscPeilpikmHNaaJZ+5sJwLi+4Inov29Q8ShV+2OsAIltOA6nu9no5wp7aa+xsRd0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cddac90-9cac-4927-c408-08d823c73279
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 05:16:12.4060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jwzVbExVKbaWYpl7QCv9bu/EOhjZIioBZv5n16q8O+rkQNDDGWMQ7a8KeKmKgUMsApGxCAXSNuAWTOiUK/dbUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4960
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBIZWxsbywNCj4gDQo+IEp1c3QgYSBnZW50bGUgcmVtaW5kZXIgdGhhdCBJJ2QgbGlrZSBzb21l
IGZlZWRiYWNrLg0KPiBBbnkgc3VnZ2VzdGlvbnMgaGVyZT8NCklmIG5vLW9uZSBvYmplY3RzLCBJ
IHRoaW5rIHlvdSBjYW4gc3VibWl0IHlvdXIgcGF0Y2hlcyBmb3IgcmV2aWV3IGFzIG5vbi1SRkMu
DQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gVGhhbmtzLA0KPiBEYWVqdW4NCg==
