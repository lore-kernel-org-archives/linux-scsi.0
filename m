Return-Path: <SRS0=Rxtd=XL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC39FC49ED7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 16:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8894620678
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 16:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="iPUmGeEI";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="P5NjmmGg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389677AbfIPQOj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:14:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56028 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727296AbfIPQOi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Sep 2019 12:14:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8GGAddY018223;
        Mon, 16 Sep 2019 09:14:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=zzk3spD5L60Ri6wOjtcyJ8L/tgqxPCWmWcur2/qjJso=;
 b=iPUmGeEI80BZTFTdqkvhLTLzbfhPI8ynKQjSPmcwcALY1+hg75kuEfkepaHyx5IKtLjx
 b2n2RmxHRBECmkGn64Um9AWGGqvC1ywc2hqcuWgHNTRDD6MAAGBZOMghaNu0EcALBxy5
 sYfvoHks6pBfjMHAgxZe2Op8AoVAXAjYSdkVb9MvrihwYIWOWBYJvh2Bay+QwFnXRkqR
 0It5wrU9sM5+2R5Lvu9BRLsmJY+8P1MeNIfE3+IIdpX97YbzTTJ+6H6Da6D6IJRxfeUA
 Peu4R1awmYnxdgpEIdpqBofsqCPlAxwh0SZADt+2d5t5yN1QItQ7FrBPSuTB9sndzrJe KA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2v0yqkq751-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Sep 2019 09:14:21 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 16 Sep
 2019 09:14:20 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (104.47.42.51) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 09:14:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9uTVO3+VZlzf4cTQ8lJco3LLIze2bLrG6h3nfRtOM5LyAclephWBvXKAGn8OUL/RIGefVSCJBGquuM6z+cDKvVjs3kfyypGXUUYZGsAFtw6rMQRvvrmaFup8m1R84IgY2Gtc8NzNAJVV0SN7LVQNwTa0Nu1HDPMKMWnQgxkSSVY9YjrpdFMWDfD3THPWpDVaifjRRqt5vs4pmK+HVD4hPF0J6pAQOe4hMEFqfLRLw8IAGetycilQQrNmhy+BaWZbvTCOiPjPhkKJQ1Ge1Keke3XFpUhl0Z1mSwXl/y0/xP0kjyrelyJzXPE/4wYT3gjVQzI0M8LCn4w6DzUjYazMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzk3spD5L60Ri6wOjtcyJ8L/tgqxPCWmWcur2/qjJso=;
 b=Yh6p8OPyzKWXLF+LnpqBLGa6PEFXE1MYYnsfKWPRNJst8P5mc1xyzwyEWy3KjKde+HgSg1rqzKgSW023JP+ahhvqYlHBVCTOii5iL+3TX+7Bh0rXZv7tnf4xanGonqCRJHqTgzXq8is0TXKFWHI6DsgM8nQCgUfnsCogi8HEqIPJPy2z5UU6Pzf0ZZfpoZ9BLk7TZDAFLC1DK3/clEteTjQsFnVk4GODmtuJe0wfUUb3frPiFJGoPJCmy7JzP/GoM4rP9imzQz7r/f/vmsMK7kQMfYnOmD6va7hZITW2MZoQDzI+7e+14WgDnywNimzsQu+SN5jwiqE0yHind0xyvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzk3spD5L60Ri6wOjtcyJ8L/tgqxPCWmWcur2/qjJso=;
 b=P5NjmmGghthzP6cKbJ/oLjFoLjIwvfej1o8+5Veqa0keROqlYdwAIVFDd2jU3i3MPkAdkvhofpciryOImNOPgxxLuxWoTGWSCHQwn4TZN3oRN8uaGjGXSpHmGpA46N/E6XwS/rgNkjnUlLokm+vdDpAw8PFy9+e/2ofGtdth2Xo=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2576.namprd18.prod.outlook.com (20.179.83.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Mon, 16 Sep 2019 16:14:18 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::34d9:2eb7:4f7b:e933]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::34d9:2eb7:4f7b:e933%7]) with mapi id 15.20.2263.023; Mon, 16 Sep 2019
 16:14:18 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     "greg@enjellic.com" <greg@enjellic.com>,
        Quinn Tran <qutran@marvell.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] SRR response handling.
