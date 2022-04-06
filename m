Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122A8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 12:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiDFMxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 08:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbiDFMwk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 08:52:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7B8D4444
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 01:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649235296; x=1680771296;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cJuuae0lSesE4iYaUoPw8KMwPByyMhoTkZxtSw9Q0ks=;
  b=Kfoefs1tR3/6YyVGA30kxKwos2bUXjblJrfJxFp7w8XvknMec9jGosSG
   JvCDXnp+C1pcuqVcJIEdGGEmxZGs+SQdNPgVw0ruXm4zScmHcHtrl3ndU
   BmSY4TB/HUMzVZhFg1oE8iwYflY2tumwyt/JmjnBE8JTNckOYEeleDvYQ
   C67+/h36a+HuPcqyKjDLjoDkFs46KAKzNgHtSyG9TjrFeEgoFEFU4UrBI
   jnM9dEkmarQQeFvc9D/rFawI2NE6hrGQCh4KUTWkDGPPCDLvohsmDoyan
   8R4eNSITuzbwdIUpFmvlDFUrpopY2BKD2hTKewlYCkAHXBmAYDJwaT0jw
   w==;
X-IronPort-AV: E=Sophos;i="5.90,239,1643698800"; 
   d="scan'208";a="91445661"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Apr 2022 01:54:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Apr 2022 01:54:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Wed, 6 Apr 2022 01:54:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwtCybzKsDlHc85EbB4xEf15z1xmfNj1VbFxCiCd3umGk/KxnyV0SCGkwJjeB+yv+7L2PmILJ0Wb+odF8AHwhZjX4Rv1a7+ntkA2xbwXYM0FvVT+ZEE2AeQUARP5ULOQEwIgHXIvrU9IIVXiy77f9yffya3nhjxJd6p6D4lsibUzBXV0W/MV7XeX8xYxbQlWZjnUcMPfmygxcddatzdDjw1MQLsw2fdxFWMl+jyXDQwduAOoqLR5cD/oCLQjo5GqP01Ru/I8IaZnATSLzjlaRbRkTeaB+vfaVa173UOb9R9ia/N6+t2F67hiSrmlURPo4eWKLeN8MlzmE94oM7Gxpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJuuae0lSesE4iYaUoPw8KMwPByyMhoTkZxtSw9Q0ks=;
 b=NLRXJicOLYRMG3eeSnxwNeW9pALmCu0KLCOtLs4Lv+pCR9I7bhoIiWhM+HCZmx+6EDRAOPItS0Cjs1fYUIBqEzT1gKvfM2uko9AZQmaPXZ40QWRCjQfwRlxJCvhgWsDtMDYxhGC3UR/eT/MCcy/L58ZawvpDp7PAMs/lUfqFmn8RiUhINMd5CwUnZV2XXTrqs4+F9REQ8fGBCMVmPSVRZ+ddnhrw1XREjtcaWc3g5pla98z5B2pwiK15RfPOiNncXB1hfKnUu6jhgc221Y4p0kF4ugJA08OMZl96E3xy9YWjyihTz4hjD63XgTulfSSzC0f9YKXwJv6wSaTJuaCjVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJuuae0lSesE4iYaUoPw8KMwPByyMhoTkZxtSw9Q0ks=;
 b=bIiDId0lYdKvmj1Uy40FYTOLYE9i3hS8NesAm/32vvBu9BVCRPxkQw6H6YkQKlsBUEZOL6lG3A+n3LZFDcoq55Vt66UafbaQyWb89ZWD1MtWj4LpwAPmmjkZRuoOBh2B4PrySz6pUh9wNT7bEEn76bW2FSw7q7C0ciyzXAx1LfI=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by SA0PR11MB4528.namprd11.prod.outlook.com (2603:10b6:806:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 08:54:52 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::48b9:f92:9375:2983]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::48b9:f92:9375:2983%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 08:54:51 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <damien.lemoal@opensource.wdc.com>, <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <john.garry@huawei.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: RE: [PATCH v2 1/2] scsi: pm80xx: mask and unmask upper interrupt
 vectors 32-63
