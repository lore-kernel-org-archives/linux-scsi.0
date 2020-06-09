Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8A8C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 06:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7CE20812
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 06:01:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=temperror (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="VxXDU4+H";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="eW/bGrFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgFIGBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 02:01:14 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44208 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726886AbgFIGBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 02:01:12 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0595pfVT020929;
        Mon, 8 Jun 2020 23:01:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=cU9YFgm2vK5VsvLksEA3rg/+mLFDQVoBd8JzRUE5sOg=;
 b=VxXDU4+HoTY2aGfYIShAEcMrbgrJNqMzYVUsfPBOe0+1XWk+41csoAPlZPKSQ80lAIzz
 EJVxcvvExAlIBBla0eic6Es0JozcxuwqSk/g5zO7jtqDsGHegPpVfV6zhdPVDr4sDKSZ
 tTNJH/5ld54EcJaLAfRf8U3CpZIeFNOGA/9g+Gn8jqXIaDy+Xbqc1US9Cvc0K5DGZVBn
 dC38Br0p1SGTLppFOmlqDyG+cGFORrsVldXenacX2gI+dXAHF0nCeLu47XcqvAPfZgw2
 JjdRElAml/BsqJUhnqV+685V/pHZfGciFNb574myYTsGT9m6G0O0Wcj3dnNE8d/zqAmM cQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31gann8cd2-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 23:01:08 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Jun
 2020 23:01:07 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.56) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 8 Jun 2020 23:01:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=db12wTc/+IRS7Nt/DNiGPyquWgK41Gc7y/dsrINUh7tkA5Kw1A7vpuWEQWhd88tF7m6DHmZ6zHp2f7dA0OXWwKIylYC5dnbRJ8i2ZkxF3+zaV+DEA9msQjSugG7e2Nuav1EESEdsaM+GR4NpFkOP0U4pkmDS7mmhy7uccb+NZW/DmXCMk9VWDLbfcblFV3piEuScQ3zt8cXEvBQuVo7LSBNXzQ1/UtZDGEn71L7zCxz+y8ZDbBo6G+fv1Fz7JrReq3zdW7eBq0Uxe+c6139WQs8fuPx6bgqUxxBADyDJH19EJ5Z0FHnXnc/+WczN4vQ+wjVLWmNkMgln78hH8aS0gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cU9YFgm2vK5VsvLksEA3rg/+mLFDQVoBd8JzRUE5sOg=;
 b=mdDceKJZr1RRsSQjeH3l3nXXF/74e1kCMSPHIqcLubXnYXb/lvE4rpV9uDADFuEu4Ck388PgGLFRqVi9Kon4tKmjxlqF49oeacD1J89XFq4zfDRC2FXs2XZoI+Hb0r3KNWB27po/TjqrCZ+ssZU7lb5X4TOlI2f+mFBHcLEJI7/RFwQNt+ESfn9GE2laA9eOkFwCkWXBcIZpMjxPZi0sFEg5amHHpz8SGKKjbBGbShRKT0+4zTJ0o1kMb3OI+TDH9XEne/Twl2L3JlDMrpv4WNe+ZTcUIaVQcgqORQHjnsevo6OaoeGQ+85YJjk0xmFBCSgeKOyBcRCD6S/zb2rvQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cU9YFgm2vK5VsvLksEA3rg/+mLFDQVoBd8JzRUE5sOg=;
 b=eW/bGrFvUrzjfJjRPVTKa7w7BOjkUvQsDxpLQdhSfNitrciinNIyqxyZCV+ysHYjFd/7oBnj2fLVi5iPXC7UEy2NbWsSMoxCLS3H+LcVnfw16UuipYzaqwRq0pd0zc4E72AJ7kNJ2BAFO0VxFlSEWLqq5d7mhJ83eWA+bzsvy9g=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM6PR18MB2460.namprd18.prod.outlook.com (2603:10b6:5:186::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Tue, 9 Jun
 2020 06:01:05 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::8020:59f7:b45b:45b7]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::8020:59f7:b45b:45b7%6]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 06:01:05 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH v2 1/2] qla2xxx: Change in PUREX to handle FPIN
 ELS requests.
