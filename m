Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28B4C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 14:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93E6A64EE2
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 14:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhBTOey (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 09:34:54 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:29680 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhBTOex (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 09:34:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613831691; x=1645367691;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Kqaf1TqJn/r/DGYkTRFOcBpGbeiO3+CT6gjsm7Qm5rU=;
  b=RpLQWFMcOzaPbiIpmmZ1R/s815HTmWCqAQZFuOEJCndHpzARd9dFOVRS
   wClfvrTTeYoBwUpmYqnXPJPwhso426XlrVhoZ9iVcVihDCcqJ1vFkSQPK
   KU2oFTwef3fkj+W42GdHR0rVSNjm1gC3a8IRqly3Rp9+S3Rgm+RoDlW8N
   0b+2UwkOM2tZa46x7cX4xQbLJLN86/jZihfyVDk3SIpKA0snnzHaIfmxm
   B28dstiG2GkjkxmR4xeWmClqjs/3B8QAfHfVTZShIo1k9uh3bPYEGiUKS
   lwlhM4GDK/IDQ8WL7ylbr/oaYJ6z5ebBtnc0rWFNYBnbFEaG0FzwYVXl9
   A==;
IronPort-SDR: 6woipi56tEZ1SXeZd6HfLYP7HHKAqvZ+vS59f+mZK6DVUkhkKsfjVjeCOo9e383342/c9LJhYA
 s1bfJeYB/r89qcgQLgEUT048l1zflwtvWZHgMQ/N4CDcViqrtXqTPn2EG0SuGqKvRfxFFlWYFY
 7jyjpS16ZGQi0t5YIQa92QzYRAIKAyKK0MC27Z2/V4alYWnw36rJTnqqM0+s7B6ODlASlmGN9N
 kVCDFfhroLBmirFKWQQhDd0haF1K7ehNTXddWKNrAvRMIvP6RheFtHV2fRtoqBp5ckITZlvUE8
 Hhw=
X-IronPort-AV: E=Sophos;i="5.81,192,1610380800"; 
   d="scan'208";a="160422576"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2021 22:33:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMcTEiSgEjBG4lBDcnaOnyXZek0qR6mY8OIM/hS18DxXEkKP7OWjyZ0awn2YmGVlf7o+6Qj/B1NSinDBj/YdWvdvBKOEuSeXWf9xct6OvNG93FEdCH7odLNzRIGAAxjw/uTsDwkrJjq6WYekWRQ7P8a0OrWwOMQQU4rZcBLKVWLeYkvRZKHOGKmYeqHUiwQejBcJLRuWD8Sk46sXHddzUsgSVIbT773vEb6coYIm73kfgAvD5P2DdJ7sm2HCEbt0ulIKssWUIt8FSL+onG8TE8JEaK+5nJxVP7u8pCeNCycVJRUywmPaFT40Fhd0qlgNXNvDxyp6IW188vbbERLwvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kqaf1TqJn/r/DGYkTRFOcBpGbeiO3+CT6gjsm7Qm5rU=;
 b=aRY/ZWfP94SZbMJck+fZHCKisa5eKpNeWUY/mcv3Q6HatnrTfr8aWl4n20mmWgmD/T3472tqvIjxPvprYGFvUmOKdOecULJB2yoWPHt+Ko0iZr8tYwx5uGQ5wbg/ynK784stmr1Q6lDnHtZ6ODuBmCZok98Bw1snw4+YlKzNu0qiyMjHAxRX+mGpW/TzIQmtD+tjKbWMLGgym2YySGRkyfYkHFcgvQCYhx/d/T/GzN08vn6ni9b9l345zhGuswjLyFAug7q1X9yJW5BpaumIUK5QsOo3LxIh8AquwX+CA8t7DhMh6T8dcTpfXF2a+1vqJR+fZJu2/IcgsHApvATQrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kqaf1TqJn/r/DGYkTRFOcBpGbeiO3+CT6gjsm7Qm5rU=;
 b=BYdp7KDLcaYfi8diuP2T/7TloRkuuHyFpUJg8/JXW5NEr8aogtbF7B4ZVySokQgHQ4QDqFenLhqB5aGEEGC5qf+AeI41TZNVog98FFG/ukK6tTeCbVro0ImNh03UYXyf3pPdF/EImh8JubmaOdTqieB9/7bTMMmWM81nrrrCKrU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6576.namprd04.prod.outlook.com (2603:10b6:5:20d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.27; Sat, 20 Feb 2021 14:33:43 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%4]) with mapi id 15.20.3846.042; Sat, 20 Feb 2021
 14:33:43 +0000
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
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v21 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v21 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXBdW0QJ7+4Lnwj06VLwfkJQoyl6phHCBQ
Date:   Sat, 20 Feb 2021 14:33:42 +0000
Message-ID: <DM6PR04MB6575B0CAAAEFACBC719257F5FC839@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p6>
        <CGME20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p8>
 <20210218090853epcms2p8ccac0b5611dec22afd04ecc06e74498e@epcms2p8>
In-Reply-To: <20210218090853epcms2p8ccac0b5611dec22afd04ecc06e74498e@epcms2p8>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 46b48d6e-f994-49b4-d3b9-08d8d5ac8606
x-ms-traffictypediagnostic: DM6PR04MB6576:
x-microsoft-antispam-prvs: <DM6PR04MB65765945E5FEDE6DC75C87E3FC839@DM6PR04MB6576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SrBVQ4VESsJNEyVB7BMp4zPvfxXLiSiMfM7fVeqvM5r0bMAp8udYvicbbFLrfZIb7mb7xH4xpUIXYzRk+bR0XHeXnLLUsW2hNl+Dfn4lqBBppObev/dPivDEv9xNXzjiyjiKEsHmgsXJDeRP8f+nJK0D+YRMXa1Q63+RCj09XPZungeCku2T4otDnVlZ9PtmZXpKXkoAfg1TXT78xwfgohKtGgPfybEftERJskKn2tnNi8GACkf8T+uYNZwQlgpKILZIUpYFMeJo7T9Jkd56j2dJSrIhGCZ4cPZM18VDT0H2jD1yKYO8tIR4PZnS2s6uxuaeejh9eHSZydxPfwdFgUzpVYIRTryILdukkzrxI2RMy/ZSeoiUpnotXrGMarZbALVeJeScz7IRWtlyIr1LBE+hUwNEbILu6NpdESqYqoQm7LKQvr8OD6LJg+6qM9HZs1fauVpHkolsEJe1sFL1DlDMHg2SKCxSWBrHH9Vuy/hahHCkbXW4gjHerDvTvyjFs9pYu2tbVNPbTG7JtYwyTae7XNRam+ImhgCglCnLcfuT7i0UkWq6UXCDEXta+Agt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(7696005)(66556008)(66946007)(4326008)(66446008)(33656002)(4744005)(76116006)(83380400001)(86362001)(64756008)(478600001)(54906003)(66476007)(110136005)(8936002)(8676002)(921005)(186003)(5660300002)(9686003)(55016002)(52536014)(26005)(71200400001)(7416002)(6506007)(316002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dmEva01iMFdzS3dmQTBZWkhTcWdpUkRmSU1YdDNsR0kxQzM2aSt6Y0hUcDhl?=
 =?utf-8?B?RzZqK3JCNWUxOWxHMUhrMzVJWmp5cVhaRmh2dmlpb1BRby9SZEs4UXZNOUdy?=
 =?utf-8?B?UVByRzN4ZzhTWDFWRitIT0xOalMyMkRYMzlYZU13V0hyaC9vNVhDRXNWN0xG?=
 =?utf-8?B?NDhwUDR2bWRjM2s3Nm80bnJkcnI2TG1NR0kvWGw2dm1MRVg1akRBSjlURjg5?=
 =?utf-8?B?Rlo3bkFqdjMwVTdmVElvUGFCa3k2NG1wekpTYW1ITTBZWThzdlF0b3pzYWpF?=
 =?utf-8?B?YlZxTVVzM0QrYTVpUi9xNnplbEpaZnlnTzZMWWxmZVRhaWZ2SVNPMHdHZHlx?=
 =?utf-8?B?SEN4enFaRHZPYXRZS043SnJWUFpQUk82UmVRWUpVYUc2Q09mU2dIbWRmYm9I?=
 =?utf-8?B?TWlNRWY1QTA5ZSs5Z2ZBZGs3OXVEcUlKOG52b09HVUp6VTV4NXdQT1RsQlN5?=
 =?utf-8?B?d2ZwdXdpV0JnakNmQW5zZnI2SzJMbkxqd2FnSWJOMGZ6aUdaWXN5ZnlwVzIr?=
 =?utf-8?B?b3MzaEEyMWZZbFNjMlRsWHQ3bjdqa3dKcnh5S3hpeXhqcXdYTmovaExFWXlV?=
 =?utf-8?B?cytCaVBSSjU5SGdSM3hiNUpJMXp3T3FJUjVFWnlxcWNnRHFwRVdiTGsvNFRD?=
 =?utf-8?B?aFN4SnFtbDF6R0NPcktLVEtZUFF1b255dENmU3M5WGtrazIyZVd2Z0ZLd2Va?=
 =?utf-8?B?UU5naFVHbElveDc1SkdhM0hWa2hvLzIwY2pEeldoUm9UY1VtemtXVFRXN250?=
 =?utf-8?B?VndNNFZTM2NxN0RxUXc1elloZzBhaW81aHNMLzFpTHdiay9wbFRrQVdEZ2pr?=
 =?utf-8?B?b2t2Q0VLN2gzVmRybmZ6WDgyUHpWWFk3Ync1UjRPeS81UGNtcEdIYjZ4RW9y?=
 =?utf-8?B?R0F0dnFVckt5aHM2MFhHZ2tpbjViMTQ3NUQyNW53ckc4T0lQSEpJL01kL3Ay?=
 =?utf-8?B?eDdyK2pkTzhESm1yVWRhVk92L0wyMHk4dXRUZGxEeVZldiswZExKK3RYMFhC?=
 =?utf-8?B?UzQxZk5EMUVwLzNKMmtYa1RRdi9UaGdLdCtHSnJuWEpyU01oK1Zhb2xFaXhM?=
 =?utf-8?B?R0lPajlrVmJzZFhCZTVNMGw1bDhCZlEvb0V1ck80cnpyY1Fnc2FZRnVCbng1?=
 =?utf-8?B?S2dQeGM1ZmFtcXA3SFJ2TzdmbjIvSFI4Z3ZnTWt3QmpuWFVFMTRmN3JwbDB4?=
 =?utf-8?B?WnhTRysyTDAvdSsvcS95MkE5OVAzRjl1WFE0VGxyVjFHaHpzK0M4aEtNemc0?=
 =?utf-8?B?TFhldW9NUG1vN0RkT0dlU3pKMEo2L0NxT1E0Zkx6R2Jib2swT3VsdEQvWG5p?=
 =?utf-8?B?UEIvRXVCYWNHeW5xOUhWa0xHVk9hdTVsdGtkT2grNjdEN3c3R0RmSldmN0VD?=
 =?utf-8?B?N0dydE1yUUtXZFJ6enJnK0hycVU2WDVFUDc4azRCQmtHMjlYT2JNK0h4ZEN5?=
 =?utf-8?B?dlZiZUlxOHlZRllOZi95NjVYMTUwNGV3WEhscmRZVmVjTGp0U2JyTjhwREp4?=
 =?utf-8?B?Ni9aaVRNUEp4UHRYdlRUR1FWVWRhbmwzWXR1Vi9SKzR4YytkbXpaVytIQkFi?=
 =?utf-8?B?bGdnV0lndnVEWjVIRFFlRGpYWHY2RFg1cjBhM0VTZ0MxMXpWMGVvdnJZclhI?=
 =?utf-8?B?enBhNUNZQmJGWkZTZEtUNkRTR2ZBMmVPT1hqUVZQTFRROTBscDN1RHRpenFO?=
 =?utf-8?B?MzdodDJuQTR6ZXJ3UnVYR0p5aGhmaVhqdEJkUkhZQjJJdW8yL3dxWGxMZFJt?=
 =?utf-8?Q?I1slZO603KvK6RiqsU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b48d6e-f994-49b4-d3b9-08d8d5ac8606
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2021 14:33:43.0868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9IBWTYqyUk8npLmoksf7+k5/prsg7CR2NAFexdbHgaT3BiWtHdsYXy5wG97ZCfFE1XOgfidyMeWHZ2sdJOMeaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6576
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICAgICAgICAga21lbV9jYWNoZV9kZXN0cm95KGhwYi0+bWFwX3JlcV9jYWNoZSk7DQo+IEBA
IC0xNjcwLDcgKzIxMDksNyBAQCB2b2lkIHVmc2hwYl9pbml0X2hwYl9sdShzdHJ1Y3QgdWZzX2hi
YSAqaGJhLCBzdHJ1Y3QNCj4gc2NzaV9kZXZpY2UgKnNkZXYpDQo+ICAgICAgICAgaWYgKHJldCkN
Cj4gICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiANCj4gLSAgICAgICBocGIgPSB1ZnNocGJf
YWxsb2NfaHBiX2x1KGhiYSwgbHVuLCAmaGJhLT51ZnNocGJfZGV2LA0KPiArICAgICAgIGhwYiA9
IHVmc2hwYl9hbGxvY19ocGJfbHUoaGJhLCBzZGV2LCAmaGJhLT51ZnNocGJfZGV2LA0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJmhwYl9sdV9pbmZvKTsNCj4gICAgICAgICBp
ZiAoIWhwYikNCj4gICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KSW4gSFBCMi4wIGRldmljZSBj
b250cm9sIG1vZGUsIHRoZSBob3N0IGlzIGV4cGVjdGVkIHRvIHNlbmQgSFBCLVdSSVRFLUJVRkZF
UiAweDMNClRvIGluZm9ybXMgdGhhdCBhbGwgSFBCIFJlZ2lvbnMgYXJlIGluYWN0aXZlIChleHBl
Y3QgZm9yIHBpbm5lZCByZWdpb25zKS4NCk1heWJlIGEgZ29vZCBwbGFjZSB0byBkbyBzbyBpcyBo
ZXJlLCBvciBpbiB1ZnNocGJfaHBiX2x1X3ByZXBhcmVkIGFmdGVyIHlvdSBraWNrZWQgdGhlIG1h
cCB3b3JrIGZvciBwaW5uZWQgcmVnaW9ucy4NCg0KRWl0aGVyIHdheSwgSWYgeW91IGRlY2lkZSB0
byBkbyBzbywgSSB3b3VsZCBhcHByZWNpYXRlIGlmIHlvdSBjb3VsZCBhbGlnbiB0byB0aGUgZnJh
bWV3b3JrIEkgcHJvcG9zZWQgaW4NCihzY3NpOiB1ZnNocGI6IFJlZ2lvbiBpbmFjdGl2YXRpb24g
aW4gaG9zdCBtb2RlKS4NClRoaXMgd2F5IHlvdSB3b3VsZCBoYXZlIGEgd3JhcHBlciB1bm1hcF9h
bGwgdGhhdCB3b3VsZCBjYWxsIHVmc2hwYl9pc3N1ZV91bWFwX3JlcSB3aXRoIGJ1ZmZlciBpZCAw
eDMsDQpBbmQgSSB3b3VsZCBoYXZlIGEgd3JhcHBlciB1bm1hcF9zaW5nbGUgdGhhdCB3b3VsZCBj
YWxsIGl0IHdpdGggYnVmZmVyIGlkIDB4MS4NCg0KVGhhbmtzLA0KQXZyaSANCg==
