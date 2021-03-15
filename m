Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB6AC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 09:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BD564E6B
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 09:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCOJXN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 05:23:13 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37140 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhCOJXB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 05:23:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615800181; x=1647336181;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kyY0np0vcNYmeeeqyXiZ8cf2590jjcdzocVUdxQT9nM=;
  b=nGKhkIxuM56jM4I4Tlhl7wJBeZwzgmsAhLvqTJ0LaMGXkoroP3L6z7ze
   QzSxrGGr/YE//r47zMpi+68mVIu8Hv1blHeJ8+RFhulgsXUAzK2J5K0ss
   mP//IW6+7fLY1/b43rx+JUXXa8YTKPsZ0kGqRt1GOiBl4s4u1OxSBf+rH
   ew2uwQrpkrahTbfs1ZKQZYsdZinV0jJsAlfky646LOFXFD5SkTIwcb6dJ
   k3sKH+DYRAh+VJMKN92Eb5FHLeDx6DXyvJcp+zFstwGZMHzZ83aA4/ax9
   paWJFSa94GQlXn1fbPm3btWDwUihCJLreBwXIOg8xCvU+BomMP3SxNyDQ
   w==;
IronPort-SDR: GGSkq6tkZV1GREnKSSlbJRnUM4zWzxI/iG7fIa1EKHIt9u4KWc8MRJqJxlbNTXRzVmTw0ePAol
 LwEldldxIxNWbNPaYssp/EbZ6KM111daWf/WoEFlvLK46GVYaHSpuN6tWMwK2I/m7Ty4Ny3mJ6
 Dsl/3GQMfkW3cXDS7fyQ2GtVm+Ut4ogxtL1mHPG5bjzEdmsJ8nUKJ7ovBaTJsLsNQj8IHQ5m85
 KWCB38RloICBeCeJGsT9XCtWjAn0OHHK2+VN/i6OFPTChc1YYRcD3i/QvsKoC+BfbYx2xtFT9p
 SQE=
X-IronPort-AV: E=Sophos;i="5.81,249,1610380800"; 
   d="scan'208";a="166647626"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 15 Mar 2021 17:23:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiT+81GEx+sCUsE72FHe0EMNbS9NScSN/FccaTaeyOBzqzbbpPxzkV129hbfEFEmTf9Y87CGACMKwGqBMwYRse1OwHJMo/sQtaV9bsxQQC2Unrf0GiIl6Px+yxZFzuT6Y8CgXLsgW2DSsBxv6q8oyE6i7nUwGYchiy5Vuxe379jdAuGRoR11tweF92nJ41pU/YMOTk/L6me81rR4Tw36My4depim7533Nlwx7MZIbgOF/g46z84jqylY8Q4WaIek6qWHAxzzYLrbYEg/ZCdyvk/BB1YazznYDwsxpxaguiDWLTzyZoE3mz7WvbZSo9yVv+lyvHWwOnKJZ3+9kbPhCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyY0np0vcNYmeeeqyXiZ8cf2590jjcdzocVUdxQT9nM=;
 b=Otamw1uboOkoBSpMPOBGGjrATx8SYIoUZtAULtf28mDbosHvjMBxkq0SE7oBWKSYk6PpXrCEcwne1UykRxYZ3gWCerfsQS+5BjGaTd6LVRwlwRoQxD4rKEjiQazSGhcKbBKH6LWuEQHc3eu3fXOHNKdnts7wS/qQXM4o7lPyk2/sNJtG+L5QOmKw1wnzKil9LEdLWawOw+CUuqlvPWk/Z8PGpw+X5CXdocyWvJvsz/bg23xcSghsP+6TR04gu3QdZG6ww6kZdPszbSeFJG6hJB3Rd81LFMhW0WpXnLgm/7uXadiulEBHrkZ94/dNaU6iJdmRF+MLyp529f/P1eiVJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyY0np0vcNYmeeeqyXiZ8cf2590jjcdzocVUdxQT9nM=;
 b=cDySMZKJTR6afLGxFTcWckm9j0AGWsXfcAxwRUNuyFgl1WqFd4Lxh4D5nkxu/FQcyl3y03HptbOTf6d4ozn37g0BBiqXY0PhHE4ByWYBDRtNpammI4st/7RkmNuXvObwP4xfR+RotDJ++1IbwBey/D09pRXn/LspvUmnMiZ+GHY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7003.namprd04.prod.outlook.com (2603:10b6:5:1::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Mon, 15 Mar 2021 09:22:57 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 09:22:57 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v5 03/10] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH v5 03/10] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHXD2ei7j8moNyDbkOuTIbGJCHBHqqEzvaAgAALDxA=
