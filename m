Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75008C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 18:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37F396109D
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 18:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhDOSl7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 14:41:59 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:51611 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbhDOSl6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 14:41:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618512095; x=1650048095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U8CQ6S8HRekLY4YmHAdIn3pyM2yI1zI13K+BEtgwTQk=;
  b=0q9x4cAOSfzysI6Zqpegdn8/hySKEkiXa5Hrv6b7wjjIYlg3BYT1nP4e
   d++fekSvcoh9/IiOoxDeCp6yxNgkETVV67khoGavdzslENK5YT6iNUr4F
   e7rjTz1uxBk3YXrUfR5ZSjX8c69OqXtEj1iI4uT49XNPxIJ96sVfKN380
   CSukrbnMELtc1W5fpxz+cLINmQ6OEDZAKaio5s4KemnLXZy1c7JJCZEVy
   VLTFVREzoQ+D6Z86noJprTLXF9ullTKCpHq0vi0+IxDEEBWfEQkWDV/5c
   zC8IL8+GC9QU89bIBifBN+SHBjSIX+SNZAOuj33QjcumV+Tbgh2rAjK/2
   g==;
IronPort-SDR: 3JK0RJ1/oQ4QHHgrGNLrULe1ZYW1EupfQNLrPQVqrvxtYcXMnP7FkGCbVVIZ667ZwyVqjthKG3
 GEn+jtSQ0hz6aFa1whRHQVvQ5R2quT3hXQ8HmhVqzEOf9MnOjn0G2y3DWi21gtR9LJzjOBd+Hl
 vbrmpMIk+chwA+2E+mfJS6TpyzCXiG+WIMMZLQweQBjUFczn1ARJLIOwC7C0ypMkIwuJdTq22M
 32jpCFiNaaN5GCJWv4FQt8/C7vuB2ualABIMyjvnUd0+xvd1sPanhM2jgVhKbRInylCpQmPAZ2
 wFA=
X-IronPort-AV: E=Sophos;i="5.82,225,1613458800"; 
   d="scan'208";a="117187016"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Apr 2021 11:41:34 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 11:41:33 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Thu, 15 Apr 2021 11:41:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqiWdNXm7jIgURP5ltF3GVf8GgFFKK6h2aW1YWFSrMS0ug2gn6tP6nVahH/FWWVvQtF66x6q3t8qnSsT+apqVYaFZqAjoHoCGQjKzv3vXlek2fulwXes896NJQ9fg6bCQBP7dY8hHrA/xx82NlvH7iFZOjpULKjKvq0x5SS5sgESHQgWNQLYteEvWUNm3ZI7F6Qgq/AoK/B379OS8nRP2qLj1dZ/lLaednxoAwTHPzkk3N4cPy55PGYdJz77XYZSkC2eMRXBsegGhtC9nO5oq/323zZX4RqVz9L79BJi3H/5USgNoFfkXyF4pfTptp2oG6OWybHpGnNRYmzvBFWRiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8CQ6S8HRekLY4YmHAdIn3pyM2yI1zI13K+BEtgwTQk=;
 b=QqbXnM3Lnmpmoi+erzVLgf4EWhKudbJVs3vi/1VTncTeNDvt1bJznMeL0/5JWuOmBXnTjHroQGP3tufUq+X6PwpjHqtjLDIDo3ht7KE8OAc6Y/gzPu8glEoxeuL9eF6NbD003VxHHbGuTDb2Lr4HEUixUQqIUpOh0QNXLje5WdBl8/l0RJj4bBMTdQqP98R7dXWDyqWdyVH/CY7HPPtLdWBHgQ7Fjqi9HXHxwVuKGx71OkyRP1vAe0o6ldUuRVFo0avK0poiv1fYBQnmALtSKbJwasEwetLC2audhjb0wMObi+Xx9tY4qjIFPB7HnzdR4R9RIiKF6tMHgIZJoyXvKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8CQ6S8HRekLY4YmHAdIn3pyM2yI1zI13K+BEtgwTQk=;
 b=FnGcY4/ZbDJGfnN2Ng456BIEJ8uFYcUXMPhjk2MRLrpy/iZymThajOz16C32YYgEO1VEOG3sf2+EcEBaRVvQorkMLiG52MG7Gt9K2K/F9aw0CpAThFLioUc5g8olj09gV+20xde4xL7HaaTZdb+NtboE9lwYBd4gHXJSFywr6jQ=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4812.namprd11.prod.outlook.com (2603:10b6:806:f8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Thu, 15 Apr
 2021 18:41:31 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::a002:6253:12fe:2d2e]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::a002:6253:12fe:2d2e%5]) with mapi id 15.20.4020.024; Thu, 15 Apr 2021
 18:41:30 +0000
