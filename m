Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1801EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 12:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbiA0MIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 07:08:35 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:58565 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiA0MIe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 07:08:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643285314; x=1674821314;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FHYsP7qfj9pccoCqf/VSBCx6/pDHd9Hh5PVeczU6vyU=;
  b=o+aHQZPBtqWx4Fc+qaKx/JqfxW8yccilzSLXTTR7snNFy9PFpu5zq+2g
   0lAaDmAZQMIV3Go7+Vm81KKngyAi9hRMMq/gl2kx/UVOTa5kWV4mqtdrO
   hyUSVl4fIbuWCErqRQ42o480WMh79PmePrSj4OtwevS06ynqtqv0yLj+c
   DxZ4nGT3/zsNBTSY4/R/xNPpXHj0J6IFNwfFb20HxH4FGm4bBCJ4Jxhuc
   OPA7pQylb3TBsglSgAV+Uw0Uf5uJBRnMYk8ArymCVF51Z2NGuyvw4pNnp
   fTWD6qmWggtacotQDlCKnIBbqFcXNPHLwKpp2dj1OP3pnxAAB1Xa1PVV7
   A==;
IronPort-SDR: JxuPk2H5bZBpkDiNbvJ5KA0SMTltW9qhDmW0kYWfXwv6pGVIyT65Pq//TVYE2hOdn81CwXHjOp
 Ot5yZCWb6EGPmhA9zdUhYRvPnsmaCADxe68jct0ffrVhbksf//AXcb+LEphTC0JsH4/MFkrS7N
 lfo2vhopy4sTWVA3vJMjP17vdEWSfJeZ6GmkncgQk9QXnrdrGJ3+qP/+BiYmusvB75gQeYrDY1
 j7c2vW8myeeIwX+vaP/y2DMAJTwAGE6F434/u7cctE/fz/eKNcyRMxJsZyKXCzMaTYB18gqBOs
 H49ETTRJotrBGib+QScVxF8a
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="83858856"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 05:08:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 05:08:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 05:08:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3ogxTLhdPAO4geHGNRbGFCIFNCGoVD8MYkRK0hdzuDXgJxnZM2TeP7eOR/Go7ZYrXDpwkm0/cBDUXZQjpUlM+XY9zLaF4cXU38WjPpbNK94LRogHGKwAiuik9FXT2hVwad4hVgkS7/oeq6KXSJ/80Ig5gGF2bIUQOzG3sGRyRv7ooyE8WnptvDOjfIq9EM/KzWXjqxIuu9URD7qazeIp9kLbSA6pixDiOEJXbbxd21trra76lTiEZ/WFMHToLPKUf1S8LuRUXWRcG9euoC/HP446Vb55CrCaawCwW6HZuIf7EHFxDQlQ9YibDHtamSFmQTOgmEt+jZE6IVT9oB6jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FHYsP7qfj9pccoCqf/VSBCx6/pDHd9Hh5PVeczU6vyU=;
 b=eFo8Up0+kc5/GJ/vI5qbIviO6BzOgNzKDWSP5Go+rDYkL+gRNaJea1HqPkl0b9JrHGmtU3I2oXphOUpx5ORrKYIa7a7TLhTEpS2GZ/bNtSicquMXuYOPukwKqwADSKZ1x/EG0sLpXSHghMUc6GhHD+otAihcnFiyjVlHm35cHlpMrM1bEvAneQUVQ8iaploXCzx/J6keNIaoEOphRvyjiH4W3z4ZkJZVS5I2U6B0ObSaIwLs0wf+8eLcMkb6A9Vobi92a8/IQyisP+Eyw2WbG9YVcEb0k/C/y1wa3lEWqyz7ZieaVTx1BvvwUFw+kHHrnuX1F00uCZ9p83P8hx+6Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHYsP7qfj9pccoCqf/VSBCx6/pDHd9Hh5PVeczU6vyU=;
 b=rMl1U1w3EJihTzC4A8Nw8b+IfoGfgiu0A6XaxY0anF2qDoYTHSK+xCvthUDvQJM59iSDXvyum6/qO2E3Wlz450J8t6f+iQO57e9i4jo3fqcVYSkPICDiIb1bdP7UAv3yANyg/RnuO/bvrAxsoLc8irl8dTaRxzRgxsG4eKPDA/Y=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by MN2PR11MB3824.namprd11.prod.outlook.com (2603:10b6:208:f4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 12:08:28 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::f1d9:ed22:d95a:59cd]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::f1d9:ed22:d95a:59cd%3]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 12:08:28 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <jinpu.wang@ionos.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>
