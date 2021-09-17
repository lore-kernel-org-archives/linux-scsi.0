Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8957C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 19:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A97C5600CC
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 19:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238991AbhIQUAk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 16:00:40 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26411 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbhIQUAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 16:00:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631908757; x=1663444757;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=fXPmse3UPInLSP0eVqHSz+uHuSOSuTblJ+zMezyxKlA=;
  b=VhOnWGcjpzx35snGxxBsVyz+jFWI9GF6JdiI7/8ZVAw9+E+4Os5RSdwI
   iR/6T9pfViXxKj/Fd1n6k9OdSkJNn1G/jAHYxx/8nV7ZdW6BLy9XlaTV6
   wUoeYDmYPNIykuHfAzwHuI/iGbbK2+7ffcuV9/DymNKZnWZKiI6pD7kcn
   mUnouKEW69eMn3eXYwifa4qRphak2vRW3T0dO7RItDjYas+gpOOPc1Sj8
   c1sWSFf2JG5nGF2AmYNlq0egkU/4gnZn+tOnw72IZLtOy1SGfl/mAVzTo
   z1EQ2CjswPAOMDjINio1qJ8V1FMdxXrEG5YKUhI14JRUb0ykZWFICttJJ
   g==;
X-IronPort-AV: E=Sophos;i="5.85,302,1624291200"; 
   d="scan'208";a="291915841"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2021 03:59:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOu7VwlXTXwQDgac3gYCaSghiSwKWwOlrzzFSPq51DNBRSFvNMgfIiW5THxxLADSf5e6qwGRNEXT5xCh32PqIrvfirWSjDSQXNIBIEL1bYYG76c0nZCgEmGy7mD5ZOztDBqO2oLNC3h+3pcf4O66VonydC0Kb4f2g0V8IVjhKYmlRoHnOtQ4LILmsFlj/fQFEwKS8BZohsj5CTs8KYWuOqK9xXWgIFy2TYpeQaHYsmQqEkcIe4jg0KtKVltH8J5Bum4b4lGalAV2hjg/gJfNYPaRTtord2bRX1BAI4I+FLqhDkZeeY6VDyQieUEmU2nG2u5jGXAMPJq48f9Wcicl5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fXPmse3UPInLSP0eVqHSz+uHuSOSuTblJ+zMezyxKlA=;
 b=kB8PBHzn6BWvNrCGPDZSjtwxFj9okf27i029dlnc9Oi59DN0nh3p6rE67kz8lGymWnOgnP7gdKpR2u8QY1P5cSep6p4VhB8vW6urkGhbBOSLzD/3VByuWApB79bxCRr+2SSumgxESiYwJ+aUnHgGQukbjQ6nrjEA0uoghkSNSAch32JoqDS565Sxofgy5P5Al4toZt0RnlLuu3gCbSTUZD4J5zWjseSMcsMwf8Hd0RUQsj7IfWqJlg1HGutlOC8TM8bs6P9awpRdsa38dOtzGA/Lie9KxPCwmSEsMc4kGHG5p+7y+kzRrwzC5GN2mN4vIt1vGwEtrEVn3x+DZu3VJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXPmse3UPInLSP0eVqHSz+uHuSOSuTblJ+zMezyxKlA=;
 b=j39U1N0V4RsUzBfX5fz8lQ7gnjcEM5U2ZlW0lDT/S+4eyXpkCuwplHuSOpSSsYz279xdOTZHOHmL63Lc8rYjtIP6ITYjKnRu5q52w8T+VRVJAFVk5UMk/WvRiGivK7FPcjVDX4bW0VJ1Zk2jKv9fSoReG6pcEmGZATPpLRWDj5U=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR0401MB3655.namprd04.prod.outlook.com (2603:10b6:4:81::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.14; Fri, 17 Sep 2021 19:59:14 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 19:59:14 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "bhoon95.kim@samsung.com" <bhoon95.kim@samsung.com>
Subject: RE: [PATCH v2 3/3] scsi: ufs: ufs-exynos: implement exynos isr
Thread-Topic: [PATCH v2 3/3] scsi: ufs: ufs-exynos: implement exynos isr
Thread-Index: AQHXqHcIUtwIA3dfAECudvRbpFHX2quoq5fQ
Date:   Fri, 17 Sep 2021 19:59:14 +0000
Message-ID: <DM6PR04MB6575978CE43BB03BB0B29AB1FCDD9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <cover.1631519695.git.kwmad.kim@samsung.com>
        <CGME20210913081152epcas2p2eac4a8dbef33164a150dccf2e282dcce@epcas2p2.samsung.com>
 <746e059782953fca6c21945297151d2bb73d3370.1631519695.git.kwmad.kim@samsung.com>
In-Reply-To: <746e059782953fca6c21945297151d2bb73d3370.1631519695.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b5b11d6-0544-484b-9ed1-08d97a159fc0
x-ms-traffictypediagnostic: DM5PR0401MB3655:
x-microsoft-antispam-prvs: <DM5PR0401MB3655E94FFA864A05DC2CB364FCDD9@DM5PR0401MB3655.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h65Sr6oLWelCDxwPN0jfeHj8ReigM3zWlspAzSJRRAEhG+V5HXos5g0TQMIQMtLOlDrAMXOkm+JOP8msh/4nCzIScxkc0ZOTAC1teWefa22Ikoild8U9uw6ovER5xaL2H9oFTy7mRnBYO5QBeoPu8AWOO1OKUHPZZG3VqzLzHZ7MO5FdbubMjiAPYM3c+8PylTiiqVZ5a5HgdOLGveOGyNfzeK7t6EZPxF/3HmJTRZHgC0DdXCFF5gWQDrh6T0tMIy7J+3jCep0qV4GYwnhj0u5Y7x/R9xUzSW3TxMk/Paz4U0oiD3KxuzGbZW2LRtz/IOhdA/g8IV4NS1y3ucAGXMOdF3eqSYO3qFZMUP0hihf4oL7t1vEFsQMpcANuQS4oqLbbYDqpf55cLbigYNw4hENF7sPHsoX8SaIiB+daGmauNPBNKKgMVDyxRgTEpxQthM9dAjXA6m4nFFsv8K48i0qCbs1IcXiI+8pLkpIoUA1pQkd+7wJQYt0V0UARuySVl0K1Obzkvy1F5JKhPaIm+SGJX8ZhwxV5wa/KKdm3biT9yHX7kcPdkK9Qr2TAq8PVNkAX3ZTbQ/WezITsk4LdC2UuTBjp7qjBVi3n0a+5kd+6Z9/BkDAD5Be1r++ymNz7ARcCTsfRPEb+5dOG3So7ikVmGND9wSINwFThFsnThtzZiSb5uoyZAcsq7JMTgTmBZpaysFlYhx0/lfVeRBc7LCii9g6IK0jdb9/JNSuQpkc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(9686003)(86362001)(8676002)(122000001)(316002)(8936002)(33656002)(55016002)(110136005)(186003)(26005)(7416002)(52536014)(2906002)(38100700002)(38070700005)(64756008)(66946007)(5660300002)(921005)(66446008)(83380400001)(478600001)(7696005)(6506007)(66476007)(66556008)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckE5ZjdoaXByWEtPZDFPWkFaQWtMOG1PalpnUi92WGdnUVBlcCtXUzRaWWdH?=
 =?utf-8?B?UFdHanZ4dDZkc0N5VXJVcEJ2T3hGMTAyODFTOXArR3N4TU1YRzNZcTJWckRt?=
 =?utf-8?B?QXRSRUo2NG5nYnR4YnhOTFdJQlJRWWt2R2pEeFg0MXQ5djdCWVowQllENlVT?=
 =?utf-8?B?aGo0WjlpUzVDai84bjVEVjJEOWJCTlJGREFvd0NVVUNiU3B0QW03SjY3VE5B?=
 =?utf-8?B?eXE5N0tSUGNlaHdmWGlKa2ZUMWhzYUx4UHhMZ1pZblk1eFFZalJrVnlpNllS?=
 =?utf-8?B?NkZCZEtESTdraTdGVWVTTk9pdW1FQ0tWenZZdHhFeithaG9EajFTYnRQWWl2?=
 =?utf-8?B?bHc4NkEwL2E4ZVRXRVo2QUJ1enBZdEk4Z0M4K3RXeWFFSWV2NkxXZzFMaWg4?=
 =?utf-8?B?dEJ0Unh1U2pWaW9yNzMvNWVGU29Sb2lFTjd4L0FBOHRSbDJEMVpEbG8vSjVC?=
 =?utf-8?B?MDVlYXBpRCtuSHd2ZllhTHVaZW8vTnMxTzFldDEyay8xUzFSdXZubjNQWGtH?=
 =?utf-8?B?NWU1M1ljK3dwSElEMnI5bWFheDIvUmFDVUNIZ0pPRjNoQVFrTTJLZ1UzVDBO?=
 =?utf-8?B?clhVNEduQWM1WGZ4UU1kaHF3NW1wVnZwdHk3YmpCakNpNDNiZCtRRTQwbFJV?=
 =?utf-8?B?cW9jQ2lReFovR3Y2TGlwWUhJMG84T0tlcThEUjBwQ2ttOWVheDVsM1dWQ3pm?=
 =?utf-8?B?VDh4UEJ5L0h4ZGNObXFkeVBET0FRaTBMaW9qamVhazFubm5tVlBGeEhRMk9I?=
 =?utf-8?B?QnE5UFpYVUFzQ0N1YVdrYWhNdWovS1Z1RzBpZlR4TnIybTlRVmZUMnZXR05o?=
 =?utf-8?B?ZHpzSmpORWlWL1ZxeHRrWFZ4d2d4NUpjMjlaKy9OZ2g4SVZsajZYUENnells?=
 =?utf-8?B?Y1oxRWFLOEIvZENHT0F2S2gzZnhNTHNwTmZqOG5nbmxNSU5TV2NRUlRMbzQ2?=
 =?utf-8?B?MGNOdG01YTJva2NBMFpmZzBCY01McW05clVOSHgxUTAxL1B5S2ZEUUdxQkJU?=
 =?utf-8?B?aGloNkhMR1ZDSjVWTUFSUU1CVEN4bkJFQW1TVnNFNU5OZlB5dnB1R05wR3FW?=
 =?utf-8?B?VllJWitvZ2c5K0hjbTkvMnFkWkRBTnNQVnNLYWttU1AxYVRZRmlQNkJWZDl4?=
 =?utf-8?B?eC8rUFJQaW8zWVJjRjEwck5CcnloaUt2U3EwVXNwUDl5aThaVzh4NFhNZm1C?=
 =?utf-8?B?K1RtRTVNcDBpM3lFWktnMzJzcFA4RTFVRHhnQ2RPaXgva2E1K3ViVTZjemRO?=
 =?utf-8?B?SWNjYUhGZ2dkSEd6ejM5K0RSQU4rbW1GWkxFSlJKV2wwdTFvRVN5cnZhamNV?=
 =?utf-8?B?OFQ0emVnVTJxNzg3WWZVUWJzMTZwZmMrYkJqcllwT3VXS3RBcFpuUFFyS2dz?=
 =?utf-8?B?M3RTUGUwUlAzWVkxekJ5M3puU0ZyM0Q2Y3drSzd5S2dEZFo5OFRibW5uVDJM?=
 =?utf-8?B?K2JhanczMEN2ZXZ1SzVSY25YbWhFWW9FVGRpd0FHY1h0V0NubTFRODBMc2hm?=
 =?utf-8?B?eGVrT3A1bXBvM2VXTTU4ZzNMUnhDMUwrdEo3bzJqSnFEMnBMbTBtWGM0Q3Va?=
 =?utf-8?B?TFFvaTBqSXJOSGRrMWNORXBXeURpWEtUbFprYzRHTitHaXhOek45QWFoazRy?=
 =?utf-8?B?QlBaN2lQd090dDhueGFBQllTMVBKMi9pL0xkQnlFWmRrZC9NUFdUdVJGWnBN?=
 =?utf-8?B?REk1OUE4eFpvTXYyZ1cyYjArSmxHZGFvN3IycVpEemtXOUw5Nm9RU28rcU9Q?=
 =?utf-8?Q?IFBVrFMeE7N2zc0jAvs+PNMmeclox0y7FRWm6Sn?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5b11d6-0544-484b-9ed1-08d97a159fc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2021 19:59:14.1066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k86wptNrzTEPOmpJf6O8x/2WMFPivYgPgft8D1deScBumOL9VUaCnWTCCHIBwYvyM2WP/WayWHaLX4vbG/uX4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3655
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNCj4gK3N0YXRpYyBpcnFyZXR1cm5fdCBleHlub3NfdWZzX2lzcihzdHJ1Y3QgdWZzX2hi
YSAqaGJhKSB7DQo+ICsgICAgICAgc3RydWN0IGV4eW5vc191ZnMgKnVmcyA9IHVmc2hjZF9nZXRf
dmFyaWFudChoYmEpOw0KPiArICAgICAgIHUzMiBzdGF0dXM7DQo+ICsgICAgICAgdW5zaWduZWQg
bG9uZyBmbGFnczsNCj4gKw0KPiArICAgICAgIGlmICghaGJhLT5wcml2KSByZXR1cm4gSVJRX0hB
TkRMRUQ7DQo+ICsgICAgICAgc3RhdHVzID0gaGNpX3JlYWRsKHVmcywgVkVORE9SX1NQRUNJRklD
X0lTKTsNCj4gKyAgICAgICBoY2lfd3JpdGVsKHVmcywgc3RhdHVzLCBWRU5ET1JfU1BFQ0lGSUNf
SVMpOw0KPiArICAgICAgIC8qDQo+ICsgICAgICAgICogSWYgaG9zdCBkb2Vzbid0IGd1YXJhbnRl
ZSBpbnRlZ3JpdHkgb2YgVVRQIHRyYW5zbWlzc2lvbiwNCj4gKyAgICAgICAgKiBpdCBuZWVkcyB0
byBiZSByZXNldCBpbW1lZGlhdGVseSB0byBtYWtlIGl0IHVuYWJsZSB0bw0KPiArICAgICAgICAq
IHByb2NlZWQgcmVxdWVzdHMuIEJlY2F1c2Ugdy9vIHRoaXMsIGlmIFVUUCBmdW5jdGlvbnMNCj4g
KyAgICAgICAgKiBpbiBob3N0IGRvZXNuJ3Qgd29yayBwcm9wZXJseSBmb3Igc3VjaCBzeXN0ZW0g
cG93ZXIgbWFyZ2lucywNCj4gKyAgICAgICAgKiBEQVRBIElOIGZyb20gYnJva2VuIGRldmljZXMg
b3Igd2hhdGV2ZXIgaW4gdGhlIHJlYWwgd29ybGQsDQo+ICsgICAgICAgICogc29tZSB1bmV4cGVj
dGVkIGV2ZW50cyBjb3VsZCBoYXBwZW4sIHN1Y2ggYXMgdHJhbnNmZXJyaW5nDQo+ICsgICAgICAg
ICogYSBicm9rZW4gREFUQSBJTiB0byBhIGRldmljZS4gSXQgY291bGQgYmUgdmFyaW91cyB0eXBl
cyBvZg0KPiArICAgICAgICAqIHByb2JsZW1zIG9uIHRoZSBsZXZlbCBvZiBmaWxlIHN5c3RlbS4g
SW4gdGhpcyBjYXNlLCBJIHRoaW5rDQo+ICsgICAgICAgICogYmxvY2tpbmcgdGhlIGhvc3QncyBm
dW5jdGlvbmFsaXR5IGlzIHRoZSBiZXN0IHN0cmF0ZWd5Lg0KPiArICAgICAgICAqIFBlcmhhcHMs
IGlmIGl0cyByb290IGNhdXNlIGlzIHRlbXBvcmFyeSwgc3lzdGVtIGNvdWxkIHJlY292ZXIuDQo+
ICsgICAgICAgICovDQo+ICsgICAgICAgaWYgKHN0YXR1cyAmIFJYX1VQSVVfSElUX0VSUk9SKSB7
DQo+ICsgICAgICAgICAgICAgICBwcl9lcnIoIiVzOiBzdGF0dXM6IDB4JTA4eFxuIiwgX19mdW5j
X18sIHN0YXR1cyk7DQo+ICsgICAgICAgICAgICAgICBoYmEtPmZvcmNlX3Jlc2V0ID0gdHJ1ZTsN
Cj4gKyAgICAgICAgICAgICAgIGhiYS0+Zm9yY2VfcmVxdWV1ZSA9IHRydWU7DQpJZiBmb3JjZV9y
ZXNldCBpcyB0cnVlLCBpc24ndCBmb3JjZV9yZXF1ZXVlIHJlZHVuZGFudD8NCg0KVGhhbmtzLA0K
QXZyaQ0KDQo+ICsgICAgICAgICAgICAgICBzY3NpX3NjaGVkdWxlX2VoKGhiYS0+aG9zdCk7DQo+
ICsgICAgICAgICAgICAgICBzcGluX3VubG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0+aG9zdF9s
b2NrLCBmbGFncyk7DQo+ICsgICAgICAgICAgICAgICByZXR1cm4gSVJRX0hBTkRMRUQ7DQo+ICsg
ICAgICAgfQ0KPiArICAgICAgIHJldHVybiBJUlFfTk9ORTsNCj4gK30NCj4gKw0KPiAgc3RhdGlj
IHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3BzIHVmc19oYmFfZXh5bm9zX29wcyA9IHsNCj4gICAg
ICAgICAubmFtZSAgICAgICAgICAgICAgICAgICAgICAgICAgID0gImV4eW5vc191ZnMiLA0KPiAg
ICAgICAgIC5pbml0ICAgICAgICAgICAgICAgICAgICAgICAgICAgPSBleHlub3NfdWZzX2luaXQs
DQo+IEBAIC0xMjA5LDYgKzEyNjgsNyBAQCBzdGF0aWMgc3RydWN0IHVmc19oYmFfdmFyaWFudF9v
cHMNCj4gdWZzX2hiYV9leHlub3Nfb3BzID0gew0KPiAgICAgICAgIC5oaWJlcm44X25vdGlmeSAg
ICAgICAgICAgICAgICAgPSBleHlub3NfdWZzX2hpYmVybjhfbm90aWZ5LA0KPiAgICAgICAgIC5z
dXNwZW5kICAgICAgICAgICAgICAgICAgICAgICAgPSBleHlub3NfdWZzX3N1c3BlbmQsDQo+ICAg
ICAgICAgLnJlc3VtZSAgICAgICAgICAgICAgICAgICAgICAgICA9IGV4eW5vc191ZnNfcmVzdW1l
LA0KPiArICAgICAgIC5pbnRyICAgICAgICAgICAgICAgICAgICAgICAgICAgPSBleHlub3NfdWZz
X2lzciwNCj4gIH07DQo+IA0KPiAgc3RhdGljIGludCBleHlub3NfdWZzX3Byb2JlKHN0cnVjdCBw
bGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+IC0tDQo+IDIuNy40DQoNCg==
