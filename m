Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37917C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02AA120692
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="zJYzEVbA";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Vv6Zy/vY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfKUQjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 11:39:25 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24304 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfKUQjZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 11:39:25 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALGZwqa021642;
        Thu, 21 Nov 2019 08:39:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=RYdu4gsEs4pII0AQHZEc0jdzhmTPZgu6govJcTdx1wA=;
 b=zJYzEVbA+3YIys24pQpZyBOAfGkS7UO05Q5stwHwkWXFnFZPT53cyrZhHYDMxwyYzCcZ
 Ab2lhCHX8pw8X+7xjxpiFplrZDPzMZ0mou1nB8J5CmB9flAKfF4Yj9Def6bWduj3JefO
 lpWBnGXtUwT9E+ScKqVT2rKFDxAOd+HVSAFCyi7yakKCGnDd4WnutFaqr0Cnyl3ZiEdo
 rBr0cfQDjq2fQ6AnbQe9/NGm5fwLvUh7uGCZeLfDRfDFNvzWxBPQqwGghgDTX3xJted9
 dKzVberLgKb1krCYnlU7i1gccHmxmoQYHXTfSmBndJ3Ck6poTDS97gphwgy6RA1bWL6F RA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wd090yv92-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 08:39:12 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 21 Nov
 2019 08:39:10 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.50) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 21 Nov 2019 08:39:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGkmovsyFc8gc3pJnLMTaG+y9DwUEMRno3jb+PgMYce/QQO9WB8tdmurg8IPwP9H6Uw3JUeBzXanXDIvIBOLwr5xwLkRnEw5of9lKF69ZLN4qBVWhG1EKGnwA8MFJG17rEV2JVWmQlyj234KnGNVQVndMHNNClu+BYJNSKx02Q/fdBDOZ76c8umcmLbx79LDXOBql14dDNoB90sUtabP76EoNtC08IJo1fWbG10aMc0FRpYP14Hi+KE9siKb7pYrnee3w9A0QpI3G7BlDjemtGrtKiGq9chJvUF1uexzfKS/4+KIVrnKw4eHFm+g+2y0X9Ld8KJnPD6M+EIeIDcl8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYdu4gsEs4pII0AQHZEc0jdzhmTPZgu6govJcTdx1wA=;
 b=gb/OyZW5JqogS5g6Sn+ryPddwkDeXMJNaI2S2ywjBf0lQWnBOST0YHh7ocYp46iwne34dWfzxw0FnFDvOU708Uh1OCVhHaidSMwQ8AmCe28+TPAcslRjZO02YUUJVuywNdtogs4Nigyc5KYDHyovwLkXnPgZMLuIPAccEtovh+lS23uqr/RGVRoRWkVeGdGXLfkmMzI8zkKvQfbcv9NpsMAl/saVfUWukytuObn2VXPEwzC5XveXBoTaXuEJneSp5YChZr/jVMZXk9dZ16OCuSVbqM58nNIH5PR8uaGjcn3wFI5LDWdBKpY6/Y0hTjAT0m/C/wW5NBk4SCRmEGduUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYdu4gsEs4pII0AQHZEc0jdzhmTPZgu6govJcTdx1wA=;
 b=Vv6Zy/vYyOwX+OL9gwV5uJB5aJeBIH00TkMQ/jydnfcnOoVoIKOXFZuTYDYYm6teWxZcUjKoGB7471TUQLf31KTizWFzVM2ROUlq+fgshxiyrdwWtXo5f1v1OV0cNwEVkmzzWDO5j71lJT49ag9dwnywxTzyctMGwWmotUYbkWg=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2989.namprd18.prod.outlook.com (20.179.23.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Thu, 21 Nov 2019 16:39:09 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 16:39:09 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [EXT] [PATCH v2 08/15] scsi: qla2xxx: Configure local loop for
 N2N target
Thread-Topic: [EXT] [PATCH v2 08/15] scsi: qla2xxx: Configure local loop for
 N2N target
Thread-Index: AQHVn/G+D2gOe8OeSUuEB3741yL6mKeVb+sA
Date:   Thu, 21 Nov 2019 16:39:09 +0000
Message-ID: <7CEC2BC8-2923-469A-9156-CFDBF42565DF@marvell.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-9-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-9-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [2600:1700:211:eb30:e5e4:c939:a3a3:4c5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4338bf11-aa56-4e6d-cffe-08d76ea1552a
x-ms-traffictypediagnostic: MN2PR18MB2989:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2989E31C829E473AE4C3D610D64E0@MN2PR18MB2989.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(189003)(199004)(91956017)(5660300002)(6436002)(186003)(76116006)(305945005)(2501003)(33656002)(7736002)(71200400001)(71190400001)(107886003)(6486002)(86362001)(8936002)(14444005)(6512007)(256004)(2616005)(102836004)(6116002)(58126008)(36756003)(6506007)(508600001)(2906002)(54906003)(25786009)(99286004)(8676002)(76176011)(46003)(14454004)(110136005)(2201001)(229853002)(4326008)(81166006)(66446008)(66556008)(6246003)(446003)(66946007)(316002)(66476007)(11346002)(81156014)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2989;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mSXqO/fJ03cQYUDWSufpqPV5jk7w8N6NnuUXBPir9DMPTsIU7IoD8Kzpvmj3yU1BKWLvCjY0EUPwjjOWGtfHL3lr0z3F5dy9WwBAXxocAMsrJbj9rJZhK9UQvjB95NxmPThgrDSXDqY6SbLYYCcOy+6CoFlUqR6OnJNu8mI1Iftmr9OxOWAhYK97BjvTlg275bb3F7r/XxbibItOtgwJJuj4s7jGgEjJHPPyuKaP9bGNmeyiXeBtHDJXlLgXh7GKTeQExWIuR0kqg//FDJ6x29sMbnMHfsOOaI+ZgSuTRqFlvVGnKbJeohFxoY1uLI139druAqbqTI7iNxeaaMBpcGanHq5zsFhUiR2UR3d5PzoFFjHPHDKVxCRqgv9zmVw/n6tklWNrHFLACP418HH5LSjTi4jJvQOY74AlSwX02vwdQmxUfPBAIZ1K8SB3O+uB
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B4F6C46EA842A48A42A42E3166023D5@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4338bf11-aa56-4e6d-cffe-08d76ea1552a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 16:39:09.2334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B6kTN4gBqDpx45ZqkqhgvAIQwhcJZgjZFAvVvLnPW4YyXUdfBO+qcjYdS4TS4q7v5Xce5/md84PCxgq0e14qpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2989
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_04:2019-11-21,2019-11-21 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDExLzIwLzE5LCA0OjI3IFBNLCAiUm9tYW4gQm9sc2hha292IiA8ci5ib2xzaGFr
b3ZAeWFkcm8uY29tPiB3cm90ZToNCg0KICAgIEV4dGVybmFsIEVtYWlsDQogICAgDQogICAgLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KICAgIHFsYTJ4MDBfY29uZmlndXJlX2xvY2FsX2xvb3AgaW5pdGlhbGl6ZXMg
UExPR0kgcGF5bG9hZCBmb3IgUExPR0kgRUxTDQogICAgdXNpbmcgR2V0IFBhcmFtZXRlcnMgbWFp
bGJveCBjb21tYW5kLg0KICAgIA0KICAgIEluIHRoZSBjYXNlIHdoZW4gdGhlIGRyaXZlciBpcyBy
dW5uaW5nIGluIHRhcmdldCBtb2RlLCB0aGUgdG9wb2xvZ3kgaXMNCiAgICBOMk4gYW5kIHRoZSB0
YXJnZXQgcG9ydCBoYXMgaGlnaGVyIFdXUE4sIExPQ0FMX0xPT1BfVVBEQVRFIGJpdCBpcw0KICAg
IGNsZWFyZWQgdG9vIGVhcmx5IGFuZCBQTE9HSSBwYXlsb2FkIGlzIG5vdCBpbml0aWFsaXplZCBi
eSB0aGUgR2V0DQogICAgUGFyYW1ldGVycyBjb21tYW5kLiBUaGF0IGNhdXNlcyBhIGZhaWx1cmUg
b2YgRUxTIElPQ0IgY2FycnlpbmcgdGhlDQogICAgUExPR0kgd2l0aCAweDE1IGFrYSBEYXRhIFVu
ZGVycnVuIGVycm9yLg0KICAgIA0KICAgIExPQ0FMX0xPT1BfVVBEQVRFIGhhcyB0byBiZSBzZXQg
dG8gaW5pdGlhbGl6ZSBQTE9HSSBwYXlsb2FkLg0KICAgIA0KICAgIEZpeGVzOiA0OGFjYWQwOTkw
NzQgKCJzY3NpOiBxbGEyeHh4OiBGaXggTjJOIGxpbmsgcmUtY29ubmVjdCIpDQogICAgQ2M6IFF1
aW5uIFRyYW4gPHF1dHJhbkBtYXJ2ZWxsLmNvbT4NCiAgICBDYzogSGltYW5zaHUgTWFkaGFuaSA8
aG1hZGhhbmlAbWFydmVsbC5jb20+DQogICAgU2lnbmVkLW9mZi1ieTogUm9tYW4gQm9sc2hha292
IDxyLmJvbHNoYWtvdkB5YWRyby5jb20+DQogICAgLS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9pbml0LmMgfCAxMCArKy0tLS0tLS0tDQogICAgIDEgZmlsZSBjaGFuZ2VkLCAyIGlu
c2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQogICAgDQogICAgZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5p
dC5jDQogICAgaW5kZXggMTIzOTE4MTViZTA2Li4wOTZmNDFmZTE3ZDIgMTAwNjQ0DQogICAgLS0t
IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KICAgICsrKyBiL2RyaXZlcnMvc2Nz
aS9xbGEyeHh4L3FsYV9pbml0LmMNCiAgICBAQCAtNDkzMiwxNCArNDkzMiw4IEBAIHFsYTJ4MDBf
Y29uZmlndXJlX2xvb3Aoc2NzaV9xbGFfaG9zdF90ICp2aGEpDQogICAgIAkJc2V0X2JpdChSU0NO
X1VQREFURSwgJmZsYWdzKTsNCiAgICAgCQljbGVhcl9iaXQoTE9DQUxfTE9PUF9VUERBVEUsICZm
bGFncyk7DQogICAgIA0KICAgIC0JfSBlbHNlIGlmIChoYS0+Y3VycmVudF90b3BvbG9neSA9PSBJ
U1BfQ0ZHX04pIHsNCiAgICAtCQljbGVhcl9iaXQoUlNDTl9VUERBVEUsICZmbGFncyk7DQogICAg
LQkJaWYgKHFsYV90Z3RfbW9kZV9lbmFibGVkKHZoYSkpIHsNCiAgICAtCQkJLyogYWxsb3cgdGhl
IG90aGVyIHNpZGUgdG8gc3RhcnQgdGhlIGxvZ2luICovDQogICAgLQkJCWNsZWFyX2JpdChMT0NB
TF9MT09QX1VQREFURSwgJmZsYWdzKTsNCiAgICAtCQkJc2V0X2JpdChSRUxPR0lOX05FRURFRCwg
JnZoYS0+ZHBjX2ZsYWdzKTsNCiAgICAtCQl9DQogICAgLQl9IGVsc2UgaWYgKGhhLT5jdXJyZW50
X3RvcG9sb2d5ID09IElTUF9DRkdfTkwpIHsNCiAgICArCX0gZWxzZSBpZiAoaGEtPmN1cnJlbnRf
dG9wb2xvZ3kgPT0gSVNQX0NGR19OTCB8fA0KICAgICsJCSAgIGhhLT5jdXJyZW50X3RvcG9sb2d5
ID09IElTUF9DRkdfTikgew0KICAgICAJCWNsZWFyX2JpdChSU0NOX1VQREFURSwgJmZsYWdzKTsN
CiAgICAgCQlzZXRfYml0KExPQ0FMX0xPT1BfVVBEQVRFLCAmZmxhZ3MpOw0KICAgICAJfSBlbHNl
IGlmICghdmhhLT5mbGFncy5vbmxpbmUgfHwNCiAgICAtLSANCiAgICAyLjI0LjANCiAgICANCiAg
ICANCkxvb2tzIEdvb2QuDQoNCkFja2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxobWFkaGFuaUBt
YXJ2ZWxsLmNvbT4NCg0K
