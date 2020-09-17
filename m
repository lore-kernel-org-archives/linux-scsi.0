Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854D1C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 17:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22895221EC
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 17:16:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hNnqFuSw";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="A720e7us"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgIQRQf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 13:16:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47854 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726315AbgIQRQW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 13:16:22 -0400
X-Greylist: delayed 1368 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 13:16:21 EDT
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HGof83012878;
        Thu, 17 Sep 2020 09:52:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Opo3T46dI9xXQwbZkVsM+rC70SRDjzY5tM8sPjdhDLQ=;
 b=hNnqFuSwUDQlmtPcdacwCCO4T3iaPre0/pk4er+Lbg9CaC5mjREl0ZX4hiTeXExLBXum
 iBJQfcVe7sB1vsXGqkwBzJ7Ad0mvfHabSakNz+uSrYhh3H/Ta8oAbkH8nHO+pRQJvYsD
 5WQHbRaOR0MDhnATWRlWBMkaNsM4BYJo5R/zdoVAHaYKHpnV1mvcfixuAdvV3lUFqjHg
 4zyY8oOKJzBeizYr67J9ylNEkA65uAaQv859qHQn1ee1UH0PogKPGFrMP8eHi3ERLGJb
 rCI6WtG9AOw3fiFyGDpDuVbUKjDzDoiRakxWXIhvXcjVUUhFgFFF8JPRENNuElfTwSrv DQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33m73ms1p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 09:52:42 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Sep
 2020 09:52:41 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Sep
 2020 09:52:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 17 Sep 2020 09:52:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrOA7Ix62ee486uF4rXZF3PJ+jSe8+m/ET/Gem+1DSmPAAqg/8BU43fyTFCNVgGd01fYtUGY+vfCVJbiIXOMHA0R6vWb1iRfOndedHxAVBVdYzmidMwQNKLduI3a7kWnh5b/SODW8lYGflKki+NIOu2arH5mo4rzaj7wrH0btCzwEz2tiS+Hfn1RXemwSa/k0ltB1qS3h3Qwi8PHcRzlXp8OcPzvkPM2fgJabhX4UJvh3lmtCQXcLVr1+jfuWqXKYl2HDDSxG1QLCbX6ySswCMb+O2XGtMkjgkyVBf9YCDlKMz91oOdSR6DsqxAzwaQUnXLeqt7DzafmpoVFLvjYlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Opo3T46dI9xXQwbZkVsM+rC70SRDjzY5tM8sPjdhDLQ=;
 b=SG/4k1caBAWeEDaquczZ4kxBvCPt89KGzdo4x0otTXHYzEC/6a9/BLQDf7EHff4iR8XHNH1SM2z1SKwD20+es8qqslxYbVv3iZppWs/V1ydHFTNaoq1SLSBtaNfi11vm/Lfk8DWCF1rgJ6VIb7EfU6AGnY/8z+B1nDJMNJKEiezmeL2J5oOoYkK8ouVQCTc/KlIkoCXDGDZLHdugb6Du8r0tRyUiPNOiNRucgyszJ1VpqT1oB+pQdFOFZ/rnXxeopT0TMn231LBI9+PEmn0mi6eqgBhShcs3FeGXpdPFH06oQlGM8RYwL6MscsP0mFV/AwvEXNL7h6nCrPoS6ZDjyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Opo3T46dI9xXQwbZkVsM+rC70SRDjzY5tM8sPjdhDLQ=;
 b=A720e7usOObFnEertEXGTniwQgv7scmFOjxRpsMULV+ZKbnsXxQ143bpOF/fumIXgppxxTYHCGEvaVIxsTrKBg1vp/+53Y2wFpSjMvqYpThyXVk3znBmnqkbrszoai7J+OcfBkaxhSqvMj97CjgGdrLeiIpf3nsalrgAc3sHJm4=
Received: from BYAPR18MB2759.namprd18.prod.outlook.com (2603:10b6:a03:10b::24)
 by BY5PR18MB3764.namprd18.prod.outlook.com (2603:10b6:a03:24e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Thu, 17 Sep
 2020 16:52:40 +0000
Received: from BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::b859:f213:6b19:6095]) by BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::b859:f213:6b19:6095%6]) with mapi id 15.20.3391.015; Thu, 17 Sep 2020
 16:52:39 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v3 11/13] qla2xxx: Add IOCB resource tracking
Thread-Topic: [PATCH v3 11/13] qla2xxx: Add IOCB resource tracking
Thread-Index: AQHWgne7rcsV+CpI1kq7Qdnu7WkZXqlYnVmAgBRv2dCAABNjwA==
Date:   Thu, 17 Sep 2020 16:52:39 +0000
Message-ID: <BYAPR18MB2759B6FC4D9A4E89CDA31CA7D53E0@BYAPR18MB2759.namprd18.prod.outlook.com>
References: <20200904045128.23631-1-njavali@marvell.com>
 <20200904045128.23631-12-njavali@marvell.com>
 <bd547541-5a29-5ec5-305a-8614d5a8792c@acm.org>
 <BYAPR18MB2759BFC109D95D019D027304D53E0@BYAPR18MB2759.namprd18.prod.outlook.com>
