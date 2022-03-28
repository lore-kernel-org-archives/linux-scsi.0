Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40655C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Mar 2022 10:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbiC1KxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 06:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiC1KxR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 06:53:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EF7522EC
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 03:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648464697; x=1680000697;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NGoAkCTIdTdu/PdewVTT6zwFN4cDuV4NIafwt5RTAYs=;
  b=NK+Yb4lHnT6Bw7o/bnCVZAPINMzmY3gpXdFzk8PEJqmDJRGHWbpXkQZd
   UZ6BBnsutIeq7RKyJWYKfnomg9PTehhIN6ODm/8SiGjIY+PuSz2/1qeG3
   me5pKLVkASKOgMFyPWvPJONSpJywI57Ljm4iP/urH/xWTwpv+lrjeA6ip
   wygjaWQ1eB1DRnd/5DPzNwTTplfrG+N2RmeO7d4oO2WAxlP5hBLtXoU9A
   AcBKKmQXus5G2ieutmS9HJpg+JGhiyAuM2liFPAbTTIZPRz2AfNCzfBrq
   fzl9qM5zR3kk2Npg8TpknudBzr+FuXVbN08+/F4FT9jPUYqC+nEf6hn0e
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,217,1643698800"; 
   d="scan'208";a="153468967"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Mar 2022 03:51:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 28 Mar 2022 03:51:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Mon, 28 Mar 2022 03:51:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EUkjpOyDBw1jOMVlTykXptUwYI0tpFMCPzTFOuaWnb9qWvb3VjJCGtJaa5aPInMmOTv/KJsxGdxor02BjvGsJlAjD9MjCrQaUJgWDrwHAe624Yl6GfGa3+NuJEiLhH3r7CfJ2bqCISDX+b4+WuSx8kcsoqIVRWrhX6PX7kUF4ewsS7tsFHavSI/7zd0vQSzuGu22y3rWnG5MTMAdUewy/peRM3kjJ2xDjqfpKow8G03f4tEQKOSgmA819qHvf774qSgRK/GNqCrDWLch3Rx9mbdB/pg7XdI48/hD8Fz/Ms2M/sdOFOFgl6PtJzO0wSYCs5hwZUenEiB5SVeurLsLKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGoAkCTIdTdu/PdewVTT6zwFN4cDuV4NIafwt5RTAYs=;
 b=Q1G+4qfdH7jQYva+AEsPzzDPTHQ20z8sMRxMJQhv9pV5qV8kxetHN4465lAuTknz8rLEwFmPbXbKeQR1WjXj69Qm+6vKrkgire5wax7/WTtlyGzFDV8SyWkwk9D6IZ8h6ZISam55ytt1pDZS58pJjLyT+0pXCZvw3Wv7KREzlpHA/FwYbuV9XYTeR5IiVFfrisKDPg3UusqbgmukZ9OA80ed/XFq7T9FruNXPbpC4wojUSc6JNCr7BRaB0Z5KvBkeleswfL4P4Qfe3FZUFxUXZIxugJ5btUVt/hUMOIrpolTU6r0pP5lnhg+8C3NKh5Q1B+AfKpC7E/HGRKVo6CGHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGoAkCTIdTdu/PdewVTT6zwFN4cDuV4NIafwt5RTAYs=;
 b=hyVhpCDkMjket+y+j/M+g2aGlRWsXyv2GfJ59PRGqPKM485rY89QePEjIBz2rzI5izfxa5vRzTSBFfgD8ZxMwcG3O4E1/wu8YTSrmdsr41OT3seByCC4Xac+Dl78HGUcTKZR0zWaXw6xa35dy2/RsZPuJwORLgD9zQ9NfBHbMPE=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by CO1PR11MB4849.namprd11.prod.outlook.com (2603:10b6:303:90::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Mon, 28 Mar
 2022 10:51:35 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::e0b4:5341:c860:9e0c]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::e0b4:5341:c860:9e0c%9]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 10:51:35 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <jinpu.wang@ionos.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <john.garry@huawei.com>
