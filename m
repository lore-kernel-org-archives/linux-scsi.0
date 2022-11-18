Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5398C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 08:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbiKRIce (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 03:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241404AbiKRIcP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 03:32:15 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C267BE9
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 00:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668760291; x=1700296291;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WJOKAj6aQrJ5wexvY9Yq9SWqfZivQFp69GIPWhPus9g=;
  b=BvosCLjksJewpViQUUMO9J/YxEVHStDfoc3GCtTbzSaf2lvr7dxIRtS+
   DqrQlR6+74l9IG/vixcO7RzCcS06r4dmBfvOQP1Y4izkb5JSCYctjxhVZ
   0h+o+fNVefa438BxK4R/F0iHjyuCOX8BgRBl6Mxr8u22++8vkn7X2AGOT
   5pjjqwBst3Me5/MJWgQDf5t1NFrsmsj6OaEzLUYGmNuEtBKsdo+ui9TfX
   4ypYaq63QHLsvwE9pqQhonQLimH41C2AgPabSwQ+ZPjOwlBwBeW1xJ2z9
   Uq89E9dpTvQ4SKleKXD2+92I3/uAiQJnmzSZ6OGaGisfLccNU049NJgj1
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,173,1665417600"; 
   d="scan'208";a="320937485"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2022 16:31:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlRR6I0zClEBkSKFb4kW6hAF101EWFCJKeALG6FYQ+3KVYydyLexP1zUiOOzDL+Ri5CbeHXqQ6eEOpuRK0/ShSG4UTJhNio57nty/ArPG75p5CwE5UzuogAhuEApiGuiyUGOPth2YOQ/H0E+mCk4XbGCfQbt8fUndXAYyYiWVTSo6IFnlmwAR9hE44nZc1NPWmmOA62UVDxM5C/DkNtqvZBl1Xj5SUBGHYrKYSxGN/puPL9mCLmxW0o5DjvqYK0xZAMVKpdKZtSs4tVMlhegzb2H0/DhklgSOWfzagM3CCnNQrfrLrlIZeC3+p3Qr3UNLiIRnR7GKKMWHhX32SibjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJOKAj6aQrJ5wexvY9Yq9SWqfZivQFp69GIPWhPus9g=;
 b=Kllx1bQChil21dfPdxVSwq//4BeMjpz1uIJTXrUNaELGRzVPvYwumBPBp1fplmcm5giap54xQRZhMhpF/Ts7yr4GsEMSYVaBsxF3JwgZqKHlZgVXokp/6ysTGawbEbQTAyG9p04iCIS2ZYkoK34Ao7XEAavSLFB6buKNyil3T8PeV525vSJ7PPJXuEfr/x9AV3A9O2KX5c+KdZOG0jx0lFfxra4brRKKI8STHv50wKtETOpIUfw1BfO1ibPv81/MqOhICxA9NRE/Pno9Mg1BU4Ul3z3yO/E3knisTaSDldJX4RnqG3HyIGsmBp80B+ZrTXC4ZGb5cSNTQ+Pgg5q0Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJOKAj6aQrJ5wexvY9Yq9SWqfZivQFp69GIPWhPus9g=;
 b=HODbnfxO0JGqJ0AqS6z2fZDBVXaN6/aMcDAlDmOCq1RelDEBAYV/9vq345K7Lbt2MjIrj23DtIus86MuAsAIpVDHFEVj5svUvUfKPAybMr42kxcA50T7O2eJo1ldpZhqkg5GzL9O9hB/Qz+Q7i1S6zITkVYP2XY6biYWlVYutnc=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MW4PR04MB7425.namprd04.prod.outlook.com (2603:10b6:303:78::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 08:31:26 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f4cd:7c80:5642:bf1a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f4cd:7c80:5642:bf1a%7]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 08:31:26 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     kernel test robot <lkp@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] scsi: sd_zbc: trace zone append emulation
