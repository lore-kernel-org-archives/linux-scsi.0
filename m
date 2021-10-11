Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C60C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 11:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F8560F21
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 11:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhJKLiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 07:38:04 -0400
Received: from esa.hc4959-67.iphmx.com ([216.71.153.94]:52728 "EHLO
        esa.hc4959-67.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhJKLiD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 07:38:03 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2021 07:38:03 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1633952164; x=1665488164;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=AL8oHafC8vFAWNKXWA1xqocX23kZGWPwYFocXo9A9bM=;
  b=ivdyu2dVHkNwoILL1t2u8FnyC4NjNBPVRKm5TzNaeJ6r4ErxTD3M51K5
   oBIJMQFsCaN85Cd9F/YgbkGvp87MZMK6rfwxzr3ChXp5PpmABj5y0DNk0
   wjBx56kjKsWgnzPGicsdCigjyWmZYCV5Sap1r00AW5OjIcpl9qJszhDfu
   0=;
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 04:28:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNDJYW3l6cBuKX01k3FAUrIfjfqek884KOSqwV1pmTyMGhTk8hkn451fz91O4a4OO65KEohoZnkIVe8l3HBVccleiQy6QLuGJD2E3WSG5TsiCvTpczBb0kxSDrfaf5YZf8vvXpmlj4x+ZF2XtvaInjxcZnlc3iBn9JIWCKQVPrTiUkvNvPrSIKN50+DH+3EA7rLHEr+24G8ZKjXezSSMdlkFLvi6T7YGr9ydPo6eJL6YFu/LPDZj6oHWQyTIgrMbIeOixQ+/n2vp6vh5MNOOEeFgeJf7AwX4TNwCd5llHZoNmyj7e6aeJzaRAtCeBXhZqO7fLWmxMaTsISFF1PMxlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AL8oHafC8vFAWNKXWA1xqocX23kZGWPwYFocXo9A9bM=;
 b=HL5OcGoPvmAV/DYn+Ty0xiekBbBmdZb/WEnj+Bfsh/wsGA3LFCBDre4BwfTNALUN+BBWS75XRgSX1OfM5a+rIUqyV6oFmiPx6p0vt61eNjFJSEngTwMFxf64WHwVfeBG04X9VwCeb/T5fS/BHMtNyXHNQ3pPyyQEsp6z5fpux+qR4pwiS8VdBXs4vrxhAFQ6pE2GGh9BoxyOFRI4Yw5zvNlVSBJOjMm40kUfFaE2GjpHLbPGz97E0QhPgkFfy2wuVkDPaxZp4TSoz4wL4+UaL0p6Imu/Jw9pXsBVPs/0qElFchf+3sAwYoCQJq2GEeE4lIZCKGS8enKArk5dQrAmpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seagate.com; dmarc=pass action=none header.from=seagate.com;
 dkim=pass header.d=seagate.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AL8oHafC8vFAWNKXWA1xqocX23kZGWPwYFocXo9A9bM=;
 b=XVESr+K8TaLYzKm3EA5OihbZy3fKPOmtwZw5OE9KdNLpZlh5Eb0KPvO3GLDVCZtmu1FbrYXzjnSiuTZE1dnjUTrNbe38fd7V/+uWrKI5eAiG0MKqI+bIyomMWAv4Prf85uM77XQWttoQYcwqh6WpYsa5x9gnt8DggX+rbOUaaq8=
Received: from BLAPR20MB3954.namprd20.prod.outlook.com (2603:10b6:208:331::13)
 by BLAPR20MB4132.namprd20.prod.outlook.com (2603:10b6:208:332::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Mon, 11 Oct
 2021 11:28:52 +0000
Received: from BLAPR20MB3954.namprd20.prod.outlook.com
 ([fe80::acbe:9e08:b2a1:3da4]) by BLAPR20MB3954.namprd20.prod.outlook.com
 ([fe80::acbe:9e08:b2a1:3da4%8]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 11:28:52 +0000
From:   Tim Walker <tim.t.walker@seagate.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXpSNotPEsmgqq3UOuw6kK5XM0O6vNmP+A
Date:   Mon, 11 Oct 2021 11:28:51 +0000
Message-ID: <C6214FFF-B7E3-44F8-A1EC-FFB0F7C6E6B3@seagate.com>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
 <DM6PR04MB70819BAA37D51638C5D8A081E7B59@DM6PR04MB7081.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB70819BAA37D51638C5D8A081E7B59@DM6PR04MB7081.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=seagate.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3502922b-f687-4237-e597-08d98caa4d6f
x-ms-traffictypediagnostic: BLAPR20MB4132:
x-microsoft-antispam-prvs: <BLAPR20MB4132B2C9340D16988EBB9085D7B59@BLAPR20MB4132.namprd20.prod.outlook.com>
stx-hosted-ironport-oubound: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zzMWFcBEa7p9bpQNEzXvrjGCR0yOL3Qz0ITAHcy4cdJPRvtO6QiHv566b+2xQMk2KcPtARhsoOFQ/HEgQpV5arhTCUNRazu5lIupJeghRypme0mqx28iOa/7lXoC5sGCPQ/rL0S3jHF/P4HwTHJCMusdDmwmMkx8keYjxXBlVAdDIjMcvnjeVuH5Ixxdt5RzgQyZ65tYruohoIJfYTfd31rybPvZYujAZPfbzQiRZulpI2zKudkv+K0trhgbCSfZYBKsGIQFJeZVtJSGvlltXbX+TV0XDqVU87yW7uC1g3wwnmy5iAigZY+869dbv1WUh+h+pjAbhoZ7L/iEf38gwHAxBmpWjtv6velQN8+AJuPDN5/11ME/hKapzuPWVKafagl1mbVFoUP8JU71qjdDTrqkrUYtGram1d72c+TgtCyOhHWm74f+wcMI7JTwW4ZdDmhXbjD+m7JPRib4mP53n+yDqd4ebtcdjhnaubL7QpBDfvUBuu5Op6gQ/IPFRVBotKldUEqyyISbjpONFpO6nDJWj4pJa91KneP8GJOkQ6SfLcqqGbL09gfRLsEieUXeZnjBhgOxgvKbRSLzt6JJoXJcIHa8Z3AS/YhC1dtiQ/AaAiH9K0oYZLm28eBZf/W9FdfcQmqNujivAzTQlWWnY5PchHa2kcW/R36V6t9a+7zaTs9F84WJo3dtS+Ig2ih4kOImKVYpAZnTZscDIRC6E8edad5hoCE2XP4luILRSdZoNNsS6aCZ0TTG3PbAp9Xm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR20MB3954.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(83380400001)(66446008)(6486002)(6506007)(6512007)(36756003)(64756008)(26005)(508600001)(186003)(76116006)(66476007)(8936002)(91956017)(66946007)(2616005)(66556008)(71200400001)(5660300002)(316002)(33656002)(110136005)(38070700005)(86362001)(38100700002)(2906002)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2xTTnFXZVBiQmNoekNudzRxKzFYWnc5SHduL2srKy9wb1Y3TDVDZzV4b3pS?=
 =?utf-8?B?YzY1TWZHQUE4WUowcy9ReklqY0xCYXhIVWFIeUtUT1Q2aWRMTUd6MUZKSlFE?=
 =?utf-8?B?OTZnVjRpVlo2clNmbGJseXRJLzIzU3h3ZHg0Y0VmeFZDYWo2MlJlbUJDazBO?=
 =?utf-8?B?NmN3ZTBRWVlSWmR1aGMzTStRZkdlaDdZc3NwY1lqVFVaa3g4NThIcTV5MjJu?=
 =?utf-8?B?UGJWc1VSMWEzVVdlTjRybHpKQXlEaXM2TEtBMEF0T1RTWHlSL1R1ZFB3RFls?=
 =?utf-8?B?SmI3UFIxQ3AyZXc1REM4eEdJYWVSczV5VHU2b3gvNnZhSTFTTHBEa0ZGdElm?=
 =?utf-8?B?YUdGZUpXVS9Kc1JsaEpaOFZEWXFPUWhwZW5EczNsUGhOZnRKR3hVOHhISXhM?=
 =?utf-8?B?YlhiTXYveHFENE1QYXd1dmQyQjZ0WTlSbVVmTHpjQ0pJWDNtNFpDNC93cFhw?=
 =?utf-8?B?UFc0ZlRKa0dYcUdkOTBzb2FQWFRxRFpPM1VNMVc5RkJxMndIZzI1eHNUNW5p?=
 =?utf-8?B?OHgreUwvWUo3M3J3T2tnZndYZFkwVlNWMkRoK09pU2FjNDVZYmFFa052UmdX?=
 =?utf-8?B?WG1nRkRXWGI0QzdwY2RITldGeFU1dWQ4WHgxdFJCM3hKSzBnYXZGd21IUUpQ?=
 =?utf-8?B?Tlh3bGV0SDE5dkR6RVQ4Vm5QZkpUbjJac3JuV1VyODhJK0FNUUpIUmF0VGtO?=
 =?utf-8?B?NndndysvdS9MbStoQjVncE5FeEpHdmwreHJLSVBzZk1sbTV1ZDFIUXcwRnN0?=
 =?utf-8?B?NTlpMkJFcUo5Qk1VV0FQRlU1QlMzM0s4NVFZcTl6aHdJa3VVMWplNFBmZTFw?=
 =?utf-8?B?cVJYU1J2a0dwK0luWnhXNjN3RnZPYTFJVjFMWjFRdXRRNk1zbEgxb05rZFVF?=
 =?utf-8?B?S2hDb2FudVRjUmRKWkFrUVEyY1JKWkYrc2Q4Y0h0Ny8waURRbkJRSkJnd25j?=
 =?utf-8?B?RVBicWptc3drUVBnNE1NSitYVzIrc0E2UTdCdStQeEhqdXFEaDBobXZwK3hr?=
 =?utf-8?B?NEJKTW5Ta1N1S0hvS2JzTnh5eWp0OUwwQWZabGl5cHpXK3dyYnpmbURLUmlu?=
 =?utf-8?B?VndjREowdzUyS2hoVCtNby8rWUFqU095Z3RiVGRMNTVOWVdzS3Qzb1hSV0ZL?=
 =?utf-8?B?OGNMaWo3YlNoU2hOaVNLMnNyWEtRRHlMclhocmcvR1FSc2I5UjlxVkJ5Y3Ns?=
 =?utf-8?B?NUh5aXdqZm0zNFp2aDgzQVdXalVSaG1DK3lpcXBGRGJHTzRiWjVraS96dU1Q?=
 =?utf-8?B?eXlqQk96Zlc4eUVBSWd6S0Vrck5SaVpyVWZUSlUxeUhHOXpUZG5vQjVIM01N?=
 =?utf-8?B?NTl3eUF1am5iWG9hS2NPbmlkTGczWDdld3pBVDNnM00rRDNaakdyL3FJRXg3?=
 =?utf-8?B?ZjdJaGZCTFl5RjBKU2JYaWU4Sm5xVzJXZG9GTXcrY0RWM2Q5ejh1NllhYXBG?=
 =?utf-8?B?anV0dVJtaUk4M0ZBQSs5VDZNUm5WU0ZEWUxmQUF1QnVsc3FlSFpSUGxXUk9x?=
 =?utf-8?B?Rk5UVUl2UUNPRHBOSzFXRkJwVmcxRVJqWDUvbU16VkpEMUdnZVJkY2tEOUJJ?=
 =?utf-8?B?WExDLzJjUU8vemk2Q0pjTFBDS2QxQTYxKzZSZkxMd1FyaWVrR29OUkZBWkcr?=
 =?utf-8?B?bXYwQWkvbllCYURtMVZuWlB1Vk9nTGg3MUIyNEJjOXlWU2pZQkVITjVzeFB5?=
 =?utf-8?B?aForYTVjeHB4MlpFbjYyajVtYXIzc09OZFVBWGtIeWZGSUc5czZFczdVMXo5?=
 =?utf-8?B?bW9NM01nV1JjK25SaUExS2hZTDk0ZmppUCticEl4S1JMYkh3OE9yTFdPNXZQ?=
 =?utf-8?B?R293d0RNNWxUSHdja0pKZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8249C12548FF34E903D276A05FAD579@namprd20.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR20MB3954.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3502922b-f687-4237-e597-08d98caa4d6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 11:28:51.8485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qXuR8XA63fVo96dRjuCQmSNwhuxCULEWs0ttUU9U0gTKjhVtbvqcHblqR7k3TDae+j/2gPBkgWdKOCoWevjfFDZCk1YYqBgzlvogBjsVKNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR20MB4132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uICBNb25kYXksIE9jdG9iZXIgMTEsIDIwMjEgYXQgMzo1MDoyMCBBTSBEYW1pZW4g
TGUgTW9hbCB3cm90ZToNCg0KPg0KPg0KPk9uIDIwMjEvMDkvMDkgMTE6MzUsIERhbWllbiBMZSBN
b2FsIHdyb3RlOg0KPj4gU2luZ2xlIExVTiBtdWx0aS1hY3R1YXRvciBoYXJkLWRpc2tzIGFyZSBj
YXBwYWJsZSB0byBzZWVrIGFuZCBleGVjdXRlDQo+PiBtdWx0aXBsZSBjb21tYW5kcyBpbiBwYXJh
bGxlbC4gVGhpcyBjYXBhYmlsaXR5IGlzIGV4cG9zZWQgdG8gdGhlIGhvc3QNCj4+IHVzaW5nIHRo
ZSBDb25jdXJyZW50IFBvc2l0aW9uaW5nIFJhbmdlcyBWUEQgcGFnZSAoU0NTSSkgYW5kIExvZyAo
QVRBKS4NCj4+IEVhY2ggcG9zaXRpb25pbmcgcmFuZ2UgZGVzY3JpYmVzIHRoZSBjb250aWd1b3Vz
IHNldCBvZiBMQkFzIHRoYXQgYW4NCj4+IGFjdHVhdG9yIHNlcnZlcy4NCj4+DQo+PiBUaGlzIHNl
cmllcyBhZGRzIHN1cHBvcnQgdG8gdGhlIHNjc2kgZGlzayBkcml2ZXIgdG8gcmV0cmVpdmUgdGhp
cw0KPj4gaW5mb3JtYXRpb24gYW5kIGFkdmVydGl6ZSBpdCB0byB1c2VyIHNwYWNlIHRocm91Z2gg
c3lzZnMuIGxpYmF0YSBpcw0KPj4gYWxzbyBtb2RpZmllZCB0byBoYW5kbGUgQVRBIGRyaXZlcy4N
Cj4+DQo+PiBUaGUgZmlyc3QgcGF0Y2ggYWRkcyB0aGUgYmxvY2sgbGF5ZXIgcGx1bWJpbmcgdG8g
ZXhwb3NlIGNvbmN1cnJlbnQNCj4+IHNlY3RvciByYW5nZXMgb2YgdGhlIGRldmljZSB0aHJvdWdo
IHN5c2ZzIGFzIGEgc3ViLWRpcmVjdG9yeSBvZiB0aGUNCj4+IGRldmljZSBzeXNmcyBxdWV1ZSBk
aXJlY3RvcnkuIFBhdGNoIDIgYW5kIDMgYWRkIHN1cHBvcnQgdG8gc2QgYW5kDQo+PiBsaWJhdGEu
IEZpbmFsbHkgcGF0Y2ggNCBkb2N1bWVudHMgdGhlIHN5c2ZzIHF1ZXVlIGF0dHJpYnV0ZWQgY2hh
bmdlcy4NCj4+IFBhdGNoIDUgZml4ZXMgYSB0eXBvIGluIHRoZSBkb2N1bWVudCBmaWxlIChzdHJp
Y3RseSBzcGVha2luZywgbm90DQo+PiByZWxhdGVkIHRvIHRoaXMgc2VyaWVzKS4NCj4+DQo+PiBU
aGlzIHNlcmllcyBkb2VzIG5vdCBhdHRlbXB0IGluIGFueSB3YXkgdG8gb3B0aW1pemUgYWNjZXNz
ZXMgdG8NCj4+IG11bHRpLWFjdHVhdG9yIGRldmljZXMgKGUuZy4gYmxvY2sgSU8gc2NoZWR1bGVy
cyBvciBmaWxlc3lzdGVtcykuIFRoaXMNCj4+IGluaXRpYWwgc3VwcG9ydCBvbmx5IGV4cG9zZXMg
dGhlIGluZGVwZW5kZW50IGFjY2VzcyByYW5nZXMgaW5mb3JtYXRpb24NCj4+IHRvIHVzZXIgc3Bh
Y2UgdGhyb3VnaCBzeXNmcy4NCj4NCj5KZW5zLA0KPg0KPkFueSBjaGFuY2UgdG8gZ2V0IHRoaXMg
bWVyZ2VkIGZvciA1LjE2ID8NCj4NCg0KSmVucy0NCg0KSXQgd291bGQgYmUgZ3JlYXQgdG8gaGF2
ZSBEYW1pZW4ncyBwYXRjaGVzIG1lcmdlZCBpbiAtLSBpdCdzIGltcG9ydGFudCBmb3IgdGhlIG11
bHRpLWFjdHVhdG9yIHN1cHBvcnQgd2UndmUgYmVlbiBhZGRpbmcgdG8gQkZRIGFuZCB1bHRpbWF0
ZWx5IGZvciBvdGhlciBzY2hlZHVsZXJzIG9yIHVzZXItc3BhY2UgdG8gbWFuYWdlIHF1ZXVlIGJh
bGFuY2Ugb24gU0FUQSBkdWFsIGFjdHVhdG9yLiBUaGFua3MuDQoNCkJlc3QgcmVnYXJkcywNCi1U
aW0gV2Fsa2VyDQpTZWFnYXRlIFJlc2VhcmNoDQoNCg0KPg0KPj4NCj4+IENoYW5nZXMgZnJvbSB2
NzoNCj4+ICogUmVuYW1lZCBmdW5jdGlvbnMgdG8gc3BlbGwgb3V0ICJpbmRlcGVuZGVudF9hY2Nl
c3NfcmFuZ2UiIGluc3RlYWQgb2YNCj4+ICAgdXNpbmcgY29udHJhY3RlZCBuYW1lcyBzdWNoIGFz
IGlhcmFuZ2VzLiBTdHJ1Y3R1cmUgZmllbGRzIG5hbWVzIGFyZQ0KPj4gICBjaGFuZ2VkIHRvIGlh
X3JhbmdlcyBmcm9tIGlhcmFuZ2VzLg0KPj4gKiBBZGRlZCByZXZpZXdlZC1ieSB0YWdzIGluIHBh
dGNoIDQgYW5kIDUNCj4+DQo+PiBDaGFuZ2VzIGZyb20gdjY6DQo+PiAqIENoYW5nZWQgcGF0Y2gg
MSB0byBwcmV2ZW50IGEgZGV2aWNlIGZyb20gcmVnaXN0ZXJpbmcgb3ZlcmxhcHBpbmcNCj4+ICAg
aW5kZXBlbmRlbnQgYWNjZXNzIHJhbmdlcy4NCj4+DQo+PiBDaGFuZ2VzIGZyb20gdjU6DQo+PiAq
IENoYW5nZWQgdHlwZSBuYW1lcyBpbiBwYXRjaCAxOg0KPj4gICAtIHN0cnVjdCBibGtfY3Jhbmdl
IC0+IHN0dXJjdCBibGtfaW5kZXBlbmRlbnRfYWNjZXNzX3JhbmdlDQo+PiAgIC0gc3RydWN0IGJs
a19jcmFuZ2VzIC0+IHN0dXJjdCBibGtfaW5kZXBlbmRlbnRfYWNjZXNzX3Jhbmdlcw0KPj4gICBB
bGwgZnVuY3Rpb25zIGFuZCB2YXJpYWJsZXMgYXJlIHJlbmFtZWQgYWNjb3JkaW5nbHksIHVzaW5n
IHNob3J0ZXINCj4+ICAgbmFtZXMgcmVsYXRlZCB0byB0aGUgbmV3IHR5cGUgbmFtZXMsIGUuZy4N
Cj4+ICAgc3R1cmN0IGJsa19pbmRlcGVuZGVudF9hY2Nlc3NfcmFuZ2VzIC0+IGlhcmFuZ2VzIG9y
IGlhcnMuDQo+PiAqIFVwZGF0ZSB0aGUgY29tbWl0IG1lc3NhZ2Ugb2YgcGF0Y2ggMSB0byA0LiBQ
YXRjaCAxIGFuZCA0IHRpdGxlcyBhcmUNCj4+ICAgYWxzbyBjaGFuZ2VkLg0KPj4gKiBEcm9wcGVk
IHJldmlld2VkLXRhZ3Mgb24gbW9kaWZpZWQgcGF0Y2hlcy4gUGF0Y2ggMyBhbmQgNSBhcmUNCj4+
ICAgdW5tb2RpZmllZA0KPj4NCj4+IENoYW5nZXMgZnJvbSB2NDoNCj4+ICogRml4ZWQga2RvYyBj
b21tZW50IGZ1bmN0aW9uIG5hbWUgbWlzbWF0Y2ggZm9yIGRpc2tfcmVnaXN0ZXJfY3Jhbmdlcygp
DQo+PiAgIGluIHBhdGNoIDENCj4+DQo+PiBDaGFuZ2VzIGZyb20gdjM6DQo+PiAqIE1vZGlmaWVk
IHBhdGNoIDE6DQo+PiAgIC0gUHJlZml4IGZ1bmN0aW9ucyB0aGF0IHRha2UgYSBzdHJ1Y3QgZ2Vu
ZGlzayBhcyBhcmd1bWVudCB3aXRoDQo+PiAgICAgImRpc2tfIi4gTW9kaWZpZWQgcGF0Y2ggMiBh
Y2NvcmRpbmdseS4NCj4+ICAgLSBBZGRlZCBhIGZ1bmN0aW9uYWwgcmVsZWFzZSBvcGVyYXRpb24g
Zm9yIHN0cnVjdCBibGtfY3JhbmdlcyBrb2JqIHRvDQo+PiAgICAgZW5zdXJlIHRoYXQgdGhpcyBz
dHJ1Y3R1cmUgaXMgZnJlZWQgb25seSBhZnRlciBhbGwgcmVmZXJlbmNlcyB0byBpdA0KPj4gICAg
IGFyZSByZWxlYXNlZCwgaW5jbHVkaW5nIGtvYmplY3RfZGVsKCkgZXhlY3V0aW9uIGZvciBhbGwg
Y3JhbmdlIHN5c2ZzDQo+PiAgICAgZW50cmllcy4NCj4+ICogQWRkZWQgcGF0Y2ggNSB0byBzZXBh
cmF0ZSB0aGUgdHlwbyBmaXggZnJvbSB0aGUgY3JhbmdlIGRvY3VtZW50YXRpb24NCj4+ICAgYWRk
aXRpb24uDQo+PiAqIEFkZGVkIHJldmlld2VkLWJ5IHRhZ3MNCj4+DQo+PiBDaGFuZ2VzIGZyb20g
djI6DQo+PiAqIFVwZGF0ZSBwYXRjaCAxIHRvIGZpeCBhIGNvbXBpbGF0aW9uIHdhcm5pbmcgZm9y
IGEgcG90ZW50aWFsIE5VTEwNCj4+ICAgcG9pbnRlciBkZXJlZmVyZW5jZSBvZiB0aGUgY3IgYXJn
dW1lbnQgb2YgYmxrX3F1ZXVlX3NldF9jcmFuZ2VzKCkuDQo+PiAgIFdhcm5pbmcgcmVwb3J0ZWQg
YnkgdGhlIGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPikuDQo+Pg0KPj4gQ2hhbmdl
cyBmcm9tIHYxOg0KPj4gKiBNb3ZlZCBsaWJhdGEtc2NzaSBodW5rIGZyb20gcGF0Y2ggMSB0byBw
YXRjaCAzIHdoZXJlIGl0IGJlbG9uZ3MNCj4+ICogRml4ZWQgdW5pbnRpYWxpemVkIHZhcmlhYmxl
IGluIHBhdGNoIDINCj4+ICAgUmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50
ZWwuY29tPg0KPj4gICBSZXBvcnRlZC1ieTogRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBv
cmFjbGUuY29tDQo+PiAqIENoYW5nZWQgcGF0Y2ggMyBhZGRpbmcgc3RydWN0IGF0YV9jcHJfbG9n
IHRvIGNvbnRhaW4gYm90aCB0aGUgbnVtYmVyDQo+PiAgIG9mIGNvbmN1cnJlbnQgcmFuZ2VzIGFu
ZCB0aGUgYXJyYXkgb2YgY29uY3VycmVudCByYW5nZXMuDQo+PiAqIEFkZGVkIGEgbm90ZSBpbiB0
aGUgZG9jdW1lbnRhdGlvbiAocGF0Y2ggNCkgYWJvdXQgdGhlIHVuaXQgdXNlZCBmb3INCj4+ICAg
dGhlIGNvbmN1cnJlbnQgcmFuZ2VzIGF0dHJpYnV0ZXMuDQo+Pg0KPj4gRGFtaWVuIExlIE1vYWwg
KDUpOg0KPj4gICBibG9jazogQWRkIGluZGVwZW5kZW50IGFjY2VzcyByYW5nZXMgc3VwcG9ydA0K
Pj4gICBzY3NpOiBzZDogYWRkIGNvbmN1cnJlbnQgcG9zaXRpb25pbmcgcmFuZ2VzIHN1cHBvcnQN
Cj4+ICAgbGliYXRhOiBzdXBwb3J0IGNvbmN1cnJlbnQgcG9zaXRpb25pbmcgcmFuZ2VzIGxvZw0K
Pj4gICBkb2M6IGRvY3VtZW50IHN5c2ZzIHF1ZXVlL2luZGVwZW5kZW50X2FjY2Vzc19yYW5nZXMg
YXR0cmlidXRlcw0KPj4gICBkb2M6IEZpeCB0eXBvIGluIHJlcXVlc3QgcXVldWUgc3lzZnMgZG9j
dW1lbnRhdGlvbg0KPj4NCj4+ICBEb2N1bWVudGF0aW9uL2Jsb2NrL3F1ZXVlLXN5c2ZzLnJzdCB8
ICAzMyArKy0NCj4+ICBibG9jay9NYWtlZmlsZSAgICAgICAgICAgICAgICAgICAgICB8ICAgMiAr
LQ0KPj4gIGJsb2NrL2Jsay1pYS1yYW5nZXMuYyAgICAgICAgICAgICAgIHwgMzQ4ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4+ICBibG9jay9ibGstc3lzZnMuYyAgICAgICAgICAgICAg
ICAgICB8ICAyNiArKy0NCj4+ICBibG9jay9ibGsuaCAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAgNCArDQo+PiAgZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYyAgICAgICAgICAgfCAgNTcgKysr
Ky0NCj4+ICBkcml2ZXJzL2F0YS9saWJhdGEtc2NzaS5jICAgICAgICAgICB8ICA0OCArKystDQo+
PiAgZHJpdmVycy9zY3NpL3NkLmMgICAgICAgICAgICAgICAgICAgfCAgODEgKysrKysrKw0KPj4g
IGRyaXZlcnMvc2NzaS9zZC5oICAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4+ICBpbmNsdWRl
L2xpbnV4L2F0YS5oICAgICAgICAgICAgICAgICB8ICAgMSArDQo+PiAgaW5jbHVkZS9saW51eC9i
bGtkZXYuaCAgICAgICAgICAgICAgfCAgMzkgKysrKw0KPj4gIGluY2x1ZGUvbGludXgvbGliYXRh
LmggICAgICAgICAgICAgIHwgIDE1ICsrDQo+PiAgMTIgZmlsZXMgY2hhbmdlZCwgNjM0IGluc2Vy
dGlvbnMoKyksIDIxIGRlbGV0aW9ucygtKQ0KPj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBibG9jay9i
bGstaWEtcmFuZ2VzLmMNCj4+DQo+DQo+DQo+LS0NCj5EYW1pZW4gTGUgTW9hbA0KPldlc3Rlcm4g
RGlnaXRhbCBSZXNlYXJjaA0KPg0KDQo=
