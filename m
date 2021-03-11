Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E207C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22A1364EB6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhCKIEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:04:54 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:24769 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhCKIEu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 03:04:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615449890; x=1646985890;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C+2MFtL9U4kUcQPc1K9oeoidxqYXV8mQaTMlKMM1K9w=;
  b=MQJCslhbtOJfqHWR/ClLLbfsyGmTqFZfJH9OrVn5e+aJrhwaiMeoMUWp
   85Rbx12xuLI7c4u2EeAG4GCo/23dvhMY4JAw+3/TVpWYwPsFiS0Ll5zq8
   Hgu7+9MyfpjuRPkFc/GJFxJKWSjaNsqS2ioCkmJRfYn9/f2W4ZXtkB88W
   gzbC55zWcslKZqbmgiSKqsXuLf/VCQ0lM8hiioXHXYWuWesf6oWEQmdL9
   ndsEXpz/NSXvsU76/vtUdls0HKSUsNHe9pGMR12hk+WiTY8WXjzgPmDsn
   b4zuPMGP8om3qpPS5er6GJln7Sj+y1volFfdArw/J05cSJ0WYs7HxbzUH
   Q==;
IronPort-SDR: 8j/CtZ8VxkGCWnSzmbCMgmCL9pwVt801fje0SKKGApasVNeelHaVZYVG6EZYKeuY2E4jnBMc9y
 6y5WkB4It4bE0t36YKM2JcQV3gANVI4JSOk5VFiSmuo+aEcFP+NRbNH63O+t5HRaLT170JS1ds
 l0X9FDxLpqbDHhxSkEya6UdMG/oma7MqPESiMHSnJCqDZTvDXoGEqU/nvfhHzWHph/c14e4d6p
 95LyKvCBax4kjZGHlWhCmKE9zUVrS0efnxalPLA4c5/YRt0p4Zm1Xxu6rGlDngFNnRvVR4g03Y
 FcU=
X-IronPort-AV: E=Sophos;i="5.81,239,1610380800"; 
   d="scan'208";a="161885836"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2021 16:04:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JohNHG4GU8E9x0vPXH6y7zqMaMcIiK+UmJAZI+NiuJfYfvI+yuvK84g1ZTMo9po0kjvUFxISk+drFFrbd+EfWG5HPTGGQ/KzYLwEAinXINyVEzKfogT2qk7zBit65uTnAQNA53ayEuhppNbSW0wNQ5fUkpBar5P5ZiwMsPO+484MKS/icmMg7ep5edqVJHqu9sQjW3wnByg4ORKYr/pWyUkrfHI4KVC4n75efq0ZqLmHarouylK8cD4Uq84BB0wKx2ceJ60oQJh95p4+ovC2DMA0MjyNnOzv0aCCtvoem9qRNlEVcaHxht0RT345/zBCRT945QK6O2BOgl85vK+WBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+2MFtL9U4kUcQPc1K9oeoidxqYXV8mQaTMlKMM1K9w=;
 b=liROHXP6+AU8Y5b/nxFp/01SWjthjmoY9exuIF4yM1RdwxTnCDLWIcY6v/ygV4bFlhXW4frj9FqpRmOiXYeCMIO2XVKVdqzgfI0ZAsqb7Uy2myOVsBjmTZDjXctGyWVaejY0fKR005TZEMOwdAzO/We7xTDUwEkR5VYTYR8bo7PFibi0ichO/MRtI3JWzDZGHuBAjPFTQXGeYKKeasSQzo2hczYJzKsG4OxgAGWjvLvEdFBjikn/Qx5IxJeBKMDXOy2qXUioKKyWmpj1pFDma3gtGzdJTb44LKsb/tb/h2eYV8h5Fr/C1cu0xOhS14xbAVR1iv+7LXRFpkQvHkpyQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+2MFtL9U4kUcQPc1K9oeoidxqYXV8mQaTMlKMM1K9w=;
 b=Igl2XwA5h9AbBbhfOiOoAr8Ad+i3o6nYxEVN8rcADXQB3/t+WfGJP4dDvcTILn9YsBhlRbpG4TRy2ccNgLyJ0Fy5ZCy3fHIRedfaru2GU3HyC2GrzIqGz33MD8TKNZomA9vcHpxxFqNfzDWQBgf1IbyLCm3gAstbdmPx4lo3P/Q=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0541.namprd04.prod.outlook.com (2603:10b6:3:a9::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17; Thu, 11 Mar 2021 08:04:13 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.039; Thu, 11 Mar 2021
 08:04:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v5 03/10] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH v5 03/10] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHXD2ei7j8moNyDbkOuTIbGJCHBHqp+eD0AgAACucA=
