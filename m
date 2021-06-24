Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4D4C48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 04:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2B35613CC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 04:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbhFXEFu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 00:05:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35260 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhFXEFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 00:05:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O3oIvb021846
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 21:02:22 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 39cg2n8grv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 21:02:22 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15O42Lag004887
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 21:02:21 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by mx0b-0016f401.pphosted.com with ESMTP id 39cg2n8grs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 21:02:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfqDhIOdADL++NLbGHofq+Nt6do2DYTvG6OXr3CIK8qbsr+bOXzX93vsBXV+hO4zB2T5GgXlYsKWBsedWIT4/TOIATs6EIw40tZSdQK/IzCSww9Bl43mXdeF5sMU6SpBfix9bLuiAneyR9Apq8QmFHF2GxzaHxvlmGaTojGkawvEtBFjMufY/iFDLKYWxu1MLXPMehG7EMzdjobBjv1ZgABrlRhiFPWd3X/YNNgRnk/q8tBK1OkCSNe7jFk03XLXxc/SeuJ2WfvaIH+6NN4O111V1rV9Zs1F4Ae9xg2SOCzFDHZQQ4hr0TYkzhMBNiAr6QCxkYOYMEPt+LrR+wgmcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZ19cij7x1Lbde0ozvaWL3SFyprYLhpsgEbosZf6Xy0=;
 b=GcBZWXb4Aoq3egXud02ZeCfJltczPvxNNixoY0MfyXKAY+N0Iy2ConCvqtii59Qi8wb+sR/wJVW8OAxHPMFLyZ1FkjJ1IAiouCOPR2wdUtKgOTICM6IBGH+7dA0skJhVJQA6K5JLKvzvGgUsjSeztUzvkknO4vDPdiz6ZUXrFWX9+lKk+68jNk6plm6pqptcS94/sWGTuFm0jbmayAUoTA50mTCkn8wm4bw4ZC9gQ0OKqZV0bhxDx0wWP82Ou6nQH5r8B4JREbgVpVLVW/D13Ehf6egGis08s1/gjQxvqKsIJKeQ4U/JmKWg/jxeoybR8wf4pXZNC/OAVdmNyG2jlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZ19cij7x1Lbde0ozvaWL3SFyprYLhpsgEbosZf6Xy0=;
 b=Zf+RxYDurL0XteRqEc2wF7koUZMh74MoxqIADm6rKMC6EJsMMKIkdONC8uLxQuiY/obZuYExiYpXRZIGWpFppFMdFXKcRqWCIIBCnxbIk3zGPWgTDX7u0dPc97ExB98vGd98ZfLYUEwDmpG/mu2jXkLXQz1WCR4mL21Jw7WZ2a0=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by CO1PR18MB4730.namprd18.prod.outlook.com (2603:10b6:303:e9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Thu, 24 Jun
 2021 04:02:18 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::292c:463a:b28d:cb02]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::292c:463a:b28d:cb02%9]) with mapi id 15.20.4264.018; Thu, 24 Jun 2021
 04:02:18 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH v3 10/11] qla2xxx: enable heartbeat validation
 for edif command
Thread-Topic: [EXT] Re: [PATCH v3 10/11] qla2xxx: enable heartbeat validation
 for edif command
Thread-Index: AQHXaBrTDMDLIoXaOEaBJWGVAvkVdqsh8CuAgACZnvA=
Date:   Thu, 24 Jun 2021 04:02:18 +0000
Message-ID: <CO6PR18MB45009B91FA30BDE67A994F9BAF079@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20210623102611.3637-1-njavali@marvell.com>
 <20210623102611.3637-11-njavali@marvell.com>
 <9862c087-71b1-92e2-677a-a74330212de4@oracle.com>
