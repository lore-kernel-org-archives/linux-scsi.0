Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1919C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Nov 2022 05:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiKAFdT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Nov 2022 01:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiKAFdS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2022 01:33:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE7913CD8;
        Mon, 31 Oct 2022 22:33:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKs1D2YzSgnctaLeX1Ayh1Cdat+hNotVpm5o/kxCEaBd+4XUwWy9WBTw9M0adDP9yuZrF4TU+L7pNCWKOq5wsJbYf5CFC7FE2Xe5+cZ9PuwcavrITcYuX5Ka1txw9Y/65mEEufbEamBaQE2AWfBEAgw1FQs5NJ3UlKgOaOW34CbjAbaJuyxaRurOy+OWI9yvUFYgN5SMiWgtX42ldgho0y0E0IkQZsarHGljv0Qy4zwdX2GvoPvpWAOv85kcN+SHT/BXai/Wu/23Tq08mpUWG4MdspPyXgDKGoXStxsyuyurbEUNCqCwdM+PypLiLEuuR4DcaPYKhfurs+AqdUIatQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FGBD7yItPtbtndxGoGcsDKJAZZpUrGiwxy16yGJiJmU=;
 b=WUCQwon9aI0Jm8vY8q4kGzWcRg6aZAiVj1StE3JVdllGo5embFElK80slz2yowytMq73vOL4csXV94X7zrLFhbb6g7EqzwPcpEqSZSSkV4LIvQJaQUl7cI1A0HaShsxvpGDZCHsLM7bN92ZWuiYzAXHWRdhmBjbZSHr/Wvf9q1DKKMi+TogpWuHQZ77N/vm8Qkom11JW7W+MFuwsL/ftXDk3qplFiwCMPcO8hAd07E7l1J4u6KLu2JmHR5E9L+CDjPEsyMm80UXoJMas3bxfI6bfIRYpYMUtJF8ZqYzV3AXY4An/Sfi+hW2VV5PMkQnFXbs4CQwWOmRY32PtleBl5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGBD7yItPtbtndxGoGcsDKJAZZpUrGiwxy16yGJiJmU=;
 b=th5pxT/Oi4ZHPHTTdNPW4P0dU4YtYYgS3i6vzdK+h2DnuXKJyH+lpZ6qjqoO3vmmFJdlYx0Eu86sG5bSKKU3tY26zhfGKIcoBwI9hcxfwwkFQ3gXEXOd5+EnLnChhKLLNxBmcOXcMmDpAC5GvBcoonGcjxz33TRexvEmqmXXmLGTVJhQlqJ81sPcmYrG4dFaXrEB2Rq2eQWTsQvfv41foXXDmdmI2mC3D2EFvfsFUDo9g81zV/OXQmxA8TIfGIyA2vRcgtNAaCjCzr2ScgTyntYe4sIxqmmUrtXdwGBzERWuRlzQUkfzFSmwLIORIDQ1pfBpTfNQ5tSbzoWE+C/RAg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7011.namprd12.prod.outlook.com (2603:10b6:510:21c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.38; Tue, 1 Nov
 2022 05:33:14 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 05:33:14 +0000
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
Subject: Re: [PATCH v3 02/19] scsi: Rename sd_pr_command
Thread-Topic: [PATCH v3 02/19] scsi: Rename sd_pr_command
Thread-Index: AQHY6ZGB0y/7jYYoWEirC4MSbfG/a64pk7uA
Date:   Tue, 1 Nov 2022 05:33:14 +0000
Message-ID: <cb95f562-32a0-299c-a74c-7bd50a0cbea5@nvidia.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-3-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-3-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7011:EE_
x-ms-office365-filtering-correlation-id: ff4c0d98-cc08-4f35-d987-08dabbca9290
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZUupsOu2/ZnXhWy9xnLTKxQAEz29BC0AmMTX5P2pSnX+tXHAEj02i5uvpUeAd7WdaX1pLj9bwMZjrc9hXG+dwyPCa9EpHovrS7v6TCGDNMAj/4QIxrL6UjlHQKxMahwobwp1EHBj5uxMLjQ+3/Fr46wp0n3Al2RSG5ezkB1nShYzl9YyeraDpkZVkekK9vKvuENPDxmBCHYn9HWGmtDVKCL+vYL/KS+zk94ovCMW9Qr3j+0VTjsu5h/xENTQDOk3xa7eTqceAe8Sj2KPMr/09BBkyzpDpvLR7faL5qKrcg6NjRvuFxOrQoF6mlU/6iFcuT4nXMbBxlEVA1MUXdwjZsiID2pIpMBD/2MO+IUOdxfBwMThjjOGSCEsVkxNZSsjxCoMqIQQbVU43ubQyEahyHFVPQBkt1IY8AvsQR3IiYRI2nxPvSDaRhKofu48YcsmJrwB5x9kTAtS10NL5KO66omy8+nud7RFQ21DC/L4RsgnBdZE+kJP1nZyFKwEOYt00fqUYfBVfJjuqcJd3VjCqqmfu2pKLgv1uSuVw686Z3qF5OyOqYTAgSjCmc2frTJNTLOpvfZ6P1E1SCDCotf/qxWwakComd8OrkGa6K7qYLRHg5nGUzxhFdKtq3wV2mpa0wEA7w2LfKhuVtWkcFG+pEr4GqxzUb9M4DCByBoPt0LHeQIDgp7dlxgt3EGdfMvHgSva1OciKt+uMPN7cqIZt9U5KItlEyQhpYY1HKH/ZdTe/dJmtdlIQP/6bMcYvj0SOL15nirnjoHw6l/qYckJTMFg0GcjPMX5VekwmNCiMq2WOqpvu9ZqQJlTgD9YqXtoGrYPkW5UczHa6OgU645ZPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199015)(31696002)(6486002)(86362001)(71200400001)(921005)(38100700002)(31686004)(66476007)(5660300002)(64756008)(41300700001)(110136005)(122000001)(478600001)(53546011)(7416002)(2906002)(6506007)(558084003)(91956017)(66446008)(66946007)(76116006)(38070700005)(66556008)(316002)(8676002)(6512007)(8936002)(186003)(36756003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXdUL3crRjJXdHB2SERKNEsvenN4MVpJQlFrY0Zld1JLaUx4S2NLVmlaWDRB?=
 =?utf-8?B?NXFBc1dUTml3VzhsdHhJWHUrTG5wSk5SQjB3RWxFSlNhdW1aZUNBV01qZmxy?=
 =?utf-8?B?dnlVTldrSWE4STMwTmtnQldNdDNDRGtOZTlVT0pkbCthK0lXTVpEekVIdDRv?=
 =?utf-8?B?Wnpia1NsRTdYdXlmVmFJZ2hhRnVKdTFiT3RoZnR4a1RpbW02RnF3NHd0dmFX?=
 =?utf-8?B?ckpuUzlwNU5rVUdtTzBjMUFUVGxHcHI3WjJJZGxsczJ2dHpPWE9WZEJJV01L?=
 =?utf-8?B?QUpkK0IxVjBvb282ckVYVXZEVkVmT1g0SVBzNEVJTFF6SStWMkpzYWNYdUJu?=
 =?utf-8?B?SmJrOWRVb1Q2Vlg3OGlyelU0T08yeklZc2xtcWJJcEVNa1NyWkVNRkp1YWtp?=
 =?utf-8?B?bXBNbmFTTzVSNEttbW9JT2ZNWFkzQldITHV1aUdxeVgvYU5BbS8wTmcvd0Rj?=
 =?utf-8?B?SHhUSGhveGZrSGpMY2JwQnBVUk51OWhrdlFPZFhTdlRXM21kck5IYzA1L2lI?=
 =?utf-8?B?dVJzc3BXb1FkMVV6aEo3RFdSQjFQSU8yTEgvY0JpZEJYM0crYVpURGVlYURt?=
 =?utf-8?B?RFc4dUtEYldMWHkzeFRoUXV3VUg2ZDg3aVhuZVRUVXE1ZmttT0RaV1ZZQkor?=
 =?utf-8?B?bFozY3FyOTgyaG9md3RkWDdLeDZObWlrWDhkYWEzbVZhQjFmTnRCUjNZTmkv?=
 =?utf-8?B?WGI2YkxzVjc3QTMxRWIzRlFVUGVNbUJTQnNxbGlHNjNWejFod1EvYWR4VGRz?=
 =?utf-8?B?dElGOEdtRTA4ZFNKbTBSVkFlKzkwczhJbmZMRUpvZkc4Z1lQQWE3M2U0WWZM?=
 =?utf-8?B?Y1lvV09kOFpNajVQUmMrd2JBQWdGVUZlazhaRjZJQUxqd0MrKy9uR3F0dmZW?=
 =?utf-8?B?cEpubG9taW1qeHRzYmNKOTF3R091T0I3anVnZUNwdEluWHNpOUVwY3hBSmMz?=
 =?utf-8?B?Qk9HSzBSaTRmMEZPdFRRNmhPSUVxTE5FdGFnRWV4QVIzR3JGUTcxeGpjdFRq?=
 =?utf-8?B?ckpEV0puR3lvOEVuNFVuektmc0hJRGcxZjJYQTVVSUlXclNNaUJKWllpdFdh?=
 =?utf-8?B?cnlPaURsb1FvcW5kaDdqRDJjR3VmVDBRQmZ5SVVnSzRlUm1YeG5lcjVMNUJ0?=
 =?utf-8?B?OHM1QStseFEyelJ0Ym93RzNmZFNnY2lKRHJCcnNMV3Q0T2tXT1pvNHpKZ2tK?=
 =?utf-8?B?dVBldW9QS2p3RDZ4L3JJUkx1a3dBVFR5L1BUeWtSRmhIWXBqTjRONm9ibFJv?=
 =?utf-8?B?ZWtsZmxUak8rVG5VaHZOd0xuRlVUbm5PWFYralRLb3cvVE41dW1sSXkveno1?=
 =?utf-8?B?azVpY2pGSEtIdjNzbmw4NVhPNitVTVJ2dEk4V2hXaUdCUm44NVhvMC9QbDZo?=
 =?utf-8?B?RFlRQ3FrVlE2NWdvSm9YUzlnWUlkMTBINmhONGlJUkFqZnlxRi9QZmpRR0xn?=
 =?utf-8?B?RHpLWmpsMDNkRU0wSjJXQS85NDVXVW9jQk9WTmtSZGFNdkx3VUpCS25IeHU4?=
 =?utf-8?B?ZjRiczBCdGJsUEhuVUYyNHZ2SDB3aDBhNWtTTGRrMVM0OVBXZGNtS3NUd2dq?=
 =?utf-8?B?ZFp1WGdnODA4Tng4ZlR6VHBzL3RjZXZBNSthMTdmOVlPK2t0TjVpczRkV2F2?=
 =?utf-8?B?dGpNSzFrR1EyUlgwYzZtTUlFcEU2ZjNqY296NlpJQnYxYUUyMWJqK0VBWlJW?=
 =?utf-8?B?UTl3OGUxdDlJSkkxV1N3dXk4Y05xV2JPMHBGd09VMitqL2tXc29YNkdGWW1m?=
 =?utf-8?B?clBDTS9kUk9EazltZEpEeUI5NG5NL294N2tKdk9xTTZrM3c1c1M3bG04Snkz?=
 =?utf-8?B?aHFNK3BxNDU2cmRTUVY0bTJuMmVKb1pFQ0t5SUZnUHV1c04wNjN1a1lqRDN5?=
 =?utf-8?B?bmNTN3NLUXFGcVVBb1hzUThMNEo2Z0tsaHNUYUdydUllTXcvT24vVGhjMXR3?=
 =?utf-8?B?K3VlZmxoV0RDeVN2S3VXNEdoR1NoMWZKSVlyUndHS1lzdGJIYTY3cGp4TVE0?=
 =?utf-8?B?VlAwdWt5SXY4ZEhLMm9hSWVzYVVRa2xHVXlkMU9GSU9oUitXSTZ5bDFzb1Vo?=
 =?utf-8?B?a1NYQTk0OGxob0t2VndrbGJMamZCdkRuT0kyZjlUd2g1eFVhRnJSNVBJVHF0?=
 =?utf-8?B?S3UzaGhuRDA4dXYxQVNHU3ZsYnNjVXl6TlVKa2llRWkrOC9Ta2ZlZk0zb3g2?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <79B9D7962E875D4394CB8368FCFA26B6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff4c0d98-cc08-4f35-d987-08dabbca9290
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 05:33:14.2944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R4yYa//tVK3kQtp8RK44PG4+Sm1jg9qrM/r33YocJRPktC1UKcKzaX1zp4D6DWYIAymFITjjDz7hEtfDv7eMEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjYvMjIgMTY6MTksIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFJlbmFtZSBzZF9wcl9j
b21tYW5kIHRvIHNkX3ByX291dF9jb21tYW5kIHRvIG1hdGNoIGENCj4gc2RfcHJfaW5fY29tbWFu
ZCBoZWxwZXIgYWRkZWQgaW4gdGhlIG5leHQgcGF0Y2hlcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IE1pa2UgQ2hyaXN0aWUgPG1pY2hhZWwuY2hyaXN0aWVAb3JhY2xlLmNvbT4NCj4gUmV2aWV3ZWQt
Ynk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gICBkcml2ZXJzL3Nj
c2kvc2QuYyB8IDEyICsrKysrKy0tLS0tLQ0KPg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1
bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
