Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBDDC4CEC5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 17:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AEE72081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 17:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="vkO/Tjvp";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="rNJbysBr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387433AbfILRXz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 13:23:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55024 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728215AbfILRXz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 13:23:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CHKRda003002;
        Thu, 12 Sep 2019 10:23:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=73qVl+DP374zZytFEIIxKwrVxAS1Its3OjSZS03dFRA=;
 b=vkO/TjvpgI2BH8bk52NgUbS0hfVH75ouyz4i5LPLazF03yZGfkpEBA56n4wqrxuD425V
 lOoslq3rWK3/mx5yC08ifYFTbCgvEhkGK5k7g/BdcMlhkXj6FBsWzH/+Ktig9VHf+4ah
 w/eW/L3wEfskzBdXzdPmXgTAX4dL6oHDKN3G1B5wO5Tj+th+AU9VtX6cPTRR4sr4efWz
 o5R1v6oMU0A/xh2U6y3ZwBdu/Wuc5AND3hH3GYzN2c4b992ROrfCXip+w3duMmiybGKY
 sehMNRPGw1vBBDnkYj22vfrDQ/TqJB46CwQA0YCP9D4pCqxxxO+WM3ilz51G209weInZ og== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uxshkgk9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 10:23:52 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 10:23:51 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.58) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 10:23:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4wnWHgPwiHxuPDaOlSQ6RO1zxdVsZVyfJ0Z07s//ky93kKK65tIWO6bt29akTdUsUuqZOlp/1AxaqgisUvkcDv0Zsu11DqKvaKfDE0GZxD2l1KH8CzyfJ/Oy5tvrdKH0HNLK/7wX/G/Yu0sq/9vqqj7fGG8nfO1m0SjQ61Ej2jxpY+9ePPmsVEH3iJ4tUK6cnOpWkOiiVu1IieYlTAMZCvef/b3ZMyjErHrmXOZzy7HIJvNqGRZTziFmXvOTBFH4rGE8V/tIEUfJ8nK1Ta6obff6AdzWjCKDe6C950v7BLNzuHBXqf2PgWubywcqTtSCOxpZkr/cKzWAAy0TGSBQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73qVl+DP374zZytFEIIxKwrVxAS1Its3OjSZS03dFRA=;
 b=OHFX+FN/rFPShXTsRJRoVyEPQMHL1w7Hwj6BEgq7SrPFvnu+O5XoaFY8T49iK2kSDzXpTz1Eyz/Xk+NOPjCsMIGhidOPoxZ13BzGcfeG23s1NUtXeABNicSVu3e2zv8EC+fWc5dAoaUI9blPDfF9uGmMgLRsQRwdQVwvb8moRSwlbQrLbIlBU6sayAMKNHkQJFVD7CjlILpvRdutWFADfKrEp6jWZyTo0lf3cxmdZMZJju7MCGHu1eT2WPlLHfjWVIN/WvuqttyWvC/S4vXyEV/JHFL94hWc6q7a4BUm6tP7RSUixBZOE1VD1+5kbglTK3blsIB8Cx9d1X8DT/48Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73qVl+DP374zZytFEIIxKwrVxAS1Its3OjSZS03dFRA=;
 b=rNJbysBr6Z47DE1uQZiw22wTLOhUVdmjtWXk5qt1wWE9Gh3WGaNhTFEW5IB4IeRj7yo7F1tJq0ucgDE3MVSXZAqlgzlkR8KkpEAo1Dj1l9/Nw+v7quvlPCP7SQ4h1AEE0ocFffID+ZeXqRaYGb/9nO/k7c3Mk0xW7lQcJRFbWb0=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2847.namprd18.prod.outlook.com (20.179.20.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Thu, 12 Sep 2019 17:23:49 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::34d9:2eb7:4f7b:e933]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::34d9:2eb7:4f7b:e933%7]) with mapi id 15.20.2241.018; Thu, 12 Sep 2019
 17:23:49 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
