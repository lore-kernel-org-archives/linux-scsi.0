Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734B5C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 13:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354942AbiASNuB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 08:50:01 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:2949 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354916AbiASNty (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 08:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1642600194; x=1674136194;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LQToFKJJQjdVzk9Gb9A9Kkd+uLqOc/M9pmP5Ke/WoU0=;
  b=kOUcsIRLKxMB3df+RagJhUAO7qAfNGG/u5VlApAGsVy6sCEEJqnFz8WB
   KCN5ooPkpTQFGv5nMNfRe+6tboJ30AhILf0H6ifXfX1JfsKe/eBfnTB1P
   Bpc+D7Oqd0zHpQW1RAFydERmTLA0IDvoEIky0LwvTpidcy+IGJ6B8rUP0
   SYSwpr0i8cxpAXiPU6xjG3V9iWDKSR5MpigdZjpG1NhsdQJ/NTy8YO1cf
   yXgBytApwMjIpyFqxqnhEbllkSsjiR+s0SmW7vKgo1M594HQF8TfvUdPX
   Ni9+VGH8RkgHIdgX5Sr5llVfi+8nFpxf1cZyFs8ZEfKJy0Lp0wv3yCck/
   w==;
IronPort-SDR: ATCc/oJp+jXo3SBwNTEWPQuBclIUQMdU9ISagg6nN0Yc5066CqXts1CRNW/dJHI7/BRB14UBBg
 6Z3c06pvqaTAf8a5VZ1vJqqCNJjtO0nTHQpYL5Z87X3Ke230auDnS5jfmgv56omwczwVbldqph
 QnLUbCukSeTr/awfat6FT/d3RO+Pz9+jm4qGVA4TYPw2fjoKFzSO8QvJa0IILj0PA/acvHrw6b
 BBX/gwK+e3IjrLFMomxm3iELNV1ID2mQ9Jiz5ZczCC+QvQTZC9TEcYq0R2mVmB9UEM+XdriH7G
 66q++Xjx8kcUEG6TKIZByt3R
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="150156970"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jan 2022 06:49:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 19 Jan 2022 06:49:51 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Wed, 19 Jan 2022 06:49:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoTKh+ial3KkldmU5kAB08FrWNB/QyvWcCy9wGlNv9myWA4KPMEAg7jqlrWd0ewM+DGVElEPDXw3caJustekJXdcltgP4wQ5OD7ZTPI+xMXqX+/hWFRcAEUqV4/zWNLOTDoSmMwd98Vh46y0l2a5tDbJjt537sASWsVjP1mUqA05I3oKZlrF2wBiVftyHOgqbgJoEMzHh28fneIaMiL74EidZBHB8OgknoGCvsqip0YIm7+25GwddCXk5GiKWA05d0QGYx4bW3Sn8PhHXdBhMssmL6w6UD0E6lMwkF9Qks4SV6vrIPnXMDeYe//xg36LmFnkMgxSXU0yeaxuCh1FHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQToFKJJQjdVzk9Gb9A9Kkd+uLqOc/M9pmP5Ke/WoU0=;
 b=MPasarnRXLxs74rEt6E6o1i0K9wF5avJWBHb/H5uYqqfgrf6YpOyYBWGlUQ5llRpl6/QTvgf2kIQDcvOMsaMgz+dK49YxOl81kcMNLAKyVIvSglPt6Ur3cgeegwzI8KmdCbvxN9qp4KZW1vTEFtcJ70vsXh+/ldrWIvR4RUGZzcU3rUZGrDWYhOTY3dyl/7wdW5bUxn8ieX4udbXT58S1jeuVLfY6JqJ709Vd2P8d1QR6Bga21ik/L3M2FluzOcSJbKIVkLBy+hpquqtKFtL6kNYB6K+OeJFoGSW9W5FlXyledE/x01ydqQ3a6vlbFVeUeuabmOy4QKoDaAw3Kg4SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQToFKJJQjdVzk9Gb9A9Kkd+uLqOc/M9pmP5Ke/WoU0=;
 b=ZUm2GR60a5VoAj64ze8zKF0NaFisMkDR9YCC0oiWb8L7yxM83TfCP+UOfFaCEEKODTV1zc6Xnj7jx9MzAF0JPCvUYlj7tydUF9+ciT9ZgPukw9HY25qsYIzRM7760QnAvoX1wWKMqOP/A4EBQDwl397gIF+C0JIxD1RTQfW+POs=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by SN6PR11MB3231.namprd11.prod.outlook.com (2603:10b6:805:b9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Wed, 19 Jan
 2022 13:49:46 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::d469:8d33:e5f:8b9c]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::d469:8d33:e5f:8b9c%5]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 13:49:46 +0000
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
Thread-Index: AQHX+KUJaMkhjLzSFEiHPF663Zk+AqxBieQAgATH0tCAD+byAIABQ17ggAVR6YCAAQpd0IAAE0SAgAMLX3CAACh7gIAGQ8mggAGxVwCAAWyPkA==
Date:   Wed, 19 Jan 2022 13:49:46 +0000
Message-ID: <PH0PR11MB5112A280BBF7AAB0636059B8EC599@PH0PR11MB5112.namprd11.prod.outlook.com>
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
 <PH0PR11MB5112CBA1FFB800289710BBC0EC579@PH0PR11MB5112.namprd11.prod.outlook.com>
 <a8d13d70-226c-16eb-6007-2102d3f8bb26@huawei.com>
