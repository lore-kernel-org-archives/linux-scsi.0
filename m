Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41DD8CCA47C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiGDNcy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiGDNcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:32:08 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EC711A3F;
        Mon,  4 Jul 2022 06:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656941349; x=1688477349;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=DETqGw45FnGNrO41009rcO1zv0DTf1jz3ltJyB44A6mxfruVneJZ+c1r
   LT2m0rb3TWin3kTpCDd51R+LXZ1sGKg5GmhnRTD3Y+Dgq771LVZYBJrvF
   /72q7qRVVCMK1aL8wsR+L3g2KzGOh0vV8vIad+T9ZHl/bdiDiaY7L4qdL
   L+a0B6F3olEIGDohvgvxjC3Fl/p3gW0bQ5dpkBkYVWYPYFiHgdTX9dlA/
   iLqEEvU2n2d7qFYUCv5SJgkO4f7Qju6nynwo2qCL1vLVeMXPrG1r/usUM
   aGSsuLEk61izl1I1uSFooJX7ZvnP4hJzmZxvsTCkpBMiA2PuJP/hys0zL
   A==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="209661083"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:29:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dffqif2BQ0m4Li2Tfa0Jvr9unfWJnPrzQLozetEuikxHRuisgjg2h5D1NalzUu6+YkwSG4IFfSjcTOzhX9ZzDR/CKr0X9I8wKcUqtGHF20c8s5LAxOyu8bxz7k+/N1yqUt2hllb7njJyD+Q8t2Xj79B9jpGiU8pwZ41X+/plbATvGWL0gkispkxpucoQr9mf1SBgUhzHaRi7Xh01WcAShtSpz/zK7P6QufCBOMDO1K+wbAutJQ6Dfu/UWj8wKd5Q4RY/ihFhVUd9fExEPVdval6HIUYSm8I2WCB8dOSrNl6/TNLwbJRT7c8OwLWMJ3yYi0DV9iCLWAU839yl9EUzXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=WUKvS5rcYOM6jtPxXQgq2vu0ccjRq4NwOGTZ9fCWMQMp0niGGDuvSidJJnrkZ8edJNxoizWivqiqmcEMWPRTlJ/+MTp5Tev1ftGyXpibJ4elk9VYx/4B6V3a6gtAo7Mc+Hdh8gdAZohzhRpjuhSwaOZPs1QsFS6KFAQ8cnMt9bCpDH90ccDC1ahxfFA7sk/nPDrsOy8WrPeENicdoU/dQDlZwc5ba40JLELAQy3HNUkQ6BHa1/a+uUu5p2jnZmjtNE7fsLHOqUErnu29ZAqAFG/8h2lkGp04Jpgd+00P5/0f1lsONxrQcp6zU9GS7/St9cBNgTHdd5R64jwMdke6cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=P0gBckg3InLru6To+0fX49m4Tpy7uYDLwMO6fJHpHnhMXqsNSLZzpVOCbGwmPokE/OwxEQWWuzejFbYZOrEH1oOBIepf/V04etw3pgwIqTiDy9xfuau9QSVkhM5jm6/hzo+RJklH4A+g2NgtcVu3xrrWorQoWNcjuDHZQEwLnws=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7253.namprd04.prod.outlook.com (2603:10b6:510:19::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 13:29:07 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:29:07 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 16/17] block: remove blk_queue_zone_sectors
