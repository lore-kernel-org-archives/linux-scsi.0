Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FA1C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39F7960FE8
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhJ0AJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 20:09:06 -0400
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:29953
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230500AbhJ0AJF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 20:09:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oC1isOglQpKmIYGzLoflTKRQWPU792/h3SPVv3BhNfM7RuTxc+arsh7DRXRx7HbxN1ZTw/cky6SeMcoQvQmKDKf3TtQ81KWt5IZKwfcSpJCuz2p4b60CP/GmLJuamMBN/3/Ap647uLa4Me0SYFDZM3lF9UE7ma3b/B1674ejramyMFIa3cAaZTa8334XwlGaIhD2nkIDUCdurvZ5U0ee9JRgtfzJpmH8ZRqsQNKYhxIDiIwQf3KPSFBnqLoBHffpUaj2Nep/w7p+GAhw6opkk1Mdoxx3iHyu1WVyWUaLlca5hLxMO5XsJZo14J86BGHMiPbv/cnx2edFneEnf4zgCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xarRQ0WyJ7n3EJvMj0153QETAmgss3mVY9jhPAdMWe8=;
 b=jTV3xfTmjaF9/rml4gCmDJ1jNrUWs/+a761Dudfu8ksYZaQTQncp2KDOyhFxedKQ+k8rE6zUmfOZHHSveYdhGvYVv8Y9TKFUtAXubNNtwFoB1mxWnJcNEUVwVVre5xbVQq0sfh5Ce9aTFdenLeiq/sG5DsajqWTWqXadlSEY7jWGA+tS2Y6WrF1zIZ5t1yCnjthIom33QaHr7BXyuHBelmNgGKj70mhazup/YIP/trPWZfGaJZC+/TiW3wVqqun+obXxTbaE8aBTHTb1zyd0REWAPT/vA6mFh9aw5Q3ibIYNYnJPLZ5s5bjLtY2SUbXzt2voK7bTNuaAWTdAQT9boA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xarRQ0WyJ7n3EJvMj0153QETAmgss3mVY9jhPAdMWe8=;
 b=BBO7kZxJn6IxD05j6U1SS9ZDEoeFPbXCuJ1dmQJ5xP+CsHiDx7Mh7TXpK4SOSE+yc3GTDyhNcjbezeLJiRLh3KbH/ifwVamUqxIH/3aCT+Zc1pnz7ke9trKwHIi9zkHzy2f42wovdoYXuiqQAsOkFwJJcRAR6eKpJHmo/fFf3nQUoosJef/MOBPhFaPP2MbG1X75NAEXnZm+135y7e4Nnbot0AirVFUy8M5Oex+piRlWU30EfGiTf/A6E7N/dm0ZkU0c/9GfU+FuYhucU2VgrGxnHlXb4yc15nsUr6rA/Dlqb7Yg11r1QIGzplG3kR5agNELEagz4715qPmJmCmCxg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR1201MB0016.namprd12.prod.outlook.com (2603:10b6:300:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 00:06:38 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 00:06:38 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 11/12] block: move blk_print_req_error to blk-mq.c
Thread-Topic: [PATCH 11/12] block: move blk_print_req_error to blk-mq.c
Thread-Index: AQHXyW7Ej3kKMqJNM0WwOkVH1K3qk6vl+igA
Date:   Wed, 27 Oct 2021 00:06:38 +0000
Message-ID: <e3123131-fb96-1163-ea56-021252501efe@nvidia.com>
References: <20211025070517.1548584-1-hch@lst.de>
 <20211025070517.1548584-12-hch@lst.de>
