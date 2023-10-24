Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2BEC25B6B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 02:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjJXC7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 22:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbjJXC7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 22:59:34 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFA710F7;
        Mon, 23 Oct 2023 19:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1698116366; x=1729652366;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=fsgcp1jpMPWsZMs25Q/J+X6y3sKQviriOIYFQ088Vto=;
  b=OD1y37bcsCbgCUI4rj8ofiYfutmc7/FMMn7onOI5zxeg8w8heHddHQnG
   pif7mwUKn6IpxXP6DPV/YysIf+vu1jzZpLJEMZuWWVuGwwlfNfj4ny7Jd
   46m6Qx79uYJds0AmkD13FLMdM7yiYbgVjFOlVJM9nEwH7Jt77YP0O9drs
   /AQ57F0zlTPfq/01dsOMZZ07M1DZhyj8Z3YLUiHy5/jUVS5YYf0X5K18q
   zhdCKyjIk3mOmSNhfaWpsHSdbaDWCqumEpbbvvus/rlKVg7wtduKClL6O
   aQHjY6dTRXoZIhBNjtINHe9AFAlkjTR0zTFrLirQ0x1P/DRqFQ9/J+Zch
   A==;
X-CSE-ConnectionGUID: XhEl0Kp2QCaniQaQ76mMIQ==
X-CSE-MsgGUID: DZ7kiG4bRfGPFPokBcF6RQ==
X-IronPort-AV: E=Sophos;i="6.03,246,1694707200"; 
   d="scan'208";a="456624"
Received: from mail-sn1nam02lp2041.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.41])
  by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2023 10:59:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYYvVfa0pL/nsota73MWXIbGHWiw2pGoai7/7feL48JalsyOVNFQDfAr2pLeY6Nea4j2bImHr+Gyi1v5WznT9PfP75Sp0Ws8CgTlCex8zSAgB9mNs20w5FqoeWWCpskjedkLxFvxU3c1Cd6OLCqiQEUR6dtsJ72tFeTvFQYvGOzboYr+Phepm13iJAHhwRbvTJ5/OyfV/bMo82WmM+dSOo0beMCq+4ZrAT7IPp+JdEBRIRpC7XwIe8ZGCaXxQePWsePbYTvhG/EOdppPE38ZXG+U5JUO1dnh1v6U8zkC6XvC1w7PJ+5zOvsfr9+i1aTNWRu1iOjDN0VDKT4hhrDvTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsgcp1jpMPWsZMs25Q/J+X6y3sKQviriOIYFQ088Vto=;
 b=GE4AncX3tFmfOh69zeo2RNpP7DFbibigXOrfOzTk3valf0CIfZGvwhMHBclnwmuAydp60itLBBto9BWV/TaGgM16qA02ZQuisMl0RgiUmyvDYsCnqwqcDNgV5FRWpQTHq/YM4+EPXjTrVvFKw6bUMsumHT3JsCJnF+018fGaAKK6QG8cqNP296IL3nEd+H2t+Xu4et6+aIryfpedN9/R1HgcoHpEwtTXurhoo0jAVvZ5tJ7FF9lyaa/4HVOqtH9UzC6v4fEeXg231hb3IZxALotDYIhp/8+dBtWWmTORvn/2HdrrzGWLdouU0QpPp5fh1Xg1yq67K0WLYvfQP8amVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsgcp1jpMPWsZMs25Q/J+X6y3sKQviriOIYFQ088Vto=;
 b=wuqbO5XRobM1Grig9lmREltl99tpYeO2FBVdvutoa/lIeEcgj/R5lbl00KLshAHec/+WE0lvM9Oj80E2rI2IMgm/9Cg32Kz0Pq28MVf8/jpROKkfOWeUymoigKYChQw7Wx01+KWXpK0LLL7ROEBnrn4djuPH+6LgzC7hwYgMpwE=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SJ0PR04MB8565.namprd04.prod.outlook.com (2603:10b6:a03:4e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Tue, 24 Oct
 2023 02:59:22 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e%3]) with mapi id 15.20.6907.032; Tue, 24 Oct 2023
 02:59:22 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Daniel Wagner <dwagner@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        Bart Van Assche <bvanassche@acm.org>
