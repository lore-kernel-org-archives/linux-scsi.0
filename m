Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB7F4C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 11:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9256C20CC7
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 11:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZN8an+4J";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hmR/bkWo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgFQLbW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 07:31:22 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11719 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgFQLbV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 07:31:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592393480; x=1623929480;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r67+ypQoSf+qYv9kAKvzjRuSgg5USH4PQjpQSckTUkY=;
  b=ZN8an+4JZHMxWBlh8MnEqsk7hFKcobfney31sjOjTrXIPVF9QGeq1AMT
   87fvNM70aw5Wt/z6b7nAbNRgQh0GqTpgCyeO4o9zhMs2vLU6ZpLDidP9x
   o6n0/nUC66yl6Kl167PGhQYgQOddHYrWf9A4NcByXJjSHBbgsQqJnnmUS
   dEugNqti0sHE7cJ9kBpkTSaRbRxbJ3KjDpd2kYAcHTO03ycC1tmu9rb0w
   BVRa83CYJ1vMR9DV6MzawzbIvM1WaC4eQMcPKJ4XZD9F0zw7Z600BrhVr
   uaBYJEhuhKy/mO9mKmhKL0v4T04DeQ+rTXBERGPPzHGu36tpkwrp1n05J
   g==;
IronPort-SDR: l5C8EN5+e4Ksg56aaN5cstTp94wus6UZ6HQQ6grskXat1f7hp5oFzBYkvHz4eTcePU5WNTFlkx
 A/d8UU47dzo8GP3jB6JL7FyKpEmDelQkqmK4NURS86Yt+bWFN0jxcG2otnrH4Vqf6OO8HW5BGc
 SVnoBhyez4h+9F441O9G9EHXghsLehhOmO7onbrTeDx52ZPubcfY/QaBT5fh680RbD7X2EVWhH
 pFNmpzKOSSOLL5L3rDol+XptygMj4jSCpmxrkP9RDUxpb7tbHoDoyH+DpQernqKzlaqJSfzQPY
 9q8=
