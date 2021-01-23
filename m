Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78302C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 09:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36C0923437
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 09:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbhAWJ3O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Jan 2021 04:29:14 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:13527 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbhAWJ2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jan 2021 04:28:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611394094; x=1642930094;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=cn2H3Um7jTGvhH9SfA4GO+fWA+DGTrUuwJRSkSbQfBQ=;
  b=qlq7dUHW45xtzDUTQlVCeih0iV4yrpb8l566rz06sp7Oinfmp5zlLbeR
   IBkiefmJgfV7ldjeCj0ApEJgpgOc91qcf17ugo3OMeUIIhqn8QdJ4u4jI
   GbDvEGwut7avDa2fS1999MaYWnmB/sjuAt9aUoZ76S2hrmgcAmGEkIhHP
   P9eF6MY+HQEj11BYjrg8id9laqM5/SsTHFOs+fZawY/kjxNd+Iht9Y9OC
   zcFX2asZp1ZxtowJWFQMGULVwzazIBhDgoojmQr1bGZESDRPVX/ziuCYu
   XXy7LDuBXsryPhH1uFVOG+uBhQi34jIa/Yes0vCYLHxGpo2bU1vpHHW3g
   w==;
IronPort-SDR: mKk1wzTfGdWjGtF8LdTIfD+UQhfmK/3E93plK+1yEQadCwv/k485LMwDVPWiYY9QuwmbE29dvK
 8xdJ+yJymWhzqUosvGNH52TxmXmePkjlvNNfVqyXo0B0wHOjqKIo3/kMQOBtbDx4SW2P5AYAIU
 CJSEdXDHH5P3GRO7EB7FbiRsTGst0/vhYP5xZ8umvLb3o22stddUTf8wgVE2sWybBU6MiTZ2b5
 ae4ofymzR2iYRDMBhS/sYL7PC6Jrh9pu7hg4n6KwC69QxJYQcpu+hujalGKBHd7m2p65N4nat+
 /Q0=
X-IronPort-AV: E=Sophos;i="5.79,368,1602518400"; 
   d="scan'208";a="158148868"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2021 17:27:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzeLID9VhWvYbasphW0rQBwe7Cbgvw1MJKO6syZJvC+CGe1Zbz4DVjz01lRk79itDBQmwOuA64STscm7FW6Yp2zAWS2k5bKqOvzhxYkT9pioyb+JKE7cselqMywM1NxF0UTu5ixOg/jbIORYnNh3TEuXxgiy6jiZPF0Lj6LkIhlutM9HseezAViwH0IUn5YGHij2xe8IZ9Qdp4pcpes2fm3qMvrjxItTz2SpGg7i2+sFhvH0IduG3C2do8jq85tg8oXtMypVM7atnPKOl3Tini7WNKmyNj1lSHXBEyI4rsWJzEhoIqULNQe2JAfimo82RP51grrJvpYzgXFVL2dB3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cn2H3Um7jTGvhH9SfA4GO+fWA+DGTrUuwJRSkSbQfBQ=;
 b=TpMI1o2YWNahk+V6+LWTVHmQCbq2Je/mJ30VqdaD4yq6kk999NPaya4YKvDRrKViHRX+O7IJHpV/6GXGQGcDxyYmGUvSoUxDYvlQAss9kxVLFQPeevsfvbJVGpUmYNQFpVLY9Lv6dirogxQ5vpCLAgjH1hKKXu9gcyES2GNFtgDIhdvuNh9vLT3+F0SRj2+zINOwECiZ6nekwdb8cUNJsLTQFsWbgqTWokithTBcSXTgs7b6iqpw3n6V82KntxnVOsjqMs/HYBvJdzv+B/FSF1PYwfSNmvHKEvm4ulXJRJpQ4FHNxAz88PLEMme41s6mmfzIiNNscWSyHDRiz6ZYGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cn2H3Um7jTGvhH9SfA4GO+fWA+DGTrUuwJRSkSbQfBQ=;
 b=sEDqbP+p0RAK8c8tqU5Z3iC9dnc38frfJH2Z25HefmrEZ93h0ubfmtnUS5oBOaAAjWQpEQnFducuinZZf1Zz5fugM5tyxWVrShvaQqfNnshGeBLYUEFKlPY3X//NwFWYG3i1hfkxY9BtWiYvPyuqEKrMeQV40tXKiJWYc4e5Xxg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5628.namprd04.prod.outlook.com (2603:10b6:5:163::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.10; Sat, 23 Jan 2021 09:27:06 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 09:27:06 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "bhoon95.kim@samsung.com" <bhoon95.kim@samsung.com>
