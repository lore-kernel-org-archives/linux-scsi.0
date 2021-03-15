Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7D8C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 09:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42C1D64E31
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 09:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhCOJVC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 05:21:02 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:36971 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCOJU6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 05:20:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615800058; x=1647336058;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SYYVkW0Mjh7/cY2APtwG2ENv32/5VY1CIhzf84meQ54=;
  b=I7rFDxAZ9Z5kQPRykGqD+Goyvw8yVY26sHGExyuV4q8SFq+OO45sjYEX
   Pk8cWdMOLuqDinpR05XxaVFYDuQTQi7cSZtYGCFCe5cuEkT9yOReelqy1
   jWxTNVby8WWz3mxBe+B7RxLv7v4BkvOQ/13B/JwkgAeoD1QoJ43l32hd4
   nzvwJn7BNAqvWlvF61tfsetWKZv0zsR870S9ueSkqCfjEUFmiXLR7ocUD
   9F59f1CyqU3inw2YBGBKQrg6KWu7HSe1UhzmpHsTejhM4fUmFtabepu69
   8BNNXO+eHDviLoiblBnQ3KeZAxK4X45w72DRwQ+b1rG1qnMp6U6TzK5ZX
   A==;
IronPort-SDR: y6i7i/qqyybS9fPHjtaqsEeCvAZjl16AENfxAGNkMPodx+FC5QIbkUJ1ppe8+PAj/wwPHF00AM
 2MOdn04fIahPDcZfBcDvCsG4kry0dsJyON0euy9cIVUJlM/WE3ALgs6ygkknwRZt3MHh+ODPR+
 0utw0qOEU6jcIMe5Pw0GsVqwFThREhj6g7YN0DjurqUgDDufolacPnGWevQkw7RIHFXs9f3IAF
 n+sYgpqop68CdJb2TFShb1P00snhvAIh0qij0i+q0NPNMBIQT0szxyur8oW45Ln7QjH5CYv2Ce
 /Xk=
X-IronPort-AV: E=Sophos;i="5.81,249,1610380800"; 
   d="scan'208";a="166647403"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 15 Mar 2021 17:20:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWs8XMoIwybDMJLTnalMoeGbuY7f0nO5Gzx2Y+lyeLOyyZpq3xzMtJjFxf0A1c74/3E6/EtSPN72BoAi0pTHopgHUoEvrAG71Oi1hFCeJcSVOA4paSMT1IsDOvFBoLrlKdD0apbfw4TcRM2HmfMq8BRx+ecoaNwIr2q78PDJWJrej4xCuu9p59JgF+EuZp3j8mZBvOI/gc0usNEEL2Egpz8Q7fhoHWrINTmPerU1HJO6Sxu2XWHTR8mjBNw+y4QpQmnbRN/y7DTxN6zWJ9cAgzRObUpBYV5Ze0/uLCjwBO/4M78lga1LKxlUG5Gig8TtD1fgsvGJkuRplD7ZlPgGqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYYVkW0Mjh7/cY2APtwG2ENv32/5VY1CIhzf84meQ54=;
 b=mFW1zW5FUMZortIJ51Xz4pZzJLopb4BzZxITvUMQ76gcE9P6/2qTNTRAX+6fHaq31JJpDEVmZZZJADEE2j92qdvxpIYRrNeoTEAmQHquIB6fWFBagkov6rU4XoSL9Gs2gjKPoIm5uvI7dQIrsHkH3SHf6Qgy5k7ftxTow2Z/z9twu4d3mCUvYmonJJCiK9hfOIK+GXtl+cHS6gUqiUQovySyUaS6vLD4ni/2qX+AOD0Q5BY2ksKrdm7j4wMhY5gy6NdTQ5h1r/km25b/EGlnyrWA4vx7e6dWj1d4E8nHdA1WuXEN3jCjlUTsnM4mSkb8jsmtj2VxYo7xsyKWpFBTwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYYVkW0Mjh7/cY2APtwG2ENv32/5VY1CIhzf84meQ54=;
 b=ZT3vNubE333hGCddLAwhnEYzRBvo8yLV/2EgDSqp0PYSehBROVKU+lzNO4zFO0RryyU3Eromvim1dt/swZEZyGJ3++85+rINseGvtlWJZ+XBaZzq+8jxL5Ef4bhg30b2+jBPTBZyXQ9jgPuj0G/5C0c6rqTqR9jSnKxjtU3vTso=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5449.namprd04.prod.outlook.com (2603:10b6:5:10e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17; Mon, 15 Mar 2021 09:20:56 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 09:20:56 +0000
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
Subject: RE: [PATCH v5 03/10] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH v5 03/10] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHXD2ei7j8moNyDbkOuTIbGJCHBHqqEdEEAgABlUmA=
Date:   Mon, 15 Mar 2021 09:20:55 +0000
Message-ID: <DM6PR04MB6575A58446F1EB9ABDFBB7A6FC6C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-4-avri.altman@wdc.com>
 <343d6b0d7802b58bec6e3c06e6f9be57@codeaurora.org>
