Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B40C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 11:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380040AbiAYLAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 06:00:38 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:30194 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379922AbiAYK6i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jan 2022 05:58:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643108317; x=1674644317;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=61W3dgmjP8/R7celkn4SY3PR/p6uPUOwfYBgfOCCEuM=;
  b=cK9Hn1RMyufndf66pKBHBVVZ7BxS8Qluv6UDOvdORXM8PrygONbL5ATE
   UwhMZVt/GL67YJSVap5auL1ypbbqeRmO3oprzKzhvxP918w1sQJloLLBR
   bTQ9Yr3MmNoEPWQ5ttOqrytA8PE+4aD3p95aN18ZsaIJ8bT3T8DIBKqm2
   8N7xbNCPHJIN1jR6ZdxK2OsnUGBnVjI4rgUTTBZmVAsJDRAQP37eLcqo5
   Ue2Z+G9wWVtZna6omFhfXF7i2SqsOlVYjak+cPY2M8ugpWOnzTEX/2v1u
   ZZqUAFTMjzdz2W+OMdzae5a6QImCw+bywnfZMn7gLmEL5gI6mMvCDKaow
   w==;
IronPort-SDR: vh5+EfgDfyV3rjDnIFg0TTSDH8KXzv+n23j46k/Ia1eokeb8CATb4FV79/f7LzaKag8YCgtgEv
 DDtL5N0XD6be/SD5kogBVXsU9pDVq+yACcYB4NmwNFShkoAFiQSV+kUHy5rdzVJu7924GjxrHh
 jVKjl7wUOERkAjrzoVC1ee3RLLVQKfphWqabqArdER0Ui3kXISA60mmGkwfmIiDQGFCL3A+4oX
 OiDXHRsrOGvVNqk2JIJhTzLuU0c9nn+qB/XsgSzpWDd6v41V4qC25Fp3BxyQ/qM9ZLCdtnIUHX
 shHFnK8Z+jnXcBVxM3B/orQs
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="83589591"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2022 03:58:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 25 Jan 2022 03:58:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 25 Jan 2022 03:58:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NeG9pXN6+QhVeOiJ6Nu6WYuR5909KZDlfxX4O9T8DWkyirz/eP/kV3ilUagHNxr7HQg7f5g5w5MjDm9rus3fUhhzO3hF//uUvtfKIPajBBu3Qj2zFwbkw0cWlkvaptOEsuznXBvFvxOowG1QbWEAFkTjxxWZNm0yjdtig0DwU6T4IuvwP73Dubwimcb+3UrFD9Wi6QWJiuphwJ3lmQVJIYIMiMZdqn3r2K7/eOELq2an2UV1PRma/ewTdYGxhexXI3C7qSByB7fBXP/4qRRJwKLKgwpco6HMeWDo6Q28ZPv6oElru9r494hqLlftPUSEdBrqViEC2ewEWj/dCRPpGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61W3dgmjP8/R7celkn4SY3PR/p6uPUOwfYBgfOCCEuM=;
 b=kGeFNbPeuUif5u4JZSQGv1oFOgTmeOE41mpvvJJKhKZDHkkC9I0CE4M3GNFdYb/BSKCznrmU/Ee+T3swrW5VpQW985qLOp+kQxdls8GqUapMUbHOL+1Vw6LgtfCx5+gJ1JfMOycCWOKIUdtJ8HIViDQcfPhvQCCzQfroBSNcNpAs3PHOZrhLAhuwrUWPwGKqT08UJy6CJFd29gxO4DJC2HgVSr5a9U3c5GMYXZ4kCMYcVkz52YjD7v4LNwy0cW23aZdbzh+sGfYOkygknvHmYwvthLUIFI0ZHmOF3CDKM+Y/NMzfSB4nBF+b85GutfEXV9opJ+K7pk66kFBxgVwvDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61W3dgmjP8/R7celkn4SY3PR/p6uPUOwfYBgfOCCEuM=;
 b=LHmDYJDlG/dQhtUhMLvI4QMrXLqL381XySz0uhPFItqSTcD/IiVhTQVBOIyqRDyElqXgqDGCcbCMSOuf9QV1wDmlL0kioT/LbtaNMWCanCZgiw8pZOR+dVixYpxBYzz4Ni5qS5g+QH56TgwDMA3jk+kbYRvMWKL54rotd0+uCos=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by CY4PR11MB1320.namprd11.prod.outlook.com (2603:10b6:903:2b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 10:58:30 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::f1d9:ed22:d95a:59cd]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::f1d9:ed22:d95a:59cd%3]) with mapi id 15.20.4909.019; Tue, 25 Jan 2022
 10:58:30 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <jinpu.wang@ionos.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>
