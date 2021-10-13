Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49EDCC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 12:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C321610D0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 12:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhJMMfW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 08:35:22 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:30449 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhJMMfU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 08:35:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634128397; x=1665664397;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/9AGMJIgFdXKAFOKiMk/vQp0ZPRetZYUMRG8MlwSF4E=;
  b=CFhVpjLcs+cV15kgMkBdpvDW3FfuYiTY2uhahY95Oe/N2MfmpQ4IVgLr
   XIzvlQ96cxlB0gfzwMVKv/KcLOuczdJ+z7NyB/h7TYKsbs3o44LqDzMP7
   m6pHbamFTMns0kqfgK+ZJVrgPtit2sbGRDUr/YNOINh+L8UjUqAKZlLf6
   cwEDreloWcgS6Zq37kt7o4l6ala30GQIArWMV8vOSQXmx1hNotNftj9EK
   CLWeJVA/jVHybIuUXEFsZl2pYqj4yhZoA2gsRqMlmlCEXco59Jk1nfSND
   JwPapd3HLi+RBqC2GP8KpK6wobFgvlugwmSzHgZo2o/ME8YCxz5P6OxVu
   A==;
X-IronPort-AV: E=Sophos;i="5.85,370,1624291200"; 
   d="scan'208";a="294450315"
Received: from mail-mw2nam08lp2177.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.177])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 20:33:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMe51hqeUG4GyMPnfCapjMX3R2C9YcQbw3KdNrwZfY+pZKnu9MSNL6+yCHtHLGT7jZxNrgxl5dcMOIrIPtuy5hRr9irctDK+rJsaTIYPw/+c3V8Gai7ULkEre6ru0eDwVAhnY18B5rGPeUotqeeHsXEiud1uWtIpcS/uNSqIhl6lse7LLPqoToHfwGXce1KkAaXvu6y+G9bjpnecWNFoNl+jmUSD/KPbWWhuOVLedPnr4g/+5TOVYq864axtmcO0TOPwuPwOeuK0QJTWbMQXCezmyZP6jZ1bM/3LpPildID+pziTB8s2slDwgNqIMVmvuR7BJp+DYlZgKWzqfNrtkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9AGMJIgFdXKAFOKiMk/vQp0ZPRetZYUMRG8MlwSF4E=;
 b=mLS9vwwegn6mmoOQJagKC5N4mqkbbsI1IL5XH2cnVhlJizxb0yu4j1Zv8iDXVVQLqcOIOl+oxr59SMKEaijshA54ukFoXkxWkZTo0h+F2MNKQXmfy90k5CWP7G585Aejf+9r48BwzhSxQV9gs8tvP9dP5BMyUrw4OqtyYRA4f16/NoZQWYcfKToVszI5IvqxQ3Qp9UiQG9xdBrFFxAn9fDsUvD96dvmX4hYN3rab89T8EtmlezN2ysoqGux+uUXyWP1+D2A+1kYFU/saO6ff3h+LwC4ODdlrZpS3VbO9uUsSoXnAh7uijk3dDDoIZEOn2eRLmmDYU9g83k1G7WQa4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9AGMJIgFdXKAFOKiMk/vQp0ZPRetZYUMRG8MlwSF4E=;
 b=kYVyXJuutPPgnE4xQYRtWTx8dkxUkAD19t7eC+bTQ4bBkdQkjqsDkdPYwu6TUkDa0v70v2V+BPMibEo5HLRluOyrRGRleCJxvpaVlXlhlN1JJVUxCw9F+MKDs0M/msSvfr2wqsEk1cwYyaLmoDkdf5OnWzsUomegtjaDV9iioTg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB3899.namprd04.prod.outlook.com (2603:10b6:5:b9::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.22; Wed, 13 Oct 2021 12:33:14 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 12:33:14 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/1] scsi: ufs-pci: Force a full restore after
 suspend-to-disk
Thread-Topic: [PATCH 0/1] scsi: ufs-pci: Force a full restore after
 suspend-to-disk
Thread-Index: AQHXv2ktILZ4+Vq6Pk6quV5n8PaEsavQv1twgAAQcwCAAA2dcA==
Date:   Wed, 13 Oct 2021 12:33:14 +0000
Message-ID: <DM6PR04MB6575E9C845EF88EAF2A65C35FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211012125914.21977-1-adrian.hunter@intel.com>
 <DM6PR04MB65752EF1F70EA5CF44F8AEAFFCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
 <4b6b177e-2311-5c90-2eaa-e648aeaa5d72@intel.com>