Thread-Topic: [EXT] Re: [PATCH v2 1/2] qla2xxx: Change in PUREX to handle FPIN
 ELS requests.
Thread-Index: AQHWPcU/TrwhXsmIcEiLwTolV1QHUKjPHMiAgACtUmA=
Date:   Tue, 9 Jun 2020 06:01:05 +0000
Message-ID: <DM6PR18MB3052470BBCFC4F6857B28624AF820@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20200608184630.31574-1-njavali@marvell.com>
 <20200608184630.31574-2-njavali@marvell.com>
 <1e2939f1-d117-d548-722c-730e9f21e2de@acm.org>
In-Reply-To: <1e2939f1-d117-d548-722c-730e9f21e2de@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.98.122.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2160b495-63f3-453c-b0b1-08d80c3a7f49
x-ms-traffictypediagnostic: DM6PR18MB2460:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB24609EF5B5508E17D82936D3AF820@DM6PR18MB2460.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +BtgWaXPdCz7AK4o75mAPtbo4gTwcvrxGUTfxBybw+yjEshH6ljwxmnLwVPEImXATnd61dU3CH6QZxQ9guT7lmlVPn1r2jBtuC+F5UQrv5tWWYm8T6jz1NXO4pn2JuAyBzaSM+G76WOc4b9cGc6iiXjahIRKLPXhJBsMBqghKCM32LlAMMNbPS7Lo/qG1Goqw9Ndq5/lCXGSuxlGRPXp6Xz0hUiWro2QZnmeN1ZV4LdzXnfDoVAhnXzZclzY6Nd/pZmwU4i+3aKOpadov/UIK3nN3/G1oyDhDuwodW6vNOTOVUSB7IMRR1knDuyiDe910hxKDqOyUejHmXo5MBrgiMOFLq2/aSvgWpHt3rC202n+T3sXI7Nuu1ptYiaOcM+pmMPGHamoqewtVWe2IRztug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(33656002)(316002)(66946007)(76116006)(66556008)(5660300002)(66476007)(52536014)(71200400001)(66446008)(107886003)(8676002)(64756008)(8936002)(83380400001)(7696005)(478600001)(55016002)(2906002)(186003)(26005)(86362001)(110136005)(4326008)(6506007)(54906003)(9686003)(966005)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FCWEjrQNc147vcaMUny0N42M7vfvMbCvGda+WiyS2LIvQjuZYRuyDvoQ9F2JnMks6JLcsJGK3lhKpTVW61VbIv+Slj1pRvis+Mb5+V9euaXDV3WpfpzAZrUY3SrAkVGQSgDo4HvFl/xMzTdycsThJ2ke3kI7UGfCVqWQkVy0R/248HoUURcybB5zSUxDTqTXnTKVzLUelHk8MLD/MaoRWxE9FtoSE77+SVZz+YcbmMBQ6ZC1vMKQj8/ZwW2uKXRQKl03TQ513mxx9dG1sU3GYo9SIIVM6XdgW2gKzDON1CsumNvTXPHGqJMgnQrmYezMUkWUa7U70dIwazUOwMIhl7QOUNqDyKFwaH6KSOSuCDHMCA9RKFDcIVq07KsE9HCn6v31gW9UF+7EyfZUBj0B8YLs9g5Uf4jDtXH08aWmzkMd3SlEP6+RQuFDw6ZVMPveW8svBAVHgzl158EuRzBMSMlQ4E8xdpEITlKw2lTlTIU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2160b495-63f3-453c-b0b1-08d80c3a7f49
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 06:01:05.5217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8PyMhlUVe4zYSA5q5dVCTNafGxZVkGoQukMFo6TVazbJ3sr9JubBypBxClwrweR9L1T43acFhRKa+jAjE5GlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2460
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-09_01:2020-06-08,2020-06-09 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QmFydCwNCg0KU3VyZSwgSSB3b3VsZCByZW1vdmUgdGhlIHRhZ3MgYW5kIHJlLXBvc3QgdGhlIHBh
dGNoIHNldC4NCg0KVGhhbmtzLA0KTmlsZXNoDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCj4gRnJvbTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IFNlbnQ6
IFR1ZXNkYXksIEp1bmUgOSwgMjAyMCAxOjA3IEFNDQo+IFRvOiBOaWxlc2ggSmF2YWxpIDxuamF2
YWxpQG1hcnZlbGwuY29tPjsgbWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20NCj4gQ2M6IGxpbnV4
LXNjc2lAdmdlci5rZXJuZWwub3JnOyBHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbSA8R1ItUUxv
Z2ljLQ0KPiBTdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwuY29tPg0KPiBTdWJqZWN0OiBbRVhUXSBS
ZTogW1BBVENIIHYyIDEvMl0gcWxhMnh4eDogQ2hhbmdlIGluIFBVUkVYIHRvIGhhbmRsZSBGUElO
DQo+IEVMUyByZXF1ZXN0cy4NCj4gDQo+IEV4dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tDQo+IE9uIDIwMjAtMDYtMDggMTE6NDYsIE5pbGVzaCBKYXZhbGkgd3JvdGU6DQo+ID4gRnJv
bTogU2h5YW0gU3VuZGFyIDxzc3VuZGFyQG1hcnZlbGwuY29tPg0KPiA+DQo+ID4gU0FOIENvbmdl
c3Rpb24gTWFuYWdlbWVudCBnZW5lcmF0ZXMgRUxTIHBrdHMgd2hvc2Ugc2l6ZQ0KPiA+IGNhbiB2
YXJ5LCBhbmQgYmUgPiA2NCBieXRlcy4gQ2hhbmdlIHRoZSBwdXJleA0KPiA+IGhhbmRsaW5nIGNv
ZGUgdG8gc3VwcG9ydCBub24gc3RhbmRhcmQgRUxTIHBrdCBzaXplLg0KPiA+DQo+ID4gU2lnbmVk
LW9mZi1ieTogU2h5YW0gU3VuZGFyIDxzc3VuZGFyQG1hcnZlbGwuY29tPg0KPiA+IFJldmlld2Vk
LWJ5OiBBcnVuIEVhc2kgPGFlYXNpQG1hcnZlbGwuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBCYXJ0
IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gPiBSZXZpZXdlZC1ieTogSGltYW5z
aHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFuaUBvcmFjbGUuY29tPg0KPiA+IFJldmlld2VkLWJ5
OiBKYW1lcyBTbWFydCA8amFtZXMuc21hcnRAYnJvYWRjb20uY29tPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+DQo+IA0KPiBIYXMgYW55b25l
IG90aGVyIHRoYW4gSGltYW5zaHUgZXZlciBwb3N0ZWQgYSBwb3NpdGl2ZSByZXZpZXcgZm9yIHRo
aXMNCj4gcGF0Y2g/IEkgY2FuJ3QgZmluZCB0aGUgb3RoZXIgcmV2aWV3IHRhZ3MgaGVyZToNCj4g
aHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLQ0KPiAzQV9f
bG9yZS5rZXJuZWwub3JnX2xpbnV4LTJEc2NzaV8yMDIwMDUxNDEwMTAyNi4xMDA0MC0yRDEtMkRu
amF2YWxpLQ0KPiA0MG1hcnZlbGwuY29tXyZkPUR3SUNhUSZjPW5LaldlYzJiNlIwbU95UGF6N3h0
ZlEmcj1GQVc5d3V6YnRIDQo+IElaTDdTVjYzc3I4ckc1OUhjdHUtZUd1MEc5cHh3T1hnUSZtPVdy
S3NqbjhpbHpWbjMycS0NCj4gOWVNSGJuVVV2bDFjcGowNm40ZktxOEtmQmhjJnM9Z20ySjBHaDNo
b3RnZW5MYWU5dUZ2ZkNpRDlNSzdpWUduDQo+IGFZaFlyblN3enMmZT0NCj4gDQo+IEJhcnQuDQo=
