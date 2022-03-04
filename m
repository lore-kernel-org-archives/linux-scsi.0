Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF15C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 09:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbiCDJjr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 04:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239248AbiCDJh6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 04:37:58 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494671AA49A
        for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2022 01:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646386591; x=1677922591;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=iadUryfFt0gBsFoQ/0gBlxUQCSablpjS+rkSu1sXDQjd0QKhxjq0UGp3
   jhbYsX2AaC68axSxAAtd+BNmAsZ9YRgxGfou7zFwWDw6pTsrwd12vcaxy
   1Pt1b5F2lRzS2PkC2RkujXpEP5Y+wEMawnyQcduaqh19f+U+TceWDOhQt
   M2jf3pqtA1gcsIGBeVVQxEtzRbrl9AQlZyFmKcxVcysERNxCJ/ZZSzgER
   rfOBBOOhWdKiI4rVXPSYmiCq1J/bV1nPMeIwrVMCGppAWOSsWkiXAaktz
   pt14dzr0+yaLYYAfmoX3Mi89gUS69WiZdJQJiNq0EWRLWlm32RhUL9MzJ
   A==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643644800"; 
   d="scan'208";a="193414551"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2022 17:36:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3B6wHg00bDTZaEo83Sh1ghL+z8HYV+a/0MuH69tq76hVWyfSlaEWLQRGMQqiWPhdy5w3yLGpmd+ToxKIR94y5dgvo7EgfggwBT6/hSDyucw7SXJfu+q0vVyicKjHl8NzBT3HJ7k0a8zGdbSjPFu7PkNKKuYvnJFJvUYHpLoNkCb3bbjgk7bc+eMzQ96ZxXyd8s35YBAHrL+KUmLHjqZDsKnQkrvjkS45UzNMEp9f07WLjcvrL4siz7HEPR+E+0MDthknEf+UYJoDp51FQvYoetJNpmLiP4m230IeozA7g8HSHrks2K5GRYIbdDazZxG72zQuU7eMXgHCk1I5ClLkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=cYN7qAasI/AKjvSbijE5RtXZy4QyLUE9sfODthcB+s+Q6EIpieoGrfGYJvdyqDSAQfmVmo60ZtJZG7kJyWMbiCrEq3D1CfNNjfkk1IxPfi3z9fH52KV9lTvOmojW+samjsM89CHyM/k5o95ZN2JB0rPt2It5OanbxvAjWOwBlQVAMOkThZ1Q/XJsrxpJuBiGbRqo2Tn+1JbqyrAVr3ejkBzmk1K4nEKD6LH3G57SNV2Wb/Hw0HpgIyPgtEx2QLT2aM9tU3T59g+rDMOOvB6t2F1ojD28x4bm4XjzH0ISz3VJ3M5iG8TE1lfAUwUId018nBwnisdGcID1Pqdu10jIPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=z7Ztn/uiAi9rbkGLr63vFLlJ2YbZopERX7q6If//OkxZRWO+OZo6LgrCzkc4RTG9KBIk2P0HhzW+Kst5QvWVq4CI8p6tRVB3uinV2CO33dCfR+Xp8/NDpOvRWygK7Dtz2JCGB9u326XSfiLb8RDNaY8IOGL+9Iu5yAZirIaf9aU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN8PR04MB6305.namprd04.prod.outlook.com (2603:10b6:408:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 09:36:29 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.014; Fri, 4 Mar 2022
 09:36:29 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 13/14] scsi: sd: Reorganize DIF/DIX code to avoid calling
 revalidate twice
Thread-Topic: [PATCH 13/14] scsi: sd: Reorganize DIF/DIX code to avoid calling
 revalidate twice
