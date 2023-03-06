Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797BFC6FD19
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 10:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCFKn5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 05:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjCFKnz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 05:43:55 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3DFE051
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 02:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678099434; x=1709635434;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=rF/3TTlWaR+ShW8OVBIulOWixcE8WNqMT3i2EjOBjMvrr+JyTPjXj7T4
   ILugvNRHLkKSj0x7QfHhQJ7mlF0b0u0cFlTWlaB6+GT9GiuHwiY84u9Kh
   Iu4+GrYCiwEmmphkCEYHB1uCYThx+8s3Ypnu/gptLcg5oIY4v5krAVKXL
   lp2QgACspIVxPJ2d9tyvLV9JTNE3WGGO91HWnYwkdEw50RhsmlNvNvuBo
   EhFNB2J3iAwgbMLqqxNQEmJiUfjxF8EdKf2BbNAf+Wn2Ym3lgotEk/91C
   O8MO6Pi/3FkvVuvWRzHzddI0KUvmEBwJfL8eD7RCjBIgboHJswFqJkDnq
   g==;
X-IronPort-AV: E=Sophos;i="5.98,236,1673884800"; 
   d="scan'208";a="223178513"
Received: from mail-bn1nam02lp2041.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.41])
  by ob1.hgst.iphmx.com with ESMTP; 06 Mar 2023 18:43:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtvCD4zk4qDX9OtUBpNBO6Pluwqr0EbCbf/Db7HnMv67dzf0V+gS2aflWIGTzzk9kuepZM5shL3ZxIKSGnB5zEtd12MrgCRnAaBQrjkK+p1IsQlPBYa7xeyMITP4YactiXjIUYhyWdCHiUJ27mlsXWBExv8g6feNqgH81MQ/3nztq5tMHSzz45YDz8U/uw2/oro4QN5H72oI5BX07P2qR0nzsw/iKkudO8E/dSaczp+y+guSpGH8h4kESzP7MJnC3ET/DySBDRd2Ew2sYZ1IqAt7BJOqVQ+3xjh+BtTSnKSgLnuJ6k4F/pcS8+spCnoniUQVLNNWS0yxaN3f8w4cVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=X7WhKzXzd5xmLel18IhVGTt9D52jEHJy1I9lWUVmqJGwyAf0zc8eSLqQNbL51PEBMkukxkmqfs876ddmdeHqeGCwK1EsCSWe1iR+JkMezEPLAeqUV67ZDEtKrr4Ty1+WERamitkD3SGcyhjDBdLKGyILUTOOoCnYSlxhWkZzwDc1rwKWj7sexpPxY911KxS1NcAE4dfa0cw9KjGW6C9S2mHk2NVvarNXQlfiVJtWWhQMYsXL+2kPM7oXdCmjZlhuEwWc1nwD2vql4QbWhCl1QZu7hd3TEGEyEw3OFfXX3s2PnVWDfmNLvA5UUh85gdK+0p1h7mb9NR5LrlvU5SLHWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=Qe/XtBKOtt1qdoMLAwAmfes7jhyBd2GGWm5UxAYlFzTmuK9ZePyLjccYdFv07BsFfuRWL9G5I5l8pYiDQmvjkZ7EFdDR25jHqFxKhEbARAY/FSL1O4LYd7rh4C/vklbH7n1LnfDeyHoIVbtm1UCK1BY8kRv+l9HE01N7e8cM8oI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CY4PR04MB0872.namprd04.prod.outlook.com (2603:10b6:910:54::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.21; Mon, 6 Mar
 2023 10:43:50 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%7]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 10:43:50 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH REPOST] scsi: sd: Fix wrong zone_write_granularity value
 at revalidate
Thread-Topic: [PATCH REPOST] scsi: sd: Fix wrong zone_write_granularity value
 at revalidate
