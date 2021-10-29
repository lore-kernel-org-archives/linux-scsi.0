Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7BEC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 13:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B15F261184
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 13:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhJ2Nhu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:37:50 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:53537 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbhJ2Nht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 09:37:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635514521; x=1667050521;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kYYXgLsRSolmrEu1L5PeCy16AhMuTCfO9suwUGqDID4=;
  b=nXYTyUdhHJGRZ8izti/yaDhrSDGdsDxuDg6Galvg8iwONYazIbfpHFMX
   JRgiJlP9Fx7mengJjRFrgR0EiBy1AbyZBaR9CvXj6Gjr01+o6Vaxb9C0v
   poTZUaunNy2yUNt6CL8g2FyQtuVF0FkyHeOw0xuyEs281YeAjVTQkyvh7
   Z0MR1muUSxF6meBqj5lvB8r3A8DzX4s73GqqugVezLVyHRAsIr+oLocoo
   4BPNHu0jcgP3TB4PyWzlLVn6RTtLn4iwB9kDN3Lt4Eg07olv8OZGVOrda
   JKawm9hhmKAB6ddA5Yq39icEEUUjCWa+po02TYDqW8TiJV+MnoXcNhFOi
   A==;
X-IronPort-AV: E=Sophos;i="5.87,193,1631548800"; 
   d="scan'208";a="185123164"
