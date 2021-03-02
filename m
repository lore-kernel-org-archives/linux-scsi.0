Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDCDC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAE7864F07
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581362AbhCBSuv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:50:51 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26097 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377999AbhCBIx0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 03:53:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614675199; x=1646211199;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sytk17hwoPezlu9+28lpkgMCXVIP+fbN9KgKIlN7+i8=;
  b=Yx+D0gkgyJE64A1rBK6WDZQLo+e/JIHaoZufFEKyic6aZaGwModhrm2z
   OiQrCOJerZSi6X4HiFvT6Q94fa5PhsrqaoVtNqBiNTbzH9kaJS7p7hXEF
   W9NoF1v3/47VobfhSfIafPZEzUKGOub7991g9ImK4ejKsNHUpGYwabqlC
   /WRUs79zgw/VQsaAbCVFKv0NPXDxfcxnoZM6bz7Vh3es71V4Bmzx9Hf1/
   JUH4QtGd/INjlUsnR+mZTwFlHtWoON1HLlseoZOz0fsqDPmvlz0kQzLVi
   ACS2ivIhi52+Pu9b0FxjH5wFdgvoJR1VGEz86nmsZbBwo+Og61Y8zPJg1
   A==;
IronPort-SDR: wwnQoAE1BWl3a2WEL15S8vQxT8IMBYSpyZCqoNPXaNzdgiLY6lkpyIEgMxN6MJFJ58uDZMdsv0
 Do7egm6KXZEawjVt4CEPwQGIeNe/jaSbtMGWL2N2DAoBUrVsAU2UIKLdsgeHaneYxGXVVunygU
 WZ7wYPJPL3u35ujRbjEdTz7W8rC1L2qmcZPXHvHhY9O0E+1n4ljUFypPUrYR4IEDw+TzRW4yWh
 BWrZ0DSyyCsvcyfa96hYlV+Yq8gmYbP3vZnpIMd+k1p1cS3dVy/ta5hrMpcpouWFLnSZhqTiik
 U/k=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="162309215"
