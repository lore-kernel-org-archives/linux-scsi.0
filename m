Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B36C19F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 10:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiHIK7E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 06:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiHIK7C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 06:59:02 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9D660DA;
        Tue,  9 Aug 2022 03:59:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoR4Xt7sqiVVMTE1Xd6Otjy7w+WZww9iWRNFKUpNSKQSZtZ+I5txLDsHiPZnbjaSft7zVyrOKgNbbyNc+Kjjw+dVuw6BgjoRgmfJZpddtN3n3rMimKw2DJW9OSux8lEcsIxu+TFX4BQHXgtN6tcaJFiBFFpG4tMi97r0IPPt/CQC9edeezPFe0VZ+ppSysjY3hJsNMNdh5PcTIr19kCy6tHB+Nrv7QdcZ7u+8j3LCI3Odi4ykROADw1Fbq6S/sHoa4OwLzcTY3kbMEjkgdLPNWeJK/Q5+OqF/HN/O434UXOkLgL03X3mryqiNCOQQJdqVA/Uqzwh3k+UWHLZCpjtTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYLaWdi2ZU5lakQyWc5PAjomKt4EUsoCyTu0kNEJZj8=;
 b=cbzO2iNe7Ryv7QtvJ+gcw8GX4Mju77B0gBFWNnaSZBiJeR3VJ09EgloLCPVXs/u/eUQcUiSHeLvi/5rL+rRVecHFYhluono2XzzS6mCdAhkmHFRHozutC7E40vkEQ+2rgyDSuM74AGSOze7yB9LMyGMaRnxWEfMzffvt4RYzgrEOkEIg/p417R3ZQJnvKnTCz7EDyqDwUKkl4UJ+1kUw4dslKsEr95ly6QnV0FX9ggI8+0hpT6lISyMaE2CWXMVAmOyZ6ZQapkIT/Cg5EXch4Y0uUagvu2jGPxGpuZcelcdewwQqbowjFogrnNfxdRyAE/jLBrFkDGL/pFt9KKFfyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYLaWdi2ZU5lakQyWc5PAjomKt4EUsoCyTu0kNEJZj8=;
 b=jeumRL7WDZEvJYzc2TczcvscxusO5/mWBLnpd9s5ZBwUNox61VxqPW073CGT6A81bBvHBzhFU/1ssBMaW2ScT6mi7fsYCRCN+/giXFY6OrtJF6yTh2RifxHWapx3iVDcItHpUWhGTRhbeZJGKuCQS2psYH4w/3g23hplQIs5FezxCrtikYoFF1RTi1K67KbQLDQJo+f117BtFMCWENiAm5HGCThF4y5UTfVZkL4Ok2URQ+SlTrQl08Y8cUuUUKI1zx5AgwmQSdTLko6ps/WD2o+4gdohh0NvEaDpimRT4z9WWEz9VFAuokoRIyckqkcazcLngzELVS/RrlwnUA64fA==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by SN6PR12MB4704.namprd12.prod.outlook.com (2603:10b6:805:e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 10:58:59 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Tue, 9 Aug 2022
 10:58:59 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2 13/20] nvme: Have nvme pr_ops return a blk_status_t
