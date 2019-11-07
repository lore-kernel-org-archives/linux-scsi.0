Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC551C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 21:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B8A121D79
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 21:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfKGVHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 16:07:22 -0500
Received: from m4a0039g.houston.softwaregrp.com ([15.124.2.85]:39348 "EHLO
        m4a0039g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbfKGVHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 16:07:21 -0500
Received: FROM m4a0039g.houston.softwaregrp.com (15.120.17.147) BY m4a0039g.houston.softwaregrp.com WITH ESMTP;
 Thu,  7 Nov 2019 21:06:12 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 7 Nov 2019 21:05:40 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (15.124.72.14) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 7 Nov 2019 21:05:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmdMAN7gOm/25uaWgmnsbQ7rBGplgeTmIzJ5+qo0zgxkVzM+zGpO38R/ewfK1ATTxh194YdAFUdYLeHADmTi7kndi3jiPY6Brm1GJqkdCDaLlOPcemNuW3uH8DjxEc3jg+c2tyJfptbG7AI4o9ZzkMypM9opgeA1U8ozAbfbCwErrhIB8EhlxVDyLtQi6Yxdmmn8jf/mIovUseZdtgZcYtNaMAdyE7pN/1YteJOmbDA4V0MkvoBJIhDRJAot1mPa9Iwf2h97CeWRzpzFeikGaWdmQHdgDb0pH9vOQBXH2lfXZUPQIO5Q8j59pnGlNqi25sxf0YmQJyxiSYUYk4KtIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PjeNm2GpIEhKkmlcE5KF4HBHdVmqRpO5PFX/4DItiwo=;
 b=ffxRsA3wzsGxKslPWg5jeo+UZLHTahHj2aT3cU9amlyDBYZaoIMwToYKzHzgYH7Bz/EQvo1Z7CuiRSr7PpBr4TtbOFKkh2CuFqPndsQe1PS8BnZ8Ovu0xC/6JLIP9nF9pHCF+hGjrFu0EtL0Wb40BZV5Yd7X/Z2HEzUT2Jl5FLmmHmExhaltdoQEM3lmEFB3AhtecP/C67eP0UMkJ20U00R++expQd0GhrOphrqlMVMYyuZEVfKcpWuJvdPFTU/jf5uc+GDB/ttJHfVBb02/IhSDbxqr+oDVWZ0qL25phTlewOBRwJa3Ia0OxBOvroKtxH0P+/IJFGyMU0Odx8DRIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB1402.namprd18.prod.outlook.com (10.173.212.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Thu, 7 Nov 2019 21:05:39 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150%5]) with mapi id 15.20.2408.024; Thu, 7 Nov 2019
 21:05:39 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        David Bond <DBond@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "mhernandez@marvell.com" <mhernandez@marvell.com>
CC:     "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: qla2xxx: don't use zero for FC4_PRIORITY_NVME
Thread-Topic: [PATCH 2/2] scsi: qla2xxx: don't use zero for FC4_PRIORITY_NVME
Thread-Index: AQHVlYtMnCf/6Msk5U+CzMMdXwD3P6eAM0SA
Date:   Thu, 7 Nov 2019 21:05:39 +0000
Message-ID: <50c756425b8a339cc57e5812e9aaba8e7e2f985d.camel@suse.com>
References: <20191107164848.31837-1-martin.wilck@suse.com>
         <20191107164848.31837-2-martin.wilck@suse.com>
In-Reply-To: <20191107164848.31837-2-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f8e35ba-9ffc-4b7b-9642-08d763c63dfe
x-ms-traffictypediagnostic: DM5PR18MB1402:|DM5PR18MB1402:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB140283A48A6E5C24F0A5A3A9FC780@DM5PR18MB1402.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:800;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(199004)(189003)(66066001)(26005)(81166006)(6486002)(2906002)(76176011)(99286004)(71190400001)(102836004)(478600001)(6436002)(2501003)(6246003)(118296001)(71200400001)(229853002)(54906003)(110136005)(14454004)(86362001)(6512007)(66556008)(5660300002)(3846002)(7736002)(8676002)(305945005)(316002)(486006)(6506007)(4744005)(91956017)(25786009)(6116002)(81156014)(446003)(8936002)(66446008)(1691005)(76116006)(66946007)(256004)(66476007)(11346002)(64756008)(476003)(186003)(4326008)(36756003)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB1402;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4zN7kQI6pPsUL2R0b2mNOZPz7m437Yf0dy8+VbkCkOG6K/X0sA4cD2ZFyJquQn8Q5kCdB6gZk/N+b07LNWcyTYgu85MNxwHkWrmOX9qMWRlW0RKfIvput8+GVJCZqx3qNdO7rOf5Vx3LqkykxM74KVu507MMu5lEvAr13vWoOCqmXAIT2w4k1dKJ1zYNXfWdt7EuywIW0epfDKKKiED1SiTduIUS+h72qG/GEZuXZTuJLqyOKTRW9wS4ojXLXV6lNHZsMMQn97mJPsP3pC4aoDprigKsYVyn7X17Kdcq6UTJ3xBPZdyiiUPsFVv09MKVmSWUWRsMzf3kKtt+3T38wbTW7ztzg5uKRQbl8/8sDHolr+vGNReo58A+gDxwt+xsdI+nyg0DgMgUQ/3ya/exWJgzyQNWaCyArHtnKT9ZNXyvWagVDWYQl0HcXFR+yclY
Content-Type: text/plain; charset="utf-8"
Content-ID: <82404F62BC3F19479068CB103CF7256E@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f8e35ba-9ffc-4b7b-9642-08d763c63dfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 21:05:39.0154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /i92A8ZVCejngXy1Y7x1jNbZhkF+Y1L6s6kTuoZ34+kZ7PxR1DbcksW9n8GPc6QY4p6DZXXodX+eedHsWMAkyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1402
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE5LTExLTA3IGF0IDE2OjQ5ICswMDAwLCBNYXJ0aW4gV2lsY2sgd3JvdGU6DQo+
IEZyb206IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPg0KPiANCj4gQXZvaWQgYW4gdW5p
bml0aWFsaXplZCB2YWx1ZSBiZWluZyBmYWxzZWx5IHRyZWF0ZWQgYXMgTlZNZSBwcmlvcml0eS4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPg0KPiAt
LS0NCj4gIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaCAgICB8IDYgKysrKy0tDQo+ICBk
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5saW5lLmggfCAyICstDQo+ICAyIGZpbGVzIGNoYW5n
ZWQsIDUgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KVGVzdGVkLWJ5OiBEYXZpZCBC
b25kIDxkYm9uZEBzdXNlLmNvbT4NCg0K