In-Reply-To: <a8d13d70-226c-16eb-6007-2102d3f8bb26@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a5dd77d-fa50-4cae-7cfc-08d9db528dd6
x-ms-traffictypediagnostic: SN6PR11MB3231:EE_
x-microsoft-antispam-prvs: <SN6PR11MB32316CDBF248BED49F294615EC599@SN6PR11MB3231.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vrE/1ws4+nm/o60APCTQSjZ4+/mlz6xkKK/MG8pqI0vTLtu4igf1mBEAmmYFA0bTH1GMa6Yjd1n861WuyTrgZMeLPHd+NScY/SisrcMxG2uHPd3VXjLJFwrhuXzaLfeZYk54JR23DohUE52879mo/PZphcB2LKC767BZ6ZieOX6WxAzmouF6pnXNBuwdpZD+jgtdKofeeNYYlnQtPBuCTGzNHFscMEW2s/97z2AhlvRLP9UvAmNxW0Lqx6R+QeUuzdWilC6wNfMowXwiHt0T/gQip7uCiZuAcXH0heVp19WFIZi0ZKxmAXj38DAcaUU/KUoxS7s11ytem9EZ2jSrZa3df/VwQWH2vstZMwAkbycQC1QtdPp8k+AxNZ7WvE/rnqGMcgiTbQyv/mMTlFJpTAJXVpFS1zFSA5E7+AOkAU7pY4cMQ6mINVF1hYh/S7cESuVLHBbJaMNgrHvbtpkrENH6QuRnOdCpn9zMwZW2sx2iMsP9XQ5+5V12k2W/2yUrdJ2DKvquewbLt524Xi9jJ82qEvQODFVvOatXOKuD4U0V2DHeUcx/imGCJN/4mi/QZuqY/086H0MU56QmQ7UlfvmxdNKEXXac6wO9IIW/PpTaHPnBEHFiez5hfJyYQm7sXzw0l+yiNJB4PxTq8cVQu9ksxJzFzL2HWTl6aF//F47wxmLFoKpvNqpRrK3fBLoYUmdaQ6iglmOXYQ93lmE+Gg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4326008)(33656002)(7696005)(107886003)(186003)(55236004)(316002)(122000001)(38100700002)(52536014)(54906003)(6636002)(110136005)(2906002)(76116006)(9686003)(66476007)(66446008)(5660300002)(66946007)(8676002)(86362001)(508600001)(83380400001)(55016003)(71200400001)(66556008)(38070700005)(64756008)(6506007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1VIeFNzZzlRMEY2bEE2UTFyd3h0ZnBTRWQ4U1hNZllCNVBaR0xsdDl2am5D?=
 =?utf-8?B?VDlIKzkvYmZTSFNESlZBQmZTRDZIRi8zc0xjejNQVEVrQzJPd2ZSeVRSaWxB?=
 =?utf-8?B?Mnk0V3dpcVpWUlFqV3NGbkJkaTZCQzhNMWQ5SHBCWVVCZUZMY3ZiVG9YVzNw?=
 =?utf-8?B?YVErMFFFcHpBSzJocUkybXg4OURJMjdNRGdOUlRwS1pDQnVob2o3MzhydDBB?=
 =?utf-8?B?UDljMzRiQmZLLzFjNWpuVXVTZFQ4b2p2Z25UMkhOWmY4aFpoVnBXWE1zOVli?=
 =?utf-8?B?QldndzdiNE1kNTRxWlUzMnhYa2pUaHUxc29xajFxYlZRS1pGdG1zMDNvZ2tR?=
 =?utf-8?B?S3B6ck9uZ2lxVU83WXExRVhwQTFZVlkxQnJYbTJocGtNMUdpSnhOZXJiMVNl?=
 =?utf-8?B?ZzRzRFdVb092WkczcGhiQ2xScDU0WGRNWHc3WEwvcjlCWS9MU0RzRlBiK29i?=
 =?utf-8?B?S3B6eEt1ZTJybkppUTJNNXd5d0NiVHorSXBvc3oyREV4VmllSVlOQVYrVldm?=
 =?utf-8?B?UE1jclRzN3piOFdyLzZIWkhPb0ExU3M5YVlLdGl0REhEaXB3VTlMS20vWHpX?=
 =?utf-8?B?YW5GTWdvWHI0TXk4YVFqdU5xRDQ4b3RMQ0wwMGI0TzJWU3BDR0w1UzhCS1lx?=
 =?utf-8?B?cTNRYkJQK1RVNlZ4SFl1N0g3SFBldWFmeEZhS21rRCtaQkx2UjY0TlhLTXJW?=
 =?utf-8?B?UStteXZuQzlLV2hTNklTOFAzYmRSYjlDYW03Ti85ZitiZmdZa2hEOG1BaXgx?=
 =?utf-8?B?eTJCQ09QNzhKN1NFcFVjUmhpMjRNY25YR3Zpb1ZaRGRMRVZtSm1HK3d6KzM4?=
 =?utf-8?B?b0Qyc04ydUtDbkVZdFRFVDBCYzc3emhoSnA2SzZ2YTFPVlIvY04vOEhtWWdE?=
 =?utf-8?B?cHJSL2FFTG0vMGwvUDZTU3JIVWRmTXQyZXZZNXpMeWxzZ0lIMWFrUEY4a2x5?=
 =?utf-8?B?QmRYRnAwTEFONUZOS2hON3VGUjVhZWtSOVZJV3dhM1JGeU1DWGtQQi9MYi8w?=
 =?utf-8?B?NTlGRkNSRFlYY3BoV0hmZ3FYaHJSdHQ2THd3NUtMdzJuL1EzdlcxT3dadmM0?=
 =?utf-8?B?bDlQM3NyOXdOd1J5Z29MTENyVkFiaDhpOE5zVEZZZFlZeVNwVnMrSmE1K1hZ?=
 =?utf-8?B?ZzZnY0lDVTc1V2Fzamczc29JcWp6aU1kcHNMdGlnVXUxSVpoNWRmTklYbGlD?=
 =?utf-8?B?MFJac0d2dVFyczJkYlFJeWR6aTNQNDhXQlJEZjBRRm4rTzdUYVBiUysrWTEr?=
 =?utf-8?B?SjhnMVF3SnA2QitxN2dGSzM4cktWRE1PZENmVGpWMFYrUXlFY0NYYTk5WUJm?=
 =?utf-8?B?QUlXR3J5alVKR0M2ZVYrREtEMDNQTXI2SFdWZUpENytGVlVsZ1E4azQxMzl5?=
 =?utf-8?B?emVZM1NUQ1JhUG5RWUdJYUZ4N1VrR2U5N1NuZERKcWhFbm13eHRaS1FhbHFu?=
 =?utf-8?B?WHFab1VPWElWb0pXRFVXY1pDQWlIMTdPbUJLMUc1cHQ1Z2xxbCtRdk9WMENU?=
 =?utf-8?B?QzdLZVlUY0FWQXJwaFViYVJodTNYeDdtUldXdEg5MlgxWmgvUkNheTBOR2gw?=
 =?utf-8?B?WkRwS0R0K2hRakNRcFJlQWlWRzJ1NXdOemVaWEtObGpETC85KzA1OFg1VFlP?=
 =?utf-8?B?aUpsOWhGbDA0ekh2OEtlRUJEZzIrb2I0d3o2azhYb25ESldwTTZXMU94Ky85?=
 =?utf-8?B?STBjQStsNWNvM3pycUMwbjBwcUgyQVAwK280dVNVRkZWbXA2VjRIQ21OdXV1?=
 =?utf-8?B?Y3RkT1VISVdIai9IQ2pHcDUxMVZ6dE9hWW9RUlN1QVF4eFFaY1djTnJrRFJT?=
 =?utf-8?B?azZTVk5xU1VwaHM2aCsxV3VyYXlJN0VUSzBrcWRsOTBPbE93UlpJalNKYUNa?=
 =?utf-8?B?UTNvRnltVTl0dmw5dS9KdHVTR0dON2RRbDRvOEhydTBRcTlGejlCZktBMTI1?=
 =?utf-8?B?TXFLd0pkdFljSlp6SHBDUzd4enRKT2tsdVdGNCtsRVljWU1PWmF1VzNUbm5Y?=
 =?utf-8?B?YjZnNmE0YStUMXVPN1cxTER5YXo5SjFoUS9ieFZOVGt6THp1TWhKQjVTc0l3?=
 =?utf-8?B?am9UQlFVQklHWG5DUlloa3dTVHBTd2dKbjVvQkRDaE1pd2UvaHhlbGFaNHVP?=
 =?utf-8?B?M2RzKzRWQjFHS1dwSXNaeEM3VFhoenVxb2NxZnI3MDlkQjZ4MFlZTEQ4Tm9K?=
 =?utf-8?B?SDNPdy9LTHd5UjE0ckI3bDBiRm1tL3dNUVRXdVRVUXdWdHNJeGk2ZlYzUnpE?=
 =?utf-8?B?b1ZYSkwvTE5oMnZoUnJ0SjNla2VBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a5dd77d-fa50-4cae-7cfc-08d9db528dd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 13:49:46.1831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rqHKZ3iy6a+ORZLNX+4QvkK4DblfxZ0yLmrd3x5XNVLTu+gV0EJz9MiA0zzns+ghDSpwKtpuGHWrVKU29/2V/1ZTTSMXnDwD1jx5SI1Y5wM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3231
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSm9obiwNCiANCj4gSGkgQWppc2gsDQo+IA0KPiA+Pg0KPiA+Pj4+ICAgIEZyb20gYW4gZWFy
bGllciBtYWlsIFswXSBJIGdvdCB0aGUgaW1wcmVzc2lvbiB0aGF0IHlvdSB0ZXN0ZWQgb24NCj4g
Pj4+PiBhbiBhcm0gcGxhdGZvcm0g4oCTIGRpZCB5b3U/DQo+ID4+PiBZZXMsIHdpdGggcmVzcGVj
dCB0byBteSBwcmV2aW91cyBtYWlsIHVwZGF0ZSwgYXQgdGhhdCB0aW1lIGdvdCB0aGUNCj4gPj4+
IGNoYW5jZSB0byBsb2FkIHRoZSBkcml2ZXIgb24gQVJNIHNlcnZlci9lbmNsb3N1cmUgY29ubmVj
dGVkIGluIG9uZQ0KPiA+Pj4gb2Ygb3VyIHRlc3RlcidzIGFybSBzZXJ2ZXIgYWZ0ZXIgYXR0YWNo
aW5nIHRoZSBjb250cm9sbGVyIGNhcmQuDQo+ID4+PiBUaGVyZSB0aGlzIGVycm9yIGhhbmRsaW5n
IGlzc3VlIHdhcyBvYnNlcnZlZC4NCj4gPj4+DQo+ID4+PiBUaGUgY2FyZC9kcml2ZXIgd2FzIG5l
dmVyIHRlc3RlZCBvciB2YWxpZGF0ZWQgb24gQVJNIHNlcnZlciBiZWZvcmUsDQo+ID4+PiB3YXMg
Y3VyaW91cyB0byBzZWUgdGhlIGJlaGF2aW9yIGZvciB0aGUgZmlyc3QgdGltZS4gV2hlcmVhcyBk
cml2ZXINCj4gPj4+IGxvYWRzIHNtb290aGx5IG9uIHg4NiBzZXJ2ZXIuDQo+ID4+Pg0KPiA+Pj4g
Q3VycmVudGx5IGJ1c3kgd2l0aCBzb21lIG90aGVyIGlzc3VlcywgZGVidWdnaW5nIG9uIEFSTSBz
ZXJ2ZXIgaXMNCj4gPj4+IG5vdCBwbGFubmVkIGZvciBub3cuDQo+ID4+Pg0KPiA+PiBPSywgc2lu
Y2UgeW91IGRvIHNlZSB0aGlzIHNhbWUvc2ltaWxhciBpc3N1ZSB3aXRoIGFub3RoZXIgY2FyZCBv
biBhcm0NCj4gPj4gdGhlbiBJIHRoaW5rIHRoYXQgaXQgaXMgc2FmZSB0byBhc3N1bWUgdGhhdCBp
dCBpcyBhIGRyaXZlciBpc3N1ZS4NCj4gPj4NCj4gPj4gSWYgeW91IGNhbiBzaGFyZSB0aGUgZG1l
c2cgb24gdGhlIGFybSBtYWNoaW5lIHRoZW4gYXQgbGVhc3QgdGhhdA0KPiA+PiB3b3VsZCBiZSBo
ZWxwZnVsLg0KPiA+IFJpZ2h0IG5vdyB0aGUgYXJtIGNvbmZpZ3VyYXRpb24gaXMgbm90IGF2YWls
YWJsZS4gV2lsbCBiZSBkaWZmaWN1bHQgdG8NCj4gPiBnZXQgZG1lc2cuDQo+IA0KPiBCeSBhZGRp
bmcgKGVuYWJsaW5nKSBhIHRvbm5lIG9mIGRlYnVnIGxvZ3MgaW4gdGhlIHRoZSBkcml2ZXIgYW5k
IGVuYWJsaW5nDQo+IGhlYXZ5IGtlcm5lbCBkZWJ1ZyBjb25maWcgb3B0aW9ucyBtb3VudCt1bW91
bnQgd29ya3MgcmVsaWFibHkuDQo+IFNvIGl0IGxvb2tzIGxpa2UgYSB0aW1pbmcgaXNzdWUgLyBt
ZW1vcnkgYmFycmllciBpc3N1ZSAtIHl1Y2suIFNpbmNlIHRoZSBpc3N1ZSBpcw0KPiBzbyByZWxp
YWJseSBwcm9kdWNlZCBpdCBzZWVtcyB1bmxpa2VseSB0byBiZSBhIGJhcnJpZXIgaXNzdWUuDQo+
IA0KPiBUaGVyZSBhcmUgbG90cyBvZiBmaWxlcyBpbiB0aGUgc2hvc3Qgc3lzZnMgZm9sZGVyIC0g
Y2FuIGFueSBvZiB0aGVzZSBiZSB1c2VkIHRvDQo+IGhlbHAgZGVidWc/DQoNCkZvciBteSBkcml2
ZXIgbGV2ZWwgZGVidWdnaW5nIEkgbm9ybWFsbHkgdXNlICJsb2dnaW5nX2xldmVsIiBzeXNmcyB0
byBlbmFibGUgYW5kIGRpc2FibGUNCmxvZ3Mgb2YgZGlmZmVyZW50IGxldmVsIGR1cmluZyBydW4g
dGltZS4NCg0KRm9yIGV4YW1wbGUgdG8gZW5hYmxlIElPIGxvZ2dpbmcNCmNhdCBsb2dnaW5nX2xl
dmVsDQowMDAwMDIwMWgNCmVjaG8gMHgyMDkgPiBsb2dnaW5nX2xldmVsDQpjYXQgbG9nZ2luZ19s
ZXZlbA0KMDAwMDAyMDloDQoNCj4gDQo+IFRoYW5rcywNCj4gSm9obg0KDQpUaGFua3MsDQpBamlz
aA0K