Date:   Thu, 11 Mar 2021 08:04:12 +0000
Message-ID: <DM6PR04MB6575319E8340A8AD89633CFEFC909@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-4-avri.altman@wdc.com>
 <838c79b39bf43e2ceaac06a190ded990@codeaurora.org>
In-Reply-To: <838c79b39bf43e2ceaac06a190ded990@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec33f7d8-d584-4e72-f97d-08d8e4644211
x-ms-traffictypediagnostic: DM5PR04MB0541:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB05418C89ABF2551CB6736EC7FC909@DM5PR04MB0541.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FPFkl5bRRWjUx7t5v1c5jCENZPibYoGjLcMGL1suM3mFrDylzMoIWyhwCt+lqj4l7XkVD1cg1PcqszzTA70Z3F+0nT61eqrOleqw07+zr6WDuFvgoLKeYWCHzBtJx05+3ey+wVGgxxZz6PyWyw5H05w4k8e6Sq3fxAGppXh0NBEidiHyADmB5QvJbdo5XBbiDtMCMb8Io7PyajltYSefgNxPF9C6yycTGSLrQaXKEcPRv+CSpU5IpBtGYJEYHRYsQ6kIgbvkx+mU80zZmxbIuYCnFhlmRAp7K1z4N8Vx6OMYKnmnRvgAu6RygCUVwkNRVnyb/pLBDYsYqm9JfdfULx7m5sp8a/614GxFlWGabvndxOsB1Ri3upHZdM6N008c49EdIkgbggL5ZY5CuOr97bwRUASLqkYrIMkRiYTPUUhLyJX1sSLCZ+H7xLYFoNd2zeN5ZhGf/s9gRBo0qRtlVt30P09tiiQ44Qpt7fuoEJUaiWrLkFnVHZuRdfZ93GWj3F1khe4F7gDWQF/Gr3EggA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(66446008)(64756008)(2906002)(76116006)(9686003)(66556008)(52536014)(6916009)(478600001)(316002)(66946007)(55016002)(66476007)(8676002)(7416002)(54906003)(26005)(4326008)(6506007)(5660300002)(71200400001)(4744005)(8936002)(86362001)(83380400001)(33656002)(7696005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZHVQeUNNVnRzQmhQVW55L2R4aEdxTFloMUhjWCtvT09sRXFmMEo3RDlwTWRi?=
 =?utf-8?B?L01zcWRubWJtaTJzN0VCa0VYd3p4bWVWK0xWck1vL1dzVlZCVlFzUnZHUHpm?=
 =?utf-8?B?MFR3R01Xc1JSdDRpTG1YK3N4TGxYTUZ4VUFySUpyR3FtakgrZDJBUkp3a2J0?=
 =?utf-8?B?QzBGVDlzZ2ovM2RnVWZPcklFaHd5aStmM082bUJPQW4zQWlxYjVIYnJ2TnJD?=
 =?utf-8?B?M0xBaksyak9yZGprMVBuWGJZUm8yTDBuaVZsSGlHU0FaVEtRQUNvalhOaEdL?=
 =?utf-8?B?M25naUhYbDQxRkI4N2FOTUV1ZE00dERPM093ODRXNklTcFY1QnJPUVZuM1Rl?=
 =?utf-8?B?c1dMS2JOUzNXZUo0YkEvNjV1U1lJaVZwaTRxeVh3WEg4SHByVUtQdjVXeEtV?=
 =?utf-8?B?UW5rWjRYK0dsYWdWdkdCRE9PUjV1VWltQ2JFc3J6RVliOHVyTTdlSTlBRElO?=
 =?utf-8?B?a29HeGN5TSswVkQ1TXp6ODVXSVlXc243V3FnYnc0K3Z4RU1Qa3ZxZGEwYU1I?=
 =?utf-8?B?VndQTFFra1llcGlQNjdFWjBYT1F0Q3Y4bGFBaWVicEVqYmVXUlBQbzUyNVdN?=
 =?utf-8?B?enZqMmtNNjBBUklXMEJXZHRKN3paRjZ1U1EzZG5tYnhPNEN6R1M1RjR6M3d3?=
 =?utf-8?B?c2ZyZXJPQ1Bhdis0amlJa05lOERaMjVzdldkNFg2amZHdERiN0lBREl0b24r?=
 =?utf-8?B?SXcwWFgwOGl3alBJNmxFOTlERElwb3lLV2d0T3VUZW9jRk8rZnBRSWZjU3ZJ?=
 =?utf-8?B?THFkMGJ2WUNTcmhzczltaXJwZTNwWi9zZUE5WVg3NHYxVzJ5OUdieVpDT1kw?=
 =?utf-8?B?SEhrWUlZYy8yMGhZVXlwcVBPK3lkR0ZZNFBLQm1uSkU5dnVHZEJHSnE5V1FN?=
 =?utf-8?B?cVlnaklHbDFIMWxJSzBkQTBzQ2VwR0xrSW03K3cxU3FnTmRDdWZOVXNld1Vv?=
 =?utf-8?B?dWhDclpNS1E3RHBVM3RvWlREY1NVb0NrTWxVelhBTFFLdkNWSmhIU2ltUTNs?=
 =?utf-8?B?QTBTMTQxcWVnaWJZeUtmYTFza3dTd0tGbXQrb1hmSXluTUpxWmVyc2hmV095?=
 =?utf-8?B?TVgwZWpIZnE0dlVGM2xmRHNaN1oySUNXbjBZR3l2eXRhRklScW1MNWcxTkJ4?=
 =?utf-8?B?cWQ4MVluVUhaa2hneWl3QlV3dG5vMnJURFkzYXBaS2pZSVhnMURZK3NTZFpv?=
 =?utf-8?B?ck9MWkZxRVdUTnFWNzZtdWRwd0I1WjhJZ0Nhbm83bE40T05CSjlSc0RHcmdw?=
 =?utf-8?B?ZWx4dnJqNGlVZ0szWHNJb0p3TVJXa1ZWWXZHVmlEMWFzblhPSXFSOVkxN3Zm?=
 =?utf-8?B?b1loR3VOaFhGeUdkUHFwNGVOUlJCN1llNHpTdzFwSFR0cktxTlZZNmhRNkg2?=
 =?utf-8?B?VklsWWVSZitOb1NuL0QybWNSTW9HMkNsR1A4VTFkUWlzckp2VmQ0bUtZZWFK?=
 =?utf-8?B?cmU4VmNRRFpZL0N4L1l2cjVidDN3MUZzc0N6eThRWkFPUnVHakF2WkpiMkJ1?=
 =?utf-8?B?S0lSU0FoMFQyNERNT2Y1TWswdmZhS3REaEhFMFlVMW9pcmxrQlBWOTgxZzJZ?=
 =?utf-8?B?TklkUlRHSFo4QWVidFZDRDhVUnRhSFRxdkxKa291YkdUTDVhTkVMSzBOeWFB?=
 =?utf-8?B?UFVENXc1djdqT0FPQllYR1hCOURFWTlOcVJjSG9ZblV6SldTYlVKb0VvVUxr?=
 =?utf-8?B?MGZUOG9VT3ZtY0hnUUg1eWJSMTFkdDNqR0JWNHhQZ3pUNXZzSW84T2s4cFRB?=
 =?utf-8?Q?4HwsSutSWB+w+lOMVbuHJtGkhP7g+0Yst+ZvW3f?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec33f7d8-d584-4e72-f97d-08d8e4644211
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 08:04:12.8624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G9nhEqeW1feT40Cp90d8BWVg0i+PiAAfTf2ALZ9nXMnXoto3tdpJPbVh0FL04H7WrT/89sMoY/oFDjYJO+Dytw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0541
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5jIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNocGIuYw0KPiA+IGluZGV4IDA0NGZlYzk4NTRhMC4uYThmOGQxM2FmMjFhIDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmMNCj4gPiArKysgYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hwYi5jDQo+ID4gQEAgLTE2LDYgKzE2LDggQEANCj4gPiAgI2luY2x1ZGUg
InVmc2hwYi5oIg0KPiA+ICAjaW5jbHVkZSAiLi4vc2QuaCINCj4gPg0KPiA+ICsjZGVmaW5lIEFD
VElWQVRJT05fVEhSRVNIT0xEIDQgLyogNCBJT3MgKi8NCj4gDQo+IENhbiB0aGlzIHBhcmFtIGJl
IGFkZGVkIGFzIGEgc3lzZnMgZW50cnk/DQpZZXMuDQpEYWVqdW4gYXNrZWQgbWUgdGhhdCBhcyB3
ZWxsLCBzbyB0aGUgbGFzdCBwYXRjaCBtYWtlcyBhbGwgbG9naWMgcGFyYW1ldGVyIGNvbmZpZ3Vy
YWJsZS4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MsDQo+IENhbiBHdW8NCg==
