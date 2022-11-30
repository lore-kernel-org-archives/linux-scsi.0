Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEC1C352A1
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 10:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbiK3KCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbiK3KCX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 05:02:23 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE9B2F66A
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 02:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669802543; x=1701338543;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0zWJoFPiQomXVKkfK+A47m/eU8qKsUI+xJ30UoiKNu8=;
  b=qh0/w5pfZ/tbO8wdqJ6lSf2sRruJ7FUz/QbJTxajAPSa0Q+yJ7/Z7Efr
   L6v+BVRIcZEsU9ozdZxJonXX46TUlSPs81DKJaJO4QQ9DkDmd6QWh+L1Y
   ZQFNBb2h5pQWNmcgBcaUtvjheY/R0OBRCJBaTUs66c0tE8We0Gk0e5kEa
   JkbbzomGFMhr6rtMrjveeVvjRE3SPLkBPBXSTCTVOjSTbiLmiyGoiSWx+
   86SlG4k6aS67KfZR0WkhJmisMaMRtZpd/oALLK8vSnKp+EMMEcjoOijDQ
   ByNxtY/fBxyGiivUfVuQZkLwEMq4jCnK+gqpa5Ga/9ES4HMZY5hQdS3e4
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665417600"; 
   d="scan'208";a="217827523"
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.106])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2022 18:02:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SeF6DO0z30sFfoegOev60VD/FWzWEDBkd+xM3JNHpgTk2BMOUGj5kgnyA8KS3e6A5e9IlIzByd2oJwRPtitTqdERptNtTaTuXoUYNFefGZiXyogFx3BM99X71ViP5jQ5zQUBRMlblKE7zbTgHnV/pdm/10ehJdPJxAsvDRW3cVDVIzt42llg/a5Q3g7a1oZYTms6KXu84hGWXzCc+jVGa8rZIplUols4MY4kn4GwLnZsfGoNUKJU4fVQpvVNlV3aaUFDOa5h3PkCUgdC5Qag8BfxMJweNtMP524JKnRM2CtdxTFqU94cP9ZF75gqCHCDieIXcJPFWNmP4ZvOFN/NeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zWJoFPiQomXVKkfK+A47m/eU8qKsUI+xJ30UoiKNu8=;
 b=G/k0CY3JNCtZxgJpU5rffWcdZt2nsGvJKd4+emW8SRTyV2JehIAG1M9mf416Kw7BsMLYLk48Fhy6utTKoGhCZvV+pqwcMaTUopiFj0Hj613hoFZFdD75vH+xEsGTEZkrxqyvB49P4wL1DJn0tbAtAMYJNi967JldaBQ5emOIz3tmBblzIOWB4tsjB66g6sPr3V05QLbgQx2T4AHDc5pZpzPP85yKdw+QBWpNtTspCVQyvz18HOtmEHyEYiHRrCMZnrZ2KMpPmV3WUQ3YfKhQxstzVDGvUQbJSiergRTLxzu/lCuEXgWUPmFSYAoQfnSCe1uPDBX/iiKGbmuhLK97nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zWJoFPiQomXVKkfK+A47m/eU8qKsUI+xJ30UoiKNu8=;
 b=h90NwWXnzME4blm4SlkLAzzcr6RguhWuv+w9+psM8ceyTqTbpMAvXIxONh2pfvfxr5izWoHoDUrmKZ2x//te4gr9wp0TicOX5g/p60q2HTcsWcDFJdrtV86bBWGLNAMYeZKXmtfL6xvdBMztJ3t9JYJl4w+yASS4A3IVOcqRdI0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB8243.namprd04.prod.outlook.com (2603:10b6:510:109::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Wed, 30 Nov
 2022 10:02:20 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81b2:90e4:d6ec:d0c6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81b2:90e4:d6ec:d0c6%4]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 10:02:20 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Thread-Topic: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Thread-Index: AQHZBJdIwi0ipPRZEki0DoidGKrtk65XO8GAgAAAZ4CAAABTgA==
Date:   Wed, 30 Nov 2022 10:02:20 +0000
Message-ID: <e918ff92-4b39-3a4e-21b9-2d6408873161@wdc.com>
References: <39540065afb936255236311fc6c93f67a7805bf6.1669797508.git.johannes.thumshirn@wdc.com>
 <a60e44ec-a262-d668-4410-60518091f514@opensource.wdc.com>
 <Y4cp5S4AWV7+Sw3T@infradead.org>
