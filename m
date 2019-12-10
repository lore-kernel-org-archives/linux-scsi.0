Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7572AC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 19:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 353D520828
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 19:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MFbfhuNJ";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="SYYtTjGx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfLJTlk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 14:41:40 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59652 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbfLJTlk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 14:41:40 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBAJYJjZ011607;
        Tue, 10 Dec 2019 11:41:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=dQqoDWiCS9Pw0vUB1whyiEi7kYCGe+Iz+DJpCpfXAN0=;
 b=MFbfhuNJ+GlQcZz8xDRcc+Vv448kbpdU/aibnbdRTu3ObYc6k/tpdRpUSYQJCCTWuunw
 46OUtr0zR80RFGudQq2BrsL4W9NGEm13OWBR4EWovjnRcBbFwvAOPvQspv24OvJSo05H
 i8rP5A8mwlnj7PEbMax1Zf9s1R3praQiFq302IGES0ywfkvDBsoKqiORC9qvsBnTGT2s
 ZgINwhwlj+ODOqK+LjipCnhz65V7bRqeI2HLrAMglSZK2JVSd5AbNCdU9OCgBH+39JVD
 lKcpQ5HVRBNMSLmaIb10wO5HEN8+uE5pBNlG97Zi4UIIqSMi1S3JbEJnFWiB/OwHf5i2 Tg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wtbqg1qn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 11:41:28 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 10 Dec
 2019 11:41:27 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.53) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 10 Dec 2019 11:41:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YskS4UjYYP0fqDaacCsVQh6WaGVNLrkRmirSBnuwEl7zMbBusuuUtN8znXBDTtZ/VfPlCEZdBN9C3Xnfju08IsvC6dO6hS+lNJSRhbFiXwrVbZoB6CUV3dJSuL4AMr0Uqg0z1+YF/KfPNNlxr8nA53kRVdLxXIei4oFQIWI8T0KUqKHJKxu/y/hbE143UyQI4uN+rB2P/PqlKXuP2Wi0b+3ij78mS+UnZDSNXrIAGB4lA2yGTbjpXgVrzuzN6u1lhqwqZQDV76gzwq1PzGK01087+ceNHJB87xkCOukuxjILlHKDDPyxkG/WtxJr9luUTYm3dB/pMpLcEH8eFVB5oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQqoDWiCS9Pw0vUB1whyiEi7kYCGe+Iz+DJpCpfXAN0=;
 b=Hfwmx8e6iclIe29UJUDAiEW06v4IGYP36+cHRCqr6DVLDYglZDzlocQnf5HtWF9srNu15W7YwSE9M0jZWtWkx0CBy2jA7MRR9iEddmkrsrFZUGE3TFRkhdZxHF04I2F2SAn4tqKa8peowe+kPliEnVfVqPWffaANCgXXFPoqdrzo2sNf1Z3hjrRtroPs3GM3NKDW/8QQgK8Fv4/X24dooeQKgQ83rfUJfqt85VIEBTSV+EGIpKqkTBIDYFdtq32diuNSnsoC/C7RfrWhVdo+vweM/tiT3DY8UV4Ej1PsV9gs5kVzd1lorH6nIMVDE40TH2I9VNcM5NeLfWuC+8e8fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQqoDWiCS9Pw0vUB1whyiEi7kYCGe+Iz+DJpCpfXAN0=;
 b=SYYtTjGxhOuZRASVGmzwXYoHbN7UeDXgjpggaJMD9CsKaUFPQLS+5nP2tTbYEg36uyc+FaVS7Bpnq35pjwcGHOOgPXqXWbK4bpQPt5bygD+MNKlVRYp2oG9F9EQzGMPpGh46D8c8PZRjCQSzuEnGgWe4xSlW+ySvFT5uLZk1c6I=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2671.namprd18.prod.outlook.com (20.179.84.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 19:41:25 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::eda7:1699:29f1:9eb8]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::eda7:1699:29f1:9eb8%5]) with mapi id 15.20.2538.012; Tue, 10 Dec 2019
 19:41:25 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 2/4] qla2xxx: Simplify the code for aborting SCSI commands
Thread-Topic: [PATCH 2/4] qla2xxx: Simplify the code for aborting SCSI
 commands
