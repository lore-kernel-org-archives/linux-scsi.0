Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361FDC77B73
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 02:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbjDUCth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Apr 2023 22:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjDUCte (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2023 22:49:34 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91366E75
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2023 19:49:29 -0700 (PDT)
X-UUID: 1f4fb194dfef11edb6b9f13eb10bd0fe-20230421
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=2dafxJrkg+PuerYlfRZYPuIZRD8/Mxplh4dpvY4WjcM=;
        b=BxkmhoUj4zkcRyOFbBpZ2ZyhS4Stivr5OAioAb5UozLT3WcnQUgPw2Xb6RYG+pgbzwXN+nOGc9lIFYlf7GR5iLbhYyshR4IGyh2h5tgKU/5RftiSzB1LIrUpuAFFgOS/BPCG11y+MFff5/3jj87FMAVyMl6cvXHCaVYIyBICUU0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:39868cda-ff06-4a75-81ee-279d92e2ffd2,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.22,REQID:39868cda-ff06-4a75-81ee-279d92e2ffd2,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:120426c,CLOUDID:e0a1c484-cd9c-45f5-8134-710979e3df0e,B
        ulkID:230421103225I3ISN862,BulkQuantity:1,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0
        ,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-UUID: 1f4fb194dfef11edb6b9f13eb10bd0fe-20230421
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <powen.kao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 257697579; Fri, 21 Apr 2023 10:49:23 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 21 Apr 2023 10:49:22 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 21 Apr 2023 10:49:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6rX9IaaJrlK2OTZsANlf5GkHHe8p8NKI+37AoboPOiKjr89ac2b2JQbA+EksrK4h6FqW0JBcGByWxOyaoeODuRw47xSV4cOrHFBegA1Ij+I+NHtU2HQ9HxhBT6laYcFet9G58c2dgfVtMip8r0zz8dhXmi9yKGMiJ45FkBiotGPCQwA11zVqyXWcZh+NaXWJMdoTyjSD++jQOUVYmTR6smLMJsCnXQXwj9GjvKRMkWI9K38LEZGbrFt45AYdUt0cIioun9UW1y29xxzYk25PfAQjBqt//zBDC1w/kFD5bve7clAO60ZJJQuNlWeh2+TNhORHuROQJkHy/OFLWXbNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dafxJrkg+PuerYlfRZYPuIZRD8/Mxplh4dpvY4WjcM=;
 b=m2c3XrRo75gLPkvEmQn/I6lys/tdeHp82IKnV+6EmxcWPAhpOUvy6h7RAlv5VdUb5fFl3BaxWCuEvNtqNnHDRZVy+CY2hnVoUk935li9kGBfVH3mMNMTu7O3yie+/dk0lHVlFys0qmH2LIDJni50PdFqgQ8fs1TOnYAob4p70Nigm4VucOXgnGItSOtykWV3RjoJ9vaY9zJDWFE86zZ5xMgWq5xGsvLHh9V+Za1i7BZVC1XJUV4zD4gGgOBfd5xYRObGE3H7OUV5wpndX4HOlEMveLy5HYePTMTx3o5tHbaKgl0bRMOrmgLkB7+1OQVmLY5H7/kxfxWwoZjGRDBQzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dafxJrkg+PuerYlfRZYPuIZRD8/Mxplh4dpvY4WjcM=;
 b=Xufgs1VmheJAwzL4N7Yopo0+5cdefnVJEMj6x5/7zALRauISpP5CnA2QQottsSZ4R6QEyLAgwO4KSfxxuZ+rNxQjIclvvLVYuqXbE2zoXaDdUqX/2emlORkGiicWbLPrIHl7LmSOlshrOj3Nr58mTeVG/SpUlsHIthJ5ScoJ3Ws=
Received: from TYZPR03MB5825.apcprd03.prod.outlook.com (2603:1096:400:120::13)
 by SG2PR03MB6501.apcprd03.prod.outlook.com (2603:1096:4:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 02:49:19 +0000
Received: from TYZPR03MB5825.apcprd03.prod.outlook.com
 ([fe80::f0ea:f00a:e800:a382]) by TYZPR03MB5825.apcprd03.prod.outlook.com
 ([fe80::f0ea:f00a:e800:a382%7]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 02:49:19 +0000
From:   =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>
To:     "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "mani@kernel.org" <mani@kernel.org>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>,
        =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
Subject: Re: [PATCH v2 0/5] ufs: core: mcq: Add ufshcd_abort() and error
 handler support in MCQ mode
Thread-Topic: [PATCH v2 0/5] ufs: core: mcq: Add ufshcd_abort() and error
 handler support in MCQ mode
Thread-Index: AQHZcXCB+koEtiXBfE6+nSrBisDW4a81FNoA
Date:   Fri, 21 Apr 2023 02:49:19 +0000
Message-ID: <741e3f01cd1d89e797a9c45fd7e6b09489bfb59f.camel@mediatek.com>
References: <cover.1681764704.git.quic_nguyenb@quicinc.com>
In-Reply-To: <cover.1681764704.git.quic_nguyenb@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB5825:EE_|SG2PR03MB6501:EE_
x-ms-office365-filtering-correlation-id: 7b9cbc9c-e8b1-4b00-7854-08db42130122
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MYyTg0BtqrVKSm2lniujoczLZ3bXjOnIvUWgB1uHw5Zc29UivQrdnpPGQlP1yEoI9irjQ052FM+CVZiUzDNc6iw19y9icY19Wk0sECSK65nSAU5smElNEmHn1ThcusHHCz77UaCyBcjTnYiCAJoEaWVFGD2CwbaMwKISET30Acdnsz7JzwVPsy6nMdU4oZwtCRMdv7yEzsXKvJiDb+jfDsjFSsl4E+TlleBfz1sKo1ofiGAF0sCWRytVYv6mVm3MeXoJwxxHtGXGkHv8Cncmvthdk35OZr+hgVXTesedqr9zkn3OON9pSeWvmMU4gNUgLiy9DfktNXJAz9y5aYgp8OtBT078Wc5RTlNpuBlHm6OGUe2s22xV26OF95ECLoL6EdGdwjmTqTPgq2kbc8MaHd9yp2fEcODEk3NFmhyojHAkVd92BK0bUtMHb2/RKvNcvdI+y+JKfoAqJJRNYKAJ0v8qPNWXDESQKTSKgqpFjcPYsFTvQaxjm8ajqaHPWuYZiGgGsEuEeM8dKRojpjCHez0A5RMfYd6THE2YWZKiY9JrVAMni7Ua77AM2aqyeFJeZv+6dzT89wzIDnIy5q24oJRa+i65N8Xikuu34fdbttgXjVdM1RuK9GqAo65wagErZUynCpES3UdhFA+YIfGrK/rx4a8HsGDYz2w51LkzwaA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB5825.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199021)(107886003)(83380400001)(26005)(6512007)(6506007)(4326008)(316002)(66476007)(66556008)(66446008)(64756008)(66946007)(76116006)(6486002)(2616005)(71200400001)(186003)(36756003)(86362001)(110136005)(54906003)(38070700005)(85182001)(8676002)(38100700002)(2906002)(5660300002)(8936002)(7416002)(478600001)(921005)(41300700001)(122000001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFlCR0MwQXJRL3U2bWVWUHR2OEpTUEdHNTBRdEh5SEFuQitKSVNSVDNhMi9q?=
 =?utf-8?B?Z1hrZzBFTjJvS2QzRUIycHFuTGt5UmF0alV4T0x4REIxWDFWNnZ2dFNvRldU?=
 =?utf-8?B?S1FhN2Y1SklxVWJnNzd1SnFtR0xMMVBzMUR1VE40QjJ0RjRONjRTenkvYy9u?=
 =?utf-8?B?NFZNZVk0cWRNalJQNUpIVWhFWDdRRmhhMnNiY3g5TU1yMkR5OWtxVGpFOWNB?=
 =?utf-8?B?NVdiQW9ZbllzTGRQdDZ4MnZDaXpkdjRhQm5pOTMyUFVVWG12Mjh6RzBwMFNw?=
 =?utf-8?B?UFNielJyUWxPaE4xekpXN1EzaWtkOXhQR3NIeTY2RXk0UVRuNFBKNnd0MmxM?=
 =?utf-8?B?c1U1V1B0YnRVQ1RLL1BvdEU2SEJEVmpTUHZYOEs2bUEyb1dOcG8wbElrN1k3?=
 =?utf-8?B?MTNyVjBvQ1lEZy92TkU4VHY5KzFpYVI2SXlENWZaQnJKUTZiV0d0Z1drcVFz?=
 =?utf-8?B?Q2JDa1RvNytWaEx6S3ZPZEZTN1EvTXpsM25vOFdCNWFrMFlWNnhsUi9CZFpy?=
 =?utf-8?B?RGZLWWVRbi9aZ2c2NW1FSE8vbTlSVnZRZHc3NExQSkljbEZUQjVOZUk2M1dR?=
 =?utf-8?B?WDFUeE5WY0hFMWt4YlR4RnUySkwzb0U0N1VjMkVGaEZaUEdpL2t5ZWpQVEdw?=
 =?utf-8?B?NzVKc2kvL2Y5Y09yOGZyUXkvdThUOVJFa0h2azVCQUZodGE1UmRackNIWDlN?=
 =?utf-8?B?ck5BN3JtL0h2Kzl3U2o3Z2lGb1V4V0MxZ1BWODNEaStZYUpNVDEwVDNjMEZz?=
 =?utf-8?B?OS9OdFV3dGQ3b0hhY3g2MXl3d01rYXAxWkFlSWpvdmFOU2R4ZW5UdzN6RzZ1?=
 =?utf-8?B?MnMwYVlOb3pJaUFGSVlRRHlxbDBtR0VEMjFncGVUblJlM2JWM09EcW9PamNH?=
 =?utf-8?B?V2FyMjB5UzlRc1BsRGttODZGSnpTOXZuZldJUTFtcVh0MHpQcUFCT2pNcEhZ?=
 =?utf-8?B?RDVSUWJSS3I3K2xlUXNxSjR2NjNQT2pja0pramhxYTVSVHJGb0Vnc01JM2JG?=
 =?utf-8?B?ck45YUgrUVpYSXV3VGlrUitPbFdFU0xFenpWRXBuem01bmZrWEdNVkJOSDQz?=
 =?utf-8?B?T3Z5NDlsTkFQc0tDWXZpek83WW15emk5QjZoWEZUeEFwcnM3S0VzOVg3TUJF?=
 =?utf-8?B?UDFCa2M4QjJjU1cySDBzdVNISjBlUzhEYnlOaEZoaHYrYTR2NHFQU2lwbEgx?=
 =?utf-8?B?dU5KQy9NSWpvY2xkaExwMEtYNzlWY2VjRzVUU09PaVdUdkNnSGk5SG9LNU5H?=
 =?utf-8?B?TUt2dG5qdDRSNE15elpzWlBCcGM3Y2dpSlAwK2J4UTRhZno5a1NVZ2ZWemhT?=
 =?utf-8?B?ODJpOU5xdGtDZmZCR04vU0t1QTU1OE9VM3ZEeWY5eWM0ejFDSC8yeWMvM1VC?=
 =?utf-8?B?OU5wOXdCQVpkNUplZm9HSzhOYmpJVndTY0JFTVM3RUZ2YlBpSzVuUmdralZm?=
 =?utf-8?B?WXRKcU5wb0ZmRUJXRXZoeUNvZXhaTk9wYUhWeTJSbzVGWXRuKzdVbytBOU03?=
 =?utf-8?B?TFM3TnNMVWhiaFhDcHRNdm5EdEVRUFlpbnNyK3crSllobmlrOFZlMkJPTkpl?=
 =?utf-8?B?SHhFQndHZTdScUl5dXdKVWxTdm82SzJMTTlEQlVWUVcydkdBQWx0dktMbk9t?=
 =?utf-8?B?Y3ZYTnBlUDdxd2VvN0lQK0h2UGYxdm1obURQWDJZaHAvL0Y1U0Q3S2g1b3dD?=
 =?utf-8?B?L2o4OUZnRHc1UVJGMjlvRTJqWVBqck9jdzVSQTJNekhxbi80ZjgrSVk1MElj?=
 =?utf-8?B?ZlBORjkwOFlRWnRKb0NIVXdVVE5nd1V2dGZOMERML3ZtaWJjMCtrUzVUMFNU?=
 =?utf-8?B?WXZ0SDQ1anFOSmlZUHY1QlpUbXY0THVEdDdTREZBN0pUZ0VSS0V0Q2VHWXBF?=
 =?utf-8?B?MjZvcWJPajdNaS9zYlVpNDlSbWowTjFsWm5Ralh2RHhxQzMvdzIzd1A1RWgv?=
 =?utf-8?B?aVZlTzhjSnNocklTejBNMlVIKzNGVFg4VHVqcHpYbnFiRUh6M0pENUMrZ0Nm?=
 =?utf-8?B?R0VwRTVnTFh0dFVWMUY0NXZOMUpSUU5kN1dWcHhsTllRYlhKOXRzY2o1YkVo?=
 =?utf-8?B?MGJITUdneEttOHVDUFI5cVVIM0VUdWl3cE4wU3NuUjNzQTdIcFVOcFJrOGtm?=
 =?utf-8?B?cmppQmVxc3VEcFJwZWV6ZTlkVDcrMUtHeTZiaHB4aUIzejcxQ0grU0tBN1Nk?=
 =?utf-8?B?RUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C75304AF1659864198CEB71CD74F61EC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB5825.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9cbc9c-e8b1-4b00-7854-08db42130122
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 02:49:19.3749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tqqIm5srhyPqAVv/aPVAacFIch1juhu9MMRP12UgO+5xQI7OFlxAmZFY2qIiXsSGelXzGpiLgjUXVisNaSr13A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6501
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIzLTA0LTE3IGF0IDE0OjA1IC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRoZSBjb250
ZW50Lg0KPiANCj4gDQo+IFRoaXMgcGF0Y2ggc2VyaWVzIGVuYWJsZSBzdXBwb3J0IGZvciB1ZnNo
Y2RfYWJvcnQoKSBhbmQgZXJyb3IgaGFuZGxlcg0KPiBpbiBNQ1EgbW9kZS4NCj4gVGhlIGZpcnN0
IDMgcGF0Y2hlcyBhcmUgZm9yIHN1cHBvcnRpbmcgdWZzaGNkX2Fib3J0KCkuDQo+IFRoZSA0dGgg
YW5kIDV0aCBwYXRjaGVzIGFyZSBmb3Igc3VwcG9ydGluZyBlcnJvciBoYW5kbGVyLg0KPiANCj4g
QmFvIEQuIE5ndXllbiAoNSk6DQo+ICAgdWZzOiBtY3E6IEFkZCBzdXBwb3J0aW5nIGZ1bmN0aW9u
cyBmb3IgbWNxIGFib3J0DQo+ICAgdWZzOiBtY3E6IEFkZCBzdXBwb3J0IGZvciBjbGVhbiB1cCBt
Y3EgcmVzb3VyY2VzDQo+ICAgdWZzOiBtY3E6IEFkZGVkIHVmc2hjZF9tY3FfYWJvcnQoKQ0KPiAg
IHVmczogbWNxOiBVc2UgdWZzaGNkX21jcV9wb2xsX2NxZV9sb2NrKCkgaW4gbWNxIG1vZGUNCj4g
ICB1ZnM6IGNvcmU6IEFkZCBlcnJvciBoYW5kbGluZyBmb3IgTUNRIG1vZGUNCj4gLS0tDQo+IHYx
LT52MjoNCj4gcGF0Y2ggIzE6IEFkZHJlc3NlZCBQb3dlbidzIGNvbW1lbnQuIFJlcGxhY2VkIHJl
YWRfcG9sbF90aW1lb3V0KCkNCj4gd2l0aCB1ZnNoY2RfbWNxX3BvbGxfcmVnaXN0ZXIoKS4gVGhl
IGZ1bmN0aW9uIHJlYWRfcG9sbF90aW1lb3V0KCkNCj4gbWF5IHNsZWVwIHdoaWxlIHRoZSBjYWxs
ZXIgaXMgaG9sZGluZyBhIHNwaW5fbG9jaygpLiBQb2xsIHRoZQ0KPiByZWdpc3RlcnMNCj4gaW4g
YSB0aWdodCBsb29wIGluc3RlYWQuDQo+IC0tLQ0KPiANCj4gIGRyaXZlcnMvdWZzL2NvcmUvdWZz
LW1jcS5jICAgICB8IDI1OA0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrLQ0KPiAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QtcHJpdi5oIHwgIDE1ICsrLQ0KPiAgZHJp
dmVycy91ZnMvY29yZS91ZnNoY2QuYyAgICAgIHwgMTQwICsrKysrKysrKysrKysrKysrKy0tLS0N
Cj4gIGRyaXZlcnMvdWZzL2hvc3QvdWZzLXFjb20uYyAgICB8ICAgMiArLQ0KPiAgaW5jbHVkZS91
ZnMvdWZzaGNkLmggICAgICAgICAgIHwgICAyICstDQo+ICBpbmNsdWRlL3Vmcy91ZnNoY2kuaCAg
ICAgICAgICAgfCAgMTcgKysrDQo+ICA2IGZpbGVzIGNoYW5nZWQsIDQwNCBpbnNlcnRpb25zKCsp
LCAzMCBkZWxldGlvbnMoLSkNCj4gDQo+IC0tDQo+IDIuNy40DQo+IA0KDQpSZXZpZXdlZC1ieTog
UG8tV2VuIEthbyA8cG93ZW4ua2FvQG1lZGlhdGVrLmNvbT4NCg0KDQo=
