Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F1CC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 01:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiKPBAH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 20:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiKPBAG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 20:00:06 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2089.outbound.protection.outlook.com [40.107.212.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA69621263;
        Tue, 15 Nov 2022 17:00:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVfYUERsjFmUMo/VWFX3w0ncfU/SfJ6GHHLck7fBeSQFcOMxbwnc+D6KbxUhBXFacMNKfoMbIoI5KO47oFTJNG8Ujn7P5nIyUGVPT95+9Pz5y7nvosPZWgZMuNPBzmJyixpiGQBI1AckHU5wgnDoLiDyVjiQ2OoI3CPBgvGfnai/4wFJ4fzPpD1ECQN3HwRWT9DPvwGpB3zYLIWFuYT10roHoo+X68yGn2HwZN/YnHSwKgVbivWDYuCoCKxATz/5wGk8wF6BfvPHlsSpK2IbhT0Pk42FL70NMxCVCmUMd/bCvXqzibT3o3/SoFYvk2vox0FfRRxx9UhwCqMhaXYMZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6WFgE4ykNRg0oJf3DQoVodMznZBZaLQjGpetjGBWpCI=;
 b=B7yT9gLE64t934XS7If9WxxvShaSEHKDsdqCf+TjZ5vU3UaP0bk2xNNqoLWIrJdL6oG27AawOBIi3c4O6Ut4E64eWN40ydYBqQbDMc78DXD3Cf43DjLKhrTtzU9SO0YLaZWbKCb+T++N7LKClosspxXNxEwsX7tTUJkzsURcvUNfV6wfF8fgscvOyl/DRa0ekFB5h1X0bpzEenQdrODFv616WrCdwbJeJnkxukJQbCb47W+SRHgqYwxHgGyYzrPaj0NR4r9nlaM+0llpqYrqaBwYHvGol+C20LkhG2EAw0a1MapqN1OjvmCHG64C+GiwTA4IYouW0Hoy9NhSibcTHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WFgE4ykNRg0oJf3DQoVodMznZBZaLQjGpetjGBWpCI=;
 b=I1/kIMnGvm7+LbM1REEqvUV0N7b3mjdTlNURQOfkSyeZFalX42ZTgqRMyMrQb42pWl/YdxFzp/rUsv7xrTHd9RXUOFWLnPtFfP/1S+XW8/GpQWTvbTFr3CT2IPhEGpvMsP469CMbIOn9z7BzyDMtgqFToTWo1+6gRJih1V9MEkd/OqvL997s+ghe1fhe2Mvs+wv1z9IXaEHeL3ndU/vRzrO+Xfuzvw+7PivKnO5y8xJJbmqhudk445s4preBADugRD/qVo5wNoxFreIm8Z4eFPY6NA6C8s/Vx7vxh2s43pYRWBPVEOuN5HqN4eiOyFPNZavSs2OEIXWv/Ht5m7REIQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 01:00:03 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 01:00:02 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] scsi: Rename status_byte to sg_status_byte
Thread-Topic: [PATCH v2 2/4] scsi: Rename status_byte to sg_status_byte
Thread-Index: AQHY+TlDuJYqdMERzUym6Yzjwb9xLa5AuxAA
Date:   Wed, 16 Nov 2022 01:00:02 +0000
Message-ID: <b94a8c77-7c66-9d17-7e5d-eb87400355d6@nvidia.com>
References: <20221115212825.7945-1-michael.christie@oracle.com>
 <20221115212825.7945-3-michael.christie@oracle.com>