Thread-Index: AQHZT/UkC8NDwN3nQUSpmAEWIgXiIa7tkSeA
Date:   Mon, 6 Mar 2023 10:43:50 +0000
Message-ID: <eada3127-960e-515d-5bbf-7ae557fb3cdf@wdc.com>
References: <20230306063024.3376959-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230306063024.3376959-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CY4PR04MB0872:EE_
x-ms-office365-filtering-correlation-id: 277175d9-3b85-4ad7-f1fe-08db1e2fac13
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M64P9IYGa0hB+oBQ3+Xt6BxZXBSY8L/N2g0RJIZm3nmG9djKq73I5aYQWDjTzlk3EjppTxRIPdyp0ANH7m9BWqwneyzVcnts56eZ5H8mwBx5WR43B84KGgWB9Kh/DqAji+Q+qz2AdukOiXGE2bW3bYapPpuJvL8RVr+dwX/sjMEFzs5TRQMJpomQ2A3jgQMwYUl8eSe/IFk6UhejLo3T3jvDATiZ1mpqCYdWOfucQZVYZp7jokRCIxSfQr+E1gNtv9tEBho48a6sdo+nFCQr5NHUmYNvWAOXIL8bTH1NvXH1LdrvlDLhC89dGmhZXnlPlWWf2VdCx4NVcZerNQPe5st8qnPKajxB3po+3b/TZHpcSPHILInfswWbyBLpAWD1uFfzB1G2B4RiPfyvcdU+3rLf4mm1f0DE+9R+T8LOuxI6A5IMOXUAMpVV9OJck+KleXOmfc0ZgROHIlQLtaOJvBq6N7v7vwgyXKqqBrg0qfsni0H8S23QVlAayqKj5CeWy8A6eMLD3kF3V/D/7zY3UW1ZmFbMyc6+9hKYN5iBO2/LDUNcgQNEeMQdmvTDpVBjExcDhXc3FZrz2085vMHf64H8KKsaJ+OmVgl2+0rPweiqnbxTNZJnAjGsgidP0FKKbV9sY8gZ9Zgj7d6WPyXVi+BEvooC3+JvmGArHeJEcq4QL0MGEBleNLU6TXQzlY2rnebYuKDfIliX3SIvqnDrEtKVRd0KuDFQtXreqBhr3lE0RFbnEbGCslQmLcdqeeFHRjI84YTrVmLJm7id3mA3sw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199018)(38100700002)(31686004)(122000001)(186003)(26005)(2906002)(31696002)(82960400001)(38070700005)(2616005)(19618925003)(4270600006)(6512007)(6506007)(5660300002)(8936002)(41300700001)(558084003)(6486002)(76116006)(66946007)(86362001)(66476007)(4326008)(91956017)(64756008)(66556008)(8676002)(66446008)(71200400001)(316002)(36756003)(110136005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NmNVT2grZndqaWZsWUN5eTRXdlZDMzlKQkRURU5SZE9aQy8yOExHckRSNzVu?=
 =?utf-8?B?a1llV3Q3RENnSUdRaC96STFWbVQ1STV4Sm9jZDFVUEw3RWVYaTRvTXZvOEdO?=
 =?utf-8?B?QTRtWFZyYW5UcGRUM2pqS2RxMUpqS2U0bDVUcVhocG9mVlJpQ2gvNHFwK1F6?=
 =?utf-8?B?VVJPM2VrOStQbGJzQ242MU8xazVQRUdMdDhXRFBSWE1IQkNRWjlxcExZTGhH?=
 =?utf-8?B?T0RiNmhTZXQvUnF3VUprRFBqelQ4ZlliWFRUdWh0a0REeG4rNDZadU9Ya2p6?=
 =?utf-8?B?YWpGbGtYazNwYmhMZ2hwcERRbjNJaDZacE1CVDV1c3BtYkVOaWtkUElEdVRo?=
 =?utf-8?B?dms5bVg0dUYydTZ3WitYVWpRNWNsZmY1TTJvQnIydFpqWHlhRmpBbHFkRDVj?=
 =?utf-8?B?R1kxTFhQc2dSbisrUDEvcjc3dFZrNW9YZGxEZTlKKzN0ZGJOVjhXdDhFVzdS?=
 =?utf-8?B?NURCSVlHY1pVQ2k1eWF5RmxhV3hVNG9QQnp6d2FKeVRLTjZCYVFFZ0FiRncz?=
 =?utf-8?B?VDhXekUyZXNnZW56aEtiTGlqS294V3hqY1hZdWZjMG1tNTVHMzZLTFJKQStl?=
 =?utf-8?B?YnVqcTdXUmhTOWN0V1J4SGpyUThwbzdGYlVmUWx0R1JZdWRQNEJzNkZuanBm?=
 =?utf-8?B?Zld5dmxOVmlDajY4VzdzcHIyREZlT0hTWEhGVDliaExPNkwyeTd2cmdYOG5O?=
 =?utf-8?B?QTM2WlU2SVZiZEczUkJMbVlubnhFUHFGR09IWFBTTlRlVWdSejNWT1EzRlVx?=
 =?utf-8?B?NFhUNVd6bkk1b0VoTlBPMkxpZUZuR2xJaFhFRkNlcmVpUU5Lc0Y1ZU1jM0t6?=
 =?utf-8?B?SDV4TVpBeTlKWlV6bDJWNVVCWmYyYVYwck1oamJCbzZ3VmVRYlk4VGN0MTRV?=
 =?utf-8?B?TlI5bnNHeHljN2VraHVIWEdqVXdqcnhZUGNBN05zeHdYaXhnNi9pVTUwMnRY?=
 =?utf-8?B?RUNidEZLbDhEcHR0eVJPcENmVThYbFA1cEZaLzBsQTRWckVEL0RIQWJBMXps?=
 =?utf-8?B?Z3pyYUpGN0JtaFFQSXBYdi9MTDA2Zk8rZFN3bXN0WHBqUEVtUkVLbUlUR1ZU?=
 =?utf-8?B?SVdLWG9ZNjZwV0pJaDR1ZGc5eGp4UEZtN0hqZjB3QjBPVXN6cTk5L2h5YWZh?=
 =?utf-8?B?OGZmWUlQejhoc0Nsc1BDQjVRb3lvZWNETHh6OTdqd3pLSHJXYUo4dkZVM2p2?=
 =?utf-8?B?amtKalJsRXhNNmliM2piL211UVl3c3U2bUl5S216M2NJVFROditFbnBZYUo0?=
 =?utf-8?B?WndBbUVRTGNYMXJZNjVQbkk4RW92aGxjbUdRLzI5OEhpa0pGRDB0c1dvN2py?=
 =?utf-8?B?djVFM1FUNkRtUzkzMGczVWNQRElobzhQczN0QlAwUzJ4ai9IK0M4QTY1WS9C?=
 =?utf-8?B?TnptVjJtZ2l3RmIrWG5QV1JGRHQwazB0MTNGTmtPQmZrdVlPRUpnRVRUYUJu?=
 =?utf-8?B?U1BVLzRwcGxWYjU5a04yOXdLSlJJN3YrUndaV2JkbUVxb1BNT2xBd1BoN0hF?=
 =?utf-8?B?VkNib0QwOWNRaURtekx5YWdndG9SdUJST1pQaWlPb2h6QjBTMTVWa0VuTUsv?=
 =?utf-8?B?bWhNNGdiMEhDd0J6SFpSUUcybzlscFRvb3VTN2ZMR2JLS2xZMmx3VTNueWUw?=
 =?utf-8?B?OTB2Sy8xeE1YVmlHUW5UKzZMV0x4NC93cUNhdVZvb0hieWZ3MGphVHcvSDNT?=
 =?utf-8?B?WG1BbGFkdUZmRnFERjBqKzZ1QWtjVms5cExyQjM3c3ZrQ1hjcTduQzMwT2Zq?=
 =?utf-8?B?YXc0ZnI0bkhnRVY1dVpqTW9XRlFUYXFxeE96Y3Z0M3lqSjErRUFJMldBK0wy?=
 =?utf-8?B?VDdjanVGTk9FazVMUTFVdWZsd09Va1RJcnRrNWNrYnVjdGxuY3JYS2UvcHly?=
 =?utf-8?B?TEFCb2ZBa3A3YU5BZ3ZBYWZjVDRKYmR6SkpDendnd1ZUZVFGRVVZSTl2amVp?=
 =?utf-8?B?R09nMXE5ZVBsRmVkRDZVQWxUZTVBYk9iKy9Ybks0UlMvUjFPaU5zMGV4YWVP?=
 =?utf-8?B?U1Y3RWY1NG51clVRMmU0cUhuQ2hickVqcVVqVldiYVowVnNXM1pOZWtwOTdO?=
 =?utf-8?B?bmlOVTlNdjF5YWZVZXB6c3VzY0NoeTl2RStyMWZhUkxmTXBOQytrYk4rMkVY?=
 =?utf-8?B?TFRldTJjUG1OWkNBVVlqb3ZJNjJZRldaL2dqcjFZMlY3aXREamhUcEVMb2lU?=
 =?utf-8?B?YUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9E078D83714A4448764E541CB8014C2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MmNM7ppwKKW4qSkbeM1AEM4W+Qp8m7ydbKKuylBNyeEvAsPBVmBEHkesQoofRZl5plgURmsXt91x6Dsd9NRxcQNn6rdf5Ppdt5KlI6awMzDJ1DpoM/5DYCEbJNcCbUfOg9O5MtKHKOb9vCXyZmeE5XjE32630+G25927IvhJdxmbB0sH7RDDpL+1ypZ2m3HDT56cFKMtAuDDqpQ5xBUojbQYV/TRLDl342cRUDwmUb8b97V28dSzdNjt03MlHNo0SREWxHh3AE41+D7G8K+H2pVelZ84LBi+aXfMKApDtaLSmO05RelluoQkxp8ukzs/qExVLypwHXiO2b+0y5a+5BYC9hx8ZUTEEgz5HWZuEYUtxrX7MN3nYxGOaW+ZcGCNN1x7FXvM4jtRlPPMtNLyz5VU02s7HSfA+MVX3INR/vR+54Aul8iPhGm7SZIURfWm0oGlqCRtWO5Z5kkTI0k36k7ScM4waKc7c0DWFlf3fnFf3Vh7bY2tvt4Zqx0mXYAQeELWflaXyOXUrdZvhhrLKT7C+QtnmC/o22yO+ol11y2/jikDgUXI7aVZQPWtnDxzy5TlzO4CBvBiHHTjEIuzuInsV9Gs4ig6zEfY90noGIyhzEel7vm9/MXNyTH/64O9ZrghAKT564YXz/dPQNJ3gKcztYqOgRd1OTvPMGMMSJ2nWGQo/vN840BMSsknnVHXw4VjfZm3q5rrksphPFhUmC6QNwY5+Co/S3Bs8i0TuaOCXjE1B98yc67SjighR2MZ4cen3QAsv/utMXmF3wPC11ah7R0Yo/Xe3m3XwkNgK5zn3eIGsxFqiwquC12nhn0S
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 277175d9-3b85-4ad7-f1fe-08db1e2fac13
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 10:43:50.1716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7nlW5C2+j07sCkBavA1eCF8wDM7Xuuj6E4IUPY3pTkTfmLQ3MARae2WrU2qIzt6XAIHND4hnwAcrugQ7No2C/a3l7WzS8U27ePRTr5ceYCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0872
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
