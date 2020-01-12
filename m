Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F99CC32771
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 09:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5D5B214D8
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 09:52:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="uGWfrEb5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732538AbgALJws (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 04:52:48 -0500
Received: from mail-bn7nam10on2055.outbound.protection.outlook.com ([40.107.92.55]:25408
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732374AbgALJws (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jan 2020 04:52:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsmnUuOYI0KPAFfghQJ//9//CTwW9+vWcCup0ayNPwr1bvgthwhoc4CzaXU6spgnwC+gasDcby85x6dovSIIAsjqkzULtnQbV6Wu5caMYYFkWMK0pn6rSz/JU44ijCH88bKCJpuNBy+wdpqRhiwksFN8X7mmSnpBxo088S0XqJW9hBh0ti0fMJh5eBDSOyGF8t4PdUrUnFb81pDoZNpw6pXfE17PacogfIZnYqdrTHg+l/FpHVrnvu2qGPZKOK2y+APhlR3uKY9UHeCFQD8lE5N7wc/FI2+DY9Fgq6IOJHa3ZOAc9rko2HZ0dVMcinP8QVa9ANN+CW5R1Q0McCXjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18R43ELnS3fr8qp6rk7L0QxpdrgbfubPKy5WEsD75sU=;
 b=LnSk8c8KuQk3nvAz25QPyYAFbuN1UQN9mj5yjLmTTpf6tZAnoSDM75RnTiz6qF1SmMI8vrra05bm3auhHsl9AOzTfiAmUYkRpvZyXOSXQtBkEYtl/pQHR54J4kjHViVLDo7yek4tyGjxwX0SLAN54zVvkTXwKgU8iTwmVQ7r9iSAm15QXV3AwZ1y56KN84LUdP4sgoSVcEEp1Ji9hQjLJi/nZ373L+mAWDNVg6feSZeiZF9hrGJv7/qkl0Hei82Q5QqSAvbFJHKMhwLXGf4VjiyT73ekOC9GDtY/hQFbbNQu4xh/MNdVeOsaCDS+DgD1D9bHdVd7WR8BgAaqlFjPNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18R43ELnS3fr8qp6rk7L0QxpdrgbfubPKy5WEsD75sU=;
 b=uGWfrEb5wgCj4elJDKdBhAcWMw7HlWD07bqxXS0lxBH5fEagkW+sgsLM9hsJ3uqH5FDb1HOhJlYdyhmLa+cMe8HSoDB/nHBHRTNK9z6n8rpQxyB27cT/6AyY5udzfFy/p7cr3+mNF2pnuDh/KobE6T0tvh7KSfbdXGgA9i7geJQ=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5028.namprd08.prod.outlook.com (20.176.177.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Sun, 12 Jan 2020 09:52:36 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2623.015; Sun, 12 Jan 2020
 09:52:36 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>, Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH 2/3] scsi: ufs: initialize max_lu_supported
 while booting
Thread-Topic: [EXT] Re: [PATCH 2/3] scsi: ufs: initialize max_lu_supported
 while booting
Thread-Index: AQHVyNB8Te2VKW5gPEGL08clL52OQqfmqunA
Date:   Sun, 12 Jan 2020 09:52:36 +0000
Message-ID: <BN7PR08MB56841AD971BEE2F3E13BC4D5DB3A0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200110183606.10102-1-huobean@gmail.com>
 <20200110183606.10102-3-huobean@gmail.com>
 <95d093b6-591c-1f16-befe-3d192d7c0e2d@acm.org>
In-Reply-To: <95d093b6-591c-1f16-befe-3d192d7c0e2d@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTQwZDkzMjhkLTM1MjEtMTFlYS04Yjg4LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw0MGQ5MzI4ZS0zNTIxLTExZWEtOGI4OC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjM0MjgiIHQ9IjEzMjIzMjk2MzUzNzAxNTQzNyIgaD0iM3B2ZXVUOFdKWHBOVURyNnJ0L1dUbjdMcFlJPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eba954ea-701d-4afd-a935-08d79745275f
x-ms-traffictypediagnostic: BN7PR08MB5028:|BN7PR08MB5028:|BN7PR08MB5028:
x-microsoft-antispam-prvs: <BN7PR08MB50284933ACC567E6F1A4482BDB3A0@BN7PR08MB5028.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 02801ACE41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(199004)(189003)(7696005)(2906002)(26005)(54906003)(55016002)(8676002)(316002)(52536014)(478600001)(81166006)(4326008)(9686003)(55236004)(66446008)(71200400001)(81156014)(76116006)(64756008)(186003)(7416002)(8936002)(6506007)(33656002)(110136005)(66946007)(66476007)(5660300002)(66556008)(86362001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5028;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hblia3iuHLcWYED7bN+vD+n4+60KPZ7kZ5PCh5nUlSxTsxdneKNAESrrwOT1infEBMnyEnqk7G6U9RdXDa2bakSE4ho2O+w6AfLVI6nouyCI/8CtnODoQrvsEuH8Bkpy6F9x3yacqnZ3P9iQ/FDA/5UwdctC4hoAolXFJJkom1lJnTXHMFnUZ9sEx8f1SubF9RTeHu4FaRJciQSKWAt1nF5i5EggMiJPqeXfma6iSe7ZCHa2XHSTVM63hBdCz6IVyT5qe0GJUn7raQTH1ViD4HR0WGqJSahXmhZCNIuwIhRIWhNRFfkom2HfFM4BcvMxaA2TIhF7nI181TvMw1FSCKmLIxf+F/DqZ7anRhsFJ0FfYJTFUHCevHJT2RsTBF5vZmnDhehtFGlrg8rflQjMLlRkbkMHWuAF29KG/NSV5/WHX+PMR26pQ6B3ufpvoRyXAPb2rPSr2rPuyJ+1CWTwl3a85gTHHv+6oSvLFAV1tJmvdoqKvh3VDH3sux0fueQ1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eba954ea-701d-4afd-a935-08d79745275f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2020 09:52:36.4244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5gn5YW6oiulBnTxr7axf9nimq7O95K3J9JLFvfz99aOiwhEVfI5+CnHM65/KSdk//xmpyiuAY8jxjE3gCuTPUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5028
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEJhcnQNCg0KPiA+ICtzdGF0aWMgaW50IHVmc2hjZF9yZWFkX2dlb21ldHJ5X2Rlc2Moc3Ry
dWN0IHVmc19oYmEgKmhiYSwgdTggKmJ1ZiwNCj4gPiArdTMyIHNpemUpIHsNCj4gPiArCXJldHVy
biB1ZnNoY2RfcmVhZF9kZXNjKGhiYSwgUVVFUllfREVTQ19JRE5fR0VPTUVUUlksIDAsIGJ1ZiwN
Cj4gc2l6ZSk7DQo+ID4gK30NCj4gDQo+IFRoZSBkZWNsYXJhdGlvbiBvZiB0aGlzIGZ1bmN0aW9u
IGlzIGxvbmdlciB0aGFuIGl0cyBib2R5LiBEbyB3ZSByZWFsbHkgbmVlZCB0aGlzDQo+IGZ1bmN0
aW9uPyBIYXMgaXQgYmVlbiBjb25zaWRlcmVkIHRvIGlubGluZSB0aGlzIGZ1bmN0aW9uIGludG8g
aXRzIGNhbGxlcj8NCj4NCg0KTm8sIGFic29sdXRlbHkgZG9lc24ndCBuZWVkIGl0LiB1ZnNoY2Rf
cmVhZF9wb3dlcl9kZXNjKCkgYW5kIHVmc2hjZF9yZWFkX2RldmljZV9kZXNjKCkNCmFzIHdlbGwu
IExldCBtZSB0cnkgdG8gc2ltcGxpZnkgdGhlbSBpbiB0aGUgbmV4dCB2ZXJzaW9uLg0KIA0KPiA+
ICtzdGF0aWMgaW50IHVmc2hjZF9pbml0X2RldmljZV9wYXJhbShzdHJ1Y3QgdWZzX2hiYSAqaGJh
KSB7DQo+ID4gKwlpbnQgZXJyOw0KPiA+ICsJc2l6ZV90IGJ1ZmZfbGVuOw0KPiA+ICsJdTggKmRl
c2NfYnVmOw0KPiA+ICsNCj4gPiArCWJ1ZmZfbGVuID0gUVVFUllfREVTQ19NQVhfU0laRTsNCj4g
PiArCWRlc2NfYnVmID0ga21hbGxvYyhidWZmX2xlbiwgR0ZQX0tFUk5FTCk7DQo+ID4gKwlpZiAo
IWRlc2NfYnVmKSB7DQo+ID4gKwkJZXJyID0gLUVOT01FTTsNCj4gPiArCQlnb3RvIG91dDsNCj4g
PiArCX0NCj4gDQo+IEhhcyBpdCBiZWVuIGNvbnNpZGVyZWQgdG8gdXNlIGhiYS0+ZGVzY19zaXpl
Lmdlb21fZGVzYyBpbnN0ZWFkIG9mDQo+IFFVRVJZX0RFU0NfTUFYX1NJWkU/DQo+DQpUaGUgcmVh
c29uIGlzIHRoYXQgSSB3YW50IGFsbCBvZiBVRlMgIGRldmljZSByZWxhdGVkIHBhcmFtZXRlcnMg
bW92ZSB0byANCnVmc2hjZF9pbml0X2RldmljZV9wYXJhbSgpLCBBbmQgUVVFUllfREVTQ19NQVhf
U0laRSBpcyB0byBjb21wYXRpYmxlDQp3aXRoIGFsbCBvZiBkZXNjcmlwdG9ycyBzaXplLiANCiAN
Cj4gPiArCWVyciA9IHVmc2hjZF9yZWFkX2dlb21ldHJ5X2Rlc2MoaGJhLCBkZXNjX2J1ZiwNCj4g
PiArCQkJaGJhLT5kZXNjX3NpemUuZ2VvbV9kZXNjKTsNCj4gPiArCWlmIChlcnIpIHsNCj4gPiAr
CQlkZXZfZXJyKGhiYS0+ZGV2LCAiJXM6IEZhaWxlZCByZWFkaW5nIEdlb21ldHJ5IERlc2MuIGVy
cg0KPiA9ICVkXG4iLA0KPiA+ICsJCQlfX2Z1bmNfXywgZXJyKTsNCj4gPiArCQlnb3RvIG91dDsN
Cj4gPiArCX0NCj4gPiArDQo+ID4gKwlpZiAoZGVzY19idWZbR0VPTUVUUllfREVTQ19QQVJBTV9N
QVhfTlVNX0xVTl0gPT0gMSkNCj4gPiArCQloYmEtPmRldl9pbmZvLm1heF9sdV9zdXBwb3J0ZWQg
PSAzMjsNCj4gPiArCWVsc2UgaWYgKGRlc2NfYnVmW0dFT01FVFJZX0RFU0NfUEFSQU1fTUFYX05V
TV9MVU5dID09IDApDQo+ID4gKwkJaGJhLT5kZXZfaW5mby5tYXhfbHVfc3VwcG9ydGVkID0gODsN
Cj4gDQo+IENhbiBpdCBoYXBwZW4gdGhhdCBHRU9NRVRSWV9ERVNDX1BBUkFNX01BWF9OVU1fTFVO
ID49DQo+IGhiYS0+ZGVzY19zaXplLmdlb21fZGVzYyBhbmQgaGVuY2UgdGhhdCB0aGUgYWJvdmUg
Y29kZSByZWFkcw0KPiB1bmluaXRpYWxpemVkIGRhdGE/DQo+IA0KTm8sIEdFT01FVFJZX0RFU0Nf
UEFSQU1fTUFYX05VTV9MVU4gMHgwYyBpcyBmYXIgbGVzcyB0aGFuIGdlb21ldHJ5IGRlc2NyaXB0
b3Igc2l6ZS4NCkFzIGZvciB0aGUgIFVGUyAyLjAsIHRoaXMgZmllbGQgaXMgcmVzZXJ2ZWQsIGl0
IGlzIGRlZmF1bHQgMC4gIEZvciB0aGUgVUZTIDIuMSBhbmQgVUZTIDMuMCwgdGhlcmUgYXJlIG9u
bHkNCnR3byB2YWxpZCB2YWx1ZSBmb3IgdGhpcyBmaWxlZCwgZWl0aGVyIDAwaDogOCBMb2dpY2Fs
IHVuaXRzLCBvciAwMWg6IDMyIExvZ2ljYWwgdW5pdHMuDQoNCj4gPiBAQCAtNzAxNiwxMyArNzA1
MiwyMiBAQCBzdGF0aWMgaW50IHVmc2hjZF9wcm9iZV9oYmEoc3RydWN0IHVmc19oYmENCj4gPiAq
aGJhKQ0KPiA+DQo+ID4gIAkvKg0KPiA+ICAJICogSWYgd2UgYXJlIGluIGVycm9yIGhhbmRsaW5n
IGNvbnRleHQgb3IgaW4gcG93ZXIgbWFuYWdlbWVudCBjYWxsYmFja3MNCj4gPiAtCSAqIGNvbnRl
eHQsIG5vIG5lZWQgdG8gc2NhbiB0aGUgaG9zdA0KPiA+ICsJICogY29udGV4dCwgbm8gbmVlZCB0
byBzY2FuIHRoZSBob3N0IGFuZCB0byByZWluaXRpYWxpemUgdGhlDQo+ID4gK3BhcmFtZXRlcnMN
Cj4gPiAgCSAqLw0KPiA+ICAJaWYgKCF1ZnNoY2RfZWhfaW5fcHJvZ3Jlc3MoaGJhKSAmJiAhaGJh
LT5wbV9vcF9pbl9wcm9ncmVzcykgew0KPiA+ICAJCWJvb2wgZmxhZzsNCj4gPg0KPiA+ICAJCS8q
IGNsZWFyIGFueSBwcmV2aW91cyBVRlMgZGV2aWNlIGluZm9ybWF0aW9uICovDQo+ID4gIAkJbWVt
c2V0KCZoYmEtPmRldl9pbmZvLCAwLCBzaXplb2YoaGJhLT5kZXZfaW5mbykpOw0KPiA+ICsJCS8q
IEluaXQgcGFyYW1ldGVycyBhY2NvcmRpbmcgdG8gVUZTIHJlbGV2YW50IGRlc2NyaXB0b3JzICov
DQo+ID4gKwkJcmV0ID0gdWZzaGNkX2luaXRfZGV2aWNlX3BhcmFtKGhiYSk7DQo+ID4gKwkJaWYg
KHJldCkgew0KPiA+ICsJCQlkZXZfZXJyKGhiYS0+ZGV2LA0KPiA+ICsJCQkJIiVzOiBJbml0IG9m
IGRldmljZSBwYXJhbSBmYWlsZWQuIGVyciA9ICVkXG4iLA0KPiA+ICsJCQkJX19mdW5jX18sIHJl
dCk7DQo+ID4gKwkJCWdvdG8gb3V0Ow0KPiA+ICsJCX0NCj4gPiArDQo+ID4gIAkJaWYgKCF1ZnNo
Y2RfcXVlcnlfZmxhZ19yZXRyeShoYmEsDQo+IFVQSVVfUVVFUllfT1BDT0RFX1JFQURfRkxBRywN
Cj4gPiAgCQkJCVFVRVJZX0ZMQUdfSUROX1BXUl9PTl9XUEUsICZmbGFnKSkNCj4gPiAgCQkJaGJh
LT5kZXZfaW5mby5mX3Bvd2VyX29uX3dwX2VuID0gZmxhZzsNCj4gDQo+IFRoZSBjb250ZXh0IGNo
ZWNrIGluIHVmc2hjZF9wcm9iZV9oYmEoKSBsb29rcyB1Z2x5IHRvIG1lLiBIYXMgaXQgYmVlbg0K
PiBjb25zaWRlcmVkIHRvIG1vdmUgYWxsIGNvZGUgdGhhdCBpcyBjb250cm9sbGVkIGJ5IHRoZSBp
Zi1zdGF0ZW1lbnQgd2l0aCB0aGUNCj4gY29udGV4dCBjaGVjayBpbnRvIHVmc2hjZF9hc3luY19z
Y2FuKCk/DQo+IA0KSSB0b3RhbGx5IGFncmVlIHdpdGggeW91LiBUaGV5IHNob3VsZCBiZSBtb3Zl
ZCBvdXQgZnJvbSB1ZnNoY2RfcHJvYmVfaGJhKCksIA0KQW5kIG1vdmVkIHRvIHVmc2hjZF9hc3lu
Y19zY2FuKCkuIExldCBtZSBkbyBpbiB0aGUgbmV4dCB2ZXJzaW9uLiANCg0KVGhhbmtzLg0KDQov
L0JlYW4gSHVvIA0KDQo=
