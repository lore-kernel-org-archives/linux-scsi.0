Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE6AC49EA5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 04:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D934613CE
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 04:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhFXEyt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 00:54:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42716 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229448AbhFXEys (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 00:54:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O4kL3c002843
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 21:52:09 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 39cg2n8n34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 21:52:09 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15O4ncK5007795
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 21:52:08 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0b-0016f401.pphosted.com with ESMTP id 39cg2n8n33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 21:52:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ytf3ot87OwvAQBYek6jpX/I5jipJs+GLb76hWJde+yl706XU9m/J1xrF7aM4yV94sr8RHcHRnbt3KhYvnLk2VahxwoTOe3EM0a3s7hkkcjwTWT45yxER48EbQPYU+kYjVAIKdnlGhb29OZfVbpYoITazULzWkRj7lcIl3lFpdaVceQGc5Fn/b4T5BU5oDlqGdJQVL1HiOj+sBngQuqorLQ4RDqfTgc2YUkSpL9uJp3M2XyTjvYVEsQCIFM80OuYHsReNxZxUWuwRbV5ZaueP7PBtR1sWRDLJJ0SNU+Rc4C3wxQIXqkDqLwxM1bO5jaIhG48BIS/BG3x875UJEaxjFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYFav0IRrqUSlKInhptfSWviJKGTl/+99KpKxXq9j7o=;
 b=kTkmaxPYVyqU+eX/Eh/5XKEf+YQ958r4w2fzCtKWJe3VntFrNIahC7ajy0AjUUT/9GOz0xB6ohw/JA3pwTt+RZsZ1V0Z6PvKSd/4nq0u5OqpNfrFTF0tB8MXnXd7FZeHuLyW5oIK63ksiGyVQzJbisDfpbP0Iwmtvg4mSaiuZZQhK5ObZgIFgL7d2OWm+yMTbiHmEC5C4HerkLc7XFBnoZrWjkn7kdDengObI+iIbX9+mEEGAeMU30SGMqgPsMehhTpSQB19oaiBa1TJpfcEDIpIA22QZGJm3V7QGwkEHWSgBYuWYDgkiG7U6TtKoZJedq0eMA4GHXgnhSWwaB45ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYFav0IRrqUSlKInhptfSWviJKGTl/+99KpKxXq9j7o=;
 b=CBjrvnsdaz+XsUfOlRSoWALQtrzOiOtidxbZINyX2M9jDmKD1u6E6Gyir/Skqe6PShsd2ifSospIsXQAtlxxQjuGUM9OSHk9kSqOOVh508a/dMl/JjPhnLY5UXS5eRdkm8vs9QPtvMCnyGXlTj+BXCnBFtTd/fvHZC9a00zXgdY=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by CO6PR18MB4433.namprd18.prod.outlook.com (2603:10b6:303:13b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Thu, 24 Jun
 2021 04:52:04 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::292c:463a:b28d:cb02]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::292c:463a:b28d:cb02%9]) with mapi id 15.20.4264.018; Thu, 24 Jun 2021
 04:52:04 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH v3 10/11] qla2xxx: enable heartbeat validation
 for edif command
Thread-Topic: [EXT] Re: [PATCH v3 10/11] qla2xxx: enable heartbeat validation
 for edif command
Thread-Index: AQHXaBrTDMDLIoXaOEaBJWGVAvkVdqsh8CuAgACZnvCAAAhlgIAABizA
Date:   Thu, 24 Jun 2021 04:52:04 +0000
Message-ID: <CO6PR18MB4500FCE22684B34B1371F5C6AF079@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20210623102611.3637-1-njavali@marvell.com>
 <20210623102611.3637-11-njavali@marvell.com>
 <9862c087-71b1-92e2-677a-a74330212de4@oracle.com>
 <CO6PR18MB45009B91FA30BDE67A994F9BAF079@CO6PR18MB4500.namprd18.prod.outlook.com>
 <e793b8a9-54f3-68ba-c853-39ff8eb7e011@oracle.com>