From:   <Don.Brace@microchip.com>
To:     <martin.petersen@oracle.com>, <Scott.Teel@microchip.com>,
        <jszczype@redhat.com>, <storagedev@microchip.com>,
        <slyfox@gentoo.org>, <glaubitz@physik.fu-berlin.de>,
        <arnd@kernel.org>, <Scott.Benesh@microchip.com>,
        <thenzl@redhat.com>, <linux-ia64@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] hpsa: use __packed on individual structs, not
 header-wide
Thread-Topic: [PATCH v2 1/3] hpsa: use __packed on individual structs, not
 header-wide
Thread-Index: AQHXJTUyVb5vk6RIu06PwRfUPBgL4aqgnW8AgBVlcaA=
Date:   Thu, 15 Apr 2021 18:41:30 +0000
Message-ID: <SN6PR11MB28482BFEF29365BEF742F146E14D9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <yq1wntpgxxr.fsf@ca-mkp.ca.oracle.com>
 <20210330071958.3788214-1-slyfox@gentoo.org>
 <161733538518.31379.13275738935787597303.b4-ty@oracle.com>
In-Reply-To: <161733538518.31379.13275738935787597303.b4-ty@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a600053-d43f-4cbc-3998-08d9003e1630
x-ms-traffictypediagnostic: SA2PR11MB4812:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB48126EB639E9A4878C7D60B6E14D9@SA2PR11MB4812.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JaIAbbiwCiUXYRgv7ng6PFyhyAgxKQW87G86j57+bxQ/yUeD3/PVoXAIyMeatIVn+UWRdnmNilulH3qvKw8UAOOe2rEqmHUg1u9kyXjn4UlVNXECYkozJC8mlkzwfFL/KK/rJ/9OORVxrY/z1RAC10TEv4WnM9SOtdKrbk0Flt07ZRjy0V19ftDcSuhnqOoAMiUrUlhRwcBeolk4X8O4LnxyQAScJUWGzfw1EWfYG6GW8CPDQpLtOZ6q5X3lwGH9zLZr7j5cNgDapwb3CVX7Vvd5gwvRJrUKYkzzS1sfb10p9uK+uCUaMpYY7WoCXpWW0JSRn/b4uW6N6g7fI5keRqPSPNAibcGJg/rXBw5nqqTpz8/SfMMfI7c4aGWo0/BqH+AFTAgkyuI8DbKfdFhxkkX3W6oTkrHIWUSQ+M/cV53ziD5Vr5v20Dcb2xjVEyoTALhpMBpWKPffUyfbggX9QasGvorNeGCwkpTAXwOfOIGZO8wFin8YVFoqC+kdXeIkRRjvJmnpYXqonSkidHgnt1oMukVk1CeVSW3ZsEpGa6fRC1RU/jyai1W50H4ORzKXueP+jctM6elImOU5AC4zL60aLzpT4fTZ7lc81lfeE9i1eb/4Fl7JYYKF9/uIgXqGZRIt0nfdw/odubf7gnbMRIv5UImPpLjRL0EnuKQyToiCUSF0t6s4oCvtLiW68niXo9ulQ0CssfWnH2z3xJVKXVOGHy3UXZupcvbWfenN1u4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(136003)(346002)(376002)(71200400001)(921005)(33656002)(2906002)(186003)(316002)(26005)(38100700002)(4326008)(9686003)(83380400001)(55016002)(122000001)(52536014)(6506007)(4744005)(66946007)(66446008)(66556008)(66476007)(64756008)(966005)(478600001)(86362001)(8676002)(5660300002)(110136005)(7696005)(76116006)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NEd1OHVqM1dKc2psU2FEcUlRNWxwS3RuZjhKdCtrMWtpOTVLNnhrUk5DNm1z?=
 =?utf-8?B?OWNnRjRRai90RkZpeFJyam5TeFZRQkJsWTJwVFlXblc2ZHM2ZjFTeTBKTTVo?=
 =?utf-8?B?SU8zSmdLNit1V2NNc0NXU3Vlb2QwamJYcGw4dTA4RUFueUp2UUNpWGExeE8v?=
 =?utf-8?B?VHJ6MlZiRkMvRkpGd1p1SDNFWWNRd29jc1BKWWRSZ3dlS3g1S0EvdFVQY2Mz?=
 =?utf-8?B?T1FsMEdQKzZzd3dWN2FJdVR6SFVxWlRKeEFtcUJrZ2R0V25EcUIrU0h0ZFk2?=
 =?utf-8?B?Ym8rVm1uVGhNRTY1V1VqTHdNSGxnU0o2ZXQxTFJMbUI2aWRIMlZJaE1VVkli?=
 =?utf-8?B?ZmNiTTdMM09LSXo1aUhud05IT3NQNVN6ZFFJaEQ0Ni9kYjZ1WCtLK0tjeHVo?=
 =?utf-8?B?SHJTcnRzR2lScTBIYy82U1ltOVBtT1EvN01iVWE2YTUxd3htRlNJemZJOHBM?=
 =?utf-8?B?anpKTmlmYzRiOW13TGxPNzJWRjBaN1hZZ29oUGNzTUw2V0tCK2JwTmgxZ3Zx?=
 =?utf-8?B?eTB2VEozeFhKYm5Td1AyZjZPdGN3M1ArTi9BNFBHQ0dHcUt6NjFxRXJWV2I1?=
 =?utf-8?B?U1FoSUcvdzZJT3NOS3BVSFZQOEd5ZThCSkhCa2pQU3QzWEM3OWZ6N3lBM3Bi?=
 =?utf-8?B?Ym4vMXZWamc3cmVYeDZYT0psRklwY2swNkdmeWZqaG14S2JCay9yOVk3WDEy?=
 =?utf-8?B?Z2NSOCtMSUIxa0xUZE1aa01pcE9CaDMveHRXdFhmcCtxM2d6dWtXQ0VxU1ZY?=
 =?utf-8?B?cFI0QmVVTWZ0OWVscVNOTHZtbUd1WDZmRnJWV01hYXlEWEQ0MUxIdFdoR0lz?=
 =?utf-8?B?WkJZTXdIMit5VUZYdlZ2MUFrazhERnlKWm9ydWFoUkZXdjVlZWN0WGtzT3RW?=
 =?utf-8?B?TkRrbWVIbjN1T0M0eW5QRjFwN29SMUdWQk04RTJPcjRuUTJKeks3Znplc0xN?=
 =?utf-8?B?RlBvOHdoc0lIaXl1ZW8xN3YxbktSQnIvWFZnRVRIdk8rdmFZODhIazQxeVQv?=
 =?utf-8?B?MHorL2ZnbU1jeHd5dUNCOUpDSy9rWElGeXplNzVYWTl3aGZZR2Y4OG13Ny9B?=
 =?utf-8?B?ZDZXck85T1dGQnUzR2E2Q29MWkhlMm1EL1FMTUlkUFdkcXllQ1lmcXhRZjl5?=
 =?utf-8?B?ekplVUg5eHlvd1RFRkRjTGVIMGNFNVcwUEFxalRnUFJwdmx0bWdMeUVucjZR?=
 =?utf-8?B?TDVKd1dNeWhCWXdHK0xiUnJlNHZvTUMwQ0lzbE9Cd2E4Qm1GMy9Vb09QYzNn?=
 =?utf-8?B?K29QMlVESXpkdHRTTXZ5SEFuMlVkM0VKRS9LOVZiTGhySlNnNC9OQitrZkZP?=
 =?utf-8?B?UFd3bnNEOVY1Y2FzbnFTdnd4cExOQWpkR09SeWcvQTB1YlV4K2VqZGhWbi9m?=
 =?utf-8?B?d20zeHZNRjlOaW5wWUE0OHByZi9uR0xmM3RpZHdOZkM3N3BId0Rmbm93UGoz?=
 =?utf-8?B?MG9QK0t0NzRLWFVlT0ZReWtFUGFXb05KSmJXSWU3ZThPZ0hnVGFRblJDYncz?=
 =?utf-8?B?V0Vzb3VYVVBHNmx5U3lCYjFOWlBpVUpsZ0hiQ3RoY3J2RkNwaXl1VTdtYlNv?=
 =?utf-8?B?ZjhGUXlwZ0ZCQUkyRzI5TTFNNGxDWG9iN2pJTDQwS2M4ZkJGVVJGUTl4YlI1?=
 =?utf-8?B?anRRSktyWkxDalZWZ3ZkMFZPMzZ5U3c3NklXNHZpNjBpbU5WQmx5SmtwSjNw?=
 =?utf-8?B?OTEzdlpoYjJ4MjlGUWNETXNqYzVtLzN3MWVyNFdqZjAyYTEvcTQwWUZGOFJL?=
 =?utf-8?Q?AIZPrlevFHBhQzO6z0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a600053-d43f-4cbc-3998-08d9003e1630
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 18:41:30.9217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gyhez3RmfjD/aPcRpIsN57LEL1wiGevQzU1pwBXp80gJNEBkX3QxrTEzkycWXAr8tfZ4nCwBEtL/UWhGbftlSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4812
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IE1hcnRpbiBLLiBQZXRlcnNlbiBTdWJq
ZWN0OiBSZTogW1BBVENIIHYyIDEvM10gaHBzYTogdXNlIF9fcGFja2VkIG9uIGluZGl2aWR1YWwg
c3RydWN0cywgbm90IGhlYWRlci13aWRlDQoNCj4gU29tZSBvZiB0aGUgc3RydWN0cyBjb250YWlu
IGBhdG9taWNfdGAgdmFsdWVzIGFuZCBhcmUgbm90IGludGVuZGVkIHRvIA0KPiBiZSBzZW50IHRv
IElPIGNvbnRyb2xsZXIgYXMgaXMuDQo+DQo+IFRoZSBjaGFuZ2UgYWRkcyBfX3BhY2tlZCB0byBl
dmVyeSBzdHJ1Y3QgYW5kIHVuaW9uIGluIHRoZSBmaWxlLg0KPiBGb2xsb3ctdXAgY29tbWl0cyB3
aWxsIGZpeCBgYXRvbWljX3RgIHByb2JsZW1zLg0KPg0KPiBUaGUgY29tbWl0IGlzIGEgbm8tb3Ag
YXQgbGVhc3Qgb24gaWE2NDoNCj4gICAgICQgZGlmZiAtdSA8KG9iamR1bXAgLWQgLXIgb2xkLm8p
IDwob2JqZHVtcCAtZCAtciBuZXcubykNCg0KQXBwbGllZCB0byA1LjEyL3Njc2ktZml4ZXMsIHRo
YW5rcyENCg0KRG9uOiBUaGFuay15b3UgZm9yIGFsbCBvZiB5b3VyIGVmZm9ydHMuIEkgYXBwcmVj
aWF0ZSB0byB3b3JrIHRoYXQgeW91IGhhdmUgZG9uZSBvbiB0aGVzZSBwYXRjaGVzLg0KDQpUaGFu
a3MsDQpEb24gQnJhY2UNCg0KWzEvM10gaHBzYTogdXNlIF9fcGFja2VkIG9uIGluZGl2aWR1YWwg
c3RydWN0cywgbm90IGhlYWRlci13aWRlDQogICAgICBodHRwczovL2dpdC5rZXJuZWwub3JnL21r
cC9zY3NpL2MvNTQ4MmE5YTFhOGZkDQpbMi8zXSBocHNhOiBmaXggYm9vdCBvbiBpYTY0IChhdG9t
aWNfdCBhbGlnbm1lbnQpDQogICAgICBodHRwczovL2dpdC5rZXJuZWwub3JnL21rcC9zY3NpL2Mv
MDJlYzE0NDI5MmJjDQpbMy8zXSBocHNhOiBhZGQgYW4gYXNzZXJ0IHRvIHByZXZlbnQgZnJvbSBf
X3BhY2tlZCByZWludHJvZHVjdGlvbg0KICAgICAgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9ta3Av
c2NzaS9jL2UwMWEwMGZmNjJhZA0KDQotLQ0KTWFydGluIEsuIFBldGVyc2VuICAgICAgT3JhY2xl
IExpbnV4IEVuZ2luZWVyaW5nDQo=