In-Reply-To: <9862c087-71b1-92e2-677a-a74330212de4@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.150.138.159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5d1ef65-384c-4f23-04d9-08d936c4dc67
x-ms-traffictypediagnostic: CO1PR18MB4730:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR18MB4730A6CABD0EF24C0A63076AAF079@CO1PR18MB4730.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tGwnyM17QZTWo9Y8u6Co6tuvX1Phl4oAtVTDJtCEJ7i4q9soPH2NhXc1EYohCxu92vt+Yklqa8Jk7nkW9uHrWeL6oLXu3kr22ZovBrjAeKFxTmHa27ukMABNNchlTzQXKqE31nxksyzfJEmxZxD2ZL6ChTMUbqjbtjb/rqZiZhAn550O5sSPqX2CI81O4WazuLU8GnbkEno7QpZaZV7CwsunOoeGIMvdqR4k81wc68Vanr0x+zSGgEnC7lBGjgC7gORzkKfutvT3TH/CsyNQCgFa6HUersIb+hCUdgNWKeG0zaaGCSeaaZJ+p+uuVavlklAscB0pF+fowSBj2RUHRBCfpdMLe0B5Fh0PqzcA49mL2rpvwJkUBIgGjNi+HjvI0x2CViVaw9bf9y0rk4rsitGECZbDujBSUOzHi/NKw78EWSMbYqvLcnI6KlTjrF/syS4sYBavmbMRIQxb7OwzJZBwcJKZSiq37wdKH9E6WQq2+8YmRafZouKt91qJhz+fYZZJ/bxj4R/Nm7ckikNOuzdtGwUpAz3c8VRZTles0/wSJalRWdE+cCUsdxkDU/RIV9diRO11PEHY19VX0C7AF95hOAWVibVZrBmv+BOZJU0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(99936003)(71200400001)(83380400001)(2906002)(76116006)(66446008)(64756008)(66556008)(66476007)(66616009)(33656002)(86362001)(66946007)(52536014)(55016002)(7696005)(53546011)(107886003)(9686003)(110136005)(316002)(8676002)(8936002)(54906003)(5660300002)(4326008)(186003)(26005)(38100700002)(122000001)(6506007)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MENLcjVTbWNhNkFnQm10QVFwRUJvMldsaTMzRlBKanhsOWZpSU9TaGtwZzdJ?=
 =?utf-8?B?cHphaGIvSHZCQ29KRTdxblhsdTFhOHYxSGg5aTViVkxlRFpJd0ZkdjY4YzhE?=
 =?utf-8?B?R0RzQk1sNjRkaGNQQWRGZC95SGVKVzZ4VU8rV3NZdmRaSnZQYnovUmJ3Tnlr?=
 =?utf-8?B?VmxPYmZ3bHZKYXFKNDcvbXE2RVAzOXByQUV6RzRSVjFVUzBkNHhQZDhqUlVW?=
 =?utf-8?B?RlFZK2ZnTjFzVDNvNXZJZXBlVTlVbkxrZVpaaTlsVERZNFFTMlNSeWdPeUJz?=
 =?utf-8?B?VVRkS1VYQkJ1eFBWaTlQWE1XNnNDUmJWOVlXZlkwdUExWllsemFmTzd1Vkcy?=
 =?utf-8?B?dU1xQjRVa3Q4N09panZkSEJubm5la1A1eFAwMVFNRDVNUm11cGJzVklZWWM5?=
 =?utf-8?B?eEhjVzI5MEVENW9QcElzRVJuNkkvQ2pseFpyZUxZTlkzZkZ2WncxRUdScnl3?=
 =?utf-8?B?OFU3QVF5STZjVlVUQzFXYUV4NjBuVTBwb2JDekZFN0VicUE3blhNYnYxYjk2?=
 =?utf-8?B?NkJ6Qmsxd3UyRWVEaXJPSm1vZWRBZC8zblVLTHRuUXZtWVFHR1BpOU5nOHhv?=
 =?utf-8?B?MUlBSStPQjNTekNaVUpnT0oyTklpYVBrMTFMNllzOVBUQjA3ekk4NWcrcmIr?=
 =?utf-8?B?ZXQ4ditrTHBYV05SbFVlSWx5YWNtQm5GZXZDMUpNUEVQWUk5andIK1Z6bmZ2?=
 =?utf-8?B?SVh1SWI2ZnlaT1NQVGNqKzFITUROemhlTWQ4SlNYNDlKNDFnUDI2d29lNkpP?=
 =?utf-8?B?TEYyK013dmI3NFFlU2RNOGpIMlpzSTQ0eUhrV2Vhc1Q5dDFsN1l4OUdyZWhB?=
 =?utf-8?B?K2RtdHZKOFQ2a3BnNExIdG9FMEVQNXFiWmtWeTZxU3dkZ2NSOEN2Y3JBNkxx?=
 =?utf-8?B?d0ZCMTBhNkhqbXNiY1RIemRMaEZQR0xIck43TmU3UTBLWDVaNW5PZ2RIdVV3?=
 =?utf-8?B?eUM4UVNzWTJEUnhMZVplY1lob1MrcVJDTTluTVFxNzlSV3dmVHVtOHZOemxS?=
 =?utf-8?B?ZXdOWC9CSHVrTnZ5dHFVWlRGY0Z1ZXcvY3RvdFJhRWFvRVJvNHQ4ZExoMWpU?=
 =?utf-8?B?OHlkdkxVczluTVZ6M0VBSU0zVTY4bXVwa2JIa2YwdWxwc0JjU1FBNWJnRUtK?=
 =?utf-8?B?Sld4eEpSdFcwWk9DWTVBQTlrQzJzYmJIYzdGTHhqZ2pGcjBBMmk3ZHppZkJS?=
 =?utf-8?B?VFRPZ3pkVVl2SWRHaXJWVHFINzc2NzZ0TGVhdktvWFZLVGh4bkVwUFoxSUor?=
 =?utf-8?B?MUVWR1JKU3hJU1psc1NvZzAwOGZPNjJ3NUxVa2s1UVFpU3YyMm1qUUdhc1Bt?=
 =?utf-8?B?V2NFc2VBNUxGNlFwTjBibENmQjRNeFBMZ1pNcVpnMmRRaDBiQU02NUpMMW1Q?=
 =?utf-8?B?REJHQWRnSWtJN0FzbW1zN1Q4UkFGWG5rMWdVMEZsK3ZTQWJQWVV3a0cvVUhC?=
 =?utf-8?B?NGFEdk13VmZjQnIwYkNUUHNjYUk0d3VtV2l2VzNvUHlhM0NVbE5IREhyMlNI?=
 =?utf-8?B?eERjQ1haTTdScW9ib2hKNWE4SG1QNGZzWW9XNEJrcHFIZUtnTzBrcnFOQnEv?=
 =?utf-8?B?bmRPb3c4QlBkNVYxWVRKcEFxZUVaTi9mZ1UrMUVBZ1d5N3QvYUo4MDlqVHlZ?=
 =?utf-8?B?QkNsdlVGa0NROHZkOFVIY0prbEJYd3pFdWUzSytwS2t2RTNLdWNPSjdGVUl1?=
 =?utf-8?B?VElicVZJOG41N0l3QTluWFhnMllJdTlQZ2dWZjRIYSttVFpBbTNSaFBEc1lC?=
 =?utf-8?Q?6nkEbjVSp4qhQfx1SsAmk9z4u9lYXSmY1TtFyvJ?=
