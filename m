Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900C7C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 20:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58F2664EE8
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 20:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhBEShP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 13:37:15 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12944 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbhBEPKZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 10:10:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612543752; x=1644079752;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uGT+jCEIm8uAtXyx7HSAG4VFynnr/XzbYU05Tx1hxC4=;
  b=GvE4T3aGlnSbcGUa3dOK3JylVpZOGSccZevTWOXxCr18bCCwQVFLV9sc
   jMjG4PCf6LRWIqf0Zrz6N/2K4Kn1WZCIbWBEBpRlKlss97qHbZEPU/cm4
   +k7qtxJF0LEi2rmOl2OUkz12TTI9p4X6Z/GcSftCZfH+Cf2rCjQ70bOBm
   W1wwYCNojxtFImEsNW/6CyazsEb1MGvscZkt0gsBv13Zn3JpyScWdxSlI
   uQhK3MFiAcjNK+NYKhh2+5MYxlDDJJp9X+kfjVzUtmbOpDdMQtxzBfooI
   T3u33fGg9vycDERw/KE7Ncz2BURv+ZGWjF1It2kSbNdi9SPfnyLFFv1gv
   Q==;
IronPort-SDR: dauakS5rYvbHrIFfZtV2qBvvczOJWNWv1lYPaHv2s8/chqDaa2emdjnFZHT6ri0YQpVeRPu6vk
 cXl2UEUozbSne07xWoAfHVvkywcRDRzd8DL2ZMMioq1jB+Ilwe+ZWpZKQqMgoBn0Xc3Refzqe9
 wNb5IIx4YVquf6Vvi3rOzMl9w04fBhHYvjhmAucNdy+D63mNZ5x+5bHxlugWeN1Zx3jan3u8Gs
 LPuj8vbzOo5PyS9RobkK5A0HGTyyzbukuuYaBIkNM7PqWlos0tjB5nCjARqe1S0BC5l97YfzNV
 h1A=
