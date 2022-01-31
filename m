Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56BB9C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359156AbiAaLEc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:04:32 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:65535 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358707AbiAaLD1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:03:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643627007; x=1675163007;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=SNWMCQbf8X8DbmnPYmpaTlIPBNA99s/bsGrKQLvyGRTFQN5Q7iashzbw
   /tmwR3ZJrBJljn9oPXeVr0fGLeBoFTL/isMAgis04pk/q/D2zIaDWoFmx
   9VPzMjKplUjy76v0Skwz9N84ScwslyeWI0F4ygX2YEdeaTdnNw7jYw52d
   zjEAB2m10JRkz4Q4wEna9rEpQ5lGLOWH/A7GmLiWInQOZThf5/b8rmfKQ
   +DLWrax1Mm00M3ieUjPd4iq+gYtYyFvq3Awxjkbjnmg3AyZbJipWsVcvq
   +79DTMUrY1Y+I0GkvwgKcsxG499+uDzhauGncinZPlOuub8gAxIX4+BFb
   w==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="192787707"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:03:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GiqsCyuF4k3Pvq0JLSiDjzOwrlwdB+Kz9NJARq3tgwimOiy70My2bDJJUfkqLh/cN2DdZCcfZ7yVgTZdMubqEZJPLytUxg7suOom+18csK6gTwNW1dDja8/G4q+60mo+4l93ExsNdz6ElvomIhWVVb7V5HBbAhm0MMEGYLAbj4mr06L201A3ZXf04dJBwXTJEt8/ZgwcAIdzD7UGkYw0mPWMUjNAuccuQofSiW7z6xDDMBfiCwSuoRT22drDcDRR5mz0bLzX50RySt+j9MQogKVGP5XcvpzCnPjRo8mTlHa0Jc424s5bY8kbgnHyb+uMLFmou7mQuYE+D+3olZZgaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=Dd9lMuh+NPBzpqrNFfrFuA3zrjT7AkT8/3retmHgNkrbpJq3yKolDpHlye4nv+Yd7IBjtz9CMI+AnRfERm24mL/75/DcqGaYTYeQTKuVw5luySZCzf/TGhvTReCqa5ulo8lv6TUrh9EX1ag+9j4gU70WwDx+lxCMEs2sWbTQA5+JKbOXYXbLq8Pded7hwYmK6pMezu31TIWPzDZMxerJ3gpiqGTBHKLcnDJ3xCCzVMrfcRV4fopYiPmsUodkcpehXjp+AHfX6EmH14JQtstU8rjVwwd2r4/rpKbfP3EH6PiDKzdMKsEsLRr52FNoF6OjPELtSgVOjJWwi49V0XQvRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=hGkZgX4yufAxkKDhk2c5cIGHP+FVzuBNTV8az//hz09atJh7KgnZGFW5QRB64IcHcVOtD0MIPYOmMsr+ww+SZmfC2bApQzdqahQgXD6OgCgPDYpG7Wx3PQLDctjzkJqzoACFBWw4pR8xIWtNdsx0SzJMNePltq2EvvnxtQ1jJJA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB5833.namprd04.prod.outlook.com (2603:10b6:5:16d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Mon, 31 Jan
 2022 11:03:25 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:03:25 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux@highpoint-tech.com" <linux@highpoint-tech.com>