Content-Type: multipart/mixed;
        boundary="_002_CO6PR18MB45009B91FA30BDE67A994F9BAF079CO6PR18MB4500namp_"
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d1ef65-384c-4f23-04d9-08d936c4dc67
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 04:02:18.7839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aCfA9ROF6LkGfsXlxdFlrmbV5ZUfB0SLdUIhEsa9a6CIcbUJG+ExszPrC5gZYmb6Dkj8fC5xKmrHLxNEsrnJbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4730
X-Proofpoint-ORIG-GUID: VLYQRv2bkfiqIs4QY2yCqOxtLHU6DF6z
X-Proofpoint-GUID: Hp-6xhkM24d_7_V4k8tDJOM_PxaPbf0E
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_14:2021-06-23,2021-06-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--_002_CO6PR18MB45009B91FA30BDE67A994F9BAF079CO6PR18MB4500namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGltYW5zaHUsDQoNClRoZSBoZWFydGJlYXQgY2hlY2sgcGF0Y2ggYXR0YWNoZWQgZG9lcyB0aGUg
YWN0dWFsIHZhbGlkYXRpb24sDQphbmQgdGhlIHNhbWUgaXMgZXh0ZW5kZWQgZm9yIGVkaWYgY29t
bWFuZHMgdG9vLg0KDQpUaGFua3MsDQpOaWxlc2gNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiBGcm9tOiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5j
b20+DQo+IFNlbnQ6IFRodXJzZGF5LCBKdW5lIDI0LCAyMDIxIDEyOjE3IEFNDQo+IFRvOiBOaWxl
c2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPjsgbWFydGluLnBldGVyc2VuQG9yYWNsZS5j
b20NCj4gQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBHUi1RTG9naWMtU3RvcmFnZS1V
cHN0cmVhbSA8R1ItUUxvZ2ljLQ0KPiBTdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwuY29tPg0KPiBT
dWJqZWN0OiBbRVhUXSBSZTogW1BBVENIIHYzIDEwLzExXSBxbGEyeHh4OiBlbmFibGUgaGVhcnRi
ZWF0IHZhbGlkYXRpb24gZm9yDQo+IGVkaWYgY29tbWFuZA0KPiANCj4gRXh0ZXJuYWwgRW1haWwN
Cj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+IA0KPiBPbiA2LzIzLzIxIDU6MjYgQU0sIE5pbGVz
aCBKYXZhbGkgd3JvdGU6DQo+ID4gRnJvbTogUXVpbm4gVHJhbiA8cXV0cmFuQG1hcnZlbGwuY29t
Pg0KPiA+DQo+ID4gSW5jcmVtZW50IHRoZSBjb21tYW5kIGFuZCB0aGUgY29tcGxldGlvbiBjb3Vu
dHMuDQo+IA0KPiBJIGRvbid0IHNlZSBlbmFibGVtZW50IG9mIGhlYXJ0YmVhdCB2YWxpZGF0aW9u
IGNvZGUgaW4gdGhpcyBwYXRjaC4NCj4gDQo+IEFtIGkgbWlzc2luZyBzb21ldGhpbmc/DQo+IA0K
PiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogUXVpbm4gVHJhbiA8cXV0cmFuQG1hcnZlbGwuY29tPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+DQo+
ID4gLS0tDQo+ID4gICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZWRpZi5jIHwgMSArDQo+ID4g
ICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMgIHwgMyArLS0NCj4gPiAgIDIgZmlsZXMg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9lZGlmLmMgYi9kcml2ZXJzL3Njc2kvcWxh
Mnh4eC9xbGFfZWRpZi5jDQo+ID4gaW5kZXggOGU3MzBjYzg4MmU2Li5jY2JlMGUxYmZjYmMgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2VkaWYuYw0KPiA+ICsrKyBi
L2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9lZGlmLmMNCj4gPiBAQCAtMjkyNiw2ICsyOTI2LDcg
QEAgcWxhMjh4eF9zdGFydF9zY3NpX2VkaWYoc3JiX3QgKnNwKQ0KPiA+ICAgCQlyZXEtPnJpbmdf
cHRyKys7DQo+ID4gICAJfQ0KPiA+DQo+ID4gKwlzcC0+cXBhaXItPmNtZF9jbnQrKzsNCj4gPiAg
IAkvKiBTZXQgY2hpcCBuZXcgcmluZyBpbmRleC4gKi8NCj4gPiAgIAl3cnRfcmVnX2R3b3JkKHJl
cS0+cmVxX3FfaW4sIHJlcS0+cmluZ19pbmRleCk7DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lz
ci5jDQo+ID4gaW5kZXggY2U0ZjkzZmI0ZDI1Li5lODkyOGZkODMwNDkgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jDQo+ID4gKysrIGIvZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX2lzci5jDQo+ID4gQEAgLTMxOTIsMTAgKzMxOTIsOSBAQCBxbGEyeDAwX3N0
YXR1c19lbnRyeShzY3NpX3FsYV9ob3N0X3QgKnZoYSwNCj4gc3RydWN0IHJzcF9xdWUgKnJzcCwg
dm9pZCAqcGt0KQ0KPiA+ICAgCQlyZXR1cm47DQo+ID4gICAJfQ0KPiA+DQo+ID4gLQlzcC0+cXBh
aXItPmNtZF9jb21wbGV0aW9uX2NudCsrOw0KPiA+IC0NCj4gPiAgIAkvKiBGYXN0IHBhdGggY29t
cGxldGlvbi4gKi8NCj4gPiAgIAlxbGFfY2hrX2VkaWZfcnhfc2FfZGVsZXRlX3BlbmRpbmcodmhh
LCBzcCwgc3RzMjQpOw0KPiA+ICsJc3AtPnFwYWlyLT5jbWRfY29tcGxldGlvbl9jbnQrKzsNCj4g
Pg0KPiA+ICAgCWlmIChjb21wX3N0YXR1cyA9PSBDU19DT01QTEVURSAmJiBzY3NpX3N0YXR1cyA9
PSAwKSB7DQo+ID4gICAJCXFsYTJ4MDBfcHJvY2Vzc19jb21wbGV0ZWRfcmVxdWVzdCh2aGEsIHJl
cSwgaGFuZGxlKTsNCj4gPg0KPiANCj4gLS0NCj4gSGltYW5zaHUgTWFkaGFuaSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgT3JhY2xlIExpbnV4IEVuZ2luZWVyaW5nDQo=

