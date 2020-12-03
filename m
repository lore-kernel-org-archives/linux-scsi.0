Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBCEC64E8A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 10:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 746B8208A9
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 10:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388608AbgLCKrN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 05:47:13 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:56684 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387772AbgLCKrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 05:47:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606992431; x=1638528431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6ZmaV4epz1RzZwXxMUasO/UgWif+qh0KquY+310K4a8=;
  b=lmby9gfhpPTItuK+V4+WEV8Sz6QI4lyzUYdc5oN/O1VrX6g4p5sCPiLs
   VcavgPYkixmIz5DVeYo/vM0vAZzEaVLijY70jQINsl8+zAAr20tM2OCUI
   +QQOGtndz3uWNR+JitXaXLgUsweBwop1yr/feNhCgvdc6/7v68j/wO7/S
   Fbfhs0mEM/7Hlt0RZZ8BMKHHRl+CuTxH8peIV/gaGGp0iN7/KGnEAwKFY
   bWdE9ADN41WHRJiqBYIcoGHp5ARZmIK3+GgzovUdXbuR4Pbtkg0MzwqF7
   //ej6+wqoHQwQbUPa5/0fjA+3jktYPeiOuETh1Sit9LZHL0iTAHwrKWrK
   Q==;
IronPort-SDR: iZM7qflkQqDeJlCTqo0jzlj7zVsuhzmtlU0raGT9rR+KTyMCnjZ2NqYxSvzXHOjiKsRVUYmn45
 BVIxQ8F2NPZQ06V289OWFQ58isnhevSAhmCq0BkgubzMeJZokaTm8x+q7MJvyVA2UOcHPlYRk6
 yZqppdOaDQPr0LLCaeV7pXMOFcXW8YQ0uNC77BG0w74tiRXR5m0UlExSleiS8MKbYakKp+X6Qy
 C+8ZcY0CFN0NBXiW9NxTtJru+EI4hW5EADmE5KXaIJCYa+X4ApWCAqypf2CSz3dF6zo9NhZVwA
 UKw=