In-Reply-To: <Y4cp5S4AWV7+Sw3T@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|PH0PR04MB8243:EE_
x-ms-office365-filtering-correlation-id: 4206cfbe-81fe-4cb7-089b-08dad2b9f842
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h7H1zwMS25ENT1Fq+krFBaVam19eitPA7cJs/hRIiunQD7GRTlVh19x/0cp4eWvOrFKYH7e1LDV80vQV0WwRdBHoUSWgzN7Nq+YcckPUKWChdM/wKi6TaKnCVDX1IIhIXxLGFW5mlEMwGwHpZr7QTKGkFyxbOjorcpyzOYafcoZv8a6BtvswyVQ68/OoEOIQ1jFueWOiDwQVJMzsDd4yUzfsYNNrbkvnJGzPH8DFGz9qp476BI8jtMAQWHL7HcCA5JMTr6cCPwq3wUgp5YMfRUMir9ngGulFf+GPpxmw4VBJtoMts2UDJ6CxP8COyzLjsaQT78xQ/xh/0oLvvJquEwx78HpLFLe+1RNGqOLxGvypwLykSMob+iTne1wKVsKPTk+SkRdlMDfPS6gzZDz22TY983aEdRWuUmXeul+U0VXUcIO6STbyAzK4o//RDs6E+5ctpZBf3KVxp0xO9QcBMQl0ssaQuNnH+sC0aOGgP0U+y8Oi9RqioDr29or4BW1X2UjN+KQ1ikeyAAPp2h2btZOPpjEgvhpXUhMYfm0jChuO+a4TnEpt8qEmKsVm4laQLKti+Y3G7WLgTs72wLPvILTYUKjQ0scRrFU1+M2yyiWTAtk1k+X2j2JbccA+mgVLFXEHs/kz7Th/S4GJ7KjhUYnABxKib8AAgx6KyLO2yCOI1kY7UzFXucX/+I3RqRCJdif8OowEpxz2eZEDRoglaQiVO8S8U2id2fYpMbqktxr1XWSzynfCXkMleP0vg8XAMh9TN8Z7VO/kurPLSnFMYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199015)(66476007)(38070700005)(6506007)(41300700001)(86362001)(8676002)(66446008)(186003)(66556008)(478600001)(91956017)(26005)(76116006)(6512007)(71200400001)(2616005)(4326008)(64756008)(31696002)(6486002)(66946007)(316002)(4744005)(110136005)(82960400001)(122000001)(38100700002)(5660300002)(54906003)(2906002)(53546011)(31686004)(8936002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXZHbG9PUjVCQXlZZzM1SmI2M1owb2pyNVB5VXVvVytUNzRjK3F2NzgzMWZj?=
 =?utf-8?B?SXlXZUxiU2UxcHhsckozSFJXTnJBaGhCWEljYUdkK1ViUHpzdC9CeGE1a2tX?=
 =?utf-8?B?Q09xQ3FuVmMxRUtWVFhOZC9TSXN0cVN1Q0lDUlNyOVl3QkdLczZuM2prNWtI?=
 =?utf-8?B?TnVxWE5GVFN4bmV3ZFVBeTBqZVloaVVHSnRjaWlPVWlLOEEzcm52U2lDM2d5?=
 =?utf-8?B?OTlVWWtUOWxyZjZXQTVIV3ZOTWJxUjd0emZHM2lpUTRtcHVwbUMxSTlQSWJh?=
 =?utf-8?B?MEJzY3NEZEtZQThVdkJEMDlXRERabzNPUGlYRitQMVFnMWZlY3RoVi9HWWpE?=
 =?utf-8?B?aHp0NGZoMHpTMHZMMWVTVGxDS0JJTE9mSGwzWHJkSDNDZFdRTGZrZHNJQkhI?=
 =?utf-8?B?aUZZdEJWL3BQZ3hLM1JJV3pxWmNBbjdrcTc5Zi9PdllhMHM4UU5lSVFWMUs1?=
 =?utf-8?B?VUJEdTgvOFppVllmT3F6TmFRaVBhWGFuY0JIWWdrYlRhVFdobDM4NkN6RVc0?=
 =?utf-8?B?MnFvTXZKUGszTXJLWlNuc1Nqd2E5NkNwZ2tuYk50NFM5MG4waHpSTThvQjNJ?=
 =?utf-8?B?RjNhRTR6SlBWZ29ieXZ6ZnpDQ1dvdXNuRXdmaS9jUG4vaWx5c016RGtCZHNR?=
 =?utf-8?B?ZzJESHdvVXlPNXVyNzlIZTJsRGoveWNzOWQyTWNlRTh1eDhTb1QvaURVZCt0?=
 =?utf-8?B?M00xa3FlR09kQU5kSmNGc1ZXUk42WEpRcjdmcER3TVdlbHlYV0hTOFpnZVln?=
 =?utf-8?B?clB1TW5EUjgrc3EvakdyUTBxRUxiWGttd0wrSGpLMFVJZzBrd2xIT1Nyd2Fn?=
 =?utf-8?B?Z3FoQnNORWRIRUtGdFhOZkZQbWdLVG9zR3VrM0tDZkdRZHAxS1UreEFaTU9m?=
 =?utf-8?B?Wit4eWpuZ2htVzc0dVowR2ZyOUVNbnkxSHpSeVVpMFlPMXAwRHhuQ2tNSFpH?=
 =?utf-8?B?Z0dTY1F4eU0rVkd4aGxKTktHcWU5ckVMQnh6NXA4ZVhmT1M0Y0JxNXlFSERP?=
 =?utf-8?B?dzFyMW5IZ2hrV1ZuMGlHWGVpdVIwRGpMUUNJdDR6QS8zR3dFU2dBWDVPVFN6?=
 =?utf-8?B?dlhRZk1nR3JYZC9raUxzeDh5dHFWZWJNRHkxc1VmaG5iaGFGSk9TaXcvVGVB?=
 =?utf-8?B?SUNtUlgrU2Y2TGE5aXNKbklxd1MwUFdEdGtQczFDMi9GQXlralkwcndMZEp4?=
 =?utf-8?B?enRSZ3p0YVA4ZnJ0VUJvcXFOM3Z6Mlp5MkJYanp5NWpDOEZOL1RVVFVDbmIv?=
 =?utf-8?B?MlRXZzRkVnZaSHJUcXpuVnJNdzRqVUt5ejd2bHRFV3pWbjdKRFVBT21sSUd2?=
 =?utf-8?B?eTBTa1psOWRWMG9iUVN0NFlmcU91VjI5c0xsYklnRVJ0M1pwL0JGN0g2dHhE?=
 =?utf-8?B?ODZQTzJLaWJSKzZVMFI1S25WZjFxZko3QWdHUFNTZ2VoRUF5TC8wV08zTDN0?=
 =?utf-8?B?bmxQd0VDYjRPOTJra3V2SUx1SXMyUFpIck9JbERRaW5pNHoveDlIaXB3djZU?=
 =?utf-8?B?bU1hN0J5UDJwUHBEYlVWdzBPa2lDRmFKaU10UGQ2YXk2QlFWKzNVS2tKSnJo?=
 =?utf-8?B?TXR1ZTFNNEEreC9yVHk4RU54aDJyN3NrU0hncC9tSEdkdzZRc1Z6VXlsSWpp?=
 =?utf-8?B?bk5FWjFwQjZoSXBxSTZCUlpRTVozdExBcnBMR0lUMzhmUTRML2t3a3Q3QmYz?=
 =?utf-8?B?a0ZpbC9tN09yY3U2Q1NKZ3hZOVlMZGc1dHIzN1lJeTBpWWxQVDBUOWlna2dl?=
 =?utf-8?B?NjVHWFhBb0lTMzZIajY1ZUUyQmxDK05MVUhYRkdkWVJSc0RIY1RvS3hPOTdi?=
 =?utf-8?B?bzhjTDZKU3VNdXcxbWpNWlZQTmpLL0ZjeWg4bzdCOU5MTUpJeFEzZ25ObCtF?=
 =?utf-8?B?Qk5VcWxVUnc0SG02S0VMSVY1NE4wT1g5MDQ1ODhEcG5BSjBHYVdEWExtSEpS?=
 =?utf-8?B?bUVodFZOV21JNWZnT2hvcUpwd3QzK1REUDZSV1NFTnFyYXlObi94QmhzMVJC?=
 =?utf-8?B?SGRMQ0JZbnk1MGgzWkhlaEo2MVlGZXJ2T2FPVTZwc2J0MkgwWm1McmNIajFR?=
 =?utf-8?B?VHM5S0U3Z1pZN0dvdjhsZENRelNRQVU3RU1JVUVUWEk2RjBRNTdJMFlRRkdw?=
 =?utf-8?B?RGtoZzh5VHQ1clVLd0pHQXpKQTdiTURJemZFZjV0VzZDMjUybVVtQ3h1V3V1?=
 =?utf-8?Q?yazT1nBcBtA3+sywwvsNGNE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4CDD367EF5F79428EE310800418F70A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rGDrYXm11nIGprzCPAZ6j3GZ3Nw6EJiqdQhkJnUa1dgxrc6lRxiSg3ExD0NhrTF33XfpKjUhiZnaeXMptlXN+W/BpWNKXIwVKS2isoiVQXJSmEznK0wyMRvhCIVvt9LdbFs6TTM2C+vhJ7KWyMD6XC/nx9o3Ps1qiOrRWk4TP6IQdVQB1Z2aP/EiHCUb6u5sVv289EhYzSXUGg9zoQhafuFYyah5n//cCQPjV1g7Q3WdnY90op6d++DQktDDwok476J9iJTj5nD9TKIowadr4+KPAcSkjPghKbOU8nrCH0ugRT+NL+q7ssGyVzYd0db5gADOFQyCJ5VCbDR1eztc06PN8tNS0fsdMFkNtYuvowE6m0x09rECRC30ulz0F9M3bl+kmKG6yrEOOaRrkV6+ujvBHIZVj0OXlPTte1b5NeNc5L8kbQsa/LfhSni8+MEGm9wk7Y3033GGxhZbM7MhChFHUocZUq72jvr7Jq9rZuYThwtF8s97taNWrgGP2OglAoszmc1Aqx40sD6DX6b7NwJ4ZL0/rqCVqv91LMYJeD20PQ9ss827+Q7mClIHQHSAYFJW3NaLrUjD3ayp2CdnSBsoA5B62JNp5Rn/B4xbGza2mGeeUTrsTkO0cIX+g2fgr51kjlCnKrC4MKPL/1uybVOVIGtoAd2s5KjyfiDsdvTDPsy1yGMO2KRND8wDkiassMon8SBRO6T/QfrLjJzBZURgrbzEUE5a0klz/pXnMwoQOs4BBuLYowzGEDaiAsQDUnu2CPi9zKXWNaxDODmmeLK51XNwcM7MYbJpXaotpAd6DBDQbs6+sZNXFipo8hj5k4RXV7lCTrE+BPH7xKXK2pIAOCnHkgyFcp7fqm4DtfFlavVip5LnnDIIz0VhC2e1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4206cfbe-81fe-4cb7-089b-08dad2b9f842
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 10:02:20.2049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YCs/DtsixwRqMBYW25+NAKR0SocugenR4zi6TwcU+tV/sTt4PW8cqqksMuvrrTDbKMxrd2eC+2TKH7k5HSYqTMlRdG2OiDv5IUggbcKRFow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8243
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMzAuMTEuMjIgMTE6MDEsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBPbiBXZWQsIE5v
diAzMCwgMjAyMiBhdCAwNjo1OTo0M1BNICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToNCj4+
IFdoeSBub3QgZHJpdmVycy9zY3NpL3NkX3RyYWNlLmggPyBUaGF0IHdvdWxkIHdvcmsgdG9vLCBu
byA/DQo+IA0KPiBZZXMsIHRoYXQncyBhbHNvIHdoYXQgSSBzdWdnZXN0ZWQgcHJldmlvdXNseS4N
Cj4gDQoNCkJ1dCB3aGF0J3MgdGhlIHJlYXNvbmluZyBiZWhpbmQgaXQ/IEFsbCBvdGhlciB0cmFj
ZSBldmVudHMNCmFyZSBpbiBpbmNsdWRlL3RyYWNlL2V2ZW50cy8uDQo=