--_002_CO6PR18MB45009B91FA30BDE67A994F9BAF079CO6PR18MB4500namp_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Thu, 24 Jun 2021 04:02:15 GMT";
	modification-date="Thu, 24 Jun 2021 04:02:15 GMT"

Received: from CO1PR18MB4826.namprd18.prod.outlook.com (2603:10b6:303:ed::22)
 by CO6PR18MB4500.namprd18.prod.outlook.com with HTTPS; Wed, 23 Jun 2021
 01:54:46 +0000
Received: from DM3PR12CA0134.namprd12.prod.outlook.com (2603:10b6:0:51::30) by
 CO1PR18MB4826.namprd18.prod.outlook.com (2603:10b6:303:ed::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.21; Wed, 23 Jun 2021 01:54:43 +0000
Received: from DM6NAM04FT010.eop-NAM04.prod.protection.outlook.com
 (2603:10b6:0:51:cafe::16) by DM3PR12CA0134.outlook.office365.com
 (2603:10b6:0:51::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend
 Transport; Wed, 23 Jun 2021 01:54:43 +0000
Received: from mx0b-0016f401.pphosted.com (67.231.148.174) by
 DM6NAM04FT010.mail.protection.outlook.com (10.13.159.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.16 via Frontend Transport; Wed, 23 Jun 2021 01:54:43 +0000
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N1nUqw024957
	for <njavali@marvell.com>; Tue, 22 Jun 2021 18:54:42 -0700
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by mx0a-0016f401.pphosted.com with ESMTP id 39b91hcsv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Jun 2021 18:54:42 -0700
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N1osUJ008638;
	Wed, 23 Jun 2021 01:54:42 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39anpuvu3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jun 2021 01:54:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15N1pEHN158760;
	Wed, 23 Jun 2021 01:54:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
	by userp3030.oracle.com with ESMTP id 3995pxarde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jun 2021 01:54:40 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1295.namprd10.prod.outlook.com (2603:10b6:300:1e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 01:54:38 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 01:54:38 +0000
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0701CA0033.namprd07.prod.outlook.com (2603:10b6:803:2d::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 01:54:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nilesh Javali <njavali@marvell.com>
CC: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [EXT] Re: [PATCH v2] qla2xxx: add heartbeat check
Thread-Topic: [EXT] Re: [PATCH v2] qla2xxx: add heartbeat check
Thread-Index: AQHXZMtx/kgXQO79r06PBFyfWfsjo6sg2+Zb
Date: Wed, 23 Jun 2021 01:54:34 +0000
Message-ID: <yq18s31s5v1.fsf@ca-mkp.ca.oracle.com>
References: <20210619052427.6440-1-njavali@marvell.com>
In-Reply-To: <20210619052427.6440-1-njavali@marvell.com> (Nilesh Javali's
	message of "Fri, 18 Jun 2021 22:24:27 -0700")
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: 
 DM6NAM04FT010.eop-NAM04.prod.protection.outlook.com
X-MS-Has-Attach: 
X-MS-Exchange-Organization-Network-Message-Id: 
 a7e64006-5c0e-4657-633c-08d935e9df2a
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator: 
X-MS-Exchange-Organization-RecordReviewCfmType: 0
x-ms-publictraffictype: Email
received-spf: SoftFail (protection.outlook.com: domain of transitioning
 oracle.com discourages use of 67.231.148.174 as permitted sender)
x-ms-exchange-organization-originalclientipaddress: 67.231.148.174
x-ms-exchange-organization-originalserveripaddress: 10.13.159.82
x-ms-exchange-organization-submissionquotaskipped: False
x-clientproxiedby: SN4PR0701CA0033.namprd07.prod.outlook.com
 (2603:10b6:803:2d::27) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
x-originating-ip: [138.3.200.58]
authentication-results: spf=softfail (sender IP is 67.231.148.174)
 smtp.mailfrom=oracle.com; marvell.com; dkim=fail (signature did not verify)
 header.d=oracle.com;marvell.com; dmarc=fail action=none
 header.from=oracle.com;compauth=pass reason=116
x-forefront-antispam-report: 
 CIP:67.231.148.174;CTRY:US;LANG:en;SCL:-1;SRV:;IPV:CAL;SFV:SKN;H:mx0b-0016f401.pphosted.com;PTR:mx0a-0016f401.pphosted.com;CAT:NONE;SFS:;DIR:INB;
dkim-signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LTjxFljjoH79ax0EFUAObCZKku1j4XXRzQlc4I9+7M=;
 b=eFmLanRKkYjTSINWdq1lTUP8BzB0boFepCIYj5fZCFAwi3eTcfaknLHwvrHkAVlYJqKNZ8XSzIwQlJFWqj0GItMLOqib9coyldwgVBObWOObSCDLWb0VlwRSQkqOwfiKobQ7eX6EBgJCQiRdmItp5GFYJ+a80j4VVfYjZXjRYJg=
x-microsoft-antispam: BCL:0;
x-proofpoint-virus-version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_14:2021-06-22,2021-06-22 signatures=0
x-proofpoint-spam-details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106230007
x-clx-shades: Deliver
x-clx-response: 1TFkXGxoaHxEKTHoXGR0cEQpZRBdjHwFtQllIYExCcBEKWFgXYWNHHx8TaRt
 HAWsRCnhOF2B4RFtBWRNvQRxSEQp5TBdrehJbfWhoe0JfWREKQ0gXBxsYGBEKQ1kXBxsdHBEKQ0
 kXGgQaGhoRCllNF25PRkNcT1gRCl9ZFxscExEKX00XZ2ZyEQpZSRcacRoQGncGGx4TcRscEhkQH
 xl3BhgaBhoRClleF2xseREKSUYXR0tYXE9GRnVCRVleT04RCkNOF39cYHxsRWFZUhMeRx9/XkBu
 YW54bl9TaWUaGm1ZHUBsEQpYXBcfBBoEGBkYBRsaBBsaGgQeEgQYGRAbHhofGhEKXlkXc2luQBM
 RCk1cFxgcHBEKTFoXaWhraE1DEQpNThdoEQpMRhdvb2trYmtrEQpCTxdtRGhiHxt7WGV6aBEKQ1
 oXGBofBBgYGgQbHB8EGRgRCkJeFxsRCkRJFxkRCkJcFxsRCl5OFxsRCkJLF2B4RFtBWRNvQRxSE
 QpCSRdgeERbQVkTb0EcUhEKQkUXZ39QQBNTQ30dewERCkJOF2B4RFtBWRNvQRxSEQpCTBdhY0cf
 HxNpG0cBaxEKQmwXZn58S3xeG2BmRFoRCkJAF2doR3h+c2ATXVscEQpCWBdjU0ASRFwBa2xaRBE
 KTV4XGxEKWlgXGxEKeUMXaFhsa1keBRl7QW0RCnBoF2x9GQFdZE1BGUJsEBoRCnBsF2RzUB9fbk
 ZiRUBAEBkaEQpwTBdjUh5da3J9EhhaaBAaEQpwQxduWGNrHltwU3t/WhAZGhEKbX4XGxEKWE0XS
 xEg
x-ms-traffictypediagnostic: MWHPR10MB1295:|CO1PR18MB4826:
x-ms-office365-filtering-correlation-id: a7e64006-5c0e-4657-633c-08d935e9df2a
x-ms-oob-tlc-oobclassifiers: OLM:2887;OLM:2887;
x-ms-exchange-crosstenant-network-message-id: 
 a7e64006-5c0e-4657-633c-08d935e9df2a
x-ms-exchange-crosstenant-originalarrivaltime: 23 Jun 2021 01:54:43.4586 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Internet
x-ms-exchange-crosstenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
x-ms-exchange-transport-crosstenantheadersstamped: CO1PR18MB4826
x-ms-exchange-transport-endtoendlatency: 00:00:03.3737809
x-ms-exchange-processed-by-bccfoldering: 15.20.4264.018
x-ms-exchange-transport-forked: True
arc-seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ggbnt0PPqTAGkHwv68zts+kjyhe+EK5JuA6okEavDM31m6vbC0me2pz2gp6sJel4Zzo5d2DuwNqdsIRGvotQ0G1Dl8PwrKjOtXBLqtE2s7MqjUgywKIY0/fifZdJL2+MHKfQ8n008/KVpiRO3/+YC/Op3MlavpS38BpjAS8sFvtD66reLiPMQpZ8ltVp4tFWAod6FcroovnZSSd+1MhVLPbVNDTYpz+IN8vl055xzixQne/z29ce7s1ebpIbwQQEwumpJuSGo2AcBukRbHFtptPjSKHDsoZiDEkBy69TRsBOP1QwPKQBMegGRF57Lv9RsdlhJGRXAUf8ujAjFSiRKw==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LTjxFljjoH79ax0EFUAObCZKku1j4XXRzQlc4I9+7M=;
 b=FykZATnIbnWkfzK7MZur9hpZTyKbNzoW7kdBGw53N9QQI2YNOinv0iwark7bQOGz6122jPelFE7QQZ2YdsVOclEr5VylDUk42IcC/0cDpyPdkrRpU4u8/FeRzG05V8EvrHdLKxUhCenIMIQUkivn4Phf9HA/jDQ9HBG3MtXnjUWB1JNEPQZ93GK0gDuzF9zdai+5oN3w5iI9xA2CGEIyL5ggf+toLN8VsvbHDgV9VNDFgd6geDdWWQ03liqM3gArK1+SgnEnmuskj8fKWhEOw1tB4QBmwMIHKbtGSNe/91X2gQUWHrcXkXi+3qqBPSmn4sbJ2R0iCe3RDGD3kgKx1Q==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
authentication-results-original: marvell.com;	spf=pass
 smtp.mailfrom=martin.petersen@oracle.com;	dkim=pass header.s=corp-2020-01-29
 header.d=oracle.com;	dkim=pass header.s=selector2-oracle-onmicrosoft-com
 header.d=oracle.onmicrosoft.com;	dmarc=pass header.from=oracle.com
x-microsoft-antispam-prvs: 
 <MWHPR10MB129516BF71FBFF1BB6F5B2E38E089@MWHPR10MB1295.namprd10.prod.outlook.com>
x-forefront-antispam-report-untrusted: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(38350700002)(86362001)(8676002)(6916009)(26005)(38100700002)(4326008)(83380400001)(54906003)(558084003)(55016002)(186003)(6666004)(316002)(478600001)(7696005)(52116002)(2906002)(66556008)(8936002)(36916002)(956004)(66476007)(5660300002)(16526019)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-untrusted: BCL:0;
x-microsoft-antispam-message-info-original: 
 FfcGUGMDHt/lpHRGK67y73h7xo3qh6r5MbASaPybWm7zxQZBX7rcP1C8fmgdRb96MlCq4NnOwSi0Sl/UbUTGMDvJvUM/rdL81ZGEBfXGadQocX6YWg2+7x/5t8puyctxXFCTlAbx8sz4Uzz2Qve6crP0/cPdv4iz2EB/d0xq0n/jNrSyHtPEF9PsyY5kaSA1FJk9oFcuxpYeUZgKprCJnxd9Xz2Bo0qhzU3YTBR7wDMj2ngSGabxP5Z9q+vHYM8lPJPWpO1E+ReKTy7OGVykEVtvRMhQKoEaEMXB8BrKaNmsdGk7/fn4eADK45tbA70a39s4+w9fKlNPwjEh2bqvIcrVOuTQJA7dqcDF/oyJXBtFVZZjxOysuBmZ6D9KOnq4Gdn8J0xU8EOu/ammIuRQ+teyV+PEKAZexkyKjAE7LW5uClRIovoe8GjTJMX/+hZ2FbNg8OXVZlsFNqfs9lPNHhQ/IzOVsgTEOPh9K7VKxkc2iyNeyuxDURTJOcRfuFuugdV/qitm/SNnH7tqVwMhJare6hhYjLoOORAKMLWuk2donU07H7QnEQ2n21OH1G1jjl8sRR94YnO2VC3uUkq/pYSWr9ub8FciXq5qfXUzxqx4mSpezXWDKx53d41l1PIG/Dhp4iZpd+y5FKx/6OdMa1k0YW95EWhOFe1330BO01mO0O3hmheWy30faAxZD46gOSKw4DuS3F9sCpwJ8J3BDA==
x-eopattributedmessage: 0
x-ms-exchange-transport-crosstenantheadersstripped: 
 DM6NAM04FT010.eop-NAM04.prod.protection.outlook.com
x-ms-office365-filtering-correlation-id-prvs: 
 d8c3cc52-e79b-46b5-2ac8-08d935e9dba2
x-ms-exchange-crosstenant-authas: Anonymous
x-ms-exchange-crosstenant-authsource: 
 DM6NAM04FT010.eop-NAM04.prod.protection.outlook.com
x-proofpoint-inboundspam-reason: eusafe
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-organizationbypassclutter: True
x-eoptenantattributedmessage: 70e1fb47-1155-421d-87fc-2e58f638b6e0:0
x-proofpoint-guid: UvJVFoKsx94m5UtjDKDRDuyCO00Gs7jF
x-proofpoint-orig-guid: UvJVFoKsx94m5UtjDKDRDuyCO00Gs7jF
X-Microsoft-Antispam-Mailbox-Delivery: 
 ucf:0;jmr:0;auth:0;dest:I;ENG:(750129)(520011016)(944506458)(944626604);
X-Microsoft-Antispam-Message-Info: 
 =?iso-8859-1?Q?XX09cnclAqJDbR6bqZKInrHzracqa+igR4fjagU0WlxZYd79JjdNE+Kpq2?=
 =?iso-8859-1?Q?z0K/PocgCz4yMaA5Zy31iIJ9ajgkTc4dSPl6prmwgurvB8oU3EdgNGt006?=
 =?iso-8859-1?Q?6xvemiv6LHEBp0qZvvcueGuJ4W+g8/nyBiykI0AXBhJ4oDJ0uAkb0qg/8T?=
 =?iso-8859-1?Q?6cYzvZFaUSKjKYxQRIcYpumoCpXdgm/vwKxYUlLdd5XnaOrzhBuqYUasu/?=
 =?iso-8859-1?Q?0rtW/+pSvYzWRgbwXcAlGqBeS+fOSkfrkkksS+fN4sM/Jyeg8AUSoGnwMr?=
 =?iso-8859-1?Q?cmyhP/RtDGgq3G9IwddF8F6ULtHyOqBhxtGFRCgn3xNUSyufdGeJ9BBRJB?=
 =?iso-8859-1?Q?qgmpy+3hrpYixnI4dtMGttjxVyp3cGGHsv35mWx3f5rgO2hMwozpvG4cJj?=
 =?iso-8859-1?Q?eYwwAodp7M8zpHd7LmnIHvEo2Ci5BiGp/cXwHJfEKhOVcrqdhdGR9tHJ3L?=
 =?iso-8859-1?Q?KUPkqxQe6S4r3comZqFGtFLhIVNEPNV4/BK5505j0kKWswJXizgSpkfQoQ?=
 =?iso-8859-1?Q?lHgTSRl5ROAGkMfxhIoqmv2OpLolU25navrMUZRUu9ZQetnT6UI3pA71TT?=
 =?iso-8859-1?Q?79r3pixgOqfCVeMZb0/wDL329Q6CV826D4uBsN8Ei8J9xIuNN2V5tqZ6O4?=
 =?iso-8859-1?Q?hMkqYn6004Z1gBjQYWbpq1fQkzLq8QCzySMJUxk50MCibmO73YvVsWGQlS?=
 =?iso-8859-1?Q?0iHUbtMzAeKmdBOAGGkWIB9XnZLnc89wBk+9bzT/Sc9csAtRN+epg5fa8P?=
 =?iso-8859-1?Q?CjAYF1JBPg4Bl+ZXrnDzeeDLXu9i6UIvJfYe53ZjB0cixMVPJwwX8vJAxa?=
 =?iso-8859-1?Q?NqGxgK+dbmsFCagGIEz5B5zqlXQudvCeaNraEqHPIUfrivKs64m1KDwQqx?=
 =?iso-8859-1?Q?zRDSM1tw5H6Cruf46MzCcYVyWojlfsHjpHa2aZApNg/3vnNgBcE7HRfILO?=
 =?iso-8859-1?Q?AunvfeqmRUJFbmUxiFYNe2cW8AbAwUhbScwHb6X9y3/OhTaoHv8QB/X26o?=
 =?iso-8859-1?Q?ZtxsNSIwY/x8TTW4v1W/1pO57vERKeBKTZ/AxWEON9briQI2GHQNmYB9IE?=
 =?iso-8859-1?Q?MzwFn0Vp9BgjFBcWwAp5VsUsXBTJ/BCkb/Akhq3cf/gmGqH4Qbm1xeSvMe?=
 =?iso-8859-1?Q?x77nolVZG7tneOKs9MHwmJ3KqCpjh9orJaXiWnCowDbR/dtd/cw3IhgOV1?=
 =?iso-8859-1?Q?jHp8ioYuyNrrKg51RAClFzoKmmmg9RfmAHyoFTYF6X7Zbp99imfTyF3I7G?=
 =?iso-8859-1?Q?UK/QNQKgxylvLPpVeaqwLf3D9sTKONn2B9iQtl5dWlA62xS3ku+jFIjzx2?=
 =?iso-8859-1?Q?rDG25g18XAOdCGq1FHRMxupOTeEQlEJG9MU3wXwy1FQtplunliwz2MbAJi?=
 =?iso-8859-1?Q?1fyyvuigQgqrsUszGp/N+ZMPaj1cec4nfKMMlD9B6rJIgeSX28C54IxvnH?=
 =?iso-8859-1?Q?6tCkxeRrhZt7vP0HKi3jUJaR4JdiTl3m2kKHltthcW72v8Z+I0BzKixuKi?=
 =?iso-8859-1?Q?FvOKJ7kryIwXm/lXlu7I9kfCUZNiGqMDERy0vzUX0zd6eY2qsWnMkHROy2?=
 =?iso-8859-1?Q?PoDLkjBrq6pg3Ie18d8a0owCNHqj34rZSJNbgSpIg4r3+phVg4jFgomwVK?=
 =?iso-8859-1?Q?7TLOfwmdlakJYjaUqAppdqhZmfMujYWyDzwE+OIaUbTfMem299wF51xFQ7?=
 =?iso-8859-1?Q?Z9qvMa9co+PIJiPyPxl3X3rFFxXyKLbIReNPNvjZIIZNGQTXDNuajWk8v/?=
 =?iso-8859-1?Q?QjDwenPhn2zf+sk21FwguXLKssZns37BTR6Mc2IqvfmQNRGb0/ppmKUT00?=
 =?iso-8859-1?Q?ef9MM9eHKxkNeMJwuK9niUN9E1W4ZUQ=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

External Email

----------------------------------------------------------------------

Nilesh,

> Use 'no-op' mailbox command to check and see if FW is still
> responsive.

Applied to 5.14/scsi-staging, thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering

--_002_CO6PR18MB45009B91FA30BDE67A994F9BAF079CO6PR18MB4500namp_--
