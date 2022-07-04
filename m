Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DB6C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbiGDNcT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234844AbiGDNbq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:31:46 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0221263F;
        Mon,  4 Jul 2022 06:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656941269; x=1688477269;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=QRgdM4SoiNNpcxzY2XPxZf0yOYizEdh5tMYz1uwvsWmoaYX0p6EP1KvU
   e/M14uiPF3mGoliA6NW8jKkvByC1bPVmBGlaFnjHbuQlFOhEMqfkFqZee
   I9OK2SDhxVY22lOz+Ikw+Wou+xBapb7d5j26BrtczN0SKS2tyW5zng34+
   681A8fggGNjMlC4mdWHgugZO3eAHaAG6xhRq6AZXtcMsr7gBZukCCVaeI
   YbVNQubdqSZDOkUpjbhaQf17qn9YsCVUs29iUel2TgAf8F63pBxXC3dpv
   mlPDePkj96XJrnsUCJZtNTgdH5fFmkiwV38cjJ9pP3+YJkxmQX5WY7F73
   w==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="203428533"
Received: from mail-sn1anam02lp2041.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.41])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:27:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVzdKMAERGMF66djTm0xWibeArjBZVxldBuBx6VWd0ohE2Bv7FNQWxZHgUubnQsc+zMkg7YnTUJcZB+/7qhaSPHsCNEhjIW+LrAPpS1sT0WE0ihUuQw987conAJtmSSqEXQHGmaxIa1CVJHzAEddAvztWTadxWts5gcjAvQqsDVjVV+b7vm6pRd3B4wy07VrTe01gl9SLGc9I0ZNnQJrsMu1ChE61XDFtu+oN2kxzP00uWdm+dEeIHiDd1jAZxqhEJEDnmWyV5dmiTOfjkovun7lvQSdsIe/ZkO96yCxYCyg6Z1V33wrcQLInlijS3ekLU9kFoMntBccxN+8SCYBaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Bssu4J+kYUHdG0rVdFM0LClNXzArW77XVPNAKwk3RZHZ5bJ3KxT4OtxGvssHo9T8lTZbQLt4Ita8jAYSIhAobBhpihgiuIGxY1UpHBQvTvra3AqEkzLF7FoDeWtzi6I2rbVgdj+C+vZ8G6bZD0WYcnNUrkLlWnJbXaJyCqKVw4WkADHgCriTgDGXqatp9FwNaxnQbTQJmMfSWXm60D/W9+KCSv0puV9HBIJ2/1khRYLMXO68a3WVDu8HT1mXcb7JkXP6rlvsUIAS0moFp572kNO/gPQJFu/qrMej2EPS+ZuzUq6QR9mR1wqrE349C1WYxPwe+oiHRmAwrCf8BLU8Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=zYScAylA7eVz4ds0Nw9j9TVCz1F7+PBpkipAZrpJJMYRWwX+MuSGf9ehQuPm0yQD3HkKsa4ZCP8XmX94gLFI21bZV1r5TI6LDFcBKg6DnW1XVdZgvn/EvllG1kWXuGjB/1LcENOH/I2sspND8F1iWDKl/3fEvGD2odKmIHBZ7Q4=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:27:47 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:27:47 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 14/17] block: use bdev based helpers in blkdev_zone_mgmt /
 blkdev_zone_mgmt_all
Thread-Topic: [PATCH 14/17] block: use bdev based helpers in blkdev_zone_mgmt
 / blkdev_zone_mgmt_all
