Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603E8C48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 07:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DFDD610CA
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 07:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhFUHFW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 03:05:22 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:36993 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhFUHFV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 03:05:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1624258987; x=1655794987;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MRuhh5PBWOpI/jM2qXKhmkBhUsJIf1d8Ckr/sxFXD6Q=;
  b=ppN6D2yPaBynmS/ECgPhSaf2z2SqT1o/BZNZ7bH/EfFSAnAx08lOzD8N
   C6P0LmaWhvRB92P3PhpzMB0TIsukvsHd/PXUyDXIlRNMDFivoxpGOz5Wc
   CqTbbgf2z+NGIxxENTaorV9wBqvFQwiz2YmER7dnnfHoB50A8mPsj/6kP
   posQ1CISxwreFZwNIy1Xpa0TdkBGSJI1+JZDm30VQWxyeGtVEUTYf3g45
   WvyhkjVKj8j3PUMLiL05HheziR7n9uwhSXKAwhTBi3a7mc18h5rNtr+y0
   nQk5oLlvZio23gXbNNFkilSWxslyI8nn+jhIIpvGG/y+LBEl1/CdwN//r
   w==;
IronPort-SDR: sxIsUuag7WFYrElxgd8TRq8o9FNARUIeBgtoUdenGJcYNLf1kRxzUyBLxNa15ceHThGOwUu/Dl
 zYAbO13eQ+82K7PUV7feJrvXLdHCkJHWuwFMWtB6vkBIKea6EUAXvoww2/lQyIkdFn+e9luFgv
 82etjYKrEhRW9JY61cMqP3mM1wvFeC+zjta0fdTkmGjxNBR4s2BLmflKO5jPRFq2UxuR0zCjXM
 KZquTXLPX9kvcMCV5KwvKT0YyQnPAwZ+nUSOmQLHJVr9K1j8OY8n7CCKD0klMI/vX1qcPIg/lr
 VWg=
X-IronPort-AV: E=Sophos;i="5.83,289,1616428800"; 
   d="scan'208";a="172460500"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2021 15:03:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6bl+gu1a7zrn5MJxJkgl5fDU1HWTBDjSETNffpCLWkgGq8Uk52jvBVYhpt5muLa4i1sGYms+0b1kgoAFOptEOT+jZwKPJkfTp+faLB2OmklQzXvAGUOvie5eajo38cEcT4Yq/Qvh8W0EKTqzNa+MhaJbuSptPHyge6doqsGL6XydXdymM3xxJZVRFSE8sIkqiJO3pJXyPgNJOXWFwEPqmR/F3XMZOwbgCTHwQe2dEHNEiTBCY7yh6Kq5hOiqgoNkz0gsmr70mQjaDw3zHzBdKpDKfmoCe9yBy1o39H7JMuWr2XICgx2r2+OcWWEIAHxQl3DJUlPO5HlzhoFHkmEkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRuhh5PBWOpI/jM2qXKhmkBhUsJIf1d8Ckr/sxFXD6Q=;
 b=CETzc309VhXJO/k5u7EyD651RWdRHYJKHAoz4m6tlnvhD2lM8KYCF488rL4EC6ru7NiVq8MxIs9cG8w9dhJJTFTdCYVki5yWpLwKCmVJNlRc5XpKyGtTyvimDWRcSwNjKNDYRXSd1f2JM3IPhJ3YnwB/MhNTOyRA32Nj4UfQHWH8Sfd9g6V+MQfy5R4Iq9BhTjZM8j+2SBKWzSlW+BYidgfzfG0zcX45CUqpPDKZMoR4/9M0cmr/nUz2DFzqJXPEeczVKG8fk12OyXLdNbzwq6iMpKtoj2BhpPLdRtvgpYS4FQOwpmFhFxnmvqETv1rlTMLYMe7f2GPrm5/3ohWxkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRuhh5PBWOpI/jM2qXKhmkBhUsJIf1d8Ckr/sxFXD6Q=;
 b=YJaSMGCp2wpyrIHeFE4PZV1mdgOzHTwNOVuPvxvkOTtaobk6B6VF1y5vnxO2J0gS9kK5ED43RcxcWzOHWTSt+NgBvqWGt8tPDxrRu6yucqTAQWnRQYGlHTxp7oRQsmo1PVNbNwFmGnbeyYnKL509SMzESkeH0HaVwUJRFDGWXBM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5676.namprd04.prod.outlook.com (2603:10b6:5:167::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.21; Mon, 21 Jun 2021 07:03:04 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0%9]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 07:03:04 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v11 08/12] scsi: ufshpb: Add "Cold" regions timer
