Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8206EC432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 16:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E51E2072D
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 16:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QX7KaIGI";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="sTIDa7fI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKVQHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 11:07:14 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32404 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726546AbfKVQHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 11:07:14 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAMG6C3r003933;
        Fri, 22 Nov 2019 08:06:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=ok+BoyOWbINgXUwLeCtR/M1qQZHfQRjvCpiFVdnWg3g=;
 b=QX7KaIGIOXcgsyy3YhoNHKIrSs8qbHX55Um/lJITCoX5S4d1hdC6dwZszSn7i9v1oORg
 MXDjyxAv8fVq9jz0nCCqBws7LND2a+YQS/hycWkcymP9Arcmpw5fk3nC8qnkdU4t16X0
 uuhZ8jhl3iDkRxroO25ABGIZ7hd1BEfnmCkNK6Pvx5eOdcPQrIea2D0YHcWB02prfDuG
 NJotK7mVG8g7w2xvMGv3LylsIMI+yFqLYT6+Qy21G+G9SWvVBaNOMk0Hkxkyr0SeBSMC
 rlWxaqQLQlqj2kMUI6PbErzhNw7CwgZhFC/c/cZO8+s/wlEYDLGt37OlkW8H5Mmv250J Qw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2weafba50p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 Nov 2019 08:06:45 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 22 Nov
 2019 08:06:43 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.56) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 22 Nov 2019 08:06:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPlcvB0gu1co2aM3GN4OB9hQ8fXAVnZF8Gjg92W9hKY0VUQWWbjuRhMYZwprB6cchMWfyL2kitF4skWY+zPLN6hhnAeXTV1Ros2VHPrazcKTyMEQO8eaaZEXU1X8mD+k2scnsA2TNcsI3KjcSErkpz/XX+uQfAWAcjviFrmG52YelgbNvrdBOz1Nr8xi+JskvWRR1ez9AhI74PWtM1W/Mc2/ksvU5XrrFR9gq1POrCG+KYPISKi+a+vfr9jfAWctLhKeftIBleoxdsojEeFBiuAAjaWVEpe2Qi3kdCKIfYRTp5Ej/OKNvWXyJ/zgwrvMh6YQkdefstZoTMQmhE4Tpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ok+BoyOWbINgXUwLeCtR/M1qQZHfQRjvCpiFVdnWg3g=;
 b=UmBAAUsi8sVAIhr9nFjbGmOv6WUGQCXHT4mcqRBbJo5nLh0kd7YeOzE++tEwYMtsKNHQYKXXGXyd9ok9z2rnjkXDgxo7vHy+GiCiMHH1MNk9/D51/8sEJ45yuuQK1WlUN7iFaTYKJctU91r2UtJd2GHpq4//hrlCgOR3OjWxVvRkP7Pln/EDFpmUn5WqCrwtBHVfkXRNLEexF7WzM67mf21VQN0rdBk91ZvyWcMaCM1ban0JABFSK+nsJnzuxjq3dNVD7LnWtTY1szYQX2g5qURILYJjyDrMzcnt2MZh31f72IcEay6LFkvZHFjy80y2ORwKbOqxQXpx//hYdQYdqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ok+BoyOWbINgXUwLeCtR/M1qQZHfQRjvCpiFVdnWg3g=;
 b=sTIDa7fI2nV8omTqCghRx6vGBE4n1g7tPnUOvD8ytW9qjDn7LMYV2ewuG35vBJCX0SUnmz/Hek79i0kxMuLAdRZeEls9MAQlbSkgDNPEASuwBrsgsOS2IQLntT1Gb5UrEXL4VZOrxup6kNZjniaQXKBVEzTgSwbMBL+80ayOiv0=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3390.namprd18.prod.outlook.com (10.255.236.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Fri, 22 Nov 2019 16:06:42 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2451.031; Fri, 22 Nov 2019
 16:06:42 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Huacai Chen <chenhc@lemote.com>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Fuxin Zhang <zhangfx@lemote.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Michael Hernandez <michael.hernandez@cavium.com>
Subject: Re: [EXT] [PATCH] scsi: qla2xxx: Fix qla2x00_request_irqs() for MSI
Thread-Topic: [EXT] [PATCH] scsi: qla2xxx: Fix qla2x00_request_irqs() for MSI
Thread-Index: AQHVoC2+DFU9VK2KiUq+Q+st+wI0VaeW+LaA
Date:   Fri, 22 Nov 2019 16:06:42 +0000
Message-ID: <DC8E9064-F2D2-4B33-829C-CD7DC0438F4C@marvell.com>
References: <1574314847-14280-1-git-send-email-chenhc@lemote.com>
In-Reply-To: <1574314847-14280-1-git-send-email-chenhc@lemote.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [2600:1700:211:eb30:e5e4:c939:a3a3:4c5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b78816b6-c0c6-4761-1079-08d76f65f72c
x-ms-traffictypediagnostic: MN2PR18MB3390:
x-microsoft-antispam-prvs: <MN2PR18MB339028180DEA116DC33B4754D6490@MN2PR18MB3390.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(199004)(189003)(6486002)(33656002)(186003)(316002)(6506007)(102836004)(25786009)(54906003)(11346002)(2906002)(256004)(5660300002)(71200400001)(446003)(76176011)(58126008)(71190400001)(4326008)(2616005)(8676002)(76116006)(14444005)(7736002)(36756003)(305945005)(46003)(229853002)(6512007)(6246003)(86362001)(81156014)(6916009)(81166006)(91956017)(66556008)(64756008)(66446008)(66946007)(8936002)(478600001)(66476007)(14454004)(99286004)(6116002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3390;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PebdmLXw1MShGcA/chzRPwIQiacRnmoZcY8DYfFnugYTEBDJ0KUh5S2wrVzWPTTIvn9c6ukJe7TbUQgzmKM7HA2Ye6GP9EwzjNtPXlDROKu1GTnr1jd4ogQDDUPR6NhWVQ6HIfmw047vft/pkcr7du697aKMNl1w1zmSd/7lSewhoWB8VYMyuVA8S7dKjGWV0t2cPNpUTKUYy1wiL8NqEQtmtr1WIFgajbw2eCbOtGezAWgmnARHBjtuwtNcFKrxTd1IsKAFBdjFb+V5NAQX7V6ZEJMPziH9D39korzuTQ+ndpIoC2OkasXNKxEqwzzb3jnd+DZAh8WhBeIj4YkbIieeKIe6GpXiRFMnsztVRXXe9CUVnEE3iiHPbhHNctJmHVN151HG7RW11oT8JNQya6vykw1JjHrWFL6T1uowWJzkkTBhVzpbT/pALNKynWrO
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <31274E2B3BB49F4BB7450E770642CCFC@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b78816b6-c0c6-4761-1079-08d76f65f72c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 16:06:42.3855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 841xtoRRIe8mlMpTfTPPvWpkUrA+QMEp7qbaE/JI9NC83Rsy+AnewVlH8p4HFeq+FejzdHEDpVi9/4cBAoTEbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3390
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-22_03:2019-11-21,2019-11-22 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDExLzIwLzE5LCAxMTozNyBQTSwgIkh1YWNhaSBDaGVuIiA8Y2hlbmh1YWNhaUBn
bWFpbC5jb20gb24gYmVoYWxmIG9mIGNoZW5oY0BsZW1vdGUuY29tPiB3cm90ZToNCg0KICAgIEV4
dGVybmFsIEVtYWlsDQogICAgDQogICAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KICAgIENvbW1pdCA0ZmExODM0
NTU5ODhhZGFhICgic2NzaTogcWxhMnh4eDogVXRpbGl6ZSBwY2lfYWxsb2NfaXJxX3ZlY3RvcnMN
CiAgICAvcGNpX2ZyZWVfaXJxX3ZlY3RvcnMgY2FsbHMuIikgdXNlIHBjaV9hbGxvY19pcnFfdmVj
dG9ycygpIHRvIHJlcGxhY2UNCiAgICBwY2lfZW5hYmxlX21zaSgpIGJ1dCBpdCBkaWRuJ3QgaGFu
ZGxlIHRoZSByZXR1cm4gdmFsdWUgY29ycmVjdGx5LiBUaGlzDQogICAgYnVnIG1ha2UgcWxhMngw
MCBhbHdheXMgZmFpbCB0byBzZXR1cCBNU0kgaWYgTVNJLVggZmFpbCwgc28gZml4IGl0Lg0KICAg
IA0KICAgIEJUVywgaW1wcm92ZSB0aGUgbG9nIG1lc3NhZ2Ugb2YgcmV0dXJuIHZhbHVlIGluIHFs
YTJ4MDBfcmVxdWVzdF9pcnFzKCkNCiAgICB0byBhdm9pZCBjb25mdXNpbmcuDQogICAgDQogICAg
Rml4ZXM6IDRmYTE4MzQ1NTk4OGFkYWEgKCJzY3NpOiBxbGEyeHh4OiBVdGlsaXplIHBjaV9hbGxv
Y19pcnFfdmVjdG9ycy9wY2lfZnJlZV9pcnFfdmVjdG9ycyBjYWxscy4iKQ0KICAgIENjOiBNaWNo
YWVsIEhlcm5hbmRleiA8bWljaGFlbC5oZXJuYW5kZXpAY2F2aXVtLmNvbT4NCiAgICBTaWduZWQt
b2ZmLWJ5OiBIdWFjYWkgQ2hlbiA8Y2hlbmhjQGxlbW90ZS5jb20+DQogICAgLS0tDQogICAgIGRy
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYyB8IDYgKysrLS0tDQogICAgIDEgZmlsZSBjaGFu
Z2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQogICAgDQogICAgZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9pc3IuYw0KICAgIGluZGV4IDRjMjY2MzAuLmMwNTY4YzYgMTAwNjQ0DQogICAgLS0tIGEv
ZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jDQogICAgKysrIGIvZHJpdmVycy9zY3NpL3Fs
YTJ4eHgvcWxhX2lzci5jDQogICAgQEAgLTM2MjYsNyArMzYyNiw3IEBAIHFsYTJ4MDBfcmVxdWVz
dF9pcnFzKHN0cnVjdCBxbGFfaHdfZGF0YSAqaGEsIHN0cnVjdCByc3BfcXVlICpyc3ApDQogICAg
IHNraXBfbXNpeDoNCiAgICAgDQogICAgIAlxbF9sb2cocWxfbG9nX2luZm8sIHZoYSwgMHgwMDM3
LA0KICAgIC0JICAgICJGYWxsaW5nIGJhY2stdG8gTVNJIG1vZGUgLSVkLlxuIiwgcmV0KTsNCiAg
ICArCSAgICAiRmFsbGluZyBiYWNrLXRvIE1TSSBtb2RlIC0tIHJldD0lZC5cbiIsIHJldCk7DQog
ICAgIA0KICAgICAJaWYgKCFJU19RTEEyNFhYKGhhKSAmJiAhSVNfUUxBMjUzMihoYSkgJiYgIUlT
X1FMQTg0MzIoaGEpICYmDQogICAgIAkgICAgIUlTX1FMQTgwMDEoaGEpICYmICFJU19QM1BfVFlQ
RShoYSkgJiYgIUlTX1FMQUZYMDAoaGEpICYmDQogICAgQEAgLTM2MzQsMTMgKzM2MzQsMTMgQEAg
cWxhMngwMF9yZXF1ZXN0X2lycXMoc3RydWN0IHFsYV9od19kYXRhICpoYSwgc3RydWN0IHJzcF9x
dWUgKnJzcCkNCiAgICAgCQlnb3RvIHNraXBfbXNpOw0KICAgICANCiAgICAgCXJldCA9IHBjaV9h
bGxvY19pcnFfdmVjdG9ycyhoYS0+cGRldiwgMSwgMSwgUENJX0lSUV9NU0kpOw0KICAgIC0JaWYg
KCFyZXQpIHsNCiAgICArCWlmIChyZXQgPiAwKSB7DQogICAgIAkJcWxfZGJnKHFsX2RiZ19pbml0
LCB2aGEsIDB4MDAzOCwNCiAgICAgCQkgICAgIk1TSTogRW5hYmxlZC5cbiIpOw0KICAgICAJCWhh
LT5mbGFncy5tc2lfZW5hYmxlZCA9IDE7DQogICAgIAl9IGVsc2UNCiAgICAgCQlxbF9sb2cocWxf
bG9nX3dhcm4sIHZoYSwgMHgwMDM5LA0KICAgIC0JCSAgICAiRmFsbGluZyBiYWNrLXRvIElOVGEg
bW9kZSAtLSAlZC5cbiIsIHJldCk7DQogICAgKwkJICAgICJGYWxsaW5nIGJhY2stdG8gSU5UYSBt
b2RlIC0tIHJldD0lZC5cbiIsIHJldCk7DQogICAgIHNraXBfbXNpOg0KICAgICANCiAgICAgCS8q
IFNraXAgSU5UeCBvbiBJU1A4Mnh4LiAqLw0KICAgIC0tIA0KICAgIDIuNy4wDQogICAgDQogICAN
CiBMb29rcyBHb29kLiANCg0KQWNrZWQtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhtYWRoYW5pQG1h
cnZlbGwuY29tPg0KDQo=
