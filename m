Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBEAC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 07:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA8364DAF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 07:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhBWHwA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 02:52:00 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4510 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbhBWHvv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 02:51:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614066711; x=1645602711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y1JBeWW2EZ7CBQFu+F/CvsmKNLEZPMpPYkCh6TaSneI=;
  b=lrsfTPCmU4beCIWZjtCsH5qBvPUMkQWdJoJjmXaPmsDn8GIy6cdz5toK
   zuO+EWbh/5skhjdqSi2PeiL5HAFfSkbl+P5xNLefr+1Rwl3CX2RMTYBiP
   FTBiAiCYaKv7d1K90nQN10ZKjyp4fz6TOCVC3Aac+UvgXVIXDaTbaP4pP
   Kr6/cG7bTknBJeRoO4n56pTufjare4pioZMSKBTCpJkLyAF37FaiopFAU
   b9HLckO+bMAR0tfe+Dy/H/CF7SePc8HJy/EpghRkeSAdX9r8g3rCJUdK8
   fO2EzDpVHEshwhuqkf/zIzp6gaLHuBfbBxasQwzM8CUA3fukWC26zTwVQ
   w==;
IronPort-SDR: vfHoGd3CZA0X6zpza9hQHKhl8wOKPVs2reJPM081zlU7osuLE9XnIJgXiki8iO2XI4zL/rVKFn
 1Yp3EN/TpjiZjqhTWoS/MpGMl8vbT1t/+lpnDPwO89hU27FXgx+/1LSDJEdWq4MitlEJQPXx62
 9yPmIsHB0vbO155d24K9MOkzxjtzmMM7h99nNqpwnx07DlsgRG7piz2fl35ulbyMiHVYBzX2Yq
 /9lf2aTMMnKk2qIoYmoOzCPbM9r89T3P/2kxZggUgAu+EhjrPhmAP7/KtQCTAmcMq/wWOHcc8D
 zoo=
X-IronPort-AV: E=Sophos;i="5.81,199,1610380800"; 
   d="scan'208";a="161740666"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2021 15:50:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0Tv01kSCpZyEEuc/ogveJDIwDZloj+dHZtACLlO8+Sn/op5lrqL/kaJOe3wDcAxZzSmIxrw4HKsqQsNc09IltiU3Y55MCMU5NOMLB7y+aDIYhp4ma7s4/4iM5S44enLJ3VeFfvd5GCqJL+3OaxW+M7OhBFd/PudozYAnbnnknSu/o2/keKY6ZfTiKspo2k9RrfZDYKik+OCtpNGSRjA8vLpMITxVn2HUsmByjSI3rUIzBbx09Wa4J8JjQyXzVcCqA36QiQMo1trlwomg3akY3anMiOxlJ4fszL/nVPxrWs3S+U77dpQEBbSgfAquVO2UFpnO98x+ut2f233aAkNCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1JBeWW2EZ7CBQFu+F/CvsmKNLEZPMpPYkCh6TaSneI=;
 b=JKTTxLb0wMWD4GjvciqFblOSmiqHApsQjLaxhyslIFp30zKyG9u2FNcplGPIPBBUik7R3/f95Osh7bZYIkPSQ3nPBI6l3oJ2alZ0J5xykYNhsRQag1kAibSzZpZoM4/lHKYtsMS2kyd8Wt3GiIe9GsYlpzKTc+um+AVwWS2tysoRiXzjQ5zDP0aP2rZwcZA5B2Z7S9BvLjIBsmycIHfJY7cZ3/YL614mk7OnzXXGzZHcBlJv6jQCxPMKDqz+SoD77ZlNmwfDQR9vgTXKl1du4fs1zWN2buDGElTzxrcpjQlm8symlt4rcj1P4oE/EebNyZ18NGQuDVqc2pK1+HUOoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1JBeWW2EZ7CBQFu+F/CvsmKNLEZPMpPYkCh6TaSneI=;
 b=vHcqJ1Yd2zJXESY/fAHLsTUqUtqS5eGAKoLYyxC0wsWKGEipT2FBy5rg3EhgwQfwRmf+a5JvK3VXideTpzR00hV5QlGvcyak1xSnu+zdNZQwWNDst5iQjvRBLwOouhx3GkqFeR7+Vy6Ck7dF1oIItgnAWKT+cDIFQKp/N4pztDc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1260.namprd04.prod.outlook.com (2603:10b6:4:40::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.31; Tue, 23 Feb 2021 07:50:39 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 07:50:39 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v22 2/4] scsi: ufs: L2P map management for HPB read
