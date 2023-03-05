Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460A1C6FA99
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Mar 2023 21:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjCEVaJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Mar 2023 16:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCEVaH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Mar 2023 16:30:07 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A94315CB7;
        Sun,  5 Mar 2023 13:30:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eTbEEvU5TTRlEVF6+xqlWJDwZfxgebJu7mAV8GaXQWfmzIrR4sdwp1FEFK/dUYraJmTmZDTexe8h5NiJA4s84WkWD8Q/11LLItMNqEFG3x7qdq1jd6rIUxvkzJMMPj2cwZq0ykV8ML75MU6kSF328PbOrI2UGBx96zmqrTJaUgx1vWPRPcvh6uKLUp+XN3A2bVoOd3wnD4+7YJWvT7+bdJwqHjAAXz59uSxuz+RYjgtE6s9hK5sCH5fCrB6pqjAl2a+9Oz6jR4VHKb4RPqWQCCHNS9j7vz9DM4L34tQ0kZDzPQ5CGa0NnT35aHL+6cTcY7k1FNWCQSBjAGx/uDWudg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHvsaKYXOmvA2EkYW6wXjNm/3U5zkATWy66EZenpnkw=;
 b=g3dkQxPL2nPM1hrT+5IYgBT68Fv47ZBJekjQQ4DV3na+bHqDbJREsrx3oePg6ExUGizkUjhjZuVHEo+Ru/qgpnLtNsaKBNO+piusayMjGD1RZY/OptPe1NAki0O3ddygBjuYwP9ed9HQB0SjsYtUDjL3DXRyomnO3eD/dceIKttmrig0ETSX5RMrdl8FPjZIT7jEs4jcw/1zRT+gZzmzUNC9epmsCK4Grt52bnAKCtNBuh6x/A2WsJGL5FjF/8eGei3tIghEwS72nSP/WrxJIHHtVg5dXuhpAb+2chTCb6O3zILeDSoBw2tSSDTvDCGiqrTQTxJMV6ZcdrST7ZHSpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHvsaKYXOmvA2EkYW6wXjNm/3U5zkATWy66EZenpnkw=;
 b=SqfhXDUjebPrpGyBGbUVkBbcGJ6iy00B0j0iMVRwb1F+pjClnTjEcn/VnZAiesN2XpybAbb8Xgdp9RYUBmm93r8L7UOrebZHYQrsQkmg3MC5MNZKn5xfzsZYIKA/mhRxWa0meb6xDR+cQxj4zW0uEpZDDVLGtX/liWWOv6ZYV5o6b4INcIckmT4P+OWEJmgoESjgWWthHdF3H6PwHgMqDI/LH2IFzeKTMYIh41lq3WlXSY5QIVBTWBsIWs51tScR3IqmDxpIjzxknb/KM0EowU7Aq4Di3/XN1G1lskLotOX2B5LM3HhH6F27bLH8lTt5Pq22oTK1AvI0auobpBZGOw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7864.namprd12.prod.outlook.com (2603:10b6:510:26c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sun, 5 Mar
 2023 21:30:04 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.025; Sun, 5 Mar 2023
 21:30:04 +0000
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
Subject: Re: [PATCH v4 12/18] nvme: Add a nvme_pr_type enum
Thread-Topic: [PATCH v4 12/18] nvme: Add a nvme_pr_type enum
Thread-Index: AQHZSHgdE5qrhBqDiEOYJ4pU70wqXq7swl4A
Date:   Sun, 5 Mar 2023 21:30:04 +0000
Message-ID: <763d2af9-55b2-24bb-9b92-2e8e5616e3df@nvidia.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-13-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-13-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7864:EE_
x-ms-office365-filtering-correlation-id: 0e4d015f-75c1-46bf-b07f-08db1dc0c8c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MsBRWGuN5DLODOgDtZiLA8pYpLT6vvKFPIFhZ3UxQZ4FCsodXi4tZOPzOk3DPMsAGMMyNN7k13dBZzRPMACbUsX+/l1gw1rAk+3Jk0c/UV8LOOLwiF8TOgd+pSi3L8TSFGdTqLrnBgbwaxwb1dufN0+fNPEKiEJhlLncdn8OO1XB+3BSHfUvS6mJJEUaKSPfvof8FS9IgVxvgLVYjXRQ3bnsgdzj5/M/Z4wjlD5Ukifyea5PT5xTJgbK+9LMeeicoctQA4bY4MIeKxPGEcCqxBQPF//MxFf0Lb2XLk+MaBXmWFencvokvE2S+wxPLJ/aH4VNZ2zoaWt/ctNV32l6woHCVqx/C7FRwvAYdcAo6k3+KRFJ54bCuh4LKlaDxLSAyEyJQ+evFJC3gEclgiq42GlHaXmENGoKx8hXmsMuKd4VvX6KPxLDy8gCFzBB3zT40Ms2kbAW/7SI2rBfrm64iR0ihx9ziUKdftntz6YsFYUmUSRn5S55V1EzeRaEVaYrwTO43YQ3WrWHyj9ejiGHLVw8M3qHJUcrJy+whZwsUJw7bkcZ01eKFP5jCnH0tv1tx0ABMbiA+VOhTZDH2m8TZK7kMIIMnCPSVtHnaG2cDbq+owl2m2k2VOm7OlbnxfRedSszh0iyPmNs/wZqLCZ/7T5wDkUWa0c2eGEozoa1/5N9J32pu7epsAdMj/QsLLn87HdpU/cWhJFlFNBj6fI8Y+6j5zdCIjmSDHOCk4ZT14VHEYjAlKkWKullAzXNGOKS2UX3/Av0W+KubR1SoNSBQKwVbUvWNEfe7M3b/f6KRN4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199018)(186003)(71200400001)(6486002)(38100700002)(478600001)(91956017)(66946007)(110136005)(83380400001)(64756008)(76116006)(66476007)(66556008)(66446008)(8676002)(53546011)(2616005)(31686004)(316002)(6512007)(6506007)(41300700001)(8936002)(7416002)(5660300002)(4744005)(122000001)(2906002)(921005)(31696002)(86362001)(38070700005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blZENVlwZVlRT0UzNkw1aDRmUDVJOUtwWnJEcllTWWMzcGlaSFRvUy96QkZO?=
 =?utf-8?B?YUdxQURoN2NESkJVTEJOK1FXTk5PNlpMZm5MUEJrUTQ0Y0xlR0NOR0ROWHlJ?=
 =?utf-8?B?L2o4c1g2OElneUs3cVhCcmJQcXF5TThnZVZ4ZGZTanRORC9GMGRxRlArd0lP?=
 =?utf-8?B?bllBN0drTWlmMU9OdDVLTFhOSzl4eE9oZ2NpVE1kWDNxUmlWejQ2b3g0bW5h?=
 =?utf-8?B?TkxsQVN2R0Vsa1B4YmJvYmN5TFhhOTg1bzY4dmp3allFQTdTTW85RS9oMXBZ?=
 =?utf-8?B?dU5EcDRsSEQrckFLTWhVaExhTG1VQWJpbklEanQ5TEVaYmFmZTR6aVRoSlJH?=
 =?utf-8?B?MWhkckpuY2J2eHAzSWNqUkkwK0xnemNsNEZEVXRsRmhLcWJoZ2x5Z3BGbzBH?=
 =?utf-8?B?dytMaFJ1M0Y2NC9VQXlFWDhYQ1VqZXhpSUNHeHI5SDJHS0ZtWDBmNUpQeE5x?=
 =?utf-8?B?R011ZDd0dHNIa05TdE9idUtDWkpwcjhUbGdmc3JCK3l4a0tVV2FmZ3BpV2FW?=
 =?utf-8?B?V09lZ0duVWZOYmpyd1JKMERrck5NamtKT0VzSzBDQmxsbHpFSjNpbDFoUGdy?=
 =?utf-8?B?dlBCM3YyRFpTVjBHZkVUNVRjUEc5NkFRTXV1ZXNiMjV2M1JCZ1ZRRUVUcDFM?=
 =?utf-8?B?azJKaWxmYWt5bXRteEhVSHBFWFhhelk1TWE2WG00enN1aTFWeTAvV1dybDVN?=
 =?utf-8?B?TGFSdlBSWlpCZENFM3cxOEpBdFR4Z2kzUzNMOVpBVXNGNEVjVWRsMm9uNTZj?=
 =?utf-8?B?SWpkQ0JyWGxjdm9hbEdjUEVYeGhwQkJuVTQ2R1RickZWdHhwT0ZJaHNINEpn?=
 =?utf-8?B?T2hBZStnWmE1ckhGYjFOVlVTdmRmcGF6ZWdmYWlxQ0xrb1dzaUVwSHFKbnh1?=
 =?utf-8?B?eVh2Q2ZEZUFINnBSYmF6ZjJyanpsZ1lwQTdDYlN1eWJjQzBuL3p3VE9EVUdt?=
 =?utf-8?B?Tm5lVmNjekltajRMVDA2NVBZWlRnVXQ0NnZJbWxFRll3UlVHdFN6R3loeGs1?=
 =?utf-8?B?UG5vUmtFUmMwYjM4S1dOV2xGN0twVHFzWUJOb3lTWE1XVWJCVFVaL01HNUMx?=
 =?utf-8?B?MHhlT1IxZzI2WFI1Um1TUnpjRStONzVFalNkMkQ2OVNvNFlpYUhZTXRFK2pC?=
 =?utf-8?B?Y1F0N2tQaUQyV05obzJBNVlueTVkRUg2dVJZZmFwd0M4b3BQVFFmbXRKZStz?=
 =?utf-8?B?YkR2Z29IUkFHY2I2R1JjNnpmc3IrOTZXNlVvb0lQNkJlUVc0Q1czZHNaSExt?=
 =?utf-8?B?NHF0YlNJNUZmZVo3c0JFWStqd0hJWTA4Rk16cC8xYWt1R0Y1d2tsM3pVbStE?=
 =?utf-8?B?dDh1Wmkrb3R6NnNKdklscEZ4TzVtRG83RHMxd05qYSt3WWJwTUJOMCtBNXJn?=
 =?utf-8?B?eVdTZzR5SmxnMGFGR0dIMkh0M3ZDM2RmZUZDSzV4aDV0RnB0aXBNVnRJdTcz?=
 =?utf-8?B?SE1KYUs3UzNReG02Vk1uU3NpY3FYamhncEg4cDZBQk5VQXRybXUyRU1RUmVD?=
 =?utf-8?B?UVByNFNmOE05RldEWTUvdXVOcGROakZIc3p4NC9vSFhlZXFqcmpMNEZoY1VY?=
 =?utf-8?B?ek15RlA2WXNBTnNYNXE5WVhGYmMxSk1yNzNZRmx0NWRjMUt0V3BCRktYYk1G?=
 =?utf-8?B?dGxRU1dmeVRJNzJUV29EQ0FWMXJlQ1hsV2Y2OWZ2SXkvQ0tjejJGaUJaMEwx?=
 =?utf-8?B?SC9zVllZdmo3MFZ1aStvR1pyUGdLZTNTeXQwVTQxbi9lakl0M3gwUlM3N1JH?=
 =?utf-8?B?YzhpNXpVczZDK1VpVzh1L0t4cFY0Y0RFS0N5OTNPa3RoNnlsUitxUndXbWox?=
 =?utf-8?B?emVtTmpZeDdOTTYvTDRNKzFvbGpaUk9wZk52T01IdndmMk92bWUxcWUrZVNs?=
 =?utf-8?B?MXBIUzFmS2ZubUVDbDJKTnRWQ2ttcmxHcEl0aURWR3FGSy91YTdTQmtsYWdC?=
 =?utf-8?B?UXRmWGY1MndKeGVrSXNLV3Y2Z1lPUlFiTEI4c3FkaEErTkwvOTlOMHlZNWFX?=
 =?utf-8?B?MThjV3hxTDNRREsrVjdCMnhrbVZOdVhsRXlZZFhDT1hSVWVXSmU4YTJkWFl4?=
 =?utf-8?B?d3AvMHhSdC9NbTlmUG9DdmdSMEV2YkIxaWZBV1lHbExjVjMzNjY5a1NyL0h1?=
 =?utf-8?B?S2tmZGVuTzdPVGFZQ1BEV0dwZVkvZXlLNGJsZjFtTzFOZG9DVWtDdjk4VDVL?=
 =?utf-8?Q?AY3UzfqwhQaJ0jizr8SN7X5sCgfXwv4whkDIWk5EJcBU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB1121A40C0E85439FEC8276C18DACBC@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4d015f-75c1-46bf-b07f-08db1dc0c8c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2023 21:30:04.2332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qEIH6JkavxNeJG0F4fWYFEcE7sONVFbSAUeTdmt8YYeHIF/yxwKzniKkRhQJG4VocWAPfzWVsiZgONLI/1OETA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7864
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMi8yNC8yMDIzIDk6NDQgQU0sIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFRoZSBuZXh0IHBh
dGNoIGFkZHMgc3VwcG9ydCB0byByZXBvcnQgdGhlIHJlc2VydmF0aW9uIHR5cGUsIHNvIHdlIG5l
ZWQgdG8NCj4gYmUgYWJsZSB0byBjb252ZXJ0IGZyb20gdGhlIE5WTWUgUFIgdmFsdWUgd2UgZ2V0
IGZyb20gdGhlIGRldmljZSB0byB0aGUNCj4gbGludXggYmxvY2sgbGF5ZXIgUFIgdmFsdWUgdGhh
dCB3aWxsIGJlIHJldHVybmVkIHRvIGNhbGxlcnMuIFRvIHByZXBhcmUNCj4gZm9yIHRoYXQsIHRo
aXMgcGF0Y2ggYWRkcyBhIG52bWVfcHJfdHlwZSBlbnVtIGFuZCByZW5hbWVzIHRoZSBudm1lX3By
X3R5cGUNCj4gZnVuY3Rpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNaWtlIENocmlzdGllIDxt
aWNoYWVsLmNocmlzdGllQG9yYWNsZS5jb20+DQo+IC0tLQ0KPiANCj4gTm90ZSBmb3IgQ2hhaXRh
bnlhLCBLZWl0aCBhbmQgQmFydC4gRm9yIHRoZXNlIHBhdGNoZXMgd2hlcmUgd2UgY29udmVydA0K
PiBiZXR3ZWVuIGJsb2NrIGFuZCBudm1lIHByIHZhbHVlcywgaXQgc2VlbWVkIGxpa2UgQ2hhaXRh
bnlhIGFuZCBLZWl0aA0KPiBkaWRuJ3QgaGF2ZSBhIHN0cm9uZyBwcmVmZXJlbmNlLiBCYXJ0IGhh
ZCB0aGUgc3VnZ2VzdGlvbiB0byBrZWVwIHRoZQ0KPiBzd2l0Y2ggYW5kIGRyb3AgdGhlIGRlZmF1
bHQgc28gdGhlIGNvbXBpbGVyIGNhbiB3YXJuIHVzIGlmIG5ldyB0eXBlcw0KPiBhcmUgYWRkZWQu
IFRoaXMgc2VlbWVkIGxpa2UgYSBuaWNlIGJlbmVmaXQgc28gSSB3ZW50IHRoYXQgd2F5Lg0KPiAN
Cg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52
aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
