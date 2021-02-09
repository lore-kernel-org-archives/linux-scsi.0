Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB9BC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 13:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13C264EC7
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 13:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhBIN07 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 08:26:59 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:36137 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhBIN0o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 08:26:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612878083; x=1644414083;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kLAUlRlvHZnhJH4/bemoSqCX9KULoQ/h/6X7sDS9wxM=;
  b=dAzPrSXEj1IvC+j+j4VrbJ2HLyqfV/CoUMyiejsgTxjzQyT+5JicuZMH
   fZJ0bcicCLL4nc6rAEAVP2B0NHdUfv4KG7nsqU6S3lL/I1QiIrHd32oWF
   +FldA94F1EbP8N41bw1fqdzd1a+8ZujYWiwLqkyetdTMaY/PalHP6JaAy
   yev7XKMQmoux4Zbe2hunJ3sZQRKKArmp3/ZHilR7Jo+cs4rd6JXIqX2N8
   QW03C+uH3px7eE8zcxLLWtopqCvcmw99H7wqxqf10HuauGyrIZS/Avyqz
   ZguhDtRA44ZeeBUz4HuWf6O6bwCepSKOnBuLMehTbTgR6KrkATLgGq0hA
   A==;
IronPort-SDR: +bELSL18Lww57BPVYqPMQhg+vEbQnOk0Pi6a9eHhPj9WyGm4sK4YHQ1wcThPiAaF92jPrmQPtd
 ZioHYD4tMtnDXuNoeETgXEU5tEUwQMffCHulfI9GSmYMVpWlDyI/an9cYSUOxaFTy/2vqWtwi1
 wiP4WBhXNCYhiNUMClEkwWN0nxswdutX/4nWb71jA+lzAVNL8Wu1pcUjpHNO0CY5622Ew2sTRr
 iaB4inXMj5oHeVLLlpOtkdVdFwkkMA4AIIJdrq5tGHq0V6zJZ0cERMG8llryFEQwi1ZWBCC+pi
 Y3Q=
X-IronPort-AV: E=Sophos;i="5.81,164,1610380800"; 
   d="scan'208";a="263652346"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2021 21:39:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JY6qKSX8jJBel8aOIKHhgdjKg8pPwk4iNT53Onz8YGFTX56WSkBpHEr6rMlo0j2hT1pwYw6epwnSVZBd3VabVNFcht7jirIQ37aHv8eMz91Tl3BauLprEJ1Eh4nRHU7pTdIVZSelNoZ3ARegu2LEyzjwwQgf+DTwO2+oTEt5DE1PeZqzJ4R5V/kL4gbedlVbhd6oHyOm2iAGE22IEagf3UfLelIBjTkWaf8Xe2kQ77zSHVOiTc0mwk3cWmrvj+5xzkJIK/8zcQ87Ceigd/QF19mZ1LVZ7ipNeCxHDyJKZxWugAIQe1peoWM8Tx4k4iOjAMYdxUnWVPlXQkFMTNzAsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLAUlRlvHZnhJH4/bemoSqCX9KULoQ/h/6X7sDS9wxM=;
 b=dsuFE4KTrmJlIlP7zIswJXnVwY+fUsh1hu9sYG6GwvcM/9AoxZb9WIWm7h40Z1DnuEoT96TZG+l5WqhC94IgKULaL3oyrC/IpKT2Dd5dZrnLHi7STeNYYezmfwb9Rp9vC8L76F1qQRVaIsF4esI0DCt6XyLt949RPVtk3uKJ7kL4KJptaut+dO37FadGmwmwYa4HcAr6qXKLAzikTMVVyttjL5sgQVBZ23aE+zEmzunCA7jCKQw5GrfLlnRoZxfaWkrxkuTjizHld215+YIb1zWuwqHOnmLpK2IulxUyz4l1E8GvLI9N11U45yOLZBds50m9rCl3/Vv/fqnX/T8kSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLAUlRlvHZnhJH4/bemoSqCX9KULoQ/h/6X7sDS9wxM=;
 b=CsSIyoV//ydXefrHR2zCpIcGGkFn461aYDlRB+zTFO9xhbD5eItOiyVOqGLv7u8hNFljMQLR9qD7Z6N4fmLz5SmHFdpcdAV3W6PKBVKTVX3aFpB9+UGDWuGZZ9dah2U5+twOYT4MI87JflHHTmxdQL32sX7BuUa6mZcN85xIZok=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4490.namprd04.prod.outlook.com (2603:10b6:5:22::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Tue, 9 Feb 2021 13:25:36 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%4]) with mapi id 15.20.3846.025; Tue, 9 Feb 2021
 13:25:36 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Bean Huo <huobean@gmail.com>,
        Can Guo <cang@codeaurora.org>,
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
Thread-Index: AQHW9f/qdUh60Je+wEOqZcug0RLrV6pI8k8AgACYY4CAABha8IAGPGxg
Date:   Tue, 9 Feb 2021 13:25:35 +0000
Message-ID: <DM6PR04MB6575C8C5BEE5BCDA7EBE786BFC8E9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
         <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
         <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
         <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
 <b6a8652c00411e3f71d33e7a6322f49eb5701039.camel@gmail.com>
 <DM6PR04MB657522B94AB436CF096460F6FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB657522B94AB436CF096460F6FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 270d5451-12bc-4a80-b360-08d8ccfe2f51