Thread-Topic: [EXT] SRR response handling.
Thread-Index: AQHVZgo4dM2bN+D3c02U2OLaEsAJSacuM6uA
Date:   Mon, 16 Sep 2019 16:14:18 +0000
Message-ID: <86B9C0A9-74DD-4A6E-9A41-AE870A57C2D0@marvell.com>
References: <hmadhani@marvell.com>
 <201909080556.x885ulOr015167@wind.enjellic.com>
In-Reply-To: <201909080556.x885ulOr015167@wind.enjellic.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
x-originating-ip: [2600:1700:211:eb30:3975:5be5:7776:fd50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 150450d0-3bdc-4c96-5ff9-08d73ac0ed39
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB2576;
x-ms-traffictypediagnostic: MN2PR18MB2576:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB25763D64D232634ACE6FDB85D68C0@MN2PR18MB2576.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(51914003)(199004)(189003)(86362001)(66946007)(8936002)(14454004)(229853002)(102836004)(6506007)(36756003)(76176011)(11346002)(446003)(76116006)(2616005)(66476007)(66556008)(5660300002)(64756008)(53936002)(6486002)(66446008)(99286004)(81166006)(81156014)(46003)(8676002)(91956017)(71200400001)(71190400001)(6512007)(6436002)(486006)(478600001)(305945005)(7736002)(256004)(6246003)(14444005)(6116002)(186003)(4326008)(2906002)(33656002)(25786009)(2501003)(316002)(6636002)(58126008)(110136005)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2576;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cId7zVBeBFW/mTZyjb5tpJS1L75LNK/nsEUY3udfAulWkBM/MTuDs1vxPS9H8TgzUzDZ4THD4kdGHPq9ATFp5uTgnjCJenslJ0CeMtPm3qJE1ACqoHsDqn/A2Zxu9eSzIohUx2/UARgVG5VAG9GsDjJQSyx4ywwZxtnOiRZzpAKVqoJbPF5YL96BgZuzYkH+aeldXA/55yxa9SPjxn4BfC32pm/MXhy/Yzitj3dgbzm2QiBBNo9VhRElvDHsbvj7oHiocIY4VhD/wnVSdpesKqIKuzbdDG5s4JkZaIgl+6IaaV2TLOQJE/3y+HNx8w5rdc7IqegNH8xZUXKGas9pGF1U9nO7m8PvQgGUPf8CrHceTCGzr0NCt+NYu0N7CWI6wvs0MchuCQ4ZGoJe7X4nqrWWAiMY9v9onmBclcG9xtg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9A83A5B901F05449CF8F752F9BB6B9A@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 150450d0-3bdc-4c96-5ff9-08d73ac0ed39
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 16:14:18.2887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VmXgbd3XwJaqmnu+Ue4NzJyZOEOZqKYCUOYoZSzSkAAn9/JANON5WZOaLet7cYCXbQEHLmNblTjt+xdmkNalBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2576
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_07:2019-09-11,2019-09-16 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGVsbG8gRHIgR3JlZywgDQoNCu+7v09uIDkvMTYvMTksIDEwOjM2IEFNLCAibGludXgtc2NzaS1v
d25lckB2Z2VyLmtlcm5lbC5vcmcgb24gYmVoYWxmIG9mIERyLiBHLlcuIFdldHRzdGVpbiIgPGxp
bnV4LXNjc2ktb3duZXJAdmdlci5rZXJuZWwub3JnIG9uIGJlaGFsZiBvZiBncmVnQHdpbmQuZW5q
ZWxsaWMuY29tPiB3cm90ZToNCg0KICAgIA0KICAgIE9uIFNlcCA0LCAgMzowM3BtLCBIaW1hbnNo
dSBNYWRoYW5pIHdyb3RlOg0KICAgIH0gU3ViamVjdDogUmU6IFtFWFRdIFNSUiByZXNwb25zZSBo
YW5kbGluZy4NCiAgICANCiAgICA+IEFkZGluZyBjb3JyZWN0IFF1aW5uIGFuZCByZW1vdmluZyBx
bG9naWMuY29tIGVtYWlsIElELiANCiAgICANCiAgICBTbyBub3RlZC4NCiAgICANCiAgICA+IEl0
J3MgbmljZSB0byBoZWFyIGZyb20geW91IERyIEdyZWcgX18gDQogICAgPiANCiAgICA+IFdlIHdp
bGwgbG9vayBhdCB0aGUgcmVxdWVzdCBhbmQgZ2V0IGJhY2sgdG8geW91Lg0KICAgIA0KICAgIEdv
b2QgdG8gaGVhciBmcm9tIHlvdSBhcyB3ZWxsIEhpbWFuc2h1Lg0KICAgIA0KICAgIFdlIGFyZSBs
b29raW5nIGZvcndhcmQgdG8geW91ciByZWZsZWN0aW9ucyBvbiB0aGUgZXhwZWN0ZWQgYmVoYXZp
b3Igb2YNCiAgICB0aGUgaW5pdGlhdG9ycyBpZiBhIHRhcmdldCBkb2Vzbid0IHByb2Nlc3MgdGhl
IFNSUi4NCiAgICANClN0aWxsIHdhaXRpbmcgb24gaW50ZXJuYWwgdXBkYXRlIGJlZm9yZSBJIHJl
c3BvbmQgd2l0aCBtb3JlIGRldGFpbHMuIFRoYW5rcyBmb3IgdGhlIHBhdGllbmNlIA0KDQotIEhp
bWFuc2h1DQoNCiAgICA+IFRoYW5rcywNCiAgICA+IEhpbWFuc2h1DQogICAgDQogICAgSGF2ZSBh
IGdvb2Qgd2Vlay4NCiAgICANCiAgICBEci4gR3JlZw0KICAgIA0KICAgIH0tLSBFbmQgb2YgZXhj
ZXJwdCBmcm9tIEhpbWFuc2h1IE1hZGhhbmkNCiAgICANCiAgICBBcyBhbHdheXMsDQogICAgRHIu
IEcuVy4gV2V0dHN0ZWluLCBQaC5ELiAgIEVuamVsbGljIFN5c3RlbXMgRGV2ZWxvcG1lbnQsIExM
Qy4NCiAgICA0MjA2IE4uIDE5dGggQXZlLiAgICAgICAgICAgU3BlY2lhbGl6aW5nIGluIGluZm9y
bWF0aW9uIGluZnJhLXN0cnVjdHVyZQ0KICAgIEZhcmdvLCBORCAgNTgxMDIgICAgICAgICAgICBk
ZXZlbG9wbWVudC4NCiAgICBQSDogNzAxLTI4MS0xNjg2ICAgICAgICAgICAgRU1BSUw6IGdyZWdA
ZW5qZWxsaWMuY29tDQogICAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQogICAgIkh1bWFuIGJlaW5n
cywgd2hvIGFyZSBhbG1vc3QgdW5pcXVlIGluIGhhdmluZyB0aGUgYWJpbGl0eSB0byBsZWFybg0K
ICAgICBmcm9tIHRoZSBleHBlcmllbmNlIG9mIG90aGVycywgYXJlIGFsc28gcmVtYXJrYWJsZSBm
b3IgdGhlaXIgYXBwYXJlbnQNCiAgICAgZGlzaW5jbGluYXRpb24gdG8gZG8gc28uIg0KICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLS0gRG91Z2xhcyBBZGFtcw0KICAgIA0KDQo=
