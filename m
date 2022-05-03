Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABEFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 16:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbiECQNH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 12:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239180AbiECQNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 12:13:01 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680A13191E
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 09:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651594168; x=1683130168;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=J98iXbKTbaIqCC1hckimVvjSLVBNeOSd1WnV05xqksM/f7I6JizVjhGD
   9du1WTCfnFmvbVCQiBHNNVvqY950/kVaIPx/jQ831rVrzrgLYhxBvBCEs
   k1NFrMAVAHJzcaWzPWDlOuG+ATGhu1CVIK3nSv41xLEUZzfN8y7y6bIJa
   JR9nVuE6ejwsJ1nemFOlyY9RkPE7pTV6iXx/blhN3E/BzMC4B0kwdaDqt
   PAquNAhE71ByEfHExlv7CiUtv+oW4gzdcwggNvOamdNt/L0Ay96dV1xuw
   HJZaM6zqUT5FRpzqE+4vOtiK9riIPjMCdvoPF6IoE2YHZttc2Ozrw79kZ
   w==;
X-IronPort-AV: E=Sophos;i="5.91,195,1647273600"; 
   d="scan'208";a="311407717"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 04 May 2022 00:09:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pm2TM5J6Jhdbo2lbYBMtF7qLkvSCRfjLx4nVU2rYcyTD+u93DGog1REBwmkG2hAeOw3pEFWfpxcQJoik4hjQFHUERTkbAWlftodbIX1N7oCDOg5YgQrI2WHJO8qI10hYlMVmG8ySj0gNzkR5vi5Qddg5lc3OJ3bW1h9Pc/JUMyqLQO+GofRTfC3iRFi0uHmGeYakTuKKqcCStNTZNDRIzlx4Y5DOWo6UXmsoixCnkilik+Wy2pylQaJK5zboDrnahqpfo6CYdiXW6O6KfFj+7FIqd1RjVRSiwG0xh29s3FQJVT8jutgpPc0nnm6sG+DoKpsgeL+DuTo6G6mU7TA3Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=PP4goyjWaDeJuTOauVxjm/p059nVldX6wabuHs3F038x6SVglbKMv8LKgA4ti2Rpef4l3rts49EM3+sSpyK7KcUa9W8dXMUL1WYjJ7MnSdjA2isELFnViUnz+7Em9I2GW2rqQhs8IwR1OCngaFEobx0STFCthdl5qmuYjIfcU9CZ63llNEw6St/ZnL5qJ3J1WcLmD5OitJzueNOORTQHLQMdfPwS7tb6DqdxwRuf8UG3e5pFS3jY4eeSeYzYM0TgRWO75GWkDiICzSQutvv2shbs37kLfQn1M2yCFB2Aw9htuLqtlaXXmH0LG/OhZSQaVbIiCPrlqcpaV3FbgJ1nuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=GvlRaMtlZAiB6nHLoGisyuBNx7GOuMksilpHyDtHNpobfA8IAOhEG7QjI7P5Ir6t9YHZ9DfduM0htgIrbKZDYKmhs1LAqn7dPUYz9/l9nhlfZx6iALWU5x1vLzvTL9DvJeR2+WuueOI/82FV9jnui3wukhy0AEIjZL7hPi1mEV8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7867.namprd04.prod.outlook.com (2603:10b6:510:d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Tue, 3 May
 2022 16:09:25 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 16:09:25 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 23/24] megaraid: pass in NULL scb for host reset
