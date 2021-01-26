Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A60C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 12:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AAD920691
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 12:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392114AbhAZMMk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:12:40 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:56264 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392109AbhAZLOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 06:14:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611659654; x=1643195654;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=exyPuAaXuF99GCNoJABPf989V4+RE5MjJUg8tpGtAKQ=;
  b=MdrEd69Afdpvibfbiqba/kL/9tPWlaXAnY0P5zu+NTWyGKnr2w9YbxD7
   +8cb5hoQ70XlpDM8NFtEdFp73u2VnyWiJoYpfo5tDy3SIK4/NlnOsU2il
   xdqmcC+vt9zT+feVEP/a+SUa844+FJeq1lVhpoB4/gQzCWs0oSXi5Lwuz
   BVEPUD60BPSLUjbMzoUE12YDMtCHZO4i8QoMIhTWsvIoVOGw/KBGwX2Bf
   PyOZW926zhZqKkL1v9Qicuhkbz5UDW5YqLEEHVq5P56WMmeEfpmNbgZiu
   hRNT9/kaugPpYNJ9r/LFZbUtB5JxWsPAiAFYk46CW1UPZUJiUAgq6Omte
   g==;
IronPort-SDR: G/i3wP0cpe1HWnnTrsKgr7bRd9hlKi6WUajs/F6Vj9bJaZ/ghAqUXdBhpYwXZ7eamXI0YKkyUT
 yHbdV69RzagGLoqMLW28+J2aAnZqsdq/m3bBtdw6pMzbvL8kx1uVTZCXg9SSfWpAYMHaKdHpyk
 CTvbYUQmMBQcjFOXBe0F5YPPzGyNiN/RNVhv7kyn89Gw2+ehGp6u+xP/6qjiYWsfYCFv3yNVri
 8Czn9zTovFv6hd7gQz4m9tWcR8v6OObaXpi8jBUyunGINGT8scQcjJKbX4o+svwkZZVVibQLBx
 Qj4=