x-ms-traffictypediagnostic: DM6PR04MB4490:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB44901F28B701AEE722F3D9CEFC8E9@DM6PR04MB4490.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pPhHbW4XFIXtgZ+I2LF4qCoTo9SbpqX/6bPBwhRpdgliDeDSaVaH7FC6JtngMaRVFA/Lgc6CACNDQbR3DU/5IF459FxxV93/IGkxxRfsvHwG+E00Nta22um3SOWPn2Z3ru3EvPLYD4M1IjCmFEdK7IUnv1i0xX5njRg1bfz1Mv+56P0gCWndeEPzEU1Txe/OuGz5eLdif6ze9M0uYZXhMKRbFGodBW3+fElmygUZieXZePXudm134yvLqC69gKhKixGaX+xnniM32n4Kd+rWEOfoYMCwRAELPAgT03oe+ohZ+6gAjdl68KutFtF21YcvH0FMq9tRVRblO0j/QSOo/bHg5iuakEc7oF/gG4+6OpifEcUO09IHwjldcBj6k92nFVZBM+6I+h0L5n2/kdynh7ew+vAckfva6QXnHoMrdtBC9feEfeQzaMH8NXRaoDI9ETIpbbJoCg5LTn6vxlffKR5NldfcaAYcmto5W08329qcKJnRGRgLSsL2LDQpJcvg+4ixzNuECT+ndVi1JZ+91g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(52536014)(83380400001)(26005)(186003)(8936002)(86362001)(7416002)(6506007)(110136005)(54906003)(316002)(7696005)(66446008)(33656002)(66946007)(64756008)(478600001)(76116006)(66556008)(8676002)(2906002)(66476007)(71200400001)(5660300002)(4326008)(9686003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VW41VE1LYmU3Yzc5cStjUUpjSVVxVWFoMkhqamJOeFE5bi94ZVM2Sld5Q0xI?=
 =?utf-8?B?UGwxNkdycjJrNFhQY1d1dGtBRldQSlJmdHpIUXpIN2NPck95UGZHeUtmajBL?=
 =?utf-8?B?WnNBOU1Qb3ptOCtLb013dzdVTzJTOGtBRzNCUHZKN29TQk1zWnptYjByZzRO?=
 =?utf-8?B?T3FyS2xlSVVFcFdkZjRwczR1MWRpS1BmdTEwVy8zV1hGWnJtQnVRYWRobEQ0?=
 =?utf-8?B?NmZMZER6ZWFXVGdhYzd0TW9hZEZTbWhpYUZNR0hCZncvSUUwMEdlMXA1bVNL?=
 =?utf-8?B?S0I1elZtWGdKZUdFU08xdDBlMGNCTnRvS3NvV21wb0xpc0JCbkVrelJtTXNm?=
 =?utf-8?B?ZWdNSjZaWm9RZVRHbWk5cFYwMTdLaWZXekhrTHFsK3dKdXpwTkJqc3J5UjZi?=
 =?utf-8?B?Yk84N0xVTDJOMFpSWE14NU54UDFmVktSeVBmZzR5SmltRDBWb1I2S3JJdFZM?=
 =?utf-8?B?cTExK2hEbXJxNTBKOG8rUHU5WW5Sb3ZtTXVEQmpKRmVpMEVxSTYwQklBNlVs?=
 =?utf-8?B?Z0xXWjlSNDdtbHRxdGhuMEhrTlRrUDYxQUJjVEp0ak9xTjF4b21lVFBGTnZm?=
 =?utf-8?B?cEs2Q3pjb0tLWWNtQU1JQ3gzR1RDLy9tOU5TbFRZUjhzTUlDM3k5eEl1Z3Vk?=
 =?utf-8?B?VkRKTEZBVUVZOTJxOXZnWm15UnZhS3U2cjdyd0xML0IrYUc2eFlrZjZCSlBT?=
 =?utf-8?B?Z1FWSEtUV3A0bFR2c2ZiRFVxK3RpOHdSRWtMTllnRk0rWTAzVTArdEJIWW80?=
 =?utf-8?B?a2NOY0w5bkhyamtEMlFHaHdyemNXKyt1YU5vRTlYUmVsTEFyemVoUzE0c0Vk?=
 =?utf-8?B?QjdQNUJtQjdjNndJT0hDVDNWQ1I4SGp6SCtSVUNiTDJUK0RmR2FsVDdNTWVs?=
 =?utf-8?B?M0RseXpmMS9WdmZVWDlKTnZFVnUxZzRFK2dLdVh1d1QvbkZJam1neEZoODJO?=
 =?utf-8?B?di9mYUhoZXV5QXk5djF3UlJNSWk2LzllYWJpTFhYQWlvN3BBVmpzN1pDZEpu?=
 =?utf-8?B?NXY5QkpoaG5aUU9LTkZCeXZrekRFWGZBdVY0S1RBUytBVDRKMUVFeWEvVVhM?=
 =?utf-8?B?S0FwdWU0bXVRREVPUkgxT2QxUXUvL25YMm1WbTg5SHQrOTg1dUhYZVZFS1ln?=
 =?utf-8?B?bUY5N0d1cktEd3FZdXJDZmpLNC9rRExsWDFyWk1zTWZRbHJzNktDUEM0MmFn?=
 =?utf-8?B?akNXN3IyY1V1dVNFQ3NYS05UeEEvNzcyUWlwUzBVdC8ycW40ZVpZWlp1cE5P?=
 =?utf-8?B?UGVuRk5OamI2a2c4QXlMRmQ4VlVwd21DNzRpcHRReEM5b3l2SUtWQW91UmJn?=
 =?utf-8?B?enVOUFpCKzBkbEIrWU5QQjRjcitaUDhTdVN4Q1l1RXZXMjVGcVlaeEFVNDcz?=
 =?utf-8?B?c3RVY292dEh6UXZ3MjB0UEdoQWdpTWF1UFVIRGtDWkJtajAweHpndkxjN1Fk?=
 =?utf-8?B?VVI0VW14R1RZRVFvWlV6NE1VTGdyWkVPaFF6WEZ2UEkwQ08wZWxrc05QdW9a?=
 =?utf-8?B?ODB4QW01VWZBVVlicml0SGFobmtFV2pKcmpoU0FSYk55NnZ5NUpobE5HTVUy?=
 =?utf-8?B?MmZ6YmFMZnZBc3gxeVBEMHZJcHRKWDR5aFgvbHZhVDBHTlEzdkVaampDY2FW?=
 =?utf-8?B?Y2k5MnF6MnB4VEZhSWdLUWdaL29MREhZMkd3N2RDWXZpNC9nNnBkM01NVDFo?=
 =?utf-8?B?TEVrdmVDK0x6RldtRldqTGpabHBZNmp5UnhoejhicHBSMGYzQUxJRnJEeGdF?=
 =?utf-8?Q?OCrtnpF7y6+HrJLEmHTKUQFz8iXjHGXsQLgHubk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 270d5451-12bc-4a80-b360-08d8ccfe2f51
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 13:25:35.9522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qyx9XYtZhZaq2fVwE9zrBS6mXNdBzicTzt6tY0BYKGS9Kf49qnGub31eh9fHwQ6kzBj2B6YN/+/+nBi0qHKCbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4490
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+ID4gPiA+ICsgICAgIHB1dF91bmFsaWduZWRfYmU2NChwcG4sICZjZGJbNl0pOw0K
PiA+ID4NCj4gPiA+IFlvdSBhcmUgYXNzdW1pbmcgdGhlIEhQQiBlbnRyaWVzIHJlYWQgb3V0IGJ5
ICJIUEIgUmVhZCBCdWZmZXIiIGNtZA0KPiA+ID4gYXJlDQo+ID4gPiBpbiBMaXR0bGUNCj4gPiA+
IEVuZGlhbiwgd2hpY2ggaXMgd2h5IHlvdSBhcmUgdXNpbmcgcHV0X3VuYWxpZ25lZF9iZTY0IGhl
cmUuIEhvd2V2ZXIsDQo+ID4gPiB0aGlzIGFzc3VtcHRpb24NCj4gPiA+IGlzIG5vdCByaWdodCBm
b3IgYWxsIHRoZSBvdGhlciBmbGFzaCB2ZW5kb3JzIC0gSFBCIGVudHJpZXMgcmVhZCBvdXQNCj4g
PiA+IGJ5DQo+ID4gPiAiSFBCIFJlYWQgQnVmZmVyIg0KPiA+ID4gY21kIG1heSBjb21lIGluIEJp
ZyBFbmRpYW4sIGlmIHNvLCB0aGVpciByYW5kb20gcmVhZCBwZXJmb3JtYW5jZSBhcmUNCj4gPiA+
IHNjcmV3ZWQuDQo+ID4NCj4gPiBGb3IgdGhpcyBxdWVzdGlvbiwgaXQgaXMgdmVyeSBoYXJkIHRv
IG1ha2UgYSBjb3JyZWN0IGZvcm1hdCBzaW5jZSB0aGUNCj4gPiBTcGVjIGRvZXNuJ3QgZ2l2ZSBh
IGNsZWFyIGRlZmluaXRpb24uIFNob3VsZCB3ZSBoYXZlIGEgZGVmYXVsdCBmb3JtYXQsDQo+ID4g
aWYgdGhlcmUgaXMgY29uZmxpY3QsIGFuZCB0aGVuIGFkZCBxdWlyayBvciBhZGQgYSB2ZW5kb3It
c3BlY2lmaWMNCj4gPiB0YWJsZT8NCj4gPg0KPiA+IEhpIEF2cmkNCj4gPiBEbyB5b3UgaGF2ZSBh
IGdvb2QgaWRlYT8NCj4gSSBkb24ndCBrbm93LiAgQmV0dGVyIGxldCBEYWVqdW4gYW5zd2VyIHRo
aXMuDQo+IFRoaXMgd2FzIHdvcmtpbmcgZm9yIG1lIGZvciBib3RoIEdhbGF4eSBTMjAgKEV4eW5v
cykgYXMgd2VsbCBhcyBYaWFvbWkgTWkxMA0KPiAoODI1MCkuDQpBcyBmb3IgdGhlIGVuZGlhbml0
eSBpc3N1ZSAtIA0KSSBkb24ndCB0aGluayB0aGF0IGFueSBmaXggaXMgbmVlZGVkIGluIHRoZSBo
cGIgZHJpdmVyLg0KSXQgaXMgcmVhZGlseSBzZWVuIHRoYXQgdGhlIHBwbiBmcm9tIGdldF9wcG4s
IGFuZCB0aGUgb25lIGluIHRoZSB1cGl1IGNkYiAodXBpdSB0cmFjZSkgYXJlIGlkZW50aWNhbC4N
ClRoZXJlZm9yZSwgaWYgYW4gaXNzdWUgZXhpc3QsIGl0IGlzIElNSE8gYSBkZXZpY2UgaXNzdWUu
DQoNCmt3b3JrZXIvdTE2OjEwLTMxNSAgIFswMDFdIGQuLjIgICAgNjIuMjgzMjY0OiB1ZnNocGJf
Z2V0X3BwbjogQXZyaSBwcG4gNDgwZDJmODI0NGMyMWFiZA0KICBrd29ya2VyL3UxNjoxMC0zMTUg
ICBbMDAxXSBkLi4yICAgIDYyLjI4MzMzNjogdWZzaGNkX3VwaXU6IHY6MS4xMCBzZW5kOiBUOjYy
MjgzMzE0OTIyLCBIRFI6MDE0MDAwMDAwMDAwMDAwMDAwMDAwMDAwLCBDREI6ODgwMDAwMmRkYWFj
NDgwZDJmODI0NGMyMWFiZDAxMDAsIEQ6DQoNCkFnYWluLCB2ZXJpZmllZCBvbiBib3RoIGdzMjAg
KGV4eW5vcykgYW5kIG1pMTAgKDgyNTApLg0KVGhhbmtzLA0KQXZyaQ0K
