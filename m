Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20369C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 10:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbiDFKtd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 06:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355816AbiDFKsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 06:48:04 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA693199E37
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 00:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649229087; x=1680765087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1E2Mo1stle24P8x68TmeuLtX5DgmFPLETgHxZ+fa73E=;
  b=TFmzULAqAHO3CCcTpe0tHVvzE+hxMFQBtDtQWYw9uPpfRNC2thGk5XKY
   IC4KD44+as6X1fL8UnCgmDss8tpa+kOvkwgC0NitepKXvP42bt67W5q2N
   4O4Xt7XRrOfxP467UKDBeXYro0JPg0ePtrtbt2HBC/o543snm7XD8IF5q
   ZQ5mA0G7OBpGkoHkZXGcmHKYbth5Y+fvOSg6a24Ji3C6+6tThww8T5dGA
   K4Ni0Gk9exC/kOqz0xGY2/vhE1QIMi6S/MA02zIKPs966AfUf+7iVdh63
   w4Mst1FLr6i5gGRiWmjG+SL0CqCdrPNIfqEntbbF8P6L9v1851dWXqvDg
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,239,1643698800"; 
   d="scan'208";a="154580361"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Apr 2022 00:11:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Apr 2022 00:11:26 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Wed, 6 Apr 2022 00:11:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nd/0h5r67njaD2keFK1MYO2EPjcKp82ikL2csNp1dhlSWuNGyOwKaADX51HLXgqOlAo9YsU5BLN2W7vbUq6Iv/LMBxkvkk5GIBvxCSTeX+vAXB4l78+dUWW5XaWMOr69xi2Vw2tqV+pYcucx+pMEPpFAQJBNvjS3WYrk+4qWwbyCAspupo8AugnG7RqWBaRTPefNF2/o2So9YIY9S6W8LdmzWffyql/A8KbEM3awZsXHUjX7Fzmsqba3IPmagEfsRkOlz6h9jvbh7qhF7SGXBz+KfeZEMfaDm0wCYsHcf1agukmLz5XY1PnfngVUXUT33x/nnTxbs6Uy3pIxpwlwKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1E2Mo1stle24P8x68TmeuLtX5DgmFPLETgHxZ+fa73E=;
 b=CxO1LxsBjZzs689iwC7yfFSFEvRAqYUpAtE17nl8gXL1RaJ2E3wjAsU+QMPGppN10+iWN92iJyIIypHE09pi/PXrkkI/ZU34Kp9U5oXIM5qR3JmeGKI4LIJ4r1ac3ddRck9eyvFs2OenoCs63AWXGGLe9Q/eMpFABlohhPlUwCQbSj5EBOoBjSciD96sWAWKfWf5Vcl2CQd3g4qwXS9KpctJu8K4gC+U3yDFuIIkQBqGmWlBaJAXYLq7oVCGtWM5rsBEpJNLthIqdTe294uhknw/um7OVxgfPEoip5WySHK2ZIg/1/M2K2ML4epXjLmASuGNiNesXsp+PhFYYj/HMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1E2Mo1stle24P8x68TmeuLtX5DgmFPLETgHxZ+fa73E=;
 b=RpHWWGxfuCWOvN6pTt6ZlABzQnY4BBZN4rEYvLZImz7QO9d2glqgZ3Z2DrnexwKcV3imavOh3zKAqV7q4k+5QGay9Pv4bxPXlUv6qciuhcbUK2wZlnh+6RqQPSm4u9eKAsyX6xQBcFdHcuzmJoIIOldKpM5W56qQmhS73mO7TMg=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by DM6PR11MB2746.namprd11.prod.outlook.com (2603:10b6:5:c9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 07:11:15 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::48b9:f92:9375:2983]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::48b9:f92:9375:2983%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 07:11:15 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <damien.lemoal@opensource.wdc.com>, <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <john.garry@huawei.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: RE: [PATCH v2 2/2] scsi: pm80xx: enable upper inbound, outbound
 queues
Thread-Topic: [PATCH v2 2/2] scsi: pm80xx: enable upper inbound, outbound
 queues
