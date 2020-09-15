Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FC5C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 06:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD18620897
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 06:35:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SYSZJYoi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YOofhCgm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgIOGfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 02:35:08 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20597 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgIOGfG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 02:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600151722; x=1631687722;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2gZtkwsjPzbomViPV+4xJpRUJdNJD5YrSAOxmT45A7M=;
  b=SYSZJYoiOLlnlTSMFdUkGiMIdMhoiPii8XmDjRfKvias5rBkzNGHl4Wo
   APNG0wQFdy8iJmjHnX0DbS77Xp6yg8uXM+iuhdqP+LqzXy0FDBOPigOyD
   BV3fj63cfBjf9/En8bFEezU3YKB5W3F+i0gHPLD2vk99HHP01cx0B7RuR
   kd71tUQSl+8ABwc7cw7I+oMXSBdr7nBLsfMWaSh3tU9PL6+ZMNMzEZDOC
   HLZuBggkQ4Rrl4ed7FE1/XTuvfEB2x9iEHfyN7d5o3+EmZjRtpLKSDWMG
   JebMZsbCPPaqKRaZ6fCea+39Xql3cAYdOa8WfWNseqVvmuKBxtMCTjE7N
   w==;
IronPort-SDR: 4A5LV8PJi6nS9brtsQfRitxKrvPIF5OCH+8yMooHpOWj3QgSPchbv+Waa6rRyiQkoz+Q6PFkqy
 ObR6thP+EH0ju9DjIPFdCUdum8qt0DYFhfAn739202IXaPpwfot7hUGDketaMf8IG2uReFQ1VD
 /Cf784AdRIm3An3xzLEaPIJE8vsnVvgfPxF5HlyrYu66Y7YV5sSxx3c7bx1mA/8aMcnLq5VFOx
 INIY9J+NgdtscufyyIZBU93vKnoIvYyiPk8TTsHePZ+tQt0Bctck20+UGpWriipKhY0AkPMuVz
 EQo=
X-IronPort-AV: E=Sophos;i="5.76,428,1592841600"; 
   d="scan'208";a="250714234"
Received: from mail-bn8nam08lp2043.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.43])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2020 14:35:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6wSUkmYlsvQ4bAh26cpARHJe6UFK0FZZQFU1OQUwACW/qVmMX0uJN3Tu5x6GAO0ggR7wurry+OcDfePGTgqlmRVaN/S+8dN7kX42wHP2QqN0sO0nxh3nsCsvUE/83XZaxVEI28yIxrsshg0GXiisEqt2oGNFxCWKopWzBJnANmhhXQ+fByoveR/84CV3ZPGtVeM+2vNA83Fmw2PGWWQP/R0PcXQSZ6qt5qOi7LfzLZ5gKyyX3U5NIvRAlKXKvFI1tEnQJX1dSK1swGvN2y0+giItBIDssbjpHKA/lVvo5VdQdheNKaXCJxY7NMi5gBT69CcyFG1BSf06jZn4GCy7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gZtkwsjPzbomViPV+4xJpRUJdNJD5YrSAOxmT45A7M=;
 b=YrEd0CXJf9YH62avBdVXftYoCnvBU14euA8IDhiI9MhsWriVqWynBLyxJKK2LN4L/NVfFdYpvl398N449FI+6X3qYyhwW7ut4YoG1FuKkFMJz4V48wr34wpucbCMy0EMKUPr0XSD6HQfPtJnqWTVyG2yX4F+Vb4eRgmcqBXr7D8TO3FZ4PdqTAqOyL8I7i8b/iMr5EGrejz7Z7/OUVhmD/9W9LkGu3bKpYcD85w8mcrwuSBJ7k7IA3e4Db/9ztsy01cl95CwKmOpSaegwV3EY+ntitG6gSmY3cG/tmYqchxDwXOMDgNpCRWbntpez3TIRrZV2N8ZZVDlczb65OCquA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gZtkwsjPzbomViPV+4xJpRUJdNJD5YrSAOxmT45A7M=;
 b=YOofhCgmdC+LOcdrIxS4F0ycewU9TCPanYaJ+OtEIYAQf4NmGDTSnCPiJkfEdUiedyQTxIUlJ3E+hJS7a9N0CI2sWjoPhRvOs+HqI2llJY9HIUzra9kYZtTH2CWco22QG6iUgbhz5MphEIA2KhITegirzWDwGcJq1egZJXSH0tU=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6311.namprd04.prod.outlook.com (2603:10b6:a03:1f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 06:35:01 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::2c49:48e2:e9fb:d5a0]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::2c49:48e2:e9fb:d5a0%9]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 06:35:01 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: RE: [PATCH] scsi: ufs: Fix NOP OUT timeout value
Thread-Topic: [PATCH] scsi: ufs: Fix NOP OUT timeout value
Thread-Index: AQHWgNZIpBz3rv5rok2idB7KF6Yd1qlpUtSw
Date:   Tue, 15 Sep 2020 06:35:01 +0000
Message-ID: <BY5PR04MB6705EA7473F8971029B8372FFC200@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <CGME20200902025852epcms2p2a2d4ac934f4fc09233d4272c96df9ff1@epcms2p2>
 <231786897.01599016081767.JavaMail.epsvc@epcpadp2>
