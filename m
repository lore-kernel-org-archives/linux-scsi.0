Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE18C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 07:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEC6A64EE8
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 07:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhBBHr5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 02:47:57 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:1495 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhBBHr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 02:47:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612252075; x=1643788075;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zPCbgpOJvT+VeEmBQAMURMKrNDk8U7jwd38JuX0gJq0=;
  b=EHs7TPO2RXq/qKHFDMJ6noqGseDAingawA3wEvgwBKFdfeFbvY3sXRce
   5qWKfC0D/MeWas26JM8EboKJFfCh5haDf3kRh6znTol8ngI90ufAfJVdU
   cpbD4sEdwDlzIQ6g8AcDglgklzhuvT2fPObOuTvcv40rd8a2GlnAPySkB
   DPhkyHzcZb+XQv1WHBBkXicNt1KaQnnXgRu/p1C4sm+7nkHtrzIjaW39L
   IgVht7Lz0GMrNNMN2xRINOHPeOsjClambDdqvc9pRoTGZ9hptCp8respS
   WC9BnUPb4e/S7+9XU46wrGDpBm4S3qLnAGt9XCDE/Qqrr4gqVL/3FMSrS
   A==;
IronPort-SDR: lDAtAf/TkeUOc3oWQCkFp+UIk1Dauw1sNkNHuwLrEt8QI6vDDlXzs3Z01+jeeZfzLzAuTEQl2K
 Ab7Zs3ObJjIYc7fOJd7WJTII1Qyznk52E0miSxb/n2/xfxQezwP5JgvwJLa7NmUnQha2+JLTI7
 qySmMGtwHhuT1immCm5ewN5w8rvo8sfllIjfM7MkugU7i/IhzjTn42r6sl3Ss6QjsPIbAKHZ97
 KZ+Z/zrGl4dQIsq3m59wtRjI3xDpinOIL31htjaEflIiMWpysDrlkbNIbmSHaAHDDvbJs/uU4+
 KBY=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="269311586"
Received: from mail-bl2nam02lp2059.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.59])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 15:46:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIn1Mr4pX3/Nunm2/aCprCjZgAj5vnwtvZJuefzbHCVPA5eyN2jZGaFd7KDhyYyjdhdu5rgexutAll9NqFET1Cj6JADCyx4c6GN9ZyUoeCz6v3ft1qQk62LGxq0WbBvtNITfifNP1Tm8Ph4bBz3xsORN6ptxx/ClyZN/hMquufe/S8tSTo0Eye9Vzb6NuFF17iYAc30X5orcO1mlxnhy4iqIHbYaVvcOYvEVwXqvZJYCSwFZmj/EVpCyaJLMwciYNGgEEMaHY/Rs62kazF1o8DvmdQ/wfuYCF/TgeN06D8Hb9qlF02cmUwstMzfKXdFX9+NgPnsubHgnlpvN89BTLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPCbgpOJvT+VeEmBQAMURMKrNDk8U7jwd38JuX0gJq0=;
 b=DlPYkP1qVskYtX/s4J/0yPxtthRFycIAJNUP911xMo2mau1QvWimPPzLejhVpMSVUSVpekP85bGUZw7g23sNtDgGrgIKfTiAbyeyblGQubtmrGHjafFg1yB+SeGucRLVO98vKZzzl2iv0f/7san2ZufJYxOTfnO01vrGYjKy52ZKgCIGlzzjKxxBcf5gJ8DBzteESRUmH05P4sJs6Npk7DuQb2SzRO48TBBG9miboN3xMnvL20B5gkoQc94vjTBO/8x1hFhwjgV3B95aLaH/WTIhfWkzFM4/nPKKbVRWjfEtwspqAMeti+f2pSQmUVW3mionixL37IVcS2s+2B57RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPCbgpOJvT+VeEmBQAMURMKrNDk8U7jwd38JuX0gJq0=;
 b=VSpd4522yUePYn7fGRpjFDm3SONHKILwb/7aMfzap3Z/GfxDsAsgxLVlEBE//hRcyG3cjMdTDVEk20qJWOL41Fz1bE3UyvOZETD0QmSM94bhq40+bUh6PzQj6U1xK4zigVjpx86CzPlx/pCa63MD8Ch/0knPDyIjE5JnwZYkDh8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0970.namprd04.prod.outlook.com (2603:10b6:4:47::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.12; Tue, 2 Feb 2021 07:46:47 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 07:46:47 +0000
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
Subject: RE: [PATCH v19 1/3] scsi: ufs: Introduce HPB feature
Thread-Topic: [PATCH v19 1/3] scsi: ufs: Introduce HPB feature
Thread-Index: AQHW9f/CB4oMNhQYf06IVzvE3/5226pEfn+Q
Date:   Tue, 2 Feb 2021 07:46:47 +0000
Message-ID: <DM6PR04MB65756A9DEB4F12043FA9C8BCFCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
        <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p1>
 <20210129052936epcms2p136a2ae69803ca399c99e815e1244779a@epcms2p1>