Thread-Topic: [PATCH 16/17] block: remove blk_queue_zone_sectors
Thread-Index: AQHYj6QPLHSgoyaazkONPu0LXTiOgQ==
Date:   Mon, 4 Jul 2022 13:29:07 +0000
Message-ID: <PH0PR04MB7416F0D03312B064C29FA7BA9BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-17-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08a0181e-0e5d-4768-3623-08da5dc12be4
x-ms-traffictypediagnostic: PH0PR04MB7253:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lyYFMVVFfMFRlyF1z3qT46jg28D+TRzD2+JCxi6junZQhzvV1mj+OuZdO2kJ+TsYNVB44auEsFNyCejIePbla1FZWs8kHqoI/tx/BvV0BkzIMCEUo/FsObClGVk5VpQ0QPpN8pm4O7268DBQq8c7oyKCZ4hT3oahftDxaFutD3XvGlu9/yOprhVE2aFATqHo4eqrgS3JK81XHFeKm2YZSKCagEgOsg+qVzxf4mTQsGEZsycTGbRM31VCshXbz0QJmsbbJxnw8aJAzxzXZSeG3LdX18GcJwnNuPQZ3LRlJfJKLFfYFEg4vBLhBxbPg+HNSQvmB1v+SsjW4yVEhdATmJc4s+nhwqB81nu1qJpy8iixqtAIYpSC80zwX6RdeX964sBKFD5FjAjYDfsYX2Nbjzz4cnqV7EQEn9YGxwBj7W+Ca/DHQ0kurTjK5h/ukBsrzquDSOAnCoYMuz46lgXgZOKcHBHlSj9lQ2DvM73/zIe0bWN4R36ydUOtGGtmUDmPhlw/0Lk7LhN7K+XU/SMMkZgwUlbtpDO6rLAOQDBUITYs3kD54lMbYKhhFc5zsAYF7ADCJ9lH1Fcwj2Hc3Vahgip3mBW1/U7HpqV3lHo9znFQQxlVIipgc+tolTsEOXtGhlhQGLrYJVeXQJA6wWy+D+xoQw1h37fvl5TzWBDIMtGupi+iwQqBALlFSeIlKWsSNVsCjXkkTABE18Ly9V3UiMXkdRTwFZX3IhYBAptr6zp+go4T7+lMknWoeeRzSecT/ww9QY6X/2bhWgT5WVLEJ3zYSuHcXdeEqvEoLlkcfkrwmP7HfCnffsk6A6zaQirp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(186003)(55016003)(8676002)(316002)(76116006)(66556008)(4326008)(66946007)(66446008)(91956017)(64756008)(110136005)(54906003)(71200400001)(38100700002)(33656002)(6506007)(8936002)(7696005)(4270600006)(558084003)(5660300002)(9686003)(52536014)(478600001)(86362001)(122000001)(38070700005)(82960400001)(41300700001)(2906002)(66476007)(19618925003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5TyCkcdORhzik+xam5ow4a//YvXeL0qD6eNUjpQHnME93txHOjgx0dYAP01i?=
 =?us-ascii?Q?Fi7SUzjYQBsVLrdoaT2ecd5udKfrCE9Be0WBoibIaAhyFVHFKq4RKQHQWIkx?=
 =?us-ascii?Q?M2b6FIWaBB2Kr8M4UuX2vRgalcDy0VXKzTpZ2n/MMEm/fXN+Om+pX0Xe0b+V?=
 =?us-ascii?Q?92uPAVW4zO/FaTyS50CvGUUQhBu5jFdJvX9XozZwHqB7y498xCBu4JWMFimx?=
 =?us-ascii?Q?XYUFA7Rg+wDod0Y7l5eVjLE0idjSlGKAsRInhBYdLsKoVzMouSzKgjv5YXFV?=
 =?us-ascii?Q?1rSqd0fukkAISDwWNtSRGk05bNoJGUeoMQQxdpA1jK09rf617MMJoHtW5jwl?=
 =?us-ascii?Q?6RG5IqFOY0BEnjdBpwv1lcGA1mBbUZRn3FMn+AZRCH336SvXYmBEYGN85xZQ?=
 =?us-ascii?Q?v/0zndGSJAOlHsTxANlVbAFfy2AmX9qiJb4BHywDChaQ34+ZrEd+8wY5MEXx?=
 =?us-ascii?Q?2wCHto91McDdqm/iRpMP++6z2RH/qSxeegBthKAW4+nmD7hKtCXzinatgfy3?=
 =?us-ascii?Q?8Z1RDFiMA/dVgbf1gytS6pyu1Z7f/14hwFKiabx9Ie+i3o6Zt3ZruxdrhQk/?=
 =?us-ascii?Q?Vl+J8W0OSeY22wUj022on59zfEo82D/uIdzi39/0O8KZQfDFRVYIFvTOjUqG?=
 =?us-ascii?Q?8gHzsrT1KP2pyDkZIwV2+dz+xm7JITkDXYeLfgXO6fuGJ6Ivgg9vBrklWfx3?=
 =?us-ascii?Q?w30njhi/9FEIwNkSmpVIE8xlanJHj6fgZOBZYj/rao+ewOKxE3WDn/rSQ4eX?=
 =?us-ascii?Q?9TwzNYOHA4kPrdWwwTncTBB6XVX2oZ6vKf2s9iKQfw82MbfOyeoBMP4hxydO?=
 =?us-ascii?Q?ApaWujOydj4nNDjMopPQ6vHvKqpZUSXv+7PZl35TSXywqY9VycHT6p50T0Ri?=
 =?us-ascii?Q?96JeLeN68ROojYAvOdNKRKATR8rW8Az/G8K9tHse7kufJFL3kQe8wkHjnABu?=
 =?us-ascii?Q?WDNgKX4V5FrXoSj5z1XV731S56xRsvQ3cVLw44SH+QYWi1G42E6epKm5BAvG?=
 =?us-ascii?Q?3d6nR3TTkueD+LFKgAFifo54tjLKghRYK7aa8qeTr2hL0O6RYBCn7y9RUudX?=
 =?us-ascii?Q?jfsNQG0+ctBjRvhFM50Fok2FrLDtRCNXxsn0UTm38dkMIszoEpUjNHiceSSP?=
 =?us-ascii?Q?4l1CUj0tJ1GXfCdn4+6CapPkfsh0E1rwEtB+LwRmVXlAtuG5JiePlmJzUItu?=
 =?us-ascii?Q?qHLzH9uFLE/juiolSVtf/L++OMdHqNgeXKLSxXbZP6ReVh3daK7mKVQayeZC?=
 =?us-ascii?Q?RvG8bModOkVmEUp5oN8zhMkr3wxnLt5Y31wPyiFvZilzZwqe1JSQJXAqAi6m?=
 =?us-ascii?Q?r5C4xODVdydHjshDQn1hLIXS9HsikfoQzte+T7d3R0IN5bnkR+OznSB8sgb9?=
 =?us-ascii?Q?p7aurx+A7aNxbywnSxowETGfKJ1HInioh26V0O5vTxINNjjfwsNq5RpzcFbC?=
 =?us-ascii?Q?8RiAvaLkNyQnPQjdFrglbjd3p6Kn+8u8bLkKktQbp2/fqYoLQpxhBMm9d0XG?=
 =?us-ascii?Q?sxP0yFlZAkXA3Mf1JyFN5gPJcvH9l4EGM1NTacbavYiMv079MWIMsgqQ3lBQ?=
 =?us-ascii?Q?6r5ESVWeAKm+3OjOjyYDXWTPb7f1NI2xFs6GlFzu9eY+f2GXIvz1b3TuKwsy?=
 =?us-ascii?Q?XRtWKerZEjG2wRI4b47q8Z0lR+4+3ywHXyNQwDJiBCh0XTZtMADW8RxBqP1g?=
 =?us-ascii?Q?iKBTMz76IcdJkWykAHf6TKcjU6M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a0181e-0e5d-4768-3623-08da5dc12be4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:29:07.2482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: heKr0ZBanBUSW93Sd6gMRwAbdhdc8BKaaCP/J+8NsNsjTjVx1p1ZDr36YgJ/99sg9UoGeNruyBaoNsJJpl9dnMEH0dyiYS7Uz0hwU3F1k1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7253
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
