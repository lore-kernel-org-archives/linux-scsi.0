Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB994C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9323D20692
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="He5w6PpJ";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Uos1YjC1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKUQkj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 11:40:39 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2232 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbfKUQkj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 11:40:39 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALGdtVk000499;
        Thu, 21 Nov 2019 08:40:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=S4zd1xvEdYgbYzYUCSei82q2XKMMZV6PlctQKpgBgdM=;
 b=He5w6PpJ1hQtKrLkGZU491axoPKR/DFo3741gRbZLDaHB400DBbuwxsZy0heOpcmRrYR
 ht8aeb/VLohq85btJ7gR790al4ayI2ZoSMfJ7ejbKvcBvYiuBpUIFb5BGu81kspfzBRo
 bfWVfZ052wetgpnqexIfbCM7e6OIlCOd4yR7Yz2YVXYN4vmR4/h6u1eXgr0HvEP8nKcU
 adjG/5zLrViRaoZqTwWXb3Wb6bLYFNqBiQ5002jD9gIfLUkmslwZWZuoM1jAli0BZkiy
 9/9appP1siLMvawKD8LdvaeGhGTZJC2FuTci3QkhVL5bkKm0AQFnmAhXmUGIkRXz8tI3 Kg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wd090yvgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 08:40:36 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 21 Nov
 2019 08:40:34 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.59) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 21 Nov 2019 08:40:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQM8ty7bnQ02ZHtZnZeuWjqWjHmkMnnZaJEVB7XW23+wH8GsP6xgboihGG/rtqPFsv+M0sif8C2QplKuPJ7vlN1UHqWUmYgjEJXIyA5U4FAksxFN7dsTBcQwEYAQkK+Q8RJCUIfnG8smYVdZhu+qFiHDb7w+gbeh/Mvz7nSEOKIeVY3nB0q0F329VONGI0VxX0Kd+seW7SASL4yZh8k+fx1OurYNXzz93q38VWeXnPCJ987J2xczJOWHaYKMUjjhzoC/cg5wIJqm9eLmLC6iWZ7rkOtMac254wWVhcqvRSs51EDzRGIU3vT/aa9BLUq3glLhzq1akLOXqJOMp6+MWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4zd1xvEdYgbYzYUCSei82q2XKMMZV6PlctQKpgBgdM=;
 b=Hq/OqMwYN8hA+6K2qVAeKjiI4frxcoTMctuZTb+57MLIOP9oHNm4rUIbzBMSpRuWM0pIuh4Jb5mPGVhXTdfsY2wiogAJH+DJ+sqLGj/ZlzNMdLPDe3d42tz/btEYvz0/qiMzLTydbPExkHkxeD78m5HrlazJBi/kzHKEkCW0COdIcla5EAQciZRryn5SCWC8yuw4G4erJ7PucdP4TBMkcbSMG61chFHJcnEhSdulJv94UTwMBTrwka5JW4BmNQEO7OvwsJV6F0q0p1kFUh2YQ6ZDH/PBa7jtAI1xG+rsxxp7Ie1+lHFRqA73qR8LwOYCjUa+WslpJKdVW1b5uRjdwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4zd1xvEdYgbYzYUCSei82q2XKMMZV6PlctQKpgBgdM=;
 b=Uos1YjC1QAOG4OV/nL3iQPfEOArn2OiNutobxOVsJZOAsMsfJPh50La7+hfxA4xp2FsABdXwxtjOMzGQSGjKC2knAElL3S7WqkanIVTQgubT9fqDVGVrI2PvRvAsfhSv8WJ7bzI8sL6basM8qBkd+MTpUwL+LfGYBe9+MUgvM2s=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2989.namprd18.prod.outlook.com (20.179.23.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Thu, 21 Nov 2019 16:40:33 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 16:40:33 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Krishna Kant <krishna.kant@purestorage.com>,
        Alexei Potashnik <alexei@purestorage.com>
Subject: Re: [EXT] [PATCH v2 09/15] scsi: qla2xxx: Send Notify ACK after N2N
 PLOGI
Thread-Topic: [EXT] [PATCH v2 09/15] scsi: qla2xxx: Send Notify ACK after N2N
 PLOGI
Thread-Index: AQHVn/HAxV3ncctqIU2TmTP051abXqeVcE8A
Date:   Thu, 21 Nov 2019 16:40:33 +0000
Message-ID: <BB852933-3398-4CB2-8F59-96680F6A5E87@marvell.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-10-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-10-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [2600:1700:211:eb30:e5e4:c939:a3a3:4c5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5324a0c8-30e5-4ee0-8a06-08d76ea18727
x-ms-traffictypediagnostic: MN2PR18MB2989:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2989DE6808000B2AE4613507D64E0@MN2PR18MB2989.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(189003)(199004)(91956017)(5660300002)(6436002)(186003)(76116006)(305945005)(2501003)(33656002)(7736002)(71200400001)(71190400001)(6486002)(86362001)(8936002)(14444005)(6512007)(256004)(2616005)(102836004)(6116002)(58126008)(36756003)(6506007)(508600001)(2906002)(54906003)(25786009)(99286004)(8676002)(76176011)(46003)(14454004)(110136005)(2201001)(229853002)(4326008)(81166006)(66446008)(66556008)(6246003)(446003)(66946007)(316002)(66476007)(11346002)(81156014)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2989;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t+uR8teZiyhUspgd7Pywo8YcvRS5SamJpGGckMCJEZDkTGbakuJjA9eeVDUlvYuD18Y/4O2f+6vu2iIMyM6VRPqtAx9xfYGDc7MNuj8B5FwMYe6k2CVjb44ZTCiHzn5bavyQXfnqnu9BZ8rAtSc2riQXZ2zVZMYzXzUzIrT+16nSnJcYeQ/xoshaGyLiUbcgMTXNC+GWfHqU3FfuCLD1q604bJo2f4MPfCL7f4Ee+qqRzeW5sqp4SjXsDRdks9Zp6lQ1MYQFkHxYFIdf3zySE1fvxV/uCNF+P8vH+wBHqpL1ApOsuMfXKbaf5m4ny5LnV//jKXIIe3TydYZzvLrAJ1fnsBZ5hK+nSKnx0Bt8qujHmrEhZgx96BzFDAVjPqLJaklLe+7xLe2R5WJutlreea0ITszgNFJBf3puDERFtoZ86JfO6p08phMyIKZFEimD
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9FC11598770F844AE49AC8B5B155888@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5324a0c8-30e5-4ee0-8a06-08d76ea18727
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 16:40:33.0481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zHIQMF42/ubwHwPrTyr0BC98PqKfGYbfF1HpIbtjFCvSidVcjdjGqjOjdinM14lKgKRuOyuuVyVbc8vhsBf+qw==
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
LS0tLS0tLS0tLQ0KICAgIHFsdF9oYW5kbGVfbG9naW4gc2NoZWR1bGVzIHNlc3Npb24gZm9yIGRl
bGV0aW9uIGV2ZW4gaWYgYSBsb2dpbiBpcyBpbg0KICAgIHByb2dyZXNzLiBUaGF0IGNhdXNlcyBs
b2dpbiBib3VuY2luZywgaS5lLiBhIGZldyBsb2dpbnMgYXJlIG1hZGUgYmVmb3JlDQogICAgaXQg
c2V0dGxlcyBkb3duLg0KICAgIA0KICAgIENvbXBsZXRlIHRoZSBmaXJzdCBsb2dpbiBieSBzZW5k
aW5nIE5vdGlmeSBBY2tub3dsZWRnZSBJT0NCIHZpYQ0KICAgIHFsdF9wbG9naV9hY2tfdW5yZWYg
aWYgdGhlIHNlc3Npb24gaXMgcGVuZGluZyBsb2dpbiBjb21wbGV0aW9uLg0KICAgIA0KICAgIEZp
eGVzOiA5Y2Q4ODNmMDdhNTQgKCJzY3NpOiBxbGEyeHh4OiBGaXggc2Vzc2lvbiBjbGVhbnVwIGZv
ciBOMk4iKQ0KICAgIENjOiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQogICAgQ2M6
IEhpbWFuc2h1IE1hZGhhbmkgPGhtYWRoYW5pQG1hcnZlbGwuY29tPg0KICAgIENjOiBLcmlzaG5h
IEthbnQgPGtyaXNobmEua2FudEBwdXJlc3RvcmFnZS5jb20+DQogICAgQ2M6IEFsZXhlaSBQb3Rh
c2huaWsgPGFsZXhlaUBwdXJlc3RvcmFnZS5jb20+DQogICAgU2lnbmVkLW9mZi1ieTogUm9tYW4g
Qm9sc2hha292IDxyLmJvbHNoYWtvdkB5YWRyby5jb20+DQogICAgLS0tDQogICAgIGRyaXZlcnMv
c2NzaS9xbGEyeHh4L3FsYV90YXJnZXQuYyB8IDEgKw0KICAgICAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKykNCiAgICANCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX3RhcmdldC5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5jDQogICAgaW5k
ZXggYWI2MmZjYmE4YWIzLi44NTNmYTE4N2Q4MjcgMTAwNjQ0DQogICAgLS0tIGEvZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5jDQogICAgKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX3RhcmdldC5jDQogICAgQEAgLTQ4MDIsNiArNDgwMiw3IEBAIHN0YXRpYyBpbnQgcWx0X2hh
bmRsZV9sb2dpbihzdHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqdmhhLA0KICAgICANCiAgICAgCXN3aXRj
aCAoc2Vzcy0+ZGlzY19zdGF0ZSkgew0KICAgICAJY2FzZSBEU0NfREVMRVRFRDoNCiAgICArCWNh
c2UgRFNDX0xPR0lOX1BFTkQ6DQogICAgIAkJcWx0X3Bsb2dpX2Fja191bnJlZih2aGEsIHBsYSk7
DQogICAgIAkJYnJlYWs7DQogICAgIA0KICAgIC0tIA0KICAgIDIuMjQuMA0KICAgIA0KICAgIA0K
TG9va3MgR29vZC4gDQoNCkFja2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxobWFkaGFuaUBtYXJ2
ZWxsLmNvbT4NCg0K
