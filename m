Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31980C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 19:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF1BA20652
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 19:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CTtNrzEG";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="VNuQAxIN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfLJTkU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 14:40:20 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13288 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726589AbfLJTkU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 14:40:20 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBAJYf52011767;
        Tue, 10 Dec 2019 11:40:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=cbBo0iCET++ftqfLje+fUsjGlX+W/hoCtOwOUWBoKDQ=;
 b=CTtNrzEGrY7uEVZ7jHViR6GRX+4fhMGVb+gkJ6ymfjsc2mGhKTMq2yaMQupwHlym4l0q
 bRfdBWH23WuHyOWp9n6mctnXlPh0FZRDJJB2SfVmG0Q1IX5ELgwA6FeD8gO+Aft+UWRf
 4Fij6YkHOZ9IiAZdd+uz5TmSO9FKIm+bTPKdtyf0mpPLlgsjEk78Jqf/DbqHeNB3Yo5d
 cVk2u5g9Ahaj12sCOVrTTXj7cQsDBrVWs4TYl3JBkBLDCqNsxUMz3ghwhGD2tPy0j94k
 f9eka+JL6+7SEzFBCO19giENfl0eE8VXdd0lq5b/3u2ttbc7OUVmtoCR91usnqej59NX 0A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wtbqg1qdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 11:40:01 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 10 Dec
 2019 11:39:59 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.51) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 10 Dec 2019 11:39:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3Zva1mqJyY4KJEZskq1P5RdbOB84cI1hsJ6J8q1WFdp2DyQAycPb9zhmr2NDPSXMDJ/FYI1xIeJIW/h2Jd/qg39sMwLuU/8M78anZVPpAsbKTHpjpT1gvmQPEhOGbBqOv2bVyfR4619+EDA0L7glIsUKVPOvSlS3Ytp9tD+n979XrkqjZdvTdjLVyl1OwvRZjeAQTTBpZQcr4yF369JXQ0TiGX6Ze7knOnzKgqmLtebmNu805ND7N0gyyekuD2lmwCsseh/NSahMODcBkcdh90g8GBt7DyTu33PMrhq2FV2V4yiarQZsVF9wYF/F/c2ciHAZzSt3dqn61t9O7h/SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbBo0iCET++ftqfLje+fUsjGlX+W/hoCtOwOUWBoKDQ=;
 b=nJ/7iTwpgWKoQKEVfjvN47JtIYLQFqVbanh+7qqgF9ujoy+sROQ7Qu1xO6e8XaXJ59MyEsWUyesM4LycFuAFA9cdIVtznWG2V6dWMgvWblzT2ZlxfV4eeyjVXWO8NkC0H7XJLaJ/f4ihXi9Rb8iDkE8tQELZT2GMwxw8iHeZtES+CVDhDQjYeWX2CqKXmhLOtVgjMSvvCRZ5rvKGySXc8gqfurN0Qj72a9A69saGF2KYYMVc1WwykAMmysgBgf899ceKfCgldvZZKZXqhX/+UxEgG8KvXhPq2azWdvVZ66vyG7luuarQtyp0mUgEwWkrKj/1d6T8d3o1HSV5wrh8uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbBo0iCET++ftqfLje+fUsjGlX+W/hoCtOwOUWBoKDQ=;
 b=VNuQAxINQRVz4+tDUs1aM3Fbhv483JrO5tGHHu308kS5bkfBKeKTX62miAPR26R+PS1N6Kaf5ZHDVGdHAAM6doB+dI2ROVyNdAVKZnvn7QZwYGI7o1dBpzTFAry26f8JfxP25wAPfmnSeM/bSnwZZIsPW8TGfzfcru5Z0vvkRnE=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2671.namprd18.prod.outlook.com (20.179.84.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 19:39:56 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::eda7:1699:29f1:9eb8]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::eda7:1699:29f1:9eb8%5]) with mapi id 15.20.2538.012; Tue, 10 Dec 2019
 19:39:56 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 1/4] qla2xxx: Check locking assumptions at runtime in
 qla2x00_abort_srb()
Thread-Topic: [PATCH 1/4] qla2xxx: Check locking assumptions at runtime in
 qla2x00_abort_srb()
