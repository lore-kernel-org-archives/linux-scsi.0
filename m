Return-Path: <SRS0=hRFu=4U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0CBC3F2CD
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 14:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E5D62086A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 14:11:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IuUcjVhI";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="RJiDiSxC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgCCOLK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Mar 2020 09:11:10 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25540 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727585AbgCCOLK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2020 09:11:10 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 023E2bsE007349;
        Tue, 3 Mar 2020 06:11:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=hEqmELqET1o0It/KKGE1QpvGa4AWvga93Z1ZcJyNdDk=;
 b=IuUcjVhI+1bI0rv3pIWDwcR1WhnM5YXIz9WnsfxXSJSdUxNjAwN35BTSybVofybsROp/
 Hk4/mkbSdI7Aqm/14Ue5uGhaLpNjG8y14uHj4YO754VEMn4+OFBhP51GBXEa/QMI/b5R
 +qSnNPfVxll52RtDYZyxWu+jMlUcuWNIjq1ZnYPEvJLAtGABXpTaJE0a2EucTCo41d8y
 0Kb2XVUs21gaHweivCkBNdcEJPf3wlxKW9jZ6aIWVmt5gbDA4J+9sWk/U3vTTrr3HsUr
 U2eykgKlwRPP58ISqhRKk+nng+0qAZYl+WQ7XjYWlwAJPyTb1KZrma2W84EncYnFbmFv xQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yhn0xs1w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Mar 2020 06:11:01 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Mar
 2020 06:10:58 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Mar
 2020 06:10:58 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 3 Mar 2020 06:10:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gl4zSl+WpaeHpeQwctDwd5ufWC3DlQ2MXWWUyM252JGFePFdy5V8C/sfnTVXf5n3PgtRbbE1PerQC3FZrocjboUtWuavEIvsoa5CTowq4Ush6vwwqDAlANaQ/aj79LgfVeaWJwxlA7gbM+COhRCgcNso15J5OOPkEyboP6YMStEMcb9kvH4VLppH0UPmw92DGZR0s3B/i727iKomPhK5elM6M1mlGH4Tyae2FLa4rUWbhFQciGI4iUFKgX5TLsQ6RVh0Fr4rthaXgfriMLdKuQkj6YCaxQZwxZsMT/JkpXQIFJ5YCOlpIvjdDb/k91jZxITpPMOccqPqu88NdKrEMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEqmELqET1o0It/KKGE1QpvGa4AWvga93Z1ZcJyNdDk=;
 b=BMn+mrtR5sfEjRqH3FLzMX1i2PTomqLOpQSQJqK9kqhOlGJRygMBJJWxdSucGQCeFsv3LWoZk9WNYHoplxQ0/7gHwVcfWC+xlUOzwWDOJsCzTTl5TIlp44FdG/d1rXZyDfWaoqQLtBtNTC27FADTcHAsOKyQ0Ff89tOG8Al+4ol0uXr0TiC9k5LpyM6Ce70Uqbg7ffv1qM7WbO27BFjtDXqxSwZDPJnzL6J2GEDjoxET0wUsBdbjS3lGCJ/d0oJFsmBEzjXKIocbyaFzK7oZTqXlnRXzDyoPD3BWlVOoWcLtNw0ftVsYdxDeAYr05ThApwNioXqDgpKYxGAN104qqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEqmELqET1o0It/KKGE1QpvGa4AWvga93Z1ZcJyNdDk=;
 b=RJiDiSxCiEvtyhVMgfKBFp91Y+ga7gYtE5ZDVo5+lXi55JxIMc5KtAs5EIP+8JMbNau+LevTPBqMQ0FowV1olVn9RIqTSOFXZUz9Kp3JfePHYLmAekyKCYyVBjvs01/Q8c8YjNFI9xx21jZYLyS+XpiSZBKBUvyP3Xl8cEcuAB4=
