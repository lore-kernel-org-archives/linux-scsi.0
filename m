Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B29FA3743
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Nov 2022 05:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiKAFpT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Nov 2022 01:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAFpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2022 01:45:15 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C37630E;
        Mon, 31 Oct 2022 22:45:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvJrfr9x892BM2CxqChNPqqTgGZaj7GiLKL93vZocxl0U5xwXWQRHxYLJ4RtaYCdVQis1Zba5yiWAKg43q3ZCD0lapAbNhNqw1MJDIrSiN3pI6hh4V/mxGQ+fKvlyzCfNzm5qPEpBOtNVixaRdFfbZUhM1CGkcWd6iSQpgFBLnGzFkYoP+vS4bfjGSclQGmA4H+K8mOQDWFO4gdBHKPK0hMDy0jELx4pKQRogwm7Ey/Zt5IP85EpAlwKlpBQA/l1ADQU8Pj2jxNC7F/I94wfuFv7caLcfyLs3Tjts+SOqX0iM53/SZSXagD9z5igE+jdKmnDRjMLSZFimUu1/uGwkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTKY3ph4LMByJ6G7Vh/L2qlU235UeRcUj/wMItg2z/w=;
 b=lkb9Z5Yha/veIHVOlpxogzdXogcy76MR9qde+W+0EZ4cyBb6CHous5ieSC7MoKrhGbJ6p0GL9+tqV7tdK3LdI7bjCa+055t68uP+VeYd7kJhJRZKnXa5Sfhd43jEpMPtVy1VtYjId2buJG6qRzQN7tQUB2Qdf1JWmaptoF4k4gf0JzNaugcg2rabH95YXsXXebJfN11f4vUEcnpI9J8W5h2lh3/Tr7yKBAW6yHqm2L8ibDZ/7ROWjjCj4zXH/dLcfIpHljkStzKly/MyaKa9HhSLIn0i6inTKJAl5nFDFYaQayPZeJDoJuEGjxSoZOBwDFFl2WZ/cOOHbGab5N/YKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTKY3ph4LMByJ6G7Vh/L2qlU235UeRcUj/wMItg2z/w=;
 b=mEbX012b4EAmFIScAQBFb7juUgJ4iStuee4uESQ354s7mJdaxaC2V2LFe9aWjvauVz4HD38QorL/r4tjsrtncpIOSrUEA2PMxX43rwt5bVUf6gwpmkHYxgrbnOES5JTE9pUdpBuNfrJLin810ihG8tfbN3XzBP0WpuTJDAtyV0IU7RLdEtCDljv6Q/Uwl/Lr0dTAiERq7c8TGjo5KxrhAI5NjEnSggGb5kKMXSBe0LP21wrud4fgH6nQbwGp00KrCUwZoBgfKFNkHQe5hnzFtNyF80YvhzTbWRf5G1+vCofvJ8P4rwjuo+CDa+32ymR+5OyfeHo9+ztftuw6M+fGwg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7080.namprd12.prod.outlook.com (2603:10b6:510:21d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Tue, 1 Nov
 2022 05:45:13 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 05:45:12 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH v3 04/19] scsi: Add support for block PR read
 keys/reservation
Thread-Topic: [PATCH v3 04/19] scsi: Add support for block PR read
 keys/reservation