In-Reply-To: <20210129052936epcms2p136a2ae69803ca399c99e815e1244779a@epcms2p1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 119d0f57-747b-4549-77a1-08d8c74eb181
x-ms-traffictypediagnostic: DM5PR04MB0970:
x-microsoft-antispam-prvs: <DM5PR04MB097000A0D01062F62A062169FCB59@DM5PR04MB0970.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NEL9dl5EJe3zPsL3W3D3s1GdCGNm+/iEau9fERudjK5V9/iaPrUczkBUhjG3lIS30qQOxYHZI19gzI7vooWjv216rGWGC5mfdWTZD/marbIJYLfL8BawvkRBNGNplLOBqBjLBs13nf+5RYkSbbx5ngdDdP9hpDOCXarM1GW2bDkiUg9+D0iyINZmYo/MLsctJokXJdrMeePSlwoiVaAUzIo9Mh1IcW3BFcpfVKk9FFqEkfatKjxklMnFKv8yI2GDP5N7v6RXbRGF2uTWqGe40YrTipsW9t2zVQkdEjA0h9IjxkQKq1asvgjGLoKEE/4Sk74dH3j0bI6UtOgtFe6GOzzUFh1UUKpUKo2/Bx8wXF2rQZu8v3v1oMn6/B6iRzGnE42u9HkuHjDvJPhkybG23wdNmLbFYv2Rr+FqZFVkbjT2sUVuqvsCWC3nT1NPfpmQHZ9SCEbBcfLqFn/4okDgRg9NymDeD7hKvJQD2GRAcD2Hr46/Q0Ov0/FS2Q4nHNrX7tdJEleTuxNE1zeuIQe3NBRSn5tvvoXsM6cUK1dZB5ulJPUOtRcVrpi7s9d1+72m
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(2906002)(8676002)(66946007)(55016002)(52536014)(86362001)(7696005)(8936002)(6506007)(7416002)(4744005)(316002)(54906003)(71200400001)(33656002)(478600001)(186003)(66476007)(5660300002)(9686003)(921005)(66556008)(26005)(66446008)(4326008)(64756008)(110136005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NkZ6d0tVVzJNbzJSMW5vVmg1Q09VakJ1M1VlQTVwMWprTlk3dmFHM2txb3Rv?=
 =?utf-8?B?SUl0SWZvRXUyaWxtYnZOM0QvdVArWjBVVy90bXVkd2taWG53cVRsckR2MHFK?=
 =?utf-8?B?N2laYTBYZUloYy9BVzliVVAyVnpsbldYdEI5dGlTdTJBUTRTcXdaNU96OXNj?=
 =?utf-8?B?T2lsV3VKRzA4N1ZIclgwYXFpVGVKWXpaaVJmeisyU2V0QUJTd0FwTVdRcjBC?=
 =?utf-8?B?TU1MeVk0c0YyRW5lZGZQRWtOWWZGRWg4b1hhajFhTTZ4WHRETWNqWFcyQTl6?=
 =?utf-8?B?K0JRNlM5QkYwTkdxcDNVY0xVTzdHUTUwYU13aTQxMy9acTJvRDJrWTZJdmhr?=
 =?utf-8?B?ZjZ2bjlKSm1FYzZhQUZZRUhYbTBrbmpBbWpiU0ROdU1DK3g4VjV5OW5lUG9G?=
 =?utf-8?B?aTUxYnJuYm1FV2pJQnBqS2ZpN3Q3VEFZWjNHdGFiRjNsRnIveTBnN2tRbGRk?=
 =?utf-8?B?S3A1LzNzTFVDSUx6WmNtWWY3Z3RjdVpPYkRDSmpSenNDWWZkTHpIVkJiQkdB?=
 =?utf-8?B?OUdLSGhTOTVvaGxXZUdwMGVvYTRJa2RabmJRaXNvaUlQeENaeklEU3hROHZC?=
 =?utf-8?B?YmlITWVKV21GRE9BeWI0bTgzODFCT3BESGUxUCtSZ2ZZV0dqOFYyZUw1T1Zw?=
 =?utf-8?B?WmFrYWhxMmpZTHlQVFJRZjFzSHFtN1ZSODdVLzRwTTMwUGo3VnZjZTh0WXI1?=
 =?utf-8?B?RVRmWVpQY2ZLV0hlWHFzaUx2MU53a21HRHYyWjd3S2lkUlUvcWppUnErajlC?=
 =?utf-8?B?alpvZy9VcTMrYU50RU50NUgxejIwTS96SGZjZjJ4MmpYUUFiN0pKU3NILzlT?=
 =?utf-8?B?VDJiZ2loK1VlcW5saHVlek9xZllGRjkrTHBoclZlL2dDL3o4ZkhKWHR0RmN3?=
 =?utf-8?B?VVRqZEVUajAyTWR0Zm95Z0J0UU8vQkN2REVaYmUreUhLbFRld2VIQTFRMnhB?=
 =?utf-8?B?RmRpRi9KREh4S0MyWHBubGNnZWdYN1NsV1NHU3pnWGVoc2lrNXd5STFhZ0Zm?=
 =?utf-8?B?ZmtRNHdtRFNud1JPT3BaNkUwcE9CUnB6aHUzUndsK1BLb3kxZkUzOUd2Yjk5?=
 =?utf-8?B?MEE1T1F1cWJSRHNRVUJ1NXNrQ1RpclBwRUIyNEhUNEQ2a3FpbXprekUvTnA5?=
 =?utf-8?B?ZkxQQzc5YUVoNmU3RWdLeUc1OTFQbEk0aEpXdEoyQThpRFowRStiUlJJa0pX?=
 =?utf-8?B?R3ZPK0dQRVBtQ1kxTzQ5VnJLUWdnVDVybEhJQ0NGN2lmdzhpb2g2VTJGeDdu?=
 =?utf-8?B?L2RJbVJNa2lHVEZMekFrekVjQXFGVTg5d1dDWDBTWFlzMmwzOVIzUlZWRjcv?=
 =?utf-8?B?cUc1cE92UVFsUlRPSGpTbXhqZGtWWUtCR0NZd2RHQXlsTFhEaGpXaEhwUU9l?=
 =?utf-8?B?eWN3RXZFZFZMSW42UVJoUDR1aWtCeU43T2pRZzFlNDRPKy9nY0FDczkvb2FW?=
 =?utf-8?Q?fONQy7G5?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 119d0f57-747b-4549-77a1-08d8c74eb181
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 07:46:47.1457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mOQenoysEEuotrh5G3SW/4porT2cnZGta1K9qOhpgaWAdns6Z0jYCYDqwxNUMgo8NfGjL3A9gr9LRwziQiaGbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0970
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RGFlanVuLA0KDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGF0dHJpYnV0ZV9ncm91cCAqdWZzaGNk
X2RyaXZlcl9ncm91cHNbXSA9IHsNCj4gICAgICAgICAmdWZzX3N5c2ZzX3VuaXRfZGVzY3JpcHRv
cl9ncm91cCwNCj4gICAgICAgICAmdWZzX3N5c2ZzX2x1bl9hdHRyaWJ1dGVzX2dyb3VwLA0KPiAr
I2lmZGVmIENPTkZJR19TQ1NJX1VGU19IUEINCj4gKyAgICAgICAmdWZzX3N5c2ZzX2hwYl9zdGF0
X2dyb3VwLA0KPiArI2VuZGlmDQo+ICAgICAgICAgTlVMTCwNCj4gIH07DQpBcmVu4oCZdCB5b3Ug
Y3JlYXRpbmcgYSBocGJfc3RhdHMgZW50cmllcyBmb3IgZXZlcnkgbHVuIChldmVuIHdsdW4pPw0K
VGhpcyBpcyBjb25mdXNpbmcsIGV2ZW4gaWYgc2FmZSAoYW55IG5vbi1ocGIgbHVuIHJldHVybnMg
Tk9ERVYpLg0KQWxzbyB1c2VyLXNwYWNlIGhhdmUgbm8gd2F5IHRvIGtub3cgd2hpY2ggZW50cnkg
aXMgdmFsaWQuDQoNCkNhbiB3ZSBncm91cCB0aG9zZSB1bmRlciB1ZnNocGJfbHU8bHVuIGlkPiBm
b3IgdmFsaWQgaHBiIGx1bnMgb25seT8NCkFsc28gbmVlZCB0byBkb2N1bWVudCB0aGUgc3RhdHM/
ICBNYXliZSBpbiBhIHNlcGFyYXRlIHN5c2ZzLWRyaXZlci11ZnMtZmVhdHVyZXM/DQoNClRoYW5r
cywNCkF2cmkNCg==
