Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1FEC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 06:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhKXGIs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 01:08:48 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34216 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232079AbhKXGIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Nov 2021 01:08:47 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1ANNFqat015583;
        Tue, 23 Nov 2021 22:05:32 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ch9tr1b41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 22:05:32 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 1AO5tgem013257;
        Tue, 23 Nov 2021 22:05:32 -0800
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ch9tr1b40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 22:05:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUa7qileoAlKm92NdGuOitHVe18I6hxs7uY/iiPxLbXCNu8iktFAxvGYM/UoIvHTmU7FU7PbmOKxmK89mabop9uztxG17aYh+7CFICYyDFYR0hz9PKUlFBvyLO3Hw/hzeuqhdMq1LBbDZOUWA8K8Fqp7fNCjahE9Uz4l4lFQPzBIhT2IZu52NOONMMMSXS5FFXgecHPAGpe2CAZkQgM+r+4Hru8U2ECHQUMOC9QS+HWjpZudC7+ZwKmSHe3uuCnnCNvq/evGiLNICFU/F+nacuEXpDqzEcH+0qp21SyyJpOI8H140LKFLlKujvD31/mMzpdCvfDm60qz3Amq7nKJRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ObHe0ZuYDrOgizmCRapgM4kkOI4btS+bfYxfVv/S/us=;
 b=hbc0UHKGnc7kUlus0HP+7hIfhI1KmAPnTIExQqESN8WFzMfxwahsPYGrY7Iq59cGyuKRiv/t9TolB6KaUnvvY0h3qRkw9FCXgE6ewhVRrk6hcYUhcYiFTiKuJtOFAvpMJ3p61JEeksFIuBlMjyMcsEXB5rYGTceVMTIO5PFiY+W5sFSi/OMwjzk1nF71G/L52j8usW9ZBx4m8zMEXMQRH3VegKpgTWLM8XTc5HACAtBEvge5zBaOj9n4i/CRnBek4MSXOnbgRgZhsBVrHbRd7TKoKbFSG29gQoWautqLIFW4XmMNhB4otWyxuI230Z5mfYvhbpkhmCI5gXrHNaAsCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObHe0ZuYDrOgizmCRapgM4kkOI4btS+bfYxfVv/S/us=;
 b=Pf3AAFwp0g552NUVNUvA/2TS/Ha0zGVhOYJNWCdBjPxAYnzmQG49jJomu2BHXk76aF6zXkfNBdimlB/lGNOtiqZGczLTp+DdsxVfwAb5SjSzOt3n4HX+Pnyuj89/Q2nfSKi+npLusAYTunEns3CIYiD+DCzY0uCPFDnAiTa2g2Y=
Received: from PH0PR18MB4425.namprd18.prod.outlook.com (2603:10b6:510:ef::13)
 by PH0PR18MB4970.namprd18.prod.outlook.com (2603:10b6:510:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 06:05:29 +0000
Received: from PH0PR18MB4425.namprd18.prod.outlook.com
 ([fe80::5c78:e692:5a86:19e8]) by PH0PR18MB4425.namprd18.prod.outlook.com
 ([fe80::5c78:e692:5a86:19e8%9]) with mapi id 15.20.4713.026; Wed, 24 Nov 2021
 06:05:29 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH] qedi: Fix cmd_cleanup_cmpl counter mismatch
 issue.
Thread-Topic: [EXT] Re: [PATCH] qedi: Fix cmd_cleanup_cmpl counter mismatch
 issue.
Thread-Index: AQHX4GS1GaPhotEvvk2Hz/zH/Da7RqwRnfgAgACQJTA=
Date:   Wed, 24 Nov 2021 06:05:28 +0000
Message-ID: <PH0PR18MB4425F4F08057B89453C2222ED8619@PH0PR18MB4425.namprd18.prod.outlook.com>
References: <20211123122115.8599-1-mrangankar@marvell.com>
 <9c21c019-d6ff-a908-80e5-51b9c765d118@oracle.com>
