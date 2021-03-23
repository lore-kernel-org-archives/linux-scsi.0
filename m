Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223E1C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 12:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5EB7619B1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 12:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhCWMsj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 08:48:39 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:37281 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbhCWMsY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 08:48:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616503704; x=1648039704;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DxVIH4+VyAt+N51qea6w/XMq7p4kg8zs7HvAnfNgluo=;
  b=psjnpVvx1PI3ntLl2zUJ+4l3FurVJXDGBxjJNyoo5ZkdC/ObH9K2oeR8
   RAbT0nqQg2PAlLxZ7qm5xETggUMeX0/mb9GVzYeL60ZczWfxIrRUEURY3
   sKfgLo/PF8Aik6q4GGjwZst/m7cXgJJD/7ZVuqjojK9hXUdx6GNwl13JG
   rd0RqXl0LWb4FWUD5TEv9D4iesJrLSKcEWaYccX4mKSL/eqhA1Xyqp3Gx
   gbDWBCwuihKB+luJ76prhxxv6nn+YTIDvq+yKj7ipsDw276WHYs1HdvPv
   z5QPox1/ncSWr/iwaULpdwwOPIhLovLDYz09/miBjJUEOGqIIBnCCnNOn
   g==;
IronPort-SDR: sX+qHCGfVNxYM3QlQ19hc8Z+92GZffknOwAhGafVFmpxZsTUhrKSRJRxGX6tD3mI5vNZxiNjmH
 deg/svAV9iMW7n/kMVYz7NENQb6x2r44cPapTIlCd65HF1UuB//AClWCoQvJp68GZwsw6MWJq/
 bWWyAjY1RHk3im6CUdp5B/BBxo5x2GVOje80ZnsjgwGh+R9m+u2A7pCZpgmFpZeFo2hryTPOj0
 3sO8/0Fo/gGsDugFq3x+ogIVlAwshIr8GhhkK8ZTmqMQdOiJfOSBGk8O4UTiiG+/xzFxe4OVzI
 qP8=
