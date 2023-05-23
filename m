Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FE7C7EE26
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 09:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbjEWJSS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 05:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236324AbjEWJSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 05:18:08 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BAB1BD;
        Tue, 23 May 2023 02:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684833472; x=1716369472;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=kpVFtxrAsBKi4xB4hO+jy9ayRPvMTGJ65a6Nq/cHffbEVnnxFwIw9CFj
   HlTXE1k24GXge3tlHTG9CCH+qZmt6rMdNr0ZbgdrGoA2t8bWJNIVvcV/4
   WwihIssmMFRf0GzMQD5llWsHbpXawW14At9ALCcDl5HPHAqZFw1zn0Ktp
   DkfdPBdR0F1OPcPBvPlo5ZM9SgckBj8OvUX43t7Y9op4tcL3h51bBOjGF
   BCpQBjqMQmfuzZyFaYsIcfbQP9nzlMPnmPDvLsaLRQlzoIz3OE0wRn97m
   OHzX1g+HAzQ1OioOkaNZVGWkc2rpoqf0m1VCRrRL/mutRdDOY2ZATyIzu
   g==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681142400"; 
   d="scan'208";a="236371757"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2023 17:17:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNP2jtaErpgznTKp5g15b9j5oycRweBoropWEInfFvn/YN6DmzNzlj4E+iSmYc8drgZt6/GdP/ppOzmJoUa8fXYuQ1Hg6sPtQNDdTv8AGzcWTrOu8AjHxUqrD3tNfUEl0B/ZUnWdOdpW2lOSNYv1CukyMClbTkMJEHMS4e5rqn/f3aOGei1AXmCpOypsQl2teNQMsBO5T3RnUHWubrimNPXb+DEbu6rtSNZ5ekSE4dAOm9HF2J+2uXeonWOMQ8cpeyHtiteS9ZQPdF0HCvkADzttDBI8bPuHR7Jh6Hjzp6MiBe0iPywih84j3rFq25WcSfnQ7Jvf+08e3JdMeF7d/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=b8/ystGQYMK6Aqjnvo9M3iUUKXnUXoNhUAEa/+sde4ITLWwkSPmqgwdwYPmIzYgNTwpy42aKmfRd/4PBsgWp7o8SpFTLzPrQUoeL54piD3z40i+McCeoJ1JPtPn2ZASJJbXLx1MLhLMLyHzOfi/Q5LDK8KqsmpHvs6KE/wsOBRbnakLFVgAPswkikoOb3lXCiMTPhRfxneQWiQb8DBM0BPpRfL9cZqJ9CUl9fnVd9oqkbVE7/UD+8RaahPlyQ1jkKP32VtKTlBe+OP+VgsO/2ZpPXGv3y0/kJAd9reumkjl2Xx1D9lyfrlBKmoY76BhcxqCvRXJeVekeCeHJdReq1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=Hc9t4FTk+5EUr6xXlmEopotUZvUb9e6LA2NlyJcdwe4ro7svfjur6w64urRGoxRgKGqokE9wAcwFLt2J84o1zENdExgJwdTqJ4Mvq2IjHZIFjxjLGnOGXlQy5ZxVUJUjvOQaj6LltVmEXLPWEsDzU5EMkC5QckCYreYyjCF9sKw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7399.namprd04.prod.outlook.com (2603:10b6:510:17::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 09:17:48 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 09:17:47 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Chaitanya Kulkarni <kch@nvidia.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests v2 1/6] common/rc: skip module file check if
 modules path does not exist
Thread-Topic: [PATCH blktests v2 1/6] common/rc: skip module file check if
 modules path does not exist
Thread-Index: AQHZd2vaX1oRjyfaXUCWXao529XwJq9nwAiA
Date:   Tue, 23 May 2023 09:17:47 +0000
Message-ID: <fe99ab7a-be7d-d350-8f7e-2e3c8ee47dc5@wdc.com>
References: <20230425114745.376322-1-shinichiro@fastmail.com>
 <20230425114745.376322-2-shinichiro@fastmail.com>
