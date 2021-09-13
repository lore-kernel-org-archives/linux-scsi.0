Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB88C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 15:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D11D6108B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 15:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245001AbhIMP12 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:27:28 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:3017 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244247AbhIMP1Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 11:27:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631546769; x=1663082769;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E7QnayXSopiUpFEmXm9BOfIZuD8nugiKotqnw7SUEb8=;
  b=RsUWy0bq5TsdCb4Txpej7J//z5jCs+n2Cc9EpxVuBoLXIfSRCVjr9Uzl
   RGMS1zw5X9bhHT5krl4vDmcCJm61i1mT/WJx+/FLwxXEIT+kh2h8QvISU
   rhfYydhY4n3p0HFNsSDn0HGyn4nDI/WshCPFdilxJHJBj8E6LcB0+fvUS
   oPqqQEzowG9nqb3xUYli5CdZK3tEcoAc3K6kX0on0P1sQvLoMpCqWkLwz
   nb/NS6LawhR8n5ZtB3Z1YHIG4DcyKwU67DhDmeZDQwo0J2c+eFAnUfvI7
   PMAHAkcKH/jXGc6HbfZvuLBpvn5wmb69V6E7GkBbIlWKwl6DzvJj2fpPQ
   g==;
X-IronPort-AV: E=Sophos;i="5.85,290,1624291200"; 
   d="scan'208";a="184654296"
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.106])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2021 23:26:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgrnsZBf57Ivh4g4vlToN29vnjuYZ4H+TAfjHvx6a9O0AmTXmymI346X/+zFwZrV03wxi1Ohte3n9a5hKX4jF9eoQ8HsFXfOM144d15dLCssVF9wMyOMt8O1pS56nPMGT4F8XskfoG/zKiDsYplib3HBiwI/x3lCp11gB/MhVYKI8kPeJT8uH1N9i+hKWVoOaB1IVxUwul8PuiMGB4jTLmwLgpOuggbiHUpPRkjBl3hX3/tQ4tb+jsiS8jOOhPlWnbVPVnSKa5uc5nPKmKKmJvgsq62qZfhxruFpPZ3snQPA07Az5ilWnF9pzktxQ9kH5ri4qSUS3TaW66sMAgNMaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=E7QnayXSopiUpFEmXm9BOfIZuD8nugiKotqnw7SUEb8=;
 b=lCOlM1xSrKkPSLxBkErLywy4y7ILHAr98PCrwLzGRYH8VrMdc3J0+/32INdKmSR3Lh3jrQawtUO2iy4g07ON6NNY5tOeyhTXNvZQAgddUr3NN+SaXSCVvIJtVVzI3/nvK5Lnpg+8U33gI4Gd8lEcYATOkuMNuYHGyXUelk+iPnzdtQdhVGgBU/ryqM/utnaB8QFxfKR9M9ZoeAFaBA8i+1mZ5zjidHXWZaDEVUnElnNwXYmEac1Tl7q9W5pfRG7NwhIHsjrhStKsbUDq5SUzyVVqywqGrjI6xgcjArWL80BW3Q5gAOTTvHC5IXXyEGh9miUIhamK4A3z6EcRVnUPgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7QnayXSopiUpFEmXm9BOfIZuD8nugiKotqnw7SUEb8=;
 b=Rn8ktIpIShNrvdu2uSF5FCZQhkLtEetSm1BVWOe2mAlKU2RHzjtzPhCkb4qaLzX2fsNaTItZjf0YB5JYhNryl3/nOas1M9xGtJsvE/ID3K0kQdxth8R1FG8j913LRdaU0aY9Eua/UumuS7arvzWSJdhUklm4w1olmPMoEfJvmLU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0268.namprd04.prod.outlook.com (2603:10b6:3:6d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.14; Mon, 13 Sep 2021 15:26:07 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:26:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v3 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Topic: [PATCH v3 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Index: AQHXp9jYZSTBrQbeXkKrPDOKOpfYl6ughOOAgAD4afCAABhpAIAAAWpAgABvT4CAABD4cA==
Date:   Mon, 13 Sep 2021 15:26:07 +0000
Message-ID: <DM6PR04MB6575A743E23128B63B790D7FFCD99@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210912131919.12962-1-avri.altman@wdc.com>
 <20210912131919.12962-2-avri.altman@wdc.com>
 <8abe6364-9240-bcaf-c17f-1703243170cb@roeck-us.net>
 <DM6PR04MB65754D1CF6B4769E6CECDB5DFCD99@DM6PR04MB6575.namprd04.prod.outlook.com>
 <d28e37db-44bb-75f8-d479-dcb106fe146d@roeck-us.net>
 <DM6PR04MB657565612A342272B2160A72FCD99@DM6PR04MB6575.namprd04.prod.outlook.com>
 <bbe45ecf-853f-77f7-9094-ded8c59075f4@roeck-us.net>
In-Reply-To: <bbe45ecf-853f-77f7-9094-ded8c59075f4@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efd0664e-129e-4ff6-d2c3-08d976caceae
x-ms-traffictypediagnostic: DM5PR04MB0268:
x-microsoft-antispam-prvs: <DM5PR04MB0268A5177825F49C93291C36FCD99@DM5PR04MB0268.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AmDGLp9evF8PjJtwv1WEhVwCvnGX8n4nHtADbCtyV/nChppsIHZCPS3wE9aWVXcB9/JTGndSu8W+u4SR0HZ+ahc25+vHaq47UxIGGLvq2O2bpXroQAQFOvMOYJqt8ngxwyIBLreJ9Nl2isfl6VOBaDRTyGvILMrJuG+0LJSt7cqyLLBEaxVShkp0vR3KtdDZ9bmuJYSzwrHI1hkH2WS0xWqJOZiKEohwZeAUP9l+1rG3Z3dWZu46D3SVgm5NPYdKftXHg3aKw0P5yko3aNYWZTNaReCfWsPyJuYpuM2O92K+BO8OqvC49/LLZgxJWjpYjB+zDV371W3OOeykAv6MXBrWJsW2cv/sEraeAs5v7CzB9tnXNDUdFUlDKfoovJ5BQ8/aZNrlA6yCc8mxYDWIXPNi8LbDKRtZKv6q8rRAeemCIoGWEteo5LrEi2RbhAJ5pwKxs5lQ1uVlgoSP1AVs+XdnY5+AYUKLDglFnWnXMxXP3MhuJ/vO6uAn4FqWOYkO7vktfhv8/jONpFu/kQ0XBPz0vX0iLfa2Vh+vE5VQGvc7hBW7CrdnOYZGChfK3N7tVJFlhlALNkcVDEbPWVg5M+kTH4ekL8vyKec8f1wETIzQNYDXLM2CJS7aclHYtvDBmvW4NAJWaiZWmOjLHBpIg465crqWaPEHskxvD6IbnU236M+mvaqPMiuZshQZEvuBCGz7Z2Mxl04PrhXAqTagLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(53546011)(83380400001)(55016002)(33656002)(4744005)(38070700005)(6506007)(316002)(71200400001)(9686003)(26005)(86362001)(110136005)(66476007)(186003)(52536014)(66446008)(66946007)(66556008)(76116006)(5660300002)(64756008)(478600001)(8936002)(38100700002)(8676002)(4326008)(7696005)(2906002)(122000001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2ptNlZZdUtKSTM1UlpiN1dhblZpZnRzNGhCZm9XYlNGdnhJeUdMeTBZQlZh?=
 =?utf-8?B?T014QkRNQ3ByUWRkUFFEU1RPc0FaWm12QWlCNVVuUUJJQ3QvNVVaTjlTampx?=
 =?utf-8?B?OHorb0tSN1JUV3hSaEhsT1ZqWDA3WWh0cVJUZXFZemRtem9NWnc3WEE0WUFx?=
 =?utf-8?B?UWN3RlU5eW5sUHVHVDV4U1VsOEoyWXY1dmN6dEtwSnArTTVLU1RWNVcwblY3?=
 =?utf-8?B?ME94aEFLYlV0bFRSN2cwZGlxOWtEVjhoUXR2T0pNbTVXSkg3MmNQKzF0Y04x?=
 =?utf-8?B?OEFyNEk0YzMyZEFLUXZCU0RJZkIycWNjTFQ5SnEvS0ZZQ2NhUDBLOWVxMkY2?=
 =?utf-8?B?Y25aUlZWZUtpbU4ybnkxd2RLRVJORkNQRjM5cS9UTXNJY1BhZ04wSjRUdWkx?=
 =?utf-8?B?TmRrNEloTlRiSkpxeGlWZ1J5VUdsTnZzcHhyTm8wTWZWM2F2UE9ScnZaaEZV?=
 =?utf-8?B?LzJjWFYydmtMcjk1dnRrZS9UQUR4YkFNeGdPZ0gxWmRIdlZvVTNmd2s5eit6?=
 =?utf-8?B?ZFlOelpGenVwc3pGUDhSRlZ6YU9tVlRmUS9HcW1Jb2hPYTFBMnM2cEtjaktk?=
 =?utf-8?B?SkNyTVQyY1RYQWFTVkVBcG1lZG1Ld1B1bm5VeWhRVXBHZTY4TUE1amtmSDdi?=
 =?utf-8?B?ZURjY2lGQ3A4MnRjRGRHdnJlckt0SG0wM0h0eVFFNzlSQWdtcHFqekEyQ0FQ?=
 =?utf-8?B?NXplUUllSUxrS0xMYlloRjNkYTRsS2hRSVdmSEtjSnVOVDFYYzlRNXRoRm1J?=
 =?utf-8?B?NmJWbGRMdU1mZnBNdDcrNTFWRHY0WVJvT2kxSGNTYUFJSUxNQWx2encyZGNJ?=
 =?utf-8?B?THhWZUNhNkkwRlFJNHJsdGMwK01ORlA1cnpwWlczalVHQXVIc1U0WnFiSm1n?=
 =?utf-8?B?ZmxhWjNxUjU1VkZjOWFlVUEvZjVCaCtTQXViZU9ncW9ndjFGVzhDRmVMQ3ky?=
 =?utf-8?B?cW1saDNNMmIrZHVmdm9PVWltRUlvZzNyMWhXVEozNVFDRFdSR1VZbTRXSHJq?=
 =?utf-8?B?WUd3Nzgvek9sZWJuS0JzUnBlbkk1cUp5RVdFM0F0Snp5ZHFUT3Y1bGlhZ3Zu?=
 =?utf-8?B?cGhsdnNBTlJmSHBubUFPRzlKWFQrRUtxYVdqWGdnK2xnTVVuRHkvTC9DREto?=
 =?utf-8?B?WC85cUQ4MWxhTWdFaWYvWEhEVmhPY29ZRyt1c3B2cDQ4cUJQSXh3SU96MWNY?=
 =?utf-8?B?U1lZNFBMc0kwTDJqa082bkpuV08vSU82ZUJBTVZQUEtzRlBLVFdPYjcwbmlw?=
 =?utf-8?B?bGJ3VFB2M1R1aENtODVxMDRHb2ZPdm5heDBYVHlnZmxRVkxGNkxFR0MzYU5n?=
 =?utf-8?B?bUlSYkN1U1VtQWo2MmNjUzFRMzFqc0R2cmE4cWdVc21IeWFzY2xpTGtPM2xo?=
 =?utf-8?B?NXBZbUNVcWlzUHB2RlFCNHRzY0kxY3pUSHhjT0cvMk1rRXpkTGNNR281eXFI?=
 =?utf-8?B?OHFzWUZUbEkyVERVYzlMOW80MnBKaWs3VVJwM2pSYVh0OGJLZDAvTlBzTFhN?=
 =?utf-8?B?VE5ad0k1L3Nhcjk0am56WTkyZXZPWXJoWHpINU95VVQ1bXJkU3JRSDljbTQz?=
 =?utf-8?B?ZzhiT21VTE9seFBkejFIcS8va2w4UTA5TlhtSnprd2ZBMHEzRnA0d0t2bXpP?=
 =?utf-8?B?ZGk1TndUaERPWkU0STdoNXBKajk2enc3UkVuOUJkV0hTTCtzdHRDbkhzRmpK?=
 =?utf-8?B?dTk1cUpHczMzUWd0RmJIcW5uWUdLdjBtYXhNNUphQkJhaFR4dngvK1NkeGhI?=
 =?utf-8?Q?2RCyIOi015o46NF1d2lYuHjSIw3F1/8udtyh05D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd0664e-129e-4ff6-d2c3-08d976caceae
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 15:26:07.1715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rns4IliP/FD2iANELAStHtR68Oaz5cHPrE3MGZbyQYlOjbJ6dqV7KqNMbVy0ggT9cgfY2GiroUjJ1SSfi4w5gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0268
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBPbiA5LzEzLzIxIDEyOjQ5IEFNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPj4+PiBUaGUg
ImVuYWJsZSIgYXR0cmlidXRlIG9ubHkgbWFrZXMgc2Vuc2UgaWYgaXQgY2FuIGJlIHVzZWQgdG8N
Cj4gPj4+PiBhY3R1YWxseSBlbmFibGUgb3IgZGlzYWJsZSBhIHNwZWNpZmljIHNlbnNvciwgYW5k
IGlzIG5vdCB0aWVkIHRvDQo+ID4+Pj4gbGltaXQgYXR0cmlidXRlcyBidXQgdG8gdGhlIGFjdHVh
bCBzZW5zb3IgdmFsdWVzLg0KPiA+Pj4gU2VlIGV4cGxhbmF0aW9uIGFib3ZlLg0KPiA+Pj4gICAg
V2lsbCBtYWtlIGl0IHdyaXRhYmxlIGFzIHdlbGwuDQo+ID4+Pg0KPiA+Pg0KPiA+PiBUaGF0IG9u
bHkgbWFrZXMgc2Vuc2UgaWYgdGhlIGluZm9ybWF0aW9uIGlzIHBhc3NlZCB0byB0aGUgY2hpcC4g
V2hhdA0KPiA+PiBpcyBnb2luZyB0byBoYXBwZW4gaWYgdGhlIHVzZXIgd3JpdGVzIDAgaW50byB0
aGUgYXR0cmlidXRlID8NCj4gPiBXaWxsIHR1cm4gb2ZmIHRoZSB0ZW1wZXJhdHVyZSBleGNlcHRp
b24gYml0cywgc28gdGhhdCBUY2FzZSBpcyBubw0KPiA+IGxvbmdlciB2YWxpZCwgYW5kIHRoZSBk
ZXZpY2Ugd2lsbCBhbHdheXMgcmV0dXJuIFRjYXNlID0gMC4NCj4gPg0KPiANCj4gT2suIFRoZW4g
YXR0ZW1wdHMgdG8gcmVhZCB0aGUgdGVtcGVyYXR1cmUgc2hvdWxkIHJldHVybiAtRU5PREFUQSwg
bm90IC0NCj4gRUlOVkFMLCBpZiBUY2FzZSA9PSAwLg0KT0suIFRoYW5rcywNCg0KQXZyaQ0KDQo+
IA0KPiBHdWVudGVyDQo=
