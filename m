Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5074C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 02:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbiDGCiI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 22:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiDGCiF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 22:38:05 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F48929829
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 19:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649298964; x=1680834964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=O3MzDL/z9dtkIwKlqaLUuZx/52YZJd8vVMlM4PFhGLA=;
  b=PTSVhmrR400/e6Zdzu7hBv7lhgg0KXq2ktNuASIPMFxWP5xIKItYkA8q
   NtpZp0gdeIQ0VS0+Q65heWd+kD25FhmWyHGIKZFURsnPQEUOU3mPtuE6T
   kZBuEC85E4lvQVLcJw0wNYVzcnjHIOSJRj9UlsRkW9Y6nPKum/9he36AN
   8an9/7ril1waV1VbV/y0nebotrGIKjl4dGpuDM5A7+Df1NlDGjZ+YgMmR
   yRp+uJvJc2REp1O3Ca8lNdCc8iYEgUj8GqKsYJMa89m2hfXU1D+T0ZnvM
   PqjiMxg+aeUVgB1J5tpNE9jR5XMxSugQbQrpB0kE9jliUJIWOnH6S5hNq
   A==;
X-IronPort-AV: E=Sophos;i="5.90,241,1643644800"; 
   d="scan'208";a="197307081"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 07 Apr 2022 10:36:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G50LTkINRfGJMJyLaGmxZIOJ4/PuwYfI3VQXRYeAjQvd+CpoVitZWqnO42VcfZT0ptRbSpQVarM+4Og84KUoPqlX0P3F3dnLIHhYYkdePF+1KZOH0AqD+zgZj4yke4Kz13wG3z1bv0dyuvVhZAIaLaimhb22gs7blL/hGO1k2TaYt8JES2SufIUjgHg5tQy00U9M9BhV0X8MlngOhILDag89/iWYRbb79PKgD2FWc91xgxbbhgYT5agfjrNmVyQ+HZQM/TeMqv6ksfpXyAZ0sd1B4hGY9lYHvumGrTwwVbmpzGMMpQN58H44KWe/d4Gaeru/o9AMGYB8k75X8cbgiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3MzDL/z9dtkIwKlqaLUuZx/52YZJd8vVMlM4PFhGLA=;
 b=mMy4ex1FLTcTyGrQv93Twldl2h4VkpYVhmREhL+Gs1S8zSz2l+XnuORGkBkQJQMttKDDnfMMWm9p5l0ytPFhzKFSXZJCKX1mEqcbxT81pNOj25CASW3ZGgIx8y/EKObbz2QFcQiLQcR1kGtmWcDIZAm3ZhbrQjQjL6w2nHcLRR57kKNoc5QNj7Ib7ad0ZXzFV/3gXWjqvqcvYfqOJXYhkyEeqXyPcUuPTvzS/PN3fkAUkOwqPdWBCNOIAqQnTqqGa4GzcECOxjibvv9i4IAy68QaeUPhvAhwkVRa9yn1Urtfk2v+6mCX3a1KnblD2D5LhiQA9iG13G9SrvqccG31vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3MzDL/z9dtkIwKlqaLUuZx/52YZJd8vVMlM4PFhGLA=;
 b=oV1GccqWeA6kW+HRKSVW2P7Zq+daO6Rd0+FZ14x3Bvjl4B8mB6hKnkpzenmEmc3jh/Fr/Vu+UiDwT01oGkQA4e685n/BEjt6AsJk6eV7E0ju2fY4yxo1n5vLabgTiEl4V7rU1dMkAZmEsATnGkHQaRHb3JJYzycQXFe1bxyxSkg=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by BL0PR04MB6562.namprd04.prod.outlook.com (2603:10b6:208:1c6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 02:36:03 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::4b6:fefc:2474:bdd0]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::4b6:fefc:2474:bdd0%4]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 02:36:03 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 12/14] scsi: sd: sd_read_cpr() requires VPD pages
