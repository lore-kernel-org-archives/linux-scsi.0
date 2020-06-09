Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D4FC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 09:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79857207ED
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 09:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="IA8lvZI2";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="NF7n43vd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgFIJQW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 05:16:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39274 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726187AbgFIJQV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 05:16:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0599BYN0011939;
        Tue, 9 Jun 2020 02:16:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=SYd8kDnbG3P/Ba2FNQ2SY5a+/lNAI7Th4B7tuLEbAvE=;
 b=IA8lvZI2CCbtBZNTho+TliCzPn3l/UqdcojLwBtftE8lsH8WQ+Rz4u88QFWtXdM/IHYi
 bAp4tMxYMLsmQBSPuMGxU29wkgF3vFv3F4Q3mEukz7WAn+nFE4cZFmeDrCJW/tcEqix0
 xSrReBCFTt/q40MkcbYLr3EFDRL9zgR8YUFd0NuKubIYaFIhjsYcN732waHqpEDfwLWz
 LrrWwhYSHZpiIkTBjD04FraH/DVGFLWUo8uUybfnvfKbUXCLohCHajeRGl/YPLK4QVaz
 LBaErIvzZe65vwSVmuSVrMn6gK9x4ygsXoKN4d0sPCQk0shLnuwrsGIkBhePBFDUb5// 6g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 31j77dg2jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 02:16:18 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Jun
 2020 02:16:17 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 9 Jun 2020 02:16:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoK/tS25iSQS3F4G3Y6TVMtY+vRm2pVyIyg8iQh9iLKsrdBKOOzPePDWgTZnFhDqzNShydawGCwlouMzu/6H+bfz/aFWs+2NgwLQ107kRx1zfplhNWBvj7+EENG99aaiRFU2jAuBow6+SC/kNcJY9zbEL0siGhZO85eU1HIpJ4KRYzREOjX2q6Na4JK2pA+2q38KqbPoQbVoRtLOmSn/OAs1kZtiyP9oGRw4vmfigVFyqtML100H8bV4EY9vHTD30NwPH5JkxQ/dgymmWDDt8gtQDbTV0HEH3NMUqQVUGaRGuGmSMTcYK84piFNbjqE5+x+oft3Q3U/trS30+pAl6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYd8kDnbG3P/Ba2FNQ2SY5a+/lNAI7Th4B7tuLEbAvE=;
 b=QbWBAIWKARMiwMW6vVTnQS8RfKBl3r+t0/xaZULrzU65j0mSynCQ5hMLNVhwcQeMbWqzaFbq5nVavU70qSUCV6VlmLWyYzaOn5XMeFSnHggbeSRp8wbkofQSk4X+93cvPLPk+NATVBK9sF/ZrbVJTjOt3h24rN+Jplskr7gJIpWE3Te1HDx+lJF4zBYELyAuhGGUAAVBDW/E45nHPZ8h3kcCCnA+mcaZEAVLNG6PuUzbRe7DAiLjBVKUbfD5FEOZkx4MP6HQm+FpoogI9bh0kWGcXjUROUyAZX34KKYYq9A1krzWHLZxVtuG+MVNaqMAnJUr16ngrQsYyUfOdmY4zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYd8kDnbG3P/Ba2FNQ2SY5a+/lNAI7Th4B7tuLEbAvE=;
 b=NF7n43vdEjd8GHIINm757jqas9llTFhdvu1rvikyf1se0WoVmQcShCT+0K887Db7b/FRuK5647djk9g3RCskEgMyp4RZ7m3YymY18CkIF+OGZvXA3KZma2PIwxmeXugduBz6EFhks56SFmdJx61O32hGHNZVBQG9G3X7qHpONtI=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM6PR18MB3164.namprd18.prod.outlook.com (2603:10b6:5:1ca::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Tue, 9 Jun
 2020 09:16:14 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::8020:59f7:b45b:45b7]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::8020:59f7:b45b:45b7%6]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 09:16:14 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH v2 1/2] qla2xxx: Change in PUREX to handle FPIN
 ELS requests.
Thread-Topic: [EXT] Re: [PATCH v2 1/2] qla2xxx: Change in PUREX to handle FPIN
 ELS requests.
Thread-Index: AQHWPcU/TrwhXsmIcEiLwTolV1QHUKjPHMiAgACtUmCAADaMkA==
Date:   Tue, 9 Jun 2020 09:16:14 +0000
Message-ID: <DM6PR18MB30522A5AB1A15FBE028AD0BFAF820@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20200608184630.31574-1-njavali@marvell.com>
 <20200608184630.31574-2-njavali@marvell.com>
 <1e2939f1-d117-d548-722c-730e9f21e2de@acm.org>
 <DM6PR18MB3052470BBCFC4F6857B28624AF820@DM6PR18MB3052.namprd18.prod.outlook.com>