Thread-Index: AQHY6ZG2rXrywtNwpkassqh1XNVmtK4plxQA
Date:   Tue, 1 Nov 2022 05:45:12 +0000
Message-ID: <5edeecd7-09a0-65a4-46b7-014d1a1c1acf@nvidia.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-5-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-5-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7080:EE_
x-ms-office365-filtering-correlation-id: 9337af98-a7d8-4b2f-79c6-08dabbcc3edd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QcPPWvd8ErwvFW9cA6+HwCrYr1V015yGgbMxz6vDuX4BimCWDAn7au9BvrscLyyQ3xfBe2up4QVnD20PobIok3bWJP0JgRW1I6VllCQHeWhzkoLMBnhZvGH/jccm9fYk8phFNUMohsRkjP0KDKRax2OpX3L9EyxznQGcmDQqsrN/PHNMUbm1n9HMkQlIqAaztq2z2kVed8ETJWtevspbyrz7TVRvmgPl58ZqjKzY/fxwc5m2T6j1gBd4nk/bnXq3lNyczxlXWhoroqM/7IwyzA+BafH83L84Lv6iYchtuBjMMmYeUMFIW+CHPeDrmhBZXdDLeID0xRGoiqIm9He/kkY3JvR9nBMDEMGUmviydhLoEUPQzw1z5I9bk47m/mKyKKZybWDLpezVIgrhJIWVRBOdxh4T8ocrI8dz9nT6ijbjVZP4gY7WRjwRWgKraEfpd9feh55/bkVNfFkILw/yiWaq8wSnmbvlTl9MSj8hOFcLTM4fU3Qw6ti4PoCI8eG//RbvEd4qPfHzmQehoOmMsV3Cq8kZx98FpZtzX538F/31EiP85tuOvD4uNzTjHUydpsmUsL5mV5NeoRXRu7laWrEUPcbb8FOBICv1GeW1blU08ijChQfmdgcjv1FDRHjYhbPt2Pj5pK8FKGYzdg9WhiC14XLTPcVBR52cXJvF1T3Z9Z7GGifA5XmdMkk5rylxSC06C8+azneqIZF1pSnxbsyCiTUh/DPcv6hZfQca4UerMXCaSXiUdyjiT8AFHvLZlk247xNlXRXS0NricE0zXbIq8el2uM5jcaH3ENlkO2kOSfmDx74FXV7nVFMWiQigFxcolVIs3eiLvhbxDffywFE2DwVDorz95/Q5aPaxyr4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199015)(5660300002)(2616005)(38100700002)(91956017)(122000001)(4744005)(86362001)(31696002)(7416002)(83380400001)(8676002)(8936002)(186003)(36756003)(66946007)(6506007)(64756008)(66446008)(66556008)(41300700001)(66476007)(6512007)(2906002)(38070700005)(6486002)(921005)(31686004)(76116006)(478600001)(316002)(71200400001)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFNuZ2xCb0hsM2NHWjhlWmRBWW1rckhueTA5NUhvTlh6YVBvQ1VVS2k5WG0r?=
 =?utf-8?B?c2tSNE9PTFd6eGZHbTNoYmxSeVdmN3RhRENZa1VWdWJ6UXBiOE02Uk9IK3Na?=
 =?utf-8?B?dkhiN1BRUGNGRlZSdm9VaVFyeWM5UzhjVUpjRDQ4ZVdzemdld3JqQnRSc1dJ?=
 =?utf-8?B?T0owdnVhdUlqdlVCdUhvUCtJdXlTckh5ckZXWmpZQlJWclpEeWJQdnVoVnlp?=
 =?utf-8?B?QkNYVUhCTVlRN2VrTmxWVjVJUVcyOURJdFpEcDJleExQclhPUlZWM2Z1OEQr?=
 =?utf-8?B?SXFMK1NMbDlvZFAzUHd1NDIrQXAwZlkvV1h0K2ZnVUdqMkYxNFRob1B1VTR4?=
 =?utf-8?B?eEt3WkxOY0tldm5LZzEvQlUxTEhKNG1ObTdmZDJ4M056SXVURnVrWjRQWWNs?=
 =?utf-8?B?UTFqMEJMVTNaY1JWWGxHdWtBNVU5eFNmc2gxNzB5bEgxZWhjMnE1VHZtNDFO?=
 =?utf-8?B?N0wvekM0TlNrY0NRaGhxeWdNcVV6NHpnWUNUd1crTTFPcnZKV3BPNkJvdlli?=
 =?utf-8?B?UUk3b2xGRVFsTFRuTzJkcUtoNUdTVStpbFQ4azFSWTlpNGRFVCtheHY0RDBa?=
 =?utf-8?B?Nm1rMytxRFpVUHg5QmpHUkxJK3UzODEyRVkrclRIenI3VHQrYWNlYzZ6b29O?=
 =?utf-8?B?emNHMi9INGw1WFJ0RnRrM0YrOHUrbzBoMnVkS0hZOHE3N1pjbmZ3bnhGNnBW?=
 =?utf-8?B?Njl1eUU1L0xZaHdQQWtiZHlLWmZXelNlV3RVUC9tM1pqSXJhd25jSExHdGV0?=
 =?utf-8?B?VDFpdGFPTXRWNUt5bzJzT2FiN251VndMUHdnUWExeEZvcnpPQTliUlJNN3NR?=
 =?utf-8?B?N21rQlN2ZzEveG52Z0hZZUhtY2QrMXZ4bHc0alk3Wk80Wnorei9yeCswRWxn?=
 =?utf-8?B?RXhtNzVHcm5Cc0NWaEdzZEtPOWNOSE9RdkhTTUJQc1d3b29lOW5vRzNoZmhN?=
 =?utf-8?B?SHNmL0RCQTJxUjlBMmNUdlloelQvY1lRZXdNbm1SNDdWNmtEUzhFSmVmRVRR?=
 =?utf-8?B?eTFVS1ZWWkUwbU5xblVaZG1KbTRhWkU3ZnRPY3l2ZnZCR3dPY1E3WnhXSG5F?=
 =?utf-8?B?Y0U0aXZJZDlEWmRDaGYzZVVIbmhuemkwN2JtTjAwTnl1TktSL0VsS2tCaWMz?=
 =?utf-8?B?OWJvbzVPdkdINlhNN2hNN0h4TDZVeUFQTnlIVmFHUllEVm94Mi9KbDJac0dN?=
 =?utf-8?B?TWVaUXE0ZHV4WFFVM2d2MUlLYnBnc1VqYkRza2cxZFo5VFQ0cUQ5aVREam11?=
 =?utf-8?B?WW5ia2VvRFVEWE1ueXd4dlBOdFhHOWFiM1RmdU1FUHdoWVBXV0tpbXB2dUI2?=
 =?utf-8?B?aVFJZzdOWmMyWlB4NmFWY0RvYzZKdFVuSlNoMmo3Z1J0RHhiaytneHlrODVF?=
 =?utf-8?B?VmZCTUZ0akYzeFMzQWJTRkRSSlVTMnZSaHNRQnRqSmpuTXgrK0lMLzIzUmtL?=
 =?utf-8?B?TlFCSTQzTGxiWDY3TGh1ZzkzOEJrMlF3d0NlNkFJYnFuSFN1eWtEd3VjMXF0?=
 =?utf-8?B?aE5zeXVIN0laTk15eitPcS81RVVJQjVYcTVsUjhzdEJWZHRKR0lqd0M5M2dF?=
 =?utf-8?B?OW9pNlo5N1Y3YnFQM09KS2RUckZpbUZGVTk4NlRDbmUwZTVna0ZKaklWNTJS?=
 =?utf-8?B?dWJFTTBsU1ZaK1VpZ2U2MFV3K3FZWVUrNVNPUEs2YzRUekhmY0tWcnhaY3pP?=
 =?utf-8?B?dnpuVTdJeDVMU1dTcEJFTHh6QTZ6eVUzQUFPMVNyeGZaMDFkL3BlMGN2azd0?=
 =?utf-8?B?UzZNS0RRckZpMUJLNW8rN21VM3JGaDhVYVBFdWtibTkzUEVyUkF2RFNkVjRR?=
 =?utf-8?B?dnk4aDhXUDMvcjdzQTk2dHFZTm5wUm1CZ0Y1L1hJMVdiL1FnOURFeXgwSUlV?=
 =?utf-8?B?S3crQ29WYWVXYWxIRUpidzAydG5HclZWeVd4NWU3WTFiYjhhbitnMlV4b3c3?=
 =?utf-8?B?ekZ6OFB1SE1KaGdSK3B6cHk5ZEhsNzVoMUtPNnRmbDhxZ2JOYWRxcW85Z0pV?=
 =?utf-8?B?NElJWVNpNUtMVWpkUGV5b3Z6cDkya21xZjZlMjRJSFlscStPSEZ4UUF4Nko5?=
 =?utf-8?B?NW1jZzVIYmlJSGJhM3pUODhLOUsxaW9pUHZMckxicmZ5WXNrdW1yeFR5c3ZW?=
 =?utf-8?B?dEhoNWU3Qjh6QkVCS2UzUFFxa25lRDdZcnE3eVg4blRrUTV3aDdGVkozeVZT?=
 =?utf-8?B?S0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E81F4D3D242E1745AB4C278037589D56@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9337af98-a7d8-4b2f-79c6-08dabbcc3edd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 05:45:12.8458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aj3G3Ywe7mFukW47htTqmh3Tb0jbNr7y4JxnYRPcRzvxGBWT/mjbkivRm5f3g/RS4deJIEc9eUd3NOEni8764g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7080
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICtzdGF0aWMgaW5saW5lIGVudW0gcHJfdHlwZSBzY3NpX3ByX3R5cGVfdG9fYmxvY2soZW51
bSBzY3NpX3ByX3R5cGUgdHlwZSkNCj4gK3sNCj4gKwlzd2l0Y2ggKHR5cGUpIHsNCj4gKwljYXNl
IFNDU0lfUFJfV1JJVEVfRVhDTFVTSVZFOg0KPiArCQlyZXR1cm4gUFJfV1JJVEVfRVhDTFVTSVZF
Ow0KPiArCWNhc2UgU0NTSV9QUl9FWENMVVNJVkVfQUNDRVNTOg0KPiArCQlyZXR1cm4gUFJfRVhD
TFVTSVZFX0FDQ0VTUzsNCj4gKwljYXNlIFNDU0lfUFJfV1JJVEVfRVhDTFVTSVZFX1JFR19PTkxZ
Og0KPiArCQlyZXR1cm4gUFJfV1JJVEVfRVhDTFVTSVZFX1JFR19PTkxZOw0KPiArCWNhc2UgU0NT
SV9QUl9FWENMVVNJVkVfQUNDRVNTX1JFR19PTkxZOg0KPiArCQlyZXR1cm4gUFJfRVhDTFVTSVZF
X0FDQ0VTU19SRUdfT05MWTsNCj4gKwljYXNlIFNDU0lfUFJfV1JJVEVfRVhDTFVTSVZFX0FMTF9S
RUdTOg0KPiArCQlyZXR1cm4gUFJfV1JJVEVfRVhDTFVTSVZFX0FMTF9SRUdTOw0KPiArCWNhc2Ug
U0NTSV9QUl9FWENMVVNJVkVfQUNDRVNTX0FMTF9SRUdTOg0KPiArCQlyZXR1cm4gUFJfRVhDTFVT
SVZFX0FDQ0VTU19BTExfUkVHUzsNCj4gKwlkZWZhdWx0Og0KPiArCQlyZXR1cm4gMDsNCj4gKwl9
DQo+ICt9DQo+ICsNCg0Kc2FtZSBoZXJlIGFzIHByZXZpb3VzIGNvbW1lbnQsIHVubGVzcyB0aGVy
ZSBpcyBzdHJvbmcgcmVhc29uIG5vdCB0byBkbw0KdGhhdCAuLi4NCg0KLWNrDQoNCg==
