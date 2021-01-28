Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4077BC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 10:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E26E364DCC
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 10:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhA1KWR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 05:22:17 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36548 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbhA1KVy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 05:21:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611829313; x=1643365313;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=djOVzzbS0hZsuQ2hNDkQF8J4tsiJb4q9B0ueoA+ueuqe3kVynB8ahmTC
   WYT5FcCfED8F1OwG22bx0bMtTb22ufL8myczCGWh8fi6gdB70OKgC3uD7
   XCgLaSDpTV8dqZF35xgFtZNTb2wShfwaoZtv3cQUlL4jR/myu5rodm/+w
   BVzSShyokGeD1NJVu7qyj9TxRGB+nRP102xu39gU0SFPyN2GjDeu5Za19
   hl6Mo7UIX645s/XFnDtf7Q6OlYWuXrhxFJNLj3LpYm1NaHopll9FPx/8f
   TR3REkGdIDpNcdGi/6XY3b7vf4Q1OoBEOFE5JtnsrkKP8NsJKiYTjUza7
   g==;
IronPort-SDR: 0/Ownn11iOOOln2D/6ejdOVPdV6LyV3RJXRYLiqJlRFP8tLouyPrFG6+Z5LonaXMMzjmShUl9a
 8Qc2cS+ZJt5Var99ZhPlPLbVYiigqo+M1C1oeEW1lcs75Ja9TcJ/UztKMLO9nSm5EsDFBRFdjN
 /LzGvb6YtWnxC6ay3pGFswHEe4vrTQWRvSJUKtRKju/4t6KaRgyT4jMLxXqtlOq3jOjtF8jkTg
 KTCnP3nHKuJsI1p5JJzZIIOhb9PNGPtUjz7kQ5e5qTlPsOGSnH3QLym+dCDhl6/jS6L+81pzD+
 mtg=
X-IronPort-AV: E=Sophos;i="5.79,382,1602518400"; 
   d="scan'208";a="159709060"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 18:20:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hT5CbbPMUE5606Yzz4uOIXDDj7ExXrpS2/q1Ka09hx0/x4fAc00R9Bwp/waWIjTfK04va6GZcZtTiyZunYa1+nbYI4kTExnS1EDajyFX/JhK/CmWxpeXsvUC1EZDDvI7q4lD/WzPKCA02MTZBYv8+ekyoWaCoQ7Yb1Je6RYCmxv6/4EpZtUjuJyqa7EserEAN8dG1SC8Svw+mryUKPuUp712RLvGL9YDy03QKiWjO33Y/vfyBDW1JwFn3eO2iD0HVNc7Y+bLBd7qlFIr19dMYuzrArRNm2Znp9qTgvo/9ASDQl0VIedQ3oYOwgzg8Qh/CLBcFMhfWI1hQMpgpmJmPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=G7tRttjr5z7ugsb6qUFmPqlmEYJXQaGLy5ywMNyC0McCbC8aCuqSjsjXoCF0T63XGQSgH3ZSHTGlVJZkw3sMTCn1pHTXgSEeaW3gxjKs7ynSGkqWVwD98Yd4PYnajzG3sa5hgBedhmNmchXSTAAclImaOHFdT+ZPyE9+DaFpdoqPN/m7Yz2zdO9onvE04G1wVD/lcuE60IMnWExbkeJ4+muNG/hSaSFUB8f5BqROtacqj/S+dmj7tnJcyjTN6bZpyVnKeHOWtrER/83eqpa024fnwkYgYn3VW7C/r9lcxAP2XZK9bS9TNRcaBwTJjijzgs5T8AseoF15zCumZikk5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=u19aUvqlweRrQpNLsZkhitiGc4lf57EUuB9j/EA+6aBfjXkkAAweZXcMZloQ3F1iPiLMYot13okDPOv5mj9phPkhwetXacJBNm0OaPJhXZczQOvCSLl9vgGVzKpbkF6GnCCbaEpVesbxBebbwIgYfehOp5WWgj2g1aYq0fJqW8k=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4464.namprd04.prod.outlook.com
 (2603:10b6:805:b2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Thu, 28 Jan
 2021 10:20:46 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 10:20:46 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v4 1/8] block: document zone_append_max_bytes attribute
