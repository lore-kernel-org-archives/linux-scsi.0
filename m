Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291F1C3A5A7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 15:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1B8F22CE3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 15:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dxJVlszT";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="BTFMRcL5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbfIDPDZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 11:03:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19170 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729957AbfIDPDZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 11:03:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x84ExZZb004239;
        Wed, 4 Sep 2019 08:03:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=k23gMeXWcwVC9jsESEFXs8hzM4Zu7bw5t7NnS4ENmnU=;
 b=dxJVlszTyZthZ9hgYgLTtgKu1QRydgKZqsCgyXz8aBvDyMgIY22cKyA4Lr+tEWB6BmKh
 s5OCnGZdnjYtRP9knh0+1kSJ0aDDJT2MoD4b8Bbpue6oIA3H1TyGMC8xpj82d6Fm4kdS
 NNoR3NJCOAm5qZrsz+Qirff18eqtvD3juRV4usNMD4F5uDboK/NGuzjCv9j2umX5YNU1
 HWH79Mf9JLqRmV1j6HCfGt8BFJfQn0c/QhzBQcIWLD9BmWcNok2fWiRVV4FEtZBT0dXg
 AX2lhFMvdWFsKf+i6m2XrXmKzxKGaVjzb+/1TVs9sJlZ0j5p8SCiL9lR+zCunltCH4jC dA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uqrdmea84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 08:03:16 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 4 Sep
 2019 08:03:13 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 4 Sep 2019 08:03:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTxo/lQcJBdTG7QAHWsEm4k1VeO3fw6QHS+oRPBIrJHCI7pQn66jiZ41YZsfIHSx6gveRNgACakwtX+sCyB2UMEbyTozOAVbpyKFh2k3yEXPPGDz8Y/z8jO4xONKYS7OzQXaj0phoklq7k50xk4f5RWotgCabCHIX7Ehyr355cHZBSNyjSexjAtC7vpDDpWBnQQvTMKNsnHnTdXBUs1yQdeR2bVorlkoFgivBzh99IUT6wUhf0Z/nM30typw4ouEyf5fvcFQXtxots36ssg7XI2y0enxBcp0dRVEAgbWLXSezc/ANxrcZdZe54Y3YYuZyiNTd6IJJ4bQrgzRZUkkWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k23gMeXWcwVC9jsESEFXs8hzM4Zu7bw5t7NnS4ENmnU=;
 b=cDJ6KHv3rWhMntDfTQ3zqQpe5rJdHpNWOYq1SGIBo4XmcQKaH0ch1MUIpumv0XV9F/TmtMkslbkr9KE2DUzjAwU+1yOHZvuh0jPUyN4uLAWBlRmTNOWTQ8coT962qPEVPlVwGDeGt/oOzL0ylao3nMEA4gvmEKzCA8dwY5sy4ADJfN4fwXBa8IG9CMxyHgZbSaT7iyxVpQDJI4nrFqySOKoPGr01QTPYBbcDRxvhTyGpBNo+b9P0hR3fAIX9Xxb3HjPUXOHklZRfBt/rWZlnXRkkgZUSPNWrR13VHZ1XRhdn/wHrkS6ore85snjj590gVs67QttxwKe2FiWrLGZdMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k23gMeXWcwVC9jsESEFXs8hzM4Zu7bw5t7NnS4ENmnU=;
 b=BTFMRcL54P5Nh5j5IxkFhlEbZEkOsmBdUbE12Lo1mY2tziM2pLwKkSHCuI7fFGv5FXrPeL0qFDzsmZuzSs4p+ILU4FdJm6zSP9mTDPbdsmW1mBWZAKsOzsHLr7Wzw2ftB5Az1Gv9FIpbtRScTd/EcIL85IkwPx9FcvUS12v0K9E=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2927.namprd18.prod.outlook.com (20.179.22.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Wed, 4 Sep 2019 15:03:10 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::34d9:2eb7:4f7b:e933]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::34d9:2eb7:4f7b:e933%7]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 15:03:10 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     "greg@enjellic.com" <greg@enjellic.com>,
        Quinn Tran <qutran@marvell.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] SRR response handling.