CC:     "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH 07/14] qla2xxx: Fix Nport ID display value
Thread-Topic: [EXT] Re: [PATCH 07/14] qla2xxx: Fix Nport ID display value
Thread-Index: AQHVaX2Tr/TAui2sNUqmdValMYVCGKcoQscA//+0GAA=
Date:   Thu, 12 Sep 2019 17:23:49 +0000
Message-ID: <72A3403F-E84E-445B-B223-597BC6B33098@marvell.com>
References: <20190912151949.2348-1-hmadhani@marvell.com>
 <20190912151949.2348-8-hmadhani@marvell.com>
 <20190912165528.pbe5wip7ywst3x6a@SPB-NB-133.local>
In-Reply-To: <20190912165528.pbe5wip7ywst3x6a@SPB-NB-133.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
x-originating-ip: [67.79.99.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c01cfee-74d9-4a5d-be98-08d737a5f9b5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2847;
x-ms-traffictypediagnostic: MN2PR18MB2847:
x-microsoft-antispam-prvs: <MN2PR18MB28472AC4C6CFAB0B2C30F22DD6B00@MN2PR18MB2847.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:425;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(189003)(199004)(6246003)(76176011)(7736002)(71200400001)(54906003)(33656002)(186003)(6506007)(99286004)(476003)(102836004)(2616005)(8676002)(66556008)(91956017)(6512007)(66446008)(11346002)(66066001)(64756008)(76116006)(446003)(2906002)(36756003)(6116002)(3846002)(58126008)(486006)(26005)(316002)(6916009)(71190400001)(229853002)(81166006)(86362001)(25786009)(53936002)(305945005)(6486002)(66476007)(5660300002)(66946007)(6436002)(4326008)(14454004)(256004)(478600001)(81156014)(8936002)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2847;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AC1gOweCp/azUdY33XySGMWZEfPbZEQntZRSdO9srYzuJ3R3DUEfvsRyKFOvZaDMzkRtGALWNcgERU6H3AhnklqyQqI/95TdVk+2jXvgrAroX0f3rJxZ1PTbvdLZrT9O1Yy4C66jK4XX2TYk7KnGDfLG6fNHNr5cT11/HM2+ufXni74NNG5Gx1sHOrWAxloBvG3qnb5/Wq4Whxu+8v4PNMbBVm/3eyx70VWjLnHCXCCZ1YBODNrlauD/zBjt2IpcZSNeIAbbnoyWENY7epdkdocd/AySp6xwrRZW9Jmgl2g21TK/lUO9KWlA9K1mA2daypSZB5qJBrBEJk1bIIpEiKBID2BcEySgxrsK7bhNDrNX8kyKXL6CedvrtU211fPE5BnDfTb9MCSdmQRt9Lu0QnR025RXaWnMZ1KugjnG3hw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <25D522EF2513F849A650023D24EB447E@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c01cfee-74d9-4a5d-be98-08d737a5f9b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 17:23:49.3574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bRGKBYq6f7xiaKbjVv2UVKd8VbSZxTcBtmeF5hIIXnQcsfUYaerFSQwUeqwVPzpnjNnaoQAIvAyHwLEV85JTKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2847
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_09:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmtzIFJvbWFuLiANCg0KTG9va3MgbGlrZSBteSBzeXN0ZW0gZGlkIG5vdCBoYWQgdXBkYXRl
ZCA1LjQvcXVldWUgYnJhbmNoLCAgd2hpY2ggY2F1c2VkIHRoaXMgaHVuayBmYWlsdXJlLg0KDQpN
YXJ0aW4sIA0KDQpJIGFtIHJlc2VuZGluZyB0aGlzIHNlcmllcyBhZnRlciByZWJhc2luZyBvbiB5
b3VyIGxhdGVzdCA1LjQvcXVldWUuIA0KDQpUaGFua3MsDQpIaW1hbnNodQ0KDQrvu79PbiA5LzEy
LzE5LCAxMTo1NSBBTSwgIlJvbWFuIEJvbHNoYWtvdiIgPHIuYm9sc2hha292QHlhZHJvLmNvbT4g
d3JvdGU6DQoNCiAgICBFeHRlcm5hbCBFbWFpbA0KICAgIA0KICAgIC0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCiAg
ICBPbiBUaHUsIFNlcCAxMiwgMjAxOSBhdCAwODoxOTo0MkFNIC0wNzAwLCBIaW1hbnNodSBNYWRo
YW5pIHdyb3RlOg0KICAgID4gRnJvbTogUXVpbm4gVHJhbiA8cXV0cmFuQG1hcnZlbGwuY29tPg0K
ICAgID4gDQogICAgPiBGb3IgTjJOLCB0aGUgTlBvcnQgSUQgaXMgYXNzaWduZWQgYnkgZHJpdmVy
IGluIHRoZSBQTE9HSSBFTFMuDQogICAgPiBBY2NvcmRpbmcgdG8gRlcgU3BlYyB0aGUgYnl0ZSBv
cmRlciBmb3IgU0lEIGlzIG5vdCB0aGUgc2FtZSBhcw0KICAgID4gRElELg0KICAgID4gDQogICAg
PiBTaWduZWQtb2ZmLWJ5OiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQogICAgPiBT
aWduZWQtb2ZmLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxobWFkaGFuaUBtYXJ2ZWxsLmNvbT4NCiAg
ICA+IC0tLQ0KICAgID4gIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMgfCA3ICsrKyst
LS0NCiAgICA+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQ0KICAgID4gDQogICAgPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lv
Y2IuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMNCiAgICA+IGluZGV4IDE4ODZk
ZTkyMDM0Yy4uNWMyNzk0NDljYTFjIDEwMDY0NA0KICAgID4gLS0tIGEvZHJpdmVycy9zY3NpL3Fs
YTJ4eHgvcWxhX2lvY2IuYw0KICAgID4gKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lv
Y2IuYw0KICAgID4gQEAgLTI2OTYsOSArMjY5NiwxMCBAQCBxbGEyNHh4X2Vsc19sb2dvX2lvY2Io
c3JiX3QgKnNwLCBzdHJ1Y3QgZWxzX2VudHJ5XzI0eHggKmVsc19pb2NiKQ0KICAgID4gIAllbHNf
aW9jYi0+cG9ydF9pZFswXSA9IHNwLT5mY3BvcnQtPmRfaWQuYi5hbF9wYTsNCiAgICA+ICAJZWxz
X2lvY2ItPnBvcnRfaWRbMV0gPSBzcC0+ZmNwb3J0LT5kX2lkLmIuYXJlYTsNCiAgICA+ICAJZWxz
X2lvY2ItPnBvcnRfaWRbMl0gPSBzcC0+ZmNwb3J0LT5kX2lkLmIuZG9tYWluOw0KICAgID4gLQll
bHNfaW9jYi0+c19pZFswXSA9IHZoYS0+ZF9pZC5iLmFsX3BhOw0KICAgID4gLQllbHNfaW9jYi0+
c19pZFsxXSA9IHZoYS0+ZF9pZC5iLmFyZWE7DQogICAgPiAtCWVsc19pb2NiLT5zX2lkWzJdID0g
dmhhLT5kX2lkLmIuZG9tYWluOw0KICAgID4gKwkvKiBGb3IgU0lEIHRoZSBieXRlIG9yZGVyIGlz
IGRpZmZlcmVudCB0aGFuIERJRCAqLw0KICAgID4gKwllbHNfaW9jYi0+c19pZFsxXSA9IHZoYS0+
ZF9pZC5iLmFsX3BhOw0KICAgID4gKwllbHNfaW9jYi0+c19pZFsyXSA9IHZoYS0+ZF9pZC5iLmFy
ZWE7DQogICAgPiArCWVsc19pb2NiLT5zX2lkWzBdID0gdmhhLT5kX2lkLmIuZG9tYWluOw0KICAg
ID4gIAllbHNfaW9jYi0+Y29udHJvbF9mbGFncyA9IDA7DQogICAgPiAgDQogICAgPiAgCWlmIChl
bHNpby0+dS5lbHNfbG9nby5lbHNfY21kID09IEVMU19EQ01EX1BMT0dJKSB7DQogICAgPiAtLSAN
CiAgICA+IDIuMTIuMA0KICAgID4gDQogICAgDQogICAgSGksDQogICAgDQogICAgVGhpcyBvbmUg
ZG9lc24ndCBhcHBseSB0byA1LjQvc2NzaS1xdWV1ZSwgdGhlIGh1bmsgbGluZXMgc2hvdWxkIGJl
Og0KICAgIEBAIC0yNjU2LDkgKzI2NTYsMTAgQEANCiAgICANCiAgICBCZXN0IHJlZ2FyZHMsDQog
ICAgUm9tYW4NCiAgICANCg0K
