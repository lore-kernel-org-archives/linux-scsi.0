Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01229C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Feb 2023 07:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjBFHPf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Feb 2023 02:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjBFHPZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2023 02:15:25 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FEB1CAC9;
        Sun,  5 Feb 2023 23:14:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0zZsa/X7Vzgl/cCJ/tVd9rwU9Btwj9iFv6yXawo/V1OQkEo9VZHSZpCYTq1sta9fc/AnNwlkWBLmLfOTJG5dBoohTeXMwEo9owp3XhQOsvhEqxcTplX9Zxy2g5u/1Q72lpbtBjPLaA86u3RTWhdB6UPsctcumB5cT4H1zioRrrFYtGNv2F4IRz2atONlR5rN62Qs8Xco2rIJ1wpToPojSkS/Op45SDsLiLqhclGMfRqOoGxcPDbVyKr/03RpAFAxp7SElpQl0vqgTZqUlNV9wSX4uhIqVTY7qG+lhEWDTp7G/2ZKPpPo4WhLBroEcUGKtANULWOEfhbGkpg3+lrkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnMZCCNQzVdGtShBUePE3hCoqtuwW9nnlXhwN4RVHxc=;
 b=X+4eqf0GC8+89QC7lqFyCl5z6W8qjlCIW/OyrOhEudkStDiclsMUQ1WOg+vMdAkna9PUrrIpanJhBFUrA7FaFlEBExZ7CJTqUfgxel5zZVIsoO0SVPddmggGP33QmfNEPsy8KinBNsShhBwoXq9KCvNtwKH+KO5EelHbXpketmXEbqtF/4SQ2upe2doOrF4GgLyHia7iUmgPil61B9ZdczPbpbhgU5Asvm6joBSNeEtN24Dvvkq2+7jBOAnrBmBD0wpGakXm/DM+T5t+yL6te8hsWzzrM+LSuRq8PxYu51ppS5Xvh/2GCx9ApeSURMz7N4WbVp4uFu+4Kjo1rBQq7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnMZCCNQzVdGtShBUePE3hCoqtuwW9nnlXhwN4RVHxc=;
 b=aTW263WJQBfWS37Yqw3STnav4bi//NjYMxuLHIo67W5yzeYlHGDFq+Wprc49jBAOnSfoYhfSHSTXEWwnWHg1EcTDxo0KkoxzpFXGtQygkLbjR3QI14NWF4eevAyPqZs/kC4Gz+JZdEIUmUTI4AUDHrgRfl54al1nuIMtOWUQe1gzUFu4uZV7CQG4si5TmpL6mFbudOGnWekv0JmWBgJQ0A4T/+3ez2YHsv0YP+ik6Su8pv6Fa0Z8CauTL9+JrawdS4slj2RrTl3Ik2XXdRiMir9F3KgNLK09GLdbezS4CaeoK69BvyS3ozQUloC1vArxrVGvm2JGoFkdBUSobPnmfA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH0PR12MB8578.namprd12.prod.outlook.com (2603:10b6:610:18e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 07:14:46 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 07:14:46 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Hannes Reinecke <hare@suse.com>
CC:     Christoph Hellwig <hch@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: blktests failures with v6.1
Thread-Topic: blktests failures with v6.1
Thread-Index: AQHZFoocnkF/69AeD02U/IcKNzVbOK57EfiAgEa2VIA=
Date:   Mon, 6 Feb 2023 07:14:46 +0000
Message-ID: <aaf09ea1-9cf0-0620-2c52-7298bb3409fe@nvidia.com>
References: <20221223045041.dl6ivxgo25eiwy33@shindev>
 <Y6VXjztUUz7GFmAW@infradead.org>