Thread-Topic: [PATCH v11 08/12] scsi: ufshpb: Add "Cold" regions timer
Thread-Index: AQHXYqLc/09wMCzBWU2yKt6H6tkVn6sd9DSAgAAby8A=
Date:   Mon, 21 Jun 2021 07:03:04 +0000
Message-ID: <DM6PR04MB6575C466A26C5FEB5EEE5B6FFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210616112800.52963-9-avri.altman@wdc.com>
        <20210616112800.52963-1-avri.altman@wdc.com>
        <CGME20210616112925epcas2p1267d33aee5fa552333a0503207e262f2@epcms2p1>
 <1891546521.01624253881548.JavaMail.epsvc@epcpadp4>
In-Reply-To: <1891546521.01624253881548.JavaMail.epsvc@epcpadp4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23e5ef1b-a187-4e51-0b53-08d934829dc1
x-ms-traffictypediagnostic: DM6PR04MB5676:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB5676C59523EBC7ED471D490FFC0A9@DM6PR04MB5676.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nsfa9bUZmEN9XrawCszfdZrr5V0vgB/tD3I+s91M5lffKcaDw5CBypNf5NgEf7O14xcCdJ4wZGVckMAxFpqm3asyLZ9BzndztkEWAl3TK9W4moe471sfOl9i9JG6atDHc0WKvqvBwTnuwbsqwqBmVuSGL/Lu2YQZ5t/xMZQK1cBxWi6S9AiW63s69XWzoB/S6ldBi25ovRdKVvOOUkRA6PSjHnMS/gMMxmkI+vKqfoGOT+fLFlnwJ1AOy4qJR6NwYeK4v7+6euH9iG7K+toDwIErF4tCVKzXE02GuKUumsY7gTkv9scPiNfKBj5Fdgfl9eSu1DMtYNbLM0CZRBZktqNz8NXYdSmAN73zoTncJ0u1hPuG1VqdIJBcrxihO1ef1XaIhnKCZ6ZGHMeiycITQloQLGzmuYKqUEqeHIiO93NlhufsPtCiT8z5k+RVwH8VORrK7Jt7KbMpjACdqimTsHoVWXwjYLBiisCpr+pn7+tigD45Z3q7cuVl0VMgiwxCt+kAj4aXe6eOvdU19v06XQAetWU2ag7Ob2ulcB8+/oMJvl7Ic+LBp1bEJXf4y3+dONgDGj1WzuQx4OcmByon1nw01BtLlrxltsG6F3cWoWU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(8676002)(478600001)(33656002)(4326008)(316002)(71200400001)(83380400001)(2906002)(8936002)(7696005)(110136005)(186003)(7416002)(26005)(55016002)(9686003)(64756008)(6506007)(76116006)(66946007)(5660300002)(38100700002)(52536014)(66446008)(54906003)(86362001)(122000001)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkdQa1BNcUxlOSsrZVRrRDgrbllvT2s5MkVOby9taHlTQUk3WnBYQ3JKSXhy?=
 =?utf-8?B?cnBhTFoyMVBkbEcxeHVlUXlKTm54bHdCc3kwRk1oZVp1NC9YTVdoRkJPTkta?=
 =?utf-8?B?NWJWbWpmUzJnNlU2MmxUQUZ2YnJtMUVCYXRsY3M5N1Nkc3E4citBN2JkTDN6?=
 =?utf-8?B?OEhONHFGeGNGRmNsTkZkZkhiaEdFTE9hN3lYU3pRM2xFK0hUZnR6NVZ1NjdF?=
 =?utf-8?B?Mi9kRnlMSytrSHVYOUhMWWkwRGRyRTVtVlBmWjBRMVR5YU9BSW01emhTaDJy?=
 =?utf-8?B?R1JEYmNQdHUxY0ZHaXdkSzcyWUpkdDljK080d21wUkY2Zm0xUkcyb200eks2?=
 =?utf-8?B?TmlWclFCTm1wSlRJb0lIYmpHWngxUHlDOUk1L2FrUjBmY3NoQVNsK3Vqcyti?=
 =?utf-8?B?UUhHMG15dEZVbklYeHcydmVTWDN2bnc1alJLRVcvOHVRQ2J5cjVYSXNJYkls?=
 =?utf-8?B?VlZxSFF0aWdteVRMdStvNjlnWUY0MnNwdXR5VkJQZXRhNStJbzRMb3hVdjFT?=
 =?utf-8?B?ejcvbUR5ZnpXdjQ1WWExTEFxQWoxOE5uTDBmdUcvY1FZdllCRXA1bXZGbi9x?=
 =?utf-8?B?TEc2UG05MGphbnIwY3NaU1NyYmJsc29sRzJJSkh4Yyt2Y0xTOTlNR0cvWTgy?=
 =?utf-8?B?ZjdEcFo4VWwxTXpobUlGd2VJWnA1V2JiV05rU01kTzJ3TUdmQXI1MnRRMlRP?=
 =?utf-8?B?dGZZZVhORVNlUndoOXAwQmY3SHc1RVoraGxVdzdXNmtpZDV3bVBZRUZXRWpO?=
 =?utf-8?B?YXdFaVRPQzF3bFdNcHRXTTVyVFZuYWxCOTJ3OTJ0SUcyaGx4SE0rNGc1MXUr?=
 =?utf-8?B?QUR2U2xrNkdTQ3E2Yk9qUFBPa0V1MG91NUdJelJRWHQzbC9qT3NvdkNWYWc5?=
 =?utf-8?B?TDJSS3NrUHVVcDFEeHkrbytUWjBMSHJqeURYRllQWDQxK3g5OEIvdms4V2ty?=
 =?utf-8?B?Q3NHZVJEVjBVUUZUVGR0WGFkNHliNmlRbGF1SFZZaG11WTRPVS9NZXplMnJk?=
 =?utf-8?B?NDRxVXllM1BDaG9LSzBEVUFoLzdJUVpvVU1FejNmMlR6Z0oydm8zMjc4aWd1?=
 =?utf-8?B?Z3Ard3liUnBQQ2Z6OWZFMVVoRmpGSjBJV25CTDRLUHQraFFxTlVKN25LRXd5?=
 =?utf-8?B?OEpyZ1hxdnEzMWRzMW9yMDBxZHloSVN6U2xYanAxTXZicGJSOEU0aWFydFBa?=
 =?utf-8?B?NC9oa0hhaUkrWHRaSHY5TldHR1pZTDhUZ3ZuR3J2L2dnWWZyQ1Ivc0d4emhZ?=
 =?utf-8?B?WmVSdHhRMUpQdWY3QjZoWHVxZWwvNHB0eHlKQzVPTUxhUFF0TWVMeDdmRnJD?=
 =?utf-8?B?RTlGbGxrWWg1U2NudjVmTEpXSG8yQ2dTMDN5ZlowN0Zqd096czBKd0FHdG5F?=
 =?utf-8?B?R2lIYzdXMGd3Q3NhUlE1aENBdzd2OWVnMUo4SmN5a3pvdVA5bXJjZ3FzWFVq?=
 =?utf-8?B?ZDBCQVJKUlJvZEFRWTBSTnNjTmk4ZEZ5VkppQ3c2c09uSXlkSm5Vd0hKYUhk?=
 =?utf-8?B?WXdZb2lCbVJudGliWGtFZmE3WnMxZ1lrY3VxMjZPSDJGTTQwdjdVb2hNTnVt?=
 =?utf-8?B?dFNvbCs0UHFKQ0pnSXgzNTNNMktyUUlPOFFXSVpra2RtQm5pRUlzTVcvWkVJ?=
 =?utf-8?B?MWorL0MycEljNVFFWDVqSEd6NW9JbG9jTHJEUW1xRUVjdWdYbnZ5SjhXWGxB?=
 =?utf-8?B?dEoxSVBMem5oVGJoT3ZPM0ZGTU9XNU1aV2haeEpFTVBnNDlpTU5mM2UwanpS?=
 =?utf-8?Q?ZVgqd3e31/ORHWjSvXqEbe0eCJtnjPT0lMZp+t+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e5ef1b-a187-4e51-0b53-08d934829dc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2021 07:03:04.6025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PdNa4d0Uh7Vp/0Vm6q/40OPag+fgY/OvGYps8Uc3vBrvIOtm3cpTSMQ8fYB5XHv/0sL24AI4ehDDwhnKnoHA/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5676
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+IEhpIEF2cmksDQo+IA0KPiA+ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaHBi
LmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5jDQo+ID5pbmRleCAzOWI4NmU4YjJlZWUuLmNm
NzE5ODMxYWRiMyAxMDA2NDQNCj4gPi0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmMNCj4g
PisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmMNCj4gDQo+IC4uLg0KPiANCj4gPitzdGF0
aWMgdm9pZCB1ZnNocGJfcmVhZF90b19oYW5kbGVyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykN
Cj4gPit7DQo+ID4rICAgICAgICBzdHJ1Y3QgdWZzaHBiX2x1ICpocGIgPSBjb250YWluZXJfb2Yo
d29yaywgc3RydWN0IHVmc2hwYl9sdSwNCj4gPisgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB1ZnNocGJfcmVhZF90b193b3JrLndvcmspOw0KPiA+KyAgICAgICAg
c3RydWN0IHZpY3RpbV9zZWxlY3RfaW5mbyAqbHJ1X2luZm8gPSAmaHBiLT5scnVfaW5mbzsNCj4g
PisgICAgICAgIHN0cnVjdCB1ZnNocGJfcmVnaW9uICpyZ24sICpuZXh0X3JnbjsNCj4gPisgICAg
ICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4rICAgICAgICBMSVNUX0hFQUQoZXhwaXJlZF9s
aXN0KTsNCj4gPisNCj4gPisgICAgICAgIGlmICh0ZXN0X2FuZF9zZXRfYml0KFRJTUVPVVRfV09S
S19SVU5OSU5HLCAmaHBiLQ0KPiA+d29ya19kYXRhX2JpdHMpKQ0KPiA+KyAgICAgICAgICAgICAg
ICByZXR1cm47DQo+ID4rDQo+ID4rICAgICAgICBzcGluX2xvY2tfaXJxc2F2ZSgmaHBiLT5yZ25f
c3RhdGVfbG9jaywgZmxhZ3MpOw0KPiA+Kw0KPiA+KyAgICAgICAgbGlzdF9mb3JfZWFjaF9lbnRy
eV9zYWZlKHJnbiwgbmV4dF9yZ24sICZscnVfaW5mby0+bGhfbHJ1X3JnbiwNCj4gPisgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBsaXN0X2xydV9yZ24pIHsNCj4gPisgICAgICAgICAg
ICAgICAgYm9vbCB0aW1lZG91dCA9IGt0aW1lX2FmdGVyKGt0aW1lX2dldCgpLCByZ24tPnJlYWRf
dGltZW91dCk7DQo+ID4rDQo+ID4rICAgICAgICAgICAgICAgIGlmICh0aW1lZG91dCkgew0KPiA+
KyAgICAgICAgICAgICAgICAgICAgICAgIHJnbi0+cmVhZF90aW1lb3V0X2V4cGlyaWVzLS07DQo+
ID4rICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGlzX3Jnbl9kaXJ0eShyZ24pIHx8DQo+ID4r
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJnbi0+cmVhZF90aW1lb3V0X2V4cGlyaWVzID09
IDApDQo+ID4rICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsaXN0X2FkZCgmcmduLT5s
aXN0X2V4cGlyZWRfcmduLCAmZXhwaXJlZF9saXN0KTsNCj4gDQo+IFdoeSB3ZSBuZWVkIGFkZGl0
aW9uYWwgZXhwaXJlZF9saXN0IGZvciB1cGRhdGluZyBpbmFjdGl2ZSBpbmZvcm1hdGlvbj8NClNp
bmNlIHRoZSBscnUgbGlzdCBpcyBhY2Nlc3NlZCB1bmRlciByZ25fc3RhdGVfbG9jaywgDQphbmQg
aW5hY3RpdmF0aW9uIGlzIGRvbmUgdW5kZXIgcnNwX2xpc3RfbG9jaywNCkl0J3MganVzdCBhIGNv
bnZlbmllbnQgd2F5IHRvIGxpc3QgYWxsIHRoZSBleHBpcmVkICByZWdpb25zLg0KDQo+IEFuZCBJ
IHRoaW5rICJyZ24tPmxpc3RfbHJ1X3JnbiIgc2hvdWxkIGJlIGRlbGV0ZWQgd2hlbiBpdCBpcyBl
eHBpcmVkLg0KT2ggLSBJIGRvbid0IHRoaW5rIHNvLg0KVGhpcyBzaG91bGQgYmUgZG9uZSBpbiBv
bmUgcGxhY2Ugb25seSwgd2hpY2ggaXMgY2xlYW51cF9scnVfaW5mbywNCldoaWNoIGlzIGNhbGxl
ZCwgaW4gaG9zdCBtb2RlLCBhZnRlciBhIHN1Y2Nlc3NmdWwgdW5tYXAgcmVxdWVzdC4NCg0KVGhh
bmtzLA0KQXZyaQ0KDQo+IA0KPiA+KyAgICAgICAgICAgICAgICAgICAgICAgIGVsc2UNCj4gPisg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJnbi0+cmVhZF90aW1lb3V0ID0ga3RpbWVf
YWRkX21zKGt0aW1lX2dldCgpLA0KPiA+KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIFJFQURfVE9fTVMpOw0KPiA+KyAgICAgICAgICAgICAg
ICB9DQo+ID4rICAgICAgICB9DQo+ID4rDQo+ID4rICAgICAgICBzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZocGItPnJnbl9zdGF0ZV9sb2NrLCBmbGFncyk7DQo+ID4rDQo+ID4rICAgICAgICBsaXN0
X2Zvcl9lYWNoX2VudHJ5X3NhZmUocmduLCBuZXh0X3JnbiwgJmV4cGlyZWRfbGlzdCwNCj4gPisg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsaXN0X2V4cGlyZWRfcmduKSB7DQo+ID4r
ICAgICAgICAgICAgICAgIGxpc3RfZGVsX2luaXQoJnJnbi0+bGlzdF9leHBpcmVkX3Jnbik7DQo+
ID4rICAgICAgICAgICAgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZocGItPnJzcF9saXN0X2xvY2ss
IGZsYWdzKTsNCj4gPisgICAgICAgICAgICAgICAgdWZzaHBiX3VwZGF0ZV9pbmFjdGl2ZV9pbmZv
KGhwYiwgcmduLT5yZ25faWR4KTsNCj4gPisgICAgICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJx
cmVzdG9yZSgmaHBiLT5yc3BfbGlzdF9sb2NrLCBmbGFncyk7DQo+ID4rICAgICAgICB9DQo+ID4r
DQo+ID4rICAgICAgICB1ZnNocGJfa2lja19tYXBfd29yayhocGIpOw0KPiA+Kw0KPiA+KyAgICAg
ICAgY2xlYXJfYml0KFRJTUVPVVRfV09SS19SVU5OSU5HLCAmaHBiLT53b3JrX2RhdGFfYml0cyk7
DQo+ID4rDQo+ID4rICAgICAgICBzY2hlZHVsZV9kZWxheWVkX3dvcmsoJmhwYi0+dWZzaHBiX3Jl
YWRfdG9fd29yaywNCj4gPisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtc2Vjc190b19q
aWZmaWVzKFBPTExJTkdfSU5URVJWQUxfTVMpKTsNCj4gPit9DQo+ID4rDQo+IA0KPiBUaGFua3Ms
DQo+IERhZWp1bg0K
