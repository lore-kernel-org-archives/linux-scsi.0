Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1138EC5DF61
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBFAF214D8
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="OExxvfq+";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="r5MQjJKj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389638AbfKEPB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:01:29 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13588 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389183AbfKEPB3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:01:29 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5F0Isr015171;
        Tue, 5 Nov 2019 07:01:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=2D+31sKzVFjoIIbXl3K9GiyvRaW4/K9o5UXrcVoGDvE=;
 b=OExxvfq+sAsUJPQmEsBwLBL8r3Rb8qmwR7mTZWVcqF/sXsIIPnaAHfKLyCNKpXhPfbtZ
 KRVdQljWAbt037Q0Mzqi+Zel/SByOKX/oUZT9tkcMFqtCMPvb2MnWJPhdYRS/xcd/wMx
 QunhMA3btKXHcAP/bhIXjbKhhmbbwxLK+3wLeEuzcJ0v0jzGGrgBob71EHL7mdMxnEfW
 YMyaJ+8zGTILC/BREv4AlEZxMBTrJp5hJaRGduzlY4YCjm2UD0hzIiTZzv10/ZaiueOa
 EN2W25UFlB/glGkCvnzaBHLI1EAEF7kT2eCbiLNbQ9wlJ3fKciTEnuJmz0B2qmOPIIRa EQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w19amtqhn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 07:01:15 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 5 Nov
 2019 07:01:14 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.51) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 5 Nov 2019 07:01:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBM88KsZFoWsR5xbKBFJ/03HsxgpyRQQO7JvKPqq0ZfmKKn3prQKyMTZQHba3hmENvgB9CoXKVDozKXH0VWItNQrvmucbGtYigJ6IHu/GNyapSDCFc+P4PRsy2yNLuuCs0yiO7WgMFkdcKd1VQgWjb4dNdekcezdCLwVV6bZs8Hk3Oxd6jfdti7U8zAuhYijpDru8vE8XLxp6MKxUdcw85GAfxW6nsFayQr1Je4p3eKnH1YIxbht8brzt4PrDgAZsOCJ22MgArL17ywiN221QH7REfsaLt+GwK45Fmgke/tpxE5GQvfa5geiwaUvNJONsXFiwPMhmBKMPzQK7f8JmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2D+31sKzVFjoIIbXl3K9GiyvRaW4/K9o5UXrcVoGDvE=;
 b=LF4qerG17MUWsMiCQTS3YA8deNKNWOpbz0jL/+KKhcllLnL4RM2/Wn9JodZS6Q8mSeDFZ48EMYBsOceN/noHncl1P9KYpjyc71T1vh+NN2iNR5hOli3jg+nH0fThAKA3Y9rub+y+85H7ikoKPBA7mZ29gG1TNFwIaurTACRcb3MeZ7puyXfa3Rb4A+6LdNuV4ytmV6NobLM88Z+JBZRuE+uwvxnfefweImilS/ImftDWzTjh49btDNDv+1rJsJSRsZzhBdymx94u73xgl2pH5Q04d0zpAixQk57qbIGeemAUCHDtpnJ+pjdCtziOrLOZNHbjUmIOr7+8C0Xau9Q4ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2D+31sKzVFjoIIbXl3K9GiyvRaW4/K9o5UXrcVoGDvE=;
 b=r5MQjJKjSs1KAo01AdAQIP8I0oqdphEp7R6IBuBYY7b9YCyhGRDtd6TmnVUkEm3LgiK73nIxGJZ/1QwOOcvvqg/DVaRWPY1JR/b55lMnfGMgR1+H8GQ8E+gD0SZS/KyJ3wtQ95jYG0FCzuMz2ULM80DMeTO890ZwVido/N/0oZQ=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2878.namprd18.prod.outlook.com (20.179.22.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 15:01:11 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 15:01:11 +0000
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
Thread-Index: AQHVk+cLjvXjhYuJOEeYlbwlfllqOqd8qogA//+czAA=
Date:   Tue, 5 Nov 2019 15:01:11 +0000
Message-ID: <C4BCD72E-DA16-4A66-94DE-80E41B244494@marvell.com>
References: <BC3ECF3A-B9FA-4AD4-B4F1-F9DFAD7D1B31@marvell.com>
 <d9e094003cd101ff132560f35eb3f532297ac0aa.camel@suse.com>
In-Reply-To: <d9e094003cd101ff132560f35eb3f532297ac0aa.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1e.0.191013
x-originating-ip: [2600:1700:211:eb30:e1a7:7b00:b7d4:a14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09823e0c-5eff-4108-dbd2-08d76200ff30
x-ms-traffictypediagnostic: MN2PR18MB2878:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2878DB7F5FFA8C29308B1A8BD67E0@MN2PR18MB2878.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:517;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(189003)(199004)(91956017)(446003)(11346002)(316002)(2616005)(66476007)(5660300002)(46003)(102836004)(2906002)(6506007)(2501003)(7736002)(486006)(478600001)(33656002)(81156014)(81166006)(76176011)(8676002)(186003)(4744005)(229853002)(53546011)(8936002)(476003)(14454004)(66446008)(64756008)(6486002)(66946007)(36756003)(110136005)(71190400001)(25786009)(6116002)(305945005)(58126008)(6306002)(86362001)(6246003)(6512007)(54906003)(6436002)(4326008)(76116006)(256004)(14444005)(66556008)(99286004)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2878;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qEdhmMbDn4jt3UOrSSBBEV2nFeWwxeCvYsOdt+yU8hvxdK3QfFUspmICintZpnRO+kH8/KAdmdy4QtUlzv41WVAhDi5Ai761CaJT4xiWKtyJ0XUYL5YOyC6DCNIVdIsQufombnOyl/IpNw3ScKQQWTIl7Zo/tDCCPzjxeiM77GN8NGJ6mv1eC+3AC+uSo/Jgy8u7HCH6p49mLMgo/dZC+phMBqFHYNJCgtkehy3NNqah9q87cqULLJ/ONES9JZBjG2+VaqxeTrgZu7oLRoQwWKQNPmxWQYyUffAsOetbkwQnM52iQsuv0M1eIxlTxuakfAGYTi/COci1CXuWxSbmYzWHRLc0w5OayQGteT+5pcvIvyTdY921TGHK9PaRrEH4wXYheNeCkOQqLq27Dyn0vegaeUtHn0eyKmDlYGm4ukLreSa9KfUxQR2XnXyFTRDlqhareqYoyZppUT0n/PaeBNhD41g4a4HLsQpPUau90XM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4A2CB9F134E794E97ABE00DF1FC5C63@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 09823e0c-5eff-4108-dbd2-08d76200ff30
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 15:01:11.6189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZWlv8Nwz0ISOh3plsVYknaVBv7tphCEQzXxPi0r/2MV8npJGLLxi0GmYCSRHSIdaNXWxPFx1H4qE4p4lTyIHEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2878
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_05:2019-11-05,2019-11-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDExLzUvMTksIDg6NTkgQU0sICJNYXJ0aW4gV2lsY2siIDxNYXJ0aW4uV2lsY2tA
c3VzZS5jb20+IHdyb3RlOg0KDQogICAgSGltYW5zaHUsDQogICAgDQogICAgT24gVHVlLCAyMDE5
LTExLTA1IGF0IDE0OjQxICswMDAwLCBIaW1hbnNodSBNYWRoYW5pIHdyb3RlOg0KICAgID4gTWFy
aXRuIFcsIA0KICAgID4gDQogICAgPiBPbiAxMS81LzE5LCA0OjEwIEFNLCAiTWFydGluIFdpbGNr
IiA8TWFydGluLldpbGNrQHN1c2UuY29tPiB3cm90ZToNCiAgICA+ICAgICANCiAgICA+ICAgICB0
aGlzIHBhdGNoIGlzIHN0aWxsIG5vdCBtZXJnZWQgc2luY2UgYSBtb250aCBhbHRob3VnaCBRdWlu
biBoYWQNCiAgICA+ICAgICBiYXNpY2FsbHkgYWNrJ2QgdGhlIHByb3BzZWQgY2hhbmdlIA0KICAg
ID4gICAgIA0KICAgID4gICAgIA0KICAgID4gICAgIERvIHlvdSB3YW50IG1lIHRvIHJlc3VibWl0
LCBhbmQgaWYgeWVzLCBkbyB5b3UgcmVxdWVzdCBjaGFuZ2VzPw0KICAgID4gICAgIA0KICAgID4g
ICAgIA0KICAgID4gUGxlYXNlIHN1Ym1pdCB0aGUgY2hhbmdlcyBhbmQgYWRkIEZpeGVzIHRhZyB3
aXRoIGNvbW1pdA0KICAgID4gaWQgIGY1MTg3YjdkMWFjNjZiNjE2NzZmODk2NzUxZDNhZjlmY2Y4
ZGQ1OTINCiAgICANCiAgICBUaGF0IEZpeGVzOiB0YWcgaXMgYWxyZWFkeSBpbiBteSB2MiBzdWJt
aXNzaW9uIEZyb20gT2N0LiAyLg0KICAgIChodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5j
b20vdjIvdXJsP3U9aHR0cHMtM0FfX21hcmMuaW5mb18tM0ZsLTNEbGludXgtMkRzY3NpLTI2bS0z
RDE1NzAwMzEwODgwOTg2NC0yNnctM0QyJmQ9RHdJR2FRJmM9bktqV2VjMmI2UjBtT3lQYXo3eHRm
USZyPVA0RmtVcWd2MTNMeEF6TGVsZEdDcnczWS1ReUF5cmh5WWJZVVcwOHlXTFkmbT1QVGh3T21w
MjNJODcwZk9BNDNkUm9ram1kMkhGTkFPb2Y4ZG5Gc3JmTE00JnM9VjFKZWFtNVlLTTNDN2otUUpz
YjBqM203WGRwdzNlOWsyWDBueXF0UEtYNCZlPSApDQogICAgDQogICAgSSdtIGdvaW5nIHRvIHJl
LXNlbmQgYW55d2F5Lg0KICAgIA0KICAgIFJlZ2FyZHMNCiAgICBNYXJ0aW4NCiAgICANCkhtbS4u
IGxvb2tzIGxpa2UgaXQgZ290IGJ1cmllZCBpbiB0aGUgZW1haWwgY2hhaW4uIFRoYW5rcyBmb3Ig
cmVzZW5kLiBJJ2xsIGFjayBvbiB0aGUgcmVzZW50IHBhdGNoLiANCg0KLS0gSGltYW5zaHUNCg0K
