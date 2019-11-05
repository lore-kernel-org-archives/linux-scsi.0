Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571EAC5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A6E8214D8
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Ixklwl5I";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Wgi+D/jN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731129AbfKEPHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:07:12 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64174 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730939AbfKEPHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:07:12 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5F0SnA015386;
        Tue, 5 Nov 2019 07:04:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=YdKdlOoKQdJDfGRLXNSBIOxTxTCfbNwH6zNypF/AKg8=;
 b=Ixklwl5IGZoUW83hR1vxFthG2Xefq5SN+X9ly8aqOghKj/jaQs9OWWRSQoRuLMvUk8oy
 /9Y6H+UEbWrYmQQjHkmGmmKiTX0s3sMHjA6pQCeFX0ESJY/i/nxe6hAbVCA+LeCDH/Bv
 efscK915nXp58GzHzT2Yi80DKo6CrRvmm6shqp1dI4RwQxsV6kgVZlHYF6xWdtSdqnID
 MORO2cU5wHv+V/2GZRVyT21MYDse4UaqHonHjz5XWLamrsXfu8lGObi90lmW7lAVRI6t
 Bhera03PUJ5Fq/98qDSpr6FxfK04vui4apCdHpMX8ItWGcGtX3OYF8ENKWauSyqrNeXi sA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w19amtr7p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 07:04:35 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 5 Nov
 2019 07:04:34 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.58) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 5 Nov 2019 07:04:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5qTuPDvmEGkyXc3doH4HoobBRWHCxxaLNjHhTJcsp3U4oetQvP2ifNRlqUUTEPBfWl3iP/XEhkGdGHhSPkj3FMcqyYgyva/6+Jdu9wA450xP/V6akYYU84rezejoLA67VMOJwJJ/WGaQEgpE6kwxAD5pZOmwgBBh4EUzc1ICWRtWbiuI9OUCEUUBVAJKR4Qgnd9G9xC/YMmZAX170OJRMVnCRbzFPgm8EuVNqT6mqyfobWMdmxZy8efglZriMxmxNnZ8TLszY6CK3yw26gEc6reEH0ZUFDgaaTUNM/J4zoowZ8Fg5UjKgD3+L2RgJhbx3lbgIOgXRI4QNR90i8QBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdKdlOoKQdJDfGRLXNSBIOxTxTCfbNwH6zNypF/AKg8=;
 b=lOc/eFLtiBSH8TQYwrZJkAykE4liMEGUha6JgaaibYP5qV9TRcvn9HDd2K4WrgEeEBmGB6eG6nfwRPfh8+K8LZ/45Qm9xKd3eISSwxLeLc7aizd07XnUHv8tGb+FZSTT4bex77iQRuI5cy9s3Vbv5TmY1RWuQjw/wqI+wLu12EeLSw443LdF0aM5WoE7v27/S8xVucBExbP00QvMO0Z/5ZX6ISsFEe5N++0Ax4koveaEv3Wp6sd36BOJ2vfYJLxoHFkbNcd1j2pUktqpmy6BoK/VFWGCcUqsK33imUt0cVdStSCkrpjt8zv+A3nppAe3UJD2zQwE2yVBnpCeBxKgTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdKdlOoKQdJDfGRLXNSBIOxTxTCfbNwH6zNypF/AKg8=;
 b=Wgi+D/jNjYh3b49c5KUc0Ai6DRuIinkpXJgU/48wkip2MQZh0lKa5P4tKe03ywn2dJfvX03Ml5j5/aeDjeXe42E1hk9vUipZwB0Fr/9siEn47qiyu0Px/y0XTsFYxTCn4EPkZaZrcsUXuYq0f2iUmEExZ5ExRuZN3hRNoO9Q2k4=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2590.namprd18.prod.outlook.com (20.179.81.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 15:04:32 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 15:04:32 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Martin Wilck <Martin.Wilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Quinn Tran <qutran@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Daniel Wagner <dwagner@suse.de>,
        "James Bottomley" <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND v2] fixup "qla2xxx: Optimize NPIV tear down
 process"