Thread-Topic: [EXT] SRR response handling.
Thread-Index: AQHVYpeglF8P59VgY0uXEI7TLeN2a6cbSrcA
Date:   Wed, 4 Sep 2019 15:03:10 +0000
Message-ID: <E589D5BE-7D13-4C66-ABD3-ACA354628310@marvell.com>
References: <201909032038.x83Kcpiu027109@wind.enjellic.com>
In-Reply-To: <201909032038.x83Kcpiu027109@wind.enjellic.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
x-originating-ip: [2600:1700:211:eb30:a1b4:8e80:3c5b:486f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76c0469e-a5c1-49ba-5eb5-08d731490049
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2927;
x-ms-traffictypediagnostic: MN2PR18MB2927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2927BE5CA54483E16A93C117D6B80@MN2PR18MB2927.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(54534003)(199004)(189003)(33656002)(46003)(99286004)(14454004)(2906002)(6246003)(5660300002)(6116002)(6436002)(110136005)(486006)(11346002)(58126008)(476003)(2616005)(2501003)(478600001)(6512007)(66946007)(66446008)(64756008)(66556008)(66476007)(446003)(6486002)(76116006)(91956017)(6506007)(53936002)(102836004)(25786009)(6636002)(14444005)(256004)(76176011)(86362001)(71190400001)(71200400001)(316002)(81166006)(81156014)(8676002)(4326008)(8936002)(36756003)(7736002)(305945005)(186003)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2927;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7+sJjQJG9rHJm3VJxbYo81B4dfMnHEF8Ytnn94aBZpu8znIVq1tXWWOlNeXJUHEH0ILhnlZ9Riko6Aq3+Y3xAmTCLSjUwPSe3y3D0blf3jzGGXG/mxZ1n1hEk1IHjxkvxdkoLlqlevGx7vNqnKBGo5aViUOEQpTh3AnAl5JmfsT5DQQ5FsG6OfakAiIQPwBKWy4srqh0BcRE7UdoPVT6nxh1Bd0d0A6L0RWkgmMT8L68m/X/qQ9iKzkJH428dzUy2z6d0HLi4z7xRg/vt3T3/UGCggrshl72PxR8oKsk8OCQKXwrr3w/vokRO+0ylBOTb7Rh0E33mrx6VC1hwKjV86B4FHceGX/oR40FLQUu2dEs2XwZGIJFsJhOxbN/NfajbQv7mk3TTeIzUsWlsuIQEqiMxR22xyTBDNewj0I6Dmo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8084C5DE651344B82F3E477A0233811@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c0469e-a5c1-49ba-5eb5-08d731490049
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 15:03:10.1397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BEOE6Q6w58HwizYRLX0c3wJB64mqrCQdkc9zUDN185JufLQYFSIT9gMfLhn8WMR++EwwaIoXQAjSOhEHkZVWFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2927
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-04_04:2019-09-04,2019-09-04 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWRkaW5nIGNvcnJlY3QgUXVpbm4gYW5kIHJlbW92aW5nIHFsb2dpYy5jb20gZW1haWwgSUQuIA0K
DQpJdCdzIG5pY2UgdG8gaGVhciBmcm9tIHlvdSBEciBHcmVnIF9fIA0KDQpXZSB3aWxsIGxvb2sg
YXQgdGhlIHJlcXVlc3QgYW5kIGdldCBiYWNrIHRvIHlvdS4NCg0KVGhhbmtzLA0KSGltYW5zaHUg
DQoNCu+7v09uIDkvMy8xOSwgMzozOSBQTSwgIkRyLiBHLlcuIFdldHRzdGVpbiIgPGdyZWdAd2lu
ZC5lbmplbGxpYy5jb20+IHdyb3RlOg0KDQogICAgRXh0ZXJuYWwgRW1haWwNCiAgICANCiAgICAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tDQogICAgR29vZCBhZnRlcm5vb24sIEkgaG9wZSB0aGUgd2VlayBpcyBnb2lu
ZyB3ZWxsIGZvciBldmVyeW9uZS4NCiAgICANCiAgICBIaW1hbnNodS9RdWlubiwgaXQgaGFzIGJl
ZW4gYSB3aGlsZSBzaW5jZSB3ZSBzcG9rZSBidXQgSSB0aGluayBJIGhhdmUNCiAgICB0aGUgcmln
aHQgZ3JvdXAgdGFyZ2V0ZWQgZm9yIHRoaXMuICBJIHNlZSB0aGF0IHlvdSBoYXZlIGV2b2x2ZWQg
ZnJvbQ0KICAgIFFsb2dpYyB0byBDYXZpdW0gdG8gTWFydmVsbCBlLW1haWwgYWRkcmVzc2VzLCB3
aGljaCBtdXN0IGluZGljYXRlIHRoZQ0KICAgIHRyYW5zaXRpb24gb2Ygd2hvIGlzIG1ha2luZyB0
aGUgaGFyZHdhcmUuLi4gOi0pDQogICAgDQogICAgSSd2ZSBiZWVuIGF3YXkgZm9jdXNlZCBvbiBv
dGhlciBpc3N1ZXMgYnV0IEkgbm90ZWQgd2l0aCBpbnRlcmVzdCB0aGF0DQogICAgeW91IGFyZSBu
b3cgZGlzdHJpYnV0aW5nIHRoZSBRbG9naWMtVGFyZ2V0L1NDU1QgaW50ZXJmYWNlIGRyaXZlciB0
aGF0DQogICAgd2UgZGV2ZWxvcGVkIHdpdGggeW91ciAzMkdCUFMgaGFyZHdhcmUgY2FwYWJsZSBk
cml2ZXIuICBJJ20gcGxlYXNlZCB0bw0KICAgIHNlZSB0aGF0IGl0IG11c3QgaGF2ZSB1dGlsaXR5
IHdpdGggcmVzcGVjdCB0byBwcm92aWRpbmcgc3VwcG9ydCBmb3INCiAgICBTQ1NUIG9uIG1haW5z
dHJlYW0gTGludXguDQogICAgDQogICAgSSB3YW50ZWQgdG8gYm91bmNlIGFuIGlzc3VlIG9mZiB5
b3VyIGNvbGxlY3RpdmUganVkZ2VtZW50IHNpbmNlIHlvdQ0KICAgIG1heSBiZSB0aGUgb25seSBw
ZW9wbGUgdGhhdCBrbm93IHRoZSBhbnN3ZXIgdG8gdGhpcyBhbmQgd2UgbWF5IGJlIHRoZQ0KICAg
IG9ubHkgb25lcyB0aGF0IGNhbiBkZW1vbnN0cmF0ZSBhbmQvb3IgdGVzdCB0aGUgaXNzdWUuDQog
ICAgDQogICAgSW4gdGhlIGZvbGxvd2luZyBjb21taXQ6DQogICAgDQogICAgY29tbWl0IDJjMzli
NWMgKCJxbGEyeHh4OiBSZW1vdmUgU1JSIGNvZGUiKQ0KICAgIA0KICAgIEhpbWFuc2h1IGhhZCBw
dWxsZWQgdGhlIFNSUiBjb2RlIGhhbmRsaW5nIG91dCBvZiB0aGUgdGFyZ2V0IGRyaXZlci4NCiAg
ICBUaGUgY2hhbmdlbG9nIGluZGljYXRlcyB0aGF0IHRoZSBjb2RlIHdhcyByZW1vdmVkIHNpbmNl
IG5vIG9uZQ0KICAgIGFwcGVhcmVkIHRvIGJlIHVzaW5nIGl0IGJ1dCBpdCBjb3VsZCBiZSByZS1h
ZGRlZCBpZiB0aGVyZSB3YXMgYSBuZWVkDQogICAgZm9yIGl0Lg0KICAgIA0KICAgIFdoaWxlIFNS
UiBpcyBvc3RlbnNpYmx5IGluIHN1cHBvcnQgb2YgdGFwZSwgYSBibG9jayB0YXJnZXQgaW5pdGlh
dG9yDQogICAgb24gYW4gRkNPRSBmYWJyaWMgd2lsbCBpc3N1ZSBTUlIncyBpbiByZXNwb25zZSB0
byBmcmFtZSBkcm9wcyBvbiB0aGUNCiAgICB1bmRlcmx5aW5nIGV0aGVybmV0IGZhYnJpYy4gIElu
IHRoZSBmb2xsb3dpbmcgY29tbWl0Og0KICAgIA0KICAgIGNvbW1pdCA2ZjU4Yzc4ICgicWxhMnh4
eDogRml4IGtlcm5lbCBwYW5pYyBvbiBzZWxlY3RpdmUgcmV0cmFuc21pc3Npb24gcmVxdWVzdCIp
DQogICAgDQogICAgV2UgZml4ZWQgYSBidWcgdGhhdCBjYXVzZWQgdGhlIFFsb2dpYyB0YXJnZXQg
ZHJpdmVyIHRvIGltbWVkaWF0ZWx5DQogICAgcGFuaWMgdGhlIGtlcm5lbCBpZiBhbiBTUlIgd2Fz
IHJlY2VpdmVkIGFuZCBkZWJ1Z2dpbmcgd2FzIGVuYWJsZWQuICBXZQ0KICAgIGZvdW5kIHRoaXMg
YnVnIHNlY29uZGFyeSB0byBkZWJ1Z2dpbmcgYW4gaXNzdWUgd2l0aCB0aGUgZmFjdCB0aGF0IHRo
ZQ0KICAgIENsaXBwZXIgQVNJQydzIG9uIENpc2NvIE5leHVzIDdLIHN3aXRjaGVzIGFyZSBub3Qg
Y29uZmlndXJlZCBieQ0KICAgIGRlZmF1bHQgdG8gc3VwcG9ydCBsb3NzbGVzcyBmaWJyZS1jaGFu
bmVsIGZyYW1lIHRyYW5zcG9ydC4NCiAgICANCiAgICBXZSBoYXZlIGJlZW4gdXNpbmcgYSB2ZXJz
aW9uIG9mIHRoZSB0YXJnZXQgZHJpdmVyIGZyb20gYmVmb3JlIHdoZW4gdGhlDQogICAgU1JSIGNv
ZGUgd2FzIHJlbW92ZWQgdGhhdCBoYXMgYmVlbiBwZXJmb3JtaW5nIGZsYXdsZXNzbHkgd2hpY2gg
aXMgd2h5DQogICAgd2UgaGF2ZW4ndCBzcGVudCB0aW1lIG1vbmtleWluZyB3aXRoIHVwZ3JhZGVz
Lg0KICAgIA0KICAgIFNlY29uZGFyeSB0byBhIHJlY2VudCBmaXJtd2FyZSB1cGdyYWRlIG9uIHRo
ZSBOZXh1cyBzd2l0Y2hlcyB0aGF0IHdlDQogICAgY29uZHVjdGVkLCB3ZSBlbmRlZCB1cCBpbiBh
IHNpdHVhdGlvbiB3aGVyZSBvbmUgb2YgdGhlIGV0aGVybmV0DQogICAgaW50ZXJmYWNlcyBpbiBh
IHBvcnQtY2hhbm5lbCBiZWdhbiBkcm9wcGluZyBmcmFtZXMgYXQgaGlnaCByYXRlcy4NCiAgICBU
aGlzIGNhdXNlZCBvbmUgb2Ygb3VyIHRhcmdldCBzZXJ2ZXJzLCBydW5uaW5nIGEgNEdCUFMgMjQ2
MiBIQkEgaW4NCiAgICB0YXJnZXQgbW9kZSwgdG8gaW1tZWRpYXRlbHkgcGFuaWMgb24gd2hhdCBh
cHBlYXJzIHRvIGJlIHRoZSBCVUdfT04NCiAgICBhc3NlcnRpb24gYXQgdGhlIHN0YXJ0IG9mIHRo
ZSBzY3N0X3RndF9jbWRfZG9uZSgpIGZ1bmN0aW9uLg0KICAgIA0KICAgIFdlIHdlcmUgZ29pbmcg
dG8gcnVuIHRoaXMgZG93biB3aGVuIHdlIG5vdGljZWQgdGhhdCB5b3UgaGFkIG9mZmljaWFsbHkN
CiAgICBtYXJyaWVkIHRoZSBRbG9naWMgdGFyZ2V0IGRyaXZlciB3aXRoIHRoZSBTQ1NUIGludGVy
ZmFjZSBkcml2ZXIuICBTbw0KICAgIHdlIHJvbGxlZCBhIDQuOS4xOTAga2VybmVsIHdpdGggdGhl
IGRyaXZlciBvdXQgb2YgdGhlIFNDU1QgdHJ1bmsgdG8NCiAgICBzZWUgaG93IGl0IGhhbmRsZWQg
YWxsIG9mIHRoaXMgc2luY2Ugd2Ugd291bGQgcHJlZmVyIHRvIGJlIG9uDQogICAgc29tZXRoaW5n
IHRoYXQgeW91IGd1eXMgYXJlIGRpcmVjdGx5IGFuZCBhY3RpdmVseSBtYWludGFpbmluZy4NCiAg
ICANCiAgICBXZSB0ZXN0ZWQgdGhlIHJlc3VsdGFudCBrZXJuZWwgYW5kIHRhcmdldCBkcml2ZXIg
YW5kIGl0IGFwcGVhcnMgdG8gYmUNCiAgICBmdW5jdGlvbmluZyBmaW5lLiAgQWZ0ZXIgdGhpbmtp
bmcgYWJvdXQgdGhpbmdzIGZvciBhIGJpdCB3ZSBlbGVjdGVkIHRvDQogICAgbm90IGV4cG9zZSB0
aGUgdGFyZ2V0IHNlcnZlciB0byB0aGUgaW5pdGlhdG9ycyBvbiB0aGUgb3RoZXIgc2lkZSBvZg0K
ICAgIHRoZSBwb3J0LWNoYW5uZWwgd2hpY2ggaGFzIHRoZSBpbnRlcmZhY2Ugd2l0aCB0aGUgaGln
aCBmcmFtZSBkaXNjYXJkDQogICAgcmF0ZS4gIFRoZSByYXRpb25hbGUgZm9yIHRoaXMgaXMgdGhh
dCB3ZSBhcmUgdW5zdXJlIG9mIHdoYXQgdGhlDQogICAgYmVoYXZpb3IgaXMgZ29pbmcgdG8gYmUg
d2hlbiBhIGJsb2NrIGluaXRpYXRvciBpc3N1ZXMgYW4gU1JSIGFnYWluc3QgYQ0KICAgIHRhcmdl
dCBzZXJ2ZXIgdGhhdCBoYXMgaGFkIHRoZSBTUlIgaGFuZGxpbmcgY29kZSByZW1vdmVkLg0KICAg
IA0KICAgIFdlIGN1cnJlbnRseSBoYXZlIHRocmVlIHRhcmdldCBzZXJ2ZXJzIHRoYXQgYXJlIGhh
bmRsaW5nIHRob3VzYW5kcyBvZg0KICAgIFNSUidzIGZyb20gdGhlc2UgaW5pdGlhdG9ycyBvbiBh
IGRheSBpbiBhbmQgZGF5IG91dCBiYXNpcyB3aXRoIG5vIGlsbA0KICAgIGVmZmVjdHMsIHdpdGgg
dGhlIG9sZCBkcml2ZXIgdGhhdCBoYXMgU1JSIGhhbmRsaW5nIHN1cHBvcnQuICBPbmUgb2YNCiAg
ICB0aGUgbG9jYWwgcGF0Y2hlcyB3ZSBjYXJyeSBoYXMgZGVidWcgY29kZSB0aGF0IHByaW50cyBv
dXQgd2hpY2gNCiAgICBpbml0aWF0b3IgaGFzIGlzc3VlZCBhbiBTUlIuICBTbyB3ZSBrbm93IHRo
YXQgdGhlIFNSUiBoYW5kbGluZyBjb2RlIGlzDQogICAgYmVpbmcgaW52b2tlZCBhbmQgYXBwZWFy
cyB0byBiZSBjb3Bpbmcgd2l0aCB0aGUgc2l0dWF0aW9uIGp1c3QgZmluZSwNCiAgICB3aGljaCBp
cyB3aGF0IGlzIGdpdmluZyB1cyBwYXVzZSB3aXRoIHJlc3BlY3QgdG8gZXhwb3NpbmcgdGhlIG5l
dw0KICAgIHRhcmdldCBzZXJ2ZXIgdG8gdGhvc2UgaW5pdGlhdG9ycy4NCiAgICANCiAgICBJZiB0
aGUgaW5pdGlhdG9ycyB0aHJvdyBhbiBlcnJvciB0aGF0IGlzIHdlbGwgYW5kIGdvb2QgYnV0IHdl
IGFyZQ0KICAgIG9idmlvdXNseSBjb25jZXJuZWQgYWJvdXQgcG9zc2libGUgc2lsZW50IGZhaWx1
cmVzIGFuZC9vciBjb3JydXB0aW9uLg0KICAgIA0KICAgIFNpbmNlIGFsbCBvZiB0aGlzIGlzIHNv
IGVzb3RlcmljIGFuZCB1bmNvbW1vbiB3ZSB3YW50ZWQgdG8gYm91bmNlIHRoaXMNCiAgICBvZmYg
dGhlIGV4cGVydHMgdG8gZ2V0IHlvdXIgc2Vuc2Ugb24gd2hhdCB3ZSBhcmUgZGVhbGluZyB3aXRo
Lg0KICAgIE9idmlvdXNseSBpZiB3ZSBjYW4gaGVscCBkZWJ1ZyBhbmQvb3IgaW1wcm92ZSB0aGUg
ZHJpdmVyIG9yIHByb3ZpZGUgYQ0KICAgIHJhdGlvbmFsZSBmb3IgZm9sZGluZyB0aGUgU1JSIGNv
ZGUgYmFjayBpbnRvIHRoZSBkcml2ZXIgd2Ugd291bGQgYmUNCiAgICBtb3JlIHRoZW4gaGFwcHkg
dG8gY29udHJpYnV0ZSBhbmQgdGVzdC4NCiAgICANCiAgICBMZXQgbWUga25vdyB5b3VyIHRob3Vn
aHRzIGFuZCB3ZSB3aWxsIGdvIGZyb20gdGhlcmUuDQogICAgDQogICAgSGF2ZSBhIGdvb2QgZGF5
Lg0KICAgIA0KICAgIERyLiBHcmVnDQogICAgDQogICAgQXMgYWx3YXlzLA0KICAgIERyLiBHLlcu
IFdldHRzdGVpbiwgUGguRC4gICBFbmplbGxpYyBTeXN0ZW1zIERldmVsb3BtZW50LCBMTEMuDQog
ICAgNDIwNiBOLiAxOXRoIEF2ZS4gICAgICAgICAgIFNwZWNpYWxpemluZyBpbiBpbmZvcm1hdGlv
biBpbmZyYS1zdHJ1Y3R1cmUNCiAgICBGYXJnbywgTkQgIDU4MTAyICAgICAgICAgICAgZGV2ZWxv
cG1lbnQuDQogICAgUEg6IDcwMS0yODEtMTY4NiAgICAgICAgICAgIEVNQUlMOiBncmVnQGVuamVs
bGljLmNvbQ0KICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KICAgICJJZiB5b3UgcGx1Z2dlZCB1
cCB5b3VyIG5vc2UgYW5kIG1vdXRoIHJpZ2h0IGJlZm9yZSB5b3Ugc25lZXplZCwgd291bGQNCiAg
ICAgdGhlIHNuZWV6ZSBnbyBvdXQgeW91ciBlYXJzIG9yIHdvdWxkIHlvdXIgaGVhZCBleHBsb2Rl
PyAgRWl0aGVyIHdheSBJJ20NCiAgICAgYWZyYWlkIHRvIHRyeS4iDQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAtLSBOaWNrIEtlYW4NCiAgICANCiAgICAtLSANCiAgICANCg0K
