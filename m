Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CE0C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC8EB21741
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bvvRKjEQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HRLMTCfZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgBFNlA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 08:41:00 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4864 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbgBFNk7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 08:40:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580996459; x=1612532459;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R7aouK2pmIWRKwjR1iZqzm1WmaIthA/bKPV1+1/OZMQ=;
  b=bvvRKjEQKLQgyrjAlou5elZEZXrW+zuocGHKYEbbpH4ObI1rVeUnY06V
   rc3IUo8Q4NgTP6xiU964JZ4HWsnKuVJaCIvCiEmPE3bq43tZZjkDHdQBG
   sXXP7qIZFg1dRJyYv+RcBe9ruT66FqLHyFy1E9hiF3l+1HTFs3DDq45Qd
   QwM5NNinPPItOzQ4U4/vwIELDOqf2oc/hnIstgGuf7Xx2+M75IqfbvEGl
   L9feY/S1cM2TjATsY64gSbyGOijuaXwo7a0zq1Sxdj4sWVNuPbn39RlCe
   Banme6Q4dM0Psi5O7EUOGOwC11P3eqNm7YxF8+usKEBjnH+muKnBkp+Ix
   Q==;
IronPort-SDR: nGsAZAmEtAogXvruzsfKAXgx1z9SihjdD9sthIezZN+t+pOEkXCMOEZuoufoIn17WWUBPCnDUO
 ZujRdWwmSZU0hCnB+q4JDWFkt26yecSMWc+Ak3bmJXoa2unTZNL9ZMz6e9yQV/OFCFvtFAonFQ
 wajHENJOYqY3tT7WKDTldusFXPWde5eiHrCWwMDkMiBv+OyCk/EBdGaa/FLLNyGI2sXpVU7lZW
 uHb+9zMhv8+pDb/hBsn3ByHTiUl+2TcxGHCvjQC1LlZ0CZd7Xpd0ymuXVB93iuPXISmILtKOi2
 CxU=
