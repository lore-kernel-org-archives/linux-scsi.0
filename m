Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59324C3A5A6
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 15:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 155B3208C0
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 15:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="PMw3sAb7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391412AbfISPtJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 11:49:09 -0400
Received: from mail-eopbgr750079.outbound.protection.outlook.com ([40.107.75.79]:44060
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390076AbfISPtJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Sep 2019 11:49:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtF/22bxoETlyl43njw3PS0CSu4Qf37FlBA1435ppVZy45BjU42755f8amtlpfmmlsUl+kXJz+55pF8Zh851QCB3kefOZchNkFPCxn9gcBcm/ULRU9Y+OzDMv5cxHzAsopbKBOLptUDh0sE5IaeEbFnWCl9V/AYgztQjTZY+5f+8j67fY/C0T3EVj3ffDZhmxgcKkFgMbQF0Ydb1mETE9TnoqlIlmTBfzyYK5JzAWnnOCj47m+dt/RgYyKpjfX6HCVgQP8ILC8fEhf98Mmu9wS4+LOwLOxyWnynewpPxB9hUX3PJ1Z94tWz0hFnk1FBqfITdJVEDUbu0gx4ZUG3qJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qux+O7/PIqdrn4LUY39DdBOlZFLBu1Y5kGMlGfsBkKw=;
 b=BscqZ2ZZfrvwnq8yxNyjqd3uHdZg+BB0lAR7LgIoTk1doVLRB2LXzpQ58odKh+p17ay6uGU4YcIGMhEzE1OPqHHPKNh4P3/upsnuWwBM3wda0YUVvFMXIP2UBeAuWRbOzNPDw03V4tlcDaqS1tcuVsl+4DyBvWQenTpVmUlTzzrSNmSmh5bpjemc+jmw49Cw6Kni96uZKclBv+FbmZ/u5SD6rqCS27igSOsS3Dh8vnzwicgs+r4LQg8MnLCMLRs0KHzwYSx3AT40l5CNNE/aLo4s+huRvq4bI6SCngmbk06xhaoMLX0xjaRNjkY8nX08svcm3Nh1S96YgjjkPnBJyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qux+O7/PIqdrn4LUY39DdBOlZFLBu1Y5kGMlGfsBkKw=;
 b=PMw3sAb7HnDm81IHLKxKPkNfv9XsdPmLuZjdF6+oODXs4BuIxX/n4CORn1XczZROHAyJL4+EST0B2kCSk4RMohPDsuZTThsFR+l1P4ysX1G5rVb8GqV2eUPJRBHfIYWoO3ST9NABpdc9cdUeRew7MH9c8HmRLQbo+AXfoMiRC/Y=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5540.namprd08.prod.outlook.com (20.176.28.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Thu, 19 Sep 2019 15:49:06 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::1c5f:b47c:d1c3:c30c]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::1c5f:b47c:d1c3:c30c%7]) with mapi id 15.20.2263.023; Thu, 19 Sep 2019
 15:49:06 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [EXT] [PATCH v1] scsi: ufs: skip shutdown if hba is not powered
Thread-Topic: [EXT] [PATCH v1] scsi: ufs: skip shutdown if hba is not powered
Thread-Index: AQHVbdhzTeX/aZpSQEmPmvu/XpmQPacyzhAg
Date:   Thu, 19 Sep 2019 15:49:06 +0000
Message-ID: <BN7PR08MB5684156E52798096FBC61BDEDB890@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1568780438-28753-1-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1568780438-28753-1-git-send-email-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d9084bf-ab6e-4abe-4c23-08d73d18e776
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN7PR08MB5540;
x-ms-traffictypediagnostic: BN7PR08MB5540:|BN7PR08MB5540:|BN7PR08MB5540:
x-microsoft-antispam-prvs: <BN7PR08MB5540AC187991CFD8F9800CE6DB890@BN7PR08MB5540.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(199004)(189003)(7696005)(71200400001)(81156014)(81166006)(74316002)(6436002)(7416002)(71190400001)(8676002)(6506007)(6116002)(102836004)(2906002)(3846002)(26005)(55236004)(186003)(558084003)(486006)(76176011)(2501003)(305945005)(229853002)(14454004)(11346002)(54906003)(6246003)(4326008)(476003)(256004)(66946007)(66556008)(66446008)(76116006)(33656002)(316002)(64756008)(9686003)(2201001)(52536014)(110136005)(7736002)(86362001)(66476007)(446003)(55016002)(8936002)(5660300002)(66066001)(478600001)(25786009)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5540;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8k2U69pMVV75B70gvmmlVo09GzqGOVhjMdWBs37k5ushXN3SXVxEC1EaCr7WMx6rFHXCvmRV7zKKLBPeCfCLgzMASu4jwETyLV0z7zi3QgZpSMMqUXQAjI6/1jNlVQkLGvU4iOxv8ewGDCaf+M3fSekn0ZnqLCiXekC/vfp1/BlnlqGzTnfzcei3yfn8f7cTmxrdgpLsSgF2TGP3KFRNz5+4vXdJTWz+h89urN/KrCDRy4zpm01Pkx0xx1lL5nN6KxwB48aYJ2NHV6fqRhH65gCP+8IIh517igY9GUaCiktRLJ45yyAWXlWrknu6O+G3EdpGB7fVfgFulURCYTkRMtAoSHukYvB2OSsrwNiCn1A4xTDjV7df9Q+22bsK942dbrRZi4tGLP0NNSJUQbmp46+2wGqWDvqLsBXoenasGgU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9084bf-ab6e-4abe-4c23-08d73d18e776
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 15:49:06.6424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: epgbumimcOIeL1tT6Vw1uPvQK6Z2iRncx23AznirCe1cl8adOB2XBTn/p+aR3qxnDcaG1YV8zVkcRAX1ubxBxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5540
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>To solve this issue, simply add checking to skip shutdown for above kind o=
f
>situation.
>
>Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Acked-by: Bean Huo <beanhuo@micron.com>
