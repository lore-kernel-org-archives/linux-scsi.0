Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE69C33CAF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 22:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A96A22071C
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 22:21:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="GD3KiKPO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgASWV0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 17:21:26 -0500
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:6250
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728775AbgASWV0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jan 2020 17:21:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOvMQ4wAgkLN/k5hoB/7zhdFknZgQ+32TnsFqAeslqgAzvYL3w33o8qy1W8v0JwISQ7JVrKYWBl1zBgmzMsOXJz5FVMgUW8Otcr+nYOIj6aaNOkqj5BfYuc4GxRiCXjghZ310ZqPG9f40oA0g7mdMwto8h9v23TjBW+/B5mlJPHIFn13sttC85mIKNrHV6W4MlCOfivUSSD37+c+u5cHa9gzTuhvndKFwZG5re2reQMs5xMNILvFeQUB1m1WH7D4HLKfpcGKc055/WO84I7/rNBMqrVfHtHXQwqZ105+CkVWxh/dWQYaYVFF3ILLDh5238O2ARURs9zaghzFDHlhHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0pi1mzYQ6S/XjIpdzjfO8CZ1BkBPXyboBSpm9fSdfDg=;
 b=QaT1EdwTdlJdlw0u+apPhohRw4X2AE2UXF+c1t+YwlbbWIY+Y35TesJyYmoERq/QhMRhzvPOxJQ8AwUKAOjvB3m6lfyMenipBYwU91DB4JOM3uWu1pOciEv7z3PhRFuFw0w4IGxPrBYBlCljU/txoo59Ij+0w6yDMOWiIuJP+2TqKKSO5eqVc3xNzqf4f+0WGg+Fh7Q9t4CBad08AK0vzSJe5kZh+1LmPZnzr+YK/BmLcFYYxKPfhKXg9mdrlDjMP79xhRNCQ+AWzE4z0bRo7FZoVwzPPVu4iTmkJdsngKJVvef/MmnIwWTUfNJVOV342WINqgjcrWqxSV0ZiDuVlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0pi1mzYQ6S/XjIpdzjfO8CZ1BkBPXyboBSpm9fSdfDg=;
 b=GD3KiKPO60h25NibV+SyKlHAlZgPqr7VRPX52BniTJaJNQDmL7jWTRW2G5v/av75BveWyMgN7R3whkaFtCVpJCM82/MrdgisNSI/Q3+8FR73mAVDgCGsVY6W30Hrizg4tyoFqsjd8ZX61bmNWk1wDrh4B1di24g8lhCKWLZ1THQ=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5252.namprd08.prod.outlook.com (20.176.177.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Sun, 19 Jan 2020 22:21:22 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2644.024; Sun, 19 Jan 2020
 22:21:22 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Alim Akhtar <alim.akhtar@gmail.com>, Bean Huo <huobean@gmail.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v3 4/8] scsi: ufs: move
 ufshcd_get_max_pwr_mode() to ufs_init_params()
Thread-Topic: [EXT] Re: [PATCH v3 4/8] scsi: ufs: move
 ufshcd_get_max_pwr_mode() to ufs_init_params()
Thread-Index: AQHVzmpzGqq3xXksUEW5XaXwk3+flKfyjAcQ
Date:   Sun, 19 Jan 2020 22:21:22 +0000
Message-ID: <BN7PR08MB5684F3522EFC24CFAE250C35DB330@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200119001327.29155-1-huobean@gmail.com>
 <20200119001327.29155-5-huobean@gmail.com>
 <CAGOxZ53F8mE-b2X5FS792ZFWtZE-V=RECf82EvR6_iDh8qFKZw@mail.gmail.com>
