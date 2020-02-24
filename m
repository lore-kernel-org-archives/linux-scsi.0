Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B60D6C11D2F
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 16:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72E3C20637
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 16:36:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="l+qDZkmF";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="pxwa2rCj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgBXQgl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:36:41 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46232 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727438AbgBXQgl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Feb 2020 11:36:41 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OGPEKp014666;
        Mon, 24 Feb 2020 08:36:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=N9gfIpX8tIuDc6yVni3wmTksl9HduOKC2q8kz9JL3n0=;
 b=l+qDZkmFDTA312dAFAv8996+1sYXKDzvynSWEm/jdh72bsVeSYkJnJ7kU/9bEIOiMv5Q
 twjrha9GYbbtVyn6CGXGLlwU9h694V3iwKwUCnf4+oHWpvNeji9sq8/RI+pyI2/HPiI2
 M7GAuC+WmPYVZb6vI4Ifn3aDnGESqwXHWcp5zABNd50bNPsV6cyPl5GoU468uYphoe7p
 AG/ND1QW7TEmyHK0ly8TiwSdSfCxb8mb65bq6/JBXOf4pXAKU1B5iouzNo2DT6uZ10pL
 z0paVf5dGULBvDQ/VDykFUFUwndbxDmoljpHb2eESwDOxdUZMdYI8hy9fNlC9WSBFOPk PA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2yb2hv7mqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 08:36:38 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Feb
 2020 08:36:37 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 24 Feb 2020 08:36:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxgQu3wE3YIWUHQ6w0C5ShIJL4VUnxwCQT2jZa1AUCVZXx4lN0uuDX6jvFMB5zV5OqOiSPyJzKVYoLFG2n20umZZ/kqf7G7ME4yU2atBB1aWFEhGDqDSCvckslCpquAaM8McQwcONddxojSLiizw1TzRRnOJlhbFn54+kjpzNAm4GZq12zL3n5ATqxM50jD5uKN07a5o+2rrzOHHSP219gb9+XsmKGRG4XHmiKkhmB8V1ByGZ66RhC+yfsRkVsfv2sgKOdyNJwEgk2wN2iF7CR8Oz2WrrQEoFB23bGccofohsXhBmKaimMnz3+H9WXSFE1fTycN72txSULrZpNFmPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9gfIpX8tIuDc6yVni3wmTksl9HduOKC2q8kz9JL3n0=;
 b=UgibVkT1HU9cHPYc5doxn1fm/D/2CSZGKhq4lF1S1bpQ/uaKgWygYKzzvHgemaq+9A5Vfr/TDlu6445dStYXyEl6Wffopsr5BwDM+pzI4pj9TSorWaAk6aU8OlABJZVYcVEk7BPQQWzL3YIiHgahUcJ1Po5MlIQaPa6OiAlNSRNxwTkjwOaTEQ92tMn9BjgBPwxy75isdIZMSIzr839oPN+msVsBjowuxj7RurzGaBO2bGsoFV0lfVq2kI3xBDUktb0Hmq1IVVCmGUWJ6aoW0JLY17yE33MrAGCEqYR7AZnCo/YGHvppyDk2aNMUz2Tpea1V+Lx8ZTXY15wic5iXDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9gfIpX8tIuDc6yVni3wmTksl9HduOKC2q8kz9JL3n0=;
 b=pxwa2rCjqB6Sp5kd1zlPDB719MSVlTlAFnDnS1dzavS8L3qlDAiGNbZYBPWVGALRGxMsxoRJULQkplOSU51fAGWD3OEUl/NCEbqWkYJvrQiTjQ6hqOsDy/CHapQf2e2mXR4JEtUHNE6JQrnKUWCdUdTOvhPUwZPLsoEa17ffExk=
Received: from DM5PR1801MB1820.namprd18.prod.outlook.com (2603:10b6:4:6a::12)
 by DM5PR1801MB1932.namprd18.prod.outlook.com (2603:10b6:4:64::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Mon, 24 Feb
 2020 16:36:35 +0000
Received: from DM5PR1801MB1820.namprd18.prod.outlook.com
 ([fe80::3cc1:38d7:b255:9e2b]) by DM5PR1801MB1820.namprd18.prod.outlook.com
 ([fe80::3cc1:38d7:b255:9e2b%3]) with mapi id 15.20.2750.021; Mon, 24 Feb 2020
 16:36:35 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/25] qla2xxx: Updates for the driver
Thread-Topic: [PATCH 00/25] qla2xxx: Updates for the driver
Thread-Index: AQHV4e2gMNq0o9M7WUGhp9OToSSbcKgmWr/DgAPd9wA=
Date:   Mon, 24 Feb 2020 16:36:35 +0000
Message-ID: <A4B1A096-FDD1-4ABA-802F-F0A5327EC56C@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
 <yq1r1ynqzwv.fsf@oracle.com>
