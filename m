Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6787BC3F68F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 15:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EECF2468F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 15:39:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="pKpikirx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgA1Pim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jan 2020 10:38:42 -0500
Received: from mail-eopbgr750053.outbound.protection.outlook.com ([40.107.75.53]:20133
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726829AbgA1Pil (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Jan 2020 10:38:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtZW/HbWaJphMsno//sfK1o4jLtjy75AXJcRi6q30HB8npEelrXh439JuanKIdMaVO8FD0ytfJrtzWsmrZJz+WWrSjYg46h1C+lz1UmaCYJ9evRaatSXL1XoV05HqCgrFW9HZjtCDiDXLoAZLdmcq4Qw6m6IZlsgM6ol+eUWqtNnubWE2/80Flgvfc4Bnr7PIUle+gfbPaTaFC1k8ojNLflvF5aUIyTlSbge2WPaMYZfBLMcqREPAzsrPY2MF18ua8PxVZhXrpWujbJlQwbR/ryUDf9tdQFYO8og3/FhKbsy2RHvRNQ4uqFUrZ89pTzUoY+L4woyQ71XuXFNOV8xcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1Ebke6eveyxao7m6TM2J+k5u29xj8tTIql2r8ll4bY=;
 b=AbAe4p4mYdM7OW71LpwkN16xOdiYIAPZ2vDsAuh9quPpQhjhC1t+Rm7hRyudGd1zA4ZkxYFKScYFfe9SzSPaUPXmbnCyNHD5shubjM3dnNgsOuKc/n94OYGHlUy3RwxBCD2AA5dmGvT3hlbbJ4jE74WCtwqjSimQbGBfNWDSfKLDl96Okh5/P1VTyLyIGMOH+LIvOIQFs4RUmYpZuXFSL39v/ZPVJK+W4V7ThiPW+Il8+yKZ9iI8h803yhaZR8wUiiHfqOFGlHcRMSw2dyGIl+YOmdYtkVsd/M1sdldUD8OlPvE+e7QL07Ubea0YVnYLRjdV7FWs3UFsgsXt8tiVOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1Ebke6eveyxao7m6TM2J+k5u29xj8tTIql2r8ll4bY=;
 b=pKpikirxO6t+XQFv/XlaFpGY9PpbXvzFJNvcOT+wSAg4iFgAHO8mHApIDi23rbV5oLn3Ts9kGTmm0yuvm6z50MD/zMFVENYwokp/tUWOKK4bAF1GI/nUkJlXbS8g+C5I1GP52bLSSyah3xqR48uWYf6bIUeNoHSILwJUpFQpEPU=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4324.namprd08.prod.outlook.com (52.135.251.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Tue, 28 Jan 2020 15:38:38 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2665.026; Tue, 28 Jan 2020
 15:38:38 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
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
Subject: RE: [EXT] [PATCH v2 3/5] scsi: ufs: add
 ufshcd_is_auto_hibern8_enabled facility
Thread-Topic: [EXT] [PATCH v2 3/5] scsi: ufs: add
 ufshcd_is_auto_hibern8_enabled facility
Thread-Index: AQHV0sgOxlbzOPcdrkKbef6h38DLDqgAOCsw
Date:   Tue, 28 Jan 2020 15:38:38 +0000
Message-ID: <BN7PR08MB5684D9F9D37F3031F3FEDAC7DB0A0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200124150743.15110-1-stanley.chu@mediatek.com>
 <20200124150743.15110-4-stanley.chu@mediatek.com>
In-Reply-To: <20200124150743.15110-4-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b574952-6181-4547-cfe8-08d7a408253b
x-ms-traffictypediagnostic: BN7PR08MB4324:|BN7PR08MB4324:|BN7PR08MB4324:
x-microsoft-antispam-prvs: <BN7PR08MB4324B61BCE1F54DF75E686D2DB0A0@BN7PR08MB4324.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(189003)(199004)(7696005)(478600001)(55236004)(64756008)(66446008)(66476007)(66556008)(7416002)(316002)(76116006)(186003)(66946007)(6506007)(8936002)(558084003)(8676002)(81166006)(81156014)(26005)(54906003)(71200400001)(2906002)(55016002)(9686003)(110136005)(52536014)(86362001)(33656002)(4326008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4324;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BCeAsdyQracZ4gx9LOV9/M6dXjFHgc4HvZFyIB6wJKZ7KJBvaYrUG/njEb8GbLTQuRodyX3eMjHPOFav27RGxxeRg4zIdQCDzj/IUVCZV52bcDZJ6lLKwdqetQ619RFDpMqKil0rhPdzfLHZNBXacHOmxTFaPD8YDAOws5RUlliZ0ILudLyPySisNyHF5UhBt2HlndWiC1zIendc9Sqs9gGTC7mXz3jJQmYS5+MdSYVdmCc5NKaXGprdivIXWWTzNYbZPY4RpEe0SW+kdfH8JZ6XxAnvVvAqzERLI8EOCRbFVZnWa2zqM+cQAk3pN2WRLvarqjAUsvduIbmwuwHls2coMyy+QR2q80WLHt15CQ3YLBFV2zUGeKS2xEyTn6JS3gPaQ6kd1EVx3Q1iks9/x6pDeA0OdmejxFI08T49FOd5km/lelg3XqOjUKM+10WI
x-ms-exchange-antispam-messagedata: ZY0/V0+/aP8/Nvw2+RGe4ngsKTKQ8D7NKnubTXiYPu6vphgp40DWSHRtaCPQ30jEWBDvSFj40qCrYAaisQ+MESCLBmVMQOtog2JRU/UUVSEap3vhXq6kyl5W5RgkTM1IJZK9CFsrUZTnGcsewSe/5g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b574952-6181-4547-cfe8-08d7a408253b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2020 15:38:38.5646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vWrtZB/D9EB8lEQWXO5q33XsKm53aIXqCfyXrSCZ3IbS+SSqfjSu3fNSTPKjFFEhM8FeKqVcE5Cg6agmyBfvLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4324
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
