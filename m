Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D379C77B61
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Apr 2023 10:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjDXKOr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Apr 2023 06:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjDXKOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2023 06:14:45 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170123C35
        for <linux-scsi@vger.kernel.org>; Mon, 24 Apr 2023 03:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1682331270; x=1713867270;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=S/skN/O+QBum8fZm70nD4KyoA5Sy9mWiGUvnct2dUa8=;
  b=D7JjQJYi+E1+JhGaAqNpSV8rWi1qiIqc4zdMg3DSJvDwcKYCl/Buu/0s
   uX/NrWK55gNsj2DHYcGKTfHJnA5sgpwpA0q73zmBN+izehWkFynH+GJ6o
   sEMccpVvXt07ZeKnOMF5Do73e5CuK+eEUvMYhPJp4pGMslFiJJcLnIR73
   4RNIANC05H4FkueVy5Ilnn1xQCCez7cOSxc66pGtyzjA1i8WwauEyJdz+
   cI8HL75b6HBxxfUIu8RdxgzIYlaeydNN7erNpjvxvdjgBLDOeJP0p9To1
   D0u82rXF3YISaRbd68tTRAQAGbn9p5HjujJwqEFTBBmY/7g8cx0vvLTYc
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677513600"; 
   d="scan'208";a="229196104"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2023 18:14:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngy6NbRJsHxB7v5Qv1Dh2tUA+OnUPgrMDM2bKZVoxlI+Hk5Hrph9NtHHM0Ot5gNOqaeH7KuGHHHwR5ElxB8Qps1c8I0i8BRxfW9+21DUTQ94R5PMOfPWA3+L/mdR2OXFFgzb/s6u2znc614cQD4o3gv+1W+GW4gz5iSxhTMnnE2Re4SJZXvT8bSuIf4+bGIZFueMRVA+XB5EIWtEHJvi79kHqDBy4pZO9EvACQfFvJ05vBsJvavKPppz4sbhV0RVu5hHeiOjCFb/maZn+xhfFeaa1NfTmEbSKeBZH8etpK9QYDklYhcJbwfdN+KBtWmKLOhsilaJAcFrZT8SMu76/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/skN/O+QBum8fZm70nD4KyoA5Sy9mWiGUvnct2dUa8=;
 b=DTZ+F/GNm/qsxv4HTtNJG8iYiD4wxz9wqUOWs1M4Sdn267tyKsMgG7yLWWvXXyZWcbLK1xRkhpGjDKekKNMrP5lRFv50/CNPeZMVrdXpGcun80sHvWLXwV5bFX/dUTc8ll/2iNDaAbOW/cs8/hxR8QERgK0zmzES/ILYPRNrnHuUFWMzkGcQxzbYhGhp7kQ/DVZZB9lW0NtJmQAT8S7y520Pg5rR8qTohmMaAK7qKREbpCgPGOWreFUPblyahKMhgfCnV8D2+DZLSMdcgsEgCfYo+ICOWnqgJzHukPZqQ3QD+9SwX1tOKFyLMhZB6p3IWgTMpImc7ohER2ApnhHHTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/skN/O+QBum8fZm70nD4KyoA5Sy9mWiGUvnct2dUa8=;
 b=PUC5lH+QTpiWe4Fq4C/NXA4HJGxX7oeiOQJpGZkzpGZCd4+364sxInFAieg1o66XwaIzZv8zM2zrQLZNEe7S1WmhY/MBTcYkM16HR4BCKMIp7Auw648w/E+yzdpmcXdQiF7++AIs+a6iX25QRDRp6bg3mlpre/AyP4LVWZuMNRk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM8PR04MB8167.namprd04.prod.outlook.com (2603:10b6:8:2::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.33; Mon, 24 Apr 2023 10:14:24 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::188b:9005:b09b:81e2]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::188b:9005:b09b:81e2%7]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 10:14:24 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [RFC PATCH v1] ufs: poll pmc until another pa request is
 completed
Thread-Topic: [RFC PATCH v1] ufs: poll pmc until another pa request is
 completed