X-IronPort-AV: E=Sophos;i="5.70,409,1574092800"; 
   d="scan'208";a="130713629"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2020 21:40:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVNxNHDc32FdWBQnp8fm/NhokeGe4t9XostsNsWI14AJIYJJs64ow9fZbccB9KRHMFl1yEq63QlWbmRlNEN6W5eAPEWNNo4q1Vd6x+kj5wMWsRe8um6SkWPKl/XODpJ2p4FBgQY696TXTQ9/qF4kY5Dg/owH3OVU+MuvCucYympOvcuA9HqrOn4S+KEQ73/H+icXsLxCbUamhrOgSvbfMeLucyZGwFYWMdqwZ4DSC7oZrew6u6LWPir3NYlY6QxwC4CH7OrsTouUoD74Om33MJ7uomyCAjGoyIgdiU8FBBhWi6q0rSowcprfdzkXV72APzi7EnH4FRGq+nJRByvweQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7aouK2pmIWRKwjR1iZqzm1WmaIthA/bKPV1+1/OZMQ=;
 b=mpX+B0PPvjf8YBpKJAoSxviK/f5jrMCHLLSnrjJmBKH68+8U6zNFlIBVq8glLckkEc5ZyTvGk6Ck3xLbB2tqEVq0/TmWPaG2b+MJqsRctRhMCXfvrpTOykxb7T5Uj01qEABf+0HYDgzAZFMUNKvPHEmAujZnE2cIsw9GaUn21ceu6WvsAQB+7iwwIyZdjrTR6RJFP9WdVm5UfxqFolYTl6hVfve7gJ+GVPCbMWHUQLvGi3qRFEZtZPaGkvJxDNv+Nvu2QH9VMJR8/AoHiYc8RD8cMyz+v5o/jYTZ+eVE+VnrC5L1xCwS1Gd4Zjc0ZkCPANtCEtNsQ4hum4ccG1+E+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7aouK2pmIWRKwjR1iZqzm1WmaIthA/bKPV1+1/OZMQ=;
 b=HRLMTCfZb2xlKDlYRaYBL51SaKZMzgQFCo6vjANazeAhMk5opsmIaGuzXqZAqr/STiJW4eqN/gwRSxtS6/ZmOpANv+uVxYmnTurLyH5Y3xkSCbOXvy4wkBiCLASwQRKqNgo/9QRnm3Z555uInxKaSc04BKu/cqLfvlsycosLYRM=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6062.namprd04.prod.outlook.com (20.178.247.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 13:40:57 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.020; Thu, 6 Feb 2020
 13:40:57 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Julian Calaby <julian.calaby@gmail.com>
CC:     Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Topic: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Thread-Index: AQHV2bYgyCYLCd8TvkGCDJX1L0irp6gISGeAgAEWVwCAAC+qAIAAZ98AgAANYYCAAIzHgIADb7iAgAAQtgCAAAb1sIAACmKAgAAMGmA=
Date:   Thu, 6 Feb 2020 13:40:56 +0000
Message-ID: <MN2PR04MB699190E3474F82BEF9B91A58FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
 <20200202192105.GA20107@roeck-us.net>
 <MN2PR04MB61906E820FAF0F17082D53AE9A000@MN2PR04MB6190.namprd04.prod.outlook.com>
 <94cb1e97-18ed-ebec-23c2-b4d87434726a@roeck-us.net>
 <MN2PR04MB69910152F14A7D481029E4ECFC000@MN2PR04MB6991.namprd04.prod.outlook.com>
 <20200203214733.GA30898@roeck-us.net>
 <BY5PR04MB69809A3BEFD629A67FB563CDFC030@BY5PR04MB6980.namprd04.prod.outlook.com>
 <MN2PR04MB6190D9E63717D37285DADBB09A1D0@MN2PR04MB6190.namprd04.prod.outlook.com>
 <CAGRGNgWG2fvY33j0m00SkguU8N4TJttY4KeNtOxZ7HzTTXA=yw@mail.gmail.com>
 <MN2PR04MB6991848EBC8DED439FCD7C49FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGRGNgUA=LHbWqZY+hsYjfsTbyftc3uoGv6S3p8E4zPQyqsOGQ@mail.gmail.com>
In-Reply-To: <CAGRGNgUA=LHbWqZY+hsYjfsTbyftc3uoGv6S3p8E4zPQyqsOGQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1ea2aeea-7d5d-4984-2e41-08d7ab0a31d8
x-ms-traffictypediagnostic: MN2PR04MB6062:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB60623DFD73A95943374248ABFC1D0@MN2PR04MB6062.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(189003)(199004)(5660300002)(53546011)(186003)(2906002)(26005)(7696005)(71200400001)(6506007)(316002)(6916009)(33656002)(8676002)(81156014)(81166006)(8936002)(66446008)(66556008)(64756008)(76116006)(66476007)(66946007)(86362001)(55016002)(54906003)(4326008)(9686003)(478600001)(52536014)(966005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6062;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tTTTGQcmCOmh32wi2avxjNx4xAC7QoI40cADB3MmWhf+wr5o4zqxRRrrb3h2/d+SkWbChmuz4xxuwhsnSdDbMiSYFSUZFtTX+Kn6YHMQ59CeIB92pg5UoYALmE0Xvc350K2lW38o+UmdnIW/dRh0QIitsphlkGtpdWsGPWnfEn6ChPG7uHiQT2LBFfEj6e6WeCAGp/DHqDrda0AFZLN4ZvGt9/aMsLev2nxW/A3MmMigzglcQy5gCIqhmHnhFjYSPitQUc71V41E/uPvB9FS6wcwWy+ddHzhsibxSJlD2IILOXkYI+BD9NFiHJ42Y3yShkkrZuuUKqjHpzUtq84EoH98yk1rKDuYb1HxkejTRVS7WNXJBUY4XSB3ybXcWQQIVNWl7UfA+tdLMmxZuotLVL3bxd5qOaZe1QX1zebo/LC4NNUNVymQkD976FO9VKwOwIFkA1L0Pif46bAV3vIOuCGarZaYzdhzy5q3kyyL3DGNnFMGSyihEaX7vTVGR0BtkGdrhyEQeeokLZzTs9v04w==
x-ms-exchange-antispam-messagedata: wtEcfF4/zQAKfzz9oCmGsY3WJY1/Ecd1F65VrrrBy7JmNU/6/2EUJBI5q4leQ2sHrYPG6WlC0VHityDUf4HAjXlCBdYx5S4ODtFV2Ktwn8hpOf0B6v5S07fGwJxE4xVpckzsAPbZOFAVPmWCVlTkOw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea2aeea-7d5d-4984-2e41-08d7ab0a31d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 13:40:56.8158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VBeUUWTyBOYMNX4gXxU5ZQBsKLRr7LKjRwkhGnmQFX9d78dx90PLY9lybHLC2Km4k5bv3Kda1rB1mA+ANldkSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6062
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gSGkgQXZyaSwNCj4gDQo+IE9uIFRodSwgRmViIDYsIDIwMjAgYXQgMTE6MDggUE0gQXZy
aSBBbHRtYW4gPEF2cmkuQWx0bWFuQHdkYy5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4NCj4gPiA+
DQo+ID4gPiBIaSBBdmksDQo+ID4gPg0KPiA+ID4gT24gVGh1LCBGZWIgNiwgMjAyMCBhdCA5OjQ4
IFBNIEF2aSBTaGNoaXNsb3dza2kNCj4gPiA+IDxBdmkuU2hjaGlzbG93c2tpQHdkYy5jb20+IHdy
b3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBBcyBpdCBiZWNvbWUgZXZpZGVudCB0aGF0IHRoZSBod21v
biBpcyBub3QgYSB2aWFibGUgb3B0aW9uIHRvDQo+IGltcGxlbWVudA0KPiA+ID4gdWZzIHRoZXJt
YWwgbm90aWZpY2F0aW9uLCBJIHdvdWxkIGFwcHJlY2lhdGUgc29tZSBjb25jcmV0ZSBjb21tZW50
cyBvZg0KPiB0aGlzDQo+ID4gPiBzZXJpZXMuDQo+ID4gPg0KPiA+ID4gVGhhdCBpc24ndCBteSBy
ZWFkaW5nIG9mIHRoaXMgdGhyZWFkLg0KPiA+ID4NCj4gPiA+IFlvdSBoYXZlIHR3byBvcHRpb25z
Og0KPiA+ID4gMS4gZXh0ZW5kIGRyaXZldGVtcCBpZiB0aGF0IG1ha2VzIHNlbnNlIGZvciB0aGlz
IHBhcnRpY3VsYXIgYXBwbGljYXRpb24uDQo+ID4gPiAyLiBmb2xsb3cgdGhlIG1vZGVsIG9mIG90
aGVyIGRldmljZXMgdGhhdCBoYXBwZW4gdG8gaGF2ZSBhIGJ1aWx0LWluDQo+ID4gPiB0ZW1wZXJh
dHVyZSBzZW5zb3IgYW5kIGV4cG9zZSB0aGUgaHdtb24gY29tcGF0aWJsZSBhdHRyaWJ1dGVzIGFz
IGENCj4gPiA+IHN1YmRldmljZQ0KPiA+ID4NCj4gPiA+IEl0IGFwcGVhcnMgdGhhdCBvcHRpb24g
MSBpc24ndCB2aWFibGUsIHNvIHdoYXQgYWJvdXQgb3B0aW9uIDI/DQo+ID4gVGhpcyB3aWxsIHJl
cXVpcmUgdG8gZXhwb3J0IHRoZSB1ZnMgZGV2aWNlIG1hbmFnZW1lbnQgY29tbWFuZHMsDQo+ID4g
V2hpY2ggaXMgcHJpdmV0IHRvIHRoZSB1ZnMgZHJpdmVyLg0KPiA+DQo+ID4gVGhpcyBpcyBub3Qg
YSB2aWFibGUgb3B0aW9uIGFzIHdlbGwsIGJlY2F1c2UgaXQgd2lsbCBhbGxvdyB1bnJlc3RyaWN0
ZWQgYWNjZXNzDQo+ID4gKEluY2x1ZGluZyBmb3JtYXQgZXRjLikgdG8gdGhlIHN0b3JhZ2UgZGV2
aWNlLg0KPiA+DQo+ID4gU29ycnkgZm9yIG5vdCBtYWtpbmcgaXQgY2xlYXJlciBiZWZvcmUuDQo+
IA0KPiBJIHNob3VsZCBoYXZlIGNsYXJpZmllZCBmdXJ0aGVyOiBJIG1lYW50IGhhdmluZyB0aGUg
VUZTIGRldmljZQ0KPiByZWdpc3RlciBhIEhXTU9OIGRyaXZlciB1c2luZyB0aGlzIEFQSToNCj4g
aHR0cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvaHRtbC9sYXRlc3QvaHdtb24vaHdtb24ta2VybmVs
LWFwaS5odG1sDQo+IA0KPiAqTm90KiB3cml0aW5nIGEgc2VwYXJhdGUgSFdNT04gZHJpdmVyIHRo
YXQgdXNlcyBzb21lIHByaXZhdGUgaW50ZXJmYWNlLg0KT2suDQpKdXN0IG9uZSBsYXN0IHF1ZXN0
aW9uOg0KVGhlIHVmcyBzcGVjIHJlcXVpcmVzIHRvIGJlIGFibGUgdG8gcmVhY3QgdXBvbiBhbiBl
eGNlcHRpb24gZXZlbnQgZnJvbSB0aGUgZGV2aWNlLg0KVGhlIHRoZXJtYWwgY29yZSBwcm92aWRl
cyBhbiBhcGkgaW4gdGhlIGZvcm0gb2YgdGhlcm1hbF9ub3RpZnlfZnJhbWV3b3JrKCkuDQpXaGF0
IHdvdWxkIGJlIHRoZSBod21vbiBlcXVpdmFsZW50IGZvciB0aGF0Pw0KDQpUaGFua3MsDQpBdnJp
DQoNCg==
