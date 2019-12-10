Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3EBC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 19:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0083720828
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 19:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="vlBwliGt";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="FMA2Cnd8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfLJTjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 14:39:19 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6098 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbfLJTjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 14:39:19 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBAJZjgI031262;
        Tue, 10 Dec 2019 11:39:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=lPC0OQrQBWkYQVbQ2n84Gx+ITvnItxedCtkEkcX7i9o=;
 b=vlBwliGtRO4iivoOmlQlWGzvURgGp+t/g/flYkzPZ+2oZq6rchx3h3+He4rB2j8borTy
 WOnuaI+aZGxekdb4N5vsuVM1viVSeipQxZnH5ds7KAHfGQfgJjilkDRg0DJaaAIyX8Nh
 hjjUsBlj8ck8iCEGbis92ZY1DtF4oUGtAj4w5MBg0W4RiWwCnRzTwadDkWmNNBIqKAi8
 oZfhikVlc8zMj2rT7UNCzGlPhlEafXpCfMJWYKw27LhCg6LLI3pn7MZot7BvWW3QWib6
 MtGXLuJzexVFviVu8aawkKccSNcwu4Tx7oTTh2+5pfcaMHXpC76hO/tF+k52lkC+Jb2l 7A== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wst5swev7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 11:39:04 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 10 Dec
 2019 11:39:03 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.57) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 10 Dec 2019 11:39:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfrGatRbwLjrQyxii+S0DDfKoG+VxD30YQqRkjpAo3x9nhrZfRemSmycZTz3fOputovSWH6oQnrnnNFk8WXTZ1vtUletuE5mNCqcYQDAZZ8w46Lvv2hsHHr3KPPLYpelvD1E52ZdXbfsG3s6S3/FfrrO0Y2dMek9dJOICuuynn1O/LmsbO10A9V9ouRyhlbo37OdQo/cPb6VWKMIq3BCE7Kc9acEpdN4++WW1x/SKzemL7zRBdlTZzVybfIEflBwvvCJaD9HNU69HzPZLt0jbEIYP2Ls/2hb7N5THNNz58bvh5jekcE6TZwz40HnfDbh6DvIa0E9+VAAT0V5ArU0ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPC0OQrQBWkYQVbQ2n84Gx+ITvnItxedCtkEkcX7i9o=;
 b=cT46RGUq9YL1mgH7c91LUHtoHpZt73TJWFZzwmrnJz6NTBX1q8HXvocC4KEfmA6Q4VLlw4EUT+TO98ulZv9iiAEr7MS8CkR7B95ZMwEKTE25uu/7icAGQ4qTbecO7h2Ln+01n0JU5h2ln7Z0jrNSC6b5CPVbzwIzNLo0SAFA8l9halPfasxoqp8A8XZ6mgCLmrMT7BV6OmBxpliMtLAzYstKPBchYuNcZVGjxV83g7WZmvZybY+ZP+/FpCjz+A+3ZoByrU/kX3TWd7IJcs53qY2ANHErukXrVXvkP4LyOVRCMsL7fb0q6zNgV70J8tqEdXL1j7GqdXMxmmugaFNlWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPC0OQrQBWkYQVbQ2n84Gx+ITvnItxedCtkEkcX7i9o=;
 b=FMA2Cnd8PKtHJy1bcaCt2W6dkH4p295/EOAiRS1t7hpB7Omo9S021PNK/KQHUYUHi2ok5nIvkslbOkFTB25kabjSdVlhL10UIlrs3qLtWLfAJ7X5aAN/wwPsFvswzYR7ZaEskg0EgjwSqmv4r/APRGsGzndW5DzzegdUqq9aQ0A=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3102.namprd18.prod.outlook.com (10.255.86.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 19:38:59 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::eda7:1699:29f1:9eb8]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::eda7:1699:29f1:9eb8%5]) with mapi id 15.20.2538.012; Tue, 10 Dec 2019
 19:38:59 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [EXT] Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
Thread-Topic: [EXT] Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
Thread-Index: AQHVqptpy8DSQu/+BUCkxASW3PPDEKesoG2AgAXYcKqAAPBGgA==
Date:   Tue, 10 Dec 2019 19:38:59 +0000
Message-ID: <BEF43C75-37EE-44FB-984E-F70BAE351B73@marvell.com>
References: <20191109042135.12125-1-bvanassche@acm.org>
 <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
 <af903206-ce02-ef50-567f-d647efe0476a@acm.org>
 <20191202205554.5p77fyot6bc2ij6t@SPB-NB-133.local>
 <10e0c0c1-f3ad-7233-995d-59f1b748e39f@acm.org>
 <20191204120715.dgpr6xcdcckkae4q@SPB-NB-133.local>
 <90b2e3b3-4d9c-d997-37a3-fb8c5bc6d927@acm.org> <yq1fthtqe93.fsf@oracle.com>
