Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A02EE4993
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 09:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbjHVJVI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 05:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbjHVJVH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 05:21:07 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A630CD2;
        Tue, 22 Aug 2023 02:20:52 -0700 (PDT)
X-UUID: 2d0477ae40cd11ee9cb5633481061a41-20230822
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=uZRMM+deoKsIiHoN3fqR5idkMZZ2gvua98ZEiZChP0g=;
        b=EeRofVOYqwwtBqWg2Hg+43pcnn5BbZdmniUFeG7AG2FxDZuDI1c4T4gkuDX+bemXGtVQwneVXmBJK6tAF/3iqgEkMMWb2MeqEUxBhyPDvCKOjQwQL36nuNLe0V8FxyvZmNmLdAhigYq6WNm4/fupq8WYW74851bOWPnlvafKkR4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:7226b2e2-8bcb-4644-a7a4-81d60a19246c,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:0ad78a4,CLOUDID:5bf29c1f-33fd-4aaa-bb43-d3fd68d9d5ae,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,
        DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 2d0477ae40cd11ee9cb5633481061a41-20230822
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 107044599; Tue, 22 Aug 2023 17:20:46 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 22 Aug 2023 17:20:45 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 22 Aug 2023 17:20:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LC3BnAQaEiaP0r6mMzSdyFKE+dhYYeTSVWCqjqqj3eHhNm3LmzNjh7MG9CyE15iFNymGrqlGT5jtZLMrzXRQpv9G8ozTiTH7gSYnrPAmx/WRHMJ0ZsPkt+bth59YdlPeK0sapQoYHyk6y7Z9sm5W6OW6p/hwbY4alBqOV1YIwvjOi1RlsPdSb7VvGPzEKZhWemPLn2e5SMaSqe/2Ca4hK1nCYMv557xh9OafXob1s6nCtOD3QzIpYoslx+9k8kgFMfDMUoKvS5CmGLTJJsnpWn/kNRnxW8jRqCf6Vso8Ys/24s044ekd31/0Y6A6SR/qW/othr7NmeTPju1vJfOGaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uZRMM+deoKsIiHoN3fqR5idkMZZ2gvua98ZEiZChP0g=;
 b=JDb/IBZVVgWQxpKR2n9y7TiLbqZ1MU8Ea5Vccb4hBQhh8M3IQBS81snEMiJNhLJ+3UMyttJ3gmszg8pIg/a9ljlH82OBC6KBVjRLbQNluuQzwWMwfhkySxxiHUlpH85y7DbPoV63TaycBs+2jk9fSnFVm6cFva1gvOdxS0mygvxZ0Zcg8kQOihpaVcLIf4f46PvFLisESQ7ohaC7Ao2kvZHcrfeM9/nKxgxEyG2yiw9LpP/TpjFbpqhd2ef9MJc8xWhsCqtb7Tl2Jz4XC0U9rIh1NFJsN5aeTDcjtUy0DLoG6sCvl8RHxwk83pisqL1Jl1TWD8WgNQGMJ/DWoflhIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZRMM+deoKsIiHoN3fqR5idkMZZ2gvua98ZEiZChP0g=;
 b=Xzss/aFy5Vfx9RnkDKkJFL7Hn6FDvFm/mNYpJDu58zSSCXTAJ0itx8a+Bi4fgSCKci/AT2ImCRihsVCB9RwTLeSs/EhSXWrbjXI35jeBQr6K/E+8juEhcgSgEFF+HdeFdxaYc/MDjJzHRDHxPMctiJDExinZvs24BQK/ap3xZdM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PSAPR03MB6298.apcprd03.prod.outlook.com (2603:1096:301:5a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20; Tue, 22 Aug
 2023 09:20:43 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::aac8:d178:a0bf:d74c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::aac8:d178:a0bf:d74c%6]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 09:20:43 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "hch@lst.de" <hch@lst.de>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>
Subject: Re: [PATCH v10 13/18] scsi: ufs: mediatek: Rework the code for
 disabling auto-hibernation
Thread-Topic: [PATCH v10 13/18] scsi: ufs: mediatek: Rework the code for
 disabling auto-hibernation
Thread-Index: AQHZ1NlbJ5AfyJolY0aLaf+EHOh6nq/2CiUA
Date:   Tue, 22 Aug 2023 09:20:43 +0000
Message-ID: <884fead2cdf88b2690e0aa87769684de60e26ac2.camel@mediatek.com>
References: <20230818193546.2014874-1-bvanassche@acm.org>
         <20230818193546.2014874-14-bvanassche@acm.org>
