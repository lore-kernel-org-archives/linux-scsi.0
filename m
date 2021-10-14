Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666A6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 18:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D5CA611C5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 18:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhJNSxX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 14:53:23 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:18758 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhJNSxW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 14:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634237476; x=1665773476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gf2+2NeZkTDVPloX7i2TYQQBOlVEPV8cCxzbbOFn9Hs=;
  b=Q4mP/7vKmrjXfihYfMM1NbdkoJuXrcWEtMNrb1Ejxo3jmnaG+PHXzonV
   5h/dtibgqEQ3jGZBZknOWqun8ntJg+LeOhm1Itc6mZMJiGhCSssLhUD8C
   twBlfs+ZJdyPuoQqGvEu+P25CjUtwm1dAN/BwfdE3hGqKwasZPE81Fw0e
   RiLTN9tuQiUSY3GydXsLmG9Wxrl0ESFS5/1N5PZiHv2oFgZdJ4xgjOWZE
   woMbXjnZqWGRLRLNZspDGP2ZTQFbh0l2XbJV6XTCYiCkiPTPCOaeQSgvo
   QbOgf5F5H1gguwCell8MQjPkR9RKxv3h+qo4QzkE7GIPljO4ywNNnM47R
   g==;
X-IronPort-AV: E=Sophos;i="5.85,373,1624291200"; 
   d="scan'208";a="182873032"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 15 Oct 2021 02:51:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAXTTOkMGjr3hrnh5lROdhLaj3If77K5P6YUbBqB54sj8qgk6KV6QUXAXyg3i+Bygh+rcbqjPY6lTuyVVJaEAEQmRZoFT/0uMTJcjhyW677x4vqekvCJQOtia36YGjuf/1eqDgPs78tzC10VVxr6icAEmoAxbGiruLzpBc0tOLrLd3YeImtujTgTbs/6MlLLeyzvUnD5ESnlWmapgh3+/IFlv9ic58W/SvW+F1URw7rzlDJBwXGMROTphK44aBbUdEtUIJ5B63aRVJNoSPX6LTOd5dvn2Vk+/niT5YlQ3l0r7IllBe00MD8TnRuaJi+FsfD5Qoz7sOdoKRow6Dd+VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gf2+2NeZkTDVPloX7i2TYQQBOlVEPV8cCxzbbOFn9Hs=;
 b=ntJ1MzUZgdQH/zMDv/wMn33zt4mG6lpARukyirJ6VhB10rqzDqJILfZ4T3DaE0tB3UvXJgYDvR5hKr5ZZBlv7voaP4zvKRP66QPzaM6emsBUIZJFXZMk2JfvGgIUV+pj9Das7PGgbTh2y4EUrOb1QYGJuT92u5fQBAOsK54eBd/5KAi7xY/usDbsQnYXzzizmbMX80seSLwdYvk4f9L+vT6nTJaYPcupnQrH2qwny4D1uacJVZQZ9RHNiDAfWyBOIlfmy4dKYVfp/8r/uiNC2QYToB/hZDX7XrH8xnVX5bYyLmrhBSCXc3YD7GOoe9PthzMWnHA63ctNFbRECBzFVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gf2+2NeZkTDVPloX7i2TYQQBOlVEPV8cCxzbbOFn9Hs=;
 b=Eezg4TUKtiS/pKxNJmadONOJh3R0qRPwmc220yy/LucXCEJG3grZGJ1a12EIRRFfup4H/Y5Jj7N4zwlEhMj0Aj7ydXa8MlFW3V2lhx/8hPhb3mK0Nr22jeaCZtDjiV7UlL9DI20HonTyyd1Tb4pMzEOjdv2jR9GUbB4VVJ5E9T4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0731.namprd04.prod.outlook.com (2603:10b6:3:f7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.19; Thu, 14 Oct 2021 18:51:12 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 18:51:12 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
CC:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: RE: [PATCH v4 14/16] scsi: ufs: ufs-exynos: multi-host configuration
 for exynosauto
Thread-Topic: [PATCH v4 14/16] scsi: ufs: ufs-exynos: multi-host configuration
 for exynosauto
Thread-Index: AQHXu1MPZ7SfT2vzskiGT12e3u9RZqvS3lWA
Date:   Thu, 14 Oct 2021 18:51:12 +0000
Message-ID: <DM6PR04MB65750B8E2F84802BF0647D7EFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p410e67850fdd25fc762b0bfa49c6e24f1@epcas2p4.samsung.com>
 <20211007080934.108804-15-chanho61.park@samsung.com>
In-Reply-To: <20211007080934.108804-15-chanho61.park@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 105b383b-b54f-4c0d-70f7-08d98f439827
x-ms-traffictypediagnostic: DM5PR04MB0731:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <DM5PR04MB0731EE9765670831A29E7B82FCB89@DM5PR04MB0731.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gFlTf0YAA4JrnYfEeG7eX8K0hmRfS0AxMU5VGmOWpp5rOxoa+6U5aozCRXp5CEJ83v5R/vMBGJop1+O5Jhg7GQmV62ePprb/3SyX6ti3u83fHJ2unnlozHRaDXuHv32cEvnikPf4rZD2m34PhrB2Vsic+rpPaf/vPz3XxIB3sAfbOxvnQ75rBKGEvRNbfe86Z22hGPwOjr7yUwgdDX6drkrHv12c0kqnNNcscMO0uDD/fAGb/iFwlvd4ec2m4K+0QjSR7pyFKfMKAwfDzzbwwTxfw/AtpGhOwPQPlApOe2w+1WPcFyHoBmOZw+nj3zGmvN5/AVN9hTCXoAYSGtJX3EQ8IVg1lql1VA+5NjtnHf0fB5qPLLHnItQ4SLjh0jDqwzmhYj0Y6FvfDF5+RalOJ9tre+nviuUdIssol7Y8AHKb77C/G3UYj7fhzOyIV9rtMSBuq8QCE7W5Kls1GZhyGVX4KSc+2DENj15OOLbnlD+c+zJU1MOgBi7TEPnD8LopLRgcFaqm1YFxTCcioBaHKK8HrrCMh+nlL3a4N8qNxbkmLPKVxyKhZoJybY7mRhBTaUup5tGr/4OM9sg7Dtxt5moPx9lVVXSkGaNQIVSfJn620LnyNl97bXFb61SGnZu3FtkCBZPY6ubek7LBkq/kjJc0cP5DSHt4KaHJqIqK6cYuOdmTw/8xwkJjMRlv7o64SGSwHLCEVHvUIaC/HzKQRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(38070700005)(86362001)(7696005)(6506007)(508600001)(71200400001)(8936002)(122000001)(2906002)(26005)(4326008)(33656002)(55016002)(52536014)(76116006)(4744005)(7416002)(64756008)(8676002)(66476007)(110136005)(66556008)(66446008)(54906003)(186003)(5660300002)(82960400001)(83380400001)(316002)(66946007)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnB4WGtsa2RNYnAwVWo1TVpBUjVNK0VYYm5xS2VkUTB1N2J6cFRCcE1qeXVv?=
 =?utf-8?B?NFo5Rlp4TS9lWXlLdnEvMXgza2s3bHhWeU5zQlh4SmhnSFRrMm84WUs4ODJt?=
 =?utf-8?B?MUVBZEhUY2RWNFhDTEZlMWRJbTBrRTVCWk1oQzAvRnFXbGV2TGw2OGRNcWhq?=
 =?utf-8?B?NmRubWhoTUZyQjZuYzFPNWlxYVdYc0Fxdm5hWnpBcmJrVXRxbHdKVEJSczJh?=
 =?utf-8?B?ZXBwQXA5Q3BaVkgxZitpZUpUSkRJVkNjRU1pbkdFdkxQQ2RjR09hdjZmbFZE?=
 =?utf-8?B?R1lKMmxBak5OclJnZDV4TDlYR2k3UGxQYk1iSlA4ei93cU1RT0hrRU9vWE9U?=
 =?utf-8?B?SnFjNWpNMExkNWpjNUh4dkFETnpZbUw3c2F5OGwvTUZrM054cjI1aTNQdHpC?=
 =?utf-8?B?d3QrME5hTTBEWkJEbm53YTdHRVNDazlYc2NrYldUQlIxY0RheWt5VXFyMmls?=
 =?utf-8?B?Y2tzWjFVcDR1aWxRb1h2amR2ZVVlRi9oZXJMMGNlT0xnMkJBU1VOZUJtTmty?=
 =?utf-8?B?bURpRWVXSmQ2L3RYaUlTcTBlZWFQSnZEVEdtY3JjaWdlb0JEMFZJbkJibi92?=
 =?utf-8?B?QVZrbHYrbXNVSW1oUFkyYThEZmNyYkRzaSs0ZXFzRE5pcUQyajk3Y25DL1gr?=
 =?utf-8?B?L1BGRnVSaGxhTDJuUlFtZzBXcjJ3bmVOY1o4ejdBTllTYjcrZnk2Tmh4eFBx?=
 =?utf-8?B?eE5CYjRRWHYxVUh1YW81VzhmRDk4ejRadG9qK3F4SW0yZ3ZycWdyejFxV0U2?=
 =?utf-8?B?V1duR0ZrV2NIT1lUM05ERk4xRHV0enA3NFZUOEV2UjZpdkxNUi8zZTJUTS9r?=
 =?utf-8?B?b0xGTXVYeW9MWjNLRGdpRjdaeEJqcUxVcE9pdWVYNVFZVm44MUNGMXFqWHg5?=
 =?utf-8?B?UkR2eG9oVVJ3eEdYdFdwVUVhSW5YSzdSYnVnSUR3OXZydEJqalg2WGtNUXEx?=
 =?utf-8?B?RExobmZWamJ4ZktTTzZiNkhRY2lndWFxZUp1MXluZUwyeTVnR1RKOGcwQUpu?=
 =?utf-8?B?d0NRaFVMZWtJM0V0ak5USzM4ZklEb0taRnZjOU90MUc3UVpRSm0xT3pzODdG?=
 =?utf-8?B?TjZDd2hjVEFKZjhUY2h2bFkrVnZrb2lIbFh3bThxN2Q4TGc1OWVOeEZqMkkx?=
 =?utf-8?B?RTRtNXd5eEJNMDJxb1ZuZkYxVGJJYmJubEV2SlB1b3hIZkcvMVlWQkFvVTNw?=
 =?utf-8?B?QkV1dzlOMytwSlc0clRIZVp3Y2NGdkx1cTgwcnY4NmNIZWNTRFZCUzVxWTlz?=
 =?utf-8?B?QWJXT3YzNUMvaStJUm9KajZTbXRhUHN0WmZJTnMyUWRBbTR2M09JWXJGb3ps?=
 =?utf-8?B?MDlxUGpSNGdlbHVUUUwvTHkvWWE0S0R3akVMUDVEa3ltNlZiZ0pSZ3RkcGNw?=
 =?utf-8?B?WnNSVUc0cGhnaUtSNmpkQ09zMTNod1lTNGNuMy95Y2Jub1RjYkc2bkhSWGls?=
 =?utf-8?B?eHJlTEVMR1VkdUt0Tzl5bjV2bVpEUGFvMzM4ZGxUKy9iM1AvZ251bWUrWUVl?=
 =?utf-8?B?T3BXdWpQUmJPcmdZOExXbGx1L0NPUUlCRE85ZFgzL0I3Vm85YWZXREZXL0h1?=
 =?utf-8?B?MlZtVUQ4aEJqV2hDVFdFTUhsSW5kNmVKY1JydXNpbjRBQk85NGkzOW81Z1kx?=
 =?utf-8?B?OUVKWFNaRzc4TWxhRDV6K2QzcytCM2Q3Wi9jWWR3R1hYN0tONWdHNTZvVDJw?=
 =?utf-8?B?b2VoWjI1dnZVbGhmZlQ3QUk5YjNaSTRmNlN3a3IzWXpZVXNLRmxzblp3TU50?=
 =?utf-8?Q?lqPJ4nh/13he3NAavoeqzys0R4+VSXQOiVQU/u2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 105b383b-b54f-4c0d-70f7-08d98f439827
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 18:51:12.7360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sx77MetGfn9DSWLlv6mm9js6L9F8lYFlnGNFBe4iOmqLXb2ywQmQNsqd4wQV+2H8gsUnYlliXy8EdEpfbI54mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0731
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArc3RhdGljIGludCBleHlub3NhdXRvX3Vmc19wb3N0X2hjZV9lbmFibGUoc3RydWN0IGV4eW5v
c191ZnMgKnVmcykNCj4gK3sNCj4gKyAgICAgICBzdHJ1Y3QgdWZzX2hiYSAqaGJhID0gdWZzLT5o
YmE7DQo+ICsNCj4gKyAgICAgICAvKiBFbmFibGUgVmlydHVhbCBIb3N0ICMxICovDQo+ICsgICAg
ICAgdWZzaGNkX3Jtd2woaGJhLCBNSENUUkxfRU5fVkhfTUFTSywgTUhDVFJMX0VOX1ZIKDEpLCBN
SENUUkwpOw0KPiArICAgICAgIC8qIERlZmF1bHQgVkggVHJhbnNmZXIgcGVybWlzc2lvbnMgKi8N
Cj4gKyAgICAgICBoY2lfd3JpdGVsKHVmcywgQUxMT1dfVFJBTlNfVkhfREVGQVVMVCwNCj4gSENJ
X01IX0FMTE9XQUJMRV9UUkFOX09GX1ZIKTsNCj4gKyAgICAgICAvKiBJSUQgaW5mb3JtYXRpb24g
aXMgcmVwbGFjZWQgaW4gVEFTS1RBR1s3OjVdIGluc3RlYWQgb2YgSUlEIGluIFVDRCAqLw0KPiAr
ICAgICAgIGhjaV93cml0ZWwodWZzLCAweDEsIEhDSV9NSF9JSURfSU5fVEFTS19UQUcpOw0KSWYg
SSB1bmRlcnN0YW5kIGNvcnJlY3RseSwgb25jZSB5b3Ugc2V0IHRoaXMgcmVnaXN0ZXIsDQp0aGUg
aHcgdGFrZXMgY2FyZSBvZiBwcm9wZXJseSBhcmJpdHJhdGluZyB0aGUgcmVxdWVzdHMgLSANClBI
ICsgdXAgdG8gNCBWSHMgdG90YWwgb2YgNSBtYWNoaW5lcywgZWFjaCBzdXBwb3J0aW5nIDMyIHJl
cXVlc3RzIGRvb3JiZWxsLg0KQ2FuIHlvdSBzaGFyZSB3aGF0IHBvbGljeSB0aGUgYXJiaXRlciB1
c2VzIGFtb25nIHRoZSA1IGRvb3JiZWxscz8NCg0KWW91IGFyZSBkZXNpZ25hdGluZyB0aGlzIGNo
YW5nZSB0byBiZSB1c2VkIGluIGEgVUZTMi4xIHBsYXRmb3JtcywgY29ycmVjdD8NCkFyZSB5b3Ug
cGxhbm5pbmcgdG8gdXNlIHRoZSBzYW1lIGZyYW1ld29yayBmb3IgVUZTSENJNC4wLCB3aGljaCB1
c2VzIE1DUT8NCg0KVGhhbmtzLA0KQXZyaQ0KPiArDQo+ICsgICAgICAgcmV0dXJuIDA7DQo+ICt9
DQo=
