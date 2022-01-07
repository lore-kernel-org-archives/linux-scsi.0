Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E976C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Jan 2022 11:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346982AbiAGLMQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Jan 2022 06:12:16 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:3578 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbiAGLMQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2022 06:12:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641553936; x=1673089936;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=03XwKKlAM8sH8Lgyx5yLPYnCv8lW4ai5H1FhaY5s+wo=;
  b=wksLjiBLej61UJ7VA09n+7kgY5F5Ab1FthKD0EJ/4Md7AGiL+Yxxg8hX
   dlRHZ1cbX0Lzvm3OrCE1L5GoK1pcCgEhChTCbKQ9eq82tMD9cKuYifPrk
   oWVvNYwoY+Yh0hW91rEmD0HuYLnYMHvL143361wOJnGx9mM3mFSMzSEKf
   FyalE0Uq4dN3hpcY62vwhyH0k0Iib+bLyYS9D/xFruPmnglqklKh1YYGo
   xxWuIU4APN9KihTVG4VlP/yvc56nEgI0INjarJuyn5999uOIBJ4Q0u2cV
   rERyej+zFsVg1qSpSKzaiY6r8GMyqXoDXOLgPTVzPkF1fs9C+TYo2ZHTQ
   Q==;
IronPort-SDR: w17rubazMHl9i37zBIul86HaiBGJPVRZPjuzEysfFg0oe6EXiANCSO1h5oSpMv9HCadXUSk1VN
 N9EkDHzpwE3AVGfI+yiqjqd8yMvb+5MSUv6fgTib6XJcr2RW65/0Y6b9hFInnlOUmfwHGSN5gK
 OdTSI0YcDv9BEcH9XLNWlmk3AFT5LrPhH39DelIc7reIc57iN1sSrISl4KnLzKTvoKjnq3qZVM
 QA27cXrmGqTEuZGYTJfb6+6l2cpWGKt5uxmzpPswNZpB2yPLQUt7exb982P6roO39nV0Jksh17
 GhzQeBdt3oOeilt34O1X7s+a
X-IronPort-AV: E=Sophos;i="5.88,269,1635231600"; 
   d="scan'208";a="148881891"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jan 2022 04:12:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 7 Jan 2022 04:12:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 7 Jan 2022 04:12:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzADCcgvuMM7bg0lpnQDUcBtqXzZfiSxXLVRnWV+zQW09gbaXqgqtVxJ/Kxhlt/LcYpjtTiUKmtlkcG5giSwMSIygu+J+xPATW6fsyauKP8sOXc3EPIkNDrFtous4GsHwbJCBev6Z1F/IF3wLkViu7psGtbmBXN5MkoeFmZ4hMFo4HdxKkO/n+9SSW/WCHchwOfrJs4yXVd49bGEjyWGZuWfigHuAd1E88W2IC4SMCwAL9JR0RqY13wLGaZ4GlS2I7bnCA7BV24MrUDIrpzTHTg1fSXTUW5DSlRaijOwe2KFaSVCmRkflKy+Ym/eSgHOCK9cuTFjcZdvVkbjNkt8zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03XwKKlAM8sH8Lgyx5yLPYnCv8lW4ai5H1FhaY5s+wo=;
 b=Q0BdHApCtodbimVQ0UMwo6mxo7G97Frdq754VFP7cPb3fyKzMOpESbK6z3qZwTDB/zoQOw+6U6mvGnSWDG7+/0w806tuskfrheb7CHCdA6s6SxZZoGUI70lEdY7FyK9gKzsIK2RJhHjdiypowFeSKcrkXVHP1iOH3RebqzgC9ns/Z2tUmE3VqsoByHSWi5uk5n8Q/cvJjuY4Bftoftosxr3Lnns6FMXvQqzwiQAMj9PiYUM5Jl8WrpCB3eJ7LL7ohBXlHJBarhMd/Gd0WBfdMo/CJ57AUz/+wP9AisTIdW02vjanrR1aSlKW8kvqAjL+wvBesKskDzwTbqwYkuIKTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03XwKKlAM8sH8Lgyx5yLPYnCv8lW4ai5H1FhaY5s+wo=;
 b=NCV7DC/78OuM5WZ+/BhZFrR4nMQfILkdBgD5nwKd6z5+Rf2YGxx56HRpnJu8X8e25XPL67Rl7CM4fU/hdH9ufUR7l4Oje+mo2WpDD9nn0x9uWpRv/kCI/e5G8V8CtylCL94XDI3A50E4qnA0AXwV5KD+tlfLebUedt777IGkzPA=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by PH0PR11MB4870.namprd11.prod.outlook.com (2603:10b6:510:34::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 11:12:13 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::ec81:740d:c5cf:5ad0]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::ec81:740d:c5cf:5ad0%5]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 11:12:13 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <john.garry@huawei.com>, <jinpu.wang@ionos.com>,
        <Viswas.G@microchip.com>
