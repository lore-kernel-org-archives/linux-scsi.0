Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBDBC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 476AE61368
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242893AbhI1VXH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:23:07 -0400
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:65505
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242900AbhI1VXG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 17:23:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQDRP5bewN4nA0TE5jgm4UJaixLQXoJhCQPr8IZxGg83ROX1DCElQ95BNsBaPVwihuWegQzNNSlp2XDQkaEVCWUTBNkMW1ZrEyYWQ+xlJlxEGM+c3fWLvXK/Ww5y12IaY8iuAMgRrU5NYvfkX9tzpD6/IO7jMfC4Gnl+JKsQY3N+IXWRzLzih8YT3pY0l8E8oVLFna/Oyyxr+feqaVp9vbrql2MLT6o9uvYCRoXX0X6ncpFnqn+ecf0REt0LBlIWQom4XGH6gjrBE8ziHcPZphGe2KqSB3FjslU9lMN4uiYQPRrMioE/65LQaE7Jrcu4E4DcYx1O5nDTxBBQoQ0LkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=aRUyIONgpgPBf9C+eOEBrO6fIDBaW8qc8QxjNql7NxI=;
 b=hs0+4DScxYFNLFm0Qv/mKifv3OOkN+7o0Hfl5Rsra5lnLoKded/pj04Py0OmBIoqc92hXjIFIf5wEpev6JnVIB9RCIpjX0MO7WB5RCVASUhhCDnsg5QxUCnOjhXlKxoCTEd9ae4hwAYAQ9cQ+qdJd03TK/F4wV5YR2avYBH896ZB9oGsoC2AC1otn7dy7YgAwxoyGHb62v/oQ/HMlIIuCSulbbSazcq6Xxnl2VwL4p56VHma/Z02wCbjV08X6sShwj3CXRrnIEpAKDrrfsLlOEoFQu6wnoJyXTc0YBfW8H4TChPYR2TSVR4/zl2o8c6ib0lKG38+QlH+KtAZKQnYIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRUyIONgpgPBf9C+eOEBrO6fIDBaW8qc8QxjNql7NxI=;
 b=UkRECUGOmRqf6qLBvMMJhIHnkVhhJJyqHxD2tp1P9srk5LmMUC97G8AogNEeT+mNIE3QE9G60dDXXqEwYuxap+9/xErTr3px8mHquW3Z1r4dohtxoxDaLP1lrT3eNXbn7dF/xQbO5wfsh6gbv3OD3RKW1Tb8S4swqDcdso3XQvYdT8jDfk3cHe5w0jAWBM6RZNIcMGyKPmI1hjnY7CrKiFOK2nJoplBjm1GiBHGKyt5LPLMno39FhYH2twLY3IoPLAaAdZPcjPkyJmonTEGmAA0cgHc02qQvSw7cPJ8tXtTwy6Mbe3enyiZB5d2iJTV/A8BP7CFVpEvhmzuHLufrEQ==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by MN2PR12MB4342.namprd12.prod.outlook.com (2603:10b6:208:264::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 21:21:25 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::8931:3580:e129:7d15]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::8931:3580:e129:7d15%7]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 21:21:25 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3/5] block: remove the ->rq_disk field in struct request
Thread-Topic: [PATCH 3/5] block: remove the ->rq_disk field in struct request
Thread-Index: AQHXtCkr41vPlTt4RECKC2kVkjtGu6u58pUAgAACrQA=
Date:   Tue, 28 Sep 2021 21:21:25 +0000
Message-ID: <e9a6e00f-60e1-c604-9e08-3789fd057df9@nvidia.com>
References: <20210928052211.112801-1-hch@lst.de>
 <20210928052211.112801-4-hch@lst.de>
 <e88de776-fae9-7241-b741-9cf467f0965a@nvidia.com>