X-IronPort-AV: E=Sophos;i="5.78,389,1599494400"; 
   d="scan'208";a="154195537"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2020 18:46:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xo9jqq3cg9M0tNs8zqUoixZHXmja2y9cYcUAmM42MB4TBHDABeZ0Ww/cbUhEkgthZ7bqZcjFqJeu5eg9ze//39TBX7lDVTegrpSRTxWN+XhXCQLcDtuH4P/gI3KVfJ3qS9BGlvl+P2CwIPJmRa6qJVA+mqZYpZmDgjotXAnXBVLdEMqdyG8BnXOFFdBha5kp2fYKF8ojH+ITQ718lXLrp0Gwt7xoLi1V8tHqhvtCHSswr5L9ET48CPzIchnl5Z5Uy5Ps/vytgFdDFn+oj3hiRFLzTNjzU98nfhdI+KJS8q+bw8iuljGt0jB0YoyNrMjZMxWjj+N9FI/Yv/QLiEEJZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZmaV4epz1RzZwXxMUasO/UgWif+qh0KquY+310K4a8=;
 b=P5rqZV1WIf8VBG5d/5vzD9eosgZO7Wc9x80p/qTHIqeABIrhrneTTbQ1OdiHRBMJMFVUCBMxElzHT9KK/XNjdc3N8AUJPdqbZpC6g0kk9Eei6BwhaI0N8pnylNYJmO+9DC3zYwOY/Nrh1/u0AoPzTl/qwdaev5h3/C9IGHCas9WYOclWg3SBxRIoj57y984bKMIsvtglFDozAkosZ+dBCRP7gzAIvoqla1wnUo4JVesdDp8eRAzXRprwIQ0CA9B77ynEak4255py7LONq3eHkrXXYEStrMxW70MCuGMxwhFz5a06rFur3SBynMYrhklbffiUd7H2hKMmJs5JmxWzyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZmaV4epz1RzZwXxMUasO/UgWif+qh0KquY+310K4a8=;
 b=EHI3xFgik9Dm+xxyMfHEvvIQYoXxaKU5z3RH+d7FwElFbuq7jRL04Q88XejagdXtejjJTrgsIiojbWs7eIPkjYSuUNRqxcpRMDqOdq2pWi91qJcDf2psiBcYXlyOAww93KVLM0+DmEsKSimcrm1Escp0RCXAAx8OXSZv5LGVS0E=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR0401MB3653.namprd04.prod.outlook.com (2603:10b6:4:7b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.22; Thu, 3 Dec 2020 10:46:02 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.019; Thu, 3 Dec 2020
 10:46:02 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Topic: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Index: AQHWx0S43WodiAJh60uyT+kBS7g50qnkYW5wgACaOBCAACZ9AIAADIOg
Date:   Thu, 3 Dec 2020 10:46:02 +0000
Message-ID: <DM6PR04MB657551290696C7EBD8339328FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201130181143.5739-1-huobean@gmail.com>
         <20201130181143.5739-3-huobean@gmail.com>
         <BY5PR04MB6599826730BD3FB0E547E60587F30@BY5PR04MB6599.namprd04.prod.outlook.com>
         <DM6PR04MB6575B7ECCEA7335B2CFC2AC4FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
 <2dafb87ff450776c0406311bb7e235e9816f6ecf.camel@gmail.com>
In-Reply-To: <2dafb87ff450776c0406311bb7e235e9816f6ecf.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0bd89780-0e6e-4294-de8e-08d89778a0d0
x-ms-traffictypediagnostic: DM5PR0401MB3653:
x-microsoft-antispam-prvs: <DM5PR0401MB36536F74AFAE20A00E8B2D03FCF20@DM5PR0401MB3653.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: frWKcICF+XCpYTZu8WfWP6WqK8wZf4ahGi/qRBQStDxVl6zBhSraKzDnJ5IR9+j6Aau5zp4wOH5HquAUPuSM24u1jbyqZ7S6y6GXDYuY+NIMWiRXW7g4QQ1uC5+YzzfOEHHwrUyxY/YspXfOF4B/bzA6X+Vx3gmNPP+L5mOzaMlKVL+21X+mi3sQq5rMFB9I9VDVOvrHs3wWeW9IiEJK98sI9X1D8ExtlHtCYUf82FqEPV9VxT57rcAvFiBMlh7Dazz8Mok168yYRmLdtW9pZDO7YXGCFTEOFeaoEv5VrIi7N08+DzhkKx5cUxn75Tnm0UJapPhq0mXsqriNbGc3tuFe6ImO5P4MzuEsyL1WPTeKsU40ceNAtjRw7RBj52GoxWOTtn9D38RSiRT8c0+Ly5CPYT5WBOEMhlDW/7ONLjM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(71200400001)(7696005)(33656002)(8936002)(7416002)(9686003)(55016002)(86362001)(8676002)(2906002)(921005)(52536014)(6506007)(64756008)(66556008)(66476007)(66446008)(66946007)(110136005)(83380400001)(76116006)(316002)(186003)(54906003)(5660300002)(4326008)(478600001)(26005)(145543001)(213903007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TVE5RHk5ZDZhTFRPTTlEaDlFTWt2ZGdlUit4VThPQm5XMkM3U1FuZEZ1dDdl?=
 =?utf-8?B?TXlZZUZ1amVlU2s0OW1SUXF6RHVtUmJ6WTVUbWFEd3J4ZmRXdGUvNG1MWTJi?=
 =?utf-8?B?Wmd0NVhaU1g5OHVRQTdlT29tTWEzNkhzMTJNb1Q0SUVGYVN6a3ByY1BRSTEv?=
 =?utf-8?B?OUUvQ2NrSGxyWmpWbWgxOHZJNGRWdnd6c0R2UUVtRnVWRGFOQXpzS0Rlc040?=
 =?utf-8?B?RWdZQ3doVXlLY2lyRUhSMm1NTElSa2o3Z3diUDViRTdGN0xGalJxek5rLzZC?=
 =?utf-8?B?U2wvWVdnTkhpVUZWZEp0MEpzUVB1c3ptU2FXZkV5WS9UZTNWWXlHQXNsd21M?=
 =?utf-8?B?bnRpc0VOVVlZZ2FxM1ZUcklPbk5ya1p2Z1VoRVZaY3dvMndDQk9pL0VLcG00?=
 =?utf-8?B?SUhkNlBwcStWL0JpNXl1VzU3ZG5zL0RWWFJwRlNFUkpLY1BGaVU1clpvOUsy?=
 =?utf-8?B?K1lnVklCUEE2Y3JPa2xkMEdra2pobDhEQ0dORmduQ2oyNjVZcTlJdXBTUVBU?=
 =?utf-8?B?NmhEZmc2emRNTVZ5SFljdFZZbE1sd3owRzVOVEJNZldHaFUzM0ZudzlIR013?=
 =?utf-8?B?c0VvT0pxOEtGMHU1ZndTMkgzY1BVZEkvNzd2WGQ4eENzN3Y4K2MxOTZzeDJ3?=
 =?utf-8?B?Tmd5SnVEcUhlMkgzNmRTNWIybXBrQkgydUJaZzRxcXVhRVVwWmRkZkh1QnB2?=
 =?utf-8?B?a1RqTVNrTkVrdkpTZnljSXJ5WlJLUzVjZTJVNUcyTHpvTThUWStWaFJIeERv?=
 =?utf-8?B?cDJoS3BNWTJyNDRqOVhtM2M4TkFtU01oWHptYVU5U3pFMUZ0ZnBPaUpJMlZO?=
 =?utf-8?B?emlUcXk5ejB1TDlCR0RaYU5NUU52SWJoWkRhZ0tSOGE1R1hZamo4VXNyWi9x?=
 =?utf-8?B?aHFzZHNZbXhDS3RXWWlzd1JnL0NlQXRQRFZOZi9EQW9XOFVyZ3JJbXRrM0dr?=
 =?utf-8?B?cVExR09oa0puaTVhVmJtR2wrVEl1QjNwOCtRTnhoVzBqWTZpdUFxb2VzK1l1?=
 =?utf-8?B?YWNyU3F1alo0Z3B1R21ZblVENnpTNU9BOCs0dDJsMVcxYjc0OEk3RVZlS2pk?=
 =?utf-8?B?Z0Q2cE1MS2pvSEN6cEVLYUN5dGxtWWJlbC9iWWI5MFJiQjNRck9pRXJEeURs?=
 =?utf-8?B?UVYvT0pMdTI0c0w3Y2xLNW5WR2xGR21jVXlvWC9mUko1T0ROMFFvbkN4azd4?=
 =?utf-8?B?NlViL2NtZUVIQ1RuZURFblVmSzl1WW50V3k5cmpPZHZlbU94clZ6Rmw1aGsr?=
 =?utf-8?B?akY5Z3lDdy9NUEVaWW91MzZZdzE3ZUFGQlJtcm5Fai83U1ZwSGN1aE9hcTVL?=
 =?utf-8?Q?xkgXyJrUbLPhk=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd89780-0e6e-4294-de8e-08d89778a0d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 10:46:02.1643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Im99FkGuCaZ37RnO2mbtYe1Bv2AWZnwqZxuiQGyFBYWlPJqtTdp4GE5pLdpGh40squlnKBGjObP+uAH9n26ABw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3653
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gVGh1LCAyMDIwLTEyLTAzIGF0IDA3OjI3ICswMDAwLCBBdnJpIEFsdG1hbiB3cm90
ZToNCj4gPiA+DQo+ID4gPiBGcm9tOiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KPiA+
ID4NCj4gPiA+IEtlZXAgZGV2aWNlIHBvd2VyIG1vZGUgYXMgYWN0aXZlIHBvd2VyIG1vZGUgYW5k
IFZDQyBzdXBwbHkgb25seSBpZg0KPiA+ID4gZldyaXRlQm9vc3RlckJ1ZmZlckZsdXNoRHVyaW5n
SGliZXJuYXRlIHNldHRpbmcgMSBpcyBzdWNjZXNzZnVsLg0KPiANCj4gSGkgQXZyaQ0KPiBUaGFu
a3Mgc28gbXVjaCB0YWtpbmcgdGltZSByZWlldy4NCj4gDQo+ID4gV2h5IHdvdWxkIGl0IGZhaWw/
DQo+IA0KPiBEdXJpbmcgdGhlIHJlbGlhYmlsaXR5IHRlc3RpbmcgaW4gaGFyc2ggZW52aXJvbm1l
bnRzLCBzdWNoIGFzOg0KPiBFTVMgdGVzdGluZywgaW4gdGhlIGhpZ2gvbG93LXRlbXBlcmF0dXJl
IGVudmlyb25tZW50LiBUaGUgc3lzdGVtIHdvdWxkDQo+IHJlYm9vdCBpdHNlbGYsIHRoZXJlIHdp
bGwgYmUgcHJvZ3JhbW1pbmcgZmFpbHVyZSB2ZXJ5IGxpa2VseS4NCj4gSWYgd2UgYXNzdW1lIGZh
aWx1cmUgd2lsbCBuZXZlciBoaXQsIHdoeSB3ZSBjYXB0dXJlIGl0cyByZXN1bHQNCj4gZm9sbG93
aW5nIHdpdGggZGV2X2VycigpLiBJZiB5b3Uga2VlcCB1c2luZyB5b3VyIHBob25lIGluIGEgaGFy
c2gNCj4gZW52aXJvbm1lbnQsIHlvdSB3aWxsIHNlZSB0aGlzIHByaW50IG1lc3NhZ2UuDQo+IA0K
PiBPZiBjb3Vyc2UsIGluIGEgbm9ybWFsIGVudmlyb25tZW50LCB0aGUgY2hhbmNlIG9mIGZhaWx1
cmUgbGlrZXMgeW91IHRvDQo+IHdpbiBhIGxvdHRlcnksIGJ1dCB0aGUgcG9zc2liaWxpdHkgc3Rp
bGwgZXhpc3RzLg0KRXhhY3RseS4NCkhlbmNlIHdlIG5lZWQtbm90IGFueSBleHRyYSBsb2dpYyBw
cm90ZWN0aW5nIGRldmljZSBtYW5hZ2VtZW50IGNvbW1hbmQgZmFpbHVyZXMuDQoNCmlmIHJlYWRp
bmcgdGhlIGNvbmZpZ3VyYXRpb24gcGFzcyBjb3JyZWN0bHksIGFuZCBVRlNIQ0RfQ0FQX1dCX0VO
IGlzIHNldCwNCm9uZSBzaG91bGQgZXhwZWN0IHRoYXQgYW55IG90aGVyIGZ1bmN0aW9uYWxpdHkg
d291bGQgd29yay4NCg0KT3RoZXJ3aXNlLCBhbnkgbm9uLXN0YW5kYXJkIGJlaGF2aW9yIHNob3Vs
ZCBiZSBhZGRlZCB3aXRoIGEgcXVpcmsuDQoNClRoYW5rcywNCkF2cmkNCj4gDQo+IA0KPiA+IFNp
bmNlIFVGU0hDRF9DQVBfV0JfRU4gaXMgdG9nZ2xlZCBvZmYgb24gdWZzaGNkX3diX3Byb2JlIElm
IHRoZQ0KPiA+IGRldmljZSBkb2Vzbid0IHN1cHBvcnQgd2IsDQo+ID4gVGhlIGNoZWNrIHVmc2hj
ZF9pc193Yl9hbGxvd2VkIHNob3VsZCBzdWZmaWNlLCBpc24ndCBpdD8NCj4gPg0KPiANCj4gTm8s
IFVGU0hDRF9DQVBfV0JfRU4gb25seSB0ZWxscyB1cyBpZiB0aGUgcGxhdGZvcm0gc3VwcG9ydHMg
V0IsDQo+IGRvZXNuJ3QgdGVsbCB1cyBmV3JpdGVCb29zdGVyQnVmZmVyRmx1c2hEdXJpbmdIaWJl
cm5hdGUgc3RhdHVzLg0KPiANCj4gVGhhbmtzLA0KPiBCZWFuDQo+IA0KDQo=