In-Reply-To: <yq1r1ynqzwv.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.22.0.200209
x-originating-ip: [2605:6000:1023:35a:9cbf:2825:d6b4:8acf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54b58c7a-7102-47f1-df2f-08d7b947b6a2
x-ms-traffictypediagnostic: DM5PR1801MB1932:
x-microsoft-antispam-prvs: <DM5PR1801MB1932C1317173F16CA61391A7D6EC0@DM5PR1801MB1932.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(199004)(189003)(86362001)(4326008)(54906003)(6512007)(66556008)(66574012)(91956017)(66946007)(316002)(76116006)(66476007)(64756008)(478600001)(66446008)(6506007)(6486002)(2616005)(36756003)(71200400001)(81156014)(81166006)(5660300002)(186003)(6916009)(33656002)(8676002)(15650500001)(8936002)(2906002)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR1801MB1932;H:DM5PR1801MB1820.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zg3PNe41DzWPSsmD3he3ofsC5Qh90OPCOXdAmh2lKg6W05uIsJee60k5lXULk0JFK6qwfjvtwJdxEx1eXJ7kY90r2S/1dhH+Quenxeqvjb5f4GY+kmQfHBYn3e+njsHqeq8D+QtN7yr4Y5Db1DOrhGTYQSwnVLTY/jtzThjEiRTIiZDCOkqFL6joL+W/tpEBb7Hm4N14+peLeVHyX7wXrNQZdPCC7IzhcKx2UhFbbmI1rtUsjn9dOhpwK+UCvbVDQJLBImipPNwOdbBq3CvF70T23LPLo0V4KlKmX7LQwC2c1i6U/52/29nhkQaTJ/od0ya99XV+7LMQc8ZkaXF0ypYbiYtXgjYSChH2rUlAG85cr+VHcMsu44ocneYel6ssGh9n2/3QA19L8AxtPuDWsjm/53qEg7rWVc/g17huBpJrNYSQxNCyWsh8nTfwM+Fw
x-ms-exchange-antispam-messagedata: YQlBTDY5jAXcvGVSBlv0b92EHLdVuCs+3t58PWc/AiXoPkHa97C5YSw73bYtSUq8oIgu9i2QyMyEdfWaEr4kCs4sC39uaDe4jXNu4ZHA0d+NuIXHtPu098ruD19NyKiS81f2HlCTs4JnjCJtqzKpRKwjW7BIw0d2DzbIcioFHuKyeZhQb4+kw7QD7ZG0e4xKGcUUcAnhP12agJIjycAHXg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4C97ABC56CFF54E9A25B8246FB7AD39@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b58c7a-7102-47f1-df2f-08d7b947b6a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2020 16:36:35.2629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XG3u3GUNGTVY+0q1Yb6BZAeUeq6noQ6gBFGt/M3H1fLKcVo3VwdE2PSd4v74KQC5U+fQDZ9I1d9jB/wJN6jJ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1801MB1932
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_04:2020-02-21,2020-02-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDIvMjEvMjAsIDU6MzMgUE0sICJsaW51eC1zY3NpLW93bmVyQHZnZXIua2VybmVs
Lm9yZyBvbiBiZWhhbGYgb2YgTWFydGluIEsuIFBldGVyc2VuIiA8bGludXgtc2NzaS1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgb24gYmVoYWxmIG9mIG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPiB3
cm90ZToNCg0KICAgIA0KICAgIEhpbWFuc2h1LA0KICAgIA0KICAgID4gVGhpcyBzZXJpZXMgYWRk
ZXMgZW5oYW5jZW1lbnRzIHRvIHRoZSBkcml2ZXIgaW4gdGhlIGFyZWEgb2YgRkRNSQ0KICAgID4g
Y29tbWFuZHMgYW5kIGFkZGluZyBzdXBwb3J0IGZvciBSRFAgY29tbWFuZC4gVGhpcyBzZXJpZXMg
YWxzbyBhZGRzDQogICAgPiBzdXBwb3J0IGZvciBCZWFjb24gTEVEL0QtUG9ydCBTeXNGUyBub2Rl
cy4NCiAgICA+DQogICAgPiBUaGVyZSBhcmUgZmV3IG90aGVyIHBhdGNoZXMgd2hpY2ggYXJlIGNs
ZWFudXAgdG8gaW1wcm92ZSByZWFkYWJpbGl0eQ0KICAgID4gYXMgd2VsbCBhcyBjb25zb2xpZGF0
ZXMgY29kZS4gIA0KICAgID4NCiAgICA+IFBsZWFzZSBhcHBseSB0aGlzIHNlcmllcyB0byA1Ljcu
MC9zY3NpLW1pc2MgYXQgeW91ciBlYXJsaWVzdA0KICAgID4gY29udmVuaWVuY2UuDQogICAgDQog
ICAgQXBwbGllZCB0byA1Ljcvc2NzaS1xdWV1ZS4gVGhpcyBzZXJpZXMgbGl0IHVwIGxpa2UgYSBY
bWFzIHRyZWUgaW4NCiAgICBjaGVja3BhdGNoLiBOZXh0IHRpbWUsIHBsZWFzZSB2ZXJpZnkgYmVm
b3JlIHBvc3RpbmcuDQogIA0KV2lsbCBkby4gDQoNClRoYW5rcywNCkhpbWFuc2h1DQogIA0KICAg
IC0tIA0KICAgIE1hcnRpbiBLLiBQZXRlcnNlbglPcmFjbGUgTGludXggRW5naW5lZXJpbmcNCiAg
ICANCg0K
