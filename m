Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FF2C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 07:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiKHHdI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 02:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbiKHHdE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 02:33:04 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F8F2EF69
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 23:32:58 -0800 (PST)
X-UUID: bd3d98e682e84dca8575b5620ef8a820-20221108
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=aa/mGTV0MS5VZ+DD7olKAulKm8rIC6teR0j8MLk23DY=;
        b=WHClKt4jQhDXYlwgtnt//lniCXtSjPDYaCNe1dbQEHqE8Wz3WieXtX/gHDFk8E1ZKh60HakyS6yZMOTEjZ2rSuTcf5eW1Fo1Nd2i0ZCuniNuWBGqCpx2Nw+CC5e2O0YAOYqQlOsmnRIFxS8uCWXN6kqZbtEdTZG9fiRjvEXcD2U=;
X-CID-UNFAMILIAR: 1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:f6f8f643-9d4b-49af-bdec-f286640a7010,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:4,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-1
X-CID-INFO: VERSION:1.1.12,REQID:f6f8f643-9d4b-49af-bdec-f286640a7010,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:4,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-1
X-CID-META: VersionHash:62cd327,CLOUDID:a5e0ec90-1a78-4832-bd08-74b1519dcfbf,B
        ulkID:221108153249MXWPJCYA,BulkQuantity:0,Recheck:0,SF:38|16|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: bd3d98e682e84dca8575b5620ef8a820-20221108
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <eddie.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 861075167; Tue, 08 Nov 2022 15:32:47 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 8 Nov 2022 15:32:44 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Tue, 8 Nov 2022 15:32:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmfr4fb6gswrIut9ZsPM+5MDk6BioorUjsVy4WbuSNZ0AtDWcV8NinRwstTW70kWxGavs6nFXStTNVBxSDVCkkaoVkm/8gMxRJ5w3Jbj0yY7V/avqEDFlSoD5GthblJqRo/laW+JtoOTaqP6CsTiN1Vjmxy9spzhA4yyOCczsDsad55WZIq1Nkc+ooe2C2m/QZ3hRbdc3jI+gR2NbbXctfL3vX/aY5Dhy/RRPmpGZl/6Qfo5yS9XMhA0UvjlucvlfIz0lFlbxhxY44v/UPGE358Ou69Kwh+SZQ5FvjUsWwrk7wpgnipDxKKRsj8wzaNdq57VWzhAT+FimimkHcjGPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aa/mGTV0MS5VZ+DD7olKAulKm8rIC6teR0j8MLk23DY=;
 b=cTGEN1qvkqFBPr50jJl2wM307YM/ld0vkOWpTwcJ0GE5wB8wo2N5cLgqmPb15PPGrV1d+eeo2rQNmjPpNGlijHtyShvv8WAHNHGpcQqeUuZMX/wtsqr+87qYfRVc3KJP5XAKDccaHyJYjPqDf8AhMpbeEYEP/Vr1VV+3ZgdMS41wttvHu7R50VLhWqpinhQ2+a3HsAmEh8nRhLyo0vNYGnR5qfH3hN10n5jFFIRFMEdkR1q8NFqu54i2VC2Y2+2xaz+abpSzG9a6o92l0s269Xw5iawSpj27WZud83gI0QEWg0ugQj55Ynqb1Exzaf+7XGCiknVui4NirffTI0Cs+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aa/mGTV0MS5VZ+DD7olKAulKm8rIC6teR0j8MLk23DY=;
 b=SsV7OYInqhgyQxCT7t3WA3Ur2H1pgVbA8wxlPBfUJFhpxpXJxtrfFIqtOpZS0pECRERWDDfPEtH66VbUnMFIxaFSm8SPoQebI1GU4yQKH826JyR46dLdmiWaLJ8M5s+7O7Cb5NIZAjvp0CTXxkbUWfIiuH/qC3FGG1CwcrNEivY=