In-Reply-To: <Y6VXjztUUz7GFmAW@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|CH0PR12MB8578:EE_
x-ms-office365-filtering-correlation-id: 078b24db-1382-494f-ba6b-08db0811d3ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /w41OFk+tu73ysFnQyqyW0jGqQ95VHM4g0yEioNrOFIRbYaFGl1cznv3LZbb4lHjvBIE7zFkmyGZpPPUBsO3lptQXQ3g5ZYt7iOZ3u21ma9SX9APx28PE667mcpxC0oRwRma2HEjvcC05UMKArviq7Y0mb89r2Qm54xONlgl5tcrAqAcZD63BacetrqPLpFWVzJezDq4gAZCEovrlomPGZfbcsmkBwbzjVrUajqAwOBf2GMYDfLXJD1VIoPM5EXUK1m6gCWJfZYzkIOGEdYNCdX5MZGqGaloUwTUm1FNuhracLdnkQMG94dN04BbphHPueniEdTpR90kB8OOP6lfB6vvDmlBld2XmrqaDLsvGkcgmbkwIDOXhRB6QfaK+NB5FR9sjP5KDaJpnxCxPTeHMGzSYFAzQPNjb/BoAhR/W40kvvk/rbLSq8yqRsD8Q+5Itqum+T4nPpvwGqo+hUWxL33MQHKi5WkiG8nG96uv1/issKS2LMIkSQnan/4UbWOmCpd9HeM89or2AgYoJHYqHHfSKKnMLPUblwzQdHntxCx5j++PqrmCdZ01GmCUSRKRIuUYbhC+dDQGvipKByT6dTUfwOiPCNXx0nniGddJ9nphLvcrf43oHnCaXlYSB0kwhXta7hxiP6HkW6xiOKosLeBRRakqhD3eGkPGi/bH08g6Yfsu920MoEruLTG2q7hsKJUe9l19mUDtsKofAP42olidT88E788Xx4f/LO2Kc/YFp32L8h2mXngImZfO0MoC6Za7eY3po2+EQBHqI97NrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199018)(6506007)(2906002)(36756003)(54906003)(83380400001)(2616005)(38100700002)(71200400001)(31696002)(316002)(86362001)(38070700005)(122000001)(6486002)(478600001)(26005)(8936002)(6916009)(8676002)(4326008)(6512007)(76116006)(5660300002)(186003)(91956017)(66556008)(66946007)(64756008)(66446008)(66476007)(31686004)(4744005)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFQzSGhwZ3diU3dzUWFiUGVlVjJqMitTL3FmQzRvckw0TjN0S3I1T1lidDl6?=
 =?utf-8?B?M3VzT3duaFlZQ1VaSkpReGVjQUN1M2Y1VHdnUlFnMExYLzdzWkNnNTByYzlx?=
 =?utf-8?B?ZFQ2ZHpLSjQ5ajdVTnovS0FuMm9jSWdEclJFdFkrZjJUVHUzRnN2ZmFqbUVa?=
 =?utf-8?B?NUNoZVlVTkZPRUtBQ1hIeG5VOHo5RkU1M21JV3p5QjVmcyt3SENCUDk1RURP?=
 =?utf-8?B?dlBuYmNZMzkyQ3cvMU9TNnJHUDhGWERUWDhDT3FIWmd2UlR3VWYzRE5XRWJk?=
 =?utf-8?B?TW1ST0k1enFJcFJsRWh5ZDJJWGxQejhFdkk5dnY1MnZzQVdsQ0VqWDE4WkhJ?=
 =?utf-8?B?RWJRbFhYMWpZNzRuRllVYXd2cmRwQ2FLWmRRUlpxTHNublVCMzA3NldGODhl?=
 =?utf-8?B?LzlMRTdUT2lKZ1pUV2JVMUo5ZXF6OURFTHl3UTR5V3lvOGJ2eXVacVYyemFk?=
 =?utf-8?B?aE16eERJT1pwQUdvcEJhZU95ZmgzaG1GSk1YT3hqakI2UGpxOWxBeFhrWVBV?=
 =?utf-8?B?aU80UG9CTFdRd2lHVXA0Z1A3WXVKSlE5SVpxT3ErenAwaVR2MEtDUnpGeGUy?=
 =?utf-8?B?bGFCSE9oLzcyS2UvcDdKcW1HNEV5TlhYSnR2RkkvdFNsUkFEeFJaeUh6UG9M?=
 =?utf-8?B?cmtrUG8xNzlWMzk3bFlvM3pHTDZhQmpkL1duWmhxN0FQNmV4MWEvMzFMc3Zv?=
 =?utf-8?B?eGhGc3UvMXhRVHFwYmRCbkp4OTJnZGVoWWJCVzBQVVd2b1pqN1UvOUptaXZR?=
 =?utf-8?B?SnRtMUN6MUxRaDB2VDRBSzlaRjJRa080K3dEM09hZWd5RmRNVjFGdEV4OGh5?=
 =?utf-8?B?eXlQR3pXSTdKV1dXZXNBREZ0c3dqRWRIa2M3Q0JBOGxOS090TFlOMUo1Q3lJ?=
 =?utf-8?B?LzNpNWFVVGc1VkFqQkNLK0paSEd2SkV6WEpKZ2xHTllkcXZnb0grT0l5M1Fh?=
 =?utf-8?B?M1VUbG5pNTRRZnR3U0poYlVuS3hkOXZlblp2TnNFVjYxdFVaRDd5Nk80b2NR?=
 =?utf-8?B?VDVvN2VtTzV0aDVkYlk3bXNxZXdkN0RDRXNJT2pnQ1h3clIxZVVvMThlTXc1?=
 =?utf-8?B?MkV1VVBIeUlPTkw2bHd1anNhL09XNjNiWmVIS1pnWjF6WXdZbXdCY01KTFIw?=
 =?utf-8?B?ZlRtZy9oNzZTakxCdEQ0SXgyTEl1U1hWUVRZZ24wdExZMWV3SC9vdkEzOFF3?=
 =?utf-8?B?dkE2MWQ0cHRSMkltMlR5MEhyK05ucm1ZMzJxOFI4SURiQ3ZrSkpHU1BtQmxH?=
 =?utf-8?B?SS9QWVRyblZVRWxjL2hZenVUdG8xRkJTWlU5WlFqc0xOeGFUM1d2bGlJcEVS?=
 =?utf-8?B?YkZSb0FKWnlYck9GS3ordytQY0lBNzdQV2xwbUh0N0tVS3psdkhQYm5oZktv?=
 =?utf-8?B?dGpBNUVDQVJaelB2bnFIWGRST1p5Nkg4RVJWbExQdUkvUDhzbDg2M0NBL1lR?=
 =?utf-8?B?djFUTTRleW8vMmF1ZXVrMXdka2ZzbnJ5c1FrU2tma1R0MXUyb0pkZTdaejJt?=
 =?utf-8?B?OWRQRHlDYlR0N0w1djMwVWo2UXlHbUlXVGpEdytFbGI4UXRjbzVlSUtMMEVw?=
 =?utf-8?B?TzNpT1Y5OHpOOUtQVUs4V1FLSFFneW5lWXNVaDQ0b2FRM3NVSWFnV2E3bWFq?=
 =?utf-8?B?am5WWWUzVmJSR2t3VjRSOTVHck9CeHFsNmFPdDJJaUQzTG8wUlZ5QUlKeHVK?=
 =?utf-8?B?TDdKcUdYSkVrSjNVTi9vUThGMDVKbmJiOGJYSHNlZEdVODNrVUlPeWtuQ2tB?=
 =?utf-8?B?SUJqTDBZU1hibU1Xa0poamNpTjQ0RE83aXh2VDhVcm84bXJxdEJuc3pxbVhE?=
 =?utf-8?B?Y2JtUzJrblJkZTZuSzhRdkZpWW1uNk8wc2RkZWd0bEtpRldEbElUSDdKSGVp?=
 =?utf-8?B?dE1FV2tYaW5oUnJ3QW9OL1VOalBoN2J4MW16QVF1Y3NHRmNSYmlJZjdxMlVW?=
 =?utf-8?B?UmZRU3h4eHc5UDJDbmF6WEdmNGxna0RaTFlSVWlGbzFPalJJYlpQZFJnK2xT?=
 =?utf-8?B?MUZ3MWdlanZZYzNzbXJ1NDh4anFjaUJWUUE5RVB1RURzeDdKSTVuby9XSTc3?=
 =?utf-8?B?V3pFb3I4QWxZMFdDUlBtZ01uQXkwaFpBVzd6YXEwbysvc3hTYzlqdFh5cmxF?=
 =?utf-8?Q?bBi+rZ67FdBrtWzMqKBQ1q9xs?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97B117D83E505E42830997C57FFD457E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 078b24db-1382-494f-ba6b-08db0811d3ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 07:14:46.1457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jE0KvHMqrYpnq2Ns3tgKuoV2wrMSlZHHzXDhjbKFZle8UM4a0AKQNqZ+MaFVChhLYc4y7/+ygETPzVNm+o1FjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8578
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGFubmVzLA0KDQo+PiAjMzogbnZtZS8wMDINCj4+ICM0OiBudm1lLzAxNg0KPj4gIzU6IG52bWUv
MDE3DQo+Pg0KPj4gICAgIFRoZSB0ZXN0IGNhc2VzIGZhaWwgd2l0aCBzaW1pbGFyIG1lc3NhZ2Vz
IGJlbG93LiBSZXBvcnRlZCBpbiBKdW5lIFszXS4NCj4+ICAgICBGaXhlcyBpbiB0aGUgdGVzdCBj
YXNlcyBhcmUgZXhwZWN0ZWQuDQo+IA0KPiBJIHRoaW5rIHRoaXMgaXMgcmVsYXRlZCB0byB0aGUg
Y3VycmVudCBOUU4gdGhhdCBIYW5uZXMgYWRkZWQuDQo+IEhhbm5lcywgY2FuIHlvdSBsb29rIGlu
dG8gdGhpcz8NCj4gDQoNClRoZXNlIHRlc3RjYXNlcyBhcmUgc3RpbGwgZmFpbGluZyBvbiBsYXRl
c3QgbnZtZS02LjMgSEVBRDotDQoNCmNvbW1pdCBiYWZmNjQ5MTQ0OGI0ODdlOTIwZmFhYTExN2U0
MzI5ODljYmFmYTg5IChIRUFEIC0+IG52bWUtNi4zLCANCm9yaWdpbi9udm1lLTYuMykNCkF1dGhv
cjogS2VpdGggQnVzY2ggPGtidXNjaEBrZXJuZWwub3JnPg0KRGF0ZTogICBGcmkgSmFuIDI3IDA4
OjU2OjIwIDIwMjMgLTA4MDANCg0KICAgICBudm1lOiBtYXNrIENTRSBlZmZlY3RzIGZvciBzZWN1
cml0eSByZWNlaXZlDQoNCmNhbiB5b3UgcGxlYXNlIGxvb2sgaW50byB0aGVzZSA/DQoNCi1jaw0K
DQo=
