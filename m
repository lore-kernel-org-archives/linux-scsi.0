Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D9FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 13:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D577564D9A
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 13:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhBWNu0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 08:50:26 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20537 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhBWNuZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 08:50:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614088329; x=1645624329;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kSM4DPF4p24/wpZ+Ziw2QLdUn9O7CFKjV1OoJdgN95o=;
  b=AiIDunSZKQj1ayTi9FBiIblNQmRTuP4GALZemDuWvTm6wrG9FANqUP0X
   sZkqiNK3Tu9Dh97yesaEo2/ihrGcua+WBG9meS5/Z4SqpmG7unVx7nAxf
   4/YsojjSYrD/vXGf6LhAqUBjw/LJKahO4C0WbTN7uoEBwKKRGSVWHGAgy
   8c+A4p3sIzTA0WgC+MLZzUCKDgoE/gVK2y/ySHx/05dIZEShzEx9KUs/2
   Q4KGcCSkOQNqw/FWumwVOCVoP2FfCSxXxc7D90ROng3qn7aZH8aXGR40b
   U2lu5oT2zqV0p355VCOKxH6tOO7Ox78fAtKGifAUAYgMQgkIz0wN6bXNM
   A==;
IronPort-SDR: pkUNaD0vUbZoyhZO6o+m6qa8A8lSpfPzaGCA6enXj9t65pveQsoDQteYTawaflKpgvLCJgIbBW
 j2ynxwLaTl0Eev6+NZ4T+h7a7Jw/nW1SQFNDE40KUoLUhrpxENm93uxerv6+VvqpH7iq0wfbeF
 UB/pvOLjnMc/pl+VQy60B6EpJ9+PU4Z3nx8u3IOvz63a4JSCE7o3GNDWDXuMIU24n8/x2H+LpD
 4azUVgcF4jaY3VzFSFLOJhMfFuKlzoH9NUI61WWp7rgXIbSZbYBjwnZNQpVRF4S0WRiUilj9db
 Mc0=
X-IronPort-AV: E=Sophos;i="5.81,200,1610380800"; 
   d="scan'208";a="264792623"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2021 21:50:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvgXnAIL0c/NPyTm3Gz4wCfrDkWwExvPaqo6dl2Ocxn7qhgtYPI74CZsSbF8FcEy/TWbho9DoXICBQglkbKyWSnThi3w/QBRRlU81qNlG2dAsHAAyO0Q0xPVxchjcTN5047161IaUw4JBwuGIBc2EBGY1aS3muaFhTPPbmUDMqrUlae5QJIxXKBhvmwTU5hpSQj52WXoryZ7byLWR980h1JHVJiWGncI79Cj042kTKAyhew5/7M09GCH3+DMSL3AkO0hZPAZxSzggDj9pDivJJu59MivyAUhhuawpLYcjuGXcwYY3xwT0CoWZ7ZprA5ZIL/8b4r2YOO4l7vUY5wUdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSM4DPF4p24/wpZ+Ziw2QLdUn9O7CFKjV1OoJdgN95o=;
 b=n2f+pNdojRXLF1g6EAxQDlI5xtT1rewEIfIYI/xR01tTqZ78b15BXN4A4DH78+7u9qF9EUUAR6ZRj8MgzWPo9b/uchgK9RGYSzCONaKVaaYdK59PRu9PdFiA8Ps4wwUqZe55FkPEhKgDpk/9VO/0psLkwkkerDaWCIlAuokbh6TRLBjJ7QFrmp8IikSSjPMpdoN1/JJVnpEJQF+rjwN7EXmSIkOabutPoypdtj7H84/msxscNtCtSq4RMfwSuW/F03mFguhmDeYvoYRNMBG6tlFlXzy29txdPYYTVnZM9f8IZF7AWrkhmQAJ2EJH2buDb/O3DFIrtchjoTK9aoR/nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSM4DPF4p24/wpZ+Ziw2QLdUn9O7CFKjV1OoJdgN95o=;
 b=xEc30oEF2QOKhqTqt4nQLvP0tp8Dq2goKGTLkDwPsCek6Oc9g9/DMfo1w5lqlr7b6AC2Ui9ZYcB3Qfn0NFwqnj4zYm7DYwKdDq4ImdzW/LBShaIpQbN6ot23DAuZZfI2xtR3lTaFJhseZqi74RqZpJHSNsy5j3zgzrz72d6u9co=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4156.namprd04.prod.outlook.com (2603:10b6:5:98::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.29; Tue, 23 Feb 2021 13:49:16 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 13:49:16 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v22 3/4] scsi: ufs: Prepare HPB read for cached sub-region