Received: from PU1PR03MB2795.apcprd03.prod.outlook.com (2603:1096:803:24::12)
 by SI2PR03MB5913.apcprd03.prod.outlook.com (2603:1096:4:145::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 07:32:42 +0000
Received: from PU1PR03MB2795.apcprd03.prod.outlook.com
 ([fe80::fe7b:be1c:6bfb:6c38]) by PU1PR03MB2795.apcprd03.prod.outlook.com
 ([fe80::fe7b:be1c:6bfb:6c38%2]) with mapi id 15.20.5791.025; Tue, 8 Nov 2022
 07:32:41 +0000
From:   =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        =?utf-8?B?TGlhbmctWWVuIFdhbmcgKOeOi+iJr+W9pSk=?= 
        <Liang-yen.Wang@mediatek.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>
Subject: Re: [PATCH v1 2/2] ufs: mtk-host: Add MCQ feature
Thread-Topic: [PATCH v1 2/2] ufs: mtk-host: Add MCQ feature
Thread-Index: AQHY6Q40Ep8RzNlqkEyqYSK8ny7/Za4gW8WAgBRargA=
Date:   Tue, 8 Nov 2022 07:32:41 +0000
Message-ID: <b3e59be054cc39fc181c149aefb6a612d0a792b8.camel@mediatek.com>
References: <20221026073943.22111-1-eddie.huang@mediatek.com>
         <20221026073943.22111-3-eddie.huang@mediatek.com>
         <b22b6d17-98d6-782c-af5e-8e3d46a0277e@collabora.com>
In-Reply-To: <b22b6d17-98d6-782c-af5e-8e3d46a0277e@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PU1PR03MB2795:EE_|SI2PR03MB5913:EE_
x-ms-office365-filtering-correlation-id: 96bc181f-a145-48bf-e3e9-08dac15b6ba9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gPm5nSbd8fKm9s2A7T5yhAzkv0jn7td5wN2oOL+cuXfD5io6eDqsHzIXAX94rs6SxwdWe1EgNlDh3wL56cVgPDIULcfaBAf8hEuDAdI8ghuW+0gF6sazYHSg/MCUunD1VgDtteuEEcM5vEyci6nAlMTYGYWiWC7Eq/RiNtZhMB5oCgh9pZEQ8B1QQRrXh+sTHoyedyq+rf3hDEWdVQnDpw1tF8crMlsP0XvvzFJJXr01IyFP+ykl19rGJ4trt5Z+BuHMrW2axhB7L0RWecBrkLMlKsakpNnsNa0HG1NTXc1MtDJE6jMIwPaH410LKBnG7PlwCY6RszDNft8pU8lddGcJ7PFkBppc0R6vVxXUiZtUYgneHgYs7YWDGeZLGIb0O4TqljR3ANGYdKqgOHDIbBHUMtnxjjLrEBRMl63ruUmEL7bS3cnz5X1Oq0CWJiipBtqb0xy1rGOe09UvZnQi3qTr8pJH4barUQUVkWFQ1COgMaGTXoKW3y9q3zcxlnannNeG2TrJ/rkffCqDFtsj4s/PJIibu2rDRGR2lAcqiwUyqMCxPYr6Y0bqfrf56cPF6s60RQ568ZF/iEinUtb7SHPUSQeM6wXrfHvJi7cRPUcfyFx96gGaN0FQ5CSra8MrdkdMAiEfCcOuhiQJAuabWQsZonkiuWlqcNa7LJN6EUSbQlv6I+6rC/XQWN7uiL3bVWYroIZpdXFhCbmdgeie57I5IWeni8wQKMEz5zbBkvWJ/aQ/GyPG9X25Q6/j33385QS/2lqXz3A3pHU8+xkOP8tvjUFksCJ00Qodh2uzQCBj6G/91hT7QzdXevdW1Rz5ox7bh1lagLW84UWFMPLwZoFk9/kloh2iAzbiw6JqHzU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PU1PR03MB2795.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199015)(36756003)(85182001)(38100700002)(122000001)(2616005)(86362001)(64756008)(5660300002)(41300700001)(2906002)(4326008)(8936002)(8676002)(4001150100001)(186003)(966005)(26005)(6512007)(478600001)(107886003)(6486002)(71200400001)(316002)(54906003)(66946007)(110136005)(76116006)(6506007)(38070700005)(91956017)(66556008)(66446008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTRSWjBZZTNKT2F2VnFKa2tNcWhJc0R1NFdrL0pqYkZMWFBReHlrYW8zTFJa?=
 =?utf-8?B?SGRmY0JVTmF2a3NZcDh0aHgzTEk4YUlDU3B4UkFVN2hLd1Y5R2oycVExM2pZ?=
 =?utf-8?B?WHFlUlVIMTduSUdZanNiZG9PWXhzcmY0bnZlclNYZmtGMVlEWVZ6MTE2SFhP?=
 =?utf-8?B?aVRTNkRabkZVWEp0cGVjL1BmRW1QdDY1QlQrY1RFa0E4UlFIaU1Pckd5OGZi?=
 =?utf-8?B?WnU3eU5LQXI0bUx0VW5JaTY1SDJUNStscEMwcUlTdWxWdVZadDM3Q0xYK1BT?=
 =?utf-8?B?Y1F5MFM5VGVDdTNFd2FoK1h6cjM0TVFDZ2tWb3d3cDJRNWFIYnN0S2pRd2d1?=
 =?utf-8?B?T3Y5bmQ1a3VUVU9NeTRNRGlxSlhra1JmblR5R1RtZ0hVcXlGdkxKOFZGT2dh?=
 =?utf-8?B?TGQ2b09jZnJwcmhtWW5NQkZ3S1NBRWEwTElpYXpFMWEwZUxkTzFjNVdacTF0?=
 =?utf-8?B?Q1YrZlBYVlFmY0hYVm9VWnRuRnRhRTJEc2RBb09aZDBDTmdEb3lyQUFsemhR?=
 =?utf-8?B?UlV6aEdETmlIWE1zUHJtOUMzVVlHWXZlNnRqT3Y4dmpWSitUMWR2NWpYTEpN?=
 =?utf-8?B?empiN2tNNFo3RmtMN2dYaXNwbm94U1ZUT2JXTjllMHg4bVRHdzB0SmxKN0Qx?=
 =?utf-8?B?U0MyRHA4aWRZZHcvbUcwcStIVlpLVTN0NWRHNWs1Z0tkU1FuYVFDNlFiWk9P?=
 =?utf-8?B?MHJIZW44M1N6aHp4OUFiQjlLaWh2WjNEWVZLcFljSHB0SzVvY0NmdTJxWG5X?=
 =?utf-8?B?UXVNcmpWVkphMC95K05lWWFNRmNqdkxhOU9HK2NlS29jeEM4SUkvQXFQTWE0?=
 =?utf-8?B?Y0JPdW1nOXpmS1o4bUpyTDdEWHJYNVhCenNhNzU1WUJxZ2twV3FRUzFURmQx?=
 =?utf-8?B?ZGNTbmwvTmV0V3dkanpBbjRFa0NqU2tqNlJzeFNRY3JpTXErUGpEdGQ1WW1x?=
 =?utf-8?B?ZUdkZzVsYlBpd0l2eUhiMU1EemtOQ3krb3l5ZHdqQlZkVDhaNnFUU25zdVFR?=
 =?utf-8?B?SUJGS1RCL1hha1ZwMzJTVzJVU0ZPOUVjRGcyUXZQNzNzMnRpN3ZrdmloWElr?=
 =?utf-8?B?OG9JU09IcXMxdXhITlpyN3hUMVdXbDJzbTkrYjFpM21zYkFTWm5KOGZteEtP?=
 =?utf-8?B?T240VFVTNHhpcVhGQjVrOUtlZ1hvVkRLSzM2bCtzMGoreVVUMm1kUzFtc0dv?=
 =?utf-8?B?ZnBRK1B5NjRORFg3VDBoaDhMK0owR3FsSUFnWVJtN04rRlhpN2F0Z01ZZHFz?=
 =?utf-8?B?MURVMjR0V1E3ampDRVlYME1SYmFkWnBnc2tTZDYzNzJWaUZCUmk3bUVUeXg2?=
 =?utf-8?B?TzZPWDBZZTgzR0d6dUw1UUw0QWxjK0VpVkMzT3JjamN2N0xLNlIvYnJ4TFZB?=
 =?utf-8?B?RGJwaFBvQ1NVWlkrNXBmalIwODNmejZyME8ybzlGWlQ0UGg1d20yNE95R1hw?=
 =?utf-8?B?cGRsMkRkRnlCZ3JHVFFDem1PWnczb2lPSTEvMGVDcXd4akMzV1p6cWtHZlcw?=
 =?utf-8?B?ckttT3VyTHh0dkdqSFdFZERwbThSNjNjdWprSUswRGt4cnErMnFIbURnRWhx?=
 =?utf-8?B?UTZ4WUJHYndLTU9oNnBTc1dyM0gzMXdHazQ1aWY5emFXMU1xZjc3OFdaNnJP?=
 =?utf-8?B?aDNGZm9RTjN6TElOTDVSQXNlektDcXhIbVlUN2EwQ0pXSEVzSHlNYm01UU9v?=
 =?utf-8?B?NDREbkNiY2wvVUt2Qm84dVFMbnBDZmtzRDJmb3Iyb0VRdHAyU0V6QUZYREVC?=
 =?utf-8?B?UlpiNERJbG80ZUJOZWZyK25DR25oMHllRGhWajJRWnZlYzl4S0wxdVgvbWNH?=
 =?utf-8?B?dnI3bC9jbVloLzRnR3ArcVg3SGxVbVd5OTl3RVd6SzRBVG80NEhYVjFNR2Ft?=
 =?utf-8?B?dGI3VjB4MTk2cmRoNjMwWVpHMFpxTm53bTlKcDJwUk83U2xNeWVsbFp3ZXp3?=
 =?utf-8?B?UkNJT1ZzNHQ5TG1jZEJNTVJJTCt3elFUam00Wml6SUlhT3RwcjMyeThkbjlD?=
 =?utf-8?B?UENHRHVwQXNCMTQxZHo5OFFlQWowckM5SjJsL2FBa2dRNC92UEpacW5oSnZP?=
 =?utf-8?B?YWl4R0xkNHFXcXNnVyt2UmZTK1JrMm5qcEZ0bHpzbU91ZVRBN2NLQTBuVmdn?=
 =?utf-8?B?UXQvOXo1d0IyTnRvSGhCeGxueEdCdkNsK1NTTy93NENOQWJxWUIxbkRMcktV?=
 =?utf-8?B?bnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F898614B1C305940ACD9740ED8DC75B1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PU1PR03MB2795.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96bc181f-a145-48bf-e3e9-08dac15b6ba9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 07:32:41.8670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ICUY8VIptblP8A5k0DpJGp/9Nll0i+lHGGiZE0gBJ476Q/6WGgrNTxNXwk4nN+/Y/x3S21QODst6Z4YKp4wwBB9HwxVLnYaRinMBQTRc2R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5913
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQW5nZWxvDQoNClNvcnJ5IGZvciBsYXRlIGR1ZSB0byBtaXNzIHRoZSBtYWlsDQoNCk9uIFdl
ZCwgMjAyMi0xMC0yNiBhdCAxMDo0MiArMDIwMCwgQW5nZWxvR2lvYWNjaGlubyBEZWwgUmVnbm8g
d3JvdGU6DQo+IElsIDI2LzEwLzIyIDA5OjM5LCBFZGRpZSBIdWFuZyBoYSBzY3JpdHRvOg0KPiA+
IEFkZCBNZWRpYXRlayBtY3EgcmVzb3VyY2UgYW5kIHJ1bnRpbWUgY29uZmlndXJhdGlvbiBmdW5j
dGlvbg0KPiA+IHRvIHN1cHBvcnQgTUNRIGNhcGFiaWxpdHkNCj4gPiANCj4gPiBTaWduZWQtb2Zm
LWJ5OiBFZGRpZSBIdWFuZyA8ZWRkaWUuaHVhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+
ICAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyB8IDM3DQo+ID4gKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVk
aWF0ZWsuaCB8ICA3ICsrKysrKysNCj4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgNDQgaW5zZXJ0aW9u
cygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRl
ay5jDQo+ID4gYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+ID4gaW5kZXggYzk1
ODI3OS4uM2Y1ZmMwNSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRp
YXRlay5jDQo+ID4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiANCj4g
Li5zbmlwLi4NCj4gDQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IHVmc19tdGtfY29uZmlnX21jcV9y
ZXNvdXJjZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+ICt7DQo+ID4gKwloYmEtPm1jcV9iYXNl
ID0gaGJhLT5tbWlvX2Jhc2UgKw0KPiA+ICsJCQkJCU1DUV9RVUVVRV9PRkZTRVQoaGJhLQ0KPiA+
ID5tY3FfY2FwYWJpbGl0aWVzKTsNCj4gDQoNClRoaXMgZGVmaW5lIGluIFVGU0hDSTQgc3BlYw0K
QUREUihTUUFUVFIwKSA9IFVGU19IQ0lfQkFTRSArIFFDRkdQVFIqMjAwaA0KDQo+IFRoaXMgc2Vl
bXMgdG8gZWl0aGVyIGJlIGFuIGFkZGl0aW9uYWwgdXNlY2FzZSB0aGF0IHNob3VsZCBiZQ0KPiBp
bXBsZW1lbnRlZCBpbnRvIHRoZQ0KPiBBUEkgYW5kIG5vdCBpbiBNZWRpYVRlayBkcml2ZXJzLCAo
YXMgaW4gdGhhdCBjYXNlIEkgYmVsaWV2ZSBNZWRpYVRlaw0KPiB3b24ndCBiZSB0aGUNCj4gb25s
eSB1c2VyIG9mIHN1Y2ggdXNlY2FzZSkuLi4gb3IganVzdCBhIHdheSB0byBhdm9pZCBhZGRpbmcg
dGhlIE1DUQ0KPiBpb3NwYWNlIHRvIHRoZQ0KPiBVRlMgZGV2aWNldHJlZSBub2RlLg0KPiANCg0K
SSBjYW4gYmFzZSBvbiBuZXh0IHZlcnNpb24gb2YgVUZTIE1DUSBwYXRjaCBbMV0sIGFuZCBjaGVj
ayB3aGV0aGVyIGFkZA0KbmV3IEFQSQ0KDQpbMV06IGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xp
c3RzL2xpbnV4LXNjc2kvbXNnMTc4MzIyLmh0bWwNCg0KVGhhbmtzLA0KRWRkaWUNCg0K