In-Reply-To: <20211025070517.1548584-12-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b2a9bc3-5fed-43ba-103b-08d998dda5e7
x-ms-traffictypediagnostic: MWHPR1201MB0016:
x-microsoft-antispam-prvs: <MWHPR1201MB0016C6C446BAAE84A45D1164A3859@MWHPR1201MB0016.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CFZIqMRlBlqkaRDYblvM78oY5EMfcs7l+1ocULPIteiGnCTyj1JKLk1pWi7HmPFPkvHBDSCwI03b82fdYZfuuIPv1jd6cJpjkLHOKmn/Kw8LGVl3oMufVSOC51zRrGXBO68qOmmxOpkt3A2gGCddHIn9IhZTO2YigJ1tIR5JLszxLYhkEF1rNllQ4W9DQWahfryakHj4h/Qyke+rXZqyQzlpF273qzfg+oNCeYY5WUzRlyuTifj9cCi5GVPB+xLFjNY9bpb1PALGy3urD/Wtrw1xEM6dnd5knPCfz3nMnChrDL++mValeXfLFrOFZNd/hAbCilbpGmnTBB4jHNQlVF5Mz/5w11XuZxJGZQeKCcjc89L9PwX/5T9yKRvSe0vKzcINWzywbXs5M4qPb8J6pooT/Zr6mDBapJnoiuTMG8b2BQdhnqpPbOqA8EevzGl076bUE74V7OrnSS3O3d+9aus0gut40yqHK012d0ziLqsM+v5Hac8CH7MJUYRlcgHWfnTZkdrxBRyZqkdAv02IhycJWe73+eNWA+3gsw/byXx47IDv9KMVUfmFvCMIBFLVKnsiiUNEOtVieLo5YoKZPYmSLNxde/v3ohkitD06gwpkTgRIXT3kPunUYmb7Fp9Lg4AfK/5DQ9l8hiowOkLZUH4jqQ5lLXBXYMAiIB/FySdcoYAF827VBmdImfSBeLEBA8dPcKeqXvayedjdEl9DSWbxWDWY/nQ8ara6ARqGU8S4nQ3SnqQomR7dA6LsWO4kocvMJ2xbXE0tRKosoBwPbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(31696002)(66946007)(66556008)(508600001)(8936002)(83380400001)(6512007)(110136005)(6486002)(36756003)(38070700005)(558084003)(86362001)(64756008)(8676002)(53546011)(6506007)(2616005)(76116006)(54906003)(2906002)(31686004)(71200400001)(66476007)(186003)(38100700002)(122000001)(5660300002)(4326008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmMwUnFRbUl0VngzdFNqSDAvWnFhODRsVkVhYUlVTGNzOXg4Y1JMcnpmbklR?=
 =?utf-8?B?Rkp2MFR1eUxyVllLYmE0Z0UyakVEekxWc2pRclpJSjVjVlJ5TE85dlR4QU1S?=
 =?utf-8?B?S3ZXMGQ1NGRIOCtZaFFYL01YR1NZR0lXcVlOblcwOG5VVkJGeWlnVnNmVkhs?=
 =?utf-8?B?Z2lsdnQwWTZiVGtydXR1USs3RmY4WHAwaFN0TEcrZ0FFS0VRWmI1WFJ0S095?=
 =?utf-8?B?b1RSVnl4WFZZSDdpU2NiclV0NWdrK2Q5YUQ1d2dTUnQ4dVFWaDlBVlg1NHAr?=
 =?utf-8?B?dlNFYTdaRjZFNTJoclhJQUJjNE93WGRCaWUxQkEzcjJ3MHhrbkhpM1hHKzZi?=
 =?utf-8?B?aGVnSzZ0ZS91SzdVUVdLaEF6cWo1SjU1NHhlV1U4S2FjYjlPTnZOM1pybEVR?=
 =?utf-8?B?eThydGFIRVVlWmI2L2RYcDlaVjFwUXdDK096OUJKM1FFajRnYklrYVQ4K29z?=
 =?utf-8?B?cys4RGhIc2JjbG5Calg0Mm51WW1PY3RVY2pEUmRTRytSaXVDR284cTdSL1BP?=
 =?utf-8?B?YUJrUkNnZ2R5YXQ5MkJVN2ZEMGpodzRlZGRoQXJBYWFSdWlYTElsOWtBMllB?=
 =?utf-8?B?d2JsbmMrRGEyYjNuQllSRGxpUmxWTEptT3I4cndNT3l0bFFwanlVeXduTk5t?=
 =?utf-8?B?b2wvSWx4OGdTOWg5ZzdRT1hUTllPZHAvcEtTNzZkL1ZqYUxGNGdESWlXbGFy?=
 =?utf-8?B?c0YvRWlPTGRkSU02TEFPanQwb1hQdUd0YVhoSTM0MnhpTnBsR3ZpZ2JYT2Va?=
 =?utf-8?B?STlvcEU0MDZmb2dLWUV4YXpvUTNxU2M2d2JMRXRab0RQcTRWbVppZW1ZMGg1?=
 =?utf-8?B?c2pqVjlUS0MzNXEzcTk3WENvTmRMbXNaLzU3NlpGUExMWTJoQ2VRTHYzMXhL?=
 =?utf-8?B?UWRuTTJuK0lPZ3ErSUNWZEIzWldxWnBUZ1VPRittUWEzOEhXdjNiVG5BdlA2?=
 =?utf-8?B?eWYzcUNic1l3aU9UMjlBN0tFSlRaSWVIMGV6aVA3L0NMaUw0TytkMzJudFU5?=
 =?utf-8?B?SjRsMHJFbjJjTzJyMGw2Ukhzemtnb0xUWUNYaFAzc3ByR3NGTXQzSjZPMWE5?=
 =?utf-8?B?VnE0QjhaVXQzbG1KNGV0WTlDVk1OK3pLaWtlTXRMU20wRkN5SVNJSWpUZXJp?=
 =?utf-8?B?a3FUY1hOQ0RVQnZmdmloV1BScEZHT0o2MEFOY0dNelIxRXprRUVNOXgzS2JN?=
 =?utf-8?B?RkVPQjRLL3IrL3VJem1qeFQzdDFmandiZCt0R0Z4a3h3eWluNE1Gb2pOVXI0?=
 =?utf-8?B?WlZWcVVGS2VJd01GM1JwcnJPWUJKTW4vclcrMWUvWTRqOUM1N2ttZjF3dDZa?=
 =?utf-8?B?Y0d2dnB5L3FteHgrRm9NZW11Szk5WVNZbFJjVmNrVFlIVzVHdllvNGhMWXBU?=
 =?utf-8?B?RDlkT21jbEdjeEJuaDB6MjFhOVhvQm5ERTNiSWdYSFh0SE9CVitBMDM5enBZ?=
 =?utf-8?B?bVdPUmpzcmJZcGZYTTE0NFA5eTVwdHRkWmhNd05NZ25neVphc3hJblNGbDlq?=
 =?utf-8?B?aTI5RHltaDBvc2lTOWRadEFrYSs0VlBUMXg5VmtRMWxneDRqeU1OQ1VEVXJQ?=
 =?utf-8?B?YTBPRU1nUnpIQ3FRc0xDODYydzBLdU9lZWdqZGtjUmQrU2V3MFozdU5CcTlu?=
 =?utf-8?B?d1JUWG9QN21wbFo2WEVXbHU0YVFnLytDOEdrcEI2MkgzR09EeEo1NWhHMHVT?=
 =?utf-8?B?OXh0QVFLbmUxQTRvSDQ4V3ZYMHZuWXc2SEk0L0NmbEtIY2lqelZtdzBKREds?=
 =?utf-8?B?QlNXMXpNY2ZqZlRvdjcxc3Z6SXZ3Z1NJY1dzKzA5ZnBtTkM1WmJHT0gza1JH?=
 =?utf-8?B?N1JaSzZYa0tBV1MwNDJ6blgzdzkvRmtSbEhYMnhEQ1FLTHpibXczK0hXcDNk?=
 =?utf-8?B?SXZqdWlHOTZYN2RVQW9PT2Z0QWRVVWc1T0wzeDhKZU0rMWdycXpTQjk2NWh3?=
 =?utf-8?B?SWlFdUpDWFd6Rnpya3NQeXhnOVVUclRLTWZSbHhhSmZOL2N0bWw0UUNZUEZw?=
 =?utf-8?B?dGxYQjZMVTMyZ1NMSHZzMlFwMG5YMmRkZThBdTg4Uk1nYk9DWFU5eFFxUXZl?=
 =?utf-8?B?MUJWU3QrZFpIMEcwT3d4Qm1EcnFFWGJrT2ZwbW5ML3dSKzBDbTJEcGdXNDZl?=
 =?utf-8?B?ZDZZM1M2RjRtcnZBVFcyYzljM1dlQVBvMzNjZFhSMno5ejZQVXlESFZld1hz?=
 =?utf-8?Q?89U9pKji61rMyLqStUJFTzbahI9s0fxgWrIGysFYj+7w?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A99CB2142A706F48BE6CE1D4C5D200B6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b2a9bc3-5fed-43ba-103b-08d998dda5e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 00:06:38.6374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ldcd9+FFGIWeK0aTid8f8DD4iJAbUFKwSf2yWwQiR+NUmidstt5a0530bFZ4IzwHCNqeVY+LJ1Zfee1lK1c2HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjUvMjEgMTI6MDUgQU0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBUaGlzIGZ1
bmN0aW9uIGlzIG9ubHkgdXNlZCBieSB0aGUgcmVxdWVzdCBjb21wbGV0aW9uIHBhdGguICBGYWN0
b3Igb3V0DQo+IGEgYmxrX3N0YXR1c190b19zdHIgdG8ga2VlcCBibGtfZXJyb3JzIHByaXZhdGUg
aW4gYmxrLWNvcmUuYy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxo
Y2hAbHN0LmRlPg0KPiAtLS0NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55
YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCg0K
