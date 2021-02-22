Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377E8C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 19:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEDCD64E31
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 19:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhBVTcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 14:32:07 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:18424 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbhBVTa2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 14:30:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614022227; x=1645558227;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=js95pTMoRTGcaUj9AopgksxxksqmnVR4BNiZnQ6c2sQ=;
  b=bW6HR3VAwjeqlPmGIcPMxEuILt4SJqNi+V06C5jn6uuKz/WUKt5FiwzQ
   2jvbQd7uRrM9k9SjFuh561GI3BmruiCODjexfQ7r88MsmGZ0WxH93YWaF
   E6p5Oxkl5BO7GoxTAsb1GSgJzrhoSDPlX+SeLfekqMRR0SDzxZp+X/ULi
   IsSzOqMRLySIw2EHaESsUINUFdgKe5O3ntgA5fS7tSINLhH01qgmAVz0b
   25vGc1R7Ow/EcSlZOQ7Lfa/yWT/GFH3TMlFL0OwJ8H4gtTxnZgt/QJHFQ
   FL6FyB7SqZP2XJ3NAGjMqcaNdSGvkAuUMgthFftygD6rgVYli2/3u9cPX
   g==;
IronPort-SDR: W3EzEGxpwDK7ABQbA/0r+UAJSVBJoITx4zMa2ux0cloGB7gpl5gi2GqoU/x0FUsJhKINU5rSSH
 nqfwwlyWpTxubHKnm/yd4cDUce0WbpnaPwJIgWaN9ndpaJvAcG4IfXBQSlVrpmMHJwXXoJzhke
 sx377VzV8A2Z+PVXPbI/VXc5jBMtLaw//z/v5xJnfy2giyrYgboJdtXqFmXIxuX+CAro5Gnu31
 vZSAhJURuGiQ/EbwE/hptggeBJ3vHXHwB5sqh8aA7UDZ4h6X4tsuTc/MS2aEi70t4YLrNZl4l0
 /0g=
