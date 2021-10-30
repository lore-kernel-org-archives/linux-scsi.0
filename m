Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D0EC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 10:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A26D660231
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 10:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhJ3KOq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Oct 2021 06:14:46 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:20138 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbhJ3KOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Oct 2021 06:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635588735; x=1667124735;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GA3IUaDmVKDggmDdxUrt6kHfyRbM7cdlQlosjlCKRlY=;
  b=nvW9sRJIXq7syY1VH4FTcuozuIZjecLyZWCfqXmiYbX75BfociKFd7T2
   M+Zx+3RrDrUVAvKhq4DTFHM+tokXBUSyLpcupmVU37156u4mAm48KrJpw
   5y0uu2A2ZnPkKYmZSFzNgpmpR6eQ5d3EAq7BydIRu9AtHkDqeRS5tbVbS
   yP5sKkwcOo3ujTn/9sFiVfpYAuGsxjJmyiEnRvsCAuWwWQR9H/G6jCGJt
   GjrZ8qWtTUHT3ioZvdtUDHfATqR2q/jiR3UVdocYdzWDpfKtOUl8tX/Ck
   JyyM2qH7Kcx8C26tETZ2yC7w52F0+Q3Q6eTyRdCptVglsQl/s50B5a/qn
   g==;
X-IronPort-AV: E=Sophos;i="5.87,195,1631548800"; 
   d="scan'208";a="183232279"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2021 18:12:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7AkKPk58CwtiArzBWKQi8QA5Y5H53qr7Vrgxrgx9aZwRvNpr1/VR0OFREQ25GnT/IudSpRGKaqUmQoDf2Qoeovj+iUXBBxvoDI3UPpiA2hx+VeJrah2CRSFQwvRGazH/J8b1gmgD0l5QFo/aSTq4FKCbkhdr19oU/qmpL+mv1UieuxttFqGCFRbYVc2nWBovOvluc2pyAOyq7um2w3yuF4Dg2MMFZNaRqZJwNXL/kjDObR4JWcPxxdJio6W4GcXk3nPyUnPVVNclTIR0bKTeGin+vPVF27Rw30NJHolv7JnTBU07ia0mNT90MdwSSG7JV3CGTEhZYRPmFUnZEF4Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GA3IUaDmVKDggmDdxUrt6kHfyRbM7cdlQlosjlCKRlY=;
 b=bsw/PdHYcpD178fv7d6yO8soPDqWx3Gcc7/L1hnQj+g8puAGfprgvDDVfD+NiDlJBIb5N4Oy2zTDniKhX3RaS5K/pdWIa/xDXm9Vd+/iTG2weMnHa5V7YiQqnv5ofITYQC7PdgwV7VjeAr4a8qZuIsUrpVoLdSo93mfJNKAJ7FhXDeCYfhsgEqA+kMSqrHKlSkyBAMSr2GJcpkCBkeZpt4CIGAmyCAAa8h7aTtq+9Ki/JfNbT+0GdgpOOpxRWhSVgghoKzg1FgUqw7AjEsG8cSBQeq7+A6E6kc5SXjGF0D8TwNwKLE78qKnen9zUFfUmliGkSe/oogxu4JBh8FwUTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GA3IUaDmVKDggmDdxUrt6kHfyRbM7cdlQlosjlCKRlY=;
 b=DrF6AwUkDiiYIEusrRBkoDqQMqV/9rjODnS3PMpBJ1mYTkEq1Zu4SfwAlwS49EBYrI7XXBtoJKu4YNdLvkAK6iSoQBtFgccGuAV0Fl3Y5a+QkIT9H09zIAF/BO3uvcs2lhGI7KXb+ijLZsahsRrDkNO0zaIYbPQwR0dKDQdisHQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0269.namprd04.prod.outlook.com (2603:10b6:3:79::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.17; Sat, 30 Oct 2021 10:12:10 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4649.017; Sat, 30 Oct 2021
 10:12:10 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH v3] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Thread-Topic: [PATCH v3] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Thread-Index: AQHXzVamsreJdfQFdkeYI+BqRsFYH6vrIRyAgAAwaFA=
Date:   Sat, 30 Oct 2021 10:12:09 +0000
Message-ID: <DM6PR04MB6575F504229146B3C465C8EBFC889@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211030062301.248-1-avri.altman@wdc.com>
 <0f81b6d74a6bde6606ac93e20b65cc59b9bed5df.camel@gmail.com>