X-IronPort-AV: E=Sophos;i="5.81,271,1610380800"; 
   d="scan'208";a="162744261"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 23 Mar 2021 20:48:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSWfb/jRD0Pe9ft5elcFZNTZ+2DCWmLnOOBI7af5IYxL7GqtRPsuEru5d3iTYiiwcuufMjDLERuVE+OU+ZAVET5e25CxwcUIlBDqBthiZLe6Pci+vwwJPtdYaQ6ed7ByQ4scMtAlobqEAOTc/PL5KD+gD8gl2uriTdUS6uNknRg0wDpP+gudjdZl2Js6NmLQDNaMHlenBOTfVzw89wCUBUC1PCArKHBJcPoUzSwR4RutVFHliAGh+GI04+e14tAScfu8WaGQW+R61yoFIKDY2Pog0vVgD9zn/aH7bTEtAYkf/VOdWiVQoDgSJiFPkOoeLgy2gHY4SshJ88ZniANSnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxVIH4+VyAt+N51qea6w/XMq7p4kg8zs7HvAnfNgluo=;
 b=Zs0+WkQ/X/oZpiC6pG5FwD79RKgOBiXhAKoztz/wDxJle/zQfMPM7PPQWgJQy+/zuoVseUBU7klaEhEoR74gYNY+uweZvN3SrIVyE8wCWMvhCGzGxk3F5T+bBcWtDQYG9A9o5VimmLqGDGUxIxoFRxC4wK4sM39AUCaFhF79JjQVAluJ+odsFRDqThtJWF1sUpmESGQOedTX0va8BBAnU6/fk2HY8om5WIIHZWK692CPy4BJxVt3E0soTeSzwte9u3Yb/dQ6P6mGK/vZgga1+/z/JWmRLBDst0h+9VnM5g0zdyNokG2Aq19Xh1W7N+tQp92SbJVGa1xuu67GXWO1UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxVIH4+VyAt+N51qea6w/XMq7p4kg8zs7HvAnfNgluo=;
 b=S5tzPihBgx/7tgJBajjsPIJeda/Pb1r30efGUQHUP6dOf0a/T47xo5aaXrltfVEse778nxb6prQ++i4fRm1+3t38it25EkNbv5dWrfMiLegG+zqbFppUlrFg/NT/4fdbhDo0watDWhser9QDeFrQGA4mD5nqNF51p0Io0bsG+oc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6795.namprd04.prod.outlook.com (2603:10b6:5:24f::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Tue, 23 Mar 2021 12:48:16 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 12:48:16 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>
CC:     Bean Huo <huobean@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Subject: RE: [PATCH v31 2/4] scsi: ufs: L2P map management for HPB read
Thread-Topic: [PATCH v31 2/4] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHXH7BtbFfye4mAakCWSvCMt+KXRKqRhEyg
Date:   Tue, 23 Mar 2021 12:48:16 +0000
Message-ID: <DM6PR04MB657535F2F25BB41CAD191DB6FC649@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <f224bea78cf235ee94823528f07e28a6@codeaurora.org>
 <1df7bb51dc481c3141cdcf85105d3a5b@codeaurora.org>
 <e9b912bca9fd48c9b2fd76bea80439ae@codeaurora.org>
 <20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p5>
 <20210322065410epcms2p431f73262f508e9e3e16bd4995db56a4b@epcms2p4>
 <75df140d2167eadf1089d014f571d711a9aeb6a5.camel@gmail.com>
 <d6a032261a642a4afed80188ea4772ee@codeaurora.org>
 <20210323053731epcms2p70788f357b546e9ca21248175a8884554@epcms2p7>
 <20210323061922epcms2p739666492ebb458d70deab026d074caf4@epcms2p7>
 <CGME20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p2>
 <20210323063726epcms2p28aadb16bb96943ade1d2b288bb634811@epcms2p2>
 <a9017bbb57618c5560b21c1cdadb4f80@codeaurora.org>
In-Reply-To: <a9017bbb57618c5560b21c1cdadb4f80@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [192.116.177.147]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5bff5a93-4369-4480-780b-08d8edf9eda5
x-ms-traffictypediagnostic: DM6PR04MB6795:
x-microsoft-antispam-prvs: <DM6PR04MB6795969AF3A5B63D94EDBE57FC649@DM6PR04MB6795.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fGdn+A1R4wxGDDefmiw+20dz6edNLXm3Xs+SzY6WKzUGgibm9DXVdRMMKCf9+KpHiBeJg3fbo4YjU/TJvl6yZrIo5sr+QjZIudSwN/K92TabUKw70sfvZYnhNGhAX8/jqJwPuCZwQeNu9kcVh8nxszx6oJCFIjS1QPJVeeZUPzeIxsRs800hWVrx5y2Qx7B9iSmeiqnhY1kGkLQQU06LWjY2tPJLmpq5VHnuA0X61sAtqhaIUDIF7O9eDSTuH1cztqmy8Ej/zeo7omJhHzf/+Z4r2uTphf1oOwLDXdpFmDDQRudvD+0um7OMAqzEh634XSU+y7Z3qC4Rr0f5s/2baDLBSaZQgoAybNMKYtJXKNUCjKCMmFhKjhba6yssWJsKk1WcjpQ2fs+mJrrBjhbeDVRPaKchwk6g3sqYuUd215NZt3Wuih63I+B+2T9/XMKgpzOU1Ab2ZF1MKLU+DKE0UEi2avREZWpigmtcc808va4kyTJlXbIrcL10LZbBco6nPiXd/vxZly8hpPUhAI6WaEUVa7MZW1z3wFH7TMLrtJk6TTThp8HJ+hIMMLVQPQtk3f0IVdC/nZI0WNc3AnOpsoAFPYyqmGju8zxbXPiuYs3MHPbD+75jcSYfagjcU3aNAe3EIPUIAxFYG/AIg+48RmYksc5oW5AKUVdihJXRipQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39840400004)(66946007)(52536014)(83380400001)(66556008)(66476007)(7416002)(55016002)(2906002)(66446008)(64756008)(33656002)(8676002)(110136005)(53546011)(4326008)(5660300002)(54906003)(38100700001)(6506007)(86362001)(478600001)(8936002)(186003)(26005)(316002)(9686003)(76116006)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TTJtS2dxY3hVR3p6d3JveEdoVlM0TFlOZmRJUHFmZzk1cERlbVhHNys0aWV1?=
 =?utf-8?B?WWNCK2xFT2NXYjcxWlZUYmJ2Sms1MmZlMnY5alcyVU9aYm1TcmdaQjhiSXl0?=
 =?utf-8?B?bkt6c1Erckp5U3NQUXRWdkNjZVc1RTMwaEFQZlJDT013bHF3b2tHVDh3Rllw?=
 =?utf-8?B?MkNKWUpZQURPanhCb0ZTbkRCNDhRRlJyTXYxVkQ4dFQ3M0FYMlRKaDYxaDgy?=
 =?utf-8?B?WVd0elpnRGR0T09lT2RtVjY3b0hrVUt5dnVxUUxJZ0VOakVrSkgrT2tBTTUv?=
 =?utf-8?B?NFpYQzZVRkFkY1hxdWdFdlV1U0YyQnFQcDl5TWJRVWtZWHA1dGRvbHQ4Z3pF?=
 =?utf-8?B?bmRXRWFJSFJETmN6YjQ5dkx4VXFIVnViWGNMbnR2dXo5cXdGZ2I2dXN1cXVs?=
 =?utf-8?B?bkJJazZIVVNIUDVMQlpBSytHU2dWYVZEQ0x2OWFyZWowUktwRjQyZDI1aWhp?=
 =?utf-8?B?dW15R1NpNWh1VnJDdEFGalpkWWc4MkJpRkk5eUM2TnUyVENzRnZ0SlFFdTIz?=
 =?utf-8?B?T09EYXozeWdCdklCblBsdzlsMGJIczg1WC9acVQ1ZlAvMllrdUlxZ1FaTWNX?=
 =?utf-8?B?UFVPaE1iU1NhNjZ4OUxqQzE0amtTQWdzOG9QYVhNSmdLRTNpQk9KdnpvYk5a?=
 =?utf-8?B?RFlUbWRZWExtQ1VmOFR1WmxUVkhaZFUzOUMrc2pOeHJkdjdMRThjUmswcGov?=
 =?utf-8?B?R2pHV3lqejk0NDIyV3hNaXBQeHFpUWlOZFdvc2tpVTF3dDYxM1hBdVNSdWdV?=
 =?utf-8?B?T2ZhbnBOanZCblpKRzZRekZRMGQ4Ui9SRkpJUnJvRWdWYXk5U0ZjcCtUdHli?=
 =?utf-8?B?WTh2SjFXY1hRQVFRQ3l2cERUVmFNK3lSOUJpV1QyNUw3SVg2elJ5RHBPenk0?=
 =?utf-8?B?aFBKZE1xbnFMeGNXKzZ6azBQMHU1YklnVENISVA5NkR6WlArcTR3cmhaZytk?=
 =?utf-8?B?b1Y2NWZPNVBUNHBGRzZlQlg4a2EzWnB5Y2FZSDB0QUFaWTFBSUsrSktpR3VJ?=
 =?utf-8?B?cjFkTnMzOXY2b3F4WGJPeVpOd3ZOb0F0RjZYYVJSUHlhd0V1REMyZElVZktQ?=
 =?utf-8?B?YUExaUo4UzUxL1RyTFYrUkxlMmhUMkEreEZIOEdqcEtoZTM3ZDdIVFJUdUNY?=
 =?utf-8?B?SWF6N0VFTlByV0Zvd2ttQ1RqT1ZJVWwrVjlhZTREeUVpRVAxRS9RZzhocktR?=
 =?utf-8?B?T093VjBMRjRVL3BvZ1U3b1VSNm9YWkp6OFp2dmk2ZEdocXEvRThYWWtNSFlq?=
 =?utf-8?B?T242M3BJOVBVVzNwQU43UDFQNk5JV085UmVXamh1QS80MlFVQUljd050Lzd0?=
 =?utf-8?B?aWtKL2lsR2F0bzFhQ25qKzJNL1lnZStRZlJWcGsxeUZpTTVpREpBeEdkd1pt?=
 =?utf-8?B?QmdHK25uc0V1TG9ZSnJVaEZtRDR6TEF3Z3VIeW42ZzlhQW5Zd29RN3VhTFVZ?=
 =?utf-8?B?S0pHU2J2ZVB2dHZuV2Y2K2ZXUVBRdldaYUp2R0NIMGlySThLZjNEdHliQlpC?=
 =?utf-8?B?eHdjeTU5TFpldk5OMitjOFRWUDFzNE5zeFdzOG5ibGk0ZTdRbm14U1FPeDVh?=
 =?utf-8?B?d0dwc3BSNGQ5SURQOHRlNk1KQXZvN2drZEJVU2dGWGZZSFVIU3VaeTZDcGRq?=
 =?utf-8?B?WWdpeCtKVEo1TjFxWEl6OGVHbzhKMkxPRzVFNU8rc2dLRU1PMlpmOVhpTVps?=
 =?utf-8?B?MHptWmhUYTRHVnROWmdWb1BQYWlycEZITHBsWE1pVWQzaWF1Y1pJR0xpYjhY?=
 =?utf-8?Q?uVTD623Mj+3iTlutxDXQuV1NXEVJ2QYgDlkuqHy?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bff5a93-4369-4480-780b-08d8edf9eda5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2021 12:48:16.1145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MjWIMitMg8BhkweKOead+vJXaXs8dx6f5zETqNYpA8Mpksd5ATTvDFPEhLo8TEfl+Syn2Jxgrlo/7g5utPxSZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6795
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gMjAyMS0wMy0yMyAxNDozNywgRGFlanVuIFBhcmsgd3JvdGU6DQo+ID4+IE9uIDIw
MjEtMDMtMjMgMTQ6MTksIERhZWp1biBQYXJrIHdyb3RlOg0KPiA+Pj4+IE9uIDIwMjEtMDMtMjMg
MTM6MzcsIERhZWp1biBQYXJrIHdyb3RlOg0KPiA+Pj4+Pj4gT24gMjAyMS0wMy0yMyAxMjoyMiwg
Q2FuIEd1byB3cm90ZToNCj4gPj4+Pj4+PiBPbiAyMDIxLTAzLTIyIDE3OjExLCBCZWFuIEh1byB3
cm90ZToNCj4gPj4+Pj4+Pj4gT24gTW9uLCAyMDIxLTAzLTIyIGF0IDE1OjU0ICswOTAwLCBEYWVq
dW4gUGFyayB3cm90ZToNCj4gPj4+Pj4+Pj4+ICsgICAgICAgc3dpdGNoIChyc3BfZmllbGQtPmhw
Yl9vcCkgew0KPiA+Pj4+Pj4+Pj4NCj4gPj4+Pj4+Pj4+ICsgICAgICAgY2FzZSBIUEJfUlNQX1JF
UV9SRUdJT05fVVBEQVRFOg0KPiA+Pj4+Pj4+Pj4NCj4gPj4+Pj4+Pj4+ICsgICAgICAgICAgICAg
ICBpZiAoZGF0YV9zZWdfbGVuICE9IERFVl9EQVRBX1NFR19MRU4pDQo+ID4+Pj4+Pj4+Pg0KPiA+
Pj4+Pj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgZGV2X3dhcm4oJmhwYi0+c2Rldl91ZnNf
bHUtPnNkZXZfZGV2LA0KPiA+Pj4+Pj4+Pj4NCj4gPj4+Pj4+Pj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICIlczogZGF0YSBzZWcgbGVuZ3RoIGlzIG5vdA0KPiA+Pj4+Pj4+Pj4g
c2FtZS5cbiIsDQo+ID4+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+Pj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgX19mdW5jX18pOw0KPiA+Pj4+Pj4+Pj4NCj4gPj4+Pj4+Pj4+ICsgICAgICAg
ICAgICAgICB1ZnNocGJfcnNwX3JlcV9yZWdpb25fdXBkYXRlKGhwYiwgcnNwX2ZpZWxkKTsNCj4g
Pj4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+PiArICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4+Pj4+Pj4+
Pg0KPiA+Pj4+Pj4+Pj4gKyAgICAgICBjYXNlIEhQQl9SU1BfREVWX1JFU0VUOg0KPiA+Pj4+Pj4+
Pj4NCj4gPj4+Pj4+Pj4+ICsgICAgICAgICAgICAgICBkZXZfd2FybigmaHBiLT5zZGV2X3Vmc19s
dS0+c2Rldl9kZXYsDQo+ID4+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+Pj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICJVRlMgZGV2aWNlIGxvc3QgSFBCIGluZm9ybWF0aW9uDQo+ID4+Pj4+Pj4+PiBkdXJp
bmcNCj4gPj4+Pj4+Pj4+IFBNLlxuIik7DQo+ID4+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+Pj4gKyAgICAg
ICAgICAgICAgIGJyZWFrOw0KPiA+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+PiBIaSBEZWFqdW4sDQo+ID4+
Pj4+Pj4+IFRoaXMgc2VyaWVzIGxvb2tzIGdvb2QgdG8gbWUuIEp1c3QgaGVyZSBJIGhhdmUgb25l
IHF1ZXN0aW9uLiBZb3UNCj4gPj4+Pj4+Pj4gZGlkbid0DQo+ID4+Pj4+Pj4+IGhhbmRsZSBIUEJf
UlNQX0RFVl9SRVNFVCwganVzdCBhIHdhcm5pbmcuICBCYXNlZCBvbiB5b3VyIFNTIFVGUywNCj4g
Pj4+Pj4+Pj4gaG93DQo+ID4+Pj4+Pj4+IHRvDQo+ID4+Pj4+Pj4+IGhhbmRsZSBIUEJfUlNQX0RF
Vl9SRVNFVCBmcm9tIHRoZSBob3N0IHNpZGU/IERvIHlvdSB0aGluayB3ZQ0KPiA+Pj4+Pj4+PiBz
aG91ZA0KPiA+Pj4+Pj4+PiByZXNldCBob3N0IHNpZGUgSFBCIGVudHJ5IGFzIHdlbGwgb3Igd2hh
dCBlbHNlPw0KPiA+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+PiBCZWFuDQo+ID4+Pj4+
Pj4NCj4gPj4+Pj4+PiBTYW1lIHF1ZXN0aW9uIGhlcmUgLSBJIGFtIHN0aWxsIGNvbGxlY3Rpbmcg
ZmVlZGJhY2tzIGZyb20gZmxhc2gNCj4gPj4+Pj4+PiB2ZW5kb3JzDQo+ID4+Pj4+Pj4gYWJvdXQN
Cj4gPj4+Pj4+PiB3aGF0IGlzIHJlY29tbWFuZGVkIGhvc3QgYmVoYXZpb3Igb24gcmVjZXB0aW9u
IG9mIEhQQiBPcCBjb2RlDQo+ID4+Pj4+Pj4gMHgyLA0KPiA+Pj4+Pj4+IHNpbmNlIGl0DQo+ID4+
Pj4+Pj4gaXMgbm90IGNsZWFyZWQgZGVmaW5lZCBpbiBIUEIyLjAgc3BlY3MuDQo+ID4+Pj4+Pj4N
Cj4gPj4+Pj4+PiBDYW4gR3VvLg0KPiA+Pj4+Pj4NCj4gPj4+Pj4+IEkgdGhpbmsgdGhlIHF1ZXN0
aW9uIHNob3VsZCBiZSBhc2tlZCBpbiB0aGUgSFBCMi4wIHBhdGNoLCBzaW5jZSBpbg0KPiA+Pj4+
Pj4gSFBCMS4wIGRldmljZQ0KPiA+Pj4+Pj4gY29udHJvbCBtb2RlLCBhIEhQQiByZXNldCBpbiBk
ZXZpY2Ugc2lkZSBkb2VzIG5vdCBpbXBhY3QgYW55dGhpbmcNCj4gPj4+Pj4+IGluDQo+ID4+Pj4+
PiBob3N0IHNpZGUgLQ0KPiA+Pj4+Pj4gaG9zdCBpcyBub3Qgd3JpdGluZyBiYWNrIGFueSBIUEIg
ZW50cmllcyB0byBkZXZpY2UgYW55d2F5cyBhbmQgSFBCDQo+ID4+Pj4+PiBSZWFkDQo+ID4+Pj4+
PiBjbWQgd2l0aA0KPiA+Pj4+Pj4gaW52YWxpZCBIUEIgZW50cmllcyBzaGFsbCBiZSB0cmVhdGVk
IGFzIG5vcm1hbCBSZWFkKDEwKSBjbWQNCj4gPj4+Pj4+IHdpdGhvdXQNCj4gPj4+Pj4+IGFueQ0K
PiA+Pj4+Pj4gcHJvYmxlbXMuDQo+ID4+Pj4+DQo+ID4+Pj4+IFllcywgVUZTIGRldmljZSB3aWxs
IHByb2Nlc3MgcmVhZCBjb21tYW5kIGV2ZW4gdGhlIEhQQiBlbnRyaWVzIGFyZQ0KPiA+Pj4+PiB2
YWxpZCBvcg0KPiA+Pj4+PiBub3QuIFNvIGl0IGlzIHdhcm5pbmcgYWJvdXQgcmVhZCBwZXJmb3Jt
YW5jZSBkcm9wIGJ5IGRldiByZXNldC4NCj4gPj4+Pg0KPiA+Pj4+IFllYWgsIGJ1dCBzdGlsbCBJ
IGFtIDEwMCUgc3VyZSBhYm91dCB3aGF0IHNob3VsZCBob3N0IGRvIGluIGNhc2Ugb2YNCj4gPj4+
PiBIUEIyLjANCj4gPj4+PiB3aGVuIGl0IHJlY2VpdmVzIEhQQiBPcCBjb2RlIDB4MiwgSSBhbSB3
YWl0aW5nIGZvciBmZWVkYmFja3MuDQo+ID4+Pg0KPiA+Pj4gSSB0aGluayB0aGUgaG9zdCBoYXMg
dHdvIGNob2ljZXMgd2hlbiBpdCByZWNlaXZlcyAweDIuDQo+ID4+PiBPbmUgaXMgbm90aGluZyBv
biBob3N0Lg0KPiA+Pj4gVGhlIG90aGVyIGlzIGRpc2NhcmRpbmcgYWxsIEhQQiBlbnRyaWVzIGlu
IHRoZSBob3N0Lg0KPiA+Pj4NCj4gPj4+IEluIHRoZSBKRURFQyBIUEIgc3BlYywgaXQgYXMgZm9s
bG93czoNCj4gPj4+IFdoZW4gdGhlIGRldmljZSBpcyBwb3dlcmVkIG9mZiBieSB0aGUgaG9zdCwg
dGhlIGRldmljZSBtYXkgcmVzdG9yZQ0KPiA+Pj4gTDJQDQo+ID4+PiBtYXANCj4gPj4+IGRhdGEg
dXBvbiBwb3dlciB1cCBvciBidWlsZCBmcm9tIHRoZSBob3N04oCZcyBIUEIgUkVBRCBjb21tYW5k
Lg0KPiA+Pj4NCj4gPj4+IElmIHNvbWUgVUZTIGJ1aWxkcyBMMlAgbWFwIGRhdGEgZnJvbSB0aGUg
aG9zdCdzIEhQQiBSRUFEIGNvbW1hbmRzLCB3ZQ0KPiA+Pj4gZG9uJ3QNCj4gPj4+IGhhdmUgdG8g
ZGlzY2FyZCBIUEIgZW50cmllcyBpbiB0aGUgaG9zdC4NCj4gPj4+DQo+ID4+PiBTbyBJIHRoaW5r
cyB0aGVyZSBpcyBub3RoaW5nIHRvIGRvIHdoZW4gaXQgcmVjZWl2ZXMgMHgyLg0KPiA+Pg0KPiA+
PiBCdXQgaW4gSFBCMi4wLCBpZiB3ZSBkbyBub3RoaW5nIHRvIGFjdGl2ZSByZWdpb25zIGluIGhv
c3Qgc2lkZSwgaG9zdA0KPiA+PiBjYW4NCj4gPj4gd3JpdGUNCj4gPj4gSFBCIGVudHJpZXMgKHdo
aWNoIGhvc3QgdGhpbmtzIHZhbGlkLCBidXQgYWN0dWFsbHkgaW52YWxpZCBpbiBkZXZpY2UNCj4g
Pj4gc2lkZSBzaW5jZQ0KPiA+PiByZXNldCBoYXBwZW5lZCkgYmFjayB0byBkZXZpY2UgdGhyb3Vn
aCBIUEIgV3JpdGUgQnVmZmVyIGNtZHMgKEJVRkZFUg0KPiA+PiBJRA0KPiA+PiA9IDB4MikuDQo+
ID4+IE15IHF1ZXN0aW9uIGlzIHRoYXQgYXJlIGFsbCBVRlNzIE9LIHdpdGggdGhpcz8NCj4gPg0K
PiA+IFllcywgaXQgbXVzdCBiZSBPSy4NCj4gPg0KPiA+IFBsZWFzZSByZWZlciB0aGUgZm9sbG93
aW5nIHRoZSBIUEIgMi4wIHNwZWM6DQo+ID4NCj4gPiBJZiB0aGUgSFBCIEVudHJpZXMgc2VudCBi
eSBIUEIgV1JJVEUgQlVGRkVSIGFyZSByZW1vdmVkIGJ5IHRoZSBkZXZpY2UsDQo+ID4gZm9yIGV4
YW1wbGUsIGJlY2F1c2UgdGhleSBhcmUgbm90IGNvbnN1bWVkIGZvciBhIGxvbmcgZW5vdWdoIHBl
cmlvZCBvZg0KPiA+IHRpbWUsDQo+ID4gdGhlbiB0aGUgSFBCIFJFQUQgY29tbWFuZCBmb3IgdGhl
IHJlbW92ZWQgSFBCIGVudHJpZXMgc2hhbGwgYmUgaGFuZGxlZA0KPiA+IGFzIGENCj4gPiBub3Jt
YWwgUkVBRCBjb21tYW5kLg0KPiA+DQo+IA0KPiBObywgaXQgaXMgdGFsa2luZyBhYm91dCB0aGUg
c3Vic2VxdWVudCBIUEIgUkVBRCBjbWQgc2VudCBhZnRlciBhIEhQQg0KPiBXUklURSBCVUZGRVIg
Y21kLA0KPiBidXQgbm90IHRoZSBIUEIgV1JJVEUgQlVGRkVSIGNtZCBpdHNlbGYuLi4NCkxvb2tz
IGxpa2UgdGhpcyBkaXNjdXNzaW9uIGlzIGdvaW5nIHRoZSBzYW1lIHdheSBhcyB3ZSBoYWQgaW4g
aG9zdCBtb2RlLg0KSFBCLVdSSVRFLUJVRkZFUiAweDIsIGlmIGV4aXN0LCAgaXMgYWx3YXlzIGEg
Y29tcGFuaW9uIHRvIEhQQi1SRUFELg0KWW91IHNob3VsZG4ndCBjb25zaWRlciB0aGVtIHNlcGFy
YXRlbHkuDQoNClRoZSBkZXZpY2UgaXMgZXhwZWN0ZWQgdG8gaGFuZGxlIGludmFsaWQgcHBuIGJ5
IGl0c2VsZiwgYW5kIHNwZWNpZmljYWxseSBmb3IgdGhpcyBjYXNlLA0KQXMgRGFlanVuIGV4cGxh
aW5lZCwgSGFuZGxlIGVhY2ggSFBCLVJFQUQgKGFuZCBpdHMgY29tcGFuaW9uIEhQQi1XUklURS1C
VUZGRVIpIGxpa2UgUkVBRDEwLg0KDQpGb3IgZGV2aWNlIG1vZGUsIGRvaW5nIG5vdGhpbmcgaW4g
Y2FzZSBvZiBkZXYgcmVzZXQsIHNlZW1zIHRvIG1lIGxpa2UgdGhlIHJpZ2h0IHRoaW5nIHRvIGRv
Lg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gQ2FuIEd1by4NCj4gDQo+ID4g
VGhhbmtzLA0KPiA+IERhZWp1bg0KPiA+DQo+ID4+IFRoYW5rcywNCj4gPj4gQ2FuIEd1by4NCj4g
Pj4NCj4gPj4+DQo+ID4+PiBUaGFua3MsDQo+ID4+PiBEYWVqdW4NCj4gPj4+DQo+ID4+Pj4gVGhh
bmtzLA0KPiA+Pj4+IENhbiBHdW8uDQo+ID4+Pj4NCj4gPj4+Pj4NCj4gPj4+Pj4gVGhhbmtzLA0K
PiA+Pj4+PiBEYWVqdW4NCj4gPj4+Pj4NCj4gPj4+Pj4+IFBsZWFzZSBjb3JyZWN0IG1lIGlmIEkg
YW0gd3JvbmcuDQo+ID4+Pj4+DQo+ID4+Pj4+DQo+ID4+Pj4+DQo+ID4+Pj4+PiBUaGFua3MsDQo+
ID4+Pj4+PiBDYW4gR3VvLg0KPiA+Pj4+Pj4NCj4gPj4+Pj4+DQo+ID4+Pj4+Pg0KPiA+Pj4+DQo+
ID4+Pj4NCj4gPj4+Pg0KPiA+Pg0KPiA+Pg0KPiA+Pg0K