Thread-Index: AQHZcpB3WQVyd0N5Nk6XP0AldI1k/K84rxYAgAE++ICAABxnEIAAL0EAgAAMArA=
Date:   Mon, 24 Apr 2023 10:14:24 +0000
Message-ID: <DM6PR04MB6575D9AFF7D11BCFA2CE148FFC679@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <cpgsproxy5@samsung.com; stanley.chu@mediatek.com>
        <CGME20230419072745epcas2p47b29940fe7e50d947a29546a8e79abb9@epcas2p4.samsung.com>
        <1681888769-36587-1-git-send-email-kwmad.kim@samsung.com>
        <DM6PR04MB65758403CC6D31654A98BB43FC669@DM6PR04MB6575.namprd04.prod.outlook.com>
        <004101d97669$97c787e0$c75697a0$@samsung.com>
        <DM6PR04MB6575372C3F82509E9AE69466FC679@DM6PR04MB6575.namprd04.prod.outlook.com>
 <003501d9768f$6bd06280$43712780$@samsung.com>
In-Reply-To: <003501d9768f$6bd06280$43712780$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM8PR04MB8167:EE_
x-ms-office365-filtering-correlation-id: f635edf9-5a45-4c56-8e91-08db44acadc1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LuYfkElAwhjxf1BV8by6OWXI/v2Q/LUQ4ShK4B6ICcc0wVlOt6XqiTvlgZqYyvBsNnZFI+qn/+0rHcEklDewKx1GtopmXvSQ8+nYuul0Oh5Bw+FoUvgDsxOPnOAfVtGaM6d7qhc19M7Cl2SIpIr81rR+Sv+12K5LCi9ZHXwEqp/K1Bp9GvL92Cdbh/wNpqwdTQ4irr8NWb7bbss05ocRYjHjydnuwkieWXHaNwCR/8DkyTxWDLJyyomqqVGGx86SlEi8jdp0q8judL9/vjY2mTHH6f4Yy+6AU4x97S6HdN46JM1okd1G20qz7FdO5iL7hJAGWAiDsir5r//hzI+TWN3jgeDoX7DWCWgXTP3M2juMhL787U+MMqiC9w3hWTOcBhAN5GFguO1GJ7RzIac3TH4aQFNvuYi1O08IxgYezDD84GbkZI2GUtQEPcKMkOJj+q0HNaB1RbdvkW+sBdwX+X0DAEfpsvJ/LeRV7yHA4h+8mnzNixtmUUkKuEhgw4wF/8LJEZPQsRJUbReGPURNFz/ABYQayWXc4h9/h8/vhIzD3elsh1o7S7iGAoqnNz82a5K2ateRz5vTsOMCSs9hvcOhg80O58cc5Bhj1B+Lf3dCI/grOSVfNt6EO48gxOZP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(478600001)(66899021)(110136005)(86362001)(186003)(7696005)(26005)(9686003)(6506007)(55016003)(33656002)(71200400001)(64756008)(66446008)(66476007)(66556008)(316002)(82960400001)(83380400001)(66946007)(76116006)(2906002)(38100700002)(122000001)(41300700001)(8676002)(8936002)(38070700005)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUtDUjNWNGhtSDFuVUxGTUcxbmZQV3RvaXZTc2Z3U1pReTdEaHBKZ2JEaTgv?=
 =?utf-8?B?Y3RkMy93ODM5aGRWWVdhMlorRFBHT2F4b25lbS9vMmVNR1NoOFkxd3l4Mm5C?=
 =?utf-8?B?a0VScS9Udm1Ydzh3L3JWcHRWVFFrbEswaklvV3owcWpTbTNTSzFGVUVTZFF3?=
 =?utf-8?B?OFF4aUVnc0c5WS9Nb1NadnZBQTEyOFdmcnBBTW1GcFBqZDIvdE9FZU5wcTJS?=
 =?utf-8?B?K0dQc1JMbUpQWThoa2RuY0NDbWlMSUt1SUlsTTRhdmE0K21HOGwrc1hlWlJu?=
 =?utf-8?B?RmdBNWovRHZuRm55cEdLck5oa2JvZEVZVXBUYUZnQ3lFYis5c3RDSmxFbXYz?=
 =?utf-8?B?a0hSZGNtUUt3OXlaYVFTaUJPZUx2WXd5WENhdk9oTVZGd1Y5QU93bWhMMGtx?=
 =?utf-8?B?cjJtYnRnTFkrZVFjeHdWTC9rYVBBWFZ3emxSSE1oVG4zZFAvQWgyczVkZWpy?=
 =?utf-8?B?TkU1S2JsWHJ3V0xmU1IzelBreE82eHF3ZUZIZGZuR2MrbnZLMXRsNGxEQ0NV?=
 =?utf-8?B?NnFwbnRpcTZYR2FRSlNrYnoxSzFjeE5iWTdMSmNDZEJoMVVlY0RxYnpESW9K?=
 =?utf-8?B?dlNhQzQ1LzhNeXpucTB4TmtHZ0JPaURKMEdjS0pFblJrc1hQQnAyTlVCYlp5?=
 =?utf-8?B?RDVhRFI4SDRmYjhEdW9vRHdZMmo2N1BScmZNdWNIZjhOTUhCZmxOM0Y0NlhV?=
 =?utf-8?B?bDZ0L3JUTlZiVkQ5RWUzd1FOWHJLck9VY0hyeHhxTWZHTGJCbCt0SFcxTmNq?=
 =?utf-8?B?NHBhRGJleGJpcDdzS0pYTmkzdDBwaFhNVUxmYTRkcnUvM21XcXd0TXVUWUJu?=
 =?utf-8?B?MmRvaGtZQ3hIQzcxZ0pwbGg4U2dlMFhocmdITkdkdGxrc2pUTjdDTjY5QzRN?=
 =?utf-8?B?YS9hTVNjaXdOdUtKWFMxd3RNWXoxTHhQcDc1SHo4aGNhMjQ0WTRGbFpiU2ZW?=
 =?utf-8?B?alljNXY0MjB4cXJNdkpJSWJFSi9pNG04OFptZUJJZ2Vlb2doMWRHL1k3OEgx?=
 =?utf-8?B?TG5vVVJ6dVh4UGdIT3pTRERPMWtJclZ6dmtVWC94R1M0Nm5CVjl1RVd5Nzdp?=
 =?utf-8?B?RDJwSEVpWUY4UlZxaU9OYy9lNGI3cER2dmFtRU52MHJMREhWNk1jNTVNT29M?=
 =?utf-8?B?K3pmTFp1NmNkT3VZVTNPVjRQK0ZqenUrcjE4YklQK1p6bWtNSXdPVEFVSk5P?=
 =?utf-8?B?bTBSK05YYUF6ZVJ4dHIyWTJXdXU5TlpuSGF4V3lzVWpOdDNUNnFNMWFlZjhz?=
 =?utf-8?B?VTE1L3p1YmNwYlBjMXhTNit0UjJQcTN0NCtHeGZXU2oxbHdPMFUyMUxFSXFW?=
 =?utf-8?B?aVNkcWlQUGlmdk1VNVdIQU1SZU5RZFhmVFEwbis1T2xZejhFVHY0ZWRJeHpG?=
 =?utf-8?B?K3ZhWTkvREFZak00NmFMay9Kc25iRHlEQTJtNUpHcktEZ0g2N3oxaGx0NEZI?=
 =?utf-8?B?Zld3dkRZaEtQQUhwM0kvRUt5RDdsM3RkZWlvRStURHFtc1BDaENJVm8wcFd1?=
 =?utf-8?B?VG5qVVYwSVk2TzVRUXBLL0I4NjhaQkNTSVNmWVJSMTM5Y09zRy9hTDlnVGFx?=
 =?utf-8?B?bkxENXB3R2lTdEdRSHF5SkpnWWJxSXRGMFZ4VzdreThUQjhwOExIenpQckxx?=
 =?utf-8?B?VS84elF3c0Fqa3lxQ1Z4MGE4d2VzQUtjeGcvWjNoR1N5RndSOERxZmpUN1p3?=
 =?utf-8?B?cDNuZkQrVVdyL2k5S29Tb0ZkYUkySCtyUlpOb1RIM3hzV1VwdUNWZGZWZVBY?=
 =?utf-8?B?L2laWU9ES1N3VkRpQjJENldIcFh3SWFjVXZUSWNMMy9jcFhNVUROM3F2d1pn?=
 =?utf-8?B?RG5pTUZpbGFLdVpIZmJSRS9yRGtkOWw0Mzg1bnRsQnY2RTVVd0p2T05yTFFE?=
 =?utf-8?B?OVhkNVZCWWpkU0thV1FvM05tdk0xVXYrSldVWUNnaCtXcmpFcklESGs1ZS9y?=
 =?utf-8?B?bFlQNEtpdjNJcGJONG9QTStLWCt5cnFLTXV2NGxDZDNRSStsTllKSHMxMnIz?=
 =?utf-8?B?cUVUU2tXdUlDUU51dUdQUjJxc3VGWXZaVjBuODdLVkF5OVZrS2pJbnpVeTlW?=
 =?utf-8?B?aG5iMHA2Ym05WDUzSTdKcW05NHEybzlTajVNdTc3V24vaUJVYUJtc09KTURI?=
 =?utf-8?Q?XiG8CfBsabKIXtT017iFFYIPE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: p3IyBWb3uUEIBAzGOhmeI4H1V/k0Np4b9kRAtaWyTHwymuSIG86+kPLLKYEh+AtpeTkKbOtZWYtEsAcDRo9gBKVfvkFuEjFgDeHmkUAZ4EE4KxQgfau3HAymQ7wFfs6rzHVb6ksayUNmCIKwMrJlrNLv4bVQlQsTudDhGppuVm2ygPVHUi5EGCAILRCDbBy8htUtJNx2nZjicySW5HO2/mXdmTDzQT3CStRIjVU5sW1/l9bYE/3ScFCgbx6K8ZlESCnB/nFzoBtEqD69HR0WrZBNks2dYrKRaDW1z1yk+lH/rqJb5imn1aLl9GKuqOqs1N/tai9NgzDqsadf9amAKqpwkidGnrRN7508eDaQD1BRqgS5dQZzov13V2wtYh6nKh2a3WjevttlaR6M/1sIva2KwbhdIOo7bro08h9yZM7H25+bZL0bnZ52ndGSdyw7T3uUbISWnnK9rhGBJVzB7UJZlVOzsFjjpX2rL9c3ElsDb7H+5WJIz/vt/Q0yJgaQr31CoCylcW6rCq3nCakJiB/acwZ/+BClDQBpvw5LdG1GMCQibskzZ1MhI6JPrqcjjPJ1oIuPW/44fV4tYl8mfaJGrmiGmRKNlmVPsGJURLlWTysmGhB5EbGY5zpbTGiYQfLQGmSUlPDjfNefe5Ytx16/n8a/0P9BYtyiWAKRHI+1V7ylDqRJpwWz9qT0DXUbG0IQ8EavpsKb3v68BoMGR0cq/tovHfeUDDYGXjphIqKYPDGSiKTVP3DVtCrXPEJ366JV+ivSHfRTgFVpvyzHn5WddO/Rf4vAH1oA8rZiFBG4QQPbTtHYjXTn4vyAIzzb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f635edf9-5a45-4c56-8e91-08db44acadc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 10:14:24.2764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LsinYFa/pd+Lk1zdIBIvNCyDmvCKgRG+dwA/QpfSP6XPGdOnX2MZXKUtIz5lKfYvS7zt/OHm7aucs6FMV2Xe6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8167
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gPiA+IFJlZ2FyZGluZyA1LjcuMTIuMTEgaW4gVW5pcHJvIHYxLjgsIFBBIHJlamVjdHMg
c2Vic2VxdWVudCByZXF1ZXN0cw0KPiA+ID4gPiA+IGZvbGxvd2luZyB0aGUgZmlyc3QgcmVxdWVz
dCBmcm9tIHVwcGVyIGxheWVyIG9yIHJlbW90ZS4NCj4gPiA+ID4gPiBJbiB0aGlzIHNpdHVhdGlv
biwgUEEgcmVzcG9uZHMgdy8gQlVTWSBpbiBjYXNlcyB3aGVuIHRoZXkgY29tZQ0KPiA+ID4gPiA+
IGZyb20gdXBwZXIgbGF5ZXIgYW5kIGRvZXMgbm90aGluZyBmb3IgdGhlIHJlcXVlc3RzLiBTbyBI
Q0kgZG9lc24ndA0KPiA+ID4gPiA+IHJlY2VpdmUgaW5kLCBhLmsuYS4gaW5kaWNhdG9yIGZvciBp
dHMgcmVxdWVzdHMgYW5kIGFuIGludGVycnVwdCwNCj4gPiA+ID4gPiBJUy5VUE1TIGlzbid0IGdl
bmVyYXRlZC4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFdoZW4gTElORVJFU0VUIG9jY3VycywgdGhl
IGVycm9yIGhhbmRsZXIgaXNzdWVzIFBNQyB3aGljaCBpcw0KPiA+ID4gPiA+IHJlY29nbml6ZWQg
YXMgYSByZXF1ZXN0IGZvciBQQS4gSWYgYSBob3N0J3MgUEEgZ2V0cyBvciByYWlzZXMNCj4gPiA+
ID4gPiBMSU5FUkVTRVQsIGFuZCBhIHJlcXVlc3QgZm9yIFBNQywgdGhpcyBjb3VsZCBiZSBhIGNv
bmN1cnJlbnQNCj4gPiA+ID4gPiBzaXR1YXRpb24gbWVudGlvbmVkIGFib3ZlLiBBbmQgSSBmb3Vu
ZCB0aGF0IHNpdHVhdGlvbiB3LyBteQ0KPiA+ID4gZW52aXJvbm1lbnQuDQo+ID4gPiA+IENhbiB5
b3UgcGxlYXNlIGVsYWJvcmF0ZSBvbiBob3cgdGhpcyBjb25jdXJyZW5jeSBjYW4gaGFwcGVuPw0K
PiA+ID4gPiBNeSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgYm90aCBsaW5lIHJlc2V0IGluZGljYXRp
b24gYW5kIHVpYyBjb21tYW5kDQo+ID4gPiA+IGFyZSBwcm90ZWN0ZWQgYnkgaG9zdF9sb2NrPw0K
PiA+ID4NCj4gPiA+IFllcyBhbmQgb25lIHRoaW5nIEkgaGF2ZSB0byBjb3JyZWN0IG9uIHRoZSBj
bGF1c2U6IDUuNy4xMi4xMSAtPg0KPiA+ID4gNS43LjEyLjEuMQ0KPiA+ID4NCj4gPiA+IEFuZCBJ
4oCZbSB0YWxraW5nIGFib3V0IHRoZSBzaXR1YXRpb24gdy8gc29tZSByZXF1ZXN0cyB3LyBQQUNQ
Lg0KPiA+IE9LLiBUaGFua3MuDQo+ID4NCj4gPiBIb3dldmVyLCBQbGVhc2Ugbm90ZSB0aGF0IENs
YXVzZSA1LjcuMTIuMS4xICJDb25jdXJyZW5jeSBSZXNvbHV0aW9uIiBvZg0KPiA+IHRoZSB1bmlw
cm8gc3BlYywgaXMgZGVhbGluZyB3aXRoIGxvY2FsLXBlZXIgY29uY3VycmVuY3kuIE5vdCAyIGNv
bmN1cnJlbnQNCj4gPiBsb2NhbCByZXF1ZXN0cy4NCj4gPiBBcyBzdWNoLCBJIHRoaW5rIHlvdSBu
ZWVkIHRvIGV4cGxhaW4gdGhhdCB0aGlzIGlzIG5vdCBhIGhvc3QgaXNzdWUuDQo+ID4NCj4gPiBU
aGFua3MsDQo+ID4gQXZyaQ0KPiANCj4gSSB0YWxrZWQgd2l0aCB0aGUgZXhwZXJ0cyBvbiB0aGlz
IGFnYWluLiBUaGV5IHNhaWQgdGhlIHNpdHVhdGlvbiBhbHNvIGluY2x1ZGVzDQo+ICd0d28gbG9j
YWwgcmVxdWVzdHMgY2FzZScNCj4gYmVjYXVzZSB0aGV5IHNlZSAnYSBsb2NhbCByZXF1ZXN0JyBt
ZW50aW9uZWQgaW4gdGhlIHNwZWMgY291bGQgYmUgYWxzbw0KPiBQQV9JTklULnJlcSBmb3JtIHRo
ZSBsb2NhbCdzIHVwcGVyIGxheWVyLg0KPiAtLQ0KPiAiQSBsb2NhbCByZXF1ZXN0IHNoYWxsIGJl
IHJlamVjdGVkIHdoZW4gdGhlIFBBIExheWVyIGlzIHByb2Nlc3NpbmcgYSBsb2NhbA0KPiByZXF1
ZXN0IG9yIGEgcGVlciByZXF1ZXN0IDI2NzkgZnJvbSB0aGUgcGVlciBEZXZpY2UuIg0KWWVzLiBZ
b3UgYXJlIGNvcnJlY3QuDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gQ291bGQgeW91IGV4cGxh
aW4gbW9yZSB3aHkgeW91IGRvbid0IHRoaW5rIGl0J3MgdGhlIGNhc2U/DQo+IA0KPiBUaGFua3Mu
DQo+IEtpd29vbmcgS2ltDQo+IA0KDQo=