Thread-Topic: [PATCH v22 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: AQHXCP2AswDeSMp180uO0U3nTEujWqplvVHw
Date:   Tue, 23 Feb 2021 13:49:16 +0000
Message-ID: <DM6PR04MB6575E664773FFD81FB16EBF4FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p8>
 <20210222093117epcms2p80c6904ac3ac7b10349265ed27e83eea4@epcms2p8>
In-Reply-To: <20210222093117epcms2p80c6904ac3ac7b10349265ed27e83eea4@epcms2p8>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 60281c45-4ab1-4d2f-85a8-08d8d801cf83
x-ms-traffictypediagnostic: DM6PR04MB4156:
x-microsoft-antispam-prvs: <DM6PR04MB4156E6554A691189BF7268E1FC809@DM6PR04MB4156.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7xizO4RWElVJKT3Q7Vs2TB4lvfBXAqV0WfNhFTU5+mo0LCtCueTmpVdl5G52KwkXJjBCYFoWef+Jaotafy+Jqms88shbqP3Vgk95tdAu+xgetiuoxaGZeknAYnLemjz4frtpWdukkDuIYBRRYAQV7UBqbrkOLBckMFuLitY2EZ/a7ojst8dOGzSzsYxagchU2XPFZ88j7jptqMwI70Lf9Cf0n7xqc3+Y8M9dGhjaqd6fsXIC3qsiuI/a6qD8ZVDPY4kA4S5vXZpFSPk8bqjvynDvCDPKveUj2MbmRUj6GmDCGBw/tVnPR84UFdTtcZKJ5SxLGYMb0KzzbO0/sA1KtNcIX7yOdM6YQUuXK1YNXfOnCWXTDLITrh5cuQ7QVJyle3rQGY7x5RFUArEOYEt05ZCIMuXgoq296Hq2sMDi3Df5ZkttoBFlTvKEc/Ey2kpWqBJ6Bw+9lc++aAExUss3HpBJOEopmvmXMtX4HUJ7MqJQgINSGwvU/FPNzXZw8OsJWNPqtChcJyKbnxcZrpHj+AB4BOdwJuhmQYMvHGY7x5c1UG07rbWXELht6r9MsX+L
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(55016002)(7696005)(52536014)(921005)(54906003)(498600001)(4326008)(66946007)(71200400001)(76116006)(66556008)(8676002)(66476007)(86362001)(5660300002)(186003)(6506007)(8936002)(66446008)(110136005)(7416002)(2906002)(4744005)(64756008)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?T0E3ZE5wR21uTDFWUDVGL3Nydjk5MFhBNGtwMDRON0FVMnZ1VHBNQ2VOcnZm?=
 =?utf-8?B?RTc3TXdKR1FlWTl0Yy9weEdFaklNd0txdHVqVVoranJoV3g0ZXZ4TUJycUx5?=
 =?utf-8?B?VUprVGlIeVBBaElvWElsMVN3TnFacnJxek1Na2VHSkhJSlZONzBvNW9teVFH?=
 =?utf-8?B?OUhvbHFJdnlua1IxMkJXa3pmSVdYbjJyamZ0enZPSElpa2RRTi81Q0g5dER1?=
 =?utf-8?B?bVFGT3F3ZmpFMWNZMkRTOE9aRnZ2MDFseHRPUkhyeXo0UEg5ajdibG1DSlBL?=
 =?utf-8?B?THJNazZSR2dGQmhhc0lMNjJkNE1rOFVzNzhjSHNTMmY1Zitna05mNVh0Zkow?=
 =?utf-8?B?TTJQZkJ4cFJ3bzA0Y1d3MGFQRmJtVUdyZTlxaVdGNStFRGJMdFZJM1U4TitI?=
 =?utf-8?B?V3NrR0ppMjh5ODQvVklmYm1XUlhaczdPK1dLc202UC9kQ3JXdUtVdGIzT0wy?=
 =?utf-8?B?TnZOYzI0dEFlN1M3VVdVSVJrRHVIOUQ3VUtSMzV0Q1pJalprWkUvYTNKUjJR?=
 =?utf-8?B?ZWtTT1hCdGVJUkNTbU9vZHV6VDdvcmo4WjJEaG9YdFBBZTBRWk9NZk0yVUNw?=
 =?utf-8?B?UmxzQWxSMWdwUDFSTWwwTm04TnJwaXZIc2dTbG9ENjA3ZG04M1BNaFl4NHNE?=
 =?utf-8?B?YkQ0Z1VlbGoyaE5hRVNQRGhIeW1nOFJjblFLNkJyQjJDUk9KUW12YndwQU5D?=
 =?utf-8?B?V2VVSVovdElqVWcySDUrZGgzY2FuaFV2bElPczh2enpyTVRjcFVCa0pRRy94?=
 =?utf-8?B?d3dyazBQUnBTOUIyZXhGcXJCSmY3SmlEa1IvZTdFQWRtNlFyOVJHS0NGYzVh?=
 =?utf-8?B?WVJCRG5kN2MrMGVtM1ZXbDFaZmY3Z3FoK1ZwVGMrMS8xM1dCMGNrOWUzZGlY?=
 =?utf-8?B?LzFGMFowTEF3Uzc2QzNtaSt6OVZJWG9UNk02QTlQcE5DR25NMHFEQTBLU3M0?=
 =?utf-8?B?ZVQ2N2k5YytxQytUamhDa2VZSG5hOWtZSFl6T1AvbTR2U1BlSXhxWHNLK2xI?=
 =?utf-8?B?UVJESzZxRG8xUkNmMVo0SndPaFB1NFB3a1pYb3QvejZnaWpUNXdyUmR3TVUx?=
 =?utf-8?B?czRRbGdvOEttNU5aU04rcVc0NEVWZFhBU1hzSGhXVDNEZzBNeDltR09mRUZN?=
 =?utf-8?B?aUFPYk81WVJsMEpVdUJjdmUvanlwcVgrYU1hTHJhdVFZcUZvMkR0WnhNZHRv?=
 =?utf-8?B?ODgrVGx2bDJnVlVVdTROdEtZdWJ4akQ5Tmw3Sys2MkZoQUsxYzM4VDV4ZHgz?=
 =?utf-8?B?RjdDTGVtU0VrT0pwRU5CWjhydFNBVkphM25OOGxQbjZXQXIxaUZ4WTVJTUZ1?=
 =?utf-8?B?ZmkxMmRFREpmUTlmaFZmeDMrMXFxNFJmMlI1clA5dUMwWWluR2JhbmJrSE1u?=
 =?utf-8?B?aEF2Vm54RVR3aXJ0MUpOaGY0NVVKcHIzRG1ROTR1cXNkVXNrWnQ0ZGFsMUhr?=
 =?utf-8?B?OUEvRUR5ZDVqanNYNi9HTFd4MHBrei8zRFp3U1pqajVwbXl0NlBpN2x3YjZL?=
 =?utf-8?B?TmVMaXUxMlJOS3dEWTUvYXBYK1hQaDBMOHFCdXJvVlUvK052NFZlTDJlVHNX?=
 =?utf-8?B?M1BRMnRocDh0UGpKd0pKMllMV1FxN3VmaFM1T1NyWkhtWklmQUEveVRUbTNX?=
 =?utf-8?B?ZmR2cm03V0FmbUVxL2JyR3pqQzRWY1NkQ1psS3ZxdklzRkNNWXpiZlJjdGNw?=
 =?utf-8?B?T3BPWC8yb0o1RkR1VW5wNWtXNnozSjZ5N2dIRFp4TzVrQnYwVGFQaFFUQnYw?=
 =?utf-8?Q?k5dMl+6D5zxoxivISTek/6OLxtSyhNMCl2YzRxl?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60281c45-4ab1-4d2f-85a8-08d8d801cf83
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 13:49:16.0407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ERhWkj0Dr1SY1Afa+Prdy6fqM/xTAMAAWuzsZRddikoToG87q7E0hFeiI6kMceKSqk2BVUDLcYxKR5LGuwxHRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4156
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICtzdGF0aWMgaW50IHVmc2hwYl9maWxsX3Bwbl9mcm9tX3BhZ2Uoc3RydWN0IHVmc2hwYl9s
dSAqaHBiLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHVm
c2hwYl9tYXBfY3R4ICptY3R4LCBpbnQgcG9zLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgaW50IGxlbiwgdTY0ICpwcG5fYnVmKQ0KPiArew0KPiArICAgICAgIHN0cnVj
dCBwYWdlICpwYWdlOw0KPiArICAgICAgIGludCBpbmRleCwgb2Zmc2V0Ow0KPiArICAgICAgIGlu
dCBjb3BpZWQ7DQo+ICsNCj4gKyAgICAgICBpbmRleCA9IHBvcyAvIChQQUdFX1NJWkUgLyBIUEJf
RU5UUllfU0laRSk7DQo+ICsgICAgICAgb2Zmc2V0ID0gcG9zICUgKFBBR0VfU0laRSAvIEhQQl9F
TlRSWV9TSVpFKTsNCk1heWJlIGNhY2hlIGhwYi0+ZW50cmllc19wZXJfcGFnZSBpbiB1ZnNocGJf
bHVfcGFyYW1ldGVyX2luaXQgYXMgd2VsbD8NCg0KPiArDQo+ICsgICAgICAgaWYgKChvZmZzZXQg
KyBsZW4pIDw9IChQQUdFX1NJWkUgLyBIUEJfRU5UUllfU0laRSkpDQo+ICsgICAgICAgICAgICAg
ICBjb3BpZWQgPSBsZW47DQo+ICsgICAgICAgZWxzZQ0KPiArICAgICAgICAgICAgICAgY29waWVk
ID0gKFBBR0VfU0laRSAvIEhQQl9FTlRSWV9TSVpFKSAtIG9mZnNldDsNCj4gKw0KPiArICAgICAg
IHBhZ2UgPSBtY3R4LT5tX3BhZ2VbaW5kZXhdOw0KPiArICAgICAgIGlmICh1bmxpa2VseSghcGFn
ZSkpIHsNCj4gKyAgICAgICAgICAgICAgIGRldl9lcnIoJmhwYi0+c2Rldl91ZnNfbHUtPnNkZXZf
ZGV2LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAiZXJyb3IuIGNhbm5vdCBmaW5kIHBhZ2Ug
aW4gbWN0eFxuIik7DQo+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVOT01FTTsNCj4gKyAgICAg
ICB9DQo+ICsNCj4gKyAgICAgICBtZW1jcHkocHBuX2J1ZiwgcGFnZV9hZGRyZXNzKHBhZ2UpICsg
KG9mZnNldCAqIEhQQl9FTlRSWV9TSVpFKSwNCj4gKyAgICAgICAgICAgICAgY29waWVkICogSFBC
X0VOVFJZX1NJWkUpOw0KPiArDQo+ICsgICAgICAgcmV0dXJuIGNvcGllZDsNCj4gK30NCg==