CC:     <linux-scsi@vger.kernel.org>, <vishakhavc@google.com>,
        <ipylypiv@google.com>, <Ruksar.devadi@microchip.com>,
        <damien.lemoal@opensource.wdc.com>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>
Subject: RE: [issue report] pm8001 issues (was driver crashes with IOMMU
 enabled)
Thread-Topic: [issue report] pm8001 issues (was driver crashes with IOMMU
 enabled)
Thread-Index: AQHX+KUJaMkhjLzSFEiHPF663Zk+AqxBieQAgATH0tCAD+byAIABQ17g
Date:   Fri, 7 Jan 2022 11:12:13 +0000
Message-ID: <PH0PR11MB5112F2D4A506B0FE6DC5B01BEC4D9@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
 <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
 <00505633-c8c0-8213-8909-482bf43661cd@huawei.com>
 <1cc92b2d-3670-7843-d68a-06fe68521d24@huawei.com>
 <fd0eafc6-9443-fe5e-2c2f-91d6bbe8b174@huawei.com>
 <PH0PR11MB5112EBE80F9A4AD199866CA7EC429@PH0PR11MB5112.namprd11.prod.outlook.com>
 <0cc0c435-b4f2-9c76-258d-865ba50a29dd@huawei.com>
In-Reply-To: <0cc0c435-b4f2-9c76-258d-865ba50a29dd@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d327bdc-3c23-4933-dcf9-08d9d1ce8e5d
x-ms-traffictypediagnostic: PH0PR11MB4870:EE_
x-microsoft-antispam-prvs: <PH0PR11MB4870983FE73D8B4E84AF0507EC4D9@PH0PR11MB4870.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uR7XYd6ndG/4YjVtsmfB/ynKScFfFPmFz8kuVbTloLYqXoa2WtF/7tY3KrzmDaozkvhxDEw5TplORBqtgqw0z1TFUMfNvZRcdiB8z/76l2uTxfzlEBqONpRO1ydMof6AnNpbTp95MdeIptkwGRkrgtP6nB8YqIx0qki2ChLKqSRdzHz+n0EdFaAVY5+PQQAah2EOUPrmZ0978dhtv5plqyKKye2/bHAjfDl9c0+nvdPY+pATo1uBM9svSGSzhG2UQoYEw93ajgAWVaJQui4e8Yj5eI3xl/Hx8AzT33V2jBl7LZ/jS6HRz9EEOpzhKLfo/vaZzP6vToVrmJsBDh2Ltqe6tynDK94RAmVXLW+v4PDgiXLvbKEOZS8FAHw3o14Ka0BZf6FQPkGKzIHH2ekEmrQEhL3qfeAD+zH/UDbB+UONVMPO01qLGY2EJ8trtEMefRrwsUfADBtVc1CSsoL3sXHptvq5AML6J3FRmgh6Wjo2PPFgY+gI9VtFADbS2h1GlroSsgfP+oGKeO0tlwzuCgyMaGKKRObMZk4dTQKed6645rCSY1PkVaWl2rZRPdM4jilpydcjcHkCFloQuEU8BxaJU5gadcBap+IDwZkvic18KWOB/H5FtxsucIkS6Z/x6jUuaHnDoSKEjWB+KX7xSBi3jnf3InDVTjEKZ8SMFGLhsJSKXNaTaoKjS5BiC5brB+hl+Wio1odTNCC5kh6yIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6636002)(52536014)(38100700002)(508600001)(6506007)(4326008)(53546011)(64756008)(71200400001)(9686003)(122000001)(86362001)(38070700005)(316002)(66556008)(66446008)(186003)(55016003)(33656002)(83380400001)(107886003)(66946007)(76116006)(54906003)(2906002)(110136005)(26005)(7696005)(8676002)(8936002)(5660300002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUdLM29jMEtKZ0dkUXJHQU5PMWZ1eFVVM2d3RHBsSVY4VlVqL2d4MmlQMTNm?=
 =?utf-8?B?cHdla0hOM0VUQzFMQ0xSd0xXemNhV0V3UThYYy9mOUdLYzNWWE5aSnl6VlhI?=
 =?utf-8?B?MlNkb2RyM2tGMFVpcEt6eTFUajVRTW9xTmdmc1FmVEtOajdvSEQrQ3JxQUxU?=
 =?utf-8?B?QmZiTC9HWEhqV3lxclhjV1hXYnp1Yjl3Y3pjTGttZVFKbkZvNXFQdHp2bnB5?=
 =?utf-8?B?b2JCTk9kTzJ5UjJhY1pyVDlmV2xiU3hNSUpWWXFOa1J2b3ZoMXVrcytTdGNs?=
 =?utf-8?B?cWoreXlSWlB5RFdqb3RVa2NpYXhzU0g5UzVUZHpveWRsaUJObVo2UWpWY3Js?=
 =?utf-8?B?Z05DaDh5UzZwYlVUbmgxYkQ0L0xJSUF6ZlFMeDZSSjJEYXFuV29RWVIweVp4?=
 =?utf-8?B?TWhkNGl0by84V3dRS0M3UzhDQytBdkEvWm1BZ3dROVlaZmxBZjExZkp4dDA1?=
 =?utf-8?B?S041YlRHeXdhdlJtenNzaGxIaHBWNHdpbmN3ZDh2WkFRMkM1OVIrTklJaGpm?=
 =?utf-8?B?emlDc0g4Wnd6enBaYlh0dEExZUpxZmViN054U2ZGa2E2NnNkUWQ5K0FYKzlC?=
 =?utf-8?B?QlhJVlh4MCtReTVNdWYrUnZQK2lDaTVXdGlWM216NTJpQlVUQmorV3RBQXh5?=
 =?utf-8?B?SjN4dVJvTC8ycTBSWGdxcHBGWmlnL3oybWVTTGN1NE16QUcyeFdBN1VFWVdh?=
 =?utf-8?B?Y3h1Mk5tT1NIT2tuMmdEYU1SYWUyUEZXNVJGNUlSOVJhZk5aUWlKNFdTVVJ5?=
 =?utf-8?B?RDhCWTF4TUxuOG1OKzd4ZENyVzVKSXFZNFpyU3dIWlN1cHZWUjhBWEZCR3pk?=
 =?utf-8?B?M2RxT21BcSsxdEF0ZFE1Zmo2a1pndi9HT2dtd2JiKzVuSTBKUXhZWDV3eHd3?=
 =?utf-8?B?WUVHT0JlRXc5MUlobThXTmJkeHJ0bEw1WTQ5REUzSEtTKzlNcGJ1ajRmaFpi?=
 =?utf-8?B?djI0RFJJLzJyWHNRT1Q2RFRkcnN2dGdobmRoaFFRYmg5ajY5WkovZjU3R2hS?=
 =?utf-8?B?NlJiQzQ3NTl4dWhsbzkvK096M0Y5MjFwQWdxUGc0UFJsY0VyZkxCbmtneVBI?=
 =?utf-8?B?bVJxVkp6YXhGMHVDR0Jxd3g2OWNEaVA3cE1ieFM2akt4L2R0STA1S3VHVFFn?=
 =?utf-8?B?OTNoYXQxcjVSbUwzVVVsMkxGTWVDMlphL2gyampodWcraWZ5eWtqQVRDckZl?=
 =?utf-8?B?TGlhbm00OHN0Mk95dWk0TFR4Y0tqMHZSODNwWjNySU0zdDg4ZEcrNVNDM240?=
 =?utf-8?B?K3FjUE15d1BtTzlGc05IU0Ruc09XWmVEa0VNWUFhSG1mbmd4M011bExnRVFP?=
 =?utf-8?B?OHY3OVFZRks3cWJkNkNudjdDZ2R3VmZnQWp0VXViWXdZTHR3OEJsdjNVemk0?=
 =?utf-8?B?MnhqZGIvcVZzMEpISTA4U2JDbXFuYmtUMkZ2aG5LRWNleVZGZWtWb1dsY2k5?=
 =?utf-8?B?bk4ya0xCU0p3bFZ6QjNrZXdvZUVPS2x3VFhIN2dFQ2F2STBQcmlsbGhjTnpi?=
 =?utf-8?B?RmZrMEcrdUdIMUJNNnVNR3Z1Z3RNT04zTlRBYlorcHFSdW4xdDJWU3ZxazJO?=
 =?utf-8?B?VUNWQ2c4aFZSQlA4Tllja2N5TWtnVjJYUi9OOVRjTHNGbFMrdzBzcHliM3Nt?=
 =?utf-8?B?ajBvNnVlQ3A0N2YvM3o1SnRGdkJjOGgwOVFyS3RsOFJUNGtZWnNibnBEYmxr?=
 =?utf-8?B?RlVPQ2tpZXVZSzJlQThHckJGVDlXamUrVFUwWTFvQ3lmdGUxUHZWNmhVOC9D?=
 =?utf-8?B?WVNldnlUUDA0OWMyVGordy9uR1B0RTUzNHhwemZWNU9lc1B1eGdLcmxSRkhU?=
 =?utf-8?B?SDl6cy82ZnhFdHRMOTdtWkVTOURHSytoYnZQUUZTVGF3UDJud3dYOFpYT1Ra?=
 =?utf-8?B?Q252MkxDSGpPU0hZbkZ3NEp0RThtQmNINnF1LzRMc1djblArTUR0V0d6Z3Yy?=
 =?utf-8?B?VE9SYUJ1Y0pDVnpWYkt4bzB2MVdVQ0h3K1ZXc2ZlOU9LcTIxNmRNUXRtQ3JC?=
 =?utf-8?B?QUJkT0JFZ3ptNk84NnE0bTNOb2FYSTJPcW1KazR1bmNKYVVsNVdvbkJidXEw?=
 =?utf-8?B?eUk3L24walR1Q1VLaGZtTFI4ZTRKWE1neXZPUFdYL0RUZUh3V2pRaUFtV2Zm?=
 =?utf-8?B?WTFaWUcrK0tCOG5Ld2V4QUlibFN5SDJjelh2M3RnVE1ydllKaFROSTNKMFhx?=
 =?utf-8?B?S3BWVjBGZ3B1TENLU25Gd0ZEd29senZ1U1hFZlBHMG9taG5SWDF3bk5YLzF4?=
 =?utf-8?B?N3Q1NEM3d3kwQVZHaHRwbzRpTlN3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d327bdc-3c23-4933-dcf9-08d9d1ce8e5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2022 11:12:13.0684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AyYueSn4D0+OH9qdTxD68uY/AdJYiV7638aq6OfGaEGQpJEmlPKfBuL/cFgd6CMn+KdqzNxl8Zx4ri9DNkDCZ9ALI7WZt1LrOa04L3B3KwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4870
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSm9obiwNCj4gDQo+IE9uIDI3LzEyLzIwMjEgMTM6MjYsIEFqaXNoLktvc2h5QG1pY3JvY2hp
cC5jb20gd3JvdGU6DQo+ID4gUmVnYXJkaW5nIG1heGNwdXM9MSBpc3N1ZSwgd2lsbCBjaGVjayBh
bmQgdHJ5IHRvIHJlcHJvZHVjZSB0aGUgc2FtZSBvbg0KPiA+IHg4NiBzZXJ2ZXIuDQo+ID4NCj4g
PiBBbmQgZm9yIEFSTSBpc3N1ZXMsIG5lZWQgdG8gY2hlY2sgaW50ZXJuYWxseSBhcyBpdCB3YXMg
bmV2ZXIgdGVzdGVkDQo+ID4gZm9yIHRoZSBzYW1lLg0KPiANCj4gSSBoYXZlIGZvdW5kIGFub3Ro
ZXIgaXNzdWUuIFRoZXJlIGlzIGEgcG90ZW50aWFsIHVzZS1hZnRlci1mcmVlIGluDQo+IHBtODAw
MV90YXNrX2V4ZWMoKToNCj4gDQo+IHN0YXRpYyBpbnQgcG04MDAxX3Rhc2tfZXhlYygpDQo+IHsN
Cj4gICAgICAgICAuLi4NCj4gICAgICAgICBjYXNlIFNBU19QUk9UT0NPTF9TU1A6DQo+ICAgICAg
ICAgYXRvbWljX2luYygmcG04MDAxX2Rldi0+cnVubmluZ19yZXEpOw0KPiAgICAgICAgIGlmIChp
c190bWYpDQo+ICAgICAgICAgICAgICAgICByYyA9IHBtODAwMV90YXNrX3ByZXBfc3NwX3RtKC4u
Lik7DQo+ICAgICAgICAgZWxzZQ0KPiAgICAgICAgICAgICAgICAgcmMgPSBwbTgwMDFfdGFza19w
cmVwX3NzcChwbTgwMDFfaGEsIGNjYik7DQo+ICAgICAgICAgYnJlYWs7DQo+ICAgICAgICAgLi4u
DQo+IA0KPiAgICAgICAgIGlmIChyYykgew0KPiAgICAgICAgICAgICAgICAgcG04MDAxX2RiZyhw
bTgwMDFfaGEsIElPLCAicmMgaXMgJXhcbiIsIHJjKTsNCj4gICAgICAgICAgICAgICAgIGF0b21p
Y19kZWMoJnBtODAwMV9kZXYtPnJ1bm5pbmdfcmVxKTsNCj4gICAgICAgICAgICAgICAgIGdvdG8g
ZXJyX291dF90YWc7DQo+ICAgICAgICAgfQ0KPiAgICAgICAgIC8qIFRPRE86IHNlbGVjdCBub3Jt
YWwgb3IgaGlnaCBwcmlvcml0eSAqLw0KPiAgICAgICAgIHNwaW5fbG9jaygmdC0+dGFza19zdGF0
ZV9sb2NrKTsgKioqKg0KPiAgICAgICAgIHQtPnRhc2tfc3RhdGVfZmxhZ3MgfD0gU0FTX1RBU0tf
QVRfSU5JVElBVE9SOw0KPiAgICAgICAgIHNwaW5fdW5sb2NrKCZ0LT50YXNrX3N0YXRlX2xvY2sp
Ow0KPiAgICAgICAgIC4uLg0KPiB9DQo+IA0KPiANCj4gT25jZSB0aGUgdGFzayBpcyBkaXNwYXRj
aGVkIHRvIEhXIGF0ICoqKiosIGl0IGlzIGNvbXBsZXRlZCBhc3luYywgaS5lLg0KPiBpdCBtYXkg
YmUgY29tcGxldGVkIGFuZCBmcmVlZCBhdCBhbnkgcG9pbnQsIGV2ZW4gYmVmb3JlIHRoZSBkaXNw
YXRjaA0KPiBmdW5jdGlvbiByZXR1cm5zLiBTbyBpdCBpcyBpbGxlZ2FsIHRvIHRvdWNoIHRoZSB0
YXNrIGF0IHRoaXMgcG9pbnQgYW5kIHRoZSB0YXNrDQo+IHN0YXRlIG11c3QgYmUgdXBkYXRlZCBi
ZWZvcmUgZmluYWwgZGlzcGF0Y2ggdG8gdGhlIEhXLiBJZiB5b3UgZW5hYmxlIEtBU0FODQo+IHlv
dSB3aWxsIHByb2Igc2VlIGl0IHllbGwgbGlrZSBJIHNhdy4NCj4gDQoNCkkgdG9vIGhhdmUgc2lt
aWxhciB0aG91Z2h0IGhlcmUuIEFmdGVyIGRpc3BhdGNoIHRvIEhXLCBubyBwb2ludCB0byB0b3Vj
aCB0aGUNCnRhc2sgc3RhdGUuIEJ1dCBzaW5jZSB0aGUgY29kZSBpcyBpbiBJTyBwYXRoLCBtYXkg
bmVlZCBmdXJ0aGVyIHRlc3RpbmcuIA0KDQo+IFRoYW5rcywNCj4gam9obg0KDQpUaGFua3MsDQpB
amlzaA0K