Subject: blktests: running nvme and srp tests with real RDMA hardware
Thread-Topic: blktests: running nvme and srp tests with real RDMA hardware
Thread-Index: AQHaBiYWTin4xWkZxkKsvv5vKBqfkQ==
Date:   Tue, 24 Oct 2023 02:59:21 +0000
Message-ID: <vaijnbobhxyz4nkk2csv3nfhnpeupbudakcn3qgmo7o6vii4x5@rfnfdll6iloo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SJ0PR04MB8565:EE_
x-ms-office365-filtering-correlation-id: b982d38f-af24-48db-65a3-08dbd43d3920
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QISyWRXGoySjYLxSmG4eswaf/Pvr0OT8AhKwDnx282lLhNP+GfJQO9YI6Idwu4ir6tnrXliVOtKVEiePdttll7lVwMKFU7LK2kS9Zmi/kAbPTqOH50uFizIjSIRuDcVag31NDCJc5c/2LUMdKgpOSg8e8j1D/bU1kwGnF03iZTnuhk++RPToiDiD47LFwD8qwHMJcL3r6DQeHAJze9sNqHk3p2bYMYKdJFJWHJRMwhlavBR4fE5COQ38tnrhjyXk67mVzvYwD4rdse92vPD9xmQU+yvcnZw5szg2plMzvNsVJ3UGJUumh3uq57E7sRmPdnZoep53PSransb+spcg31FiTgrnRmzY2R5z4qThnt1ZnyBvgu0V9VbB4nII1CJxqnigkvDww9QWq50asAn0D2HYeU4uWnUD9c6yhRAJ6dmcvwQbDn6wPpan43kuA4JWMBSoTNDe7tnv/vVydNp2H7Vid3ucf64Sm5fKtmmsB31BxzN9nMr535ZDXkeMKcKBxU8JZCqbEY9U4a8hGJWAkbhPerwHY6TOi33ZyzjEBPupH8kNmWL0BEO9rOapjscLH4VFV6cUCJKmsU/ougUdCLDnruoVTeVX6opYcFb29rA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(376002)(396003)(136003)(39860400002)(346002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(83380400001)(6506007)(9686003)(6512007)(478600001)(64756008)(26005)(6486002)(966005)(110136005)(91956017)(66446008)(54906003)(66946007)(76116006)(316002)(66556008)(66476007)(86362001)(71200400001)(38100700002)(82960400001)(122000001)(8676002)(4326008)(8936002)(41300700001)(44832011)(2906002)(4744005)(38070700009)(5660300002)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r0BqcVA6v9INyDhph5w14Pa7VkRhoxjsl6kgZOOHxOhm9h8MQ/mdE4MMPSNJ?=
 =?us-ascii?Q?gTycWSjGrTjyH/DiKdKWNc6n7fnr6/U4qUuzDWNTRL1/nfEZkAaAch7E/wtl?=
 =?us-ascii?Q?Vl8XDHFKgn3F18SbClQ17oNPYby2S1G4vrpQZZr0uwENH+1zJRPxT2hiuccG?=
 =?us-ascii?Q?y4kJdOnZj6WODFlvFNcGL8doLtZ02a1pZOzXWS4aURBjQ5CxfNw0f5ipnEiU?=
 =?us-ascii?Q?FiPM5ycjFV2J7v7Az//38BP/5w+166JPXDPBL4KTpzozcEnlFgcnZ2UGtFWy?=
 =?us-ascii?Q?bKBM/duWgccaLqTCUB9U//Cbi5pKx3JO7u9XH/yN3673TY6GZOerMMHjQabx?=
 =?us-ascii?Q?ksQ29+mQaFrzXrimSfMte7bmcKZoxbwPnx7uAQ3gD30vJU1VDB6Ajaz/K9HY?=
 =?us-ascii?Q?EFdwHLHmCh3wOH1WJrQA8WjzSrHc2UNOgbHZiGrbyO70ZKvTF1uGDuGgrjcx?=
 =?us-ascii?Q?AjaWSxzuPbEkV7k6cypEITZzSnem0LklA+4KzrTL5E2mP5NLYbA50H3HZoLj?=
 =?us-ascii?Q?2DrBS03PymjPETg2ixnUGjAwXnP11gfBtmcpfyZUePune3SzSXoNFgacF7Dg?=
 =?us-ascii?Q?hl2boysYDO6nuw8j0yYqLNYzazQfqpxaqYRWCCLYFxRscOmtW739e+Y1gIKL?=
 =?us-ascii?Q?siAQcaj/Sa10JllgjcuCvk4yi5pYoW0cK1Vm8/nXgKjKzffsTnTe4vHf8YHp?=
 =?us-ascii?Q?lkyCXBD5F6QmeORAbwjQ18U3f5mcW1rum7RMoReAvIpuDWLns7iWPMkZ7ISX?=
 =?us-ascii?Q?/m7MF1D4ad8pJMS4wj3+zM4KxizSJU8w2rzrC5qqBeTKpxFrM0QOfbdETIwv?=
 =?us-ascii?Q?0k+OGRYCApbAWs1ohCyOokTLv+Cg8NqjkPKDvtFHRwwVUYXmWPJvBFO9riov?=
 =?us-ascii?Q?ifGhh1yDKlN83DgNbo4K85+DCD71SQ8ase4OijIv0merD0O5dElv+bn+YnDO?=
 =?us-ascii?Q?L/yXLkSQifUXhOjVicnKX6F11xmuA2SFYBGmyM5FpXFuM9f0Ahtcglbtzwoy?=
 =?us-ascii?Q?ZCsUV9oDKNDQwsMD9i42so3q7DkXs3a83GE1cRAh/7jPYluwmbVj9GlT7dZ+?=
 =?us-ascii?Q?XL7Vh/WYiz59UuJk0Ep4lh2kC+Wt2GHbSCrp9s9i+XrVgOGJCKjV+tpdw4nx?=
 =?us-ascii?Q?xKOumNPDYDz6YEKxBS/8tzl6apheVPReVrPsyri7Sc+xMwvpbHX0hhe+J6GP?=
 =?us-ascii?Q?23f46/iY3En1Bz/Iy4UpTkF9rzX6w3cpqOUiE507fq9c2wECl8ka4GwKAA1D?=
 =?us-ascii?Q?B43ozbfmrhaHqtyYEdxHXqyoWodIBg5lqrZcY44iz6r2HEZ/HMeBX7cC3lGA?=
 =?us-ascii?Q?Fiaj9PWrHwqCDRtq/NIcJOA+X3WRfloWXDGkjIL8cw61ayOeT08027McThp1?=
 =?us-ascii?Q?tBXOepGs+mZVUaTRZBH5+5XIi5PzGRjZnKNgZrA9DwoZHHOIMORJ6W74G8Lb?=
 =?us-ascii?Q?T6i00egy6g1q/AXD2JWAgpk0xAwmpVAJSPv+heUBJD0DbBRseeWf1PmOZYt7?=
 =?us-ascii?Q?gM+wrjcX/NhhPuORDcyjYtJNs7Tx6j8aW9ak7cVHhGkKZh+lLloqHpuuSNEa?=
 =?us-ascii?Q?Del1r5XC2bLtvhqSaoX6j+Pcp7+mcfhk/iwCt173xT780zvYD5Z6rvfGA7JO?=
 =?us-ascii?Q?Kpz+rjBLlZg6YpmMZ3ls5yU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E8D2660223806C408064B118A3016F47@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GC/H2fLyY66ikMT3sLwN1g9WU4kmLCXq3sikFUM3TS3gi4GTHZm/qVCgqtjc4ARNrIZQYY1kRI7GW5Om6IJ9DWuEUY98lHUjTzZ/sQB03c08YAbIQHJ9SGCyLRGWVsPV8c9wHIF7LBBaAqLCJmaU0uKM9RjJbzfNofC8kqwaOYGtSf5AU9fQt6xX8afUq3eiztNoOURFR7A+lheE6LlFIdLWDR77wj5aIms1UuyuFowq0uWg1q4RunUYYqdjJpYXwHmVLv4nX/8NDoIlK2hFXXozrwRZ6zM1/xvKfSji455sRoQNP91pCc5eA3unM+WHalyWuTL1HScwYp20elYkBFXfgDN72I6zuTdllJQT5PYNUjC8+w8oTNMs3BLoQeYQKO3bWhihEzsBkEbMf4vzOw7kZnXLkquTigEzc800wnq+VqwWVNeoiXs0aE8ZBVpo/DPF7YN/giSZcgAp9sDViSZVQMyVOulQpzC7lSnXvmkdbKzijznBkC04J6szOw1wGL4Ku61CoOHN3dayZm/3dbWw62ddE5boE9eW6lQirkRkvObfo4jpAM6S3HuS5E/zdgHwVCdW7DlNMBi1APExPLrnFRi3VrFjpp9O9QbLNE0EiiMcEPyJr1Fa+uw11rBY3iVfAakwcPSJt4jICVConyofXA3NyrCktJ+bPQxqsu4uh/tTHcI1SpmTDbIzQpalKme6eodNWAuJoM6Ni15nvg34r9ggyt9KwMJOiaJbvUwsQOUSBKmajNje7AtP1LgZQZhDZ3zda4wWgYAvum9fbz2K4heDgiynwsFk41l8woFY9fGMzMHQRLgdnGO/58uuqA1G6+rNdCM+SvbsCmjWeMz1v6cpU0o1TgcidtCnpzMpFTY1+OokSF6x1pOxZtZYacZLnFXHmu3HTWeR6Y49cvJOlZ/eMG6NBUr6hSuhCtM=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b982d38f-af24-48db-65a3-08dbd43d3920
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2023 02:59:21.9036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jl45FI3BZTI8XPHFuWwpzk3wgU3j54uXcrYgmb4vDiwSizjUzCAgSpJXcNOOjX6otMNu9JOGYPAmlnPciwLO7CDa1+rZnsVi/zr/uax+iUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8565
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello blktests users,

As of today, software RDMA driver "siw" or "rdma_rxe" is used to run "nvme"
group with nvme_trtype=3Drdma or "srp" (scsi rdma protocol) group. Now it i=
s
suggested to run the test groups with real RDMA hardware to run tests in
more realistic conditions. A GitHub pull request is under review to support
it [1]. If you are interested in, please take a look and comment.

[1] https://github.com/osandov/blktests/pull/86=
