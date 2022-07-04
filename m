Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7EAC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbiGDNZr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbiGDNYh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:24:37 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA052120AE;
        Mon,  4 Jul 2022 06:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656941011; x=1688477011;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=omNSc1MEIx+epOwWuK3D0NNxKuRaPvmjPgpqbRpCS3ZpmKBv+++kdr69
   +E4en/aRdVq6DNWdiZY5ynR7dbwJidG2TMUUNfzS3WDrVAqFdn/1E9SvK
   2pVuj85G0kq/Qh+4a/42i6cgzEhGdP5bAx6nDwlJh+lfLezttgLkcTQmP
   yEdyULbDUFBU0EOW2zZ/6f4XCv0bnzBxgYNr/SrTBGSsRb6QM4qU2srb9
   RJmrneBiUfhWGLwE58jqke6QC5oVBwxtZfdsiwMTDuIqOq13f/ihll9Ug
   +jAfMXnLc9LP5LyRO2jGyi9kawv2ugkQAHT/OKbQLRM9jWSPABgG4055N
   g==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="204767331"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:23:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpCWpaV6HMCRuJ4qSSwND+t9Q/TxoSzrloabCNq00jrxJcnNPnVkygH2WsufQIwjMLdWlnpP2m+P7LCkkgVUccNVctzW6HScZMI9r/DWypwOyYMRwPAj8ynjSE9vkgu5ZJakcAjxM8xwvsaYPNy94QrYIEj3b3JgZLn7xI5KwgDve1aQNBWeIdQ7kwAzD3w4IYZfKmzKMCmU2O5X2sHIaok893QBVCuPfj1+nKy0lrckYcnKKA96kIBaOTrA9PAgKbV1N00ORh84BWkDO2nCwbvxX3k+HoQyyoKi06t8UUm0InyjTyJrqLyHY6p1iFkOd72pOFvFRbfZ4cNIyXL6fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=e8l6MXcZE0xdxTHjm4rO/yqhU9uiG+vbW7GmdQn4sYVfKpYVcJ2iGiDGFxfAEHOnVba9jCq8U3YZHZNTpdWJCMXQ7RE9swQR9scQfdzhifkowAxt13s9pq11Y2rKmLwYB22ho+4vjMva4IFXJOnYjMIjbosv2esTspjKnryB+rTamiIImJy6i0sTbKvm/yKq0Cqf63reTVFCgCWWpGo7Y5DzIWNmqbAuym71mBmIHOonMoZjVx9HzHW56xSYUnFFh1R613lDW0v64t9JQ9Y7y9iMIPeipzPSUtU/rCeiqSfwfiTtYf06BjFmrYkZMeYufIvxY1Imn9d8pHREEcYApQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=nqdhs3D1wjSerDzHp5fxvTRcgyCbNtlkTr9a8aFIfMtSBFs6ShdDvRUn01rb6R65dnUCXCaX/Qtb5vFwSAqg1lVsjbwtOxynqEdF94MjKKbWzgIkv1F/gvi3v9mApulOLKKEg6vndNgbEVIDK1+Rsyf/fkWErIxag61N53gjwlw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO2PR04MB2152.namprd04.prod.outlook.com (2603:10b6:102:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:23:29 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:23:29 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 10/17] block: pass a gendisk to
 blk_queue_free_zone_bitmaps
Thread-Topic: [PATCH 10/17] block: pass a gendisk to
 blk_queue_free_zone_bitmaps
