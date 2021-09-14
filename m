Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D369C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 07:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C27560F26
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 07:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240634AbhINHQg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 03:16:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3898 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235026AbhINHQf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 03:16:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DMk5ZH009391;
        Tue, 14 Sep 2021 00:15:15 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 3b2380v16n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 00:15:15 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18E7FEd5013562;
        Tue, 14 Sep 2021 00:15:14 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0b-0016f401.pphosted.com with ESMTP id 3b2380v16a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 00:15:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSlXEcUJP2NcAdj3TyoI9pVXMqpKeLSCAXFnte/+9YK9uJW7IGaqwOfgHOH//qAx1XvFGUIntQf+FwvkUR7Xl7GQ2JRreCtwt9s3nE9msFWSKgRViCRAFIigY9HB/sOLFC2mxFzyiwU8I/Pb18CyU4+Mn+W7YyJRVBcKx4HH2EgiH9B1BQl1z/EQ6pdiCBxYK7aAdXQb6BdaMY9BhCZT4DWuBOJKXe/iHH2BExmW3Ab/aQPLn7R6StDNfEu8P46dR+pAjzR8dL0Bv2TK7I0laYmA3fF5fL0kDCAQSKDAp6Ka+jBSttmNUG0qloHUf56+YOb2xVra11oFGbNbeqSgLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AcgdprexyjtmY0fUOJhbUpZTycHGhmTTRj7A4LgpBsY=;
 b=MCpay87u4PsEA6snYBk+w9nuKs3a7mWEpTL9QQ1gQP62qc2cjYF5TsPo4PdQajFYTEWsC3UI2z6kBu0E8Y11hdsPHdHLvwKG3EDDRJaAqx+/wkDgJ9ttcOjg7ZbtIbOyYfB5tqvzhEvclbejp8CIY2BjoOPpxcaSfAm1gUTk4inJVxa14rC6LJZ+fkWzERJFcfv8hOp3PrhhyI4E6m2tAtsDWkGvnxwPCPwP70t6eX+hAAjfXyEsqU5f9tkuRCFMR2UDJVf8bpFKmX8htrmowBSydJGheYiDo+QlhDbKtkYngsNTnZERCufaXYbK9bpAEjLy7f7Z/z3/ZYAQB4mXBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AcgdprexyjtmY0fUOJhbUpZTycHGhmTTRj7A4LgpBsY=;
 b=DsgUig27d+ytRtU8aRggParTKcHDYMJdlKPaF1qoANCmFJSVAiI7o00xuP7gyPxxMnQXFbPQ/Akt2Z9zIJsoj3QKGaeN8zeYGiPY2hPO8U1wix8LSx0EhEQNy6AieqiuTrs+cdyzgFNMAmHUnkt3GLIGUwxLIh4KVhzzKlTaPMk=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by CO1PR18MB4620.namprd18.prod.outlook.com (2603:10b6:303:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Tue, 14 Sep
 2021 07:15:12 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::e1e0:2245:4917:79db]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::e1e0:2245:4917:79db%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 07:15:12 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Harish Zunjarrao <hzunjarrao@marvell.com>
Subject: RE: [EXT] Re: [PATCH v2 01/10] qla2xxx: Add support for mailbox
 passthru
Thread-Topic: [EXT] Re: [PATCH v2 01/10] qla2xxx: Add support for mailbox
 passthru
Thread-Index: AQHXpNE1ovPPTM2Zm0yLdbUwWsWt2quadPEAgAiqrLA=
Date:   Tue, 14 Sep 2021 07:15:12 +0000
Message-ID: <CO6PR18MB4500AD57B2D53AD56F14B777AFDA9@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20210908164622.19240-1-njavali@marvell.com>
 <20210908164622.19240-2-njavali@marvell.com>
 <96a11a9b-fc55-0826-1970-b37b738c3c97@acm.org>
