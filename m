Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57051C07548
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 06:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbjKOG6N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 01:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjKOG6L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 01:58:11 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04289BB
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2023 22:58:04 -0800 (PST)
X-UUID: 4f37fd60838411eea33bb35ae8d461a2-20231115
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=r1Yxnwd0nASXx/EVdWhvyH905eynOp4+YASdXOEx28I=;
        b=tO1qiddrsus7w/QzutSFXYxISQY7mm7J0HC+jSXNDbbIqpqiRwMTKwn+ZeFXTZZGgi8tKGmBqh5LrBUGvbOZOFwhhSEZzdYXPrMZptP7pYe6z0kkjIoStvgJFwSBZDo7e4ZLTAgIrB0kncYs3/GE+AATnPhlMvoELwbUDtdihTU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.33,REQID:f53a10ca-e280-430f-b911-711cfa631615,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:364b77b,CLOUDID:16188dfc-4a48-46e2-b946-12f04f20af8c,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,
        DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 4f37fd60838411eea33bb35ae8d461a2-20231115
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 222896927; Wed, 15 Nov 2023 14:57:58 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 15 Nov 2023 14:57:57 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 15 Nov 2023 14:57:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWNZyEHXw01RogudUqtrb2uY4iZY7xfsTMuP8dlRIB9CdN2zsr8j0aOO791UiHWTItlXgOXIbNdJmq9cPHysPvz6ijhK/63c+wRL6Zo4f4RSyJj0h8D0G/3Abjj3wXQGAw/WUomcOZyxUTzPliEtKlGEFh4Uxvv2+lxSkxjAEwQkJAZ5uzJV8d1cp9/Uoos0vsktO+7zz9KNXFsrlDl4d1a7oV31A9VFmtZBRlodxKdTgD7l24xuUcqNPNBz2/e0HZXVFhv2A64PF2H+uTGfQlb+1PUJeT54nTleEWn23hKH8lZqie+xdrFbQlRu7QhOzIQcGYNyXWsPk8DspqWczg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1Yxnwd0nASXx/EVdWhvyH905eynOp4+YASdXOEx28I=;
 b=fXr9uLEXaw2uDhvM7Fl1Wle1IvmEVXD/JXGdVjUKh5bLEevzePtivlYocF0D/IhOrcyoZLzGk8A5f8kUWjf3cWs+OTG9bdbaB0MxOS0zkzYKOxEF/sOqsNGprkIPgnsA02BV5GJBgN2Ld9vy5H2+7QHehxMH4pUg9PDX1spGypF0RzM9Jglj8/dMwUSYIJt22KhjCzGm8CCiK0wUJQGobaM/jH7FiDqZPh4iRpZrlXrczpIZ0Bu3BdgYWFZJseRSjxhenNhO09GTjHyuGgbID/KfP4jZBfDzAwb97dLzdCnzRC8ifV/uVfyyc0CueX8vziIPX9HYaAg0pXwtLR4Epg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1Yxnwd0nASXx/EVdWhvyH905eynOp4+YASdXOEx28I=;
 b=jAPc6mcVCAdstCEg0OFfa28wwFvn80Nziq8Xv2WiTpiWXgNki5BekSdyKh45Hg+nH58/BUY6FOppEgsLxrc2HWApoi0IH7IhMf3TeL3pmwhec0knTJ4f8sYwUMW3OPBIOJAfej6nkKhd9muzUFPtc8wXk/8KN7XvedvKNoObzvI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7528.apcprd03.prod.outlook.com (2603:1096:820:ed::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Wed, 15 Nov
 2023 06:57:54 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::744d:5eb2:b571:9c45]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::744d:5eb2:b571:9c45%7]) with mapi id 15.20.6977.029; Wed, 15 Nov 2023
 06:57:54 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "Arthur.Simchaev@wdc.com" <Arthur.Simchaev@wdc.com>,
        "quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>
Subject: Re: [PATCH v2 09/12] scsi: ufs: Simplify ufshcd_abort_all()
Thread-Topic: [PATCH v2 09/12] scsi: ufs: Simplify ufshcd_abort_all()
Thread-Index: AQHaF4/bKk2+xqxw/UGntLVSEtHMyLB68vuA
Date:   Wed, 15 Nov 2023 06:57:54 +0000
Message-ID: <13d51fbcb0c7fc91d7e655057133f6c47cfebd34.camel@mediatek.com>
References: <20230727194457.3152309-1-bvanassche@acm.org>
         <20230727194457.3152309-10-bvanassche@acm.org>
