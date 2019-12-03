Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4EE2C43215
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 22:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B002215F2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 22:38:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZNcl/Wzn";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="r/8kRUvD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfLCWin (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 17:38:43 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18648 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728049AbfLCWim (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 17:38:42 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB3MYeKH020281;
        Tue, 3 Dec 2019 14:38:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=09di8A8nhyhJRTaYOQzOttGApbnPBSDJoGxzEuOgBw0=;
 b=ZNcl/WznbsgTxyoMUHYOxb3HzOePIm+XwkspKXOnfIVQwfNM80twRrR+TArUHH5NzXl9
 br2l2gy7jF4cat1TaXNShDPrLOQZjdpJ1WrUFx/TUNBSbSWhTFJMbQY0F6YT4hys0MjI
 lZGsxqbAEtpZ6Lffyoofqk+uBK69lv0aZEgFJdfM0mdgTq6BIDcrdTThiL+VCxHg+v3X
 zKvu5u/ucOMbFdilzn4D5ugV/R+dsTNOhaKk1Q6IFo/eLLAe1WA+Y+6Gk0oqviYBZ6gn
 FHgaOgvaha+5llcCCmlrX0VyhsQ/nujz8zS5ZMQZ96FRtuTjYNmbgY6s/ER7nUVRl9X4 aQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wnvgvh4df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Dec 2019 14:38:41 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 3 Dec
 2019 14:38:40 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.50) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 3 Dec 2019 14:38:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9bHr4kaMKur7mtq/fCKCxYtAqwz9AheC5pSHdL5iInmeUnK36XzQrtXUFPR2ITfzlsWWsFel271KZgbsUsV58RIydwImWOn64B+1TJPiXA/8BYF76Ljq0HmbVDhI/2/b9JrOszbrapdqz2QY5fsIb1WYS7jUMA9ZwGTVtUEeJapApJg2Udp0q8mbVyt+xB4l4rAWXFpmR5hB+0kaOfX5UIKrw7dkC2zrfDxJoHrh3DYlBctnkhlcaXWJ+8nuLhmZjpqmNc3bveWah16jQ3Uj5OaVk/IGbS9X/oClAtaW4qzikg80ql+rC3Rl29nfEpriqKj0R6T99mX3HPyyo+yUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09di8A8nhyhJRTaYOQzOttGApbnPBSDJoGxzEuOgBw0=;
 b=EJLM1+Wpre3hJ1bmyHoChHBUAeoQeOuc+0zkvYk44twUJOeGc474X0VKEc3fNq1NwyLWvOwXMqyXYJ2XKLR2HeI682pB/HpswNDkxIwVz76f2qc4muP6gihh6uGh4fRaIzVNomW6U5EQSPtJpUdQHi95cj0xson+luDJDHE0++LYvHjAADGLTBwzAL55G/4QpaZU/R4gHRLgPuAggYz6qLX+X6ogwYcS0KdGEYZ3Phm+0B6js2WiNVpjm7pci0h5br/j9L3GYKTe3hbin3ntHCOuPiOupWRZDGtmp1vaiShqLoyS5GOsJoet5ym2iPezBVqRKefHXQa/wN73Zpd6qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09di8A8nhyhJRTaYOQzOttGApbnPBSDJoGxzEuOgBw0=;
 b=r/8kRUvDa+AtIPOS2VPGXnzxJj7cdL1Q7kPq2zvPgfFzpCc4X20ppuWRByKqImBF+V7+nwu8V3iY3RSUd0BBLMbdMlv/43saPiGaf0DpD/R55NFcj78rn/edKeVCCgyoJXBoo9+zkPJ2dnBKCQgfkz1Tr4edvsu4N57fGqiu6bM=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3374.namprd18.prod.outlook.com (10.255.236.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Tue, 3 Dec 2019 22:38:37 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2495.014; Tue, 3 Dec 2019
 22:38:37 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/3] qla2xxx: Fixes for ISP28xx
Thread-Topic: [PATCH 0/3] qla2xxx: Fixes for ISP28xx
Thread-Index: AQHVqio4qUCuknmVykWJj5rhB/XD4Keom+SA
Date:   Tue, 3 Dec 2019 22:38:37 +0000
Message-ID: <78521D5F-71F4-45B0-A9D5-F73C36C6A0A1@marvell.com>
References: <20191203223657.22109-1-hmadhani@marvell.com>
In-Reply-To: <20191203223657.22109-1-hmadhani@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [2600:1700:211:eb30:ed7d:3402:2c44:7ca7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eea81534-7c0c-4708-1c63-08d7784189ec
x-ms-traffictypediagnostic: MN2PR18MB3374:
x-microsoft-antispam-prvs: <MN2PR18MB33742A1C54D150AF0CC9DCF3D6420@MN2PR18MB3374.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02408926C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(199004)(189003)(6486002)(14454004)(2501003)(6436002)(229853002)(99286004)(58126008)(316002)(6506007)(110136005)(6116002)(2906002)(102836004)(76176011)(186003)(14444005)(256004)(478600001)(86362001)(6246003)(6512007)(25786009)(36756003)(11346002)(71200400001)(33656002)(71190400001)(5660300002)(81166006)(8936002)(4744005)(446003)(8676002)(46003)(81156014)(4326008)(66556008)(66946007)(91956017)(66446008)(64756008)(66476007)(2616005)(76116006)(7736002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3374;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kSzdjlnJJ6Le93nCOsaa6KU0oaynGgPv/eZCpZ0/CgK0VZNxSb7H0JJKPH2hyC+nAFjcLnUrWajFL8foxChCYAr9ewaH1z51gy2mnLN6kQE8PpzT5dmihpp0GzOtQf88HsqhUHybYJ/QPWAEab0JLEv5h+8Xowj04pg22+AfD52uDyOwMxjmtTACzeYeHnkBIUW4/GTOMKIZ+melyLnI3H+PMP51qgcUaN96+3zDIeI0fnDv9IbhP48PMYJOmNWJ/xxxwLKGNRRJWsmpQ7pF2gKH+wIYmrsHT68ADn4H0UK+Nf/nX2Q1QHqzfTZBckzsqI61Bfz6cMZdHvD91F3l2G1O5es293JRNjn+vnxx82taU/KVgPbflp6Ui4r8ZDLnKJkwJz9q+ad4KH8yXJM2ILY88/hpUddKnuPJffZd7hueJEQV8UcmRQP+XVLMCiSU
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9DE4426F960E8F478666E3112F38667D@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eea81534-7c0c-4708-1c63-08d7784189ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2019 22:38:37.7364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ic4CN9bM8s+t9SSE/UAMT+Bfv7w5e2zszmx1jR12V0zMo4OsmzaDPaouOAtptgRH+evOFRNyMoOZ74y8FVrTrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3374
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-03_07:2019-12-02,2019-12-03 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDEyLzMvMTksIDQ6MzcgUE0sICJIaW1hbnNodSBNYWRoYW5pIiA8aG1hZGhhbmlA
bWFydmVsbC5jb20+IHdyb3RlOg0KDQogICAgSGkgTWFydGluLCANCiAgICANCiAgICBUaGlzIHNl
cmllcyBjb250YWlucyBmaXhlcyBmb3IgU2VjdXJlIEZsYXNoIHVwZGF0ZSBmb3IgSVNQMjh4eCBh
ZGFwdGVycy4NCiANClBsZWFzZSBhcHBseSB0byA1LjUvc2NzaS1xdWV1ZS4NCiAgIA0KICAgIFRo
YW5rcywNCiAgICBIaW1hbnNodQ0KICAgIA0KICAgIEhpbWFuc2h1IE1hZGhhbmkgKDEpOg0KICAg
ICAgcWxhMnh4eDogQ29ycmVjdGx5IHJldHJpZXZlIGFuZCBpbnRlcnByZXRlIGFjdGl2ZSBmbGFz
aCByZWdpb24NCiAgICANCiAgICBNaWNoYWVsIEhlcm5hbmRleiAoMik6DQogICAgICBxbGEyeHh4
OiBBZGRlZCBzdXBwb3J0IGZvciBNUEkgYW5kIFBFUCByZWdpb25zIGZvciBJU1AyOFhYDQogICAg
ICBxbGEyeHh4OiBGaXggaW5jb3JyZWN0IFNGVUIgbGVuZ3RoIHVzZWQgZm9yIFNlY3VyZSBGbGFz
aCBVcGRhdGUgTUIgQ21kDQogICAgDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9hdHRy
LmMgfCAgMSArDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9ic2cuYyAgfCAgMiArLQ0K
ICAgICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZncuaCAgIHwgIDQgKysrKw0KICAgICBkcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfc3VwLmMgIHwgMzUgKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0NCiAgICAgNCBmaWxlcyBjaGFuZ2VkLCAzMiBpbnNlcnRpb25zKCspLCAxMCBk
ZWxldGlvbnMoLSkNCiAgICANCiAgICAtLSANCiAgICAyLjEyLjANCiAgICANCiAgICANCg0K
