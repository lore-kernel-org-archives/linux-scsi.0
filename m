Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BFCC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 07:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EB2164E12
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 07:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhCOHyS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 03:54:18 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:18631 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhCOHyH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 03:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615794847; x=1647330847;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OsCxJJxI3hdHL4Im9hNzwyWBSlwjJlM2UhVnKWwTs3Y=;
  b=LaqP5irqGJZ47fsMBSvMq1S+don0nWdDrIfJ0T/PY93X1s3to2S73941
   YuAtd83+JhjUw2m4Vn7TYaINnCAiSK9jfC56cWlw8SyD35olIzVa2NSKX
   YgVIN23wJaIR5XTaLjLSSMNIqYfquuzuAjP+fg8s4gEjd4iQL8rBI3Jwv
   78/KFl0ZizNwpwcxxwpd58PL9bPTRagGIe41PGXZ2Dqn8NQmf1jYANt6H
   wyHueXVVkaPKUtLBc6h6v9AFXEQc5mZu8BX+u1vv+0wWs62YZZ4PQvM6a
   YnLLFSmFXiL9KcFSlrFOZ4kzHkfh7p1EsVUJdccrN5dzAUvi1iO3XiGBb
   A==;
IronPort-SDR: rkXrpOqzDILmPu/PIX1q/eA1QzmOdppOF0C1Se40ucgXl8U3AW9GPiqYB+B9OzLSLr9dKQcoZS
 tPfEmrTkqPa1O8tRcUZLPV4+/bWjYhq6g0UPes2rr2raC9wj+cuKjJKsH8ZmeeB3kg119ucR3m
 4nbf/Zn5eVKWGTVPSwOnZW2St6KwQ4EIrl3/5qZsL24dZF4dwTQyo/AakGDThWaaArmqNzCMDc
 /clPVbFtz0JEzTFcTDvWB+FkgMrViE9T8zacjsiDYexUkJL57bDBSqflsi1/Bkj5AkQjqjY/21
 5FE=
X-IronPort-AV: E=Sophos;i="5.81,249,1610380800"; 
   d="scan'208";a="272860004"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 15 Mar 2021 15:54:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4LTPWygd2KXr2XdcmPiI3BgEAcvavfAOLxN35VdjuhCwRnbiI5ofETStLPx/RJK94fM13pzI5xZd3k+gpfqLO2rmJcW5NOzIRx1UCFgcltmf5VlaE+iqGkPrMlJzYGhIR1C/5jVJ7x9hzZohPoHD4r2pPEw0hKHZ9kd9IodKKE9HNSEJW00us8guOWlRpezZaEYsdEaJH8aYxOE2GH4MfpxH4+uFf2wDT1URV9RKZLuENRP0cU9LclttKSGfGqQicaFIAHni0Ft9ZA5t1HUdIs4Resf0CuNc/P+SBjAtAMVUQKttDeq1dSG/g52YQozJU/nQpeRDYc1QwJ0ygBlGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsCxJJxI3hdHL4Im9hNzwyWBSlwjJlM2UhVnKWwTs3Y=;
 b=Cqli8P9mJ/RLfdn9/eEWN4qBZoi9yr0Tv8xlbrr9ugC/EIBCHL0jP2yfb05Oz0eUcYnLOdlEJEeUbmxJtV4sDIr5b7c4+AYteN4nRICPKKM0UccCA+EPFTdRaJL5odHkbw52rMV4srxK4gof99rztaTSAuVyJhP95UOzOQdZcj0kAHbc6p8idaNIecousJfAA1NXMkeAb+vRV/1j7WGsJ0jcp5WUd276jp611ydviHgrfD/UlM+CPwXxChD1jHRPnmT5ieYMY+n4TIQk5dfvPJ5qT/Wi251pigKLNLdhjCTp45S1N4ebqv5TG3AXx9KSMq74Jd7a6HikIb+JFGlLBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsCxJJxI3hdHL4Im9hNzwyWBSlwjJlM2UhVnKWwTs3Y=;
 b=AaTG0F25wJr9jBWeqO//2fzYgnTVdUz4hy94NtPA2v3GPteSNGFxsYs6dTGrQojGAlh5k3raWkJRO72bnC1E/YOls0PElCEkny+tGz9XcD4eq3THuQbrKz6D2z13GoSPGKeILKiPSJFjf5SbcDJAPqusiDk6cLep1svtPSeAZrA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1101.namprd04.prod.outlook.com (2603:10b6:4:44::39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.20; Mon, 15 Mar 2021 07:54:03 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 07:54:02 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v5 07/10] scsi: ufshpb: Add "Cold" regions timer