In-Reply-To: <BYAPR18MB2759BFC109D95D019D027304D53E0@BYAPR18MB2759.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [98.164.229.97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0270b959-3669-4bd5-8e82-08d85b2a16a5
x-ms-traffictypediagnostic: BY5PR18MB3764:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3764CB28CCBEAB9350FFE965D53E0@BY5PR18MB3764.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6XmLJlPvLDf4gYA53pW3s1WsoUk3wkKFH+TQ8XMojp/VsU2tXFFsMX3cpt2gJ3iX33ZmCUzG6lGDETBstS2wv+hFOMtFJfHLw6y25vM7f3j8lqrSQcJzTWJnbndltJ0iN0qC6BuejETwRGK+aHWiz87IIY8LqeEaqt/djcb5QNwv3+OBgLt+ztgRJhzZo7z57Ym1hhWIABB2WsYb1Neq5naaEPCk4mWGdDkswT/copz5nyApPZG2oHIDEwOGbtprhVNs04Zcptzkfgq9GGHu2TXhm6eH2t8tje36Sq/eaWa3s39J+L/X/MR4voAQh4+Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2759.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(66446008)(64756008)(66556008)(66476007)(66946007)(4744005)(71200400001)(478600001)(55016002)(9686003)(52536014)(76116006)(5660300002)(6506007)(53546011)(4326008)(83380400001)(2906002)(8676002)(2940100002)(33656002)(54906003)(86362001)(26005)(186003)(8936002)(110136005)(7696005)(107886003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3RCdb5Ti96rWZAFVmTP4nvkyW8xU23CA6BTS6Wq3XsugjszS3HpJMQT8xjYTKzKYxX/aZLdLq9dCg+ePfYDpCcFLTVNqsMNMWaW9+ajh1lGTbCszHMHHCcdAHqTY4GORe8VxY8CGFhMbRYQhgn+qPODjQMUDmygImap0O69dKxdICS2JHrFCXmmgOGhQ2QBqCCpqmrBNQT0N9UQ+sl8qL6bIw7yCVDLIgVjzrI/JGRyb+8pRCfounrFtbZ991iSiaO1+2z/FC0FBwzS6buQhthvbq08p1UwCt52Bs9RrLjoAQPKNWvdO3Frrfy/e7xMQLfgM/Uf2LO+/PmTXzhYNxlZ8N15Exbog9AU3pOgJZyBrJQ3kFZeWgMa4YWjnWY8HZQ6SccsrqXBKLI3g2Z15x0XO7r3K/AoRbfzC60lkFDL0dmHMenTdEacYhZzD32nzIkgJsZqxj8l4otn//chzVjr9mvW37ogrqwNvUX5h0FCZFNscUGS/l8pgoBh2MCqoje9a+CTmgNGeWijDN4RZQ0vUFmzw/OPgkujfNoGUV96k5zsBFcUD7aiQhPUlnAWVPuEpQ+e3BkF4ADJ2o+NBWwvEtTbLNXmfE9TdyDGzlhe8z1dbhZPOyh8wlH51RuOsIHPRbFJrznzMUk66VnoA9g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2759.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0270b959-3669-4bd5-8e82-08d85b2a16a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2020 16:52:39.7798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8PLyfqqICXMeFLvZePSP9KtGTRhtMlE6Hs+1IWbDM66GrO0Xm5GThFimQt9z9YTUPm98dV+l0Ws6fT3cdsvujg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3764
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_12:2020-09-16,2020-09-17 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpPbiAyMDIwLTA5LTAzIDIxOjUxLCBOaWxlc2ggSmF2YWxpIHdyb3RlOg0KPiBUaGlzIHBhdGNo
IHRyYWNrcyBudW1iZXIgb2YgSU9DQiByZXNvdXJjZXMgdXNlZCBpbiB0aGUgSU8gZmFzdCBwYXRo
LiANCj4gSWYgdGhlIG51bWJlciBvZiB1c2VkIElPQ0JzIHJlYWNoIGEgaGlnaCB3YXRlciBsaW1p
dCwgZHJpdmVyIHdvdWxkIA0KPiByZXR1cm4gdGhlIElPIGFzIGJ1c3kgYW5kIGxldCB1cHBlciBs
YXllciByZXRyeS4gVGhpcyBwcmV2ZW50cyBvdmVyIA0KPiBzdWJzY3JpcHRpb24gb2YgSU9DQiBy
ZXNvdXJjZXMgd2hlcmUgYW55IGZ1dHVyZSBlcnJvciByZWNvdmVyeSBjb21tYW5kIA0KPiBpcyB1
bmFibGUgdG8gY3V0IHRocm91Z2guDQo+IEVuYWJsZSBJT0NCIHRocm90dGxpbmcgYnkgZGVmYXVs
dC4NCg0KUGxlYXNlIHVzZSB0aGUgYmxvY2sgbGF5ZXIgcmVzZXJ2ZWQgdGFnIG1lY2hhbmlzbSBp
bnN0ZWFkIG9mIGFkZGluZyBhIG1lY2hhbmlzbSB0aGF0IGlzIChhKSByYWN5IGFuZCAoYikgdHJp
Z2dlcnMgY2FjaGUgbGluZSBwaW5nLXBvbmcuDQoNClFUOiBUaGUgQmxvY2sgbGF5ZXIgcmVzZXJ2
ZSB0YWcgZG9lcyBmaXQgcmVzb3VyY2Ugd2UncmUgdHJhY2tpbmcuICBUaGUgcmVzZXJ2ZSB0YWcg
aXMgcGVyIGNvbW1hbmQuICBUaGUgSU9DQiByZXNvdXJjZSBpcyBhZGFwdGVyIHNwZWNpZmljIGJl
aGluZCAgYWxsIGNvbW1hbmRzLg0KDQpRVDogSSBtZWFuICIgVGhlIEJsb2NrIGxheWVyIHJlc2Vy
dmUgdGFnIGRvZXMgTk9UIGZpdCB0aGUgcmVzb3VyY2Ugd2UncmUgdHJhY2tpbmciDQoNCg0K
