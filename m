Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA694C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 21:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76EED20855
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 21:39:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="v3kJwSz9";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="GWqBdTod"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfKTVj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 16:39:29 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35308 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbfKTVj2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 16:39:28 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAKLa6aw020672;
        Wed, 20 Nov 2019 13:39:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=KVqb2bcjoIe+5OcqZQEUmoNRCEqYqN2pK/p6epCXeDg=;
 b=v3kJwSz9sRwbCABMEh48M8tOxwMNnJohqiRNyVh+LmDcYzcWj2KnoOVAjm/YjCIVHAZj
 3kX9BoKbMRv4iw07Ewik76rMrwVZIVoIDePdEYecuG2wXFBjyVElh8+n9e/j3FH6z7cp
 ps2gVCGhCR84vLtALGCoZ3kyWshWHPmyGgjTQAHL92mWIZCkqnlKC5ME7F2GPIFb1EjQ
 4oLFsfkVqYJ+t7II6oK2fXV8/GZ+tr/ypXGUtlFl1sKVOdAae0JtBQXXZVuAyDm/kFdK
 sZIr/bwPuQMILnIUfULFuTNOCGGGootWPic4uTUBpcxkpVMDswTaJ4deq9pUepQyxJJ/ Qw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wc8429yyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 13:39:24 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 20 Nov
 2019 13:39:23 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.57) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 20 Nov 2019 13:39:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLEzuBNsMp0VLupkC5vFc2s5XhEutGMHosELEXMCRu5N54E9MqXziwdemh4n2oyCEvWKyyMSNyjhhHZeOuXWD2+HS367rX5edVHFe1+74aiqksj2W/D+FHaFsDKHEOrlyICYEERC9gdckiAKOVoRwlSr/c3y027D9fesc5c7ZxH2AvsvDHQdHNukxz0R2QoFimu1dKvIyhDhXbPYdcUhf0gEdsmKJnLyDHoZas7fyvra5ZPyztD8++poUC7vPQwM8eMBsu0uCiP2fQ/Talt3Yn/thZ/it1+AeIwpSfrPrhRN4FS2xjVtvyfk1hyun1coXLQOg7a/eZ0uIytlgGe8Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVqb2bcjoIe+5OcqZQEUmoNRCEqYqN2pK/p6epCXeDg=;
 b=N7c8Sk0mzJ6PmTk04yDUKDZ1GdPS7fHptAyqjFnaBdPiDLIHRw1G4hJEIkSFcmgxcK9KYe/LJtMCe50ZKa7sxyYZsuMBQL0sYZb2T/LNNAC1STG5m8y5183IB7KgvnbeXDzJaxRBGMjs7FCnJAFwFbTDKsMoHcjlfTeO7yqODdN8c9/XDQlgDU4Rt1R+30poGz6KAaCFdCXE2agouP11h5EYMztn0CKMeaKOq1a1NR5Yid+L0Zy/fQDNfSTC9DeOsVxuD9TmNizQyOiU7w7y/JjVmDjdVsuqSphbDpteLcnvzU6Cc4QIUO8CbT9F1fZHM75JtiApQG5AVP0O+5ohZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVqb2bcjoIe+5OcqZQEUmoNRCEqYqN2pK/p6epCXeDg=;
 b=GWqBdTodVVVIPEXBFv6YOxPf1XssHrrnhTrOxOeiXieHyzUES6Aq8/IOLnYaooO0pbRYCzkjYbnRXEDwfIUZmgFX/XgvgEL/a0zfhsIHxbcKUUGbKQKPnzQWMmY89n+4nPbga9okSqU/4N9Hx4VQhyMiGptDsPPGmo7tE6rvEJM=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3152.namprd18.prod.outlook.com (10.255.239.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 21:39:20 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2451.031; Wed, 20 Nov 2019
 21:39:20 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
Thread-Topic: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
Thread-Index: AQHVnzeVB3U3F9Aoxk2vuaLsnrZQ86eUl30A
Date:   Wed, 20 Nov 2019 21:39:20 +0000
Message-ID: <22154B05-853E-42D2-9B3B-749FEB9D1E51@marvell.com>
References: <20191109042135.12125-1-bvanassche@acm.org>
 <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
 <32187dd9-f222-fbed-cc93-1c6abca6e06c@acm.org>
 <19433666-FCA3-4340-8A81-707F85B87F02@marvell.com>
 <1dac96c3-54d5-11bf-292b-c25a62a3c919@acm.org>
 <fa7d57ec-77b3-3397-063e-d949716abaa8@acm.org>
In-Reply-To: <fa7d57ec-77b3-3397-063e-d949716abaa8@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2600:1700:211:eb30:6942:a80c:a21f:7035]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c475a95-c2f8-4680-9872-08d76e021a24
x-ms-traffictypediagnostic: MN2PR18MB3152:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3152D92770D9382D9840A8CDD64F0@MN2PR18MB3152.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(396003)(39840400004)(346002)(189003)(199004)(8676002)(81166006)(91956017)(64756008)(76116006)(66446008)(99286004)(229853002)(6116002)(316002)(76176011)(53546011)(6506007)(6916009)(4001150100001)(478600001)(256004)(54906003)(4326008)(86362001)(66556008)(66946007)(66476007)(6486002)(14454004)(107886003)(8936002)(6512007)(6436002)(50226002)(25786009)(6246003)(102836004)(36756003)(7736002)(2616005)(46003)(476003)(11346002)(446003)(486006)(33656002)(305945005)(5660300002)(186003)(71200400001)(71190400001)(2906002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3152;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8XcYc7wlkl+98K1Qo+8IUqu7XkAtEXBVYLE7VOJOZoiujV7n7qq8QWOouOth5dTe6aZY9c34NQCSRTKtzdgQLFHNvCmeTij2SDJi16YNay1y86YMm43ZTqkj9Ps64RA8Kn25XnkYPu/jNhCFKCjQtOj90bnufdfBuU76IX+2GfBmm8Fg/qnSDoftaWjTO8Q/0IcIn2y3XCa2ezufFfifaPQ7sslICBKPQGutenowxLv9Iup718JpRyMSUnq0wmCBbuewOUOajcOzZNigGhvbp8jFBLn9Ku5e+zibIf+PnUQT0mSaaG9O/bJTg5rZRo00TmZi1rTzlYXV0y+NmSu8av2Tvq37/hUWgcik5hGnYGi1eZ5EbudmAMpXKp5sEr4WWX7QyjfcRA6emNOsTXjvhJtHr8H0AkbMfvnGFPaNSwU6Vyg7Xq+F7q1LDMxAdiFM
Content-Type: text/plain; charset="utf-8"
Content-ID: <24AECFD9FB1F7E47B253B366908B4A74@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c475a95-c2f8-4680-9872-08d76e021a24
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 21:39:20.0162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WRgYWakEH/flPasCkwr0iq6nkCQCQEO8b6qV/mvUhZV0DjP3YgFJ1++1Np1j0e3vjSVhC1jqh6hOtDGMKd0O9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3152
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_07:2019-11-20,2019-11-20 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KDQo+IE9uIE5vdiAxOSwgMjAxOSwgYXQgNjoxNSBQTSwgQmFydCBWYW4gQXNz
Y2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+IHdyb3RlOg0KPiANCj4gT24gMTEvMTMvMTkgNjozNCBQ
TSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPj4gT24gMjAxOS0xMS0xMyAwNzoyOSwgSGltYW5z
aHUgTWFkaGFuaSB3cm90ZToNCj4+PiBPbiBOb3YgMTEsIDIwMTksIGF0IDg6NDggUE0sIEJhcnQg
VmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPiB3cm90ZToNCj4+Pj4gSGltYW5zaHUsIGNh
biB5b3UgdGVsbCB1cyB3aGljaCBhZGFwdGVycyBhbmQvb3IgZmlybXdhcmUgdmVyc2lvbnMgbmVl
ZA0KPj4+PiB3aGljaCB2ZXJzaW9uIG9mIHRoZSBhYm92ZSBjb2RlPw0KPj4+IA0KPj4+IEFsbCBh
ZGFwdGVycyB3aXRoIEZXIHY0LjQgd2lsbCBiZWhhdmUgc2FtZS4gSWYgeW91IGFyZSBydW5uaW5n
IGludG8gaXNzdWUgd2l0aCBQMlAgY29ubmVjdGlvbiwNCj4+PiBpdCBtaWdodCBiZSBzb21ldGhp
bmcgZGlmZmVyZW50IHRoYW4gc3BlY2lmaWMgdG8gdGhpcyBjb2RlIGNoYW5nZS4gT3JpZ2luYWwg
Y29kZSBpbiB0aGUgZHJpdmVyIHdhcyBub3QNCj4+PiBmb2xsb3dpbmcgZmlybXdhcmUgc3BlYy4g
VGhpcyBjb2RlIGlzIG5vdyB1c2VkIGluIGluaXRpYXRvciBtb2RlIGFzIHdlbGwgZHVlIHRvIGlu
dHJvZHVjdGlvbiBvZg0KPj4+IEZDLU5WTWUgaGFuZGxpbmcgaW4gdGhlIGRyaXZlci4gIEFsc28s
IGNhbiB5b3UgdGVsbCBtZSB3aGF0IHZlcnNpb24gb2YgZmlybXdhcmUgeW91IGhhdmUgb24geW91
cg0KPj4+IHJlbW90ZSBwb3J0Lg0KPj4gSGkgSGltYW5zaHUsDQo+PiBNeSB0ZXN0IHdhcyBydW4g
b24gYSBzZXR1cCB3aXRoIGEgc2luZ2xlIFFMRTI1NjIgYWRhcHRlciB3aXRoIGJvdGggRkMNCj4+
IHBvcnRzIGNvbm5lY3RlZCBkaXJlY3RseSB0byBlYWNoIG90aGVyLiBUaGUga2VybmVsIGRyaXZl
ciBpZGVudGlmaWVzDQo+PiB0aGF0IGFkYXB0ZXIgYXMgZm9sbG93czogSVNQMjUzMjogUENJZSAo
NS4wR1QvcyB4OCkgQCAwMDAwOjAwOjBhLjAgaGRtYSsNCj4+IGhvc3QjPTEyIGZ3PTguMDcuMDAg
KDkwZDUpLiBQbGVhc2UgbGV0IG1lIGtub3cgaWYgeW91IG5lZWQgbW9yZSBpbmZvcm1hdGlvbi4N
Cj4gDQo+IFBpbmc/DQo+IA0KPiBCYXJ0Lg0KDQoNClNvcnJ5IGZvciBkZWxheS4gQ2FuIHlvdSBz
ZW5kIG1lIGxvZyBmaWxlIHdpdGggcWwyeGV4dGVuZGVkX2Vycm9yX2xvZ2dpbmc9MHg1MjAwYjAw
MCB0byBzZWUgd2h5IHlvdSBhcmUgc2VlaW5nIGlzc3VlIGluIHlvdXIgc2V0dXAgYW5kIGlmIHBv
c3NpYmxlIHRyaWdnZXIgRlcgZHVtcCBhbmQgc2VuZCBtZSB0aGF0IGFzIHdlbGwgcmlnaHQgYWZ0
ZXIgeW91IHNlZSB0aGlzIGlzc3VlLiBJ4oCZbGwgaGF2ZSB0byBjaGVjayB3aXRoIG15IGZpcm13
YXJlIGd1eXMgb24gdGhlIGJlaGF2aW9yIHlvdSBhcmUgc2VlaW5nLg0KDQpUaGFua3MsDQpIaW1h
bnNodQ0KDQo=
