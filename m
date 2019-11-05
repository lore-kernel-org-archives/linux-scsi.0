Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB37C17460
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 14:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07EC321929
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 14:41:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="d1N5UUWU";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="OfdYatAN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbfKEOlQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 09:41:16 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17792 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728417AbfKEOlQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 09:41:16 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5EQWKf006279;
        Tue, 5 Nov 2019 06:41:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=1sl8X4uZxxYDWaPVVZ7yEE+wUT+xepokrACveZax4+c=;
 b=d1N5UUWUgLFaGpWekJwdVsVH6V7hRyVY27Xp9smFObRpqNLZdbjhqmYMJeL532UqarUs
 yW0MmYtCyFKy6OmNcP0W28yWSVChEN8Umo5N5WhUjgzOE5ZGLt38QX7Jo5TgQ++v5uUo
 BZ7UuqOfOt4B5vUUz+Lt7ghn3zH5vIDL5geyKBqUqyy4gBPEej7epe2BZicRZSiksNvq
 7VCYQ70j562kp4NsKb/qN9A4jqhlBq01Qd49P8GrHkH5FqQFUbgAGEHExnBCzwQYfad0
 SJy40cFAq7198TTsryQlk5/KZTS+uuhTdFfEegPQ5XGVUhTW4cF/VPmuBCS/l7fx4JXS fA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w19amtn9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 06:41:06 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 5 Nov
 2019 06:41:04 -0800
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (104.47.41.51) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 5 Nov 2019 06:41:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fo7+KMYiaGsmGwkLzIGKpzsTIraOH/tgP22Ff6wY8jyQl/WI8YTUTN8zLSsz0npWUtRgmgM3MOl+pqv29M/6IDHsdHw2TPiFiwucgfqwmHhJV06gPK/vrlAiI22gfdf+ErkCNvUSCm2N8GRke5yucqjvoXMOiR9eIdt9ulWu5WZZiZOQVBzfBAV78Lu/8xGMKvkzBP56Hy0tMeGQOazuIoUdTmjJmNzvEPqORHaRrXlC0dmQ7Sad8o4tcqmWYmABOfLS92ffYFs9BmWx9AoucS10FuOJmfgQROL2xJMMef1bzkbkKbIR2Yjhe7dmv96KZXN+kYR2wxPsykQsIqywtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sl8X4uZxxYDWaPVVZ7yEE+wUT+xepokrACveZax4+c=;
 b=WS33Ew5ylpyfUvg94czz8N5ofPDIzVkzoHwWZbEJ+XT+lR6Ua6nhaSW3IcjnbxmOWBNG1W2lw955UHz0V0YyQiy8LC+3/Bp/1w0H+yAkDny+1qqHrbEmPeBQxL8pO1iz6jJweNAuVvngFajHm4hJcM2z1mX6d3LmyIvufkw6SDcYl+l4Arn6iAvk3o+XO1RpM6pF0hyTbThSWHK+SCMb6B3ergKW5IdhwmpnQNhKCUjj3v945ZYqqgRnlvXwgeruZ4YkeMKFImQTDNGNqwAsmUeIajIligh2s2jL5NbQKVU9+o9laJL2wT8V/Nyr6i9tsKJC27NmgsRzEtsXnYj1Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sl8X4uZxxYDWaPVVZ7yEE+wUT+xepokrACveZax4+c=;
 b=OfdYatANU/Y5alZshG4E1syaEqgwnP7X+/86jFNd1AmhE+FJTP3o67g7rAPYu5+HuzfC1uDWlMAoaQv7KMH8zQQcizFPcFkTFbkMIU6wFVFtbfvdJZUsXIpdnTE4plxr4WbXYdBcw1Ia+z0qEo7of/S4JptM7I9L5qh2/h150RA=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3248.namprd18.prod.outlook.com (10.255.238.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 14:41:02 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 14:41:02 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Martin Wilck <Martin.Wilck@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>,
        Quinn Tran <qutran@marvell.com>,
        "dwagner@suse.de" <dwagner@suse.de>, "hare@suse.de" <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v2] fixup "qla2xxx: Optimize NPIV tear down
 process"
Thread-Topic: [EXT] Re: [PATCH v2] fixup "qla2xxx: Optimize NPIV tear down
 process"