Thread-Topic: [PATCH 23/24] megaraid: pass in NULL scb for host reset
Thread-Index: AQHYXm0QCz99NIi6Yke0Y8Cbda0quA==
Date:   Tue, 3 May 2022 16:09:25 +0000
Message-ID: <PH0PR04MB741680100B0F1792053642959BC09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-24-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97421224-ce96-41a8-b79f-08da2d1f4b2f
x-ms-traffictypediagnostic: PH0PR04MB7867:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7867BA95D7CD742B4915978E9BC09@PH0PR04MB7867.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FKITXhKU8d5w18+RljNXUZu970rULMXK2/YodqHedIEHgbwRDdqAgZLBcNr8ip1ULCDaK10Ml86/5+2SDCPOIUDKU8GUc0I9jB2/FD5Br+EkG3XiiPhM+LtDIlCQy/l1ietKjhRCEmM+77xIX1GfIRflYgblLVsRPl/fOInRn0ky9G07xOzOdRK7Usd6S9/mwreg7juLEOQ3/ugUrXTigmtzAc/q2mDW3vQObwP2LaiElOlC7loGxGHdyOk6YjDw4GdlyMfvYoJl7GZO+ouFNkJ5PbuBVBZVnvxm9pc5wGpnOFeeB0oa5fIzw5/VlwQXCyWSjT7tuSTxhze04WqspklodQcZXtF5W/nxGQkOVUROyJUQNX1KThFynt3NdnhO+0eFlhcB5DbgBozIuJVI2OqOq17Bpyu7zKSklmACRPWaKIKRsyefCaxOOkAcZlNLqszL/TfJebHj4ebwBk3hyuueBRZ4j/T3SmdxaJYn78Bb+pDXpevQKsIZIIWy3VdFId5ekBFret3LgtDvOyoq2IJfAGi4VfgKH2HhRQpM7LTS1yFHuarX4wKBk0fOaPwKQVkdvgcQLvWhRWo/MBwmV6gQE+hjaMxkY9DeTCaSQnS4JHwVH6+0eu10MnhG8mswXJ+zV83eSY7rUqJo+02Bb1Bm18xGF5KP8jN10JNfLwZVArbYuMA5YsQtuXHlMBgNk3n6pPxqMJdCB9Y5KRXzRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(38070700005)(122000001)(55016003)(558084003)(52536014)(7696005)(26005)(86362001)(2906002)(33656002)(8676002)(4326008)(4270600006)(66946007)(66556008)(66476007)(66446008)(76116006)(64756008)(186003)(54906003)(110136005)(6506007)(71200400001)(5660300002)(508600001)(9686003)(82960400001)(316002)(8936002)(19618925003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sR2aFcEo0Y9WR31Jb9UnZTaihn+Jn8mP8ib7Qx7JAP3M0kWJUJsiHS2zvhsq?=
 =?us-ascii?Q?KlLI3bKjwjcRbbXh0eqVXGeZYuAyeJgz2bhl5jYtDwAJ4GJChc+GYxO8sNQ1?=
 =?us-ascii?Q?DWWzHPcga+vHa+ZpFVOifjTQmuYeG6qjK3sAKzKfGbuKQCIS2jdjNhErYXcH?=
 =?us-ascii?Q?iTiS954Z/F8L8NynpI6naFG2OWd9BSyDbdo7CQOk1FeW4obZPlVcesphqgLG?=
 =?us-ascii?Q?kAN2Z3/qaLW02q9dBHn6f3TV+I+f6EhO5OiTH7u6HCf4xsXPONzmPOckjD7b?=
 =?us-ascii?Q?nuNo5foEX6ZAuXPECffLMdabKn1jER/ycQbXSn1F5dkwXyyiizmA59KAzu3k?=
 =?us-ascii?Q?DPJ1F3Aam9Jn6nI+zyuF+1Qk+Q4dRPc0eSyuxMWymlQJxU04Pcu0LwrK2cMn?=
 =?us-ascii?Q?0IZZfArYBoUIHW11k2cI9FQbEvBHmScZouWYCkv8hJQUeegPDUtnW+k8/oYj?=
 =?us-ascii?Q?QNdpvMw/78fCjp72PtSnvREmop8qjHBzxt/VGo579/cYu1nYixuDZ/34kuho?=
 =?us-ascii?Q?hXbG7ft8f7F3YGY+sduUspP7hfEK6T+Gir2GX7cEs7nrD25eri0kdgh5MAU7?=
 =?us-ascii?Q?yvFWlgYBkNJhM5jjcWIgznBp2cB35SHWtkkXRqXNSMzQ7S3+vtdqjBcfrOI6?=
 =?us-ascii?Q?eUPyfS8NLv42OpgIkMdFa/1McL+VrQ0LCFxanXISvJTg+g2IFZrxhVWH4uuD?=
 =?us-ascii?Q?ZJMrOi3aM4tcWVQBOIKI7WVQxEkwFwHYPK36F9qb4UEbha6hb5w2huH1lf6+?=
 =?us-ascii?Q?RZgaPDcGq3jLecwgshx89SBFZQjoTrqi13YtBIcTu3foRB1HXhQ5A8QU0PAT?=
 =?us-ascii?Q?I7m0RCDoZFbaXRdF5qataeczrvlJ02xQ9cfc4ZphKyv7TjHu7/ShiM/onGM/?=
 =?us-ascii?Q?AHUnuolAZQwGuTpiYcn0oOa0VBlXa3MemcOOCSxEmkbnLvaHkvGPHBmkh0mR?=
 =?us-ascii?Q?P7hzIeNCE8a13N9M35Nwc9vQ4p02hoYBsTY9mOZnTGKe2Uoeq/loCQNFevna?=
 =?us-ascii?Q?OPqcnGEGXRsBdOMcYsgSyhxD3YzTDEvc37IiJibZSPcbrJpVadWQ9SOPvr2t?=
 =?us-ascii?Q?ZFIJxqFhmHLsFPlerNCj4AEab4OhAA5LAas1D7Tb/7LviFWNQwxTJMDCxQ85?=
 =?us-ascii?Q?FhXndoDUrbx8PCpeXUFcTe9OJ5K0TUi63vnFRCNTTQZtDB+rMT8vbVSdxmX1?=
 =?us-ascii?Q?x4Yk3wK/MmCz7Szj8gYDf9k5V9nog6EG3oc2E67Bkyf7TctU4TycovO9h/sA?=
 =?us-ascii?Q?Cg+NEI6pIfJANJnXaKa3ZEK3Z115o4eyAc+BS/XkoMStCB1JJdrfLlDJukGN?=
 =?us-ascii?Q?cTtUhKJKQFwo16B1JgzHiRgZ+frxap54YHjkskZm5Bw8lBu7bJgjfgNyo/20?=
 =?us-ascii?Q?zSFnHYscJidRJ/UmMNvmaJOfvav4x7nKLGztW3qCl4zQDvQXI4TRetXaRDMD?=
 =?us-ascii?Q?FNNynWav7kt7rFgVnqCOjepRBWPxXR8WBhpt5V1Bt0r45s2DvrRF/BYT2/Wq?=
 =?us-ascii?Q?P6c+GLsGq/Jdc90Oz708edXKUdqNAYFPRZUtOWnl/nxUySsgswuBOD4/hs0y?=
 =?us-ascii?Q?Hu+LX6CE1Pgdv3f8z9v/q/u/JRPUP1SiI4E+tyZzJE8nX5SG7SzWmlfKu4+5?=
 =?us-ascii?Q?nIMOEyqx6eCHrRMsM4rMc3vZoEA0Hsi30YEFVtCt6RkNXv3Ml+8zh8Zg/zYP?=
 =?us-ascii?Q?xPrMPQJzEEwqmxmeSvstijsBilXeEwlq1qhVzIkg7ZiVx+OD+BNN/2mC7qQL?=
 =?us-ascii?Q?aJrF7uCOkO4W2cttuLWuFC5c4/ZRLe6nwV1RY02BgbNe0HvV0kum?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97421224-ce96-41a8-b79f-08da2d1f4b2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 16:09:25.4532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +O35RF/FZd7RGcbQzvwvutZ0OZu3OJqk/k/wUjmKLvF2UMsovK5oPfrRxSIbORLBf8WcBk9Emb32Rd9u3llAT0r2MGRiM20/8dJyCPhUjzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7867
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