In-Reply-To: <9c21c019-d6ff-a908-80e5-51b9c765d118@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a85ba823-13ac-4fac-b6a9-08d9af106a78
x-ms-traffictypediagnostic: PH0PR18MB4970:
x-microsoft-antispam-prvs: <PH0PR18MB49707B7ACFD004C2715182B3D8619@PH0PR18MB4970.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nZQ58OfKiYaT+p+w/9eQQKEPjBnuS/MfQDjMQq2HGAP/2EXyqt4xiX5IfrpaOr0P1spHTiN2+NoEuPawWaM+Vd7FJO98qGi8sy0BfubrwLiWzOm21proV3FL9AIBqH1+5gKOc1B9eJsbQCZYZjr6XL+HC/4UC9F9gkBq4TnjIRGHlg2UYX7NJzQplbWF53fZp9CYYens4uwpt2TbO+CQlp1uraHnvJnBVNaB/AXvsMwi62PJN6XIHUDcRZ7PHstVI2U564dYTd4nKqjSXQV1ab4IJ+9PzXhLcjiC8VodqjuprJVWyjv3T8Pq9GAGPNMiwR3/FXqnh8arqEJtA2vFprhi8je7QOX8ClXNIc9vieTYwVG8eMEg0i/sysST2J44lvjKuRRFQFS82+F1xaXJmuR1bwCHgrlBcGsy8ZoRQ/IITVIT9ZAMjNYeX/4xi8ikqKnOJxJOiuyg1/lTBFGTuIvftZGE/9fhNbGkR6OEpJqIYtnIvfFaDq44aht93L+HlkQc2x3rUpNFT10G4sfsAC1ZMyOlf8uvNIsQT8iLPalHCwG01AD8L2Jg1Ga8gQJiwyZgFFjcAm3fQku0SE+7lVrHrNitQWOhLeOEXIwl0nYfKI8kuKwIpeEU6YaYsx5reATE3K0qtP4FPaFqmWS2TeOaZNXXJQIQz2NaPIeaRbmtHKNstY59oR8ZSrTatIo2dTHowRz6rH3Fi6G3z/dXnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4425.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(122000001)(71200400001)(66556008)(66446008)(38070700005)(186003)(66476007)(64756008)(8936002)(55236004)(26005)(66946007)(86362001)(7696005)(5660300002)(38100700002)(33656002)(52536014)(83380400001)(76116006)(2906002)(110136005)(54906003)(4326008)(55016003)(107886003)(8676002)(508600001)(6506007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1BncjhOR0c1UlgyMlM0eFhKNHJ4WG01NXpaNkFpQXBZakZ5b0lza1QvZy9F?=
 =?utf-8?B?WEZMM3hDZmFla2lrR20rT05BRWRtaHIyMWtDZmxpcVhyN1E1WnZ2a1lXL1NL?=
 =?utf-8?B?MTZoNVR5dEdrM2JoNVlaQTh4dHU4dkVTTE9wdzVxTVZadzQzb1Jxb2tOd21E?=
 =?utf-8?B?SUlPL1VzRGhvSXAxd2JmYm52a29GL3JtM09LejNNcldwTTJ1YUpNZHR1Wmw3?=
 =?utf-8?B?Y1hvK0phY1FOblR5MjVIajBiRG0wTjBlVzN1aXM5VTI1MUl2Q2hrYmFVZERR?=
 =?utf-8?B?NS90bmlZTWM2VmJzTzc5VXErcmx5ZW9tUkFDSzB1ZGx2WkZLcUlGNkUzQjBC?=
 =?utf-8?B?RVFqN01COXFNVHBRYnB0aEJYdFFpeGkyRjg4dkFTNm43YmZJeGJEcWhUTkhz?=
 =?utf-8?B?RkU3Mk1hZ1VmdWNvT1M0dGc5WWNMbVpTaXR0UVdvQnlEY3d4RHNZRVJqKzdL?=
 =?utf-8?B?QUFnYkFnVXlWOTJzSzJNY2c2enpPMzBJWEZ6WFg2SGw0dUU0QXlFVVFzdkZ6?=
 =?utf-8?B?Tkk0dGxRdFVhcTM1eDVWVzZqY1p3dW10c3R0TTdLVzIyeEpxNndCMmJSU25s?=
 =?utf-8?B?TGlsS0tXS3JBTURjdTdMTmxteENkb1FmWk9RU2dJS01zdjM3UDRVZTdHZ0NF?=
 =?utf-8?B?S0FKSlg1SUY0SEx3bVFXdEwwZEU3dmRIRUcvc08rWjM4ZVpoL05YQzZab3ph?=
 =?utf-8?B?QmZERlQ3SFFNMmFaMUttbjFwbDlKclFCbE1rOVo1QlduV3hBK3IxQ1JHWG9i?=
 =?utf-8?B?TlUrbzlUUndPYVpZdlZCUGdVbktjWjdmU3FzdVFQdzliTHFmaWJ5NVhhMlk5?=
 =?utf-8?B?ZHJaTHR0d1V5aExYYWgrY1hzNmNuVVQxMC8waDVvU21jNlJGTE5ZTkkwaFha?=
 =?utf-8?B?NTRPMUxQT1Z6ZUNIaVAra3J5SkR2MGFuc2phTGtLSlpnMFdxaWk1cHRlZy8w?=
 =?utf-8?B?NGFXWmxmYWFqQXVSbTFnMGZIVFRHcDRaVDI3MDA4NkwyTERNaUZGV3lWd2sr?=
 =?utf-8?B?UVJ0VVhFZ1VzU1JOcnJycFR1VFZjZ0NKNU9hbXA4ZXJONW1peFVYdEg4SVVu?=
 =?utf-8?B?Si9lZ2hDVHU5RlpmL1ZnRmZ6VGx6a2UxeEt1SkhVc3BzeTAzTG9tK1dlSmhO?=
 =?utf-8?B?ZUlGSUNhb0IydUpTTGxERmdIRzVtbHhsYjQ2U1gzUlRTV0VzZFJoa1JVUGdU?=
 =?utf-8?B?MjR5TWc4cGlMcTdmQk16YStZSVRRL2xNd2tLYmVsYkxURlowVUJsdkMvMys0?=
 =?utf-8?B?T2l4Uk9tT3RrR2hXdXYvQTdnK3Y3SjRieENGVHczY0xZWDNDM2xCZmgyOXNB?=
 =?utf-8?B?bm1ENHFDYnoyTnUzL05mNVNKV0tzQ1E2a05xbEovdUhLSWJDSldRTEt4T0Jk?=
 =?utf-8?B?MDR4MkpEd2xwN01YRUpVTlZoVGlWNUhydWRQbUZPWlFtcmdBUGhCeFg5dkRE?=
 =?utf-8?B?alBTbTBwaUdWZmcyZ2k1eGdIcDRzc3ZIUHRlNFJ1aUowNDVFakVld3JKTDJl?=
 =?utf-8?B?OFE2UUZRanl1TWtyNk0vT0IxOGR2dE9WdjF3alJWQjJkRFhPU2N3M1pSanph?=
 =?utf-8?B?S3JJVXFjTHpua0lMTzgwQzE0NTF1ZEdaZ1NzaXNTRFJpdmxzTFpaY3A1UW5u?=
 =?utf-8?B?QWEyb0svUTZsTmd3VGNGTXA3UkF0OWNxODVWQ2ZQQnk5UEtROXZNdTcydzRW?=
 =?utf-8?B?NXkrVVpTWjhXSlNxSTVTaXN6RDIzVHEwemRLUXdmVUdIeXFvY0ZZQ3Q3c3pj?=
 =?utf-8?B?c2owT1BLLzJIUjEzdUt3aTRDL2hmMStSYWRHTy9xdDlYU3lrL2g1Tkc1ZnBp?=
 =?utf-8?B?bk05T3J1SEIzYU1ISllwRVVTLzBnbzQ1UVpWOE1zYkFkWXZHRU9lOXFOQUpl?=
 =?utf-8?B?Q0tKeTByVmtrZ0FkZytjQ0VwVVNKTEJ1TG9sQlNsdDJmK1pKUk55a1FNN3FP?=
 =?utf-8?B?MXJKblBXNDlXZUUrTjhSWnUyMXdiTzB1eVlMaHgwZjMxZlZtdFkzb0xPSUtR?=
 =?utf-8?B?MmRxNUg4NVNRcnNKc1FNaDFHS1JuWFF1VDdCWUEvUkt6dGR4M3QwWHA3b2dj?=
 =?utf-8?B?bVNMTTUrdk8wc2I1NVZkR1V3Y1Z4YjNmaVk5dXJZUVloWFhDcFlyWHo1YnFN?=
 =?utf-8?B?bE9mTmJyV2lWK1A4b0YxZUpiQzg2L0k5b1hmanZCb3VQNk15VE9JMTVDbXBB?=
 =?utf-8?B?cnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4425.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a85ba823-13ac-4fac-b6a9-08d9af106a78
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 06:05:28.8088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aykgs+qB1PVMLZJpH6VwmuKLHw/5g5BFQQBcu2BANtrnGsQGIobf/YMTFUSstvzW/W8qCgfoF1jYmUSfQpB3bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4970
X-Proofpoint-ORIG-GUID: GGbju-aKU-_12905j5PjUdVnm_rUTEOy
X-Proofpoint-GUID: XNmel8IsGpXhkhiPYXUxP-RLP-xUfPu5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-24_02,2021-11-23_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+DQo+ID4gIGNoZWNrX2NsZWFudXBfcmVxczoNCj4gPiAgCWlmIChxZWRpX2Nvbm4tPmNtZF9j
bGVhbnVwX3JlcSA+IDApIHsNCj4gPiAtCQlRRURJX0lORk8oJnFlZGktPmRiZ19jdHgsIFFFRElf
TE9HX1RJRCwNCj4gPiAtCQkJICAiRnJlZWluZyB0aWQ9MHgleCBmb3IgY2lkPTB4JXhcbiIsDQo+
ID4gLQkJCSAgY3FlLT5pdGlkLCBxZWRpX2Nvbm4tPmlzY3NpX2Nvbm5faWQpOw0KPiA+IC0JCXFl
ZGlfY29ubi0+Y21kX2NsZWFudXBfY21wbCsrOw0KPiA+ICsJCSsrcWVkaV9jb25uLT5jbWRfY2xl
YW51cF9jbXBsOw0KPiA+ICsJCVFFRElfSU5GTygmcWVkaS0+ZGJnX2N0eCwgUUVESV9MT0dfU0NT
SV9UTSwNCj4gPiArCQkJICAiRnJlZWluZyB0aWQ9MHgleCBmb3IgY2lkPTB4JXggY2xlYW51cCBj
b3VudD0lZFxuIiwNCj4gPiArCQkJICBjcWUtPml0aWQsIHFlZGlfY29ubi0+aXNjc2lfY29ubl9p
ZCwNCj4gPiArCQkJICBxZWRpX2Nvbm4tPmNtZF9jbGVhbnVwX2NtcGwpOw0KPiANCj4gSXMgdGhl
IGlzc3VlIHRoYXQgY21kX2NsZWFudXBfY21wbCdzIGluY3JlbWVudCBpcyBub3Qgc2VlbiBieQ0K
PiBxZWRpX2NsZWFudXBfYWxsX2lvJ3Mgd2FpdF9ldmVudF9pbnRlcnJ1cHRpYmxlX3RpbWVvdXQg
Y2FsbCB3aGVuIGl0IHdha2VzIHVwLA0KPiBhbmQgeW91ciBwYXRjaCBmaXhlcyB0aGlzIGJ5IGRv
aW5nIGEgcHJlIGluY3JlbWVudD8NCj4gDQoNClllcywgY21kX2NsZWFudXBfY21wbCdzIGluY3Jl
bWVudCBpcyBub3Qgc2VlbiBieSBxZWRpX2NsZWFudXBfYWxsX2lvJ3MgDQp3YWl0X2V2ZW50X2lu
dGVycnVwdGlibGVfdGltZW91dCBjYWxsIHdoZW4gaXQgd2FrZXMgdXAsIGV2ZW4gYWZ0ZXIgZmly
bXdhcmUgDQpwb3N0IGFsbCB0aGUgSVNDU0lfQ1FFX1RZUEVfVEFTS19DTEVBTlVQIGV2ZW50cyBm
b3IgcmVxdWVzdGVkIGNtZF9jbGVhbnVwX3JlcS4NClllcywgcHJlIGluY3JlbWVudCBkaWQgYWRk
cmVzc2VkIHRoaXMgaXNzdWUuIERvIHlvdSBmZWVsIG90aGVyd2lzZSA/DQoNCj4gRG9lcyBkb2lu
ZyBhIHByZSBpbmNyZW1lbnQgZ2l2ZSB5b3UgYmFycmllciBsaWtlIGJlaGF2aW9yIGFuZCBpcyB0
aGF0IHdoeSB0aGlzDQo+IHdvcmtzPyBJIHRob3VnaHQgaWYgd2FrZV91cCBlbmRzIHVwIHdha2lu
ZyB1cCB0aGUgb3RoZXIgdGhyZWFkIGl0IGRvZXMgYSBiYXJyaWVyDQo+IGFscmVhZHksIHNvIGl0
J3Mgbm90IGNsZWFyIHRvIG1lIGhvdyBjaGFuZ2luZyB0byBhIHByZS1pbmNyZW1lbnQgaGVscHMu
DQo+IA0KPiBJcyBkb2luZyBhIHByZS1pbmNyZW1lbnQgYSBjb21tb24gd2F5IHRvIGhhbmRsZSB0
aGlzPyBJdCBsb29rcyBsaWtlIHdlIGRvIGENCj4gcG9zdCBpbmNyZW1lbnQgYW5kIHdha2VfdXAq
IGluIG90aGVyIHBsYWNlcy4gSG93ZXZlciwgbGlrZSBpbiB0aGUgc2NzaSBsYXllciB3ZQ0KPiBk
byB3YWtlX3VwX3Byb2Nlc3MgYW5kIG1lbW9yeS1iYXJyaWVycy50eHQgc2F5cyB0aGF0IGFsd2F5
cyBkb2VzIGEgZ2VuZXJhbA0KPiBiYXJyaWVyLCBzbyBpcyB0aGF0IHdoeSB3ZSBjYW4gZG8gYSBw
b3N0IGluY3JlbWVudCB0aGVyZT8NCj4gDQo+IERvZXMgcHJlLWluY3JlbWVudCBnaXZlIHlvdSBi
YXJyaWVyIGxpa2UgYmVoYXZpb3IsIGFuZCBpcyB0aGUgd2FrZV91cCBjYWxsIG5vdA0KPiB3YWtp
bmcgdXAgdGhlIHByb2Nlc3Mgc28gd2UgZGlkbid0IGdldCBhIGJhcnJpZXIgZnJvbSB0aGF0LCBh
bmQgc28gdGhhdCdzIHdoeSB0aGlzDQo+IHdvcmtzPw0KPiANCg0KSXNzdWUgaGFwcGVuIGJlZm9y
ZSBjYWxsaW5nIHdha2VfdXAuIFdoZW4gd2UgZ2V0cyBhIElTQ1NJX0NRRV9UWVBFX1RBU0tfQ0xF
QU5VUCBzdXJnZSBvbg0KbXVsdGlwbGUgUnggdGhyZWFkcywgY21kX2NsZWFudXBfY21wbCB0ZW5k
IHRvIG1pc3MgdGhlIGluY3JlbWVudC4gVGhlIHNjZW5hcmlvIGlzIG1vcmUgc2ltaWxhciB0bw0K
bXVsdGlwbGUgdGhyZWFkcyBhY2Nlc3MgY21kX2NsZWFudXBfY21wbCBjYXVzaW5nIHJhY2UgZHVy
aW5nIHBvc3RmaXggaW5jcmVtZW50LiBUaGlzIGNvdWxkIGJlIGJlY2F1c2Ugb2YgDQp0aHJlYWQg
cmVhZGluZyB0aGUgc2FtZSB2YWx1ZSBhdCBhIHRpbWUuDQoNCk5vdyB0aGF0IEkgYW0gZXhwbGFp
bmluZyBpdCwgaXQgZmVsdCBpbnN0ZWFkIG9mIHByZS1pbmNyZW1lbnRpbmcgY21kX2NsZWFudXBf
Y21wbCwgDQppdCBzaG91bGQgYmUgYXRvbWljIHZhcmlhYmxlLiBEbyBzZWUgYW55IGlzc3VlID8g
DQoNCkZyb20gbG9ncywNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCltyb290QHJoZWw4Mi1sZW8gUkhFTDkwX0xPR1NdIyBncmVwIC1pbnIg
InFlZGlfaXNjc2lfY2xlYW51cF90YXNrOjIxNjAiIGNvbm5fZXJyLmxvZyB8IHdjIC1sDQo5OQ0K
DQpbcm9vdEByaGVsODItbGVvIFJIRUw5MF9MT0dTXSMgZ3JlcCAtaW5yICJxZWRpX2NsZWFudXBf
YWxsX2lvOjEyMTUiIGNvbm5fZXJyLmxvZyB8IHdjIC1sDQo5OQ0KDQpbcm9vdEByaGVsODItbGVv
IFJIRUw5MF9MT0dTXSMgZ3JlcCAtaW5yICJxZWRpX2ZwX3Byb2Nlc3NfY3Flczo5MjUiIGNvbm5f
ZXJyLmxvZyB8IHdjIC1sDQo5OQ0KDQpbcm9vdEByaGVsODItbGVvIFJIRUw5MF9MT0dTXSMgZ3Jl
cCAtaW5yICJxZWRpX2ZwX3Byb2Nlc3NfY3Flczo5MjIiIGNvbm5fZXJyLmxvZyB8IHdjIC1sDQo5
OQ0KDQpbVGh1IE9jdCAyMSAyMjowMzozMiAyMDIxXSBbMDAwMDphNTowMC41XTpbcWVkaV9jbGVh
bnVwX2FsbF9pbzoxMjQ2XToxODogaS9vIGNtZF9jbGVhbnVwX3JlcT05OSwgbm90IGVxdWFsIHRv
IGNtZF9jbGVhbnVwX2NtcGw9OTcsIGNpZD0weDAgICA8PDwNCltUaHUgT2N0IDIxIDIyOjAzOjM4
IDIwMjFdIFswMDAwOmE1OjAwLjVdOltxZWRpX2NsZWFyc3E6MTI5OV06MTg6IGZhdGFsIGVycm9y
LCBuZWVkIGhhcmQgcmVzZXQsIGNpZD0weDANCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo=