In-Reply-To: <4b6b177e-2311-5c90-2eaa-e648aeaa5d72@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b353639-affb-4514-a96a-08d98e45a059
x-ms-traffictypediagnostic: DM6PR04MB3899:
x-microsoft-antispam-prvs: <DM6PR04MB3899F58D6746C787261BA669FCB79@DM6PR04MB3899.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b5PMzJG2O+QSyDRhyZhkJd+ySuiD5MJiszWuXJwrQg+e96CuBqFOR7E3RXdfTZr4F7SOWXc15IxkbeIfkQ4Ana89jS9MJeb0EmkzYdWhYWp2ppnAMd5mcO88rxTstoTov6XQfXtPg0uPS4LiMqPMicbSLy/9618T4d5IBIcSkyi9zHDzLjKcXue0X9IJgA8YaRFnhGKwc/WTBFSNBcpb5429d4iwL4L9x8vJmhPqM5PtCviJdEd9sQyKbCPNJlmYnCMq1MfjYyMVpmlT746ATV7RZ2jb78hDuFHjPT2E18/8+ZtuLcRCtHU8VCSvYAuscpIwd78MXvekbeqOZkqYRg9J5eGJhtzV5GhZFLYDwK9eOOb2Aen5pS47H4AJKAPqMdjX6qqa7C/uHoNNwvNkN1yIDZ+V/fZxJKMluaM48kDEpb8dZvA7Je2gVySxmmWU4BIvmF+GuP3XxnIx881LCXORgwWA4ykYLZMvLMVqHWXj44gq/FSnPX8EeEIdIHLFBgI5G640rUUsYSFbC6lwCS5wKJJetJpFJm3498b3wLCJ2fqiPpPKwjpwysu3pvYfm69OugYo9VA6qpCDYONjFSX+Xi+37he1zdfg+/iDuMax0OV4JtZBhNLCL4OL2U/A4m1/KalZFVKObCdiGGF1KFM5cYEjjVZuvGv4uQEebN0yip6tYLlrZEVpdT6R2z2GL6YLTg1AxYLbyKey4s/m3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(186003)(53546011)(33656002)(66476007)(26005)(5660300002)(508600001)(66556008)(316002)(8936002)(8676002)(54906003)(15650500001)(55016002)(9686003)(66946007)(64756008)(6506007)(38100700002)(82960400001)(71200400001)(52536014)(122000001)(7696005)(66446008)(76116006)(2906002)(83380400001)(4744005)(4326008)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXBCVHNoK2QzaVRZcjMrZW9JcytCUlBRQ2VrMzluWG5STDJDbDg3Nm1sbkJ2?=
 =?utf-8?B?ekFlNnl0VHQzME1jWmlDOVBscnJ4TC8xMDd6Skg3RGNkTjUydGlhVkQ4WnRX?=
 =?utf-8?B?eWNsS1d2U0RwMHFmT29nV1RoM2ZLWk5ZcUFDTSs2NFFBaU84U0hYdFc2cVcr?=
 =?utf-8?B?YkhUVlZxSkFpQmdrMTNGOUQybFRzeXVCakRJRVVOb3V3VWYwaXhnRlZNdlp1?=
 =?utf-8?B?V1Y3ZDhaeXFCWVRmWTBaQWZtU0tPbWxhcVlXQXFDS1hVSVV3aUNadldLUm13?=
 =?utf-8?B?Sjg2a2FCOC9pcFNXczZqOFVnZjhZMktXbncvQURsZ0RDZnBJYTRzUEhpQkM1?=
 =?utf-8?B?RlFuOW1JL2pJZTlTTTk3MWEvMHk5eDBJUXVKeS9VdWNZRStJREF5OS82RHM2?=
 =?utf-8?B?MWJxTlBCRG1pUjdiRVVmbGJXZG1ReFh6NzJLSFRKRWVzZm0xWU1WRDN0WG11?=
 =?utf-8?B?SnVGTDl5K1VhS0ZiaVcxcFV6ODd1N1RTNUt0MHo5bHdEQmVwelhxMU9NZlBx?=
 =?utf-8?B?cVgxYVFEVStlVHMyc055a2lvNVVLQVVHZ3pBWVhkRU5iU2hFbmtDWUVpVlBu?=
 =?utf-8?B?aEs3bTNqMVBZbC9mdFk2bGpWT1Z2TEhIOTFXczhQdldOSXJadzI3V1JxTDZq?=
 =?utf-8?B?WlV6K3JXd2lDS1ZpN2puQnpnN3lua2gxdk5kWmNLR1pZTjNtVnpIZERwcGM0?=
 =?utf-8?B?MWxDcHZ6dnVKaDE4SmF3RmNidDZ2VUZGbUgxTGRMQytlTm9QTUc1UGFuU3I1?=
 =?utf-8?B?L09GS2V3ajZYSEZheEhwaUFxWFlRVnY0TEN0bGdhUzFRdVliVk0zR2o0aU13?=
 =?utf-8?B?TEZvQ1Y2L2xKbUlTYXp4VGxMMHQvSnpOaWhWWmpZVmRFR0ZDcGNZTkRFa1dh?=
 =?utf-8?B?NWFBT2s2bGVMVW1JZ1FUN3VydnlCenJjMjhHQnJYTkRMTC9rWi8rTU5YY2l1?=
 =?utf-8?B?UHRsNlRudC9ObEpBcEF3VXhEYjE3OXJ5TFJySzFiVDhEK25TWlA1bHVCZ1kw?=
 =?utf-8?B?c2p0NmZQZHJodU1QTWZpWXo4UUxLL2UyMERDOTBZSENmUkdSalljaGk0SHI1?=
 =?utf-8?B?VkhmODV6UktCSloyU2xOTkxxSWZEY3AvcklCYW9kMWp6cTU1aVNUWm56b09x?=
 =?utf-8?B?bHJ2UXB5Nm1HdkJCaW9aclhtSS9NbVJseUd3T0U2NGxreTJxL2dwdFh1dGtQ?=
 =?utf-8?B?M3hYMFVJRVpNd2pBWGFEY2lMeGxXNFVOYWVZUlFCRytoa2VtdW9SMjZ2YmlN?=
 =?utf-8?B?MGVNMXBPSWkvejllRzZCZjFFMm9QU0I3dzdyUkxyZ0wyQzhqZS9JWEFEY21v?=
 =?utf-8?B?NDVBSXhocmhmRmdqQ1l6aDlLRjY3STNGQTdLWnpldHdIWXVqc2UzNlZLaVp4?=
 =?utf-8?B?MEs5R3VkMTNVUHlkQ0JYcXZzVTEvQXg3QkR4RjRCemcvQzNyZnBjRFkvQitq?=
 =?utf-8?B?NFdXaUdBYnNZMyswSEJ0M05VNGd2ck5FY1ZBbDZtZkNtT2t1a0hSMzhTSFcx?=
 =?utf-8?B?bkN1NVJEUWJnazVYbENuUzZWQ3ZTOEg1dVl3RzlhdEE5WWIwL0lwaGV0eTF1?=
 =?utf-8?B?RWxQTDMzYzVGTkRYYUk3Qis3SW5JMWl5b3YyWlBzMTFwbWl0aFdnZjBhWDAy?=
 =?utf-8?B?cUF2MWYrRmVYN1N1b3lNem41OVZ0UE14S2FtMWhNRnphYUJNNFJsaHpEcWE0?=
 =?utf-8?B?TGxnY0xZTGthV3dhL1dnOHlJZXA0elNLci9GblpqbXVacWlSRHcrQXR0M0Zp?=
 =?utf-8?Q?zr7hTr75f/o7fUa6r0pdfIkiHLWnT0mmuGPzS0Z?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b353639-affb-4514-a96a-08d98e45a059
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 12:33:14.2504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HmcxoxVG8yQiYSARHf39mX3lWDcXvMR8ZxH9+1l78ecfOyBBrvLA//RxUKJmxEMcYL5I0QJ84adwNZRMAa1Z8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3899
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiAxMy8xMC8yMDIxIDEzOjQ2LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPj4gSGkNCj4gPj4N
Cj4gPj4gVGhpcyBwYXRjaCBlbnN1cmVzIHN1c3BlbmQtdG8tZGlzayB3b3JrcyB3aXRoIEhvc3Qg
UGVyZm9ybWFuY2UgQm9vc3Rlci4NCj4gPiBXaGF0IGlzICJzdXNwZW5kLXRvLWRpc2siPw0KPiAN
Cj4gSGliZXJuYXRpb24sIHJlZmVyIGtlcm5lbCBjb25maWcgQ09ORklHX0hJQkVSTkFUSU9OIGku
ZS4NCj4gDQo+IGVjaG8gZGlzayA+IC9zeXMvcG93ZXIvc3RhdGUNCj4gDQo+ID4gV2hhdCBwb3dl
ciBtb2RlIGlzIHVzZWQgZm9yIHRoYXQ/DQo+IA0KPiBTYW1lIGFzIHNwbV9sdmwgZXhjZXB0IHVm
c2hjZF93bF9wb3dlcm9mZigpIG5hdHVyYWxseSB1c2VzIHRoZSBzYW1lIGFzDQo+IHNodXRkb3du
IGkuZS4gUE9XRVJET1dODQpJZiBzcG1fbHZsIGlzIFNTVTMgLSB0aGUgZGV2aWNlIG1haW50YWlu
cyBpdHMgUkFNLg0KT24gU1NVNCBob3dldmVyLCB0aGUgUkFNIGlzIHBvd2VyZWQgZG93bi4NCg0K
PiANCj4gPg0KPiA+IFRoYW5rcywNCj4gPiBBdnJpDQo+ID4NCj4gPj4gU2luY2UgdGhlIEhvc3Qg
UGVyZm9tYW5jZSBCb29zdGVyIGZlYXR1cmUgd2FzIGFkZGVkIGluIHY1LjE1LCBwbGVhc2UNCj4g
Pj4gY29uc2lkZXIgdGhpcyBmb3IgdjUuMTUgZml4ZXMuDQo+ID4+DQo+ID4+DQo+ID4+IEFkcmlh
biBIdW50ZXIgKDEpOg0KPiA+PiAgICAgICBzY3NpOiB1ZnMtcGNpOiBGb3JjZSBhIGZ1bGwgcmVz
dG9yZSBhZnRlciBzdXNwZW5kLXRvLWRpc2sNCj4gPj4NCj4gPj4gIGRyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLXBjaS5jIHwgMzEgKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KPiA+PiAg
MSBmaWxlIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygtKQ0KPiA+Pg0K
PiA+Pg0KPiA+PiBSZWdhcmRzDQo+ID4+IEFkcmlhbg0KDQo=