Thread-Index: AQHVrrrh8CGR21hE60Kh9/EDKHFLsKezYSeA
Date:   Tue, 10 Dec 2019 19:39:56 +0000
Message-ID: <222378BC-A133-43B3-B9DB-FEF9E4106858@marvell.com>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-2-bvanassche@acm.org>
In-Reply-To: <20191209180223.194959-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [66.73.206.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93b6a785-ad5e-425f-7cfe-08d77da8bc6a
x-ms-traffictypediagnostic: MN2PR18MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2671B63DD25D95C423CE6A7CD65B0@MN2PR18MB2671.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(199004)(189003)(2616005)(478600001)(6486002)(91956017)(110136005)(36756003)(54906003)(33656002)(4326008)(6512007)(26005)(2906002)(86362001)(186003)(6506007)(66946007)(64756008)(76116006)(66556008)(316002)(81156014)(8936002)(71200400001)(66476007)(81166006)(5660300002)(66446008)(8676002)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2671;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4QrIAJ1cLpbx0Ee0dg/1mln/DI/RrGjBoWxFyz4E1Cp1GLc0luSq/7Lp/po2jbc4qqFdf8jNX83ZX3XR5QEKbDggOAIaRwzvtlzuwvjOwZWxUapjGoYXuj+1rNRpIWeKz+mIpDc6Wmzm1cJ2LJcWAQwHlcTblpemQnrIVZrDmnfWsk4XXkBTkqOUfrkGnM9yL/HxVAAdBzFmbkP3CIpsx6IfKB0q9gKQSlDWpKKX+jO8CE4wTmjQd4q1RF4hSvwqGCrdpvedbgUOYl6hl/lVexRf5NaesxQJ3OHi3vx3Chi7VOo7TYegbcfEkPtqGb9lm4vOAxKd65ZlD8WHg9yE/pQ40MKNQ8MtZ+x7R1mVDYGDWk0wRE4JGtPpzWikO3FFE+xhRBveoycYQUdADT+CvGwJa3rqv/QKCs5z07Fylnn0710kjJc4CimJB3+KqayX
Content-Type: text/plain; charset="utf-8"
Content-ID: <13C014F257FB3044BAF2A2B55344C6AD@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b6a785-ad5e-425f-7cfe-08d77da8bc6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 19:39:56.4018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7dx6rq9iF9IBEdq7I+/4Bf60G2d4aXv4ZVxMeS9p/vflPEWQaSWEWs/g5LXWjYf+ofL8hvEdyRMvyllanP4iBQ==
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
ICAgRG9jdW1lbnQgdGhlIGxvY2tpbmcgYXNzdW1wdGlvbnMgdGhpcyBmdW5jdGlvbiByZWxpZXMg
b24gYW5kIGFsc28gdmVyaWZ5IHRoZXNlDQogICAgbG9ja2luZyBhc3N1bXB0aW9ucyBhdCBydW50
aW1lLg0KICAgIA0KICAgIENjOiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQogICAg
Q2M6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPg0KICAgIENjOiBEYW5pZWwgV2FnbmVy
IDxkd2FnbmVyQHN1c2UuZGU+DQogICAgQ2M6IFJvbWFuIEJvbHNoYWtvdiA8ci5ib2xzaGFrb3ZA
eWFkcm8uY29tPg0KICAgIFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2No
ZUBhY20ub3JnPg0KICAgIC0tLQ0KICAgICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYyB8
IDIgKysNCiAgICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KICAgIA0KICAgIGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYyBiL2RyaXZlcnMvc2NzaS9x
bGEyeHh4L3FsYV9vcy5jDQogICAgaW5kZXggOGI4NGJjNGE2YWM4Li4xNDVlYTkzMjA2ZjAgMTAw
NjQ0DQogICAgLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMNCiAgICArKysgYi9k
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYw0KICAgIEBAIC0xNzAwLDYgKzE3MDAsOCBAQCBz
dGF0aWMgdm9pZCBxbGEyeDAwX2Fib3J0X3NyYihzdHJ1Y3QgcWxhX3FwYWlyICpxcCwgc3JiX3Qg
KnNwLCBjb25zdCBpbnQgcmVzLA0KICAgICAJYm9vbCByZXRfY21kOw0KICAgICAJdWludDMyX3Qg
cmF0b3ZfajsNCiAgICAgDQogICAgKwlsb2NrZGVwX2Fzc2VydF9oZWxkKHFwLT5xcF9sb2NrX3B0
cik7DQogICAgKw0KICAgICAJaWYgKHFsYTJ4MDBfY2hpcF9pc19kb3duKHZoYSkpIHsNCiAgICAg
CQlzcC0+ZG9uZShzcCwgcmVzKTsNCiAgICAgCQlyZXR1cm47DQogICAgDQpMb29rcyBHb29kLiAN
Cg0KQWNrZWQtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhtYWRoYW5pQG1hcnZlbGwuY29tPg0KDQo=
