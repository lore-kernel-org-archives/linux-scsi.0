Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AECECCA47C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbiGDNWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbiGDNWk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:22:40 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF80D5F;
        Mon,  4 Jul 2022 06:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656940917; x=1688476917;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=RVFGo+SDJok9mo3djqTcRDNciBsj00KIp/q/E1DVhyeLhpFmA5PsLNS2
   GNkZZC0S7hZZWe6lnEzl9SxMdAAP51J6bDKDSxODcMSX/NWPk4UbHfwmv
   SjcLyJDh1pBKEihOsnux3DWObZdcbCJ6jGCqB/W/zjMOBCiwtAPj3bndI
   0/kevModH8MvVAnF6TxJ1wxbDuAu3wIFgdh5PTp2UZwpzENGwK6eKflNX
   kpNhYY0+1D5JkAfi+buSAeNpbvpWyr2ABWZK0MlPoXIZhp7nXyFin3uBf
   +d1h1UjTbReAYqWzKD/KXAURk+Bbhe5NiuV3CI7503chGiMSqIShVg97H
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="204767248"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:21:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8mlQYchCzmZ+/l4aP+qWDPKb31cVki9AnTuDToTsifnh9LO109NzEZLrnQbOLrcIxIkErGf0o5B+xvOkrR/TnuYg2O6jnXaCOFqitrkRyVit8S6fC7kRAw4ZENik249cnLolJbepQLCwYAuea8niKBmW/zgJFEbXTRcCaJ9dGTsc7kc0HhgWbEIu5E2NlKZfUK6s3DFvzYgKCHVHlrShvfb93xMdT6hieuJ06HCBsUkkrjtbxYebSb5hrwWQmF9k3dsoA9cGfdeL7s5SuKqK3P7gW4MgQ9CSbqzLvodtp6WyQ/sYwZE+IeYJisnVwua/HCQRgG7r0fShbpDJzVk1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Cq88h4od3XsDZby42J0kNFR1TbY4Bwvrrz26yhK54oeLMklCbdjas8AcETy7Cw+M2gR+pvcYgpQz5EFQlh0tkEqWllOYO8kpxTsle+7m4+IBhRzNOkQgWTD2XoCy61U31yAClyA9to+4yO4yXXceDWmitLqY4xbGjKQUp2wGVAIBGimaIkWJw1sOXpIQ3oZGpNuwQ91ty/Cz+XsD9BFzjbhRIgUYX3M0iTy5ccyy6o3/vN1i64WfEW6XgdIWZBofL05dnPRqOCMqmW15TWbdWyd+t4YgTtc5bTYLLw4/xZH8ZF0owo1nUf3i7jSd44rmSFcxWLYRlqFMGGhhvtfXCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=etGHs+26lZe4jCF0MWClg5MCf5Ksb/TbxIoOAJvkh+xsr0WtBabHQ76tlbVZeCKa5KuhIm6sYjU4HIhps5cy4+BGL77DBgKWk7vNiwRRf30h3wvr4VzhbfpRuxQUiy+vCm8RZ7Bzc9+CGZnyO4CArlOs9J2fVyeAphjh5k4p0VU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO2PR04MB2152.namprd04.prod.outlook.com (2603:10b6:102:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:21:54 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:21:54 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 07/17] block: simplify blk_check_zone_append
Thread-Topic: [PATCH 07/17] block: simplify blk_check_zone_append
Thread-Index: AQHYj6P/DrtBcNYUt0WfsATrLdpl9Q==
Date:   Mon, 4 Jul 2022 13:21:54 +0000
Message-ID: <PH0PR04MB7416AD2DCA0E8D8462490B909BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-8-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcba4de9-88ff-478c-1377-08da5dc029ba
x-ms-traffictypediagnostic: CO2PR04MB2152:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zcq3QmtBwT8Ha8d/3rb8uYo+eP3mvlD0/ZRzPbKS3rlx85uwda7xxc3mspmQIuqE7fUfIEZZhn6oCopzvD1P0U68cvsR4NMNTgZMBeRoPf+uATCInK7fSHoFZZlNkpZCruyGsrRHNTuHA9ridevHChk/9eMj45IBUYVNRO0nFE9QPfur5MQWBeMbHZmGVgAdaPkD3zK7x3syR6nKcNHlj+PchRQFwgqSdj/L+yde3D8M+dtlvcoLrLLY2eq9vcbYabroEw18dTZ/xkppM33JO3LsXGOz6Sz/YqVc5b0f3Aa1ky1XlDeF+YmkZFNdsjPRjh8KmPYS3sVYwz+weZsZbGsJu9wjkyeoZcqIT5XI6pZDmth85UOE8K8fcRObXHn+Dv8/thunZ4AONik1PwpZ+XHWjQNyWiNbZTopY08IPjeINUHL4SPimMn1gEsRqJHsa8W/VfFsprTxfUmqz8+FzxUPSAADIYP2O7aBU5Vuu968n/zxHm5ZJFiOkF2oNVvlcQ5aUpEqvPhy8wE3P6N5tcJS5EhN3dcMOo/OE2LO8kWULiKyLR2jqBjYlpix6fyd1fZvT6PnlPkwOL35lXHZlN/ykpqd+FGMGMAQmdrjL+5qQCSm0OvHYGGbV4dQ+yCFsITxOCkPDFI9bTWFuOPdxK8uHZO64Xbews8hHNyOE5kXASXgedIrhH3c0QEeZQ/fNyvQXGo2rfHV037IUJEUXNSsuTUHS6uswxYQf7uu2S6IqAE40RALay4T5dU1cR4oVHWJtOJSnLZL7qQ9rklJEiGF6jitke5vvXzi688AJfBiH/cpzGSwBD6hxecZOBKj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(52536014)(9686003)(5660300002)(110136005)(86362001)(8936002)(6506007)(7696005)(76116006)(64756008)(54906003)(91956017)(66946007)(66556008)(66476007)(8676002)(4326008)(66446008)(316002)(122000001)(41300700001)(38070700005)(82960400001)(478600001)(71200400001)(55016003)(33656002)(19618925003)(2906002)(558084003)(4270600006)(38100700002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yMvkpu3E7Avt8krnmJPqNd52BTCFXKXB+D851+b9j7zwFQqP+gXgx7cGILLZ?=
 =?us-ascii?Q?w3r7ph5ZfNPt34j4sqfhR1DlJKWjgR3k8/0qosXjAOGntCa5uTlcZlgqS4jc?=
 =?us-ascii?Q?NjhV0IiNDdK1fhSjzlYTtNXbe7lgotVE2QUHX1iOaWeG3rdp75Al3ZbDlCpA?=
 =?us-ascii?Q?RdY9Q0GqpZJgczfHQB0bWWFFXhwkgLqqqBWjzY58z0TquHbvlpcothiQ7REb?=
 =?us-ascii?Q?y/+lzrECpLwGfJxDIl3oqeA4xW5ru+A3goW1HpWEg0oz8KVHHzxxJPmk0D0Z?=
 =?us-ascii?Q?8otobRrWlbPnFquMu2mXbKkBMdwL8L6Ok+oe8/ALGzBa1RzqBPtfKS+p1vc1?=
 =?us-ascii?Q?8CtClg22AFGMvmQbqljs1KHvYF8xsh6xI9cBKt2Y1HgJu/ULwUAPlAalnZsx?=
 =?us-ascii?Q?2ZHFqUUzaTQ2RIoEvp5BRuoQIjxkgT6CJ1CJNvEHje+pdcMcXTZYBylX7Nwo?=
 =?us-ascii?Q?SGYk+J6iYfVdn825qKGOu59iK9BWToaOlhGCeUhXypGj9PIGGQ869aizx4P7?=
 =?us-ascii?Q?yvobfs4LcjnN2MoFpbv8W7oCQoffWw2hWDnzUaWal1VR7hIrRutlidmMhpZv?=
 =?us-ascii?Q?7J3my+y5p3xZ3yXSCmd4IolN/Jvxq5CbHgc/uXba+qEbhxgTdVaniy6a6t5X?=
 =?us-ascii?Q?Wc6NwuMWrAQU5SyK1bw4VrGuBLmodSry8cRC8BWamuQQodEMVrf4xEjpIXDf?=
 =?us-ascii?Q?Qvi/LaTCjyeA4DJWb4M+zoGG7YoARkXcvuw7MH3YIhFQnugk+SWf06FrjHK4?=
 =?us-ascii?Q?Vfo3QaFGrco5epDP4d+uiODBoBMwi/R2fbcVrhjOchngTUE3j4bs3rWiLWGi?=
 =?us-ascii?Q?fu7IlTs/V0DQ4z4Q2CfZ/kmYcoTtgAlL692WUxjmpC7IcMzKvPDaLpI9IKNU?=
 =?us-ascii?Q?ugAa6q87ED+Y6+Xjc7N2oGTCVdMCnlSg+0FIis4VgeyjCy2AzviQdb+9RJb+?=
 =?us-ascii?Q?MWLXS6rmOzM7a75/brhWQNzBdDz0/LR7H58XrUpb7lnvUHZgXLBzFTdvk+TF?=
 =?us-ascii?Q?uG7pvAhcW0MM5nSW6Z/CNvDXvShqTYbSX/wuvPXkRUg5kiLwC3UI1PY5QNkr?=
 =?us-ascii?Q?THOWncZ393ggAQZ3U5cmi+GQMX/LrxHBMrh2sgklRzf0YiPjAk9ETpbSQsaL?=
 =?us-ascii?Q?mG6ZNcS1ZZRK/kCgKCze4zfHZJktjM3wSPgdFsoSm2nUtXkTwTP2WzimQfLy?=
 =?us-ascii?Q?D8MQ9gyiy8SiBhOfRl6xplkKOQ6jfOtDmTiHCk9eKWujvUKNcjS5zmvT7lrD?=
 =?us-ascii?Q?d7flGZlwsJsYsN57jBJwCXUW3AqIdEHfh956cWSbNkZYeflEYoT9kMLEXBLy?=
 =?us-ascii?Q?PRjDW/rksTpjr5EbANv6j0F1d9417Zr/bLloaXvFgHdKty47SAETzNo5Z0NB?=
 =?us-ascii?Q?Roe+16Y6A5ChvGqAtTfUlff0pfThOJcF7dWXGQlk4lMmPM6taW8MeKE5J2H9?=
 =?us-ascii?Q?OkbKGqDRJ79DR603EC6qVPoMbhOnEUohvEX3O5hNN1x+4UZ/tRbULTQFm2w9?=
 =?us-ascii?Q?rQLmwUHhFsUaeAwAzbVYg8FsbuzA+ir6CCFaSn0oDK9N4K3qN9SZTKVAxTFu?=
 =?us-ascii?Q?1dWTaEPjBgl6V2gfKdfeagXX39q9MjEmmj7yTF+yjV7q0c73M1QYrjYxA8ML?=
 =?us-ascii?Q?zP64goqcxqhgI6BnHUSx0lVaLheMEcaLkGVZurK0FZ/8LLEem36ExA9A+sJv?=
 =?us-ascii?Q?HRaJXtQeeaqfwdWo9XqjVl9SGqs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcba4de9-88ff-478c-1377-08da5dc029ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:21:54.1042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U9zJqxoEqc/brbp4cR9TwCs1fM9r7m/fSp1FC3Csk+TZn+VIhd7vUk0TL3J4Syk28e7+UKfm3JehhKvtI3UVqu6CDqtsn/itA5Wo5ahrTYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
