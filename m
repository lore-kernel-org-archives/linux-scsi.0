Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15135C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 06:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiDEG5s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 02:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiDEG5r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 02:57:47 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861091DD
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 23:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649141749; x=1680677749;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wuNevErC+7ELzg2HqBAiZgAW79OFrFjiFsYCoJrK4ww=;
  b=Y3Pt/tvNoq58X2C+yWS8EBwkyUHs8SbMkJ2ghspV5LX4mXQ675/e+Yo1
   g643WNEI1yIUfBgoB1z4wUvagL2fBkBPS8neovAapqTcDdHdzf34y2NUj
   T5/S3D2mWXLeppaiwxs04jvQ8uPRQ6cCPN190yhBFe7OSxE3ElLep9BXh
   j6b3we1nlyjN53BGQdW0cncuDk7okvxQkfc1HwG9nbUS0NyOd8MFU+ejW
   ZBeBkF6Mm54CyS1hU39xXudxgBMjsXsET7D/NIorFwTdHYxVhwCQ27jZW
   QIqYGE5isCfb6jwFw4q/zadG1L39eRxKsmx3la1/6C6voEAFH7eijyh79
   w==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643644800"; 
   d="scan'208";a="197112614"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 05 Apr 2022 14:55:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1CZNJ8NQe8hWbzXvO+dS6lo2tBl0hA8SfLnL0x9QdLTQMhlMBT56QswKuFwIKseijdft8X2E3D09dWVKH4ySXKSFXFuFS61GBKZ1vpv8Bw4kRf0VFF9Zk2StjlRfhIyz/Zro+3xDoEAU3jhBYmkzEr6EuB9aPzJCDxqYx3gRoTOQ8D3J+A72hCKxAB5svQah0FTa4UdimV2zD20yf9zzfGGLPD4iX7xdXvck42jxFF24mmiU7Ziop4s9HZSkFE5809+AZjtHaBzHyKeyIE5wM3QFfJJQB0Cpq/5FQ5FkK5IuhCcdVDt7BLJ4s+E66teDPrP4+tY4nuww92+q7yNRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuNevErC+7ELzg2HqBAiZgAW79OFrFjiFsYCoJrK4ww=;
 b=L/fklL6PcBX1EiNNiWzVnkl/nO0OlaGPw6lCDQTKDKzEX/cxtXRiYPrnWAO1LzQEIKnqxTz7o7Yu3wcIaesyF+Mr/on0aNf3srl/b9oxyBer38xANJPpM/JZrrlwT+KBhznDmj2Howa4YLw9hsVr6Ok1JeRb6YdmIVNCtiWz9I8oEPWutq2vvHzDItL2WBpIzjnRoiIDcvwTgn1PLYC3RQaBoILzAfV3O2Bh/nxmTwL/NIchgN60O0x98/o5LT3L5gcrHohHWvIVJMLDEqqn6mRfJi9wleu5Ed4pGjLoLLfV5vZ0ZjyGm9ipLAAuUdlTkZKpr+H8gkpfUA9uJD45iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuNevErC+7ELzg2HqBAiZgAW79OFrFjiFsYCoJrK4ww=;
 b=mGppozeiQWcQJBl0LKDTtz2uzy2xfT7F4l8uW7al1XqHVYtHt8yFKyDtEYnCpWhenAttzpEzD7M3oGV4iKMErePyqMCyhbtqvElHY+MYTCW80koCcWwcFJEz+4Bxb20a8PjMirIWiRI/4nn7sg9+SeWDb1PaCpk7KAQ2DHjdhKk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN8PR04MB6161.namprd04.prod.outlook.com (2603:10b6:408:50::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 06:55:46 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 06:55:46 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: RE: [PATCH 11/29] scsi: ufs: Remove unused constants and code
Thread-Topic: [PATCH 11/29] scsi: ufs: Remove unused constants and code
Thread-Index: AQHYRU/S9rh8DmXsr0KXnFq5JED5x6zcMxZwgALTvwCAAeKccA==
Date:   Tue, 5 Apr 2022 06:55:46 +0000
Message-ID: <DM6PR04MB657598992B8F67FD787BFAB8FCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-12-bvanassche@acm.org>
 <DM6PR04MB6575F371F794F5AA28FCCB33FCE39@DM6PR04MB6575.namprd04.prod.outlook.com>
 <4d6c2e51-b8d7-6f2b-bcd6-a26d60a21fce@acm.org>
In-Reply-To: <4d6c2e51-b8d7-6f2b-bcd6-a26d60a21fce@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b719e48-20de-4a84-572c-08da16d14fca
x-ms-traffictypediagnostic: BN8PR04MB6161:EE_
x-microsoft-antispam-prvs: <BN8PR04MB61617D6627D773C97EABA76DFCE49@BN8PR04MB6161.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nETTy5xJdX1cf6flaldbxr/ctYwmdRmU0Xuzgx5lnmtS6Xo+9jn7/9YTQp8avprC/TeNyYn7tNQ9ntpDKp84pN+b3nT95nIqekfb0L2u0jq23jYvOKQBWmEJ6mA/0OPruZpGtcYFumYTZIy5N/y+MZf4NWfP0c1lQi5Gy8v7uH656P4wYAFbltx9q+kmszdCyygQPnd5jHokCc7kS+WoOiPJ4CXMbgpDIbw1v4q+OruGOlMU7i5s9A0RmtIGLEH51F4UVyw6unMmwn7rmdCkTv2hQ73/dWySqNdLz2+vgMwyl7EBJeITHOGpeRsCfp3A8bENSb6xXM/UODToiIJTSuHtcpdXx/WBGPODG2lre30JP5oTQNG8o/1FaDSPTVACwwYOhg+9aaV3fT23g5rQ5jE+mZTCBjrLnxMPVyh83jNdvRXS0vkZ4Pe2T4KlQmlA0vp2qdAFH8DJmSMpeScsPVVS3b4gccIhLBZRAh0H0sk2O5Kvi132PFJUCNmHdNecd/Wd1nwP+b7mpptwk6YWa/AtNrbsRyHKwf+ZW3PoCTtl1TG2XXwja8VEFZaTtwoo75A1irV3yaTtRrRY6hNZBUxfEeRN/Ecq3teoXsHUtt8IZD1RNYVs406FnmtvION6IqzM3pCV5mHd55/x+bMu8H7Sid9JSylYbxWvPoP44Q511AtspJqkUK6RKc6n9vMRMDqSPeCxGPf/90RvaasEFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(64756008)(82960400001)(66446008)(66556008)(66476007)(38100700002)(8936002)(66946007)(7416002)(5660300002)(122000001)(76116006)(52536014)(86362001)(316002)(6506007)(33656002)(4326008)(186003)(7696005)(71200400001)(26005)(110136005)(9686003)(53546011)(54906003)(55016003)(2906002)(508600001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlJ6bXd0dHNETGh6NmVCUjJNaHdYTU16THhqK2ltb0pEYkhFS2FvQmp2aGNO?=
 =?utf-8?B?SVZoSkgvalNQMjh2V1dTWjJ0ZjlTaVpRNTduNG9YWmpGdGd3SFRicyszRUsy?=
 =?utf-8?B?bW9TdlVpZVh3U3RQenBQbG5sWEF3RXRrN2NTVldxUXBDVzc3ekJGak5YYS9O?=
 =?utf-8?B?Nm51dm1qeEk4QTY1eXlzOGc0byt3Sk5GcitOY2h3bVlIeVVRQ2FYWldKUGVL?=
 =?utf-8?B?SFlyUUhOKzA4Y0lwd3RtMGdSODVVcG40NFVuV3Zqam0xNmJkNjkvRzYyM2pa?=
 =?utf-8?B?cnpBV3YzbE1qQTFYQ3J3VGo1K1VJRkd0bmtRa0YvWDRpNHJRZlJlSkNOenpy?=
 =?utf-8?B?UnhXeU9YQkVjbVIzQmZ2V2dHSVZhQnZ6czVmZFcrRmN2ZGUyR2o3VzZIcU1F?=
 =?utf-8?B?TWxRYXdnMzdDbjRDKzlHWlhmU0ZRSVMzY2ZkQmI3YWRDNUlNYm8xMmF3ZWlU?=
 =?utf-8?B?dHJTK3dxTjZJZ01PSll3WndpZHFmdzNqdnlEQmh5WkFwa0lPMU8zb2E3R3RI?=
 =?utf-8?B?VjhKUjVxTzVvL1pOOUs4bytmeUtTZHZYWnJaMjN6S3lUZ0djRk92WWVJK1B3?=
 =?utf-8?B?d084S3U1OFNtaWFOTzh2bVdwVUI3ZXdxREx6azJFTnJZejhYMmQ0YW9hcHlq?=
 =?utf-8?B?T2tIK242N3gxNVdESWV5anhnRTRhb05QeEZZRVlEMWZJbGhhWDhSUTlMSkdS?=
 =?utf-8?B?RGgxSlRxWUZaRzM3RHR3UUYyZ2dLVEVyTmdwM3FSSmtFUUg2dWVxcmRGQzlT?=
 =?utf-8?B?WFJpcWZsU1BvQVloSzQ0cFhPQkdhWmVENnYyM0VGZWt0WFRJZUp6VUdYV2pm?=
 =?utf-8?B?aFNCbXB2OW1acVhLNDBwRmxFWEtyK1RvMjlxSVdZeTJyeC9YOENjL01kWmJs?=
 =?utf-8?B?S2NYSTZBMSs4c3JPcTA4MzFOMUY2S05MdXpHT0NJaDVmZms5a3pZNWZrVmM1?=
 =?utf-8?B?a09IdjBvVldCa1JDTmIzQW9pa1RHOFVsUVZVaFBmRkJyTHArWm82aUpET2Fq?=
 =?utf-8?B?UlhKbTFZVUMzcitMV0VpOHA5cVo5bzhralZ2VmJ4R1Axa0pCay9FYkltS25X?=
 =?utf-8?B?WStFWFFwbmp3NUY5UThTU2UxVDBVRUp5OGpjVXRGemhLclUwK2cvbzlWVGs5?=
 =?utf-8?B?L01qNFN4MWx2Nm03eWlkcWNmb1RWTncrUDh2V1ZMMGorUVFhbm5OQkR3ZzRn?=
 =?utf-8?B?OXBXcFpVSkphem1Mb0ZMak96aW9obFBtTzltdzE0N3NoaXJUSDM3SEIySXRz?=
 =?utf-8?B?eVZsMU9nQ3Rialg4ODJxdjJ5akRTaWJrcjJCcE9ySWl1YTFaTklDWFh4ODJU?=
 =?utf-8?B?ZjBXdCtiemVTZEh4V1hlSWRsV2dRdGtNVmh1bExjTnJvQUI0WitNblA0TEl5?=
 =?utf-8?B?ZUNSK1JvYklSS01XbjBISmFRUnFLakI1Qml6MmgyZ1J0KzRFelZFY2dyenhW?=
 =?utf-8?B?L01iL2FKbDFiZWtDT3QzMHUvNEdzRFhGd0RWNDAvMEljNXFQLzhtamtrM0Z5?=
 =?utf-8?B?YjZ1MTNDay9wSnhLNEVHaDQ5T2tVWGFBVnhkY1hqMTdYbzZ3U2R5aHhhUzNG?=
 =?utf-8?B?dzNrTzBrT2szYnBrNXNpZlQvN3JGUHRFenZjc1FIRHdMeDNwNWduaVhMZytV?=
 =?utf-8?B?alhMcTZCV2tsMUNPSHMwU0NXL2pmQ3VqbTEvNjZMcC85TWFENDdlSmxnR0Fk?=
 =?utf-8?B?RE5IY0p0L0NNMGJ1UWE4dU9rOUdwcUFaOXNva0hSTUlrZTZXNFQ3VE4xYmdB?=
 =?utf-8?B?SWZ1VmlWaTRKMThHVzNIaTVaR0hhU3FOQXJhWGFVYjdrU1FmVDFDV0NmTjMz?=
 =?utf-8?B?d3lPMkVRSWFGcHNJNnVDeVJRV3k2N1dxdDFlRTFWYTR5V1ZBMmVLZSt0eDM4?=
 =?utf-8?B?aGVsbkVWN2hlWTdjM29SNk9heWFWWWpYK05YL08yUXR1R2E2SWpLS2xjMWZr?=
 =?utf-8?B?WGJ1S0U0ajVUQThnbWdBN0dPSCtCanRyUVcwWldHWlFINGdkYit1b1dpZkM0?=
 =?utf-8?B?MWJHcy84bkR5OFNGb3oyaEd1RUNFajMvdVNNVkVLSXFjVFlqbVFJRDhDTHdO?=
 =?utf-8?B?ZjdLVktmb2V3cEsxV1Y3ZHJOd29yUUNUdWNYZzNpaUplclJ5SWFZak1IOGtx?=
 =?utf-8?B?ejdFOGVOeUhJQlcrQlRZS3d3WDRGbllqMFlTNzQ1Vkh0cWRCUXVZbk9IdnZm?=
 =?utf-8?B?SG1CYkxBV0NqQTRJV3JZdmFSaTY5VmJoYVJoVzhQeVFnM0VUbXpBRnZyUmli?=
 =?utf-8?B?MWJNbkZ0MVgwQ2dDRVFJa29Ed3czazQ3Tnd3eCtBTTNTZkd4TjZibUFwenpR?=
 =?utf-8?B?YWxiUmdwK1BpNmRxWHR0T0crTncweDZzOXhvakNkamFZU0JGNlQ5UT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b719e48-20de-4a84-572c-08da16d14fca
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 06:55:46.8046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yTIPBdO2G4LOQh46B0jWc7fx+gJ7Zq/JZ7gQh1uP5YDLFN2lWUIiBSBYAva5Y9dNyu1nmgy0oqqom930gsgRgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6161
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gNC8xLzIyIDIzOjU5LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPj4NCj4gPj4gQ29t
bWl0IDViNDRhMDdiNmJiMiAoInNjc2k6IHVmczogUmVtb3ZlIHByZS1kZWZpbmVkIGluaXRpYWwg
dm9sdGFnZQ0KPiA+PiB2YWx1ZXMgb2YgZGV2aWNlIHBvd2VyIikgcmVtb3ZlZCB0aGUgY29kZSB0
aGF0IHVzZXMgdGhlDQo+IFVGU19WUkVHX1ZDQyoNCj4gPj4gY29uc3RhbnRzIGFuZCBhbHNvIHRo
ZSBjb2RlIHRoYXQgc2V0cyB0aGUgbWluX3VWIGFuZCBtYXhfdVYgbWVtYmVyDQo+ID4+IHZhcmlh
Ymxlcy4gSGVuY2UgYWxzbyByZW1vdmUgdGhlc2UgY29uc3RhbnRzIGFuZCB0aGF0IG1lbWJlciB2
YXJpYWJsZS4NCj4gPj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFu
YXNzY2hlQGFjbS5vcmc+DQo+ID4gTG9va3MgZmluZSB0byBtZSwgYnV0IGJldHRlciBnZXQgYW4g
YWNrIGZyb20gU3RhbmxleSwgYmVjYXVzZSBoZQ0KPiA+IHNwZWNpZmljYWxseSB3cm90ZSBpbiBo
aXMgY29tbWl0IGxvZzoNCj4gPiAiLi4uDQo+ID4gTm90ZSB0aGF0IHdlIGtlZXAgc3RydWN0IHVm
c192cmVnIHVuY2hhbmdlZC4gVGhpcyBhbGxvd3MgdmVuZG9ycyB0bw0KPiA+ICAgICAgY29uZmln
dXJlIHByb3BlciBtaW5fdVYgYW5kIG1heF91ViBvZiBhbnkgcmVndWxhdG9ycyB0byBtYWtlDQo+
ID4gICAgICByZWd1bGF0b3Jfc2V0X3ZvbHRhZ2UoKSB3b3JrcyBkdXJpbmcgcmVndWxhdG9yIHRv
Z2dsaW5nIGZsb3cgaW4gdGhlDQo+ID4gICAgICBmdXR1cmUuIFdpdGhvdXQgc3BlY2lmaWMgdmVu
ZG9yIGNvbmZpZ3VyYXRpb25zLCBtaW5fdVYgYW5kIG1heF91ViB3aWxsDQo+IGJlDQo+ID4gICAg
ICBOVUxMIGJ5IGRlZmF1bHQgYW5kIFVGUyBjb3JlIGRyaXZlciB3aWxsIGVuYWJsZSBvciBkaXNh
YmxlIHRoZSByZWd1bGF0b3INCj4gPiAgICAgIG9ubHkgd2l0aG91dCBhZGp1c3RpbmcgaXRzIHZv
bHRhZ2UuDQo+ID4gLi4uIg0KPiANCj4gKCtTdGFubGV5KQ0KPiANCj4gSGkgU3RhbmxleSwNCj4g
DQo+IENhbiB5b3UgdGFrZSBhIGxvb2sgYXQgdGhpcyBwYXRjaD8NCklmIFN0YW5sZXkgd29uJ3Qg
Y29tbWVudCBieSB5b3VyIHYyIC0gcGxlYXNlIGFkZCBteSBSQi4NCg0KVGhhbmtzLA0KQXZyaQ0K
DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQo=
