Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CB2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Mar 2022 10:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbiC1Kur (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 06:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiC1Kuq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 06:50:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607543DDDB
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 03:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648464543; x=1680000543;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LRBc1D/zs8cVpfxk/n6IlPWY49fXpurBxx/FIn7qdTc=;
  b=NdmlptPODZKj54DJ1Zsa8VtKUb4hnoCvwZb6GRHG5HINc+IyDSQv2SdJ
   L2WVhMzV1zIt3IppXGaOvVPCUg1I2pfC9Q468wXH0DX4Pk+Fz0tGrvJHz
   U+Px1X8fTnZ/E/yIXmL5IcoLJQ9MOO7xcRfmrwMTf6hLb5lYxcKLC3NI8
   79zS7WwS/vEQwHMkt7whlHOy9Vdp9IOVOcZwgMb6dlA0Mkmopiu9x7qHQ
   FKFxrNxuvotgmyDjn/Xkx0mI9lYgi31ThZhGdkMLLLgYwpeyH0rnAyjam
   ChBytYm92XsM96/2NgGNUuf+9kxghNRlAPNi657/UaaCz0ZPrtjryyTl1
   A==;
X-IronPort-AV: E=Sophos;i="5.90,217,1643698800"; 
   d="scan'208";a="157910023"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Mar 2022 03:49:02 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 28 Mar 2022 03:49:02 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Mon, 28 Mar 2022 03:49:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GoEbu1kK/AHRpb7oLLZ86ksi+cAYdDgsF0tEh225+PZ5alOp/snQt1dlX8zhJQR2isWXJvMDiIeOHVQFa0sY1wdT8FMdIzx5vCATaZ/36PhPNu0gbB06sO3gvKy+GzOfScX86v/OTEL0eIOS+3mWRXBH0bPk2tHDPfERsHsof66knLjFvuZFXR0J3Y59u2uw1PJGuQuYdYZpH65HkcheFmiz1dtNoZFKxHSBroy9qYqDMxgimH633MSvKxP1Kk9Z5T7kGN4IRTLePFM8pScqTSlFsHJGcuTvEsDhmQUDZdKziTpdqkpTPP0Rq/qwQ1J9uPwbAlOqejr77s/GJlpgGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRBc1D/zs8cVpfxk/n6IlPWY49fXpurBxx/FIn7qdTc=;
 b=ess0iSfLVgb57N9v5J+q98+YFxqy6v1PC2GeAANBcXXntm6s5CaMy0CsyqSh3g+SsmxS0PNcpAOx+PEc8hQwtE2u49fE5/qRTS7JjrwApxEUgmEoUCq9OFna+x7QMy6DLRer1X8kfjfV6pqx89f0HmNtqgGJfqO+we/9PeGdiOWFRT3FNmI/PgGwD++Nqfq5QWKoyhPHgqJRqMcto2Njt12Y5/hSok4fGmgyFGln0VO3cp8/Q1H9zQLEYhLbkooCucHxgaxofavjogmM/AqUz+vbfxUhKMjIiapw3MdyT7u+OuDvn8OMBU3E61FAi3GJZLcl3eJGYBWyh9+vpEAttA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRBc1D/zs8cVpfxk/n6IlPWY49fXpurBxx/FIn7qdTc=;
 b=TO6eJGTrlcH/+ejsXtEK7Z/rduCtKB/+L2uuVpZLE8mvH0vOIPu9zD0y8a/uOfThlFlHcIScAZ8R34/nHBad4/9TRj8bFGnZnelAtgEPhGjnMo6jB6NMIprwm2xGID6BWP2ZfGJy0N1B9RdhXiqzm9s1ob9L3Xj3jCcM5Tx8YpY=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by CO1PR11MB4849.namprd11.prod.outlook.com (2603:10b6:303:90::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Mon, 28 Mar
 2022 10:48:57 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::e0b4:5341:c860:9e0c]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::e0b4:5341:c860:9e0c%9]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 10:48:57 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <damien.lemoal@opensource.wdc.com>, <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <john.garry@huawei.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: RE: [PATCH 2/2] scsi: pm80xx: enable upper inbound, outbound queues
Thread-Topic: [PATCH 2/2] scsi: pm80xx: enable upper inbound, outbound queues
Thread-Index: AQHYQoVzviw9Wo5iQ0aHkU3P6jni9azUk5yA
Date:   Mon, 28 Mar 2022 10:48:57 +0000
Message-ID: <PH0PR11MB511221F7D5DBA851FAF43A4DEC1D9@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <20220328084243.301493-1-Ajish.Koshy@microchip.com>
 <20220328084243.301493-3-Ajish.Koshy@microchip.com>
 <99820f1c-10c8-72b3-c5b8-3d7209dc3fde@opensource.wdc.com>
