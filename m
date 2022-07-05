Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C599C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiGEG1q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiGEG1p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:27:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C43B11160;
        Mon,  4 Jul 2022 23:27:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTgbJgW7kll8b6qd9Y4VWEoBZYUOxi1Wue8hs4IwpHz/SI+mozkn4WYSfHNuZe1/IBPBO73lrsttz0SMGqybrKfjeyJXrGCQxaHD4wOYz7Wo4Ibi92TsDrMbF2UbacdWQZpCFJB2nYneYlwylBY3wMJrUcN3vZ75RX9sPFzgiNDAsGdpSg1SI2WgpHyIB9aQ8GZGDjyfcNhpgIrRqx2kjFoya2QrbkCih3ZmymUSCEJBivePjH42R0e6DRQgbldHV/iTIFM/s98GVtNIPcPlswv2NgEAQGFlOhyNwS2a9otzSehNBrUZ1jkQ+15JXLpR4UrGl+C6HSh32V+ChQhbSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkMrSiYqVcPW3m8RT2/XqRSW7p89fx1bWcp4T1h79gQ=;
 b=FO5cBiOLAqs7QZ7hxJm+O5wYFB95je6jfzqASXkcDeXz4OY8J0pQ0+xYuVXGnTltL50nqfb5nHLL2DPQK81pp5Z9pZ1a8k3rhYTt0yo86zs43t2zs9/LLzP2ZhrO+3HtmZjm2obg9MXesoA8c2akZfZZbLpaED83fHCvl1DJaGmRSz+qP9bF8pnMOCNEf+Cu4DZUVPz5QFa9PQ2JweNh8W59N17UXdSVYlK6G0eLm2V1Psfaf4NnX054mtj4RC3Y3doz4jOhjSTtpy1LCbUndVZKicjBsSwEBzVJU1ts0W6AIz+NPhgOZUUNuuS2bcwyWgwqWOJPXNIcPSCMsBVZ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkMrSiYqVcPW3m8RT2/XqRSW7p89fx1bWcp4T1h79gQ=;
 b=ulF0uThlIBw8q1e3HMgpYhkUc+x0XwKn7ilT0Ffk1vyFhQaG43zFaI8wwiOnkf154O4yvWImU0w2Qg+czley0LJVbzPyuH2VcwXiq7XewePcd7ZhaVUY5kjdH8hQFQZT9vK2oIlbrq5sIBXeFQ3IsZtSXiVhLjxlZYL62W/ZikLfzseI+BA2q+0pMZ98YqOBXSc1vYJgNrwoOlfHE+rZaH/qLfW7ddd+su1D6gAvQ8EWPAdkuOn1yXY6RgiM5AfbxB7q6awuE3CmIhsLWzM0S5n2jizzpqucgse2qe1mRoJWcoEaZZLulFovXLRgBo66PNQcnSey/PVuWqljozO0sA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH0PR12MB5089.namprd12.prod.outlook.com (2603:10b6:610:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 06:27:43 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:27:43 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 07/17] block: simplify blk_check_zone_append