In-Reply-To: <20230818193546.2014874-14-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PSAPR03MB6298:EE_
x-ms-office365-filtering-correlation-id: 7e365d23-47be-4e9b-d998-08dba2f10f8a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GgBWwLEUsKi6tng5nCAY3MDlcY8KTNb/pO0IjRgOcG+JGtXbxVf7nqmgZsMTbZV+3AU7qXwqcCS8V86GsVxEJlxd3n1/7PkiYRMf2gcwhiSj3tp1pUvVs5Gysof6k0jyxW9NlmmLAkhOaFIsVjvzSW8Yk4bRlrF6PKorR6bZkWMTbghVYZeSFf4usi9kX2vHAteOXlvnbICMhmH7lz91M3F2ZJOQtXxMmDzIB+UPLk/HbQosRgw04i4wSoOpkcwUq9rtLUXb//XoGu5D7XX2RmXXiSoR5e9fVgtBbhOgRRpS2Pzl+6oBz4FgnZXtZzw8tkhpZ+ycG7HArBtXdtm0cgEbWyN2ix6+8IzgNiiIb53fiW5wJr3ZcXyM4XCxyWphtdbNFRQkYJWHnJPPGoDTQ/T+VfzGxapE3LgX0Gr1Yt9CRtnU5Kzk9YILR/zc2Uw6IO3IlWTBb+qpm4W90dknsoquIVYz01IWbRy5WKd2jhuNPVOMHzgj2IGRleM6LVIhxxydYdzr3mCeo9UuUyip7YMHSEzdUe5ntaKaioQOuidzf2IHJRjCjT7HO/ut00e5brspy9mTb/v+oEIXBkg325QFDM99ib38h4TiiXaFUId/2Jp7o5Hmc64I8a3uMu6sjG8LUSSOgg6mOAd/j5ETiYs7oD5BML9JTwRbnUJT/ddZZfPaI2xO90YIOHsSY7pXBLvjOJRisZQYHscB+KyoS/ogRBhou5xbdPSYh+/wM5A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(39860400002)(346002)(396003)(376002)(186009)(1800799009)(451199024)(2906002)(38070700005)(38100700002)(83380400001)(7416002)(122000001)(6486002)(54906003)(66946007)(66556008)(66476007)(6506007)(76116006)(316002)(64756008)(66446008)(91956017)(71200400001)(110136005)(41300700001)(6512007)(36756003)(478600001)(85182001)(12101799020)(86362001)(26005)(5660300002)(2616005)(8676002)(8936002)(4326008)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVV3Ym9nNFFyT3VkRUJUa2V0Y3JJNzM5cFk2a29hekRkcFNlY3Y4VEt2NWll?=
 =?utf-8?B?a256dGk0bTlaRFZETVVpNzVva3R3T3grUlE0YklnRGpqRlRxLy91c0FUTEk1?=
 =?utf-8?B?cGhNV2ZFQnNMRXdxUmFRdWl4M1pDRjJvUlBadWlGQVUwT0ZxWlVYWGJRSCt3?=
 =?utf-8?B?a2hRUXBPcnJMeFYrVVdYMW9zZ2NvSzI3NDFUb2JiUjlQT05jTk9qNjVQQU5K?=
 =?utf-8?B?dDdLcHAzU0dHaFg5elJ6M0hyKy9SNXFINGJTaWg0dm42RzNFT0RDMjdUd3RJ?=
 =?utf-8?B?YWtlaE5GZjdQMU1lUmxqbU90NGY2cEUvaE9EQ2dLQzlvRllHc2dZWUMwcVlZ?=
 =?utf-8?B?SHdzWXhOaytidytlVlJzVlJabUZnczNpSXQ1NFFLNVNyb2RvUzhvS3FlL2Nm?=
 =?utf-8?B?MjFDT0xmYXlKSE81aVMvM2lzSHRNV2FYaGs0VmU2Y3piT2xHMXJpeDlnRGFl?=
 =?utf-8?B?NmRMaDdVcFJnYmRERTI4MFpqK0c2dnFDL0FPYnFqMEYzdlVsY1RsbnRYVUVn?=
 =?utf-8?B?ZE9MaWE2SmpmQnNmMnBNMGdpejNXTWZ5MFJMaTdBSlBQUTdQclM2Y2NaS2Rt?=
 =?utf-8?B?ZGk4VDEvMDJ5bmx2VlBxb2tuODBRZmt4V2dwNTl0UXVsdldJY3Fsc29pKys4?=
 =?utf-8?B?YUpsOEpJWGViaGJtQW10UlBjUCtQN29qa1YzTlFKWEpVdzhBOS9acU53aC9Q?=
 =?utf-8?B?SklsWDlwTi9UU1BjK202bENTOWVtcjlSS1NUUGQraHdBZWRLajVrc0RCdFMv?=
 =?utf-8?B?aCtEWVRtS3cwbVpzMUtiMXNOQ1hyQTBreWdCcVhQQ0R3TGhEd2VaZ3pFTDBY?=
 =?utf-8?B?VHVaSEhraXFvMFVlNFlOOXorclJlZEZwYVV6ZjFVLzUzaTJhWXJJbUV4bUtq?=
 =?utf-8?B?NFZFM3RZZ2NNYzhyQTNLQVBNWXJNd1hCQUFEOTVCam15c2VYdFczWU9JcENm?=
 =?utf-8?B?clZiSFFnOXFCRE12ZXI2U3gvcVNUZEVuYWZweXNyWmVhTkh4dHdoeFkzaTBj?=
 =?utf-8?B?c3QyamR4UXd2cmxNT1Jadk93ZHY4b01LZkdBMmMxamFHY1hXZU53RlVvbzdN?=
 =?utf-8?B?ekhsTnFROFVLU2VJRm9zSjJWb25jaFI0N2lLaHhPT2ZMWVlJMkRiUm0zUUhi?=
 =?utf-8?B?REc4bU5QNFNaZTVQM2dmSmdLdi9CcDZTdTM3UzVyMGd2U0hyNm90TWtqSDhi?=
 =?utf-8?B?M0NycEZlTFF4WFJLaWs3MGd4OGJFS1h0bVhWbTV3clcwSk1zVE5kN0FISXdl?=
 =?utf-8?B?cnU3ZFozckk3dU15WTRlZS9GWS82aHBHMkJwNXZkVDBISzlPVUdqNzRnY1Fk?=
 =?utf-8?B?WEkwL1NoUDhYU1hqMnExbmVMankxQ1NueUJKVk1jc3NYb3NvTlVpbjk2T0I0?=
 =?utf-8?B?Z0V6YTZueHVNZ2pYQnBXYUdNUFJlYm01bDNTcEx1ekFuODBiV1lkWUF0TWhQ?=
 =?utf-8?B?RUYyeEphV0NLWUphWHRqQzBXSnp3cXJrdzNXVmxPNGpGODlUeW13cnN6a1c5?=
 =?utf-8?B?a1VaWWpKMXQ5Y0ZHZXEvRHFyS0FnKzVyUXZ2Mm5HRk11ZGdBZ3hSNnd0S0pQ?=
 =?utf-8?B?MVl1c2ttSjJYeElTY0FQUHIyL2IydGpaRFJTU2tZbGpoSzRsOVpybGNzOE81?=
 =?utf-8?B?Smd6YzAvY3k3SFpKRlZJckg5SzFuMVdBdlF3SWJpTDc3MmhlNlZobWxCZU9C?=
 =?utf-8?B?NnNEdVVSUG4xa1FEcjNkenJTc1ZZdjhqSTQ5ekd1VHFkdXNZUkRoZ0pTRGd3?=
 =?utf-8?B?ajRQaE9qZW1KTXo3UnNsOE9wcHg0T0ppS21VT2RWNGdIZVEwbTFndXlZT25D?=
 =?utf-8?B?TCsxS3VVbzFVd05hSU1sL2tvYWpOTzZTZDdvVWZMTkdnNWVIakMrYjJRUjNu?=
 =?utf-8?B?aHAzd25zeTN5SnA1VXNSR2JUd1Rvc1RaOS9ENVpJdzRLZ1p0UklmUVRKQ3No?=
 =?utf-8?B?bGgrQURUdnBZK2d0ck9FcmVSaGpLZ0NGODB6RGw4TWdRTm5zY3kyTDNxaGdl?=
 =?utf-8?B?dWh3NDY2a0FsQW0vakZ6QlBqR2V0RVgrcXEvUUZWSWduMFZrTmg4dU52ZUkw?=
 =?utf-8?B?UjhyYkV3cVRQeGd2dmoxTEJtQlc3ZytKcWhOdjZFakR4N0M5K0N5dU9RYlV4?=
 =?utf-8?B?VXNrQk5uTjR2bXFpVkU2Q1ZWaml3QnUybkd4bjI4TGpRT0NVSGV4VEZybzVV?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <92E58D2A41B3C04E827A6A49CFBD717E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e365d23-47be-4e9b-d998-08dba2f10f8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2023 09:20:43.4472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0x1+pqnzOEnphJ3UylghTmvSasKKvL1iATQY5BVDkjDPjNkclZEOjmL9qloHPVXxk7h2Dpx6MhXj+DgkkHDTsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR03MB6298
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KQ2Fubm90IGNhbGwgdWZzaGNkX2F1dG9faGliZXJuOF91cGRhdGUgaGVyZS4N
CnVmc2hjZF9hdXRvX2hpYmVybjhfdXBkYXRlIHdpbGwgZ2V0IHJ1bnRpbWUgcG0uDQpidXQNCnVm
c19tdGtfYXV0b19oaWJlcm44X2Rpc2FibGUgb25seSB1c2VkIGluIHJ1bnRpbWUgc3VzcGVuZCBm
bG93Lg0KU28sIGNhbGwgdWZzaGNkX2F1dG9faGliZXJuOF91cGRhdGUgd2lsbCBnZXQgZGVhZGxv
Y2sgdG8gd2FpdCBydW50aW1lDQpyZXN1bWUuDQoNClRoYW5rcy4NClBldGVyIA0KDQoNCg0KT24g
RnJpLCAyMDIzLTA4LTE4IGF0IDEyOjM0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+
IENhbGwgdWZzaGNkX2F1dG9faGliZXJuOF91cGRhdGUoKSBpbnN0ZWFkIG9mIHdyaXRpbmcgZGly
ZWN0bHkgaW50bw0KPiB0aGUNCj4gYXV0by1oaWJlcm5hdGlvbiBjb250cm9sIHJlZ2lzdGVyLiBU
aGlzIHBhdGNoIGlzIHBhcnQgb2YgYW4gZWZmb3J0IHRvDQo+IG1vdmUgYWxsIGF1dG8taGliZXJu
YXRpb24gcmVnaXN0ZXIgY2hhbmdlcyBpbnRvIHRoZSBVRlNIQ0kgZHJpdmVyDQo+IGNvcmUuDQo+
IA0KPiBDYzogTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4N
Cj4gQ2M6IENhbiBHdW8gPHF1aWNfY2FuZ0BxdWljaW5jLmNvbT4NCj4gQ2M6IEF2cmkgQWx0bWFu
IDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KPiBDYzogQmFvIEQuIE5ndXllbiA8cXVpY19uZ3V5ZW5i
QHF1aWNpbmMuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3Nj
aGVAYWNtLm9yZz4NCj4gUmV2aWV3ZWQtYnk6IEJhbyBELiBOZ3V5ZW4gPHF1aWNfbmd1eWVuYkBx
dWljaW5jLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jIHwg
MiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZl
cnMvdWZzL2hvc3QvdWZzLQ0KPiBtZWRpYXRlay5jDQo+IGluZGV4IGU2OGIwNTk3NmY5ZS4uMjY2
ODk4YTg3N2IwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5j
DQo+ICsrKyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gQEAgLTEyNTIsNyAr
MTI1Miw3IEBAIHN0YXRpYyB2b2lkIHVmc19tdGtfYXV0b19oaWJlcm44X2Rpc2FibGUoc3RydWN0
DQo+IHVmc19oYmEgKmhiYSkNCj4gIAlpbnQgcmV0Ow0KPiAgDQo+ICAJLyogZGlzYWJsZSBhdXRv
LWhpYmVybjggKi8NCj4gLQl1ZnNoY2Rfd3JpdGVsKGhiYSwgMCwgUkVHX0FVVE9fSElCRVJOQVRF
X0lETEVfVElNRVIpOw0KPiArCVdBUk5fT05fT05DRSh1ZnNoY2RfYXV0b19oaWJlcm44X3VwZGF0
ZShoYmEsIDApICE9IDApOw0KPiAgDQo+ICAJLyogd2FpdCBob3N0IHJldHVybiB0byBpZGxlIHN0
YXRlIHdoZW4gYXV0by1oaWJlcm44IG9mZiAqLw0KPiAgCXVmc19tdGtfd2FpdF9pZGxlX3N0YXRl
KGhiYSwgNSk7DQo=