Received: from mail-sn1anam02lp2044.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.44])
  by ob1.hgst.iphmx.com with ESMTP; 29 Oct 2021 21:35:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fs9xcdaEdSVrNiVUeFfUq1Y5VtZFMtqrAX4ntvQtvEyHNsQjMsSlJNjkLOMEyXWvC7OJ0aoqou2pCJru64n7hnci49C98ww+TTmx+cov1vAC/skt4w64Prrdwn2jBgrrGF5i/TrOfRG7Z2/tTnLe1brP4+v5JZW7X0fjW2oU6daz9PBRPhnrUO+plDGOUmNIx6eRZhEu1zjGeW2uZ2JqrjQROjLbuNH3ySE6QpFstQyDJNuvczL79YvazqkuSbrJ2+B2Y78baQ78zehWyLXObfU0VpgtxOoOsRLolgdIsb1maAm0dpJPO/EANLvog/73D79iyBngeoMhb4Hp2EnDeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kYYXgLsRSolmrEu1L5PeCy16AhMuTCfO9suwUGqDID4=;
 b=bGgqFgSx7qjfl9uKVrCQcXphMVp93Ke72SIMhz9aeokf5/rd9xmt/VaQm2vn3/eXkZzjnLXcFgVyr8TpUornS6XOPy8RVzy35gcb9+ubw6Gl3HOg+/X/AaI5Z67gRcN1C/J1uF0y9yORCOWuKoSpZJTOVhr8k8Ck8wiNlW8YG0y6o806I7C02Y0YJ2UUuKr8RuLqGiopBkTt/3JCwT/6K6gqULuutjCnzvajsRBhK7t+/GFFF1QwJV9ixA4Nxiv4MwBROmUbSZsZ/UwPdGxMxKbYjjY47DZhedKxxU8nM6lUdfoCOX/JkzsCuMw/sk+sDc7Kii9IRZivTKdHPH3B/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYYXgLsRSolmrEu1L5PeCy16AhMuTCfO9suwUGqDID4=;
 b=X/sfHBQc7Zil9cT6qWMZDNueE8dr2CngKoO4khBAWJbrDS3J9rlYsqXy2SQJ9+ABHpODc08ky9xiQgkh7QgW5qAqXdRcj/7IZD3czc6JMaU9sI1iNoTT4CBgJ2FscnBtG/4DLpoGNe2ETICHaukeKuCOl0R86Sj7pypfNo61vbw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7004.namprd04.prod.outlook.com (2603:10b6:5:245::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Fri, 29 Oct 2021 13:35:18 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 13:35:18 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: mark HPB support as BROKEN
Thread-Topic: [PATCH] scsi: ufs: mark HPB support as BROKEN
Thread-Index: AQHXyjjOYVeyo4bGO0aKDDaXkCtLD6vp0hSAgAAMrgCAAB+4QA==
Date:   Fri, 29 Oct 2021 13:35:18 +0000
Message-ID: <DM6PR04MB6575BF38F8A144FD7D185E8EFC879@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211026071204.1709318-1-hch@lst.de>
         <20211029105353.GA25156@lst.de>
 <a9641903818fd5e68397d9e42826640d9578c1ce.camel@HansenPartnership.com>
In-Reply-To: <a9641903818fd5e68397d9e42826640d9578c1ce.camel@HansenPartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: HansenPartnership.com; dkim=none (message not signed)
 header.d=none;HansenPartnership.com; dmarc=none action=none
 header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a22ecdb2-87d4-42c7-1dad-08d99ae0f288
x-ms-traffictypediagnostic: DM6PR04MB7004:
x-microsoft-antispam-prvs: <DM6PR04MB7004F7BB44837AFE6E7804CAFC879@DM6PR04MB7004.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dnCnqgWLGRZEieiA/stQa5/g5+Nkir37yxQJAAsvprPYWRGULl6N4WnlRX0YBSRk/wUenvZwnnKtbjDAZPXNpN6seTFk7w4XpZ0E5gje7eN39X+zx6PcQSDSmrk+t1+M9V6Y2rKfG4YnUntHFxZzoWwWUqx02aquGV+bdPFypr0bs2UdaalJNKyjkTr4dxRnTaC1M5JZyAYVV4FosC9cJ5bOlUGi0dQInUprpfOVfX4oGjhIs1yJu/rLbcb0kYDkeNmaUAvzZ+8pzU88DAX4I9H/xvFRVQceiSgfSDYdW8/ebzc/0qwhSAQ9uy2cerBT90XO/kNlCAm71gvisOk2cxlWa1IYGY+cfGI7w6mtVB5pqsRxyA9jCWClWN547ffq1fhTCth7O2ENkhiPmFm/PLT8VSQB3GY9FaOBPXy96LG8lJQNNLftWlZBiQKm7b5KTFcSLVqJSxvbuAOp47UBXafO+gozz7ApV/KRM3guwBzFqOehi/njh0AEUOwUfrlBA7Hot6PuNE4w+SYCcQSDnv8UJhtw8OshiPcIBZ/sXHY79274q/dQt/D9DFFcDDJ+UXQ6+K0Qk32oEZ8rw7SgA6BtcmL9+9bpObzn7Kywinx0Uj0z+Ous+Z0MtZIEo2mgefwy/lL76qJUp0LeBftN983YeWC/OplGvIRZFQ/2XW/CHH/D2vr7ZFV3+N3Afq6Sz01Iyc3sNOC7797CSgTwGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(64756008)(508600001)(66946007)(66556008)(66476007)(2906002)(76116006)(86362001)(8676002)(54906003)(7696005)(66446008)(82960400001)(71200400001)(52536014)(4326008)(5660300002)(55016002)(4001150100001)(38100700002)(6506007)(110136005)(9686003)(38070700005)(316002)(83380400001)(4744005)(186003)(122000001)(8936002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkN2aXk5NmFaR0tuNkFYdi9wUm5ySU1NODFRNmVjNWtVdGpJTFZxNUE0dEp5?=
 =?utf-8?B?VG1pUmJGbUtKbjFEUFZ6Snc2RWhvd2VUckJsMWIwT2VRWVg3aWt5TVhCRTZR?=
 =?utf-8?B?YVJEbERQZkljSE5NYWsvL1pWZ1k3a1lUTExnNXZHY2FqUzEvbjdjcjRpaFRL?=
 =?utf-8?B?UEE0R0F6anBiVTBnWFRmZlBIaVFYN2xUUStsVXZydU5NbEVHMDhtQnBBSDRE?=
 =?utf-8?B?TDZGa3U5SGp2RHN6LzBFRXZ6S3k2cko2YXZkeXprcFlzUGIxc0tONkZMUGZp?=
 =?utf-8?B?Z1dqdkFubWtreER4c045b0ZaU0hZK05pVDREQjYvOC8rNnhTSEpMU24veEFR?=
 =?utf-8?B?alZKZmtmbjlZN2ZJT1FJYWN3SERSR2plbzZ2OW5QUHdrS3UreVJUd3lIQ2VQ?=
 =?utf-8?B?dVh6anRGQStlZkVkR3ZiRHpsb2tYbDg3b1MyT1VBUjY3MjlnNzk1OUZ2MldE?=
 =?utf-8?B?NlpYbWM0eDB3K0dhUVA4MFY4SzhTU0gyM1ZkL1ZNMk81Mk40akViZVlCZS9L?=
 =?utf-8?B?Mmt2TzR1ZFJWRC9ITERETmtkaXA5S1dLUmVpMExKUzl4L1lnUmc4NVkxZ2V2?=
 =?utf-8?B?aUdFcEEzd3ZBcWxVR2xiSTliT0dsdTdwRWpRa09NUVBOd3ZoMjdWYkt6V3g2?=
 =?utf-8?B?UWdmcGpUTmlEUTZ3NVF6ZmhQMVhaNGZuVTlnSWR0eFBsV2drTnVsRUxNclNk?=
 =?utf-8?B?SnJoenhSVVRCV1pQcUY4eVEwRXRVY1ZJRWFGSjczelNYcDRUNnFkbG9yRW1T?=
 =?utf-8?B?L3pZVGpoTmU1Nlp3UUJGeWk3MGJzU1JuWGdCRnBaT25aNzYyN0oyRWtPemNL?=
 =?utf-8?B?VnZqU0s0YlhWai9qWWlkR0NmeEpyUHJ4cXRyczQ4VlpLanE0UXB1MDRQSkpy?=
 =?utf-8?B?NFQ5UWlYTURwLzhFSkFUZnRiOHBWVlhBRS9Yci9VeWlQKytIdXUwRENmcnRm?=
 =?utf-8?B?c3J5QTN6VFp5bTJkYkNiS0hrZU0zd2RrV01NeWs3VXltWFB4QU12R3JheUMr?=
 =?utf-8?B?bkExTFRSb1FjY1RkQm93RWY3Z0QyczV0Tkd6dXdOZWlRVEwzbnF3Znlkb21i?=
 =?utf-8?B?OWhQNldxSmF4b3FGUkQ1U0Y2VkljY01XNkR1RDU2QjNTOXpEMlQvVGhIOEl6?=
 =?utf-8?B?VXVoNE53akxnZmQzaytOTFBMeE0xTngrbTlJTDFONWM2MFFDK1N6R0VGdTZN?=
 =?utf-8?B?S2dXcFBDT3VWN3RMb3hJOWoxSHd4blJENWEvZVB6NWlBSnpCN3ZGaU9Vc1Fl?=
 =?utf-8?B?Rml5R3Z3aUNSRXB3ME1mLzMzcVNQTjNZOElxWnYycmNTeUlXYisrRmthSGlL?=
 =?utf-8?B?ZEpiL3VZQ05QVjQxNkF2cXA3NFpHSGl3TGJ3ekRZSDV5OXpuZFowakg4dGsy?=
 =?utf-8?B?VkRVVVpKUDhqTkFhL245K245Ynp6QmhKSjFhdXhaSmFJT01zWGZHbURPSEk2?=
 =?utf-8?B?azhmSFNvdGR3dmdPTWN5WWpOU2JhdDUxdFhmNU1iVWxrZk1FTWV1THdMd0pj?=
 =?utf-8?B?MGgxVFVsZWVJS1ZRWWNjYUo3VjRjbTBtRVpBY3Ftb3hlK0VGblpOc3ZPemx3?=
 =?utf-8?B?VnFyT09pOVk2YzV4M3owa0NObGhJQmNFbVBlZURZdkVJMHZkOGZ3a1plSmo0?=
 =?utf-8?B?MGljcVJvZWhkU2srVGNrQnpUMHluNFBjY2xjcnNEV1FucHZma092alNWbGRv?=
 =?utf-8?B?cWFXb0ZlTnBKc3UxMGFXeTRGcHBpQ010OUFRRG13R2tCOXY3Q2d3dytSTFQ2?=
 =?utf-8?B?WjBsVkQrM280TThtYnA1ZUdUWFFWS25kZENhSXE3M3BVMU1nbitXZUVLaUVs?=
 =?utf-8?B?YUNvZWJXQkdQZDV4U1dwd3lwTWVBby9Gczl2SStVQytRTzZwL1ZPOWp6M2N6?=
 =?utf-8?B?azJQS29OaVpreWpWYUEwQWNBS2tiT2hUZktNWHVpajUrKyswOHJ4bEdQSTVq?=
 =?utf-8?B?S1E3SXRucGY1SlF4Smcxd3hRMDMvWWF4a3IwY21ndmhJR3ovZExmN2dzR2U4?=
 =?utf-8?B?TnMzL1l4UmV2R1Q2SVdiZUZwR2lLcmlNUExHOFRmSzhmYmF0TllWdFNhVS9t?=
 =?utf-8?B?THhMQmRHK3RZckpKR2g1a2lxRCthVDZiRkJ1ekt1b1Q3Z0l2NHhabDgwUHQr?=
 =?utf-8?B?Q3lDQkVRcjkvZnEwVVc0MXlHOEh4Q1Q3UUk0bWgxRTV4RDk5QlUvWW1nb0VM?=
 =?utf-8?B?NlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a22ecdb2-87d4-42c7-1dad-08d99ae0f288
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2021 13:35:18.0739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w3kBGuLCu84LUEaGbSB7dNdnI9/eNggmTjbDm3QhgaSBKddjGmC+ObhRHeGJHNamNDro+ACMMbMbL3tQS1k9CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7004
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiBGcmksIDIwMjEtMTAtMjkgYXQgMTI6NTMgKzAyMDAsIENocmlzdG9waCBIZWxsd2lnIHdy
b3RlOg0KPiA+IEdpdmVuIHRoYXQgdGhlIGRpc2N1c3Npb24gaXMgbm93IHR1cm5pbmcgaW50byBi
aWtlc2hlZGRpbmcgd2V0aGVyIHRoZQ0KPiA+IG5vbi1wdWJsaWMgVUZTIHNwZWMgaXMgbWVyZWxl
eSBjb21wbGV0bHkgYnJva2VuIG9yIHV0dGVybHkgY29tcGxldGVseQ0KPiA+IGJyb2tlbiBjYW4g
d2UgcGxlYXNlIGFkZCB0aGlzIHBhdGNoIG9yIHRoZSByZXZlcnQgYmVmb3JlIDUuMTUgZ29lcyBp
bj8NCj4gPiBJIGRvbid0IHRoaW5rIHRoaXMgbWVzcyB3aWxsIGJlIHJlc29sdmVkIGluIGFueSBy
ZWFzb25hYmxlIHRpbWUuDQo+IA0KPiBOby4gIFJlbW92aW5nIHRoZSAyLjAgSFBCIG9wdGltaXph
dGlvbiBmaXhlcyBhbGwgeW91ciBjb21wbGFpbnRzIGFib3V0IHRoZQ0KPiBibG9jayBBUEkgcHJv
YmxlbXMsIHNvIHRoZXJlJ3Mgbm8gbmVlZCB0byBkbyBhIGZ1bGwgcmV2ZXJ0LiAgSSBqdXN0IG5l
ZWQNCj4gc29tZW9uZSB0byB0ZXN0IHRoZSBwYXJ0aWFsIHJldmVydCBBU0FQLiAgSWYgbm8tb25l
IGNhbiB0ZXN0IHRoZSBwYXJ0aWFsIHJldmVydA0KPiB0aGVuIHdlIGNhbiBjb25zaWRlciBtb3Jl
IGRyYXN0aWMgb3B0aW9ucy4NCkkgc3VwcG9ydCBEYWVqdW4ncyBwYXRjaCwgYnV0IGlmIHRoaXMg
aXMgeW91ciBmaW5hbCBkZWNpc2lvbiwgSSBjYW4gdGVzdCBpdCBvbiBTdW5kYXkuDQpDYW4geW91
IHJlZmVyIG1lIHRvIGV4YWN0IHBhdGNoIG5lZWRlZCB0byBiZSB0ZXN0ZWQ/DQpUaGVyZSB3ZXJl
IHF1aXRlIGZldyBzdWdnZXN0aW9ucyBmbHlpbmcgYXJvdW5kLi4uLg0KDQpUaGFua3MsDQpBdnJp
IA0KDQo+IEphbWVzDQo+IA0KDQo=
