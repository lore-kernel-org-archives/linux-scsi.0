Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F5FC43217
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 01:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiKPBBc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 20:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKPBBa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 20:01:30 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2060.outbound.protection.outlook.com [40.107.100.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A0E22B0E;
        Tue, 15 Nov 2022 17:01:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtnhNNOKgjOD6ciFERkhPnDgg2niD07MBi652lTy9wS11nxL/VaeHm202xcfBjNBf3+JoBAuXa0m9Z2vHsazABrjto5Q0yD3tErl9W9GjmdXrgPVIzPkBG1FDBHx6lx6ucOUXqVOfMXjJrvywBhWa+CkwIool/E61+rBDpeOegOX5i7EjnoTLhx3aZPrnky1CmWdCf7xKnO03k6I2DWcKHBHKbdZvdzZeqE9zPyMk5dUvEsPs5OUega5ToT02N6smgllahcoR7KPSzYOcy8dAH0k/RhM3NgCL+n7EO8gUQXgXRXhU4j9jvp2T6znzlzI7YdCen43IRsZLIxuWw98OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67dZZ8EsXCxBULhqNlOhB8OIXaR9yqLVeckL2ry2eIs=;
 b=dZ+TCcxsFgVZU06jI+VNF4qbbx8cvSqQX24KIBP58x3x9Q2ySKyboEhaqtILzj9MOBF7Mex3l8cbrm1r49XXGYHSgmMLPB88LLmzmQw40Xcbe2bHffuYFaZoM2AhZR+iA0FADGSZ7HvUjm2y0PB8VPhz66rERiVi454F6H8nLA6D2HVPxrTBgcy9CKJy6KiNTKlxQ/vC93a1muIzQr3brHz3oayl9k6CZWYG+13ch0v/oKldYfMDrkTEImCEXXNiFdELJYhtP2aU2RKpgIt5fwcoeDInMHAoTa9x7g3qfVHoD73oBfDyQpTaY/1DNFqdi5d5D2r73wkCxhwnRXImxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67dZZ8EsXCxBULhqNlOhB8OIXaR9yqLVeckL2ry2eIs=;
 b=bN/EllIfkrIMpaktynFfdPk/2ofOdv+e7JaDLpO7YTDBYv91yvhPSL9jFn7DEkCzbEiAcpyx2SnWyK4SiH8p2iMw3edgIBu71V1Z7odcG76sw/MDkSj8WqnOUh3U6ljUuSRijpEUM+7quxM/ZaStYwp5sDKioNa4VIi+aLpn0++DJPivFX2q0/j+rdNssIFk9V/QDjG5oA6pQlvOw+7aV38Q6F7ogo0SkcI8e2K1Q8htuAemj/GP0zqZ9w8wUNTuNDYOZUnaA/BkBapycoKI6fTSYnVJSm3Yq2HtX0+G61emPz6VrtZyKId5kiHB4/ofoKn6Vvo1yBYtke2PFRLwow==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4114.namprd12.prod.outlook.com (2603:10b6:a03:20c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 01:01:27 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 01:01:27 +0000
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
Subject: Re: [PATCH v2 3/4] scsi: Convert SCSI errors to PR errors
Thread-Topic: [PATCH v2 3/4] scsi: Convert SCSI errors to PR errors
Thread-Index: AQHY+Tlf5CwY0dj4GEeKungsJ+r3Sq5Au3QA
Date:   Wed, 16 Nov 2022 01:01:27 +0000
Message-ID: <5f471168-6f8d-7158-5a7b-049db282da1d@nvidia.com>
References: <20221115212825.7945-1-michael.christie@oracle.com>
 <20221115212825.7945-4-michael.christie@oracle.com>
In-Reply-To: <20221115212825.7945-4-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4114:EE_
x-ms-office365-filtering-correlation-id: ec288b12-d00c-4617-fc60-08dac76e16f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ROKebsKBXL9yUzvbljl3XxBKfxmH4QBL3cMN3raxMtBLu0/6OToIazej1yp6wHX3ZAwG7R720x/ICHwECzbToHp9a93Vsz7sb2EizchDSdbOcGxYQzI/tF8PkQdFGtU/REgnkTGA7xuaJ8o4XCzd3Bluo6pVi+U3b+VpqT2re5g0vOs6Wo0csIhuwUlFHUR64tc7l8iduQYMc0uGnylIF8EUknjdtv3F7A2GpMVTmy2uFSEMIJgVb0Z6rRI58TTCj5Ls1vmQPZX2qny44cmyQ2iHAjPHTd9Y3jtBBf8UK0Zu1J3/9DevFXLPGyGqRGs7f+W4+4Z9+6GV9HbQmCaJanEcTgsMlGquBAhMdysuRx5jtuYn/qNmu0X2fOhithcf3GsZ+qO9Dpy16qo8gH3iLtxYfFr+yp1G32kCPJFSzijBBevyGxyOwbOfpjsEXdfmrvo3nIbIDCLkljL6/UatQ1u7/pGLzzowmx3Bfquvf3ezBEV9GtntpjzbNOxCtxYC5CNEk23eDlyB0Rlun0GTgVN0qcUJroAl3aDyb0mJb8C5okaUykN66Jjtze+uKSH1LU030YvfWH4H8Jf5bJcctyEyK+naoEQXW6qt8DqSkLyEhJ/SuwWBGEazKXMSNwzuaFHa1kyEIJde4/bLDC/BOV/8sanfOErWbuEbJ56i1nRmVc2dmQGNT3/VmJ6NADdyTAw/VjN9HOXeRlUnbHXasikWb8+UFp9P5EAQZtg1rDlWuk6hP98lNGfpqdo9i/LFNl1QiZsBi5xCTZ9agisp5EayqasKHEVhBAzkJnguz3kIpHFGxSY57fnfUEXy/whvLlCPxaLCDGFab7k0xYQyefHgQu4HA3+B9E8e1HprVk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(451199015)(186003)(2616005)(6512007)(71200400001)(6486002)(478600001)(53546011)(36756003)(110136005)(6506007)(316002)(38070700005)(86362001)(31696002)(38100700002)(122000001)(921005)(66556008)(31686004)(2906002)(66446008)(8676002)(41300700001)(91956017)(76116006)(64756008)(66946007)(4744005)(7416002)(66476007)(8936002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVpVNFhoZnAvenNNcEl5S2VjSDlaWWhZcTRRT3B5dHpWYkw4bXZCcCtqamJq?=
 =?utf-8?B?bXBiZCt5MjdGa2hsTXJINmZPRW5HQWtpNXE2S2lEa3hoOHg4Z1B4dENRZUQ1?=
 =?utf-8?B?bjRoZWlRL1hURkxwNXNnMDNMMUVMNkRqQVFvUlBEQkZQdFYzUkxvekpkZ3R0?=
 =?utf-8?B?bzM1V3pJOFl1Yjc1TUNIS2FDMUthaWtTYXlNazNDSHFmb1o0RlA1dVpwWjNO?=
 =?utf-8?B?cXBSeXhIUzNhYkpjeDlHRHNZK0hpYlpoR2pSNWJtL21Mbm1hTUZmQkEvUGN5?=
 =?utf-8?B?R1l4bjZ2M0RURXk2ZERiQXlwcHlVOXVhU1RhVkpMazlpdU5aRW1EbzVUanJI?=
 =?utf-8?B?anFwREhwTklNcElRNlhjZDJHUzJiYnR1UjZvcGdIdzF1bDdSbU5DLzdYOC9k?=
 =?utf-8?B?aXN5NXp1SlY0WUs0NUFPRUcxeHJnRmRUeXA4LzhFOS9SaVVOakIwR1p6KzhW?=
 =?utf-8?B?RHdydXZzRXZMa1N1ZVZOMlg0bmZKZFRaZlZoOTlIOGpVRjQzdEVyckJyNHFL?=
 =?utf-8?B?SktBdjQ4SXZkTHorM2FQNGlRT0lmcmNvRFk4OFRESHJpQ2o2eDRmaUNaQld4?=
 =?utf-8?B?WDBmVVAvdFFhT2ZDV1hiV0RwWkpGaVZkMWprMFlvd2N4bTFkRndVZkM4S3hB?=
 =?utf-8?B?S0x1UVUrMm92c241Uy9vNHErL1dzcTF5cEFCQ0NzQnc1YzdGbUE0RDM1WVVv?=
 =?utf-8?B?SitHNkhQZVVSRXNna0xvclYrNktzOEVmK09yRnpWTjdUcnVmMGJLaEZML3R3?=
 =?utf-8?B?Um5YengyZGdqRHhjNWhGYk1GREdyRytIT1ZPeFJIRGN6VW9QS0VKNEEreEF5?=
 =?utf-8?B?M3Bkb2pUeDNlWUNIUDM3UWJaandKR1JPZEkvSC85eHlmdnFrcHhKNGtZSVlx?=
 =?utf-8?B?bVV2RXcxYnpBUjBWRnRxWVdaV2lLVE9FcnZKTnJtQ1QxUklEbm1jd3BvZWcv?=
 =?utf-8?B?b0hDdTVNek9mbGkvdzVLTkFLWG96QkVuLzRkZEg0dStjTkFEWm9pdkFEWlFP?=
 =?utf-8?B?SHArK1BJamtWY290TzVlVXRod1N1aVZiN1Y0TFdtZldSc0Fqd1V0YmQ0a3Vp?=
 =?utf-8?B?S24wRXVkajVQbVA3MnZ3bzZjanU0dlE1MDdFM3hDMWlEOW40OThMb0ZvQU9I?=
 =?utf-8?B?d0oxRmh6UXNpWHpuRlducHZ5SkxLQzVWLyt3ay92Q0pqTFJJYktVQVY4VWs1?=
 =?utf-8?B?K2FsVUs0VDZHSmp5NjNvZ2syS1h6ZHdwYjhOeStFaktDS0RsRjhEellVeWVO?=
 =?utf-8?B?ZUFEdGZmV29xVkZ6cFprOEZEZTJHeTY3MWRELzdQU2d1TGhTV1NQRjZWMlBK?=
 =?utf-8?B?V0ZCbGF1dlQ3MFJyZUtYUUN4U3lPbjBodjV1RS9aVWJmR2FQMWhvK01kSkVw?=
 =?utf-8?B?THhLLzlGSzZVWm4wSFBXOUpQalZCc0xXelRUQnVCSUl6cUM1RXdrQW1URGtn?=
 =?utf-8?B?Q3RMSXh3dk13MWk3eWV6bXc2ejk3VUJnTE1BV2tnellzbmFxd2NuOXlNWFN4?=
 =?utf-8?B?bjg0N1RWa0h2NnQ1ajF1U0FOdHBxZVlMREcrUmdtN2JEdlFTZEgyaTdHdFhz?=
 =?utf-8?B?R1Q2OU5vdWFSZms5UCtXMndieVVUTzJYRGJxOGlKNjZ1S3RKWmNFcEh3dUpF?=
 =?utf-8?B?ZFhpZHVvVUpqL1liRUJ0L3IySlJ6Sk1IS3ZRQmh4dy9lSEdxeGxadGR4Z2l0?=
 =?utf-8?B?a3BhdG1RY3FQSUR1UFkwTTZQWlJJMjVmZVREMjAyakJjYVg2ekZPaGZUcGNM?=
 =?utf-8?B?aVZZc1FpQk4wZS9TUEFwN2QyUks4L2dNc29WVDk3bmhQck1FT1VycnhZM2R6?=
 =?utf-8?B?Z0FWT3ZGZVpFdDRxdXdNZ3BlcXVtRGJaTzlyZTdxTHZsQ0NBNTNnMS92UGti?=
 =?utf-8?B?bGhGaUZTMTNacTlIMlhocFhnQzFGdUFJMExmN1VjNEhKa3hzNnJOR3JvcWRY?=
 =?utf-8?B?TWs2eGI5d3p1Wi9ZRE5WalZadjhocmwvSVNxMUpYRFNxWmgwZE5QTmgyZEgr?=
 =?utf-8?B?YlQ5NDhkeHJjTXY0WDRQSmVLcnlWdUtjTkVDRURPc0w3YkhNNU5abVNvMDJt?=
 =?utf-8?B?K1dJVVIrZ1NvdkZBNzVQTVQ4ak5od2JPYld3VEdwcy8waDRtR2JSVGFsdG5z?=
 =?utf-8?B?TlVzSlVjMXd2WlFMRHJ1dit4OXpITmVQNHRPdzZIV3h1UHA3RkhhNXlveXR5?=
 =?utf-8?Q?IdqpC2YSOZ1UMnNY7rhO6VFmVWPbPyAa6S2Rho88vZBQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0416F4FFB135149AEB96F14D446A125@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec288b12-d00c-4617-fc60-08dac76e16f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 01:01:27.1361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8xaFRxpE2lELv32JNEbmUBfalf1DJCFipwN817Plmz88E0CZNm7trnV4d8a2XKa0gA+ecUBO3Pb959dm5balYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTEvMTUvMjIgMTM6MjgsIE1pa2UgQ2hyaXN0aWUgd3JvdGU6DQo+IFRoaXMgY29udmVydHMg
dGhlIFNDU0kgZXJyb3JzIHdlIGNvbW1vbmx5IHNlZSBkdXJpbmcgUFIgaGFuZGxpbmcgdG8gUFJf
U1RTDQo+IGVycm9ycyBvciAtRXh5eiBlcnJvcnMuIHByX29wcyBjYWxsZXJzIGNhbiB0aGVuIGhh
bmRsZSBzY3NpIGFuZCBudm1lIGVycm9ycw0KPiB3aXRob3V0IGtub3dpbmcgdGhlIGRldmljZSB0
eXBlcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1pa2UgQ2hyaXN0aWUgPG1pY2hhZWwuY2hyaXN0
aWVAb3JhY2xlLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0
LmRlPg0KPiAtLS0NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxr
YXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQo=
