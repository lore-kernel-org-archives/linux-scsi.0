Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C18AEC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 11:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 929D161359
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 11:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhKGLJ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Nov 2021 06:09:59 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36214 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhKGLJ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Nov 2021 06:09:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636283236; x=1667819236;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OZ6T9Bo58Ddqx7KOs46wqIwIhUwOfCHlye4zAmMRqTQ=;
  b=FWMkzJLq6EQhl1/01cvBA8/J9E8XQlG2VWyVqSh4zHkZh/6J6UYptVDf
   LvT3ARhNeN4eeuCgGR8NPNFw7TnIacNI9J/ollQXQdtTTlUFgQZPnwlSU
   DCm05sTrEnl2CfgEGKfkUWwxqbvYjmNArXzQopWXgOhJxRpDXOCRcF37z
   5jvxg0U4SvExs6agEfJnVHQ1z1p/U/2GrKwtGPYhyqREWQLbEyR9czW3S
   eAxyUnOryTyfmUhp8B9B5vq6EgAqJJRRfiRhHkAzLjrkgIPQYZ+eZSuTi
   ioP/1PTALmZxjvh3C6Jfs5U6/ldfs2xVd7eijovl9L1G1XeAZWYmy2vd0
   w==;
X-IronPort-AV: E=Sophos;i="5.87,216,1631548800"; 
   d="scan'208";a="185914834"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 07 Nov 2021 19:07:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8SUmBy4zeec4IRBwKsyXezSX2VxaIuHfD8GTSqV4A83EpBN6j+sPzAPS6xSFn3jgoAITnfrw87MAyUUXfVrwXgEkzEpFDv1l2PWMsUzd2+VvFDEobUPhHZR+wXifnSQwSh1nWwaa3AdKxfovPOIQqL3DOo42sb2VfzdxcpwNi0cFM3OXNXJSWCY6l6BlNeWiSsNJfhkfpfCwqMdxdnr0JJPLz7MQ3k51tGpwfs2UN9WVzmqzR+g1k5wDzNdkUkDqK4dfmWEEfGHBUpLR/BzeHjUgelJQa4DRr23eoD/dSqIHI+a8L3Ja/geCl/+pDBC/qqHGakFoc0US/vImZlCLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZ6T9Bo58Ddqx7KOs46wqIwIhUwOfCHlye4zAmMRqTQ=;
 b=BIrnAUjCNi4X+Qbo1uU3NUObTDpMJM9qcYuvsh5ZIkDdmqdK1h6Y/OyCVh3/1QmjLAjaj/vAatO2RuS7whlpYxLGKZAdFzdSWk0JY6M4j1iz+F5sheKMvTNht7J5yG6SQyDrP+miSgijJa7Ucml+w+OHi1q7k0aifrBIcpGfZS9WSdS/Bt0cvgx728LOTLxlu71wSpVPOXpAeJ1BYNWPkeXkyK2p83reKrJggPn6zjZWIyd80m/4ZIJ0rK+T7awQCHsWfB6PYyyX1fPHTOZA4Cc540pnmsJUkVDNWWLqIKSJrOaXBUnyHwoM2tnG2YjXt/sa8fxp94MNCdL+TKd3KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZ6T9Bo58Ddqx7KOs46wqIwIhUwOfCHlye4zAmMRqTQ=;
 b=IIn8z2tj90q5921oXbQEWlCXO1pWql+6P4hllknZZYmT8a/5Z5zAdktejXo8Qy1wPP2VZALb7wIrRsF0veTFrseG/gHT257+aeVdEDXu2Bzab1PLU5TUn1GCSB/v6rI+LeMvbdut40ay8Hpb5zEO/O1voXqfpibgEYsHCr0LQRE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5948.namprd04.prod.outlook.com (2603:10b6:5:168::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Sun, 7 Nov 2021 11:07:12 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4669.016; Sun, 7 Nov 2021
 11:07:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
Thread-Topic: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
Thread-Index: AQHX0EaSSjZqSA+VqEiwzPZ1y3EecKvxXzOAgAaKwzA=
Date:   Sun, 7 Nov 2021 11:07:12 +0000
Message-ID: <DM6PR04MB6575BC6BCE4A6BFBB0E3F519FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
 <82dffddc-15e8-dc1a-abda-e84e7e441d87@intel.com>
In-Reply-To: <82dffddc-15e8-dc1a-abda-e84e7e441d87@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3723276d-9178-4fd3-28c3-08d9a1debfd6
x-ms-traffictypediagnostic: DM6PR04MB5948:
x-microsoft-antispam-prvs: <DM6PR04MB59483D71913DC3E701FB94B6FC909@DM6PR04MB5948.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T8CSO6Jmkla68/+5qztGvYdxSBTyYxMP9xRsG56o+5llBC5XqpGCVHJ1LEDImSx/8LmS2e6p1V+BrHkBFUPZxtFI5FWGNJdJMnSMW6GkvpVumNoFfMf2a7QHnVxFS5fPmxBcJV1kAi4IHhh7RKSly7spZ3PNEbAV4HuZjNFxhPZE6WIocm7t1uoemaJZZO2A7siIMecEUttafypUslbqu2i8rTaOhe1CTDW8wrpzZJ8kb+wuY6K0JVu9Vinc9xDieIkLVADKwBpdWg6ZgFjqhozniFQh6c7bt6etlaP7v63GnkkZBgujTW7g7uoU8gP0dpM2K5ak+TRORZW3LuV8mItRZkGsk3unRAlF+F1kl4tzGpqJotgXaztlW0boesqC+ZTRhs7gnRm6BSUlLTjgRpsR0eQp+VQ49NbBpFamM7ZeEtFNFjNCtb6fP/QYtiaA4YAijuy64sa64JBpG4mdTE9pGOVxOjckjKZIQyDH90iBfdmv110MYnoitlsrzNYpE6HDEKE6dE3KtQN7BTXS1ddS6+0y3sKtmUAGtNwoBR+w+eSH/1UCwXI03OQdxel3UyyWjcmrqocpr7aCkN5JiK7kjohFq8lUUvQdDK1FndeSVSq22LQa9a/vcpG2Ju2PR9BmRawDeLY/NQa5pBBHzq0EDsCXHlTqGK9h/z2MeUEpmXtw+gE8ZOLpfemyDeQtNEP9iaZtPvC/BUDqur5vkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(66446008)(66556008)(26005)(66476007)(8676002)(64756008)(86362001)(55016002)(83380400001)(110136005)(5660300002)(66946007)(76116006)(316002)(4744005)(186003)(4326008)(38070700005)(9686003)(54906003)(82960400001)(122000001)(7696005)(6506007)(2906002)(52536014)(38100700002)(508600001)(33656002)(71200400001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2hmSUxjTWZvWituZWZkTjhJNFVUNmV0OUVsSnRQcTJWTFppQlVhMndKcUov?=
 =?utf-8?B?c2dpaVJOTWs3QzRFdjhMOHVGbUFaZ2JBMU1mSWloZFA1M0F6ZzRpL3RJUDNv?=
 =?utf-8?B?aTliSWhPVE1XZXVReXNxQU5TVjUybFJxKzNiTlEwSEJ5OHcvdldKTmJsZU8z?=
 =?utf-8?B?K3cyM2NuY3YzeUdRMVNTL2tZQ2cvejQvK2oxSEdnakNUSGt1VFpNK3N2amVM?=
 =?utf-8?B?dzhkemM4eVdZUmJMdGZhZWZCL3JDd1J4RUdLYmdEYTNhbUdMcnhmNmVaTis0?=
 =?utf-8?B?bllpbm4zNmpIMVpmL0VjUVcvR0h6ZFFOTGtEZjhCQXJnT0wzUG5lQTE1QzdV?=
 =?utf-8?B?VWhadXFrVkFjN29tb3Z0VWNOWjZOaGovVkx2d29UMWJRZ1JPeUlQazFBalBj?=
 =?utf-8?B?NWtNTUdjdWdPR2Y2eFJVVjBZMU1wUVAvbTJSZ1NtS0xENjBOcGJ0cVVKa0VC?=
 =?utf-8?B?VnFPSUJXRExIaEFJQng2MjRXUWhxWFJRY0p6VWc5WDk2a2pqL0RlalVvTmpu?=
 =?utf-8?B?UXp1NDhlMkNYMVJKeWpMbEl6N2lOM1VVNUFNSXZnVmJtQncvaGJIZUdhb3JO?=
 =?utf-8?B?TE40TkdUT05MS2M1eGtFSzBFVEU0Wm9KY1ZyRisySWNtMHdiWXA3c1lhMlV2?=
 =?utf-8?B?dGJPZ0RoSFVGUTFTcGZsZ01rVkV0MktoVWE0ZUJ2VHhYM3JmclRqMWlXcG1v?=
 =?utf-8?B?TEZJSll4dC9sbEU1MDgzUFdKTUF1RW10VXVrd3VGV1ZVN2RKZ05NYi9NMStm?=
 =?utf-8?B?K0F5eGlpRi9NNEdsS0dSUEc3dHNxd2VZc3JqRHh5dFRXeS81cDljaUdiRXVm?=
 =?utf-8?B?STZyd1dWV0xURDJNMnpqSXBWSkFKQ2JtNWZib0grUEtEV1pVK2RaaTBrR3U2?=
 =?utf-8?B?TlR2Q05ZMTR1Uk9Pekw0aFd3Ui91NC9yUS8vVnZmNG1UL09QM0JHYkU4ZWxB?=
 =?utf-8?B?YU5XNVUzeTh2OVpsWVY4R0p3RGRuME1xc0ttZXVWLzYvTlpJaVU5ZW4xblNn?=
 =?utf-8?B?blorN2dnL2ZJL3MyWUFQVVpYN0t2akNZcExqdWxnR0JHc2JWb053NUcreTRW?=
 =?utf-8?B?dnp3Vmp3OWE5aXptbEFBZXRHdENJckVTS1N0S1AyMmFZMGtmV3dqOUFFdGo0?=
 =?utf-8?B?VFFMamFLc3EwWTMvUDgyT1BGZ3lyWE5XTFJIMGFWWTZIbW00MzJTUFRvdksr?=
 =?utf-8?B?V2ZLWk5BODR0VWhQMWxMb3dWRFBpQ1I2aFJFTkM3bFY0U3VsYmFUUUYyMVd3?=
 =?utf-8?B?c1JrQ1pieVpmbXdhQ3kvWm1YRE9mN1NVY0RJWmVDTlI4QS8rdzBJbldOZC9V?=
 =?utf-8?B?UjJBS3ZJTGs1SWw5L3YwMndXZTVKTnl1bjlMSjNqNzhwZzRmMDd5R3lsbkxt?=
 =?utf-8?B?Y2VzQ2dGdC8rS1NrNndlb2NtSU5IK2VZWmJTMWt6R3VzcmdZQlUvUmxDSnBK?=
 =?utf-8?B?TEtFVXN5YUZORnBFOUdOV1lyRnpMSloyNlppaVB3UnoyNWhxQ0FFSzV2VFda?=
 =?utf-8?B?bVI0ZlBXTThKRTAxTzBYb3dmMkY3ZlBxdjVSMWR4WVVVNTVJcWd3THkxemVK?=
 =?utf-8?B?KzZUaWh0d0MzcjEycTBJNjRJVmI0SHJOWkdlYTF2bk1zRlRGR0Iwcng5ZWZt?=
 =?utf-8?B?anF5MEZRVE80QzB0WVNpeENIeWMwNVJlNzlXemVhanVSRW5HbWk4UzliaUdm?=
 =?utf-8?B?dm9ZczRkNkZleFFWTkRyRUFWb2dxZ21OOFR6SCttSU4rV3NQNlU1aWNYRUFt?=
 =?utf-8?B?V1Q4MmlSbW5XQUNBMENsTjRpUXZFbjE4WWMxZVFkT3ZxRXIxeDA2ZFpHVVJR?=
 =?utf-8?B?bXNBTEp2RGRLaWpkcDg2VnVVdkpZWFIvKzl4ZnFkaVNQdW5aSnBwOHBOdUhH?=
 =?utf-8?B?d0s4cHUzakowcXQwSDFXMitVYzFFaFlHQ2VVdUp1Qkp5VmFxbWEvQ1BudjBR?=
 =?utf-8?B?ZGtiQ1FtZ3RhSmFXRm1EbXdCdFBZaXB1VWdQYjIvL1ZDSEtPMjgvaWY3dEN2?=
 =?utf-8?B?eFpuUGZjSEswUEE0b2lGMUVQMWpWYU9sVGw5K0lTNWRmT1EyMU16Y0U1ZzQv?=
 =?utf-8?B?QVkzL24wS3A0K2NZblVwbm1SaytkSmJHdzdpbTBYSXJKYjUxWHRydlQxeVUr?=
 =?utf-8?B?NVNoREpvVlVkUm50ckFSWTQ3dVZPVHhnZ2J0Z1ViY1ZLdm1LS1VvaGp6S3hS?=
 =?utf-8?B?U1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3723276d-9178-4fd3-28c3-08d9a1debfd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2021 11:07:12.1586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iULT77zPwfScBxkKRw5c/j0lsuRP99kYxEyC5wFw5edEfcATccC77NwKnhaZzW1fqG4fMFu/F5WnFJq4Z7wTWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5948
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+IEZpeCB0aGlzIGxvY2t1cCBieSBtYWtpbmcgdWZzaGNkX2V4ZWNfZGV2X2NtZCgpIGFsbG9j
YXRlIGEgcmVzZXJ2ZWQNCj4gPiByZXF1ZXN0Lg0KPiANCj4gSXQgaXMgd29ydGggbm90aW5nIHRo
YXQgdGhlIGVycm9yIGhhbmRsZXIgaXRzZWxmIGNvdWxkIGFsd2F5cyBmaW5kDQo+IGEgZnJlZSBz
bG90LCBlaXRoZXIgYnkgd2FpdGluZyBmb3Igb25lLCBvciBieSB0YWtpbmcgdGhlIHJlc2V0DQo+
IHBhdGggd2hpY2ggY2xlYXJzIGFsbCBzbG90cy4NCj4gDQo+IEhvd2V2ZXIsIHRoZSBwcm9ibGVt
IHdvdWxkIHRoZW4gYmUgcGxhY2VzIHRoYXQgY2F1c2UgdGhlIGVycm9yDQo+IGhhbmRsZXIgdG8g
d2FpdCwgbGlrZSBzeXNmcyAoZHVlIHRvIGhiYS0+aG9zdF9zZW0pLCBleGNlcHRpb24NCj4gZXZl
bnQgaGFuZGxlciAoZHVlIHRvIGNhbmNlbF93b3JrX3N5bmMoJmhiYS0+ZWVoX3dvcmspKSwgb3IN
Cj4gcG90ZW50aWFsbHkgYW55IG90aGVyIGRldiBjbWQgdXNlciAoZHVlIHRvIGhiYS0+ZGV2X2Nt
ZC5sb2NrKS4NCkluc3RlYWQgb2YgdGhlIHJlc2VydmVkIHRhZyBtZWNoYW5pc20sIHNpbmNlIHdl
IGFyZSBpbiByZXNldC1hbmQtcmVzdG9yZSBwYXRoLA0KaG93IGFib3V0IGZvcmNpbmcgb25lIHNs
b3Qgb3V0IGlmIHRoZSBkb29yYmVsbCBpcyBmdWxsPw0KDQo+IA0KPiBPbmNlIHRoZSBsYXllcmlu
ZyBhbmQgbG9ja2luZyBpcyBzb3J0ZWQgb3V0LCBpdCBtaWdodCBiZSBwb3NzaWJsZQ0KPiB0byBn
ZXQgcmlkIG9mIHRoZSByZXNlcnZlZCB0YWcsIGlmIHRoZXJlIHdhcyBhIHBlcmZvcm1hbmNlDQo+
IGJlbmVmaXQuDQo+IA0KPiBNb3JlIHRvIHRoZSBwb2ludCB0aG91Z2gsIGZvciB0aGUgcmVhc29u
cyBhYm92ZSwgeW91IG5lZWQgdG8NCj4gY2hhbmdlIHRoZSBvdGhlciBkZXYgY21kIHBhdGggYWxz
bw0KPiBpLmUuIHVmc2hjZF9pc3N1ZV9kZXZtYW5fdXBpdV9jbWQoKQ0KTWF5YmUgd2UgY2FuIGp1
c3QgcmV0dXJuIGVidXN5IGlmIHVmc2hjZF9laF9pbl9wcm9ncmVzcygpPw0KDQpUaGFua3MsDQpB
dnJpDQo=
