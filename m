Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A483C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 23:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D020560FE8
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 23:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbhJZX5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 19:57:37 -0400
Received: from mail-bn8nam08on2071.outbound.protection.outlook.com ([40.107.100.71]:51616
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233833AbhJZX5g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 19:57:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlAInOK09z4s9Iek+eOg830+LwsGw+vuCpEj0oK3Z2ooz/vU07ZsoJTfQWhvHQD/zLj8kDrHG4wKET3DJBZHk42e7bO+MZ+8Tcxy0Yo1U3jMkpYOL6tQONTMDpVQy7F+jHmNiw7GwWWZf+R+8Yi4ITcVN2wUbOCEmN/j4pWEDsBbjBjHKy5S7ga3t6msRUSvVgsTbfMTXxkcHXSjUKRSQVkktxsXBSuZAHP/u6OdSdQNIoAM1KHjCSN2SoKpX8WGQ6OPAg3u3aT2TAL25PQBxDS0H47pXm2sPLaSnH2Zh8D2kAO+OmMcfU1NMU6RoZpDaWQHZawNlpvWyBFMAsfpRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1VV98xbZNPH7dqmC8KU4L7m56U8PvTTB158klKn/MI=;
 b=aXsBdaouKWfdk2mOV3Bf4zAsG5VPYGYnehXwzo3AntWseqTFpfXU97sjDmJR+bINgq1bTi3qUNYPuZKT+L7cTdJhg6QNNwX8zXkL/PPHxD3MIOHHRLhOpjY6S02zRbOM2W8X4VdPrYCjnh6MTO6INmUIeQcLBnlWJg5AsfXaAkJarheUBCa2hg+TdFp8XsztZfKZOQiWTaDDeIf6kYpeWBsaRyr7Y9gWnxrl9u89l44uEEUAmBt/BduI/wZ+JHflCnOma//lYxTsoLgF2IXg927T2ft9k3PrPHKEY0Admg4mFFX65IXqOBtu+luB8vGOKSNGe/qEMwtyyMupaHQ7YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1VV98xbZNPH7dqmC8KU4L7m56U8PvTTB158klKn/MI=;
 b=FdU6J2JFW493q7KLbsJvE7c/7tIxGKK9QZrKIorkzqv7cAHLPzZIdJ1s62jlTzAr1ACtispq7NqV/ciRD/wtNCICD3rF32iGlWWSLwiuVBwGT2yFN9UdeABy1zlznIgFdlIOakISd4q5UM7hkzQkIzzsylOTDZCAEdFnCgB4FCz3BOf46bfXLNPI8Kzx0DbMfFwMnoW1PLL9w10Kz4TExR2TaxJTs4axNh0S37u6xogMFwSvAvx4e3djfOlI2f8GRROnSHLTOfFNqpF0ZS6l9LI4wNDhKgD0Bh2xihjudlwvOwlXcMu/Rz9FEJwYoWcRraEwqs9c5fqfGo6Q3l7uMQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1566.namprd12.prod.outlook.com (2603:10b6:301:11::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Tue, 26 Oct
 2021 23:55:08 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 23:55:08 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 01/12] block: move blk_rq_err_bytes to scsi
Thread-Topic: [PATCH 01/12] block: move blk_rq_err_bytes to scsi
Thread-Index: AQHXyW622C7FLy0ytEOazH/alslcZKvl9vCA
Date:   Tue, 26 Oct 2021 23:55:08 +0000
Message-ID: <e93f8426-7871-7967-283a-2c98526b0936@nvidia.com>
References: <20211025070517.1548584-1-hch@lst.de>
 <20211025070517.1548584-2-hch@lst.de>
In-Reply-To: <20211025070517.1548584-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69839579-30f6-4054-4421-08d998dc0a65
x-ms-traffictypediagnostic: MWHPR12MB1566:
x-microsoft-antispam-prvs: <MWHPR12MB15663A5A92548D65DA5F8316A3849@MWHPR12MB1566.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:639;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RvdNIUS9MHrdSVJ3Ir0DhTl2QVlOLUJuDN8KpNsxqCRf9IHdB5GcO3DoxfMiX44cCM6CYW0uxqG/wcl5wAjzh3iaq+KRLeBsZ2bcheiT9EGXi73EPTgkBAt5c7x+XtvRbfFcX7eGTS3UzNYYQQqTTTXnPWF7y/ppxT+gdFioEI60T6ovgYxyRYfsBsHy+hrfrxiHj4z+xkevU4bKV5st+LzptW5FoiPYqNqOCquEutlL3jyXNOA3sMbKf74hlvy0LTu0Kx5lGtiOoosrEQKdyw77Gu9TcxFWHdofkCoKPW4LxHDieOYdmGZU/L/WYp/qdyI0DFJ7XVnqaWT6IREQ0M/AB0HFlHV2NuR4WLmGlKmCmZSM/25K08PcFqGSfj6lSgl3uuQIf2c2XNciCsp1nJ2JXIVo28huX1So9GcmlZCPimDnUUSVzAXmF9M+Bx9eG0Zoiz0VLWbc5VWBC73cyawOTRIUHh5+96kkJ2II3yLDAQiUyciChkpwThT2zA4xJ9S9YJ/lBuDAHugPPce4XNu7Pa5vO/Mj4yRll7tLQ+wgFELX/VGt/nhhhnV2az35sQRLZUd48P4Fpwq+Asr4Njm+k361UlnvkJNXAKz4t6ANFFEFPnsXaKMAfK8ayQeWwQdRlRq6YOjzZLuH9I68/TnSE6l5X7s4CATd+f/j7i7rteB+KPncOajWHl79jkF7lNRRMhZFn7lDc+sYCEn4XSPMECTnE6J3cG6xbwd7qsy4+qnV7TeKIXwXH1+fdhyh/hCeMzLLVrl11+l4EydsMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(38070700005)(54906003)(86362001)(2616005)(122000001)(6486002)(71200400001)(186003)(6506007)(8936002)(6512007)(316002)(64756008)(66946007)(558084003)(5660300002)(53546011)(66556008)(76116006)(6916009)(66446008)(2906002)(66476007)(31686004)(83380400001)(36756003)(508600001)(38100700002)(31696002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTh4VE9PRkVVcW1MMy9kVEo0d0Rtc3VNRzRBd09WQk4yL3g3NVh3OTMxKzA2?=
 =?utf-8?B?NGo3UDl2cHJUMlBwQTAwbm5XamVpKzNqMWJLSTVlR2VQT1l5NTNldDUxNWUx?=
 =?utf-8?B?MHpvbm1uc1lpQVdkRlRjTmZndnpzRVFnVExBeWpxdENHaE1qVWtoRytmSXVq?=
 =?utf-8?B?NU1CVENSM29PUFBlZVBoNWl5U0dCdTk1ZjVtaDdiQmxJSXVGajEwOWNtc2l4?=
 =?utf-8?B?ZnNxTjhobmVzWm1zWE1CaWJidmllUXV5ZFJXUFFYMEZadnVhd2JCYWo0NFp3?=
 =?utf-8?B?OEh3azJoZmhNd2xXamNWbUdPSVI4bzRxazBqRUxVNXR1UjV1NnRPRXFFR2wz?=
 =?utf-8?B?YWVZcGtlSFFWWWhSNlRNUHpqUFB0T1pEUzBqY2ROTmFFZXI2QzlydU1NaGZ0?=
 =?utf-8?B?Nk9BZzBQb0RMRmwwdHNHaURqZlhYY3NTa0NRRGFZNTFwWE1jdDNLNWZwRmtl?=
 =?utf-8?B?UFQvMEJLM3FYdFNKeVVrKzF3WjY3dUEzUjA4cHVEcnF2VlRqb2xTMHpWT1RS?=
 =?utf-8?B?Tmx4SUF5V2poeU1Pc3pOc0pObzZRTkprWThUU3FQNVcyTU43bVEybjlOcCth?=
 =?utf-8?B?NE95SG1HQURFb1kzRnpuWjRjc1dVaXNnaVJZa3V6SnpnZTdUZUVzckJaS2ZK?=
 =?utf-8?B?VWRTSC90OTV3TERpU1lTYUd3aC9jY1g0TW5udzloSmpONi9mZlFTMGlhQjRV?=
 =?utf-8?B?bXUwSUt4RWk3cE8ySkgxcFg0VEhwaGxZanhkKzVGYTRjMytRT0lIQy9qVTdz?=
 =?utf-8?B?MFNwMnBVRVhWTVBLZFEwbG5wMm1UMWdhL0M2SXM1aFg3L05UTVh2cUVoSU1V?=
 =?utf-8?B?R2RyeVhRUVhYcjBwbFhEanZMSG1Ga0pwU3RJREEwYkh3b2ExY3BGc2lYS0FM?=
 =?utf-8?B?dGJJdXdnc2ZybnU1dTdpV1hVdDgyeERQb3dUZ2pUdEtFdUpaS3FLc25oR3U2?=
 =?utf-8?B?Qzc1WGdzWWd0OTh5NDFaa1JWS2t5MVVhd0NNN3gwaFQyK3FUVUh6cGhhNEF4?=
 =?utf-8?B?N0Y0cFlYS09Na2EyWHdxSGY4SE9hYmJ0R0ZDc2NvODRYWUxhMHBlK2pRZWto?=
 =?utf-8?B?aEJPcGRhUjhzZFRhWjNudWpFWEVETVlFS2VzNzh2N3FMcUZNZ2RaZ2hwTWRy?=
 =?utf-8?B?bFZoMXVXNWFMeTVDUmtoTFh1bGNHMG5IWThYc21qK1gzakVjbXVYbXg3Wk10?=
 =?utf-8?B?bXoxQWVGVm1pTEFvVkQvcnRkNk9MRDExRkZBdVdUN1NqaVB5TWNSSG9CVWZk?=
 =?utf-8?B?eDhJT0dNbzhyYUNhdC8xc1FEOXF6dmYrdXRGZDRlOThVdEFVRm9rSlVRZzJP?=
 =?utf-8?B?MDg3Z004QmJJQUpVSE9ic3Z6TzJNeUZWUndHV1pJN3g4RGNNN05PY01Dc0Js?=
 =?utf-8?B?ZTdFNFFCWEFVLzZnaGVpMVJtRTA0S0liajZwZWpQc2tPVjRMVmZDcWxwcXpE?=
 =?utf-8?B?SzgrQWVZRTVBb2x1TG5TRStCUDdQZG5RSEEyQWx2Z2Z3VjdOSHdTemNXaTdR?=
 =?utf-8?B?VlJORnZScXRTRnBMdDJTTk9zZ0hnMTltQ3RZTGRMMjJJSjdiNjdUS2ZIMXds?=
 =?utf-8?B?N0kxQXkyWm5MU0xXaVNPbUQyakNHSVVpbm9UcWJUME5yNnNDREdILzNqR3FL?=
 =?utf-8?B?Q0Q2SzZMdElGdno5KzNyY2tROXJCUFpDeFF5bXJUS214M3dSQ29vMUlmZ1JW?=
 =?utf-8?B?eS84VFRabFNiVE94Y3dkK1Y4bEc2UzJyWVVrVmVoZ1Jkb2d3d3dBcUJHL05u?=
 =?utf-8?B?cE9GMitIOFNtbm5uN3QzWnpBZkRscHlmeWhxYjFQVnlxZHZjUWp4RHJJaUNS?=
 =?utf-8?B?WDZWRFBWcHRGUUJ2d3orekoxYkt0bDRyMVVza3AvTVE5bnBITkxRUWM3bWlC?=
 =?utf-8?B?WUpyN3JUTEt1NjRpbWpSS2ovRk1tSWhZdjdhdmdQTGIvcForOEJmdSs1eUdz?=
 =?utf-8?B?SUFuYm5uSmEycVF6RlFEejhkaXh5WWhyRjZEbndTMlVVTmZZNUVVTlRwM3Ur?=
 =?utf-8?B?ck92VVcrTEhWeTB4bTBpUWZLZzRSbkxFWFlDS09sWkJTVTFMaVpVckw4V2tR?=
 =?utf-8?B?VVBWM3ZQNXh5V3JlYXNnZTJlYUZMMkxhQzkvL1phZ2RhQi9rUUk0WnVqL1R3?=
 =?utf-8?B?M05xT2Q2c2svT1dRT0VtdnIxeUhuVVEwZE1reFlTSmVxT2VQN0ZzOGdaOEZP?=
 =?utf-8?Q?ttFuz5D12YSLw8osqfMBrvu2IU1j3pQnbK9k7EWjEn9L?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1E4AFB6526AB1408EC82F1B4860AD4C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69839579-30f6-4054-4421-08d998dc0a65
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 23:55:08.3532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pE/jyI0569WV46ySmD9fec/DR1GqBZRfKvcw7q1hEo3Z/G9l2AO8F1yWCG4Aq4l5JNgsccfzRWA0bWvNyFqwIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1566
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvMjUvMjEgMTI6MDUgQU0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBibGtfcnFf
ZXJyX2J5dGVzIGlzIG9ubHkgdXNlZCBieSB0aGUgc2NzaSBtaWRsYXllciwgc28gbW92ZSBpdCB0
aGVyZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRl
Pg0KDQptYWtlIHNlbnNlIHRvIG5vdCBibG9hdCB0aGUgdGhlIGJsb2NrIGxheWVyIGNvZGUuLi4N
Cg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52
aWRpYS5jb20+DQoNCg==
