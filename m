Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189CAC55191
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 09:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3BC020767
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 09:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="OHaVO+xn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgDXJvv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 05:51:51 -0400
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:41825
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbgDXJvu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 05:51:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IA8b7imnGEvCXidneCPVFxm5FIyHQIbF9YtA93eyrlPIPKqTjYPsdXV8e3I6B5qNEbM4jSllDRCIYh92lSJFrvUvF7JVGdNBSw60CVHLFywEjtj7l5EHaCKNo1mEormtkrtrOUHtuKg3ZPNCBRMla0iaO0yQxFUMyvinHbhcSNAlWeyfhob3Ch8XJz6dERmzmWXX/7pvku+EkSPiiurMoR1cVtlM6Neb91sQTer2mypFnW6FfX+IHsZmhDdfh2h9tGIFn6M2l4GmzKx5gzINUMRrH04X+rVrUJjpMfWEJ8jLFjXcvtLxV7LFZku3uIPQRlnzzHFzUlct8SmQHiOD+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkUFqLMGN0ieRdRpIaqBWX4eEJMIxpskYDgJ/A8TyUU=;
 b=U9HiEwrcYt/tm9F2Q/j0+toMOIOoviFAk9sCndm1c+JuDAAWUo1sII2JuaM3Rh6YL2zN5lHhCdywulImlkq3M1VdTUQ5FTsWlsYlclYcA3zREA7ocPVbwxHpadagyn/Sd0mryQcUCN7NUeXIHx8hfWYyFUtR21DjwBQuHIWxUViQx1PO9diYFeASPumnvVMO79aMxCGYVQpD7yZJgZFkbapXcZyTEtOC9j5rcgfzqjA70or+/FHx6WzcTz9foF+Oe//itfWe9agLWM0cnFiQnsFCtIpF6X7+uO8KGOuAv089UDIspnHrx9B8it8lSDb+mGNjG9oJkZxIYm5dCiHx1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkUFqLMGN0ieRdRpIaqBWX4eEJMIxpskYDgJ/A8TyUU=;
 b=OHaVO+xn7g6oh3P2xDFGUdrGzzOODdW6khbOja2/0JugXmuSTVo8bP6BYoBBJZqPFqpn23y9cdctuu8nSDSbcVwzde3+DFthOstrY7UsrhADqIGmx0bzFEoJ/MiWowDrMX3QMp/+Uivu+GfeyPlmozcwGMPzjlyO+DWSm3/7xqo=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB4883.namprd08.prod.outlook.com (2603:10b6:408:27::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 09:51:47 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::5dbb:4fb8:f0ca:6988]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::5dbb:4fb8:f0ca:6988%6]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 09:51:47 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
