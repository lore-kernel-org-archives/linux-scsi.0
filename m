Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1415C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 15:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238761AbiEXPPk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 11:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238797AbiEXPPh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 11:15:37 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C4B9CF03;
        Tue, 24 May 2022 08:15:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzh+RcdGz77Do/mxiDRbpixv1GniP4YtmaB86gcW7gvHh8qjYZvvxkQEFRwgGMxiRfGQjnSVSN0fVkM2KYudnbtnlcLkt097G7eMpYj24mUK+xO5F61orspchAfoQzsAPP1aamkU7/bWrvotPKYiw70BYVmTfZaqr4aEYTdA749jWeSyZfrkGtXvWUCalMJrXAvzFicwTu42Udwra64k2gRKD3MI9tsSrwhp4W+m1iBSFSQV7quGxvP25UYZy3zbOo4g4h8eEo/8H2qVZiKeDDWYjmA0rw6as28GD0y75vhM6W0WF9hCzmwfkZx4cwj1pV5ra11fwwM/LXkUlO0IFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRoHQZsvFv2XIFqIbXYP/IG3rT1d674yLsUFWUXKK/8=;
 b=YxZ+0f/KeJ6h0iOX1uQyBsANcdbXOJQhbRosA1bK9fVBGkU5jxncVouxgv00Ik2IHiFrd+wAo4YxyApp1vcievKiMLGndB8m0coAjRZkPXO6guYV/hk8viQmmN0YCSa5W933lmUs3PWqYyt69/3M5DZbQru1JyMMozc5jpB48J027oD2pGGSWCYrMw64QLASUBY3g5hWB1Op3Je8kKsXb2wuCq+8PvpW8xGZbHkX7PqNLSE/6AIf68/7QV+Onmo509EMpQKOsLVyWQczFIWhseRv1ZxwR7gAJInDgeJ1X3PloEYybyLq3ghFySNudOniYUI/Bo8gyE/nuAvs+GrgMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRoHQZsvFv2XIFqIbXYP/IG3rT1d674yLsUFWUXKK/8=;
 b=oDsDZ9s0pwuzXdFRGavMRZacxukedn6YGFXJMi0spt6cEPoUp3fooe6SEfuVDr5VgFAKcApJzPHpEowU+aF1z0FIyYD4zABNQSAzf6dcAiPccBZJmCCX0H1u2copIZ4Yj+rRjQsCvU/mrRxcOUa+POXKcYrXygCmvlCxSBAaI2juCHziDgoGIJUTV6mxWbZNOGWnjs8WCeGghUUQ/ntcy56faLewNFp1hX7Nsrsz3npxgwTRcUR8Xc+meSKCorApzKZ0kT5uToEqv9Y00ou3cj66hzZuFFQZCL/YuZicbl2Zzh/PXoJoB/Le+dnfgyST+Z2kbPuF5cFAYsBxN+HmSg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MN2PR12MB3501.namprd12.prod.outlook.com (2603:10b6:208:c7::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Tue, 24 May
 2022 15:15:28 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6%7]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 15:15:28 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
CC:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: return BLK_STS_TRANSPORT for ALUA transitioning
Thread-Topic: [PATCH 2/2] scsi: return BLK_STS_TRANSPORT for ALUA
 transitioning
Thread-Index: AQHYbzMZyFFOmbcYw0mQwshW+vC3Fq0uI80A
Date:   Tue, 24 May 2022 15:15:28 +0000
Message-ID: <a3671fb2-fb43-2437-99fa-256aca1c76b2@nvidia.com>
References: <20220524055631.85480-1-hare@suse.de>
 <20220524055631.85480-3-hare@suse.de>
