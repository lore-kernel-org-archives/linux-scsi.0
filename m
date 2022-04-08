Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624A3C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 08:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiDHIeF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbiDHIeE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 04:34:04 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AD1D083C
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 01:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649406722; x=1680942722;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=640gwAZAeJKSUVdHatzbfNvdT4dDIivTH+qNxFTLTY8=;
  b=kOiLS9d2e4K1yShdhWwe+EdO+lOWC30u67K8Ji6IOLf8XRmhXw4nKO5W
   hdKW1mmWCxELrKt0mt7rnZfdmq0kWzsUODrIHGQZFehvQ5lBtF4J5u5y3
   Gz7TYHsSVvoDEq4YU27iysI8T3YWkz8rLbUpjeiqslRcyRbCkECGjOnm7
   TWUaiQ44jeNIW/obzEyaiDgBzp+PAlUKez9V954uCBdv2Hkqw5A5BNxDq
   G03iURtLK5nTA49zZSifif7nVgqoPrwvMjF17TBa+Um6qmRoY2m80+fkc
   1xiIeZAUXPkRoaw0/1SlwClpfytuvSu7WQT5UJLJNeAMmF3KKgWBw7FQm
   g==;
X-IronPort-AV: E=Sophos;i="5.90,244,1643698800"; 
   d="scan'208";a="151993304"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Apr 2022 01:32:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Apr 2022 01:31:59 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 8 Apr 2022 01:31:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUc+MkzlSSrzxkioBPDPAF0yY7wjrfH/m5zlpjMs4cGHAl+uU/EOcRA4tH1+6rnHHaxTOc/JfCYkdPDNaPx6BMtZyvYDhX6F+ANM2VgCQ9BN2pxRxaB25+OQP3KL/F0yNQm2yXvaXvzd5cSlwQobBjFo2v4b920wm3qwLhx7asLOwvOYCzsYQ2fRhF78WYT4+5ldO1wNT+qYxoCEXbTYQjuD681P41NLJovJ+EFpMFkQTuM6Vj/d56IaX+B269fdTYzUIlO/z1eh8ypvmohpd2Sl/32xTGdoyJW1K37Od4+ZWomI272AM90YjYK3K1mQwRvw+8ADxs6k2dWYAXCQ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=640gwAZAeJKSUVdHatzbfNvdT4dDIivTH+qNxFTLTY8=;
 b=VGfDPb9o5HnuSN9K1azuXKB8dWeXaX2dReCXkb0k23pTqzFYCy6ySDkJVP7vN3OKnVD+LIOahurGCgah3qCnovyXxt279tuCcPMQQSSlUUm6kEEQQn61TVbm71gWQD9OELZs3pj1hM50QSRgTcKauEPPUAfTUl4WA5VWeXrB/t9URxRZntWqqpygTyqcKWZbrD5/bOvUWeIq6L3N/gaYTwN3u48QFCS5VNnKoyL4PVbq6XXMtiqu7VGVknOPEkJfmnpu7mnXU8xBNyfzUwxvLSGpy1JR2Dsck8WnqA4DGSdNDBeSR24bEAGtiIrtiMf4U6t6QEedLwFX/vodVGnNxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=640gwAZAeJKSUVdHatzbfNvdT4dDIivTH+qNxFTLTY8=;
 b=ckDkuPUEWlLTS24UfWZZhjuKAOejLSr4FDQcHFqfB5ornrf/0m5WRheHBzExW1w4tPLWU5wTFpxnQO7mBzHwxKGVG8LDJQ5altXdwFgwcB0Zba2lr8UzJK9+qUXoPL1TgRBg7+xNi43pnxi1vPOm6y3yrE+m0AydTE/jpD90Q3s=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by SN6PR11MB2992.namprd11.prod.outlook.com (2603:10b6:805:d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Fri, 8 Apr
 2022 08:31:57 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::48b9:f92:9375:2983]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::48b9:f92:9375:2983%9]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 08:31:57 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <john.garry@huawei.com>, <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: RE: [PATCH v3 2/2] scsi: pm80xx: enable upper inbound, outbound
 queues
Thread-Topic: [PATCH v3 2/2] scsi: pm80xx: enable upper inbound, outbound
 queues
