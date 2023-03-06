Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F352AC6FA99
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 05:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCFFIT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 00:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCFFIS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 00:08:18 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2044.outbound.protection.outlook.com [40.107.102.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D2CCC0D;
        Sun,  5 Mar 2023 21:08:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpSfgUkhE2U5fJSI7SxVscnPpqypSgyAmia91jdE/J1DwZi69ybi+Be4pe1W1b9rx7yrfzyDcrcxPW7kO21Zk92PND+uZ4r19tBr05xeZkTDYp5jQ22lrzWKtZ9kTJNiD3wMBRuHZloHXrhzPyxuG3EBLt/3apJvDB6g75OxsXvvcJN4Mtv5eL8OaO4yeYQNG8K4IZBVTageWQzKfUy3jseThA4CxJX7Q1tYDE3dIp+kBNL16iIaUSHP8WOpV92L/tYccl8wku/qnGqzAk/8Kt0dRYz+s/djaHc8wY8hSyf+QAgs5mavLUylEVk3KK5gHTkbSUNXCiUNNX5U0/NXGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTTHQp/BxOp+FM54HtxUgDXGfCksfD18ttlewIB7Ifc=;
 b=oXlqjIy9DhPLDAIZn1tEJPJAKatv2Z49uasJ9Y6saMAJT8YWbo9Pjr8Y8w4yE9Xe9Rrwm9t/1jHgO6WjvTZ4WaJ1NiFM4vFoTi9sAe3ou9TSjbBXYHfHuQhWLbHQthcguaWJAaBTbYejD7ZgMSrQ3MBpxhg3h5X/cr7FBQn/qpsPgkHoInFCEVneKRi9py+i1irq9pVppOLY7+fjsP8zNg4fGqMWn3x4uyKXGclv2vyoJJlIsoeo/W+OHP9X7+tsZC90G/VyGW5TLGpS55JtOHcrGilDRaUbBLVYolYPOVSkaRGReNMdFbDIkMrFaJBXjcuXQ+oka8O9poloDIhg9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTTHQp/BxOp+FM54HtxUgDXGfCksfD18ttlewIB7Ifc=;
 b=oC3/o/hXl6YLTdOLe3mDQhPzsVmxpiZSNViqZ2gOQ/yHZC0dMKyQ5Fll2xZ9DPk/ETme03CtiquNXaH7iuoqjEE4i1Kf8n31Ak9WdVigqBM/p9ulg4w6WgzQj/me/fahnCxArAkIsced7Uv1bt8ehqqeylwmE8qb9WUxXu3B+y7sdBaBJPXJpbViVk90j3+lLhV9Y0qVOl9oN5+34VzVdw+LjRJEK4w+603KrWOc4H0O/fPV+r31zn4QEPHQHxelbP5DErPm+g64V7DnlKUaYAKlzJnwQdMXcC6ZiIU6w3njcXQF90+SRajnu7aAS3y8Mf3cDkItdAFl2rs7UmcJgA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH7PR12MB7453.namprd12.prod.outlook.com (2603:10b6:510:20a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Mon, 6 Mar
 2023 05:08:15 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.025; Mon, 6 Mar 2023
 05:08:14 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH v4 05/18] scsi: Add support for block PR read
 keys/reservation
Thread-Topic: [PATCH v4 05/18] scsi: Add support for block PR read
 keys/reservation
Thread-Index: AQHZSHgQzNEL10tdBEqbC7x0bFhc867tQmKA
Date:   Mon, 6 Mar 2023 05:08:14 +0000
Message-ID: <821298cf-a76e-be6e-c683-7bf34151ddec@nvidia.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-6-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-6-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH7PR12MB7453:EE_
x-ms-office365-filtering-correlation-id: b2aac136-b2ca-4bfc-9eba-08db1e00ca80
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jY/Nc+T/k7vjt2qIHl31CH+oCOGp8iKaR1g/U8NPLXOHpxD2PtfLmHmGgdyoiL18DXyrssLKpPsfub8vHlUyjxmDD0wtN6NFGd3EgzNVgRocEfte//AOlgej7QOoJPT3Tb63ytfgmjsIL9t2AosUtqpjaPjXcGaqqdMEEyjiWgqKRFVOWgWC5mnt4jQ+B8bDKql1KB1ax1+VMExlGL7niWlIAd/iiMgCYkTMEUoR4gUlx41/le9fhriIQ8jVBWNw3YUdRZYfKlt2jxmp/Fo9MgQqFryJq4MI6ovTor45HtfA1BCHuCTCRpGC2guac+NaSqFVl/gfbmaEMEINmUYQZs2SQCXb+9Yh9ZUGorNtOIUOwOf14/xpMCcPRxlGBbmTVHkAtBTfnCkWhtywoIjg89/bPHTu2K1olP+mwOLmxpDoTQ/2S25TjAJ/ZYlBOa7zyDIRUEVSvv+Id/VfAbJHyLSRewuk0WhhhYd809hzWWodS0TODndB1escd8AGwCarDHxAhzdK5m8wgxRiPf7Jm/ovjCpRDGwhlpEP1vJ4U1GwWT6i/Ep77sitKUMBCWeN2IZGL0tdFq2Nt9EcmlOHno9K3BQTwrpr4eRmSA2vJEG1QHdvf570sSOwVSjN/8REL27zvzuMQdH26wHYsDATcVxoE7U+7zyunQOkKxNPNbsbx7fZcziTDkdHW8IfyI6GNqiuU2c/Kmkx8dxX/ASCiC+XKR4YwPTGQZOYkiWFMJA+kqn48Ni1hqcIpJnMH0X68B3+R5YQB4dYxkMHDz7dkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(186003)(122000001)(38100700002)(91956017)(38070700005)(921005)(8936002)(64756008)(41300700001)(66556008)(8676002)(66946007)(2906002)(4744005)(5660300002)(76116006)(7416002)(71200400001)(478600001)(53546011)(2616005)(66476007)(6506007)(6512007)(6486002)(316002)(110136005)(36756003)(86362001)(31696002)(83380400001)(66446008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzVtYlcxL0FkTkZqZWYySVBZR3JQNTJGRjlNK1EwcVBySU03VDQ2RUoxU3E5?=
 =?utf-8?B?MWNyLy9DbGtPalNQcVBQR0ZpLzBVdmJxTCtvV0VjanU5MDgydGF4RENqOGRO?=
 =?utf-8?B?QUJBdUMwQVR1UnB6aHpSbUZNYXMza2RTd2tXdWNvMisyNnl4WTYzTzY2bnRQ?=
 =?utf-8?B?cmExaG5GOTlXNnkzYzlQRlViZStlTVZtNm9reS82QlVXQkpLdlpLSm5TSG1M?=
 =?utf-8?B?MC9XK2xUbkZSVHJLdDZnQ0xFQSthNFFqMUZCQzgyUm9SbzM2ODRBbExROFhM?=
 =?utf-8?B?Q0xkWG5VY2NqZWgwTFoyRzA4Qmd4VmhpclFWakpnSXRCOWw5U2pEeFhLRVE2?=
 =?utf-8?B?dVN0eTlJV3kxK0lIN3FUUDZvU1EvVmtFRGNEWU1tck5Hd2JnV2pMT1ZGZkg1?=
 =?utf-8?B?YS9PeXFEZWZ1eWVXMGh6NExPUDZBWHlodjkrYkhzYU9VNkkyUm03MTJJazFZ?=
 =?utf-8?B?U3FLK2ZIR3hCUmtXaXU3bEZNNWJzYTJGZk83RXREVHg5L3ZLczZpYkdPc0Nz?=
 =?utf-8?B?azZ3S1F0S2dTc3gxUER0clVkS2IzUTh1T25jUExLZ1B6WGI3Zm8reVNzWWtq?=
 =?utf-8?B?aDdhc1FZUnRNOWJia1JyVDl4V0syVkFhRjA5WFZKUU4xZzd2RWgvQmVhNlBT?=
 =?utf-8?B?aHN6SSs1QkVGRURjSmhoNUQxbDAzbVFOQ3FUeUl6bEtHd2dKUXRvOHNBWjFk?=
 =?utf-8?B?L0xFcCs4cWxsNGF4dEx1QS9pVitvdzE0eGw3RFdjbjA5cmVIRnlwa255OXBU?=
 =?utf-8?B?dG1NTWJNMDJMM2c0Y1ZTQm50cVNQY3hRendNRE03T0hRY2dNalZtYndGTENn?=
 =?utf-8?B?YzZqaERzQTh0cjg0SFFIZ1lxcTFwOE9iZ0tFWGFpeDZrK3hTSmU3Z3J1cWox?=
 =?utf-8?B?TGVIcWdjS0J5WTArN25heUlyaU5kQnNjL0dmUCtaVFF3VjErcEVyanR1VmJo?=
 =?utf-8?B?ZW1uVms4NkhucjFEKzA5RmZjaEJUdHVhSEY4aEN2bDBjS013S01OdVBUYWdp?=
 =?utf-8?B?dDErNWhrdmc1bUl5TS9UcGhmWnc5Q2tZanp5OGQyMVJwb2VyRDlXSWZLbzBD?=
 =?utf-8?B?cVZ3SWtHMGtqUjQrVktUc1Z2M2VhdTZjOUN5cklSNEZzOTNYZVNZMXhscy9o?=
 =?utf-8?B?T2hrSWl1NkN3S3lUdVpkaDJKSGxxYkdHUUR3ZVFvMFphclZuVXVydVRyWWlk?=
 =?utf-8?B?enVOMElZRkFieUYyR0N3M0tmQlVoNFJTWWVzakxxc05keGxOVjR6bTVYWGJ4?=
 =?utf-8?B?dzlpT2EvN0RKd0dGOEJ0RXhkV1FQRFpxWS9HaGhUWjNvQkt2Q3FrbFViYlZk?=
 =?utf-8?B?d2dySjRVT3VoTTFYVVpaa3hKanJQaFRlOFNPN2dTbjAwdkJTdzVlSlpVSFZ1?=
 =?utf-8?B?WmJZNmdrYk9rNHRyYTRvVmo1d3NSbTBJRnpFK2REOTduL29UR1ppMUdIT2sy?=
 =?utf-8?B?d3kvcTRMczJTTW5HL1BJelNnalFxWFhTbnREOUpaR1B4OVhMUzlpdUk2aDZI?=
 =?utf-8?B?Q3Z1Q1FpTUZONVZFQzFwVmNGTHl4MWtISGh1Z2xBcUF3elJTbDNiSUtuV2ox?=
 =?utf-8?B?bExLZWE0dVZHS2Z3SVVkZTlmb0tHR3h2VFlZTWs0ejBJTmFzUytuVHNjOGF1?=
 =?utf-8?B?ME1PcDdzcGN6YkMrSE9hbUorbmwrRWt0T1p2cWcxOGNORCs1RTVubTI3ZjZt?=
 =?utf-8?B?elYwcWo0TW13Unh6N3B4a3hjT0QrU0orMUwxcXJrYk1WUkFuamdmMCtXb3R5?=
 =?utf-8?B?RHU3b0hyU1REeVF0a1FYcmdmaFNkdjhTNTRFWVZkdmg5dHllZUdFN2taVTJl?=
 =?utf-8?B?OFZlZGtDbnlSK3VmR2JGd0g0UjNXeXBGV01tUHozM0FuYWpBV2ppMlhoR3Ar?=
 =?utf-8?B?Wm5vdDlyb1RSMEhNQjZRcFJFTXdDTlNDTFY2K1UvbWtOTDgvZ3hNbzkyV3Nl?=
 =?utf-8?B?MHRsbnkxRFArWTBEN3ljMjdubHhqaWEzTjJvZkx6aElPNG1mMm5Fait4UnFS?=
 =?utf-8?B?UlZrY1NrK3BlelRReFpUdlRnMHhCMFJndkVyeU83eUUySHRsdC9UOFAzUnZk?=
 =?utf-8?B?aytFQ1BUZk9CNXkrUVg3TWdPbE5aVmJrWEJHUmFCYWNSaFp5Qkkzak9CRk5X?=
 =?utf-8?B?V0ppWUxHYVF1dUl2NktadDR3Y2lGN3hCajZKbzRMZE01NkIyRmIrdzhJRFB0?=
 =?utf-8?Q?tFlicD7jCMhh0Gi7Rcq1IB4movvtz0sr1aKo3gInrzmH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03C2209FE2D1514D8822CEACCA28F459@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2aac136-b2ca-4bfc-9eba-08db1e00ca80
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 05:08:14.9161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q9/tnemrRCfiTMhTujpQDPM88JKWDyqdXgg7M7jwCWxZ0ozrT9jDzA53sUrkfP7bblZ9IfcylUhhS0Qf2pGYFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7453
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMi8yNC8yMDIzIDk6NDQgQU0sIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFRoaXMgYWRkcyBz
dXBwb3J0IGluIHNkLmMgZm9yIHRoZSBibG9jayBQUiByZWFkIGtleXMgYW5kIHJlYWQgcmVzZXJ2
YXRpb24NCj4gY2FsbG91dHMsIHNvIHVwcGVyIGxheWVycyBsaWtlIExJTyBjYW4gZ2V0IHRoZSBQ
UiBpbmZvIHRoYXQncyBiZWVuIHNldHVwDQo+IHVzaW5nIHRoZSBleGlzdGluZyBwciBjYWxsb3V0
cyBhbmQgcmV0dXJuIGl0IHRvIGluaXRpYXRvcnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNaWtl
IENocmlzdGllIDxtaWNoYWVsLmNocmlzdGllQG9yYWNsZS5jb20+DQo+IC0tLQ0KDQpMb29rcyBn
b29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4N
Cg0KLWNrDQoNCg==