X-IronPort-AV: E=Sophos;i="5.81,155,1610380800"; 
   d="scan'208";a="159232436"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2021 22:06:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NY/h4BWZPSxqRoiagde/W0DHq0DIztztthuvvVw3VvLL9PflibZWweD/+tlpQ7oUC32RHEgmZUzDpE0+C4OYYQtEwP1WLi9k2CArKK2NYTPYLwRT0hl0ZNBRFJtfXvxgngYDU5LxM1WnbY3u+JU6KFp/IsXEhf/Zpc79y92ptupQNuhMIvzZMWm9R9b86rmHqul7LOtC/cdMkre1KJKES0ARtk1S/FoqACle0ogd3iuOjsO0f9250WmNbDgN9CbYH3NOm48J8/hNjzyOOFsR/Qu5faTvttzYxYx9L1qCMnwrMCoqioQXlnzf+de/zhLZHz8iYJbDvLTXis0T9uUGjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGT+jCEIm8uAtXyx7HSAG4VFynnr/XzbYU05Tx1hxC4=;
 b=S/ATqDqF5NW9nUk3eR/mvC7YtnCd8BTPYRX4nuK1zF7JgZ3enBZ/8T8tM0e4urhvpjcLTwZ1i6+sSa4pJwPh7+kmqGCDe6aM7oJbzV2SLMU4gan9HvtmP4O8yb6ytZt6ibsWV/iZPXWbWIa0OH8McslubxxLsX8bakFOJBK1dWhtJNn0cEuS1/c3qFKTGrKyXp6yFhlT/PHlyN7T9l9NXgVN/U1GyeVe3marQuKk+1R19ayfEpZ2+vRTLhRvv4jm0AXdz0UTlARmIOAUEhxCLXHiDXzqFZozx38IsKjSnVJneS7tvc+wLh06R8dEr0YIH65VQpDp7UHB4qPwXQ4aWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGT+jCEIm8uAtXyx7HSAG4VFynnr/XzbYU05Tx1hxC4=;
 b=btCfQaG6WsNMKOjqiLbUT1SXGkttbovC7xBhyN/6tbd0KyQAxogMF070NbGiK0lNHoQxTWnmG8ikvCl7rjWyfXR5XIlXED18mojsvrZCNNYxLmryri2Rq7n5gZR3FeNJCojw9WPoeutVykJQe+HBX0fccJqpEVOQNsZ8u6H4GKg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1258.namprd04.prod.outlook.com (2603:10b6:4:43::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.23; Fri, 5 Feb 2021 14:06:18 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Fri, 5 Feb 2021
 14:06:18 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: RE: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached sub-region
Thread-Topic: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: AQHW9f/qdUh60Je+wEOqZcug0RLrV6pI8k8AgACYY4CAABha8A==
Date:   Fri, 5 Feb 2021 14:06:18 +0000
Message-ID: <DM6PR04MB657522B94AB436CF096460F6FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
         <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
         <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
         <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
 <b6a8652c00411e3f71d33e7a6322f49eb5701039.camel@gmail.com>
In-Reply-To: <b6a8652c00411e3f71d33e7a6322f49eb5701039.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bbfbece1-b988-4ef2-5ec1-08d8c9df3596
x-ms-traffictypediagnostic: DM5PR04MB1258:
x-microsoft-antispam-prvs: <DM5PR04MB1258CF89CB36C2DB359E5CB3FCB29@DM5PR04MB1258.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cwIDxe1SelG74JwPY/swIWp6Ag4BcpD7AoDWXLD37j8JSXL2oq43z0c8J7xV2lAd+2cCjUy3FZMn+1T6IVvP2r9d2V2PX/kNWSTLIezHdy+5yyM6CMoFuPhI1iNCZcdncBhFOltHq8uwdOlp7xf7gg162I+PluengmK1xeB0k2KSdU52fpUpB+Zycd3wvf6QURrsTpKJ68AxdYGMEWuLEfuwo7i1Hkz41DKUdezGwSDbBjCrwXMpddnzPoXQRdAhMuyVUNYouamu9Ua95Daepm1A7OgmfhO150Dg9qH6CqLtoIelJtd6rGrGFbBpVCsN441HWaPpVVL71MJM0wxp/DDnbR1yk4O+fBDAj7vCuJbgDvLasU0Q3phKwBVB0NijJjSetFbWM4HMs0yMjB5DQEyHpeN4C+KRVZ71PPSnBuiN/jqS7ippeOJ+5B0TTvs8zO88RMYMZsBhqA9VyFHEgFOqRnnM+vrUCPbTE7VYhUQboDaduATbAj7SLBgpgIPRGbTISAFL9OV/UrUwGjejiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(64756008)(478600001)(71200400001)(66946007)(66556008)(76116006)(66476007)(4326008)(66446008)(6506007)(86362001)(9686003)(54906003)(110136005)(8936002)(7696005)(83380400001)(52536014)(186003)(2906002)(8676002)(4744005)(55016002)(5660300002)(33656002)(7416002)(316002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eUQwV3BLdW54MUV4QlUvK3JDZVd1cm8xc3dIbGpHMHlTdzJpdStKVWRPTzdk?=
 =?utf-8?B?WHpEMDZwR1RKcDlmQW8ya2R4OWNScm1XbzYxSDh6dVpzb3RHTnlCaEkvK0xi?=
 =?utf-8?B?aWpWQUM1M1dOa3l4VnMwMVJRNzUrcU9wSE1FVkNkNEw5TmVDbWFrK1JjYkJt?=
 =?utf-8?B?YVBpc3lMNURkSEJKM041bmpnSFFPTzEvYkliRU13b2lxNlo0OEdMcG4xSGZr?=
 =?utf-8?B?akhLY1V0aEFuckxmSkNvOVdlUnZuQkdGZ0pla1ZMcElVZVRPcWpPYnhybmlv?=
 =?utf-8?B?M3ZraVZ2dS82VThOSi9KZ0JXTFA2T2trdCtDNHl2RmlFbU0yaGt4aXlKaGdv?=
 =?utf-8?B?Q2FnWXNGRDFpdDROOUd5NmM1RGtIbFBPVEsrQi8xOS9JZi95dUNmM25xcFVY?=
 =?utf-8?B?aEVBTTBvQ2Q0aWpHZHBOZzh2LzJVNnBpMWw4WGFvTEFoeWRZSmtzR2VNeUY4?=
 =?utf-8?B?bUFiZ1BsVHZuNzRKM0Zpd3podkxibENSVUJqYXI5bTlLR292WUR5bTBNZXdV?=
 =?utf-8?B?cXFFVTRGUHlRMFkvZDFJQitKaGEzTFdyd29CN0F3WWF0c3BHV1hTcjVTMGY2?=
 =?utf-8?B?NGRURjhaQjZ5NDJlU2Y2cFJta0J4Zlk5bFI2THJ4RS9CMi9jMDB0VWozT2JO?=
 =?utf-8?B?ZlR4a2lWL1kra2o2OFFaVmVuTGpnMDBETVpteTZCNlVlcGFkY1JWYlBxWjB6?=
 =?utf-8?B?ZkkvcnBlSmdsdlpRcEZJSk5henNVVnFpM0dNOXg1NnlvUmhBS3FURUd6Y0k0?=
 =?utf-8?B?eVJwSncvcmxjcjZNQyt5UGVueThQNndDcW0rOFlaUmlIRUl1QmZ3YjZOVGZv?=
 =?utf-8?B?VGVFMGN3b29JdlRKNkMwYU16cEJaNFZKQVlZeitaZzdrakpXdktQdWFNaW1j?=
 =?utf-8?B?S2NqaTdkc1RsSzhvc0Z2YlVYaXpBNWd1T1hlMy92WHVyZjR4TnVzZkVRTzZn?=
 =?utf-8?B?WE8zSlZ0ODMwRVZJRm9ZdFRZS1ZBNmg1aGZwSC9POU1Rck1ESG5jSlhtSmtr?=
 =?utf-8?B?VFpMZzdhRHQ3eVJxM0xnN3IvS1hUVVA0WUlwSzc5eWw4TnVIK1FkUW1RWWlK?=
 =?utf-8?B?d21OZ3U3UC9pTHR0OS9sNUxScCtuVkhqTEV4Mk1MdmQxaStrSm9wbCs0NzR1?=
 =?utf-8?B?ZEw0Z2tRajZMZUwxekRwdy9uVkp0UzFlcGZPRDlzSmpHOWdPblZiK0dtUCtZ?=
 =?utf-8?B?VWkxS1pOTXJ2M2syckprbndrSVFtdWFYNXk0SC8xeFEzT25OVHlXQU5WREU0?=
 =?utf-8?B?WTArRWVobi93R3Q4QlpxYStDTkJ6VEZwS01FOFhRUGlIOFlhNUJVckZycXQ4?=
 =?utf-8?B?aGFOcGZvRGZFM2lRS2tMb0xyNGxpYSt4QmtzcWZEdzlqN1ZGRnc0cTJHYWZi?=
 =?utf-8?B?NXNNNEVMVkptWG9MWitDYkxpcW5oMVMrYnRFaHJ5eGtwUFdNeVg3c0pZcnlz?=
 =?utf-8?B?eXBXVGlucmgwY25GdW9EeXFZN1F2L3dVQ1NCYjk0QTkzRXpOZTBydW4yRGU2?=
 =?utf-8?B?d0JQeGc5b2xDcWQ0UnhQUTNtUGhYTjVkUXlYWE1TdUREei9abGE2d0taWEZ3?=
 =?utf-8?B?TlpDTWgrU3lTSzFYem8rcUhwWXJWbzN4Q2dVd2R1aUJ2M1lyNllUaDYvWWUx?=
 =?utf-8?B?ZkhRc3JWK3F5ek40b2VRbEY3Q1FTK0FadTN6aS9qVCtlUUtBdkt4SytvSjF6?=
 =?utf-8?B?Q091dklNSlNRZVNDenhtbk8zbVhFS1p3VTZiYTNVZXRBSE5TN1RHcjJVTGRF?=
 =?utf-8?Q?wH4Lps3TwRLH29nPw66aQJPhYKZknbVU84o0kOs?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbfbece1-b988-4ef2-5ec1-08d8c9df3596
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 14:06:18.5707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PL1mZbOtrxG2bbS7iwURNqzLEfV4IczGse3DfU6R/Eq9Cdz2KrSUowks0Aar/Ui0FjzFaDNq5Ffft67mnOFBng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1258
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gKyAgICAgcHV0X3VuYWxpZ25lZF9iZTY0KHBwbiwgJmNkYls2XSk7DQo+ID4NCj4gPiBZ
b3UgYXJlIGFzc3VtaW5nIHRoZSBIUEIgZW50cmllcyByZWFkIG91dCBieSAiSFBCIFJlYWQgQnVm
ZmVyIiBjbWQNCj4gPiBhcmUNCj4gPiBpbiBMaXR0bGUNCj4gPiBFbmRpYW4sIHdoaWNoIGlzIHdo
eSB5b3UgYXJlIHVzaW5nIHB1dF91bmFsaWduZWRfYmU2NCBoZXJlLiBIb3dldmVyLA0KPiA+IHRo
aXMgYXNzdW1wdGlvbg0KPiA+IGlzIG5vdCByaWdodCBmb3IgYWxsIHRoZSBvdGhlciBmbGFzaCB2
ZW5kb3JzIC0gSFBCIGVudHJpZXMgcmVhZCBvdXQNCj4gPiBieQ0KPiA+ICJIUEIgUmVhZCBCdWZm
ZXIiDQo+ID4gY21kIG1heSBjb21lIGluIEJpZyBFbmRpYW4sIGlmIHNvLCB0aGVpciByYW5kb20g
cmVhZCBwZXJmb3JtYW5jZSBhcmUNCj4gPiBzY3Jld2VkLg0KPiANCj4gRm9yIHRoaXMgcXVlc3Rp
b24sIGl0IGlzIHZlcnkgaGFyZCB0byBtYWtlIGEgY29ycmVjdCBmb3JtYXQgc2luY2UgdGhlDQo+
IFNwZWMgZG9lc24ndCBnaXZlIGEgY2xlYXIgZGVmaW5pdGlvbi4gU2hvdWxkIHdlIGhhdmUgYSBk
ZWZhdWx0IGZvcm1hdCwNCj4gaWYgdGhlcmUgaXMgY29uZmxpY3QsIGFuZCB0aGVuIGFkZCBxdWly
ayBvciBhZGQgYSB2ZW5kb3Itc3BlY2lmaWMNCj4gdGFibGU/DQo+IA0KPiBIaSBBdnJpDQo+IERv
IHlvdSBoYXZlIGEgZ29vZCBpZGVhPw0KSSBkb24ndCBrbm93LiAgQmV0dGVyIGxldCBEYWVqdW4g
YW5zd2VyIHRoaXMuDQpUaGlzIHdhcyB3b3JraW5nIGZvciBtZSBmb3IgYm90aCBHYWxheHkgUzIw
IChFeHlub3MpIGFzIHdlbGwgYXMgWGlhb21pIE1pMTAgKDgyNTApLg0KDQpUaGFua3MsDQpBdnJp
DQo=