Thread-Topic: [PATCH RESEND v2] fixup "qla2xxx: Optimize NPIV tear down
 process"
Thread-Index: AQHVk+kjrebV27kmXUOXVa1+ECU7zKd8SEAA
Date:   Tue, 5 Nov 2019 15:04:32 +0000
Message-ID: <C7A0B3A1-6AE9-467D-95C1-191C51AEA53D@marvell.com>
References: <20191105145550.10268-1-martin.wilck@suse.com>
In-Reply-To: <20191105145550.10268-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1e.0.191013
x-originating-ip: [2600:1700:211:eb30:e1a7:7b00:b7d4:a14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76b07bbd-96ea-40d2-4929-08d762017712
x-ms-traffictypediagnostic: MN2PR18MB2590:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2590B6C0B1CCA58F854C5F04D67E0@MN2PR18MB2590.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39850400004)(366004)(376002)(136003)(51914003)(189003)(199004)(256004)(186003)(6506007)(102836004)(305945005)(6246003)(14444005)(81156014)(2616005)(476003)(486006)(446003)(33656002)(25786009)(2906002)(8676002)(81166006)(6486002)(11346002)(7736002)(8936002)(5660300002)(86362001)(6116002)(478600001)(71190400001)(4326008)(14454004)(71200400001)(64756008)(229853002)(54906003)(966005)(66946007)(6512007)(66556008)(76116006)(76176011)(6306002)(66446008)(36756003)(316002)(58126008)(46003)(110136005)(99286004)(91956017)(66476007)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2590;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +YOf7OCaJQUY4dVds84vp9KU2B1LkG97BdRKnP/7M4zRTiVJxby18aoFw1VOTS2ooR6kDGlm64prV7RwGtbmZJsFy2ya3NtPOOBXJc8V/YaFNXzFHhdybpGxWCJELB7FhfedQmcSvFEQ/mmTbhCooLcLlRuG8IT5ZqsFfY6Mx0njWx7loNWkSLtb7w7/l5n1zMAJfbu/m1xhO5NoMNF/Z4B5sw2fZjlF9pUgMYsgBzi4DnMWeILaTHZsKMQVBzXn3fTOf+4E+Oj8XDYbnj2MFfa2Cge0PUnEOw+eh4yeyv2JSmMjoloUyJXfvOxsR75iXS1XbfzaNVZGQ56YP/sgJTaJPhGvqAgoZXkrJK22Jq4zkqX5leAbk4SWy4M9kn+3Tlwh7xIxh5A8oSgFsQ6LIzTGyxmxoo3WCcOZScfu7m/rrdvjkilNGzntzCN84y60LdcbRLn7y74+Bh8U+HnsBMkJ1n0BHvBOtPyqTEmwtTU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD7C6343222022449922CC495BBB0B4F@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b07bbd-96ea-40d2-4929-08d762017712
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 15:04:32.7731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MR7Oa80bX+FwPdKFsqShmahXnJ0zuTZSYPvvTheQ3kQU8+RtnlzWc5opsCbjAX4Qf9sydS8UD9/GRXuilZ0ieg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2590
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_05:2019-11-05,2019-11-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDExLzUvMTksIDg6NTkgQU0sICJsaW51eC1zY3NpLW93bmVyQHZnZXIua2VybmVs
Lm9yZyBvbiBiZWhhbGYgb2YgTWFydGluIFdpbGNrIiA8bGludXgtc2NzaS1vd25lckB2Z2VyLmtl
cm5lbC5vcmcgb24gYmVoYWxmIG9mIE1hcnRpbi5XaWxja0BzdXNlLmNvbT4gd3JvdGU6DQoNCiAg
ICBGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4NCiAgICANCiAgICBIZWxsbyBN
YXJ0aW4sDQogICAgDQogICAgdGhpcyBwYXRjaCBmaXhlcyB0d28gaXNzdWVzIGluIHBhdGNoIDAy
LzE0IGluIEhpbWFuc2h1J3MgbGF0ZXN0DQogICAgcWxhMnh4eCBzZXJpZXMgKCJxbGEyeHh4OiBC
dWcgZml4ZXMgZm9yIHRoZSBkcml2ZXIiKSBmcm9tDQogICAgU2VwdC4gMTJ0aCwgd2hpY2ggeW91
IGFwcGxpZWQgb250byA1LjQvc2NzaS1maXhlcyBhbHJlYWR5Lg0KICAgIFNlZSBodHRwczovL3Vy
bGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX21hcmMuaW5mb18tM0Zs
LTNEbGludXgtMkRzY3NpLTI2bS0zRDE1Njk1MTcwNDEwNjY3MS0yNnctM0QyJmQ9RHdJREF3JmM9
bktqV2VjMmI2UjBtT3lQYXo3eHRmUSZyPWxhbnVBRFVpejJ5bnVMekdBUWtKUGZ2Z3JaeG1tT3Vj
THZDcEdwOVNuZ1UmbT1OSmxhcFRrSDh1TG5aOVBTWVozaVJfclhKenlyNUUwRlhjcWZSUXU5X2pZ
JnM9blB2STI1M29VUnQwUTJQLUNJV1RFeW1qQlB0QlJvb2VuRGpDck5kM21RNCZlPSANCiAgICAN
CiAgICBJJ20gYXNzdW1pbmcgdGhhdCBIaW1hbnNodSBhbmQgUXVpbm4gYXJlIHdvcmtpbmcgb24g
YW5vdGhlcg0KICAgIHNlcmllcyBvZiBmaXhlcywgaW4gd2hpY2ggY2FzZSB0aGF0IHNob3VsZCB0
YWtlIHByZWNlZGVuY2UNCiAgICBvdmVyIHRoaXMgcGF0Y2guIEkganVzdCB3YW50ZWQgdG8gcHJv
dmlkZSB0aGlzIHNvIHRoYXQgdGhlDQogICAgYWxyZWFkeSBrbm93biBwcm9ibGVtcyBhcmUgZml4
ZWQgaW4geW91ciB0cmVlLg0KICAgIA0KICAgIHYyOiBjaGVjayBsb29wIGNvbmRpdGlvbiBvbmx5
IG9uY2UgKEJhcnQgdmFuIEFzc2NoZSkNCiAgICANCiAgICBDb21taXQgbWVzc2FnZSBmb2xsb3dz
Og0KICAgIA0KICAgIEZpeCB0d28gaXNzdWVzIHdpdGggdGhlIHByZXZpb3VzbHkgc3VibWl0dGVk
IHBhdGNoDQogICAgInFsYTJ4eHg6IE9wdGltaXplIE5QSVYgdGVhciBkb3duIHByb2Nlc3MiOiBh
IG1pc3NpbmcgbmVnYXRpb24NCiAgICBpbiBhIHdhaXRfZXZlbnRfdGltZW91dCgpIGNvbmRpdGlv
biwgYW5kIGEgbWlzc2luZyBsb29wIGVuZA0KICAgIGNvbmRpdGlvbi4NCiAgICANCiAgICBTaWdu
ZWQtb2ZmLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4NCiAgICBGaXhlczogZjUx
ODdiN2QxYWM2ICgic2NzaTogcWxhMnh4eDogT3B0aW1pemUgTlBJViB0ZWFyIGRvd24gcHJvY2Vz
cyIpDQogICAgLS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9taWQuYyB8IDggKysr
KystLS0NCiAgICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMgIHwgOCArKysrKy0tLQ0K
ICAgICAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQog
ICAgDQogICAgZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9taWQuYyBiL2Ry
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9taWQuYw0KICAgIGluZGV4IDZhZmFkNjhlNWJhMi4uMjM4
MjQwOTg0YmMxIDEwMDY0NA0KICAgIC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9taWQu
Yw0KICAgICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9taWQuYw0KICAgIEBAIC03Niw5
ICs3NiwxMSBAQCBxbGEyNHh4X2RlYWxsb2NhdGVfdnBfaWQoc2NzaV9xbGFfaG9zdF90ICp2aGEp
DQogICAgIAkgKiBlbnN1cmVzIG5vIGFjdGl2ZSB2cF9saXN0IHRyYXZlcnNhbCB3aGlsZSB0aGUg
dnBvcnQgaXMgcmVtb3ZlZA0KICAgICAJICogZnJvbSB0aGUgcXVldWUpDQogICAgIAkgKi8NCiAg
ICAtCWZvciAoaSA9IDA7IGkgPCAxMCAmJiBhdG9taWNfcmVhZCgmdmhhLT52cmVmX2NvdW50KTsg
aSsrKQ0KICAgIC0JCXdhaXRfZXZlbnRfdGltZW91dCh2aGEtPnZyZWZfd2FpdHEsDQogICAgLQkJ
ICAgIGF0b21pY19yZWFkKCZ2aGEtPnZyZWZfY291bnQpLCBIWik7DQogICAgKwlmb3IgKGkgPSAw
OyBpIDwgMTA7IGkrKykgew0KICAgICsJCWlmICh3YWl0X2V2ZW50X3RpbWVvdXQodmhhLT52cmVm
X3dhaXRxLA0KICAgICsJCSAgICAhYXRvbWljX3JlYWQoJnZoYS0+dnJlZl9jb3VudCksIEhaKSA+
IDApDQogICAgKwkJCWJyZWFrOw0KICAgICsJfQ0KICAgICANCiAgICAgCXNwaW5fbG9ja19pcnFz
YXZlKCZoYS0+dnBvcnRfc2xvY2ssIGZsYWdzKTsNCiAgICAgCWlmIChhdG9taWNfcmVhZCgmdmhh
LT52cmVmX2NvdW50KSkgew0KICAgIGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9x
bGFfb3MuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9vcy5jDQogICAgaW5kZXggNmU2Mjdl
NTIxNTYyLi5lZTViNmNiYTk4NzIgMTAwNjQ0DQogICAgLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX29zLmMNCiAgICArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYw0KICAg
IEBAIC0xMTE5LDkgKzExMTksMTEgQEAgcWxhMngwMF93YWl0X2Zvcl9zZXNzX2RlbGV0aW9uKHNj
c2lfcWxhX2hvc3RfdCAqdmhhKQ0KICAgICANCiAgICAgCXFsYTJ4MDBfbWFya19hbGxfZGV2aWNl
c19sb3N0KHZoYSwgMCk7DQogICAgIA0KICAgIC0JZm9yIChpID0gMDsgaSA8IDEwOyBpKyspDQog
ICAgLQkJd2FpdF9ldmVudF90aW1lb3V0KHZoYS0+ZmNwb3J0X3dhaXRRLCB0ZXN0X2ZjcG9ydF9j
b3VudCh2aGEpLA0KICAgIC0JCSAgICBIWik7DQogICAgKwlmb3IgKGkgPSAwOyBpIDwgMTA7IGkr
Kykgew0KICAgICsJCWlmICh3YWl0X2V2ZW50X3RpbWVvdXQodmhhLT5mY3BvcnRfd2FpdFEsDQog
ICAgKwkJICAgIHRlc3RfZmNwb3J0X2NvdW50KHZoYSksIEhaKSA+IDApDQogICAgKwkJCWJyZWFr
Ow0KICAgICsJfQ0KICAgICANCiAgICAgCWZsdXNoX3dvcmtxdWV1ZSh2aGEtPmh3LT53cSk7DQog
ICAgIH0NCiAgICAtLSANCiAgICAyLjEyLjMNCiAgICANCiAgICANClRoYW5rcyBmb3IgdGhlIGZp
eHVwLg0KDQpBY2tlZC1ieTogSGltYW5zaHUgTWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5jb20+
DQoNCg0K
