Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2895C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 16:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93D822085B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 16:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="s3ZvolP0";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="oN/iFDxP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfKGQqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 11:46:40 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51318 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729451AbfKGQqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 11:46:40 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7GjflM013841;
        Thu, 7 Nov 2019 08:46:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=SsI8U9B6X2rGQSpdnRtETIoHXoyH3ErvorYXxU8urm4=;
 b=s3ZvolP0XZV0h0u2GC/vy0DGe85SW7OMPi3N0dGPGPTTmgJKNfuFqlN53orTn5K3HCKm
 SYxz4RBtDMqRvMPNNxxSh4uE5tQLlqkTyV5OvejEeMMoZKwhPI8eGqaS8L2e2cscdg5n
 4m9EgdXyk0HS8Eeuy+wUnahVcaY9T9maGJGdeCLPS38aQRqWi5sGOuclveZk/GTZ3uvE
 OVKhwF3PtYtNSbkK7qgny6Romx1HvvheftIh9EGLj5pBidH0tzxZ0++HDCxON7bIvBzO
 tSyrlt9NYQZUJNkI0aYMc75nEufZVaCLLdedHXr/GCOLxMK9VTlSA6j7AIF0vpEQDIgc cA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w4fq6su0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 08:46:30 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 08:46:28 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.57) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 08:46:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3hVdZ2RAEaoElhhE5rzPX4Q8nl7C/vQ/4bmUHqTMFTeOyiQq4YkYOaK3x2GyovQcf/0q7K4i+hgZwK8+pMeFUkvQOfJqsykUasJegtanWjOA79Wut4bNDLzRL6y3qbql6fDzDBtCrwgxnY0N2U97ej7oG2rv1ieylnSBNk/z4eks8eTpk20hjIkPXL0dF+NP07/Ahsa8UGeiZZkcJ39PwKfWN3geMWxpcbTyyaUTwfFArpO6nz9nQ/7hejvJ7k4+HktZm5DbsBvNifjGGhK1fDczAF6cpvDVBfl67C6H/yObalR778hhzAvzqrlbzsDr6IyFrR5SSocS7lJa7dXZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SsI8U9B6X2rGQSpdnRtETIoHXoyH3ErvorYXxU8urm4=;
 b=ZLVtbKfS62ru+Oz39Z08IElBu1p4BNb1YiUmZdXijK8Cvr7Tk3LLyxVFMe5HAktcV0G3yu7bp8ctgcaU+jLwKSJjmJeZC5upesvEv5nijSBcbA9o4WYKUuN3lwZ4EiPHJYb6GxlNE1Y1bHRbfVIzMESNm0HwXtZJHm1zc4xpCKZcSdBb1U0TO88jZ6tSI6xz8C5/fTsXw3yg+ZnRX5RnBP5WJTu98u6j9oN9B3KEjCjnHAHZitHQW5Yk4OpHrwD5QfmoLuj3XH9zhTn/UP7UfKY1FLjYdo04HS6ELIPGZpJONgV+zljp/8VZbtOA/hjHUR/PIrdiUdpa9OpRvcreUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SsI8U9B6X2rGQSpdnRtETIoHXoyH3ErvorYXxU8urm4=;
 b=oN/iFDxPzgKZP7jJPJifA9wxXlRZ67dTLddIUkoVupMETB26wS7hlcK43jzNBXKs3SryvKMuYAQPdFS46je0nZJePGXcDD4uaRa8/JdjFHhmsLAS2LI7XYpfiDD0TNlYOazpV/ee5Ondjyiss6YUFHHmh27XxXoKiLPTDBSdStc=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2960.namprd18.prod.outlook.com (20.179.22.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Thu, 7 Nov 2019 16:46:26 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2430.023; Thu, 7 Nov 2019
 16:46:26 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "<James.Bottomley@hansenpartnership.com>" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] [PATCH 2/8] qla2xxx: Do command completion on abort timeout