Thread-Topic: [PATCH v5 07/10] scsi: ufshpb: Add "Cold" regions timer
Thread-Index: AQHXD2e3uMXza01lFEKVh8wFSC1kCqqEWKYAgABpABA=
Date:   Mon, 15 Mar 2021 07:54:02 +0000
Message-ID: <DM6PR04MB6575B5DE46AEB7D456437974FC6C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-8-avri.altman@wdc.com>
 <f42b0c8c424a448668c4903c784c2059@codeaurora.org>
In-Reply-To: <f42b0c8c424a448668c4903c784c2059@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ed67ecb-fdfa-47db-a382-08d8e7878026
x-ms-traffictypediagnostic: DM5PR04MB1101:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB11012DD34C1C9CA37A431F07FC6C9@DM5PR04MB1101.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: plYtPc0QTMJQOsYvtMnqdboRUChJa4VCAKPeiVv63wj+A4JEQBg/8faQUiI2aNqFrmLruoIRQ8hMMfd/mPz5+QALMvLtIdQ1ogVSKdEF11cS6LYqRpKHzz85G/39ND8bIMwHMPKRvN3lxJ0k5YW0yrmz4cE/p/9T+QSk7QPHglkWg4iPq/fDfObDhMKS6XbHrPNo167bHenEiK/CquFTPT5sK+otcjSoeTE0SBnCkAkzUq2l3zMI8g8SqUazrF08OZOFV/6e1pBko/r+1H5XYk90yiMrfcs32y/4/KeWb8vRAGhtChymB4iL8SbPu6ToN4wR1PLKFtcErR0xPOwgpuMWuHxoUOvuzBFmUBb4ifngqwqpIfuWTGGBImEpGgsnuyI8BAD0uVdGGmPNTS6y5UdI6ToE8ZU+BMce6fSjjiIZF6ye0Yn07Z2CNG4UNLqTUQfDw45GbzWGVUPk2iuWvKO2BMTfOaz8R49v3kEOwz6E4Xkwh02w1hsCNnyN+C2OHRcI6om1BzEtxC2W8XRz3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(54906003)(9686003)(4326008)(6916009)(7416002)(55016002)(7696005)(2906002)(52536014)(6506007)(186003)(26005)(5660300002)(66946007)(4744005)(66476007)(64756008)(76116006)(66556008)(8936002)(83380400001)(66446008)(316002)(478600001)(71200400001)(8676002)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?THRMdDdWL29uRzQ3ckZxMkFQUzlpd0hiTVpMUXdyZFFYUnJBTFR6dlhPazIy?=
 =?utf-8?B?TDJKeE5sR2h1cWpRRzliQkZUOHJXSEFjRkNrbHhFckVnaW1DZzdrWkUwcnRp?=
 =?utf-8?B?REl4Mk1KK2VQNHdoZ21XbnRUY04xenRDaHdLL2JseS95endCYkl2L0R3YU9D?=
 =?utf-8?B?UFViblNCL05UeXJIQnl4ZGRBVTdmeGgwSUpiY1pqTFlxMmhMWkZqWVZ4TGJR?=
 =?utf-8?B?WWhXSk1GMW9Ec3BYcjRDaG5ubi9mRVBTdkJnWDI1RlpOdzk0OU4vYXMveXds?=
 =?utf-8?B?ZUhMQTVvSnpWVkF5UmlSc2RjaHBsZWhZS0o2eGJCNTJ1STU1MWlKVE9aSWRj?=
 =?utf-8?B?Z2IyakFxZEdEcVB4U0M4dkN5OUM4bysvd0xEZWNxVUlkK2R3bWZXNEN1Nk1k?=
 =?utf-8?B?aWdmR3BMeDdIZEZtbXZhRFhaTnR0dXpBM2prcXJ0aE9pL0tEbWpWd0NPNFFK?=
 =?utf-8?B?N2NEOW83Nk5sSXlDRE04Q1FxbHJPZmdBMmdFbGp3eWg0OER5aXZXV0pjV2tv?=
 =?utf-8?B?N2NoMUV5cjNIMEZrOVZKeitEaCs3cFJweE1xbnIyWXEwU3luUVdZaDlSamtp?=
 =?utf-8?B?SVpTYUFrNk9aUC9uYzRZdTNSN0Z6eFRqTzRYaTlFMy9mR1lPOVBNUEpJcE93?=
 =?utf-8?B?cmZIRk5JL2VaZkFmb3RQU09XOFQrUlhYOEx2bWp3bzUvbnZqTHVsVVNxWWph?=
 =?utf-8?B?ZWZHV0RoMk1rY3BUNGdmL3NPMGpnUDUzbllNZllScnlRSzc1RkR4bVpiWjVM?=
 =?utf-8?B?WDZDZW9XbHI0WHdjcEZha3VLMGxzM0ZOc2lmbjZtT0lUcHVxWmlUTVNYU1U0?=
 =?utf-8?B?TW92UFNpKy9zcUVTQ09KSWdoTDEvczVQTWNUb3EycExqc3FBbGc5VzN5Qmha?=
 =?utf-8?B?SHdPMisrLzRNc0FPWFNZNWRTeGRYQnBYWC9FUEVPd3FRSSthVjhmdXNwMlc1?=
 =?utf-8?B?eEYvZnFpTzFEa1RQWnBVZEg1USswU0NKWThmY1FWT3FUa2drcEpsZGtPWGtx?=
 =?utf-8?B?cEJDV1ZONzFNMDJ6blFkT0phK3JVRDFGZ1lXYkdMQkUyZldyZmcvUVR2K2Rs?=
 =?utf-8?B?dkFaRS9CSDVMZFpNYVlHMkY1M2NOYzVySWFjMktsQ3Z1UHkzbnpxZEZmOWZv?=
 =?utf-8?B?R3UwNVFLd2ZlRG1JdzNyUWhwcWpjNlJJbUtvV1JpUmVod1UwcWphK1RJRkVs?=
 =?utf-8?B?QURaWGVWdmoxUU1TUmRteUQ0TFE3MWJTeGV3STNqbE5SL1JvMU1rNWxXNFhp?=
 =?utf-8?B?RWNqeWdhVnlrZGRkakszeGpzL25ydjYxMTVOQlJpT0cvVmNYZWRSOHhzRlRN?=
 =?utf-8?B?WFZpVnJIV0tjUVJWRU0vaXJMMnJJSnUyNWlETjRGWFRzTEdURkpZb2FaT3VT?=
 =?utf-8?B?Ulg4Uk5ZeU5PQ01XWndqR2NmT1F0bUdQWUs5NGgwZVdEQk04ZUluaWVvRW9o?=
 =?utf-8?B?cytQKy9hQmpUd3FZbHBKaHZrakIzR3U3OFZmYTVlOFplVDZ6Wk1ONDJDUVpU?=
 =?utf-8?B?NTZ6aDlXWVNobjlFeVNpUG9nbEcrakE0SXJtYXA0U3I2Q0lOMnNOa0JveDdj?=
 =?utf-8?B?eGZKVEQvNVJ6M0RYOFkxZi9Jbm16NFVMV3M4VklyQmxtMG5wSEU3VThKNHJ2?=
 =?utf-8?B?WXNOUkVLVEdpaXRKdGZCNjJHZ0F0UEFyUTdRQUNRVlQvMVRKL05PV0FJbXRa?=
 =?utf-8?B?bVRPMURTaVJLNE5UYU4zd09xZXkvaXBxeVVHNU1QWlo1NTlTYU9GMHczTUNx?=
 =?utf-8?Q?7wI+3r1uKgztREzyJ4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed67ecb-fdfa-47db-a382-08d8e7878026
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 07:54:02.8466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SO7jVfYmSfAiXNOP4j0iW0s131Lj5SQdrsTJO3MXBDxKZHMLlUNcI3UgCto9yZc5usicuNXhMIam/r8dkgOpKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+DQo+ID4gK3N0YXRpYyB2b2lkIHVmc2hwYl9yZWFkX3RvX2hhbmRsZXIoc3RydWN0IHdvcmtf
c3RydWN0ICp3b3JrKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IGRlbGF5ZWRfd29yayAqZHdv
cmsgPSB0b19kZWxheWVkX3dvcmsod29yayk7DQo+ID4gKyAgICAgc3RydWN0IHVmc2hwYl9sdSAq
aHBiOw0KPiANCj4gICAgICAgICAgc3RydWN0IHVmc2hwYl9sdSAqaHBiID0gY29udGFpbmVyX29m
KHdvcmssIHN0cnVjdCB1ZnNocGJfbHUsDQo+IHVmc2hwYl9yZWFkX3RvX3dvcmsud29yayk7DQo+
IA0KPiB1c3VhbGx5IHdlIHVzZSB0aGlzIHRvIGdldCBkYXRhIG9mIGEgZGVsYXllZCB3b3JrLg0K
PiANCj4gPiArICAgICBzdHJ1Y3QgdmljdGltX3NlbGVjdF9pbmZvICpscnVfaW5mbzsNCj4gDQo+
ICAgICAgICAgIHN0cnVjdCB2aWN0aW1fc2VsZWN0X2luZm8gKmxydV9pbmZvID0gJmhwYi0+bHJ1
X2luZm87DQo+IA0KPiBUaGlzIGNhbiBzYXZlIHNvbWUgbGluZXMuDQpEb25lLg0KDQpUaGFua3Ms
DQpBdnJpDQoNCj4gVGhhbmtzLA0KPiBDYW4gR3VvLg0KPiANCj4gPiArICAgICBzdHJ1Y3QgdWZz
aHBiX3JlZ2lvbiAqcmduOw0KPiA+ICsgICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4gKyAg
ICAgTElTVF9IRUFEKGV4cGlyZWRfbGlzdCk7DQo=