In-Reply-To: <96a11a9b-fc55-0826-1970-b37b738c3c97@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd411601-8290-4fea-ce51-08d9774f64de
x-ms-traffictypediagnostic: CO1PR18MB4620:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR18MB4620AD65319FE683FCA27C33AFDA9@CO1PR18MB4620.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DH6cqS+inZ7ImQ1R9gjvlDelaeYeixhv9Ay50kIMkoe1ia1uoibGfmpQchqzcFw+lfUdhnV91qvcNUDvRS+pnuchK8DYoTKW+bQ1bmGQW0KKW09oXt5LlA8TOs+xXclSsbDZ94XCcLFPeWr6jLZo549RAM7l3+VjNk0/3QCnMTAtF8xPQNLjwjLCJzKJE6O16Ml0DdppQHYX63RwlsMduNntSxLM0VX5cTY5INjIIaXs1a/2WJzDRpmyVgHrZlbyGzeN4Ya9e8ahfgNRI/bJ6tEXu2Oyyjflf/+jrqsR4958z2epiQNdafnKQv1cJGGdW1AboenMbPFl+uccoi7LpJdDLiyb03+GXseb07nWQSNQ0K5jy/R8A6NLSpxTPXmAl52tEVlIzRh+C8gih/4qpi+trRBBxfIBa8jwJUasvNJUX2+xXk+vK1wUpk77FjNC7sQSJvZ1MmlIvg/nPhFhdyZJRoyHdXoBVGZbhZnHZEiFQFTVJIX4gxRzJlyk9rAn44HRxzZDfzdhS3RDYRqxsNJ3BHeHiiW3o8npIusomcotdctEiqTs9qkGeHrudchHjnvDn5BduCMvRAPLfZ1HtJGf9qXe7ec+iPUh1hL/POWQbe3Z4WGGIuufRYuXV4B9J7XPgQX4IpcHKrH+X5OD3o9CS7KghIyrdPJdCrt72vQABjQAZ7mfymhlzI93MKETk7aRfwpFKX3+zN16Sn+x0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(55016002)(33656002)(107886003)(186003)(54906003)(8676002)(26005)(316002)(8936002)(53546011)(83380400001)(6506007)(2906002)(52536014)(122000001)(66556008)(110136005)(7696005)(64756008)(66476007)(15650500001)(4744005)(66946007)(5660300002)(38070700005)(9686003)(38100700002)(66446008)(71200400001)(478600001)(76116006)(4326008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1Q0SHgvV1NZUEdseVFRek9ncHFVVVEvRzB3REN1VEc3Vmt2bjl6bWRpNU85?=
 =?utf-8?B?UGlCVDFCZWF5NjBLd3hmSjRSRXU2ZytRZzRITEZhMXNlZDZZTkZDYk10aWxV?=
 =?utf-8?B?MjhYMnBYb3ZIOExCYzd0QllOejdhdXJDV2JSZHc3Q2FKQzhBTC93ck9kR0t5?=
 =?utf-8?B?VGZnL2VidkdGeStsOUpVQXg3WmdLbzA5NDc2cFgwSnBPOUFCZWVrTGR4WThV?=
 =?utf-8?B?aS9JU1cyQjF4aHFrR3ozVnJteHBiWndjcFJNTHlVOE8wb3RmZDcxNnE4T3Zt?=
 =?utf-8?B?c1h4bi9XOFZMa0VOZS92bWMzZG0yQWEyNWJ3V29NV0hSai81bVVSN04wUVp3?=
 =?utf-8?B?Z1BpSWlHL3JSM3pUYzlNc0x3aEY5dHZ1aTNyYjhwRHN4a2lYUGNLeGtYS21r?=
 =?utf-8?B?VkdBVWxDUkdod3JBS2F2SHlGd29OTEY5THN4a0F2T1FEVnNnUW1neUY1Q2hj?=
 =?utf-8?B?elk2RC9Rem03Rk1ZeCtGVXoyMmxhajNjS2VNODlCZXc0SlVSRFdpMXNPNTNB?=
 =?utf-8?B?QzZEQnZHRHR6cWVmd3V2UEpRdTFTYlh0WnArSDM0b0R5QnRRTnZhVWJFUkdr?=
 =?utf-8?B?a0VTcGF2VlowVXk2akFjcTlNV2tZd0F4OXJ1K3Zvd3FFMmNvNnlqM1FyRml3?=
 =?utf-8?B?dndPL21oRTdEcGlUSnlYU1JEVHdnSkx0MndObElRS2VxUGFkSkhLdVNVNnR2?=
 =?utf-8?B?L3ROOWIwSngwSzJlaVB0NnFYVWNGZ2NQMmtnTFBZYWZYV2k4cWt0dzRTRy9Q?=
 =?utf-8?B?ZG03UkZPSmxmUEhNZTc0TW5ObDJ0aEE0RWtqbHE1Zzlzdmt4T1dCZDRqUDFl?=
 =?utf-8?B?Qnk0OFE3eDRWaFltQndzMjI3U2hjNE4zY0xhZVl1bnh0QUZTRHhzVXNWRm04?=
 =?utf-8?B?cFdsQVBUM1FoQWgyTjYwNVZQR215djNuTTNFdUdDOFZ5Nm5hbXNqcmlyMUpP?=
 =?utf-8?B?N0FIQldSM2F2aWc0Nk94NURZSlFRU0JOaDRXa2JYalVZUDhEK0VtT1RrOERB?=
 =?utf-8?B?dUNjL3NVWXNVZVF1VmNLYjBCSXVSbTRSREdRMjBqajgrem9uMlcreTFNUDJB?=
 =?utf-8?B?bnJ1YUJzcUNkNmNoUG9TYzByanhCdnd0MXRrdUp3b1RJOEZtUFZpcW1OUStJ?=
 =?utf-8?B?MXBjRnFFa0Nia2FiSXBlRElaTmJYM1NGUU5sb0dqYVJLZzMzQ1dKbW9vYnNt?=
 =?utf-8?B?U1RQdXVFWUhHL1pwc3pPRzVOaTFHSlBObyt0a3dNbzFVSE1sQ3R1bnQrR2RB?=
 =?utf-8?B?M3J2ZjFTRHI0NjZBWDlPYWtnbk1aRXV3emlGZjkxdktKaTFnNTlmV1I5OGo0?=
 =?utf-8?B?YUxiV2FBeVIwaW15VTcwSWN2SzFVaE1GZXlvcEJ1V1p3N0RLYkQwWDJTOTVI?=
 =?utf-8?B?R0V5cHhTZXNBYUFrb0dsT09tMVVLVnRvdTl2Tm0wTXZ3OEhSbDZ6UXV6dW93?=
 =?utf-8?B?L3VlR1hBT0JKVEN5YjFxcDdlTDhkSFpTZHhwTEt3NEJxakxkSStSWlBTRXV5?=
 =?utf-8?B?dENBcVlMWE5QSTRWUkR0bHBNN09UdytCMFJLZWQ0ZE4zS3YzLzJnMFlCcVRB?=
 =?utf-8?B?Nk5IU1JkY1g2SldsOE1hejdGWjl4T1JKdnRtMWdxUGFiZThhMld2SGxEdGI3?=
 =?utf-8?B?OGE1REN0L3RQbWdpT0swYTNOcEQ2RXR3Wk5qQ1pTNEt6MEVOamFqTUdOQm14?=
 =?utf-8?B?OTJlTnNucVBDb0FqZEZCMzlsT0F6Z2RXQkxiWnpGZ09GbmN3bDQrUkhSZjVa?=
 =?utf-8?Q?YxG3cGW8jhoQypFuiKniz93Sbl1z42ZYeXdCg9Z?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd411601-8290-4fea-ce51-08d9774f64de
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 07:15:12.6159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ILZTY3GDRk9FnO5wqDlTwWO6hvIf5Pa6VdYUahsqjrHW4pTTdYBJhfm5MQaj4+VQTosqcxJyrjt0l0pbj0jbAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4620
X-Proofpoint-ORIG-GUID: IdqCAXSgLj4NT4BZVBs9BaXy4qckPRHy
X-Proofpoint-GUID: jYDosRYaNoOqkquHjpmbMnzZH7rF_ICa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-14_02,2021-09-09_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QmFydCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJ0IFZhbiBB
c3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIg
OCwgMjAyMSAxMTo1OCBQTQ0KPiBUbzogTmlsZXNoIEphdmFsaSA8bmphdmFsaUBtYXJ2ZWxsLmNv
bT47IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tDQo+IENjOiBsaW51eC1zY3NpQHZnZXIua2Vy
bmVsLm9yZzsgR1ItUUxvZ2ljLVN0b3JhZ2UtVXBzdHJlYW0gPEdSLVFMb2dpYy0NCj4gU3RvcmFn
ZS1VcHN0cmVhbUBtYXJ2ZWxsLmNvbT47IGRqZWZmZXJ5QHJlZGhhdC5jb207DQo+IGxvYmVybWFu
QHJlZGhhdC5jb20NCj4gU3ViamVjdDogW0VYVF0gUmU6IFtQQVRDSCB2MiAwMS8xMF0gcWxhMnh4
eDogQWRkIHN1cHBvcnQgZm9yIG1haWxib3gNCj4gcGFzc3RocnUNCj4gDQo+IEV4dGVybmFsIEVt
YWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IE9uIDkvOC8yMSA5OjQ2IEFNLCBOaWxlc2ggSmF2
YWxpIHdyb3RlOg0KPiA+ICtzdHJ1Y3QgcWxhX21ieF9wYXNzdGhydSB7DQo+ID4gKwl1aW50MTZf
dCByZXNlcnZlZDFbMl07DQo+ID4gKwl1aW50MTZfdCBtYnhfaW5bMzJdOw0KPiA+ICsJdWludDE2
X3QgbWJ4X291dFszMl07DQo+ID4gKwl1aW50MzJfdCByZXNlcnZlZDJbMTZdOw0KPiA+ICt9IF9f
cGFja2VkOw0KPiANCj4gV2h5IGRvZXMgdGhpcyBkYXRhIHN0cnVjdHVyZSBzdGFydCB3aXRoIDQg
cmVzZXJ2ZWQgYnl0ZXM/DQoNClNwZWNpZmljYWxseSwgbW9yZSB0aGFuIHRoZSBkcml2ZXIsIHRo
ZSByZXNlcnZlZCBieXRlcyB3b3VsZCBiZSB1c2VkIGJ5IHRoZSBhcHBsaWNhdGlvbiwNCmFuZCBk
cml2ZXIgdXNlcyBvbmx5IHRoZSBtYnhfaW4gYW5kIG1ieF9vdXQgZmllbGRzIHRvIGFjY2VzcyAz
MiByZWdpc3RlciBjb250ZW50Lg0KDQpUaGFua3MsDQpOaWxlc2gNCg==
