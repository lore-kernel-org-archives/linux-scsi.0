Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F029FC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 06:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C570320825
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 06:48:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BTeBOB/G";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cEjyZGmb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgFIGsx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 02:48:53 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:10666 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbgFIGsu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 02:48:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591685330; x=1623221330;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LCs9de9PirTW/i9pCH2wjvcA8DKruW1YMWfpQUa1P9Q=;
  b=BTeBOB/G2ZK91FlY+Gs6D0cU1eLiI74o2rdFPiklK0PQcfSZBvF8uxrM
   r4ALlPvZZVmi3dr6zjVmhLYCjbrufUVOL0BIdFpsRS/M81uw6KA/OKVZz
   1X2jh6t7GFK+VAt5yY9JSkqej2gJzHR1gYoXCa6/kvQq1J2TTNUxGXEFH
   MeM+8xepT29v8KfzZtEz+s+eIXu1NYStiLE4zJQrOaN/kHpQaM2XhAJxz
   Fmlev4+7J7dCY8z35sEPDPUPNlDU06xH9BErOF1QT+MIVMhdFZn64s9R7
   q+IQPtzDpJQBhIYJQULkocN5TcH+5+PklDcSetarpN7aEJnA1rtxZGh6h
   w==;
IronPort-SDR: Ie+Y+uQwEy0CKqxMXQgotagQ0L+JMSwLD1SiM4Ue9zrn4KAqdkPOm/mdy1JfizYGTu7qNzyA3I
 jkGHGKqJ7/Y/G5OyKe98DHxEW3cuxtZYDkKS6ePKWGAhuyaIpXUozKS/f6OpO7Bzdos3szmUp1
 3fC2a+SamLTbSTO2OaLptZXsrnto7FRto+IQfudljn2j9hHMMRMguHpDIy9FITSKSc5wPfpg+w
 2QOHT9757uADwqaf02oD2wsrHlaY9Ebc350Ff5f5kJTVEIb1bJadoziMw7PuJsHTUyLMl8grrd
 0B4=
X-IronPort-AV: E=Sophos;i="5.73,490,1583164800"; 
   d="scan'208";a="140934927"
Received: from mail-bn8nam11lp2177.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.177])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2020 14:48:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SB+n7fRBdDo+z0/WZkGObekLE9PXoaqB45cBb6LjLPKGapQ/jL+GFIkPoTR9GuQEjgpXvDHx2jL3oPLi+sBx3G9btioaB8KMQDOEi+kk7+pIxvLx95E/JCX7GhklUBjHf10APki3Ocw6RABXOn0tQQgiVpNRUr4IqfkNnm7rSfP6rFziM2YmhuPAwJIIjCgmsyI6nW+9WRyOCmF4OA/NGtuaJxNzC5T76ITOmsYpxqu7nHZqtdpW705QuzSc7H88Zhfl2PUNJXmEWNnXutbYDZZ1hB0/eG00++sjKmuv3QnqJO016tAYGAqpskMhaXRQ211r9QrtD8Wgu6//CH7irg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCs9de9PirTW/i9pCH2wjvcA8DKruW1YMWfpQUa1P9Q=;
 b=b21jWc6ZU2JDB1izWJD9nRnj4t/hFVHBBmdJY9jUOGyHRFvpdu4C3hOzzrsTlijLJi8HP3IJAqZSrTZOZyarDmYxYYO5ePjH9Y+ge3RyvtnSufwDFQG5DpOpZDuAej3F1zQ5rnCGPD+H0Yd6IagZLBfR10yQ0Opf+cPmJp/pTVhUrSDWNQC1Sf7BaRFKENR3nI9SR8PFYqW3zj16QzJaX6wrRGrsuEzBxkcokW+KbEejZ+fH6ATXZ/WQs+TIMqPGTOYiz+K28tXUPf3J5JJ1qlG5hfMdmgwquVAAmksJfsE4ttjl0AOu8FNQFFDAo+Az8kO695zRZ+nhNWQnNHmc/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCs9de9PirTW/i9pCH2wjvcA8DKruW1YMWfpQUa1P9Q=;
 b=cEjyZGmb3rReXU9obvPx8aeQOl34F1IVgr4HLKcvH56ZQTa9fdurjFb0NoBTTqtv3eL1ayEtzIIT8xunWI/G7LHTXb+FZa1U6eKQzCTGWRTxxLZ2qpHLDkTpueMGdx3fyDGqz4ow+QJP9NwEA9u090LSGZz4aX57pUZJuzM80K8=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4782.namprd04.prod.outlook.com (2603:10b6:805:af::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Tue, 9 Jun
 2020 06:48:46 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 06:48:46 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
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
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH 4/5] scsi: ufs: L2P map management for HPB read
Thread-Topic: [RFC PATCH 4/5] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHWOt5z/DbVMmIRNkq+06TbmiHC8KjLsIjggAPKWwCAAGFjwA==
Date:   Tue, 9 Jun 2020 06:48:46 +0000
Message-ID: <SN6PR04MB464062D306BA6D635F274CD4FC820@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <SN6PR04MB46409E16CCF95A0AA9FFE944FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p4>
 <1776409896.101591664283293.JavaMail.epsvc@epcpadp2>
