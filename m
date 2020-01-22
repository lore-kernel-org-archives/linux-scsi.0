Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B41AC2D0DB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 10:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D625E20704
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 10:00:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="FcNvJFyQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgAVKAC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:00:02 -0500
Received: from mail-dm6nam11on2075.outbound.protection.outlook.com ([40.107.223.75]:13266
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726204AbgAVKAC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jan 2020 05:00:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWUoOY1jA42hEbs+eSBT43WPcdKkgWfC86x2t/ijUoWvx7HrZiOkO9OFcbk1QH2rpnrq0z/yvFfzlOOZjr4rokr5JRx7H+DFku5WGwZeQCHqrpicqpxcz3gqtaXBdVjvhxfhznsMigbzxgu8/xHiFbp7ULCILIxOIdl55CAD1eTl1cqOSvDYc3k7PLjAf3SNjoHQOsdtKEjFjKvc1EIGxcMmHxSGk7wLF/Z2cccV+4pyAzk+sG+zJC9ICCRH4jm57fErg05NsubP0x4Nd95PzHCl0wq+MlZl5lbY/2Ab4Sb2eS85yu2VCJw+ua3kOoyq8h2mSw1H+fVYPx5RD0aYxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mUsMUjloSq8S4C8nna7T7+FZ8F46FNHWcTAD/bB/f8=;
 b=YDBwCe/MqftcimtZQ3p26N7HHCwpKoijG2LVQw2kd4xaXa671PcJvdEEsNKO9T1P7kJGhG63MEcojQPYRnLvU5eTl77UxywaJ0utyoxUmcUV8RiXpbZeRb2YmAmro/OULcSYQDce5t1W6UPfeDbGrJnHnAmE80NRTpol8YGEgwWLJ9x+g1c50ZwHLQLOMYBCGHAwz+iu+PyQxVx0LX3mL+tFrRx0Ai9Bz++ShAPHVkrykuOxi/8i8d6t0boEIm5/yTnE31DDKN/vilGVcQ0k8Z+jDFbSoC7/6owmsHMpX5cFmEd/veh61ZoQPtBgSDvGFtzgEjJbnH7hpyBnwT11kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mUsMUjloSq8S4C8nna7T7+FZ8F46FNHWcTAD/bB/f8=;
 b=FcNvJFyQs06MfzbjNCP+tHPfHnUiOKqaqXpTu1xQRmlURKhfAh5QDhd9OdiPcQjyxVxBk1J1T/BKBPcZKCSzGLgOcQEWwImVIadU6wAm+cG+SldFyw3cPDWa6EJV3ehlUuN6W9ciIfRdyWRdpbnd2FWdeZ5z/vEwgEoXPT+JMIk=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4243.namprd08.prod.outlook.com (52.133.223.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 22 Jan 2020 09:59:59 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 09:59:59 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Colin King <colin.king@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH][next] scsi: ufs: fix spelling mistake "initilized"
 -> "initialized"
Thread-Topic: [EXT] [PATCH][next] scsi: ufs: fix spelling mistake "initilized"
 -> "initialized"
Thread-Index: AQHV0QQmJdFwW6oj8E+NgME1zqouXqf2chTw
Date:   Wed, 22 Jan 2020 09:59:59 +0000
Message-ID: <BN7PR08MB56844ADA4B5C9AC21230BC18DB0C0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200122091250.2777221-1-colin.king@canonical.com>
In-Reply-To: <20200122091250.2777221-1-colin.king@canonical.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWYwNjI1OTRjLTNjZmQtMTFlYS04Yjg5LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxmMDYyNTk0ZC0zY2ZkLTExZWEtOGI4OS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjExNTgiIHQ9IjEzMjI0MTYwNzk1Njg2MTA3NyIgaD0ia3NvR0g5Q1hJZi9tZzdpUUVLTnhrV1YySlhVPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFDVmtNdXlDdEhWQVdYcVVER2RnMTluWmVwUU1aMkRYMmNBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUEvaFRDdndBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3eb16ade-eae1-4503-3692-08d79f21d789
x-ms-traffictypediagnostic: BN7PR08MB4243:|BN7PR08MB4243:|BN7PR08MB4243:
x-microsoft-antispam-prvs: <BN7PR08MB4243A92712A9C2F1463353C9DB0C0@BN7PR08MB4243.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(189003)(199004)(4744005)(478600001)(66476007)(66556008)(64756008)(8936002)(81156014)(81166006)(8676002)(86362001)(66946007)(76116006)(4326008)(5660300002)(52536014)(66446008)(33656002)(55016002)(7696005)(2906002)(71200400001)(316002)(26005)(9686003)(55236004)(6506007)(186003)(110136005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4243;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AVCRVL1yD0Pi0yYBRn/Zgw8dhHN4UVL2rWe80LNU0xw0m50dhtIu/JfjW2JfZ+LI3eld9CqB46U+0aRLFZuvEwiTaMXWHfhIs/Uev5dCQdMKFKtqkvbR6c+KkkVpiDaegCy5fi/PumR+vd3Z8/mq+JwYJOgoqaJibVa7QxY72xEoVDF2DkI9kuuP3fWoA48VXmOs9lHceKD8YS+3Or/5sfskPipiFVmbflLg3xAPYeU6jhXVftJmdgg20L9AbxAdZrtm2UtZl/mzcP8lRhh89CUs/i/jNU0oZKItEqw631GKjP8wS5Tyfb5gtJMvi0Inf1ffvlZvP7D5bKVlu4fnDrQFnMXOJir/DMMlzwhEdaStCN1FgrzG/x6jOaDmjccp0JcrTBCQqN+3PSXaxoCpQPC5H9bnJ+aSYE4nm+1zv9qlBRMxwyRL+WK+AlulMY8n
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb16ade-eae1-4503-3692-08d79f21d789
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 09:59:59.3386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VHMPCsWkG6weX8Bhdmyrn0uuYieyi5vwb1qTYQmaxqtLw6AX1yaAFjzE6GSiWrfSOxkUZgHRIiPO1QJEsSZGhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4243
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIENvbGluDQpUaGFua3MsIHRoaXMgdHlwbyByZXN1bHQgZnJvbSBteSBwYXRjaCwgYW5kIEkg
c2VlIE1hcnRpbiBoYXMgbWFpbmxpbmVkIGluIGZvci1uZXh0IGJyYW5jaCwgaWYgbWFydGluIGRv
ZXNuJ3QgbmVlZCBteSB1cGRhdGUgcGF0Y2hlcywNCkFkZCBteSByZXZpZXdlZC1ieSB0YWcsIHRo
YW5rcyBhZ2Fpbi4NCg0KUmV2aWV3ZWQtYnk6IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+
DQoNCj4gDQo+IEZyb206IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+
DQo+IA0KPiBUaGVyZSBpcyBhIHNwZWxsaW5nIG1pc3Rha2UgaW4gYSBwcl9lcnIgbWVzc2FnZS4g
Rml4IGl0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdA
Y2Fub25pY2FsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy5oIHwgMiArLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
LmggaW5kZXgNCj4gZGRlMmViMDJmNzZmLi5jZmUzODAzNDhiZjAgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzLmgNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMuaA0KPiBA
QCAtNTQ2LDcgKzU0Niw3IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCB1ZnNfaXNfdmFsaWRfdW5pdF9k
ZXNjX2x1bihzdHJ1Y3QNCj4gdWZzX2Rldl9pbmZvICpkZXZfaW5mbywNCj4gIAkJdTggbHVuKQ0K
PiAgew0KPiAgCWlmICghZGV2X2luZm8gfHwgIWRldl9pbmZvLT5tYXhfbHVfc3VwcG9ydGVkKSB7
DQo+IC0JCXByX2VycigiTWF4IEdlbmVyYWwgTFUgc3VwcG9ydGVkIGJ5IFVGUyBpc24ndCBpbml0
aWxpemVkXG4iKTsNCj4gKwkJcHJfZXJyKCJNYXggR2VuZXJhbCBMVSBzdXBwb3J0ZWQgYnkgVUZT
IGlzbid0IGluaXRpYWxpemVkXG4iKTsNCj4gIAkJcmV0dXJuIGZhbHNlOw0KPiAgCX0NCj4gDQo+
IC0tDQo+IDIuMjQuMA0KDQo=
