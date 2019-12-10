Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795E8C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 19:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42D8020828
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 19:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RTS/eWHL";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="o2n9GAL5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfLJTk6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 14:40:58 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24176 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbfLJTk5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 14:40:57 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBAJYJjU011607;
        Tue, 10 Dec 2019 11:40:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=xTnUJ9ayyBfWSGLnJZvyCTDQEVNS6+97oL3e1acAGFE=;
 b=RTS/eWHLi9TEzHRUD3r6wf3QMi7ecuCQH9xZu4XOEMkw8o8CQAzTyJAA/aXPLpW9jAlw
 pjfK6siVHksYWm4t6XdHfIpxzRmohFYSaGHFTRSxg67t5+oOuKWY5ivLv+lPrHZ42xxS
 uYqqUqjtNuSFuAc8o98tbcjpLVBbkuvYBbPHUxFdnbV8Fedzv7vD1yXAjx+EBwuybRwy
 Z8CO1Uvi50/qiJYA7J46pzDTR7VCGpixPnG5c7aQgXOks9IeinUwYxrnk9LY4RbnKstj
 hiZ3xlYHocou/YvexdK052pD2l4WEM40Dre9Rxbus2j0nyPsqRVv/5WPAJaB6JtF7d8h gg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wtbqg1qgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 11:40:48 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 10 Dec
 2019 11:40:47 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 10 Dec 2019 11:40:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2f+Wbv9VkKUAxodKOtaA3NjovpK7GnM65Jurc9gzCho11fq2D8SdlNPyvBaWU1dSHP7u+Go6ZgUTOVWaG8rqrlhCDMykRzVQVlACEg/T3MUBVMEOVOH3u4U5vRn6uxBo53un/9z+gQZr5qwT/qPZjM2jhU+YBKZwWpq4bCGk8utzXyQQ3yYQttZDyG292ZHg+fMvowpyXi+nHbhVlUwLZQho3BgSKSUfVU5I/rtCed292a9Dlx0tTobO8Yx0utJUkcsmw/6uNdpq5+ypltfH1sPEoLIEhHnx56PYTIlvqetJuQKi8aZK9HfMcOYqXi574cOsPz5dg5nNueX4VIQ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTnUJ9ayyBfWSGLnJZvyCTDQEVNS6+97oL3e1acAGFE=;
 b=mTRC4Qv2Qzs65kWsCXAu/ZGIK4udydnqlnTSSN6EVne/Ss1ZvJGKYVqiCiyhz7NhCrtuXskPekdm/5xbQl0DzlVhez/ZHJQbFBc0O6vqUQH6lqBg8o9ukkJKfs82raGQH0goCk1cCtsgys/MCXEpG2JT8Qd3FfXB01DrO1PqqPXFZ+wY52Eky3JOVRs1PYjjzFnW0n3BOItOy4U2v6dAe71mqPGp2C4Dp+W1RV74SIy7Sw66LuShtvG8H/+kny1cz0qVhOdgRFkdLZiFJkHi5F5+4YT7IMV88aC3BaMHxNp0UnGX0kokOERunIvF0QPRJ/mwmwDQBwB6MJY0xgze/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTnUJ9ayyBfWSGLnJZvyCTDQEVNS6+97oL3e1acAGFE=;
 b=o2n9GAL5vF55MD7FL7wSiAC8vRkwAF8UuY6EGj5Z97nI3HeMseUfbVzPY2sAiq4ja8LN/hPFmUNtOIKQ4c3xXAiDrPQUrFbDWxRbYJLMw7jCUc3xCKrqYf1g6/2DtX/Zpevo4QMnLvBuXxiZu35xdZJk1AOPqk7rhQIUc4cFWaY=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3408.namprd18.prod.outlook.com (10.255.237.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Tue, 10 Dec 2019 19:40:45 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::eda7:1699:29f1:9eb8]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::eda7:1699:29f1:9eb8%5]) with mapi id 15.20.2538.012; Tue, 10 Dec 2019
 19:40:45 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 3/4] qla2xxx: Fix point-to-point mode for qla25xx and
 older
Thread-Topic: [PATCH 3/4] qla2xxx: Fix point-to-point mode for qla25xx and
 older