Thread-Topic: [EXT] Re: [PATCH v2 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
Thread-Index: AQHWGQIuljcTg3qMfkuM3OvLDJ2opKiH6txQ
Date:   Fri, 24 Apr 2020 09:51:47 +0000
Message-ID: <BN7PR08MB56845CD413B93D28184BFFEBDBD00@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
 <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
In-Reply-To: <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTMzODVlZGMxLTg2MTEtMTFlYS04YjkyLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwzMzg1ZWRjMi04NjExLTExZWEtOGI5Mi1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjE1MTEiIHQ9IjEzMjMyMTk1NTAzNjA5Mjg5NyIgaD0iOGV0R0FURWkwUU03eWpEU29uTklnbmR6VWxNPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFEaFdlbjFIUnJXQWFYK1F4czhTNlJkcGY1REd6eExwRjBBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUFmM09FS1FBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.104]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 918f3b2b-bee6-4eb5-17a3-08d7e8351ad3
x-ms-traffictypediagnostic: BN7PR08MB4883:|BN7PR08MB4883:|BN7PR08MB4883:
x-microsoft-antispam-prvs: <BN7PR08MB4883D493EA33188CEC36446DDBD00@BN7PR08MB4883.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(76116006)(4326008)(54906003)(64756008)(66446008)(5660300002)(52536014)(9686003)(26005)(186003)(71200400001)(2906002)(478600001)(55016002)(8936002)(66556008)(110136005)(66476007)(8676002)(66946007)(81156014)(7696005)(7416002)(6506007)(86362001)(55236004)(33656002)(316002)(921003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RP+E3DLGlpLfnlQOYYQ7HLL1m7WBQSy2IVqHhYssNjNjYSUBhzdZo7Sk3OlsKxiMoOZRPYvvPWJuKf9/5IK6MMUWq3BXv+CTR1LP9rsfbQng4YXBQ9E9JZ2fg8Y6lsgcdekF1nM0iVS2Rvx21r1BS9Fz5uU2VsRmG9IccAgqeX2fW53g3KhoHIur7EesQ5S5wlm9NNlHGEgVDtdw7N02IUyQsYkKwpkaVu7T91gZW5dbwPdQS8Nt8SP/ZInv5la2y6/t1s2TBJsHBgzC5vBPV17NplsCcFILiDu+DAXuaP+hyxxJxen8oFzjMdVJN7u1U6dskE9zN9+ZSt/fZ3frSewsHvyW/2k042FKcqzc6GZirFU5HYloez+AvgtFcEYfegkJhvhDcfDEB6OEtGkAonGKYYMvf+/aM3ijN6t2pP7mGtlxNdv6t7ymY0KF/OktcNLJBtoAkM9W7HM2Sn+LBIyzEjo9XA3C8K/Ikeqd9XM=
x-ms-exchange-antispam-messagedata: FQVPJYUqzNiX/BrZjiCDKpwnfgJ4AJVSxjiqEYaAh9NFtCP7ega4mz9Lzv5KTjbU4UgZBLi+de0ANQMG/fAPMl1zjLUnNQqqFQl/2qEZ8xIoZ+/o/F6FAJ/78AmNmHXdFCLBLq5zxnZmlAmsp2+tYcy+5uxxNPCGV00Hphba9Fb5ferv5q+oE4oqC8Xm6AATLaslotd73BEidRgc70QrNetugsd8/l3WLiyGqTT6bQwm/v84zU/daOZxcXr1qADU/yx0aXS+Cim/ww+2l5MYbU/5YB97p1NgP/IZ12M/SWvbVgaEZjxqQZ89HLBQe90Q4nGylojmja8nqEpp9V8Yjmr0c5ofOsBnGTFv+4cmBpk1vvO4ISNGU/55TkBR5UQs1n4knMNUsIL3EmiUPQnyzuRRMUkarYyaUOlGAKjODUx+orIyNheFAE6LxT8lKiVuKstzuTRDiiixEGhk+DnMyRnz5HWDxR2GcsreTVzB9SMf/jHVXydMRxNSTehPXL3lp2Ok6EDQzlCLvmJyKjhGl/WWezHSyL6Qwly77/iWq63gox08WFHWfKquDUCYMrmsf/rHlOXuJniQyx2Zno+yM2kLALaUFZ8DwHSG12gjKFTSlhEwhQvemMifQL2hUumKpgj4jXUsUMlPij8NmAvXgkQlZPPe/ftIm/U4QJ+R8Xff7gdjqwSj0xeXwBi5YewQy9NVb+TFgkor2gsMD0IwpYrLifRnixIp2OEXCgHRfpP/ly5yHa/vqIxA0fIs+5qa4Kw3qPo21c0LU0EjpSI+HQXOlWQZFSJdZ5pczBbpcuM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 918f3b2b-bee6-4eb5-17a3-08d7e8351ad3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 09:51:47.3049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fNMoqyk35zZAhsReSCZ/uJJJnGjmi4tGW7jySPNuJXRDr3ZQnkWckKVrNlRUVDMeVVt28mwVdBRlzlwVM2ywgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4883
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEJhcnQNCg0KPiANCj4gV2hhdCBhcmUgdGhlIHNpbWlsYXJpdGllcyBhbmQgZGlmZmVyZW5j
ZXMgY29tcGFyZWQgdG8gdGhlIGxpZ2h0bnZtIGZyYW1ld29yaw0KPiB0aGF0IHdhcyBhZGRlZCBz
ZXZlcmFsIHllYXJzIGFnbyB0byB0aGUgTGludXgga2VybmVsPyBXaGljaCBvZiB0aGUgY29kZSBp
biB0aGlzDQo+IHBhdGNoIGNhbiBiZSBzaGFyZWQgd2l0aCB0aGUgbGlnaHRudm0gZnJhbWV3b3Jr
Pw0KPiANCkkgZG9u4oCZdCBmdWxseSBjb21wcmVoZW5kIExpZ2h0bnZtLCBhbmQgc3R1ZGllZCBp
dCBpbiByZWNlbnQgZGF5cy4gaXQgaXMgbm90IHBvc3NpYmxlIHRvDQpkZXBsb3kgTGlnaHRudm0g
ZnJhbWV3b3JrIGluIFVGUyBIUEIuIA0KVUZTIEhQQiBoYXMgYSBzaW1pbGFyIGlkZWEgd2l0aCBO
dm1lIEhNQiwgIHdoaWNoIGJvdGggdGFrZSBob3N0LXNpZGUgbWVtb3J5IGFzDQpkZXZpY2Ugb25i
b2FyZCBmbGFzaCB0byBob2xkIEwyUCBtYXAgZW50cmllcy4gIEJ1dCBib3RoIGFyZSBub3QgdGhl
IHNhbWUsICBVRlMgSFBCDQpjYWNoZSBjYW5ub3QgYmUgYWNjZXNzZWQgYnkgVUZTIGRldmljZSBv
dmVyIFVGUyBidXMuIEFjY2VzcyBhbmQgY29udHJvbCBvZiBVRlMgSFBCDQpjYWNoZSBjb21wbGV0
ZWx5IGFsbCBkZXBlbmQgb24gdGhlIGhvc3Qgc2lkZSBVRlMgSFBCIGRyaXZlci4NCiANCkhQQiBo
YXMgdHdvIGNvbnRyb2wgbW9kZXM6IGRldmljZSBjb250cm9sIG1vZGUgYW5kIGhvc3QgY29udHJv
bCBtb2RlLiAgSW4gdGhlIGRldmljZQ0KTW9kZSwgSFBCIGRyaXZlciByZWFkcyBMMlAgbWFwIGRh
dGEgb25seSBiYXNlZCBvbiB0aGUgZGV2aWNlIHJlY29tbWVuZGF0aW9ucy4NCkhvd2V2ZXIgaW4g
dGhlIGhvc3QgY29udHJvbCBtb2RlLCBpdCBpcyBtdWNoIG1vcmUgZmxleGlibGUsIEhQQiBkcml2
ZXIgY29tcGxldGVseSBjYW4NCmluaXRpYXRlIHRoZSBMMlAgcmVhZCBhY3RpdmVseS4gIEluIGhv
c3QgbW9kZSwgSFBCIGNhbiBsaW1pdCByZWFkIGxhdGVuY3kgYW5kIGFjaGlldmUNCnByZWRpY3Rh
YmxlIHJlYWQgbGF0ZW5jeSwgc2luY2UgdGhlIGhvc3Qgc2lkZSBjYW4gbG9hZCB0aGUgTDJQIG1h
cCBlbnRyaWVzIGJhc2VkIG9uIGl0cw0KcmVhZCBiZWhhdmlvciBhbmQgb25jb21pbmcgcmVhZC4g
QnV0IGN1cnJlbnQgZXhpc3QgVUZTIHN1YnN5c3RlbSwgY2Fubm90IG1ha2UgZnVsbA0KdXNlIG9m
IHRoaXMgZmVhdHVyZS4NCiANCkkgZG9uJ3Qga25vdyBob3cgZG8geW91IHRoaW5rIGFib3V0IGFk
ZGluZyBhIGZyYW1ld29yayBpbiBTQ1NJLCBsZXQgRlMgY2FuIHBhc3Mgb25jb21pbmcgcmVhZCBs
ZW5ndGggdG8NClVGUyBIUEIsIHRoZSBiYXNlZCBvbiB0aGF0LCBIUEIgY2FuIGxvYWQgTDJQIGVu
dHJpZXMgaW4gYWR2YW5jZS4NCg0KLy9CZWFuDQoNCg0KDQo=