Thread-Index: AQHYLfeFhyebsHHePEay/Hhv8MWXVw==
Date:   Fri, 4 Mar 2022 09:36:29 +0000
Message-ID: <PH0PR04MB7416E43D9E649D6372BCB0249B059@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-14-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee38d847-f148-4fa2-f345-08d9fdc27610
x-ms-traffictypediagnostic: BN8PR04MB6305:EE_
x-microsoft-antispam-prvs: <BN8PR04MB63050DB27A45617796064F5E9B059@BN8PR04MB6305.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zSOCscf/18yRsBtdAJmR9GzYAEs6yXAQkmjr9nluEFFKBX6ndU6+vjEja4saoGxWMhgshGtN2+PJ+llO70u7beDX7zwK4TanLUbLwZst8lX5GBxhggbQ+eFmnjYHmXCAJINdwp1ELcjquwiGwHui9OwN1DQjGnLgISLt1M650Tu0vqxjIVZe8r4pUyq4u4lww0egGJXPb4j9MZFD46mnaiF3A/JKScBDCW9zb9cw5WlMDabZpqGX5mXpd75Ow60e3NWu1hgOcrhLocDEYcVJB/RJc7WnHbXG/D4IgO4LxTXe8EZbjTYoRoE5yNbBrcjVKVNoRx8HLyOTkZ0KpuJ3J9Yzm8bpCtwdU8zY4GZA7epXLvJNUk+7lZdBe0PlQOdVVedOMbXxTwC5Q9IxqfF+UhUVYZ7ylVp7Rd4lpQyY3UD2L/VdA5c7CVjOltAxjk/jn/rOt5NJvaNK0FNQuO7pxWGPhQvQddt5erbPvaAuggMkeEjNjeLAqMIz/aOZCos6D8AZMhtDOquOnskm78aqItpU0TsCtff+cfaVmXpZGIIzRYSG8AQwV0/TEIuATi2gGqNzC7/CYltdPy5UiiiWRSUxUkyi5XeAqdBcVVajiWbd1r19JF622eBZr/usSAX70cusNau7MMYQzEt/h0nIP8Qh/mh3+IJhaVyRakOMT4AmOPt+m1/PwLdnmSUT7jBcHbz7obE2uMYKduScKDOjuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(5660300002)(4270600006)(66476007)(6506007)(8676002)(64756008)(52536014)(122000001)(7696005)(33656002)(66446008)(8936002)(110136005)(38100700002)(82960400001)(508600001)(186003)(558084003)(71200400001)(76116006)(316002)(91956017)(86362001)(66556008)(66946007)(19618925003)(38070700005)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?znAUAUJhxdWIn6+GcRtSeCOSIQ/yhP8582RHTOmty0lHldw9N3+rv3o9DLNi?=
 =?us-ascii?Q?Sad+URM6EiR97Clir/0YJnAzOcbOPFhUdpOFoliTl4Bj2a9y1NpKCZYnsk5a?=
 =?us-ascii?Q?qxEq40aIvPOKmkhjHicTVDR9SJ/qq8nKtiYFdiq72Tisof9M0vPo3rr3EKWD?=
 =?us-ascii?Q?Vmy2GlO9Vxruikd2urjRf6f2cjrY4qzuvjxlT8Ft6EkIqrGTFoSLYidp0Fok?=
 =?us-ascii?Q?LQiMHIPfrh0b8+tf3dmjW3z8kwtbhch3JR+eTNdChQx20V9iUGDabT0XS8R3?=
 =?us-ascii?Q?41T4Qmg7y+2V9TGdT9kJZN7DsDzGfdxL3yfOmcg1p9M13zSpUwEctom8teCS?=
 =?us-ascii?Q?dAHmakQL7tNaMGWLNDj3xApDaeAdgfuvXPPuIfOeIwEUa1dw6LNkVHeavwzl?=
 =?us-ascii?Q?OU/PSu6CAoxZbyOzDIRCI8sLx8mS67/Kok96lzfnGDjMIQA1c4L/FORtXHZe?=
 =?us-ascii?Q?Wcx/FQjFBD0zj7upyD49BK7mjqAX1EVdeRVhUyIHQ20xJQ4LJDlBu4M2fd//?=
 =?us-ascii?Q?B0N6dAJ3SLCzg8OQ9Q9fdAaU1x7Na/GlLKKw9RspVIZ1nfirVIlSuumouuQb?=
 =?us-ascii?Q?T3eTeAgDyv80dgYlO5TJGUMp4MkiLVpzJuJPcG/0yItWYK9F34yWemUwGPZq?=
 =?us-ascii?Q?ThZR1YEnhFDp3w51HHVigffSK4a5jHLNVuoW3XwNldwATdZ0bXdsk5I29T+h?=
 =?us-ascii?Q?Xz2N+PWmvCItPTtP1mNALh6VUwppFIsmU6+KT2HXx7YxHRMZbtzejfsiDvVq?=
 =?us-ascii?Q?E71OyBq9/grsiP2O4nZbyx5c22Og9IwrEgYAp0y0aK7bv4GY1lkWOoqPslHL?=
 =?us-ascii?Q?pHhgQOnvb1XjZoZBEcfBL8yYfHchq7Ga0oYPBvpnpdeu6ERnhfQtPCHf5B14?=
 =?us-ascii?Q?DmscwblJ6z1BsQBClv4Iy2wn1/8Yumi8OL8tMuHJGfu0+WYKl9NR3Y8UFB9T?=
 =?us-ascii?Q?lgfxN1a8zlGDoaenr0Du4CAj6woaQRBa5VWJ0w8WRXuek4vDkr9+ttcFHkg+?=
 =?us-ascii?Q?D2wLHvJhEBos+rWqWWx1WfV95Ayq4Jh3wYBFPKpaj/S4IMbBCHM8kAlZlF43?=
 =?us-ascii?Q?0K+E7NPA+E+Rt8Sc+wop4OfZzjzCqrYEN2AIytoLTDCxVKRWRT1GIdxTcqel?=
 =?us-ascii?Q?6NZ+BBsQpEmDMM/vHSboverGmNuAAaXTx1E3xjeuyIsiIXGGn2+cPI38tHgU?=
 =?us-ascii?Q?Z92JRxggxPhQ+gRzWVrvrxbBgfVn7fNpYRoW261Uy9e2WfUG7xxgK3BBeUHq?=
 =?us-ascii?Q?uYT1HOPmS7KFjIZGN/htXkH2z8xLS/bYBw1zJ5rUU1hMvX+/Rn1Um/nExMiB?=
 =?us-ascii?Q?pef1URuFfOJ2WL83pIcMHObsevZ+BfJBzVL7nI6vGvJHo67fR1VwJCefExaJ?=
 =?us-ascii?Q?tc6SXrZKhjkj+f0sGZxcgqkP0uozo6NokNytFo5hpnv9rANp0YhQTS4DDCyG?=
 =?us-ascii?Q?JCE4poXVaJUOWaicKP2iL5FqqnZ+zFnvv7Ys7eq68AxWmCvbsY5LuU3hiPHL?=
 =?us-ascii?Q?pSaesusQgJyY4zjeNInZ0Ml7iCOqYVDp/eJYYu/EY6WqV/rVnF4CORmyML2N?=
 =?us-ascii?Q?Sh6syp1X8XH8Kp3BRPbD0vouH/V4TSasGc7tgtBwp+wRGkIY7YlihCK++Qkf?=
 =?us-ascii?Q?1fyJ6lYsZoCcnZ7yYxak5ily4ImwIv3ZZ3S5fHv+vqNFG0FzO2kXC79DwRBo?=
 =?us-ascii?Q?w3FCwzf7UTBSivfpaEG0jYJJO40ojHx+AIflHhaAtzdesCI5/u8FjoA8LkiC?=
 =?us-ascii?Q?Wr2e6VkS5/Zg3iXu0Pd0OuliSH/ZK+I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee38d847-f148-4fa2-f345-08d9fdc27610
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 09:36:29.4691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ScIrq3y+LrpJjxBQxRLgMY08arI3VBYwy1ak2kuL+pC4O8Zigw6jKMTaGFTxbEBZ0OVLX36a1jyYTlOmJHrT55H6MEMdNXhDVwc/bANpQs0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6305
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