Received: from mail-sn1nam04lp2053.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.53])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 16:51:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlZiypB7R/adcjdY3FOyPwnMI3BagD5OQvGXIhOLUjwtMUCArPwOwlUCdenaEIWrzk6UWrDqEn0ooj+pBm4AKKG6QYRPvzUGpImf5cuD72iX4yslwck3dfZ7oqrdV2kas00P5XHHvxSrbrT3UQq+I8B8PYc0hqhMqofiO2Yz62toOiThFTwVXvtwCuO5hEnv9hfgHHO+HxxKdnnaZ0FqmCNhBgZRhJqtBQAqWAeSzJ4GYlvvgwQta8LiLAmmdqeb6szSI9PBlPzVcZw/8Wi3t/YiKCf7Ij14EjJvKoA7hSK4QwKW66rkQYpstm97ZCibo/okQbETLDXgeDaaXLB8iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sytk17hwoPezlu9+28lpkgMCXVIP+fbN9KgKIlN7+i8=;
 b=Gn337yybSc4bmoxrCqTCk1w4xZLSxwkjQ9qQowfEQgX9iy5ia1WGUpdUDwrc36Ol07T90ObE7fKPkBR5fiylKQHrwb03EbwnIVpYhmN0sqBgr6VTG7lHsOq7hnF/LNCkHcIT84ufXTs54qsade1dRQJdFEjRIjQwDZU4Iab6quj26OetD/uDfaXM/h5v11GOHhJFI7aD9y6bwygbOtQAbPBG3QrxkDtNW+nEwCD3AY8XCmRNl143yz1bVjv7WEg//kEqFc/JYCd6XhSuro2aKtDe+zGYa2Q+vfx4kpCQfriH6jqhW9nX99wy/hA+Q9c3UG3EzLuqqSL3qa9sg3an7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sytk17hwoPezlu9+28lpkgMCXVIP+fbN9KgKIlN7+i8=;
 b=bpflfupnCCc5W4mdwAcV1Y3fBTYdLO2DbzVc4DnW800oWxkqgRg9cLRN3LIveYDTkAk4bk2vzjT3iPUZirbQIqkXZsWJzdyrPaVaVzHCIBuNbUC5z1UwvMP+mBJzxxkLXxrGy4wsBMpikBYMB0Nfi0LhP1xYmP+EhikZqquT/Y4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0410.namprd04.prod.outlook.com (2603:10b6:3:a9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.26; Tue, 2 Mar 2021 08:51:26 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.030; Tue, 2 Mar 2021
 08:51:26 +0000
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
Subject: RE: [PATCH v4 6/9] scsi: ufshpb: Add hpb dev reset response
Thread-Topic: [PATCH v4 6/9] scsi: ufshpb: Add hpb dev reset response
Thread-Index: AQHXDBo/LCB2rl6Je0WNJnfKtkW+SapwYZkAgAAId8A=
Date:   Tue, 2 Mar 2021 08:51:26 +0000
Message-ID: <DM6PR04MB6575FF7272CBEFDCCCAD117DFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210226083300.30934-7-avri.altman@wdc.com>
        <20210226083300.30934-1-avri.altman@wdc.com>
        <CGME20210226083447epcas2p2f68ef00a935d25bd2cfc930d1ef1f4f7@epcms2p3>
 <2038148563.21614673682593.JavaMail.epsvc@epcpadp4>
In-Reply-To: <2038148563.21614673682593.JavaMail.epsvc@epcpadp4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dbc73926-a34f-4cc3-2e06-08d8dd585d87
x-ms-traffictypediagnostic: DM5PR04MB0410:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB0410CDC8AFBE8A154731FA44FC999@DM5PR04MB0410.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xxDCPzrLkRU6lzpOp58PgkKBUDoJAHuGWrDLq/YDuNFtguP0paGQ+xeEVGbs+drnCvkSQAqwT1rkrvDHgyeLLgDf0QG2ILe9Ey8gHcdPGHpZ0XlKnM31lotQI/Ol4krki9sQdpxWbr01i54DFpuw9z1KSNjxXoTOHWejRzDWEp/390670/2fVStMZcpoFHpiB0A1s4EvYOhQCGQWts0zgiTCVH7gWZ1jj+jlRsNf1iRABRrsLpg49g490WFxGLNyU4wbHTPXOV0tZWVGwf8V+2wyM2o8xW3mq1qV+hdwjdiuyXOcFLBU3z5sXea2DkN45Dr9AlIPx1DXF0FfYskvfpw73GfAXNoa7h1e67MpBwskLMAdiSJENsPUaeIFPMML6ev7q/9t1s4WsUc7K15KhBe/TRwpjnwav8ZzGmsthHHeV061klrRcOw6C984SPpya9W5vNfFffcApFqQO9vd9iHZGkqtXTGWDsPPGJ9bE4o6kPwbwyus9neWvl70VmSmGaaGHm836DbC7gq1mifq+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(9686003)(54906003)(7416002)(26005)(71200400001)(8676002)(4326008)(110136005)(55016002)(2906002)(52536014)(6506007)(186003)(5660300002)(83380400001)(86362001)(4744005)(316002)(8936002)(66446008)(66946007)(64756008)(478600001)(66556008)(66476007)(33656002)(7696005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OXR6c0RtbGg3T2pzWDhDN2tOcmpRZUV4MlppZDhHWXQwMTYzaW1NSFpneTdh?=
 =?utf-8?B?citxUjVOdmJvWTBYMmt6WTg5YXYrak5rQlRGcFNYTkF4U3pkMjg1aVJjNUpl?=
 =?utf-8?B?UUNjR1g2L2JTaHVkaVNzWWxibWdWaStPWDZ2bW5TTnh5bXJ3MUhFNEw4MlpT?=
 =?utf-8?B?VmJZSHlXRzF4OVZFUHFnTEl5Um1wZWZza2xySURBdzdHd3JPWGo5WGxEd3J3?=
 =?utf-8?B?SFFia3BsRjR1RTF5clRVSXpraFczUks0UkwwdWtLRElqVnZvdFBFNFczZjJH?=
 =?utf-8?B?WmFoQ1JIOXcwVGxyaDZZbTBMS0ZYdzhuOVVpM3B2OWtCUTU4V2p4VmtFVDI3?=
 =?utf-8?B?aWZ0NW5qQVZCSFNZWHhqNVBGR2NWT2VPVlJEMmYrMTRLNXV0SWo3NTVHbXg0?=
 =?utf-8?B?Mk44aG1wV1V2dDBNZjRycU8rU1hMbnVKRVpGSm5QcVVCRzFNUnNTVTZHRFFJ?=
 =?utf-8?B?NC9pZ3dMREtxYXJ0Zjc5MWZTSFR3S3Exekp4eFdOTkJ0Z0xKM25QaHphb1pu?=
 =?utf-8?B?UkEva2lBeHpHTit3ay9ObkpCYTlVQjIyb2JySFBtU2RqSUI3d1k1RWZpWHdY?=
 =?utf-8?B?cDd2OFg2Y2M4cXlZUmhwQjV1RUJtV25HUFlLN1lLZVRWOHU3MW9zZVBJalA4?=
 =?utf-8?B?c29Wa3dlbGl3U3VERUQwbWppWlJTam9JcUdJaWpYV3UxR3JPTmIyaEVkT0pu?=
 =?utf-8?B?dzNXK0I3OXlTYXhvbHJidlMrZkhGRjRzWWc4OUEvRFI2aHIvbkx3dHUwRitK?=
 =?utf-8?B?eXl2eFlLTnBiZU9iN3BNTWxFWjNZaEw4dlh4VnBxQnR0NW9sUVVpellRRTNG?=
 =?utf-8?B?M1pSOEZjYitGQjZBN2tjRE0xV1FZNTFHNWxKM0pXQ1loc3ZxZkE4dFRydm5S?=
 =?utf-8?B?b3JyUU41YWNCcnovTUVwQmZzd01xejVsSzM3VnZXdkh0NC8zTjZTNmxhajRK?=
 =?utf-8?B?SWt2ZmhOd2NCaG9vUEU3YXpiRFcyZ2lWWGdoRUU0TWc0aUZGODQwdVJYa1da?=
 =?utf-8?B?NllWNG8vR0lzL3NwQjlxTTdEV2ZjdWdjOGFFZ2lIWmZJS0dEdHFqV0Y4elo1?=
 =?utf-8?B?ZGxvTkRCNjRvUWd0b05TZlBwRXhha0hISmZSUHltRDBPc3dpbmQ0cUJUQ2hk?=
 =?utf-8?B?UzFXR290VG50ZWQwdFVlVDF1UWNwdE9TeEZySjZRWWN6MzQ1c1ZkYU9pQzVl?=
 =?utf-8?B?YTRkMmxmakNRcmMzMjF6anlJaHNjb0JzSGNKVXE3S2VlNUtHMlJ4M2pWUGh6?=
 =?utf-8?B?bEQvZllUY0lhemdQYm5wTDFMb2ZYcnpLU21zdFV6L1MzbGNScEF2SHFVZjFK?=
 =?utf-8?B?YVlCenU4OUUzSWJWUlpQaFp1N3h0QU9NZlBLaE9jS0RucGJHalh0YS90VEZV?=
 =?utf-8?B?Z01abWxkbS9XcXNyb0FjenVwZ05iU1VLTE1iUmtCYUFKUlVBSWd0YkVTL3lN?=
 =?utf-8?B?T1o4K2ROVDVSeXhxbGJNRXZBUWFUVFBiTy9yZnpUK3l0eGRiQzVNV3lNWFd6?=
 =?utf-8?B?dWMzVFA3dE5lWHlXMytkZkJuSTY0SldWZDVKK1MweXVHZm1aZTdSa3F5UDkw?=
 =?utf-8?B?MkRTZitmcEJuUDhYVGZxNDFGcUtMcVUzelpSclpIZHk1T3A1VGNiUk9LY3Z2?=
 =?utf-8?B?c3hxTDRvbkJmRlhtU3Z3WjJuWThVenY5aGx5OWZhdk5wN2lKeVdyNDZaWE5z?=
 =?utf-8?B?bnZseFRyVk9hTjFLOGh5T25pb0FTamVSU3lYSndqaHREQVVzY0lkWXQ2dHJt?=
 =?utf-8?Q?IVt1K7+FxiyvluYBjYIQqX/FUUASU7uvZa4kyW8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc73926-a34f-4cc3-2e06-08d8dd585d87
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 08:51:26.7960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c83Yt5J6yJy6DPRSyuIFEE1bshy6eTaIzpyvdMFtRprNR+sp9jzC3gJpudzdgafW1vYchfT5CsytzdtaRWrQbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0410
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBIaSBBdnJpLA0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIu
YyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmMNCj4gPiBpbmRleCBjZjcwNGI4MmU3MmEuLmYz
M2FhMjhlMGEwYSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5jDQo+
ID4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNocGIuYw0KPiA+IEBAIC02NDIsNyArNjQyLDgg
QEAgaW50IHVmc2hwYl9wcmVwKHN0cnVjdCB1ZnNfaGJhICpoYmEsIHN0cnVjdA0KPiB1ZnNoY2Rf
bHJiICpscmJwKQ0KPiA+ICAgICAgICAgICAgICAgICAgaWYgKHJnbi0+cmVhZHMgPT0gQUNUSVZB
VElPTl9USFJFU0hPTEQpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgIGFjdGl2YXRlID0g
dHJ1ZTsNCj4gPiAgICAgICAgICAgICAgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnJnbi0+
cmduX2xvY2ssIGZsYWdzKTsNCj4gPiAtICAgICAgICAgICAgICAgIGlmIChhY3RpdmF0ZSkgew0K
PiA+ICsgICAgICAgICAgICAgICAgaWYgKGFjdGl2YXRlIHx8DQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgdGVzdF9hbmRfY2xlYXJfYml0KFJHTl9GTEFHX1VQREFURSwgJnJnbi0+cmduX2ZsYWdz
KSkgew0KPiANCj4gSG93IGFib3V0IG1lcmdlIHJnbi0+cmduX2ZsYWdzIHRvIHJnbl9zdGF0ZT8N
CkRvbmUuDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gVGhhbmtzLA0KPiBEYWVqdW4NCg==
