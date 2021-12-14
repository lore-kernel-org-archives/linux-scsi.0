Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63427C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 07:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhLNHO5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 02:14:57 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:13399 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhLNHO4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 02:14:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639466095; x=1671002095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WemjwIIw0jas3hnvWHxz+g6qSBNEX9IYUqpxQoAvlZ0=;
  b=Psmx6mnJQ+uWQNNUw0M2Yj4Qb6F5ck1kj4hq4h/8z34stwzskO2y16ta
   XwICOZUthYkernqgMFfcA7pmbACLvJ1edHsy/g7yLoIyejo6jO/kwh/mn
   AmjeKBh2xBr4vpxnHmZh6QBRQeoLTdEzs47kjTdLXk9zNsSR0kNieM9cm
   KWXZVnAJV7XuflVaTM3VkfEB/97jViewhJAaniL6Cy9qalBIi5VoM2tT4
   fHrY/sf9TWuQhJKpINOh6kfdz+pNHkwZtkCwDHO3PX8ecHsruAzkzJ9AJ
   JkGse+gi5JXBcKOrLkIcRCQXixVt40ajDwaxL0z0welQ/4z1+YxnhDxBa
   w==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="188186846"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 15:14:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mqoz6C0uAl8EkMMMDDdjyaeozWejqB4m/Zju7ET455ZuA2bW92UpbvWEpbjxzgJSRXcSOcp+7Y8J7CtxZPnqux4ifNiI1M+0CGXNbdtSONRQ4oerWOxs8i6Tv6UDIsWjapAz970LxrUuGjvvnQeTVgzaCnXslGtNsYGBFCscWTw4My5hf0eU4E1nrIieEcMlDd6eg2c8piLcU8Aml4RbI81oem3OB22FwrHPTLIB16mf4hWa089uF482iwbijWwzf8+sZbHL/4YV7cch17k5tt2ZWR4tiCGe4fP2nUmaRzmPnkHJwBBqge3fpz8uL8NOtgZ53Jb2N7NkPA58J3AWCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WemjwIIw0jas3hnvWHxz+g6qSBNEX9IYUqpxQoAvlZ0=;
 b=FCmbRQQCuXUFYJZ+uVB25AqDepK85GDvj/YdNDOLBaDsZFWpHiezuBNom7rkkAccX/FdWLR84MZtNfwI/d0X7eG54JsRksn3+UuKk/iKJnbVINJ+vUeKqzQmuaq+vZ2H9Ensun2OY2R2eFzQJXmdhInWY09WEH2hYWJoDNbukCQ15h+SQRjqjuFa56iHTVe7GhiD8DgMMapZv2kyHFQgWmN92hyOCxRIau+eZb/lzJkuVAJMX28jIx6etxAlbPrRcIA5jzfnhaYBMZItaoUDySF+X4n/1QfCkPlbaizuZ2pwrCQpuDcPi+ePmFDlDw3yNd0mHcMIWmljxxjmWLmD9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WemjwIIw0jas3hnvWHxz+g6qSBNEX9IYUqpxQoAvlZ0=;
 b=i40xEJVXGIAndgGu4Kwe7742Z2v1mAkjZ4zuh6o0g6lV4uewtJ7mBFGQLPR4RFItehNZwxJxwlwHDYMKASo5rOuu/QWNwPIh9XTkDeQDuYIoy6pbOIGhpx058aofdMKGN/4Xq7QOdPMEWOiVQE0qwroikiKyttfInNX+I/QMYWw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0732.namprd04.prod.outlook.com (2603:10b6:3:100::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.12; Tue, 14 Dec 2021 07:14:55 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::970:e4c6:a13d:7e24]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::970:e4c6:a13d:7e24%4]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 07:14:55 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: RE: [PATCH v4 00/17] UFS patches for kernel v5.17
Thread-Topic: [PATCH v4 00/17] UFS patches for kernel v5.17
Thread-Index: AQHX8KUSoAeEK2bqHk6ZDwdhARh966wxktlQ
Date:   Tue, 14 Dec 2021 07:14:55 +0000
Message-ID: <DM6PR04MB65752EB0E198BDA3F723DEE8FC759@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211203231950.193369-1-bvanassche@acm.org>
 <163945683293.11687.10954614360616312364.b4-ty@oracle.com>