In-Reply-To: <20230727194457.3152309-10-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7528:EE_
x-ms-office365-filtering-correlation-id: 76fc9060-a835-4421-c382-08dbe5a83108
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cAMX+0JYsVXgq/6H+TXhbwQcf1N029DRcpPL747H/5cpNBwZL7/256W4qv4A8TgJLGWuWUFFyEukyWSyCkL/ldLZnDXtcAGOMgIGfGm+4VmYHHffmpxL5Ep3SN6qdTsjKi9lHOtC2aFwLyjoRhQ7LrJZr4/rPZbm08US2FGHx/bsYz+2TOE1/SZzTjM66aFlz5ER1nh7hrxO5zcCza3cuMBjfeQSsLagY6lpd2JvWveQ8bcKyrf2FVv9GO2qaJZ8jRyyTaYzedI5HcsKki/RTtX2WSKawEWIaBTQi9O1HErPtzD21PQPx2RyoL8ALW6lHdzuRJ9i8aEMr2US1G88WbNKNWziz7FUIuKqVq7izoufafwSiy3Cm2FoP2iq9ljcqrDjflr7+FMgIvvMYSMtrCeHBZ0EgpAZY56AUQE3lW9r4epKD3f7NHMbObQkZDARVnw1MXLgRnYhXWgIDlinPAlpkvgUrJd0rZy8E1xtiqhDUSHV/roDc7Huk6Jycf86QWqeO8LMnaWYp0ERkEoNMqELfVZBqzo5FeYLfvmHnAPwhrhm2MiXhnXrXoodj28OgpYQtkmwsA8dqW/Ad0LlZimp60Gk42eJBRONoutadh0n++6f9c4ErgwuxDRccVg9PfSpUIrWtDuGsww7+vvH9d4XsAfDUxM9Co66pVcl32PayQGEG+AMXh9utjEavUVl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(366004)(136003)(376002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(2616005)(8936002)(8676002)(6506007)(83380400001)(6512007)(26005)(38100700002)(122000001)(478600001)(6486002)(71200400001)(110136005)(91956017)(316002)(54906003)(76116006)(64756008)(66946007)(66556008)(66476007)(66446008)(38070700009)(41300700001)(36756003)(85182001)(2906002)(86362001)(5660300002)(7416002)(4326008)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWhWRmhLUGFVNG55QjZWVWNKN29VTENSREswLzQveldvWTZPdnN3NER6eEM3?=
 =?utf-8?B?TEkvdi9keWRqd01RV0xLVHc2bzcxRVBaVjY3R0JRU241WWlBeThrZDRMSnN2?=
 =?utf-8?B?d09RMVZWK0hzWndtN0JZUXIxVEZtcWttSzB5VjVPNUJLalBCQXhQS0Q1bSsx?=
 =?utf-8?B?K010TEM4dHdyZkxEUlpjaEdvazZ3VDlaKytlRDVYcFNaOWNNOUFoTXV0SFF4?=
 =?utf-8?B?b2t1cERQSWtYZ1VLbktDVHlSWXNrMFUydlpma1ZpNTk1NVY3c0FKRllLT1RM?=
 =?utf-8?B?bXdpMi9IRzRvNVpPeEhmMzBldm1DWmNyQ3R6T1FwMHpkdVljWTBGTW50SHpH?=
 =?utf-8?B?UmVKRXhlUHlpZEYyRlgvOEo5aUFsRTU3UjdpbXR1MjZHUyt1K2dXNEtKQjN2?=
 =?utf-8?B?NzF4VWRaQWZSU2JUdkZCSzBzdnFOMEFZdFREYU1Pd3VvY0g0WE0rL0w0ZTcw?=
 =?utf-8?B?R1gzY0xvY0RzcUJnYlVVd2JMbkczRHlzMU15V1NydEVjRllFaWFMQVZiczFS?=
 =?utf-8?B?V1BZVG01ejRRVmlyZnNaNFdUcWxhMHZhZ1dvRFI5L1RvdTFqZGVxL3dJU0Rx?=
 =?utf-8?B?aFV5OWFQb3R4eWdVb3RWUE1tUWdwVlVYWmdjQllscnpweHdGcUtqbTNhZmxy?=
 =?utf-8?B?cjUvVmE0MTZpWWlwZzhZdy83NjdmaGtabVJDcEhlZUNLY3pDcmNsUjhWT3ZU?=
 =?utf-8?B?bkIva1ZrdU5kSk8yd3ArV3VSVC8wWHlFNFVpc0tLVjMvUm81b2R0djdIZmRx?=
 =?utf-8?B?LzRsa09ZcExlUjZHMFcreERKeCsyQ0JlTk4zK1NwbThKOUVrdGlNQ0NBcVND?=
 =?utf-8?B?S1hmUnVBckRSeU00dEt5MDVES3VxUUtMeGc1NlpxVXdQOVd2VUt1YXdDNTlk?=
 =?utf-8?B?c2s5SmhndzhycGlmd0VxcG5zcmd6S05iUG1KZG85bGo1N1crNXFjdHFMVm9G?=
 =?utf-8?B?VG5qTWtsZ0ljSzhWMGQ5SFd4dTJPMG5lNU9JZ1ludTNmak1FTEcvUUVwYVRm?=
 =?utf-8?B?Q2hTYVpBRno0aENFNzArRkNJYmcxalNOSGhULy9ERXlrZXRZTm1saGszemZN?=
 =?utf-8?B?eThza3pOcXZPUFdLRWVVN3BoTjF0ekhQbkRuMjNPYjI4ZS95YTUrOHN2T3Fl?=
 =?utf-8?B?TnVkUi9pM200NGh2SXMrTy9Sam1qRXFCbWc5NWRNMjB1d0FmazRmbUZyVEJ1?=
 =?utf-8?B?ZDhaWllzUHdaY3lLcHdpWnY0eW85RGhSQW1mRktaNVJWK3l1MU9sVFFEcGFX?=
 =?utf-8?B?QmJrcEhwNWhpMVJlTEt0bzVVeElmNVRvL09NeFRTUTVzcE1lRkZ5eUpKYkE4?=
 =?utf-8?B?Zkl4ZkFQNGIzdjJVR0pyUkJJSUM0YVkyTTlwQWxkUGNFRjZiZjY5TWQ0RVVO?=
 =?utf-8?B?NUlQeXR2blRVbHY3Q2hZaU42K01TeTByQjFEWWxnb2U1Vzh6U0trNC9iVlds?=
 =?utf-8?B?OVpjTXdhY3hDMXJxZVFRS1ZqU3o1aFFFU2RmL2VFWUdOMDdZd0JJaXEwTlUy?=
 =?utf-8?B?ckxiQkprMkVPV0lFbjF3MWh3QVJBZ0w5dU5sYVlONExvdzhaWDBOUHdSemUv?=
 =?utf-8?B?bjhSUXB0WC96NWZ1R1dFdW5UNnh4UTRGZmpjbTQ4K3FWeEpsR0piR1lCaDdl?=
 =?utf-8?B?ZGo1VDI1N1FvbTZSZFFOTzZWT2RUVC9zdm9scm5OVyszSkxsZzNhTWJ4ZEZP?=
 =?utf-8?B?WUFMOExzT2JMM2RXMk1lRXc2c2dGUXJyVUhLYnNJTmhPSHBCYTZZYVV4aTMw?=
 =?utf-8?B?Yks5QjRMODMwekpBZnNLaHRZUGlqSDZ0cHZlN2R6cHR4ZUZ4V2NkODFJb3M3?=
 =?utf-8?B?Y1VBYmZqdllTSk54cTdWZytkZWMreDVhTnlQSUEwQWFhQ0hlZTM0dlI2d25I?=
 =?utf-8?B?YkhJMWQvOXcvSzQ2b1A1c21aTXQrZ1Azc2JZZnRvaUZybVRlQlFqN2E3Z0ll?=
 =?utf-8?B?ZG5Ja0FEQy9weCs2OHZaa3ZCaHBJSU8xZHhLYW1nMUFoMDBrRUFVSGRDR3hO?=
 =?utf-8?B?cU5CeVM0VXFZdVFpZnh1WTB5elFEcjEvdlV2RXVodzJ4K1dwckNiczRBUmVT?=
 =?utf-8?B?dkNzUFJKeWkzMnBIaXQ4TGgwWFhkdXp2NnZyVWFKWVdIKytSaElOTE1XYi9n?=
 =?utf-8?B?b0doL05jWTA2UURITTUxRUtLZEMva2djZTFxSlRyRVNDY3hldGsrUFo0TVVr?=
 =?utf-8?B?Unc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1711B8C0AD88DB4C8770C45D77A00C2B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76fc9060-a835-4421-c382-08dbe5a83108
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2023 06:57:54.2634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0U2wStJZTJgZbtdeE4fZi5Zso/r2svKxwn4afszCN+fvvGQBVnkZmVy0y59Warh4CJy7h9JJ1HaDPnIBZyS5Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7528
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDIzLTA3LTI3IGF0IDEyOjQxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFVuaWZ5IHRoZSBNQ1EgYW5kIGxlZ2FjeSBjb2RlIHBhdGhzLiBUaGlzIHBhdGNoIHJld29y
a3MgY29kZQ0KPiBpbnRyb2R1Y2VkIGJ5DQo+IGNvbW1pdCBhYjI0ODY0M2QzZDYgKCJzY3NpOiB1
ZnM6IGNvcmU6IEFkZCBlcnJvciBoYW5kbGluZyBmb3IgTUNRDQo+IG1vZGUiKS4NCj4gDQo+IENj
OiBCYW8gRC4gTmd1eWVuIDxxdWljX25ndXllbmJAcXVpY2luYy5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiAtLS0NCj4gIGRyaXZl
cnMvdWZzL2NvcmUvdWZzaGNkLmMgfCA0NiArKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0t
LS0tLQ0KPiAtLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygrKSwgMjYgZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBi
L2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gaW5kZXggYzAwMzFjZjg4NTVjLi5iZjc2ZWE1
OWJhNmMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIv
ZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBAQCAtNjM4Nyw2ICs2Mzg3LDIyIEBAIHN0YXRp
YyBib29sDQo+IHVmc2hjZF9pc19wd3JfbW9kZV9yZXN0b3JlX25lZWRlZChzdHJ1Y3QgdWZzX2hi
YSAqaGJhKQ0KPiAgCXJldHVybiBmYWxzZTsNCj4gIH0NCj4gIA0KPiArc3RhdGljIGJvb2wgdWZz
aGNkX2Fib3J0X29uZShzdHJ1Y3QgcmVxdWVzdCAqcnEsIHZvaWQgKnByaXYpDQo+ICt7DQo+ICsJ
aW50ICpyZXQgPSBwcml2Ow0KPiArCXUzMiB0YWcgPSBycS0+dGFnOw0KPiArCXN0cnVjdCBzY3Np
X2NtbmQgKmNtZCA9IGJsa19tcV9ycV90b19wZHUocnEpOw0KPiArCXN0cnVjdCBzY3NpX2Rldmlj
ZSAqc2RldiA9IGNtZC0+ZGV2aWNlOw0KPiArCXN0cnVjdCBTY3NpX0hvc3QgKnNob3N0ID0gc2Rl
di0+aG9zdDsNCj4gKwlzdHJ1Y3QgdWZzX2hiYSAqaGJhID0gc2hvc3RfcHJpdihzaG9zdCk7DQo+
ICsNCj4gKwkqcmV0ID0gdWZzaGNkX3RyeV90b19hYm9ydF90YXNrKGhiYSwgdGFnKTsNCj4gKwlk
ZXZfZXJyKGhiYS0+ZGV2LCAiQWJvcnRpbmcgdGFnICVkIC8gQ0RCICUjMDJ4ICVzXG4iLCB0YWcs
DQo+ICsJCWhiYS0+bHJiW3RhZ10uY21kID8gaGJhLT5scmJbdGFnXS5jbWQtPmNtbmRbMF0gOiAt
MSwNCj4gKwkJKnJldCA/ICJmYWlsZWQiIDogInN1Y2NlZWRlZCIpOw0KPiArCXJldHVybiAqcmV0
ID09IDA7DQo+ICt9DQo+ICsNCj4gIC8qKg0KPiAgICogdWZzaGNkX2Fib3J0X2FsbCAtIEFib3J0
IGFsbCBwZW5kaW5nIGNvbW1hbmRzLg0KPiAgICogQGhiYTogSG9zdCBidXMgYWRhcHRlciBwb2lu
dGVyLg0KPiBAQCAtNjM5NSwzNCArNjQxMSwxMiBAQCBzdGF0aWMgYm9vbA0KPiB1ZnNoY2RfaXNf
cHdyX21vZGVfcmVzdG9yZV9uZWVkZWQoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gICAqLw0KPiAg
c3RhdGljIGJvb2wgdWZzaGNkX2Fib3J0X2FsbChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgew0K
PiAtCWludCB0YWcsIHJldDsNCj4gKwlpbnQgdGFnLCByZXQgPSAwOw0KPiAgDQo+IC0JaWYgKGlz
X21jcV9lbmFibGVkKGhiYSkpIHsNCj4gLQkJc3RydWN0IHVmc2hjZF9scmIgKmxyYnA7DQo+IC0J
CWludCB0YWc7DQo+ICsJYmxrX21xX3RhZ3NldF9idXN5X2l0ZXIoJmhiYS0+aG9zdC0+dGFnX3Nl
dCwgdWZzaGNkX2Fib3J0X29uZSwNCj4gJnJldCk7DQo+ICsJaWYgKHJldCkNCj4gKwkJZ290byBv
dXQ7DQo+ICANCj4gLQkJZm9yICh0YWcgPSAwOyB0YWcgPCBoYmEtPm51dHJzOyB0YWcrKykgew0K
PiAtCQkJbHJicCA9ICZoYmEtPmxyYlt0YWddOw0KPiAtCQkJaWYgKCF1ZnNoY2RfY21kX2luZmxp
Z2h0KGxyYnAtPmNtZCkpDQo+IC0JCQkJY29udGludWU7DQo+IC0JCQlyZXQgPSB1ZnNoY2RfdHJ5
X3RvX2Fib3J0X3Rhc2soaGJhLCB0YWcpOw0KPiAtCQkJZGV2X2VycihoYmEtPmRldiwgIkFib3J0
aW5nIHRhZyAlZCAvIENEQiAlIzAyeA0KPiAlc1xuIiwgdGFnLA0KPiAtCQkJCWhiYS0+bHJiW3Rh
Z10uY21kID8gaGJhLT5scmJbdGFnXS5jbWQtDQo+ID5jbW5kWzBdIDogLTEsDQo+IC0JCQkJcmV0
ID8gImZhaWxlZCIgOiAic3VjY2VlZGVkIik7DQo+IC0JCQlpZiAocmV0KQ0KPiAtCQkJCWdvdG8g
b3V0Ow0KPiAtCQl9DQo+IC0JfSBlbHNlIHsNCj4gLQkJLyogQ2xlYXIgcGVuZGluZyB0cmFuc2Zl
ciByZXF1ZXN0cyAqLw0KPiAtCQlmb3JfZWFjaF9zZXRfYml0KHRhZywgJmhiYS0+b3V0c3RhbmRp
bmdfcmVxcywgaGJhLQ0KPiA+bnV0cnMpIHsNCj4gLQkJCXJldCA9IHVmc2hjZF90cnlfdG9fYWJv
cnRfdGFzayhoYmEsIHRhZyk7DQo+IC0JCQlkZXZfZXJyKGhiYS0+ZGV2LCAiQWJvcnRpbmcgdGFn
ICVkIC8gQ0RCICUjMDJ4DQo+ICVzXG4iLCB0YWcsDQo+IC0JCQkJaGJhLT5scmJbdGFnXS5jbWQg
PyBoYmEtPmxyYlt0YWddLmNtZC0NCj4gPmNtbmRbMF0gOiAtMSwNCj4gLQkJCQlyZXQgPyAiZmFp
bGVkIiA6ICJzdWNjZWVkZWQiKTsNCj4gLQkJCWlmIChyZXQpDQo+IC0JCQkJZ290byBvdXQ7DQo+
IC0JCX0NCj4gLQl9DQo+ICAJLyogQ2xlYXIgcGVuZGluZyB0YXNrIG1hbmFnZW1lbnQgcmVxdWVz
dHMgKi8NCj4gIAlmb3JfZWFjaF9zZXRfYml0KHRhZywgJmhiYS0+b3V0c3RhbmRpbmdfdGFza3Ms
IGhiYS0+bnV0bXJzKSB7DQo+ICAJCXJldCA9IHVmc2hjZF9jbGVhcl90bV9jbWQoaGJhLCB0YWcp
Ow0KDQpIaSBCYXJ0LA0KDQpQcmV2aW91cyB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2sgcmV0cnVu
IGZhaWwgd2lsbCBicmVhayB0YWcgaXRlcmF0ZQ0KYW5kIHJldHVybiB0cnVlIHRvIHRlbGwgY2Fs
bGVyIG5lZWQgcmVzZXQuDQpCdXQgdGhpcyBwYXRjaCBvbmx5IHJldHVybiBsYXN0IHRhZyB1ZnNo
Y2RfdHJ5X3RvX2Fib3J0X3Rhc2sgcmV0dXJuDQp2YWx1ZSwgaWYgc29tZSB0YWcgYWJvcnQgZmFp
bCBhbmQgbGFzdCB0YWcgYWJvcnQgc3VjY2Vzcywgd2lsbCBub3QNCnJldHJ1biB0cnVlIHRvIHRl
bGwgY2FsbGVyIG5lZWQgcmVzZXQsIGFtIEkgcmlnaHQ/DQoNClRoYW5rcy4NClBldGVyDQoNCg0K
DQo=