In-Reply-To: <CAGOxZ53F8mE-b2X5FS792ZFWtZE-V=RECf82EvR6_iDh8qFKZw@mail.gmail.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTAzZGEzMjQ0LTNiMGEtMTFlYS04Yjg5LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwwM2RhMzI0NS0zYjBhLTExZWEtOGI4OS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9Ijg5OSIgdD0iMTMyMjM5NDYwNzk5NDMyNjk0IiBoPSJIL05HMk41NW1xMERjYU4rRXV3d2I3YStNem89IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 112df2d9-65f7-47cc-1253-08d79d2dea35
x-ms-traffictypediagnostic: BN7PR08MB5252:|BN7PR08MB5252:|BN7PR08MB5252:
x-microsoft-antispam-prvs: <BN7PR08MB52522F4015FBEEAA160F9808DB330@BN7PR08MB5252.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0287BBA78D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(189003)(199004)(110136005)(7416002)(2906002)(54906003)(9686003)(55016002)(478600001)(316002)(7696005)(52536014)(4744005)(5660300002)(86362001)(66476007)(66556008)(66446008)(64756008)(76116006)(66946007)(55236004)(4326008)(6506007)(186003)(71200400001)(8676002)(33656002)(8936002)(81156014)(81166006)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5252;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tkUMbvtBqEZjggm+nTLa8leYx6QufWP8e0lZ5Xkm3h4FqnbjbyMSpY/C29yXGt2yxbeFlthbBMwP+kfJ56Pia2dCWPa3Y3h4ax4zmJeIrg5n4tmfB1aTcM8sDE6WWUi4G5gEuNDmIHcn3tMB9bpnu3IWv5p4lP5pnnYe5ueiDtWdDxpxfBX96oesQkPgPy+IwJruTz+irRwZ1rSD7GVmmT6mbPj/rbYnwcIp0jpj615dguMVAd9QkLF/PR5enYaa02w5FuWNVTnrRE3BkwpU/AE5IjT2e/GThksoS3ejEGpWNHRYoONX9vOQhEJ+Y+saSGc3B+PWgyc39BX20U/ZSBGBdLRhLYtdaIIJk9ljP+bdpG+j+pVIE9VR0FplLRKYDzDrtkPyWtFnv2LqsDJXWw9dvMh5mttLPVkyON1atilc4wGzv3F6s9UNgkV6nIRy
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 112df2d9-65f7-47cc-1253-08d79d2dea35
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2020 22:21:22.2871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MhJjcwYf6LYORygBmccBCFQZcvuW2dbVOfmsZftK+W1LgVkKfS7fADa5o9grlyvWV/DjcfT2mp1KEhad5th5dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5252
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEFsaW0NCg0KPiA+IEZyb206IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQo+ID4N
Cj4gPiB1ZnNoY2RfZ2V0X21heF9wd3JfbW9kZSgpIG9ubHkgbmVlZCB0byBiZSBjYWxsZWQgb25j
ZSB3aGlsZSBib290aW5nLA0KPiA+IHRha2UgaXQgb3V0IGZyb20gdWZzaGNkX3Byb2JlX2hiYSgp
IGFuZCBpbmxpbmUgaW50byB1ZnNoY2RfaW5pdF9wYXJhbXMoKS4NCj4gPg0KPiBUaGlzIGNhbiBi
ZSBzYWZlbHkgc3F1YXNoIHdpdGggdGhlIHByZXZpb3VzIHBhdGNoIHdoaWNoIGludHJvZHVjZQ0K
PiB1ZnNoY2RfaW5pdF9wYXJhbXMuDQo+DQoNCkkga2VwdCB0aGlzIHBhdGNoIGJlY2F1c2UgSSB3
YW50IHlvdSB0byByZXZpZXcgdGhlIHBhdGNoIGVhc2lseS4gVGhlIHByZXZpb3VzIHBhdGNoIGlz
IGV4YWN0bHkgdG8NCnNwbGl0IHVmc2hjZF9wcm9iZV9oYmEoKSwgZG9lc24ndCB3YW50IHRvIGRv
IGFueSBpbml0aWFsaXphdGlvbiBwYXRoIGZsb3cgY2hhbmdpbmcuIElmIEkgbWVyZ2UgdGhpcw0K
cGF0Y2ggdG8gdGhlIHByZXZpb3VzIG9uZSwgdGhhdCB3aWxsIGRpc29yZGVyIHRoZSBvcmlnaW5h
bCBjYWxsaW5nIHByb2Nlc3MsIGFuZCBzb21lIHJldmlld2VycyB3aWxsDQpoYXZlIG1vcmUgY29u
Y2VybiBhYm91dCBwcmV2aW91cyBwYXRjaC4NCg0Ka2VwdCB0aGVtIGluZGVwZW5kZW50bHksIGZv
ciB0aGUgcHJldmlvdXMgcGF0Y2gsIHlvdSBvbmx5IG5lZWQgdG8gY2hlY2sgaXRzIHNwbGl0LXVw
IHZhbGlkaXR5Lg0KDQoNClRoYW5rcywNCg0KLy9CZWFuDQoNCg==
