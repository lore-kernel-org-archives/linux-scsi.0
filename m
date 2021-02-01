Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405EFC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 07:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B87A64E30
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 07:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhBAHX1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 02:23:27 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:21117 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhBAHWU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 02:22:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612164140; x=1643700140;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lEXeRa7XWwbfFo0oCMOsC7Meaa/ySS4LJyBYekjw00Y=;
  b=T5I7M6dtPgpOWAhzWi/y1H8mDGVM1B4tUAuRzRs6epgAZDxdyXZqRtbo
   75cPYYpSSmLOtE79M/qlAG+yA3RRsF4VDsWOaBSlB5Uvxt23EWV6kcRcc
   naMSQqYOg8/CkJkFFmm6vz6wMsdYKclNV+rZANp2uHgBx0TneRuEuYVuK
   CP7UZ/twMhNFii9yGnd+eY82kSmi7rw4GKf8eKhzFXZBeOfxNSuhKBeYM
   JHr7UxY8GA5QYNrjyPqEFNSlvkElYSheQqeeY6KX+C2jkhoryoB/VnoMR
   NsmGS3YtSbzmDdFfWJV8uU15RE+DVXs/mlr1FzICIDuLI3FdlnhT2jtz8
   g==;
IronPort-SDR: 0OFzOfsbz/Cm2omoGB3pfXsXTZcOirrPeWyieyC6Be401uzDdUtScydK3AzaAe8mUMzMDvbmOC
 tC5F0BOFBJ2w9EfbuaxRkhvlVObdfpx5JDPhQ2+C3j4arY+TfuUncnZar/xaKX/DcNedXTQont
 uEoLe8wTsafe2knSOYdIYA4aFLJD/Ll7MA5q9APCEaq60dHxAEUGwIraf4YOljnSQHD5wBBiim
 AWX0CNYICRTRq+OQKY0hJv1AHyciPFZuPNoJwRNMjijCN9eORVC+mguyudQU6j3eRATKtOOSgB
 gHA=
X-IronPort-AV: E=Sophos;i="5.79,391,1602518400"; 
   d="scan'208";a="159973672"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2021 15:20:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aj0VtWmBD2GLjxulZvuVO6KGPr0gvk8Cli0wQdBlTAx8edOd4hk3I0Pgt/DL1mdaMcTfI8hjPbpHHhbz1G6vCTOlYE8+io8c4uMTy8VL/oBM73TaZ1wNuGMJLRJxIRfo2oJBsZtBLlQzPJNmQc0vl7jVab31mQowuoNii6AzWZAhDbjRwyUYFFTFHvAsGSSjrCFyh8G7AfkzGRQ58/Y6BN/5YsRka3DpDgtEq7LoXFw6DOyiw9IwMPIQdmqVT98sJu8AKW6mnI4KSoXo08gG73Pv6c9beT4jXDInpF8I1PHMTe/bBUG3F5LOMJ+Tho7mPFx4o5ubS5u3KOfNTyWCag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEXeRa7XWwbfFo0oCMOsC7Meaa/ySS4LJyBYekjw00Y=;
 b=jwIVB11F0nb4r2oE55a7ba1u7kSluBC3JP+CYv5sHZB8sQ6b1ZtWVcDo+xC5b6fqvEFQ1elCIW5XE/WigoVkgUswu+Gza4dvvVu+89scOur72IE+nItsVl1RmeUIMlS0W1DJ6qXnyqn1Y7qfI0zDF1bGb8D+fyYfRcTxmQkkZGC+UjrE7XnaJHa16fNK7/L1YGCcj9seDKscoa/NCs759JOlqF/6tPzkNXnBSV5m+FoxuMxiSYZ9SnFx2+4uw0//psyiloIPcHnCIg+o6VY7eNyFAASk33WbxbyxVzoAHTKOUYjhq0B11kN1jZ+nKIm5bMnHpFJ6g0a2akH6VIvslw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEXeRa7XWwbfFo0oCMOsC7Meaa/ySS4LJyBYekjw00Y=;
 b=boAyawPR2HcbVPYbU8L/tZu1nu8LxNN8JG7gqSBGOTlyBYeyBXWe4JTECTXA1WMPGUdhelBiPCrWa4Z5liFLYL4zcjzfjDq9U/Avg1hoMjtGMoXaIDl+xyli+bPeVpV6R8SHbZJDaLJ8dx29egfvx+bFJMBm8dRb6kBcy0Yg3S8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6969.namprd04.prod.outlook.com (2603:10b6:5:240::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.19; Mon, 1 Feb 2021 07:20:19 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 07:20:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH 6/8] scsi: ufshpb: Add hpb dev reset response