Thread-Index: AQHVrrrl3DrpW05440ODzDM31OgBuKezYWEA
Date:   Tue, 10 Dec 2019 19:40:45 +0000
Message-ID: <989C980E-981C-46B1-9B71-B4226EA3E687@marvell.com>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-4-bvanassche@acm.org>
In-Reply-To: <20191209180223.194959-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [66.73.206.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 498236fb-c006-4561-7f7b-08d77da8d977
x-ms-traffictypediagnostic: MN2PR18MB3408:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3408210D403275E8175A5E29D65B0@MN2PR18MB3408.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(189003)(199004)(66946007)(91956017)(76116006)(4326008)(8936002)(110136005)(2616005)(186003)(8676002)(86362001)(54906003)(36756003)(66446008)(64756008)(5660300002)(66556008)(66476007)(6486002)(33656002)(26005)(71200400001)(81156014)(6512007)(478600001)(2906002)(316002)(6506007)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3408;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9dpVC90AYpVxp0HQC0YqrMrjHqd15/1Hcs6Dxtxx9jGMklrh6BWJZ26EfeLGGV5nAcvmqi10PF6Fqv9x2EFrOtWtlBzQqhk4YDazERoMuEzNpLnIyu47P06eJnXdtA+ma2UuW/fQUjk1aMBJToP3VQQ3vtjmycuXCHIHSj93Yp0Ct2VLK7HG6aYQKlT2Gah3uWyu1AnfBKEygTmf1D48FIrDepVeEDvM/8Qo0+FPyM9QVpUq/QgWVpkCA/x5JukMy5uquLEM1c5bKGAW1DJyVyyE9kGlvQnB42GCVsPIzVbry+xzpDg0U+ApfiW9+6xqmU5x35DsHSgg0ck9lKgupQPU9niZjNLWK+BAqXBee+gv51ADTFEqFeqTGtfqTiUwJU0+/dsMLVV/HmtIVzMS5byzx5Kq371JSz6z0xKcMEY6MlU4blpflFRTABFZxmTF
Content-Type: text/plain; charset="utf-8"
Content-ID: <518120F651A6874DBB50C52B83416D74@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 498236fb-c006-4561-7f7b-08d77da8d977
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 19:40:45.1430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z3pYFzygfHgisaL0Yn8i0v1mEflnJB0mX9HLxU6Oer+pdQBj8x/7YNOoiZ4m7VppRFuSx7b1qqCJzav2mtBm0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3408
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_06:2019-12-10,2019-12-10 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDEyLzkvMTksIDEyOjAzIFBNLCAibGludXgtc2NzaS1vd25lckB2Z2VyLmtlcm5l
bC5vcmcgb24gYmVoYWxmIG9mIEJhcnQgVmFuIEFzc2NoZSIgPGxpbnV4LXNjc2ktb3duZXJAdmdl
ci5rZXJuZWwub3JnIG9uIGJlaGFsZiBvZiBidmFuYXNzY2hlQGFjbS5vcmc+IHdyb3RlOg0KDQog
ICAgUmVzdG9yZSBwb2ludC10by1wb2ludCBmb3IgcWxhMjV4eCBhbmQgb2xkZXIuIEFsdGhvdWdo
IHRoaXMgcGF0Y2ggaW5pdGlhbGl6ZXMNCiAgICBhIGZpZWxkIChzX2lkKSB0aGF0IGhhcyBiZWVu
IG1hcmtlZCBhcyAicmVzZXJ2ZWQiIGluIHRoZSBmaXJtd2FyZSBtYW51YWwsIGl0DQogICAgd29y
a3MgZmluZSBvbiBteSBzZXR1cC4NCiAgICANCiAgICBDYzogUXVpbm4gVHJhbiA8cXV0cmFuQG1h
cnZlbGwuY29tPg0KICAgIENjOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4NCiAgICBD
YzogRGFuaWVsIFdhZ25lciA8ZHdhZ25lckBzdXNlLmRlPg0KICAgIENjOiBSb21hbiBCb2xzaGFr
b3YgPHIuYm9sc2hha292QHlhZHJvLmNvbT4NCiAgICBGaXhlczogMGFhYmI2YjY5OWY3ICgic2Nz
aTogcWxhMnh4eDogRml4IE5wb3J0IElEIGRpc3BsYXkgdmFsdWUiKQ0KICAgIEZpeGVzOiBlZGQw
NWRlMTk3NTkgKCJzY3NpOiBxbGEyeHh4OiBDaGFuZ2VzIHRvIHN1cHBvcnQgTjJOIGxvZ2lucyIp
DQogICAgU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+
DQogICAgLS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMgfCAxNCArKysr
KysrKysrLS0tLQ0KICAgICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNCBkZWxl
dGlvbnMoLSkNCiAgICANCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X2lvY2IuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMNCiAgICBpbmRleCBiMjVm
ODdmZjhjZGUuLmUyZTkxYjNmMmU2NSAxMDA2NDQNCiAgICAtLS0gYS9kcml2ZXJzL3Njc2kvcWxh
Mnh4eC9xbGFfaW9jYi5jDQogICAgKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lvY2Iu
Yw0KICAgIEBAIC0yNjU2LDEwICsyNjU2LDE2IEBAIHFsYTI0eHhfZWxzX2xvZ29faW9jYihzcmJf
dCAqc3AsIHN0cnVjdCBlbHNfZW50cnlfMjR4eCAqZWxzX2lvY2IpDQogICAgIAllbHNfaW9jYi0+
cG9ydF9pZFswXSA9IHNwLT5mY3BvcnQtPmRfaWQuYi5hbF9wYTsNCiAgICAgCWVsc19pb2NiLT5w
b3J0X2lkWzFdID0gc3AtPmZjcG9ydC0+ZF9pZC5iLmFyZWE7DQogICAgIAllbHNfaW9jYi0+cG9y
dF9pZFsyXSA9IHNwLT5mY3BvcnQtPmRfaWQuYi5kb21haW47DQogICAgLQkvKiBGb3IgU0lEIHRo
ZSBieXRlIG9yZGVyIGlzIGRpZmZlcmVudCB0aGFuIERJRCAqLw0KICAgIC0JZWxzX2lvY2ItPnNf
aWRbMV0gPSB2aGEtPmRfaWQuYi5hbF9wYTsNCiAgICAtCWVsc19pb2NiLT5zX2lkWzJdID0gdmhh
LT5kX2lkLmIuYXJlYTsNCiAgICAtCWVsc19pb2NiLT5zX2lkWzBdID0gdmhhLT5kX2lkLmIuZG9t
YWluOw0KICAgICsJaWYgKElTX1FMQTIzWFgodmhhLT5odykgfHwgSVNfUUxBMjRYWCh2aGEtPmh3
KSB8fCBJU19RTEEyNVhYKHZoYS0+aHcpKSB7DQogICAgKwkJZWxzX2lvY2ItPnNfaWRbMF0gPSB2
aGEtPmRfaWQuYi5hbF9wYTsNCiAgICArCQllbHNfaW9jYi0+c19pZFsxXSA9IHZoYS0+ZF9pZC5i
LmFyZWE7DQogICAgKwkJZWxzX2lvY2ItPnNfaWRbMl0gPSB2aGEtPmRfaWQuYi5kb21haW47DQog
ICAgKwl9IGVsc2Ugew0KICAgICsJCS8qIEZvciBTSUQgdGhlIGJ5dGUgb3JkZXIgaXMgZGlmZmVy
ZW50IHRoYW4gRElEICovDQogICAgKwkJZWxzX2lvY2ItPnNfaWRbMV0gPSB2aGEtPmRfaWQuYi5h
bF9wYTsNCiAgICArCQllbHNfaW9jYi0+c19pZFsyXSA9IHZoYS0+ZF9pZC5iLmFyZWE7DQogICAg
KwkJZWxzX2lvY2ItPnNfaWRbMF0gPSB2aGEtPmRfaWQuYi5kb21haW47DQogICAgKwl9DQogICAg
IA0KICAgICAJaWYgKGVsc2lvLT51LmVsc19sb2dvLmVsc19jbWQgPT0gRUxTX0RDTURfUExPR0kp
IHsNCiAgICAgCQllbHNfaW9jYi0+Y29udHJvbF9mbGFncyA9IDA7DQogICAgDQpBY2tlZC1ieTog
SGltYW5zaHUgTWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5jb20+DQoNCg==