Thread-Index: AQHVrrrkv6SN9ZDX+UmUx63qwj5HI6ezYZEA
Date:   Tue, 10 Dec 2019 19:41:25 +0000
Message-ID: <D468C0DF-7ABC-45F3-B1C5-A751F4E21636@marvell.com>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-3-bvanassche@acm.org>
In-Reply-To: <20191209180223.194959-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [66.73.206.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89dd3596-b410-4519-902e-08d77da8f17c
x-ms-traffictypediagnostic: MN2PR18MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2671920285A147AFE600838DD65B0@MN2PR18MB2671.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(199004)(189003)(2616005)(478600001)(6486002)(91956017)(110136005)(36756003)(54906003)(33656002)(4326008)(6512007)(26005)(2906002)(86362001)(186003)(6506007)(66946007)(64756008)(76116006)(66556008)(316002)(81156014)(8936002)(71200400001)(66476007)(81166006)(5660300002)(66446008)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2671;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hN/9ik6FCyrPJ49x6iFc5MHg/ZQuPVg2TCczgs3e0bUcThzQYoPN7OOQ4I46KmG+h+8hJwYKFLFsf8+t+hADKlG626YlbkRSXJoFeyycYcU94hK2Ar/Q/Xmikt3eYUXHPJQhUi4DpHIMK4ndHCmjgRgIiQDa08JDG5yIwkz9+0VAv3kKQrirlVnMofvvPURdVFj7dn1ft0s3bTKXS2gILD835jiD4aiKBFBRDMu4PBskYOWA2V9CbHAgA2YnHe+eN2qHRM0GZc2q43bYRcNgCO6eAK8ABpx+4b0ZwffzAJEDfZnBO8TJN3k3dt2o46oUZChcxkDLOYFBH3uDTFyY7oHCYocZaBXEIVFmSwomH/SFQqGGtSZxXKmJbJgI/LWpiijKu28zliCe5acbFbheDKmR/MB3Kk2gxvyT0Lx4IoSHDUoZSdDIY/wYjhEfV8Uz
Content-Type: text/plain; charset="utf-8"
Content-ID: <7269896C8FD81342A588140B12B1F18A@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 89dd3596-b410-4519-902e-08d77da8f17c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 19:41:25.4695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ID8wm561yya1vr/uxwx2+I3qcrAUyjsrBK27cAErUHlabB/ko0v6Uu20N9+kn1+657Awo4E4XxOeGk8mKYwTsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2671
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_06:2019-12-10,2019-12-10 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDEyLzkvMTksIDEyOjAyIFBNLCAibGludXgtc2NzaS1vd25lckB2Z2VyLmtlcm5l
bC5vcmcgb24gYmVoYWxmIG9mIEJhcnQgVmFuIEFzc2NoZSIgPGxpbnV4LXNjc2ktb3duZXJAdmdl
ci5rZXJuZWwub3JnIG9uIGJlaGFsZiBvZiBidmFuYXNzY2hlQGFjbS5vcmc+IHdyb3RlOg0KDQog
ICAgU2luY2UgdGhlIFNDU0kgY29yZSBkb2VzIG5vdCByZXVzZSB0aGUgdGFnIG9mIHRoZSBTQ1NJ
IGNvbW1hbmQgdGhhdCBpcw0KICAgIGJlaW5nIGFib3J0ZWQgYnkgLmVoX2Fib3J0KCkgYmVmb3Jl
IC5laF9hYm9ydCgpIGhhcyBmaW5pc2hlZCBpdCBpcyBub3QNCiAgICBuZWNlc3NhcnkgdG8gY2hl
Y2sgZnJvbSBpbnNpZGUgdGhhdCBjYWxsYmFjayB3aGV0aGVyIG9yIG5vdCB0aGUgU0NTSSBjb21t
YW5kDQogICAgaGFzIGFscmVhZHkgY29tcGxldGVkLiBJbnN0ZWFkLCByZWx5IG9uIHRoZSBmaXJt
d2FyZSB0byByZXR1cm4gYW4gZXJyb3IgY29kZQ0KICAgIHdoZW4gYXR0ZW1wdGluZyB0byBhYm9y
dCBhIGNvbW1hbmQgdGhhdCBoYXMgYWxyZWFkeSBjb21wbGV0ZWQuIEFkZGl0aW9uYWxseSwNCiAg
ICByZWx5IG9uIHRoZSBmaXJtd2FyZSB0byByZXR1cm4gYW4gZXJyb3IgY29kZSB3aGVuIGF0dGVt
cHRpbmcgdG8gYWJvcnQgYW4NCiAgICBhbHJlYWR5IGFib3J0ZWQgY29tbWFuZC4NCiAgICANCiAg
ICBJbiBxbGEyeDAwX2Fib3J0X3NyYigpLCB1c2UgYmxrX21xX3JlcXVlc3Rfc3RhcnRlZCgpIGlu
c3RlYWQgb2YNCiAgICBzcC0+Y29tcGxldGVkIGFuZCBzcC0+YWJvcnRlZC4NCiAgICANCiAgICBU
aGlzIHBhdGNoIGVsaW1pbmF0ZXMgc2V2ZXJhbCByYWNlIGNvbmRpdGlvbnMgdHJpZ2dlcmVkIGJ5
IHRoZSByZW1vdmVkIG1lbWJlcg0KICAgIHZhcmlhYmxlcy4NCiAgICANCiAgICBDYzogUXVpbm4g
VHJhbiA8cXV0cmFuQG1hcnZlbGwuY29tPg0KICAgIENjOiBNYXJ0aW4gV2lsY2sgPG13aWxja0Bz
dXNlLmNvbT4NCiAgICBDYzogRGFuaWVsIFdhZ25lciA8ZHdhZ25lckBzdXNlLmRlPg0KICAgIENj
OiBSb21hbiBCb2xzaGFrb3YgPHIuYm9sc2hha292QHlhZHJvLmNvbT4NCiAgICBTaWduZWQtb2Zm
LWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCiAgICAtLS0NCiAgICAg
ZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2RlZi5oIHwgIDMgLS0tDQogICAgIGRyaXZlcnMvc2Nz
aS9xbGEyeHh4L3FsYV9pc3IuYyB8ICA1IC0tLS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9vcy5jICB8IDE1ICsrLS0tLS0tLS0tLS0tLQ0KICAgICAzIGZpbGVzIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMjEgZGVsZXRpb25zKC0pDQogICAgDQogICAgZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaCBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9k
ZWYuaA0KICAgIGluZGV4IDQ2MGY0NDNmNjQ3MS4uYWI3NDI0MzE4ZWU4IDEwMDY0NA0KICAgIC0t
LSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaA0KICAgICsrKyBiL2RyaXZlcnMvc2Nz
aS9xbGEyeHh4L3FsYV9kZWYuaA0KICAgIEBAIC01OTcsOSArNTk3LDYgQEAgdHlwZWRlZiBzdHJ1
Y3Qgc3JiIHsNCiAgICAgCXN0cnVjdCBmY19wb3J0ICpmY3BvcnQ7DQogICAgIAlzdHJ1Y3Qgc2Nz
aV9xbGFfaG9zdCAqdmhhOw0KICAgICAJdW5zaWduZWQgaW50IHN0YXJ0X3RpbWVyOjE7DQogICAg
LQl1bnNpZ25lZCBpbnQgYWJvcnQ6MTsNCiAgICAtCXVuc2lnbmVkIGludCBhYm9ydGVkOjE7DQog
ICAgLQl1bnNpZ25lZCBpbnQgY29tcGxldGVkOjE7DQogICAgIA0KICAgICAJdWludDMyX3QgaGFu
ZGxlOw0KICAgICAJdWludDE2X3QgZmxhZ3M7DQogICAgZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS9xbGEyeHh4L3FsYV9pc3IuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYw0KICAg
IGluZGV4IDI2MDFkNzY3M2MzNy4uNzIxYThkODNlMzUwIDEwMDY0NA0KICAgIC0tLSBhL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYw0KICAgICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9pc3IuYw0KICAgIEBAIC0yNDg3LDExICsyNDg3LDYgQEAgcWxhMngwMF9zdGF0dXNfZW50
cnkoc2NzaV9xbGFfaG9zdF90ICp2aGEsIHN0cnVjdCByc3BfcXVlICpyc3AsIHZvaWQgKnBrdCkN
CiAgICAgCQlyZXR1cm47DQogICAgIAl9DQogICAgIA0KICAgIC0JaWYgKHNwLT5hYm9ydCkNCiAg
ICAtCQlzcC0+YWJvcnRlZCA9IDE7DQogICAgLQllbHNlDQogICAgLQkJc3AtPmNvbXBsZXRlZCA9
IDE7DQogICAgLQ0KICAgICAJaWYgKHNwLT5jbWRfdHlwZSAhPSBUWVBFX1NSQikgew0KICAgICAJ
CXJlcS0+b3V0c3RhbmRpbmdfY21kc1toYW5kbGVdID0gTlVMTDsNCiAgICAgCQlxbF9kYmcocWxf
ZGJnX2lvLCB2aGEsIDB4MzAxNSwNCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX29zLmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYw0KICAgIGluZGV4IDE0
NWVhOTMyMDZmMC4uMjIzMWQ5OWQzMTFiIDEwMDY0NA0KICAgIC0tLSBhL2RyaXZlcnMvc2NzaS9x
bGEyeHh4L3FsYV9vcy5jDQogICAgKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMN
CiAgICBAQCAtMTI1MywxNyArMTI1Myw2IEBAIHFsYTJ4eHhfZWhfYWJvcnQoc3RydWN0IHNjc2lf
Y21uZCAqY21kKQ0KICAgICAJCXJldHVybiBTVUNDRVNTOw0KICAgICANCiAgICAgCXNwaW5fbG9j
a19pcnFzYXZlKHFwYWlyLT5xcF9sb2NrX3B0ciwgZmxhZ3MpOw0KICAgIC0JaWYgKHNwLT5jb21w
bGV0ZWQpIHsNCiAgICAtCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKHFwYWlyLT5xcF9sb2NrX3B0
ciwgZmxhZ3MpOw0KICAgIC0JCXJldHVybiBTVUNDRVNTOw0KICAgIC0JfQ0KICAgIC0NCiAgICAt
CWlmIChzcC0+YWJvcnQgfHwgc3AtPmFib3J0ZWQpIHsNCiAgICAtCQlzcGluX3VubG9ja19pcnFy
ZXN0b3JlKHFwYWlyLT5xcF9sb2NrX3B0ciwgZmxhZ3MpOw0KICAgIC0JCXJldHVybiBGQUlMRUQ7
DQogICAgLQl9DQogICAgLQ0KICAgIC0Jc3AtPmFib3J0ID0gMTsNCiAgICAgCXNwLT5jb21wID0g
JmNvbXA7DQogICAgIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKHFwYWlyLT5xcF9sb2NrX3B0ciwg
ZmxhZ3MpOw0KICAgICANCiAgICBAQCAtMTY5Niw2ICsxNjg1LDcgQEAgc3RhdGljIHZvaWQgcWxh
MngwMF9hYm9ydF9zcmIoc3RydWN0IHFsYV9xcGFpciAqcXAsIHNyYl90ICpzcCwgY29uc3QgaW50
IHJlcywNCiAgICAgCURFQ0xBUkVfQ09NUExFVElPTl9PTlNUQUNLKGNvbXApOw0KICAgICAJc2Nz
aV9xbGFfaG9zdF90ICp2aGEgPSBxcC0+dmhhOw0KICAgICAJc3RydWN0IHFsYV9od19kYXRhICpo
YSA9IHZoYS0+aHc7DQogICAgKwlzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQgPSBHRVRfQ01EX1NQKHNw
KTsNCiAgICAgCWludCBydmFsOw0KICAgICAJYm9vbCByZXRfY21kOw0KICAgICAJdWludDMyX3Qg
cmF0b3ZfajsNCiAgICBAQCAtMTcxNyw3ICsxNzA3LDYgQEAgc3RhdGljIHZvaWQgcWxhMngwMF9h
Ym9ydF9zcmIoc3RydWN0IHFsYV9xcGFpciAqcXAsIHNyYl90ICpzcCwgY29uc3QgaW50IHJlcywN
CiAgICAgCQl9DQogICAgIA0KICAgICAJCXNwLT5jb21wID0gJmNvbXA7DQogICAgLQkJc3AtPmFi
b3J0ID0gIDE7DQogICAgIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShxcC0+cXBfbG9ja19wdHIs
ICpmbGFncyk7DQogICAgIA0KICAgICAJCXJ2YWwgPSBoYS0+aXNwX29wcy0+YWJvcnRfY29tbWFu
ZChzcCk7DQogICAgQEAgLTE3NDEsNyArMTczMCw3IEBAIHN0YXRpYyB2b2lkIHFsYTJ4MDBfYWJv
cnRfc3JiKHN0cnVjdCBxbGFfcXBhaXIgKnFwLCBzcmJfdCAqc3AsIGNvbnN0IGludCByZXMsDQog
ICAgIAkJfQ0KICAgICANCiAgICAgCQlzcGluX2xvY2tfaXJxc2F2ZShxcC0+cXBfbG9ja19wdHIs
ICpmbGFncyk7DQogICAgLQkJaWYgKHJldF9jbWQgJiYgKCFzcC0+Y29tcGxldGVkIHx8ICFzcC0+
YWJvcnRlZCkpDQogICAgKwkJaWYgKHJldF9jbWQgJiYgYmxrX21xX3JlcXVlc3Rfc3RhcnRlZChj
bWQtPnJlcXVlc3QpKQ0KICAgICAJCQlzcC0+ZG9uZShzcCwgcmVzKTsNCiAgICAgCX0gZWxzZSB7
DQogICAgIAkJc3AtPmRvbmUoc3AsIHJlcyk7DQogICAgDQpBY2tlZC1CeTogSGltYW5zaHUgTWFk
aGFuaSA8aG1hZGhhbmlAbWFydmVsbC5jb20+DQoNCg==
