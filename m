Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15B0C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 06:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5BB660FC0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 06:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242284AbhIBGxM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 02:53:12 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44119 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237106AbhIBGxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 02:53:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630565533; x=1662101533;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w8iCCQagxWq3/QlnKOgzMA0XnkxtISYPYmxvWdYnCtE=;
  b=qCi5doHTiUJP38oAiZ2kCKU+zvoNOqlIh3xp50xBRfqYxzvPG5yoejDf
   XUHSPERMIoADqCjpnN/EcVk9tOzlZH6eVVqJfNvBo3K7WYPsz9vTy6RI8
   UqNOIRHIXM3wTp2B9HCUEfXpozjgRfLQBu2YH5Z8aRV1KhiBQ4Ub4qGdj
   Kf6GJdBBFtjypW28kxfeCB5OreT4lsCB3RNJ29hDU1ZeFRXE+bDc32brS
   PrNu4UVAfJXzvEcaHMgONs95ET9uYZ1PpwweYM2/af37/vThgp7Pjn+Kv
   UBs2PPUdQIqOALrpkFzYbh19cVDMRR44MFWE1IkxtKfIhZZM3DRB9zl8N
   w==;
X-IronPort-AV: E=Sophos;i="5.84,371,1620662400"; 
   d="scan'208";a="282813268"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 02 Sep 2021 14:52:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3+0zvHVNgGuh3HOtMa5vf+QPnAVONChDI4LynmfVLxBiULA/SlN6GqdJZceMv5Vqhs0Z0Ae44bsS1aDDtOY+a2yNCsL0xNffOmm5PGFnuZ0uVeXFBxK44TTxGxGgddF3lJcs9g8Ehse/7QfEKUVT+hJUX8yvzoiBBMOD4f4f8z2Gi1fBLsbWtzk9EKKVnpWB75gC402MV3O+t3dPGuHlswnMPmMkbBloMF1pppGWLHPqXZ5qEacT3nMMwyYthzPuuJ7O6TVlSo35slsUcOfxU8pPmzwjeeFBPsr57X771aPSHywzH/Gj+sops1/WrBTwjBj/ackbPbEcyAjh7iXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=w8iCCQagxWq3/QlnKOgzMA0XnkxtISYPYmxvWdYnCtE=;
 b=g05t800Nz9nMwQC9oWShuLF4jhrAXTpaWmVlYaf/J4kpJJlnT3kXOsfK/2USi8fYfWUfwx0tQLS29J1i5pXbUuSBm5n1uLJdlkQA2pjaAtQCT36AV3TsXuG+5+P/M2ykDIw0nA76axXnQZfsS7Xpc9QjIbfpU2apRPA5LfYlcZ0wKCADE7uh//pFqULRbJdf6pYyxlRmGnAKejnwK9jRU10FF3/2hxF69bqH54U4qoxzXTLntWWkRnYMgivW+D8xv2YtEnf3VshBU0IgsXIbOfIBBz2Og0d4k3UeHbxiDiOsGeOELdyVHCybepGimPLhGSIXb5mpvFs1NEYhppGDHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8iCCQagxWq3/QlnKOgzMA0XnkxtISYPYmxvWdYnCtE=;
 b=BzRSmsMO4udly3u3RGLj+PB23r+yfH17Atj1/bVHLVbVIF788QSQZGF+WnjJC5MMjIvmeuzWJNj2/ulaKE5BbLSVYukkMtH9DLSHXj/LGvv3qGpNy4i41dxCpFGCiybwUM3tyKeLWjLaThbS4notH4EzBAlvwYNWMg+0w8RW6pA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6511.namprd04.prod.outlook.com (2603:10b6:5:1bf::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19; Thu, 2 Sep 2021 06:52:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86%7]) with mapi id 15.20.4457.024; Thu, 2 Sep 2021
 06:52:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH 3/3] scsi: ufs-sysfs: Add sysfs entries for temperature
 notification
Thread-Topic: [PATCH 3/3] scsi: ufs-sysfs: Add sysfs entries for temperature
 notification
Thread-Index: AQHXny5PdQ2tnJxsz0q33tHp7qZa8KuPZTkAgADo/tA=
Date:   Thu, 2 Sep 2021 06:52:10 +0000
Message-ID: <DM6PR04MB6575999F5D92901B5D2791EFFCCE9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
 <20210901123707.5014-4-avri.altman@wdc.com>
 <0c547d74-481f-0c5e-9f7a-8c29218a0d3a@acm.org>