Thread-Topic: [PATCH v22 2/4] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHXCP10vlbegHFtDUeQMxctLbOIr6plWD3Q
Date:   Tue, 23 Feb 2021 07:50:39 +0000
Message-ID: <DM6PR04MB657508BC3F0D0240FDCBB043FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p6>
 <20210222093050epcms2p6506a476c777785c6212cc80fc6158714@epcms2p6>
In-Reply-To: <20210222093050epcms2p6506a476c777785c6212cc80fc6158714@epcms2p6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 494c0d5c-299f-4510-47b0-08d8d7cfb6d2
x-ms-traffictypediagnostic: DM5PR04MB1260:
x-microsoft-antispam-prvs: <DM5PR04MB1260B8D18CC67459B6C4CE06FC809@DM5PR04MB1260.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C0JaWPbyu6Bt/UtWyn65cgd8Zk1HSnnTF8/lbkQK0hjGOeo5WUJ/7FI1QJOzI9Pbxn0selHqqBYqf7gBx88+lVfbPITpUT3xhk8EYuI29HUuyZVr2lmQi8VZQ4qJXgoOrW3OCMxRCKsX4QZEMqxKKPgO7p1fIxf3+Kokji4rg0tEKPVsM0RY8Xely1/CFZlwlScebiW7BYWS0Mq4owOygRhWiRoOoVRQPawiJ6pr5m73Ymw2qYg5skha6eXA4Z06Uzm5P670uU+l1A0hsa7AQkQ25GrWm08E6ppUesbWgsxw3eZKajYQ2v5057RhIaJfV/7pX/wj0pH7nrL6bMuSoR8rD6S+lCLTy6yNGsUzeKamYO0LwoU+XvRdt0PA2rwAA+OPOMUWCSl6IzKbBbRdqLn7jVKgp3nyg8MJbH6QZJ8JPC+ilji5TyF1p9K1oVTuzb+0uzliIPU4cA7tmi812e+vip0c82AMh2DgtLG+xjctky0QH/trPWvYoxVcL/o/qRgbP775qTgwKwRr2vWRCoTKXBcrjVS0ej2NVL0U/uuXx6NPqTB7hQGlxTdQTnLJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(478600001)(2906002)(316002)(33656002)(921005)(66446008)(66556008)(64756008)(66476007)(6506007)(55016002)(186003)(26005)(5660300002)(9686003)(76116006)(7416002)(54906003)(66946007)(8676002)(7696005)(86362001)(83380400001)(71200400001)(4326008)(52536014)(8936002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aUlLWHRoeS8yQjVFVUJKWm5vZFd3dmRKWUY5V1phNC9OU1VLekhEb3hrb2xV?=
 =?utf-8?B?S3dzSTh0TGVoWnFNY0JybUVOMWc4ZHQ0cm1pZ2taaUJXcnQra0JVdE43Yk1N?=
 =?utf-8?B?UEoxYUV6MWxITTRkNTMwam1NMFB1QnkwV29CMU9hS3pQWEd1UW4wTnp0K2tR?=
 =?utf-8?B?OXhGbVgwd0hNU2xFTmp5cDhXdXZYRFpLVHZ6UFArOGZFRmRuY1YvR01HZGh0?=
 =?utf-8?B?bmU3b2tuSHR6aHNtVEJCNEV6WWswWUFJZGRvUTdoUnhQcUxJRmkrWlNHdXVa?=
 =?utf-8?B?cnNoeUd1aE5ESUJjM1cwbU16alAzei9PZmFvdFd2WmdjMjduZHBJWnJVaE1E?=
 =?utf-8?B?V3RJVFYrMEVxZXdFenJCMjFhUXJtWEZTSTIvQUZMaG5VamtTZVRxek9NS2RL?=
 =?utf-8?B?Vkk3TXUxRnhaVDF3dVczT3d4bVJ4b1hJWkU4eGo2eHJsaldjaDlTbk5tc1p2?=
 =?utf-8?B?QVl4aVgzZk8rQ3ZMK2NSUHJ4ekFyeWRTajY0THF4dFBqSlhtbDlnTUhETlZ2?=
 =?utf-8?B?YXdabU9CWFBPTWR6Ty8zNk1OKzBRS3l5VytINDNXTmlXNVVzQ05XYVBWZXp2?=
 =?utf-8?B?VlMvclRINjJZREJsVkFHRUJ3VmVMWWEwelAzUkE0YmRJSHlJN1pNVHlnSmpN?=
 =?utf-8?B?Vm1JMFU1dWhQTnZwOHlDU25lSkRGSWdkbHFYVE01VDNUckZiSXlCcW9BRkV2?=
 =?utf-8?B?YjNQTURILy9hWVVuY3FHaktEVjFRTW84VW9zaWw0S0RBdkZ4eXpia3plRUNx?=
 =?utf-8?B?dnlISnBZbjVNckVmZEJGMk1qaFMxU1BBM3V4N0twdDJvRWhKRTZuc1BpdjhV?=
 =?utf-8?B?OXJmcEg0TUJsYUF1YjlWSFRMYzFrSldCNmI3UVVBd1MwaXAzNFA2WE53eStO?=
 =?utf-8?B?Q2RZM0xiVkxqRW9xZzJ4R0xSWC8rK1d1c2xjYitncGU3cldIMDRCbGdlVzYv?=
 =?utf-8?B?cmJKVGdncHVKWEN4cnRuT2JBbzFTQ1p4WGRmOHlndnZRRUJoRC9oTmdGMFNk?=
 =?utf-8?B?OUlFZUxNRjQrejlhTmdNc05zejl2NE9SYkFoMDlJcmJpUnNUVnpWSGUzV2Jl?=
 =?utf-8?B?MXRuMzZkWFo3cldPQjNuc0JKYU5DQm9MdkYxQ3habXg5cWJPc1pJRC8ySUtr?=
 =?utf-8?B?SUFmYWE3cWNKKzRMWUh6M0R1SGhvaXB6WW1mOWtPeE1GUDcwK2sxMGVSYWV4?=
 =?utf-8?B?L29keG1UWW54TWZIWlhvbHJrc2N5eFltekpiR09rNWpSK2tuUm94UHh2SENP?=
 =?utf-8?B?S1VBdDRRWUVTNHlZUFBoMjZidFdkNlh0aWlxOENvK1JkOHczQ0dOWmIvMXIw?=
 =?utf-8?B?RlRrMllvMUlwSHdac0lUVVlzVTNwejV5RFYvYWwrcVg5M1AwYm1DaWZuajJh?=
 =?utf-8?B?NGFkd0VKbzZnYjZlU2lZeXlURFVHQWJlK2dVeHVNazFPT2MzWi9ZbGxnMlFN?=
 =?utf-8?B?SUh6bXJYL2xhanFhOTZWQzZ3UXBpcFhZck05Q1VucmViKytGbytXODhUMks0?=
 =?utf-8?B?aHdXYlJjY1hIemY1UHdya25wQW9yV0tieDZyMFZtMk1wc0R0KysrS1hXS3BP?=
 =?utf-8?B?dTNJaGVPd1JZRFBPVUNBVmFMZmovTHR5MEZwRkxaYUhIeWI2dGlabEEvNlRh?=
 =?utf-8?B?WGFFdm9IaUpGcEIyMGplMEkwTnU5dEJIbnZZTFFJNHFJYjRBcXhRdWRPbUpH?=
 =?utf-8?B?R01EUmxaM2swdkoxcHlLWEluMHl2eVNiR2Y3Mng0eFN3aGc2VGxMTDVnY2V3?=
 =?utf-8?Q?YpQThByQP1J6xB0H7/23BD9ww/9rOsgQ3Dyc3y6?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 494c0d5c-299f-4510-47b0-08d8d7cfb6d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 07:50:39.7166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0zegv9QFr61sKMuyJwRrfUf1R83gENX2m2BmFi5ndSqRmi/UpLwSh56Cji6mppeDc87+ueE5XtAsvs3WNZRLsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1260
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArLyoNCj4gKyAqIFRoaXMgZnVuY3Rpb24gd2lsbCBwYXJzZSByZWNvbW1lbmRlZCBhY3RpdmUg
c3VicmVnaW9uIGluZm9ybWF0aW9uIGluDQo+IHNlbnNlDQo+ICsgKiBkYXRhIGZpZWxkIG9mIHJl
c3BvbnNlIFVQSVUgd2l0aCBTQU1fU1RBVF9HT09EIHN0YXRlLg0KPiArICovDQo+ICt2b2lkIHVm
c2hwYl9yc3BfdXBpdShzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBzdHJ1Y3QgdWZzaGNkX2xyYiAqbHJi
cCkNCj4gK3sNCj4gKyAgICAgICBzdHJ1Y3QgdWZzaHBiX2x1ICpocGI7DQo+ICsgICAgICAgc3Ry
dWN0IHNjc2lfZGV2aWNlICpzZGV2Ow0KPiArICAgICAgIHN0cnVjdCB1dHBfaHBiX3JzcCAqcnNw
X2ZpZWxkID0gJmxyYnAtPnVjZF9yc3BfcHRyLT5ocjsNCj4gKyAgICAgICBpbnQgZGF0YV9zZWdf
bGVuOw0KPiArICAgICAgIGJvb2wgZm91bmQgPSBmYWxzZTsNCj4gKw0KPiArICAgICAgIF9fc2hv
c3RfZm9yX2VhY2hfZGV2aWNlKHNkZXYsIGhiYS0+aG9zdCkgew0KPiArICAgICAgICAgICAgICAg
aHBiID0gdWZzaHBiX2dldF9ocGJfZGF0YShzZGV2KTsNCj4gKw0KPiArICAgICAgICAgICAgICAg
aWYgKCFocGIpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiArDQo+ICsg
ICAgICAgICAgICAgICBpZiAocnNwX2ZpZWxkLT5sdW4gPT0gaHBiLT5sdW4pIHsNCj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgZm91bmQgPSB0cnVlOw0KPiArICAgICAgICAgICAgICAgICAgICAg
ICBicmVhazsNClRoaXMgcGllY2Ugb2YgY29kZSBsb29rcyBhd2t3YXJkLCBhbHRob3VnaCBpdCBp
cyBwcm9iYWJseSB3b3JraW5nLg0KV2h5IG5vdCBqdXN0IGhhdmluZyBhIHJlZmVyZW5jZSB0byB0
aGUgaHBiIGx1bnMsIGUuZy4gc29tZXRoaW5nIGxpa2U6DQpzdHJ1Y3QgdWZzaHBiX2x1ICpocGJf
bHVuc1s4XSBpbiBzdHJ1Y3QgdWZzX2hiYS4NCkxlc3MgZWxlZ2FudCAtIGJ1dCBtdWNoIG1vcmUg
ZWZmZWN0aXZlIHRoYW4gaXRlcmF0aW5nIHRoZSBzY3NpIGhvc3Qgb24gZXZlcnkgY29tcGxldGlv
biBpbnRlcnJ1cHQuDQoNCj4gKyAgICAgICAgICAgICAgIH0NCj4gKyAgICAgICB9DQo+ICsNCj4g
KyAgICAgICBpZiAoIWZvdW5kKQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiArDQo+ICsg
ICAgICAgaWYgKCh1ZnNocGJfZ2V0X3N0YXRlKGhwYikgIT0gSFBCX1BSRVNFTlQpICYmDQo+ICsg
ICAgICAgICAgICh1ZnNocGJfZ2V0X3N0YXRlKGhwYikgIT0gSFBCX1NVU1BFTkQpKSB7DQo+ICsg
ICAgICAgICAgICAgICBkZXZfbm90aWNlKCZocGItPnNkZXZfdWZzX2x1LT5zZGV2X2RldiwNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgIiVzOiB1ZnNocGIgc3RhdGUgaXMgbm90IFBSRVNF
TlQvU1VTUEVORFxuIiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgX19mdW5jX18pOw0K
PiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiArICAgICAgIH0NCj4gKw0KPiArICAgICAgIGRh
dGFfc2VnX2xlbiA9IGJlMzJfdG9fY3B1KGxyYnAtPnVjZF9yc3BfcHRyLT5oZWFkZXIuZHdvcmRf
MikNCj4gKyAgICAgICAgICAgICAgICYgTUFTS19SU1BfVVBJVV9EQVRBX1NFR19MRU47DQo+ICsN
Cj4gKyAgICAgICAvKiBUbyBmbHVzaCByZW1haW5lZCByc3BfbGlzdCwgd2UgcXVldWUgdGhlIG1h
cF93b3JrIHRhc2sgKi8NCj4gKyAgICAgICBpZiAoIWRhdGFfc2VnX2xlbikgew0KZGF0YV9zZWdf
bGVuIHNob3VsZCBiZSAweDE0DQoNCj4gKyAgICAgICAgICAgICAgIGlmICghdWZzaHBiX2lzX2dl
bmVyYWxfbHVuKGhwYi0+bHVuKSkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuOw0K
PiArDQo+ICsgICAgICAgICAgICAgICB1ZnNocGJfa2lja19tYXBfd29yayhocGIpOw0KPiArICAg
ICAgICAgICAgICAgcmV0dXJuOw0KPiArICAgICAgIH0NCj4gKw0KPiArICAgICAgIC8qIENoZWNr
IEhQQl9VUERBVEVfQUxFUlQgKi8NCj4gKyAgICAgICBpZiAoIShscmJwLT51Y2RfcnNwX3B0ci0+
aGVhZGVyLmR3b3JkXzIgJg0KPiArICAgICAgICAgICAgIFVQSVVfSEVBREVSX0RXT1JEKDAsIDIs
IDAsIDApKSkNCj4gKyAgICAgICAgICAgICAgIHJldHVybjsNCj4gKw0KPiArICAgICAgIEJVSUxE
X0JVR19PTihzaXplb2Yoc3RydWN0IHV0cF9ocGJfcnNwKSAhPSBVVFBfSFBCX1JTUF9TSVpFKTsN
Cj4gKw0KPiArICAgICAgIGlmICghdWZzaHBiX2lzX2hwYl9yc3BfdmFsaWQoaGJhLCBscmJwLCBy
c3BfZmllbGQpKQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KSG93IGFib3V0IG1vdmluZyBi
b3RoIHRoZSBkYXRhX3NlZ19sZW4gYW5kIGFsZXJ0IGJpdCBjaGVja3MgaW50byB1ZnNocGJfaXNf
aHBiX3JzcF92YWxpZCwNCkFuZCBtb3ZpbmcgdWZzaHBiX2lzX2hwYl9yc3BfdmFsaWQgdG8gdGhl
IGJlZ2lubmluZyBvZiB0aGUgZnVuY3Rpb24/DQpUaGlzIHdheSB5b3Ugd291bGQgc2F2ZSByZWR1
bmRhbnQgc3R1ZmYgaWYgbm90IGEgdmFsaWQgcmVzcG9uc2UuIA0KDQpUaGFua3MsDQpBdnJpDQo=