X-IronPort-AV: E=Sophos;i="5.79,375,1602518400"; 
   d="scan'208";a="159516454"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jan 2021 19:13:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBy1XceV9oOQxmk3+X0VIWMO2xPkOeQFIIQ+EwrMTWnyuhrNpHSnRv7TbbBgCs9uxLh8l8AnN9MvOykAvcMAWzE2CkS7qoqlNfj1PYF/GWSAS3cWBFYnzqzm/lCgzPHmWSSJzieMp/rb0VfIvwmLZdVXLLEVw38UaDM26c8855rI7WScBjlPaL5HJanCRGLvfvhef3Ym4/Pcx/QA5MoYMrkQB7bMq7ZWLOO2Z9Lpk/FB/CF/7IExQ1gmjQfThl5NDFXflTGTTEr3aSM57/gm7Vbe/P4O0qMyG/LjS6DqiikS7YrtkUMvAFtnT/57I/6VhskrNUT87ALS9ZYiqBVG5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exyPuAaXuF99GCNoJABPf989V4+RE5MjJUg8tpGtAKQ=;
 b=oYlKpfiwg2v9uPpb1R6gw3+WQ076i7g7EMEmdkG3PqGtUwvHsamhtVfUUpCmCqYru/+hFr9Rg28hHkVxVXGoOPXQObLrctHMyZfjdGLMwvpESN5fNznDZ22TsdmHgDy2BPQsDegsEvk02rxYZTA+mdGKD0XM6LXkxBv7FC27CTA5tXa/bGksLngBKK1yHJXVs8Qhfl3h4SSOGUe4XVdxGxQbxbYCd6I8hSutE4Oc7a7G7Rn5uNCix04QgmNrcpicKSV36pP2cdB9CijKu9nJQd3XdwrO7FzzJhJhn45ICUKgYwPWbwgOtNenFUq6pdZuxyViMxhTiKtFny9koYUz+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exyPuAaXuF99GCNoJABPf989V4+RE5MjJUg8tpGtAKQ=;
 b=w+SNUAH22ylCBPLqc5WePWjmusNniET4cejtXiJyTLG9GzFBe4tTRZKfUQWucE3zkLVZoNk3MEo2YiuufSWV7rgz0IeoZjVsBLa6L0qDQwZnmtqjhKKrfvKkfRnV2MkSXP80G3bkN0zI1oBl8JnGIlj7AO4LeeBb8VlmP5We3XU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5081.namprd04.prod.outlook.com (2603:10b6:5:fe::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.16; Tue, 26 Jan 2021 11:13:06 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 11:13:06 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "bhoon95.kim@samsung.com" <bhoon95.kim@samsung.com>
Subject: RE: [PATCH v8 2/2] ufs: exynos: introduce command history
Thread-Topic: [PATCH v8 2/2] ufs: exynos: introduce command history
Thread-Index: AQHW867RP2vI8AtugkiwZI90gE8Srao5vw/w
Date:   Tue, 26 Jan 2021 11:13:06 +0000
Message-ID: <DM6PR04MB65758E89AC1F171814CADFACFCBC9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <cover.1611642467.git.kwmad.kim@samsung.com>
        <CGME20210126064508epcas2p3c1132f7b6895d344784629a0d2e74c12@epcas2p3.samsung.com>
 <d2e077fc8e8cd49ada614a08bb3dda85e8222c8f.1611642467.git.kwmad.kim@samsung.com>
In-Reply-To: <d2e077fc8e8cd49ada614a08bb3dda85e8222c8f.1611642467.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b2d11def-2222-46ca-06ff-08d8c1eb5b63
x-ms-traffictypediagnostic: DM6PR04MB5081:
x-microsoft-antispam-prvs: <DM6PR04MB508149A67273D9038E564EFFFCBC9@DM6PR04MB5081.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xMfaNM7AKL0z8YxuDZHlJOGNN1KRKT9vnGb80oXuFhHhklamwyHI3Ez2gwuzINxsO/vcY0P/lWTSGDhpiaTf4kVYoGZ7SvGTmkCDgLqKpmlJhQrRFV/vHtJsb4HG3x1yoa0HPsVIzx4oEDSQgB8uNo492p3c4Mxl/brcS8akUqKSVMRhCcgv60pOd/vxBpeqgKOJSGYspiAOELmMzRW7sabhr2f2oFOr9dPBYzZz5Fp0VmULgJpPdKeGzpvl55tLOksV6nuY5sxkzBH9+VrbNYHMbmXy5scuO1etxumTQJ4fA13SeGShqaPsaOPahpUQZW9DVMWiCEaPQQP4QndPifAKt3nvFR89qUk+afXSkG5Vo5wE6yuZwlk/SgB6Tc5tzc2CpuP+wM4o6LXnBGctAH9AniM7cHI/Mno+Y+0saRkfbRzLGcdBV/jmkIW6iJRVEw+z9yRg+mY4Y242tgtsaxpvGFOVRiiZLs15IiFU+NdHZ5xUX6uiqQOyI2B9tNHDOcpjyvX9GEqYR9KdRDRG7iRAjCBGB24stZF9wW6EgHXpnXP1uvTtGhJnilwnM2Is
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(8936002)(5660300002)(71200400001)(478600001)(55016002)(66446008)(9686003)(4744005)(66556008)(66476007)(52536014)(66946007)(2906002)(76116006)(33656002)(64756008)(186003)(26005)(7696005)(921005)(110136005)(6506007)(86362001)(316002)(8676002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NlJxeWlwQWtGUDhYaXJOTXBLMUtjZ1Y4WlYwalR6REpCNm1KM1JpWFlKNWdZ?=
 =?utf-8?B?a0RqcjV3dDIrcDVwQnBEQkhseFYzTEFGZXJMOTdESUEwcHFHb1JmVDBKMGNT?=
 =?utf-8?B?cGVXVUdSRTgrSlV5YXZ4ZFk0MzUvWlBmT2txL1lvVmV0eDhBMGg3dDg5Z0Rm?=
 =?utf-8?B?eXU5U3FUaldwMzl5NGhMTmppU21iMmlycXFCOW1obUpZcXRQOUQ3aHF2dWJL?=
 =?utf-8?B?c0QxUFRQZWZnQmZ4UzVvV09oSUUwZTZETnppdTJqelg5NmZpT3RXNGVNQ0Ru?=
 =?utf-8?B?MHN0N0VYVVBaL05JRHI3OFZ5QTlzbk1KTUltWGFxeFZ5OFpnSVpVVjdYd2dG?=
 =?utf-8?B?em93OEMrRjh2YUdPb0p0ZmxtUWZqQmNqeWdKNEJMc1hLM1Z5RXVRTDhuNUNQ?=
 =?utf-8?B?MHUxa0hxd056SmZUdSt4a3RqQzJrd2tqMUVrOWZDSGl3MzI5MzZOQ3hsS3VO?=
 =?utf-8?B?WkY0NGx4a2hMbDhjTFJ3cEZCeXZrTGIyOFdrOENuV01lVWpxM1FVdDNjZ3I1?=
 =?utf-8?B?cXhQeUZEVUlVTnBMYWdudkE5eU1xdjczSkNQcjJwSDB4MUVPb3Z4TTlieDV1?=
 =?utf-8?B?M1lMQ1FTbzFlOGNCVlVBRzN2U1NGaEtGMDI2REc1V1NtUTZ6ZWRnOFE5blZP?=
 =?utf-8?B?K3g4YzNYVGhhcE9rcmNUYXU0UGtHUDNpZlVTRGZxRHB6TUt6Z05mWlhwL2lk?=
 =?utf-8?B?c2dFdzd1VnhCb0YxdzVvUXNWL0Vmc1lCT3ZXUldmVkpCNkN6VzVFVU9TeCt4?=
 =?utf-8?B?TXJHUkZoNFBRdzhtZ2VOZW0rYnQ0c0xZalJjRWVZV3VWS2loVWk4SllnSHBV?=
 =?utf-8?B?RHd0Q09IT0NibW9Lb0gyeWxpUzhDUG1rV2VjbmVjTDR0QVhFRElJMmtUR1R6?=
 =?utf-8?B?T3NpVHFFKzB4eXZxdGVwTDM5dVl3bmZrRVZlRWJxYmNZaUxNd0ZqaGR3RUlo?=
 =?utf-8?B?d2tPWGJnR3FXQ0p2bTVyRDZ2ZHU3MVFJNEYwRTZIaE5PYVhzd0tHV0NYY2VO?=
 =?utf-8?B?NGxwOTZQekVpamZDT3dXQmVBU0w1UWZpcjQ3WHF0MklMWVE2TVE0WkYzYVZr?=
 =?utf-8?B?bEtOaFUrNVR6a01lY3pYcjE5cGk2aXBYS1BwREdkZ0owR1hmNXZqZXJSY3RZ?=
 =?utf-8?B?VC9MdXgwVlp1ZGhrZDBEdHVjWENST2pJT3lvRFJia3FnWHNwMkJTRDdrWGwx?=
 =?utf-8?B?VDlqVWdwV1RzWkZkdFRTeVJZb0hlRWFvYkcrNUR0YjkvUkZEZmhUdnllZTlD?=
 =?utf-8?B?OTJtS084NEZzSWFjRWI4STlEL0d2YVMzb1dvWUpXOU5ScDZ1NGR2SjVpZTZn?=
 =?utf-8?B?SjNzdEY1ZENYZjNQL3dIaWNreS96YXZ2SkRyem5WK25mcDlHalpaYitrMERG?=
 =?utf-8?B?UUU1MzVtQ1RReFBhcmFkOEZaSzRiQ1UwMlBHYkFES0ZZM0hVSVpxMklwdDdV?=
 =?utf-8?Q?DbpW4q1S?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d11def-2222-46ca-06ff-08d8c1eb5b63
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 11:13:06.6272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yLG7UeZT8EntmIu+/s11Lg4VGJvGFOnZ/1qfru8TyoFdDlDW/VD/SmPdoFHsjIQkAjn0WfH2U4Y6rodvX2uNog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5081
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArDQo+ICsgICAgICAgZm9yIChpID0gMCA7IGkgPCBjb3VudCA7IGkrKywgZGF0YSsrKSB7DQo+
ICsgICAgICAgICAgICAgICBkZXZfZXJyKGRldiwgIjogMHglMDJ4LCAlMDJkLCAweCUwOGxseCwg
MHglMDR4LCAlZCwgJWxsdSwgJWxsdSwNCj4gMHglbGx4IiwNCj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBkYXRhLT5vcCwgZGF0YS0+dGFnLCBkYXRhLT5sYmEsIGRhdGEtPnNjdCwg
ZGF0YS0+cmV0cmllcywNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkYXRhLT5z
dGFydF90aW1lLCBkYXRhLT5lbmRfdGltZSwgZGF0YS0NCj4gPm91dHN0YW5kaW5nX3JlcXMpOw0K
PiArICAgICAgICAgICAgICAgaWR4ID0gKGlkeCA9PSBNQVhfQ01EX0xPR1MgLSAxKSA/IDAgOiBp
ZHggKyAxOw0KPiArICAgICAgIH0NCk1heWJlIGp1c3Qgb3V0c2lkZSBvZiB0aGUgbG9vcDoNCmlk
eCArPSBjb3VudDsNCmlkeCAlPSAoTUFYX0NNRF9MT0dTIC0gMSk7DQoNCg==