Subject: RE: [PATCH] scsi: pm80xx: Fix double completion for SATA devices
Thread-Topic: [PATCH] scsi: pm80xx: Fix double completion for SATA devices
Thread-Index: AQHYEWyWtrdnXRVehEWyVddNqe7ubaxzj4FAgAGL7oCAAaq9AA==
Date:   Thu, 27 Jan 2022 12:08:28 +0000
Message-ID: <PH0PR11MB5112A9B6001061AB902D589BEC219@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <20220124082255.86223-1-Ajish.Koshy@microchip.com>
 <CAMGffEnD0+X2pYXZ2==DUMt7uYFBRTJTNm7KsyKMd1JyfTr2pg@mail.gmail.com>
 <PH0PR11MB5112675EFFD42B96E559D034EC5F9@PH0PR11MB5112.namprd11.prod.outlook.com>
 <CAMGffEk3oyDfdJnK3ruv5hKTXY40zsk8xDoAOyQwRj2D-mYmDg@mail.gmail.com>
In-Reply-To: <CAMGffEk3oyDfdJnK3ruv5hKTXY40zsk8xDoAOyQwRj2D-mYmDg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df19f451-c96e-4220-4035-08d9e18dba5b
x-ms-traffictypediagnostic: MN2PR11MB3824:EE_
x-microsoft-antispam-prvs: <MN2PR11MB38240E6E3C4114ABC790BE66EC219@MN2PR11MB3824.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O2s41LoOM1vTadkza3E8o/nSuREe7DWmXoIkWpE3KKO/1uVzmEDsZ0JqnS6u41429SOF0oK7attpvpZg3la1oRxOtDoJ4rJUmUDhYRuKE1mW4uzQCnn1pfzelDE/MlV6SevB4s548O0L/ndli+ZPXiyZ3FyhnjuXtLk9SbI6lnQsSb2Rezn3fo8eN+WzIE6sBSJt9R8ggUfMocG87o35RdofXsFYy1g2+JZgXBO+HeL3AE5efa3ju+s32zrUwdHMJaqxmZTqXvBWa+jGhxRkFSEnnEV92vKPM6xVhyxju5p39ssbbdnfDdBjLG2ME5D8DkpBPRdveyVTChI0zzOtot7/j+K2eVoOgRS/7zE052CS2O2WXgMQ08GoZt5+ae5Asr1ia0gK6iXr2CVD7l7jnLik8+jNxmEpjTL1P/24Zb4pWHmixy1ExotuM0XcWeiFgLCg+4RhUqmsSf85IQoAklxbNOWVvT8xE6z15Xly2nnsnPgdSJUr2y8DGuCx153I55JmjpySfIWuWWsJo63SAdjhMLTVNE7RYvmnin5k7dzpKv4ClmiZEiXYhPQaNi+QIC8NJCMibC6+HUCEPadus386XifoxG8Oz1Hiaiw3ZwoYOsIaeDjdutsnQ00kI4+DmeMqLpQys7bPYRWBaXWm5uyFq4MmD9uWPAzgZaEoC4OQdLmfVRGJIbK1NnyQ3ThrscCvEXzt6aklHbdximrHtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(107886003)(66946007)(316002)(6506007)(4326008)(76116006)(6916009)(9686003)(508600001)(64756008)(52536014)(5660300002)(66446008)(66476007)(66556008)(8676002)(8936002)(55236004)(7696005)(55016003)(26005)(71200400001)(33656002)(38070700005)(2906002)(122000001)(83380400001)(54906003)(186003)(38100700002)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUY3UGJhdzE2REZySnhEc0dxZ1dCL3Vxc3YzNUJ1dTVKTHlObGV3YW81WEtJ?=
 =?utf-8?B?UElWWDBQbm9oRDV2M0tnYzdjOWdaWmlZNU85RjdPL2tsNUxFSHA3MzNJa1di?=
 =?utf-8?B?MlV2ZWdEbmxSVGl2bFNZN1FlREVMVUxicXZWUEx5K2VpMW1TOXVWYkxoOURt?=
 =?utf-8?B?NFBJMmJwZ3N3cTlHZFI3MGNFdWlvWVIxMkd1RUxBTXBTRHVoY3lJbnVrMDFJ?=
 =?utf-8?B?dk9lNzVFM1NNck9CQVRZNHo2MHkyU24yY1R6aXZ6TzBidTdER3ZPaHZydlNa?=
 =?utf-8?B?dVZwQ1lLRk5uY1AxaGwvSWhqTW96MlNkUThuWnhta3lQUnZ0TnZFY0pKT1Vo?=
 =?utf-8?B?RWgxZjl5ZFBtYW1kUGE1K0FCVjBzSjA5d3R0azhac2RFVlFJcW1NSk1qcGF4?=
 =?utf-8?B?OExYT29UZjVLTFFSelk3dG1BREIyUXRsczVNQXZxaER0UW85UFZ3Snh5b2Fq?=
 =?utf-8?B?bFNoQTRheWNxRkRxSW92SUN4RzFPV0c3L2FtRHJHRTdETUlqT1RNQ0pCQTRM?=
 =?utf-8?B?c2VtOTJxYVZKYmxPWUVzVDhmdGJUeWR5bEZ0TnhNRFdGSnVCditGWDZZcjBw?=
 =?utf-8?B?OUlBRUlVVS9ySlpIR2NYVkxOY3ZwSExPaDg0dHJlTUI2OEk1MVRkSkZUUzhq?=
 =?utf-8?B?dDZ6Q1hkb2liT3d2WGsrMzBrTi90a3lXSXB2NUdUaUNoMXg3K0MwVjdnTkFE?=
 =?utf-8?B?dWl4LzcvVStzWWhoa1plR0RZSDI5eHl2MXR5VVJEd25EandNZEtLMEpvaHZD?=
 =?utf-8?B?VytYMXRHL1RoVUlaZFpwNlZjTUVqbDlISFB3a3dZakZCUkVESHc0TUdMeTZs?=
 =?utf-8?B?ckcwWWo5V2VFbWFFc2VGVGd3ckZxOGluQUo5blRpdlkvdkxtSjhFd1ZUNVA4?=
 =?utf-8?B?MnhSaDR2TzlJSk1EMlNhOWkraE5DOG1EODY3NjVFRTJ6SmlxazlNRGNoTjRN?=
 =?utf-8?B?bEpCYVhSMUIvYU1yYjlFaksrMGRTRXYwSmhUTTUvMVVSWnFHRXlXKytOUStU?=
 =?utf-8?B?T3k0QzI4R3dyUUIyNGtBNmVqa1VCWHdDYk1HNU90U3FGdUJkdjFiajNoZFBF?=
 =?utf-8?B?a2ZlRGk0amhIczZHeEVDNWgzZndKT3VRVXNtY2tmMUVqYmpKeHg0ZU5hQlk5?=
 =?utf-8?B?WjgvL0FFdmYvbHJwdmZTeEZ5RlM4ZnY0ZndnWnl0ZkVGMFNqbUhIdGVhK1Rr?=
 =?utf-8?B?bFJjbUl6MVJyUDQvU0wrUWtaeC9yTHVUakZjdVVXaFlIanlUQjdmN094Qi9L?=
 =?utf-8?B?T21SeHBXOVAvZlVXRXhQbTFBQkh4NGlsQ1JiSURvaGVaSCtqTEN1bXN2elVv?=
 =?utf-8?B?eEpudHhkNnZNejFOSFJHWnhjMTBITXBSN2p4VWE3Y21SYTl3MDN3MytBUmFY?=
 =?utf-8?B?bkE0VUNydEtRd2pTbXhCTGhlL3V5a0NFcGl4dUFXK3R4Y2pCbElCVEtCbkpx?=
 =?utf-8?B?emxoYVFiRXFZaTZZU0xidmNqL2NVeTJwMnYrV2dxeW9vdjQyK3dFdXhFUWtS?=
 =?utf-8?B?VUYvSGR2L0lXODVlV3NwN3AwWm4wdmNYZjZnV0V6MW1Iazl4SW9TV3daOWFR?=
 =?utf-8?B?Z1ByM1dRWjNnRlYzTEdvSWVUaytqQTBweVpGZEhBMEw3TnFXb28rSFJYcXQy?=
 =?utf-8?B?b2JPUEljNHBKbFlPZUhFb0NWSElTc3RVcFFHTW5oelhENm45NzM3U0ZpZVp5?=
 =?utf-8?B?bUVGd01qckEvb0x1NUhNVHJFUmNVblNudXUzSVh1ZkRwbTZ1RHdpOGxVQWdo?=
 =?utf-8?B?Um9Pa1pLRE0wcVMrRVltd0w3dWQzQ2UxUGNlYlRFMGdoZk1BRXI2U2wwdXJW?=
 =?utf-8?B?cXR5MzhBdmxwNThBZWJUTG5uRi9RRklrb2xJRVZNYWVkWmo5RjByWkhiSjhE?=
 =?utf-8?B?V3VCajEwRjkxQ2lmNk40bFBVRHFsVllUeEVpN2hSN3FCdCt6OVl6azhNdjFJ?=
 =?utf-8?B?QXFvZ0o1SHdGN3VvQk8zamo4cnY5cFR0Q1lTQ3hBMmYrS1YxblF4OUYvL21W?=
 =?utf-8?B?Z3RlM1BGRXNlMGUrTzhqUEtwc2FUYTVpYmZNZUhDMFJnWkliZTM2aERYRURu?=
 =?utf-8?B?amdkcWFUaTVQdTBsVkowUnE1ajQyOW9sZDQwQmRtNVUxMVJDSm1DYXVhOVJu?=
 =?utf-8?B?dGxmUnhOMnNyd2ZBTzdwbndHeFJHSjlkR1N1VmFCYW5rRHVKTVdoTXUvMVZF?=
 =?utf-8?B?NXBsYUgzaWRsMlB2Sk9Td2lpUWxPdURBQnZBNmN4U0pXdEo3VVZPeVhrQTFW?=
 =?utf-8?B?L0VhVHViY2c5Q2NDMVFQWVI1R2R3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df19f451-c96e-4220-4035-08d9e18dba5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 12:08:28.1879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tidrusNQ6dcShz/+sF+k/yEWBnRFM2fETBW0ZDFU3zBKhkNaaASGBhWo0IL+pVNfiXR1hcFTX4c9ex3rSDLTxe1dqvWf0pgcdpTPcJQtosk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3824
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSmlucHUsDQoNCj4gPiA+ID4NCj4gPiA+ID4gRm9yIFNBVEEgZGV2aWNlcywgY29ycmVjdCB0
aGUgZG91YmxlIGNvbXBsZXRpb24gaXNzdWUuDQo+ID4gPiA+DQo+ID4gPiA+IEN1cnJlbnQgY29k
ZSBoYW5kbGVzIGNvbXBsZXRpb25zIGZvciBzYXRhIGRldmljZXMgaW4NCj4gPiA+ID4gbXBpX3Nh
dGFfY29tcGxldGlvbigpIGFuZCBtcGlfc2F0YV9ldmVudCgpLg0KPiA+ID4gPg0KPiA+ID4gPiBC
dXQgYXQgdGhlIHRpbWUgd2hlbiBhbnkgc2F0YSBldmVudCBoYXBwZW5zLCBmb3IgYWxtb3N0IGFs
bCB0aGUNCj4gPiA+ID4gZXZlbnQgdHlwZXMsIHRoZSBjb21tYW5kIGlzIHN0aWxsIGluIHRoZSB0
YXJnZXQuIEl0IGlzIHdyb25nIHRvDQo+ID4gPiA+IGNvbXBsZXRlIHRoZSB0YXNrIGluIHNhdGFf
ZXZlbnQoKS4NCj4gPiA+DQo+ID4gPiBJcyBpdCBhbHNvIGFuIGlzc3VlIGZvciBTU1A/IHdoYXQg
aXMgdGhlIHNpZGUgZWZmZWN0LCB0aGUgY3VycmVudA0KPiA+ID4gY29kZSB3aWxsIGxlYWQgdG8g
KHcvbyB0aGlzIHBhdGNoKT8NCj4gPiA+IHdoeSBTQVRBIGlzIGRpZmZlcmVudD8NCj4gPiA+DQo+
ID4gPiBUaGFua3MhDQo+ID4NCj4gPiBUaGFua3MgSmlucHUuDQo+ID4NCj4gPiBZZXMsIHNhbWUg
aXNzdWUgd2l0aCB0aGUgU1NQIGV2ZW50IHBhdGggdG9vLiBXZSBuZWVkIHNpbWlsYXIgY2hhbmdl
cw0KPiA+IHRoZXJlIGFsc28uDQo+ID4NCj4gSWYgdGhhdCdzIHRoZSBjYXNlLCBwcm9iYWJseSBp
dCBzaG91bGQgZml4IGluIHNhbWUgcGF0Y2guDQoNCldlIGRvIGhhdmUgcGxhbnMgdG8gcG9zdCB0
aGUgY2hhbmdlcyBmb3IgDQpzc3AgZXZlbnQgcGF0aCB0b28uIFdpbGwgYmUgaGFuZGxlZA0KaW4g
YSBzZXBhcmF0ZSBwYXRjaC4NCg0KVGhpcyBldmVudC9jb21wbGV0aW9uIGlzc3VlIGNhbWUgdG8g
bGlnaHQgb25seQ0KcmVjZW50bHkgd2hlbiBmaXJtd2FyZSBmb3Igb25lIG9mIHRoZSBTQVRBIA0K
ZGV2aWNlIGdlbmVyYXRlZCBJT19YRkVSX0VSUk9SX05BS19SRUNFSVZFRCANCmV2ZW50IGFuZCBs
YXRlciBmaXJtd2FyZSBhdHRlbXB0ZWQgdG8gdGhlDQpjb21wbGV0ZSB0aGUgc2FtZSBjb21tYW5k
Lg0KDQo+IA0KPiA+IE15IHVuZGVyc3RhbmRpbmcgaGVyZSBvbiBzaWRlIGVmZmVjdHMgd2l0aG91
dCB0aGlzIHBhdGNoLSBIZXJlIGlzIHRoZQ0KPiA+IGV4cGVjdGF0aW9uIG9mIHRoZSBmaXJtd2Fy
ZS4NCj4gPiBUaGUgY29udHJvbGxlciBzZW5kcyBhIHNhdGFfZXZlbnQgbm90aWZpY2F0aW9uIHRv
IGluZGljYXRlIHRoYXQgdGhlDQo+ID4gSS9PIGlzIG5vdCBmaW5pc2hlZCAobWF5IGJlIHBlbmRp
bmcgaW4gdGhlIGNvbnRyb2xsZXIgb3IgaW4gdGhlIHJlbW90ZQ0KPiA+IHRhcmdldCkgYW5kIHRo
YXQgdGhlIGhvc3QgbXVzdCB0YWtlIGFkZGl0aW9uYWwgYWN0aW9uLiBUaGUgaG9zdCBhY3Rpb24N
Cj4gPiByZXF1aXJlZCBkZXBlbmRzIG9uIHRoZSBldmVudCByZWNlaXZlZC4NCj4gPg0KPiA+IFRo
ZXJlIGFyZSBjYXNlcywgd2hlcmUgY29tbWFuZHMgbmVlZCBzcGVjaWFsIGhhbmRsaW5nIG1lbnRp
b25lZCBhcyBwZXINCj4gPiB0aGUgc3BlYy4NCj4gPg0KPiA+IEJ1dCBmb3IgbW9zdCBvZiB0aGUg
ZXZlbnQgdHlwZXMsIHRoZSBob3N0IG11c3QgcmVzZXQgdGhlIFNBVEEgZHJpdmUNCj4gPiBhbmQg
YWJvcnQgdGhlIHBlbmRpbmcgSS9PIGluIHRoZSBjb250cm9sbGVyIGJ5IHNlbmRpbmcgYWJvcnQg
Y29tbWFuZA0KPiA+DQo+ID4gVGlsbCBoZXJlIGluc2lkZSB0aGUgZmlybXdhcmUgYWxsIHRoZSBy
ZXNvdXJjZSBhcmUgaW50YWN0LCB0YWcsDQo+ID4gbWVtb3J5LCBldGMuDQo+ID4NCj4gPiBOb3cg
aW4gdGhlIGhvc3Qgc2lkZSwgb25jZSB3ZSByZWNlaXZlIHRoZSBldmVudCwgaG9zdCB3aWxsIGZy
ZWUgaXRzDQo+ID4gb3duIHJlc291cmNlcywgdGFnLCBkbWEgbWVtb3J5LCBldGMuIGJ5IGNhbGxp
bmcgaXRzIG93biBjb21wbGV0aW9uLg0KPiA+DQo+ID4gU28gYXQgdGhpcyBwb2ludCBmaXJtd2Fy
ZSBoYXMgbm90IGZyZWVkIGl0cyBvd24gdGhlIHJlc291cmNlcyBhbmQgaG9zdA0KPiA+IGZyZWVk
IGl0cyByZXNvdXJjZXMgY29ycmVzcG9uZGluZyB0byB0aGUgZ2l2ZW4gY29tbWFuZC90YWcuDQo+
ID4NCj4gPiBGb3IgZXhhbXBsZSwgaW4gdGhlIGNhc2Ugb2YgSU9fWEZFUl9FUlJPUl9OQUtfUkVD
RUlWRUQgc2F0YSBldmVudC4NCj4gPiBIZXJlIGZpcm13YXJlIHdpbGwga2VlcCByZXRyeWluZyB0
aGUgY29tbWFuZC4gVGhlcmUgYXJlIGNoYW5jZXMgdGhlDQo+ID4gY29ycmVzcG9uZGluZyBjb21t
YW5kIG1heSBnZXQgc3VjY2Vzc2Z1bCBhbmQgZmlybXdhcmUgbWF5IGdpdmUNCj4gPiByZXNwb25z
ZSB0aHJvdWdoIHNhdGEgY29tcGxldGlvbi4NCj4gPg0KPiA+IFNpbmNlIHdlIHJlY2VpdmVkIHRo
ZSBzYXRhX2V2ZW50LCB3ZSB3aWxsIGNvbXBsZXRlIHRoZSBjb21tYW5kLg0KPiA+IEhvc3Qgd2ls
bCBmcmVlIGl0cyBvd24gcmVzb3VjZXMsIHRhZ3MsIGRtYSBtZW1vcnksIGV0Yy4gQXQgdGhpcyBw
b2ludA0KPiA+IHdoZW4gd2UgcmVjZWl2ZWQgdGhpcyBldmVudCwgY29tbWFuZCB3YXMgc3RpbGwg
cGVuZGluZyBpbiB0aGUgdGFyZ2V0Lg0KPiA+DQo+ID4gSW4gdGhpcyBjYXNlIHNpbmNlIHdlIGZy
ZWVkIHRoZSBETUEgbWVtb3J5LCB3aGlsZSBmaXJtd2FyZSBjb21wbGV0ZXMNCj4gPiB0aGUgY29t
bWFuZCwgaXQgd2lsbCBnZW5lcmF0ZSBJT19YRkVSX1JFQURfQ09NUExfRVJSIGV2ZW50IChwY2ll
DQo+IGVycm9yDQo+ID4gYmFzZWQpIGZvciB0aGUgc2FtZSB0YWcvIGNvbW1hbmQgc2luY2Ugd2Ug
YWxyZWFkeSBmcmVlZCB0aGUgRE1BDQo+ID4gbWVtb3J5L3Jlc291cmNlcy4NCj4gTXkgaW1wcmVz
c2lvbiB3YXMgdGhlIEZXIHNob3VsZCBlaXRoZXIgZ2VuZXJhdGUgU0FUQV9FVkVOVCBvcg0KPiBT
QVRBX0NPUE1MRVRJT04sIGJ1dCBub3QgYm90aCwgd2FzIHRoaXMgYmVoYXZpb3IgY2hhbmdlZD8N
Cg0KSSB0b28gaGFkIHNhbWUgaW1wcmVzc2lvbiB3aGVuIHN0YXJ0ZWQgdG8gbG9vayBpbnRvIA0K
cG04MHh4IGNvZGUuIEJ1dCB0aGF0IGlzIG5vdCB0aGUgY2FzZSBhZnRlciBnb2luZw0KdGhyb3Vn
aCB0aGUgZmlybXdhcmUgc3BlYy4gJ0R1cmluZyBldmVudHMgdGhlIGNvbW1hbmQNCmlzIHN0aWxs
IHdpdGggdGhlIGZpcm13YXJlLicNCg0KSW4gc29tZSBjYXNlcyB3ZSBtYXkgZ2V0IFNBVEFfRVZF
TlQgYXMgd2VsbCBhcw0KU0FUQV9DT01QTEVUSU9OIGZvciB0aGUgc2FtZSBjb21tYW5kDQppLmUu
IGV2ZW50KCkgZmlyc3QgYW5kIHRoZW4gY29tcGxldGlvbigpLg0KDQpUaGFua3MsDQpBamlzaA0K
DQo+IA0KPiBUaGFua3MhDQo+IA0KPiA+DQo+ID4gVGhhdCdzIG9uZSBzaWRlIGVmZmVjdCByaWdo
dCBub3cuDQo+ID4NCj4gPiBBbm90aGVyIGluc3RhbmNlIEkgY2FuIHNlZSBpcyBkdXJpbmcgSS9P
LCBob3N0IHdpbGwgZnJlZSB0aGUgdGFnIG9uY2UNCj4gPiB3ZSByZWNlaXZlIGFuIGV2ZW50LCBz
YW1lIHRhZy9jb21tYW5kIGlzIHN0aWxsIHBlbmRpbmcgaW4gdGhlIGZpcm13YXJlDQo+ID4gYW5k
IHBvc3QgdGhpcyBldmVudCBob3N0IHJlLWFsbG9jYXRlcyB0aGlzIHRhZyB0byBzb21lIG90aGVy
IG5ldw0KPiA+IHJlcXVlc3QuIFRoaXMgbWF5IGxlYWQgdG8gc29tZSB1bi1leHBlY3RlZCBzaXR1
YXRpb24uDQo+ID4NCj4gPiBUaGF0IGlzIHdoYXQgSSBjYW4gdmlzdWFsaXplIHJpZ2h0IG5vdyBh
cyBzaWRlIGVmZmVjdHMgd2l0aG91dCB0aGlzDQo+ID4gcGF0Y2guDQo+ID4NCj4gPiBUaGFua3Ms
DQo+ID4gQWppc2gNCj4gPg0KDQo=