Thread-Index: AQHYj6QASEyytapJ10WFibhlgH8yCw==
Date:   Mon, 4 Jul 2022 13:23:29 +0000
Message-ID: <PH0PR04MB741681AA0BD262865045696E9BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-11-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2331791a-3fde-4158-76e6-08da5dc062a2
x-ms-traffictypediagnostic: CO2PR04MB2152:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QkKy4jes4Qi+4Ur471ng8dpaMuGYrNdD4onWo/7VQq93/dix5rWW6gygdZZ9mImvIuhYzcGJs6EodVNEs9z19Xmd8EOSKcZUhdUN3nqW7/AdDk2XVxjtFHEPZXQvC4Y7BX8V76+g3DIn46mKLr5GBmJCVtgGBe0gy4wSS74UbroM+GRXMjdHwnEi3EH5iauli1O34VGy8Rxh0CXkBx0tzJ4FpurCQ2daZDZSaQLY4c9x8XsZLGmvaUULEi6QC62AZQs1kF8L/ax/E+LQG3A6O44V7494CP1DvtdKxda6bb7RIUIZndewmTRgvsCwUMV7QXP5qwcQRpUTtWnqo9KUVH+/6jkQvwktq9mZrKEawoR4xeKzkHGzHpiasTodGJzFi5RMc5VFiKgdaFC5pSE+6SWeJiUJGbD8B4cm+hBETQNmTf23nIjbGhQ960QKf3Wm07gWSzPluJuyZW2oVlaTLVLqY+MfOLFDT+hnKUml2F+Ui6RfohF//Updz3W+z0YH7Ems3HzC2IbSpijRzEXy7wQigAmZVfeIB/f6X8zcaa2SSwaTbKgyGRv9r6jYx2aLvazdJKIyDCA5hTKHsxRuV7WWMhLev5Rw6sr58OGg9eHkdbOt+C2coWWBcTGCac4ZOe8K1FImEq+0QX3J6cr02lnn2Qu15XbpEaeTTvkKq+48bI4ZqajJL84BK3RcjMDbjFogFvbYvtzpHZrqA9r8cqY/zNGZsIhJoJuclzN+NvgAFU3DdPa+l2RpJ/mUd/lZdQ6Ncsv8YbYrw+EUhRRkpP/aik08wUYFFXpP9lyoZRwBqywEaJlCko+FjwBfT9Xd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(52536014)(9686003)(5660300002)(110136005)(86362001)(8936002)(6506007)(7696005)(76116006)(64756008)(54906003)(91956017)(66946007)(66556008)(66476007)(8676002)(4326008)(66446008)(316002)(122000001)(41300700001)(38070700005)(82960400001)(478600001)(71200400001)(55016003)(33656002)(19618925003)(2906002)(558084003)(4270600006)(38100700002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Cn4aT3kqXreR30VD3JbVnlTk/72PpqgrLJ++vUw68SMJSDENvMGNrDJeO67g?=
 =?us-ascii?Q?vEvIogtmzH3QgRIbYJuRw/wZcYCA0/6ENtDEZkoCevdqWmO5SU54+McluXsr?=
 =?us-ascii?Q?EWYiHYoNUMPJRsBqzY3gIZeJ7nO4haXVZryIyz5jxpko7ZUyIP1fWOCtH1xi?=
 =?us-ascii?Q?ZIsHH2pNUwPYervMGJmRtEu8RYJ3MOhwms/8H+PDHayioZIdBYKzqcf0fa0H?=
 =?us-ascii?Q?fq05gkXB12Hyud0JJCkSA2Uv9be66Q8hdln1l9kbvL8PgvAigUnbXf738sy7?=
 =?us-ascii?Q?/0SvPlUMdKOgg8gLPdtTfO73Q6hYaR55yB3REv8YlwTuQlSlsm7tUplNg0hL?=
 =?us-ascii?Q?An7oUcAhGg7pfUS7rWxxSyCl8pyYa5eaqq8iItBMTiujvjfad7HMM90d4/dm?=
 =?us-ascii?Q?TXvQAcjVhwsnnqJF8D1AJC4axg/tS+hWh70GATkJKxDHY5QFnZTCvz1CuCNH?=
 =?us-ascii?Q?TJVlRdD8S5Y3ziobP1WAKr3WlugSEW/psaooUiD4l59BVL8v0Dr3h2kabIox?=
 =?us-ascii?Q?q8S7b1vnrcXAYnlDqlKNzCekZ5oge8HLI827lwAtTFnFsVVvz8H5yLvdGSSm?=
 =?us-ascii?Q?4Qx7eCIuZ7tnVBqZnacUNrDtf7wO4TEuf/I5WlGcwEJgdjAFTdzeBDSPLK/W?=
 =?us-ascii?Q?o5E9rDScMHy4eyFToHBH6AiSbBQ8NOpQBjmdOl8tTRCG2njTD9st0yL0Cwj4?=
 =?us-ascii?Q?NOWtxPvOm7lmtQ+exgzBz72kUCn51ZbrDEGccoZW8RugxzchWK34hWbmRxxe?=
 =?us-ascii?Q?eyVDQtmvQmn8Sebewhulwibr/dOKOwPFw9FKIAyfGiXfAzmq6SEZjwHmMg1+?=
 =?us-ascii?Q?ayYO5ykPXAaWMeefzzz/jrE3zCaNBgVaAZZZKjxg2HpVB0Y+mh/j7Uh4bvzd?=
 =?us-ascii?Q?rjBQO1kjDxlVlnWhDsTA76k5uk74VFg5+m15Uv6pgix5d36z6E/NIKK45Fyj?=
 =?us-ascii?Q?viHzWf9DGw/lxnrR59wuJ/tPrUKH166Cpw0kVOtLNcMLnS4vdgcaNMJ19orY?=
 =?us-ascii?Q?QHT8nOam7NhMOPxvM21JnkomGWQ1jFRvPxP5/wmlP8UhRCD+QU0lDFQZMZrn?=
 =?us-ascii?Q?pUFvX5qTK0bF2PSY8MIoPHZGZVgEymr7sxr1bK6uFCIgLMONwWBQU7lzaJfw?=
 =?us-ascii?Q?G4N9Qb+uxUWQYdim4ME7Q53qJfnObpTArjJtLyzsucrOPb0l1OfoVtkqqX1G?=
 =?us-ascii?Q?7zGq9gwiWryVwnkPs+NXJrj2dGeg8Te3ojH8tCSibv42wtx0O3dPGcfRErHV?=
 =?us-ascii?Q?AzIx9Ji1LIVQOsHh0FDyq/H2P1sr8Bpo0tvfgv8qZ53H/ZU9n9Y0SIqxMETZ?=
 =?us-ascii?Q?boabXYM5kV93OBRxY3sdyPUypBDNZhhLRKw1e1sezFsL3IeXxF18p1LU/6uI?=
 =?us-ascii?Q?pm2odcjP/ZFzxGlaN6jzitRZ2Q3uXacS/DwxSCpRx11uan8Th6LyQodooSp6?=
 =?us-ascii?Q?xT1QiLiU2jrZufWarL9RYdktN+CMT7ryPdlc1aKO4JSSwDN0rG5WRK9npJku?=
 =?us-ascii?Q?5xqWFpSaBnIrHnJogF9PVVwKxOFEJT7xuJ0wLqn2ynig+Tqs/ajSO6l6ObWk?=
 =?us-ascii?Q?XOrEjUoTt50hq0DcwmISBUAvpfOoMe1YT73oeBavEDqaLMQEvFoukLePPsDx?=
 =?us-ascii?Q?qT5BQ0tqqUL3qt4bLPig0KHZ1P/iN/1SeetnVRoJaCHkehVzfYz6rj+9RwvY?=
 =?us-ascii?Q?lULyt5Bi4YnOLhWamenph2cKyuE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2331791a-3fde-4158-76e6-08da5dc062a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:23:29.5951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bxc3qta+cZdnzm+UFeJ/wq8aYg4Sd8p9gg3ZM+VQ6TiI9FAFBkW63YfLI4jWiSGvvP3bv2/go5MAlk6VnLH0mD5T56H9AhOSAwE49J9fI4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