In-Reply-To: <0f81b6d74a6bde6606ac93e20b65cc59b9bed5df.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79b17d7f-815c-4c58-7293-08d99b8dbc44
x-ms-traffictypediagnostic: DM5PR04MB0269:
x-microsoft-antispam-prvs: <DM5PR04MB02692DB4192BF600CCD5B76EFC889@DM5PR04MB0269.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A843DQYd2MuZNTQtx61qvSF9kcEcV+p7kd879p5Paa3z3Q0zwcacPng05Ly099hgSzQLIAAZQCSm/bw0CweeMrYjrSg9FrqBkDmHmOS+oAmm5NwLyARKG3l6WAtqPM825MV+OxBJtfPu16Kf4Gdsbhfte5flXaOey4aGCY7YmRHITOeTPDQe9sYjGpacdRmk5yPNE2Rkkd7HUKftxACKaDFW2rpnIqNQj2nHhYhRnxH9T5/gTm3rh/fuZsFNIO7nr0JKDys24q00gbP4i1mwJdYhP9ftUhDcwJ9FDwzJ46EBhFsPouJ1896g9C/Wz+G370u4sCg9qw+4dIMWv5oHM5o5LVeSoqPkBmkVi13NZputDTNXT1oIN1VMzy/pzQu0ytnHobi3vMZbpyBAI+PeIHuDc8vUntvmcCswVqyAJoYrGSbHLcwkLW9cY1M5mlknIZakTl2+eLw5CwQpXQprVWFtiWOwZi3WOEAieFJoRqMUy6js4fMcW66UrPVqsaU/ykNEi3L7daC/4vRQ/rnyFV+XyRsbRs68UAw9M7tx7XwxltUI/r+GIY27CFu73IK2Y92PxZbra4kZNWWapgP0djGkZYCsdH7alvsvNqeDgLpBs6pwpQjEEsm5/VdF2ZOznn/t5FmNn0WOUDi/Jsci1Ycwy91yysvVaOU3dPm/I8kzrSpAh+q6JfmUA8OxwLROc5/nNcvmiACbyoLn/o4SRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6506007)(8676002)(186003)(4744005)(38070700005)(9686003)(26005)(86362001)(7416002)(83380400001)(71200400001)(52536014)(33656002)(5660300002)(8936002)(54906003)(82960400001)(122000001)(7696005)(66946007)(66446008)(64756008)(76116006)(66476007)(66556008)(316002)(38100700002)(55016002)(110136005)(508600001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzZQbWdVcUZRenk2V3BkOUlEZHBxdUtycFZkSzZ0V3dMYUtlQmFTSWEzTjZF?=
 =?utf-8?B?MUUzM240K1Z2WEdrTFQ3OWVrYTgwNlRYdWNKbnlmeEZqMllkdnNzVVg2NE5O?=
 =?utf-8?B?NjNSUnFGRDRpMlU1a2ZhQ3RvcklDVVNPNStFeGYrcTBxRG1BSDZhdDg1Nisz?=
 =?utf-8?B?bzRRMng4c04ydzAxOGRWdS9CY21LRXptZ0ZXalFWOHJ1UE1tSGV5TzRLSnp6?=
 =?utf-8?B?RExpRXdJU2djZTNrSFZSNDYzYWwxTXNIRGszM1EwdWZrMHdaM1BvZzVUT0JS?=
 =?utf-8?B?SStwamEwNUhXQS91WWYvbnZqUTZIaUZKM0thM3N6UTNwb2NjdnF0bWJCRVRV?=
 =?utf-8?B?TXZkWDdBNEZwdTN4STQ2TXBPb3E2ZVBZWWVtNDBWSURsZ2FHUUhBdUtjTXIx?=
 =?utf-8?B?eTU2b0Z4bDZiL1lnbnk5MUZqSlRUU3BpRHRTTzdEWWFjaGtuTktzT1VrYm5I?=
 =?utf-8?B?SGIybnM4UFFDV0Y1Umo5cWJIS0lhdURIK2s2bStXOEZBRzdubVhDNHlUYm5m?=
 =?utf-8?B?YjdWTVg3T2VRT2wzQmFyaE0xL0tBQmpEdHVGaEI3R3Uya0xLUmhwZmx6MkdB?=
 =?utf-8?B?VjMrNkQ2RDh3WmYyVGJHUUNYbGtYZFBCR1g3SGtpWXA3UE1MQWVHbm13Z3p5?=
 =?utf-8?B?WWJhY01Vd1dWTWROcUY3VGU0OFZjYjZoWXN1aUVSY3Jnd3NEOC9pTERUMmls?=
 =?utf-8?B?RDdpNGFwZ2lCYTZlWm82d3diMjFCT2JFWkJvWlVpRjk3NU9JVHArRjZ1cU8r?=
 =?utf-8?B?NGRxeWxSV0gySGE2MklJRFJNV1d0M1lIalBWZUJ4Z2R4Y09jcWdnTnBYOUpr?=
 =?utf-8?B?ajlXRWdpY3hlU2NQc044Z2VDMkZ2NTU3eHFxYzVmRXRqYVY2bzNZaEJVS2lk?=
 =?utf-8?B?VGpCOElNN2w2a1BMRWpyWGVDaTlwU1VzLzNEQVZxQkU3bHFQZU9zL3J5bytZ?=
 =?utf-8?B?Tjl6dWJNRmdIU2E2M3BqaXE3ODNrd0JoRTREU3hiN2c5UnBkbmRZaXlhWXhO?=
 =?utf-8?B?UEl2Z0NWV1pxWFdlOVYrd2t3cng4VjVKc0ZPNk1XMHR4VDErblREcVNneHZC?=
 =?utf-8?B?a2J4VXJ2aXNIbThXdXhJMHgwUVBZUXk4KzVMVm5iTTg0dlhiQlNYb1Y4SGNl?=
 =?utf-8?B?ZnZqSmVSTUxkSk9oVStibmlWQmIyV0hQeGZmSXNObEs5OWQvcU9lSFlFbnM3?=
 =?utf-8?B?a1hrRGN4Ti9zQTJWK0orWnRwYnJoK1NTWGNIam8xdkpTck5uUTloTzBVL3cx?=
 =?utf-8?B?dFJwUHRYZVk1Zm9LV1FrNlhUbHNOanQ2TWxBeGZaYlRCc3JOMkU2ZWFJZk0w?=
 =?utf-8?B?UXo0MVo2TlBnUExES3VHZXEwOE9yQncyNlhzaHY1aENYaEo4cjBWRndIazJ4?=
 =?utf-8?B?Tm9ONnNLdDc2dWJZWVM5OGt4enZNSTNDR25ybzdRU3UyZWo5Y1Y4SXZZazRz?=
 =?utf-8?B?aW5pU25LcXJHM21KZ1FGUmhNTEdKcmc4STIxMnJrVFZ3aUpMNmlvS3hLdU5C?=
 =?utf-8?B?QlNxcno2UE5oUE5EeDZqMUVFUFFuOU5kS0sxa3IxS0IreXR0MlAzcE9Tam4v?=
 =?utf-8?B?WXVPdE9VcmlOZkUrV1pWNVZsMWpJZW84L0NhQlRBaXIxbHdZS3FzYXk3Sk9q?=
 =?utf-8?B?Nm8vN0tFQ2M2amZBZzkzUHRVVnRkQis5Q05mclA1STdaRUxIeEZsUzlKTGxL?=
 =?utf-8?B?bTlZN0xnaXVGTTVTays3V1VLaDc3empsbHlRMmM4c2xHTFBzVlhaKzJLd0d6?=
 =?utf-8?B?WTMrVHpJUXpEOFdVNVRLREVnT3lqWFRsdXo1Z3Znb2JIQTlLVjBsdWYrdElP?=
 =?utf-8?B?cFZqK0dVRXZXa1JyRCtld1gweVMreGJVS2hNS0ljelhXVWRQblFqRHV4cTl6?=
 =?utf-8?B?QzJyS1JUNEo3V2UrUkFYenRtSERITDJsZWJqZjhMQzMyRHVvSXE3dmhtVVhC?=
 =?utf-8?B?UTJrUjZmSGdnYWlDZE5rTEFUSzlaZi9pbGdXUnFUdHgxaHpVelFNSW8vS3dD?=
 =?utf-8?B?eEwrRjcwc1d4NmFDTDNvWHJLUk5HN2c4NGhkWUNheWNsb0JCb2VPZ2FSYU5L?=
 =?utf-8?B?bUMvd2JyL0t2dmtkUzI4L3doOXd0QXl4L1k3U25NR0pvL2JNeFBPbzR6RjRz?=
 =?utf-8?B?TTZWTXVMV2RuOWl1b0JhQkd1YXY5RnV6S2w1ZDY0aWNIOUxhM0xpVDJ4bm5p?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b17d7f-815c-4c58-7293-08d99b8dbc44
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2021 10:12:09.8801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d9DUMhRJYGpm3OyRn2HUwTfHFvP/uQ8D1uVuvbsSjKgJl/L2brnbeEOi79ta28cDlGSC9obc9f9VoODgrnrbOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0269
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+DQo+ID4gKyAgICAgICB1ZnNocGJfcHJlcChoYmEsIGxyYnApOw0KPiANCj4gDQo+IGl0IGlz
IGJldHRlciB0byBhZGQgb25lIGxpbmUgY29tbWVudCB0byBoaWdobGlnaHQgdGhhdCBIUEIgcHJl
cGVyYXRpb24NCj4gZmFpbHVyZSB3aWxsIG5vdCBpbXBhY3Qgb3JpZ2luYWwgcmVhZCByZXF1ZXN0
Lg0KV2lsbCBkby4NCg0KPiANCj4gUmV2aWV3ZWQtYnk6IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jv
bi5jb20+DQo+IFRlc3RlZC1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NClRoYW5r
cy4NCg0KV2UgYXJlIHN0aWxsIG5vdCBoYW5kbGluZyBtYXgtc2luZ2xlLWNtZCBwcm9wZXJseS4N
Ckkgd2lsbCBpc3N1ZSBhbm90aGVyIGZpeCBsYXRlciBvbiB0aGlzIHdlZWssIG9uY2UgTWFydGlu
IHBpY2tzIHRoaXMgb25lLiANCg0KVGhhbmtzLA0KQXZyaQ0KPiANCj4gDQo+IEJlYW4NCj4gDQo+
IA0KPiANCg0K
