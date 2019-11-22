Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DA5C432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9478F2070E
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UNpOG4dM";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="ossQVl3O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKVWz0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 17:55:26 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23430 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfKVWzZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 17:55:25 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAMMkVdR009261;
        Fri, 22 Nov 2019 14:53:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=BuV7+8lAS0c8jv1P6A4NQmT9kyPf6aZmTTvmY8a0t4c=;
 b=UNpOG4dMR396zu6KDQYftSbHIojPuBbntaEVHS8Rr6oFdhJObpHk61qM38yVEemrG2v+
 94jkLX4JwNih3ZOeUekhEMADGjtqwgbCzwyQZTu4VQsjI7vrE0TIy/ZDJcSCFZnK6iaG
 412NJhM66v4Ho+tu/dy9UC8+ZGLumuvqI0NyQUmlu5BePhJhkn17pxDEY6sVn38gz+v8
 sfgtEj/WUyaZ8YZ1YdvsfbB9OAW5Mlm11LtZr4D13VKKEMGHYCDEsGTLeG+xk6LCCAKS
 BKHJNiVkXwo/H7dTZzNPcm0oRZS4SHv7IdUzWoEt44RuJsU1GS3lWXGJ6FNZasSCJzu8 TA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wearf3dn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 Nov 2019 14:53:58 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 22 Nov
 2019 14:53:56 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (104.47.49.54) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 22 Nov 2019 14:53:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgyOgMEtLESgZ13Dk4X+KY8OUoiE9aNX587QMX8KJLA9G+53la0ZbhS2twwyM2IQcV96LT3MAaDzp5YXu6flS5Py/t/i84yJVXlK5kDEA5Q7zt88sjWShWtmp6yvzXV2a5zcdWCevSLLZ2rei0Ny3F0ErZphOsuSdwDOCzIF+Z8tO6zy689ibB2H+ZgX4RAu65fXPTSD7YhF+y0uJt5w1Dn4LAyiV26daEeUdbdR0buefDtEBjw91KgvVgOH/JgxkImCiW+OQZ8cTph/YHxNcXEza6CNTV+uxYXCiItwUHa7oNLxAq2Sfce/BvT4JNfBfJFCtDfuSSvTorWACMEQ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuV7+8lAS0c8jv1P6A4NQmT9kyPf6aZmTTvmY8a0t4c=;
 b=gXvjNttbtJ2SsREi6PZZuaDrx+pfOf4BVwb4jQ1j5jKO4ae95EoUUrni1ubMuaqelUbe2EwiMZAQD+tal09rhUff6YUM9SjovEIF9kqXG9+nlNtOyCqHtBc754rEejL4OteF0GHLjJinth0R/4zBTa+sMww8eB7wMMj+Ry0ZMD8TPtZSL1aWhYnRJGvK91K48VS8yndKFGAn0PfLDeyIklkrwQLxDnGAZ/hoGBcFjDjSMNg8UC+dENUbZb4CeDu7gKklOP+ZLlZs0Q8JgOn9lYr2jTap9pihrK+2stlBBwh6fI9WJBricKCD5mKY3PMjqfqZyD+fXlKlYqWRvLHiHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuV7+8lAS0c8jv1P6A4NQmT9kyPf6aZmTTvmY8a0t4c=;
 b=ossQVl3OszV9KOZvQ4pQoXeXOTjsnjwlYKU7UPCtMpnvPpnGYXspbnlVUuX8HzDx3GaE7EVqRUQ/H9hVD4uTYLRMCyg1mQFaGGV2t6C34KxOnv0cj702vd/nR3QJppYvs93qNY0MAMs5y+1vFakxOXKkh8KLWDxz2HyFoPjxoVY=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2815.namprd18.prod.outlook.com (20.179.21.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 22:53:54 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2451.031; Fri, 22 Nov 2019
 22:53:54 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Martin Wilck <Martin.Wilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>
CC:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [EXT] [PATCH 0/2] scsi: qla2xxx: Fix rport removal after unzoning
Thread-Topic: [EXT] [PATCH 0/2] scsi: qla2xxx: Fix rport removal after
 unzoning
Thread-Index: AQHVoYe2arQ5SLfVh0KW3Mf0Hx2tLw==
Date:   Fri, 22 Nov 2019 22:53:54 +0000
Message-ID: <5A4623F6-6B62-4482-A62C-4D4964B3ECD7@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [2600:1700:211:eb30:19c:a516:66f9:713e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b352463-7e28-4cf3-fc19-08d76f9ed9c6
x-ms-traffictypediagnostic: MN2PR18MB2815:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB281531CB5589D35260414900D6490@MN2PR18MB2815.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(189003)(199004)(5660300002)(6116002)(76116006)(66476007)(66446008)(99286004)(66556008)(4326008)(81166006)(81156014)(8936002)(58126008)(54906003)(6506007)(64756008)(86362001)(305945005)(71190400001)(6636002)(7736002)(71200400001)(66946007)(91956017)(102836004)(14444005)(46003)(256004)(186003)(316002)(6436002)(110136005)(478600001)(2616005)(6246003)(14454004)(8676002)(2906002)(25786009)(229853002)(33656002)(6486002)(36756003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2815;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YPxjRIn7Ehp6+4cEKjo+wEC1Ttj5JnGgYQYeeh5tRCE5k2ZNGNo6VGi0jb3hc5jpDAvYb2SIX918wVnrGthY2QkkLbukFvEzLWu8frxJKmJ3RT4G2icSBLYRCXaw3PmXKEtD1iyVNcXqCqSIAuxCYlI7+XYLOreOEd9PQhjQDr3fjpCiLcjzwSWQKbN49bnfqeTT9M81k6/FSorW3WScXQBPsmNuIvQ+QIExbu8tmDpUn3wNU4t2qByZ+Vn1copCzYNvi/iQRFPmhKXble84GsMicU1Wqmnt901F2XmWkW95Lp1QdM20POZVifT222LnKY6Ez7imShL2/XUb3LJ24q6ZmiOdnOoHpg7vQkCfZnPnO9seEabpnL4VErRp/TlbbJGJVUzF7lH11yZlbc1XLLIS66dU9cZxilW/rX9/J2OYtDN8+s0Q1WSBwJJhRGlN
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C37BAA81873A14991A2AE4C2D4CDD12@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b352463-7e28-4cf3-fc19-08d76f9ed9c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 22:53:54.4487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Z2ot5lthTVTayn609bFU47E8DBfnfE2lGi+rblFJFO9vVCVh9kEvoVj7oe5Z/ifP3kepZgOylk3XpUOG93bcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2815
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-22_05:2019-11-21,2019-11-22 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDExLzIyLzE5LCA0OjE5IFBNLCAiTWFydGluIFdpbGNrIiA8TWFydGluLldpbGNr
QHN1c2UuY29tPiB3cm90ZToNCg0KICAgIEV4dGVybmFsIEVtYWlsDQogICAgDQogICAgLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KICAgIEZyb206IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPg0KICAgIA0K
ICAgIFRoZXNlIHR3byBwYXRjaGVzIGZpeCBzaW1pbGFyIHByb2JsZW1zIHRoYXQgb2NjdXIgaWYg
YW4gaW5pdGlhdG9yIHBvcnQNCiAgICBiZWxvbmdzIG9ubHkgdG8gYSBzaW5nbGUgem9uZSwgYW5k
IHRoaXMgem9uZSBpcyByZW1vdmVkIGluIHRoZSBmYWJyaWMuDQogICAgVGhlIGRyaXZlciBkb2Vz
bid0IG5vdGljZSB0aGUgcG9ydHMgYmVpbmcgcmVtb3ZlZCwgYW5kIHRoZSBkZXZpY2Ugbm9kZXMN
CiAgICBwZXJzaXN0IGluIHRoZSBob3N0LCB5aWVsZGluZyBJTyBlcnJvcnMgd2hlbiBhY2Nlc3Nl
ZC4NCiAgICANCiAgICBUaGVzZSBhcmUgcHJldHR5IG9sZCByZWdyZXNzaW9ucywgaW50cm9kdWNl
ZCBiZWZvcmUgNC4xNiwgcWxhMnh4eA0KICAgIDEwLjAwLjAwLjA0LWsuIFRoZSAiRml4ZXM6IiB0
YWdzIEkgcHJvdmlkZSBhcmUgb25seSBhcHByb3hpbWF0ZSwgYmVjYXVzZQ0KICAgIHRoZSBkcml2
ZXIgY2hhbmdlZCB0aGUgUlNDTiBoYW5kbGluZyBpbiBzZXZlcmFsIHN0ZXBzLg0KICAgIA0KICAg
IFRoZSBmaXJzdCBwYXRjaCBhZmZlY3RzIG9ubHkgImxlZ2FjeSIgRkMgYWRhcHRlcnMgdXNpbmcg
c3luY2hvbm91cw0KICAgIGZhYnJpYyBzY2FuLiBUaGUgc2Vjb25kIG9uZSBpcyBmb3IgbmV3ZXIg
YWRhcHRlcnMgdXNpbmcgYXN5bmMgc2Nhbm5pbmcsDQogICAgYW5kIGFwcGxpZXMgaWYgdGhlIEdQ
Tl9GVC9HTk5fRlQgY29tbWFuZHMgc2VudCBieSB0aGUgYWRhcHRlciBmYWlsLg0KICAgIA0KICAg
IE1hcnRpbiBXaWxjayAoMik6DQogICAgICBzY3NpOiBxbGEyeHh4OiBmaXggcnBvcnRzIG5vdCBi
ZWluZyBtYXJrIGFzIGxvc3QgaW4gc3luYyBmYWJyaWMgc2Nhbg0KICAgICAgc2NzaTogcWxhMnh4
eDogdW5yZWdpc3RlciBwb3J0cyBhZnRlciBHUE5fRlQgZmFpbHVyZQ0KICAgIA0KICAgICBkcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZ3MuYyAgIHwgMTYgKysrKysrKysrKysrKystLQ0KICAgICBk
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jIHwgIDYgKysrLS0tDQogICAgIDIgZmlsZXMg
Y2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCiAgICANCiAgICAtLSAN
CiAgICAyLjI0LjANCiAgICANCiAgIA0KTG9va3MgZ29vZC4gDQoNCkFja2VkLWJ5OiBIaW1hbnNo
dSBNYWRoYW5pIDxobWFkaGFuaUBtYXJ2ZWxsLmNvbT4NCg0K
