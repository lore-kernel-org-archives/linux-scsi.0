Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4802EC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jan 2022 14:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiAQOCi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jan 2022 09:02:38 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:60089 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236889AbiAQOCg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2022 09:02:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1642428157; x=1673964157;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zVYM9HpEzGhqgSUgd3EKW1XLIDXP0qNLyGtT1UWD8JQ=;
  b=m9xWor+DhmtYvncUCLgCAqv+IsjRFzxaTKMvpJkz0XtbG8dfzEPQGx2x
   PN8dB/+naDoiSOC4YkuGhtEjQvEPbOKgt3dMcV+xsQH7apscuzbQ7ALdi
   86+H41KIJYsBjrrZKpjgm2BbYbCRm2nDkgVBz3UTsIqahbc/dc1ScFzYC
   u4igJtQW60m4/jqg/t7zrtZnXgCCV/MlszJt0KMIdjMG0S7v1se2MXDxG
   6v+0IHfi/lq0imGKwlWMOEsbaTehCJGZOKfP4oROzdPMBuWSzHHS2Gwuv
   qB3v7faM/6x2/dSkqUSDx997gZr/01lMAoqiwZFu2OMj56e4KGvHrU0ZJ
   Q==;
IronPort-SDR: KRkGOwDBvaUDCFKYuppCHubvcajEF9kvhYnAQouzvVGLhNrX1437Xu2Lzm4fOE8hhlL7sFPrQ7
 gPhVVo1qGeVM3+mXCpws+YkJk+Q+PC7XvjRdpgJBPAHRnfxYXlP61nefG5Z9mXCM9d/KR0/zoX
 1ANUZngvZSzdfMxWDgCGwl0VhDRMlISBy5tyZB4FcDwD3pHfKK0NKiDZIyYfX1mIKxP/newItm
 SHvqTwMCsNlnzsjtZMjmpCdZ+eSH0Z7KQS+0/5X7mIWLs4whzobmte4qscpC9ylmhhKHkGW/JE
 Ad4cV74NbAtM4Q+J+dLObyMk
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="149884508"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2022 07:02:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 17 Jan 2022 07:02:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Mon, 17 Jan 2022 07:02:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGyd4Pf8QS7JfB16abWuaJitLA4Ep6X2BVUf7xIaq3BauOyIhvsDFrYuTrwkL2LxbD/GqBaXbkH0uN3XYyFBCt2WNYqY5LReYS3RXUnnM/lnwS07ViIVSTS5BxzzoVdz20y5lQ/SPbFLp61TbwZjmR/Tw9hEL/bPtsvHxA/LEFMhP1m9akRFnaK5be/iF5IPY+HO9K2T4GkphrzjSbyJb+nA3SccZDCJjONHpGi6+ychMFPrrjHNDYYyaABzKUJt2GVeyoXMwbv9TqMLLomPFyN5oYmQN6qTy4W1uC1nsT4Z9narzhlS5jF7Yz3pic3dMnMTRJet8ryfYFUcooAZnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVYM9HpEzGhqgSUgd3EKW1XLIDXP0qNLyGtT1UWD8JQ=;
 b=S54Sikht82l41NZY4I8Ts42FKAtHaYyNroqaEbtSjBbmvfD60ND2kffJrhr8SWBYeuzjp0OPtB22Ranx72LyTMjBOJ8cn+NbuYENwduKtUE3llitTsHS+2lcogkkIfdSfqPoVH0llcaN5akpF2heiFLkKsBwEdPQsPUXEjN7aV3yblHsWr0ovxNgjApB5txRS9R5vAUh/PdR6ecTZ0SyAbRucEGJDDr4312fPBST89nlEwu93GSXbplH6/fl0FRBqydeULmaYMMoB5YbHM3dLc/BvuvjBXsaiwF8yODDq+Oqcn7702w3Xc8hyPCl+qTM6TNuGpn14UIUjTwj7PGMQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVYM9HpEzGhqgSUgd3EKW1XLIDXP0qNLyGtT1UWD8JQ=;
 b=ix/mKK3TEaQHOKJV2Pruc5CqtfqBMkz6DR9gtHpymN8vBIJYwiBKWWTsNae94tyWzOprOAaJA1xFKvieVKYScCe3pWfWvalOfMOKEZSEGG088USl1oTXcV8BY7T4mkpqOggKtKJZZs2M1KuTSFZkpuEyEM3NURFmW27NjFNjXJs=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by CH0PR11MB5689.namprd11.prod.outlook.com (2603:10b6:610:ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Mon, 17 Jan
 2022 14:02:31 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::d469:8d33:e5f:8b9c]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::d469:8d33:e5f:8b9c%5]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 14:02:31 +0000
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
Thread-Index: AQHX+KUJaMkhjLzSFEiHPF663Zk+AqxBieQAgATH0tCAD+byAIABQ17ggAVR6YCAAQpd0IAAE0SAgAMLX3CAACh7gIAGQ8mg
Date:   Mon, 17 Jan 2022 14:02:31 +0000
Message-ID: <PH0PR11MB5112CBA1FFB800289710BBC0EC579@PH0PR11MB5112.namprd11.prod.outlook.com>
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
In-Reply-To: <05bec388-946d-057d-20d7-67ebe5f2cfdf@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ff8b764-0e12-400e-82f2-08d9d9c200e3
x-ms-traffictypediagnostic: CH0PR11MB5689:EE_
x-microsoft-antispam-prvs: <CH0PR11MB568960E536F62EBCD1EE7918EC579@CH0PR11MB5689.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ca2i3wZ1AZ5POqF4IWSzlTaOUEih35yAtxOj9jgxfBL9RkpDywU3FSbwb/uQwDDh1ip5FTnXcrmWKBhE7tKMFnf+I2F57Woe+qIHmFJSL65S0ZXSKhHeGWZ42nDJ4HolE8DNGdcng0tnOiEDthRr/VN+aLZJfufjdpeBtdaWOAs8wfBJOomB539mTtlx2x+aYcJy3BoFTwywH7AMK2sLDRCTpm6O3sSm3pQ86ps7sVB8hxypLJAEC8KACcQPfsJQoG4yEjnUh0VFNHM26J4gz6v+Lc48dX7XGQQlL1wUjYBXuTC3qS+71XTqh/0fpdaAdqpt6COtVTu+OLQYlc++EFlRs3xn7euy19BoqkjBMRmqzStlqEe1Z+VVLm5zYwLecJ4l2AdKVL1Xs6P3vzyx441nOqjgD+aWo5JUE5x10dzroXlW84WyJwy9xQ3FU+erlaBl1hz5JLzKF/IUgo3MJeHEh4dNeNQ1IdXn7vd6mOQ/NRosbL+ZB0N4v4ZpUxpcPP13Rg6yeeGfOld295dwwgc0VpuSz/mDWPlQMFsAZBRaeei7CDnv+MhJA7ZXd+GrwBUDIkj0EVINmzDmWdSd9uoy8ruVWewH5f5x8RHX3WKOK7YlZqjULH4xptibVzURyUPAvzmWAc4gXOprt66t4vD7HBZnZQARz87I0K0+MzGmFK9nbpRqXBw58eA8jVUE4KyxwoJXBd8LUXa29DFUQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(7696005)(66446008)(64756008)(66556008)(8676002)(4326008)(55016003)(33656002)(83380400001)(186003)(6506007)(38100700002)(316002)(55236004)(54906003)(122000001)(26005)(66476007)(71200400001)(508600001)(107886003)(86362001)(66946007)(9686003)(52536014)(2906002)(6636002)(5660300002)(76116006)(8936002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZldJUkRxWnUwNzMvc1N0emVtanNmeTRYcHBEU01KL242U21DU2JKbzNGeXQz?=
 =?utf-8?B?WjcxOGR5K0x5NWl1M25qTVYyVk80RlViYW1GTnZvVnJZSzNQUng5RWtOc3l3?=
 =?utf-8?B?M0F3SDBPTTBXT1Fqb3VhUW9lM1FqRlZIUFdmY0QvR1RrRmlUMUYxejRMZzha?=
 =?utf-8?B?NUY0UjZUSnl1T21uV0dPRkJBTDNQWXYvbHNabXU4NWQrZ25ySWRuS2NDVndq?=
 =?utf-8?B?TDRsSTA3VTJUbEdHQ2Zub0ZvNjZrMTRLOE1BMjYxWCsrWHlWQmI3NVJZaEY4?=
 =?utf-8?B?M0RnR296dXVyOWsyRU9jQUdkSzdDdE54bDFiV2FYak1VK3ZUa2V4T0d0UDNS?=
 =?utf-8?B?bzdPRGhJMTgrN0ZCakZqOWh2WFdaaGZPRlBDalFpMzJQdE1pd1A0NWNWb1lZ?=
 =?utf-8?B?Y3QybGhicWZmRlBxVmNFZm1HZmZDYWwzb0VTbG5EWlE3UXl0RThzZHV1YS9m?=
 =?utf-8?B?ZmI5UEgyQ3gwaitMSFc4Y1UrM21Zb1k5ZjdrNHJtd1d2bGpQUnNVdjl4eDlH?=
 =?utf-8?B?Vm9CV2tDM0pIL3IvS3RLT0lYOWxUSnBpdUIxRzdtOG9DU1hFeDhjMW9LOHpn?=
 =?utf-8?B?ZnlMZzVEOC9MWGVTaWRiaFl2d2JhS1ZxZFZJN3B0SDRHOFZ6eGFoZmNjVmox?=
 =?utf-8?B?bzVTeDJUL2lBbUY0L1o1S29PMWJ0Z243RFQ2U0NEYzFrdktwcStCWERCUXBh?=
 =?utf-8?B?MHlyYkxCaE43VzlQWDh2U1luTTZ2MUpvK1Vjam95VWQxVFpBd2RPRmFQL2hs?=
 =?utf-8?B?NHFHV3lidjJJRHU5Tjd6OGpMTW1xS0JoWEV1WUh3eE9XMFQrQVlaRFYwRWxB?=
 =?utf-8?B?QWdGSzVFQXJyRm1va2hhdU9idFN0cTJhbWtGZGZjanRmNGhHSEtyNTgxYWJ1?=
 =?utf-8?B?cTAwbGFXVnB6YWJhdmp0dk80clNpUlg0OTJSZjRDMVdmRDl1cGtBd1gyTisr?=
 =?utf-8?B?N1RuZDhuM2p6TlJ1M3MxRS9ubzVqUlZYaG8wY0dEeWtFcHhSMC9NQ0NRd2Rt?=
 =?utf-8?B?a0pMbkhBekVnZGxrZTdUR2dTcGJPMXlGd3lJUnVxU0FqNG1tWFhyNHEwaVJ5?=
 =?utf-8?B?TzFFZG9DZzkyNkZhbWRraUt5bGc0Ri9hUVBIWEk0WU9paHkwZFJ1Kyt5WTAx?=
 =?utf-8?B?aW9Uei85RmQ1TmhhK0Y5ZjdHSktxemJMT1JiVDA5YzBwQkhTcU45K21DdWx3?=
 =?utf-8?B?QnhVdzB2TTJmMkdpS1BZaE5LcGc2QXBhZWliNUgzcWV1WjNYUnZIdVBxUGZ5?=
 =?utf-8?B?UWNTUDBrdDRpOUM0RUhlZ2FHNXgyRWpack1xQlRWMk9SbGFXdnd3YUhGOVFh?=
 =?utf-8?B?V1lBNnBONlpjRzdDZkRYdXIxclhqYkdoYTVSSnRLMG9LQ2habFpMbXV5djRV?=
 =?utf-8?B?c1Y5RmtSRURYT3NjWHg1cnJPQ0lWNGVNeEhCVGFzMm1CZ1NQc0V1YzRwQ3Fo?=
 =?utf-8?B?RWNCSGdrVXNuZFdmMjVkK2FxdHBza3B2Zk5DMllzOWNtM0VpYXdEcVBNOHc2?=
 =?utf-8?B?RDFjSTY0WFIxa2RZL3MwVmVkUnZNNWZsbnlETkFJU0FzekMycGFCYXplRDV0?=
 =?utf-8?B?RmlJOHVkVUNkNzAycysrY0RiRlhUQmpEb1RldmdPb1E1K25JQjREdTdpTVdJ?=
 =?utf-8?B?RXJLYVBpVFZYWEtVaTVSWkRiN1RXNmdwMEZVT1lZU3JudVZ6N0JMOXJSWmZQ?=
 =?utf-8?B?YmlKR0VQNDd3U3R4RU5WaERibTJQT0k5OVA1WlJ0eHk3RHJKV0F2d3h1aVNv?=
 =?utf-8?B?alJjblVWZC90aTBRQ3ZrOExMNFZ1UklXMDA3bHVhcmtZV2FBdExRY1d2ZzZ0?=
 =?utf-8?B?UXRKNGtLbDRMV3BnL0tGdEVhNExiS0dWUFFBMEtnak9FZ2crTmJKQWttQ09y?=
 =?utf-8?B?QStVZDVnRFRwUnlZeFJzelVBT09zWHMwRGhRL0NLUVY3SzJ5S1MrakJJZ2o2?=
 =?utf-8?B?UVExNGR2d1JhRnNXWHN2RXhIcDd6U3BTa3BYVm4rM0NwQTc3VTFOdXM0WXc1?=
 =?utf-8?B?cWlPbzUyaXZwUldUdmZielNsVUlyckdjTkROdWhaMHVqa3VhTFFjSVRsQ2lI?=
 =?utf-8?B?N1lVOHY3ZDQ3TEJpUit4QjltUWlFaWY2TnZrMXBKMmxQcHRMSkR6cmxmK0pY?=
 =?utf-8?B?UGt5c3pFU2JtZytGcnErT3gvbm9GVmtUY2RjdWNTZzlKMUVHWFgxajc3TlpB?=
 =?utf-8?B?OHBJUU9wVVdKLy9HdDEzbW1ESStnOXgweE9sR2gzVTZoYWlVTmoveUtuSVh0?=
 =?utf-8?B?NHpPQ0pxSVM5TUlhalJhdFFic0t3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff8b764-0e12-400e-82f2-08d9d9c200e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 14:02:31.0960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3ll6Q/XFxo/r4OWKeJ+zkrNW363HT+kuXpVEjAP6jiIyLWUrNHSX+i6VmDpzbRi3iXcuzLX+MnLJNzGlQcFz/nYLLE1irHdOGdzabidR25s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5689
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSm9obiwNCg0KPiBIaSBBamlzaCwNCj4gDQo+ID4+ICAgRnJvbSBhbiBlYXJsaWVyIG1haWwg
WzBdIEkgZ290IHRoZSBpbXByZXNzaW9uIHRoYXQgeW91IHRlc3RlZCBvbiBhbg0KPiA+PiBhcm0g
cGxhdGZvcm0g4oCTIGRpZCB5b3U/DQo+ID4gWWVzLCB3aXRoIHJlc3BlY3QgdG8gbXkgcHJldmlv
dXMgbWFpbCB1cGRhdGUsIGF0IHRoYXQgdGltZSBnb3QgdGhlDQo+ID4gY2hhbmNlIHRvIGxvYWQg
dGhlIGRyaXZlciBvbiBBUk0gc2VydmVyL2VuY2xvc3VyZSBjb25uZWN0ZWQgaW4gb25lIG9mDQo+
ID4gb3VyIHRlc3RlcidzIGFybSBzZXJ2ZXIgYWZ0ZXIgYXR0YWNoaW5nIHRoZSBjb250cm9sbGVy
IGNhcmQuDQo+ID4gVGhlcmUgdGhpcyBlcnJvciBoYW5kbGluZyBpc3N1ZSB3YXMgb2JzZXJ2ZWQu
DQo+ID4NCj4gPiBUaGUgY2FyZC9kcml2ZXIgd2FzIG5ldmVyIHRlc3RlZCBvciB2YWxpZGF0ZWQg
b24gQVJNIHNlcnZlciBiZWZvcmUsDQo+ID4gd2FzIGN1cmlvdXMgdG8gc2VlIHRoZSBiZWhhdmlv
ciBmb3IgdGhlIGZpcnN0IHRpbWUuIFdoZXJlYXMgZHJpdmVyDQo+ID4gbG9hZHMgc21vb3RobHkg
b24geDg2IHNlcnZlci4NCj4gPg0KPiA+IEN1cnJlbnRseSBidXN5IHdpdGggc29tZSBvdGhlciBp
c3N1ZXMsIGRlYnVnZ2luZyBvbiBBUk0gc2VydmVyIGlzIG5vdA0KPiA+IHBsYW5uZWQgZm9yIG5v
dy4NCj4gPg0KPiANCj4gT0ssIHNpbmNlIHlvdSBkbyBzZWUgdGhpcyBzYW1lL3NpbWlsYXIgaXNz
dWUgd2l0aCBhbm90aGVyIGNhcmQgb24gYXJtIHRoZW4gSQ0KPiB0aGluayB0aGF0IGl0IGlzIHNh
ZmUgdG8gYXNzdW1lIHRoYXQgaXQgaXMgYSBkcml2ZXIgaXNzdWUuDQo+IA0KPiBJZiB5b3UgY2Fu
IHNoYXJlIHRoZSBkbWVzZyBvbiB0aGUgYXJtIG1hY2hpbmUgdGhlbiBhdCBsZWFzdCB0aGF0IHdv
dWxkIGJlDQo+IGhlbHBmdWwuDQoNClJpZ2h0IG5vdyB0aGUgYXJtIGNvbmZpZ3VyYXRpb24gaXMg
bm90IGF2YWlsYWJsZS4gV2lsbCBiZSBkaWZmaWN1bHQNCnRvIGdldCBkbWVzZy4gDQo+IA0KPiBU
aGFua3MsDQo+IEpvaG4NCg0KVGhhbmtzLA0KQWppc2gNCg==