In-Reply-To: <343d6b0d7802b58bec6e3c06e6f9be57@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fa1502d2-bc5f-4bf1-bd70-08d8e793a373
x-ms-traffictypediagnostic: DM6PR04MB5449:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB5449BC7BAC645F86DF7573E6FC6C9@DM6PR04MB5449.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xPeCo49b0kFAqzUBLYs/1ceHziEkhTMiUUTqFg/1I/05RrT7q9pxCY5gvDsDbNnfuZUlF3EEBtnW2E8cz5IZjqFkd6Z5If0G+UgXjN2A27EOcAsOSSIcGy8BHdFG+lIPpwqDhrkgB3UTrQ9kkeq3MCpv5hrPFwMlSEu91cY5k3TlHv2OTfWR3QeEX8RVCwYzZFUUmqviFtM862QCB/iKFgrrXPLOPAPKb3oXU6KlRo8nYz5Ctz2UmRfnuT1MqkMDjPTdPfvHDbJTfuniD6i4JJgQyKAa8+uYxU4nkQ/+5C4fHZ8DcHPWPPbG3MJ4VwqSke7Qkv1iwp7QHk0/4bDz+jkwLQBnU9Z4KHpeMRlMUfnk76a4YuL6QPgpVzhvYfkLp1ifRHRkOm+cY7m2kcBqQBaFle9F3p6q8yTNoa4cU5UAatzp183LwAx7NMmWY7QPKxotVyK35t2AX6/olWtNSLc5uJra36tSKLtr6x0dnsArTofDeOhQp9D4A6uCfRyVmTiCJ3ycDhe7DnGg9hBMMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(6506007)(71200400001)(186003)(2906002)(64756008)(66446008)(4326008)(66556008)(6916009)(8936002)(26005)(8676002)(55016002)(5660300002)(7696005)(9686003)(7416002)(66946007)(33656002)(52536014)(83380400001)(316002)(54906003)(478600001)(66476007)(86362001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?akVXZ0h4MkQrcHNDVkMzQVI5UlNDWDE2amhscHlTcDJqemRDSnZsd25teldr?=
 =?utf-8?B?TmYydFdlYWJnb1R4UmMyNGtMV1c0bWtsOEpjYm9JNkZpbVhLR2YxdmY0VWhI?=
 =?utf-8?B?ck05UVpHV0pOTnc3VTZ6djJzdEJDeDdZa2VOWWZrZkJ4d245eUtiVis5UzFF?=
 =?utf-8?B?RTZkRC95TU1tckNMejdkVVR4d0prMUk4eFhoVFc5ZHFibzZVSnhIYWI0TFRE?=
 =?utf-8?B?UVpqcjdJaGxnSEJ4V0UyaDZWaVUxZGlkVUNGU0lLUkxKUEJLWWZCb0UyUEZU?=
 =?utf-8?B?M2oyRzdoUmxUQTNnSU00Ti8yeDljalVqVC9yZWpCWldmZjlTVExWeTQxeWlG?=
 =?utf-8?B?R0h0NkVKZGt2cVRMOXF1algwZ0xSdDJ3cURmTzV2aWl6UEVuQi93bkhHY2x4?=
 =?utf-8?B?VzlBT29sZ28wb0dpb2ZCS1pZWGtuOVN0ZnV0dkpLVE5nNDJyMUE2Ymd2cCsv?=
 =?utf-8?B?aDY3TVZWUmZ4VjZNaEttdkNyMGJtRmpMYlVKVXFlOEtoM3JYUG5ITGdaRzhC?=
 =?utf-8?B?SmI3T2YwVzQzcHpDL2lZQVJTLytFVHpZQmU3MjFxa0tiQmkxRnRLYnJqd2R0?=
 =?utf-8?B?K2JGN3N6MHliMzFnLzVlNm9obXZKR0Q3SXRNUnBJaHVDdGZKeWxJSFRteXJB?=
 =?utf-8?B?MWxZY0xneWgxcGtBUU9ZZnprQXp3YnppM1JUekppeEd1dkZuTTFSU1dtZnhx?=
 =?utf-8?B?aytOU1hITEMwMlRxaG5iSXpidmNUQmdVT1M0alJUeXJrN09WVFhNWndEU2c0?=
 =?utf-8?B?OXNaUWsxYVE4bW5tRnFOMmNsdURnWU5XZjBIMS96a3NBUEJId2VLc3hQVkNv?=
 =?utf-8?B?Z0ZYcjIvTkZUL1piSnhoOVFjbUU1Ny9TTXhPOFdEUEVHQlRYblNGMlFxb0Fi?=
 =?utf-8?B?aUp2andQRWpzTmJLRFFmVHZteThLMzhqNDk3MTBVZE5WdmRVbGRrMEFGdEJq?=
 =?utf-8?B?Ny9ybnhFSUlqYXkxZW5nUnhTNnB0VW5admp4cXFqaC81SW4zQmlpN0hYdWph?=
 =?utf-8?B?RVBrQjZNK09uM05QVExXaURacGpEQ2NSTVBBeTVmZ3VxQkU0cU9mNWhENTh2?=
 =?utf-8?B?L1F5RHJSMVdJMjFaenQycng0RU81VENNeC83UVhLZ0RvMU1ja0VCQmFoNGxo?=
 =?utf-8?B?bzdobGJKajgveHh1MEZ1MXlrUjRCVzFtMUY3cThDT3FVVDZIcmhPQmw3bWcx?=
 =?utf-8?B?UjM0QllWYnFFWVhEOWZHK2R2MEZPNEZBOXRXZ0tsT2l5ZzFoa3JZNEdIVDlJ?=
 =?utf-8?B?MkNXVXJuUENnVllRcE9veUtXUXBGaFZMcHcxRVhXZXQvK3JGMVl1Y01ZcGMz?=
 =?utf-8?B?WHUxRU9xVFFIb1hDMThIcEpaR0w1Q2NTcTA5ZHc0SjhNRU80cTMrUUZqYVd6?=
 =?utf-8?B?SitmMWQrU1lkMjdhUlRJYlBodU5XNlRLaWZrQ1NLeHhWbXpiMUZUNTM0VHhZ?=
 =?utf-8?B?TkZaMVl1NFRvKy9CTm1tejNFcjR6Q2xRRzZLdzhmS0NwK3dTWldIMWVTb1BJ?=
 =?utf-8?B?SWs3azRLTDZGTzlaSGxEbnRWSVlYSnpPeGVDOHpmSWIwYmV5OVFDdFZZVU9r?=
 =?utf-8?B?Z202ZkhLWXMySy9qaUFZOHE0QjhiL2ovdzRqcS9HL2E3dTBGdjNIcDV0QXkw?=
 =?utf-8?B?RmIyYmFqaklVTWxodFpnUEwxTTR3Z3o1TFFaTGlYbVgyaGtaZ1VSZy94cUlV?=
 =?utf-8?B?VUx6aXU5Z2VjWHRzMFUzSjVaMUpieUk0Qis5djBIRzFpMHpHZ2YrV0JGYnVM?=
 =?utf-8?Q?lFdcgmJjEmQflQYV8Dwpouc6gc00Xn1q/pfOym5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa1502d2-bc5f-4bf1-bd70-08d8e793a373
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 09:20:55.9643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lA4i3S+lj88eIATVIugHEyYxjXyAH8Ae3m5HZPG05JYWhscr12Me6DaQIAasCstu4L1QTEkrqsaGlEJdjbkIqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5449
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ICsNCj4gPiArICAgICAgICAgICAgIGlmIChocGItPmlzX2hjbSkgew0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICBzcGluX2xvY2tfaXJxc2F2ZSgmcmduLT5yZ25fbG9jaywgZmxhZ3MpOw0K
PiANCj4gcmduX2xvY2sgaXMgbmV2ZXIgdXNlZCBpbiBJUlEgY29udGV4dHMsIHNvIG5vIG5lZWQg
b2YgaXJxc2F2ZSBhbmQNCj4gaXJxcmVzdG9yZSBldmVyeXdoZXJlLCB3aGljaCBjYW4gaW1wYWN0
IHBlcmZvcm1hbmNlLiBQbGVhc2UgY29ycmVjdA0KPiBtZSBpZiBJIGFtIHdyb25nLg0KVGhhbmtz
LiAgV2lsbCBkby4NCg0KPiANCj4gTWVhbndoaWxlLCBoYXZlIHlvdSBldmVyIGluaXRpYWxpemVk
IHRoZSByZ25fbG9jayBiZWZvcmUgdXNlIGl0Pz8/DQpZZXAgLSBmb3Jnb3QgdG8gZG8gdGhhdCBo
ZXJlIChidXQgbm90IGluIGdzMjAgYW5kIG1pMTApLiAgVGhhbmtzLg0KDQpUaGFua3MsDQpBdnJp
DQoNCj4gDQo+IFRoYW5rcywNCj4gQ2FuIEd1by4NCj4gDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgIHJnbi0+cmVhZHMgPSAwOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZyZ24tPnJnbl9sb2NrLCBmbGFncyk7DQo+ID4gKyAgICAgICAgICAgICB9
DQo+ID4gKw0KPiA+ICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ID4gICAgICAgfQ0KPiA+DQo+
ID4gICAgICAgaWYgKCF1ZnNocGJfaXNfc3VwcG9ydF9jaHVuayhocGIsIHRyYW5zZmVyX2xlbikp
DQo+ID4gICAgICAgICAgICAgICByZXR1cm4gMDsNCj4gPg0KPiA+ICsgICAgIGlmIChocGItPmlz
X2hjbSkgew0KPiA+ICsgICAgICAgICAgICAgYm9vbCBhY3RpdmF0ZSA9IGZhbHNlOw0KPiA+ICsg
ICAgICAgICAgICAgLyoNCj4gPiArICAgICAgICAgICAgICAqIGluIGhvc3QgY29udHJvbCBtb2Rl
LCByZWFkcyBhcmUgdGhlIG1haW4gc291cmNlIGZvcg0KPiA+ICsgICAgICAgICAgICAgICogYWN0
aXZhdGlvbiB0cmlhbHMuDQo+ID4gKyAgICAgICAgICAgICAgKi8NCj4gPiArICAgICAgICAgICAg
IHNwaW5fbG9ja19pcnFzYXZlKCZyZ24tPnJnbl9sb2NrLCBmbGFncyk7DQo+ID4gKyAgICAgICAg
ICAgICByZ24tPnJlYWRzKys7DQo+ID4gKyAgICAgICAgICAgICBpZiAocmduLT5yZWFkcyA9PSBB
Q1RJVkFUSU9OX1RIUkVTSE9MRCkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgYWN0aXZhdGUg
PSB0cnVlOw0KPiA+ICsgICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcmduLT5y
Z25fbG9jaywgZmxhZ3MpOw0KPiA+ICsgICAgICAgICAgICAgaWYgKGFjdGl2YXRlKSB7DQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZocGItPnJzcF9saXN0X2xv
Y2ssIGZsYWdzKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgdWZzaHBiX3VwZGF0ZV9hY3Rp
dmVfaW5mbyhocGIsIHJnbl9pZHgsIHNyZ25faWR4KTsNCj4gPiArICAgICAgICAgICAgICAgICAg
ICAgaHBiLT5zdGF0cy5yYl9hY3RpdmVfY250Kys7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
IHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhwYi0+cnNwX2xpc3RfbG9jaywgZmxhZ3MpOw0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICBkZXZfZGJnKCZocGItPnNkZXZfdWZzX2x1LT5zZGV2X2Rl
diwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiYWN0aXZhdGUgcmVnaW9uICVk
LSVkXG4iLCByZ25faWR4LCBzcmduX2lkeCk7DQo+ID4gKyAgICAgICAgICAgICB9DQo+ID4gKw0K
PiA+ICsgICAgICAgICAgICAgLyoga2VlcCB0aG9zZSBjb3VudGVycyBub3JtYWxpemVkICovDQo+
ID4gKyAgICAgICAgICAgICBpZiAocmduLT5yZWFkcyA+IGhwYi0+ZW50cmllc19wZXJfc3JnbikN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgc2NoZWR1bGVfd29yaygmaHBiLT51ZnNocGJfbm9y
bWFsaXphdGlvbl93b3JrKTsNCj4gPiArICAgICB9DQo+ID4gKw0KPiA+ICAgICAgIHNwaW5fbG9j
a19pcnFzYXZlKCZocGItPnJnbl9zdGF0ZV9sb2NrLCBmbGFncyk7DQo+ID4gICAgICAgaWYgKHVm
c2hwYl90ZXN0X3Bwbl9kaXJ0eShocGIsIHJnbl9pZHgsIHNyZ25faWR4LCBzcmduX29mZnNldCwN
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0cmFuc2Zlcl9sZW4pKSB7DQo+
ID4gQEAgLTc0NSwyMSArNzk0LDYgQEAgc3RhdGljIGludCB1ZnNocGJfY2xlYXJfZGlydHlfYml0
bWFwKHN0cnVjdA0KPiA+IHVmc2hwYl9sdSAqaHBiLA0KPiA+ICAgICAgIHJldHVybiAwOw0KPiA+
ICB9DQo+ID4NCj4gPiAtc3RhdGljIHZvaWQgdWZzaHBiX3VwZGF0ZV9hY3RpdmVfaW5mbyhzdHJ1
Y3QgdWZzaHBiX2x1ICpocGIsIGludA0KPiA+IHJnbl9pZHgsDQo+ID4gLSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgaW50IHNyZ25faWR4KQ0KPiA+IC17DQo+ID4gLSAgICAgc3Ry
dWN0IHVmc2hwYl9yZWdpb24gKnJnbjsNCj4gPiAtICAgICBzdHJ1Y3QgdWZzaHBiX3N1YnJlZ2lv
biAqc3JnbjsNCj4gPiAtDQo+ID4gLSAgICAgcmduID0gaHBiLT5yZ25fdGJsICsgcmduX2lkeDsN
Cj4gPiAtICAgICBzcmduID0gcmduLT5zcmduX3RibCArIHNyZ25faWR4Ow0KPiA+IC0NCj4gPiAt
ICAgICBsaXN0X2RlbF9pbml0KCZyZ24tPmxpc3RfaW5hY3RfcmduKTsNCj4gPiAtDQo+ID4gLSAg
ICAgaWYgKGxpc3RfZW1wdHkoJnNyZ24tPmxpc3RfYWN0X3NyZ24pKQ0KPiA+IC0gICAgICAgICAg
ICAgbGlzdF9hZGRfdGFpbCgmc3Jnbi0+bGlzdF9hY3Rfc3JnbiwgJmhwYi0+bGhfYWN0X3NyZ24p
Ow0KPiA+IC19DQo+ID4gLQ0KPiA+ICBzdGF0aWMgdm9pZCB1ZnNocGJfdXBkYXRlX2luYWN0aXZl
X2luZm8oc3RydWN0IHVmc2hwYl9sdSAqaHBiLCBpbnQNCj4gPiByZ25faWR4KQ0KPiA+ICB7DQo+
ID4gICAgICAgc3RydWN0IHVmc2hwYl9yZWdpb24gKnJnbjsNCj4gPiBAQCAtMTA3OSw2ICsxMTEz
LDE0IEBAIHN0YXRpYyB2b2lkIF9fdWZzaHBiX2V2aWN0X3JlZ2lvbihzdHJ1Y3QNCj4gPiB1ZnNo
cGJfbHUgKmhwYiwNCj4gPg0KPiA+ICAgICAgIHVmc2hwYl9jbGVhbnVwX2xydV9pbmZvKGxydV9p
bmZvLCByZ24pOw0KPiA+DQo+ID4gKyAgICAgaWYgKGhwYi0+aXNfaGNtKSB7DQo+ID4gKyAgICAg
ICAgICAgICB1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiA+ICsNCj4gPiArICAgICAgICAgICAgIHNw
aW5fbG9ja19pcnFzYXZlKCZyZ24tPnJnbl9sb2NrLCBmbGFncyk7DQo+ID4gKyAgICAgICAgICAg
ICByZ24tPnJlYWRzID0gMDsNCj4gPiArICAgICAgICAgICAgIHNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUoJnJnbi0+cmduX2xvY2ssIGZsYWdzKTsNCj4gPiArICAgICB9DQo+ID4gKw0KPiA+ICAgICAg
IGZvcl9lYWNoX3N1Yl9yZWdpb24ocmduLCBzcmduX2lkeCwgc3JnbikNCj4gPiAgICAgICAgICAg
ICAgIHVmc2hwYl9wdXJnZV9hY3RpdmVfc3VicmVnaW9uKGhwYiwgc3Jnbik7DQo+ID4gIH0NCj4g
PiBAQCAtMTUyMyw2ICsxNTY1LDMxIEBAIHN0YXRpYyB2b2lkDQo+ID4gdWZzaHBiX3J1bl9pbmFj
dGl2ZV9yZWdpb25fbGlzdChzdHJ1Y3QgdWZzaHBiX2x1ICpocGIpDQo+ID4gICAgICAgc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmaHBiLT5yc3BfbGlzdF9sb2NrLCBmbGFncyk7DQo+ID4gIH0NCj4g
Pg0KPiA+ICtzdGF0aWMgdm9pZCB1ZnNocGJfbm9ybWFsaXphdGlvbl93b3JrX2hhbmRsZXIoc3Ry
dWN0IHdvcmtfc3RydWN0DQo+ID4gKndvcmspDQo+ID4gK3sNCj4gPiArICAgICBzdHJ1Y3QgdWZz
aHBiX2x1ICpocGI7DQo+ID4gKyAgICAgaW50IHJnbl9pZHg7DQo+ID4gKyAgICAgdW5zaWduZWQg
bG9uZyBmbGFnczsNCj4gPiArDQo+ID4gKyAgICAgaHBiID0gY29udGFpbmVyX29mKHdvcmssIHN0
cnVjdCB1ZnNocGJfbHUsDQo+ID4gdWZzaHBiX25vcm1hbGl6YXRpb25fd29yayk7DQo+ID4gKw0K
PiA+ICsgICAgIGZvciAocmduX2lkeCA9IDA7IHJnbl9pZHggPCBocGItPnJnbnNfcGVyX2x1OyBy
Z25faWR4KyspIHsNCj4gPiArICAgICAgICAgICAgIHN0cnVjdCB1ZnNocGJfcmVnaW9uICpyZ24g
PSBocGItPnJnbl90YmwgKyByZ25faWR4Ow0KPiA+ICsNCj4gPiArICAgICAgICAgICAgIHNwaW5f
bG9ja19pcnFzYXZlKCZyZ24tPnJnbl9sb2NrLCBmbGFncyk7DQo+ID4gKyAgICAgICAgICAgICBy
Z24tPnJlYWRzID0gKHJnbi0+cmVhZHMgPj4gMSk7DQo+ID4gKyAgICAgICAgICAgICBzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKCZyZ24tPnJnbl9sb2NrLCBmbGFncyk7DQo+ID4gKw0KPiA+ICsgICAg
ICAgICAgICAgaWYgKHJnbi0+cmduX3N0YXRlICE9IEhQQl9SR05fQUNUSVZFIHx8IHJnbi0+cmVh
ZHMpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiA+ICsNCj4gPiArICAg
ICAgICAgICAgIC8qIGlmIHJlZ2lvbiBpcyBhY3RpdmUgYnV0IGhhcyBubyByZWFkcyAtIGluYWN0
aXZhdGUgaXQgKi8NCj4gPiArICAgICAgICAgICAgIHNwaW5fbG9jaygmaHBiLT5yc3BfbGlzdF9s
b2NrKTsNCj4gPiArICAgICAgICAgICAgIHVmc2hwYl91cGRhdGVfaW5hY3RpdmVfaW5mbyhocGIs
IHJnbi0+cmduX2lkeCk7DQo+ID4gKyAgICAgICAgICAgICBzcGluX3VubG9jaygmaHBiLT5yc3Bf
bGlzdF9sb2NrKTsNCj4gPiArICAgICB9DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyB2b2lk
IHVmc2hwYl9tYXBfd29ya19oYW5kbGVyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCj4gPiAg
ew0KPiA+ICAgICAgIHN0cnVjdCB1ZnNocGJfbHUgKmhwYiA9IGNvbnRhaW5lcl9vZih3b3JrLCBz
dHJ1Y3QgdWZzaHBiX2x1LA0KPiA+IG1hcF93b3JrKTsNCj4gPiBAQCAtMTkxMyw2ICsxOTgwLDkg
QEAgc3RhdGljIGludCB1ZnNocGJfbHVfaHBiX2luaXQoc3RydWN0IHVmc19oYmENCj4gPiAqaGJh
LCBzdHJ1Y3QgdWZzaHBiX2x1ICpocGIpDQo+ID4gICAgICAgSU5JVF9MSVNUX0hFQUQoJmhwYi0+
bGlzdF9ocGJfbHUpOw0KPiA+DQo+ID4gICAgICAgSU5JVF9XT1JLKCZocGItPm1hcF93b3JrLCB1
ZnNocGJfbWFwX3dvcmtfaGFuZGxlcik7DQo+ID4gKyAgICAgaWYgKGhwYi0+aXNfaGNtKQ0KPiA+
ICsgICAgICAgICAgICAgSU5JVF9XT1JLKCZocGItPnVmc2hwYl9ub3JtYWxpemF0aW9uX3dvcmss
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgdWZzaHBiX25vcm1hbGl6YXRpb25fd29ya19o
YW5kbGVyKTsNCj4gPg0KPiA+ICAgICAgIGhwYi0+bWFwX3JlcV9jYWNoZSA9IGttZW1fY2FjaGVf
Y3JlYXRlKCJ1ZnNocGJfcmVxX2NhY2hlIiwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBz
aXplb2Yoc3RydWN0IHVmc2hwYl9yZXEpLCAwLCAwLCBOVUxMKTsNCj4gPiBAQCAtMjAxMiw2ICsy
MDgyLDggQEAgc3RhdGljIHZvaWQgdWZzaHBiX2Rpc2NhcmRfcnNwX2xpc3RzKHN0cnVjdA0KPiA+
IHVmc2hwYl9sdSAqaHBiKQ0KPiA+DQo+ID4gIHN0YXRpYyB2b2lkIHVmc2hwYl9jYW5jZWxfam9i
cyhzdHJ1Y3QgdWZzaHBiX2x1ICpocGIpDQo+ID4gIHsNCj4gPiArICAgICBpZiAoaHBiLT5pc19o
Y20pDQo+ID4gKyAgICAgICAgICAgICBjYW5jZWxfd29ya19zeW5jKCZocGItPnVmc2hwYl9ub3Jt
YWxpemF0aW9uX3dvcmspOw0KPiA+ICAgICAgIGNhbmNlbF93b3JrX3N5bmMoJmhwYi0+bWFwX3dv
cmspOw0KPiA+ICB9DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNo
cGIuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmgNCj4gPiBpbmRleCA4MTE5YjFhM2QxZTUu
LmJkNDMwODAxMDQ2NiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5o
DQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIuaA0KPiA+IEBAIC0xMjEsNiArMTIx
LDEwIEBAIHN0cnVjdCB1ZnNocGJfcmVnaW9uIHsNCj4gPiAgICAgICBzdHJ1Y3QgbGlzdF9oZWFk
IGxpc3RfbHJ1X3JnbjsNCj4gPiAgICAgICB1bnNpZ25lZCBsb25nIHJnbl9mbGFnczsNCj4gPiAg
I2RlZmluZSBSR05fRkxBR19ESVJUWSAwDQo+ID4gKw0KPiA+ICsgICAgIC8qIHJlZ2lvbiByZWFk
cyAtIGZvciBob3N0IG1vZGUgKi8NCj4gPiArICAgICBzcGlubG9ja190IHJnbl9sb2NrOw0KPiA+
ICsgICAgIHVuc2lnbmVkIGludCByZWFkczsNCj4gPiAgfTsNCj4gPg0KPiA+ICAjZGVmaW5lIGZv
cl9lYWNoX3N1Yl9yZWdpb24ocmduLCBpLCBzcmduKSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBcDQo+ID4gQEAgLTIxMSw2ICsyMTUsNyBAQCBzdHJ1Y3QgdWZzaHBiX2x1IHsNCj4gPg0KPiA+
ICAgICAgIC8qIGZvciBzZWxlY3RpbmcgdmljdGltICovDQo+ID4gICAgICAgc3RydWN0IHZpY3Rp
bV9zZWxlY3RfaW5mbyBscnVfaW5mbzsNCj4gPiArICAgICBzdHJ1Y3Qgd29ya19zdHJ1Y3QgdWZz
aHBiX25vcm1hbGl6YXRpb25fd29yazsNCj4gPg0KPiA+ICAgICAgIC8qIHBpbm5lZCByZWdpb24g
aW5mb3JtYXRpb24gKi8NCj4gPiAgICAgICB1MzIgbHVfcGlubmVkX3N0YXJ0Ow0K