Thread-Topic: [EXT] [PATCH 2/8] qla2xxx: Do command completion on abort
 timeout
Thread-Index: AQHVlYrlthD256FvTkKwkrjchY6MfQ==
Date:   Thu, 7 Nov 2019 16:46:26 +0000
Message-ID: <18812620-026F-4A2F-87CD-EFDF3A16684A@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
 <20191105150657.8092-3-hmadhani@marvell.com>
 <51483fdc-f102-0a08-7c19-d3e9f1792a86@acm.org>
In-Reply-To: <51483fdc-f102-0a08-7c19-d3e9f1792a86@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2600:1700:211:eb30:89ae:d606:9fa5:b6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cad73641-c4df-4d4a-5f61-08d763a207ff
x-ms-traffictypediagnostic: MN2PR18MB2960:
x-microsoft-antispam-prvs: <MN2PR18MB29603C752943F2E6FD5A1CF3D6780@MN2PR18MB2960.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(2906002)(486006)(53546011)(14454004)(256004)(76176011)(25786009)(46003)(6506007)(7736002)(11346002)(186003)(305945005)(2616005)(6916009)(476003)(229853002)(6116002)(102836004)(8936002)(33656002)(76116006)(6436002)(6486002)(66946007)(316002)(71200400001)(6512007)(86362001)(446003)(6246003)(71190400001)(5660300002)(50226002)(478600001)(8676002)(81156014)(91956017)(66446008)(64756008)(66476007)(66556008)(81166006)(99286004)(14444005)(36756003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2960;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vCo/LO5wZlhnQe2E1S2wfmoLHS4xYSAqh6kZhskZmUl5fmlJoBPfUi1904fQ/MmMQW/tqC3JwhULKC9mysxspuHLna3iC28WlIE5A84qmnKQP5jYokcJsbqLVBSOkmzm5NZ748PPTGdY4/ApNXgOtB1bNG7lZG/UsDwrwMm3G2i+vqww5p5gWkbDHRX1eJymQYQc1QyeAx9C68aA+6wRXZDHI7LhlLQMO9j6Keg3iStXHcZ0oIdXuFmRUj9qbxhCw933SWJauluM7j915rErn6+p9zLuVGINAxcWZhSvycMkaenvGtvbQaorrN18d6ry5tOWX//sCK/8JOSE21lcCM3tbpoqnelb9YCcEg+cSB66A+VQGGcqgwXWCgAZz6VidjSYLMf39l6SRtY2jTnGWDMRgaBS7VBTOS9u5Q0PhtksvIJWAlqKuPMhKK0k83KV
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F0792184CF7FC4196BD9EA310A2A459@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cad73641-c4df-4d4a-5f61-08d763a207ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 16:46:26.4743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /oBEQ3AEmt4YdIzVz3tkXn1qsCq6d0QbynPWB4TXzktUHQTSvcMZ+RljHvG8c7Z1qaA9K5ZGtRn0W/gQq7moAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2960
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_05:2019-11-07,2019-11-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QmFydCwNCg0KDQo+IE9uIE5vdiA1LCAyMDE5LCBhdCAxMDo1NyBBTSwgQmFydCBWYW4gQXNzY2hl
IDxidmFuYXNzY2hlQGFjbS5vcmc+IHdyb3RlOg0KPiANCj4gRXh0ZXJuYWwgRW1haWwNCj4gDQo+
IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCj4gT24gMTEvNS8xOSA3OjA2IEFNLCBIaW1hbnNodSBNYWRoYW5pIHdy
b3RlOg0KPj4gRnJvbTogUXVpbm4gVHJhbiA8cXV0cmFuQG1hcnZlbGwuY29tPg0KPj4gT24gc3dp
dGNoLCBmYWJyaWMgYW5kIG1ndCBjb21tYW5kIHRpbWVvdXQsIGRyaXZlcg0KPj4gc2VuZCBBYm9y
dCB0byB0ZWxsIEZXIHRvIHJldHVybiB0aGUgb3JpZ2luYWwgY29tbWFuZC4NCj4+IElmIGFib3J0
IGlzIHRpbWVvdXQsIHRoZW4gcmV0dXJuIGJvdGggQWJvcnQgYW5kDQo+PiBvcmlnaW5hbCBjb21t
YW5kIGZvciBjbGVhbnVwLg0KPj4gRml4ZXM6IDIxOWQyN2Q3MTQ3ZTAgKCJzY3NpOiBxbGEyeHh4
OiBGaXggcmFjZSBjb25kaXRpb25zIGluIHRoZSBjb2RlIGZvciBhYm9ydGluZyBTQ1NJIGNvbW1h
bmRzIikNCj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgNS4yDQo+PiBTaWduZWQtb2Zm
LWJ5OiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBI
aW1hbnNodSBNYWRoYW5pIDxobWFkaGFuaUBtYXJ2ZWxsLmNvbT4NCj4+IC0tLQ0KPj4gIGRyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaCAgfCAgMSArDQo+PiAgZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX2luaXQuYyB8IDE4ICsrKysrKysrKysrKysrKysrKw0KPj4gIDIgZmlsZXMgY2hhbmdl
ZCwgMTkgaW5zZXJ0aW9ucygrKQ0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9kZWYuaCBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaA0KPj4gaW5kZXggNzIx
ZWU3ZjA5YjM5Li5lZjliYjNjN2FkNmYgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxh
Mnh4eC9xbGFfZGVmLmgNCj4+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaA0K
Pj4gQEAgLTYwNCw2ICs2MDQsNyBAQCB0eXBlZGVmIHN0cnVjdCBzcmIgew0KPj4gIAljb25zdCBj
aGFyICpuYW1lOw0KPj4gIAlpbnQgaW9jYnM7DQo+PiAgCXN0cnVjdCBxbGFfcXBhaXIgKnFwYWly
Ow0KPj4gKwlzdHJ1Y3Qgc3JiICpjbWRfc3A7DQo+PiAgCXN0cnVjdCBsaXN0X2hlYWQgZWxlbTsN
Cj4+ICAJdTMyIGdlbjE7CS8qIHNjcmF0Y2ggKi8NCj4+ICAJdTMyIGdlbjI7CS8qIHNjcmF0Y2gg
Ki8NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jIGIvZHJp
dmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KPj4gaW5kZXggNWRiOGFkODMyODkzLi43ZmRi
ZTA0MWNjMTkgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5j
DQo+PiArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jDQo+PiBAQCAtMTAxLDgg
KzEwMSwyMiBAQCBzdGF0aWMgdm9pZCBxbGEyNHh4X2Fib3J0X2lvY2JfdGltZW91dCh2b2lkICpk
YXRhKQ0KPj4gIAl1MzIgaGFuZGxlOw0KPj4gIAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPj4gICsJ
aWYgKHNwLT5jbWRfc3ApDQo+PiArCQlxbF9kYmcocWxfZGJnX2FzeW5jLCBzcC0+dmhhLCAweDUw
N2MsDQo+PiArCQkgICAgIkFib3J0IHRpbWVvdXQgLSBjbWQgaGRsPSV4LCBjbWQgdHlwZT0leCBo
ZGw9JXgsIHR5cGU9JXhcbiIsDQo+PiArCQkgICAgc3AtPmNtZF9zcC0+aGFuZGxlLCBzcC0+Y21k
X3NwLT50eXBlLA0KPj4gKwkJICAgIHNwLT5oYW5kbGUsIHNwLT50eXBlKTsNCj4+ICsJZWxzZQ0K
Pj4gKwkJcWxfZGJnKHFsX2RiZ19hc3luYywgc3AtPnZoYSwgMHg1MDdjLA0KPj4gKwkJICAgICJB
Ym9ydCB0aW1lb3V0IDIgLSBoZGw9JXgsIHR5cGU9JXhcbiIsDQo+PiArCQkgICAgc3AtPmhhbmRs
ZSwgc3AtPnR5cGUpOw0KPj4gKw0KPj4gIAlzcGluX2xvY2tfaXJxc2F2ZShxcGFpci0+cXBfbG9j
a19wdHIsIGZsYWdzKTsNCj4+ICAJZm9yIChoYW5kbGUgPSAxOyBoYW5kbGUgPCBxcGFpci0+cmVx
LT5udW1fb3V0c3RhbmRpbmdfY21kczsgaGFuZGxlKyspIHsNCj4+ICsJCWlmIChzcC0+Y21kX3Nw
ICYmIChxcGFpci0+cmVxLT5vdXRzdGFuZGluZ19jbWRzW2hhbmRsZV0gPT0NCj4+ICsJCSAgICBz
cC0+Y21kX3NwKSkNCj4+ICsJCQlxcGFpci0+cmVxLT5vdXRzdGFuZGluZ19jbWRzW2hhbmRsZV0g
PSBOVUxMOw0KPj4gKw0KPj4gIAkJLyogcmVtb3ZpbmcgdGhlIGFib3J0ICovDQo+PiAgCQlpZiAo
cXBhaXItPnJlcS0+b3V0c3RhbmRpbmdfY21kc1toYW5kbGVdID09IHNwKSB7DQo+PiAgCQkJcXBh
aXItPnJlcS0+b3V0c3RhbmRpbmdfY21kc1toYW5kbGVdID0gTlVMTDsNCj4+IEBAIC0xMTEsNiAr
MTI1LDkgQEAgc3RhdGljIHZvaWQgcWxhMjR4eF9hYm9ydF9pb2NiX3RpbWVvdXQodm9pZCAqZGF0
YSkNCj4+ICAJfQ0KPj4gIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKHFwYWlyLT5xcF9sb2NrX3B0
ciwgZmxhZ3MpOw0KPj4gICsJaWYgKHNwLT5jbWRfc3ApDQo+PiArCQlzcC0+Y21kX3NwLT5kb25l
KHNwLT5jbWRfc3AsIFFMQV9PU19USU1FUl9FWFBJUkVEKTsNCj4+ICsNCj4+ICAJYWJ0LT51LmFi
dC5jb21wX3N0YXR1cyA9IENTX1RJTUVPVVQ7DQo+PiAgCXNwLT5kb25lKHNwLCBRTEFfT1NfVElN
RVJfRVhQSVJFRCk7DQo+PiAgfQ0KPj4gQEAgLTE0Miw2ICsxNTksNyBAQCBzdGF0aWMgaW50IHFs
YTI0eHhfYXN5bmNfYWJvcnRfY21kKHNyYl90ICpjbWRfc3AsIGJvb2wgd2FpdCkNCj4+ICAJc3At
PnR5cGUgPSBTUkJfQUJUX0NNRDsNCj4+ICAJc3AtPm5hbWUgPSAiYWJvcnQiOw0KPj4gIAlzcC0+
cXBhaXIgPSBjbWRfc3AtPnFwYWlyOw0KPj4gKwlzcC0+Y21kX3NwID0gY21kX3NwOw0KPj4gIAlp
ZiAod2FpdCkNCj4+ICAJCXNwLT5mbGFncyA9IFNSQl9XQUtFVVBfT05fQ09NUDsNCj4+ICANCj4g
DQo+IEFmdGVyIGFuIGFib3J0IFNSQiBoYXMgYmVlbiBzdWJtaXR0ZWQgaXQgY2FuIGhhcHBlbiB0
aGF0IHRoZSBjb21tYW5kIHRoYXQgc2hvdWxkIGJlIGFib3J0ZWQgKGNtZF9zcCkgY29tcGxldGVz
IGJlZm9yZSB0aGUgYWJvcnQgU1JCIGNvbXBsZXRlcy4gSSB0aGluayBpbiB0aGF0IGNhc2Ugc3At
PmNtZF9zcCBzaG91bGQgYmUgY2xlYXJlZC4gSG93ZXZlciwgSSBkb24ndCBzZWUgdGhlIGNvZGUg
dGhhdCBkb2VzIHRoYXQgaW4gdGhlIGFib3ZlIHBhdGNoLg0KPiANCg0KR29vZCBwb2ludCB0aGVy
ZSBhbmQgYWdyZWUgdGhhdCB0aGVyZSBpcyBhIHNtYWxsIHdpbmRvdyB3aGVyZSB3ZSBhcmUgbm90
IGNsZWFyaW5nIHRoZSBjbWRfc3Agd2hlbiB0aGUgb3JpZ2luYWwgY29tbWFuZCBpcyBjb21wbGV0
ZWQuIEhvd2V2ZXIgZm9yIHRoaXMgc2VyaWVzLCBJIHdvdWxkIGxpa2UgdG8gaGF2ZSB0aGlzIHBh
dGNoIG1lcmdlZCBhcy1pcyBhbmQgd2XigJlsbCBzZW5kIGEgZm9sbG93IHVwIHBhdGNoIHRvIGNv
dmVyIHRoYXQgd2luZG93LiBXZSBhcmUgZG9pbmcgbW9yZSBjbGVhbnVwIGluIHRoZSBhYm9ydCBo
YW5kbGluZyBjb2RlIHBhdGggdG8gbWFrZSBpdCBtb3JlIHJvYnVzdC4gVGhpcyB3b3VsZCBiZSBn
b29kIGNhbmRpZGF0ZSBmb3IgdGhhdCBzZXJpZXMuIA0KDQo+IFNpbmNlIHRoZSBibG9jayBsYXll
ciBhbHJlYWR5IGtlZXBzIHRyYWNrIG9mIHdoaWNoIGNvbW1hbmRzIGFyZSBvdXRzdGFuZGluZywg
aXMgaXQgcmVhbGx5IG5lY2Vzc2FyeSB0byBhZGQgdGhlICdjbWRfc3AnIHBvaW50ZXIgaW4gc3Ry
dWN0IHNyYj8gSGFzIGl0IGJlZW4gY29uc2lkZXJlZCB0byB1c2UgYmxrX21xX3RhZ3NldF9idXN5
X2l0ZXIoKSBpbnN0ZWFkIG9mIGl0ZXJhdGluZyBvdmVyIHFwYWlyLT5yZXEtPm51bV9vdXRzdGFu
ZGluZ19jbWRzIGluIHFsYTI0eHhfYWJvcnRfaW9jYl90aW1lb3V0KCk/DQo+IA0KDQpZb3VyIHN1
Z2dlc3Rpb24gdG8gY29uc2lkZXIgYmxrX21xX3RhZ3NldF9idXN5X2l0ZXIoKSBpcyBjb3JyZWN0
IGZvciB0aGUgY29tbWFuZHMgZnJvbSBibG9jayBsYXllci4gSG93ZXZlciwgcXBhaXItPnJlcS0+
bnVtX291dHN0YW5kaW5nX2NtZHMgaXMgdGhlIHFsYTJ4eHggZHJpdmVy4oCZcyBjb21tZW5kIGFy
cmF5IHRvIGtlZXAgdHJhY2sgb2Ygd2hpY2ggY29tbWFuZHMgdGhhdCBkcml2ZXIgbmVlZHMgdG8g
cHJvY2VzcyBhbmQgc28gd2UgZG8gbmVlZCB0byBpdGVyYXRlIG92ZXIgaXQgYW5kIHRyYWNrIHRo
ZSBjb21tYW5kcyB0aGF0IHdlIG5lZWQgdG8gc2VuZCBhYm9ydHMgZm9yLiANCg0KLSBIaW1hbnNo
dQ0KDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo+IA0KPiANCg0K