In-Reply-To: <20220524055631.85480-3-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 362fd58f-4d25-45aa-fb7a-08da3d983c6d
x-ms-traffictypediagnostic: MN2PR12MB3501:EE_
x-microsoft-antispam-prvs: <MN2PR12MB3501CF9B200362B581B9FFF8A3D79@MN2PR12MB3501.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qVgHWrILQ0lbZWBH8zvPwDbiNUDmpIBDc9n2QzuYRlmcGRppVYQqz3qTbQJ9mjtIn/3lqPiLYUdq9v4luP5fChSWhZNJEhxCEcCTNz+zL0O+S6f/C7D5QBk1Ca4kqs01333JuoLVb7d03vOSZJHpl5d2zl4P/JE1POGttpYHnEdX5OL6cmZ51w59w+IuLBOHeq27uPLykze+pLv5km+FRsBdtWPvUMqxJ3SdX1IH9/r8hKPlCpSBbffzZA3dqui8BWN65I/iyFmKbZI9Xq19YUf8bkWIroM/o+MdNpooMg/LPIsHDn4TWJIvQycKAdi02KhNQltj4ygFkFO+IDneFawvuSUWOEgalxkRrARDa4ihljHHfGXl2iRbdDzKTJM6EfqSMZ816oal8QfFwexfyVl68d0KsPjFhZt0v9mtUTAyiKYcqP+yxhXNi/VwkCBq5D02T0GRP2sfW9bv+QXHGxPGUPDf14cgHBgFkvWnpIuTCDRw7nuMMTcNsKGZyJ0chLn13A89ilRONw5WwKrpYxAuQIyvasZJgdQQMwK2ExpZcc5tNS/H87F6EuZyaxTXs2YVEbewmTcvHtz/nxmdF3ccZxCGdOI9ltYXVdBvErFlUdJASdyJxReOXpdq+DOozkeYwKyAmJmng8aZgnKW5Strei8cwcK9dqJz5HhQiQrJaJjc5Xupu8VTxsM3xw2s3kWqHQC5UfsOUxC5FE1Pw2j+ajGx0h0zevtGC8FmRmKppqxwbOuXQ+RNQlxNFlWIW3DPk2IW5HxiW0qM9kYuSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(2616005)(6486002)(66946007)(54906003)(508600001)(6506007)(186003)(31696002)(2906002)(6512007)(53546011)(38070700005)(38100700002)(122000001)(76116006)(31686004)(91956017)(110136005)(5660300002)(66476007)(8676002)(36756003)(316002)(4744005)(66446008)(64756008)(66556008)(8936002)(4326008)(71200400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2cxZnczL3pVbDlHRlRGOUFGYU9VV3FIK0RhOG9KWWJXV3hhVjZocEJzVlNJ?=
 =?utf-8?B?Z2lWTnh6K2RSczZzV3ptUUFwbUpjdHlGV1VkS3MxMWQxck0zNlBYV1ZnVnFK?=
 =?utf-8?B?QW4vbUdTWXBuM2o2ZjJJVytJcTUrMVp6bEdiUWZzb1BjWjkvak1waml5bXJY?=
 =?utf-8?B?VStxV1czcEdtOWFvNjFsZEdQdGhiWTdVT0lyR3hIM01wcVU0aFdONCtnNk12?=
 =?utf-8?B?T1JaVkZ2MmtVWDJ4MkRVMC9MQndkRWpKaHB4U3ZHT1VrVEhZNzBaMVM3YzN6?=
 =?utf-8?B?dVh5ek8wY2ZSaTdlMjV6c2ZIQzUyZlNPR3ZPdHh2Wndja2d2LzlvSGcxYzQz?=
 =?utf-8?B?ZytkOFZtYnZXNzgrV3pTVlBYcExuWWUwVytSTXlMSUxiZUdTa0NOd2llWmZB?=
 =?utf-8?B?c0U5Z3lsWUVSWG9yTkhQYk5ZalM5MlBIWC9OY21zVExZRkxOc281cjZsU2ZB?=
 =?utf-8?B?ZEUwVVltYTVwNklwUEJoamNyU0FsdkZiN0lZcU4vY1B5ZVV2RXFwQTgwOGlB?=
 =?utf-8?B?MGRNS3NIZlhYcHdocWpGZFBUTEp6YTI4OUhaSmkxTCtZRnRCanpEaUFZMndI?=
 =?utf-8?B?Q3VlSXpQMDdjdy9TT29Xa1AwWm41aVVjdzY2bno5Z3dOc200enQyTm8zcndD?=
 =?utf-8?B?U21yb1l1TUYxdHVPS0dSTnpnQVAwbkcraVdhZE9hVUNTNHZ3eHdWOVV4U3F6?=
 =?utf-8?B?elFLUEQySUl3L3l2RDZBTVlHSnN6M0pPZEcwN3FNc0p4SkdmVFJkZDdORy92?=
 =?utf-8?B?d2oyYzNPQmxSM3RCQjFjdUZJMllUZGc2NWVHaDNxQVBiMkt1MlhRRUdpdjdR?=
 =?utf-8?B?Z01qM3lSRzJzU09Bd29oNGFFT2JMSDJOQTVTY3lxdk5QMjhJMlA1ak9najZs?=
 =?utf-8?B?NFFQa1RwcGxNM2dIWHRRbTJmRXVLeXREQVVWbmRWY0xNeVN6U0c4SWJTNWZN?=
 =?utf-8?B?ZmNuU1JYd0xzQ0lNN2hmbHd6RjZ4VmNCb0RucDJNQmd5d3BldExicmFCZVFW?=
 =?utf-8?B?N0YzMjJEelV6dEM0ZXVRdWd2YlUrZzlHWXFONlZyeVdrVEFhZWNwSU5qRUFL?=
 =?utf-8?B?OFVEekdueVROSVBoOWx0aml5VXJiclh5Wk5xZThsWlM4V2pIZmw3eXpwT3lt?=
 =?utf-8?B?VCtMbUhCOEVlcUtCNHBVMHJFTmJZVDNhL3NNdHVnbEFpM05NUUJtM01mVkRr?=
 =?utf-8?B?R1RjS1dNcHVPVTFmU0hlZExXWGVHNVNtRE4yd0Z2SlJJeW9nUWhOZFROclNy?=
 =?utf-8?B?YVJRbXNhMnNDRS91QlRnN041RmZZZEJCeXNaMUdqZzF3cDl3NmVUY3krUmE3?=
 =?utf-8?B?empDVHhsTytHcHZSWU9tWlp3V09BNGtOMlE0RUt6ZUM3dTNyQlR2VXpKYUho?=
 =?utf-8?B?dG4zR1JJSTgrU0h6c0NrbWxQejdCYlNDakN5cCtxeC81MjlFbEZTVG14eGZ4?=
 =?utf-8?B?aTRrRmRuOXJrT01wMGhWQ0R5M2YwbExoZTJlMTVkUVh2OExtMHV4Ty8wR2Rx?=
 =?utf-8?B?Y1RuSndOU2RHdCtveUpqc2xTTHFsT2JUNHhEWGVuMjhyRkNSS2ExZjNmRnB6?=
 =?utf-8?B?Yi9YQ0lCYm1xRm42cC9KRFZMek96bGJqSUh0Y29IUUYwODA5U2lydmdpMG5V?=
 =?utf-8?B?MEtkOHI2dG53Z2FGMVAwM0Y2MzJ0Tng4RWt0VEpDc3dWR1B6Tmt6a0V5WVpx?=
 =?utf-8?B?OFhUWWQ3czZrdkFKL20wN0E3S3ZFL2JScUZ1VDhWN2lUaDAraVJHV1l0WDZi?=
 =?utf-8?B?ZUhMYUd3MlNZeDhDMjY4UFF6bnVVQXQvYlpTZ1UySVRlUjFDdVBoazFoaW5U?=
 =?utf-8?B?dUplWmh4dU1MWEY1TWpaOEpPSkpsWmtBOGFKcXhOYTMwSDNRSVk4WG9Mai9S?=
 =?utf-8?B?SVk4OEovZXFDV3ludWJLZ04zRUZZdGJ4RWlza083YW5GRDNaZEZlSEJsWnNh?=
 =?utf-8?B?ZHRCa1Y1Wm5uajhQTExtUjZ2aDI4TkR2TDNoalp4c2llV2ljYlJnbFZtSjdv?=
 =?utf-8?B?VUhMVVhlVXJWSStZQVVXL1JITnBxSnFvc1U5TjBLZWhHQzFsKzJGRlQwNHI5?=
 =?utf-8?B?bVpkMCtuNm5mUHNabTI1NzloaVdmeDNuZ3YvbS9aTUV1SGl1czJLVEptQlFy?=
 =?utf-8?B?NmdoTEtoR0R0QmdQakJXTnNRZ296aFFXV3BCMWhNNnpudzlySmVHRkdaUzNG?=
 =?utf-8?B?TzZuZmZyRkZMQUplekRQNnRxOXg0c0g5RzFacXVIdjhTVWdEVUY4dENUWU5U?=
 =?utf-8?B?bTF1QnFIZCtIQWxKbW9YM3M4NjRGa3dQVkNVR05MbkFqUUV0d0U1dFQ5cWxR?=
 =?utf-8?B?UWdyeEhsNHNWY280U2MwNDdyTjV1SXhiaDhTSGp4c09zRE52NnpKZlJwOFpO?=
 =?utf-8?Q?gRFktLBGWcsFuVOp81HSDW+KFoPY5fDK9lm/c18SIpXo7?=
x-ms-exchange-antispam-messagedata-1: 1lYFS4sYKUQRDQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <00AAD1F468557C4FA9B0DEA67A95B8A6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 362fd58f-4d25-45aa-fb7a-08da3d983c6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 15:15:28.3885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x1ubcpg6vT6t02+aPK2yYQZtykMqBcFzh3LgveOeW3sPt3u6m9nWesQMH8nfVDw9UaCAPAgLzfjF22afmNJw/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3501
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNS8yMy8yMiAyMjo1NiwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOg0KPiBXaGVuIHRoZSAnQUxV
QSBzdGF0ZSB0cmFuc2l0aW9uaW5nJyBzZW5zZSBjb2RlIGlzIHJldHVybmVkIHdlDQo+IGNhbm5v
dCB1c2UgQkxLX1NUU19BR0FJTiwgYXMgdGhpcyBoYXMgYSB2ZXJ5IHNwZWNpZmljIHVzZS1jYXNl
Lg0KPiBTbyByZXR1cm4gQkxLX1NUU19UUkFOU1BPUlQgaGVyZS4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPg0KPiAtLS0NCg0KRG8gd2UgbmVlZCBh
IGZpeGVzIHRhZyA/IGlycmVzcGVjdGl2ZSBvZiB0aGF0IGxvb2tzIGdvb2QuDQoNClJldmlld2Vk
LWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