In-Reply-To: <e88de776-fae9-7241-b741-9cf467f0965a@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ce03e25-c6ab-4c3c-b780-08d982c5ed52
x-ms-traffictypediagnostic: MN2PR12MB4342:
x-microsoft-antispam-prvs: <MN2PR12MB43426BF59318D80B5190F507A3A89@MN2PR12MB4342.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K/bf5YVPW04Oa42uJ+2ERfXUud01bBQBXj3WBu24fwiTy4Ymgjr6RXld/ZIM3NPxCaZOm1vKYeM3CgzwcFTQxb3cwVxmGiKX4Ga0IiMLPNKtOC2xspsumUOY6vIAXl9oiyM8zanGY3GAQWwmVhixlX/wthuBsfdH6BS0U1xtb4KdVO993KB3+pOfy4XZNswppo8qTebhg/KJL4eDc333pWd+r/K4/wUyV7xPl+tgqzPnhJzLqgRep9cRFcv+31/LaMft3+CtP/CBWR5WkBbd9nmrQ9rZiJLUs8cHHlLHi0J311kb4p1le9X+xGj7wKMxYUDOLiPw6vs5dTdF426dqR7E6eTQ9+y/QGw2BVVtaBljvAbstWjo9+p/OP3jFJsG7ImCpdF7gX+b8/LmMBZzZ6sV884pHVFas6wKwt0GZ46WC4MGQo5Rg5jv0vzWeR8i4XtjIiJevErlRjRsCSW9lxO1u3bc3Din26Da7Q3Sy7fWtL3e/2PZIr8EeA/AYN2Vvv8QdDAANa2Dl5b3SJegnv7TavLpoEag7DruSCOYi1RE1NNcl4/ypGAbuyEDdvXgtF2wkbl2i4TOhjKLSLeomlyU4ZklKKodwua6x6J0dAjwmrx5Fr2zf7W70uyQ7Q0KepLLDj7Rvt7stmG9QQyMJ+BqE6IbRLDErpOR1IBVe+kEoMN81FkOSm7jh5BbkWCmSWc1kSrVB+8kviD/QVK0VWhfrVOfUwcqmUt03ZfCOuHVwsbniRzoOdmkmJRqzej+7ce27hrWWPUBm6dDZg8tHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(53546011)(76116006)(66476007)(66556008)(8676002)(66446008)(64756008)(36756003)(5660300002)(31696002)(86362001)(91956017)(4326008)(38070700005)(71200400001)(2906002)(83380400001)(186003)(110136005)(6512007)(38100700002)(122000001)(508600001)(4744005)(2616005)(316002)(54906003)(8936002)(66946007)(31686004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXp1UmVSdk5qNjJxa214VVhNa3o1QnBaQ0Y4eTVObk9BcXRuVnJ4WTcwZGxh?=
 =?utf-8?B?Z1FVTlBXS21tL1d6ejMzM3dZVS9OdFhpK3FoVTlUaWV2UDlGOVlKTGI2cElk?=
 =?utf-8?B?NDFyUDRRSndVdlpIZ2xCdHB6WHZaTmVkNnBvUzVyN3lFZHpkUmxrd1JOamdU?=
 =?utf-8?B?cXBBc3MvTWxZc0hZMTZPSHNxb1lydDBLRVVUVFI0WGtqTEUxMjV5Q3ZGSGJ4?=
 =?utf-8?B?YkFsWDV3U05BeVh2dC9obXBoQVNkMEd0Nmp1aXpYYkdhS0tNNFVVbEQ3SUtT?=
 =?utf-8?B?dkluRkRFNWRLZzJWcEg4OWMxQXhubWVPRi9vU2VhaE4vZWtxQnBtclhnMW1r?=
 =?utf-8?B?MWJ0VmZTZVMvZVFMMUxIVk9uWngxb3NmTnBtSXZrL29lK00vWXA4RDRKNHFu?=
 =?utf-8?B?c1ZEenJJYlAzRnJqaU9LbEJpWmN4QW52L0daQXJhVXZKVmhQODdlZGh2NmFr?=
 =?utf-8?B?UjdiUW1FcnMyMHQwaEd4bEZPUDNRcnRCckNSWEErZ285ZUNYS2RpSWRPZDFO?=
 =?utf-8?B?Mm1lbHNWdjM0SVA3a3ZPVmh1U3l2aFVkSXVmQXZpZkNOemNMNXZYUHVNR0h6?=
 =?utf-8?B?NjVlWEU4bTVxU0hDVTBVWU1CbklLQi9tTjlubHRJVEh3WmVQZzBzcnFDRzNx?=
 =?utf-8?B?eTF2UDZUOFRHM0l0NnRmeWtzeEFFamQ5UXcraDZpR1dDWWdOMkpiQkZXY2Uz?=
 =?utf-8?B?RHBtUyt5SU42VFhOUjBPR2pKbWdiK3huZUtyOVNJNmduaWtwWWsvb2d4Wmlk?=
 =?utf-8?B?dy9FckhqR25XSGQxYXptejlDZGpoM2grWndGVkF3SlMyMjZGSzYramVGR1Nt?=
 =?utf-8?B?L3FMN1hyVE5WZ3MxMmJaNHhsNmo5NGZScDUrdEIwSi8yOFZmL210WXJaeHJB?=
 =?utf-8?B?dG83UlVCZnhwK3AybmZ5NlJFNkVoUVdad0VBaEtaVWtKNXhmK1JiZmlqbmU4?=
 =?utf-8?B?K2JJeW1TWnFCMHlPR2FLYktCUVdYejY0cWphb0FHOTJPVGNDQXpaNUdMMEhq?=
 =?utf-8?B?UGtzWG04UWU3Q24rbHhOanZmVVhoRlYzM0twRi9lQ24yVGdVSmFYTVR2TThC?=
 =?utf-8?B?N0JQbEM0TE40QUFnRjEwdng0VVlienBrVDVDbSt4SmZVek41czhESUtwZUNS?=
 =?utf-8?B?ZDMxQmNRM3lmK3paRm85VGRZaVZ6TFRSeW0rNStVa2JGQytoYkZjYjdVY3VR?=
 =?utf-8?B?RW43ckJDekRUTlp0SXNYQmpDL1dOelkyRW1XZkQ0dnltRUxzbkNDRWREblZX?=
 =?utf-8?B?U0xWUGd0UWdQamh0SDRVVnpUMnBMeXdxNVNwY0tQOGp1ODJteDZsNHAzVmVs?=
 =?utf-8?B?a1NRVWRpb3ZybDIyQ01ScXdpSjNzZnRpVWpRNVpqTWUyNTBTMzU3WnhTRk8z?=
 =?utf-8?B?VDhLZ3RFRFVqUkk3amVQekVTOE9vdWpKWFE1UUZMaVp2TzlkNnBuY1FRaWhL?=
 =?utf-8?B?VnVpNi9VZW9Qdzd4a0poQnhsTExCWCtZR283Um9MWjB6bGJCUHpIbnBGNTJT?=
 =?utf-8?B?cG1NOE9xOVpnM3JCSlNNTXNFWXZKODRCNEVEeEdmTzdBTjFJdU9Hc0RnaTdV?=
 =?utf-8?B?VTFDQTFQYlp0WUNlaDBKVytJbDZJRmJKdWpNR2dVRGwyR2xMd2NBUHJDNHRS?=
 =?utf-8?B?ejZ5UzcwZSsrVmx1Si94ZkhvakZubUxVVk01UEFqVnF4U3Q4YmJ3K25IQXpM?=
 =?utf-8?B?MXFRSXRieXBjajBDak5RT3RpNVZHYkRIYm1QanU2bmw3OWhaNzdFZmM0S20z?=
 =?utf-8?B?WjBsRkwvVWxhTmdObnpXTXFZWEZkbGNKSGxXSWd4dVV3a2ZRSTRlY2J4dExS?=
 =?utf-8?B?YlhNdWdoWitrME1SNnpidz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D12520F09FE86A4FA7DF9C9CD0462296@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce03e25-c6ab-4c3c-b780-08d982c5ed52
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 21:21:25.0685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F31LrF81S5rOD0JS+Gpsatq4d1NVjLXlk6+XEAPhpqgA1syv52af93lmJ9Y8byn8+2lBZub8q4cSSetNQtEzXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4342
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOS8yOC8yMSAyOjExIFBNLCBDaGFpdGFueWEgS3Vsa2Fybmkgd3JvdGU6DQo+IEV4dGVybmFs
IGVtYWlsOiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiAN
Cj4gT24gOS8yNy8yMSAxMDoyMiBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+PiBKdXN0
IHVzZSB0aGUgZGlzayBhdHRhY2hlZCB0byB0aGUgcmVxdWVzdF9xdWV1ZSBpbnN0ZWFkLg0KPj4N
Cj4+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPj4gLS0t
DQo+IA0KPiBQbGVhc2UgY29uc2lkZXIgYWRkaW5nIDotDQo+IA0KPiByb290QGRldiBsaW51eC1i
bG9jayAoZm9yLW5leHQpICMgZ2l0IGRpZmYgZHJpdmVycy9tdGQNCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbXRkL210ZF9ibGtkZXZzLmMgYi9kcml2ZXJzL210ZC9tdGRfYmxrZGV2cy5jDQo+IGlu
ZGV4IGI4YWUxZWMxNGUxNy4uZjA0ODg2OTRhZmRiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL210
ZC9tdGRfYmxrZGV2cy5jDQo+ICsrKyBiL2RyaXZlcnMvbXRkL210ZF9ibGtkZXZzLmMNCj4gQEAg
LTU5LDcgKzU5LDcgQEAgc3RhdGljIGJsa19zdGF0dXNfdCBkb19ibGt0cmFuc19yZXF1ZXN0KHN0
cnVjdA0KPiBtdGRfYmxrdHJhbnNfb3BzICp0ciwNCj4gICAgICAgICAgIH0NCj4gDQo+ICAgICAg
ICAgICBpZiAoYmxrX3JxX3BvcyhyZXEpICsgYmxrX3JxX2N1cl9zZWN0b3JzKHJlcSkgPg0KPiAt
ICAgICAgICAgICBnZXRfY2FwYWNpdHkocmVxLT5ycV9kaXNrKSkNCj4gKyAgICAgICAgICAgZ2V0
X2NhcGFjaXR5KHJlcS0+cS0+ZGlzaykpDQo+ICAgICAgICAgICAgICAgICAgIHJldHVybiBCTEtf
U1RTX0lPRVJSOw0KPiANCj4gICAgICAgICAgIHN3aXRjaCAocmVxX29wKHJlcSkpIHsNCj4gDQoN
CnNvcnJ5IGZvciB0aGUgbm9pc2UsIHlvdSBoYXZlIGFscmVhZHkgZG9uZSBpdCBpbiBwYXRjaCAx
LA0Kd2hlbiBJIGFwcGxpZWQgcGF0Y2ggMSBpdCBmYWlsZWQgb24gbXkgdHJlZSBkdWUgdG8gY29w
eSBwYXN0ZQ0KZXJyb3IgYW5kIEkgbWlzc2VkIGl0IC4uDQoNCg0KDQoNCg==