Thread-Topic: [PATCH v2 1/2] scsi: pm80xx: mask and unmask upper interrupt
 vectors 32-63
Thread-Index: AQHYSWLN5JqtlI57eE2tI9K/DavoPqziiYBQ
Date:   Wed, 6 Apr 2022 08:54:51 +0000
Message-ID: <PH0PR11MB511238FFB6AFDC6E494C82D3ECE79@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <20220405092833.83335-1-Ajish.Koshy@microchip.com>
 <20220405092833.83335-2-Ajish.Koshy@microchip.com>
 <3f94f4e6-762b-d1af-7021-45e5b250ab6d@opensource.wdc.com>
In-Reply-To: <3f94f4e6-762b-d1af-7021-45e5b250ab6d@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2eca35f9-af91-4680-414f-08da17ab1cb4
x-ms-traffictypediagnostic: SA0PR11MB4528:EE_
x-microsoft-antispam-prvs: <SA0PR11MB45287541576E1C7D0FCCD68AECE79@SA0PR11MB4528.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9BjZ5cneBeeh3C5qUXtHs6e4xBNOdlEwO1nc10JyK/QzeqCCwxpoOAISxvUOtif6Kj0/orz3ncORKidfvXdY5Nl6mEbuYudrN4ELkVKrC400cVm1Y0tSRKT4DCsBWr5hX8YORXHay4VnlaPjvjL8Qo7vkGXalJECjc/qSNP3Rv7NDBocSsyvkpi9yffbtDqW9Owq1x7Jf4u1x/HsQ8gPB1E3HSg/Sm4hx/B3Jsmxo1iexx4OdEAB2q8FHxUM2WXC3KlVoL98T0VO3MtGYt0T2Z2pq/BlZ2j2LHQk6r8jZRr7ULihjq6lLD7s2cKa0wMi4V4n63oK/IxZxFbUMqwNCtnkZUoBvpgO8zTbd4WhZ1O0MPJFCPGmADxo8F1r31Rna9S/Yk0dejMAa8RRvaxQiin6Cs2U3P6+s2xR9KsAwKViqVeagrciQ8z/CCjjcnzBpuO9snTGmAeOMcIJAT5Q+52zxpUqBdRkUWdHbgA4Gdwl1qHLavIJnRLATMbb5gMofxXA42QNGvKzS8SSlkFdsKCo9kthbkguwzdR8dpEs/2Whhss388nSJhfy5mz5JLDUmzowS8PisYUWglkSUbj9qJYgAnlLR64RJU3KneDfwEqEi+jbiO+9G9FO+gTi6tyV7hSMuCgAUODaRCdtXpaY9gj+urCNsVStVxu1o9hwfWfRT8OafCiEEQGLul9SGpP63XoLDjBMlzO4+yzXKIhfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(186003)(26005)(38070700005)(38100700002)(122000001)(5660300002)(8936002)(52536014)(4326008)(8676002)(64756008)(66556008)(66946007)(55016003)(66446008)(66476007)(2906002)(508600001)(6506007)(7696005)(53546011)(316002)(9686003)(71200400001)(54906003)(110136005)(76116006)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SndBU0tseGE4REl3dlJ2bUVhSG1uZXVQZUl5bVl5Z1BZdjV4ZXhKMVpqVkdW?=
 =?utf-8?B?SmxIT3YyMG9oZXhoTHBKM3RkSm1MdW1ZRnRDdUFqbDg0emJlR0REWllwU0I4?=
 =?utf-8?B?YTZpMlk5L0FrK3NSWHBmYitGNG5STlU5R0duV0lzUzgyNmlaQVJkQ2gycWZl?=
 =?utf-8?B?ZENFYndLc245MDBNTmFzODc1VDZ2S3pldEVMSlVBb2ZvYzdickQ0eDdPSzM5?=
 =?utf-8?B?bXBKSVVhM05vajFpQkxacUVQWDc4Qm5YbEZIVXFNeEpIeVpHRHNmVTZHM2Z1?=
 =?utf-8?B?TXhMOW81OEJ4Y3N4eENqQUVlTytDR1d4ZjllSDVkTDNnYkh6Z0RINEtJZzZN?=
 =?utf-8?B?WktnMEhDemlKblBaVDlGdWpXajNnMTBoMTdIQmFTSGNDak4rSzA1a1NaWkRu?=
 =?utf-8?B?Snk2MkdlQjVxL3k0OTdhL0JYVktMK1NzQStORExhd3E2UGdvQ3VKNVpYSGxB?=
 =?utf-8?B?TjI1OWlZZG5UL0tuekFSOXZVSVRtbURNWXFhNnZ2Z1g2VFJRR25jN0lveFBx?=
 =?utf-8?B?MWdQMHdDMWRWM2JoY3RXVzY1K3pzR0NTdWh3UjJ2b1RKZ0VLL1VGN2hyc0R4?=
 =?utf-8?B?TXV3VmcrcWtzWTZPSUR5REVSV1pib091TmdhRmV1RzFmRjNhLzFJREpKalBQ?=
 =?utf-8?B?bG9EUHpDZ1g3UDFPdzBvdTlWQ1ZMVlJOSlZrM2lkNGxpZ3pPVUhOWis1Z2M2?=
 =?utf-8?B?dXlNU0ZTSmdpeVRXS1RVZ1hlcFFKdjVmNnlKSjJOSnZ0MFh6UWNUa2lRWk9N?=
 =?utf-8?B?aU9BVDd1UTRBNlFTaEtwdmdCcGV6Q0xGcEM5SFZ4SnJ3YTdwaTVaaS8ySkRP?=
 =?utf-8?B?R1hickFudnFQNUQzZjVjUHZjNXpPT3pSdytRZ2czTzQxV3hSWm9Ha2o2aFBN?=
 =?utf-8?B?Y3YxbmVBcDRCOWo3M3FqemIwQms0dTZhMHI4NFRkVk9uSytTYVJVMEtlTkNo?=
 =?utf-8?B?Y1M0UzluRVVlekFzMlhIYVZvNWQybnZ1WnhCemlweDNBOUhVWDZFbmx1YUsr?=
 =?utf-8?B?WUg0RHlkMytMM0RmYVNGY1FtRm1mM3pYVDRvUDJhQ1E2RndYTWE0Zjd6VkpT?=
 =?utf-8?B?VEdlcEtqSXJnTUlXQ2VtcDcvNmdsQ0FMbmNmU0dwUDUzZ29nUStXTEszeTFW?=
 =?utf-8?B?WXVnZEM0YXJVeFpCY1BSeHVUeFJIWk4wRW55ZUJDd3BpVGU2aXpqelZCeWNM?=
 =?utf-8?B?Z2kyL2g1eWxCYVZvK2o4anNPWktwZlNXSVU5ak1ZeXRrVmR2cExrVkd5WktJ?=
 =?utf-8?B?eTJQWGQ0NFMzUEZ0Z3ZqMVFRVGV0N2ZUY1FiK2w1bkNyUHp3dTIwaFJOU0M1?=
 =?utf-8?B?bGJhVWtEWVRPbnlOVEtMNDlEUUdhNWhyNTBnUENWMm9BVXBRcnppK1dvMnhD?=
 =?utf-8?B?WFZrK09pYy93ZkkvRHY0YnEwaVJqOTRpVllSSXo5YlQzM1E2dVRMUUtXeXQ4?=
 =?utf-8?B?Z3VqNGtEUXdlaXZzbGRTNWthd0NkblRodU14c1JQTmpSMjdXRXlGOHRsM29o?=
 =?utf-8?B?b2h6VGVSWGlCMWZ3K3VsRkw3S1pyaEpvVVVJYW9CNzltYmhZSVVLUHlWdUhD?=
 =?utf-8?B?TDBnRHYyRFprdktBRCs2Y3Bxb1B6cU9KWTVZaXFjelZ0YzllaXdwaThyNWRB?=
 =?utf-8?B?cGRoM3JRZWhXLy8xa0E0MDdXV0VoeDI2SEZFUldWVk15QnJNRG5HRWxHeDNy?=
 =?utf-8?B?cFhNcWZxem0yKzJ4c0dSa0xoSTVLVC9ES0Vib05BVE5JRHcra1FoM296L0h0?=
 =?utf-8?B?NmhodXdaVnFSUzlXR2Nud2Nkb2VDalN0VFB2K0hicE5jelRqYmQzc2t1SVFo?=
 =?utf-8?B?bmJQU3N0MWJPVlllRnYxOFFoSjJkOTNzOEYxT1pHelNyM2lZUlJuTXpBM0RU?=
 =?utf-8?B?aWppeTFRbnJJYmJCNVBWTEZTb285UERkRmZyMWNqL3FsbDZyMEcvSmxpY2pD?=
 =?utf-8?B?QVg2OTBTWC9kem9NSVJpdTR0eFZmQnpZT0VML2lHQVJBa01lK2JNbC9aWGNn?=
 =?utf-8?B?aWFTbW1PSklyWlZTVDAvOG5uSG5GaFRySHJXUmdKMXVMa01nbXdZZVdNdVF1?=
 =?utf-8?B?MUsyelg1Mk1sc0FraFBMaTBZWEoydVRQVCthQ1R1Mmpib3pORXd6ckpuMFEr?=
 =?utf-8?B?T1Q2bHVocUpLdXAxNFFMamdmQ1pmQUZNaGQvQ3g0ck9xQS9OaWF6eWZtYXZZ?=
 =?utf-8?B?WkJSMnpOSVMzVVo5QWI0NmFXQ0xIbXlYN04vM2EyaVQwNldVb0MvSktSUHdy?=
 =?utf-8?B?R1FiTnBGOXhwanQ2TTQ3SFRDZnRiTTJLWlBmQ3VXWkhXNGtTaGFmOFZjQXYz?=
 =?utf-8?B?cC9YNkNhSG0rYXBkNytGQXlDSkM1K1lzRUJZQUVRZkh3NWVBeHEwakdJRC9R?=
 =?utf-8?Q?DhHI4/yFijW5M53E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eca35f9-af91-4680-414f-08da17ab1cb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 08:54:51.3830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d64IknmnX6f3hF9wVREQl2XaU2cnXzbepmE7BsAVMqmOPm0wzZL/HBYhdL2RK230V5ic6+wBR4GOyxp0WQf0cZnthncI7wAl+mXUoUzACcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4528
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmsgeW91IERhbWllbiBmb3IgeW91ciBjb21tZW50cyBiZWxvdy4gV2lsbCBtYWtlIGNoYW5n
ZXMgaW4gdjMuDQoNCj4gT24gNC81LzIyIDE4OjI4LCBBamlzaCBLb3NoeSB3cm90ZToNCj4gPiBX
aGVuIHVwcGVyIGluYm91bmQgYW5kIG91dGJvdW5kIHF1ZXVlcyAzMi02MyBhcmUgZW5hYmxlZCwg
d2Ugc2VlDQo+IHVwcGVyDQo+ID4gdmVjdG9ycyAzMi02MyBpbiBpbnRlcnJ1cHQgc2VydmljZSBy
b3V0aW5lLiBXZSBuZWVkIGNvcnJlc3BvbmRpbmcNCj4gPiByZWdpc3RlcnMgdG8gaGFuZGxlIG1h
c2tpbmcgYW5kIHVubWFza2luZyBvZiB0aGVzZSB1cHBlciBpbnRlcnJ1cHRzLg0KPiA+DQo+ID4g
VG8gYWNoaWV2ZSB0aGlzLCB3ZSB1c2UgcmVnaXN0ZXJzIE1TR1VfT0RNUl9VKDB4MzQpIHRvIG1h
c2sgYW5kDQo+ID4gTVNHVV9PRE1SX0NMUl9VKDB4M0MpIHRvIHVubWFzayB0aGUgaW50ZXJydXB0
cy4gSW4gdGhlc2UgcmVnaXN0ZXJzIGJpdA0KPiA+IDAtMzEgcmVwcmVzZW50cyBpbnRlcnJ1cHQg
dmVjdG9ycyAzMi02My4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFqaXNoIEtvc2h5IDxBamlz
aC5Lb3NoeUBtaWNyb2NoaXAuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc3dhcyBHIDxWaXN3
YXMuR0BtaWNyb2NoaXAuY29tPg0KPiA+IEZpeGVzOiAwNWM2YzAyOWE0NGQgKCJzY3NpOiBwbTgw
eHg6IEluY3JlYXNlIG51bWJlciBvZiBzdXBwb3J0ZWQNCj4gPiBxdWV1ZXMiKQ0KPiA+IC0tLQ0K
PiA+ICAgZHJpdmVycy9zY3NpL3BtODAwMS9wbTgweHhfaHdpLmMgfCAzMSArKysrKysrKysrKysr
KysrKysrKysrKysrLS0tLQ0KPiAtLQ0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDI1IGluc2VydGlv
bnMoKyksIDYgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3BtODAwMS9wbTgweHhfaHdpLmMNCj4gPiBiL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3
aS5jDQo+ID4gaW5kZXggOWJiMzFmNjZkYjg1Li4zZTY0MTNlMjFiZmUgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgweHhfaHdpLmMNCj4gPiArKysgYi9kcml2ZXJzL3Nj
c2kvcG04MDAxL3BtODB4eF9od2kuYw0KPiA+IEBAIC0xNzI4LDkgKzE3MjgsMTcgQEAgcG04MHh4
X2NoaXBfaW50ZXJydXB0X2VuYWJsZShzdHJ1Y3QNCj4gcG04MDAxX2hiYV9pbmZvICpwbTgwMDFf
aGEsIHU4IHZlYykNCj4gPiAgIHsNCj4gPiAgICNpZmRlZiBQTTgwMDFfVVNFX01TSVgNCj4gPiAg
ICAgICB1MzIgbWFzazsNCj4gPiAtICAgICBtYXNrID0gKHUzMikoMSA8PCB2ZWMpOw0KPiA+DQo+
ID4gLSAgICAgcG04MDAxX2N3MzIocG04MDAxX2hhLCAwLCBNU0dVX09ETVJfQ0xSLCAodTMyKSht
YXNrICYNCj4gMHhGRkZGRkZGRikpOw0KPiA+ICsgICAgIGlmICh2ZWMgPCAzMikgew0KPiA+ICsg
ICAgICAgICAgICAgbWFzayA9IDFVIDw8IHZlYzsNCj4gDQo+IE5pdDogRHJvcCB0aGlzLi4uDQo+
IA0KPiA+ICsgICAgICAgICAgICAgLyp2ZWN0b3JzIDAgLSAzMSovDQo+ID4gKyAgICAgICAgICAg
ICBwbTgwMDFfY3czMihwbTgwMDFfaGEsIDAsIE1TR1VfT0RNUl9DTFIsIG1hc2spOw0KPiANCj4g
Li4uYW5kIGRvOg0KPiANCj4gICAgICAgICAgICAgICAgIHBtODAwMV9jdzMyKHBtODAwMV9oYSwg
MCwgTVNHVV9PRE1SX0NMUiwgMVUgPDwgdmVjKTsNCg0KT0sNCg0KPiANCj4gPiArICAgICB9IGVs
c2Ugew0KPiA+ICsgICAgICAgICAgICAgdmVjID0gdmVjIC0gMzI7DQo+ID4gKyAgICAgICAgICAg
ICBtYXNrID0gMVUgPDwgdmVjOw0KPiA+ICsgICAgICAgICAgICAgLyp2ZWN0b3JzIDMyIC0gNjMq
Lw0KPiA+ICsgICAgICAgICAgICAgcG04MDAxX2N3MzIocG04MDAxX2hhLCAwLCBNU0dVX09ETVJf
Q0xSX1UsIG1hc2spOw0KPiANCj4gQW5kIGhlcmU6DQo+IA0KPiAgICAgICAgICAgICAgICAgcG04
MDAxX2N3MzIocG04MDAxX2hhLCAwLCBNU0dVX09ETVJfQ0xSX1UsDQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAxVSA8PCAodmVjIC0gMzIpKTsNCj4gDQo+IFRoZW4geW91IGRvIG5vdCBu
ZWVkIHRoZSBtYXNrIHZhcmlhYmxlLg0KDQpPSw0KDQo+IA0KPiA+ICsgICAgIH0NCj4gPiAgICAg
ICByZXR1cm47DQo+ID4gICAjZW5kaWYNCj4gPiAgICAgICBwbTgweHhfY2hpcF9pbnR4X2ludGVy
cnVwdF9lbmFibGUocG04MDAxX2hhKTsNCj4gPiBAQCAtMTc0NywxMSArMTc1NSwyMiBAQCBwbTgw
eHhfY2hpcF9pbnRlcnJ1cHRfZGlzYWJsZShzdHJ1Y3QNCj4gcG04MDAxX2hiYV9pbmZvICpwbTgw
MDFfaGEsIHU4IHZlYykNCj4gPiAgIHsNCj4gPiAgICNpZmRlZiBQTTgwMDFfVVNFX01TSVgNCj4g
PiAgICAgICB1MzIgbWFzazsNCj4gPiAtICAgICBpZiAodmVjID09IDB4RkYpDQo+ID4gKw0KPiA+
ICsgICAgIGlmICh2ZWMgPT0gMHhGRikgew0KPiANCj4gVGhpcyBpcyBub3Qgc3ltbWV0cmljIHdp
dGggcG04MHh4X2NoaXBfaW50ZXJydXB0X2VuYWJsZSgpLiBEb2VzDQo+IHBtODB4eF9jaGlwX2lu
dGVycnVwdF9lbmFibGUoKSBuZWVkIHRoZSBzYW1lIGNhc2UgdG9vID8NCg0KSSBiZWxpZXZlIGl0
J3Mgbm90IG5lZWRlZCByaWdodCBub3cuIA0KDQpGb3IgaW50ZXJydXB0IGRpc2FibGUgSSBjb3Vs
ZCB0byBzZWUgdGhlIGZvbGxvd2luZyBlbnRyeSBwb2ludA0KUE04MDAxX0NISVBfRElTUC0+aW50
ZXJydXB0X2Rpc2FibGUocG04MDAxX2hhLCAweEZGKQ0KaXMgdXNlZCBpbiBwbTgwMDFfcGNpX3Jl
bW92ZSwgcG04MDAxX3BjaV9zdXNwZW5kLA0KcG04MDAxX3BjaV9yZXN1bWUNCg0KQnV0IHNhbWUg
aXMgbm90IHRoZSBjYXNlIHdpdGggaW50ZXJydXB0IGVuYWJsZSBmdW5jdGlvbi4gSSBkb24ndA0K
c2VlIGludGVycnVwdCBlbmFibGUgYmVpbmcgY2FsbGVkIHdpdGggMHhGRi4NCg0KPiANCj4gPiAg
ICAgICAgICAgICAgIG1hc2sgPSAweEZGRkZGRkZGOw0KPiA+IC0gICAgIGVsc2UNCj4gPiAtICAg
ICAgICAgICAgIG1hc2sgPSAodTMyKSgxIDw8IHZlYyk7DQo+ID4gLSAgICAgcG04MDAxX2N3MzIo
cG04MDAxX2hhLCAwLCBNU0dVX09ETVIsICh1MzIpKG1hc2sgJg0KPiAweEZGRkZGRkZGKSk7DQo+
ID4gKyAgICAgICAgICAgICAvKiBkaXNhYmxlIGFsbCB2ZWN0b3JzIDAtMzEsIDMyLTYzKi8NCj4g
PiArICAgICAgICAgICAgIHBtODAwMV9jdzMyKHBtODAwMV9oYSwgMCwgTVNHVV9PRE1SLCBtYXNr
KTsNCj4gPiArICAgICAgICAgICAgIHBtODAwMV9jdzMyKHBtODAwMV9oYSwgMCwgTVNHVV9PRE1S
X1UsIG1hc2spOw0KPiANCj4gU2ltaWxhciBoZXJlLCBubyBuZWVkIGZvciB0aGUgbWFzayB2YXJp
YWJsZS4NCg0KT0suDQoNCj4gDQo+ICAgICAgICAgICAgICAgICBwbTgwMDFfY3czMihwbTgwMDFf
aGEsIDAsIE1TR1VfT0RNUiwgMHhGRkZGRkZGRik7DQo+ICAgICAgICAgICAgICAgICBwbTgwMDFf
Y3czMihwbTgwMDFfaGEsIDAsIE1TR1VfT0RNUl9VLCAweEZGRkZGRkZGKTsNCj4gDQo+ID4gKyAg
ICAgfSBlbHNlIGlmICh2ZWMgPCAzMikgew0KPiA+ICsgICAgICAgICAgICAgbWFzayA9IDFVIDw8
IHZlYzsNCj4gPiArICAgICAgICAgICAgIC8qdmVjdG9ycyAwIC0gMzEqLw0KPiA+ICsgICAgICAg
ICAgICAgcG04MDAxX2N3MzIocG04MDAxX2hhLCAwLCBNU0dVX09ETVIsIG1hc2spOw0KPiANCj4g
QW5kIGhlcmUuDQo+ICAgICAgICAgICAgICAgICBwbTgwMDFfY3czMihwbTgwMDFfaGEsIDAsIE1T
R1VfT0RNUiwgMVUgPDwgdmVjKTsNCg0KT0sNCg0KPiANCj4gPiArICAgICB9IGVsc2Ugew0KPiA+
ICsgICAgICAgICAgICAgdmVjID0gdmVjIC0gMzI7DQo+ID4gKyAgICAgICAgICAgICBtYXNrID0g
MVUgPDwgdmVjOw0KPiA+ICsgICAgICAgICAgICAgLyp2ZWN0b3JzIDMyIC0gNjMqLw0KPiA+ICsg
ICAgICAgICAgICAgcG04MDAxX2N3MzIocG04MDAxX2hhLCAwLCBNU0dVX09ETVJfVSwgbWFzayk7
DQo+IA0KPiBBbmQgaGVyZS4NCj4gICAgICAgICAgICAgICAgIHBtODAwMV9jdzMyKHBtODAwMV9o
YSwgMCwgTVNHVV9PRE1SX1UsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAxVSA8PCAo
dmVjIC0gMzIpKTsNCg0KT0sNCj4gDQo+ID4gKyAgICAgfQ0KPiA+ICAgICAgIHJldHVybjsNCj4g
PiAgICNlbmRpZg0KPiA+ICAgICAgIHBtODB4eF9jaGlwX2ludHhfaW50ZXJydXB0X2Rpc2FibGUo
cG04MDAxX2hhKTsNCj4gDQo+IA0KPiAtLQ0KPiBEYW1pZW4gTGUgTW9hbA0KPiBXZXN0ZXJuIERp
Z2l0YWwgUmVzZWFyY2gNCg==
