Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41203C352A1
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 10:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiK3KJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiK3KJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 05:09:34 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490FC27CE6
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 02:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669802973; x=1701338973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mLuM2mQVF09He8sWYi+slT4B/0M58Ca1DKl8rZuhVGs=;
  b=Q7PUMsjXPhgpSocDklx8rgeiRmB+sxPkpKhhkxXPcNbX1ShqmsjLn0am
   gvp4tvjAkCNXw0eQddCD8XoJaVlYqnlPsjk4XZfS/CeQITFkO9m4n7Eht
   Oz2SD47ptaxPnbTEAaVC2u6sQtZIFSETzHKABo304+k658V1v1GmxcHvE
   d1j63Z0UbvXZnSAcNETxnV3MI5N3LAYaPhsX39WMzgLVOW/o9WHm8VI3k
   HCO1JUZ52iVSKfUSbWNJyuhTqchtpl5EfSkbe9I3llHM63RGnEy7n4VcX
   rCdtz6vBZx9awS3dpGDuly8tkSictpOHxPJFCB1RrEGc1NdE9Jrwr7n+1
   A==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665417600"; 
   d="scan'208";a="217539407"
Received: from mail-dm3nam02lp2045.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.45])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2022 18:09:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbObznjpV4OrzJzMAR6slA0xREDV6eAS3/fkBOw7wiu2X7vFucQnOy/H0g9zxhI6HTl0ucfPX7ZZ8NfbsN+CRO6HHoq4MX1SBVpkvGa2Dc9GRJFYgTc1z3meFPzvam5SRuYn+44zP3kqBc6Q4q5UME37JWoV/O6VTaOgaZ6KqZjJGOpf9dioNcI9sgbEoZT9cnvcwhzxiHIiePZ2HhLlKn5RTy99nyFhMkpI4BUr0cuqvjFZdqBSlEj/pDCqAVg9cLrfE4S5OFr8VtP2K8eidZQ8QLyjO4Mq/CGwZQ6ce1Dt6UzhVlJoSiWdjdmW93SH22+TFw7JAwUFVqPgAeyB5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLuM2mQVF09He8sWYi+slT4B/0M58Ca1DKl8rZuhVGs=;
 b=Uaa6W1zi8h3XK7xca9XjF6FaJOs+pbiPBBuiD6HivkMREEr9HMMJ0Zw0yyzAInGQkmevTe/YTwTeDUSq93ZJ2M3bLoBvsR9VetN8wOWk2Z5AW0Lntr7owgZ9MAWB731cOwpBWWy84WWq/t8zJx50Jj45r7lp5uNrjtfnvs84VxBazPpoEvEhB1237V5HnWAbEBf43SYjQmpTF2p18yM3KBKB/K9SJuPreeYL4ou8ZQsvHRJMMaJYnYGls3DQMLLjUsc0PYwP7d8dZCdSz6NkEE/4sW8FVD5NeVeaQ6IUmp/BESVB4xG++oby9J/yjO2/b+G9nhBDhFb/ox+Ui77Pjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLuM2mQVF09He8sWYi+slT4B/0M58Ca1DKl8rZuhVGs=;
 b=yt1Zr8KCqZBFYvyDr61TlgLcYgjs6Xp+e+jZKT2oR6GuDs4JPDzz/Znpg2evTau/TMWFO4NnIW5NWO64vvb7X5H8F0a1Wa8fixOjcIPM0JD+DCNXdmIkCvgMSNSX54p0VG9s5w1k/0MjqQUCmVnxqXf9vx/O/K0ihliJXZseDDM=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB6397.namprd04.prod.outlook.com (2603:10b6:208:1ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 10:09:29 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81b2:90e4:d6ec:d0c6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81b2:90e4:d6ec:d0c6%4]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 10:09:29 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Thread-Topic: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Thread-Index: AQHZBJdIwi0ipPRZEki0DoidGKrtk65XO8GAgAAAZ4CAAABTgIAAAF4AgAABo4A=
Date:   Wed, 30 Nov 2022 10:09:29 +0000
Message-ID: <5f43d97b-dd9c-2c0a-506f-180e7bc2d83c@wdc.com>
References: <39540065afb936255236311fc6c93f67a7805bf6.1669797508.git.johannes.thumshirn@wdc.com>
 <a60e44ec-a262-d668-4410-60518091f514@opensource.wdc.com>
 <Y4cp5S4AWV7+Sw3T@infradead.org>
 <e918ff92-4b39-3a4e-21b9-2d6408873161@wdc.com>
 <Y4cqegAv4SlFq6ci@infradead.org>
