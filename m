Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F980C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Nov 2023 02:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbjKCCYd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Nov 2023 22:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346197AbjKCCXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2023 22:23:44 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DF6125
        for <linux-scsi@vger.kernel.org>; Thu,  2 Nov 2023 19:23:37 -0700 (PDT)
X-UUID: f4cb700c79ef11ee8051498923ad61e6-20231103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=i4GVunw0aLVYj13xBerZW1+crcQz749oKma5jQCsfEQ=;
        b=e2LeaNy1IfFK3c6vcl/J3ZZLSE9LUzXCP1uNw0d3OVOqcrzphy6kuaLfgDFnWLk5cPmVmG/KbZvIdU7toCn2jx4UoIWzgOfhSnUlKHhFYMs2UHragS0FhtVFPWeCoKEw0KSqsxLDjCY0d918h6CSCelNUoB/ddn/m7Zywlymi8k=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.33,REQID:cfcb2eed-8017-4a77-aaae-62007e0eb39f,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:364b77b,CLOUDID:e0c518fc-4a48-46e2-b946-12f04f20af8c,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: f4cb700c79ef11ee8051498923ad61e6-20231103
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1495344560; Fri, 03 Nov 2023 10:23:20 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 3 Nov 2023 10:23:19 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 3 Nov 2023 10:23:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLNa7vWgi2io+hcjFygZlm90Waa2JQePJk2+G8C0pLbHdi1DHLgKTfiGkNWHCoodDdQuh0l7B/Grzlwt87rfHtc2wF+bhJsu3mKbOKKkC3CWhgYCPVQPktEVeK4CJ5K5icBE0c92uqhjPQjxVnODJ3C/p57w3uwXQ3/Shqy98K9PjyHU1FKsMQaRNqTSJEFKq92fqx04PjOHixF50BhIx23ymMoU/KiLbZ3q3W+8D8dd4XDD+Sckzh6Xx4qAg4bhDUROF2rIuqNv/GKmsD64tCGKtI8GATNfNx1DFgfQ90h56kNEgxZh7wG5GYy7lMCcaxMdx09HaiAEm0Ykq8z3qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4GVunw0aLVYj13xBerZW1+crcQz749oKma5jQCsfEQ=;
 b=RaCS89lVvwJ1bJeyd92tbWRb0LRutW+pwwq+TClCDTTmyANkNkpd8FS/9OuzR8mzO0CEKyj2g+h60jcWEMzzLdVhsHUQI6oDrbvqDsynAJc0gxUunvqGjHFij99ppW5vDWodIOFmxCRfxk66JfCY8Pi88NmBQbOaYMkjZQiombjdN0JTys/o2xjyFN9/52zri7bknXA3AwLuwaZjdfjnG6Tp9N4hE/nbwOSLYHm6EovAh1C+p2XGu8OLiIOqAhNWPGpsQiXg/cH406ExkWsomhwyJ8L/a33alZAwXgNPHFAMSamGfYVewVFrhlcEY8vSqG1U/FiOHz7xR3+d/vrpuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i4GVunw0aLVYj13xBerZW1+crcQz749oKma5jQCsfEQ=;
 b=opCFZKeOz/cuhSpNCI7fef2dN/q7Cihga0jShV+987bChQLU0UZ8crr9l+0LvQs+YjmqPtypHAWLjg1S9hnjkGZIOAMwoy/hBiroZlbkrTLAf6bnUb8/EfNwF00r4e/37mVnO/96Lg+HoCzRAEerlWv8TiLQEWqrKMadTyLr2Qs=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR0302MB5362.apcprd03.prod.outlook.com (2603:1096:820:40::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Fri, 3 Nov
 2023 02:23:02 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::7326:baa6:dc8f:dec8]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::7326:baa6:dc8f:dec8%3]) with mapi id 15.20.6954.021; Fri, 3 Nov 2023
 02:23:01 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>,
        =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>,
        =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
        =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
        =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: fix racing issue between ufshcd_mcq_abort
 and ISR
Thread-Topic: [PATCH v1] ufs: core: fix racing issue between ufshcd_mcq_abort
 and ISR