In-Reply-To: <231786897.01599016081767.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2dd0033a-8c60-4ef9-2bc0-08d859417934
x-ms-traffictypediagnostic: BY5PR04MB6311:
x-microsoft-antispam-prvs: <BY5PR04MB63117AFC0F829035FBE04261FC200@BY5PR04MB6311.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YelDgpMXvVFRKckSWEyZ7Z4eLU9dlM6nXoMMTVI/CQghBV3uyUyYjKo72yj5R2NeTMNbKLJJlOI3/huDF3kbVXbw0/ZHnYXi4lMKY7MvOoRsTkvUw5z+e7Yu3W7rCobS7UNbMWFkRdVHJ4Aoq5J45ZcVHyWlBYpfafKzp6qR59azoK79YWn/wUw3j30ncPastj9RwP0sOyVSkNCVlwhQxqBAxUXS8wGGf1ksQuitMLDOlfCr18H2RAtm1POWmWwK0HGYClpw23Z0e13gug7KcSIY9bxPbj+5kVmstN4xKoQ3QSzkI+y6YFbKLwHpoNssIuTXrgIK24CFMSQjZ6iWc9L4ZUZ4UvkCZnF5lC61FVM6EdtBHyvv+pldP0h5wt2E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(26005)(7416002)(4744005)(8936002)(55016002)(71200400001)(7696005)(8676002)(54906003)(2906002)(9686003)(64756008)(66446008)(66946007)(4326008)(110136005)(66556008)(33656002)(66476007)(76116006)(316002)(86362001)(478600001)(186003)(5660300002)(52536014)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DNhotY9cFqpV/YVpl7S42aMzjI7EDrSvNXGnrNKhnEwU+GoRkghA4AfJVSDRdmEu9UAm20C42fDHlATwEJ9STWEh9eja7QBtwBGocLx06qs4kHMU8q+0HxgXlDqQaw+bhNgsWi+Q2I/Q1pdeMxrQSdO2YMhKxhEzvA1qOOR4rB0nXRT9bz/B9nr0AKk51MG+q0hhkOub1tVGrRc4JLRx61JvclwwwsEO9t5n/RWHPy55Y3gAtz0HTVF6su69KeMW/4GlqihnI4uc/oD/Lcy+DAjMxDIV0lyUZoXnkRjavmSXhzsLC1repka3bpYw+jv25o0Dz0rMnM1hkakJoIDFJjipy/mgnVz3qxsujKeRPT+6MMchUnWAzOismnUsiSz++bpMx19IQUDCuOtT/zxkpiX6OvkSdrkZdht9/d/KgktVH5zgtdA8A3+ejtcbRLw9h9E+FnYZsAQSCFMxH4n9FlOGLJz3WfgNQYSBHfMlIfgLV/k8JeRU9kmzgvV8nZZ+v9LHaSC8vlyr5WvCsSGVPK/zgjlyzKidzJWmOiSVZ37ZmB2VAka9/Cv4YeliYrf37hkEQWB6YECZCMRzVTFpJCpHQfe+kSNg3UIVbbIq8M1Yw5W2/329n9rl/MhpQJ5ie+JBMo3Gl+iUOHZdT8QSJA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd0033a-8c60-4ef9-2bc0-08d859417934
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2020 06:35:01.3237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +PU6rwgsfvUIAns8y1zqSNWtoVNHETtClm/+MqncQ+uDkHbW5fmlQkL8NENR8KfxssvqE3mxbS36WfZGZ4N+ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6311
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+IEluIHNvbWUgU2Ftc3VuZyBVRlMgZGV2aWNlcywgdGhlcmUgaXMgc29tZSBib290
aW5nIGZhaWwgaXNzdWUgd2l0aA0KPiBsb3ctcG93ZXIgVUZTIGRldmljZS4gVGhlIHJlYXNvbiBv
ZiB0aGlzIGlzc3VlIGlzIHRoZSBVRlMgZGV2aWNlIGhhcyBhDQo+IGxpdHRsZSBiaXQgbG9uZ2Vy
IGxhdGVuY3kgZm9yIE5PUCBPVVQgcmVzcG9uc2UuIEl0IGNhdXNlcyBib290aW5nIGZhaWwNCj4g
YmVjYXVzZSBOT1AgT1VUIGNvbW1hbmQgaXMgaXNzdWVkIGR1cmluZyBpbml0aWFsaXphdGlvbiB0
byBjaGVjayB3aGV0aGVyDQo+IHRoZSBkZXZpY2UgdHJhbnNwb3J0IHByb3RvY29sIGlzIHJlYWR5
IG9yIG5vdC4gVGhpcyBpc3N1ZSBpcyByZXNvbHZlZCBieQ0KPiByZWxlYXNpbmcgTk9QX09VVF9U
SU1FT1VUIHZhbHVlLg0KPiANCj4gTk9QX09VVF9USU1FT1VUOiAzMG1zIC0+IDUwbXMNCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IERhZWp1biBQYXJrIDxkYWVqdW43LnBhcmtAc2Ftc3VuZy5jb20+DQpB
Y2tlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQo=