Thread-Topic: [PATCH v4 1/8] block: document zone_append_max_bytes attribute
Thread-Index: AQHW9TEkMgeHpmzBJUK18PNs2a0qPQ==
Date:   Thu, 28 Jan 2021 10:20:46 +0000
Message-ID: <SN4PR0401MB3598E30093CC3EF92E0397839BBA9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-2-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [62.216.205.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd4af1dc-74d5-4b90-9d6c-08d8c376604d
x-ms-traffictypediagnostic: SN6PR04MB4464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB44646F3246845C6A0D1BB1009BBA9@SN6PR04MB4464.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bDW6g8cMkdEv/Po3RuZv5maIY11NsYjbOXpqbLAazk0ZpZbiqOhtx/OHN9c0FeYoe/tGIVYNC9sjeAvoh5wEOnDxgxZLhAP4XzuMj+UZlgusgHv2Fw9jw7xuHPUYgIghtuuUSiH3wxBZd54xrfQhQZpLjAj37O13H6wqTOJadPlNu9aTxzao6oQ7k29NSFQw+ADoHvBlAoKu1+2fIAqRokawdZBWFPQ5Vm4u5EsDF7Hc/stAUld1omCYb8k1v8eSFerYnBLhs6EW9oNuKrtVYb25GdK2s7qzAmvVkEXEow5S+MxPFNfuoTH6BrEou96dkdpwdrnivc4B6ntAAY97P9x/3ICF+YWRsbkot9IG2xpfkesdyLgK/wuwETv7cYNhGNLRxR1nqC7z/Ua0zplOB804zoYFW5RHdEY+GPRES2UnezXKAJC90AwqSlxOnydZU+EWbwfNokMxQ9tXcbMiOM+L6Zbh5QTymDB1FrN6px5OQFwALU4tXNrYI17xX2OjfK1ayVwOSmj/MK5R55zb0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(110136005)(76116006)(64756008)(71200400001)(8936002)(66446008)(66946007)(6506007)(5660300002)(7696005)(8676002)(86362001)(91956017)(66476007)(478600001)(66556008)(26005)(52536014)(54906003)(9686003)(316002)(2906002)(33656002)(4326008)(558084003)(19618925003)(4270600006)(186003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CgyucL/mouhnFC7ycJ+6gkxehUZRI+vIKjgRDU4BUjY3JbYTVw3KZAvokeut?=
 =?us-ascii?Q?ve6hrpnfTSne76ZOQhqZqHFZeNhzs3w9sdPc27gcof025q5REEoTcdJd6EB6?=
 =?us-ascii?Q?t8rG2DxgBqvQRvToDb5rXGmGN6BAuPqWGUarG6L2foji9rjehsiYagpuQ0GL?=
 =?us-ascii?Q?S2JQoOEkzpKHMnfBevEyqpqz1x5xeaa4NyhMouqguyimojg2IM2UDuj6Go4+?=
 =?us-ascii?Q?kih7cPg21dUPUiJyriLhhj06VMj0Fxd9Xnu66dRi5Mp1AIjeRuGMz292Orh+?=
 =?us-ascii?Q?hOE5/weD5m9CGgpM/xGRQZukdcv5i8P9yhj8ynBoWwWfBA+6cqVB9m+v8O84?=
 =?us-ascii?Q?oY+go8IZFwNkvTuPI34uyzt3T4kGMMrWLwUhEg1qNQRWZlTI2LVEbWaMWV09?=
 =?us-ascii?Q?Jh2osTk9JsbaRjHtMeQ7dL+gkuQiX9FiI5mdJGdV/yRkbxqqsaeTxnRNrbgN?=
 =?us-ascii?Q?kwA7bj7QazAXdMycJh2OCR45Yyjb6daCPQN+4DD9LH5tomihh4SEQBa+GNhr?=
 =?us-ascii?Q?0fIcUxubWxmDjtclM8QnGlaLLr70GdsnWWCStacs/rX75t2mOXyZ75QxSJS+?=
 =?us-ascii?Q?w0RueJi/GjM1/6PW4PLANwLa06BnzUx8y65DdGLq8Ax+iUVIWGfDw/iPbVmp?=
 =?us-ascii?Q?BxoNR+TRNwOTaVU5rj0pTyG7F0K2lBjmbLasDOdya5va8AVmTmrbU+hd5s/C?=
 =?us-ascii?Q?JlQTUi3Ov9t/Qj5VWissrJtqPyjkdQs8w6SDagUETV88RohS5/F93XqKy/Ey?=
 =?us-ascii?Q?/k8X6NSJwGaREpuGpQViyf6n+bavmQWE3mCVKZX9/kuhY8XZkTOWbAUQ3vHF?=
 =?us-ascii?Q?Rzc+mDxj4Uz1eRhm3dEZKi99lrVZzMnZml2O9U7ZsrFJAWwlPf6Z2eY+9QcO?=
 =?us-ascii?Q?JOT0W7vNlThCiQjpWJVY6DqBpqf/mzibitaAx5uwNRjRhEyiXTOkTDB6BqND?=
 =?us-ascii?Q?ksB1CEocqXwXdxwauEQv6rjs5PLQbxxTlr/PB+O41py3c6j17mhifwLUBC6G?=
 =?us-ascii?Q?KnslUwJt6sksdC1vMAxYenTDm8VSfntl0zbcFED8uIgvyB48XtOR7vvVkyUi?=
 =?us-ascii?Q?ARfBACQdx2cyy7CfDfZghqHiXcCfzQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4af1dc-74d5-4b90-9d6c-08d8c376604d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 10:20:46.1032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3EFqX9X9KE8k2ZjCaB2H0Kpxkn/eF7wyYksZjO3D14dOluEYh7Q1m3cAV5lJSWhS2wZQu0tb4XCiBvm5xLm7hqn1orNiTxAiOoITHuSFtEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4464
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