In-Reply-To: <99820f1c-10c8-72b3-c5b8-3d7209dc3fde@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7698d0f9-cd81-4b10-36df-08da10a88fb2
x-ms-traffictypediagnostic: CO1PR11MB4849:EE_
x-microsoft-antispam-prvs: <CO1PR11MB484930CD55936D6236773BF3EC1D9@CO1PR11MB4849.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h84XVVDeoh5mLjI9JyzbPsi3EnsnVhV/AAwjd8TYiYm21ShQjvAYPIQG/CD3r2uEsrgJZMCUnAW0qXj/6Re3L0pXiSpTni+tQ5GQdcXX5a5ddyONzvpdLmEpwcGHrPLvzR8KzMBRy1qz7g3Sz252rqrchGWt9lGE/PwI4/x44T3PPTYg0d46qmlnsoAb+fjuzktxgRNm1+Uxk2qKeBEYsS/uwrcs0yHMCYGVuQa977wsSgWpdduOeA0nvHKz8Ws+L8KhDnopEp0rlPUqwp5nPC50eQRkC1Ud40TIOrgnmGi4aAiVU6i8IGJP+YHRElCCd6a+2g88r20CeYbLT4ReuSuXEkYuJzMUX/8yP8Xwy34bsVUAaQQFCebcLny75ng1Cta7Nnk5cwCX9q566FNTNH0w5wmaWd3+ML+u3PsHmT2wY4orCBSdytGJ3zoTkD4kfEcPlYNUSDPVGRRR2SO2t6jn+hJ2wA4IS+U4C6LZvFeyGw+xbtyvwRtEbJ+Iyp8Q7HcDiak8NLU35KcH99MTjO1uTDV+LE1/14OL3Gob2uXEKAbEAQq8xaXSiVA0FndHPcHOYLMfKuW3deV1DzTwmt+Kil0o5WF+jpBBIwsh21EigkiXk1nlq1AIrDgee19j0c9RPbVMwSKVHX8XxSoa9VNxIRrKFXSo07yXkLkU4lCM1k0j/MMKLAW96uCcmJq2jMjcAqG27sbg8B6uBlYxkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(186003)(55016003)(8936002)(26005)(52536014)(2906002)(508600001)(71200400001)(316002)(66946007)(66556008)(76116006)(66476007)(8676002)(66446008)(64756008)(38100700002)(4326008)(53546011)(6506007)(5660300002)(7696005)(86362001)(110136005)(54906003)(33656002)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEpHbEVULzRNVFVaWDdwLzNlUnhlUU9SRnBQQThPeFB2b1FYK0JHYloxRUVT?=
 =?utf-8?B?dVJhaTNuQTBENkVOeE5lYTllUkJpNE9VS0NSZXZxOGY5NTBGWHhKZUpvanZk?=
 =?utf-8?B?enk2Q1VveDVubjA1a3Vabi9mL1NOckE1U3Q5WFVmUnF2V3A0UUVZNC9sSFRC?=
 =?utf-8?B?Q0gycFIvTzFSYWZ0M2N3YXdPZzBZRWZjNzJ0eUx4N3pzUDhnK1E5QU9HRGND?=
 =?utf-8?B?ZXhwWGN3ZnFQZFB1OUxDV2poVXhna1UxOVdDc3pxWHhYMFdvZnE5c28yTk5Y?=
 =?utf-8?B?bVp2aXRwNW5pVmZyaFRORllzYkNGT0VzRzVsWXV5MzNHOURZbFJmNFl5ODlD?=
 =?utf-8?B?bVhINkNibWJIK3ZwcVpIcTJLenAxOXZVYlpwZDhGV3dzdFhxMUhuUU5odWxr?=
 =?utf-8?B?bEdLZXo3cWtBRTBieXVWWHFHMHZ2aFNjaFI4TkFYV3JOWDVTZ3VCcStZMExV?=
 =?utf-8?B?cmtQTVYvemw4WTVncFVwNUZLREFDa2p0Z2JzcklpR1F4VStGL0JCWkZXd2s1?=
 =?utf-8?B?ZkZOY2xiM0tZcjlTRFkrZlI1dk1oYXVUdW1zN2pzcXVUL2J6VGt0bTVJenVr?=
 =?utf-8?B?N1NGdDVnem9sZ3hSYlpjZWFTbEZUdldZMjBuMUZMNldwb1Q1SEE3Zlpja3ZO?=
 =?utf-8?B?VFU2NEpiSlkvWGhsMGdvS01paFVXeGhlZFdtQ0RmWFdIWkN1QjgvVlFXeEc0?=
 =?utf-8?B?blY5VWVjb2JpdWN2bWFJNGhkVDJ4djk5eUZYeDlxc29CRVpxUnZCR0xtYXo2?=
 =?utf-8?B?UmU3dlBFQ1BFbkFQNUxiWWxCYk9scGNOYjI2NVhva1NaTnJNU0gxWWJ2NWtI?=
 =?utf-8?B?Njg1RW9pamlHandDVHpmYVRoMzVXVmxJNUxjOFdac2J1WWo2OVZDellPcDVM?=
 =?utf-8?B?VzMra1p2bW52R1dmQS8zTWg2TW1OR1VieThPaVhxbm9pU1F0SEphMGtPTGVo?=
 =?utf-8?B?R2ZJSVZTVVVsUGVWTDdQUGVTRHNHVnlvRzZuV2dvMlFQQ0ZnME1qakVVdGpi?=
 =?utf-8?B?aXJPNjdHNUxtN1V3N2RWTzltQlZGdC9WUUF3eHFRYUhxbnFXVHQvTEZhSG9y?=
 =?utf-8?B?cmh0bCt1N3MrQ0VGNUkxN1Npem03Q1RxQlFuWVlRZS9KRXhvYjFUZHkzZTJu?=
 =?utf-8?B?MFg0ZExEOGlzM2c5U3JwYjFXd1JBY0I5OUdEU0Fpcjl5Zm5lOUZQSFoxS3N4?=
 =?utf-8?B?TjFHT0NpRU1sR2htejRhalFpV01WRmhnL2Z1S1VUcnFJSVhHcXV5dW5XcDZI?=
 =?utf-8?B?U2g5a3ZEMkJlc2t0dFZaQ1QvSFNyYzU5NVlNcHNiZnVKQmszZUtyQlBpdUpD?=
 =?utf-8?B?cEpZaFFXNkNJbnRGNXkrekE4ampPMmx3dkp4eTIvcU5GQ2lyVnU4Mk1BRHV2?=
 =?utf-8?B?Wk9mWmRoam5OK0xpZnExbnZQeXV5RnB0QVFpRG1vMmt6Mmgwb2FSWnF0aHhu?=
 =?utf-8?B?RXJCZlEvb3QwRkFkbDJzS3l5ekdoKzdNRk5Dd0FkUlZGL3hwVzNZbmNKUzUx?=
 =?utf-8?B?T09BajF0TjBaZWtFTEg1bXpBbStsMWhqKzM3MG15dy9IcmtvM25zQU5FUkty?=
 =?utf-8?B?REwvWFU4MVE2UG9SdTc5a0UwOGdTSFFEcjM2SjlVMXVwWEpIZDZFWVhNZnE4?=
 =?utf-8?B?YUw0Q3A5a21KVkQ2VVlhejIrVEdCN0dod3NZTjBQM0tkcUYycFowSHMzVi96?=
 =?utf-8?B?MzZSc3JCV01ET1VNRnhvUXJ5RHUzY1pBSXhqcDZvQ0hBdzVHY2xkalREWG1V?=
 =?utf-8?B?dFNjbTNub0ptUmpzeGxOR2RTc25pa0h2VjZ2a3EvZXdaVGVzOGRweFF4WU1o?=
 =?utf-8?B?aDZ5RG9udFd3Y1NHNDlDY3dhc3lLVHlyOEREcnl3RzZ3OHJlT25ocjNYbGlR?=
 =?utf-8?B?bEd1c3hNY0RmTHFmMjBLZEZtYW1zbTdKTTh4eXZHeE9GK2RkL1dlN01tNHZw?=
 =?utf-8?B?blM3WEhOWnBRSklUWjhGaVZiUWh0VkJ3SGJ5d0ZoK3Q2TWdWaVBveXY3dnFs?=
 =?utf-8?B?bTQ4b0RtZVhsKy9yTWtlRXNRbDJWU1ptbFptTFlkdmdGVitXZHRtUWVaYUFU?=
 =?utf-8?B?dUNSSWJPb2M5VnBBa0pwbW5uTEUxQVREK2FDc2U3OUlSU0tuRTFnNGZKZkw1?=
 =?utf-8?B?Q3NsQnVGK0VYQ3Y2UUhMd29QdWZSdnE4UDlJcXZrclhwYm5MeVEzU3dITDl4?=
 =?utf-8?B?Mm5XL1VrYXF3VlRHVTRYbHFwUDc5aDR4ZHB6LzJ2OE9YREhVYmJaKzYzUE9J?=
 =?utf-8?B?cnlOYmlqT1FFL1VLWElyVXhFVENYTW94b004c2EydXpyTU02SU1ObG1GY21M?=
 =?utf-8?B?b25SSnR5d28xMUtMNlp0MUdCUDV5UVFpMVFoWm1UcExLMVZKZ1NxeVlBWExG?=
 =?utf-8?Q?94u87xs8TULJMq5o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7698d0f9-cd81-4b10-36df-08da10a88fb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 10:48:57.6468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ehiPh65ZftajHBALp5vVODq4mLyjEr2UNSaFLbcb+CvmREv2PWTYztU9HM8IjI+NJVhcScY+Lqf8pzwNyzbPM6Tj395NmVvkkb6GT7bNF98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4849
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmtzIERhbWllbiBmb3IgeW91ciBjb21tZW50cyBoZXJlLiBXaWxsIG1ha2UgdGhlc2UgY2hh
bmdlcyBpbg0KUEFUQ0ggVjIuDQoNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5r
cyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUNCj4gY29udGVudCBpcyBz
YWZlDQo+IA0KPiBPbiAzLzI4LzIyIDE3OjQyLCBBamlzaCBLb3NoeSB3cm90ZToNCj4gPiBFeGVj
dXRpbmcgZHJpdmVyIG9uIHNlcnZlcnMgd2l0aCBtb3JlIHRoYW4gMzIgQ1BVcyB3ZXJlIGZhY2Vk
IHdpdGgNCj4gPiBjb21tYW5kIHRpbWVvdXRzLiBUaGlzIGlzIGJlY2F1c2Ugd2Ugd2VyZSBub3Qg
Z2V0aW5nIGNvbXBsZXRpb25zIGZvcg0KPiA+IGNvbW1hbmRzIHN1Ym1pdHRlZCBvbiBJUTMyIC0g
SVE2My4NCj4gPg0KPiA+IFNldCBFNjRRIGJpdCB0byBlbmFibGUgdXBwZXIgaW5ib3VuZCBhbmQg
b3V0Ym91bmQgcXVldWVzIDMyIHRvIDYzIGluDQo+ID4gdGhlIE1QSSBtYWluIGNvbmZpZ3VyYXRp
b24gdGFibGUuDQo+ID4NCj4gPiBBZGRlZCA1MDBtcyBkZWxheSBhZnRlciBzdWNjZXNzZnVsIE1Q
SSBpbml0aWFsaXphdGlvbiBhcyBtZW50aW9uZWQgaW4NCj4gPiBjb250cm9sbGVyIGRhdGFzaGVl
dC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFqaXNoIEtvc2h5IDxBamlzaC5Lb3NoeUBtaWNy
b2NoaXAuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc3dhcyBHIDxWaXN3YXMuR0BtaWNyb2No
aXAuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3Njc2kvcG04MDAxL3BtODB4eF9od2kuYyB8
IDcgKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgweHhfaHdpLmMNCj4gPiBiL2Ry
aXZlcnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3aS5jDQo+ID4gaW5kZXggYjkyZTgyYTU3NmUzLi5m
MDRjNmM1ODk2MTUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgweHhf
aHdpLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODB4eF9od2kuYw0KPiA+IEBA
IC03NjYsNiArNzY2LDEwIEBAIHN0YXRpYyB2b2lkIGluaXRfZGVmYXVsdF90YWJsZV92YWx1ZXMo
c3RydWN0DQo+IHBtODAwMV9oYmFfaW5mbyAqcG04MDAxX2hhKQ0KPiA+ICAgICAgIHBtODAwMV9o
YS0+bWFpbl9jZmdfdGJsLnBtODB4eF90YmwucGNzX2V2ZW50X2xvZ19zZXZlcml0eSAgICAgICA9
DQo+IDB4MDE7DQo+ID4gICAgICAgcG04MDAxX2hhLT5tYWluX2NmZ190YmwucG04MHh4X3RibC5m
YXRhbF9lcnJfaW50ZXJydXB0ICAgICAgICAgID0gMHgwMTsNCj4gPg0KPiA+ICsgICAgIC8qIEVu
YWJsZSBoaWdoZXIgSVFzIGFuZCBPUXMsIDMyIHRvIDYzLCBiaXQgMTYqLw0KPiA+ICsgICAgIGlm
IChwbTgwMDFfaGEtPm1heF9xX251bSA+IDMyKQ0KPiA+ICsgICAgICAgICAgICAgcG04MDAxX2hh
LT5tYWluX2NmZ190YmwucG04MHh4X3RibC5mYXRhbF9lcnJfaW50ZXJydXB0IHw9DQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKDEgPDwg
MTYpOw0KPiANCj4gTm8gbmVlZCBmb3IgdGhlIGJyYWNrZXRzLg0KDQpPSw0KPiANCj4gPiAgICAg
ICAvKiBEaXNhYmxlIGVuZCB0byBlbmQgQ1JDIGNoZWNraW5nICovDQo+ID4gICAgICAgcG04MDAx
X2hhLT5tYWluX2NmZ190YmwucG04MHh4X3RibC5jcmNfY29yZV9kdW1wID0gKDB4MSA8PCAxNik7
DQo+ID4NCj4gPiBAQCAtMTAyNyw2ICsxMDMxLDkgQEAgc3RhdGljIGludCBtcGlfaW5pdF9jaGVj
ayhzdHJ1Y3QNCj4gcG04MDAxX2hiYV9pbmZvICpwbTgwMDFfaGEpDQo+ID4gICAgICAgaWYgKDB4
MDAwMCAhPSBnc3RfbGVuX21waXN0YXRlKQ0KPiA+ICAgICAgICAgICAgICAgcmV0dXJuIC1FQlVT
WTsNCj4gPg0KPiA+ICsgICAgIC8qIFdhaXQgZm9yIDUwMG1zIGFmdGVyIHN1Y2Nlc3NmdWwgTVBJ
IGluaXRpYWxpemF0aW9uKi8NCj4gDQo+IElzIHRoaXMgY29tbWVudCByZWFsbHkgbmVjZXNzYXJ5
ID8gQW55Ym9keSBzZWVzIHRoYXQgdGhpcyB3aWxsIHdhaXQuIEl0IG1heSBiZQ0KPiBiZXR0ZXIg
dG8gZXhwbGFpbiAqd2h5KiB0aGUgd2FpdCBpcyBuZWVkZWQuDQoNClllcyB5b3UgbWF5IGJlIHJp
Z2h0IGhlcmUuIFRoZSBjb2RlIGl0c2VsZiBzcGVha3MgYWJvdXQgdGhpcy4gDQoNClRoZSByZWFz
b24gZm9yIGRlbGF5IGlzIG5vdCBtZW50aW9uZWQgaW4gdGhlIGRhdGFzaGVldC4NCg0KV2hlbiBn
b2luZyB0aHJvdWdoIHRoaXMgRTY0USBiaXQgZGV0YWlscyB0aGV5IG1lbnRpb25lZCBhYm91dCB0
aGUgTVBJDQppbml0aWFsaXphdGlvbiBzdGVwcyB0byBiZSBmb2xsb3dlZC4gDQpTaW5jZSBNUEkg
SW5pdGlhbGl6YXRpb24gaXMgbWVudGlvbmVkIHNlcGFyYXRlbHkgaXJyZXNwZWN0aXZlIG9mIEU2
NFEgYml0LCBJIGJlbGlldmUNCnRoaXMgbWF5IGJlIG5lZWRlZCB0byBiZSBmb2xsb3dlZCBpbiBh
bGwgdGhlIGNhc2VzLg0KDQpXZWxsIGhlcmUgY29udHJvbGxlciBkYXRhc2hlZXQgaXMgbm90IHRh
bGtpbmcgbXVjaCBvbiB0aGlzIHdhaXQuIEl0IHNpbXBseSBzYXlzDQoiTm90ZTogSXQgaXMgcmVj
b21tZW5kZWQgdG8gd2FpdCA1MDBtcyBhZnRlciB0aGUgTVBJLVMgZmllbGQgaW5kaWNhdGVzDQp0
aGUgaG9zdCBoYXMgc3VjY2Vzc2Z1bGx5IGluaXRpYWxpemVkIHRoZSBNUEkgYmVmb3JlIHNlbmRp
bmcgY29tbWFuZHMuIg0KDQo+IA0KPiA+ICsgICAgIG1zbGVlcCg1MDApOw0KPiA+ICsNCj4gPiAg
ICAgICByZXR1cm4gMDsNCj4gPiAgfQ0KPiA+DQo+IA0KPiANCj4gLS0NCj4gRGFtaWVuIExlIE1v
YWwNCj4gV2VzdGVybiBEaWdpdGFsIFJlc2VhcmNoDQoNClRoYW5rcywNCkFqaXNoDQo=