Thread-Topic: [PATCH v2] scsi: sd_zbc: trace zone append emulation
Thread-Index: AQHY+CDXCOC0I4eZpUuWZjylU2pizK4/dVyAgATqrIA=
Date:   Fri, 18 Nov 2022 08:31:26 +0000
Message-ID: <7c758dc6-692c-3aeb-a0de-05e4134f839f@wdc.com>
References: <6a21e78a188e5a0d630acd771afee11c7d45d183.1668427228.git.johannes.thumshirn@wdc.com>
 <202211151344.VGP4HoGU-lkp@intel.com>
In-Reply-To: <202211151344.VGP4HoGU-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|MW4PR04MB7425:EE_
x-ms-office365-filtering-correlation-id: 409520f7-7c8c-47de-a19f-08dac93f4863
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U6Q+W+l7SqW1t5MsvwxmjcUerdHmPspOiZNdUNycvXve9kHEHMSFhgkqF5MQpp1y9elg1snUOthvPaSSotTernCkdgM9v65Zrm6S1sK8/lbcjTr2P8TgnMe2i9AuYHW7C52ZErOR1bxqMT/H3eXs9RS4RZgusAVVR0/rwvRmilrR/SC3rGutOzHuKAfT3XTyFYMCO/8PslEG2STvr7/HLX/YrY1psP0o9OdJdE8MvPBlKMrxS4n9QMC4Jta0e/HrIQ15biwWQdF1SNlzCtZZrmKmo8gX2r7AHS4oJu9d469EFk7msJmsQHpXDUi7tPV94HoGAlDMQfiXlOPt71O7eMKqC8edoA+K7VLf7coKWlMn2hREn1GkK6f/4recQCz6lVHgo9xynAjv6CcBNRWYzH8eW2qTjdOkGhd6VYIVrC+D/UG12K/2iM6dG7a8d6rDHId0HGj3Nl5GrAgVUWQusVAlZxxwDyGonIo196n2rCARLsuLM5yYMqUf6hMrH2nlofD6TlH9GG/EaMvoMePB3Erw8Oxz9BWkXjDyxeULnFm1stTA2uzyoF0NVwNO+POvbZP4z1oyHhqlenJ37SgkWR1+OHwfAGRPsqSGMeF02veH2a3BO90idWQ/1nVmZqK6o+8Wem9+aObVnR49QNm4Fii/3R/hsY5DNPXDOGLihLGw7qWXv+e7aNqfN1X8bR8ViXG8u5yhxtWeJKO5nAe0OJvHDI2d4L8gVPyHdmrzKcSzbVuB7s1q37wG3OjHhIJLTl+kVjZOG4nrUcYbPsbk/CJkYSgjY7HSZSHdJMpgIkwEnMXe29rn6TStfuFcGhoXEJrY5si6fV9S6XcYgJzVTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199015)(2906002)(31686004)(83380400001)(36756003)(2616005)(76116006)(31696002)(86362001)(66476007)(6506007)(186003)(38100700002)(53546011)(6512007)(110136005)(54906003)(38070700005)(82960400001)(122000001)(8936002)(41300700001)(5660300002)(8676002)(64756008)(4326008)(66556008)(66946007)(66446008)(91956017)(966005)(316002)(71200400001)(6486002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFpFRVUxbWl3RWdSbmx6MUZFODdMZ05uaHQwZnc1UGZidGNJM0dTQzNzQzlJ?=
 =?utf-8?B?M0pVamc1cXhuMmQ0ZmpxUWVkQnZPci91WVNmdFdOdlE5QU1wZFIxU0pUYjNX?=
 =?utf-8?B?VjJoKzJZcEV4M1RYL2FVUkRQa2pKUmhOblRWdHB0d3hEcXB4bkxoSUNlTDhX?=
 =?utf-8?B?Wk1oNHljeVhvdHVZTjFIR2tpL1AyUjJJMiszRTZrS1dYUUk1NGZnVzh5UUxB?=
 =?utf-8?B?S0QxaFdEaDVGUUp6UWN3bkNyQ1RuQ0srcm1HdllHNitGVW5xUW4zYXpPem0r?=
 =?utf-8?B?Q3VJblFCWjBoaWdSaVVYWnBzWTBTWG8rdkJHQmVJc0R6Y05pdXZSSW95WTlC?=
 =?utf-8?B?N1ROcEJ6eERORHBMazA4em5MTENoSU9ON3pTTlV3OUhXUnR4SnVMRlFZZ1g0?=
 =?utf-8?B?S3VjTU1HVE5qVFpYd25TdVRteGlPNEFjaEhLQUZOMmhJcDJidk9mdVlZWkdh?=
 =?utf-8?B?dVl3bkY2c0xWQXpWSWJhZEJYRFVZemRaOUZEclFHMVhSeWU4aEZDbTNFZ2wy?=
 =?utf-8?B?Y2pFU1ZDVDF3SGNMOTh3cDNEOUc5TDM4UVFnZERQbDEzUFRVbkI0WkJRUXNt?=
 =?utf-8?B?akR1R2FMazdyL0dZNXhqZTQvUEdQbFRONmpscThwU2ptQXAzSzBIOUMwcFNl?=
 =?utf-8?B?NzJpTjhJUkF6Zm40Q1YwWTF6cnZWeEt0cEFMZ2JJVEFmY3NVQmdXN0pjd081?=
 =?utf-8?B?WTZYOEU5WHhIb2U4TUh3OGxSUU1XUmM2UmNZWktIcUNHQWJWV3djUmJ5UEZW?=
 =?utf-8?B?OUtLQlljRjN1Q0RkSTg5Ry8ycG9vQ0EzTE5Cb1dlWmNIYTBkWGY0SXZLbGRQ?=
 =?utf-8?B?RGVXZk56UmlSVVdiemdQdys0M0xaa0dkQ2RZTDgrT3NIYkpKR0ZEMFhtQnUr?=
 =?utf-8?B?Q1crOWQxZEEva1h6MEZTODBoTW9MOHROR2c2bDR1enV0TkRmK3NMV3RSYjF4?=
 =?utf-8?B?a3RXWmpLL2htNmFiUEQzSmlneUdZQ2s0eTZkbnVuYkZxNThXQThkOW5XUUdy?=
 =?utf-8?B?aDJ0UHcveWVDeUxCbzRZR0N2QXlhK1BHbUlGbWU5eEFrWm41cGJBa2xCaEpQ?=
 =?utf-8?B?WittVHlxTUgyd1g1QitSS29LRm5UQ0JhMmFXdHF6MmhZenZadFVURnZjNDIv?=
 =?utf-8?B?bjY3VUhlMkhCNTI4cXNLWnR5aVRjS3drbTg3MTVjRW1uaXhDUnRCa1FraDRP?=
 =?utf-8?B?dS9KQURzV2lCZFdoR2x0R0RYUUEwb2Rkb3BiSDZIanhRb3dsNE5xNmRVWEo4?=
 =?utf-8?B?NGs4SDNtMUNTN1RELzRuOVdvRno5QVFtYjNhUnlyNDMxalN2anAwTnJhZ2x4?=
 =?utf-8?B?VkR2eWVlZjZIUFp3NDJKNzhqb09ITHZUL2pNbE4vVmFZMVMxbUdSWEZSZ1Rz?=
 =?utf-8?B?Rnd3akR2T25RZzNWaE5ZbktzQ1ZTZ1J4KzRnMTJTTmx5OU05NnkrREkwd1dC?=
 =?utf-8?B?d3lqTWlGajY3TFF2UWRlMXlKeTVvVStNZjVmWDhWWUdYSjhSemdoWW5LUi9k?=
 =?utf-8?B?UTRlampXamtqeGxsbDBpbGtqRG8rVFhVT1JweVhjaVNMQlBtRGVoVjJyajJk?=
 =?utf-8?B?Skh1MDJiazdhUExWVlY5N0VObXFUTmExTHBLQlRnd0hBRndkc1FJMjQwOHFW?=
 =?utf-8?B?ZjhDbXI5eHRNQm0wOEJwZldEalZyN3VHMEdVS1lUSkErU1Q5MzJNNzY0aXZQ?=
 =?utf-8?B?cnJtYkEvOThzU0lqVy9ubndFVlRHRVRuYUdtTmdVUzVQWWdXM0hoblZ2dVll?=
 =?utf-8?B?SGpVeEZYalhRRGlTdUlHQi93UGNKSU9zNExlS2daQUh5Z2VjaXlKRGxhWmJy?=
 =?utf-8?B?RWpLa24xZUJ3UUFBTTJ3ZUJ0WXVvOWRveisyVjVsZWtEU0s1cnZ3dlkxSGxz?=
 =?utf-8?B?SndmWVU1Rkg0UHRlRldVYXlrTkdDN0FHMGxFMnRqVEhCNDlwbnExNU1vcmtM?=
 =?utf-8?B?Nk5Cb1FrR2Z2eFBQOU9heWRFYm5SbUxyb3dZc2FLV01PeDBMaUVqcXlCTFZn?=
 =?utf-8?B?bEMyd01QR3h2eXZJa1JMcDM1dnc5cEdxR01VTGdxQ0UyVzN6YUNGZllMcmJt?=
 =?utf-8?B?VmFHdHkzd2xMb3FIbUZOMVpDM09nOWt6S2ZISG9Wc1NYc29qaUFTM3IyaTBo?=
 =?utf-8?B?WGozZCtoZHBjdWJRUmxWUUhtSVltVnFvYVpnS1AvRmk0d1p5djVrWE9KWmNs?=
 =?utf-8?B?dzdEWmd4a2UvR3RtLzJWR2MrVnljdzBqdDlqREpTSk5FYkxuWk1DVkVMQkxV?=
 =?utf-8?Q?oBA8x0bp/NqiLQAMdMFuFRSWzBBX2EqY1CfcirR+iQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBD12DAFD9A70040930C899785C66CC7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: BING9OpOyvPG8dPdkV+LeG3D0wcW0Ffsna6cBgTaWB/m5xVRRfnwgEPhM+kvN/PQHvFWPlV7GY36JbQWy+OopV9XX3SzbCh4OURF4XiDJN5Lfh+h18aRENWbJbn3bmpMuuCNqJyf8U6hR+/uX7KjvUvGoTmbE0VqHKtrySGdIWEMJGEuYALw8a4mefbRejRqIIzGg6/SwePFJHnEHr49QEebDeY+T8qBtyK2uWbpLRYJf7o8tKwEAkh26qtCRqXWscgnufkXB4+XyOAgwIhDm8hOwiPOv0Cy5g/j988WT7h1bBgMxQCzY73Jy86DY27NvNwRyMyV5DSbjrZxwKjo/uqnADizuJrnYkiu7zJX2I852GY542iw9UT7Rk9KAO5qiHpDig+XlfYKk5phUj6v85k5XJcbWMDX1had7XF4nl5urMruUL1bFcFWjcs9YJYmLe0M8Noakshabir04O8uXEuhx6XtmlEA4+F6vvGQHClx5qygLLxA7A/zBaz5qYZR82clMNRqkQAT7fEEhjz1yVahWs1IZmk4gaXYE6iJzYkYirIKKWtY4L14HS16XTcv0InWwoTw8bwEVtEsmptEEU6uo1H/31YR4bsjhe02c1XFON0rRcJvquBuKz9103sFvPjqguXZgnwgTNx4ufB70nIgHWhM2MYvxxadKqAVWS7UEvZJP/W8XXFWC97GgAsai7ATynpbhJeVeC32Zmcf63HWkdQEYN3lngTqlzww7GtmCV85WXnEU2YdIQ0ztMW3V+9/nsrPngYJSX+XiTFHu+YbdY/ebu6LtC8BF9ZhxYPtiRuEgzwpMdz/N0ygAuJOfDlJ3O42YwwXZSabx0F2rueFc3lTTMENfHwX9njhIaw0PhJT+o9wzMcqaGXO4w9hpfjAU1Bd2hSiYZd8vnrexQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409520f7-7c8c-47de-a19f-08dac93f4863
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 08:31:26.0801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pb5+H7xQ6BV0xA6ktvmuYtThUauu3xLnn6+f7b8GYMjjFFFRWIpbGmt0IvBPlUUeEy1Lotc9QSfLKSCt7ixXJcYKMYtMYRXJdZgS+hslTeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7425
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTUuMTEuMjIgMDY6MjcsIGtlcm5lbCB0ZXN0IHJvYm90IHdyb3RlOg0KPiBIaSBKb2hhbm5l
cywNCj4gDQo+IEkgbG92ZSB5b3VyIHBhdGNoISBZZXQgc29tZXRoaW5nIHRvIGltcHJvdmU6DQo+
IA0KPiBbYXV0byBidWlsZCB0ZXN0IEVSUk9SIG9uIG1rcC1zY3NpL2Zvci1uZXh0XQ0KPiBbYWxz
byBidWlsZCB0ZXN0IEVSUk9SIG9uIGplamItc2NzaS9mb3ItbmV4dCBsaW51cy9tYXN0ZXIgdjYu
MS1yYzUgbmV4dC0yMDIyMTExNF0NCj4gW0lmIHlvdXIgcGF0Y2ggaXMgYXBwbGllZCB0byB0aGUg
d3JvbmcgZ2l0IHRyZWUsIGtpbmRseSBkcm9wIHVzIGEgbm90ZS4NCj4gQW5kIHdoZW4gc3VibWl0
dGluZyBwYXRjaCwgd2Ugc3VnZ2VzdCB0byB1c2UgJy0tYmFzZScgYXMgZG9jdW1lbnRlZCBpbg0K
PiBodHRwczovL2dpdC1zY20uY29tL2RvY3MvZ2l0LWZvcm1hdC1wYXRjaCNfYmFzZV90cmVlX2lu
Zm9ybWF0aW9uXQ0KPiANCj4gdXJsOiAgICBodHRwczovL2dpdGh1Yi5jb20vaW50ZWwtbGFiLWxr
cC9saW51eC9jb21taXRzL0pvaGFubmVzLVRodW1zaGlybi9zY3NpLXNkX3piYy10cmFjZS16b25l
LWFwcGVuZC1lbXVsYXRpb24vMjAyMjExMTQtMjAwNDI0DQo+IGJhc2U6ICAgaHR0cHM6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbWtwL3Njc2kuZ2l0IGZvci1uZXh0
DQo+IHBhdGNoIGxpbms6ICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvNmEyMWU3OGExODhl
NWEwZDYzMGFjZDc3MWFmZWUxMWM3ZDQ1ZDE4My4xNjY4NDI3MjI4LmdpdC5qb2hhbm5lcy50aHVt
c2hpcm4lNDB3ZGMuY29tDQo+IHBhdGNoIHN1YmplY3Q6IFtQQVRDSCB2Ml0gc2NzaTogc2RfemJj
OiB0cmFjZSB6b25lIGFwcGVuZCBlbXVsYXRpb24NCj4gY29uZmlnOiB4ODZfNjQtcmhlbC04LjMt
ZnVuYw0KPiBjb21waWxlcjogZ2NjLTExIChEZWJpYW4gMTEuMy4wLTgpIDExLjMuMA0KPiByZXBy
b2R1Y2UgKHRoaXMgaXMgYSBXPTEgYnVpbGQpOg0KPiAgICAgICAgICMgaHR0cHM6Ly9naXRodWIu
Y29tL2ludGVsLWxhYi1sa3AvbGludXgvY29tbWl0LzdiYjQwYmE0MzEwNzNhMjgzYzFkYjY2OWFl
ZTQxNDIwNDVkZDA5NzYNCj4gICAgICAgICBnaXQgcmVtb3RlIGFkZCBsaW51eC1yZXZpZXcgaHR0
cHM6Ly9naXRodWIuY29tL2ludGVsLWxhYi1sa3AvbGludXgNCj4gICAgICAgICBnaXQgZmV0Y2gg
LS1uby10YWdzIGxpbnV4LXJldmlldyBKb2hhbm5lcy1UaHVtc2hpcm4vc2NzaS1zZF96YmMtdHJh
Y2Utem9uZS1hcHBlbmQtZW11bGF0aW9uLzIwMjIxMTE0LTIwMDQyNA0KPiAgICAgICAgIGdpdCBj
aGVja291dCA3YmI0MGJhNDMxMDczYTI4M2MxZGI2NjlhZWU0MTQyMDQ1ZGQwOTc2DQo+ICAgICAg
ICAgIyBzYXZlIHRoZSBjb25maWcgZmlsZQ0KPiAgICAgICAgIG1rZGlyIGJ1aWxkX2RpciAmJiBj
cCBjb25maWcgYnVpbGRfZGlyLy5jb25maWcNCj4gICAgICAgICBtYWtlIFc9MSBPPWJ1aWxkX2Rp
ciBBUkNIPXg4Nl82NCBTSEVMTD0vYmluL2Jhc2gNCj4gDQo+IElmIHlvdSBmaXggdGhlIGlzc3Vl
LCBraW5kbHkgYWRkIGZvbGxvd2luZyB0YWcgd2hlcmUgYXBwbGljYWJsZQ0KPiB8IFJlcG9ydGVk
LWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4gDQo+IEFsbCBlcnJvcnMg
KG5ldyBvbmVzIHByZWZpeGVkIGJ5ID4+LCBvbGQgb25lcyBwcmVmaXhlZCBieSA8PCk6DQo+IA0K
Pj4+IEVSUk9SOiBtb2Rwb3N0OiAiX190cmFjZXBvaW50X3Njc2lfcHJlcGFyZV96b25lX2FwcGVu
ZCIgW2RyaXZlcnMvc2NzaS9zZF9tb2Qua29dIHVuZGVmaW5lZCENCj4+PiBFUlJPUjogbW9kcG9z
dDogIl9fU0NLX190cF9mdW5jX3Njc2lfcHJlcGFyZV96b25lX2FwcGVuZCIgW2RyaXZlcnMvc2Nz
aS9zZF9tb2Qua29dIHVuZGVmaW5lZCENCj4+PiBFUlJPUjogbW9kcG9zdDogIl9fU0NLX190cF9m
dW5jX3Njc2lfem9uZV93cF91cGRhdGUiIFtkcml2ZXJzL3Njc2kvc2RfbW9kLmtvXSB1bmRlZmlu
ZWQhDQo+Pj4gRVJST1I6IG1vZHBvc3Q6ICJfX1NDVF9fdHBfZnVuY19zY3NpX3pvbmVfd3BfdXBk
YXRlIiBbZHJpdmVycy9zY3NpL3NkX21vZC5rb10gdW5kZWZpbmVkIQ0KPj4+IEVSUk9SOiBtb2Rw
b3N0OiAiX190cmFjZXBvaW50X3Njc2lfem9uZV93cF91cGRhdGUiIFtkcml2ZXJzL3Njc2kvc2Rf
bW9kLmtvXSB1bmRlZmluZWQhDQo+Pj4gRVJST1I6IG1vZHBvc3Q6ICJfX1NDVF9fdHBfZnVuY19z
Y3NpX3ByZXBhcmVfem9uZV9hcHBlbmQiIFtkcml2ZXJzL3Njc2kvc2RfbW9kLmtvXSB1bmRlZmlu
ZWQhDQo+IA0KDQpJIGhhdmUgbm8gY2x1ZSB3aGF0IG1vZHBvc3QgaXMgdHJ5aW5nIHRvIHRlbGwg
bWUgaGVyZS4gVGhlc2UgdHJhY2Vwb2ludHMgYXJlbid0DQppbiBhbnkgd2F5IGRpZmZlcmVudCB0
byB0aGUgb3RoZXIgdHJhY2Vwb2ludHMgaW4gU0NTSS4NCg==