In-Reply-To: <20230425114745.376322-2-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|PH0PR04MB7399:EE_
x-ms-office365-filtering-correlation-id: 495348d7-1fbd-479e-b58e-08db5b6e9351
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yGWvGnCrtDJ68cxdbj+KExswZv/E9/f8xaxwC8MK7Cmg5y1YI68VukagNUJj4OLoEjp/Gm2dq8O1mrvaMIcHb+UzbbP6O6JCWvYWdb1Jl4mlNZWqWjWY6qGyuS0ozUo4B/yUohRfP9DB1TdbolNXSi2pn7dzJgB/BJZcD2+zq50fbxLHxwHAc31e49PJP+CGIYgFqvXH+ZccmpdQKpN7VOcwdVYNs1avYaWJg/z0hmFRJYOOLs3EoJGNTVobwbK5AfXmVHBeyd0ZnB7TL4BXxzt7ptzbgJiX8U8XAMbafCUlHnJhBGmZeyFhmgpz+zUE1z+l7GtQRJXvubs7/DujE9GsWs8gg15ijv+RK9GFrZp24B4RLYQDmjQcAw0a061AK6cC2XA3c0GfG+LYozYnHIQ8/fkZeMOroOQCNJGbKErN3XjNLhZvscjZSATXnqcegYAMr2yjDvodeoU3/nGO3DGUUrqkAwGpfhLPmUu3CmMtCyk/50PLjFXOuVYD9XuymSNLcoV/hHW7JD69OhBotbd/+u7Mo8YISlc8Yazr3xQw0dKFDxmHT3cANWns8KNYqz9c0iMm5tyU1AiPah6y89KTSlKdB9AG2bQHU1VkCEyhfLfHog9AbBu77mbwxNIS8DxPpdCCU2Qy2C9k4BcXgaTQgBgLnYc0sA8UpdTWr3XUdJuJF5stpQJimjokNhCB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199021)(8936002)(8676002)(5660300002)(186003)(4270600006)(6506007)(6512007)(122000001)(31696002)(86362001)(2616005)(38100700002)(38070700005)(82960400001)(71200400001)(41300700001)(91956017)(64756008)(6486002)(558084003)(66446008)(66556008)(66946007)(66476007)(76116006)(316002)(4326008)(36756003)(478600001)(110136005)(54906003)(2906002)(31686004)(19618925003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZG5wcWlMTmlTM0k5SXBtamVWblB6Z05wR283N3M5Nnd1bG9VWE9qS1ErbG80?=
 =?utf-8?B?UmxIVnhXWEZBSzJlc0ZJYzlLOXc0cG4zcWhNaTVaaDdDMlFzWkxHYjRXTFI5?=
 =?utf-8?B?R2cyWmJwckNLanI0U25scWQ0ZjJlSldzeW1DTkVCMlc2ZUJ5bzcxS204Y3J5?=
 =?utf-8?B?VEcyeWZjZndhMmJ4aWlRRnZTaFVNb3R0eG83RmU4NFlCQ0JnZkxCRWFIeFo0?=
 =?utf-8?B?TVdYczNsMTBaMG90d2V6THVNT21QLzg0bmEvaTgyajhlWjM2Nm9yNW1OTGhy?=
 =?utf-8?B?bEsxSXlyMmE4dnBqQUFValUxYzluNThwVEpJbXdPSE1xK0M4Si9jOEZPdDhF?=
 =?utf-8?B?cmI3SmQwWkluWDRrVXdwWHFUWEttUTNKUHNObXFHYzlWdTNheEZYNXNUVUlt?=
 =?utf-8?B?eWdrQSs0dndFM3puejZxdG5OVUgycjZnWFJseS9xU1F5d1d5a0lCOGc3ZGIy?=
 =?utf-8?B?UlYzV2VTRXBScUNrdzUwQUJBcEFFSjZZNmFWbExWRFF4azd3Qk5kNmNtdjBL?=
 =?utf-8?B?V0pjNG9tdDBSVDRKZlFIQVV3TmNCaTBvRHJKcHp5WGJoa2t0SXU0QU1EMkg3?=
 =?utf-8?B?WDVPS2dOYWxVYWFmRHJMamgxYWgzbXVRRWRGc3BKSVlqRit3YndObzdDVE1j?=
 =?utf-8?B?dTZEYU9MVUkxd0hmTWc0enVkTGtrQ1Q3QzdUc2dnWUpvY3U3RjJqZjF1VG5t?=
 =?utf-8?B?Rk02STk0RkRTaXZCbEQ4dlZhY2VMc0FVcTlzL3d5dWFidmxlRTRTT0l3Uzk1?=
 =?utf-8?B?Nnc4T0NmVldlUUFUUTM5amdLWGw0V25UWVFrY1lpT0x0emVrQ1FSVWEwakpT?=
 =?utf-8?B?aE1mTjlvQ01MVTlHSTVwbDB3c0VuQ2FkMzV0ZjBWc2tLQlV5K0lHZk1nWVc5?=
 =?utf-8?B?YXp5ZTNlaVcxWWcyY0g1eFA0Rjc3OGFocTJ0MFBhS0NYYXB3Q1p3VkZUeUNN?=
 =?utf-8?B?Qnp5RHdLZkVBSjdJbFlYSnpqNlVBMzJlalpMY0FOdG5mVEtwRDMxWEhScFJv?=
 =?utf-8?B?elZTcGdUbmZWc0ZkRHJPdUU4bUhpeWRLdm43MHgvcFhxUk9UYmNENkg3YXFL?=
 =?utf-8?B?c3NRMWJyUHdWcThVelA5OWRUSllJVVd0YnpSaFNCemswZ0pYYm9oMDNDUGY5?=
 =?utf-8?B?S0VZNG93R0owUmxZNkpIV2kzQ1NVWnQyczlBU0x6T1ZUSmJPTmY5YlBqdEVI?=
 =?utf-8?B?dTZBSGpwYmoxeUFMSW83cENISzhGdnQxdG1nSkFyM1hxVjRMcnMwUTFVVlNL?=
 =?utf-8?B?dUVrSjdwK0dlbzNQeCs3bzlwVEgreFNUaGpMYkxRdkQ4TlUxK3QvcTEyQ1Rx?=
 =?utf-8?B?V1o0YVRaMGh3Nk1HL2kxU1E0bXVlcHI4RDMwR3pzbEhtQjU1K2JHVmRPTXZq?=
 =?utf-8?B?N2pJZjMzdVBLWVY1R2NoRDF1Q09wS1Y5Yk9Fa243NzV3VHRWRzNHLzNIWUUr?=
 =?utf-8?B?dmRCQVJ5K1ZidTNMQnNWMjVUM1IrYlVkSHhCcWFKL2I2VkM2aTlMSktDbjhm?=
 =?utf-8?B?REJDWElGd1lIZERaZkp2YjBma0IxeDFZREx6c2lLbmVuSGpRZWduZE14citi?=
 =?utf-8?B?UnFjK2g2Mk9yRm1LRWR6aFZQTWNjQ0w1bmFhaTFhakl5QklrRnVqdDBzSjlE?=
 =?utf-8?B?cGhNYTYzc1oxYUFFSi9mZHg4eXhZMFhLQnJBcWE2bWRQV0MxZ21Eai82TExV?=
 =?utf-8?B?KzVlU3VqS1ZqSkFadjZMcTEzcnFwSW9rYnNkakdWUFk2LzVKa2NoQ1ovd2wv?=
 =?utf-8?B?WnVxSi9LMGdHOXI5SmhQOVp3M1k5TGJYdWd2OTVTTXhoS3dMT05seTZVd0J1?=
 =?utf-8?B?eXgvcjM2NFkyd2JlV3RoeWRoNDhuRVZreHU1dTdpVnFyMWRsRkdxWFpiZlBS?=
 =?utf-8?B?QUliajFGVFE1YnRTSUc0N1QzL0c2V3cvTjdlc016dEhyb0hSY28wSUd3ZElp?=
 =?utf-8?B?dDAwMFQ1WHJBckFEUTNMRWJsWmRZdTROQ3hQRFNlM3lnM3FicjN1MDlld2Rk?=
 =?utf-8?B?ajNaaVF6SHFwQlcyam9FM0lteEdPbnZhZzJ4L1hYZ3VoOVdRTVlVOWVSRExy?=
 =?utf-8?B?UldhNmVIL2R6cWx5YVdlOWlOMzZVKzNTOStqYTQ1T0xZVmZtYkhQSzh5MHVt?=
 =?utf-8?B?S3FLOU9NYk9Va243Sk5POTNmWGo1ZWJ1NlZaYU9VSWFqTHVFeTM5ZnpJRmZ1?=
 =?utf-8?B?cjlRay9pd3lmWUZXZHpTUlJEanRIVVRCdHhvL0tiVDUwTW1GUkxONXYrMnIv?=
 =?utf-8?B?blY2Y05GeWkwTTZka1A4L1VNLzdnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3EA057C8831117489A6E8872EC45768C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: V5PElIYuyfqKH/LHhinAJWAyHf7XrEwhq9CaaMYyTI4FS0VoVDvWdg+eS9gLoADjkNAnhYQJjMxQNixvjYxvcK9Xc2tQb8VmxW5e1YgQ/SLLz2O3GaHDx3KWQs5+yOcRvhq1f+dEXXpAg/mNwiqBIj36FUmtcE5uXtI78bOiBMX8iCSTEbSbqa1tpoptp7smmmc3od6x0d2ei1fWFd9giF4Pzokg0RrkqSoZufShvrP+Q/ng9DJlh2sGZ9Y4S9Bf5UGH4MXaZLh6pCc9lreyCYZqCi4vQcdT2Hs/M64boWNpbcbwNJmkGdwsBnpaqKrZXr4xQKZt8CGkOo4zFEy8SKI3Mls4wkqUiuXPXiO0gluFM2UBVEV+BAzdKElXmU23pQt5IkhLfdOKPNu3KXKULly19e8vlycNr6CdshPUZT6IOGQb3IGDGM5EU+F95O1Ww5sMQzDmItrNDjOmVYYf4SRnP6vukxBv14NwFIsZ/WkYn7esNMsw9prGPrEqQw2/TMf71JumaFjjsU+scT/a9jPE+C8QnZSb6d7Z1iexW0b15IZlh/zy34IPOzJtK9bHLCDV51/EnlW6dzUs65pqTadl8d3BlJ9qOKE+py9LiMO3lZ4OsP4qzSz2FAxi8J3rC+RR5B0a7uZGrgxJYPnCKlcPvIlNfjRPPbpWUWfntBLHOhkrBV3VpUAdB4Ee9p27UGfHlcEyFWmbomp9i+0iV2EVTpch33zbmcETkt/J69NnRUN+bDveg8orQ2tYJMN6ELl5Pv7vuEnfJJtmoLgOArRK21DeA+CohondU3GSprPPNV1TcfqQku/aLR4/fVbNa0tJjx8Hn2u984gX/bClog==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 495348d7-1fbd-479e-b58e-08db5b6e9351
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 09:17:47.8732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BHUj1DzKAhvTDwlW9KN0z2C5B1lkT9pvh4ZJa3bxFOaRR2WjA3J2XtNJZFJXvVqyiF4oKhDIk2E1550lF+6ArNkt9DreKpxZq2myqQxw8CY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7399
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