Thread-Index: AQHYSyFcX2uFESQ7Jk60BA+m+Iq0iqzlrypQ
Date:   Fri, 8 Apr 2022 08:31:57 +0000
Message-ID: <PH0PR11MB5112CD09B3503E1D0FC23FDDECE99@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <20220408080538.278707-1-Ajish.Koshy@microchip.com>
 <20220408080538.278707-3-Ajish.Koshy@microchip.com>
 <67ca3648-38b5-86b0-9503-17a2eff8d7dd@huawei.com>
In-Reply-To: <67ca3648-38b5-86b0-9503-17a2eff8d7dd@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 960ee19a-28a9-488f-8eae-08da193a3e87
x-ms-traffictypediagnostic: SN6PR11MB2992:EE_
x-microsoft-antispam-prvs: <SN6PR11MB29922E9C26B7E57FC00C5225ECE99@SN6PR11MB2992.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pWPQx2/u8kmCZ8jNyEzR4h/Bb4MLRTL8PZha3WPsYojRt6SF0VoabvsAkyV3wGKT8gHwSbF5D76t2DHnYuDeDx5u4rlciUon7+y1xWCE+fOq0aXT3F9xFG4LfHRCjOGZ1UGBmd254mtLDwuXtJzpU/poaUWCzUBoj8xHAxVwVgwRMpgARJuruZj3AsoiXYq+iytD7D+Wb6LWfbNE6TNkgOHbizVrVshF6RAGUshd7wJ+1EWbaNUipVmA/cKxO7Gx1bNsWYnGS7tDriEoUqCmdQyq+YySmUC5/YtzQnvHyUPyI9MhjRa9UlcxboKR6oW/S68c2c92wslzz9YXA0yDpjgy7CSHdbXguxA50Rn8Fpv9YvIK5AYoY+XBqgEMHz48psCea8Ht2LbCaIkH7wby/x1osMAXYijher/DBCTaf/0GlDrXa16+p8pYZYQXnBwmDGyThsZWrFMAq7veHuBrSNMp/JsXNcPcCWXczMNlll2A65oUg3u224Nk9MjfCKBPJnLXDiFAobL/bMLD8Vh+gmvUunv3sBPdBsWbInu243ukGOODbfcIKYw9OXlU6GJcO3gUEJK4CwT3cLTNcfiSjky2/KA0qpgy4d2TB3KpLKjLJlCeexv38/i7r8qnkqRYNeTlpKN7U7d5YGLDWeYpZ3W+azCOPABP2hH9gLDrOMeMqsU0fn5DYSVr2Nnv6om8AV5PtjoUHZ3YF9KZpwjzfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(54906003)(38100700002)(122000001)(53546011)(9686003)(2906002)(110136005)(55016003)(33656002)(26005)(52536014)(8676002)(76116006)(186003)(86362001)(4326008)(5660300002)(316002)(66476007)(66556008)(66946007)(71200400001)(6506007)(66446008)(8936002)(7696005)(508600001)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZktUdlByU3lKYjFsSnNjdHFmczJ0aGxuaWxFb0Q3azR3YWRLYitsUEZ6OGhP?=
 =?utf-8?B?clcxZm9DeUJhUThqbFpHL0d3WWdDcDk3bmZ5RU55RytZWDk5NjZWVEJpUTdD?=
 =?utf-8?B?K3gxbFVVTEZpVmVaZ3Y5allRQ2FHa2MwMjJGRm5sOFRQRWxiZ2dONGZKSE0w?=
 =?utf-8?B?MXdrVG5GMmNKbHpMQ0IyN2RpSlNSeHNCS001OXdMQk1zUnQyTTM5VzFJS1V1?=
 =?utf-8?B?bGxYQzJObTJLTy9SNDR1RUlMdGFOblZjU2RScXBkUVVpSk05SEhXNEVqbW1z?=
 =?utf-8?B?QmFCeVpYQkkzUzF6bTdZOU0vK3hlVlhwQ1NQM0gwcExQbnp4bVNwUVVFWDVj?=
 =?utf-8?B?bUc0Tkc0ZWZJZFhCZWh5VUhGNkpBSTJlNWRBSlRJZHlya2ZJMUxXSGN5dGFO?=
 =?utf-8?B?eHF5WlV6SElxajdIUUE5ZVhMeFRSc1VEK0RBaW14TGg0YzZrVjM0aVZqb1V2?=
 =?utf-8?B?V2NMUkpVVlNrUTgyYTUrekROc0NpVGw0dGE2dEgyVEhWL000K2VIbXZGUnh5?=
 =?utf-8?B?ZFJDOWgwdThxUUxmcEpUNHFOcC9nV3B6bTRHN0NCb3IrbW5KOHhXVFNVTzZQ?=
 =?utf-8?B?ZHJ6L1JiSlc4WUZITXRXUkZiUVpocm16YW5SNTZRTDEwRTdFUGl3OUNtM1N1?=
 =?utf-8?B?NDRPK09uaVp5dEpuRy9Mc3hsVm1TcnJkRVY5cVhONFU4ejdrVStmVjRZaWcz?=
 =?utf-8?B?WjVhZFhuczBhcEhyemk2WGo0RlhkNUJjd1I0cUxQNU1rczZqc2c2a1FQWGk0?=
 =?utf-8?B?ZCtsaGhBTXFmb1BraUl3OU5vNm5iTHRGSGFDTXdpa1JTMlcrMGdQQTZQZU10?=
 =?utf-8?B?aWxNcUc2TGo5Tk53QkpTVXdubXVNb3FKUUJ3c2dReC9KWG45aXIxeGhmck5K?=
 =?utf-8?B?VlVvUUdKNTRoeEVjbHgvUFBSREE2RWVnbHhwSU5wcUNzSlFucDF4Nkc5K1Np?=
 =?utf-8?B?TmtvTENWS3lDKzZ3R0Z2YU1SNHhFL3h6czBUSERGVFR3NnNLQkFraHQ2MW81?=
 =?utf-8?B?UUgySks4YjNpdHNmZUVrVUFUSTRHRytpZnFYTjMzc1NrZ0NjeDRxQm1TWCt3?=
 =?utf-8?B?Vm4vS1JMc1A2dTFTQ3lVQXozaXlwem9sYW9BMWlGb0ZRR0VCT2hsaXl2dUdj?=
 =?utf-8?B?Sml1b0ltR1hOVjVjdWhvb2t1dnRTUkJXMVRCeEZVTFUya1o5dGExVkRLMUcr?=
 =?utf-8?B?ZUNML1J6OG42Y1V1VDZYRXNDK1Ziay9ucEJBV084bEc1Z0c4a3R1Mkk2QTVy?=
 =?utf-8?B?Qk14elNrUm0zYXVVdHZtMUQxSjZwS3JVbk1IRFlOWmh1N0x4a3RaaUc2UndN?=
 =?utf-8?B?dEZrWnMzdjE2SXNJK0hTNWpxU3QxY0RTUVNMYytjVk5IaDlDTGdNN3pualZ0?=
 =?utf-8?B?dThJcW9KK2NLZm81Tkd4QytDaDhTY3ZWMVhiTVQ5TkZzUTM5V2lFZ3RvL2RR?=
 =?utf-8?B?Z2I4cDBVVng3QnVIQUNtY1h6MmxTM0ZiSDNzMG14dkpsY1JLNnhoaFE0U2xK?=
 =?utf-8?B?d0JUQXZRcWJJQzNZQi9GcVB5YWxaRi9hL1d5d01zcGpOT3dTUGsvM2ZuRTNw?=
 =?utf-8?B?TUkzK3NPYnN4QWl2MktjQnNJS3hCcHpENWI1Q3dnbCs0OTc3QkIrNTM1UDNZ?=
 =?utf-8?B?ZFlSMGhaUTZnQkdVN1JNYUxaUTlKUEVGdzRjQ2N3RE0wTDVuenBxcnNQdURk?=
 =?utf-8?B?Q0dQMUlKVUhjVzM1dG51MEN4VXlJK3duVGkvMVhXclY2M3IwZm1WK3NlV0po?=
 =?utf-8?B?WGR5bEJYWWFaVjhNdklLbFJYNlFkWUFKQUJTVjIvcjJQMkhvcS90ZnI0UTc2?=
 =?utf-8?B?aVFMeW1oL3hOVE1uYVVaRnVreFNGQUJ4R0s4VmlxdWU1dW1wVlNnRHI2cmFZ?=
 =?utf-8?B?aDdNU2IyaEtNM0FjY3NLREtFYi9GY29VVHNYcVNJVmFXMDI3enZUL3h2SUJU?=
 =?utf-8?B?NC9xd0FURGRBeUNldkxzN0FUM01SMXBsTG55TUVaQ0tGQVJmdzZVek5GeE44?=
 =?utf-8?B?VEtuRWJkMk01M2RhQVhYMWlNb2hvS0dnSmhEb1VyRFVBczNhNENjbngvbkps?=
 =?utf-8?B?YStPZ3NabEllSkhaOHdBOVJEamRGcnRFM1V1M2pRb3pEMVE4QVlFbkZPNmJy?=
 =?utf-8?B?MWhOSjJoY253TmVUdTNiK1VRYzNXZ3l5dHRuMXBRR215Z3NGNGNTTisrdXFq?=
 =?utf-8?B?eXo2RW96KzBIWlFqanc2Ujg5UFh5R2J2bkNZS0NJOHExdTlmWjdaUXU2SXkv?=
 =?utf-8?B?bjE3OHlWT2VhdGNYL1ZPODF4aUNGM09pZU1CVnViVXAvdXVFZlB5RVRyU2Q5?=
 =?utf-8?B?ZzFuckV6UlFWSkhWS0xJL0h3dEcwb1VwbWRKMHNRa3ZPYW8yanVkbnJjMXBz?=
 =?utf-8?Q?1Kkrb/cX0S+Yorzg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 960ee19a-28a9-488f-8eae-08da193a3e87
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 08:31:57.3746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y4rYZrk6UvyFr9Dnt1/thsk4IbdwPxdqGCfc6y5o/JA/gn1RFdGuRjGgkUEjI/kIbYSxRSx4ZaGKm7yoL7aMrmP9X+k/fOCTqQ0vzN4ibMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2992
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmtzIEpvaG4gZm9yIHlvdXIgY29tbWVudHMgaGVyZS4NCldpbGwgZG8gaXQgaW4gdjQuDQoN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3Uga25vdyB0aGUNCj4gY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiAwOC8wNC8y
MDIyIDA5OjA1LCBBamlzaCBLb3NoeSB3cm90ZToNCj4gPiBFeGVjdXRpbmcgZHJpdmVyIG9uIHNl
cnZlcnMgd2l0aCBtb3JlIHRoYW4gMzIgQ1BVcyB3ZXJlIGZhY2VkIHdpdGgNCj4gPiBjb21tYW5k
IHRpbWVvdXRzLiBUaGlzIGlzIGJlY2F1c2Ugd2Ugd2VyZSBub3QgZ2V0aW5nIGNvbXBsZXRpb25z
IGZvcg0KPiA+IGNvbW1hbmRzIHN1Ym1pdHRlZCBvbiBJUTMyIC0gSVE2My4NCj4gPg0KPiA+IFNl
dCBFNjRRIGJpdCB0byBlbmFibGUgdXBwZXIgaW5ib3VuZCBhbmQgb3V0Ym91bmQgcXVldWVzIDMy
IHRvIDYzIGluDQo+ID4gdGhlIE1QSSBtYWluIGNvbmZpZ3VyYXRpb24gdGFibGUuDQo+ID4NCj4g
PiBBZGRlZCA1MDBtcyBkZWxheSBhZnRlciBzdWNjZXNzZnVsIE1QSSBpbml0aWFsaXphdGlvbiBh
cyBtZW50aW9uZWQgaW4NCj4gPiBjb250cm9sbGVyIGRhdGFzaGVldC4NCj4gPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEFqaXNoIEtvc2h5IDxBamlzaC5Lb3NoeUBtaWNyb2NoaXAuY29tPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFZpc3dhcyBHIDxWaXN3YXMuR0BtaWNyb2NoaXAuY29tPg0KPiA+IEZpeGVz
OiAwNWM2YzAyOWE0NGQgKCJzY3NpOiBwbTgweHg6IEluY3JlYXNlIG51bWJlciBvZiBzdXBwb3J0
ZWQNCj4gPiBxdWV1ZXMiKQ0KPiA+IFJldmlld2VkLWJ5OiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVu
LmxlbW9hbEBvcGVuc291cmNlLndkYy5jb20+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL3Njc2kv
cG04MDAxL3BtODB4eF9od2kuYyB8IDYgKysrKysrDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgNiBp
bnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3BtODAwMS9w
bTgweHhfaHdpLmMNCj4gPiBiL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3aS5jDQo+ID4g
aW5kZXggY2RiMzE2NzlmNDE5Li43MWI2Y2M0Yjk0MjAgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9zY3NpL3BtODAwMS9wbTgweHhfaHdpLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvcG04MDAx
L3BtODB4eF9od2kuYw0KPiA+IEBAIC03NjYsNiArNzY2LDEwIEBAIHN0YXRpYyB2b2lkIGluaXRf
ZGVmYXVsdF90YWJsZV92YWx1ZXMoc3RydWN0DQo+IHBtODAwMV9oYmFfaW5mbyAqcG04MDAxX2hh
KQ0KPiA+ICAgICAgIHBtODAwMV9oYS0+bWFpbl9jZmdfdGJsLnBtODB4eF90YmwucGNzX2V2ZW50
X2xvZ19zZXZlcml0eSAgICAgICA9DQo+IDB4MDE7DQo+ID4gICAgICAgcG04MDAxX2hhLT5tYWlu
X2NmZ190YmwucG04MHh4X3RibC5mYXRhbF9lcnJfaW50ZXJydXB0ICAgICAgICAgID0gMHgwMTsN
Cj4gPg0KPiA+ICsgICAgIC8qIEVuYWJsZSBoaWdoZXIgSVFzIGFuZCBPUXMsIDMyIHRvIDYzLCBi
aXQgMTYgKi8NCj4gPiArICAgICBpZiAocG04MDAxX2hhLT5tYXhfcV9udW0gPiAzMikNCj4gPiAr
ICAgICAgICAgICAgIHBtODAwMV9oYS0+bWFpbl9jZmdfdGJsLnBtODB4eF90YmwuZmF0YWxfZXJy
X2ludGVycnVwdCB8PQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIDEgPDwgMTY7DQo+ID4gICAgICAgLyogRGlzYWJsZSBlbmQgdG8gZW5k
IENSQyBjaGVja2luZyAqLw0KPiA+ICAgICAgIHBtODAwMV9oYS0+bWFpbl9jZmdfdGJsLnBtODB4
eF90YmwuY3JjX2NvcmVfZHVtcCA9ICgweDEgPDwgMTYpOw0KPiA+DQo+ID4gQEAgLTEwMjcsNiAr
MTAzMSw4IEBAIHN0YXRpYyBpbnQgbXBpX2luaXRfY2hlY2soc3RydWN0DQo+IHBtODAwMV9oYmFf
aW5mbyAqcG04MDAxX2hhKQ0KPiA+ICAgICAgIGlmICgweDAwMDAgIT0gZ3N0X2xlbl9tcGlzdGF0
ZSkNCj4gPiAgICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7DQo+ID4NCj4gPiArICAgICBtc2xl
ZXAoNTAwKTsNCj4gDQo+IFBlcnNvbmFsbHkgSSB0aGluayB5b3Ugc2hvdWxkIG1lbnRpb24gd2hl
cmUgdGhpcyA1MDBtcyB2YWx1ZSBjb21lcyBmcm9tDQo+ICAgKHRoZSBkYXRhc2hlZXQpLCBhcyBp
dCBpcyBub3QgYXJiaXRyYXJ5DQoNCk9LLg0KDQo+IA0KPiBUaGUgY2hhbmdlIGxvb2tzIG9rIGFw
YXJ0IGZyb20gdGhhdA0KPiANCj4gPiArDQo+ID4gICAgICAgcmV0dXJuIDA7DQo+ID4gICB9DQo+
ID4NCg0K
