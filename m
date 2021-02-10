Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E98C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 09:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4465964E40
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 09:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhBJJjn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 04:39:43 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:12783 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhBJJh3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 04:37:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612949849; x=1644485849;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/6eug5Eg+Hbhssbh1hjGJwKuRmZhTEoOeMYZyoIfXDI=;
  b=ql5j49NF2tjNoHzY67nd4fJJ22JtfR2huFk4RS6iDiQ4Ofit2ieS1u5O
   OT+lR/OoFE0hi+RvP9fUyeT3c/V8SqFah8zbAEmAGvl2kxNsG/Kj2Y8LK
   +ae+ckymbYROj5lNZQjqDhTvxYtWD1HNXJIbbLky3gqvlTrEpbpFhutpk
   YcxoxIat5GiHEKwWZ9gx+a/M1gQ8DeRnDJdaaMixuqHGaexb854RllCmK
   tvD1PwG9/1rHxpmb255vos5ESYxcpxh0ezimZ0Ttjv8mssUAbjU51JhPe
   7/UgQtjZ9F2jLHnxPEwzYjJIbsrp+G3XLAgWyP4w9iuPQyfkcdhhjiqaB
   A==;
IronPort-SDR: prgxUlgfOB5t84hHo/9RSIWshy0fzIAIIxAP2CKKii99qBzdirWLVWrJcKJcYnvqzuJYwTdIkF
 LB6JMnqGTxgQRtJg46N5DX4TfMVnoiaDqghjhfCRuT77+Cplxq2gic+cjmkbQ+eGV/5f3wWvaZ
 vaN6rDig0+mdVyxoYvb/VwF6w6GAHRcdkaP1L24vLNsjDtYxON83AVhSXYCXtN1ShZU9vjt1wN
 uqiNlOCGKc6XDbSZ6seIzL1DrX4rSWLHh7hNtYbaGNuynOnE2zxRwSjrtGMd2NmQ/JNTWD5NPd
 CdQ=
X-IronPort-AV: E=Sophos;i="5.81,167,1610380800"; 
   d="scan'208";a="160794939"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2021 17:36:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/+e1uZgHdAZs3GTelNflzLFRUGylQTvaergp6ANpTQLcOfOICqy/BLVPZGvHkbdRvZTicSJDq6aUNNuHy9BJWC62b5xONZ8cS6sL/WAz9dPNrL3gwuHva/2WXWhgcwx+LIYkP8sgitr+YmVH2vDzqv+/weJHevtTESgXcvBQtDwv4VwGw37CQS3Xz48ysn3o5nRxERTNODXL7SawUBlYHbeOBqvXD4VXPi97QzlIGk3LoZvUnKFtGgBqXre8ofgOSEDC/Z7sHC2D8Jhqww4wMvlegNPQnMq4KFB7qX+E6eFm6jL2CBgSLgtv2SHQo4sFLZDx/KM2mSZ9qQQ/5DezA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6eug5Eg+Hbhssbh1hjGJwKuRmZhTEoOeMYZyoIfXDI=;
 b=cvWBdfUcShmixPum2nzw0sIiwg/ihog0dace7vsgmBmbU0YAkDVbrjWBp8dNhwzhrbIxaYom2cnY88Fgu2VZFjgXf00ANI90ki8ATeKXHiXXEtSiYy1dJJMnpLXnN9vNg6bWxa3HN7cIa5Mxj1vPgNCHkxnKDXYPk5/0wWFmDQV3B3BdtNlC+CnXo1/4tTZehX4/NVWLtwfj6uq+mXoOYymEIXXVOdG/jAA64JmRVP+3ls/mC0N4TJfkwcmKQVkxQ5It0OUvdlAgzD538tJF7ZDDYUnRzuXFOMUlgptwWkR4i0dvTvZrkkCq2G5dOFoIJm47u7OTcJgVS8jpYnzRGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6eug5Eg+Hbhssbh1hjGJwKuRmZhTEoOeMYZyoIfXDI=;
 b=A2UeqvsK0sgvEzj496Hf6W1G7mvhj/3YIJnytRPygFLb+gvWc2xe8P86dOLotVboF59z5w47jh+D2ycTeHbpzo2wyUNxnkMHREJgoilgHjg8LJPVPlgKuVZJKrnP+SSk4HLEjQnkBzz8ZD5iwTyNFS9BJvBKKs/BPOLZdn8GbVA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6510.namprd04.prod.outlook.com (2603:10b6:5:20b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.27; Wed, 10 Feb 2021 09:36:13 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%4]) with mapi id 15.20.3846.025; Wed, 10 Feb 2021
 09:36:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: RE: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached sub-region
Thread-Topic: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: AQHW9f/qdUh60Je+wEOqZcug0RLrV6pRMbEw
Date:   Wed, 10 Feb 2021 09:36:12 +0000
Message-ID: <DM6PR04MB6575F1BC9AD1D4637D81C345FC8D9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
        <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
 <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