In-Reply-To: <DM6PR18MB3052470BBCFC4F6857B28624AF820@DM6PR18MB3052.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.98.120.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e88b5b1-ba76-4037-27b6-08d80c55c276
x-ms-traffictypediagnostic: DM6PR18MB3164:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB3164E0F4269CB9A9410FF861AF820@DM6PR18MB3164.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CbGqjBpXiR7KAAmEp1QYZpHKTGSMbuL/OKglWmHJsS24UQx2PKx2vx9b8WZFzWzBrOu10PkL1/9+nQlXJYfEuMFv4v2E/WHaVxofSbGb2J4ljHX2iMwWFtV/AN2GZVEt/z/+YfDjDiieemBDAR/Uvd62jaZLyTDyOFouH/Da/nBFwb31Pbkhy2ANwrnGvm+ClJNpI3nPlwWHEt5laqjenxcLb3TFGtE8uf29uy0pCkdAex1LQ2ow3leX+EeTcCfGe048DgkIqIJ6eGQERQj/6wpffKN95e+j6E7Vszns7mFXnIthY7phSOcKVsonDh3jfjOAqfKFWB9YFvlIKIjsPQtM5zHsvOT1ncdYLrU3Gihed+Xrm+/XHUe+m/ZHk8fXRVCZGPNG6R1aFTSLYDDtbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(8936002)(5660300002)(86362001)(33656002)(4326008)(55016002)(26005)(316002)(186003)(9686003)(110136005)(478600001)(7696005)(54906003)(966005)(53546011)(6506007)(2906002)(66946007)(66446008)(66556008)(66476007)(76116006)(64756008)(107886003)(2940100002)(83380400001)(52536014)(8676002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: v7h4MV6Z42AMy7G8zXiPDzx15b7wLjw7BFpd43kpSd8GHyEm0uVykG3AGTqGS+IW1R6ARrLpCnvHvIkOyjrqtSLS3xxDLBU6LfAcnpRHtuD0rfxFA95fQHcxm2JwwdBM6F2qESJ7n7EGsP9YpcJcVXYHBdw4jE2Hsedn6gDuU/MRod0ALvFNmGtGJWZX0EDbU8FOxxVyjE06covVZGmCRcge9WONj04o6okExslm2OSl9GWc9Zr7fgvGJcnDwyOHH3oEIFwTQh6sTBKvWJDbjiAaST5KQgTO01io6FRJmT/pG+unDhv/Z3gNrZKEfJhQPeQKIApBOTgTG24/8cPLd3H3V+vZtKhNgdzTuwY8FIq1Pm2NCdVMriSr7MmQ297PPYDQkItsRlXtrNczmh7y61w0GurpACFBv//nGHNwCIohqXFHuGXULM4pZ8KUt+YeQsDBWlio2BQZhhYC5cKYMV91sxKZRM6dS3ycdfDiWlg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e88b5b1-ba76-4037-27b6-08d80c55c276
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 09:16:14.5492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xNWA0lkUvttVwelNk8unjQw2UIwNiJq/2gISQaTPF2HS538L5dWa2LIvxaDsX5NJzDXBJfW4F6pd4gOFx+3bTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3164
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-09_03:2020-06-08,2020-06-09 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QmFydCwNCg0KV2UgaGF2ZSB0aGVzZSBwYXRjaGVzIGludGVybmFsbHkgcmV2aWV3ZWQsIHNvIGlz
IGl0IGFscmlnaHQgdG8ga2VlcCB0aGUgcmV2aWV3ZWQtYnkgdGFnIGZvciBpbnRlcm5hbCByZXZp
ZXdlciwgQXJ1biBFYXNpLg0KDQpUaGFua3MsDQpOaWxlc2gNCg0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0K
PiBTZW50OiBUdWVzZGF5LCBKdW5lIDksIDIwMjAgMTE6MzEgQU0NCj4gVG86IEJhcnQgVmFuIEFz
c2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPjsgbWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20NCj4g
Q2M6IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVh
bSA8R1ItUUxvZ2ljLQ0KPiBTdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwuY29tPg0KPiBTdWJqZWN0
OiBSRTogW0VYVF0gUmU6IFtQQVRDSCB2MiAxLzJdIHFsYTJ4eHg6IENoYW5nZSBpbiBQVVJFWCB0
byBoYW5kbGUNCj4gRlBJTiBFTFMgcmVxdWVzdHMuDQo+IA0KPiBCYXJ0LA0KPiANCj4gU3VyZSwg
SSB3b3VsZCByZW1vdmUgdGhlIHRhZ3MgYW5kIHJlLXBvc3QgdGhlIHBhdGNoIHNldC4NCj4gDQo+
IFRoYW5rcywNCj4gTmlsZXNoDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+
ID4gRnJvbTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+ID4gU2VudDog
VHVlc2RheSwgSnVuZSA5LCAyMDIwIDE6MDcgQU0NCj4gPiBUbzogTmlsZXNoIEphdmFsaSA8bmph
dmFsaUBtYXJ2ZWxsLmNvbT47IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tDQo+ID4gQ2M6IGxp
bnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbSA8R1It
UUxvZ2ljLQ0KPiA+IFN0b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20+DQo+ID4gU3ViamVjdDog
W0VYVF0gUmU6IFtQQVRDSCB2MiAxLzJdIHFsYTJ4eHg6IENoYW5nZSBpbiBQVVJFWCB0byBoYW5k
bGUgRlBJTg0KPiA+IEVMUyByZXF1ZXN0cy4NCj4gPg0KPiA+IEV4dGVybmFsIEVtYWlsDQo+ID4N
Cj4gPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gT24gMjAyMC0wNi0wOCAxMTo0NiwgTmlsZXNoIEphdmFs
aSB3cm90ZToNCj4gPiA+IEZyb206IFNoeWFtIFN1bmRhciA8c3N1bmRhckBtYXJ2ZWxsLmNvbT4N
Cj4gPiA+DQo+ID4gPiBTQU4gQ29uZ2VzdGlvbiBNYW5hZ2VtZW50IGdlbmVyYXRlcyBFTFMgcGt0
cyB3aG9zZSBzaXplDQo+ID4gPiBjYW4gdmFyeSwgYW5kIGJlID4gNjQgYnl0ZXMuIENoYW5nZSB0
aGUgcHVyZXgNCj4gPiA+IGhhbmRsaW5nIGNvZGUgdG8gc3VwcG9ydCBub24gc3RhbmRhcmQgRUxT
IHBrdCBzaXplLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFNoeWFtIFN1bmRhciA8c3N1
bmRhckBtYXJ2ZWxsLmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5OiBBcnVuIEVhc2kgPGFlYXNpQG1h
cnZlbGwuY29tPg0KPiA+ID4gUmV2aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2No
ZUBhY20ub3JnPg0KPiA+ID4gUmV2aWV3ZWQtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhpbWFuc2h1
Lm1hZGhhbmlAb3JhY2xlLmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5OiBKYW1lcyBTbWFydCA8amFt
ZXMuc21hcnRAYnJvYWRjb20uY29tPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTmlsZXNoIEphdmFs
aSA8bmphdmFsaUBtYXJ2ZWxsLmNvbT4NCj4gPg0KPiA+IEhhcyBhbnlvbmUgb3RoZXIgdGhhbiBI
aW1hbnNodSBldmVyIHBvc3RlZCBhIHBvc2l0aXZlIHJldmlldyBmb3IgdGhpcw0KPiA+IHBhdGNo
PyBJIGNhbid0IGZpbmQgdGhlIG90aGVyIHJldmlldyB0YWdzIGhlcmU6DQo+ID4gaHR0cHM6Ly91
cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLQ0KPiA+IDNBX19sb3JlLmtl
cm5lbC5vcmdfbGludXgtMkRzY3NpXzIwMjAwNTE0MTAxMDI2LjEwMDQwLTJEMS0yRG5qYXZhbGkt
DQo+ID4NCj4gNDBtYXJ2ZWxsLmNvbV8mZD1Ed0lDYVEmYz1uS2pXZWMyYjZSMG1PeVBhejd4dGZR
JnI9RkFXOXd1emJ0SA0KPiA+IElaTDdTVjYzc3I4ckc1OUhjdHUtZUd1MEc5cHh3T1hnUSZtPVdy
S3NqbjhpbHpWbjMycS0NCj4gPg0KPiA5ZU1IYm5VVXZsMWNwajA2bjRmS3E4S2ZCaGMmcz1nbTJK
MEdoM2hvdGdlbkxhZTl1RnZmQ2lEOU1LN2lZR24NCj4gPiBhWWhZcm5Td3pzJmU9DQo+ID4NCj4g
PiBCYXJ0Lg0K
