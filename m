Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495A2C33CA2
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 12:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03CBD2072A
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 12:03:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UiZrLXUw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="e3h79P4U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgAJMDp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:03:45 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:53692 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbgAJMDp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 07:03:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578657824; x=1610193824;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mIYuEtE1twTS6pBp6Lhyf5q26O/j9t/zJOD3JxSEF6A=;
  b=UiZrLXUwM5dxpVu+h3/wY+6gmrwJ90P7xFg213Xln+Cmdr28pcifdueZ
   EzmpriDHeXRm6WgFVHEHBiIYPyH/NLCx4w2qgr+wuDCXVoBDLqvK6vDYo
   /wTOYSWPE5GsO5fDTbMomxlvu/KO3VCUKMdj8pI7qOXHk9bY6QVAa7jne
   YMFRXRds5UcPgeDaZ2FF4MXb0PMHCdQGJMPHy/rZBgEJbbsP9x5bW9u0D
   GGjljWbCgkEkEDVmGizjpttLhpZc2i+9YLIoiHLVIVyH7LOiEqFq6ARVG
   mWx5RWIOGxyPfpoO+VVP0jcdfpJo4EmBGC2DmdQfdbva0zJdJ+6LN9hLA
   Q==;
IronPort-SDR: 8OBa70XfvJm90PWwjrk+uxwe7qArdEyU5MfYOWbS6G9bPwbpZ7y9MgKEX6JDxoAYnxDIBlfbU7
 HmnNJLRoXp1gURt0OncnBAL/bm0kj/0PFHEywWXq3B2eR6PMQfS7LAheG3HWJV08pKXZG4oQ+o
 k1TWTVLstVuXOJ7zucVVzuYnJnqHtpOWEU7yHWO0ItLgDdzMMysWiqF7gLXegeVee1szNxKqe2
 HquDg5b0Fv/P8RdBb5fYoBlc31aKI/MzRnESUDP1M3gPXpKVwQH/1Wbz89gjb9aiHJyP5ISHmV
 s6E=
X-IronPort-AV: E=Sophos;i="5.69,416,1571673600"; 
   d="scan'208";a="234935208"
Received: from mail-sn1nam04lp2057.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.57])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2020 20:03:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ev0frBsBv+evq6hp0mIvYJqmYmAMxNZu4SgM3yfqLrnxna88bUFBD5qNEGlo6/+gRge1gUoBJB7aP6GBZhDckpVhgaB1HGEPl6tPPWgMOOrPBiYuqPeUrF4zfWR/xMZ4lPH7LWRQFEx0rpluy89dZAy9eEqpjqfQ7XPBRQLo6CuZ//A8CuJPNmGrObAxW/5uRymcC0Krtfal/l8tQadln4tiCBaXYF8xdUwWcX8CHZF/vNDAk7Nc/AWE/IKappmhEsFSauxmlNjD4K9/Icl4CwPT2GuhgC/ZT5o16cecTHHTjEcXbHoP+GuQiv5WmQW6DCECffh0/2/u28tZvp5fYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIYuEtE1twTS6pBp6Lhyf5q26O/j9t/zJOD3JxSEF6A=;
 b=ReXuu3Fz5Y54dpjPu75Rjp/TUJW43pAtTS4wrkc1PXzIpw09vd4xjnPv0C8xZ9RKHWvVGScHGsfzdAR389YsQn2sxOZn7Qz8t7Aj0ZuPzbNKl0MLysG8B/i+6zDIaMp4xX73fWELQDAoXPNnct56JTr1GK8k+Q5tEnRbK1VZQyb6h8aqY6zCvI+5zkn+gzLLfQ6teaDJRO1RGMnhmVvbg0Sxr9qYu3qQOdaeIwAdzrX4eD98l+nF2bq63GhsjfvXXAP2Bo8UT+TpXUXaEpuPJaoLtFV0T9gi9qUIUiDX0OoE4gUXeQhA/4Ffq+mTeqnZbJMKURvsnu48cU/c1ELSlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIYuEtE1twTS6pBp6Lhyf5q26O/j9t/zJOD3JxSEF6A=;
 b=e3h79P4UgqaZwc5HDjP84UAEu0NnhYPMKnut2NoMtjf7qMUFQSna7X0Wg4Kf6OdrkWteNi8shXQAaV7LpPfXzEDJBqoAqmLLAcupVUBHsGuNceMtVcDi1sNKI3HRZGBcR1nN5GJhMZshN4xyI3aTWohhr4b/xbktngmblAPLE5A=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5952.namprd04.prod.outlook.com (20.179.21.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Fri, 10 Jan 2020 12:03:42 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45%4]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 12:03:42 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Can Guo <cang@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH 4/4] ufs: Let the SCSI core allocate per-command UFS data