Thread-Topic: [PATCH v2 13/20] nvme: Have nvme pr_ops return a blk_status_t
Thread-Index: AQHYq4P3yU1KFsg5r0m9GCayjBo/iq2mZwWA
Date:   Tue, 9 Aug 2022 10:58:59 +0000
Message-ID: <7423e01b-0ee7-1827-9960-a6fff8f9fb3a@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-14-michael.christie@oracle.com>
In-Reply-To: <20220809000419.10674-14-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f480f050-28f8-4282-1a81-08da79f629dc
x-ms-traffictypediagnostic: SN6PR12MB4704:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tVaF//hil9JQ3JgQa84uDUMUmYgrVSqDVNXHwY2NYY0Z/1qN/EmU9kSXHa7bKFlAjJwPCNlyHn3cHTGOjOgpDjbAydL9/jgjuhj9PCr60LHPUPbcNoIxPT87JFYVhZKWdKocMj34FBLrFwy4FLpFk8okwvf9yr1M7h9v8VodeJI47guNd/wPvPBaDzSK3T/7AWHtN/tbNcYR3f3WMimjT5LO1A0dWSoOVjshoG9qITD/N2Odh+0kkPf7M3wQTlfoiFSvZCFDxgXDb6+H/dEX7IEfUQTEo21Q+5qY7ASwjtzKR3kQzM1RefltjAO5cr+PgeAuResv4J1MlCSIrqHkvgoufDMKipJ7OqV1Eh55FbupZ+QdTCxvv93k6r8QX6vwoeV3jYbEm14dMV2zl49nF5AmCxzU2D5UFyPHLAxJ/eJOH0zGudz+sKRBEvPaw8SzXJy8UkA4Tmu6dvXiz2PYS/mdVAiDZstp1KDYmpPxfhyse8ffvCXtXt9VoLFvv3cMK9LmHxGv2MNt99Ggmld04j7JC7vtk4vzNRu41ippSJtaL5xMTHLiQOMNUORDkHGKXp8J96s1+cZKWXjvYrFDwZIkNBXR5M80Mf3WUEioUX5s7py3u28CAn9JP7WNig1B2rtNponj9LNd1oeAgOqwNgSNquLHLHspURuIWgaP03kk+XXfUzF2MH9Ic5DxLjBvfLlj+kumyFD1qtE2ukQocrFvZtvO1imkINX0H37GAnNcxKbtAdSekKW/HMVrwP/SpSPirRmYBm1tOJFz/cneUKr0a5pzEQ43dP8JsaMpr1UU7QqOg2YZtmwhLK2K7g6Dkob96xeBVVQ4qkY6LgboZs0yfGmtaRRKpz/+/e3RvXaVXWC+A3NpXTiG+CjVOIH8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(316002)(2616005)(478600001)(2906002)(54906003)(76116006)(64756008)(66946007)(66476007)(66556008)(41300700001)(91956017)(4326008)(31686004)(36756003)(6916009)(66446008)(8676002)(5660300002)(71200400001)(6486002)(38100700002)(4744005)(7416002)(6512007)(38070700005)(83380400001)(86362001)(53546011)(8936002)(31696002)(122000001)(6506007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2JPbE1nOUtsUmNqZEFnNnRtY01tMHg4V2JOdGRrN1RjV3hjVXdmeVA2UUEw?=
 =?utf-8?B?dEdndTNwQTRFSE5DOU1LZ244cDBnZEpGRU83WExNYndkL0R0UE02U0JUL3I2?=
 =?utf-8?B?Z1hHOER6cHA0TmdMbFgyMmdUaEJuSHNiUTRpREEvRjBZSnhKS0NiVVBEMU1C?=
 =?utf-8?B?bVVBY1BJcnNJc2FtZENzOGJhTWRoVW5OTDlidmlnSUZkL2FhNHRLS3hRU2gx?=
 =?utf-8?B?UTBaWWwwejU1cEpwU05hRU9jc0FZYWRCSVlVUVB5SkdZNlVGUkQyZUdiaWtq?=
 =?utf-8?B?MWp4MXBibDdmYllZMitJTzM3aVlqYUhwU0U1QlRLZmxJV09JSXBudlVUZ1gr?=
 =?utf-8?B?VWlwZm5YV1IySllDUCtVZ0Y1R1RVOGdyOHdYL0l1QWhJNHNzOFJFNDVVNi84?=
 =?utf-8?B?ZzFBdkxZME1xYWJ0YUYyVmg2V1RWdGRvZTBzRjNNeW1zYjRnMXVmRHFGdGJz?=
 =?utf-8?B?bjJ6MnZsZUIyZ0tuZWVIU2k4elZub1FldExPR2pOc1E3Nk42ci9pZW16YnJl?=
 =?utf-8?B?YjZhMlY1OXdtVWQ4R0t6WlNpT1h3bFczNVFEUTRLaHhEbHl6d0IwR25USFgr?=
 =?utf-8?B?UDdUdlpZSUIrRWlwd1ptM0hsZmtEYSs2Y2pQTTlkMFFocmRkaGRwemVXSXdn?=
 =?utf-8?B?Mm44UkpOeWNUYjRxWkgvNmxTa01nc1hkNG41UXJvaDYrRlZUN0xyNE5abEZn?=
 =?utf-8?B?aXM5TEcvTFpLYitiR09BREN5NE4wRFdxampnSFk1bVkxTFp2dGltcTZndk9Q?=
 =?utf-8?B?amVOMFZ2QW93U3gyMTlHbDI2eUkyMzVKSHRaaXp5c2tmMnFHbS9URlFDY3hw?=
 =?utf-8?B?aDdnbW12Mmg2aXQ3amd3TTN4elI5MzJZck1QN2d4MFF4WkovUkQ4N3NSOWtQ?=
 =?utf-8?B?VDU5NXhBTTQ0TEk3K3pjd1dFdEF6QUtOQm5YdDhFYzBuSEt2aG93bWYzTm5j?=
 =?utf-8?B?SXo5RUsxb1BXVmRTcElMbnJOeUc5TUVrbmhZSXhVOFp4SElEU05zcy9jejRr?=
 =?utf-8?B?TjZZeFJ0eWV5cmFDS2psT01qbTFwTzhNU2xiM1dia1oxaTlKTXJGMkxqWW1a?=
 =?utf-8?B?QytQS3VvS2tqNDhXUWtMWjRaSnBiSDBzTmVJa29qNUpLb3dhYWh2bUxscWd5?=
 =?utf-8?B?aWU4OXdTZURDODUvVGlTaTNJUkRDa1BwRkx4OEVKNEFteGIvYnprVWxJckJl?=
 =?utf-8?B?bWgrVUFOMDlMNkliVEZWMHpSNGwyQUFXWllUaXVnYzFGT2l0dmtPK1p4b29L?=
 =?utf-8?B?UXV1aFAremtVaHA1eER3cXlnWGxyZGxqUGR4SHlzVG1ubHBjYmpjZ2tvQWg5?=
 =?utf-8?B?WDNTejlPckZDQXMyUVNpRTltVnQ0dXM2cEhYTmlRM0tLRXN0WUh1a2wvcUhV?=
 =?utf-8?B?ZGJVOWlyeGUydHNRRkFFR2IrRGwrYWJQUHFCM1hiYjNYM1VYQjNrV0dLMEtO?=
 =?utf-8?B?VEEzZmFqa2g2Ui90S3k2aGRGMitNVWZuWFdNdFQwdExaZ0V4UTV3WTZ2YlI3?=
 =?utf-8?B?NEtNK25LWmRKRm54SGlmRkRYYVRGN1duclpMTDl5KzdwVGtwUzc1NVlLRktL?=
 =?utf-8?B?a2QySUo3MTlBbVZTTW81YzhMc1N2VmJHQTBKSnFPMFE3MG1td3I1L1J5YlFP?=
 =?utf-8?B?a3lMOGhPM0NSQjR5VTk5UlJJSUt5VVRVTytjajJmK1RMQ1RwWGR6WWZWNEFG?=
 =?utf-8?B?MTZTZkF5VlpzSFpNcjBUWWtUTFdwdnFKNVNiZ2tTM2dhOEdERW1UUUI4cjll?=
 =?utf-8?B?UXRnRWljREhSMVFkcnk4aURUcTBMOUhXQkpMaFNKSTNpWTlRcEdVYjVHSVAv?=
 =?utf-8?B?dnRXL3p4RzZKRy80b3ppZWNHYjh5Q1EyNzNTblExcjhyVlhvdVcyM1ZjUkc0?=
 =?utf-8?B?Uk12eXZZTG9kTTN0N2MxWmJlaCs5WHdQMEp4OUxPUWwrNnZlbkRWbmtmOHBw?=
 =?utf-8?B?NG5iaWIyK0V0YkF0aFFOL2N3Lzd1ZGhxQXNacFdvTkNIN2FqVVVuVWpya3RQ?=
 =?utf-8?B?NVB2VnowdU9vL3ZmRHUxdzlaek9BbytSa1EvWWViR1libVB0azdJbWVRNlZh?=
 =?utf-8?B?dkJmZG9nTDBnRk5EdmlwWmk0QjNkMEZoU1MvODlDNTZYRkl0OWpxa1VsQjVs?=
 =?utf-8?B?K3B0MERLblZHOGdYMXBFTmdvZUNMa2RJSldXOXdkZEJlUVVHRnB1bTRleDl5?=
 =?utf-8?B?dkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE42A5E64608F64485667316FF043744@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f480f050-28f8-4282-1a81-08da79f629dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 10:58:59.7396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 58lYG+ffPsQzBNpSlp8hfq7oaHdNUjKDlLBFI28EPZoha8x28s0eYVuRj85o6C+UqtIG3EF78VAoTlnGk6hVzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4704
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOC84LzIyIDE3OjA0LCBNaWtlIENocmlzdGllIHdyb3RlOg0KPiBUaGlzIHBhdGNoIGhhcyB0
aGUgbnZtZSBwcl9vcHMgY29udmVydCBmcm9tIGEgbnZtZSBzdGF0dXMgdmFsdWUgdG8gYQ0KPiBi
bGtfc3RhdHVzX3QuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNaWtlIENocmlzdGllIDxtaWNoYWVs
LmNocmlzdGllQG9yYWNsZS5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbnZtZS9ob3N0L2NvcmUu
YyB8IDU0ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0NCj4gICAxIGZp
bGUgY2hhbmdlZCwgMzYgaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9udm1lL2hvc3QvY29yZS5jIGIvZHJpdmVycy9udm1lL2hvc3QvY29y
ZS5jDQoNCkFnYWluIHBsZWFzZSBjb25zaWRlciBtb3ZpbmcgcHIgY29kZSBpbnRvIGl0J3Mgb3du
IGZpbGUsDQppZiBvdGhlcnMgYXJlIG9rYXkgd2l0aCBpdC4NCg0KLWNrDQoNCg0K