Subject: RE: [PATCH v1] scsi: ufs: export ufshcd_wb_ctrl func
Thread-Topic: [PATCH v1] scsi: ufs: export ufshcd_wb_ctrl func
Thread-Index: AQHW8VCRORFv83wQW0ORkZLDFh1ei6o07/4g
Date:   Sat, 23 Jan 2021 09:27:06 +0000
Message-ID: <DM6PR04MB65759EB046EFFB3D1AFF79DDFCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20210123062524epcas2p30522ab83455f8e2cc78d2824f0def515@epcas2p3.samsung.com>
 <1611382437-187970-1-git-send-email-kwmad.kim@samsung.com>
In-Reply-To: <1611382437-187970-1-git-send-email-kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cdadc591-6249-4ccf-795c-08d8bf810d0f
x-ms-traffictypediagnostic: DM6PR04MB5628:
x-microsoft-antispam-prvs: <DM6PR04MB56281980ADCF6000D4773C1AFCBF0@DM6PR04MB5628.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6qR/h+4yUxyN8xlvyczW4p9nLZWBtfz9LAmM++u0Y9fCmJIN3mU/u/ABh9veVqe9pyxgwKYLWf17SvXOHhBHnRvjtd6ZJMq7sFKIErxvlDYnVR+4vg08gPiz7FOYipEgicH8R2wPfSCRWNYqAGoERDUFBmoHFUOfT8ovLTBzV1uZ/LBDw/mP6pGHwdvHheF/HJ9hrZzfGtBdy5wSq1jGsnsb5Pd4jcEmI+LGXiclevEbRqOMBT+jGGXPe+AzQs7PgNc3m3/eEiHwvZAuTvZ3hUL+/V6wIER4YImhQPoX/Cu+uU3dy/CxbDvphzH06/M1zJ9CJJiFrPBjU122p+ipQpP05hhNK/6rGj4YTrA6EKcwWVTxR8BBzDikuSbQZ8O58gCGralVynJ+vmQvEk4r28MJ12OG4Ard6yGzmZWgQtuiqaYRtoSR3Gpck/LrlRBO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(2906002)(110136005)(7696005)(921005)(33656002)(66446008)(66476007)(26005)(66946007)(55016002)(478600001)(52536014)(7416002)(64756008)(4744005)(8936002)(66556008)(5660300002)(6506007)(71200400001)(8676002)(9686003)(186003)(76116006)(316002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NVdIUkxDVHpoQ3l5RjNld0pFVHBCNkJPZXlrVVFEbUlrU2lKdUtGbmphK2N4?=
 =?utf-8?B?Q0V4MmRPZjQ4RWlrc3FsZDQ5MjUyTFBIVjFUcnFseUdHV2lpa2VVUTY3RTNR?=
 =?utf-8?B?RmtKMXpNUG5mVmxqaEw4VENrdXR1Z1ZmaGVLem0xUnBWcFI3VjRGSHE2eXRr?=
 =?utf-8?B?QTAvcFBjZEhPZGJkVWhCb3NVZ3dKeDFvYzRBL0VvN3ZZZ1N2Qyt0OXJBYWMv?=
 =?utf-8?B?NXBoTGdKSGNxam91bW95UlFQMUFqRkxQU3dYWnBSZGtoU2d5azJzUnBHZm44?=
 =?utf-8?B?dXpuMVZhWHdnRkljbDVVV3pLRDc1ODJlcHhiYUNEcUR3K1llK1BWS0QxZGpV?=
 =?utf-8?B?UVZ3U3RIZFFRUWN0M2ZTZkR6Y0M1L3FaTVlsMHlIV0Q3WlloTmZqOFRhQTNE?=
 =?utf-8?B?M08wUWNKRFhNU0ZwSlFXNXV3eENzdVhjeU15U0hDZ0RnUGZTbFU0VGdibkN1?=
 =?utf-8?B?MUEwcjU1d2ZOUDl4d1l1VkFmRGd3Y0RtaE03Mm9kcDd2KzJaUlpFNmxlSHVH?=
 =?utf-8?B?dTRwNlBXb0lhdjIrMTMwWnRvbE9TWWF2QWxHa055TEZiNFlIanpteVZ2VWh4?=
 =?utf-8?B?UU0rSjJPZ1dMRktHZGVabGovc0R1Z3FMSkFEeHQ1WEM2eHA3STNwZTd6MDVs?=
 =?utf-8?B?eDNKZGVmRkFENndIdzFDS0VFZTZCRVhpRXFGbEp1Nkwrd1RxM1RnWXoyY2J4?=
 =?utf-8?B?N3pTY1NEU3pHUDhadUVRdWswaXBPbTkvek5abmgwaXhQSVBIT2ZOS2JpWEx3?=
 =?utf-8?B?RGlhYW1wU0pWOFFCMytzOTMzSGNkUXQ0cTBJakdrR3EzY3RKSnpQTVlvUVlV?=
 =?utf-8?B?bzE5ckpBYk1ZRStod3I3WXBRa2kwTnF5YXJLK2p2YjZZZVVnRk5WTUx1MHZl?=
 =?utf-8?B?aTNGYjQxTTNqam90UTRBcU1lTlRUcG9lN1NOcVkvZGFZV2diaDdkZ1k5dTlT?=
 =?utf-8?B?bmJmTTNHM3R6VmIyTUFlQm9yMDQ1OEs4ZnFIYjVaazJiRU9lbFZlQ3NQMnl3?=
 =?utf-8?B?K2tDcFN6M1hxNDZDZkNYdFE5ZTRqdWRXZEJpS2xCd3dIVUt5TC9QeFVIemlj?=
 =?utf-8?B?NjRNSkx3Sm5jUnB1eFV5YzF4YzM3cHlMZzlSL1FpY3lBRjNCM2ZwNkZWT09J?=
 =?utf-8?B?QmhSUlJ3bjJIdkcvMDIyc3ZQVHZvMFdMYnBkaG1kM0J0cGl5dTRZeDdxM1Rx?=
 =?utf-8?B?WGROYkxZcWtBekNWdm5lSi9sRWdWbkx6SkVVbEpCc25MV2ZyV2hiZ29qdjhw?=
 =?utf-8?B?NTlqZVBSY2l4N2xEdTBGaVlrR0VUVXhpT0hQM0JvbGkxemx3Q1pEb0tWTC9o?=
 =?utf-8?Q?lPoBUjuPZDJGA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdadc591-6249-4ccf-795c-08d8bf810d0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2021 09:27:06.3002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vLPD8EKlpyCgiQSVnT3YH3NF6Pa1QeWIKAAYwwH+uFr4QLKb0xLpShNR1a/P3PBapFquL+H9DUr4MwcV6c8xsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5628
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBGcm9tOiBTRU8gSE9ZT1VORyA8aHk1MC5zZW9Ac2Ftc3VuZy5jb20+DQo+IA0KPiBUdXJu
aW5nIG9uIHdyaXRlIGJvb3N0ZXIgc2hvdWxkIGV2ZW50dWFsbHkgbGVhZCB0bw0KPiBpbmNyZWFz
aW5nIHBvd2VyIGNvbnN1bXB0aW9uIGFuZCBpdCBuZWVkcyBiZSBjb250cm9sbGVkDQo+IGJ5IGEg
cG9saWN5IHdoaWNoIHNob3VsZCBiZSB2ZW5kb3Igc3BlY2lmaWMuIEJlY2FzdWUNCj4gaXQncyBk
ZXJpdmVkIGZyb20gc3lzdGVtIHJlcXVpcmVtZW50cy4NCj4gDQo+IFNvIG5lZWQgdG8gbWFrZSB0
aGlzIGJlIGNhbGxlZCBmcm9tIG91dHNpZGUuDQpGYWlyIGVub3VnaC4NCkJ1dCB5b3UgbmVlZCB0
byBzaGFyZSB0aGlzICJwb2xpY3kiIC0gb3RoZXJ3aXNlIHRoaXMgaXMganVzdCBhIGRlYWQgY29k
ZS4NCkZldyBtb250aHMgYWdvLCBTRU8gSE9ZT1VORyBwdWJsaXNoIGEgUkZDIG1ha2luZyB3YiBp
bXBsZW1lbnRhdGlvbiB2ZW5kb3Igc3BlY2lmaWMuDQpJZiB0aGlzIGlzIGEgcmVzZW5kIGF0dGVt
cHQgb2YgdGhhdCBzZXJpZXMgLSBwbGVhc2UgbWFrZSBub3RlIG9mIHRoYXQuDQoNClRoYW5rcywN
CkF2cmkgDQo=