In-Reply-To: <yq1fthtqe93.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [66.73.206.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 158e6654-1f37-4cb8-4bef-08d77da89a82
x-ms-traffictypediagnostic: MN2PR18MB3102:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3102570FE5015B8B51F89F1AD65B0@MN2PR18MB3102.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(189003)(199004)(6512007)(6916009)(66446008)(36756003)(33656002)(54906003)(86362001)(2616005)(6486002)(91956017)(76116006)(66476007)(66946007)(8936002)(6506007)(64756008)(5660300002)(316002)(66556008)(478600001)(81156014)(2906002)(107886003)(4326008)(186003)(26005)(71200400001)(8676002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3102;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sPt5vY7Xw94I3AN2sOvy4mGCmUsQFmv6r4TLKAXxtBjHUTf7fDw+aiQ3eyyH3KbJhvdY8IcmK7/aRs0eq41SIIP93HVAL2fAqrZC6XXq9DQSAM5CmCRAtygT+sNJR+C5v/wMinaZ9Oh5rHOaSbXeR3vxSi/ROoeNKpSnVrEacFaYCbKZOgSWWNoLYe2D5bFdLUmx3z5yUsWDV2gJbMC0FCgTXrZi7Sn9TUyC22OzEsVZAlFtJboU8KwXuTjWGTndGn4BoltJ2SFcne564tLuYJ2HUsL+fx0e6U8uTFykiVgEbECCOILWJwTaKbOqMElgqtUnqi/T7FMMpbvKS6ZEmuQtq8P6gjllPToaMAff/A17QyR+ploIwK2PddnScSqSYIiD3xtqDTgkBJqfZU8IGw+IIFE0D37JFywnvJTTkNJRoHglCn1gMo8e5dLkzuzS
Content-Type: text/plain; charset="utf-8"
Content-ID: <62DF2894F47D2B449E3878F30D44B614@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 158e6654-1f37-4cb8-4bef-08d77da89a82
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 19:38:59.5822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9sfPXLKokAE+ieZtwmGzkfxHriqIBUrnH9Ta6lUoT5v7nDyyfhsdKI9qVj/Fh5BZKsTZ2uDdpH49AsL075mZAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3102
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_06:2019-12-10,2019-12-10 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydC9NYXJ0aW4vUm9tYW4sDQoNCu+7v09uIDEyLzkvMTksIDU6MTkgUE0sICJNYXJ0aW4g
Sy4gUGV0ZXJzZW4iIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4gd3JvdGU6DQoNCiAgICBF
eHRlcm5hbCBFbWFpbA0KICAgIA0KICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCiAgICANCiAgICA+PiBGaXJt
d2FyZSBjYW4gZG8gaW1wbGljaXQgbG9naW4sIGFuZCB0aGlzIGlzIGhvdyBpdCB3b3JrZWQgZm9y
IGENCiAgICA+PiB3aGlsZS4NCiAgICA+PiANCiAgICA+PiBUaGVuIGV4cGxpY2l0IGxvZ2luIHdh
cyBpbnRyb2R1Y2VkIGluIHRoZSBjb21taXQgeW91IHJlZmVyZW5jZWQgYnkNCiAgICA+PiBzZXR0
aW5nIGJpdCA4IGluIElGQ0IgZmltd3JhcmUgb3B0aW9ucyAzIGZvciAyNjAwLzI3MDAgc2VyaWVz
IGFuZA0KICAgID4+IGlzc3VpbmcgRUxTIElPQ0IuIEhvd2V2ZXIsIGZvciAyNTAwIHNlcmllcywg
Yml0IDcgc2hvdWxkIGJlIHNldCB0bw0KICAgID4+IGRpc2FibGUgaW1wbGljaXQgbG9naW5zLg0K
ICAgID4+IA0KICAgID4+IFRoZSBsYXRlc3QgY29tbWl0cyB0aGF0IHRvdWNoZXMgdGhlIGJpdCBp
cyA4Nzc3ZTQzMTRkMzk3ICgic2NzaToNCiAgICA+PiBxbGEyeHh4OiBNaWdyYXRlIE5WTUUgTjJO
IGhhbmRsaW5nIGludG8gc3RhdGUgbWFjaGluZSIpLiBJdCBzZXRzIHRoZQ0KICAgID4+IGJpdCBp
biBxbGEyNHh4X252cmFtX2NvbmZpZyByZWdhZGxlc3Mgb2YgY2hpcC4NCiAgICA+PiANCiAgICA+
PiBEb2VzIGl0IGhlbHAgdG8gc2V0IGJpdCA3IGluIElGQ0IsIGZpcm13YXJlIG9wdGlvbnMgMyBm
b3IgMjUwMCBzZXJpZXMNCiAgICA+PiBhbmQgbGVhdmUgdGhlIFJFU0VSVkVEIFNfSUQgZmllbGQg
dW50b3VjaGVkPw0KICAgIA0KICAgIEhpbWFuc2h1OiBQbGVhc2UgYWR2aXNlIG9uIGhvdyB0byBm
aXggdGhpcyByZWdyZXNzaW9uLg0KICAgIA0KSSByZXZpZXdlZCB0aGUgc2VyaWVzIHNlbnQgZWFy
bGllciB0aGlzIG1vcm5pbmcgd2hpY2ggaGFkIHJldmlzZWQgdmVyc2lvbiBvZiB0aGlzIHBhdGNo
LiAgSSBhbSBva2F5IHdpdGggdGhhdCBjaGFuZ2UgKEknbGwgYWNrIG9uIHRoYXQgcGF0Y2ggc2Vw
YXJhdGVseSBmcm9tIHRoaXMgdGhyZWFkKS4gQmFzaWNhbGx5IHdpdGggbmV3ZXIgcGF0Y2ggc3Vi
bWl0dGVkIHRvZGF5LCB3ZSBhcmUgcmV2ZXJ0aW5nIHRvIG9sZGVyIG1ldGhvZCBvZiBoYW5kbGlu
ZyBOMk4gbG9naW4gZm9yIElTUCAyNXh4LiANCiAgICAtLSANCiAgICBNYXJ0aW4gSy4gUGV0ZXJz
ZW4JT3JhY2xlIExpbnV4IEVuZ2luZWVyaW5nDQogICAgDQoNCg==
