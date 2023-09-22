Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43A4CD4F35
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 09:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbjIVJIn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 05:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbjIVJI2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 05:08:28 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3AE1B9
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 02:08:18 -0700 (PDT)
X-UUID: 8cf62244592711ee8051498923ad61e6-20230922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=93dn8ROXLKKEusGDnm+0mfT2VNO87Y3Eh1jpzVNm2Pg=;
        b=J0mkf03pIiuiosjmIw9H12cYi9z0TeWRtLQeB1p3TJldyS6ivpy5xVitBD0FKFdg8PULv24Ax6YgWWh3uiSXI5DDR65uDrKpUaVtawgCpOkH1Aa/+A/hkXfvveSbcZ4ykh0GP+L2c3/+e0I+WQqqH40hyk+PU2vVl4KwpeF9TgI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:a05d0320-217c-4adf-bde2-e5b88c68d985,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:5f78ec9,CLOUDID:cd4856c3-1e57-4345-9d31-31ad9818b39f,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 8cf62244592711ee8051498923ad61e6-20230922
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1624556741; Fri, 22 Sep 2023 17:08:09 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 22 Sep 2023 17:08:08 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 22 Sep 2023 17:08:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vi420WDZrsGMHFj0flfpaujVN4lly+IMEOqVMyhRnsYiT/ol4DkyXj1mzjSrKubzzWcHbOWyPuFGtyLVKYPmcrbWrfzCOi4l/8d8deP3YJVVzEVJlNJUlMXzGwdx52I5Qs2i/YQ/OP87b2V65tG/FxH8n1DeHB7jehBegI+ak4VBPrrvk76IVRZbpbtPBfs9Rkra1pjJK1H8fbudBSxYeFSWmF2EkQU/tBaSTktLsGykEaG7PbRz/sELx5G0KXgacpijEMuuvwH1UyLNzQY/lhDU357tqw9EWm4qJ1HldtULF+wVQjwZQlRbsjfXNB4Vwdr6XeYRkWKr7KSnzC+7QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93dn8ROXLKKEusGDnm+0mfT2VNO87Y3Eh1jpzVNm2Pg=;
 b=YhsoA0PFPhLnH/TEOE2+sk50PlXqWaCYDhHbIZEW8wyg5jm8q7jbtuMp0kxstTzFa6xt01/GM87FviCuiot4t7scHISTbahFodInvX1kF3n1ERxQnIddc/VR0x2u+q5TuFYXv7SEoP5LI9P5GlwWRj5CjM8C7KIByq5+UUTnBxbyH9uCvTOSRjTWQK4qpiLAxfo0IYi9y9xzOmYmaQVhUISRyZr0Ms0jbAoojVGCNNhpP2CVUtvFzZmxezp0DK9YvsRQEXuCvN+YEwiYbM3xk7R/cDL3isPw57QFLkaQGiZnuRAEFre8xaGz3Sy9VjBe4DG8pRyVejH5VHKW8X8jlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93dn8ROXLKKEusGDnm+0mfT2VNO87Y3Eh1jpzVNm2Pg=;
 b=qRaUCEZjdocyKDguNfYeYC0Rsqxnkxs+cWbRtFknKPghrXoRZzp05djYGVw4B3+9Asd5ObMnBIsbMoahbB3MnGCc9oalWx/Wifrg/uAq3OCDw+0M8ziXVLGGup4VyjW6BgZ+Hrl24hSB4dsO7SaAvzmx2nz48Z1gmkL2maUHLxw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB5513.apcprd03.prod.outlook.com (2603:1096:4:123::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Fri, 22 Sep
 2023 09:08:06 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::6b1e:f21c:5401:d739]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::6b1e:f21c:5401:d739%4]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 09:08:06 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
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
Subject: Re: [PATCH v3] ufs: core: wlun resume SSU(Acitve) fail recovery
Thread-Topic: [PATCH v3] ufs: core: wlun resume SSU(Acitve) fail recovery
Thread-Index: AQHZGoHnTKhsAXd540WNH79JB9yhKK6L39oAgZxTuYA=
Date:   Fri, 22 Sep 2023 09:08:06 +0000
Message-ID: <a1a3865ddc3e3617801b0fbb5fea9d7b9460d390.camel@mediatek.com>
References: <20221228060157.24852-1-peter.wang@mediatek.com>
         <9d142dc5-6a31-3f79-69c8-9967e833a671@acm.org>