Thread-Index: AQHYj6QJhV/jUhPC30WqDPob4rRZfg==
Date:   Mon, 4 Jul 2022 13:27:46 +0000
Message-ID: <PH0PR04MB7416938C9ED2EF264149CB2E9BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-15-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8eec4415-791c-49de-c309-08da5dc0fc0f
x-ms-traffictypediagnostic: SN6PR04MB4640:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z45Cr9w2EdVUZvMCrIZOA5g/4ZUMUJqD3JquCDr4MQtL02FElzvgSo2zXCQSnZzyQBkopRpjiuLj4Q11a7gXRoxdyeYnqPkEMCZSokboH3Q6GVqSqj3uakWCE5lM+usq9fq3nPoEk+LdNUcW0ARsatrlE1EfRcpMu5fOujvvyj/jnhVB4UQA6z4uIRpnqkgp/qeyJJcVryWCsbAHvpi0/QBO3di1rK9CtD+p732xfHG4wptYaHD22QqoJroFg/C40zvewNW8VmDOmIWRifWGpe5WKSogVe+/ZfNrZGC/ZjxXbDjPPtzoJ10uoolZHyjNED72Si2BZyzD0P9fA1QknKznmZBfrUK1Tva3sg5cUExFL2l0ELRMHNlLO93ysmHbiF5/y7SV4ge6zdNugzOUn0w5h8OyOp4PvByYvH77A+3fQ2qZ+A+rwpQQqyJCL8FFUIiBFrbsRD9+hO4+IjrnxMjPIqSzPCWnjjpKvkFWDzd60UwP9sTShWCntVF+QAJp6olSdiGnYNsr8MwlK5XLEYfWjXo9/UL8eFmVJNaKHF+GhnYkMTLJV8wj3dNoBLl71jlAyZI9HOi9xdRAROyVFJ48NofYw4EwP3al+gZ9xM1jAq7q9YV0t365vONNOo7BAaVtbvafLvERFM5sNxf9ybtiiPjLz7Xxv8rqzVPHVO07558lYrkG+8qkqYNWhgTD4bJO1wHwyRBUeP3dArZ7ZDxeA3ljVYds52OlrIdyGwPvL/B08QEpzZPsmI1XKWi8OLSxlMzdywDMI/EE86x5mVu6Mwq9beG+nZtfdEUq5PWpew40ZHEPbmuKdPg+JEAy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(33656002)(38070700005)(4270600006)(122000001)(2906002)(5660300002)(558084003)(186003)(82960400001)(478600001)(55016003)(19618925003)(316002)(8676002)(66556008)(66946007)(41300700001)(66446008)(110136005)(8936002)(64756008)(52536014)(76116006)(54906003)(4326008)(66476007)(71200400001)(9686003)(7696005)(38100700002)(91956017)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+7cgCNtDWvBqdCRm6k8imSv2q/uAJrq1guOvU0kCvZe3xCBuAz02rg8zye8i?=
 =?us-ascii?Q?qpWmcFriN6FOz6rasRF7UkixCg4GAzDs2WWseW/HLSU7g9G6zrSxigEdtWHj?=
 =?us-ascii?Q?sBKGSRazRubl15KCSsAST0PYo3YhfOe6Ng+cji7co8YF2nFFmkdjKLEQ5FZr?=
 =?us-ascii?Q?l1H2QT/mpJ1FODuvSbAnum/54HpSqyzxEagS1MxSCDxfdQfpOnbJRd+N4J2U?=
 =?us-ascii?Q?TgAZMAAsdPlMyiLF8eI5yU0Ky7ro47OFFIopD5FKpUNe9rKyUmVKcEHWHd4e?=
 =?us-ascii?Q?hE6zobQzia4A3DX4XuyYDHlyfjdWPFmPeirUVGii6pb2CyIWWUO6cu/CF/pl?=
 =?us-ascii?Q?gXIu/M/G9hNoh+8PqkKjujOxh3cI+7i1v11ERf7t3mToexn8xTKubN12YsUy?=
 =?us-ascii?Q?0k7b6Pbcf3I7S7mL4jbbDtt2NwH1xbBLlKTd+yNKqaSCrvcSp21h83wHRt/F?=
 =?us-ascii?Q?Odm6f8TQ6eiPEmIfKJCisC51CJJzBWe6VwyF2t6+1XHoGm0rUJ//xvvaVcGc?=
 =?us-ascii?Q?onm+4wEozjJ1aNBMNkpgM+zRM/ji0SKvHAzHmFYYc0YIoAXVFLvADxzWtDCi?=
 =?us-ascii?Q?pdKQY1Rbh8L5WC16oT9JZlzvXY7Z4G2obJ+fq8spwkzpnaY8glX/5cf9mqXQ?=
 =?us-ascii?Q?nLj9yjeXofIzP5GnvoNWkc/jYunkPPmoq8ISDIcxoRo2USt2zWdIAvwBPGNK?=
 =?us-ascii?Q?xgMdNI4H8Se92vnlP7D6AEEtVt+7utL2sPy/6v+/oK+OsJ6K5m8TedIbzqjX?=
 =?us-ascii?Q?LJwHRy5Hn7RIu+anMybYyLGsqhZ7yh5D18vV4U3YABdUPETjfq2D03TzCBYY?=
 =?us-ascii?Q?8syG+hQphSGaMV+3oNc+d8aqqiZeEe0bbrKzck+6lkcljepMEw2gVWvUKh9h?=
 =?us-ascii?Q?2giSNF7TO3TA3ySTgNN3Vy+721FsHoF9CX1RMNdbnN2mbFff64WHd/KDVFoi?=
 =?us-ascii?Q?ASaxO+Bt6LHtG8VNyF1IXxNqEH1jXoUOvaD5LLWuOKXR5lhiWABYogorssv3?=
 =?us-ascii?Q?3rowAHeICH3uT8PP+fKVLjcRHCOsEzMHBI2YGeh1MYRyYJ49/ASASEC5QsME?=
 =?us-ascii?Q?gjOr/CdDgeyC/XPvVAZ6s8aNFPEHNtoZ8qRy7ns0UgHBqbS94OB/nQ27Dph0?=
 =?us-ascii?Q?rzrBTijNx6AkL1uN8svuzBPHVwisE0BwnMMK1AdgHe41khofDY4sBDUmfNsn?=
 =?us-ascii?Q?VLUh1XciEhKD+8ZcjCmYR3f7Z/TnsvXYoYB7JePyZM33+3orfgJW6taMtIzb?=
 =?us-ascii?Q?TTpONkoxt51sm2M2wJMETCwomjHx3AFb8igPN5JVKXZKqQ0GtC+EtLQww/eO?=
 =?us-ascii?Q?iA9ilQhUV7cVuVznP4BlCGm54gIsNdtlReDV9ku2ySezmI0BFezXMUGCObWf?=
 =?us-ascii?Q?MTVIwO/yj/NfZzUAWTGTgg11Z7yaklk7MezHU7HA1lUsCetCheB3Y/tRnLdV?=
 =?us-ascii?Q?wISvaUnAnHbKU+5+iQzzlcLj0GlnzxzExnwHYu4YUgNFfHrPOQgQFrMTSKZ+?=
 =?us-ascii?Q?Clts9qH8zKDTWz7NCSXyzOmE+uvATZrs+rvosG4vyhWaEQgG6dsOZzIzXWEY?=
 =?us-ascii?Q?Aj2kUPxwQSVlvSKlm2OLYRBtQBcAChEGneDg1iN0H2pCIeEDjLLBZ885tDAN?=
 =?us-ascii?Q?zvMIry7sp3FG6RO7ID9Y0MtCBbGsvqN6SSpy1FtNIum5pPKXrm6og1PdCx8J?=
 =?us-ascii?Q?53EaE76Bf1DWm/sFseWnbUvIXYU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eec4415-791c-49de-c309-08da5dc0fc0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:27:46.9717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gjAx7d0NZGX7eCamTJ/4zWEXdDxJE92nnRShqoN1GYYxhXhNs3vKZmhl9X+HIa4yM38N2JjLXqJVKq6MgKzbsxFFVhA32tlY4S8O6MRKbNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4640
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