Thread-Topic: [PATCH 6/8] scsi: ufshpb: Add hpb dev reset response
Thread-Index: AQHW9L77hbrWJQFO80aqpNztJvhvIqpCx6oAgAAjoFA=
Date:   Mon, 1 Feb 2021 07:20:19 +0000
Message-ID: <DM6PR04MB65754ED55D0389CAA21DA5FFFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210127151217.24760-7-avri.altman@wdc.com>
        <20210127151217.24760-1-avri.altman@wdc.com>
        <CGME20210127151338epcas2p2c323a148587e311f7f5e19b4edbe43ec@epcms2p4>
 <1891546521.01612156502170.JavaMail.epsvc@epcpadp3>
In-Reply-To: <1891546521.01612156502170.JavaMail.epsvc@epcpadp3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a45cbb66-d040-4bd6-551b-08d8c681d4da
x-ms-traffictypediagnostic: DM6PR04MB6969:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB6969A6BB7584A9CA6C17EE8EFCB69@DM6PR04MB6969.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LnVSXkx4xmVzspgptjmARiZbSZP5QvlUxxo/c2a0Nsdmu+6f15OxODwnc9D22EwP+nTgWfO36XJ8fEXkxBF+INohT2gX09pbMM6L2N3H6vebwrvh5lcYukWMrGS5UhoZhwzJRmzFjskPyvYtdOqeF+T886KdPILQJILoYY+wdWdQIV+x291BRfSucSEXBTcGefS5HK2zpftUmx5EBC1fOZn+auR6lLXjpvHY0g+FC3cSJB+35gy8DnThTD033mlCq68cmgbVGdSLuTWmaXVVWmxcOUGQ1LkQg6kXnyb4GxKSl5gFLNuPPvQUhBbhsHmtSieHb0iZb1IkWIbdB2IYUMn05E7tm89xFcVwMXs0wQ1FOVMWWqth6LMAetQXZ7Xn130SJG6MfsdKMOQmPjL5D2R7DePomxR4BHVS/J5wRU0AZKk3y0XyelI+1WcnSrKmDdtYiOcxHITqqedTKMULzqJweQyzesfleo+SVYQnhMoun6YApHq7nVIufAMl7GRzKUmH095Sm6sf3ehCY1ER3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(54906003)(110136005)(52536014)(55016002)(71200400001)(76116006)(316002)(7696005)(86362001)(5660300002)(9686003)(2906002)(478600001)(4326008)(26005)(6506007)(186003)(8676002)(33656002)(558084003)(7416002)(8936002)(66556008)(66446008)(66946007)(66476007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bGhkdmxxTHFCQzdJcGxZcXFDL1FlVXZGL1hXRG9Xdk41VFhSMHljSVhUUCtB?=
 =?utf-8?B?UnBjeTB3QzJNSVVvNlU4YVRZR2V6QTN4NCt6QjJSY1RoM05WTCt5K1JieVFo?=
 =?utf-8?B?M0tiV3htdWtuOWVGNExzd3VIOWRLZ1JkMTdyOWh1Mlh4TGswWFo4RWNKcjM0?=
 =?utf-8?B?d3FLY3hSL05HQkdGaU8wOWxiNDAvZnZ4bGRGc1R5N3VMSW5MVzZSV3JGcU9G?=
 =?utf-8?B?TzNPVlgzcDJpcFc1RFVnaTVMZ1gyei9Qa0tySTlKUHhOZlNFSytPQ0VzZ0lP?=
 =?utf-8?B?M3VQQitRTHdLL1ZucjlCNjZVeE5HNC9MYW9MNmFVYzVYTDRMM2llWllCcGxr?=
 =?utf-8?B?NnZwZkpBVEduUjRaTS96cVB4VVZwU2ZCL0kxcG93WWdvbVo0Q2tKSUpRSkRo?=
 =?utf-8?B?RW9ZS25qNEVmVVh2cG14M1J5ZnB1c2xwR3ZXbTZneWN6S1YrYlUvaFRhSkhL?=
 =?utf-8?B?YmFodDNNYkdBWityKzBBemhvZnFlU3NXSnQrOHZicUgxV0JvRHFKQ2FvcUY3?=
 =?utf-8?B?YTMwOWI5Y0dUUnNUdzVUT0U1S01DeWtXWHVQMkxMMjBRTk8xcy9jWE8xMXMw?=
 =?utf-8?B?WnJ6NEgxSGdod3UxSzM1eHBTMW53dGtNcjRPNWEzTlJCdGI5b2U5dVJ3TUhD?=
 =?utf-8?B?UVJGK0ZvSDh3UkpHV0hsdGpPd0R6b3h3RkhGVm9TQkJEREZwZFYza3E3RENN?=
 =?utf-8?B?VVRTN3g3VWsrTDE4V2NkWXpKWEROcFVhM2tGM3RoeXBCa05RblNsUGQrQ2lM?=
 =?utf-8?B?RUtaNS9lWEdkT2JZbjRycGdlV1ZjZWg3Q3dhNGpxdE9PMjdmcW96SkdWS1VU?=
 =?utf-8?B?eXErUEFUcGJacEJEWnBndmo3NmMxRnpYN3Y3MXNKM1VSUlcyZE1GdTIyZHVO?=
 =?utf-8?B?amFEUCs5TnBhNzI2Q1BiM2Ywa0J5cG9udVRSZzZMaDlzM1J0TWZUcVVocElj?=
 =?utf-8?B?djJBcktvNjNiSWZrV1I3aTZzdXFvbElwRFFBUmROYmJnTXptVkk0OUpVWnBP?=
 =?utf-8?B?YnE5Qy9IMGlaaVRjcHd1NzJVQnRVdC96ZGtUNUY4ODNQSzdVOUM0aDJiVnhn?=
 =?utf-8?B?ZHdqVGR4TXBtQ28yanhJSXNDYzJ3eFdJT2cxeDZ6SEhJcTV6RE1mSEM3ZW9L?=
 =?utf-8?B?YU9CVThUNm0vQ1VreU4yT1ZBSnZycW1CUVNVcU01WXNXMXk4OVJOYlZsYVJr?=
 =?utf-8?B?V2VFdlZQQjZGRW94YVg4R2NNeFh4VGlBSzJHanhWenpKck00V3BVQWFSdm9p?=
 =?utf-8?B?OUM4THB6UjAzN2ZqU2E4VlRsUnBQNkpoVU9xeEFHMmZJOHlFQlV2aGYrcUhv?=
 =?utf-8?B?ZDRrbkFyeVFidGx1Y040RmZvSWNIS3ZSYXVZQzJ0Ymh3dHNteUw2WDVndW11?=
 =?utf-8?B?TVlJYnliTTdUZjEyaEY4ek0zUVRJZXAyUGpERDJtZ1ZhWThMdGhqbEJqSTN1?=
 =?utf-8?Q?Wx88KZsK?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a45cbb66-d040-4bd6-551b-08d8c681d4da
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 07:20:19.5780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3fJLU73RcpE+22y5EjnwTMYIfO1xoJxEuhk1WO+PD4wRqF5rvFOIdk9wAwYLw8WvRYmLZNXrS55I5c637J9DLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6969
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gSGkgQXZyaSwNCj4gDQo+ID4gKyAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHJn
biwgbmV4dF9yZ24sICZscnVfaW5mby0+bGhfbHJ1X3JnbiwNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgbGlzdF9scnVfcmduKQ0KPiBIb3cgYWJvdXQgcmVwbGFjZSBsaXN0X2Zv
cl9lYWNoX2VudHJ5X3NhZmUgdG8gbGlzdF9mb3JfZWFjaF9lbnRyeT8NCkRvbmUuDQpDYW4gYWxz
byB1c2UgdGhlIHJlbGF4ZWQgdmVyc2lvbiBpbiB0aGUgdGltZW91dCBoYW5kbGVyIGFzIHdlbGwg
KHBhdGNoIDcvOCkuDQoNClRoYW5rcywNCkF2cmkNCg==