In-Reply-To: <1776409896.101591664283293.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: defa6f76-644c-4663-4266-08d80c412875
x-ms-traffictypediagnostic: SN6PR04MB4782:
x-microsoft-antispam-prvs: <SN6PR04MB47826F29877C3476CED42326FC820@SN6PR04MB4782.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iupXbVoDK4c8fPjGwD/F8pOBqz8ONV7KQ0RI+bimn9aZbSDchQ4wwVVpwQsP8lSltoto5AcS3T8iPzDSfwh4fjqdvkPGnOHInJM0qi+lAztBYAndXjwkV4ZJwfeKDkigz7nyGTieUroj8upJQcIp4F5o0MorJJ8wQOyIL0V8BgBSeXqKK26rq/6ltR1e8uQu4cLcUNwoK2lZq/brX51UeCkWl8GlH/7KUiNLhN7BS2Gf3lbhwQN8MljVyhLAFfXalJkr+Lp2AwY7qzAbU79GGi+K+d9bk4XYpdDQW0bga7pW4qmqxXDbFdSMIK5pdfb9xm0NHo/U/xAs6lO1mtxTUprCufFkhRVbmeVxThbTtmv3dPSklhVpDpTM2Qow5enk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(33656002)(5660300002)(83380400001)(54906003)(52536014)(110136005)(86362001)(8936002)(8676002)(64756008)(66476007)(55016002)(2906002)(26005)(316002)(66556008)(7696005)(478600001)(6506007)(76116006)(71200400001)(4744005)(66946007)(9686003)(186003)(66446008)(4326008)(7416002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: clgJLdEpM8QzZoGrAMepXHnVvJ2y8UvSr28et1/ndkdCT7KwQWB4ZCON+JEk+WTebqMOUnwAuYSThK4ycYRK8tA35zKo15VEN5b4FolskFKslbDQnzdaoAENl2gCMSyNtjzTgMVcsjIKyHJtIA/1AyRZVCNvgN6VNJblBSOXY3XlVZH8BidigxBhR+YHbjoMh0RzrPZtoHtjan01NoUR4uPikvcbuWppUFHQ3mrvioRA/c4it92UfuIqGRpBrgd2hk4KttnY3gZSGwbCh/dOt1nJA+YbWeQ+Veco7SpmeFKk9wpInrvPfk3UF57atCgx2aU4uDWq86ArgKMjWyr355sNG+Kd9J2uq9spV9e7vbwkjhARNrSxGoCsepV4jDaCJw0G4vOEKn8itWacMTu4CehVCg09lCd6NtBt4M89xIgt3KtpKZmztkAoI8/EJxk+P6OS7Xi4IX7LTBHiP5smUVMIfcP82R9MDpqtyEo/0hE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: defa6f76-644c-4663-4266-08d80c412875
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 06:48:46.2806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u72aqGgI+INS8nLq1QOLieef0w4lIHYxM2av9W89GL0oxZfFwu56TSyg/B70EP41pOfaZdrbY4ukT4S86n4obA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4782
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gICAgICAgICAgICAgICAgIGRldl9pbmZvKCZocGItPmhwYl9sdV9kZXYsICJ1ZnNocGIg
cmVzdW1lIik7DQo+ID4gPiAgICAgICAgICAgICAgICAgdWZzaHBiX3NldF9zdGF0ZShocGIsIEhQ
Ql9QUkVTRU5UKTsNCj4gPiA+ICsgICAgICAgICAgICAgICBpZiAoIXVmc2hwYl9pc19lbXB0eV9y
c3BfbGlzdHMoaHBiKSkNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHF1ZXVlX3dvcmso
dWZzaHBiX2Rydi51ZnNocGJfd3EsICZocGItPm1hcF93b3JrKTsNCj4gPiBBaGhhIC0gc28geW91
IGFyZSB1c2luZyB0aGUgdWZzIGRyaXZlciBwbSBmbG93cyB0byBwb2xsIHlvdXIgd29yayBxdWV1
ZS4NCj4gPiBXaHkgZGV2aWNlIHJlY29tbWVuZGF0aW9ucyBpc24ndCBlbm91Z2g/DQo+IEkgZG9u
J3QgdW5kZXJzdGFuZCB0aGlzIGNvbW1lbnQuIFRoZSBjb2RlIHJlc3VtZXMgbWFwX3dvcmsgdGhh
dCB3YXMNCj4gc3RvcHBlZCBieSBQTSBkdXJpbmcgdGhlIG1hcCByZXF1ZXN0Lg0KPiBQbGVhc2Ug
ZXhwbGFpbiB5b3VyIGNvbmNlcm5zLg0KVGhpcyBpcyBub3QgYSBjb25jZXJuLCBqdXN0IGEgcXVl
c3Rpb24uDQpJZiBhIG1hcCByZXF1ZXN0IHN0YXJ0ZWQgd2hpbGUgcnVudGltZS9zeXN0ZW0gc3Vz
cGVuZCwgY2FuIHlvdSBzaGFyZSBpdHMgZmxvdz8NCg0K
