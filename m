Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFF1C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 22:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 241B564ED6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 22:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhBAWqo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 17:46:44 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49928 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhBAWqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 17:46:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612219599; x=1643755599;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+nkO8gmRQ7eRwU97mS8RM4kPlK5XXatWlFB9dWvMdCE=;
  b=FFmeOCY/UIs9CjcdKlxDgQqKQsd0y2v22yeibzVCRkqUBIUgKj2G0mss
   pn0nPysB1o+o68+VQ0lrcul47ktprP/U356USnOBirnw4J/WXfQ85eFMD
   J9PrGOQexkRfuasQG73sKev5Ro3S+BZ0cYhnu1kvVFUxPPaKwM6DWIg28
   IWcIyBW70lGf1Z5LeO/sm3f77YDkv87eh+tQrdFMEw/JYC6Ho7LBP9C7e
   IpRStIAX8UxapzGC6zAJMKqUO3c9lYcFloacWdjAq2DxUBHOnfmc7k81Z
   TCe3nkzLGjRuv3a53TBMa23wE0TWe7P/60RE3UIN7Y6O5wj3oL0yq5a9c
   Q==;
IronPort-SDR: /E/BUfNipKAW4bSngMiPa5Wnbjj3tQUqBwq+oMb+7XOCUPeSW+nZIFidYlge3UthSd2JA133KV
 MEs5EzbCeUXJ1C/UBj5CM49lT3nvEjUnkBTUQ/HA56Tg5rQJo2TUREFJkj1T9Wkp1zKDPcMOa+
 X4IL8PUqD1WQu9DuKzFiyh29bnlO5hYtErjT0bH1G391ilk7RJqX+wyITj1PMAbzchm/qFb7Je
 9hjbM0cMfErB5gSfWzAw+/tq80H1+7LLZ4gs/ImhykugEczoGhzpYhDNXp0ZsSpT5anPv0c0XJ
 mzo=
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="113358540"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2021 15:45:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Feb 2021 15:44:59 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 1 Feb 2021 15:44:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eG/6uBZOjqvv/mIqxmVTA3YCBqFa9D39wJgq4DEn1B5iuzTTTmVcSuGqA763zveEAPkU5WD3fn3x55V4iev6PCQaZUgjmiVAQjaRPtrlRgd85rl33/OkZsnkJ/db1f67XnlF9G+rbQer2+uZ6mJ6CSRQ2gPREwmxCX9SevufAp3ape93lb3MUjcTv3+WQLMMyQ/4p1hWOBCJqUAYXRYolXAimqRlwG4BBrKnw7sFVQBl0hN3Rcp4d4kx/h37Ndv9axyFH53FNbjqo5C2JRpaLrAV1fqVGPbrWTBcIwV2XzjorpNR5KTQ74KdgTrcDvYO3ilV1MZs0wZHeiF7rUIyQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nkO8gmRQ7eRwU97mS8RM4kPlK5XXatWlFB9dWvMdCE=;
 b=IFMwf1XicnVL0GHLPAWTzlo9OOHQa11HdrW690raadaTmNRYIZ5ENVNcTyI9rpxu/o6n+9eO0lLs3PQZGd5nCvSWaoFOc8hukaMqgnY3y6Y9FejPvxeSlKmjtTfBNeuLd2Xv3NB8R09zd/rlj+mZ0sL/KP2tX+hwgeLLiIDIpE7afVpceoRHi147MmStt21rABfAgvRtxAKbV1UY4/2ymbaajMjHPemPkn1iuDynVuV5oOdjMO2c8IfFayfty0ih9pNl5iDd4nL6r7DOqTIKXEjiKmmnVi7OfRitQILuqBVTrNgS8w4372+EZjKVTxKlqT2Y4kfm5ugVk9kBfwvwdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nkO8gmRQ7eRwU97mS8RM4kPlK5XXatWlFB9dWvMdCE=;
 b=f9ziU6ZR+nDiirQGFcewk/QhvNSp4BkPnMkz5Seuu4cIbfYbOntbNMY/CzYgCVTqiZERci+RkZaPlvbIv1Qi5troer42uYXgzT5/XgyjlXlTVB/n1DF+Gjt7LFkBYF0aBHC0v9PHRJr/cSxU4TX6Lxv4G0UzmjKXTHelloj+Joo=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3005.namprd11.prod.outlook.com (2603:10b6:805:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.23; Mon, 1 Feb
 2021 22:44:56 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 22:44:56 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <buczek@molgen.mpg.de>, <mwilck@suse.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>
CC:     <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>,
        <hare@suse.de>, <Kevin.Barnett@microchip.com>,
        <pmenzel@molgen.mpg.de>, <hare@suse.com>
Subject: RE: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Thread-Topic: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Thread-Index: AQHW71yKurA1STNSk0C6miEuXSSEDaow9juAgAEFWACAAAlxAIAAAq6AgAAFxoCAEee3kA==
Date:   Mon, 1 Feb 2021 22:44:56 +0000
Message-ID: <SN6PR11MB28483CC40EE39193333F32B2E1B69@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
In-Reply-To: <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dd6a65c-4546-4a1b-e7ff-08d8c702ff9e
x-ms-traffictypediagnostic: SN6PR11MB3005:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3005F4D6B97FD536ADE0EBA3E1B69@SN6PR11MB3005.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BQq9vCIzR2ML9ChdIpV/lZhjkgakr6bwMN+AKs/p79A5YBvoKXaTJ+w6BAFqI7sZ2xSrQif0q2nPNjgbpsaT7jg/9HfVQLqtB6pNhg38F25rsmSG3RFJ2vyaA/RQx7SpFdU1tpffq9cNnBVqtfTsXKnuZ7wEHtQXKxTwrGrb/9U8vBRnH1HFHL5UK2ntxVaRybEvSERTt4T32g4MLZMph5zP/mE0frB8DNhZW8+3jWSDSYiBP9U2oAxHRoEC6Cek6Ets9CxjeHM/CZwSCKly0JyNY+M+77nBv+APmMONQnBF0qE1VJUO2RVI8g/sTqREOTygVZlJuDBzA2CVWkDNXEw4quQhreR/b3p8fZ0UCnFOqEA6rqEiWazxiYlasST79wHOfTeGNpTvgMwb2yjGsvVHhlsVH4mk4Z1f6kCODDOpPqr0y1v2JsBlccxNczEqeh+fFMRV3+UjyxrA3ku6glCnR8FYfv5CJpznGooG/1oQ/APz2xlaBcw3+u9vtet+ITl9dZog1mJm5bnMTbVPqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(396003)(39860400002)(52536014)(66946007)(64756008)(66476007)(66556008)(186003)(86362001)(26005)(76116006)(66446008)(83380400001)(6506007)(7416002)(7696005)(8936002)(8676002)(110136005)(33656002)(2906002)(5660300002)(9686003)(54906003)(55016002)(478600001)(71200400001)(4326008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SXlMTUYyNUpmVFNEUDNlbEpCVHVwVE1PVGZrem1oMUJlOWIzYThIM0FDM0tW?=
 =?utf-8?B?MjhSZ295b24vbUR6NGtTbk5lekNWS1VIN0tmVmlVNEhYQTZUaStHeG5WTHZC?=
 =?utf-8?B?RXRwdGppSnBqRjNjUGdzTmxWS0FIN1RrR0p2STFnMEZ3bG1QeEF0Sm1jUHk4?=
 =?utf-8?B?VkZMaXR6QTA2RGFuaCtaSUVOU0ROWE9PMWtvbmdKTWwyd3F1aXlDVG84RG9a?=
 =?utf-8?B?RWkvMGxxazgrTFNqcDZHSENXNEtpdDdtWUZZWmVwdjQrMkh3cEFjenpzMFB5?=
 =?utf-8?B?QkNZc0QxQVE4cnI4SW5xZGRKR3UzQVE0eFJwZ2kvU3B1WWJpM2dZSEZrTC84?=
 =?utf-8?B?amZNa3oxeFc3YU53WkZPT01tbGRiY3dud0JhYnFQRldvcGNpNjlYNjhjeU1K?=
 =?utf-8?B?cy9Ma2pzYTRmZG1adFVWcDZXRm96Nlp2SkJ2R3JYN0FUZXhjeEltQUZlc3Vr?=
 =?utf-8?B?R0dUd2gvaG5JMWdNT1BJOHduNFVsWG1kSnIwQ1FQZndPNnZmVWl3NVRHdnZs?=
 =?utf-8?B?V1NpZWU5YzlPTUFZdldzdTFoa3ZUdE1ydHg4UC8zOGZwRFY0ckloWkFacm9x?=
 =?utf-8?B?cy9UbS9yNWs4aEorbkNLbzBKODBzR0Z0dFpOLzdnMkRjT1N6Wms4cE43b09a?=
 =?utf-8?B?U3poSFp4QWhOa3hxOUcvOUUvbU9DbU5XNU9BZi9hVUsxOEJ3d2NKaHNnVUVY?=
 =?utf-8?B?cnJoRDdGVlFjVUNUeHg0dGM3Vm9tQlNWNnVnZDJUcUQ5a1piMjg0ajVFS0Rm?=
 =?utf-8?B?QnNuYm5mZ0ZGYTdnTExCVUx0OHY5ZUsxUFQ4S0hoZXBma2tIVDRFK2tzZ1hM?=
 =?utf-8?B?RFA5bEllRWs5OTZXdlpzc0lRaW1ySEdLODU2VUNUeTllU3UyUTZXT3ppd0ND?=
 =?utf-8?B?ZUtITzdlQ1E5cUdJTHZuM0dPZVNvZThMRmE1aTJQbWpNZmxHajloUE5jU1pF?=
 =?utf-8?B?TFJ0ZWpTeWlRKzVCYmU2d3EvZ0xvTGFmQmw5YTkwVDNLdGQ2UkQwVU9TaFVK?=
 =?utf-8?B?YkUzMVU0b1FqdVNrTUw2SHJjbFI1bUNXcWVLQWpoUXBsWktOcHE3UGxIazU2?=
 =?utf-8?B?ZEwxRW5CNGxFWC8zc2p1TWZLZTlKWGlNcUJPTEx2ZHBjZm9qYitHNUppczE0?=
 =?utf-8?B?Qkt3R2hrRWEwL1ZURi96a3RUbXFrUEl2M0V3Z01MQzBjcWZVbytOY1BNNFhD?=
 =?utf-8?B?ZzRQVmhWMXArSC93ZDJraUxpOStuMnE0MUVxUCsrdndRbTJKRzFSMGtDbklj?=
 =?utf-8?B?VXNrOEYvdy9xZ1BOL2VNWWhuSUt1d2dkR1Y1NExZMUdZL2NKd1E1cU9SNmVF?=
 =?utf-8?B?cVNpWE14UlE1dnFMbTMxT2IxcGhONW9GVmYwN3ZiS0ZycHpGVmt0TkxXSm85?=
 =?utf-8?B?SEhNMVV1dGZmdlJlSjdGV0kwZVJTbDJVTVdWUk10R2Q5UUZpZ25kMjRjVXIv?=
 =?utf-8?Q?UZ0HAQIC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd6a65c-4546-4a1b-e7ff-08d8c702ff9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 22:44:56.3622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xs1nCpPBP9MIjIxP1HA6KQl2/6ybYWxZoIcmJw579n1//BVmMgoBD1tjdu4v0GTnba7f+hg9fyGkqniGUEVhpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEpvaG4gR2FycnkgW21haWx0bzpqb2hu
LmdhcnJ5QGh1YXdlaS5jb21dIA0KDQpTdWJqZWN0OiBSZTogW1BBVENIXSBzY3NpOiBzY3NpX2hv
c3RfcXVldWVfcmVhZHk6IGluY3JlYXNlIGJ1c3kgY291bnQgZWFybHkNCg0KPj4+IEknbSBub3Qg
MTAwJSBzdXJlIGFib3V0IHdoaWNoIGRhdGEgeW91IG5lZWQgYW5kIHdoZXJlIHRvIGZpbmQgDQo+
Pj4gbnJfaHdfcXVldWVzIGV4cG9zZWQuDQo+Pg0KPj4gbnJfaHdfcXVldWVzIGlzIG5vdCBhdmFp
bGFibGUgb24gNS40IGtlcm5lbCB2aWEgc3lzZnMNCj4+DQo+PiBpdCdzIHByb2Igc2FtZSBhcyBj
b3VudCBvZiBDUFVzIGluIHRoZSBzeXN0ZW0NCj4+DQo+PiBvciB5b3UgY2FuIGNoZWNrIG51bWJl
ciBvZiBoY3R4WCBmb2xkZXJzIGluIA0KPj4gL3N5cy9rZXJuZWwvZGVidWcvYmxvY2svc2RYIChu
ZWVkIHRvIGJlIHJvb3QsIGFuZCBkZWJ1Z2ZzIGVuYWJsZWQpDQo+DQo+PiBJIGZpZ3VyZSBzZGV2
IHF1ZXVlIGRlcHRoIGlzIDY0IGZvciBhbGwgZGlza3MsIGxpa2UgL2Rldi9zZGFnLCBiZWxvdy4N
Cj4NCj4gWWVzLCBJIHNlbmQgYW4gZXhhbXBsZSAob25lIG9mIHR3byBlbmNsb3N1cmVzLCAxIG9m
IDMyIGRpc2tzKSBidXQgDQo+IHZlcmlmaWVkLCB0aGF0IHRoZXkgYXJlIHRoZSBzYW1lLg0KDQpD
b25maXJtZWQgbXkgc3VzcGljaW9ucyAtIGl0IGxvb2tzIGxpa2UgdGhlIGhvc3QgaXMgc2VudCBt
b3JlIGNvbW1hbmRzIHRoYW4gaXQgY2FuIGhhbmRsZS4gV2Ugd291bGQgbmVlZCBtYW55IGRpc2tz
IHRvIHNlZSB0aGlzIGlzc3VlIHRob3VnaCwgd2hpY2ggeW91IGhhdmUuDQoNClNvIGZvciBzdGFi
bGUga2VybmVscywgNmViMDQ1ZTA5MmVmIGlzIG5vdCBpbiA1LjQgLiBOZXh0IGlzIDUuMTAsIGFu
ZCBJIHN1cHBvc2UgaXQgY291bGQgYmUgc2ltcGx5IGZpeGVkIGJ5IHNldHRpbmcgLmhvc3RfdGFn
c2V0IGluIHNjc2kgaG9zdCB0ZW1wbGF0ZSB0aGVyZS4NCg0KVGhhbmtzLA0KSm9obg0KDQoNCkpv
aG4sIEkgdHJpZWQgdGhpcyBmb3Igc21hcnRwcWksIHNvIGZhciwgc2V0dGluZyBob3N0X3RhZ3Nl
dCA9IDEgc2VlbXMgdG8gYmUgd29ya2luZy4gVGhlIGlzc3VlIG5vcm1hbGx5IHJlcHJvcyB2ZXJ5
IHF1aWNrbHkuDQoNCkkgd2FudCB0byBydW4gYSBmZXcgbW9yZSB0ZXN0cyBiZWZvcmUgY2FsbGlu
ZyB0aGlzIGEgZ29vZCBmaXguDQpUaGFua3MgZm9yIHlvdXIgc3VnZ2VzdGlvbiwNCkRvbiBCcmFj
ZSANCg0KLS0tLQ0KW3Jvb3RAY2xlZGR5ZiB+XSMgbHNzY3NpDQpbMDowOjA6MF0gICAgZGlzayAg
ICBHZW5lcmljLSBTRC9NTUMgQ1JXICAgICAgIDEuMDAgIC9kZXYvc2RjIA0KWzE6MDowOjBdICAg
IGRpc2sgICAgQVNNVCAgICAgMjExNSAgICAgICAgICAgICAwICAgICAvZGV2L3NkYSANClsyOjA6
MDowXSAgICBkaXNrICAgIEFTTVQgICAgIDIxMTUgICAgICAgICAgICAgMCAgICAgL2Rldi9zZGIg
DQpbMzowOjA6MF0gICAgZGlzayAgICBIUCAgICAgICBFRzA5MDBGQkxTSyAgICAgIEhQRDcgIC9k
ZXYvc2RkIA0KWzM6MDoxOjBdICAgIGRpc2sgICAgSFAgICAgICAgRUcwOTAwRkJMU0sgICAgICBI
UEQ3ICAvZGV2L3NkZSANClszOjA6MjowXSAgICBkaXNrICAgIEhQICAgICAgIEVHMDkwMEZCTFNL
ICAgICAgSFBENyAgL2Rldi9zZGYgDQpbMzowOjM6MF0gICAgZGlzayAgICBIUCAgICAgICBFSDAz
MDBGQlFERCAgICAgIEhQRDUgIC9kZXYvc2RnIA0KWzM6MDo0OjBdICAgIGRpc2sgICAgSFAgICAg
ICAgRUcwOTAwRkRKWVIgICAgICBIUEQ0ICAvZGV2L3NkaCANClszOjA6NTowXSAgICBkaXNrICAg
IEhQICAgICAgIEVHMDMwMEZDVkJGICAgICAgSFBEOSAgL2Rldi9zZGkgDQpbMzowOjY6MF0gICAg
ZGlzayAgICBIUCAgICAgICBFRzA5MDBGQkxTSyAgICAgIEhQRDcgIC9kZXYvc2RqIA0KWzM6MDo3
OjBdICAgIGRpc2sgICAgSFAgICAgICAgRUcwOTAwRkJMU0sgICAgICBIUEQ3ICAvZGV2L3NkayAN
ClszOjA6ODowXSAgICBkaXNrICAgIEhQICAgICAgIEVHMDkwMEZCTFNLICAgICAgSFBENyAgL2Rl
di9zZGwgDQpbMzowOjk6MF0gICAgZGlzayAgICBIUCAgICAgICBNTzAyMDBGQlJXQiAgICAgIEhQ
RDkgIC9kZXYvc2RtIA0KWzM6MDoxMDowXSAgIGRpc2sgICAgSFAgICAgICAgTU0wNTAwRkJGVlEg
ICAgICBIUEQ4ICAvZGV2L3NkbiANClszOjA6MTE6MF0gICBkaXNrICAgIEFUQSAgICAgIE1NMDUw
MEdCS0FLICAgICAgSFBHQyAgL2Rldi9zZG8gDQpbMzowOjEyOjBdICAgZGlzayAgICBIUCAgICAg
ICBFRzA5MDBGQlZGUSAgICAgIEhQREMgIC9kZXYvc2RwIA0KWzM6MDoxMzowXSAgIGRpc2sgICAg
SFAgICAgICAgVk8wMDY0MDBKV1pKVCAgICBIUDAwICAvZGV2L3NkcSANClszOjA6MTQ6MF0gICBk
aXNrICAgIEhQICAgICAgIFZPMDE1MzYwSldaSk4gICAgSFAwMCAgL2Rldi9zZHIgDQpbMzowOjE1
OjBdICAgZW5jbG9zdSBIUCAgICAgICBEMzcwMCAgICAgICAgICAgIDUuMDQgIC0gICAgICAgIA0K
WzM6MDoxNjowXSAgIGVuY2xvc3UgSFAgICAgICAgRDM3MDAgICAgICAgICAgICA1LjA0ICAtICAg
ICAgICANClszOjA6MTc6MF0gICBlbmNsb3N1IEhQRSAgICAgIFNtYXJ0IEFkYXB0ZXIgICAgMy4w
MCAgLSAgICAgICAgDQpbMzoxOjA6MF0gICAgZGlzayAgICBIUEUgICAgICBMT0dJQ0FMIFZPTFVN
RSAgIDMuMDAgIC9kZXYvc2RzIA0KWzM6MjowOjBdICAgIHN0b3JhZ2UgSFBFICAgICAgUDQwOGUt
cCBTUiBHZW4xMCAzLjAwICAtICAgICAgDQoNCi0tLQ0KW2dsb2JhbF0NCmlvZW5naW5lPWxpYmFp
bw0KOyBydz1yYW5kd3JpdGUNCjsgcGVyY2VudGFnZV9yYW5kb209NDANCnJ3PXdyaXRlDQpzaXpl
PTEwMGcNCmJzPTRrDQpkaXJlY3Q9MQ0KcmFtcF90aW1lPTE1DQo7IGZpbGVuYW1lPS9tbnQvZmlv
X3Rlc3QNCjsgY3B1c19hbGxvd2VkPTAtMjcNCmlvZGVwdGg9MTAyNA0KDQpbL2Rldi9zZGRdDQpb
L2Rldi9zZGVdDQpbL2Rldi9zZGZdDQpbL2Rldi9zZGddDQpbL2Rldi9zZGhdDQpbL2Rldi9zZGld
DQpbL2Rldi9zZGpdDQpbL2Rldi9zZGtdDQpbL2Rldi9zZGxdDQpbL2Rldi9zZG1dDQpbL2Rldi9z
ZG5dDQpbL2Rldi9zZG9dDQpbL2Rldi9zZHBdDQpbL2Rldi9zZHFdDQpbL2Rldi9zZHJdICANCg==