Subject: Re: [PATCH 20/44] hptiop: Stop using the SCSI pointer
Thread-Topic: [PATCH 20/44] hptiop: Stop using the SCSI pointer
Thread-Index: AQHYFJVvrUqwYqCSEEm87TBFQ2Ygtax8+ykA
Date:   Mon, 31 Jan 2022 11:03:25 +0000
Message-ID: <c6cd58450c5be4fbd13d59e02db0926d4a4f377b.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-21-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-21-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16f7d995-35b1-455c-b653-08d9e4a94d93
x-ms-traffictypediagnostic: DM6PR04MB5833:EE_
x-microsoft-antispam-prvs: <DM6PR04MB5833F17B8E29168B4050E9499B259@DM6PR04MB5833.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UU9emSnGRYqeWct+mu7BeBSX0wSKQnKn4WzFT+gyUH+9lUy84/XLLzhrmDU9pYnlYGodF9Hf+v0kwBBEEyC2tr51ppGkMwCqfXYrqpeDpvWmj8cUk5QGOkV2JrM+R33CAwcsTeAvUjDhsQX3FcvdLbsCjg1mCT03d0u6pqwJ+YbbxY0QvoUOfMA6leGteQmnuG+85COeDBYkWct+IdK/4qGpGiRh3TiSyT6nWOu2UuVV4CPagQ7HYxPPtDpmgO9O3CP/8vknfl4Hy2Jjz+unM5IoEvMtBKNklpIil8CIj+tadPi1znKM9DtbVNTHm24uSon3V5Ywc32oRXBOt9fDPHjYq0WSOA3XflnGPjHYIDWJ7xvPoPLPoKNaqCxtUdWh0hRrJXBBoXOD8mqWSUtSgdYKZPubIcGe3jC+H2P6KoaJ2TnAcqexu2k2C0H5Zwu5Msq3gRkFSq1yXJp4HaqQbmcmRB7n9PfsAG7oFdUwZc9dsfn7Xe44zRI9REx/1YqnWiUArzlQ/BWhpEGQ6IN6mE23h5g9aWYg0frw1b0WpMyJ6lWfKOtZYuDd68FS19AxpJLwXfDVe4hTqEd9nwUjHgRExObKlKR7EbYocxa+uru7rlcJToKzKvurP+SyhypJBxhLH9sGTg+dPxuD2+4oFFdkkfTutF7r17nkd9Qixu/p9uEURLfEkTx83qThCpDQaSgcijnEK8cLrZVo1SWCAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(6512007)(5660300002)(110136005)(558084003)(38100700002)(6486002)(122000001)(19618925003)(71200400001)(82960400001)(26005)(4270600006)(186003)(508600001)(8676002)(8936002)(64756008)(66446008)(76116006)(6506007)(91956017)(2906002)(36756003)(66946007)(38070700005)(316002)(86362001)(4326008)(2616005)(66476007)(66556008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ak1obnZoNVh5bTM1NVJUSEtMNDBFZVRrTllLWFJubVFLRW5ZTEVRY2Npbm14?=
 =?utf-8?B?Uk9FSU4xVUtpMCtkVHZrQWREa1dvMVBjTno3UGFycGppL3NuUlZxOC9jT0E1?=
 =?utf-8?B?cE1xdFFUcTBuZjR4MW1XdXdiY0k4VTdjeTlXUjZSS0N4YnBzUkhBSnZJM3c4?=
 =?utf-8?B?WERmU0xKUHJSTDZZWkwvOHBOdzBRYjBQdWk3NG9LRmxtMkEvZkxJVjkrMTI5?=
 =?utf-8?B?d3BETDdWMml4UTc3TXpGaXZKWnU0RDdsYUhUQjJCNkZnRXlPRHdTQ3VGU2gy?=
 =?utf-8?B?VlFuKzZMaklDZ3pxRHpuOFhSekxjY3V3QXpYa3pVYmRHU2pjTjMyWjJEenB2?=
 =?utf-8?B?R2FmeHlPeHp3R0pWOW5xUjZOVk5IYnF2MkJEY3VFQTRXT3pVNTlGdlpLTkJJ?=
 =?utf-8?B?V0ZmK21HNDQyUWlVNUFxUWxPSmRXQ3ZkQ3dyc0lCZUJLZ0lrVFI3SXRxNE44?=
 =?utf-8?B?UXRUcUY3MGxtOVM0RDEvaXhPbzZic3l1TVJJYklqOUZRSnMxbzVrYzllalk4?=
 =?utf-8?B?NmpwUjlyemYzRVVXNlB1OFZzeEdtVDdOb1VvTkdCVTZWQVlTWHVGZFJJcHF1?=
 =?utf-8?B?NTBTNXJsb2lTUWRCUTM0Rm9lMjBqZytYckd5UVo3Q2xkZE1oVzQrYVIwVnhM?=
 =?utf-8?B?VnR5bUhYNTNYTmRNZTNFQ2U2OWhQN09QTG42OEN5YkljMVgwWGJPbzNwckdO?=
 =?utf-8?B?bk5rYmFBbG5VRzNlQXcwNTBUNUF3T1Z5c3F4MWxKWnY2cDZUK01RQ1REcXcv?=
 =?utf-8?B?d0xYZXh4TkpvRVdmNllpNTEvVGZkYjJGb1VqUE1WZU53NnlzcjgxUTJSZzNF?=
 =?utf-8?B?aXp4amJmZy92cUFlaitLVjVmcGdhUkRkd2hROUZQT2VmNmZPa0I1R3VDYmJi?=
 =?utf-8?B?TG1yR1htYTY2eDhQTnFheUhjaG9mSTZtZWs3cERNd1E5TnVSUnBFL1BqR2d6?=
 =?utf-8?B?SUhpeUdyL05TUERuN2hrYkJHdDhzSE5HR21iMWphbkNJRy9CTzQxV3JvUzFm?=
 =?utf-8?B?Rk4rY0hXaFVUT0FaaE8zY0UxV21mY3ZrcXY1VzBrNEgxa2hkdEpRRGJxZGNn?=
 =?utf-8?B?MitTcFhtZ1YwTUNxQWxYYVRHdVljaGk1d1RERy9EYVRjL1NQSUkyeG53QW9l?=
 =?utf-8?B?Z285ZExyV0NGSGwwRzlKVTEwVGlJR3drZUI4ODNCbld0bE5FQW9VYjUyaUVn?=
 =?utf-8?B?L3BWZHpBVFp4TGw1RDRkRkR3bDduZlZUSVVyWmU5ZVh2SXlMOVR4aGxHRzIy?=
 =?utf-8?B?OUp2SndQTElqLzNLYkdrYnlPMW11T2dtTGExUlNaSlY0WGtBOEUvV2hVZTFp?=
 =?utf-8?B?SjFWUVFBU044V3I1bzIycDZEOFZYbzFSMWFCRVBNOENReXoxajNuOTFLUjBI?=
 =?utf-8?B?cW55eXJZZDdZOHRRTGlsTG16YnBUWmtkVjFaUXBwTHdSMUJmZENDb0lqeTI4?=
 =?utf-8?B?SHMwWXAzTER2WGFnS3hmdlJaQ01Ud2FTNkFPWXU2OXNLbzFoNEpFaUM0UDZk?=
 =?utf-8?B?YSt0Y3lKblZCSS8yREJNRVg4M3lMN2Z6K2ZocDZPank0M0g2OVZpM21BSjQv?=
 =?utf-8?B?cTgwbXRVcmF1bzVtdk5mTFcySW4rcWxLR2M3OXBFVkQ4Y1dFQUNLakw3L2dp?=
 =?utf-8?B?bUVsbU5NZURNUjhIVXhJK1YwVno2RmR2Y1hhdWoxSmZ4OGd6Y2RPdjRnbDFI?=
 =?utf-8?B?MUUwT3Y3Z01Pa3A5dStkQThMRSsvOGlkZEFqY3QzTW45SWlhR0FvVXZab1hn?=
 =?utf-8?B?aFh4SnNJKzdUb1hHNmM3cEd3MTBWTDhncXFuMXdabERiOG9JTFdRdkl1Q2Y4?=
 =?utf-8?B?QlU0RTVKSjRRNGg5RUR2aXpHaUQxNHhBQ0ZRUVR3Wnk1dmtuZENvQVJFZEZU?=
 =?utf-8?B?WVhnYVloRFQ0NDNyVzBhdSt2TTladkpmSTFYbXBPOURGWStPODhZYVh1RW1G?=
 =?utf-8?B?UUZIZE5SVzhvWk9Md2pkdVpMc1hEWWhPaENGL0NkeXdXcjRVV0dxVzU4a2Rl?=
 =?utf-8?B?SFJRWStEUW5BQ0N6NEZNcTF5ajJMaHpZNlZ0ZDl4Z1pvcWJ4NWJkRWY0enA0?=
 =?utf-8?B?V3VhZWM1bDVMelFOZGpqNmpXSkVkWlF2SytoeHlxRXNHSTEzVk9xanZEZXdq?=
 =?utf-8?B?djFqV0VxdGFFSXR6V0FFRERxSk5sdURCaCtIT1h3dVZvcjJwaG94dW5tQ0sv?=
 =?utf-8?B?MFMrNHdYK0NKc1dWUVF3blViZWVaNFdoNWJLd25EWjVCNUtDakl0SHV2NTdQ?=
 =?utf-8?Q?r5Jvtc/UcFsCTDGEyWUpblyw6lCBoPoLJSW3U/Ivds=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <694467E71CBA4D46B88B05929644DA10@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f7d995-35b1-455c-b653-08d9e4a94d93
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:03:25.0518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9efxk/EFPFoEVQGO7pjmlpTvfKsluNfbd/US+Zy1jCM2sax19rQziFCPXLoKkn1wLq7yhymz/QNxz1ETlbgTlQHDKniIw9JbmoWBaNkyGWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5833
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