Thread-Topic: [PATCH 07/17] block: simplify blk_check_zone_append
Thread-Index: AQHYj6PzpYs7vaKvl0+Bbvh/T/B0O61vUWSA
Date:   Tue, 5 Jul 2022 06:27:43 +0000
Message-ID: <aceed252-2623-9e20-e288-9b9c66ab7398@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-8-hch@lst.de>
In-Reply-To: <20220704124500.155247-8-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e213c893-16af-4f44-d416-08da5e4f7814
x-ms-traffictypediagnostic: CH0PR12MB5089:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BUtOV0hAoj5ekb8cQHJl5FVvmVgguGaoTa+dFQ+DYZ9vhQfZUKsVKkMxLpF7zQ8EJvy7RA85UA4Pi5J1IcFXaHyo80ZCr+A6Bbz7xVz5vEn37v9fLmP0o4N281PZODiXABbNYEE/8nPYI5WTQCyka/SN4viAhJIdbKfEYg70UEqkNnt50a/uTZ/UpmcisPGn9QnH+9/UPXuWZOmbOQsWnM3TaKgbN9ZIBzPGJRl59APq7giGWIlIVTnaaJV1egyQ9sQkzfqz+BFghy22o9Z7ymxDdbeEwgaNHTqc67i+RpsCIpj12bC7jKQVz510Xi4k4xiJCECc1P8T7DlJMAnVfVjU1DUhvk0ZuQ65NKi/ecRSFgaejDpigu71qH+0laXG2l53UiFbXMTZZUQHBJ5MdHCQF7uJQQE93v/lLtZiXVPYFl28yHZAtMdTsYku+d2EMocytF4gTGzcB/5vk5vqXYKrhzOui4UxMVtRV/kBe4mstKRLcKsHNXn2uMvDLN4ZtZ0garvsBmYMvcI4tzblIY6xZGYkb0VMkOWtl+qBKfD5N4s+l+nMKinYS9jHExkQ1hKTYJxw8inlJP3XAg5eNUkJCinjn+rwjq6Zz4DKBTlhSvEKEnH9viOX23YxpTvDo58k3VYnWltepn97cU5fVhQWS7xsSIpZdaFmw33I46fyJM0b1XFA87dEHEcC2/Og9TBveT+CKenHf9v7FB5+wuoCYkSF0PBuGCOP+YTKyDZLCjz+BSaYAvZxcgGmdF1zRRwnTbg6JgAKP2lAIyihd6DqdY2g1ol6gS+SECxcTk/j8htuTapp6aXizlUOt/CmY482bF10cXjiPmQ58zPAfc3HNwAbtVUjpivkwGzIDpG+cwCQkopKwdQDB1b+6rwn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(31686004)(86362001)(38100700002)(41300700001)(6506007)(2906002)(53546011)(4326008)(66446008)(110136005)(36756003)(5660300002)(558084003)(76116006)(316002)(8936002)(71200400001)(186003)(6512007)(54906003)(2616005)(478600001)(31696002)(64756008)(6486002)(38070700005)(91956017)(8676002)(122000001)(66556008)(66946007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZU1yUU9hWko5d0NLcUFHVUZkWnc3cldtUGoyZnBzUE9Rc1VKUjJLMTIwa2FU?=
 =?utf-8?B?dGNtZ1JTMGcwckdsSXNrdExSdG5iOHk2a3ExT1Z1VzJwODVDZnhCM0dDVkJx?=
 =?utf-8?B?M1lSMnBaNFlzUkhaZWpGOWRHR0ZIR2lTeEszSklWaHV4YXF4U0lhdEhxV2pR?=
 =?utf-8?B?ZGtweU1SREROS3RRSW9TemlOSGFodkExU3I5cEVoVlRXaTdtcnJFSzY3dEYw?=
 =?utf-8?B?dDg2WjlaS2pXalJPV0t4Y2tCWVVWMnh5S0FrcnJmLzZCNDRGb0VOZnFJajEy?=
 =?utf-8?B?cEZxWUxPQ2puVG1UVm9uR1hBVld6cUVPWDZvRTRzVko1eHlYTTV3YWkwd3k1?=
 =?utf-8?B?SVJFT3BqRjd5ak5VZjdhU0o4MVpjdW8yellSaXAvSWZtYjFpaHhiZFF3cG50?=
 =?utf-8?B?MkFpenFmSCtuSldnZ2M3aFdyQmE2SmpWU3Ztd1hMS00xRWxFT05DcFQ5VkNx?=
 =?utf-8?B?T0Y3SzU0bk15VU02c0ZKZlNtUzM0NWVkcFlxUTRLWTBMOWg1dTMyTHNiZXVq?=
 =?utf-8?B?QW8zejBiYnNGd20xeE1Id3VZZFhvd0hBck1vazl5QmRIZjNPbUplRWZ6dWww?=
 =?utf-8?B?bFNkbnBzU2JPSXhTaWtaVDdSRW5TSkdJUzIrY0ZGeXhjUEJSc01LYWRDbUxG?=
 =?utf-8?B?M0dNUVlhcXovcTdZdDdjQkZOYVpYTmVvMk81aXNJZVA5ZktFK0p5eEFuRStK?=
 =?utf-8?B?dVRUUGxhMU9zU2JxcWNpSHVkZTZqVXBTZEpWR2gzK21kU0dlOHpzdUd5ek1z?=
 =?utf-8?B?OEVRSTRLWEovb0g5ZEtRbitBNzBJQ1p6ZG1qQWFBMVJCUE9HT05jTDdmd1Z5?=
 =?utf-8?B?dUFmenJ4cUVPSitMMlJoWEpmV0NwLzI4bjBZMkdicE9RcFI4QkYyU0ZvVjFR?=
 =?utf-8?B?THNPbHdvU3lZTzNIdU9MOE83NGRQUnFFekVhSXJvL2VEUEErL0tGMDJWK1RH?=
 =?utf-8?B?TUEzeHBNQUpTekwwdll1eWduNHMwZ09ET0s1WDk2M2Rtb3grclE2YVZUTnZ6?=
 =?utf-8?B?TE1ENGdUOXdIV3A5b2ViaTVjWWMrdmlQcEgwcjBOLzJvMFVJNnloUTNwQ0l4?=
 =?utf-8?B?aTdqU0kzdlBmZS9Ba1cvVmdmbmp3NzBjVzluaHpaUlNMTWRnWDJZYk94UWFn?=
 =?utf-8?B?dERVdTFWZUZNcHhiUkF2QnF1bkorQ0wxWW1tNHp0aHZWK3BQMEFnZ1FiQ0pS?=
 =?utf-8?B?MTVKczl2K0NaSUJWTTB4YWZKejlCOGhLRS9VR0xlYXlIYnk4Z05YSklrSFNY?=
 =?utf-8?B?Vkx5dkNHV0hNZUVCMlVQbmxNT0RReXlLY1JUVDBENkZ1ZlRteTA5MmNmSzZ3?=
 =?utf-8?B?WkhrdkJFRjllQ3dRUWdWckJDT2RGa2FIMWtNQWJNc3Q3aklyRmZEMTBYQWlB?=
 =?utf-8?B?Z0haMjhKei85cmlDTFgwWEI4TndIQ0dvNkRUS002KzRvSE5tYTJaNXN3cm51?=
 =?utf-8?B?WVJya0dFVm40bWNlNGNQWm00U3R0bitMTTJwbnFtMjlPTTQ2cTBGVTVBMEJI?=
 =?utf-8?B?cm1oTDdGYUpsWUVFaDJEeUZWdVNBZHFTbmt6eFQ1TmRSUkwyQWVSQUlBRzJ2?=
 =?utf-8?B?VjNxNTJCK2NNdm8rWnBkcGpxZzNiUFhINFVXUkhYWVNrQTdhZjlCM0xDODVt?=
 =?utf-8?B?bWcrampsc3ZrUE1lNjFRYWtNTWVwNnRLK0xmQW5GbENyNzQ3bjlSKzgyK0hq?=
 =?utf-8?B?TzFSRFR1b0UzV3dNTUxzQzhBS3ZwMmNSMTAzUFR6dEZ4aVpuc0tzb3ltTnlh?=
 =?utf-8?B?NmQ3bVA3K2V3MGowQVMvQllkNXBOcllLN05NYUVxK2prQThXWjJ5Qlg0SkZ2?=
 =?utf-8?B?VmNGakpZZkZZbXYrNy8wNzdnMTc2eFIzN1ZNcUgzMCtYc1p2YVFQWk5XQnho?=
 =?utf-8?B?c1dBODdQUjBSdkZMYm5YajJ5QUpleXNGUC9VUXh6YzZ3TG9zdjREa2NuTVhM?=
 =?utf-8?B?WHRqVmQ2ZW1VMTlnY3FEeDFQQTFSVjV2eWgzaWFxWVZrN2EzMUZkcFEwY2cz?=
 =?utf-8?B?d2JjSEVJLzkrV3c2VHFRQUU3VG1PK1haK0NqVUZxTGRHdXZHekpRT3hqeTNt?=
 =?utf-8?B?eW0zV2huNnFreStLeHlmRnREcUY3Ly9LZmhROU93RXJ6Y2IyRHRRSGI4RTNz?=
 =?utf-8?B?UlBCUWl2UVFpMDduTzBXWnZYM2p1U2k1RTdSVnMyZWxUS2hJUmZaNjdZUlVV?=
 =?utf-8?Q?AG+CDxsq2CECHr84Ru6aLYZDND+DfCrWCfPtHGoRYGG9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B3BC4058E7F2A409947556E1CFD2716@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e213c893-16af-4f44-d416-08da5e4f7814
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:27:43.6248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hDJSAUv9bE7o669hvqqg/0RwKw9D/woaTubeSPOJMMomxbo6C5FHo4baj2Cvr9WW+wJZu/HkguEFR8w842fynw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0aGUg
YmRldiBiYXNlZCBoZWxwZXJzIGluc3RlYWQgb2Ygb3BlbiBjb2RpbmcgdGhlbS4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KDQpS
ZXZpZXdlZC1ieSA6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0K
DQoNCg==
