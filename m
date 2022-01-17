Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EAD0C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jan 2022 13:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbiAQN4P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jan 2022 08:56:15 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:17810 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiAQN4N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2022 08:56:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1642427773; x=1673963773;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zD5sCkIXqbEYNCTLOlLZ5Lqkc6eJDGccrC0CfveYDz4=;
  b=RsSAqQbETfFQ1//UK9ybF0XfsbgtRv2V63le3dbkfs1IGaKF9QqDFgs/
   DHxBoXtuqXZJmuOq/KITlX6tih2zxfZRfwAaZaHITcEZH6QGiFY0lepxi
   ygoVk9WE+J9v0wqcSf5rFXP6zN5G2nVTLvZnDRi/lOw858FVLoG61ghYg
   xS0aeP39WVpgz9DBV0sXm+46nnypB+pKke0ZPkD1ZRmjBjy9hu+pvemeJ
   zkBN5HHJXDKFky3wR0raUSrKHmHgnKWTDbLSeSdXznYat8lzuOUMRC5K+
   1FKoHpFZHsKOgX/D44jXz5NHf2Pu9JfuTOGmgW8oUY4HZC74MUjeRBxPY
   w==;
IronPort-SDR: tWELaBRPbraqvNBaNG9kD7eAHL6Z1Zp/00Wj5z8/AL/e++QDl2c3Gaj8PV2hI8RDvDJuXCEWG4
 1Te86edTfUAZ6ba9dyzT9a/+ZhBBF9DDkYve1mJJIyOydzlP6cAOsoNXNG1wcLupWLYs+PTh8q
 +y+SwCvi23nnS/PybOT4Gfed1xkqt+jW+2oDl7PaYmvqU0wokCvxoh/xsDhPjgCx2JFFf2bzCB
 nnqD+jQLhwSCG4eKoF4NNKps8FHoNwpH3RBpiUtU1/DUs9mdBuqAfqY/TnQV+5Ng6Zeus0+x0Y
 7JGquP2K88ILFpQcuUSRm2D+
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="158901553"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2022 06:56:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 17 Jan 2022 06:56:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Mon, 17 Jan 2022 06:56:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNGCeLvGq9VrarshD9O/iLcVII/23EG6UWP0GGfIZNDJW35OYGlEL02m+3n0iE8RAp+nU1Mn9JikEP9WNPKxsXx165VykG2zVg5qctz6hZCROmKN1IZT8NgVaooLPqva89eStXvSj6T0hA5wvve7XPax8dYhx70U9CPobNJsKvpJ4OI5MIG9ut11V+adVtBmm3cjznRfdLe7ivYWZZ+r6ZfUcPFoEoYCLhCctwkr5pqOOwbb+8Syuo1/COPB0o/7wp5HOtIrHklznUwh/N7dpo11NJ5Q49SweV17Vueda+Yo7EqQKll/KtD8W8EWAweVFYCyYfyxcHC8Q0LnQGlibg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zD5sCkIXqbEYNCTLOlLZ5Lqkc6eJDGccrC0CfveYDz4=;
 b=cx/v2Iu7v/be/yXBB9a6ZeyhZQ6iYj81LEa3ZJOqXneAi8qvF9ajLt2pGmos2Q53ZO6aGJejPcMhDYUQAh5HUmuCwHxwbyGE8hm1jDxewIdqS6H2WvHdjCNkV+BKe9VixGgyxYZmJkVBx+ym7TgqRQ0TTA11JFTl/Y/RXj+sFOrKaZLm5tMUOSqWiSiKXOWGNIRWhAYENTG2IB3MDraxrcX5vTLwNUIe744fL+NdyHtbveBIANWSzd/4tocFA/+SlsMixxeutznHIggPgcmR8wR2n0hJiIxd2TcWPSCzJQPqSvt6uy9cuup6kyPHrOVCZi6WsEFqh2AV0O+bzIlSzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zD5sCkIXqbEYNCTLOlLZ5Lqkc6eJDGccrC0CfveYDz4=;
 b=XwmlJJDFz2pdGJX6uT3otohPLgkxq685d1hIfeObq5MgykOKtF/it1XllTJYoON2czjrQK0/MbBn551+YP0k+wZV4TaKEBDkZ6voVQKouSH0b4HNsYLuuNBiCo12jbgHGIhErp/jVCOYi6YSCELMOiiKRArOztFdzGPfqxTTKwc=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by BN9PR11MB5483.namprd11.prod.outlook.com (2603:10b6:408:104::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Mon, 17 Jan
 2022 13:56:07 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::d469:8d33:e5f:8b9c]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::d469:8d33:e5f:8b9c%5]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 13:56:07 +0000
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
Thread-Index: AQHX+KUJaMkhjLzSFEiHPF663Zk+AqxBieQAgATH0tCAD+byAIABQ17ggAVR6YCAAQpd0IAAE0SAgAMLX3CAACh7gIAB1ocAgARLfMA=
Date:   Mon, 17 Jan 2022 13:56:06 +0000
Message-ID: <PH0PR11MB5112D8C17D9EA268C197893FEC579@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
 <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
 <00505633-c8c0-8213-8909-482bf43661cd@huawei.com>
 <1cc92b2d-3670-7843-d68a-06fe68521d24@huawei.com>
 <fd0eafc6-9443-fe5e-2c2f-91d6bbe8b174@huawei.com>
 <PH0PR11MB5112EBE80F9A4AD199866CA7EC429@PH0PR11MB5112.namprd11.prod.outlook.com>
 <0cc0c435-b4f2-9c76-258d-865ba50a29dd@huawei.com>
 <PH0PR11MB5112F2D4A506B0FE6DC5B01BEC4D9@PH0PR11MB5112.namprd11.prod.outlook.com>
 <34319d65-104d-55a0-175d-96cf3f0aea89@huawei.com>
 <PH0PR11MB511238B8FF7B44C375DDDFADEC519@PH0PR11MB5112.namprd11.prod.outlook.com>
 <75d042c1-cee5-ce91-e1cb-9e2b7bb1ce72@huawei.com>
 <PH0PR11MB5112E3E9787F20EDEB58D481EC539@PH0PR11MB5112.namprd11.prod.outlook.com>
 <05bec388-946d-057d-20d7-67ebe5f2cfdf@huawei.com>
 <477acff4-b9f7-f395-4bb1-c7d4985e2cac@huawei.com>