In-Reply-To: <0c547d74-481f-0c5e-9f7a-8c29218a0d3a@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d75366db-af4f-4354-b0d2-08d96dde305b
x-ms-traffictypediagnostic: DM6PR04MB6511:
x-microsoft-antispam-prvs: <DM6PR04MB6511CB5E1237C2FF2F53F658FCCE9@DM6PR04MB6511.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 17riN8bheLGdFWtVLRMBiWfyQbgvkUdq4CTLCp8NVommelx22itBX2dsntNKicdKqPsmsT/C1HsO9eZTQ0eOhT/uwNk52FtbGl13SQw2A7gGq/KpC4Rk1i+K2NfQ89T1ik5lgr6CO3ajKUhSaFhT2QZZrvGUy71QbYlYVTi1tbO3k91AHsfNqo0yxXNy5leKHzuYtvkaN8vmPsmTzRF9UrVV0FjmTxl90D8uJr9riUBrUVQsiA1zopy0bZrcijB8J3eRt8o8xnJD+SevlyPl7z3FgYkT4wFCOd1FmxwqpCFYjXSwVXZDxVKXKQkFWdFAgNXQtQTdUB/Cai6nSErIxTmQoUhj02NYEV9fck17/SXTTT7tXzd3kLosi9tz/+rNcBGSJPiUcN1JIaQXqR2J/rjQkAlVVmD8sUt5hFJR5P6aMtitShFaNc0s8TwJF3Eo+Fvm/XIYiyCSbwCc3xFS6sTLg4xM/QObvXZTlsR5p1ramtYsx9xq8gK8GtbvowjQPn+5sbeYq4tljcS/QRJa9TIy54A7nZNvrsDdWCmDaICsPVyy++16ySdpky7Ao5ytEcSRPbsvl/rP7WnBXNefS4LSRGCBOi00nrrJK4i+5AJ8nMmoD5dQJxQOXIEAew+6zeHY8Nwq0RuvZ3dRuRyoKKiH14R73KGZURCGat9AD0xy1yvjAj3yeKz5SgokBJnWSwvuWzMJI8T8kmhEHMe/cMQGw1pLDp8bNcg+vRZ6tQx0lcWJpvRMMHQZQoYO5CTFtlWbtJNY7i90n40iirLBCu6INuJ/yacQOyhIvCK5dfk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(15650500001)(4326008)(8936002)(52536014)(5660300002)(66556008)(66476007)(8676002)(66946007)(76116006)(110136005)(71200400001)(54906003)(66446008)(316002)(64756008)(33656002)(86362001)(966005)(122000001)(7696005)(38100700002)(6506007)(2906002)(53546011)(478600001)(83380400001)(55016002)(38070700005)(186003)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0xaMHR6Kzl1aFlOd0VVK0IwM3gvWHFUanVpWmVTck9pZVdDK1hZVDQ3QVZs?=
 =?utf-8?B?OUE1Y2NHdTZRZ0hjWHNvd1Vkc08xVUJQakpxcDFZak1Fb1RkTGtNTXY2eGxX?=
 =?utf-8?B?aVdZcGFxZHMzVTNaZnMrRmJndzNncUhMYXRhQitVdnFRbnZoSUZtUVZMcGZq?=
 =?utf-8?B?a2dDVllBdVJkUFhyWGJZUzBqYThDWjh5SUhRdytvVExRQkdXZU9ibTNhTjQr?=
 =?utf-8?B?M0orcVlJRnRTVTM5WmtPVjV0WmZaSmQxSTVYa2UvcGgrWXJ6N0ttaFNPdXdE?=
 =?utf-8?B?eGhaQVNJbStyeFE1T0xqVGdkMG1wRUYzL01hbWRncG4rdzk3TGpEVHlWU0Vm?=
 =?utf-8?B?bGFwdm9kNThTWHpxcHNYRjREN0JxSjhnUDhqV2lHekpiSHZmaEkvcHlUMDJy?=
 =?utf-8?B?RWVFRmkvSEdGSXp4dElqSjluR3VJckhidFF6TzU4dER1NjQrSStwWnBsNEFt?=
 =?utf-8?B?MTU3SDBvaHF5RG5hd3NkREdaMlcyd3Y4VnBEWVgrZ0RPMk5SWWlaUk03eVVB?=
 =?utf-8?B?UEVqbGZCOFcyZHVEc3h2ZkN4UytFL2VrMml3SklMN05XUWRZWlNRTUJCZTlQ?=
 =?utf-8?B?V1lGNm93b1QvYmNkZkZicmI0amhUSW5PWVNSSTlJajVZWjRGWDJ2ZlNSSUVX?=
 =?utf-8?B?YVBULy9jamZIK283d3JtRWszNUZSdisya1RzV1NlZXhXQ2xlbSs4RDc4T3gr?=
 =?utf-8?B?L1NFdmZTdmFYZm0xNlgyNDNiZnpwOGl1YmpMcW9zNE41MUtmTXk4bG9wMzcz?=
 =?utf-8?B?ckJ2SVVpZURZU3hiODF1SFUrRUg3Y25lbUcyNFJ6czRlemtZbk9QSjVsd284?=
 =?utf-8?B?c1JtUzRaRW1YWFhxZTJwQi82OTNPd3Y3RDhnQTNlVERrQTNkUW05ODkyVVJw?=
 =?utf-8?B?V2RIbjMxTllGR2M2NnBPNXhXR3B1VGxvYm40SFdhcmRiL0xEQ0lBaTcxRkFB?=
 =?utf-8?B?MU9lajZIVnlVTVZUQ0QzNmt0dUFEMDNnTmxmVHNoZldFdkwwdFdFSHQ0Mkto?=
 =?utf-8?B?eFdNYVV4QndpTzFaRVV4ZFlBY3krcHEyVXNXZ1d4bmQ3V1pDSXJrcDBIeUVv?=
 =?utf-8?B?K3VLOXVRMDZ5OW1rQjlzRnhrcjQwbnVpSkpDZDZLK092SWtMcGdySjVSVnNX?=
 =?utf-8?B?Ris5OG44K0lodHc4OHBTNmJhbWw3dkcrZC8yTU5SSytwTGp2cDk0SXA4Z2FF?=
 =?utf-8?B?YkFGNTJ3Vm5ySm8xL2IydXZSVithL0NiY3VYTk01Tm5PQXR4TDF2Qk43UWlY?=
 =?utf-8?B?bFA2dWdMdFU4YXp2a1MvVGpHRzA1cytOTnZ3SUliVWViVFRaVjlCZHlneW9a?=
 =?utf-8?B?YUcwOFI1MGxtZDA2YmZYb3ozTXdIekFQTjlqVnYvWnVwUzFtL0JISmpuUits?=
 =?utf-8?B?MkdpazQzQkwveFlja2luZE96SjV1RGRTeWRNVzE2ZnBQejJFd1RlUE14bXdE?=
 =?utf-8?B?L3MwRVFNOHk2T0l4MFJVaUttTmdOZ3VmcFhTekk0U0oxMk5JdDNmaytmSm5u?=
 =?utf-8?B?aHFEeFVqb0U1SzMzOWFCNWt1dVRXUDNpVkhNRUF5SjQwUWFCaXdzeld4RmpN?=
 =?utf-8?B?TXdEL2p3ZTVoc1ZrVHhvYzdMY3ZEanE4dVpORDRqZFpjdUdCZXl0L00wN3V2?=
 =?utf-8?B?bUV5eVhTTTNZVnJ3dXRUcGN3UWNtcGFIYkQ1VHpRNk52RGdPczdRMjdNOUlY?=
 =?utf-8?B?RHNtSWRlRWVzMkRHc1pZS1crNCtlbm1qZG1hZFozLzE2RHI3VG54SGhLd0Rz?=
 =?utf-8?Q?1rYc+hiwgbuwBNTeU+fj6F2oE3Q5A+YvgO6rWTU?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d75366db-af4f-4354-b0d2-08d96dde305b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 06:52:10.9784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bEZFwQ10s8KLuPuZoTwtXqAIZZ7+vtpWCs7NIsgkpUkECkWzfUwV+tRlzDtBx9u9IDyTLZXXQqcsgJ/q+VGR8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6511
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gOS8xLzIxIDU6MzcgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+ICtXaGF0Og0K
PiAvc3lzL2J1cy9wbGF0Zm9ybS9kcml2ZXJzL3Vmc2hjZC8qL2F0dHJpYnV0ZXMvY2FzZV9yb3Vn
aF90ZW1wDQo+ID4gK0RhdGU6ICAgICAgICAgICAgICAgIFNlcHRlbWJlciAyMDIxDQo+ID4gK0Nv
bnRhY3Q6ICAgICBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCj4gPiArRGVzY3Jp
cHRpb246IFRoZSBkZXZpY2UgY2FzZSByb3VnaCB0ZW1wZXJhdHVyZQ0KPiAoYkRldmljZUNhc2VS
b3VnaFRlbXBlcmF0dXJlDQo+ID4gKyAgICAgICAgICAgICBhdHRyaWJ1dGUpLiBJdCBpcyB0ZXJt
ZWQgInJvdWdoIiBkdWUgdG8gdGhlIGluaGVyZW50IGluYWNjdXJhY3kNCj4gPiArICAgICAgICAg
ICAgIG9mIHRoZSB0ZW1wZXJhdHVyZSBzZW5zb3IgaW5zaWRlIGEgc2VtaWNvbmR1Y3RvciBkZXZp
Y2UsDQo+ID4gKyAgICAgICAgICAgICBlLmcuICstIDEwIGRlZ3JlZXMgY2VudGlncmFkZSBlcnJv
ciByYW5nZS4NCj4gDQo+IE15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCB0aGUgd29yZCBDZWxzaXVz
IGlzIG1vcmUgY29tbW9uIHRoYW4gY2VudGlncmFkZQ0KPiBzbyBwbGVhc2UgdXNlIENlbHNpdXMg
aW5zdGVhZCBvZiBjZW50aWdyYWRlLiBTZWUgYWxzbw0KPiBodHRwczovL3d3dy5icmFubmFuLmNv
LnVrL2NlbHNpdXMtY2VudGlncmFkZS1hbmQtZmFocmVuaGVpdC8NCkRvbmUuDQoNCj4gDQo+ID4g
KyAgICAgICAgICAgICBhbGxvd2FibGUgcmFuZ2UgaXMgWy03OS4uMTcwXS4NCj4gPiArICAgICAg
ICAgICAgIFRoZSB0ZW1wZXJhdHVyZSByZWFkaW5ncyBhcmUgaW4gZGVjaW1hbCBkZWdyZWVzIENl
bHNpdXMuDQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgUGxlYXNlIG5vdGUgdGhhdCB0aGUgVGNh
c2UgdmFsaWRpdHkgZGVwZW5kcyBvbiB0aGUgc3RhdGUgb2YgdGhlDQo+ID4gKyAgICAgICAgICAg
ICB3RXhjZXB0aW9uRXZlbnRDb250cm9sIGF0dHJpYnV0ZTogaXQgaXMgdXAgdG8gdGhlIHVzZXIg
dG8NCj4gPiArICAgICAgICAgICAgIHZlcmlmeSB0aGF0IHRoZSBhcHBsaWNhYmxlIG1hc2sgKFRP
T19ISUdIX1RFTVBfRU4sIGFuZCAvIG9yDQo+ID4gKyAgICAgICAgICAgICBUT09fTE9XX1RFTVBf
RU4pIGlzIHNldCBmb3IgdGhlIGV4Y2VwdGlvbiBoYW5kbGluZyBjb250cm9sLg0KPiA+ICsgICAg
ICAgICAgICAgVGhpcyBjYW4gYmUgZWl0aGVyIGRvbmUgYnkgdWZzLWJzZyBvciB1ZnMtZGVidWdm
cy4NCj4gDQo+IEluc3RlYWQgb2YgbWFraW5nIHRoZSB1c2VyIHZlcmlmeSB3aGV0aGVyIGNhc2Vf
cm91Z2hfdGVtcCBpcyB2YWxpZCwNCj4gcGxlYXNlIG1vZGlmeSB0aGUga2VybmVsIGNvZGUgc3Vj
aCB0aGF0IGNhc2Vfcm91Z2hfdGVtcCBvbmx5IHJlcG9ydHMgYQ0KPiB2YWx1ZSBpZiB0aGF0IHZh
bHVlIGlzIHZhbGlkLiBPbmUgcG9zc2libGUgYXBwcm9hY2ggaXMgdG8gbWFrZSB0aGUgc2hvdw0K
PiBtZXRob2QgcmV0dXJuIGFuIGVycm9yIGNvZGUgaWYgY2FzZV9yb3VnaF90ZW1wIGlzIG5vdCB2
YWxpZC4NCkJ1dCBpdCBkb2VzLg0KSnVzdCB3YW50ZWQgdG8gZG9jdW1lbnQgdGhhdCBleGNlcHRp
b24gY29udHJvbCBpcyBjb250cm9sbGVkIGZyb20gdXNlciBzcGFjZSwNCkFuZCBhdm9pZCB0aGUg
ZXllYnJvdyByYWlzZXMgd2hlbiBnZXR0aW5nIGludmFsaWQgdGVtcGVyYXR1cmUgcmVhZGluZy4N
Cg0KPkFub3RoZXIgYW5kDQo+IHByb2JhYmx5IGJldHRlciBhcHByb2FjaCBpcyB0byBkZWZpbmUg
YSBzeXNmcyBhdHRyaWJ1dGUgZ3JvdXAgYW5kIHRvDQo+IG1ha2UgY2FzZV9yb3VnaF90ZW1wIHZp
c2libGUgb25seSBpZiBpdCBpcyB2YWxpZC4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLXN5c2ZzLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jDQo+ID4g
aW5kZXggNWM0MDVmZjdiNmVhLi5hOWFiZTMzYzQwZTQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtc3lzZnMuYw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXN5
c2ZzLmMNCj4gPiBAQCAtMTA0Nyw2ICsxMDQ3LDg2IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCB1ZnNo
Y2RfaXNfd2JfYXR0cnMoZW51bQ0KPiBhdHRyX2lkbiBpZG4pDQo+ID4gICAgICAgICAgICAgICBp
ZG4gPD0gUVVFUllfQVRUUl9JRE5fQ1VSUl9XQl9CVUZGX1NJWkU7DQo+ID4gICB9DQo+ID4NCj4g
PiArc3RhdGljIGlubGluZSBib29sIHVmc2hjZF9pc190ZW1wX2F0dHJzKGVudW0gYXR0cl9pZG4g
aWRuKQ0KPiA+ICt7DQo+ID4gKyAgICAgcmV0dXJuIGlkbiA+PSBRVUVSWV9BVFRSX0lETl9DQVNF
X1JPVUdIX1RFTVAgJiYNCj4gPiArICAgICAgICAgICAgaWRuIDw9IFFVRVJZX0FUVFJfSUROX0xP
V19URU1QX0JPVU5EOw0KPiA+ICt9DQo+IA0KPiBNb2Rlcm4gY29tcGlsZXJzIGFyZSBnb29kIGF0
IGRlY2lkaW5nIHdoZW4gdG8gaW5saW5lIGEgZnVuY3Rpb24gc28NCj4gcGxlYXNlIGxlYXZlIG91
dCB0aGUgJ2lubGluZScga2V5d29yZCBmcm9tIHRoZSBhYm92ZSBmdW5jdGlvbi4NCkRvbmUuDQoN
Cj4gDQo+ID4gK3N0YXRpYyBib29sIHVmc2hjZF9jYXNlX3RlbXBfbGVnYWwoc3RydWN0IHVmc19o
YmEgKmhiYSlcDQo+IA0KPiBQbGVhc2UgdXNlIGFub3RoZXIgd29yZCB0aGFuICJsZWdhbCIgc2lu
Y2UgdGhlIHByaW1hcnkgbWVhbmluZyBvZg0KPiAibGVnYWwiIGlzICJvZiBvciByZWxhdGluZyB0
byBsYXciLg0KRG9uZS4NCg0KPiANCj4gPiArICAgICB1ZnNoY2RfcnBtX2dldF9zeW5jKGhiYSk7
DQo+ID4gKyAgICAgcmV0ID0gdWZzaGNkX3F1ZXJ5X2F0dHIoaGJhLCBVUElVX1FVRVJZX09QQ09E
RV9SRUFEX0FUVFIsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUVVFUllfQVRU
Ul9JRE5fRUVfQ09OVFJPTCwgMCwgMCwgJmVlX21hc2spOw0KPiA+ICsgICAgIHVmc2hjZF9ycG1f
cHV0X3N5bmMoaGJhKTsNCj4gDQo+IEFyZSB0aGVyZSBhbnkgdWZzaGNkX3F1ZXJ5X2F0dHIoKSBj
YWxscyB0aGF0IGFyZSBub3Qgc3Vycm91bmRlZCBieQ0KPiB1ZnNoY2RfcnBtX3tnZXQscHV0fV9z
eW5jKCk/IElmIG5vdCwgcGxlYXNlIG1vdmUgdGhlDQo+IHVmc2hjZF9ycG1fe2dldCxwdXR9X3N5
bmMoKSBjYWxscyBpbnRvIHVmc2hjZF9xdWVyeV9hdHRyKCkuDQpXaWxsIGNoZWNrLg0KDQpUaGFu
a3MsDQpBdnJpDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0K