In-Reply-To: <20221115212825.7945-3-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SN7PR12MB8131:EE_
x-ms-office365-filtering-correlation-id: d92aa21f-627d-4f5a-2b87-08dac76de48c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BA9Lkn0RspcgnK8Yq9mE0VomY7pWYlLDd14cWAZxQTfkXYA7FRa3QZXYt61J6Q44qhNAiWDPbWGqmdJBuHLpJTb3+KgGhbm4T72zy5Nw5yTNbp/fUDeYh6X56lxAEKz7X7AjoC4ts+4yYL/1Bg/zq7yORTd6Yu6aA4ddNsThuax1VmbGWSbAB+EWz/5Z3ge14kADobSZnnh3DP7SNcvz83DumBnh2HlCv5Sek0As/ziFNdIdxrcbzkdNVejAGrGzdsMw6REKLHqG3gd8cwtpwQmuJRgad7kuYhfX6qab3NEy0Ii073nZ8TShflg50h8f7VWgHIFnmV7Wl1KNGumE+Kxxv4t6642ZXTCcrfsCM2ekoJUNiAIKvXu0Z3FI62oiXwoCVUtGSaIRRW+tcHBPTv7MdXbW22bb/N8Ui7Uhk9Jcc7mMoiB3D8cPQYKaIPyVu8Muwyeun9YK98ymVdu6l1N6i/DAOAYA4Ykqe7cqz7Dai88+ngA5X3q3IK7PUT4Qwq/T3vTS+juQgsTI8fyOXhmzHYsLSw1N6vcoC9Ekm0syeuQj5tCDLnrXTkVPoiibgQn7PZmzvMe1jWPC9tqBfxIqjZ8ymYCGSCmmg7RkA9hhDcb3Kksg79sLd+ClmudD6FeeDg2IEJ+8s5izteKNman0+3JqKIOZKFK/+Qad8Uj+8fFnypCK3eKk/djCHJBW+FbBojfNjuyFc+3D4o+PkC/v/Nd5SciY4vS42lpDbfB2FgMnUCOz4lmFxwFSccuzwe8TL5EFolD0KIsEdqE0Vg6MJw9yVQV8k0PKwCBaimRAWhUUxAS+94T68Itew4nq2nnXfZHrOl4nAiPPmsOqiVCrW5FQtkceXEOSslFt6Xs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199015)(31696002)(6512007)(6506007)(53546011)(38070700005)(71200400001)(558084003)(2906002)(122000001)(86362001)(91956017)(5660300002)(41300700001)(38100700002)(6486002)(76116006)(478600001)(8676002)(186003)(110136005)(66476007)(921005)(64756008)(66946007)(66446008)(66556008)(2616005)(8936002)(7416002)(316002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NlpyM2hkMXp0WG04NFEvendETTBaOUFjUW5jRDM2dnh1Szg0d1l5eXcwamFQ?=
 =?utf-8?B?TUIxYXRlZ2pSMHcxWGk5L1hjV2FXUWxsVmJsaU5RV09zUDc4Y0JCeGVPQ29k?=
 =?utf-8?B?Z2Y0TSt1RGwySUg4bndDcm1WUENOa1pobm1UU2VNTEZIYzJMYlJ3MTk3a1VO?=
 =?utf-8?B?aDkzbCtZeElVNnROT0xLaUtJL1NxRFRiVHV2NVhmbXhsb1J2NmdBaWVrSHlQ?=
 =?utf-8?B?Q1pJTjkyMnVBTGxjK0tCTGQzektFOE41bGtEcmo2MHd6VVBLNFdOMUZRSDEr?=
 =?utf-8?B?Vk0rMVh0b3hMbUlxWCsyY3MxWFplRVpNVVpKV0tYcEhpdDhuRy9Bb2RMcUU3?=
 =?utf-8?B?U3B3VWpMOGRuY2FXdzg3cUhzUzR5K2FzSi83ck92SjhXY2pYdGtMaS9TYUIx?=
 =?utf-8?B?dVJWV1BOMEczTklHTUg3OFpUNTdNc3NoWEpCZHNqeGNxeTBJTkR5WWlOODMz?=
 =?utf-8?B?TVRsZFUrVklqbzVLNmZCSFdyamlqZW1PUHJteTcrYndER1BQTWV2RzVWM3Bl?=
 =?utf-8?B?QlpPUy9CUUxjOGl3RUMrTHFvdkdCZGttOS9WdkNROFJqVzhQNHhFQytGNC9r?=
 =?utf-8?B?UllMeFZNNHNsMDlXcWIvSGVrK2tzcTJVandidGYyaVNMRFN4L2RIczRTVUJT?=
 =?utf-8?B?QTRDeFdKMnU2dlp3VTA1WE1nQnkzWHZ6eitZaWxiUHRCeTNjY3RYVm0xYXhN?=
 =?utf-8?B?SGV0bERNcXF2OXpud3VpV1I0R084bCsrT056bWJMaEZsVTRFRGs5VlZnN0Y3?=
 =?utf-8?B?eXRJMnJDa1ZwVlloaXN6OXFxOFIySktoN0NvMzJaaGdJOUxKdXdmcXBvWnRm?=
 =?utf-8?B?Yy9qcG1tUGgyUi9GRFAvSE8waGZMWk9tY2k2S09XYUUwcDlxc2d3S2lLVXRR?=
 =?utf-8?B?THdzUkJaSmZzaVhsRGlkUHFkR0cvL3dISkdUYUs5WmtSWm9IbGE3MXJiRTh0?=
 =?utf-8?B?NkhCcFpUU096VjRWWDV6UnlFZ1NFZGFCZkFQVjZMcUZ0R043SDRjWFM5eVA5?=
 =?utf-8?B?ZjErbUFqZlBBTHhxbERERkh4ekl1Mm1BVGJYaFFxeDdOMnVJNlMvMFJjbHVp?=
 =?utf-8?B?WW5rcW16aVhCeHN1M0N3TVQycHdpcm5CbFNOSnhzTloxcHJ5c0I0MnNlWFha?=
 =?utf-8?B?cVdQTUs3VU1YaXVheWIwYU92cmNMejh2bWdJYTVCSnNScHJmTERQc21CZmxY?=
 =?utf-8?B?NkZpTkFQZWp0WFF5S0NGUHlGeW5CeThadStscmZhMDNXeFdKZE5ubWk4c2lp?=
 =?utf-8?B?Z0V5bDZUNDcwWkZnUVFFRDlrTXZBVUNjNDJMMGpXb1dicFl1ZXlyVXJhUW5W?=
 =?utf-8?B?OUFFZXJUR1ZBLzNEQ0lJYWJ1eVFQL2ZrS09jaU82U0NwQ3VYYnBTN2FuYXJS?=
 =?utf-8?B?b2MzRUpiNU9zVGl0enZralpXK0N1M1lFSWNLRXVuN0lRRWN0dXdiNW9ZVFBu?=
 =?utf-8?B?RnlOZ2MvR2c2YlpSelNuaVQwZDV3LzY5Q09CY1JSQ3VkY2krdTM4OWJDWDFO?=
 =?utf-8?B?SEZva1k5ZVgvdmU5bU9sOUJvYUlGcCsvejljbCt1OXlUU0ZQaVlnRm1lZFVL?=
 =?utf-8?B?R1I5Z3VLalNRYXlRK1NvWmgxL3RkTFdCRXFwUGhTbUxyY1Y1NmV3V3lmK0d0?=
 =?utf-8?B?WGVMcE9PZksvZ2VzUWNIcjErR3AycWlrNDhPWnFkTlphaGlwWnQreWRXemwr?=
 =?utf-8?B?S3ZqaGFCQURwYWc1L0tOZlVwUFlDNTE0cmFZSkdyY2QzejQyOGlCYXV2MEFZ?=
 =?utf-8?B?YXBMUGNmb0tBeDFKVCsyeGdJQU55UUtIQjU5bWliRDhzVFBCdk9zZ2krNEFa?=
 =?utf-8?B?clJKWWdTR2NJcjV5dHJXMExST00yYyt5Qi95cjRQOWRQeEdyQXpqV29TaFR6?=
 =?utf-8?B?NnhwRWtCc3FQOTdwWW1lSzNtL1pLc3d3djErMzVXbjdWWFhWL2xWMUF0cFpw?=
 =?utf-8?B?T0VRUW5WTm84WGVoTEU0bmZxTVBiZGFzajhTTnJDNEpzY3pJMWxSd1FzV1pn?=
 =?utf-8?B?N1RKV2tuYVl5ZC9rQVNFZVllZnFFczh6c0FjOFFuUEhSa0ZhMUR4SnFwOVgy?=
 =?utf-8?B?cDhrL0M2U05lczVHWWdXZzBBTk90cVBINm5tbUp1Y25pNXNORmRxeG5KTmNX?=
 =?utf-8?B?cnRpTGlFdGhQSXg5UDhLRGZnb0pnY2lFd082bVFSbEJUTzF0TktscjdOS1p6?=
 =?utf-8?Q?e9HNk5uTIXmglqA1KXpDEfIE+ik2tpH0RMRZvnCePoXo?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA703F752FD4A94A84CED8B5AAE3F408@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d92aa21f-627d-4f5a-2b87-08dac76de48c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 01:00:02.5944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uVZZ4B1ZfIY8JbtyTf3G8zj/27WSy7l5hIL79gTnw0b27devWD1zf73mFpNwYOj0i58jaXwbOZPMSllRrHz+cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8131
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTEvMTUvMjIgMTM6MjgsIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFRoZSBuZXh0IHBhdGNo
IGFkZHMgYSBoZWxwZXIgc3RhdHVzX2J5dGUgZnVuY3Rpb24gdGhhdCB3b3JrcyBsaWtlDQo+IGhv
c3RfYnl0ZSwgc28gdGhpcyBwYXRjaCByZW5hbWVzIHRoZSBvbGQgc3RhdHVzX2J5dGUgdG8gc2df
c3RhdHVzX2J5dGUNCj4gc2luY2UgaXQncyBvbmx5IHVzZWQgZm9yIFNHIElPLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogTWlrZSBDaHJpc3RpZSA8bWljaGFlbC5jaHJpc3RpZUBvcmFjbGUuY29tPg0K
DQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZp
ZGlhLmNvbT4NCg0KLWNrDQoNCg==