Thread-Topic: [PATCH 4/4] ufs: Let the SCSI core allocate per-command UFS data
Thread-Index: AQHVxZBMBjHYQAMMRUSGfCYvryuWmqfiFWXggADXmACAAOOVgA==
Date:   Fri, 10 Jan 2020 12:03:41 +0000
Message-ID: <MN2PR04MB699185200396C559CC2976F2FC380@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200107192531.73802-1-bvanassche@acm.org>
 <20200107192531.73802-5-bvanassche@acm.org>
 <MN2PR04MB69913704982A01708C36374FFC390@MN2PR04MB6991.namprd04.prod.outlook.com>
 <45cb376d-42b8-5bc9-70e1-a93935d02287@acm.org>
In-Reply-To: <45cb376d-42b8-5bc9-70e1-a93935d02287@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.137.86.228]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a80feb92-ff8b-4274-c2cb-08d795c522c4
x-ms-traffictypediagnostic: MN2PR04MB5952:
x-microsoft-antispam-prvs: <MN2PR04MB5952A491F4B5B685C17A8A30FC380@MN2PR04MB5952.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(189003)(199004)(110136005)(4326008)(54906003)(186003)(26005)(7416002)(316002)(478600001)(86362001)(7696005)(53546011)(33656002)(52536014)(9686003)(76116006)(5660300002)(55016002)(8676002)(8936002)(81166006)(81156014)(66946007)(6506007)(66556008)(2906002)(66446008)(71200400001)(64756008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5952;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h3Q4hZNjfiKGmthCg46Zi5f0KEBVKXjyDeLVWqdNY5g83sp3I3nnOaQF6zD7f7CYmTKOEPlqkdv++yrnVzigcNl8bHS7ruycqT6pToA9LiSPgkvLdY5oFtwWnqwXDU6lK9RlHUdWau2NpDFhbmuEeYYtjWFFycAjXixMeg04vs87TH1QzNvl44h0gfiOMrRuHG0ekSWlQZEmxzOPdljlChS3kGB56w2+bayTBUvAG4ZMH8JxO9DmpoOlwteGXBgBDkzl7LBmCYslorEPsS3DbhhF36yBzvBgVGdfE880md3RLReBC1wxnHG0mebk+Y/nDAJULa5RWnrgCdpkxzlD+Lv5DwCqZlBqd6rLxmmKx1dlcR/oD5MweNLln9W9C7YnPcHfbc8jP3XPnjT+zHXrdEgnIpWWD3hRRaE5Alpb9o/A2zeVQAB4i7AzXuGBM+MZ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a80feb92-ff8b-4274-c2cb-08d795c522c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 12:03:41.8520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LNiMPo+cX5/rVuzc1c6ro7erqJ8kCTXidwLtZuCi3SUqPc8sloYelUFF5vO9N8YIqh+x6ThprkU0TZOvh9E6yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5952
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T0suICBUaGFua3MuDQpQbGVhc2UgYWRkIG15IFJldmlld2VkLWJ5IHRhZyB0byB5b3VyIG5leHQg
dmVyLg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IA0KPiBPbiAxLzkvMjAgMTo0OCBBTSwgQXZy
aSBBbHRtYW4gd3JvdGU6DQo+ID4gQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiA+PiArICAgICAg
IC8qIFNlZSBhbHNvIHVmc2hjZF9pc19zY3NpKCkgKi8NCj4gPj4gKyAgICAgICBzd2l0Y2ggKHJl
cV9vcChjbWQtPnJlcXVlc3QpKSB7DQo+ID4+ICsgICAgICAgY2FzZSBSRVFfT1BfRFJWX0lOOg0K
PiA+PiArICAgICAgIGNhc2UgUkVRX09QX0RSVl9PVVQ6DQo+ID4+ICsgICAgICAgICAgICAgICBX
QVJOX09OX09OQ0UodHJ1ZSk7DQo+ICA+DQo+ID4gTWF5YmUganVzdCBXQVJOX09OX09OQ0UoIXVm
c2hjZF9pc19zY3NpKGNtZC0+cmVxdWVzdCkpDQo+IA0KPiBHb29kIGlkZWEuIFdpbGwgZG8uDQo+
IA0KPiA+PiArc3RhdGljIGludCB1ZnNoY2RfaW5pdF9jbWRfcHJpdihzdHJ1Y3QgU2NzaV9Ib3N0
ICpzaG9zdCwgc3RydWN0DQo+ID4+ICtzY3NpX2NtbmQgKmNtZCkgew0KPiA+PiArICAgICAgIHN0
cnVjdCB1ZnNfaGJhICpoYmEgPSBzaG9zdF9wcml2KHNob3N0KTsNCj4gPj4gKw0KPiA+PiArICAg
ICAgIHVmc2hjZF9pbml0X2xyYihoYmEsIHNjc2lfY21kX3ByaXYoY21kKSwgY21kLT50YWcpOw0K
PiAgPg0KPiA+IFNvIHVmc2hjZF9pbml0X2xyYigpIGlzIGNhbGxlZCBub3cgZm9yIGV2ZXJ5IG5l
dyByZXF1ZXN0Pw0KPiANCj4gdWZzaGNkX2luaXRfbHJiKCkgaXMgb25seSBjYWxsZWQgZnJvbSBp
bnNpZGUgc2NzaV9hZGRfaG9zdCgpLCBuYW1lbHkgYXMNCj4gZm9sbG93czoNCj4gDQo+IHNjc2lf
YWRkX2hvc3QoKQ0KPiAtPiBzY3NpX2FkZF9ob3N0X3dpdGhfZG1hKCkNCj4gICAgLT4gc2NzaV9t
cV9zZXR1cF90YWdzKCkNCj4gICAgICAtPiBibGtfbXFfYWxsb2NfdGFnX3NldCgpDQo+ICAgICAg
ICAtPiBibGtfbXFfYWxsb2NfcnFfbWFwcygpDQo+ICAgICAgICAgIC0+IF9fYmxrX21xX2FsbG9j
X3JxX21hcHMoKQ0KPiAgICAgICAgICAgIC0+IF9fYmxrX21xX2FsbG9jX3JxX21hcCgpDQo+ICAg
ICAgICAgICAgICAtPiBibGtfbXFfYWxsb2NfcnFzKCkNCj4gICAgICAgICAgICAgICAgLT4gYmxr
X21xX2luaXRfcmVxdWVzdCgpDQo+ICAgICAgICAgICAgICAgICAgLT4gc2NzaV9tcV9pbml0X3Jl
cXVlc3QoKQ0KPiAgICAgICAgICAgICAgICAgICAgLT4gdWZzaGNkX2luaXRfY21kX3ByaXYoKQ0K
PiANCj4gPj4gQEAgLTYwNzQsNyArNjEzMiw4IEBAIHN0YXRpYyBpbnQNCj4gPj4gdWZzaGNkX2Vo
X2RldmljZV9yZXNldF9oYW5kbGVyKHN0cnVjdA0KPiA+PiBzY3NpX2NtbmQgKmNtZCkNCj4gPj4N
Cj4gPj4gICAgICAgICAgLyogY2xlYXIgdGhlIGNvbW1hbmRzIHRoYXQgd2VyZSBwZW5kaW5nIGZv
ciBjb3JyZXNwb25kaW5nIExVTiAqLw0KPiA+PiAgICAgICAgICBmb3JfZWFjaF9zZXRfYml0KHBv
cywgJmhiYS0+b3V0c3RhbmRpbmdfcmVxcywgaGJhLT5udXRycykgew0KPiA+PiAtICAgICAgICAg
ICAgICAgaWYgKGhiYS0+bHJiW3Bvc10ubHVuID09IGxyYnAtPmx1bikgew0KPiA+PiArICAgICAg
ICAgICAgICAgbHJicDIgPSB1ZnNoY2RfdGFnX3RvX2xyYihoYmEsIHBvcyk7DQo+ICA+DQo+ID4g
Q2FuIGxycGIyIGJlIG51bGwgaGVyZT8NCj4gDQo+IGxycGIyIGNhbiBvbmx5IGJlIE5VTEwgaWYg
dGhlICdwb3MnIGFyZ3VtZW50IHBhc3NlZCB0bw0KPiB1ZnNoY2RfdGFnX3RvX2xyYigpIGlzIG5v
dCBhIHZhbGlkIHRhZy4gZm9yX2VhY2hfc2V0X2JpdCgpIGhvd2V2ZXIgZ3VhcmFudGVlcw0KPiB0
aGF0IDAgPD0gcG9zIDwgaGJhLT5udXRycyBhbmQgaGVuY2UgZ3VhcmFudGVlcyB0aGF0ICdwb3Mn
IGlzIGEgdmFsaWQgdGFnLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
