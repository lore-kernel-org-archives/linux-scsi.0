Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD16FC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A80820692
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:39:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NjZMsETD";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="ZBAavkF2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfKUQjo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 11:39:44 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37812 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726714AbfKUQjn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 11:39:43 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALGUSHw024435;
        Thu, 21 Nov 2019 08:39:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=epibBaZb2gakU8EJ07Z0pluIBeMas8q+QR6v5MiEtM0=;
 b=NjZMsETDBeDXSvWk3jQ5Bmfh0io1gmP6T2KudzTHzr/itEOLDySxZoBL01TFs0jNvirU
 54k0D3EBvifYg/c70ZuIbXHcenfaG4D+B7cp8FOKD/8T47gjycsR+zRnMkUEYeiQvQLh
 GKlcMR0hTrMY7UlclMJ71Jsd2oW8Gd6QivwuPknk8lJiwh5KTCbChg+/GY6vnXhbeL/f
 OeUbXt+QpiMPkbiVwFW5G+vFWHE7t+33sKy887uzSuXRXQRY7kkO1p9gBsRgc56CUX0Q
 0pw8Ud8aWw31t/GCi7rDtiUiKRqvwzikRbWlS403QmXTFvrXGzidO/Rpl8rKSO5nuZ4g mw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wc842eg0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 08:39:42 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 21 Nov
 2019 08:39:41 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.59) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 21 Nov 2019 08:39:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9Sa+lugk3nes4VfGGMe2SKX5zrN1aPPVIvCv7yncA2KKm1ky+MBOV6gIB4h4ctRvrnTor8eGK5bDLxbkbi9S3h6jcP2ggv/nddIbI7mWpBI2scLcFftKBWwm0hpsxAQmxWb5PxQxmtyG3YdaROYC/f1FR+gdaOxVg3rOKQC3xKqUw9Rf4SszDv0iHFIojLi3hF2+9FTdev9NPJFWis+fJ13bvO/1RZhhVfqIXSqZbiCf3ZYuCMf9wK4NughUwrx9+3zIDzhe4i3cJ5ZLcmw6uv/nVUnwZxKfsh1miJ4nRP9N27O2NbMX3JFHU5pow/dwfzeuV2fqnzJ4y8ZSLYplw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epibBaZb2gakU8EJ07Z0pluIBeMas8q+QR6v5MiEtM0=;
 b=Ey877/gj6GjpJVkErxaucFao6MdeswZkNSdRASWYcW+s56xgA8qym2BBaPpPhmQspe36svydlXVk0EneFos5OK+ne8iHtPa/mc64sQWoPYbWudkNZb9KI1mSodwOYzsWW3GP642BXWBaZEzmJSUfP7YAbDqA+HBjO1iL3EeGEDFEzmSaxBFxw9R9tBrRdsZR1n6VhwQnU/Cmn0EsKFZM1bmgJWEsM7hkWg1D59eRUFYpGqV0uBg73fGNI+98VABbfENYk23WEiNfHznwdX9V55uMjWrJ5WBv2oJB0d36gCPqL5SB7D6iymJgER6sP6KnCxorzRVo2bNtRr2xf4Isbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epibBaZb2gakU8EJ07Z0pluIBeMas8q+QR6v5MiEtM0=;
 b=ZBAavkF28NaAhOBUz/POgeKUEVPmOcKNlU3Oz3OTi0q8s8dmUQp2CetDWPcHDOxHMgSfs1sLsYyovCN6BUoYeOsAXVg9tkwlMugk3MLacVlQDm5bDaoxWVxDSM3yY3WlNDk2b6+WCxDcDi7TZmQTtkamxPikKM8pOM0IYh1SL3Y=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2989.namprd18.prod.outlook.com (20.179.23.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Thu, 21 Nov 2019 16:39:40 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 16:39:40 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [EXT] [PATCH v2 07/15] scsi: qla2xxx: Fix PLOGI payload and ELS
 IOCB dump length
Thread-Topic: [EXT] [PATCH v2 07/15] scsi: qla2xxx: Fix PLOGI payload and ELS
 IOCB dump length
Thread-Index: AQHVn/HDkx73ep7NLUmA5nfpevgHZaeVcA+A
Date:   Thu, 21 Nov 2019 16:39:39 +0000
Message-ID: <15A0B661-7E18-4884-84CA-699284FB95D4@marvell.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-8-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-8-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [2600:1700:211:eb30:e5e4:c939:a3a3:4c5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cea7d8b-7ad3-44dd-8e8f-08d76ea1677d
x-ms-traffictypediagnostic: MN2PR18MB2989:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2989DB44A896A35D31FCD649D64E0@MN2PR18MB2989.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:279;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(189003)(199004)(91956017)(5660300002)(6436002)(186003)(76116006)(305945005)(2501003)(33656002)(7736002)(71200400001)(71190400001)(107886003)(6486002)(86362001)(8936002)(6512007)(256004)(2616005)(102836004)(6116002)(58126008)(36756003)(6506007)(508600001)(2906002)(54906003)(25786009)(99286004)(8676002)(76176011)(46003)(14454004)(110136005)(2201001)(229853002)(4326008)(81166006)(66446008)(66556008)(6246003)(446003)(66946007)(316002)(66476007)(11346002)(81156014)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2989;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eUz6FbpXsURGVHuieq0NbqgRu+V/Qh0FzXifvQ2iU/H687BG27FfTi53s6+AezQbn0/5EI99cKgVls576JRrA7rUYK+BtQfb0pzp7OzT3OYPYFgoBnOzH4MwihwXA644L34vbj/Qna7zkMKt3OIIy1EWK0t7QIDhKmMBsHG/LPwaW8BlXMk+dXSWr/yzbrUbCCGJPRvx8WEnK5u7U2s1DL/Grb1GLyKv2jlxA+rvwLxg/V7Xxw1MNsmjS4ZgwImMjpWO86b8wGF0lMnNoCs+PGAXaJ0zNrAKDHSFSlSrzhaL+9QPYoFOvWigsZb5wDuQf9pziNvv7YzCbNMhbaDqv8366ZFFIHFl19wDcivvaWxZq6l9TOYqnQzEr7qDvt2lpNwYV5qNEvc3jod4hecrrJerxXLu6hEDuqeEyRlIhIj+tC2FOvNi8bjPL5Xyc7U9
Content-Type: text/plain; charset="utf-8"
Content-ID: <21223DBF11A3B64FAD53A19157A5BC24@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cea7d8b-7ad3-44dd-8e8f-08d76ea1677d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 16:39:40.0086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qzxAm+sakvu2YfGP62g4i1OLgG/KISKy0+yYwFeL+WiAE49RaoHBsDX7hxTN2xQt5rhKNJqZyflFS5DnQonAng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2989
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_04:2019-11-21,2019-11-21 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDExLzIwLzE5LCA0OjI4IFBNLCAiUm9tYW4gQm9sc2hha292IiA8ci5ib2xzaGFr
b3ZAeWFkcm8uY29tPiB3cm90ZToNCg0KICAgIEV4dGVybmFsIEVtYWlsDQogICAgDQogICAgLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KICAgIFRoZSBzaXplIG9mIHRoZSBidWZmZXIgaXMgaGFyZGNvZGVkIGFzIDB4
NzAgb3IgMTEyIGJ5dGVzLCB3aGlsZSB0aGUNCiAgICBzaXplIG9mIEVMUyBJT0NCIGlzIDB4NDAg
YW5kIHRoZSBzaXplIG9mIFBMT0dJIHBheWxvYWQgcmV0dXJuZWQgYnkNCiAgICBHZXQgUGFyYW1l
dGVycyBjb21tYW5kIGlzIDB4NzQuDQogICAgDQogICAgQ2M6IFF1aW5uIFRyYW4gPHF1dHJhbkBt
YXJ2ZWxsLmNvbT4NCiAgICBDYzogSGltYW5zaHUgTWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5j
b20+DQogICAgU2lnbmVkLW9mZi1ieTogUm9tYW4gQm9sc2hha292IDxyLmJvbHNoYWtvdkB5YWRy
by5jb20+DQogICAgLS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMgfCA2
ICsrKystLQ0KICAgICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQ0KICAgIA0KICAgIGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW9j
Yi5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lvY2IuYw0KICAgIGluZGV4IGIyNWY4N2Zm
OGNkZS4uYmQ4MTYwZmRkY2QzIDEwMDY0NA0KICAgIC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9pb2NiLmMNCiAgICArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW9jYi5jDQog
ICAgQEAgLTI2NzYsNyArMjY3Niw4IEBAIHFsYTI0eHhfZWxzX2xvZ29faW9jYihzcmJfdCAqc3As
IHN0cnVjdCBlbHNfZW50cnlfMjR4eCAqZWxzX2lvY2IpDQogICAgIAkJcWxfZGJnKHFsX2RiZ19p
byArIHFsX2RiZ19idWZmZXIsIHZoYSwgMHgzMDczLA0KICAgICAJCSAgICAiUExPR0kgRUxTIElP
Q0I6XG4iKTsNCiAgICAgCQlxbF9kdW1wX2J1ZmZlcihxbF9sb2dfaW5mbywgdmhhLCAweDAxMDks
DQogICAgLQkJICAgICh1aW50OF90ICopZWxzX2lvY2IsIDB4NzApOw0KICAgICsJCSAgICAodWlu
dDhfdCAqKWVsc19pb2NiLA0KICAgICsJCSAgICBzaXplb2YoKmVsc19pb2NiKSk7DQogICAgIAl9
IGVsc2Ugew0KICAgICAJCWVsc19pb2NiLT5jb250cm9sX2ZsYWdzID0gMSA8PCAxMzsNCiAgICAg
CQllbHNfaW9jYi0+dHhfYnl0ZV9jb3VudCA9DQogICAgQEAgLTI5MzQsNyArMjkzNSw4IEBAIHFs
YTI0eHhfZWxzX2RjbWQyX2lvY2Ioc2NzaV9xbGFfaG9zdF90ICp2aGEsIGludCBlbHNfb3Bjb2Rl
LA0KICAgICANCiAgICAgCXFsX2RiZyhxbF9kYmdfZGlzYyArIHFsX2RiZ19idWZmZXIsIHZoYSwg
MHgzMDczLCAiUExPR0kgYnVmZmVyOlxuIik7DQogICAgIAlxbF9kdW1wX2J1ZmZlcihxbF9kYmdf
ZGlzYyArIHFsX2RiZ19idWZmZXIsIHZoYSwgMHgwMTA5LA0KICAgIC0JICAgICh1aW50OF90ICop
ZWxzaW8tPnUuZWxzX3Bsb2dpLmVsc19wbG9naV9weWxkLCAweDcwKTsNCiAgICArCSAgICAodWlu
dDhfdCAqKWVsc2lvLT51LmVsc19wbG9naS5lbHNfcGxvZ2lfcHlsZCwNCiAgICArCSAgICBzaXpl
b2YoKmVsc2lvLT51LmVsc19wbG9naS5lbHNfcGxvZ2lfcHlsZCkpOw0KICAgICANCiAgICAgCXJ2
YWwgPSBxbGEyeDAwX3N0YXJ0X3NwKHNwKTsNCiAgICAgCWlmIChydmFsICE9IFFMQV9TVUNDRVNT
KSB7DQogICAgLS0gDQogICAgMi4yNC4wDQogICAgDQogICAgDQpMb29rcyBHb29kLg0KDQpBY2tl
ZC1ieTogSGltYW5zaHUgTWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5jb20+DQoNCg==