Thread-Index: AQHaCLGs15USPRn4k0iVCY5EmXuIgrBn5/KA
Date:   Fri, 3 Nov 2023 02:23:01 +0000
Message-ID: <f9fd6c96fe9c2eee03e81c583bd31902440d3366.camel@mediatek.com>
References: <20231027084329.4067-1-peter.wang@mediatek.com>
In-Reply-To: <20231027084329.4067-1-peter.wang@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR0302MB5362:EE_
x-ms-office365-filtering-correlation-id: 14e23a45-7267-4526-d8b2-08dbdc13cdd7
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZDvVFRabslsZdxZnppNnqnAU7Mgrpzog3G5w0+DUkuvBh0WV6MJSeK+lCRF+vCNK810jiJPV/UX0diord+eqps9cRzBiYHp3G11y5I1C4nCtBuPPEfFPJyTNvpFiyyfoJSgIUdHxZJVRCogAKYdsNeiuVvacnYioQSrNZfbrAt97z3fVVxHiIZoeIeul3RMsBBpSg8ToTh/kuwRDVVVhjLRXf8MoGVkgga4ezfoX3jRPwRAUNju1Ildc2XT0vYTi1QeGqUAE5nveYkIa+jIaXU71e5TF+6Iskq0tGJrhWVmWv5u1YV0PUGSuFSfAtjSKi4ToaVAFY2TsCje9jlkXoTjlNQkfZLXeasJDO6zVPFFhBmBgXNCHha154+0kMSa+wzVtq87zs8PcKgt5kXjzPyGrCnZYZoPqSDWK43Qdk+v08Mx52p0PlURpXSWSU9K9AyIOjjLQP+0z7uiM2TWn5i2cgsby/+L8TGIFTHRx4nZeLLORyMCMpg6V8mS0W3i86Ebi5mVRYj+E77XwVd6oRRWXY5Cf7OVyU7AE54IJsXr1GnajNKE+8bHTtGRdLfl36StzeXL5V81Xmxk1fP+YeQi8DF1DCsYqfzSkw4f+XKByuQB3OJbhpnDHmALwBKlquMVX9f7zHszlYEfU8u5qyOrXhd+X0MndUvF3Oi49G6KmI8JuNIvHvC137Jb8edYI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(396003)(39860400002)(346002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(86362001)(85182001)(38070700009)(6512007)(107886003)(38100700002)(2616005)(71200400001)(26005)(4001150100001)(36756003)(6506007)(83380400001)(122000001)(478600001)(6486002)(2906002)(91956017)(110136005)(66946007)(41300700001)(66556008)(64756008)(66476007)(76116006)(8936002)(8676002)(66446008)(4326008)(5660300002)(54906003)(316002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkRxRmVwU3NIMXhBR2VMVUI0RG9iK1VjRzJDN21sa3dUQ1ErNGU3ejlVeExa?=
 =?utf-8?B?U0hhek9aYmQ2c2FEVnhhOTJRMERRNlJVRXl3UmJIM2o3WmI3TzNQYmZSekRs?=
 =?utf-8?B?QXU3aG44M01GSkNiQWMzUlA2R0NLSG1uUlkyMXRjRzVFbDhlcmNLVjBqN1Nk?=
 =?utf-8?B?UG41UzA2YTV6aHVRYitqTXlKem5iaXpVaFhkUkl4K0tlYU1rM3h4QUI1UTZw?=
 =?utf-8?B?TitYS3pQVTQ2RzdKZWdxWHp5QnRhSmRQbXZxNm45K0ZIUXdXWGRlWEg0a0hy?=
 =?utf-8?B?cTNVenAyUzNiZHRIR2VFT0N0V3pnR0pyK3hrWnpySUZ0VHpxWENBMzVIajFn?=
 =?utf-8?B?QmJJa2FQQ1ZtT1VuTVVCbmtyRkRtenJNUWpnTi92S3lDZjRRQ253NE5tMTZl?=
 =?utf-8?B?Uld5dmRWUTdyaEJHRndhZnFPMmtUUDJGV2JJZW5Scjk4TS9oamZ2Z2NoK0Fh?=
 =?utf-8?B?bXp1VktWandiR0N2T3Uwek9TUTFYTWsvamQ5RG9mclQ0TnJJUjZEUGs2bUFB?=
 =?utf-8?B?MWV2K0VNUTNOZnRSMWxKcXZYZEREV1RxV001UjYyY1pCZ0hRakhnYWlzQ3Vk?=
 =?utf-8?B?K3Zqd011VVBVTGMxd3BvWEdycGFQMTlzWHlZQlpwcm1ZU05acFgvMWg2dkV6?=
 =?utf-8?B?YURpMUk4bWV0MWNiZGtTekZBdHo4clArZHRualJlMVNxdTBoL2RWb0lYbVNj?=
 =?utf-8?B?U0tXS3Bza1k1NVFIaUFzR0lxM0hubFYvVUJUa2hmWFBzSGd2TXBobThtUDIz?=
 =?utf-8?B?Wko1czAwVzFsVFBKd3BCb3lkS1NnTm1hVjdOenVEM0svWThFSHBOOGFCRXJu?=
 =?utf-8?B?Z1c3c214WFk2YmxMK29ZekQzaFNMR1NUaGtMODdZT291SWVOVkVwZDFKNENG?=
 =?utf-8?B?Mi8wS0FxOG5ya3Q1dHpXT0xYY0RocDFEQmtFUFl3YVFyS0lKcUY5cEtrOCtK?=
 =?utf-8?B?bVB0Ri9NOWJSNXBCSjcyVXBDUks0MGlHVlVCVnd1eG4zTFJZTGpINm9KR3Vm?=
 =?utf-8?B?QTBTdVVpc3ZRbmx1cGx4bXhGaS9hNUljYnRLdlJ6SzVVbTB1eW5kMVZVRXdS?=
 =?utf-8?B?cENVZ3dFSDlGTnZUaTBZWDZXRnkyNGpleHdpc2IwRkxjbHZqV2ZSVS84M2VB?=
 =?utf-8?B?ZkhyZTQxNWFEeGRaWEVQM0ZaYUNkZVJqUXlpWXRMSksrSWVPaThQQmJFOTAr?=
 =?utf-8?B?bC9GWUpSRHdrY2U5djlMdWhueVpuaHhCY2hVRkRUQ09iZnJCVXdHTHY0cktH?=
 =?utf-8?B?VTRaS3RRczNTZWsraVVRR3FnS0xFNGR5VWloaXU5WVoxREh5MXRmbmZTeW5a?=
 =?utf-8?B?d0FRbmFGMjl4TkNDVEdnQmtzdFFDbnpQUUhEcExRNnNOY2VMaFhDNWgvWXR2?=
 =?utf-8?B?NjFBSkhTdXJWSnc4ejZqcERjeWV0cjlwRlZTVStKQ1lCbHMzSFZ4YXNRb01j?=
 =?utf-8?B?YlVKKzNDcS9yeVdTOTBIb25ibjFkU1JaLzEreHpkeldGSmxod2NqWlllaUQr?=
 =?utf-8?B?RjJabXFZNWViMmpVUWFoSEo3ZElZY2NjVGhjaHpnNTNFU2hCc3lVWjM0NlpP?=
 =?utf-8?B?eTdLVG45R2FqekpPRDVnMDFRR0NLYlVISzBTMHBkQ2xjdEN2c2VYNDd0NU90?=
 =?utf-8?B?ZEVGVzFUbVg0NzkvUVQ5NDdkYm9lNlVPTzA5VWh5a0RwK2hDMEx3dG9YdUow?=
 =?utf-8?B?c29Nc0RkSnA0Vzh3NXlkU2FpM2dvNm5WSkxlOEE1MVRiN0JZblpsa20vTHNQ?=
 =?utf-8?B?Z3locVpKWEFyRjZYNjYvMWV2UkhmV1R1bEZISGZ2eGNPb0U4Q1ZyY3UrdnJF?=
 =?utf-8?B?TXRweEFKTTY0VjBNRGdLWEVtWDFRTmNaWTJ2VzA3YWRhUTlJTUdxeCt1dDBk?=
 =?utf-8?B?aDFXaVFHSlhWMDYrang2WDkzUUpQNVBRcE1CY3lPMHR1L01PWFRtNmc3KzI2?=
 =?utf-8?B?NndrZWNlUmIzMmhaV2puYWlPQ21OaEdhbXdDcjNZRnJTbXFFdlN5UWNFTDNY?=
 =?utf-8?B?WjdkYmZST0NxeHoxYkRySDNCTG5JbWEraVZXZkVvUUcwU2Z6TDJzT1EwcE1O?=
 =?utf-8?B?cjhhU0dSb3UvOEZESmRDNjJMc1EzV0p6TUlPWWxwYWZpVzhPT1crSmRwWW9a?=
 =?utf-8?B?bk9CWmRJSkNOUU9uekNHQ0hCZ2pONDU3OGRjcVoyMlczbUtmVzJyOHdRSE5B?=
 =?utf-8?B?YWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AADB0A6D3E552A42BA6427E31D7AD4D5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e23a45-7267-4526-d8b2-08dbdc13cdd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2023 02:23:01.8940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dtST27vLLaMwopI7w/jPYq9mpIGD58Vkx3nEfKm7qyPaFFByDjQF7SCdwIeAfvBlRblKGk15iQMKeJYfww0q9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0302MB5362
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgYWxsLA0KDQpHZW50bGUgcGluZyBmb3IgdGhpcyBidWcgZml4IHJldmlldy4NCg0KVGhhbmtz
Lg0KDQoNCg0KT24gRnJpLCAyMDIzLTEwLTI3IGF0IDE2OjQzICswODAwLCBwZXRlci53YW5nQG1l
ZGlhdGVrLmNvbSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRl
ay5jb20+DQo+IA0KPiBJZiBjb21tYW5kIHRpbWVvdXQgaGFwcGVuIGFuZCBjcSBjb21wbGV0ZSBp
cnEgcmFpc2UgYXQgdGhlIHNhbWUgdGltZSwNCj4gdWZzaGNkX21jcV9hYm9ydCBudWxsIHRoZSBs
cHJiLT5jbWQgYW5kIE5VTEwgcG9pbmVyIEtFIGluIElTUi4NCj4gQmVsb3cgaXMgZXJyb3IgbG9n
Lg0KPiANCj4gdWZzaGNkX2Fib3J0OiBEZXZpY2UgYWJvcnQgdGFzayBhdCB0YWcgMTgNCj4gVW5h
YmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IHZpcnR1YWwg
YWRkcmVzcw0KPiAwMDAwMDAwMDAwMDAwMTA4DQo+IHBjIDogWzB4ZmZmZmZmZTI3ZWY4NjdhY10g
c2NzaV9kbWFfdW5tYXArMHhjLzB4NDQNCj4gbHIgOiBbMHhmZmZmZmZlMjdmMWI4OThjXSB1ZnNo
Y2RfcmVsZWFzZV9zY3NpX2NtZCsweDI0LzB4MTE0DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQZXRl
ciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9j
b3JlL3Vmcy1tY3EuYyB8IDMgKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMgYi9kcml2ZXJz
L3Vmcy9jb3JlL3Vmcy1tY3EuYw0KPiBpbmRleCAyYmE4ZWMyNTRkY2UuLjZlYTk2NDA2ZjJiZiAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMNCj4gKysrIGIvZHJpdmVy
cy91ZnMvY29yZS91ZnMtbWNxLmMNCj4gQEAgLTYzMCw2ICs2MzAsNyBAQCBpbnQgdWZzaGNkX21j
cV9hYm9ydChzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQpDQo+ICAJaW50IHRhZyA9IHNjc2lfY21kX3Rv
X3JxKGNtZCktPnRhZzsNCj4gIAlzdHJ1Y3QgdWZzaGNkX2xyYiAqbHJicCA9ICZoYmEtPmxyYlt0
YWddOw0KPiAgCXN0cnVjdCB1ZnNfaHdfcXVldWUgKmh3cTsNCj4gKwl1bnNpZ25lZCBsb25nIGZs
YWdzOw0KPiAgCWludCBlcnIgPSBGQUlMRUQ7DQo+ICANCj4gIAlpZiAoIXVmc2hjZF9jbWRfaW5m
bGlnaHQobHJicC0+Y21kKSkgew0KPiBAQCAtNjcwLDggKzY3MSwxMCBAQCBpbnQgdWZzaGNkX21j
cV9hYm9ydChzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQpDQo+ICAJfQ0KPiAgDQo+ICAJZXJyID0gU1VD
Q0VTUzsNCj4gKwlzcGluX2xvY2tfaXJxc2F2ZSgmaHdxLT5jcV9sb2NrLCBmbGFncyk7DQo+ICAJ
aWYgKHVmc2hjZF9jbWRfaW5mbGlnaHQobHJicC0+Y21kKSkNCj4gIAkJdWZzaGNkX3JlbGVhc2Vf
c2NzaV9jbWQoaGJhLCBscmJwKTsNCj4gKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZod3EtPmNx
X2xvY2ssIGZsYWdzKTsNCj4gIA0KPiAgb3V0Og0KPiAgCXJldHVybiBlcnI7DQo=
