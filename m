Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45275C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10B74206D8
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ejgVJDcd";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="c6aBUqGr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKUQht (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 11:37:49 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55382 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726541AbfKUQhs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 11:37:48 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALGUqSI024506;
        Thu, 21 Nov 2019 08:37:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Ou/9aoPQWXQzsa7qGGPqYZyhrpJMFZmAj6fceZRcw0M=;
 b=ejgVJDcdhvb1D9dQm+fmi3v0IZ6qq8zEj4WEi7uRoLVNk5emcOAA5gdPio/Pj4+u/4UY
 ui04u0f7IM2UIQVd5WGYuuNwkGHcnl+APcucnBulx7TJVIqW3WezifIcr6GUvaERB/+I
 vphy8CBMuqNgjz2Rq4R/bhweUokZ+aktE953civNOGuvHrzgXBbqsbJ6Q6AdeKBxhAC+
 H+eIw2yuTVVdhngwYbmRII9tHGdSbkFd6ruCTbbhrjtIj/WLA7+t3Fp1Ts3+lIeNwMXM
 MkJpn5Gq/2VyV2wrIDl31m8bUCzx6erkFINo6zK39H9MUxPaGGBpFm57OmGSPs7I0yeR DQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wc842efpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 08:37:47 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 21 Nov
 2019 08:37:46 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.52) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 21 Nov 2019 08:37:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=McyzPjML9NbngNfN2R/9ihRTZkkrXH8o9UhVB3VLOGhlulgh96DCj106LwV0BM3EllHvHYRDtK+JfP4gxYF4TXviG7+N4UBgnu3Ew3kH+ayntSk1OGz8SrccK3LDOsNRf7KR1wCGNKHUlZ1MlGGm+nzius86Ify0/5iDRaOTe4AFczM/ju/MiNVAYTfWlo9ZtDOLG7UGa0Em3lEkUublfBKWI/sFQcbX1AkwBDpZesnM6/rZFWQDz+4p6PWOcKGijTtyCpn5caWv92cDXJCGyqqVZY3W08EeMNG3SlsU64R2f8yep7PRZdwjXOqwVkN+jlXMnd3n84KxWJzDT4g+OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ou/9aoPQWXQzsa7qGGPqYZyhrpJMFZmAj6fceZRcw0M=;
 b=TDf3frvRqXTuJidYMxkXITrkWL5gtvani6jnK66JPf+8E2wc9+Ud+irLod9Z7fTl7V53hWCRSByjO5S1kJ4kIuN1HVY9uPrwnSGbRkz9czeU4+5swVRBmv718G6oq9EMhqoEpLuntfOpaXtAlZBoMPKDbStc3vOVql1KbYI1sFEG8/I4NsBrNfH/wcx1XvzQN1lO+ax3Qdr+mh8ovEh5QCBWsHj5iz4XJrR0598eyHs0UxZWniD/Nul7fIVUJt4gq6JLZVYmp7mNbAYjhEnUnqvfWbhfZauTwK3FijL6KU4cM1+u1M83+LI6QoZmwf5pnvxk/jTcIEslBWMwNtVcTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ou/9aoPQWXQzsa7qGGPqYZyhrpJMFZmAj6fceZRcw0M=;
 b=c6aBUqGr8aOcIbFFj5gi8mvHPPEIlwo3pqLz3KXG1ujbQ+2cIrLbJJ3O0Db236oee1k6d4eDB7VIt7HscWF8S14alR9hZrt6AwE0nAFEWe+ITUl+BO1NYmDaLrTSV+fdikESiZe6H7j7q6L95qK4RpROB6Rv8Hgm5dHuIvazJhA=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3085.namprd18.prod.outlook.com (20.179.21.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Thu, 21 Nov 2019 16:37:43 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 16:37:43 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [PATCH v2 14/15] scsi: qla2xxx: Add debug dump of LOGO payload
 and ELS IOCB
Thread-Topic: [PATCH v2 14/15] scsi: qla2xxx: Add debug dump of LOGO payload
 and ELS IOCB
Thread-Index: AQHVn/HG6lytXPpcP023gSies1sHi6eVb4QA
Date:   Thu, 21 Nov 2019 16:37:43 +0000
Message-ID: <5FF3220F-1568-438C-85E3-F9C321449939@marvell.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-15-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-15-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [2600:1700:211:eb30:e5e4:c939:a3a3:4c5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccd7443d-5ae3-4ec0-a7a8-08d76ea12203
x-ms-traffictypediagnostic: MN2PR18MB3085:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3085233327DFFC46E128FBFED64E0@MN2PR18MB3085.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:176;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39850400004)(396003)(136003)(346002)(376002)(199004)(189003)(5660300002)(2501003)(186003)(76176011)(71190400001)(8676002)(7736002)(99286004)(256004)(46003)(86362001)(6512007)(14454004)(33656002)(102836004)(229853002)(66946007)(8936002)(2616005)(107886003)(305945005)(4326008)(81156014)(11346002)(6506007)(446003)(71200400001)(6116002)(2201001)(36756003)(6486002)(2906002)(110136005)(54906003)(66446008)(58126008)(64756008)(6436002)(76116006)(6246003)(91956017)(81166006)(66476007)(66556008)(478600001)(25786009)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3085;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p/o9KGg6qWoMjFeJJddH7W/vJlvvGGHZGQSHlnUPyIo7YCtSDz0BkySLp+UiB21bvXHLS1v2sgLccdRaDRgxpwKvh9fv10MM3uJXbmldLObtPKEBMhztCwdAbyfJVLhG8fevLoQBnR1bo2ZYLOElfnDahta4Q0xQqonMBtE6PWtPqwA3YhQ9BLnjeUvTh0G4lFtNxvNK0eEHozNUsvWLytCCpx2Mdh9mJgDrFGl/V9MCZ9/6+jDlEVcwBnj2Ydhph13bb9zUSLIewxNCUHIvYREnXrIF1oOPbsJtVpiwg1WyhHnaYJAPQhGXCxn88ogJ8w3HyGaGQ9KSk9rJJK4Fycow4rFuaET4mMd4x8mkVucKNsDgb2jaf56Iqjvngivla/v/yjTFhvB1OSYGN/sC9Jv4t2NQECE5y25r29AGSGjdy0yVjE5JJ48b6QKa+pHp
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCF1052D4BB5414383E8AF57F5CBD8B7@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ccd7443d-5ae3-4ec0-a7a8-08d76ea12203
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 16:37:43.4680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UdzyoaM+QmpMmaF25GlZ9LhkWWpq/Kg3nIZgWedjFL+vpRK4lUwUeHNy2bQTD10hJUCZmk8xTDDbvv0y+e2b/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3085
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_04:2019-11-21,2019-11-21 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDExLzIwLzE5LCA0OjI4IFBNLCAidGFyZ2V0LWRldmVsLW93bmVyQHZnZXIua2Vy
bmVsLm9yZyBvbiBiZWhhbGYgb2YgUm9tYW4gQm9sc2hha292IiA8dGFyZ2V0LWRldmVsLW93bmVy
QHZnZXIua2VybmVsLm9yZyBvbiBiZWhhbGYgb2Ygci5ib2xzaGFrb3ZAeWFkcm8uY29tPiB3cm90
ZToNCg0KICAgIFRoZSBjaGFuZ2UgYWRkcyBhIHdheSB0byBkZWJ1ZyBMT0dPIEVMUywgbGlrZXdp
c2UgUExPR0kuDQogICAgDQogICAgQ2M6IFF1aW5uIFRyYW4gPHF1dHJhbkBtYXJ2ZWxsLmNvbT4N
CiAgICBDYzogSGltYW5zaHUgTWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5jb20+DQogICAgU2ln
bmVkLW9mZi1ieTogUm9tYW4gQm9sc2hha292IDxyLmJvbHNoYWtvdkB5YWRyby5jb20+DQogICAg
LS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMgfCA5ICsrKysrKysrKw0K
ICAgICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspDQogICAgDQogICAgZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4
eC9xbGFfaW9jYi5jDQogICAgaW5kZXggMTJiMzdiNzExYWU4Li5jZDJlMGY4OWU5YjUgMTAwNjQ0
DQogICAgLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lvY2IuYw0KICAgICsrKyBiL2Ry
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMNCiAgICBAQCAtMjYyNyw2ICsyNjI3LDEwIEBA
IHFsYTI0eHhfZWxzX2RjbWRfaW9jYihzY3NpX3FsYV9ob3N0X3QgKnZoYSwgaW50IGVsc19vcGNv
ZGUsDQogICAgIA0KICAgICAJbWVtY3B5KGVsc2lvLT51LmVsc19sb2dvLmVsc19sb2dvX3B5bGQs
ICZsb2dvX3B5bGQsDQogICAgIAkgICAgc2l6ZW9mKHN0cnVjdCBlbHNfbG9nb19wYXlsb2FkKSk7
DQogICAgKwlxbF9kYmcocWxfZGJnX2Rpc2MgKyBxbF9kYmdfYnVmZmVyLCB2aGEsIDB4MzA3NSwg
IkxPR08gYnVmZmVyOiIpOw0KICAgICsJcWxfZHVtcF9idWZmZXIocWxfZGJnX2Rpc2MgKyBxbF9k
YmdfYnVmZmVyLCB2aGEsIDB4MDEwYSwNCiAgICArCQkgICAgICAgZWxzaW8tPnUuZWxzX2xvZ28u
ZWxzX2xvZ29fcHlsZCwNCiAgICArCQkgICAgICAgc2l6ZW9mKCplbHNpby0+dS5lbHNfbG9nby5l
bHNfbG9nb19weWxkKSk7DQogICAgIA0KICAgICAJcnZhbCA9IHFsYTJ4MDBfc3RhcnRfc3Aoc3Ap
Ow0KICAgICAJaWYgKHJ2YWwgIT0gUUxBX1NVQ0NFU1MpIHsNCiAgICBAQCAtMjcwNCw2ICsyNzA4
LDExIEBAIHFsYTI0eHhfZWxzX2xvZ29faW9jYihzcmJfdCAqc3AsIHN0cnVjdCBlbHNfZW50cnlf
MjR4eCAqZWxzX2lvY2IpDQogICAgIAkJZWxzX2lvY2ItPnJ4X2J5dGVfY291bnQgPSAwOw0KICAg
ICAJCWVsc19pb2NiLT5yeF9hZGRyZXNzID0gMDsNCiAgICAgCQllbHNfaW9jYi0+cnhfbGVuID0g
MDsNCiAgICArCQlxbF9kYmcocWxfZGJnX2lvICsgcWxfZGJnX2J1ZmZlciwgdmhhLCAweDMwNzYs
DQogICAgKwkJICAgICAgICJMT0dPIEVMUyBJT0NCOiIpOw0KICAgICsJCXFsX2R1bXBfYnVmZmVy
KHFsX2xvZ19pbmZvLCB2aGEsIDB4MDEwYiwNCiAgICArCQkJICAgICAgIGVsc19pb2NiLA0KICAg
ICsJCQkgICAgICAgc2l6ZW9mKCplbHNfaW9jYikpOw0KICAgICAJfQ0KICAgICANCiAgICAgCXNw
LT52aGEtPnFsYV9zdGF0cy5jb250cm9sX3JlcXVlc3RzKys7DQogICAgLS0gDQogICAgMi4yNC4w
DQogICAgDQpMb29rcyBHb29kLg0KDQpBY2tlZC1ieTogSGltYW5zaHUgTWFkaGFuaSA8aG1hZGhh
bmlAbWFydmVsbC5jb20+DQoNCg==