In-Reply-To: <9d142dc5-6a31-3f79-69c8-9967e833a671@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB5513:EE_
x-ms-office365-filtering-correlation-id: 0d6dad81-cdc4-46ad-b69b-08dbbb4b6f1d
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XprXZUudrDGu5ADqizG+ugrZ2T9oHQ3C9QAWOyLn2ncbiTeDuwf70d3riOsbT1/mh24r/TpuJTNgjIc+d1YwstcDFTgXz7Afrvjja0x4yEx4VZ04zPxDuyM7FObDyIWEgBgi37ESL/eEvQ6CHwlb5Iq7seOPiB2r47GvwxdqVpsVwTLghyOloBsNSneW6tFZFSP8YX7+2jl9PHs5cXJpOrckvYBFKhOxryFanzX73c/Fr17PpwqxtgABpdMRsoPJAsZiIghpQI3SzYpv0WgenKEuGIIwBA9185k3ZNpW5eumeT3hkKisCEukr2yWcXCSBVmKerdAYgczDAgtDdEOLyRwuFqwFyc1Ho1CNfkRloXUbfo87AQC+wOJ1jOHZSphnMkkGCD9NlLCzD8Gl50FoDSxyqZ/mn9y6pWBmNdtVlur0p/r3u1yAhSHVpvgCyzpXrb69ibHRz2BNcpV1TVPENR71vSX+iKP5GrPAqEwTcrdPOnQqEEQcZIg6LZ3ytSQRZH8sppiDLoYKdLg9SIMjfUkc81naFYbKt/8OtrjKOt2YF6arWNlnEIiOmdo3ipTU9FQg3dZw2Bcxnd5VrF0JnXKpJARBdJ4I+1ouTG7qc/k9MD4fAzxtOep/XIjxh2c76eHdi2VXkGElLmuJqWOSHZNsVc6yKlqIDSsb24Lzce5JS3dl3CwnKOhtfqwpJ8x
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(346002)(396003)(39860400002)(186009)(1800799009)(451199024)(478600001)(2906002)(76116006)(66946007)(64756008)(54906003)(316002)(66446008)(66476007)(110136005)(91956017)(66556008)(4326008)(5660300002)(8676002)(8936002)(41300700001)(71200400001)(6506007)(86362001)(85182001)(36756003)(26005)(107886003)(38070700005)(122000001)(38100700002)(83380400001)(2616005)(53546011)(6486002)(6512007)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlVZY2FRSzI4K0VlR3dZK2lNVFhZc2Q2OXUwVC9BVXpJekl3eWo4czBDMzVR?=
 =?utf-8?B?R3dOYWJkVG1nYkdSaXluRzMzZDlKUVFmUlV4dS9vT2V4WjJKVG1EeERzeUF6?=
 =?utf-8?B?LzlTemxVKzlhYTkyLzNnVUU5TjlxNCs5Q0pVNVE3R2RydW1WajJTV0ZyWEwy?=
 =?utf-8?B?QkpQUlNPTHB2TlJxZDVXYmlkSi9IcC9GMWN1ak52SW9VY0prU0FUMURkK2pJ?=
 =?utf-8?B?cDY5Wm9NbXBoM2x5aEprWEp2dithaExvUTRhdW90Z2Nmam1WV09mNk00QThO?=
 =?utf-8?B?ZUhvaGU3R3FnbEZaYVZvUWgxd3JlMk55Y255OC9NY0hDNVBvM3NWZ01JaTJr?=
 =?utf-8?B?ZkR0bHRPcS9vVWtXM08zNzgrNk9TcU1rUnk3N05kcG4rQmR0dFhlaFR3dVl2?=
 =?utf-8?B?WnZEQ29QSy8zZktZTlBWZk5qWW9TS01lQWdSSHpUcEtQc1dWNWp2OVNERSs0?=
 =?utf-8?B?STRIZWtjb0IrbDdXNm1qTGlxYml5OXNJY0hIajFCaDY1UU8zL0N3NTV5Q3Nj?=
 =?utf-8?B?RG5oNTBoRkpWMENZb05aeG1PaW8rNWlzZWFwUnRXb041VTdLdnhLZEE4ZDJh?=
 =?utf-8?B?ZzU3Ky9jOXZUTFhvbDFpYUFIUHFIRG9xMGhvWll6MGpLN3FrYWlPaGVZaXhm?=
 =?utf-8?B?cG4rb2VnN01KcTRBVGJvaGVlRGg5cmE4UFpHNVhmU2RHT0pDMEZLWVF0b0xi?=
 =?utf-8?B?S2lsS1pZMktyTkNuS0g5R1VXYzN1VGJCd21hejl4bk5oV3libktnRUFMZmhz?=
 =?utf-8?B?R1lhNlBqci9tc0tYYzRTT2RPcWFmRHNPS1VVL1B5V0Y5YnRuTFduWnRrUkNv?=
 =?utf-8?B?TkxnTGs4RFlxc1B2MTZ6aXh5dTNBQlBPeE9KV0xTdDAvL1FlUCtPbFFsQ0NU?=
 =?utf-8?B?K3dXWks1aVRid0hOcjc1TkRXRUdLOW1xU0FoUmpvek42Tk11RUUraTZtazZw?=
 =?utf-8?B?VHJlRjhrM1ZxSWtYUGhWZzhQeFFzM2x4U2tzTzZ4UlBNdmdxUTQzVnJwTDVX?=
 =?utf-8?B?cXlYbDdNRTUwYXVhT3pRMG9Ja3QreWNEU3R0cVNlOURmQ0hSQ2k5ejM5SGp0?=
 =?utf-8?B?UTI2djVIR1F5cG1aeEFhSXhvOVJPNGMwVjRIT2J0SmJFdnIrYWRwOXNRNEVQ?=
 =?utf-8?B?SmdkUVNmM204V3pKUVRhbFQwdWIyVW9GR1lJbFF1emZuNFFoZFlBQTYwd0Nn?=
 =?utf-8?B?S2VuTzFwaEx2WDE1c0xObE1MSFcwenJ6L0lwbUJuVGY3dTdqK3I2RkgveW9O?=
 =?utf-8?B?M3UyM2xObzhUSVZQNTdweSt1TVFGQUp0QmhDOTBEVHB5UHVhbC9ZWHBqMnZ2?=
 =?utf-8?B?N05YREZtYjJXYUpEUDUvS3hHdmViRmRYYWRCWUw2MGNvbGhlZWtGb21ONHkr?=
 =?utf-8?B?eVU0VU96bVFISWI3STZBMFpYZGR1dUkyT0E3ZjRjS3JnTDQ5bEovUGtXSFdu?=
 =?utf-8?B?dEM0dlU2QzlNRkN3dEU2ZmFSWmpiYzRuQjVlOWZBblE2Z1RxSkJJQTh1SC9x?=
 =?utf-8?B?OWthaGhiZWRsSjhBNFZwdGlHMmp0ZDZRR21SbkwzR1VKcjhmZUZWZG5Xc1NB?=
 =?utf-8?B?VjVmYzFKZjdzcThqcUxOSEF4U2RkSE8xWWJ4MFVOOHJ2MmQwYzRWNE91czVz?=
 =?utf-8?B?WlI2ZDJobE5YSGFCVzZEVEFPNldlcVZCajR2akRQUVRhVWNnVEM0WFRWRHIr?=
 =?utf-8?B?R3AxM1dkNDlVNVhIZkx5VERuZFZpdVF4Sjd2NFRUbWRJTlE3dm9iUzNIMS9L?=
 =?utf-8?B?aEl1bkRUNnk3RmtUNDExOVRpYXlyNGc3cnZENm1wa1ZqZXc1cjlDUlVDK2lE?=
 =?utf-8?B?Z3htWS8wb0x3R3hZM1E3eGlQMUpJd3NMYm9kK0VNT203NEFkVVRzWU9nbHJq?=
 =?utf-8?B?Ty83QlFpQmtPSkdFL1g3emxhQ3FKa2lyL2hSWVhscXJPLzFUQ2YrT2VEZ2dY?=
 =?utf-8?B?b2lobUdKSmNHdGFseU1yazNuR2NtTkhGTE5Nbkw5OE9FRUpaMG1CRjZ6Y0Jr?=
 =?utf-8?B?Uy93RUUwT3hlbHFTTzBEcVVrejdFdnVjNVBkdGFiRFZRQ25JZk1SeHdCMzNS?=
 =?utf-8?B?RmVQR1BmMEpKZnkwRE1wTjMyaVJjSjJTYkRabmRXVmtjOHFQcnduazk0VEE4?=
 =?utf-8?B?VWhSUjV3eXZMV0xUbHpHTEtvT2pneHIvaENPSjV5OFBobytocGo4Q2p6Rmgw?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71E2B02487CCB74591F87E394BD5B1A6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6dad81-cdc4-46ad-b69b-08dbbb4b6f1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2023 09:08:06.4142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cN622m3VwmuncK4KBEg9LOzbxpcAeqdyHHkRDHDXyaE3PupSHxN08Ohwwc2ARgejuUguY2ljDm7Qvx0itO6TjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5513
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIzLTAxLTAyIGF0IDE2OjI5IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDEyLzI3LzIyIDIyOjAxLCBwZXRlci53YW5nQG1lZGlhdGVrLmNvbSB3cm90ZToNCj4g
PiBXaGVuIHdsdW4gcmVzdW1lIFNTVShBY3RpdmUpIHRpbWVvdXQsIHNjc2kgdHJ5DQo+ID4gZWhf
aG9zdF9yZXNldF9oYW5kbGVyLg0KPiANCj4gICAgICAgICAgICAgICAgICAgICBeXl5eXl5eXl5e
Xg0KPiBQbGVhc2UgdXNlIHRoZSBzYW1lIHNwZWxsaW5nIGluIHRoZSBwYXRjaCBzdWJqZWN0IChB
Y2l0dmUgLT4gQWN0aXZlKS4NCj4gDQo+IHRpbWVvdXQgLT4gdGltZXMgb3V0DQo+IHNjc2kgdHJ5
IC0+IHRoZSBTQ1NJIGNvcmUgaW52b2tlcw0KPiANCj4gPiBCdXQgdWZzaGNkX2VoX2hvc3RfcmVz
ZXRfaGFuZGxlciBoYW5nIGF0IHdhaXQgZmx1c2hfd29yaygmaGJhLQ0KPiA+ID5laF93b3JrKS4N
Cj4gDQo+IGhhbmcgYXQgLT4gaGFuZ3MgaW4NCj4gDQo+ID4gQW5kIHVmc2hjZF9lcnJfaGFuZGxl
ciBoYW5nIGF0IHdhaXQgcnBtIHJlc3VtZS4NCj4gDQo+IGhhbmcgYXQgd2FpdCBycG0gcmVzdW1l
IC0+IGhhbmdzIGluIHJwbV9yZXN1bWUoKS4NCj4gDQo+ICA+IDxmZmZmZmZkZDc4ZTAyYjM0PiBz
Y2hlZHVsZSsweDExMC8weDIwNA0KPiAgPiA8ZmZmZmZmZGQ3OGUwYmU2MD4gc2NoZWR1bGVfdGlt
ZW91dCsweDk4LzB4MTM4DQo+ICA+IDxmZmZmZmZkZDc4ZTA0MGU4PiB3YWl0X2Zvcl9jb21tb25f
aW8rMHgxMzAvMHgyZDANCj4gID4gPGZmZmZmZmRkNzdkNmEwMDA+IGJsa19leGVjdXRlX3JxKzB4
MTBjLzB4MTZjDQo+ICA+IDxmZmZmZmZkZDc4MTI2ZDkwPiBfX3Njc2lfZXhlY3V0ZSsweGZjLzB4
Mjc4DQo+ICA+IDxmZmZmZmZkZDc4MTM4OTFjPiB1ZnNoY2Rfc2V0X2Rldl9wd3JfbW9kZSsweDFj
OC8weDQwYw0KPiAgPiA8ZmZmZmZmZGQ3ODEzN2QxYz4gX191ZnNoY2Rfd2xfcmVzdW1lKzB4ZjAv
MHg1Y2MNCj4gID4gPGZmZmZmZmRkNzgxMzdhZTA+IHVmc2hjZF93bF9ydW50aW1lX3Jlc3VtZSsw
eDQwLzB4MThjDQo+ICA+IDxmZmZmZmZkZDc4MTM2MTA4PiBzY3NpX3J1bnRpbWVfcmVzdW1lKzB4
ODgvMHgxMDQNCj4gID4gPGZmZmZmZmRkNzgwOWE0Zjg+IF9fcnBtX2NhbGxiYWNrKzB4MWEwLzB4
YWVjDQo+ICA+IDxmZmZmZmZkZDc4MDliNjI0PiBycG1fcmVzdW1lKzB4N2UwLzB4Y2QwDQo+ICA+
IDxmZmZmZmZkZDc4MDlhNzg4PiBfX3JwbV9jYWxsYmFjaysweDQzMC8weGFlYw0KPiAgPiA8ZmZm
ZmZmZGQ3ODA5YjY0ND4gcnBtX3Jlc3VtZSsweDgwMC8weGNkMA0KPiAgPiA8ZmZmZmZmZGQ3ODBh
MDc3OD4gcG1fcnVudGltZV93b3JrKzB4MTQ4LzB4MTk4DQo+ICA+DQo+ICA+IDxmZmZmZmZkZDc4
ZTAyYjM0PiBzY2hlZHVsZSsweDExMC8weDIwNA0KPiAgPiA8ZmZmZmZmZGQ3OGUwYmUxMD4gc2No
ZWR1bGVfdGltZW91dCsweDQ4LzB4MTM4DQo+ICA+IDxmZmZmZmZkZDc4ZTAzZDljPiB3YWl0X2Zv
cl9jb21tb24rMHgxNDQvMHgyZGMNCj4gID4gPGZmZmZmZmRkNzc1OGJiYTQ+IF9fZmx1c2hfd29y
aysweDNkMC8weDUwOA0KPiAgPiA8ZmZmZmZmZGQ3ODE1NTcyYz4gdWZzaGNkX2VoX2hvc3RfcmVz
ZXRfaGFuZGxlcisweDEzNC8weDNhOA0KPiAgPiA8ZmZmZmZmZGQ3ODEyMTZmND4gc2NzaV90cnlf
aG9zdF9yZXNldCsweDU0LzB4MjA0DQo+ICA+IDxmZmZmZmZkZDc4MTIwNTk0PiBzY3NpX2VoX3Jl
YWR5X2RldnMrMHhiMzAvMHhkNDgNCj4gID4gPGZmZmZmZmRkNzgxMjM3M2M+IHNjc2lfZXJyb3Jf
aGFuZGxlcisweDI2MC8weDg3NA0KPiAgPg0KPiAgPiA8ZmZmZmZmZGQ3OGUwMmIzND4gc2NoZWR1
bGUrMHgxMTAvMHgyMDQNCj4gID4gPGZmZmZmZmRkNzgwOWFmNjQ+IHJwbV9yZXN1bWUrMHgxMjAv
MHhjZDANCj4gID4gPGZmZmZmZmRkNzgwOWZkZTg+IF9fcG1fcnVudGltZV9yZXN1bWUrMHhhMC8w
eDE3Yw0KPiAgPiA8ZmZmZmZmZGQ3ODE1MTkzYz4gdWZzaGNkX2Vycl9oYW5kbGluZ19wcmVwYXJl
KzB4NDAvMHg0MzANCj4gID4gPGZmZmZmZmRkNzgxNGNjZTg+IHVmc2hjZF9lcnJfaGFuZGxlcisw
eDFjNC8weGQ0Yw0KPiANCj4gT24gdG9wIG9mIHdoaWNoIGtlcm5lbCB2ZXJzaW9uIGhhcyB0aGlz
IHBhdGNoIGJlZW4gZGV2ZWxvcGVkPw0KPiBJIHRoaW5rIHRoaXMgZGVhZGxvY2sgaGFzIGFscmVh
ZHkgYmVlbiBmaXhlZCBieSBjb21taXQgNzAyOWUyMTUxYTdjIA0KPiAoInNjc2k6IHVmczogRml4
IGEgZGVhZGxvY2sgYmV0d2VlbiBQTSBhbmQgdGhlIFNDU0kgZXJyb3IgaGFuZGxlciIpLg0KPiBQ
bGVhc2UgY2hlY2sgd2hldGhlciB0aGF0IGNvbW1pdCBieSBpdHNlbGYgKHdpdGhvdXQgdGhpcyBw
YXRjaCkgaXMgDQo+IHN1ZmZpY2llbnQgdG8gZml4IHRoZSByZXBvcnRlZCBkZWFkbG9jay4NCj4g
DQoNCkhpIEJhcnQsIA0KDQo3MDI5ZTIxNTFhN2MgaXMgbm90IGZpeCB0aGlzIGRlYWQgbG9jaywg
d2Ugc3RpbGwgZm91bmQgdGhpcyBpc3N1ZQ0KaGFwcGVuIGluIGtlcm5lbC02LjENCkkgd2lsbCB1
cGRhdGUgdGhpcyBwYXRjaCBhbmQgY29ycmVjdCBjb21tZW50Lg0KUGxlYXNlIGhhdmUgYSBsb29r
IGFnYWluLg0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvdWZz
L2NvcmUvdWZzaGNkLmMgfCAxNyArKysrKysrKysrKysrKysrKw0KPiA+ICAgMSBmaWxlIGNoYW5n
ZWQsIDE3IGluc2VydGlvbnMoKykNCj4gDQo+IFRoZSBjaGFuZ2Vsb2cgaXMgbWlzc2luZy4gUGxl
YXNlIGluY2x1ZGUgYSBjaGFuZ2Vsb2cgd2hlbiBwb3N0aW5nIHYyDQo+IG9yIA0KPiBhIGxhdGVy
IHZlcnNpb24gb2YgYSBwYXRjaC4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2Nv
cmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gaW5kZXggZTE4Yzlm
NDQ2M2VjLi4wZGZiOWEzNWJmNjYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBAQCAtNzM2
Niw2ICs3MzY2LDIzIEBAIHN0YXRpYyBpbnQNCj4gPiB1ZnNoY2RfZWhfaG9zdF9yZXNldF9oYW5k
bGVyKHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4gPiAgIA0KPiA+ICAgCWhiYSA9IHNob3N0X3By
aXYoY21kLT5kZXZpY2UtPmhvc3QpOw0KPiA+ICAgDQo+ID4gKwkvKg0KPiA+ICsJICogSWYgcG0g
b3AgcmVzdW1lIGZhaWwgYW5kIHdhaXQgZXJyIHJlY292ZXJ5LCBkbyBsaW5rIHJlY292ZXJ5DQo+
ID4gb25seS4NCj4gPiArCSAqIEJlY2F1c2Ugc2NoZWR1bGUgZWggd29yayB3aWxsIGdldCBkZWFk
IGxvY2sgaW4NCj4gPiB1ZnNoY2RfcnBtX2dldF9zeW5jDQo+ID4gKwkgKiBhbmQgd2FpdCB3bHVu
IHJlc3VtZSwgYnV0IHdsdW4gcmVzdW1lIGVycm9yIHdhaXQgZWggd29yaw0KPiA+IGZpbmlzaC4N
Cj4gPiArCSAqLw0KPiANCj4gVGhlIGFib3ZlIGNvbW1lbnQgaGFzIGdyYW1tYXIgaXNzdWVzIGFu
ZCBzb21lIHBhcnRzIGFyZSANCj4gaW5jb21wcmVoZW5zaWJsZS4gV2hhdCBkb2VzIGUuZy4gIndh
aXQgZXJyIHJlY292ZXJ5IiBtZWFuPyBQbGVhc2UgDQo+IGltcHJvdmUgdGhpcyBzb3VyY2UgY29k
ZSBjb21tZW50Lg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