In-Reply-To: <e793b8a9-54f3-68ba-c853-39ff8eb7e011@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.150.138.159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33d6f0f1-cb9c-4de7-c0b5-08d936cbcfdd
x-ms-traffictypediagnostic: CO6PR18MB4433:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB443334EB7B5CA553B185596EAF079@CO6PR18MB4433.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9uOMSPaCgMoxlp3Tp25tyoplhbyQo6yk8vp3nJajHRomBKjK3RdkkzbJW9Us9OAmbpRhV/QGotgreNCgG7epnFMJvR7qzcKjNSoU4JDNcSRpjhR9UAnYULTeXmrzfCBDzB0YNJrFKcqBxeq0bTb+C1PPDfYaEptEVrobrWLwgiG5yX7wRFwdNUZSRYYZpRCpGf4lqtcZw+sxmhriiKPVeyILgDO6f6IgYUZGcLc8smK5MlVSdJFJO9DVKeeTwN4HMWmNN0nBF0f2bEIQbHVWlMsg4bn1BTplJyQJ2xed6w18a5UWOE0drEAUScGZpSiMxwS1EeJbTkEL5nodD0EkVC5Vpuzh73Tb4M4xWQX7/411TIn6WoFgBOiOETkgkh/NFtKW5x8VgMs0V2gGa5efV3CIn54CHS+p7bILsKqIYgBvTDxIAxba+DINYXMbWJGdjBcm5Nwo9Y07zzSOJq+sB/0L5PRzeVPgw3aEgsbOoWz3fumqfOEmGH433a2g4KnVwhjxtjeAKBd2K1BBR3i8qHDiWABbwaXMHlM6qrmfqDRUGc7qs4fFil7w6AKyFIbfdOY1dmibYb4XAv5sn7aTFgb+gRKIz9LQhI2WV4ZFLKs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(366004)(9686003)(55016002)(107886003)(4326008)(186003)(122000001)(26005)(53546011)(6506007)(38100700002)(5660300002)(54906003)(7696005)(52536014)(66946007)(86362001)(76116006)(478600001)(83380400001)(71200400001)(33656002)(8676002)(66556008)(64756008)(8936002)(66446008)(316002)(66476007)(2906002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODg4K1VSenJtU0p4L0pxWm8vckhuVk9LcVFhWWg4b0JPRHdiK2JidGlmWFBl?=
 =?utf-8?B?Q0s4d3VIRm1FcDlOR2VSQmRiM3hua0hSQlltNVZvNVJMWHphbG9oRklaRCtz?=
 =?utf-8?B?bVlmVjBDbGl0QzhRdDN0RG1hTlR2N0dYKzVQOVo0OXVENHBGYmNTdHlUV2VX?=
 =?utf-8?B?dy9wWEhEaGlGM0R3UTJ0bVc5ZmR0cVNnSEZoamNpRTVlWjZhcHdtR1V2eTNJ?=
 =?utf-8?B?RURHWlRrSGtXWi96WThkc202b2xIVTFTMjdCTWdUaU9pNUNwYkZKMGRwaFZO?=
 =?utf-8?B?d25jRVpKeXVDWnA3M0lNaUZtdHBINHJCc1ZMQXFpMldsbWNnS2l2UU1RZ3ZS?=
 =?utf-8?B?aEttRVoxejlZUzJuNFB1ZXQ1Tmp4RjNvczRvRUk4SlYvNzRIMVlCdmFseTR1?=
 =?utf-8?B?ZUFOMmtIN1hrcWxsZUhFbUVIMTNRZFR5WGUzb2x5dkk4SnJyekFDWUNQWTBD?=
 =?utf-8?B?WjllZldBZ3lKSGx2aTBIeFY5M3B4akN5c2lxUWJJL1RxRktINUNoVlQxNisx?=
 =?utf-8?B?UldnaWFVbFA3dlRHNUVDUm9WNDlPSDVMbExnUzNlSWVXai9WOHN5OTNGUmdX?=
 =?utf-8?B?cDlJQUhmazVmdEIzREZqclRGNCtSaDgzTnJML1BjWDZhaitkcllKSGdndTIz?=
 =?utf-8?B?STY0TmFwV3JkaWxpdjVnNk5lZzlOYkJkSDJMY3k0Zm9laTZSTW0vVjU2VDhl?=
 =?utf-8?B?S0R4THhYM2ZmQmJ6K0lNUkFpcmRGc2hmRkpueHJRR085eW41amx5ZWxYZFVZ?=
 =?utf-8?B?R3JVL3hmdmxtTE5ZRHdYTXZYUGpnK0k4cS9YWGEva05tRUl4U2NKZndWZkVK?=
 =?utf-8?B?RFAydllzMjQ3WXkwbUhGVldqTXhEL2drSVlhRmtyaFlwLzlkSkQ0bENPdk54?=
 =?utf-8?B?K2dEYkJIS201OXpvbnZ1cHhHVFlLWXhya0dwTUdyeVUzZVBaUmZZSkxKaElM?=
 =?utf-8?B?WjNhdE5pSDZPcmFyTFBHSjIrSU9tMmtrOW0vR1hZMDBaS3JYblRDRHd1aVdZ?=
 =?utf-8?B?dFFsczNXc1V3UEFBNzJNK2VXMWhrZzBlVVFuaEtZaGROM1BoS2QyTFFVbW5j?=
 =?utf-8?B?L0hzNnlSV1gxelpZcE9vNDVuN3FxMFFway9pRStaNWF6Q1NQelVGYnZxRXZt?=
 =?utf-8?B?bFVUZEFCdEIyYlBadlBqTzFuVTgzMHlGUmNRVmpzdkFaTFljOWRqQ0dDYVZa?=
 =?utf-8?B?YndkaVRDSzVWVkUvdXYxMEFpWktnYjJEbTNVL2dvWi9DNHhrNWFXeXFEU3Fx?=
 =?utf-8?B?NmlpTXRNc1kxQjZNWUVOWkcvdTNzS1lxeXlMUmZrRVRHZ0pua0w4allqS0pJ?=
 =?utf-8?B?NlpISDczcTVDc0NEYlZmaHFJeG9KTENtbHJUekZGcTFzKzJ3cHZjSk4wUC9h?=
 =?utf-8?B?RWU1NVcxdFdEU0dlTEJXR3h6bWYzdDR0dExFSnZaSTNMR3dPT2pDNUQwVTB2?=
 =?utf-8?B?dkpRMjNoYTZiZ28ySVNiYlJsOE9hN1VjNG9pOGYrMkZ1aG9SVEdQb1BLanZw?=
 =?utf-8?B?TkNmL21ZMjVtZE1KM01rekdpUjYwRW1iRW01blpFK1VXT2RvczFjZHBIbVNs?=
 =?utf-8?B?bFZOaXBPTUdiL00rYnM0Q0crUlVPU0txYWNPMU4ybVduTUxxenI2UXBESjBI?=
 =?utf-8?B?ZC9DRXhMNlUwZWJZQWJIRDBFMHZ2Z2RPMzFTb2oxSi9FV2djY2RUeXoxc0RN?=
 =?utf-8?B?Um53RFUwOFpOc1U4T3l0MFA3N2llbis3MVNjSkxVNFJLc3NpYStjWkR3MndN?=
 =?utf-8?Q?ZbD+4OyhT6YUqjjqg8Txo1i/wT9QMcbykP1S+UK?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d6f0f1-cb9c-4de7-c0b5-08d936cbcfdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 04:52:04.1859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /BocT/20PGwC441nNzSgxLFCkfbHNNROhaMTR8yWk/KjF3KC4x4mFmJ60eDZzau2BEjiWz8ljEmppdgAK37GUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4433
X-Proofpoint-ORIG-GUID: D03SmeqUVpSCOxXERrkGyq-EeJl2CCgx
X-Proofpoint-GUID: -lTsoW9LnpMqiz5xADOvtwy1sFIvnf_V
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_03:2021-06-23,2021-06-24 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGltYW5zaHUsDQoNCkkgd291bGQgcmUtd29yZCB0aGUgc3ViamVjdCBsaW5lIGFuZCByZS1zZW5k
IGFzIHY0Lg0KVGhhbmtzIGZvciByZXZpZXcuDQoNCi0tDQpOaWxlc2gNCg0KPiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRo
YW5pQG9yYWNsZS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBKdW5lIDI0LCAyMDIxIDk6NTcgQU0N
Cj4gVG86IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+OyBtYXJ0aW4ucGV0ZXJz
ZW5Ab3JhY2xlLmNvbQ0KPiBDYzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IEdSLVFMb2dp
Yy1TdG9yYWdlLVVwc3RyZWFtIDxHUi1RTG9naWMtDQo+IFN0b3JhZ2UtVXBzdHJlYW1AbWFydmVs
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbRVhUXSBSZTogW1BBVENIIHYzIDEwLzExXSBxbGEyeHh4
OiBlbmFibGUgaGVhcnRiZWF0IHZhbGlkYXRpb24NCj4gZm9yIGVkaWYgY29tbWFuZA0KPiANCj4g
DQo+IA0KPiBPbiA2LzIzLzIxIDExOjAyIFBNLCBOaWxlc2ggSmF2YWxpIHdyb3RlOg0KPiA+IEhp
bWFuc2h1LA0KPiA+DQo+ID4gVGhlIGhlYXJ0YmVhdCBjaGVjayBwYXRjaCBhdHRhY2hlZCBkb2Vz
IHRoZSBhY3R1YWwgdmFsaWRhdGlvbiwNCj4gPiBhbmQgdGhlIHNhbWUgaXMgZXh0ZW5kZWQgZm9y
IGVkaWYgY29tbWFuZHMgdG9vLg0KPiA+DQo+IENvcnJlY3QuLi4uIHRoaXMgcGF0Y2ggaXMgbm90
IGRvaW5nIHRoYXQgZW5hYmxtZW50IHJpZ2h0Pw0KPiANCj4gTXkgcG9pbnQgaXMgdGhhdCB5b3Vy
IGNvbW1pdCBzdWJqZWN0IGFuZCBjb21taXQgbG9nIGRvZXMgbm90IG1hdGNoLiBpdA0KPiBzaG91
bGQgc2F5ICJxbGEyeHh4OiBJbmNyZW1lbnQgRURJRiBjb21tYW5kIGFuZCBjb21wbGV0aW9uIGNv
dW50cyINCj4gaW5zdGVhZCBvZiAicWxhMnh4eDogZW5hYmxlIGhlYXJ0YmVhdCB2YWxpZGF0aW9u
IGZvciBlZGlmIGNvbW1hbmQiDQo+IA0KPiA+IFRoYW5rcywNCj4gPiBOaWxlc2gNCj4gPg0KPiA+
PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBIaW1hbnNodSBNYWRoYW5p
IDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20+DQo+ID4+IFNlbnQ6IFRodXJzZGF5LCBKdW5l
IDI0LCAyMDIxIDEyOjE3IEFNDQo+ID4+IFRvOiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZl
bGwuY29tPjsgbWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20NCj4gPj4gQ2M6IGxpbnV4LXNjc2lA
dmdlci5rZXJuZWwub3JnOyBHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbSA8R1ItUUxvZ2ljLQ0K
PiA+PiBTdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwuY29tPg0KPiA+PiBTdWJqZWN0OiBbRVhUXSBS
ZTogW1BBVENIIHYzIDEwLzExXSBxbGEyeHh4OiBlbmFibGUgaGVhcnRiZWF0IHZhbGlkYXRpb24N
Cj4gZm9yDQo+ID4+IGVkaWYgY29tbWFuZA0KPiA+Pg0KPiA+PiBFeHRlcm5hbCBFbWFpbA0KPiA+
Pg0KPiA+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4+DQo+ID4+DQo+ID4+IE9uIDYvMjMvMjEgNToyNiBB
TSwgTmlsZXNoIEphdmFsaSB3cm90ZToNCj4gPj4+IEZyb206IFF1aW5uIFRyYW4gPHF1dHJhbkBt
YXJ2ZWxsLmNvbT4NCj4gPj4+DQo+ID4+PiBJbmNyZW1lbnQgdGhlIGNvbW1hbmQgYW5kIHRoZSBj
b21wbGV0aW9uIGNvdW50cy4NCj4gPj4NCj4gPj4gSSBkb24ndCBzZWUgZW5hYmxlbWVudCBvZiBo
ZWFydGJlYXQgdmFsaWRhdGlvbiBjb2RlIGluIHRoaXMgcGF0Y2guDQo+ID4+DQo+ID4+IEFtIGkg
bWlzc2luZyBzb21ldGhpbmc/DQo+ID4+DQo+ID4+Pg0KPiA+Pj4gU2lnbmVkLW9mZi1ieTogUXVp
bm4gVHJhbiA8cXV0cmFuQG1hcnZlbGwuY29tPg0KPiA+Pj4gU2lnbmVkLW9mZi1ieTogTmlsZXNo
IEphdmFsaSA8bmphdmFsaUBtYXJ2ZWxsLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4gICAgZHJpdmVy
cy9zY3NpL3FsYTJ4eHgvcWxhX2VkaWYuYyB8IDEgKw0KPiA+Pj4gICAgZHJpdmVycy9zY3NpL3Fs
YTJ4eHgvcWxhX2lzci5jICB8IDMgKy0tDQo+ID4+PiAgICAyIGZpbGVzIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPj4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zY3NpL3FsYTJ4eHgvcWxhX2VkaWYuYw0KPiBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3Fs
YV9lZGlmLmMNCj4gPj4+IGluZGV4IDhlNzMwY2M4ODJlNi4uY2NiZTBlMWJmY2JjIDEwMDY0NA0K
PiA+Pj4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2VkaWYuYw0KPiA+Pj4gKysrIGIv
ZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2VkaWYuYw0KPiA+Pj4gQEAgLTI5MjYsNiArMjkyNiw3
IEBAIHFsYTI4eHhfc3RhcnRfc2NzaV9lZGlmKHNyYl90ICpzcCkNCj4gPj4+ICAgIAkJcmVxLT5y
aW5nX3B0cisrOw0KPiA+Pj4gICAgCX0NCj4gPj4+DQo+ID4+PiArCXNwLT5xcGFpci0+Y21kX2Nu
dCsrOw0KPiA+Pj4gICAgCS8qIFNldCBjaGlwIG5ldyByaW5nIGluZGV4LiAqLw0KPiA+Pj4gICAg
CXdydF9yZWdfZHdvcmQocmVxLT5yZXFfcV9pbiwgcmVxLT5yaW5nX2luZGV4KTsNCj4gPj4+DQo+
ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jIGIvZHJpdmVy
cy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jDQo+ID4+PiBpbmRleCBjZTRmOTNmYjRkMjUuLmU4OTI4
ZmQ4MzA0OSAxMDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3Iu
Yw0KPiA+Pj4gKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jDQo+ID4+PiBAQCAt
MzE5MiwxMCArMzE5Miw5IEBAIHFsYTJ4MDBfc3RhdHVzX2VudHJ5KHNjc2lfcWxhX2hvc3RfdCAq
dmhhLA0KPiA+PiBzdHJ1Y3QgcnNwX3F1ZSAqcnNwLCB2b2lkICpwa3QpDQo+ID4+PiAgICAJCXJl
dHVybjsNCj4gPj4+ICAgIAl9DQo+ID4+Pg0KPiA+Pj4gLQlzcC0+cXBhaXItPmNtZF9jb21wbGV0
aW9uX2NudCsrOw0KPiA+Pj4gLQ0KPiA+Pj4gICAgCS8qIEZhc3QgcGF0aCBjb21wbGV0aW9uLiAq
Lw0KPiA+Pj4gICAgCXFsYV9jaGtfZWRpZl9yeF9zYV9kZWxldGVfcGVuZGluZyh2aGEsIHNwLCBz
dHMyNCk7DQo+ID4+PiArCXNwLT5xcGFpci0+Y21kX2NvbXBsZXRpb25fY250Kys7DQo+ID4+Pg0K
PiA+Pj4gICAgCWlmIChjb21wX3N0YXR1cyA9PSBDU19DT01QTEVURSAmJiBzY3NpX3N0YXR1cyA9
PSAwKSB7DQo+ID4+PiAgICAJCXFsYTJ4MDBfcHJvY2Vzc19jb21wbGV0ZWRfcmVxdWVzdCh2aGEs
IHJlcSwgaGFuZGxlKTsNCj4gPj4+DQo+ID4+DQo+ID4+IC0tDQo+ID4+IEhpbWFuc2h1IE1hZGhh
bmkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE9yYWNsZSBMaW51eCBFbmdpbmVlcmlu
Zw0KPiANCj4gLS0NCj4gSGltYW5zaHUgTWFkaGFuaSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgT3JhY2xlIExpbnV4IEVuZ2luZWVyaW5nDQo=