Thread-Index: AQHVk+cLjvXjhYuJOEeYlbwlfllqOg==
Date:   Tue, 5 Nov 2019 14:41:02 +0000
Message-ID: <BC3ECF3A-B9FA-4AD4-B4F1-F9DFAD7D1B31@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1e.0.191013
x-originating-ip: [2600:1700:211:eb30:e1a7:7b00:b7d4:a14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2aef9a16-3da4-4dcb-9a9e-08d761fe2e63
x-ms-traffictypediagnostic: MN2PR18MB3248:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3248903F8C98B58A8A541905D67E0@MN2PR18MB3248.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:126;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(199004)(189003)(110136005)(64756008)(58126008)(186003)(66446008)(4326008)(81156014)(2906002)(81166006)(486006)(46003)(6486002)(316002)(102836004)(6506007)(14454004)(66556008)(66476007)(25786009)(99286004)(76116006)(2501003)(478600001)(91956017)(66946007)(6116002)(966005)(86362001)(476003)(2616005)(6306002)(6512007)(5660300002)(71190400001)(8676002)(36756003)(54906003)(33656002)(305945005)(6436002)(14444005)(7736002)(8936002)(256004)(229853002)(71200400001)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3248;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nG1wINntMibWLfikHGqs02eytopxFjBJnvTBipBrpcM0/6HyAobQ69kRtYhNJTg8eTGnv2s7+0PAf7TzH03aA3XaKwd2Av/udf0d4iyjFLk8eYAtT2md8iO2xCOa2C/StO1mNfExs4urVRehUUHdvQrOeySJTg1aY67MO2BqjQjgVZsG4E/7uU6yZwguwyAmCDe7t8DBEKWWDiBX9JT3SXITTvunWR+Rpuz8gQ8nuTT7tuX16gj3sURFYCS5/4RMv55cPccKoB77XSArdMelhpYxOPCFyRA4IxT0f2nuMXMEoZ9dEWZ56a/n2rwnjQuQ/tw5vbxNnhWWmNaeJgsNeAR5+p/JMb/NSAlk7JezZFX9WTwMScTCe1E/pfhMuF8qs+uwe+9q0+8qsq4kr7+zeGp9tkmVq3/MXUl+iQX56ixzFaC0CKPvo4kHWfArqlq9ShMeu9P+ue8DyJNioIIs95cGuC7LW//Dze4iYm6nXkc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62709072F3A7984CAC7D99D1B4554DF3@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aef9a16-3da4-4dcb-9a9e-08d761fe2e63
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 14:41:02.2912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R/qovEyK3nAxYN/oG1eE719P460dt/VjpaxGIBCRebfcSLmmv/7/KbLkQGzzhT1DKZw92CVkWbbbv7CXuGfVAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3248
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_05:2019-11-05,2019-11-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWFyaXRuIFcsIA0KDQrvu79PbiAxMS81LzE5LCA0OjEwIEFNLCAiTWFydGluIFdpbGNrIiA8TWFy
dGluLldpbGNrQHN1c2UuY29tPiB3cm90ZToNCg0KICAgIEV4dGVybmFsIEVtYWlsDQogICAgDQog
ICAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KICAgIE1hcnRpbiwgSGltYW5zaHUsDQogICAgDQogICAgDQogICAg
DQogICAgT24gVGh1LCAyMDE5LTEwLTAzIGF0IDIxOjU3IC0wNDAwLCAgTWFydGluIEsuIFBldGVy
c2VuIHdyb3RlOg0KICAgIA0KICAgID4gPiB0aGlzIHBhdGNoIGZpeGVzIHR3byBpc3N1ZXMgaW4g
cGF0Y2ggMDIvMTQgaW4gSGltYW5zaHUncyBsYXRlc3QNCiAgICANCiAgICA+ID4gcWxhMnh4eCBz
ZXJpZXMgKCJxbGEyeHh4OiBCdWcgZml4ZXMgZm9yIHRoZSBkcml2ZXIiKSBmcm9tIFNlcHQuDQog
ICAgDQogICAgPiA+IDEydGgsDQogICAgDQogICAgPiA+IHdoaWNoIHlvdSBhcHBsaWVkIG9udG8g
NS40L3Njc2ktZml4ZXMgYWxyZWFkeS4gIFNlZQ0KICAgIA0KICAgID4gPiBodHRwczovL3VybGRl
ZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX21hcmMuaW5mb18tM0ZsLTNE
bGludXgtMkRzY3NpLTI2bS0zRDE1Njk1MTcwNDEwNjY3MS0yNnctM0QyJmQ9RHdJR2FRJmM9bktq
V2VjMmI2UjBtT3lQYXo3eHRmUSZyPVA0RmtVcWd2MTNMeEF6TGVsZEdDcnczWS1ReUF5cmh5WWJZ
VVcwOHlXTFkmbT1KNFJsU3pLYUdqa0pGUWhJeDZZWEw3Y2JWZ3VMVUZpc1d1TXRTWkNQZ2tJJnM9
bWdpOVY4YU9VS0owN1R6Q2lSWjFLYVlpMm5SckhPMnNhTk5EN2Zib0YyVSZlPSANCiAgICANCiAg
ICA+ID4gDQogICAgDQogICAgPiA+IEknbSBhc3N1bWluZyB0aGF0IEhpbWFuc2h1IGFuZCBRdWlu
biBhcmUgd29ya2luZyBvbiBhbm90aGVyDQogICAgDQogICAgPiA+IHNlcmllcyBvZiBmaXhlcywg
aW4gd2hpY2ggY2FzZSB0aGF0IHNob3VsZCB0YWtlIHByZWNlZGVuY2UNCiAgICANCiAgICA+ID4g
b3ZlciB0aGlzIHBhdGNoLiBJIGp1c3Qgd2FudGVkIHRvIHByb3ZpZGUgdGhpcyBzbyB0aGF0IHRo
ZQ0KICAgIA0KICAgID4gPiBhbHJlYWR5IGtub3duIHByb2JsZW1zIGFyZSBmaXhlZCBpbiB5b3Vy
IHRyZWUuDQogICAgDQogICAgPiANCiAgICANCiAgICA+IEhpbWFuc2h1OiBQbGVhc2UgcmV2aWV3
LiBUaGFua3MhDQogICAgDQogICAgPiANCiAgICANCiAgICANCiAgICANCiAgICB0aGlzIHBhdGNo
IGlzIHN0aWxsIG5vdCBtZXJnZWQgc2luY2UgYSBtb250aCBhbHRob3VnaCBRdWlubiBoYWQNCiAg
ICANCiAgICBiYXNpY2FsbHkgYWNrJ2QgdGhlIHByb3BzZWQgY2hhbmdlIA0KICAgIA0KICAgICho
dHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX21hcmMu
aW5mb18tM0ZsLTNEbGludXgtMkRzY3NpLTI2bS0zRDE1Njk1MTcwNDEwNjY3MS0yNnctM0QyJmQ9
RHdJR2FRJmM9bktqV2VjMmI2UjBtT3lQYXo3eHRmUSZyPVA0RmtVcWd2MTNMeEF6TGVsZEdDcncz
WS1ReUF5cmh5WWJZVVcwOHlXTFkmbT1KNFJsU3pLYUdqa0pGUWhJeDZZWEw3Y2JWZ3VMVUZpc1d1
TXRTWkNQZ2tJJnM9bWdpOVY4YU9VS0owN1R6Q2lSWjFLYVlpMm5SckhPMnNhTk5EN2Zib0YyVSZl
PSApLg0KICAgIA0KICAgIA0KICAgIA0KICAgIERvIHlvdSB3YW50IG1lIHRvIHJlc3VibWl0LCBh
bmQgaWYgeWVzLCBkbyB5b3UgcmVxdWVzdCBjaGFuZ2VzPw0KICAgIA0KICAgIA0KUGxlYXNlIHN1
Ym1pdCB0aGUgY2hhbmdlcyBhbmQgYWRkIEZpeGVzIHRhZyB3aXRoIGNvbW1pdCBpZCAgZjUxODdi
N2QxYWM2NmI2MTY3NmY4OTY3NTFkM2FmOWZjZjhkZDU5Mg0KDQogICAgUmVnYXJkcywNCiAgICAN
CiAgICBNYXJ0aW4gV2lsY2sNCiAgICANCiAgICANCiAgICANCiAgICANCg0K