Thread-Index: AQHYSWM7uqDDMCcgsEO2xs2FYkc70azidm8Q
Date:   Wed, 6 Apr 2022 07:11:15 +0000
Message-ID: <PH0PR11MB511255978B43754AB13F90A9ECE79@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <20220405092833.83335-1-Ajish.Koshy@microchip.com>
 <20220405092833.83335-3-Ajish.Koshy@microchip.com>
 <866fd2b3-80f9-5696-e564-bcea08e64701@opensource.wdc.com>
In-Reply-To: <866fd2b3-80f9-5696-e564-bcea08e64701@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c7cb72d-4dd0-401c-5e7a-08da179ca3b4
x-ms-traffictypediagnostic: DM6PR11MB2746:EE_
x-microsoft-antispam-prvs: <DM6PR11MB2746DB5A64F7A231D654686DECE79@DM6PR11MB2746.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O64cv9HWeg40EkQunqWsW3xTFJOAJINr64JF1aqPYiRjp8SVv1LxahjtgBXMGX7bCqGuPB6HoMGATx50hMq1qzSWobgMd0PfXmxl0BjNFf15/9lGGUbDOpgXPRKWc/bm1aC0YMUcPjV4DS9GX1s6MjnN0/RLalxYER1iD+itbMIquXKgUWx8ALM6fWgSVua1veGUNnzWKzu80YR/DjY6QMnBey2kx33eNja78bko65voUe6LyS0LyGOBkrFmbayZYS54VqGtBdIp6UEJc0eNWxa0XtpuiJEAreI1rntg3oXJ/BNn2s7BUs1tbS49iyo16OacirYe0oEBiZyoBZPQbeRTaMOrrBpMMaVPkbzPt9AFDiAuKeKOyycIYWHpx2LSqYT5tCFJ/eDWGsslRrFEfgtitOS46TdyO7/U0w+kL/ETgHpl4VJmlHHHheVWi6kzuclwEhL+WOwKFc21AXXZqXZfMV/k5t/5Jz8R0njZSINwbiIDN6RHNPpiAQXxizEut+WuPKGytPcXxe9Ihk2ytivGp5m9bcfiVKw4J/NSJiGrgFH0dTWlnBtkaTd/jvhQ52K3pjCsSXh0U5CydEple27iH7P5E9LRcvXi1EaVMu6UD/4UkxeWAwpMNXaQr+cQtnxwm0qziiYQ5Iqv/60tYEveVfCbo5R1xpzMvtFV1YZHOFZe1jnloolTtpgy7Ay/qurwDOCwwYy/F1hzu1QOtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(9686003)(66946007)(4326008)(316002)(76116006)(53546011)(8676002)(66446008)(38070700005)(7696005)(66476007)(6506007)(2906002)(8936002)(52536014)(86362001)(5660300002)(71200400001)(66556008)(64756008)(55016003)(38100700002)(110136005)(186003)(122000001)(26005)(508600001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWRPRmdFU1hVRnpxaUJsRDYxNXFBdk5GVGoyQ0RtVHZOajVQT05UTmlmWERl?=
 =?utf-8?B?dFZHRGRmYjRZYS9qS3g5NFhYWmc5U2VmN0lldUxEeXdZdzc1SmJXQ3REZjQx?=
 =?utf-8?B?SzN0UFA2Z1Fha1BZc2p3ZGVhZENUckxzd3F0d0YzQ1FuZ0hkeVNpT0p2TCt0?=
 =?utf-8?B?djAvS1VCZ1dwcnBNUDBwd2JoRUFQYWZkMlkrelM4RnFIS0haTDZEdy8yd2sr?=
 =?utf-8?B?ZTBNZDBxbFZleUtKbWlPTFlFV3RLUjFJRTlaOENLVnZVcEFDZkJVUzgrK0R0?=
 =?utf-8?B?VTF3TWs1V3I5RnF4QWo2T0J2NlhwVlg4NW05MEgzRk85OEQ1bnlYeVpWR3Rl?=
 =?utf-8?B?bGhYVU9yaHhYZTJYdzR0Mkk4WTNnWG5KdGJsaCtLQnVHMEVidXpLbHdvWHZS?=
 =?utf-8?B?YjJGRElqek5IMGt0MlZaNk1DL1ZCQlVqOUdQR3laQjk1VlZhNWJhdlBkbnF4?=
 =?utf-8?B?Z21pL3kzZkVxVUlETDJmU3ptSFJxUEJEdldXUmNXMVc1bXl3YTF4aWZFL1N6?=
 =?utf-8?B?dk9xNCtoRHIvZ0NkV3pZbk5CVHd5VXpnQk9pdkpGbnJGS3o0Tkg5K0hUMFBH?=
 =?utf-8?B?ZmF1cXNOa3dCUU03dWNVUVBUTkhDem9mUUdHMG5qZnBFWGJxU3dYZFNxRDZ0?=
 =?utf-8?B?ODN0cW1QYld5eS9QT2JGWTd5cmUyNDUySjhwaHA0V2Fmdi85K3E1UXg2UnlX?=
 =?utf-8?B?ZTdWSGkzOXAzRnhYTW94clZyR1EwTWhyeEFMK1lycmVUMzhDSk5QYk5yUnNn?=
 =?utf-8?B?QWV4YnJsRkJEZFRqY0U3NGdKanFtNnF4R0paZWFHaUJmNzZQSEd3VkxZUHFp?=
 =?utf-8?B?UTB0emE0U1pnV3cxR1g4NDFqSitBK3YvMDFaQ3N4ZmlXMGlvQXRFamFTNEVk?=
 =?utf-8?B?dm5wSXlLTStUTm8rVi8zSWVkVFNlbHBGdkkvcVV5dGRYS0hhaHFMZy9VRVps?=
 =?utf-8?B?MHBkbHZxc3JOVndSZDFoNUVnMzBXZDYzcVNOMkpMZEtad3lKS2Fua1llTkh5?=
 =?utf-8?B?aEoxVkRIUEU4Y05HSDFaZFY2aWwvaVZSNi9SeVdQbUN5ejBHN1pLSXRIRkJO?=
 =?utf-8?B?OWRwVWpmYnpCaVJCOTJGSWpGdWRPRVB6RnMzK05Gb1cxdlNlL1U2MHhISW1R?=
 =?utf-8?B?b095QVd3Z1VqTzlyT3FZNDZFS3ozTzNNZXRIRWFXb0VIVkNvM0o3aFk2U1NG?=
 =?utf-8?B?eHYyR0lOK1RBNDlqa1hJL05vdEZRak9kVGJtN2o0MVRrWGxpTTE5amNRd29S?=
 =?utf-8?B?VmJuQTdQZzBrL0NWUloxMEVtQk1GbXR3SXRKZmFhNHZGYk1lTVlCS01zMjZH?=
 =?utf-8?B?cE9xcHNnWEh1R1o4VWRidzlCOXl3RVd3WU5maVBYWmRpOVluR2FDZXl2L3k4?=
 =?utf-8?B?Ti9ReVR1RTR2ejlxQ0tqL0I4NUtvZ0R2MXEyajdoblJvNmtocFVDWGUzRzNC?=
 =?utf-8?B?Q0IvZXdQdlhGZ2JLZitFNVZaOUhTWXlwMEsyeFJJRHEvTHNsVi9WaU1BL2J3?=
 =?utf-8?B?OTRmMHdHd3Q4Q3RkTGRCUDBOa2krTDQveGFDYnQ5ZElvb2FGa2d6MndqdWJP?=
 =?utf-8?B?ZUwyWmtpUkEzNWphTGtmUFJPNHhKQi93SlRoSmF3aDlrSHJZVldPZkdOSnhC?=
 =?utf-8?B?bG5pazBzVFZzKzhxbGcvSU8yaUFtRTdtdVpxZUtheDdrYTNvT2xWaWF3WWlK?=
 =?utf-8?B?MzlPNlNEQXpRRjhsNm0zK2xTa2pFb0lpVGpyWHdESFl2dHpGQzVZNWwrNDU4?=
 =?utf-8?B?S0NCVHNrbkt5TjVuT0NDSjJLZXI5MVozdXJHdTZTS0lqTFlKTkdTVXZBOXRv?=
 =?utf-8?B?eW13WG85eitObUJOdmROSEowQnlWTzhFWFhCWXV1WDJrdXVHYVpYWFg5M0tV?=
 =?utf-8?B?YTJpMnkrdFpIVC8vblhKclozYXhSYTZESFpMRFgxeDMvOS85dXZ2dWxWNGZx?=
 =?utf-8?B?S2pncFExY0ZQSlRzUjYvRUNCT09ibHJsOFcyc3REbFQ4MmZ0ZjhnUFhCSkp5?=
 =?utf-8?B?UFJ5YzVIeHViNEVrZEVoWGpjeCtMVGYrc1V2Y0g3VjBKQzVmWjZ4cmMvRWs2?=
 =?utf-8?B?UlVYVVZwemdrcVhEUUI4RmRHQXNLWFk4S2MyNE5CdFRsNWY2RVA0cXVHRjRF?=
 =?utf-8?B?aytKVnl4WEY4dDE0TUNqWnpncnFnS3paeVpaSFd5MkJtb0dac2pKeFF3RkVv?=
 =?utf-8?B?aUxhaThkTkVodGlvd3pkbGdNemx3MzVyTkdwc05NdFN0OUFVdVAzeFZOSHo0?=
 =?utf-8?B?dzNsMUFIZzVaN2tyMWZjWFpXL0grUmFyNktzaFVmU1UxZ0prT1BIMHV6WWwx?=
 =?utf-8?B?TG1OSmdnWlpIRVB2RGlJWDUzWS9QTkFiRk5yQmMzTlk1Mnh4S3VLV042bXJV?=
 =?utf-8?Q?WqvqVGnzjvgqEHvs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c7cb72d-4dd0-401c-5e7a-08da179ca3b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 07:11:15.4565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ex/59VsYbSlNv5pOGkVXFWWrLBhyEA/XgOOkEnLEv9o6/4N82GHXKniP8+FdLObEbz5FgQ+BG7d643r/6rKsODewxlij4yE49dAl1QYcpPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2746
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmtzIERhbWllbiBmb3IgeW91ciByZXZpZXcsIHdpbGwgbWFrZSB0aGUgY2hhbmdlcyBpbiB2
My4NCg0KPiBPbiA0LzUvMjIgMTg6MjgsIEFqaXNoIEtvc2h5IHdyb3RlOg0KPiA+IEV4ZWN1dGlu
ZyBkcml2ZXIgb24gc2VydmVycyB3aXRoIG1vcmUgdGhhbiAzMiBDUFVzIHdlcmUgZmFjZWQgd2l0
aA0KPiA+IGNvbW1hbmQgdGltZW91dHMuIFRoaXMgaXMgYmVjYXVzZSB3ZSB3ZXJlIG5vdCBnZXRp
bmcgY29tcGxldGlvbnMgZm9yDQo+ID4gY29tbWFuZHMgc3VibWl0dGVkIG9uIElRMzIgLSBJUTYz
Lg0KPiA+DQo+ID4gU2V0IEU2NFEgYml0IHRvIGVuYWJsZSB1cHBlciBpbmJvdW5kIGFuZCBvdXRi
b3VuZCBxdWV1ZXMgMzIgdG8gNjMgaW4NCj4gPiB0aGUgTVBJIG1haW4gY29uZmlndXJhdGlvbiB0
YWJsZS4NCj4gPg0KPiA+IEFkZGVkIDUwMG1zIGRlbGF5IGFmdGVyIHN1Y2Nlc3NmdWwgTVBJIGlu
aXRpYWxpemF0aW9uIGFzIG1lbnRpb25lZCBpbg0KPiA+IGNvbnRyb2xsZXIgZGF0YXNoZWV0Lg0K
PiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQWppc2ggS29zaHkgPEFqaXNoLktvc2h5QG1pY3JvY2hp
cC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogVmlzd2FzIEcgPFZpc3dhcy5HQG1pY3JvY2hpcC5j
b20+DQo+ID4gRml4ZXM6IDA1YzZjMDI5YTQ0ZCAoInNjc2k6IHBtODB4eDogSW5jcmVhc2UgbnVt
YmVyIG9mIHN1cHBvcnRlZA0KPiA+IHF1ZXVlcyIpDQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL3Nj
c2kvcG04MDAxL3BtODB4eF9od2kuYyB8IDYgKysrKysrDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwg
NiBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3BtODAw
MS9wbTgweHhfaHdpLmMNCj4gPiBiL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3aS5jDQo+
ID4gaW5kZXggM2U2NDEzZTIxYmZlLi5jNDFjMjRhNGI5MDYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy9zY3NpL3BtODAwMS9wbTgweHhfaHdpLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvcG04
MDAxL3BtODB4eF9od2kuYw0KPiA+IEBAIC03NjYsNiArNzY2LDEwIEBAIHN0YXRpYyB2b2lkIGlu
aXRfZGVmYXVsdF90YWJsZV92YWx1ZXMoc3RydWN0DQo+IHBtODAwMV9oYmFfaW5mbyAqcG04MDAx
X2hhKQ0KPiA+ICAgICAgIHBtODAwMV9oYS0+bWFpbl9jZmdfdGJsLnBtODB4eF90YmwucGNzX2V2
ZW50X2xvZ19zZXZlcml0eSAgICAgICA9DQo+IDB4MDE7DQo+ID4gICAgICAgcG04MDAxX2hhLT5t
YWluX2NmZ190YmwucG04MHh4X3RibC5mYXRhbF9lcnJfaW50ZXJydXB0ICAgICAgICAgID0gMHgw
MTsNCj4gPg0KPiA+ICsgICAgIC8qIEVuYWJsZSBoaWdoZXIgSVFzIGFuZCBPUXMsIDMyIHRvIDYz
LCBiaXQgMTYqLw0KPiANCj4gTml0OiBzcGFjZSBtaXNzaW5nIGJlZm9yZSAiKi8iDQoNCk9LLiBX
aWxsIHRha2UgY2FyZSBpbiB2Mw0KDQo+IA0KPiA+ICsgICAgIGlmIChwbTgwMDFfaGEtPm1heF9x
X251bSA+IDMyKQ0KPiA+ICsgICAgICAgICAgICAgcG04MDAxX2hhLT5tYWluX2NmZ190YmwucG04
MHh4X3RibC5mYXRhbF9lcnJfaW50ZXJydXB0IHw9DQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMSA8PCAxNjsNCj4gPiAgICAgICAvKiBE
aXNhYmxlIGVuZCB0byBlbmQgQ1JDIGNoZWNraW5nICovDQo+ID4gICAgICAgcG04MDAxX2hhLT5t
YWluX2NmZ190YmwucG04MHh4X3RibC5jcmNfY29yZV9kdW1wID0gKDB4MSA8PCAxNik7DQo+ID4N
Cj4gPiBAQCAtMTAyNyw2ICsxMDMxLDggQEAgc3RhdGljIGludCBtcGlfaW5pdF9jaGVjayhzdHJ1
Y3QNCj4gcG04MDAxX2hiYV9pbmZvICpwbTgwMDFfaGEpDQo+ID4gICAgICAgaWYgKDB4MDAwMCAh
PSBnc3RfbGVuX21waXN0YXRlKQ0KPiA+ICAgICAgICAgICAgICAgcmV0dXJuIC1FQlVTWTsNCj4g
Pg0KPiA+ICsgICAgIG1zbGVlcCg1MDApOw0KPiA+ICsNCj4gPiAgICAgICByZXR1cm4gMDsNCj4g
PiAgIH0NCj4gPg0KPiANCj4gT3RoZXJ3aXNlLCBsb29rcyBPSy4NCj4gDQo+IFJldmlld2VkLWJ5
OiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEBvcGVuc291cmNlLndkYy5jb20+DQo+IA0K
PiBOb3RlOiBNeSB0ZXN0IGJveCB3aXRoIHRoZSBwbTgweHggSEJBIGhhcyAxNiBjb3Jlcy8zMiB0
aHJlYWRzIG9ubHkgc28gSQ0KPiBjYW5ub3QgcmVhbGx5IHRlc3QgdGhpcy4NCj4gDQo+IC0tDQo+
IERhbWllbiBMZSBNb2FsDQo+IFdlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaA0K