In-Reply-To: <Y4cqegAv4SlFq6ci@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|MN2PR04MB6397:EE_
x-ms-office365-filtering-correlation-id: 2d48e1db-8060-42dc-26da-08dad2baf847
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: th8JMeLt/ysiRyeQRDs+5SLKxWfDtaIQ6Rgnnm27PiulH4RT+bQpe0DHcln2j3Ygvmv0kXiKGL1Vx6+BnDso/8bb6d9YcNfF+/cKYtdqzwymJ02xrZyrRUSGSzfyt5x0OqpMSt8TOTnmPdOsnUcMqZ5XB+h6smQB9h5pdPFfGyLDl7w23G1FZ7rOUJJVOdjiMxdwIYXLexV1uoQiJcCHXnb2eDGnOEJ6fxKGu0VkrOnjgDHI7vJ5d2xvnV//VqDOXd83RH+f2B7d9IQ8y1x+coRwCWeXSCn6RFeumd4Oq0l+UFHVV1NYvHIC5b4heO7BHsKdGeg7TBaWV1ItVmSd7zDXLSEcJNBzDccrs8nBCvc7LO9fo5rNS2tHlKI57yduVyxP4/seISCHDhS31Ob/4BFWJJpccxHEL7yBgsVilEVXX+UXe/1B1lq8h3CveQ6ig1LzxSiROu01Dbsfj0CAYV5Rt9XcRBbcsog8XHw1OxEmeJnYG1J5OvK//CCabrJCTt6oiEeGjImcrCMpFKlPdVyHT1JNhBO0HbFMs7cSQjfnSqv6OfGXpYUNPUir8btaPPZQbgpIhY0j0ZVxonzMqWW+vVLZdJw0OGWbU9hG07zXlRH/b4ve1kbcD3EHAAi4h1R9iflCqgDPBSl7hsgktryvWu7IAfpp4v0O1g4YYiM2BQyZOGhci6q68kvxN3bFIbJPnyjZg68eXp9vT1lQtFPmbQR2cvcyhG/mdQGTp8VWkzDpAirTlYxeOSLU4BtUcwX1ANxa5IWXvbT5/vUuAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(451199015)(122000001)(36756003)(31686004)(2906002)(38070700005)(41300700001)(82960400001)(4744005)(38100700002)(76116006)(31696002)(86362001)(64756008)(66476007)(6916009)(66946007)(71200400001)(91956017)(66446008)(54906003)(6486002)(316002)(8676002)(2616005)(478600001)(4326008)(8936002)(53546011)(5660300002)(26005)(66556008)(6512007)(186003)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHh1b1Q1THRyNWN0T0h5Q05ZYUd5SWszMGFCY0FRNysrclVvTTlLV2lNYXRE?=
 =?utf-8?B?QzJudkdKQmRjUHVMVEh1WU85NmpVU3BBdGdGbVU2L25qY1IxOUZkTkJJVFZM?=
 =?utf-8?B?QWVmUTVwRS81NDdqU0c3M2ZmSmVuYnBHVk9UczNMcHBLMXpOaktNaUlDcGVy?=
 =?utf-8?B?QTZudUNFWFZrNTNYazh2bXQ2MEtKM0lkWXlYT1JxUDd6bURQVXVSYVJtdnVO?=
 =?utf-8?B?ODdhYUtyM2NuSFpLenlpbEJEZXJ1N0ZWUm1pempxUERrM2xrM1IzTVZIMERD?=
 =?utf-8?B?cTE4NVM5U3hZaVltMjlNQmJIUDZGYUI3V2FtYTQ0TnFPc3p0RXFwYmtld2Mw?=
 =?utf-8?B?RFJucVNvVitmdHNNVVo4VGJDN1hDbmVNL0k5WVpsb3plMkp0WEFEUWJsNzZy?=
 =?utf-8?B?NU5kZnd1UGYxcHhRUkhtdERyNnZabUFEaWVWQTBHVnhiKzZBSUFMUnVGbUlw?=
 =?utf-8?B?Yk5oWGo3VXNFZnkxc1ZQVXVtMy9hRUhrVksxVTEzUm8xWE5HYVJ3NG9uRWYy?=
 =?utf-8?B?d1h0NXJBdE54ZFA5Um0rTnl6SnVKbnFyeHlVdFNtdkxyRGQyM3JrcG80T0h0?=
 =?utf-8?B?cmR3WUVQS3ZkNWZhZVRyRG5DNThib0pteXpKYzdOZmNSTnVOdGRzMENSN1U4?=
 =?utf-8?B?ZHI2TXdxb3hOR0JtS0NqNE1ZazE5WFV2dFAwaFBzVFIwM2dEemt0Z2hyZnp0?=
 =?utf-8?B?Zzhva3Y3Z3pxR1h5YXU4ZXl4RlhmNkpwRTFHTTV5ZllQMWhJbmxkRWNrVWlQ?=
 =?utf-8?B?YjN4OG1sUjhKY0VVWnZlTk9CaSs4cmNKVUh1OHZEV0RBeVdNb2JSMVV6WWwx?=
 =?utf-8?B?aFRtVWYxUnhlRmlJTFFNcHJnRUxVaTkxQXZuMHl0OVdFVnVNV3d6U2xlK0dT?=
 =?utf-8?B?VmZpWmY3bXR0M0FTcm8xOGU5SmJZZTQrdFpDNGxSUmgvT2pIMVg3eC9iYUhF?=
 =?utf-8?B?VUtCM1g0aFZsQk05Mm03SFI4a2N2Yit0OEJXa3BwUEpvalhTdjcvNktUaEtX?=
 =?utf-8?B?S1QyMVJHcmF5YzhzcjdGem5HeDNWNXZmalNTcnI5QUgxYjFSV2ZHWjRJLzN0?=
 =?utf-8?B?Z3lSNWpMQzcwSmM1ZmJDRUVFK0R1djgrUmsrd2VyeGMvdk9KK1plU1dKd0tX?=
 =?utf-8?B?dFVqSDRUYkZkOHpUNURKeG1KQ0JkOG1sUk1aVzZqVVpPa2YzWlVjRjdZR3kw?=
 =?utf-8?B?UFdtSjhGRVh5ZVFhVm1pUzBRM2RMOWhmeWVZdmtuSnFhbmRUZll0Qk1lZG5Q?=
 =?utf-8?B?ZkZFdks3d2kvMEE5SVI5RHNVeFNFMkhkNkxENlZYTWx1MGJaT2V1V21HdHZW?=
 =?utf-8?B?TjZINTNYN1QyK1VKSlk0UnZiVjNZdXR4U3dIbDUvK2gyelpCeGF0ejIyalRC?=
 =?utf-8?B?cUsybE9SOHNSUjlpTGZBWWpZWkRXSWdnOVpuUHhEdVJQTTd3OThuMlRuaDVU?=
 =?utf-8?B?VDQwa3dOUjUyVGtqV3FzanpMSCs4eWpKM1R2MGU1S3hmRXo3dlZhNUVraHZ2?=
 =?utf-8?B?UnF3QkFzbnNxelZNTWFTRGpRa0RpUHNYTnoybFJFYXJLODFnL1c1WTh6c2tj?=
 =?utf-8?B?RFprQUN5SURIZFYxcFFhWkVvQUc1SnJUcm9vOERqbWhyTWdoYnErVjdYdlVx?=
 =?utf-8?B?SWhEUk5HWW9tUmVEaFFvZDBjTVBDS1JKb1psZmhNVytQZHpxelpYQUtqWTZ5?=
 =?utf-8?B?dXYvS2pXTlFFUklWRjhiQ1ppWnVSQmkzSWhnSkh4TkZTWmt4QUlHN0JmVmM1?=
 =?utf-8?B?VE1IaWt2bnZhZ3lDVjBaUUlzZzlOZ0U3MkExL0ZISkZtNitwQlE4N2Jta2dt?=
 =?utf-8?B?WmxXNDlocnExRXNGSk9mdVRKVzVPQlhZc0JVcC8xVHJqSTB5QjhxVmFSZXdr?=
 =?utf-8?B?dEVEU3RoQUt3dTBqa3pnOTVwU0hsUFhScWtzNkUvajg0bzFrQmp0dFpnVGJh?=
 =?utf-8?B?UUYxQ2EzZ3l1dlo1YTZ4ayszZWlQYVVJVzY3RHh0QlJuc3NCTzk4ZkZ0U0dQ?=
 =?utf-8?B?L29seVIzeXFNU1ZxK1pQZExPNU1tdGNQalBMcUpGaFg1VXpkQ3ZWVE5LcFFk?=
 =?utf-8?B?WmR3TXB2SWNBL05aZ0dwRHRhMStvZGxYS1YzR0tLL0pZeG00NUpUUGlBalVP?=
 =?utf-8?B?eXRwMUZISVp0LzM5TVpKak1kZW5UYTVnMXorUUZPTkp1SEdKUW14ejkvdEhP?=
 =?utf-8?Q?RJlt/cM/s3D1aLaCmkzUwFc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <30C690421DB78446841EA9D69F017742@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3RoteJGtP291MWeHOAwSSYYhgTw4HmbWd0Q/d+aEfr6/Xu8n7UacK8UQATkFOQmKPSExq+tJPGiW9hREDHYikbRY3GLdBE5CQ7t/Ps4MfBq9aQ+d0lROeHxIZWUM4XyckRdr+fyApnAR0QRIDfJC/sjUtGB2cOwUOt8afVR9c+fZUooibwQlekcI6MsRcrNAi/YtJoh3xh4zWKmgr9ml/64+N4lt7pHdPZ+FP8AFxhBbFjGFbWgMlmiq2kdHIPBcmVdhGtzarv7PhaGhf4rLJ2rgNn8lx03vEpDavX4fIUFqLoGf+NvMlNN2SmX2lJoSXu5cNHUR/GOQ/pYVUyEEXxaNkl1ebfb0ZgGcYbw7Hq/7S+NeS0IR5uSiEoUhQXp1WRVryUbTQ8KDhP4IC/xgsAU7l2fijgEYVL3pdyi58Kwe+BWul9p8ign9UrDimjXqF+SXnkRMpXIijSzlu6TlEEvC5SoJFKMptimOQxTfg8x/XAdvTMJUStYh+k2zPJ0YLc16jraE28dU9jjJ5x/JJpY/tWGTUBGzo40WFmRK57qmXti5TMEXGCFX1Oxs2XeIEW5/04DQKEwKw6bFpi+cURXHcFo/LxgMWxImfvIhexgNc4Ut2ngMR/xXtGd5tfF42DfsSzsgDBwqfeOstFAAr4Plcb3lelU1s9vDiWI4GhCTrqpwyCY9Bj//AhC5M4Z09YERl+/ZWNjjxcFDacPZ+UjHAp/UhjcxV2/JtFFqHbi5sNUxuYO2KsNBso/4KyDlXPZrCOIZU8EJoHCAodi2ucfqCz89/yE9JYK1Wnh6uOYWib9kP6CptNg6QEDKn2dz/yTi2VU1hEXfMs4uUu6GxTwHBFvpf6SmfjrSpBsWYAsoBa5Dcv2Sz/w+22qffVFT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d48e1db-8060-42dc-26da-08dad2baf847
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 10:09:29.7352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0zGcWZww5m62w/x+EdD7/FLC/5A642PZGGLya6qc9CE3DbH8myJiBuxKFTOMTh0qlVHquzWe0G5l8bcwhMdCbvxOK9zv1DOJG/Jl6zVvXy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6397
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMzAuMTEuMjIgMTE6MDMsIGhjaEBpbmZyYWRlYWQub3JnIHdyb3RlOg0KPiBPbiBXZWQsIE5v
diAzMCwgMjAyMiBhdCAxMDowMjoyMEFNICswMDAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6
DQo+PiBCdXQgd2hhdCdzIHRoZSByZWFzb25pbmcgYmVoaW5kIGl0PyBBbGwgb3RoZXIgdHJhY2Ug
ZXZlbnRzDQo+PiBhcmUgaW4gaW5jbHVkZS90cmFjZS9ldmVudHMvLg0KPiANCj4gTm8sIHRoZXkg
YXJlbid0LiAgRG8gYSBxdWljayBncmVwIGZvciBUUkFDRV9TWVNURU0gdG8gc2hvdyB0aGV5IG1v
c3RseQ0KPiBhcmUgd2l0aCB0aGUgYWN0dWFsIGRyaXZlcnMgYW5kIHN1YnN5c3RlbXMuDQo+IA0K
DQpGb3Igc2NzaSBpdCBpcyBpbiBpbmNsdWRlL3RyYWNlL2V2ZW50cy9zY3NpLmgsIGJ1dCBpZiB5
b3Ugd2FudA0KSSdsbCBtb3ZlIGl0IHRvIGRyaXZlcnMvc2NzaS4NCg==