In-Reply-To: <477acff4-b9f7-f395-4bb1-c7d4985e2cac@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f212151-2201-47e9-6060-08d9d9c11bf8
x-ms-traffictypediagnostic: BN9PR11MB5483:EE_
x-microsoft-antispam-prvs: <BN9PR11MB5483FD4C07108C6771FFD12DEC579@BN9PR11MB5483.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hxdPm2IwN77EszTduw1bqMhc/tnpqmLESTpCtMg97bzAsC3/F096a1H3TCJkBMdWcNArfZFbPqbb6XRNmsY6QblQdNMlK0BFZJPEx+e9AocCsvfb5sbtPz2vz+eQLOTMmRSqf2FYGbOMJtNZ/QKEC26YgtdCl4nuprWSIROJXAswEWRy1DRvaL/HTn7ZEohNvndR5DvHgIKdfeAd0lbu4n387XXd/TPwa/KbLFxYgIULqAkzIJ3fRWjsHIgcNpoFSsOj/kZL42V6/UB3qDEj9bDOFC87dhRKm+8N/NYneuyW9rbcQHQyzkHxVP9YmTc/OVVKiltAnrfk0rMlZhOF+D4MxUgEOt576W2Xig2Yj2yeasCaQJmgJo1Brk3QDklVUJbXknQo1v9DDzmtT2R+Hn+79LeOyd3HeTVfHzQOsKdONRV9HlzHcb+GorW+f+vXzACkbjOONblrKE6/+DfJPU3WUUtKLqTGRg/1kFnj0Xg4PRRgv8ZBDvwT/3WAp0hjBWKaGuJVi6qvoezl32kJd1DkPX7s+myv+mqpDfzOhBPBN5euiH1jCd6V7hmdGfZoiH2+6hyElJ5MqFgijz+8ASrd4VAwrncoeyX2GBWSCss8ecCQrsnhHnukyMSfC+7Ydgyj0OeEgdEtqDAghQ93Iw0KktjGK6QWx99Yzf8ZzWi6zevVlw2Z0SFaXYFclOiP41hkCGWixDz4uezso5BtBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(2906002)(8676002)(38100700002)(6506007)(122000001)(66476007)(66556008)(8936002)(316002)(66446008)(64756008)(54906003)(66946007)(110136005)(76116006)(71200400001)(38070700005)(55236004)(6636002)(107886003)(5660300002)(33656002)(7696005)(26005)(9686003)(52536014)(186003)(508600001)(86362001)(4326008)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3E1cGxHbkl4c1NQSzZWM296TktGQTYrdEdpd3VMcDJTOS9WUDJYY2VQMTBE?=
 =?utf-8?B?UFhWSWlXczk3d2V3ZVA0Y1AzWmxZS2k4UjdBdURWbGJXbWZjSXQ5S3RhWW96?=
 =?utf-8?B?dURJbFdRNVRsWGZNd0N3Q2hGZVl4UzZJbkVqbURsb2x0aUdTanIvanU5YjA4?=
 =?utf-8?B?V3VFckdEM2dQd3FIT1o3WUk3MVNGMGErY3orM0J4MXE1clE2MGsrUlpxQjFD?=
 =?utf-8?B?azJzWUNTa0dEK0J1TnBMaCtQTk11Qnlib0dWV09zVWxMc1poQ094S3FBQm1I?=
 =?utf-8?B?L2ZTekhQSzV0c2NjdHRoYUp4SFUwb1A0UzQ5b3ZzdXF0ZVJicXJKSU9DY0Er?=
 =?utf-8?B?SEpMWkFzbGswbmpMTmRnUXl6NDVpckJXUzVxQW9YbndnRVRQZXpQbjhvWjc2?=
 =?utf-8?B?Ym1jMEhXVlhwL0NCdVh4Q1VrMXFaVE1FRnloSjNuSVluSWFQZ1VUOXhaWTRq?=
 =?utf-8?B?eEdqdDROaUhBQml6NnJBS0wwNVJtK2hRVFhvOWY4bnRCSjJQaGZ1V3lHVDdE?=
 =?utf-8?B?SFRkV0lVVnFtU0hzWVo4YSs0U3FRTGZQclZWWDFVOGtGYzQ3UldPZjlPNXhX?=
 =?utf-8?B?U2VzUSs1bU9WQWpWbEFKTWRBcnlyWVBNR0ZvdEphUGNiSFg2QW43dUYwY2JG?=
 =?utf-8?B?MWxHV281VUtEaEd2UStzWDY1RVBHdm1JM2VVYTdQNWhLTFFnS2g5Z1RLTTUv?=
 =?utf-8?B?dVYzSVA1S0FvcVlkYVpWemU4K3hDNkpESGVuU2Q4ZHdqQUxTL1hXaGNyRHVS?=
 =?utf-8?B?dGxVSEtRYWxjRWs1TXJ2YTVWK1lXS3cyTW5ITVREZ1lRS2sxdXVieFU1L3Rn?=
 =?utf-8?B?ZGp0ZmdwOUZYT1lQd1dRaVJwZmhYMWtqbC96L0ZyT0ZEZHRCVEZ5THlRTFJ6?=
 =?utf-8?B?ZUZINTJxdm1KampvOFpSdVNMSTh3WWhSTHk1SG5TRU9oKzFyTW1NTXFaaDBE?=
 =?utf-8?B?WHkzWFY4bWdRNE9qc1IxWGM5NEhyUXFXcFlMcE5ZM0tFR1R2dUdJSjV0UWt1?=
 =?utf-8?B?NDc2Z3NzRXFEeXpyYmUxQjFQV0tHMEtvSXJPYmM0T2FxanFlVmVrNzZNV0dW?=
 =?utf-8?B?K3hBNG9PUGZ6Z0tWYmFNcUNVWmtSaXAxOUVHc3NoejgrZ3J5L1pxRVdoc1NQ?=
 =?utf-8?B?aVQwV05YSEU4MzA5b3ZOY1VMY0N3eHhQUHdwYldTYlVpMVcrQjRTWTFoVU5W?=
 =?utf-8?B?U2xTWFl4SlJlcG5ZN3VNbXFRK0xKR2YzTkRqbGk2b2doVXdRQ3JUcHlwcVVm?=
 =?utf-8?B?dnkxL2Q3bmVQVm9wcnYybnJCMHVPK0pjdTVWZ0pZUWZiNCtKeStvT2V1dVdY?=
 =?utf-8?B?VVl3dzFhdjd6ajRXWHAvZ0RrN3JVbC9xQitkMWVsdlNFZWlIRm5vTzdCVGxL?=
 =?utf-8?B?UmpKTTA5MG5Fb0ZKbTdNdHlNdWlhVzVYdG9weXBvQXV4R3YwTVZNaVhFTk10?=
 =?utf-8?B?cC8xcUlZaS9IY3Q5Z2lJcXhzNGlLWlJ5QTQrSWMxZ25wRXhLRzJBSHlibDlE?=
 =?utf-8?B?N0JrV1l4K3RyRG9Wa3pDbVdycmlLTjFvdUswMkJESkg0dXl3TUZpczRrOHUr?=
 =?utf-8?B?NCtLaW9VNUxXZXZuelRBNXp0Q3dUeC84ZTl3di84WG1VZENGTERkQTllY09Z?=
 =?utf-8?B?Zkd1ODN5Vklhek5qTWc2NzdHZ2hnMnNGS25URVZrZzdoV1V6TS83WmtIOWll?=
 =?utf-8?B?NERLUnVza0tKb2k4NVE4b25Ud0dpNTloa3RQUmozaFhnQng4eDhrWUVzMkxI?=
 =?utf-8?B?NjNqbllrNW5RT29yRzFkZkFBSkdDRHZSNVJkRGNXcFFTRFJkc1JqVU1rZmpQ?=
 =?utf-8?B?SnY4NHZudTM3eVdoMGYyQnBqaDVteTBuTlA1dzFvblJXR0Rqb3FOOWM2Z0xo?=
 =?utf-8?B?TG1QamdSYm0vSWQ3WWVTMTRpWTF6M1JCNWQ3dzNySUJITko2Z2RydXFMUnBK?=
 =?utf-8?B?MDVWODcxa1BaSHBUN2c4KzlRRlBRMkxJQ2NONGl1LzBoZDQ3ZlV4U0h5YnB1?=
 =?utf-8?B?UitHUW5pVjdrZXVzR0FVbVN0UDdZVStxUjB5czNaY0dEbkx1cFE2WkROUFc4?=
 =?utf-8?B?bHZla1VIWE5mTmhBaERnZjFTa282MFp3LzU5SnlpWDJ5RVIveG5qSWpaRHdH?=
 =?utf-8?B?aDI2cCs1dmh2SGEzaG9mTDR3Sit3TGxpUnBRSUNGZ3pQTU5wOHYzaC85bzIz?=
 =?utf-8?B?VHM2dGFtcjY5Z1UySU1FeVQ4YXYyb1NTR2lrZnlsQ2cydGZ0ckxRTk51bWVK?=
 =?utf-8?B?MG5GcjN2bmwyS1c1Wm02S2ZaQ3NRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f212151-2201-47e9-6060-08d9d9c11bf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 13:56:06.9876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qjl2ALwIWtbwDjL/aVmTdN8JrUJZCmC6CMN77DyjwOt9vl/JXIgMVm27L365aOvn/mQBxjllYzq/egqk7PCbsUmpG/+6bGd+/ly5S4uF0f8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5483
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+Pj4gICBGcm9tIGFuIGVhcmxpZXIgbWFpbCBbMF0gSSBnb3QgdGhlIGltcHJlc3Npb24gdGhh
dCB5b3UgdGVzdGVkIG9uDQo+ID4+PiBhbiBhcm0gcGxhdGZvcm0g4oCTIGRpZCB5b3U/DQo+ID4+
IFllcywgd2l0aCByZXNwZWN0IHRvIG15IHByZXZpb3VzIG1haWwgdXBkYXRlLCBhdCB0aGF0IHRp
bWUgZ290IHRoZQ0KPiA+PiBjaGFuY2UgdG8gbG9hZCB0aGUgZHJpdmVyIG9uIEFSTSBzZXJ2ZXIv
ZW5jbG9zdXJlIGNvbm5lY3RlZCBpbiBvbmUgb2YNCj4gPj4gb3VyIHRlc3RlcidzIGFybSBzZXJ2
ZXIgYWZ0ZXIgYXR0YWNoaW5nIHRoZSBjb250cm9sbGVyIGNhcmQuDQo+ID4+IFRoZXJlIHRoaXMg
ZXJyb3IgaGFuZGxpbmcgaXNzdWUgd2FzIG9ic2VydmVkLg0KPiA+Pg0KPiA+PiBUaGUgY2FyZC9k
cml2ZXIgd2FzIG5ldmVyIHRlc3RlZCBvciB2YWxpZGF0ZWQgb24gQVJNIHNlcnZlciBiZWZvcmUs
DQo+ID4+IHdhcyBjdXJpb3VzIHRvIHNlZSB0aGUgYmVoYXZpb3IgZm9yIHRoZSBmaXJzdCB0aW1l
LiBXaGVyZWFzIGRyaXZlcg0KPiA+PiBsb2FkcyBzbW9vdGhseSBvbiB4ODYgc2VydmVyLg0KPiA+
Pg0KPiA+PiBDdXJyZW50bHkgYnVzeSB3aXRoIHNvbWUgb3RoZXIgaXNzdWVzLCBkZWJ1Z2dpbmcg
b24gQVJNIHNlcnZlciBpcyBub3QNCj4gPj4gcGxhbm5lZCBmb3Igbm93Lg0KPiA+Pg0KPiA+DQo+
ID4gT0ssIHNpbmNlIHlvdSBkbyBzZWUgdGhpcyBzYW1lL3NpbWlsYXIgaXNzdWUgd2l0aCBhbm90
aGVyIGNhcmQgb24gYXJtDQo+ID4gdGhlbiBJIHRoaW5rIHRoYXQgaXQgaXMgc2FmZSB0byBhc3N1
bWUgdGhhdCBpdCBpcyBhIGRyaXZlciBpc3N1ZS4NCj4gPg0KPiA+IElmIHlvdSBjYW4gc2hhcmUg
dGhlIGRtZXNnIG9uIHRoZSBhcm0gbWFjaGluZSB0aGVuIGF0IGxlYXN0IHRoYXQgd291bGQNCj4g
PiBiZSBoZWxwZnVsLg0KPiANCj4gSSBub3RpY2UgdGhhdCBVQlNBTiBjb21wbGFpbnM6DQo+IA0K
PiAgICAgMTkuMjMxNDgxXQ0KPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID09PT09PT09PT09PT09PT0NCj4gDQo+IFsg
ICAxOS4yMzk5MjZdIFVCU0FOOiBzaGlmdC1vdXQtb2YtYm91bmRzIGluDQo+IGRyaXZlcnMvc2Nz
aS9wbTgwMDEvcG04MHh4X2h3aS5jOjE3NDM6MTcNCj4gWyAgIDE5LjI0NzQ5MF0gc2hpZnQgZXhw
b25lbnQgMzIgaXMgdG9vIGxhcmdlIGZvciAzMi1iaXQgdHlwZSAnaW50Jw0KPiBbICAgMTkuMjUz
NDkwXSBDUFU6IDAgUElEOiA1IENvbW06IGt3b3JrZXIvMDowIE5vdCB0YWludGVkDQo+IDUuMTYu
MC1yYzMtMDAzODktZzE3NThiOGZjZGJmNyAjMTAxOA0KPiBbICAgMTkuMjYxOTE1XSBIYXJkd2Fy
ZSBuYW1lOiBIdWF3ZWkgRDA2IC9EMDYsIEJJT1MgSGlzaWxpY29uIEQwNiBVRUZJDQo+IFJDMCAt
IFYxLjE2LjAxIDAzLzE1LzIwMTkNCj4gWyAgIDE5LjI3MDQyNl0gV29ya3F1ZXVlOiBldmVudHMg
d29ya19mb3JfY3B1X2ZuDQo+IFsgICAxOS4yNzQ3NzddIENhbGwgdHJhY2U6DQo+IFsgICAxOS4y
NzcyMTFdICBkdW1wX2JhY2t0cmFjZSsweDAvMHgxYjANCj4gWyAgIDE5LjI4MDg2M10gIHNob3df
c3RhY2srMHgxYy8weDMwDQo+IFsgICAxOS4yODQxNjddICBkdW1wX3N0YWNrX2x2bCsweDdjLzB4
YTgNCj4gWyAgIDE5LjI4NzgxOF0gIGR1bXBfc3RhY2srMHgxYy8weDM4DQo+IFsgICAxOS4yOTEx
MjFdICB1YnNhbl9lcGlsb2d1ZSsweDEwLzB4NTQNCj4gWyAgIDE5LjI5NDc3MV0gIF9fdWJzYW5f
aGFuZGxlX3NoaWZ0X291dF9vZl9ib3VuZHMrMHgxNDgvMHgxODANCj4gWyAgIDE5LjMwMDMzMl0g
IHBtODB4eF9jaGlwX2ludGVycnVwdF9lbmFibGUrMHg3NC8weDE5Yw0KPiBbICAgMTkuMzA1Mjg3
XSAgcG04MDAxX3BjaV9wcm9iZSsweGY4Yy8weDE2MTANCj4gWyAgIDE5LjMwOTM3Ml0gIGxvY2Fs
X3BjaV9wcm9iZSsweDQ0LzB4YjANCj4gWyAgIDE5LjMxMzExMl0gIHdvcmtfZm9yX2NwdV9mbisw
eDIwLzB4MzQNCj4gWyAgIDE5LjMxNjg1MV0gIHByb2Nlc3Nfb25lX3dvcmsrMHgyMjQvMHg0MmMN
Cj4gWyAgIDE5LjMyMDg0OV0gIHdvcmtlcl90aHJlYWQrMHgyMDQvMHg0NGMNCj4gWyAgIDE5LjMy
NDU4NV0gIGt0aHJlYWQrMHgxNzQvMHgxOTANCj4gWyAgIDE5LjMyNzgwMl0gIHJldF9mcm9tX2Zv
cmsrMHgxMC8weDIwDQo+IFsgICAxOS4zMzEzNzddID09PT09PT09PT09PT09PT09PT09PT09PT09
DQo+IA0KPiBIZXJlJ3MgdGhlIGNvZGU6DQo+IHN0YXRpYyB2b2lkDQo+IHBtODB4eF9jaGlwX2lu
dGVycnVwdF9lbmFibGUoc3RydWN0IHBtODAwMV9oYmFfaW5mbyAqcG04MDAxX2hhLCB1OA0KPiB2
ZWMpIHsgI2lmZGVmIFBNODAwMV9VU0VfTVNJWA0KPiAgICAgICAgIHUzMiBtYXNrOw0KPiAgICAg
ICAgIG1hc2sgPSAodTMyKSgxIDw8IHZlYyk7DQo+IA0KPiAgICAgICAgIHBtODAwMV9jdzMyKHBt
ODAwMV9oYSwgMCwgTVNHVV9PRE1SX0NMUiwgKHUzMikobWFzayAmDQo+IDB4RkZGRkZGRkYpKTsN
Cj4gICAgICAgICByZXR1cm47DQo+ICNlbmRpZg0KPiAgICAgICAgIHBtODB4eF9jaGlwX2ludHhf
aW50ZXJydXB0X2VuYWJsZShwbTgwMDFfaGEpOw0KPiANCj4gfQ0KPiANCj4gU28gdmVjIGNhbiBi
ZSA+PSAzMiBub3cgYW5kIHRob3NlIGludGVycnVwdHMgYXJlIG5vdyB1c2VkIC0gYXJlIHdlIG1p
c3NpbmcNCj4gc29tZSBvcGVyYXRpb25zIGZvciB0aGUgdXBwZXIgYml0cz8NCg0KWWVzLiBBdCBm
aXJzdCBsb29rIGxpa2Ugd2UgYXJlIG1pc3NpbmcgaXQgDQoNCiNkZWZpbmUgTVNHVV9PRE1SX0NM
UiAweDM4DQojZGVmaW5lIE1TR1VfT0RNUl9DTFJfVSAweDNDDQoNCjB4MzgNCkFkZHJlc3Mgb2Zm
c2V0IDB4MzggLSBiaXRzIDMxOjANCkFkZHJlc3Mgb2Zmc2V0IDB4M0MgLSBiaXRzIDYzOjMyDQoN
ClRoZSBzYW1lIGFuYWxvZ3kgYXBwbGllcyB0byB0aGVzZQ0KcmVnaXN0ZXJzIHRvbyANCiNkZWZp
bmUgTVNHVV9PRE1SIDB4MzANCiNkZWZpbmUgTVNHVV9PRE1SX1UgMHgzNA0KDQoweDMwDQpBZGRy
ZXNzIG9mZnNldCAweDMwIC0gYml0cyAzMTowDQpBZGRyZXNzIG9mZnNldCAweDM0IC0gYml0cyA2
MzozMg0KDQpMZXQgbWUgZ28gdGhyb3VnaCB0aGUgaW50ZXJuYWxzIGZpcnN0Lg0KDQo+IA0KPiBT
b21ldGhpbmcgZWxzZSBJIG5vdGljZSBpcyB0aGF0IHBtODB4eF9zZXRfc2FzX3Byb3RvY29sX3Rp
bWVyX2NvbmZpZygpDQo+IGlzIGNhbGxlZCBiZWZvcmUgdGhlIHRhZ3MgYXJlIHNldHVwIGluIHBt
ODAwMV9pbml0X2NjYl90YWcoKSwgYW5kIHRoaXMgYWx3YXlzDQo+IGZhaWxzIHNpbGVudGx5IGFz
IG5vIHRhZ3MgYXJlIGF2YWlsYWJsZSBmb3IgdGhlIGNvbW1hbmQuDQoNCllvdSBhcmUgcmlnaHQg
aGVyZS4gDQpDdXJyZW50bHkgdGhlIGNvZGUgc2VxdWVuY2UgYW5kIGVycm9yIGhhbmRsaW5nIGJv
dGggYXJlDQpub3QgcHJvcGVyLg0KDQpQcm9iZSgpDQpyYyA9IFBNODAwMV9DSElQX0RJU1AtPmNo
aXBfaW5pdChwbTgwMDFfaGEpOyB7cG04MHh4X2NoaXBfaW5pdCgpfQ0KICAgICAgICByZXQgPSBw
bTgweHhfc2V0X3Nhc19wcm90b2NvbF90aW1lcl9jb25maWcoKSAvLyBlcnJvciBoYW5kbGluZw0K
ICAgICAgICAgICAgICAgICByYyA9IHBtODAwMV90YWdfYWxsb2MocG04MDAxX2hhLCAmdGFnKTsN
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICB2b2lkICpiaXRtYXAgPSBwbTgwMDFfaGEtPnRh
Z3M7DQoJCQ0KDQpyYyA9IHBtODAwMV9pbml0X2NjYl90YWcocG04MDAxX2hhLCBzaG9zdCwgcGRl
dik7DQoJcG04MDAxX2hhLT50YWdzID0ga3phbGxvYyhjY2JfY291bnQsIEdGUF9LRVJORUwpOw0K
CWlmICghcG04MDAxX2hhLT50YWdzKQ0KCQlnb3RvIGVycl9vdXQ7DQoNCldpbGwgc3VibWl0IHRo
ZSBwYXRjaCBmb3IgdGhlIHNhbWUuDQoNCj4gDQo+IEkgYWxzbyB0aGluayB0aGF0IGZvciB0aGUg
dGFncyBtYW5hZ2VtZW50LCBzaW5jZSB5b3UgdXNlIHNwaW5sb2NrIGluIGFsbG9jLA0KPiBzcGlu
bG9jayBpbiB0aGUgZnJlZSBwYXRoIHNob3VsZCBhbHNvIGJlIHVzZWQsIGxpa2U6DQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfc2FzLmMNCj4gYi9kcml2ZXJz
L3Njc2kvcG04MDAxL3BtODAwMV9zYXMuYw0KPiBpbmRleCA4M2U3MzAwOWRiNWMuLjBhNWU1YjVm
Njk3NSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfc2FzLmMNCj4g
KysrIGIvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfc2FzLmMNCj4gQEAgLTY1LDcgKzY1LDEx
IEBAIHN0YXRpYyBpbnQgcG04MDAxX2ZpbmRfdGFnKHN0cnVjdCBzYXNfdGFzayAqdGFzaywgdTMy
DQo+ICp0YWcpDQo+ICAgdm9pZCBwbTgwMDFfdGFnX2ZyZWUoc3RydWN0IHBtODAwMV9oYmFfaW5m
byAqcG04MDAxX2hhLCB1MzIgdGFnKQ0KPiAgIHsNCj4gICAgICAgICB2b2lkICpiaXRtYXAgPSBw
bTgwMDFfaGEtPnRhZ3M7DQo+IC0gICAgICAgY2xlYXJfYml0KHRhZywgYml0bWFwKTsNCj4gKyAg
ICAgICB1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiArDQo+ICsgICAgICAgc3Bpbl9sb2NrX2lycXNh
dmUoJnBtODAwMV9oYS0+Yml0bWFwX2xvY2ssIGZsYWdzKTsNCj4gKyAgICAgICBfX2NsZWFyX2Jp
dCh0YWcsIGJpdG1hcCk7DQo+ICsgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcG04MDAx
X2hhLT5iaXRtYXBfbG9jaywgZmxhZ3MpOw0KPiAgIH0NCj4gDQo+ICAgLyoqDQo+IEBAIC04NSw3
ICs4OSw3IEBAIGlubGluZSBpbnQgcG04MDAxX3RhZ19hbGxvYyhzdHJ1Y3QgcG04MDAxX2hiYV9p
bmZvDQo+ICpwbTgwMDFfaGEsIHUzMiAqdGFnX291dCkNCj4gICAgICAgICAgICAgICAgIHNwaW5f
dW5sb2NrX2lycXJlc3RvcmUoJnBtODAwMV9oYS0+Yml0bWFwX2xvY2ssIGZsYWdzKTsNCj4gICAg
ICAgICAgICAgICAgIHJldHVybiAtU0FTX1FVRVVFX0ZVTEw7DQo+ICAgICAgICAgfQ0KPiAtICAg
ICAgIHNldF9iaXQodGFnLCBiaXRtYXApOw0KPiArICAgICAgIF9fc2V0X2JpdCh0YWcsIGJpdG1h
cCk7DQo+ICAgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcG04MDAxX2hhLT5iaXRtYXBf
bG9jaywgZmxhZ3MpOw0KPiAgICAgICAgICp0YWdfb3V0ID0gdGFnOw0KPiAgICAgICAgIHJldHVy
biAwOw0KDQpEaWZmIGNoYW5nZXMgbG9vayBmaW5lIGZvciBtZSBoZXJlLg0KDQo+IA0KPiANCj4g
VGhhbmtzLA0KPiBKb2huDQo=