In-Reply-To: <163945683293.11687.10954614360616312364.b4-ty@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ac43cb1-0d22-461c-8ec9-08d9bed16dea
x-ms-traffictypediagnostic: DM5PR04MB0732:EE_
x-microsoft-antispam-prvs: <DM5PR04MB07322D281EED0C040F47740EFC759@DM5PR04MB0732.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: icf568Sc4vIqlP3MuzY3hi+4kICaPFFFXQK6fpCJ+3DsAK0T6IA6WYO1uQjrqlVB8gbks6ek7bQ/A4wnuPRVYFxzJ4rB6lJ0PxOqS7+bQ4oPYTjCJ7K1fMWyilhe4FwgZbz+SbJXDqIgO6oWERA5+EYujXnxfCAN8qaOXvEjdIE6B4YKDKxy3IG7IBvpIlS0wH1k19wrrmEgNZPdE/FzfLPDA0YjHQfDqq7VHQCtY3IlXTJDPk5+wxcO7sxfiZI9TL02zsptaP7l0mjI+XU8RlZnqq7DaufVW8SCQnC0DIrxAkG8HcBdTWGdQp1SHb6X6GkkurzsSuwoNaM1u/nsJUleQXk8iEQm3PAsqEDOevS5mmOhFbZS4uywfXT6OLV0ELjqq7K8GEUCYlnRpVzkvXif3pSbPlhPPd40UIjRRgjcW9PwczYs7JHPV81izKBJ7frQaQZ0u/CAstdePYkXyOzBfu31rUNYO7zBV0AxLi2qR8rRF6xJH0UoVNe8Hb3JoLSXCOwjUbJG0p/wY0vwZpprQT/5Ax97UxTVho5k32ceNlzapz6xsevyFOrqFUFMS99LoMOduKfELgekQWmpP5xHoC18LevXdCMLu9I6/h7zFIxNp2VMi7OROvPjcicMp9bK8g2PXguVLfmwvzDoNvu7r4+fWRb/dt5AzdTqV3WsAWh9TUDXv2dRJyrWeGEUF3qaCGRPVY9k6uiC+FHUcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(76116006)(64756008)(66446008)(66556008)(66946007)(186003)(71200400001)(82960400001)(6506007)(316002)(86362001)(26005)(7696005)(54906003)(2906002)(110136005)(52536014)(4326008)(508600001)(38070700005)(8676002)(33656002)(55016003)(9686003)(5660300002)(122000001)(83380400001)(38100700002)(8936002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q25PZC9jeXVyZ2NTK3dvN002Y2VacFBzRlR6bTh3ZzB3WEtlSm5aa25jNHc3?=
 =?utf-8?B?amxkZGpuOHVMV1VjRHh6ak9wc2MwMmR1VjNNdktmZW96T0d3VTA0WHhzTlhX?=
 =?utf-8?B?ZjVsWlVSbFA2TlNVWkw0ZUdBS05GTSs2WnlhdGwxRklxQjQ4UUNack0yc09V?=
 =?utf-8?B?K3ZoVXQxSngyRTQzSUJKQlpiY0JKaFBteDFjMFlqa1ovbW5yZUlMODlWMStT?=
 =?utf-8?B?bHlQT0E1RnB5R1I3NjdEcXJUdklZN2lENzRXYkE0ak1kWXlSQlVUMjNndlNj?=
 =?utf-8?B?MmdoSm5GdU4zRXcyeTlQVnRURmtoSlhDMEowSjRDYS93VnhycExaY1BvR1di?=
 =?utf-8?B?eEVPZzU0aHNmZVpIeXZQa2NNNG9JMmI0SEd4b25UMk1oR0xBUXBDM0RZZGI2?=
 =?utf-8?B?cm5zNmpWK1lZYTFjckQwQVdlREVQbEp1ZThqS3plbzdPemdYVVNZblorQytR?=
 =?utf-8?B?dEluQVZIemdTK24xaUJrV3lCV3FDYW8xRytTSVFnekNickFOa3pvcDJvUHp2?=
 =?utf-8?B?SXcwS29ELzMwMmROaWR2eGs3S0Myd29UdjJMempMVDJvaDZnc2tqeC9Tazls?=
 =?utf-8?B?UmhxZFIrS0hnTDhCSVZFS0ZZZ3ZNbHN2bDZzV2tWM2ZBNlBrbXJTN3pTbFVX?=
 =?utf-8?B?TmZVS01ydHFZT3EzeU9SaXlqYUdBOS9WaUw4a1NtWkREK3h5TlF2ZlpYNnVh?=
 =?utf-8?B?QVZiT2o2enJhTEY1ZnZveS9MWk9MbTFVV3N0T1NkVDlLQXdDamh0QlJLa3dj?=
 =?utf-8?B?UTZabXhBaDNhK2gxMlp6bXdZSkdqeG10cHBvWUVXOXN5WFBhSGRUamlac01p?=
 =?utf-8?B?aFpvYlM0ZXlnVW1Ba3BaTWQzZ3ZyZC9aTE80K3JBTGdOTXl5bkYyRDJzT2Uv?=
 =?utf-8?B?bFhxZkZSMStzRXlZMElZY0MvQjJBaGFvN3lPME9kR2tuMU8zMk5NK3BPYlNi?=
 =?utf-8?B?ejczd01wQlZSYlQ3VHlROXR6a1BVeUM1aW9kUXNzWGZ5RWUvd1UwdVdmYSts?=
 =?utf-8?B?NU9KbE9ZZ1kzL0F0cFgyNkU5QlJNdDdJdkZBNys3dTRrTWJaTjl2QnBxbGZN?=
 =?utf-8?B?UkM4TGFaMlZ4eUxhTnA3V3FmaTB6TjI2TTBaU1M3Q1BwMTY0Y2VNd1pUbDV2?=
 =?utf-8?B?WHJ0QndHeXBKTzdYbzNnS090WnIwS0hvOTNZWlpGN25IeFdQeWxGcTFlVzk4?=
 =?utf-8?B?ZTlCRkpoUXJNL25FZ242dmVmSnZNcmljekVhYUx3Z0diaW02RGNrTlZxbSt3?=
 =?utf-8?B?ZHVjM1grV1JHMWxUVGJGNGJZS0NoQm84SnI0djg3ODNUWk8rVmJSMVpIYUFp?=
 =?utf-8?B?clJ0bWJ2ZVVKZ0VscXU3UUhxT1c3MEE3TWpLTURVcnk1Uzg4UExVTnpkeS9U?=
 =?utf-8?B?dG4wTnYyeTZhUXFxNmlNV00raFFwNHFtdXB3d2RTZHRkYy9vYWc4REtMZEY4?=
 =?utf-8?B?RUk2T0pVN1hsclhOaGVmV2VpMTYzcUVieDZHd0t0T1FrOXpMc3ZrSThIbFpt?=
 =?utf-8?B?cGZqaUwvOGYzMU5sTVpZNWFYMEtkOFNYWXU3OUEwU1JVY3MrMHhPUGhNMUFK?=
 =?utf-8?B?L0UrV0lTaGJqNWZjeDFRRGtTWndNVmJMem1wMkpWK3lSOWdsWEhUemx6NWJp?=
 =?utf-8?B?eXdsTGZ6Y0ZnT0NuRk1rMkVXTi9ERnd5Nm9jQ2VGeEZGNmVyaWRTbUpiMTl3?=
 =?utf-8?B?VDZiSjhYeDZGVlBma2hsWkNZeElyQ2todmxqL1d2R1hKNzVRY0lWSmZ6Tlo4?=
 =?utf-8?B?MVhCQjZJRFNqd1VyYnpvczVWL0g1QTl4b0hVWmxleE5pcDVpdm12Zzh1VGNK?=
 =?utf-8?B?QU1aSHgyRFhJWHdITXUwbldmR043blRpODRpV2o0Y2tXcVNTcmFlYit4cHdT?=
 =?utf-8?B?d2pTRjdnR3JnZWdUaFVIdmd1UThqdVFwUUdWUndBNXJNeWlJb0tyaDROU1JZ?=
 =?utf-8?B?ZnpZYWFMNFZFQmJsaUtjK0loWURzdlRNT0d1RVlKNURkM1A0U0dOQzRQUTRY?=
 =?utf-8?B?UTFsZE5KUFVqWlpRbko4SHdZejEweEV5TmdVOEozMFV2c0dZbTFBcU5aK24z?=
 =?utf-8?B?MUQrLzA3RkxaNFQwUjAvY1FNbm50aUVTSk82a21TVm10NFdldkJEM2tyVlNM?=
 =?utf-8?B?c3hEMFdNaVRJNzAzeUp1bkNDYzNmRSt3Uk1uR0pmVXlOUXVXRjZsdzNaL3Fx?=
 =?utf-8?B?UVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ac43cb1-0d22-461c-8ec9-08d9bed16dea
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 07:14:55.0385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qI6ipSZ9LMG6BFAV6px9SfifHNXAvbl8XF1E0ewdYgxGDFVl5efUnO4jq+GJVSLN9Vwkbk//rycwMuCtVQxq+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0732
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IE1hcnRpbiBoaSwNCg0KPiBPbiBGcmksIDMgRGVjIDIwMjEgMTU6MTk6MzMgLTA4MDAsIEJhcnQg
VmFuIEFzc2NoZSB3cm90ZToNCj4gDQo+ID4gVGhpcyBwYXRjaCBzZXJpZXMgaW5jbHVkZXMgdGhl
IGZvbGxvd2luZyBjaGFuZ2VzOg0KPiA+IC0gRml4IGEgZGVhZGxvY2sgaW4gdGhlIFVGUyBlcnJv
ciBoYW5kbGVyLg0KPiA+IC0gQWRkIHBvbGxpbmcgc3VwcG9ydCBpbiB0aGUgVUZTIGRyaXZlci4N
Cj4gPiAtIFNldmVyYWwgc21hbGxlciBmaXhlcyBmb3IgdGhlIFVGUyBkcml2ZXIuDQo+ID4NCj4g
PiBQbGVhc2UgY29uc2lkZXIgdGhlc2UgVUZTIGRyaXZlciBrZXJuZWwgcGF0Y2hlcyBmb3Iga2Vy
bmVsIHY1LjE3Lg0KPiA+DQo+ID4gWy4uLl0NCj4gDQo+IEFwcGxpZWQgdG8gNS4xNy9zY3NpLXF1
ZXVlLCB0aGFua3MhDQoxNi8xNyBpcyBjYXVzaW5nIGEgZGVhZGxvY2sgLSBtYXliZSB5b3UgY2Fu
IHdhaXQgZm9yIHY1IHRoYXQgd2lsbCBmaXggaXQ/DQoNClRoYW5rcywNCkF2cmkNCg==