Date:   Mon, 15 Mar 2021 09:22:57 +0000
Message-ID: <DM6PR04MB65750172036ADE7BCBAB8D8EFC6C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-4-avri.altman@wdc.com>
 <1d5380f5d1395b5733a68b902d60c24a@codeaurora.org>
In-Reply-To: <1d5380f5d1395b5733a68b902d60c24a@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7c100549-5839-4c44-fdfc-08d8e793ebc0
x-ms-traffictypediagnostic: DM6PR04MB7003:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB7003C8EED4A41669FB9E7E12FC6C9@DM6PR04MB7003.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:411;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8dfbpd4pqMEt3olO5eJOzJqqcKC3GNXRvJ2cRbbQY7zBWgMCKJOmIWheymN6lUs0UuKI/iNnLrIs+5Dx1WcOkOedYrDmtfCfdMtTDdCqO3+I/wajIcCMw1GX6OqHIpqlF9tBGcDUnxhu6rL486z2YZ7Pys3FUmm1K024AqOPp7plHCOb6oGXsapoteoSTsYrzrFw4Ax1xgCVWUG+xNy/7+BESgoi9d1bBa32gYV55k1l+nWeTlNWyylswvaDQBFYfgaXjG3V/kvsSQC4sKN/qTmgW3kv2wu94F9GgOlzvJnYRTvkfBuEGKkX+UKidgEVuzgICDTn00LcrnZ2vIPkTvck/5cm852rynpR1auVsXF92tr+1xY2jkZIj/hN3s6wb7bcMj6HO4zT4Sl+AvhaS0/ad+iAc3O8egNbk2mgtMCWxZr08409P72nxcZf9xprlyYZGM1YgOjjWoTTBbLZwW+4u0azBpzxDFRwxK4/xfWJRJ1MCzHbV8mtahhVaINgqywmeHkvd/kKqQs976L3wezertQBI8L2e+QajRWC+6hJgyxG0d6/r34E06NKGLDW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(8936002)(33656002)(54906003)(7416002)(2906002)(6916009)(26005)(83380400001)(478600001)(66946007)(316002)(76116006)(5660300002)(7696005)(66556008)(71200400001)(64756008)(52536014)(6506007)(86362001)(186003)(8676002)(66476007)(66446008)(9686003)(55016002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Tk9YYjk3VkUraHROUnFKMS9FWGJ5RmhJOXZOUFp5VzNNaHI1VjZNZ3FnYlZu?=
 =?utf-8?B?Wm1EdFZyV0ZKemQyNHNzcGZmYWJoQ1FGNjZ4S1UxUnFhVmFxV3F3MTlyNGRi?=
 =?utf-8?B?Y0FGWXl0MkhDSlo2UHVqcVgzUFd3Q0hkd0J6ZWNXWEUwdTJKd0NucGhEYU5K?=
 =?utf-8?B?ZnZraEZyYUtXNXNmdnhrVm81TE16T211M2k0WGZXOFdlWlNRUDArUWk3U3pv?=
 =?utf-8?B?VG9Kam1oUndiR0hYMEVPKy9Wb3ByTURVSWRpVVZ4am5MRTM3WDZSVVd2SHVx?=
 =?utf-8?B?ZzU4d08waW5xYUNXZjF2N3FscGlicEpLNEs3ellGb2VYS1NDdnQ1dGxqNS91?=
 =?utf-8?B?akZKalRzRVlORUxSc1hlVWE3bFE2Z0lMUkpoVGhKb1VIemVuSituOTNZZ0tu?=
 =?utf-8?B?Z1VYM0NieEtDbjdZcC9kL2NRelg5cFh2Y2Fzc0J1VWNMR0RQMld6MW9qektC?=
 =?utf-8?B?dlBab05yNkYwaGtGc29XWUFVVTV3OTNvOHpnZ3NCaVBQYlZQZWx3YWEwTFk4?=
 =?utf-8?B?UFdCa1J5WllwNUFOUjB1QzBYOHVGQjVQaXBlV1VTZHZlbThWUklBU0NTQXZJ?=
 =?utf-8?B?T3k2WldzWmVlZkFWRlNoc1c5bkh5QUEwQjRGWDdJc3VwWFBzQ3E1a3k2K1RL?=
 =?utf-8?B?QTgvNFNJeFlkTkhGdDdRdW5Hd1dUYW9CU3N1Q2dKZ1dRMmdyOXFZaVBWS2wv?=
 =?utf-8?B?bmwzUU1mcHMwSDNGbXBOSGdmcFZSUFREa3kvYnY5UnBPS1huVyswSUs5aStj?=
 =?utf-8?B?cjNMbTNXYTM4bjdwam5MT2NEbDZQakpHZnhJSXFlL0ZzU1A1VHBaVXhydzBI?=
 =?utf-8?B?MkdMU2xQOXMrNk5LaEtNRUNwLytYc1F0Yk9UUUVYMW44a3RTbmRGTHFvVlAr?=
 =?utf-8?B?VUtqdGM4UStSZmRMaDRvTjlKT3NQOHZTNG1sbVlpRmE1eCtxc2ovNnZEZ0hj?=
 =?utf-8?B?WGRzdXh0N2ZKSE1ZYVFhanFmRXBKdlhDOWRVa0xNZDFLZ3h4blBzbE5NMTl6?=
 =?utf-8?B?L2Y1bDV1ZFhSNGN6SDBzREJLU0NuR2E5L1BGYWplamJCZEtjWk9NYk0zVzBJ?=
 =?utf-8?B?VnN3UU5MTGovSlBaMkdUTDgrK2lEaGlMbCtIcEFzb0RyMHpTOHVvLzNoYTE2?=
 =?utf-8?B?Ry8zZjNBT0d1RTl2RHJmejlEa1lWYmJSN0thNFJocmFFbmNhKzhHNUxLc3JB?=
 =?utf-8?B?S3NmSkZuNXNKTzAvY1UvM090MGNsSHF1K0g1UGM5QTVJTFVuR1g0Zytlb0Nz?=
 =?utf-8?B?NTlGNnk4WTd5d2p3dEVVN0NsSTlVN0YrazVNNFl3V3ZNK1Q3SDN1QUY3N015?=
 =?utf-8?B?dmpEdTdpNzJDZkhkWUovNjRuZ1NPT1hzNDYxUG9XcVhzNEVsUmIvSUVIVHJi?=
 =?utf-8?B?V3NvcDZxRjc1MTQ3RzN4N1BpRVAvVUoySUx6ODZZYUsxVnVwTHlJMXowNUhQ?=
 =?utf-8?B?RlQzQ3pnMm9GRWR6d0JlRVovRkFmRklzVkVoQys1TjNYaUhIdmVxQm1WeU1t?=
 =?utf-8?B?MGtaQVQ2STg5NnZNdlFCZk1hT3E5cmc5eGMyTjJIdjZ2dERtcCsrUjdkRXFJ?=
 =?utf-8?B?QWZqb1N1UDFZWnQydHV4WmpqN2lPcU44ZXdvRmdLTU9MQmhxZWk3RjRiS3BB?=
 =?utf-8?B?VXk2WDRpVHptVXZIMWJ5ZjNLRUJYanBaOVJZN2RNWjlrVnlEYmZnZ3ZFb1JX?=
 =?utf-8?B?TWdnaU53b2s0YVVkWTlmYXpDUXVtT1NORE9MQU04T0pOaUpGNHgwWVBEWS9m?=
 =?utf-8?Q?MsfMNxSeVh6754oTrMT78GPu+afYaEirzMnLZUD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c100549-5839-4c44-fdfc-08d8e793ebc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 09:22:57.3003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CBVOAr2z0lPrDmHP5cEE1/eeuI/pnwmYpCFBTWE1CfqzAwVp8ZT+PEgwchBu+GNPV/OZRHAZizHi2z/FO4LlKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7003
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ICsgICAgICAgICAgICAgLyogaWYgcmVnaW9uIGlzIGFjdGl2ZSBidXQgaGFzIG5vIHJlYWRz
IC0gaW5hY3RpdmF0ZSBpdCAqLw0KPiA+ICsgICAgICAgICAgICAgc3Bpbl9sb2NrKCZocGItPnJz
cF9saXN0X2xvY2spOw0KPiA+ICsgICAgICAgICAgICAgdWZzaHBiX3VwZGF0ZV9pbmFjdGl2ZV9p
bmZvKGhwYiwgcmduLT5yZ25faWR4KTsNCj4gDQo+IE1pc3MgYSBocGItPnN0YXRzLnJiX2luYWN0
aXZlX2NudCsrIGhlcmU/DQpUaGFua3MuDQpBbHNvIG5vdGljZWQgdGhhdCBzaW5jZSByYl9pbmFj
dGl2ZV9jbnQgYW5kIHJiX2FjdGl2ZV9jbnQgYXJlIGluY3JlbWVudGVkIG5vdyBpbiBtb3JlIHRo
YW4gb25lIHBsYWNlIC0gDQpOZWVkIHRvIHByb3RlY3QgdGhhdC4NCg0KVGhhbmtzLA0KQXZyaQ0K
DQo+IA0KPiBUaGFua3MsDQo+IENhbiBHdW8uDQo+IA0KPiA+ICsgICAgICAgICAgICAgc3Bpbl91
bmxvY2soJmhwYi0+cnNwX2xpc3RfbG9jayk7DQo+ID4gKyAgICAgfQ0KPiA+ICt9DQo+ID4gKw0K
PiA+ICBzdGF0aWMgdm9pZCB1ZnNocGJfbWFwX3dvcmtfaGFuZGxlcihzdHJ1Y3Qgd29ya19zdHJ1
Y3QgKndvcmspDQo+ID4gIHsNCj4gPiAgICAgICBzdHJ1Y3QgdWZzaHBiX2x1ICpocGIgPSBjb250
YWluZXJfb2Yod29yaywgc3RydWN0IHVmc2hwYl9sdSwNCj4gPiBtYXBfd29yayk7DQo+ID4gQEAg
LTE5MTMsNiArMTk4MCw5IEBAIHN0YXRpYyBpbnQgdWZzaHBiX2x1X2hwYl9pbml0KHN0cnVjdCB1
ZnNfaGJhDQo+ID4gKmhiYSwgc3RydWN0IHVmc2hwYl9sdSAqaHBiKQ0KPiA+ICAgICAgIElOSVRf
TElTVF9IRUFEKCZocGItPmxpc3RfaHBiX2x1KTsNCj4gPg0KPiA+ICAgICAgIElOSVRfV09SSygm
aHBiLT5tYXBfd29yaywgdWZzaHBiX21hcF93b3JrX2hhbmRsZXIpOw0KPiA+ICsgICAgIGlmICho
cGItPmlzX2hjbSkNCj4gPiArICAgICAgICAgICAgIElOSVRfV09SSygmaHBiLT51ZnNocGJfbm9y
bWFsaXphdGlvbl93b3JrLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHVmc2hwYl9ub3Jt
YWxpemF0aW9uX3dvcmtfaGFuZGxlcik7DQo+ID4NCj4gPiAgICAgICBocGItPm1hcF9yZXFfY2Fj
aGUgPSBrbWVtX2NhY2hlX2NyZWF0ZSgidWZzaHBiX3JlcV9jYWNoZSIsDQo+ID4gICAgICAgICAg
ICAgICAgICAgICAgICAgc2l6ZW9mKHN0cnVjdCB1ZnNocGJfcmVxKSwgMCwgMCwgTlVMTCk7DQo+
ID4gQEAgLTIwMTIsNiArMjA4Miw4IEBAIHN0YXRpYyB2b2lkIHVmc2hwYl9kaXNjYXJkX3JzcF9s
aXN0cyhzdHJ1Y3QNCj4gPiB1ZnNocGJfbHUgKmhwYikNCj4gPg0KPiA+ICBzdGF0aWMgdm9pZCB1
ZnNocGJfY2FuY2VsX2pvYnMoc3RydWN0IHVmc2hwYl9sdSAqaHBiKQ0KPiA+ICB7DQo+ID4gKyAg
ICAgaWYgKGhwYi0+aXNfaGNtKQ0KPiA+ICsgICAgICAgICAgICAgY2FuY2VsX3dvcmtfc3luYygm
aHBiLT51ZnNocGJfbm9ybWFsaXphdGlvbl93b3JrKTsNCj4gPiAgICAgICBjYW5jZWxfd29ya19z
eW5jKCZocGItPm1hcF93b3JrKTsNCj4gPiAgfQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc2NzaS91ZnMvdWZzaHBiLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5oDQo+ID4gaW5k
ZXggODExOWIxYTNkMWU1Li5iZDQzMDgwMTA0NjYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNocGIuaA0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmgNCj4g
PiBAQCAtMTIxLDYgKzEyMSwxMCBAQCBzdHJ1Y3QgdWZzaHBiX3JlZ2lvbiB7DQo+ID4gICAgICAg
c3RydWN0IGxpc3RfaGVhZCBsaXN0X2xydV9yZ247DQo+ID4gICAgICAgdW5zaWduZWQgbG9uZyBy
Z25fZmxhZ3M7DQo+ID4gICNkZWZpbmUgUkdOX0ZMQUdfRElSVFkgMA0KPiA+ICsNCj4gPiArICAg
ICAvKiByZWdpb24gcmVhZHMgLSBmb3IgaG9zdCBtb2RlICovDQo+ID4gKyAgICAgc3BpbmxvY2tf
dCByZ25fbG9jazsNCj4gPiArICAgICB1bnNpZ25lZCBpbnQgcmVhZHM7DQo+ID4gIH07DQo+ID4N
Cj4gPiAgI2RlZmluZSBmb3JfZWFjaF9zdWJfcmVnaW9uKHJnbiwgaSwgc3JnbikgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXA0KPiA+IEBAIC0yMTEsNiArMjE1LDcgQEAgc3RydWN0IHVmc2hw
Yl9sdSB7DQo+ID4NCj4gPiAgICAgICAvKiBmb3Igc2VsZWN0aW5nIHZpY3RpbSAqLw0KPiA+ICAg
ICAgIHN0cnVjdCB2aWN0aW1fc2VsZWN0X2luZm8gbHJ1X2luZm87DQo+ID4gKyAgICAgc3RydWN0
IHdvcmtfc3RydWN0IHVmc2hwYl9ub3JtYWxpemF0aW9uX3dvcms7DQo+ID4NCj4gPiAgICAgICAv
KiBwaW5uZWQgcmVnaW9uIGluZm9ybWF0aW9uICovDQo+ID4gICAgICAgdTMyIGx1X3Bpbm5lZF9z
dGFydDsNCg==