Subject: RE: [PATCH] scsi: pm80xx: Fix double completion for SATA devices
Thread-Topic: [PATCH] scsi: pm80xx: Fix double completion for SATA devices
Thread-Index: AQHYEWyWtrdnXRVehEWyVddNqe7ubaxzj4FA
Date:   Tue, 25 Jan 2022 10:58:30 +0000
Message-ID: <PH0PR11MB5112675EFFD42B96E559D034EC5F9@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <20220124082255.86223-1-Ajish.Koshy@microchip.com>
 <CAMGffEnD0+X2pYXZ2==DUMt7uYFBRTJTNm7KsyKMd1JyfTr2pg@mail.gmail.com>
In-Reply-To: <CAMGffEnD0+X2pYXZ2==DUMt7uYFBRTJTNm7KsyKMd1JyfTr2pg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a29ecbf3-4aee-43c0-1460-08d9dff19f57
x-ms-traffictypediagnostic: CY4PR11MB1320:EE_
x-microsoft-antispam-prvs: <CY4PR11MB1320194E72849FCB7CAF1597EC5F9@CY4PR11MB1320.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KZmM/H//8zTAMamOe1w6CQVPfJfl9AC7MUAeclajwV5EreFX05LJkfbPPw8wFHpKRM9b8WYVGXGQnRTp3Mb4t1o9EOBtvyTeKkBFe8SKrUMHqZBNYaU66esmr9HmU3rwJqU5Xkvyds0hdnQnSDb2amu0PiX/XlzVgMmhkcg4d6297oKDyn/M5JTkFEJv191Z9NVyVALVzAcLkG7TgSijOdvfJ7FGG+WXq9fAvqFX5WRADeN8VYPthMBdNhnXtWRgHr0iCkeU4huX2SA1I/73jGkNNrh18Y9gOLzct3qBqLb7qVVBCznJ4mfCSFr9T88UCLZwWPMvCoXaHWXl9NBsGHKt8qDizLfyAY0jPk9aU1eUii6084kdIPr7E9F+D1J1J5Thi0GVwGX1DxGmGnrU0zrh0y1RH7ahhqGRTQflJnuirIFwhjbb+Y6gLDCG8xZQoloU6aZQrVzaQ/qjUBlIpJE2cGQlIu3yHvg6KWs9cKEle8Q3nSPlplYs/oV8zHdR/zPDru9LotjvkH58ZWfoaa5Ot+f4F42BiDF9H8J1yx4iDeD5wEocFD5f1/okzu2He2K1Dq6UyhYs/b5j5puXYpKydJVQtKE2zizh1YxQ7wCNJfNnn9ZYk4RsvlALRFSwtf4MyJMQYLqkn4Bye3sk4kwk9D94oARYFD84QqygETu/CZ6Tsvn2rzkUrcfyvVAlTsBi4QQbSE+p3pXTu1HOhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(316002)(186003)(86362001)(55016003)(66946007)(66476007)(122000001)(66446008)(5660300002)(54906003)(38070700005)(38100700002)(9686003)(2906002)(26005)(107886003)(83380400001)(4326008)(8936002)(64756008)(6916009)(66556008)(6506007)(508600001)(7696005)(76116006)(33656002)(71200400001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0llWDg5Q3FqRThKTE5QN1RVcE9zY25MbUVjRnpFNEEydHZXRWtjMkE1OVlq?=
 =?utf-8?B?b0tibTdwcldXamF6ckhLbnFONDJ3TW9GOU9pcnlzQnNDci9kbmU5aGRZSGNh?=
 =?utf-8?B?bDNXS1dJWVo0VlhBZXRYcCt1UUdjLzJoT1hNeGM2S05ja2hDUGkrUFlvZDZh?=
 =?utf-8?B?ZS9PVlNwZFRJeUZNUmhHMzFMM3Y5NkZNaFJlZkpYUUNVY2o2bnhiZTBQOTNT?=
 =?utf-8?B?ZWVMa0s0Wk9od1FGU2lKVUIzVkFDSW5YLzREcHZBbzBUMnIxdUl0OW5iOFNl?=
 =?utf-8?B?N1pURFVURnRTSCsvZEFJMS9mdlFPS0NuWktqSElNSkpuRTVabmxyQ2R1aVdU?=
 =?utf-8?B?Wk5Jdk0xekhWbE02NEphTVVWR3NDU3VkWjVhenpZSFlwTGg0N0FRK2NJSlAr?=
 =?utf-8?B?NGpXK2ZsZ084Y254dEJJVGYyRk9TbDQzTzl1QzBQV29HeVQxVm5BRmFVVVlW?=
 =?utf-8?B?L3FKVnhJbGM2eXpNa2pxd0UxQm4welJnb1FTZWZBZTdjV0VmUUdIY3MrUEQz?=
 =?utf-8?B?cFdlNkRZZlVUcTd4bDRHUlFoRkNBdWN1Wm9kZUk0dURCTHkvNjZFZFU0TC9v?=
 =?utf-8?B?WUtJVGRCcXM5dkVBdU9qbDgvYUsxd3J6MlZPUGZzMHJSWHhiMEQwc3F4S1FR?=
 =?utf-8?B?VUljcWNNazNXZTNjMHU5S1FJZjZkRDNTUEwvaW5ycGw1Zzh0YWpwNGhUMnI0?=
 =?utf-8?B?VG9tSGVhNisyQjBwREFrVTZmbjBHK0M4T3dOaktkRWxqSnZSM3hoVWdsM0pa?=
 =?utf-8?B?R25xblgvR0ZiSHJXcFJPM2QzR1pMcFNTVVJlWFZMa3BETlA4TEgrL2dsUjZD?=
 =?utf-8?B?RDhEckRPZE1OMXJ5S2t5WGt6MnE4MjFzYm9oOGpJMzBrS1Nma3Q4cmdKMFF1?=
 =?utf-8?B?WEZEU0V2djRPKy9lYmlmSjMwZTU1YTRRbU9sdUcxOFVHU00rcHBFTnBMMlFS?=
 =?utf-8?B?aE4rdGZORzNGYnNnL1VnSTVBUXJicmZuRUJjOEErU1JhLzg0TE1ma0hQM1pp?=
 =?utf-8?B?TTZUN3lWa0JEdVhucFlvTmJoL1ZSYXJBcXpYV2VRaVljRldNYy96TGxPZlVi?=
 =?utf-8?B?cWw5dUVPNjlzM2FJYWxFMWNnZEk5NkhpQkJ4WjFQeFVleVJabmVtckpHc2hU?=
 =?utf-8?B?QldlTkc3aUxoRkw4ckU0djhjZDVMaXpPQXFHb3EwSWtwUkp0Unk1SElmRURC?=
 =?utf-8?B?ajkzWlcrSytvWDdIZXRXSHNMelJWMkhxMWF3RlkwNHpLazIyMy9udEFVZ08r?=
 =?utf-8?B?ZlgrcDl0a1pWSVVMMU5ENlpabWoxWkYxMko2bTVUVTBqSlE2c2I5ZG9BSCtF?=
 =?utf-8?B?SGpVN0N5UmxKWjE3NzBMOWw2cHlnWUQ3a1V3cDQ2TkNOTjhCbTluRUdtNmZJ?=
 =?utf-8?B?ZDUxQ3pKUHVqdzgwSk5CalRyb21XK2puNVc4V01lZks0Q1RzSjFjaThWSC9L?=
 =?utf-8?B?djFjZVg5RkpaZWdLZVB2WEQvOXF1aDdFbE80SXJTRWluYkhXVUw0MnJ6SHh5?=
 =?utf-8?B?SW9lUFBvUVp4dWQwc0V0NzVUWjFrOGF1RytCQm9GNXpPQjRsVHgrcGhGaHk5?=
 =?utf-8?B?WFNITmdRY2lodW14Nk1qS2tlUW5YWVJvOTNqbmxQeldkcTZkcVZlS0xORHR4?=
 =?utf-8?B?MWZNbWlOamRGaVRycFRRTnVPRTNTYzMvUjE0d1kzaDhTS3ZFSnFPQXBGK2lI?=
 =?utf-8?B?QVBxb1dtVzlsV25QekZYd3oxUUdYUTE2am4rRG5MWUZnaFhJZkdEUkU0RlVV?=
 =?utf-8?B?OFJoNEcxa01nTGthSDBKYmdtUlhQazNpUU9ROFM1Q0FYV3NvZDAzbEI5UG5w?=
 =?utf-8?B?STdRdExPclRjdTF0YkNwa2FacFEwRGIxdHZNclJ5MCtOOFF3Z3hIUmtKbDhx?=
 =?utf-8?B?eHlDMUgzbjhoakF5RzJIdFh5ekJEYmI4Zko4cHloTDBvQWVTQkF1M3VxUi9N?=
 =?utf-8?B?VjM0OFBPdXc1VkhRUlVIckRORjh0bmZBZThtVG9DU0R3QmxCT25QeFhMV2pC?=
 =?utf-8?B?eE1aQTVqNGM4Qm9ieFp4eDc4YWxFQlNnL2VkZzg0dkp0R0tkdVhmcGxXUU83?=
 =?utf-8?B?R3RBcjFQeDhjY29EVHBJWWxWbDdUUFE2RW56SmRua1pBaDFoUkQrOFJ4Q3Bm?=
 =?utf-8?B?SGltbDl3WVk0TDdtZys3VVZ5MEVsZGNiZ1k3dCsyWXRJcGFkakFCN0h0Nm1i?=
 =?utf-8?B?bTRyUjU0d3Vnb3lNT2R0Z2hIcXAza3E5Sy9JQ29rNDEvRmhnNDh0K0NWUUha?=
 =?utf-8?B?aFQwMnpaZ2JnYkJReVpEUFBIakhnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a29ecbf3-4aee-43c0-1460-08d9dff19f57
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 10:58:30.1782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GZTH+Gv8SqIf92k82fA117dSDjbnyZxTC0ANXRiSX5hp7gcQUUSF/KxGdezLWWTvqL8f1RqNC8nwsTYnJWfUqxkATE5WS2F7vcSUjmLXPD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1320
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+DQo+ID4gRm9yIFNBVEEgZGV2aWNlcywgY29ycmVjdCB0aGUgZG91YmxlDQo+ID4gY29tcGxl
dGlvbiBpc3N1ZS4NCj4gPg0KPiA+IEN1cnJlbnQgY29kZSBoYW5kbGVzIGNvbXBsZXRpb25zIGZv
ciBzYXRhIGRldmljZXMgaW4NCj4gPiBtcGlfc2F0YV9jb21wbGV0aW9uKCkgYW5kIG1waV9zYXRh
X2V2ZW50KCkuDQo+ID4NCj4gPiBCdXQgYXQgdGhlIHRpbWUgd2hlbiBhbnkgc2F0YSBldmVudCBo
YXBwZW5zLCBmb3IgYWxtb3N0IGFsbCB0aGUgZXZlbnQNCj4gPiB0eXBlcywgdGhlIGNvbW1hbmQg
aXMgc3RpbGwgaW4gdGhlIHRhcmdldC4gSXQgaXMgd3JvbmcgdG8gY29tcGxldGUgdGhlDQo+ID4g
dGFzayBpbiBzYXRhX2V2ZW50KCkuDQo+IA0KPiBJcyBpdCBhbHNvIGFuIGlzc3VlIGZvciBTU1A/
IHdoYXQgaXMgdGhlIHNpZGUgZWZmZWN0LCB0aGUgY3VycmVudCBjb2RlIHdpbGwgbGVhZCB0bw0K
PiAody9vIHRoaXMgcGF0Y2gpPw0KPiB3aHkgU0FUQSBpcyBkaWZmZXJlbnQ/DQo+IA0KPiBUaGFu
a3MhDQoNClRoYW5rcyBKaW5wdS4NCg0KWWVzLCBzYW1lIGlzc3VlIHdpdGggdGhlIFNTUCBldmVu
dCBwYXRoIHRvby4gV2UgbmVlZA0Kc2ltaWxhciBjaGFuZ2VzIHRoZXJlIGFsc28uDQoNCk15IHVu
ZGVyc3RhbmRpbmcgaGVyZSBvbiBzaWRlIGVmZmVjdHMgd2l0aG91dCB0aGlzIHBhdGNoLQ0KSGVy
ZSBpcyB0aGUgZXhwZWN0YXRpb24gb2YgdGhlIGZpcm13YXJlLg0KVGhlIGNvbnRyb2xsZXIgc2Vu
ZHMgYSBzYXRhX2V2ZW50IG5vdGlmaWNhdGlvbiB0byBpbmRpY2F0ZQ0KdGhhdCB0aGUgSS9PIGlz
IG5vdCBmaW5pc2hlZCAobWF5IGJlIHBlbmRpbmcgaW4gdGhlIGNvbnRyb2xsZXINCm9yIGluIHRo
ZSByZW1vdGUgdGFyZ2V0KSBhbmQgdGhhdCB0aGUgaG9zdCBtdXN0IHRha2UNCmFkZGl0aW9uYWwg
YWN0aW9uLiBUaGUgaG9zdCBhY3Rpb24gcmVxdWlyZWQgZGVwZW5kcyBvbiB0aGUNCmV2ZW50IHJl
Y2VpdmVkLg0KDQpUaGVyZSBhcmUgY2FzZXMsIHdoZXJlIGNvbW1hbmRzIG5lZWQgc3BlY2lhbCBo
YW5kbGluZyBtZW50aW9uZWQNCmFzIHBlciB0aGUgc3BlYy4NCg0KQnV0IGZvciBtb3N0IG9mIHRo
ZSBldmVudCB0eXBlcywgdGhlIGhvc3QgbXVzdCByZXNldCB0aGUgU0FUQQ0KZHJpdmUgYW5kIGFi
b3J0IHRoZSBwZW5kaW5nIEkvTyBpbiB0aGUgY29udHJvbGxlciBieSBzZW5kaW5nIGFib3J0DQpj
b21tYW5kDQoNClRpbGwgaGVyZSBpbnNpZGUgdGhlIGZpcm13YXJlIGFsbCB0aGUgcmVzb3VyY2Ug
YXJlIGludGFjdCwgdGFnLCANCm1lbW9yeSwgZXRjLg0KDQpOb3cgaW4gdGhlIGhvc3Qgc2lkZSwg
b25jZSB3ZSByZWNlaXZlIHRoZSBldmVudCwgaG9zdCB3aWxsIGZyZWUNCml0cyBvd24gcmVzb3Vy
Y2VzLCB0YWcsIGRtYSBtZW1vcnksIGV0Yy4gYnkgY2FsbGluZyBpdHMgb3duDQpjb21wbGV0aW9u
LiANCg0KU28gYXQgdGhpcyBwb2ludCBmaXJtd2FyZSBoYXMgbm90IGZyZWVkIGl0cyBvd24gdGhl
IHJlc291cmNlcyBhbmQNCmhvc3QgZnJlZWQgaXRzIHJlc291cmNlcyBjb3JyZXNwb25kaW5nIHRv
IHRoZSBnaXZlbiBjb21tYW5kL3RhZy4NCg0KRm9yIGV4YW1wbGUsIGluIHRoZSBjYXNlIG9mIElP
X1hGRVJfRVJST1JfTkFLX1JFQ0VJVkVEDQpzYXRhIGV2ZW50Lg0KSGVyZSBmaXJtd2FyZSB3aWxs
IGtlZXAgcmV0cnlpbmcgdGhlIGNvbW1hbmQuIFRoZXJlIGFyZQ0KY2hhbmNlcyB0aGUgY29ycmVz
cG9uZGluZyBjb21tYW5kIG1heSBnZXQgc3VjY2Vzc2Z1bCBhbmQNCmZpcm13YXJlIG1heSBnaXZl
IHJlc3BvbnNlIHRocm91Z2ggc2F0YSBjb21wbGV0aW9uLg0KDQpTaW5jZSB3ZSByZWNlaXZlZCB0
aGUgc2F0YV9ldmVudCwgd2Ugd2lsbCBjb21wbGV0ZSB0aGUgY29tbWFuZC4NCkhvc3Qgd2lsbCBm
cmVlIGl0cyBvd24gcmVzb3VjZXMsIHRhZ3MsIGRtYSBtZW1vcnksIGV0Yy4gQXQgdGhpcw0KcG9p
bnQgd2hlbiB3ZSByZWNlaXZlZCB0aGlzIGV2ZW50LCBjb21tYW5kIHdhcyBzdGlsbCBwZW5kaW5n
IGluDQp0aGUgdGFyZ2V0Lg0KDQpJbiB0aGlzIGNhc2Ugc2luY2Ugd2UgZnJlZWQgdGhlIERNQSBt
ZW1vcnksIHdoaWxlIGZpcm13YXJlDQpjb21wbGV0ZXMgdGhlIGNvbW1hbmQsIGl0IHdpbGwgZ2Vu
ZXJhdGUgDQpJT19YRkVSX1JFQURfQ09NUExfRVJSIGV2ZW50IChwY2llIGVycm9yIGJhc2VkKSBm
b3IgdGhlIHNhbWUgdGFnLw0KY29tbWFuZCBzaW5jZSB3ZSBhbHJlYWR5IGZyZWVkIHRoZSBETUEg
bWVtb3J5L3Jlc291cmNlcy4NCg0KVGhhdCdzIG9uZSBzaWRlIGVmZmVjdCByaWdodCBub3cuDQoN
CkFub3RoZXIgaW5zdGFuY2UgSSBjYW4gc2VlIGlzIGR1cmluZyBJL08sIGhvc3Qgd2lsbCBmcmVl
IHRoZSB0YWcNCm9uY2Ugd2UgcmVjZWl2ZSBhbiBldmVudCwgc2FtZSB0YWcvY29tbWFuZCBpcyBz
dGlsbCBwZW5kaW5nIGluIHRoZQ0KZmlybXdhcmUgYW5kIHBvc3QgdGhpcyBldmVudA0KaG9zdCBy
ZS1hbGxvY2F0ZXMgdGhpcyB0YWcgdG8gc29tZSBvdGhlciBuZXcgcmVxdWVzdC4gVGhpcyBtYXkg
bGVhZA0KdG8gc29tZSB1bi1leHBlY3RlZCBzaXR1YXRpb24uDQoNClRoYXQgaXMgd2hhdCBJIGNh
biB2aXN1YWxpemUgcmlnaHQgbm93IGFzIHNpZGUgZWZmZWN0cyB3aXRob3V0IHRoaXMNCnBhdGNo
Lg0KDQpUaGFua3MsDQpBamlzaA0KDQo=