In-Reply-To: <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [188.64.207.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6878d4a4-b0e6-4f98-b731-08d8cda74e4d
x-ms-traffictypediagnostic: DM6PR04MB6510:
x-microsoft-antispam-prvs: <DM6PR04MB65106D87ADE96416C1826ACCFC8D9@DM6PR04MB6510.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XVDcST25Pb4gTVl0iAQZkhBOKu9ysitqCeNMGzeoWSgApIMLvhTW5JNaEm6ft3X8b2WwC6dG8ojqgAyn9K/9R9S/sH5ElGawvOnPoTQInS1uERjdK2fOF9lcYBD11ZtYJnBIQHyY5/0yXLcJWWV6oOssB930ebn0f9c4QaUIKb+TNu7eXfgw+UYRk7M2S6ae8vcOI4o0A/HApq1426v1JUjxUAN+0k2j2qdSMfkitqrOQ1SqjEC9CYTWQpEohdvWvEmmHO4yuZGdJOfygZiOaPcOQBUio82mN3kBCLio+v2B6H+iRf3CcuWWpfWp6JHqZQu0es8pAsHT4BTj4cncu43sn5GH0Jaj5u02F2Pnnjoy+BpDOAoK4dZtCQRqgqcU/QOW7eSXXD2SkPQhZguZGXoEeYFQuL6a9RyQu4ADcAH9n9z2Eynf7n5kl++EK/SAicmEmMseCy/Skyj4NKmZ8FwjpCRfVIztdrnsgjiND/bQhX3qZBXRTMT+RW0WXgoQyB3BVrsiO3u4Yp8K29Lb9umhZn5ZCovHtdNCIprx2/D+K6bzdj7j5UQz3/DDSJNC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(54906003)(478600001)(7696005)(4326008)(55016002)(316002)(110136005)(9686003)(8676002)(5660300002)(8936002)(71200400001)(26005)(52536014)(921005)(7416002)(186003)(33656002)(86362001)(4744005)(76116006)(66556008)(64756008)(66446008)(66946007)(83380400001)(66476007)(6506007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WmlOMkJ6UFl4WTZrVzJhR3FNeDE4WFZJTVpOaUNWdS9OUXBIZ01oZDIzMkM1?=
 =?utf-8?B?Nk1sL01KaU1jeFdqWEFUTzRJdkxNaHJIR2ZvSE9VNmpFNTNIdEdUVFlpQW5x?=
 =?utf-8?B?ZWo3K0xOWE8vdDkvSHM3dGx4NzhBM1ZEb1NGamh2ZEk1eEJuR3EzY3BucFVx?=
 =?utf-8?B?NmJtS3VBaVo3cXhocTMxUVd1dE1Fby9hLzFhWnovSHZhTm5QUXh0M1FDR1Fs?=
 =?utf-8?B?S1hjclh2OWcxcy9qSjVGcmVUdTlmWWJxZWt5N0JtVE0rbGNrTHM3eXkybG9L?=
 =?utf-8?B?dktKeUhjQ0tjbU1SVXk2dTI1WUZscmZXZ0RROGJRSm9PY1QyUXBlUGZOR3ll?=
 =?utf-8?B?SUlTcGVYaHQ5SlZsL0dBS3F6V0wvc1JhU0xJMmdrU043cVBuaFRvU2pPU0JN?=
 =?utf-8?B?YXBYd1o5dmFvNmRpdnV2ekNlWFdzSmJqR2FDSjRsZFF4ZG0zMW9VVVB6bUpT?=
 =?utf-8?B?Z3ZkczRsVWRhR0d0bFBDL0Qwclh5Rld1RHJMSXJLWWdxTTF3T3hDVlpKRXkx?=
 =?utf-8?B?WWE1Y0hiSWtuSzhRamdvWTNmWUdEdFVLQU1oSnZ5aUpzalpHTjVyRm9iTkRl?=
 =?utf-8?B?R3UzaUE3eVdyTCtMcmM2aWxldnk2RkJsVEtvdStETlFybFlCZEk1MkhKbVRi?=
 =?utf-8?B?T21YTW1FTzVndlFuMEsvR2VJcmpPVGhMK2Zxa3FITWlkY1FQb1Ntb3VsR1N4?=
 =?utf-8?B?YWpta1lzekhGQzFYaHlRWGVpMVFVU2p2TTZUWE9rcVBjaGhvaWswSmZKOU4w?=
 =?utf-8?B?QXUzZVN3Rk1TT09vUVgvbjJBUHVPd2tYRURrTHpBWmkyNDZkOXg1a3k5OHFM?=
 =?utf-8?B?WVNmTU9zZHlZQngyQ2o4MjlQcGpzTGo0eSt6MnJjV1JLSzhyODYvWkg0ZlBN?=
 =?utf-8?B?Z3JrOUw5WmhKTE5vb3J6bkpIZGc0dVgvRVBjbFFESCtsTERuZktXUEVoYnZN?=
 =?utf-8?B?eldXWFBpeEF0U3NzV0I2blFNaFNKbXdvSERIK2M3UjBadjFvUGhyRklVWEhy?=
 =?utf-8?B?MmxqVktaLzJBWWJIb2Z3QUJXTjVGUVBrelkzL1R3ejhmemMyQkliZitZWDU5?=
 =?utf-8?B?ejBrUG5CRVo2Tys1NTJlRENRdkVHRkkwWmg3SHZacWxxdEU5WUVMS0RnV3dY?=
 =?utf-8?B?OExOVlBGR2IvTHltSnhDOW9FTkNrWDh2VTZvb3p5VUFVcENoM24zYVd6OENu?=
 =?utf-8?B?RDlXUGtQZWcvekp3b21sYjd0QzQwMGhKb2p4R3AzNEd6b2pWR0pRT3ZENkQr?=
 =?utf-8?B?ZWViYjhhZUJEZ2g0QjBudnl0L0Q0eWlrR291TFZKcEl0am9tZXM5ZVlBblJx?=
 =?utf-8?B?SWVJTDY2c25sV3RJazNTYW44U0ZFVzVZS2hXQ0k3MkEzdEw1ZmpxSCtuVU5m?=
 =?utf-8?B?L28wSHFCNXJKS1Z5bFIrZFkvZFhVc2kwQ0JCWlg5L0k3TGZtN0MvR1d2a3Jm?=
 =?utf-8?B?ZkErMnVSSmlESzBEWEt5WlZUUit1cmRyT1RkT2xzS09NV1dwdjhvb0dPTnNN?=
 =?utf-8?B?TVVmMkhpTlNyYSt6a3U0SVJzZmNKcUVOd1dOODhhY0x3cDJMdktkME1aRWJZ?=
 =?utf-8?B?SjRFalBHTXAyZnFQTTA5Wm94WWVXbWhZbEpUNE8wUHhuMm9ZeHlINHVLODRE?=
 =?utf-8?B?MFVkS0REeCtYTGtJajgzQlB2RU1FS2prQ1lWeVhiZlNkZmdQQ0JObmtCYkhB?=
 =?utf-8?B?dXozUmRIUVRsR0JWcnlSQjJOMXVQOU11cUh0YWExREQ5ZkZZOTB4cmp2WW80?=
 =?utf-8?Q?RojaAIo1tP3QF+1pDWrsV3bvC4uSeRPX4wPRVll?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6878d4a4-b0e6-4f98-b731-08d8cda74e4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 09:36:12.8280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aGFbZrKjyac2J/XIQkcUwZrAikNGIOzaDX77a4/G9RpGqGdW/vtPo3OWSbINpVTwe0mH3n2Ra3cMiILtnvJOxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6510
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArc3RhdGljIGJvb2wgdWZzaHBiX3Rlc3RfcHBuX2RpcnR5KHN0cnVjdCB1ZnNocGJfbHUgKmhw
YiwgaW50IHJnbl9pZHgsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50
IHNyZ25faWR4LCBpbnQgc3Jnbl9vZmZzZXQsIGludCBjbnQpDQo+ICt7DQo+ICsgICAgICAgc3Ry
dWN0IHVmc2hwYl9yZWdpb24gKnJnbjsNCj4gKyAgICAgICBzdHJ1Y3QgdWZzaHBiX3N1YnJlZ2lv
biAqc3JnbjsNCj4gKyAgICAgICBpbnQgYml0bWFwX2xlbiA9IGhwYi0+ZW50cmllc19wZXJfc3Jn
bjsNCj4gKyAgICAgICBpbnQgYml0X2xlbjsNCj4gKw0KPiArbmV4dF9zcmduOg0KPiArICAgICAg
IHJnbiA9IGhwYi0+cmduX3RibCArIHJnbl9pZHg7DQo+ICsgICAgICAgc3JnbiA9IHJnbi0+c3Jn
bl90YmwgKyBzcmduX2lkeDsNCj4gKw0KPiArICAgICAgIGlmICghdWZzaHBiX2lzX3ZhbGlkX3Ny
Z24ocmduLCBzcmduKSkNCj4gKyAgICAgICAgICAgICAgIHJldHVybiB0cnVlOw0KVGhlIHN1YnJl
Z2lvbiBpcyBjaGFuZ2luZyBpdHMgc3RhdGUgdG8gaXNzdWVkLCBvbmx5IGluIHVmc2hwYl9pc3N1
ZV9tYXBfcmVxLg0KQWx0aG91Z2ggeW91IGFscmVhZHkga25vdyB0aGF0IHRob3NlIHBoeXNpY2Fs
IGFkZHJlc3NlcyBhcmUgbm8gbG9uZ2VyIHZhbGlkIGluIHVmc2hwYl91cGRhdGVfYWN0aXZlX2lu
Zm8uDQpDYW4gd2UgbWFyayB0aGF0IHRoaXMgc3VicmVnaW9uIGlzIG5vIGxvbmdlciB2YWxpZCBl
YXJsaWVyLCBzbyBub3QgdG8ga2VlcCBzZW5kaW5nIGZhdWx0eSBIUEItUkVBRCB0byB0aGF0IHN1
YnJlZ2lvbj8NCg0KVGhhbmtzLA0KQXZyaQ0K