X-IronPort-AV: E=Sophos;i="5.73,522,1583164800"; 
   d="scan'208";a="249392551"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2020 19:31:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNyi1UH2Oo44V3H521uwVcmt1+B5T9VNKgzSThBTXunvkvui3ekC7TnGRLUaavmOkJWZTJcVMVsI0gzE+50jkCbjRZ8dOjtMbEN6sXQBa5rhvfDT7QHjHRMqSnYUM1KvaLenj3+eAoKlTpCchnXbSqfWEoajXhTd9GIAZucRIsYjeE3p24WYfs+c6Ea36qTaladpouX1L73CqozzVVoyZHc8l8Blwxqsm0L9kctbR3KKD2aIV4g6njR+9rW0gWG1nJDx7+zeSSUQ/o3U4VDpOfg/ZXVmQtj120MwIE93UrVTEx0Ts/dbYS2QaZLd/Va4/sUW/yfGeAFLaufWJ9sU5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r67+ypQoSf+qYv9kAKvzjRuSgg5USH4PQjpQSckTUkY=;
 b=lN+OKah1sR5L1xjaU4eTd0cjEHZ7iazI4ZjIU9Adih2rLhGSl8U0b49SQPYunzffCapQJALEKRYgYdsH/v2hbyMya1oZ0W9Q8KmMP4RlYH4ABzHMizrOTeXnhX0tGef9xDna9vzIpcAsjNSm/LdwWPM/+WH5RI2cKCALWFghBNhZTjpztpcHDDjKbjbFj/0I+KKu92c2QhoVVLyjK/XwBZTGPOIWWmaQnHMCtKd4Ro4r0UU5DgFCt2sVyEx61lOWUclXadzU0aKzwFKyq2z3pjy1M4IO7fsD2qmFH+JMHXxfQcaMIMlmElS4RjBDUMJPvFAk81kG9rJXktEZiBc2jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r67+ypQoSf+qYv9kAKvzjRuSgg5USH4PQjpQSckTUkY=;
 b=hmR/bkWoBAiy7Gml4Tf9XAvsx7fZ75EDGpuypMeoOe6Vol8tUzT3ejzGlTRas9IP0gri9/Zhw4TJve4IQCS8G3W48n1Pd3nRz097T3ofj0NfvJtZuJ3FH8YyUeV6BNlk+gFYSxisKKtimxpIPjBNpyMzuTG4l0qEljNZFJp/PjQ=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN4PR0401MB3629.namprd04.prod.outlook.com (2603:10b6:803:49::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19; Wed, 17 Jun
 2020 11:31:17 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.021; Wed, 17 Jun 2020
 11:31:17 +0000
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
Subject: RE: [RFC PATCH v2 3/5] scsi: ufs: Introduce HPB module
Thread-Topic: [RFC PATCH v2 3/5] scsi: ufs: Introduce HPB module
Thread-Index: AQHWQvePZuXDGcRfX0mZaBS+6LSmD6jcrd3A
Date:   Wed, 17 Jun 2020 11:31:17 +0000
Message-ID: <SN6PR04MB4640350209C30F578945492CFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p4>
 <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
In-Reply-To: <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f03ec4f9-03e4-4aa8-26b0-08d812b1f390
x-ms-traffictypediagnostic: SN4PR0401MB3629:
x-microsoft-antispam-prvs: <SN4PR0401MB362902982ACEB73A28B7FFF2FC9A0@SN4PR0401MB3629.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 04371797A5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d9lBrMtYumxvZxlikrgDPooDHZk6sjqhwAHvgxPXD8M8rBue4ZsqYgUyuFopphycsn8aaNWJBY7aQbISVrZkK27sufi07XmePVvCS8o73vd+JZ2EGgw11lx4jqL0cQFrow0PT/ezqsN0lFWVMzZsO1Ie8CRo0Pls1WR3eFhp36ctBnYdVos5Dpc53fZckGiEAmEQlzZ7zCGR9DdEBYLzVbegcdpJHe8fGZb7nShQL9931+coQiuAhS2w59A/d0tR42RPjwCucmNziZOAXWkqWoxJm90cPnejG4QzodvAHLcR1Nb692SsDnBJmmuQmTv2AmOwQLhTMUkO4wErPV85VAAsGJkZVU+tEKpePYhzXgchgtmxxKb2w5kIt1l+Vwpc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(4326008)(5660300002)(7416002)(52536014)(9686003)(86362001)(4744005)(83380400001)(478600001)(55016002)(8936002)(316002)(186003)(26005)(66946007)(66556008)(66476007)(66446008)(33656002)(76116006)(64756008)(2906002)(8676002)(6506007)(110136005)(7696005)(54906003)(71200400001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 68fvcGO2f14TjbBLEyAqxpcqLZedecK5bqYit8YbTltL2H/R6dJvofp8iQI3O6PBukr7BrclH0ZRmIcN3bSVCAsrh+TQZl8XrOCdfzJuFgvQA0c/Ct2iagbbmOzUtbhMLleDLVnvJHgZ9qoBG3rANTDHGaDIyVQOsUQRI8hPfUs0m98YTfE7QHKeuEWeXFg8w+PVCA4XWg9dg4AC1hqyRkNTtWqX7/vCRz/NU87x3T7lV16vYnwveCrPJx7afbPfG7HQ/wa5mBQ+V4GXOy9DfrpmeBxhlHS2CcVkrcpeCO9hfd3q7jO9aUhj1jTF7amaX5C9qUBKhRrZNyM69m3iE9sZqbzb65Icf1xKo5G/BauucMFJOQQ/SwAg6HwS/uZNejyYyiIUi7lhjeHVK1gLMKMsOFw5GgGTSRTA4Oeg0PAm3xTa/Aq4gbLWE5H/LwckZkiyUWZBIx1vm8RhySDAr66Qs6xfHyKlOhjuLu4Js6M=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f03ec4f9-03e4-4aa8-26b0-08d812b1f390
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2020 11:31:17.6477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mftr1Bl8dLRPIc8j7GvMKr6YpZ6sLbpSK//Ur3RccibPk+QcSwxYt2W0toviVam7YVY01vVZqad//XD7di1NXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3629
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICtzdGF0aWMgaW50IHVmc2hwYl9sdV9ocGJfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBz
dHJ1Y3QgdWZzaHBiX2x1ICpocGIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0
cnVjdCB1ZnNocGJfZGV2X2luZm8gKmhwYl9kZXZfaW5mbykNCj4gK3sNCj4gKyAgICAgICBpbnQg
cmV0Ow0KPiArDQo+ICsgICAgICAgc3Bpbl9sb2NrX2luaXQoJmhwYi0+aHBiX3N0YXRlX2xvY2sp
Ow0KPiArDQo+ICsgICAgICAgcmV0ID0gdWZzaHBiX2FsbG9jX3JlZ2lvbl90YmwoaGJhLCBocGIp
Ow0KPiArICAgICAgIGlmIChyZXQpDQo+ICsgICAgICAgICAgICAgICBnb3RvIHJlbGVhc2VfbV9w
YWdlX2NhY2hlOw0KVGhpcyBsYWJlbCBpcyBhZGRlZCBvbmx5IG9uIDQvNQ0KDQo+ICtzdGF0aWMg
aW50IF9faW5pdCB1ZnNocGJfaW5pdCh2b2lkKQ0KPiArew0KPiArICAgICAgIHVuc2lnbmVkIGlu
dCBwb29sX3NpemU7DQpVbnVzZWQgdmFyaWFibGUNCg0KPiArICAgICAgIGludCByZXQ7DQo+ICsN
Cj4gKyAgICAgICByZXQgPSBkcml2ZXJfcmVnaXN0ZXIoJnVmc2hwYl9kcnYuZHJ2KTsNCj4gKyAg
ICAgICBpZiAocmV0KQ0KPiArICAgICAgICAgICAgICAgcHJfZXJyKCJ1ZnNocGI6IGRyaXZlciBy
ZWdpc3RlciBmYWlsZWRcbiIpOw0KPiArDQo+ICsgICAgICAgcmV0dXJuIHJldDsNCj4gK30NCg==