Subject: RE: [PATCH 2/2] scsi: pm80xx: enable upper inbound, outbound queues
Thread-Topic: [PATCH 2/2] scsi: pm80xx: enable upper inbound, outbound queues
Thread-Index: AQHYQoeBviw9Wo5iQ0aHkU3P6jni9azUngbQ
Date:   Mon, 28 Mar 2022 10:51:35 +0000
Message-ID: <PH0PR11MB5112D7BAACA1FD3D9AF49FD2EC1D9@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <20220328084243.301493-1-Ajish.Koshy@microchip.com>
 <20220328084243.301493-3-Ajish.Koshy@microchip.com>
 <CAMGffE=hAb88b3JVG2e3+swuemfiq-B9ZdvCcpfyes9gTeDC=A@mail.gmail.com>
In-Reply-To: <CAMGffE=hAb88b3JVG2e3+swuemfiq-B9ZdvCcpfyes9gTeDC=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05ec53c5-fa2b-44a1-41ae-08da10a8edb2
x-ms-traffictypediagnostic: CO1PR11MB4849:EE_
x-microsoft-antispam-prvs: <CO1PR11MB4849CD3E9B9986C2DE68DA54EC1D9@CO1PR11MB4849.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M34y0WsQzxwNBp3X550oZHAbDxOB1arNpSmUT6X168JaWvyM+y9FEolrPYGnFRMl3AGVmlsvYpfrbhUwGH4OiJGwu2VKN3Wka5GrskWQrmsFS0GCUsAs9Yg+YgF1MQQhDARzdGCdK3fp91SuEZEW5jkHkxOC+ZG6hKJdP0pKRJcSyAXs+vZFsQnYxE0KcvwO1MtWfpHd+uN5smbZSbb3s1cIA8RgZ+rY3dNlwos8oZc6qJdF+tffSYx6QXp693pIrE0qQE5VYW486dGVr6r/gCkUQL/Ne8t8Mehcn6pANGXN9MC94cHqO5lCOGopg9T0DaWylJmhTxniRHhIA2281G+IfusYYDQUzLw6j58tvI9JT/c8PVktUjQffYAsxJFPWc8ByEULRi7BCI/Ob6ffCbhaNsRF4uiIRmRP00+CjKjentM20fU0FgFpr/jTOy1JS1UM++TAxkqfnHJkYLTrOuhhrxUUx3N+wIcNqGrjdlnvuEpFUXW2HeJYBy0OvUHJ94kzA1UWSJoGvwUt4Pa37/yN8U7hrZTWGT7GzKGY8snhyqnq0djrwQfpT45mNBlDrE/JU6xDzvM2G4DHS/GYdUJwLuYHN7ODKPtgJ9efna7p9pcYY4mPnxQBdoyJpprgGPTjmAIyL6Xa3dShHbG6HtTe+RNughpUYDdVy1hqtkB3Vyjy4xL8W6zuPax1WERy2ZVc6Eh5872C4R3xF/hY0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(186003)(55016003)(8936002)(26005)(52536014)(2906002)(508600001)(71200400001)(316002)(66946007)(66556008)(76116006)(6916009)(66476007)(8676002)(66446008)(64756008)(38100700002)(4326008)(53546011)(6506007)(5660300002)(7696005)(86362001)(54906003)(33656002)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czdvazA1T2Yra0UrNUpYOXFraUhPVkhWVlY3Y2hvUmJQaWxaUS9nSlAxYmlU?=
 =?utf-8?B?eEZ5d0U4ZndaTXhteVNCNTNodzRJRURwa3EydVQ4VS83V0luSmVXbW5jOThK?=
 =?utf-8?B?QnR4SGp6WTRzYkkxR3VuQmhzdjBObkpUSnpiSTlLQjE3M2V3djdYcXcvaEll?=
 =?utf-8?B?WmV5RkRBN2dTR2tXMDloWUxvaFhlcElGcEt4ZnNoc3dzOEZyRWFmUGFMQkFJ?=
 =?utf-8?B?Z0k1YnhoWlJaU1lhK2RrdzdqQy9uaTQyRlRvUTVHeDBLcFFDcVoyeWtxQzV4?=
 =?utf-8?B?dnJaWlFWOEVvTDM0b1dlN3V2eFBQd09CNk1DcHhYY1NVcTA3VkxRVFc3dTB2?=
 =?utf-8?B?dnRQVytGRFUzUDZpVWt5QUVnK1JlczNEMkFRZlJYTUdnZFN3UzB1bks1aGpv?=
 =?utf-8?B?cUVmbzhxdDhTYi9jRXU1cEhwTlpWRC80eUZKVkt5V0FWZ2E1OUdPN2xQTVc0?=
 =?utf-8?B?NzNjSUM3cVBGUVNKTGl1L0NOQ2tXbHRyMktzVStOdXpDVGxMcmozeTRxZW52?=
 =?utf-8?B?S2Vnb2NBK1ZWL0FieXpGd21tZVBuTytIc3l0bXJISmd4ZUdyMmYycCtKSWZr?=
 =?utf-8?B?eE5WRUxFWDlYT09oSHNUc2JKVEZKMGhsRGhmL00vZGFQRTRvem1IdEhhU3h4?=
 =?utf-8?B?Ym5NU09weExMSytGV3h2Y1NLa3dFbFR5aVFLWnpQeEpLQjBpcUNyL0t5OHMz?=
 =?utf-8?B?TVczeVpMYnpSZ1hjMEFkejA4ZGFHUVZSZWZoS1hENGc3RkxVY3g2N2c2U1Ny?=
 =?utf-8?B?a3ZMTUFNTm5LQ3B6TUt1dlNCdTlNSXQ3VEx1dCtJcnhudldQS25pZDkyWHpL?=
 =?utf-8?B?UlpOY2dpbVFiaERpeHF5MFh1ZnZObVplNlRoN3pHbWRwNnhZUjhIcTNFUHhm?=
 =?utf-8?B?VG9GdU9qV3EwTUpOZktZNkYzVGNjb3B6b28vNkwvN1ZNaFIwNFJVUGNGbmlz?=
 =?utf-8?B?TjBaK2JYVVJEMFFsaUZHNFpscDF4bXhCZ3lBdVo0Zm1rRkZHZ0RzSGNSVGZ1?=
 =?utf-8?B?dUk4U2lPVkZsT3VOY0xsSjZFRXpSaGpzZld6YW9YY0I4Q1AxWFlEeDRFSkJl?=
 =?utf-8?B?Q3ZhbGViZHdESHFaTG5uTzhNYnRUNG56ZHhYNHRVdkdVdXVNZDVhS2dWMHIz?=
 =?utf-8?B?em91RFNwMzh6VGdYazNISWR1VTdBdkFYaS9VaVd5aGFCR3ZkOERreXJjOENs?=
 =?utf-8?B?UlBGd1BlNUgyby9DQWY1U2NnOG1uSWFFODd1Nk5zNjAzMjZQRWV1ZERmNy9X?=
 =?utf-8?B?KzVIYkExYysxU0JaZXR4TzJpTHFCNFhDQWZheU5nRWVuSDI5bUNja1BjRUl1?=
 =?utf-8?B?czMzVnVIQTYzRlphYkZPbjJmUzkyc0IzTEorNFdxb2ZkaW5XcWFlS1dsNU5v?=
 =?utf-8?B?ZEZORTZzdUpvYTRzdFNJbXRuYlJ5c2d0SzZCUGFRQTl4Z2lrNmFjOVQzRHc0?=
 =?utf-8?B?aHRLLzhObmhoTnkraG1zNGRHaUs2Y2hUYXUxTllodVE2TWdaUncyVDduZ3pS?=
 =?utf-8?B?VmNFYllMZC9lcXJuVkh5a2p5bzhyeGl3MVVINlBQbWJVYUh4bGVHaitIZXF3?=
 =?utf-8?B?dnhMbElMZWR6Q1ZPeFBkcW50WnBaM0NkOTA5NHRHVzgyWjQzWm95QStFcHlQ?=
 =?utf-8?B?aGZ0RmlXK2oyL0ZiK0t2azhVbTRNYUZNd215WG9LdUUvbWU5S3MyTmVRbVBE?=
 =?utf-8?B?bEdIVm1qS2dFRXEyOHM4cGZielExaU5DcWYxeEZ6Q2tzWWFtanB3RDdrNU0r?=
 =?utf-8?B?NWxiaHJYbFd3c3lwWHVIS3NmT3IxZGpzdmVpNnlacWQwVG9pQVc0SERYRmI3?=
 =?utf-8?B?N3pYeXdSYjZEeTFVcTkwMlFGYUVYSWcwZDM1VzB6UDhmeEpmMnI3MzlHMC9z?=
 =?utf-8?B?M0crL0RndHluYkFtMXRTOWZVUHBoMURpeWY2dURaekJNWkpIVnJ5YlVsYldO?=
 =?utf-8?B?UVBMWEZwdGtnUGFTQlAzeW9JTlBnU3djRGxtTGV3UnRlWGhjc05OL3ZhSllq?=
 =?utf-8?B?Z0VvNVlibjhybXFMY0luMU1SSjEzdDlqdVRVLzhybEJLVC9GMVVMdCtMNGM2?=
 =?utf-8?B?SW5JU3BScjJNeTFzK0dHUlFYYzNUQ3phTkN5cHpXU3JpRXRRbHcyUmpKT0lq?=
 =?utf-8?B?TVFyOC9ZZmN2djM2dWhwMDFIdXJEVDJYWkU3OXM1K2JEZWdhRXBTRW5IUDVE?=
 =?utf-8?B?YjMra0RMZlI2RUtKbXliWThvVzNRT0FmZFVFVUdDSHR5TTc4VHJrWC82L1I0?=
 =?utf-8?B?TU1ROHZGeXRwU1h0ZUxBM2NMQUJWekRRc0diYWhua3ZWbnBFcXVYYTNnYVl4?=
 =?utf-8?B?OVNBRU1kQklMYWNUOXFQdi9yZFZFd2tNc3FTTVJINWY1c1ppaWYxdGVGSlFp?=
 =?utf-8?Q?61XMV+YZM3biMXNk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ec53c5-fa2b-44a1-41ae-08da10a8edb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 10:51:35.2279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jRr2lHvwRD1wPPa1wKK7c8IVe79LHmBuL6cxW0D+yL86udVahB11ckLbB9sYpz9xpl3mmqLx+K2JxGWkTUv6mTtcTFBrJHWEWO/pnrNDOjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4849
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmtzIEppbnB1IGZvciB5b3VyIGNvbW1lbnRzIGhlcmUuIFdpbGwgbWFrZSB0aGUgY2hhbmdl
cyBpbg0KUEFUQ0ggVjIuDQoNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBv
ciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUNCj4gY29udGVudCBpcyBzYWZl
DQo+IA0KPiBPbiBNb24sIE1hciAyOCwgMjAyMiBhdCAxMDo0MiBBTSBBamlzaCBLb3NoeQ0KPiA8
QWppc2guS29zaHlAbWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBFeGVjdXRpbmcgZHJp
dmVyIG9uIHNlcnZlcnMgd2l0aCBtb3JlIHRoYW4gMzIgQ1BVcyB3ZXJlIGZhY2VkIHdpdGgNCj4g
PiBjb21tYW5kIHRpbWVvdXRzLiBUaGlzIGlzIGJlY2F1c2Ugd2Ugd2VyZSBub3QgZ2V0aW5nIGNv
bXBsZXRpb25zIGZvcg0KPiA+IGNvbW1hbmRzIHN1Ym1pdHRlZCBvbiBJUTMyIC0gSVE2My4NCj4g
Pg0KPiA+IFNldCBFNjRRIGJpdCB0byBlbmFibGUgdXBwZXIgaW5ib3VuZCBhbmQgb3V0Ym91bmQg
cXVldWVzIDMyIHRvIDYzIGluDQo+ID4gdGhlIE1QSSBtYWluIGNvbmZpZ3VyYXRpb24gdGFibGUu
DQo+ID4NCj4gPiBBZGRlZCA1MDBtcyBkZWxheSBhZnRlciBzdWNjZXNzZnVsIE1QSSBpbml0aWFs
aXphdGlvbiBhcyBtZW50aW9uZWQgaW4NCj4gPiBjb250cm9sbGVyIGRhdGFzaGVldC4NCj4gPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IEFqaXNoIEtvc2h5IDxBamlzaC5Lb3NoeUBtaWNyb2NoaXAuY29t
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc3dhcyBHIDxWaXN3YXMuR0BtaWNyb2NoaXAuY29tPg0K
PiBQbGVhc2UgYWRkDQo+ICAgRml4ZXM6IDA1YzZjMDI5YTQ0ZCAoInNjc2k6IHBtODB4eDogSW5j
cmVhc2UgbnVtYmVyIG9mIHN1cHBvcnRlZA0KPiBxdWV1ZXMiKSAgc28gaXQgd2lsbCBwaWNrdXAN
Cj4gYXV0b21hdGljYWxseSBieSBzdGFibGUuDQoNCk9LDQo+IA0KPiA+IC0tLQ0KPiA+ICBkcml2
ZXJzL3Njc2kvcG04MDAxL3BtODB4eF9od2kuYyB8IDcgKysrKysrKw0KPiA+ICAxIGZpbGUgY2hh
bmdlZCwgNyBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3BtODAwMS9wbTgweHhfaHdpLmMNCj4gPiBiL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3
aS5jDQo+ID4gaW5kZXggYjkyZTgyYTU3NmUzLi5mMDRjNmM1ODk2MTUgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgweHhfaHdpLmMNCj4gPiArKysgYi9kcml2ZXJzL3Nj
c2kvcG04MDAxL3BtODB4eF9od2kuYw0KPiA+IEBAIC03NjYsNiArNzY2LDEwIEBAIHN0YXRpYyB2
b2lkIGluaXRfZGVmYXVsdF90YWJsZV92YWx1ZXMoc3RydWN0DQo+IHBtODAwMV9oYmFfaW5mbyAq
cG04MDAxX2hhKQ0KPiA+ICAgICAgICAgcG04MDAxX2hhLT5tYWluX2NmZ190YmwucG04MHh4X3Ri
bC5wY3NfZXZlbnRfbG9nX3NldmVyaXR5ICAgICAgID0NCj4gMHgwMTsNCj4gPiAgICAgICAgIHBt
ODAwMV9oYS0+bWFpbl9jZmdfdGJsLnBtODB4eF90YmwuZmF0YWxfZXJyX2ludGVycnVwdCAgICAg
ICAgICA9DQo+IDB4MDE7DQo+ID4NCj4gPiArICAgICAgIC8qIEVuYWJsZSBoaWdoZXIgSVFzIGFu
ZCBPUXMsIDMyIHRvIDYzLCBiaXQgMTYqLw0KPiA+ICsgICAgICAgaWYgKHBtODAwMV9oYS0+bWF4
X3FfbnVtID4gMzIpDQo+ID4gKyAgICAgICAgICAgICAgIHBtODAwMV9oYS0+bWFpbl9jZmdfdGJs
LnBtODB4eF90YmwuZmF0YWxfZXJyX2ludGVycnVwdCB8PQ0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKDEgPDwgMTYpOw0KPiA+ICAg
ICAgICAgLyogRGlzYWJsZSBlbmQgdG8gZW5kIENSQyBjaGVja2luZyAqLw0KPiA+ICAgICAgICAg
cG04MDAxX2hhLT5tYWluX2NmZ190YmwucG04MHh4X3RibC5jcmNfY29yZV9kdW1wID0gKDB4MSA8
PA0KPiA+IDE2KTsNCj4gPg0KPiA+IEBAIC0xMDI3LDYgKzEwMzEsOSBAQCBzdGF0aWMgaW50IG1w
aV9pbml0X2NoZWNrKHN0cnVjdA0KPiBwbTgwMDFfaGJhX2luZm8gKnBtODAwMV9oYSkNCj4gPiAg
ICAgICAgIGlmICgweDAwMDAgIT0gZ3N0X2xlbl9tcGlzdGF0ZSkNCj4gPiAgICAgICAgICAgICAg
ICAgcmV0dXJuIC1FQlVTWTsNCj4gPg0KPiA+ICsgICAgICAgLyogV2FpdCBmb3IgNTAwbXMgYWZ0
ZXIgc3VjY2Vzc2Z1bCBNUEkgaW5pdGlhbGl6YXRpb24qLw0KPiA+ICsgICAgICAgbXNsZWVwKDUw
MCk7DQo+ID4gKw0KPiA+ICAgICAgICAgcmV0dXJuIDA7DQo+ID4gIH0NCj4gPg0KPiA+IC0tDQo+
ID4gMi4zMS4xDQo+ID4NCg0KVGhhbmtzLA0KQWppc2gNCg==