Thread-Topic: [PATCH 12/14] scsi: sd: sd_read_cpr() requires VPD pages
Thread-Index: AQHYLfd9I2WMHWchR0iihFVe5OI2Bqyr6QaAgDZmqoCAAaBI+IAABImA
Date:   Thu, 7 Apr 2022 02:36:02 +0000
Message-ID: <42f5ffa7055f4207490a184f39336d5174581167.camel@wdc.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
         <20220302053559.32147-13-martin.petersen@oracle.com>
         <fa37071c-3e68-9435-5f8b-6f3920e59ae1@wdc.com>
         <45050814-f512-f764-007f-5fe52e224467@opensource.wdc.com>
         <yq1v8vlljrf.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1v8vlljrf.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ac9ae75-9efa-4e09-c430-08da183f5c02
x-ms-traffictypediagnostic: BL0PR04MB6562:EE_
x-microsoft-antispam-prvs: <BL0PR04MB6562A349033891C70BFBA54AE7E69@BL0PR04MB6562.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HZqxW19gMXOMU38BX4703rgiC+wZZNE1g9FIlvJdmADBV0EeN8iWOPbuu7uGCXaUVWsm7fE8KO4yUtvKYcce5xYEL3Pkp4OOd4TEqAiIDmd0X9WTF2mBoBq+CnHX+I5qGO9LGqY0AGYJ+0KFbjfi2Sd88kXmzCMh5oqDV6Zqu6U0qss4pRxcrqRouasKvo9apNiE2GLQ2JO3vrqNKPHUcz4/7hra/WKcqdvZJTWcr/TeEvfHM/hQI/Zt1SW2FTlqTkiKRCuRXveqbGD24bqWCrte1KqkbS82kb3tPu+41YRlt+XXwZQA5v1w3mOn/QmzgYpzG9bdEQ9xE+QCKQW8L0obL4Psg9PlZDsTH94PEh9KrQBS5u75fCM6n4IXeUfT6ZCWEIurF3V/WRaA72TVHjnPZ8m9Lh3RAkP5pPoIOxIERnSvP3xov9bZ+zFz9IcglhGoygJBfJLPr0mPh9Y8rfzhyBN3CMa06gJD2lSqF+OW9bnDvzEAtS2qIjVyFA+D8FofbwbU7nt2PUOelIs9dzgq6V+W8OWxID/yPbL0wDRo9mCrwzF/h6OqWz3JtlZrFW6d5ygUZvtVgncOJ1nigXcIjWlVH8f3UbogGfN7nRC9PUHKkIcbtxvr5L2z7Y0V+8D2D8CNE/PjNwGABbmnqIc7KRbkCtITNmWoSyPdKfudVp77bGI+0WLjRuqLPhg/gy1CwkMISMM+Fr1nUFqB3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(66946007)(66446008)(64756008)(122000001)(36756003)(91956017)(4326008)(76116006)(38100700002)(6512007)(2616005)(26005)(186003)(66476007)(66556008)(82960400001)(8936002)(86362001)(5660300002)(110136005)(4744005)(508600001)(38070700005)(6506007)(71200400001)(2906002)(6486002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1VBVC90dCtEOG42RUQvSXlSazVDTUl0ckZ0dkdRa3Jiem14c3B4K1MzS0JF?=
 =?utf-8?B?UGZpUGlZM09LOUVBVDlOZDZyTitIUWZ4TXFZclBMaFNtMWM3VENUbGNKaWdD?=
 =?utf-8?B?ZVA0SmFGUmtCTzlzZG13U00zN2VjdmJWUjlHMXRnTklCaHJkL3ZrR3Rwc29R?=
 =?utf-8?B?Mm9EY3VFTEpqNlhHdE5FUE9pcXc5RVBjcFcrcGhLbVZtdVE5RE9McG5VNGFw?=
 =?utf-8?B?SWVGeTYzNCtlRmJtWVA2UlZpTXpmZ1B6dUM4N013WTB1d0FPTDhweWczVHdu?=
 =?utf-8?B?ZDNpdFpVS01BbXBiaFROR0VDU3pEYW1YRTRrT1ZuWGZaeUlYWFNNZzJMalFH?=
 =?utf-8?B?THVQRnhKMC9vYTg5NkFONEszcWxvM1NDYjB4bHFIbkNLczhob2UvQUJJMFdU?=
 =?utf-8?B?dVlnREdHYmJjMm5tRWg2R3NwZTZKLys4ODh6SFBCWFN3VHpKdDZQS0x0cURp?=
 =?utf-8?B?clZvWjFHOG9sUlZBWERjWmxCRXhYV0tHbzdCYWtYejlsWUl3N05tK25Jci9m?=
 =?utf-8?B?Q0l2ZG5FaG5XaXhEYWYzOXBvQ1cyMDZkVVhWNVZRT2ptUWt1ZUpIWm5qOTY4?=
 =?utf-8?B?bkthT1V4aUJsbjJrZzFWYUJBdnNwai9RUkN3akJubFVmUTV4amV0R2gzcFNm?=
 =?utf-8?B?WFZERWxUWEMwbjNkZjNsNDNVUVFXcWl1cGk1OWZGem9WZEVrb1E5TDQyVVJT?=
 =?utf-8?B?dlJpTXNlWC93OUd6YkUrMDM5OFZnaHhSb1ZLWE4wcVhaMjBSeVpnTWFiZXdn?=
 =?utf-8?B?V3VCTXY5OGpqSzU5a3FOTG1ZV1FIVXowNEZiMWRPeCtJWFh5T01PZWhHeUkz?=
 =?utf-8?B?SjFUNFZXUHppU1NSeU1TdE5rTW9aVXE0RXpUNkp6WlpGUXRhQ0xPN0JVeFJp?=
 =?utf-8?B?bGgvWkZNQS9udDlnN0dNdldsNGhZWUM2VVNXL3hwZG11Q2tnU01JaURUTzdm?=
 =?utf-8?B?ZmxMbGlteklEeC9Na016UHNMdWVXaUdPY2Z0bUtRTEFrZTNVVzVUaHlJVytD?=
 =?utf-8?B?UkYzQTVMYWpkQk9SSzlXQi9RZkVhVE1lWkdiZkxpQjNwYm94K3cyQ0pVNTdO?=
 =?utf-8?B?UUYzVUNJSGNCaitKb3lNdGs3ZWk3V0pjT0p6OFA4ZFRoWXBlQUZCdEhkRjRO?=
 =?utf-8?B?ZHE5OVFQeTNqSURpWXJPMXlrZFFmSERuN1ZOUWRXQ2ZxZ0gyMVEwSXVlYTRw?=
 =?utf-8?B?VkQrOFZuSjA3ZmpMRHVYaWxhYUo4aDlMamwwSm42SzVLT2UvRTg4SWdxdnR1?=
 =?utf-8?B?YnhudnRwNVlOSVZUclFuMlFka2RPQ2lMSUxDdlV1ZUZ5UkdrWGp0ODE0SWph?=
 =?utf-8?B?VDYrbHBiQVkwRDdwWmJJSnIrR3FqcjNGRC9oVFA5WU1lblhhUVhRbk50K1Yw?=
 =?utf-8?B?MUd6a1BROUtaWGxDZzFBcFIwZ1BSOXdjdEZXeUQ5TkduRENJV29EdmUwSDJO?=
 =?utf-8?B?ZC9yc1FLMUNodUhzNjlvTHRoYTFOWjkyd3YwVUF0cjB5UGtjQitGUWdpKzFw?=
 =?utf-8?B?d2FFUXJvdG9jMTZmb2dGa2ltSlBEb1poUlpuaFZ3Z0UzUXR4bXdmeThqam0y?=
 =?utf-8?B?ZlhDT3ZMa2h2djRaaEZLNTQvdVByelZ5WWRzOHdhNUZRc1BFYlo2VHhpYThS?=
 =?utf-8?B?U1drN2J0Y1NwS2VQNlFySzhyWUNzZjdiSk5KdHphd0lPeUhqL05aUlhyK1Fz?=
 =?utf-8?B?YkZwRnFLdStzNml0Sll5QkxyWGZnZ3V6WTgrYlBzbnpxZUZIUWxsTGsxT0tZ?=
 =?utf-8?B?anFpZTFxQ3lzOVhEaitnV2lPYm9iNVA3bXlKbWsxb0NCejZCREFhUGpwTUhl?=
 =?utf-8?B?NEhoN01OSW1FRkVtZExqS0dlSDVPSlZwT1BMRHl6NmRZdHRUWTdJS2JyQ3ZH?=
 =?utf-8?B?MDVET3B2anMzUkIwWjhLTW56R2dmOGpJNEUyKzdaTUI1Unl3MjhjTWpvWWZy?=
 =?utf-8?B?b2lLU2xMMWMrQ2d6Sm8rbUlRWDc0Wk9NcTcwZGlvUkNhTGQ3Uk9sVW1kVzky?=
 =?utf-8?B?aXpjbEgzeUR6c2FydWtPbTdzRlQrOUNTb1JndW5yZmhjYWw4Qm4zOWVLN1Nr?=
 =?utf-8?B?dTc0bTZuRkxhTExJKzNCVzd4OU9tOFl3VkNzRzYzbHQ2TkpEZmNSU1o2OVpB?=
 =?utf-8?B?MGJ1TVVZeVczOFI4SUpVSEFDMFo4YzRRZkFkbnppRmVpYmg2WC82dGNZZkNM?=
 =?utf-8?B?MXo0SElNaDBxc2dya3F1dDNabUdCS29HQ01oWmxtWkhPYmNXeUIxN20vUlZU?=
 =?utf-8?B?S21xRzIzOUdPYVVzREhHRithSHBpM3ZKWGRCVDB2aWtvUTg2dWY4K0o3dGxU?=
 =?utf-8?B?dDkySjg3NUFTN2QzMlBxbHN3SEJrYTM0Yk1NM0NoUGhIR2lYdm1JSkpGZmZY?=
 =?utf-8?Q?kPZxdvQNyBM8IlY0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E6CDCF291E8654E866EE0455637BA94@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac9ae75-9efa-4e09-c430-08da183f5c02
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 02:36:03.0631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kZV4lt+iINT8x4h+9AdZM3KYLNL2hGcos5Uq2vdVD9tL098hpSiihp5qsP1Lsc8KWapNp6QbBfX6gx0+azhzew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6562
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIyLTA0LTA2IGF0IDIyOjE5IC0wNDAwLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3Jv
dGU6DQo+IERhbWllbiwNCj4gDQo+ID4gSSBzdGlsbCBkbyBub3Qgc2VlIHRoaXMgcGF0Y2ggaW4g
NS4xOC1yYzEuLi4gRGlkIGl0IGZlbGwgdGhyb3VnaCB0aGUNCj4gPiBjcmFja3MgPyBJdCBhbHNv
IG5lZWRzIGNjIHN0YWJsZS4uLg0KPiANCj4gSXQgd2FzIHBhcnQgb2YgbXkgZGlzY292ZXJ5IHNl
cmllcyB3aGljaCBJIGVuZGVkIHVwIGhvbGRpbmcgYmFjayBmcm9tDQo+IDUuMTggZHVlIHRvIGEg
cmVncmVzc2lvbi4gQnV0IEknbGwgYXBwbHkgdGhpcyBwYXJ0aWN1bGFyIGZpeC4NCg0KVGhhbmtz
Lg0KDQpVbmZvcnR1bmF0ZWx5LCB0aGUgcGF0Y2ggZGlkIG5vdCBoZWxwIHdpdGggdGhhdCBBcmVj
YSBSQUlEIGNvbnRyb2xsZXINCnByb2JsZW0uIEl0IGxvb2tzIGxpa2UgdGhlIEhCQSBpcyBjcmFz
aGluZyB3aGVuIHRoZSBWUEQgcGFnZSAweGI5IGNvbW1hbmQNCmlzIGluIHRoZSBkaXNjb3Zlcnku
IE5vIGlzc3VlcyB3aGVuIG1hbnVhbGx5IGRvaW5nIGEgc2dfdnBkIG9mIHRoYXQgcGFnZSwNCndo
aWNoIGZhaWxzIGFzIHRoZSBSQUlEIHZvbHVtZSBkb2VzIG5vdCBzdXBwb3J0IGl0LiBJIGFtIHRl
bXB0ZWQgaW4NCnB1dHRpbmcgdGhpcyBwcm9ibGVtIG9uIGEgYnVnZ3kgYWRhcHRlciBGVy4uLiBB
bnkgb3RoZXIgaWRlYSB3aGF0IGNvdWxkIGJlDQp3cm9uZyA/DQoNCg0KLS0gDQpEYW1pZW4gTGUg
TW9hbA0KV2VzdGVybiBEaWdpdGFsIFJlc2VhcmNoDQoNCg==