Received: from DM5PR1801MB1820.namprd18.prod.outlook.com (2603:10b6:4:6a::12)
 by DM5PR1801MB1979.namprd18.prod.outlook.com (2603:10b6:4:69::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19; Tue, 3 Mar
 2020 14:10:56 +0000
Received: from DM5PR1801MB1820.namprd18.prod.outlook.com
 ([fe80::3cc1:38d7:b255:9e2b]) by DM5PR1801MB1820.namprd18.prod.outlook.com
 ([fe80::3cc1:38d7:b255:9e2b%3]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 14:10:56 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 3/4] qla2xxx: Fix endianness annotations in source files
Thread-Topic: [PATCH 3/4] qla2xxx: Fix endianness annotations in source files
Thread-Index: AQHV8SYK0xrupWZUXEGFKvNWrn5+wag2hDsA
Date:   Tue, 3 Mar 2020 14:10:56 +0000
Message-ID: <A9F44BB4-8DEF-48FC-BACF-B4AC2A493A54@marvell.com>
References: <20200302033023.27718-1-bvanassche@acm.org>
 <20200302033023.27718-4-bvanassche@acm.org>
 <20200302184055.dtjktj4sbsyysk5m@beryllium.lan>
 <08d14c58-d8bb-b0ff-d81b-91373ab6a09c@acm.org>
In-Reply-To: <08d14c58-d8bb-b0ff-d81b-91373ab6a09c@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.22.0.200209
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cd025f2-e45a-4872-a0cf-08d7bf7cb132
x-ms-traffictypediagnostic: DM5PR1801MB1979:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1801MB197902A8F26ED6BF34F77F6DD6E40@DM5PR1801MB1979.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39850400004)(346002)(376002)(136003)(189003)(199004)(71200400001)(110136005)(316002)(86362001)(2906002)(54906003)(6512007)(6486002)(36756003)(26005)(2616005)(66556008)(33656002)(91956017)(76116006)(66946007)(66446008)(64756008)(66476007)(8936002)(478600001)(6506007)(186003)(8676002)(81156014)(53546011)(81166006)(4326008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR1801MB1979;H:DM5PR1801MB1820.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gSrhx6yjgEDNgCObRKg2igrYTnfj3N6m3NwVM8T9if5EYtd1X5Y6yy3Jh0ExqXEnKaeUMP5uFpBbcYL/2pGfKPDC22gRPJu3RwZbhw83gRsyF7nEvABnEwMMlcDBlzwzR9IF1/qEBmK4GgFpU9RvJ5K5+h26NqNl6pt+ee3FeJcRkxsXAIiD5XaO9dKWyX3ACtH55V3gKW6/CP0NtYdq6TGy6V/zvtj3Fkma1WJtOTYSxR92nqssICCMXIzXYgyKATiYUD9s29MwHIPbZPqnOWBmOISwyboJhZAMJce3gUth4B7mJTU3FDqoUtFtJZskXT0kxw0jsXiSpkyMCnWuLiaww1giQSnikn/igjKZkyccmEg+l+uMClM9VM0JfevKwuETpGMGB8oFKop0JKa5T1SRT0EmAlO721SZPdnwSgthhR972TKNyHz8P/UMjZDY
x-ms-exchange-antispam-messagedata: raabcYZbKkegFmHYSRgqzI6xHpo7sn1Hydq9R7bRNwiE5ReC2qEUfPAWhO/DYI7YI54VMmST4Yme1fMwVCvxM85iFoKQY/5COXn2RGpuc1WdjyqF5Je0Mfo1tggqMwVlyuW1CScJHXrjkCEXaP0U8w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <87395A29DC390048A0E4FDD0DD7BC689@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd025f2-e45a-4872-a0cf-08d7bf7cb132
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 14:10:56.4560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vOzS1FWBKt9GOiF/2hboTMH6mLEKfDSBpds4MWyDDEefBvQZY4TPn/csdH/xgmEGImiaqseyQUFpcnyaeXQFTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1801MB1979
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_04:2020-03-03,2020-03-03 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydC9EYW5pZWwsDQoNCg0K77u/T24gMy8zLzIwLCAxMjozNiBBTSwgImxpbnV4LXNjc2kt
b3duZXJAdmdlci5rZXJuZWwub3JnIG9uIGJlaGFsZiBvZiBCYXJ0IFZhbiBBc3NjaGUiIDxsaW51
eC1zY3NpLW93bmVyQHZnZXIua2VybmVsLm9yZyBvbiBiZWhhbGYgb2YgYnZhbmFzc2NoZUBhY20u
b3JnPiB3cm90ZToNCg0KICAgIE9uIDIwMjAtMDMtMDIgMTA6NDAsIERhbmllbCBXYWduZXIgd3Jv
dGU6DQogICAgPiBPbiBTdW4sIE1hciAwMSwgMjAyMCBhdCAwNzozMDoyMlBNIC0wODAwLCBCYXJ0
IFZhbiBBc3NjaGUgd3JvdGU6DQogICAgPj4gRml4IGFsbCBlbmRpYW5uZXNzIGNvbXBsYWludHMg
cmVwb3J0ZWQgYnkgc3BhcnNlIChDPTIpLg0KICAgID4gDQogICAgPiBbLi4uXQ0KICAgID4gDQog
ICAgPj4gIGludA0KICAgID4+IC1xbGEyNHh4X2R1bXBfcmFtKHN0cnVjdCBxbGFfaHdfZGF0YSAq
aGEsIHVpbnQzMl90IGFkZHIsIHVpbnQzMl90ICpyYW0sDQogICAgPj4gLSAgICB1aW50MzJfdCBy
YW1fZHdvcmRzLCB2b2lkICoqbnh0KQ0KICAgID4+ICtxbGEyNHh4X2R1bXBfcmFtKHN0cnVjdCBx
bGFfaHdfZGF0YSAqaGEsIHVpbnQzMl90IGFkZHIsIF9fYmUzMiAqcmFtLA0KICAgID4+ICsJCSB1
aW50MzJfdCByYW1fZHdvcmRzLCB2b2lkICoqbnh0KQ0KICAgID4+ICB7DQogICAgPj4gIAlpbnQg
cnZhbCA9IFFMQV9GVU5DVElPTl9GQUlMRUQ7DQogICAgPj4gIAlzdHJ1Y3QgZGV2aWNlX3JlZ18y
NHh4IF9faW9tZW0gKnJlZyA9ICZoYS0+aW9iYXNlLT5pc3AyNDsNCiAgICA+PiAgCWRtYV9hZGRy
X3QgZHVtcF9kbWEgPSBoYS0+Z2lkX2xpc3RfZG1hOw0KICAgID4+IC0JdWludDMyX3QgKmNodW5r
ID0gKHZvaWQgKiloYS0+Z2lkX2xpc3Q7DQogICAgPj4gKwl1aW50MzJfdCAqY2h1bmsgPSAodWlu
dDMyX3QgKiloYS0+Z2lkX2xpc3Q7DQogICAgPj4gIAl1aW50MzJfdCBkd29yZHMgPSBxbGEyeDAw
X2dpZF9saXN0X3NpemUoaGEpIC8gNDsNCiAgICA+PiAgCXVpbnQzMl90IHN0YXQ7DQogICAgPj4g
IAl1bG9uZyBpLCBqLCB0aW1lciA9IDYwMDAwMDA7DQogICAgPj4gQEAgLTI1Miw5ICsyNTIsOSBA
QCBxbGEyNHh4X2R1bXBfcmFtKHN0cnVjdCBxbGFfaHdfZGF0YSAqaGEsIHVpbnQzMl90IGFkZHIs
IHVpbnQzMl90ICpyYW0sDQogICAgPj4gIAkJCXJldHVybiBydmFsOw0KICAgID4+ICAJCX0NCiAg
ICA+PiAgCQlmb3IgKGogPSAwOyBqIDwgZHdvcmRzOyBqKyspIHsNCiAgICA+PiAtCQkJcmFtW2kg
KyBqXSA9DQogICAgPj4gLQkJCSAgICAoSVNfUUxBMjdYWChoYSkgfHwgSVNfUUxBMjhYWChoYSkp
ID8NCiAgICA+PiAtCQkJICAgIGNodW5rW2pdIDogc3dhYjMyKGNodW5rW2pdKTsNCiAgICA+PiAr
CQkJcmFtW2kgKyBqXSA9IChfX2ZvcmNlIF9fYmUzMikNCiAgICA+PiArCQkJCSgoSVNfUUxBMjdY
WChoYSkgfHwgSVNfUUxBMjhYWChoYSkpID8NCiAgICA+PiArCQkJCSBjaHVua1tqXSA6IHN3YWIz
MihjaHVua1tqXSkpOw0KICAgID4gDQogICAgPiBJc24ndCB0aGlzIGFzc3VtaW5nIHRoZSBob3N0
IHJ1bnMgaW4gbGl0dGxlIGVuZGlhbiBtb2RlPyBCZWNhdXNlIGxhdGVyIGRvd24uLi4NCiAgICAN
CiAgICBNeSBnb2FsIHdhcyBub3QgdG8gY2hhbmdlIHRoZSBiZWhhdmlvciBvZiB0aGUgY29kZSBv
biB4ODYuIEJ1Z3Mgb24gYmlnDQogICAgZW5kaWFuIHN5c3RlbXMgY2FuIGJlIGZpeGVkIGxhdGVy
IG9uIChteSBndWVzcyBpcyB0aGF0IHRoaXMgZHJpdmVyIGRvZXMNCiAgICBub3Qgd29yayByZWxp
YWJseSBvbiBiaWcgZW5kaWFuKSwgYW5kIHNlYXJjaGluZyB0aHJvdWdoIHRoZSBjb2RlIGZvcg0K
ICAgIF9fZm9yY2UgY2FzdHMgcHJvYmFibHkgcHJvdmlkZXMgc29tZSBnb29kIHN0YXJ0aW5nIHBv
aW50cy4NCiAgICANCldlIGhhZCBtYWRlIHN1cmUgZHJpdmVyIHdvcmtzIG9uIGJpZyBlbmRpYW4g
c3lzdGVtIGFuZCB0aGUgcmVhc29uIHRoZXNlIHdlcmUgbm90IGNoYW5nZWQgd2FzIHRvIG1ha2Ug
c3VyZSBpdCBkb2VzIG5vdCBicmVhayBiaWcgZW5kaWFuIGFyY2hpdGVjdHVyZS4gIEl0J3MgYmVl
biBhIGZldyB5ZWFycyBzaW5jZSBJIHZlcmlmaWVkIGJpZyBlbmRpYW4gY29tcGF0aWJpbGl0eSB3
aXRoIHRoZSBkcml2ZXIsIGJ1dCBJIGFtIGhlc2l0YW50IHRvIGdvIGNoYW5nZSB0aGluZ3Mgd2l0
aG91dCBtYWtpbmcgc3VyZSBpdCB3b3JrcyBvbiBiaWcgZW5kaWFuIHN5c3RlbXMuIFdlIGFyZSB0
YWtpbmcgYmlnIHJpc2sgb2YgYmxpbmRseSBjaGFuZ2luZyB0aGluZ3MuIA0KDQpJJ2xsIGFzayBv
dXIgdGVzdGluZyBmb2xrcyB0byB0ZXN0IHRoaXMgb3V0IGFuZCBzZWUgaWYgd2UgZGlzY292ZXIg
aXNzdWUgd2l0aCB0aGVzZSBjaGFuZ2VzLiBVbnRpbCB0aGVuIEknbGwgaG9sZCBvZmYgb24gQWNj
ZXB0aW5nIGNoYW5nZXMuDQoNCiAgICA+PiBAQCAtNDM5LDcgKzQzOSw3IEBAIHFsYTJ4eHhfZHVt
cF9yYW0oc3RydWN0IHFsYV9od19kYXRhICpoYSwgdWludDMyX3QgYWRkciwgdWludDE2X3QgKnJh
bSwNCiAgICA+PiAgCQlpZiAodGVzdF9hbmRfY2xlYXJfYml0KE1CWF9JTlRFUlJVUFQsICZoYS0+
bWJ4X2NtZF9mbGFncykpIHsNCiAgICA+PiAgCQkJcnZhbCA9IG1iMCAmIE1CU19NQVNLOw0KICAg
ID4+ICAJCQlmb3IgKGlkeCA9IDA7IGlkeCA8IHdvcmRzOyBpZHgrKykNCiAgICA+PiAtCQkJCXJh
bVtjbnQgKyBpZHhdID0gc3dhYjE2KGR1bXBbaWR4XSk7DQogICAgPj4gKwkJCQlyYW1bY250ICsg
aWR4XSA9IGNwdV90b19iZTE2KGxlMTZfdG9fY3B1KGR1bXBbaWR4XSkpOw0KICAgID4gDQogICAg
PiAuLi4gY3B1X3RvX2JlMTYoKSBpcyB1c2VkLg0KICAgIA0KICAgIFRoZSBhYm92ZSBjb2RlIGlt
cGxlbWVudHMgc3dhYjE2KCkgYnV0IHdpdGhvdXQgdHJpZ2dlcmluZyBzcGFyc2UNCiAgICBlbmRp
YW5uZXNzIHdhcm5pbmdzLg0KICAgIA0KICAgID4+ICAJCWlmICghKnNyaXNjX2FkZHIpIHsNCiAg
ICA+PiAgCQkJKnNyaXNjX2FkZHIgPSByaXNjX2FkZHI7DQogICAgPj4gLQkJCXJpc2NfYXR0ciA9
IGJlMzJfdG9fY3B1KGRjb2RlWzldKTsNCiAgICA+PiArCQkJcmlzY19hdHRyID0gc3dhYjMyKGRj
b2RlWzldKTsNCiAgICA+PiAgCQl9DQogICAgPiANCiAgICA+IGFsc28gaGVyZSwgdGhpcyBsb29r
cyBsaWtlIGhhcmRjb2RlZCBlbmRpYW5lc3MuDQogICAgDQogICAgSXQgd2FzIG5vdCBjbGVhciB0
byBtZSB3aGV0aGVyIHRoZSBwdXJwb3NlIG9mIHRoZSBjb2RlIHdhcyB0byBjb252ZXJ0DQogICAg
ZnJvbSBfX2JlMzIgdG8gQ1BVIGVuZGlhbm5lc3Mgb3IgZnJvbSBfX2JlMzIgdG8gX19sZTMyLg0K
ICAgIA0KICAgID4+IEBAIC0zMzk4LDcgKzMzOTksNyBAQCBxbGE4Mnh4X3N0YXJ0X3Njc2koc3Ji
X3QgKnNwKQ0KICAgID4+ICANCiAgICA+PiAgCQltZW1jcHkoY3R4LT5mY3BfY21uZC0+Y2RiLCBj
bWQtPmNtbmQsIGNtZC0+Y21kX2xlbik7DQogICAgPj4gIA0KICAgID4+IC0JCWZjcF9kbCA9ICh1
aW50MzJfdCAqKShjdHgtPmZjcF9jbW5kLT5jZGIgKyAxNiArDQogICAgPj4gKwkJZmNwX2RsID0g
KHZvaWQgKikoY3R4LT5mY3BfY21uZC0+Y2RiICsgMTYgKw0KICAgID4+ICAJCSAgICBhZGRpdGlv
bmFsX2NkYl9sZW4pOw0KICAgID4gDQogICAgPiBTaG91bGRuJ3QgdGhpcyBiZSAoX19iZTMyKik/
DQogICAgDQogICAgR29vZCBjYXRjaC4gSSB3aWxsIGNoYW5nZSB0aGUgY2FzdC4NCiAgICANCiAg
ICA+PiBAQCAtMzUzNyw3ICszNTQwLDcgQEAgcWxhMjR4eF9nZXRfZmxhc2hfdmVyc2lvbihzY3Np
X3FsYV9ob3N0X3QgKnZoYSwgdm9pZCAqbWJ1ZikNCiAgICA+PiAgCX0NCiAgICA+PiAgDQogICAg
Pj4gIAlmb3IgKGkgPSAwOyBpIDwgNDsgaSsrKQ0KICAgID4+IC0JCWhhLT5nb2xkX2Z3X3ZlcnNp
b25baV0gPSBiZTMyX3RvX2NwdShkY29kZVs0K2ldKTsNCiAgICA+PiArCQloYS0+Z29sZF9md192
ZXJzaW9uW2ldID0gc3dhYjMyKGRjb2RlWzQraV0pOw0KICAgID4+ICANCiAgICA+PiAgCXJldHVy
biByZXQ7DQogICAgPj4gIH0NCiAgICA+IA0KICAgID4gSGVyZSBhZ2FpbiB3aHkgdGhlIHN3YWIz
MigpIGNhbGwuDQogICAgSSB3aWxsIHJlc3RvcmUgdGhlIGJlMzJfdG9fY3B1KCkgY2FsbC4NCiAg
ICANCiAgICBCYXJ0Lg0KICAgIA0KDQo=
