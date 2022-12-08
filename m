Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7474C4708E
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 03:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiLHDDE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLHDCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 22:02:43 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387AF9856B
        for <linux-scsi@vger.kernel.org>; Wed,  7 Dec 2022 19:01:33 -0800 (PST)
X-UUID: e605bc46c15c4661b297ab9c94a40308-20221208
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+3R7EjUvKHamhshL8mmRJXgi0j+1zadiNDyA1ahvh5Q=;
        b=L1b3cPaW1PFXYF06RsRtKKdtxW+C/0wsP9Nw3wZcUOco9J556bqaUJMTmV16kEsvcyoxNASZV+pnz20kVy8A1TQHUOa1NM9/tRpFbADDqXAWT52Ep8oIlyTaq2bM9FcpEIQDm5VZiXBMw7Kr82/GLqbydYafKkmOxLo1M3iSQH4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:603e750f-27ef-44b4-b282-8d248b343072,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:dcaaed0,CLOUDID:a118df16-b863-49f8-8228-cbdfeedd1fa4,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: e605bc46c15c4661b297ab9c94a40308-20221208
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 595752877; Thu, 08 Dec 2022 11:01:28 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 8 Dec 2022 11:01:27 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Thu, 8 Dec 2022 11:01:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGWo76D8sZHoEl1j3/Cf+Gmu0YI8fsZfaLcEsEjxW0aswrFW4YdyMvKbtto0HGT1LAgACS1l6TbtaYyziro6H1PcggHV9DBd4Kef6qaod3Rc2ebfsCtiHyQ2pyhdpv59Sqq5nuhqTQOXHuWISpqQD+xadw2sBpJluYy471EyrlfHGPzoY5WGqxwfq1mde9Y7kgxO4TtsqlNggbQ94XFNA68J3k8jp1/9c3LLmGy6A4tShgVHZcjbt6bcodI5SHqoMc/MVhBW3QUjVL9yZmmjKoLEGWsA4wOV4PSQqqLXoIdAwT1A8BRRjvZjRdmsGOG/R2JkZwT/Bq221XvAtUEGsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+3R7EjUvKHamhshL8mmRJXgi0j+1zadiNDyA1ahvh5Q=;
 b=FfS8X5wZC/WDq5NGx/Gyq7c1yEb4NB/2qf3Vu5Oq5iXECoUcC+2K9et6FO2aXdp4V2ix8uEV41wt2NJej+NnxdRj5hJFZEtZide/WTCHQmJ5l0Bye0uQYN/tBr545X5xciZ2CAsqr7ELDTxePIpLiG8F3lRIwRhjKTqkvVocNnbNcfWpuYELDVMMwQiXarbgRx/vczdO7WfgeUs2+rWVbrodmPxTN82Y8oBi1fh0O/Db3/YbiLbBAAMAWuhPtL3bU7S+xD59LkZa3ZpPnbmYsUgbd74OOz/eUdiTd6ivP8WQ5PRNwrKrjTfCfczpNaOqs3fCzD9oTpbuum8biG8O4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3R7EjUvKHamhshL8mmRJXgi0j+1zadiNDyA1ahvh5Q=;
 b=iEtVuzyjql5xgu1inEF98D0HGywr4ddC6OHhmKQ80KjmjHi5wMCENG8lX+TPAulEc54/1+G03OBxuVHWkq+M0dU0iVC7A9A1DeDagFEag9eGgzVyNkxwSPluwWD+z9pGaTOaZXeLHM52V0YO9tLtB9xlPNlV0PIRLrf2FEcAI0s=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB5563.apcprd03.prod.outlook.com (2603:1096:4:126::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 03:01:24 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:01:24 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>
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
Subject: Re: [PATCH v4] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Topic: [PATCH v4] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Thread-Index: AQHZCSBmwUDmapEV8U2DywnZbmWqca5irU6AgACjJQA=
Date:   Thu, 8 Dec 2022 03:01:23 +0000
Message-ID: <7f998f91d7bfa263f4dfd29167b02e2ff4b6c5c5.camel@mediatek.com>
References: <20221206031109.10609-1-peter.wang@mediatek.com>
         <4ddd814b-c8ed-8ac8-710d-aa317882fdb1@intel.com>
In-Reply-To: <4ddd814b-c8ed-8ac8-710d-aa317882fdb1@intel.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB5563:EE_
x-ms-office365-filtering-correlation-id: 325d37d3-e501-458c-ca75-08dad8c87d76
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +3TpqMtf0XJpnpElvFdNE4KR4ZhPub0tpZYr7VxaIEpWhDOCW/kdGtmKYC1JxtXw9klzAD9Uh0wjZwIrQJWGLrXbv0kLBBYGuHUw8ZmaVSCgksutYHyCDFRnERw0pUMhUajqpT+RSOvGNaAVvluFIEPqU0QMRL8VnDTCK7NZTMSPRpir9+P43EJ1VDIuoafVafoCBbs+sHGyBnIhgSlxtgKbfk/KUB9agJVQm7sgp0E79/x0lUN8AxTbWkXlhY0ZY4FsQWp1dvFiNIAMXSKaMV1o+bAGbUAvaiDXSCilcirKCqzLkk2CS09pau5Jvi09Emz/kpwT+ogvdz+H9HMlu5/3L7trsuowqrjbUvnQlKnK5CPeNQgk6e/ZWmYYw6oY8BaXo9wuGk1j0Ws3U52pryAYMYHaYjtejYjA4zmy5btRRMTdjt+a/h40D14ggIjWOS4PYV5NSCIP4XaesxjLSEWXCT4lDhP7hpghScCEvV7Ey0YWHsvzQVWT6Uu+hOVMXs2yPfJHdYpkhewO5e1kNW9tEGtgExl9BxFvVd0vdRm8caAd78jdwN9NptaaBo3e1Bk1dejM8lezP78M4n/UESHyL1MV+9K00oDZuHMrID/szQTIpfsn644hEkTo2yBnfdb+WVnYGBnMrToVY4HSXLldY9FmhWUpr52iORLbA+xVxk8KTBupgQxfFGZIuqbwMGAs8mxJADZ0YP3mo3lu0TDTfojPa/LxDhKOYm72vT0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(2616005)(83380400001)(186003)(6512007)(53546011)(26005)(6506007)(15650500001)(66446008)(122000001)(36756003)(66556008)(66476007)(85182001)(66946007)(8936002)(76116006)(64756008)(91956017)(38100700002)(107886003)(6486002)(478600001)(2906002)(38070700005)(5660300002)(71200400001)(41300700001)(4326008)(316002)(86362001)(54906003)(110136005)(8676002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q28rajErQkNWVGlwZUJHYlcvaEdVaUFib3hyVnhmenhXMURWUVJmdVNrb2NQ?=
 =?utf-8?B?V0lDdGxnVkZDN2NaM2ZRbnlvYUQvSm5lNG1TNWFmSVpaTVRkcGw5TTdnTFVz?=
 =?utf-8?B?c0pVUVlNcW8rYkZDT2J3RlBtUjJsLzFjTUZhU21VQWllbE5RRW5zZUdKME4v?=
 =?utf-8?B?OUZqb2lONE5BOGJNQlp4M0wrZDZmb1IwMlBxTXMxWVo4NkRwVlc5Zm9rMGRK?=
 =?utf-8?B?bmk2MVVKK083ZlY0V3VVNEZwSjBmNXZZK0VwOTZYeTBLR3hLU1BtMncyaElz?=
 =?utf-8?B?UHREUEtMTUZYTGpySEZUQWVpZXFkdXpkeml2c2t1eUtPeVB3RkRjSC8xS2xw?=
 =?utf-8?B?K2pGN1lSd3BXQVVDOFQ0alYySWJmNkhNbkZ6bXlGbCtGR1QxTElhYlVEMjhI?=
 =?utf-8?B?U2lhalRTaUJyS0xnMHg1ZFZYbUp4Mkw4M0JiUXE2NWh4YTRqTGNrN0FBT3pF?=
 =?utf-8?B?TVNCek56ZlBCWHpmTlliZUJISjJQRG0vbkUwTVByZWt6Wmg3b3pReWtOS2Fn?=
 =?utf-8?B?a3hqWXVtd1ZDWk1sck5TRjM3K1h4YTBOYjI1MTFCVjVlSEIwc2VkaFRqWC9G?=
 =?utf-8?B?V05sbFZMRnhHM3lsQkJsdGhSZytucHlsTm90V0VHeWZBejhsZVFFeHpSYVZO?=
 =?utf-8?B?Q0luTTc1ZHZ2cVlBWXFzQVc4YTBDUG03SkhuVmtQRkRob0YyVFNsMGM1TVRq?=
 =?utf-8?B?ZFBnZWd1d1lNZnF6YUdPUXRWMUxicmViclN6RUdFUGsrdG1wQTFjNnk4WVZV?=
 =?utf-8?B?cE9hWXl2NWNOY0NsSmFVRS84NFZadW1ocDAydTRLL0syaFBDWWtVakx3NFVH?=
 =?utf-8?B?Q2RpRjFoK256T0E1Smk4VnNkd2FYYkc0SVBXUjVhajhIbHBRV2RKM01ZT2tY?=
 =?utf-8?B?aDlaU2J3VlhKYTY3L29vNjdoNGRRbldWSGU5QUU3UHZMR1lMeVdrTEFpeFZL?=
 =?utf-8?B?VUJTcDN3aWt1NStLYmk1ZWxlREpYUFpRb3MreEltbW01ZkJkdDV5anBVTjZJ?=
 =?utf-8?B?MHRSUlhKWERuckhaUXFOWGdRUEZDZGtDL1ZDN2dGRUUvNDNSSDhGcDBiM080?=
 =?utf-8?B?bk14RDFDVTVSVlFabVBjeTEyUG5UOElXVmg1RjRYVXdaTTFieExwRklraGpj?=
 =?utf-8?B?T3dWaFBML3dlVzMyNXBKUkdTSUxYR3hlbmRERzVzNmR5em5GUk4xcTdEYnp4?=
 =?utf-8?B?cHc4dUorWUJXck5lSURlVDE1K0tSUUxJNFJtRWJDSzdqZmIzN2xjYllUZkVI?=
 =?utf-8?B?bjVJc09wUk41RllBQkN5U05vejBNTE9BVEJpS3BqSXV1ZDVlMWR2ZFFkUSti?=
 =?utf-8?B?OURSUGlkbjhxdGJGZVZHclJxaGpwUkJYQndZWTNlcHFDWSsvL1RKbm5hUkY3?=
 =?utf-8?B?T3Jzc1c1ZUE2enE4TzVkYVY3aERsd29IWVBRbmk0WWE3OWU0UlRwZjlQdWkw?=
 =?utf-8?B?WmlCOUdhckFYZVA0L0VBZWY0NTBFSGIzeGdTL3l0L3BiRVY4RDVjMVI3ZDJF?=
 =?utf-8?B?MzhWdGZEZE5MbDZDK0RqNDZFWXJxN2h2eVdtdnN5S0N1Q20zdnBXTldqVFNQ?=
 =?utf-8?B?aXBtckVFUWpXcXhVa21YNWdsWjRxaTV1SmpXdmM3cGphTDRTVnpvN2tEMlU3?=
 =?utf-8?B?T241WENVc1RzNi8rcmxDWDVhVlNseC93UzlFMDVmcVpXNjExMUVWSlEwV25E?=
 =?utf-8?B?SWN5YXcrYTdJQkpHcUh4UW16ejJ4dHZabVR3YVZvenVtbGRlckJRSnM4MGZp?=
 =?utf-8?B?d2ZxNGY1cG14Z2JnK2pydDBXOTVEN0JrakN3WU9TT3NxNDNzZnFsRlFlY3oy?=
 =?utf-8?B?QjhNTW1Eb2ViYXNwUXFtUCszQXFtV1hkbUxpMElKOGFNT2x3alEyQnB1Tmph?=
 =?utf-8?B?WGdXMW5UWXBQaUphbzhJYmxldXRCQ3dmbHU2N2s2K0JZM1lZK1QxZmlmTkc0?=
 =?utf-8?B?dkJvQlBNVlc4SW5SSGpWVUtmSVgrVDlDSUtBWGU2NW5kQnJCVjNTVUg1ZzYr?=
 =?utf-8?B?S2NiMmdSKy9Pcysyd1NZSFdOYkRyTmZ5UEk0bGJPQzdyemxGT01qaXlpTkY3?=
 =?utf-8?B?VXBzQmxWdDZjK3I1bEg3aGpvR1h6RmRQSUpTRzNMa0RlSllFTDdyQjVVeEJQ?=
 =?utf-8?B?Z3pDSHhleGhaUWdkSzhyVWkxeFRZSkZnK29PQk5KOGNzaWZPREhNb2lNOXN5?=
 =?utf-8?B?S1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B050F0282FF9E240BCC3C2631822B9B5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 325d37d3-e501-458c-ca75-08dad8c87d76
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 03:01:23.6186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rW0fOGea2gdC8ktCeWxXpxDLHQDE32Pi330wOAJbxDuTLtapsvZmDCOOJL2Zcg9iYNTEA6DZ7ZItYd7NN3FKuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5563
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIyLTEyLTA3IGF0IDE5OjE3ICswMjAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBPbiA2LzEyLzIyIDA1OjExLCBwZXRlci53YW5nQG1lZGlhdGVrLmNvbSB3cm90ZToNCj4gPiBG
cm9tOiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gPiANCj4gPiBXaGVu
IFNTVS9lbnRlciBoaWJlcm44IGZhaWwgaW4gd2x1biBzdXNwZW5kIGZsb3csIHRyaWdnZXIgZXJy
b3INCj4gPiBoYW5kbGVyIGFuZCByZXR1cm4gYnVzeSB0byBicmVhayB0aGUgc3VzcGVuZC4NCj4g
PiBJZiBub3QsIHdsdW4gcnVudGltZSBwbSBzdGF0dXMgYmVjb21lIGVycm9yIGFuZCB0aGUgY29u
c3VtZXIgd2lsbA0KPiA+IHN0dWNrIGluIHJ1bnRpbWUgc3VzcGVuZCBzdGF0dXMuDQo+ID4gDQo+
ID4gU2lnbmVkLW9mZi1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBTaG91bGQgdGhpcyBoYXZlIGEgRml4ZXMgb3Igc3RhYmxlIHRhZz8NCj4gDQo+IEFub3Ro
ZXIgbWlub3IgY29tbWVudCBiZWxvdywgb3RoZXJ3aXNlOg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFk
cmlhbiBIdW50ZXIgPGFkcmlhbi5odW50ZXJAaW50ZWwuY29tPg0KPiANCj4gPiAtLS0NCj4gPiAg
ZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDI2ICsrKysrKysrKysrKysrKysrKysrKysrKysr
DQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hj
ZC5jDQo+ID4gaW5kZXggYjFmNTlhNWZlNjMyLi45OGYxMDVmMzI4NzcgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUv
dWZzaGNkLmMNCj4gPiBAQCAtOTA0OSw2ICs5MDQ5LDE5IEBAIHN0YXRpYyBpbnQgX191ZnNoY2Rf
d2xfc3VzcGVuZChzdHJ1Y3QNCj4gPiB1ZnNfaGJhICpoYmEsIGVudW0gdWZzX3BtX29wIHBtX29w
KQ0KPiA+ICANCj4gPiAgCQlpZiAoIWhiYS0+ZGV2X2luZm8uYl9ycG1fZGV2X2ZsdXNoX2NhcGFi
bGUpIHsNCj4gPiAgCQkJcmV0ID0gdWZzaGNkX3NldF9kZXZfcHdyX21vZGUoaGJhLA0KPiA+IHJl
cV9kZXZfcHdyX21vZGUpOw0KPiA+ICsJCQlpZiAocmV0ICYmIHBtX29wICE9IFVGU19TSFVURE9X
Tl9QTSkgew0KPiA+ICsJCQkJLyoNCj4gPiArCQkJCSAqIElmIHJldHVybiBlcnIgaW4gc3VzcGVu
ZCBmbG93LCBJTw0KPiA+IHdpbGwgaGFuZy4NCj4gPiArCQkJCSAqIFRyaWdnZXIgZXJyb3IgaGFu
ZGxlciBhbmQgYnJlYWsNCj4gPiBzdXNwZW5kIGZvcg0KPiA+ICsJCQkJICogZXJyb3IgcmVjb3Zl
cnkuDQo+ID4gKwkJCQkgKi8NCj4gPiArCQkJCXNwaW5fbG9ja19pcnEoaGJhLT5ob3N0LT5ob3N0
X2xvY2spOw0KPiA+ICsJCQkJaGJhLT5mb3JjZV9yZXNldCA9IHRydWU7DQo+ID4gKwkJCQl1ZnNo
Y2Rfc2NoZWR1bGVfZWhfd29yayhoYmEpOw0KPiA+ICsJCQkJc3Bpbl91bmxvY2tfaXJxKGhiYS0+
aG9zdC0+aG9zdF9sb2NrKTsNCj4gPiArDQo+ID4gKwkJCQlyZXQgPSAtRUJVU1k7DQo+ID4gKwkJ
CX0NCj4gPiAgCQkJaWYgKHJldCkNCj4gPiAgCQkJCWdvdG8gZW5hYmxlX3NjYWxpbmc7DQo+ID4g
IAkJfQ0KPiA+IEBAIC05MDYwLDYgKzkwNzMsMTkgQEAgc3RhdGljIGludCBfX3Vmc2hjZF93bF9z
dXNwZW5kKHN0cnVjdA0KPiA+IHVmc19oYmEgKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQo+
ID4gIAkgKi8NCj4gPiAgCWNoZWNrX2Zvcl9ia29wcyA9ICF1ZnNoY2RfaXNfdWZzX2Rldl9kZWVw
c2xlZXAoaGJhKTsNCj4gPiAgCXJldCA9IHVmc2hjZF9saW5rX3N0YXRlX3RyYW5zaXRpb24oaGJh
LCByZXFfbGlua19zdGF0ZSwNCj4gPiBjaGVja19mb3JfYmtvcHMpOw0KPiA+ICsJaWYgKHJldCAm
JiBwbV9vcCAhPSBVRlNfU0hVVERPV05fUE0pIHsNCj4gPiArCQkvKg0KPiA+ICsJCSAqIElmIHJl
dHVybiBlcnIgaW4gc3VzcGVuZCBmbG93LCBJTyB3aWxsIGhhbmcuDQo+ID4gKwkJICogVHJpZ2dl
ciBlcnJvciBoYW5kbGVyIGFuZCBicmVhayBzdXNwZW5kIGZvcg0KPiA+ICsJCSAqIGVycm9yIHJl
Y292ZXJ5Lg0KPiA+ICsJCSAqLw0KPiA+ICsJCXNwaW5fbG9ja19pcnEoaGJhLT5ob3N0LT5ob3N0
X2xvY2spOw0KPiA+ICsJCWhiYS0+Zm9yY2VfcmVzZXQgPSB0cnVlOw0KPiA+ICsJCXVmc2hjZF9z
Y2hlZHVsZV9laF93b3JrKGhiYSk7DQo+ID4gKwkJc3Bpbl91bmxvY2tfaXJxKGhiYS0+aG9zdC0+
aG9zdF9sb2NrKTsNCj4gDQo+IFNhbWUgNCBsaW5lcyBvZiBjb2RlIGNvdWxkIGJlIHNlcGFyYXRl
ZCBpbnRvIGEgaGVscGVyIGZ1bmN0aW9uLg0KPiANCj4gPiArDQo+ID4gKwkJcmV0ID0gLUVCVVNZ
Ow0KPiA+ICsJfQ0KPiA+ICAJaWYgKHJldCkNCj4gPiAgCQlnb3RvIHNldF9kZXZfYWN0aXZlOw0K
PiA+ICANCj4gDQo+IA0K