X-IronPort-AV: E=Sophos;i="5.81,198,1610380800"; 
   d="scan'208";a="160516159"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2021 03:29:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bv/QAjqyj2TN11NGL8cVV9f5+qmXZAkrbtEsWLs4BXXNJSdxxowwQ+fWVECCBrr3svXL/oCl3tnWWznk+SyhgYFwNCTN3dDGFV3BX9GrwUuXQ0ShUq4bZwdJLQah+gLyzHvnaxMHQM1wvea7Pd9CC+61XtQF1UxOMW19JC9POnH3xhI4UWUIrTWE15IBdz49LHQ/f3b2KWyFqvMe6/IW/TzcrYbVG7YaP8MYakIDFevzo29dCQrPgkTE6TkOaWkL6lddF99SlwgxgRgpkSBYlvHtP7LfuZB2jZeIFj06cb9TrX+hybwo1hYeyftXEplotIxhkl4qlp6e/gvXR7kXow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=js95pTMoRTGcaUj9AopgksxxksqmnVR4BNiZnQ6c2sQ=;
 b=YDDF+iprEYw/8YAtWyhkxFdFKty4c8ck5k8asy1ETFBd+wTkTyVMzZrkHAtlBUgeGIPbaLWLNbt4yhGOrAzunwCTIoixvIMXm0AqXA09HCpjT7Qe31xgtp4irxsYvYCCOWPdqcwY4I9g4YMizu8/KkmeXC1YDTlioqsA3y13k3B4dVcdwR9srjibc4eksQlwngRawLDRWQS2+DJNt5FadDJj4qn8ND/zrPtBX07nH7AbwqcoGzN4uimCob7uIL9yXvy6qMZAbtdjlAAktUp641C7kKoQClhyoA2rTfHVEe1Mt2KImezJLZujrJtW5QWOKeMIP0Ir0V1qgEBcqIs1Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=js95pTMoRTGcaUj9AopgksxxksqmnVR4BNiZnQ6c2sQ=;
 b=XykXf8+v08E1PkYnTBulBr5VbL4V384uFbUMqDuEYVTe4Pe34PZUgykYyXkPCRmB++fCuMvcj1PnTNSsWQeZvM1X67UJVWKjBJja0AuvW3+RotIlWTDfKl86kIdbZrCguVNFxPuA0/B8TnbhOuCx+HJbdk2UeOC3E5d1K8SGpX0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7132.namprd04.prod.outlook.com (2603:10b6:5:247::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.29; Mon, 22 Feb 2021 19:29:09 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.032; Mon, 22 Feb 2021
 19:29:09 +0000
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
Subject: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXCP2Y/e9Fs0BGVk+8HmhkjtrqFapkfadA
Date:   Mon, 22 Feb 2021 19:29:09 +0000
Message-ID: <DM6PR04MB657588F1C76DC0D5BFC68862FC819@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p1>
 <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
In-Reply-To: <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a6e921db-25de-4f81-8e23-08d8d768206f
x-ms-traffictypediagnostic: DM6PR04MB7132:
x-microsoft-antispam-prvs: <DM6PR04MB71322B64B80196FC10364868FC819@DM6PR04MB7132.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e92fTlGI/uI77uIR53J14hWRJP+DIhS/8bbaUpUxDkbYUp8+Ipw0lbS61kNWU5mHyiP8j5CC9tApAwUDYnARUtxE8wza+rYUYKbdf7jEfxF+3MX53XGiOk3E1bC0cwIiLPIq2Ia4n6RnwnuMP/9Gj55RnlpHTmYaGHaVL+sIf4M75UGwzpkEqvYcbBxPh2p/SRqvifiDjYmhKh8yPw0bH/hLDFtYb6IqGbYqQOyXYcgNfHYQmh1tEm1O/lc2U77HdxQsQww1iMniRa7LFj/71eU1ywlrSuGtWLlehe3Zwp4C9GEuJ/BcnQhTcyTz7h+YjKDEyWiR/9LMjiXh3RwyttOVsX4+pDtK9CESob5uj4SU8xd2vjIIAtFmhkPRk6JcnQrLY6kfkBWGD1DoUFHfzUU6Abyraqn/U+H0k/bqINMTBDq21PAhJioadvwd4CMRDUaKgJiDE8n8y7UmY2xbZM1hCdcYZ1/zZtyqXxRb73cL7M9zcrl3iwbUwzzJ/onUhYE67c4mCC/EWfpv/ZJEFoRdK66NmaBmPp9JXDuD6T7LH3aM+xmpf2ppgKo9TfyM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(6506007)(66446008)(52536014)(66556008)(71200400001)(7696005)(478600001)(186003)(64756008)(66476007)(9686003)(55016002)(26005)(8936002)(4326008)(2906002)(316002)(7416002)(8676002)(76116006)(83380400001)(921005)(54906003)(33656002)(86362001)(110136005)(66946007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bkMzOEQ4T3p4RzhhMHJKYWJGb2dFUjB5bDlhK2VQc2NiSmNNaXB5VHdKMTZK?=
 =?utf-8?B?T1ZHNGV2bjA4cUV0NHF0VjJNMVVEVEk5S01vcy9YZVU1dXU2aHg2S3JmZEJT?=
 =?utf-8?B?ME5pbDlxcGNIMXZvVTBTMkoxUWJ0SjhxSC9yYUU5SzlNL3lpM1V5YVBnQkdD?=
 =?utf-8?B?TklLS3NjTG1WQTMvN1ZkOFJkYytYNnlWUWx0ZTMzY2dXRlpTMWtuQjVsdTFy?=
 =?utf-8?B?Q2RiVlVJaS9ZT1ROL1BYdy9MYWZwNWc2aXRTcWlGbXdkaS9GZHNVK1Zta1J6?=
 =?utf-8?B?eDVtTU1CQTQwdE43VlBBZzVSVDVNNnZHRm9VOVdQTVNMR2Q5SHo2eE1MWVR0?=
 =?utf-8?B?ZW5IejVjOVZRUnc5ZTJacEZURHJoei96dGdoTDc1a1gxQ29GQWlkYkpnZjh0?=
 =?utf-8?B?SXNQODNzU0hDQmxUR2Z1MDNGQmNDcnFSdUdUMm41UnVWZHFyNHI4Y3F3cmc3?=
 =?utf-8?B?S1BSVXFxalRwOWJFcnd5L0hwSy9RMlpqSW9XRzZpVDNBb3hjMFd1K0dpdDI4?=
 =?utf-8?B?anAvR1ZpdFFSc0pmZHZuZWUrUzRCRDVzd0lzVW81YTdDai9vQnlLZkR5cDhM?=
 =?utf-8?B?S2RHaW1aMzkxQ2paTVZwMGFRL1lEVElwZ1docW8zNGsxUGlHdnlOU2tXNjNQ?=
 =?utf-8?B?YnpaTVpSdkczTjFheHBWR3NHSmJZSnZKYUFISDFxRzJ6VDVEeXRNOFdDMm1m?=
 =?utf-8?B?M1BSKzk4RG9yaFJlbnZ6WmExQnFBc1IxMmVadnloQmlBc1J3bFU3WUx0aWcz?=
 =?utf-8?B?Q2tiVHR1ektjNEl3TTFrVnBRM2JzNW4yd2ZtbUtLVmJ4N2xkWTYzcThEbVgr?=
 =?utf-8?B?NGVRWHdTQ0QvaW9wdmoxN2d6czFHVXNjUjZSdERZQWRkTk1UQklHRFFZUEF3?=
 =?utf-8?B?a3dPeGZ6aTBPZnlGL1RlK2QyMkVWcVhhRFJaV1NtTWVNaVlSSmkrL3dQbER4?=
 =?utf-8?B?SnFOV2dGWTNxYmUvRjlJUXA4VWpwN0lEZTZsQW9JZFNUVVBMbkppN25yd0pF?=
 =?utf-8?B?ZElYajdlTGk4VThscGJCWlhFWUFFRm1zMVhLY05lRjduN1ZvVjhZbW4zM1FL?=
 =?utf-8?B?cnhiM3JXQUM0SSs4MU04d2hsenprOTMvSDVkc0ZpOWxSY05YWGJ5dkhtVlZO?=
 =?utf-8?B?UTljS3pPMVh4M1p0MkRJMU42ZlZ6YmRMM0hJOFNsaFVDa3hLS2NlMFNPWGxP?=
 =?utf-8?B?U3R1ZDF1Y0V0d2ZuTnM5MCs5bzF2SkFGd25GbmhTbUVpbzQvMjZVRnU4aDNj?=
 =?utf-8?B?a21BT1IxeHRQbDZxRWVGTDVGY0tqQW9UblZ2bHNiN3lpZSsyTlA0clk5bnpu?=
 =?utf-8?B?VWt4VGhKclNnbEdqZ3ZqTldHeVBRcXloRGc2VVpjYVBGME9GWjdwY3VlVU1u?=
 =?utf-8?B?Wi9kQkFOa3NVdmN4TTZtckpUVGtlVGFldjVaaU9sYmJWZTNSWTI3NUJ2eG9Q?=
 =?utf-8?B?a2YyOW15d1V6UVJVNWZBbEM2UnVINnhtZ1doMjVReTNrRDZaRGgwT1I3ei92?=
 =?utf-8?B?KzlNSzJaTWRhQUc3aUlONkpnZ2dnNG1ManUycVM1RW9NY3NBbDIxQ0NUR005?=
 =?utf-8?B?ay9qWE93dHV5N3E3ZkVsV2FQUUYvMVlaSndWUDlvVGVGbHpKN04xYktIcnpm?=
 =?utf-8?B?TTl6cW4yTlZiY2V2ZThmSXJyUW45MWtOTjhQZFpGbHN5aU85MSttWHBKYzB4?=
 =?utf-8?B?TmlXU0Zub2tFeW9vL0IwV2ZzNlEwQUJTZHc1amFDVmI3dnhBQ2RLejNEVmJN?=
 =?utf-8?Q?3g6brYmJyga6plmHtyZ3kqws5s5TjTa1N1FYnWU?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e921db-25de-4f81-8e23-08d8d768206f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2021 19:29:09.2691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FzJo4zaNj5Frljl9fSVeNIVW5f98W0YMwRAcAktn9Vu6oP5/JBpu76wK+niSImFBKpgwzbkzl7Q/BTfa0pKpEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+IEBAIC03NDQ3LDggKzc0NTIsMTQgQEAgc3RhdGljIGludCB1ZnNfZ2V0X2RldmljZV9kZXNj
KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+IA0KPiAgICAgICAgIGlmIChkZXZfaW5mby0+d3NwZWN2
ZXJzaW9uID49IFVGU19ERVZfSFBCX1NVUFBPUlRfVkVSU0lPTiAmJg0KPiAgICAgICAgICAgICAo
Yl91ZnNfZmVhdHVyZV9zdXAgJiBVRlNfREVWX0hQQl9TVVBQT1JUKSkgew0KPiAtICAgICAgICAg
ICAgICAgZGV2X2luZm8tPmhwYl9lbmFibGVkID0gdHJ1ZTsNCj4gLSAgICAgICAgICAgICAgIHVm
c2hwYl9nZXRfZGV2X2luZm8oaGJhLCBkZXNjX2J1Zik7DQo+ICsgICAgICAgICAgICAgICBib29s
IGhwYl9lbiA9IGZhbHNlOw0KPiArDQo+ICsgICAgICAgICAgICAgICBlcnIgPSB1ZnNoY2RfcXVl
cnlfZmxhZ19yZXRyeShoYmEsDQo+IFVQSVVfUVVFUllfT1BDT0RFX1JFQURfRkxBRywNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFFVRVJZX0ZMQUdfSURO
X0hQQl9FTiwgMCwgJmhwYl9lbik7DQo+ICsgICAgICAgICAgICAgICBpZiAoIWVyciAmJiBocGJf
ZW4pIHsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgZGV2X2luZm8tPmhwYl9lbmFibGVkID0g
dHJ1ZTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgdWZzaHBiX2dldF9kZXZfaW5mbyhoYmEs
IGRlc2NfYnVmKTsNClFVRVJZX0ZMQUdfSUROX0hQQl9FTiBvbmx5IGFwcGx5IHRvIEhQQjIuMA0K
DQo+ICsgICAgICAgICAgICAgICB9DQo+ICAgICAgICAgfQ0KPiANCj4gKw0KPiArLyoNCj4gKyAq
IFdSSVRFX0JVRkZFUiBDTUQgc3VwcG9ydCAzNksgKGxlbj05KSB+IDUxMksgKGxlbj0xMjgpIGRl
ZmF1bHQuDQo+ICsgKiBpdCBpcyBwb3NzaWJsZSB0byBjaGFuZ2UgcmFuZ2Ugb2YgdHJhbnNmZXJf
bGVuIHRocm91Z2ggc3lzZnMuDQo+ICsgKi8NCkFjdHVhbGx5IHRoZSB0cmFuc2ZlciBsZW5ndGgg
aXMgbGltaXRlZCBieSBpdHMgKGFuZCByZWFkIGlkKSBzaW5nbGUgYnl0ZS4NCkZpeGluZyBNQVhf
SFBCX1JFQURfSUQgPSAxMjggIGlzIElNTyBhIHJlYXNvbmFibGUgY2hvaWNlLA0KQnV0IG5vdCBs
aW1pdGVkIGJ5IHNwZWMuICBNYXliZSBtYWtlIG5vdGUgb2YgdGhhdCA/DQoNCj4gK3N0YXRpYyBp
bmxpbmUgYm9vbCB1ZnNocGJfaXNfcmVxdWlyZWRfd2Ioc3RydWN0IHVmc2hwYl9sdSAqaHBiLCBp
bnQgbGVuKQ0KPiArew0KPiArICAgICAgIHJldHVybiAobGVuID49IGhwYi0+cHJlX3JlcV9taW5f
dHJfbGVuICYmDQo+ICsgICAgICAgICAgICAgICBsZW4gPD0gaHBiLT5wcmVfcmVxX21heF90cl9s
ZW4pOw0KPiAgfQ0KTWF5YmUgYWxzbyBjaGVjayBIUEIyLjAgYXMgd2VsbD8NCg0KPiAtdm9pZCB1
ZnNocGJfcHJlcChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBzdHJ1Y3QgdWZzaGNkX2xyYiAqbHJicCkN
Cj4gK2ludCB1ZnNocGJfcHJlcChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBzdHJ1Y3QgdWZzaGNkX2xy
YiAqbHJicCkNCj4gIHsNCj4gICAgICAgICBzdHJ1Y3QgdWZzaHBiX2x1ICpocGI7DQo+ICAgICAg
ICAgc3RydWN0IHVmc2hwYl9yZWdpb24gKnJnbjsNCj4gQEAgLTI4MiwyNiArNTQ2LDI3IEBAIHZv
aWQgdWZzaHBiX3ByZXAoc3RydWN0IHVmc19oYmEgKmhiYSwgc3RydWN0DQo+IHVmc2hjZF9scmIg
KmxyYnApDQo+ICAgICAgICAgdTY0IHBwbjsNCj4gICAgICAgICB1bnNpZ25lZCBsb25nIGZsYWdz
Ow0KPiAgICAgICAgIGludCB0cmFuc2Zlcl9sZW4sIHJnbl9pZHgsIHNyZ25faWR4LCBzcmduX29m
ZnNldDsNCj4gKyAgICAgICBpbnQgcmVhZF9pZCA9IE1BWF9IUEJfUkVBRF9JRDsNClNob3VsZCBi
ZSAwIGlmIHdiIGlzIG5vdCB1c2VkPw0KDQo+ICsNCj4gKyAgICAgICBocGItPnByZV9yZXEgPSBr
Y2FsbG9jKHFkLCBzaXplb2Yoc3RydWN0IHVmc2hwYl9yZXEpLCBHRlBfS0VSTkVMKTsNCj4gKyAg
ICAgICBocGItPnRocm90dGxlX3ByZV9yZXEgPSBxZDsNCldoYXQgaXMgdGhlIHBvaW50IGluIHRo
cm90dGxpbmcgaWYgeW91IGFyZSBhbGxvd2luZyAzMiBzaW11bHRhbmVvdXMgY29tbWFuZHM/DQpU
aGVyZSBjYW4ndCBiZSBtb3JlIHRoYW4gcWQvMiBhbnl3YXk/DQpPbiB0aGUgY29udHJhcnksIGl0
IG1ha2VzIG11Y2ggbW9yZSBzZW5zZSB0byBjb250cm9sIHRoZSBpbmZsaWdodCBtYXAgcmVxdWVz
dHMsIGluc3RlYWQ/DQoNCj4gKyAgICAgICBocGItPm51bV9pbmZsaWdodF9wcmVfcmVxID0gMDsN
Cj4gKw0KDQo+IC0jZGVmaW5lIEhQQl9TVVBQT1JUX1ZFUlNJT04gICAgICAgICAgICAgICAgICAg
IDB4MTAwDQo+ICsjZGVmaW5lIEhQQl9TVVBQT1JUX1ZFUlNJT04gICAgICAgICAgICAgICAgICAg
IDB4MjAwDQpJbiB1ZnNocGJfZ2V0X2Rldl9pbmZvIHlvdSBhcmUgYmFpbGluZyBvdXQgaWYgdmVy
c2lvbiAhPSBIUEJfU1VQUE9SVF9WRVJTSU9ODQpNZWFuaW5nIHlvdSBhcmUgbm8gbG9uZ2VyIGJh
Y2t3YXJkIHN1cHBvcnRpbmcgSFBCMS4wPw0KDQpNYXliZSBpdCB3b3VsZCBiZSBtb3JlIGNvbnN0
cnVjdGl2ZSB0byBhbGxvdyBhIGRheSBvciAyIGZvciBtb3JlIHBlb3BsZSB0byBjb21tZW50IHRo
aXMgbmV3IHBhdGNoPw0KQWZ0ZXIgYWxsLCBpdCBpcyBhIGxvdCBvZiBjb2RlLg0KDQpUaGFua3Ms
DQpBdnJpDQo=
