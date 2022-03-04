Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8DCC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 09:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbiCDJdY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 04:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiCDJdY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 04:33:24 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEF048300
        for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2022 01:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646386354; x=1677922354;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=HZlUvECmyq5K/jEklMZf28AZaaipBJv/V4SrtMkvW7Jpq9pH4VOaxwpe
   sBMUtQ1JAyh8dr0BK8e7PM/diJn+f+71qvvH6b+JSUwpZt4QHUhDGT8iU
   88RHTinyVEJK85FyvkdLgbuTDMw0M5SnhmZgo9UVISLwkcqngD/ybCdB5
   pesm0qH2ixzYEdG54FWVaWQiEfzu0OQlK1HKlOHoaQbtVMgQy3NgMAcdw
   erCoBT9mADUJswnOMebVI/aDL4iS0asJVhbx3hA2oh+ldcEKQWdJg3vkM
   Ws8Pd9HAjNSyEjxup8fTo7J4zZddijTTckFq6uEe8Uru2zIs3YNEuqtDW
   g==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643644800"; 
   d="scan'208";a="298613400"
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2022 17:32:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I69L4hm2rV+PiTmpBMoEqo7NB0DDjP/uvD8n356K4ZrErkCN2b6vaSbxqd3Jj8b51QSXl0RV/GPTKsfs8SnMef3MXz05/Bv0kXbBs/3kIStEg56dI8zSnFNfvto88mPKMyznjreFpl3QMGDZHqFDhcLEfzXxKm0zMlz9/+TQ+qOhe2BXVUwwjT37G3ccBsl9z3DrKqNqsR/DXOOMzdnjM91z4hr7O0TKaeeDK0NrDFTJUVms+5X+K7xonwEfgagH0R81rXvAQEmLi0ptyLbIlIHt0PSayzFSNIPr0T3T41qMb6sIEjPCWcLQdPpTHI3TYNL8jiXBMKDhaWtWvCmXbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=dqyvpZHUxvkq9ilpgL4B65G/MkrEiQooS/z0w0ZdTsAPihCBmIExZ4g8EQAdUmRSFB2KCFO0WcWSetP7+mzULOi+Vs9G08PtUa0Od8R0alcpa7umCxrmR2nv44T5WjQjNbZdLX1qytWuyDBw1roTM+FCUZDpo1MbKCTeKi4BziuDgheiaDH6VN7tanTu96rXOQhoBm6/rHwMG/1puQseDHJkE+xi7BWJ4oM6huoFi9fnbqdQGz822HPavwhDJ3yixE90DWd8vgepImGlJw3oxEHf/r3M3BaU7O0H7gHDfLdYZ6a7EkeEY4CHBE0Qm+COl9f9hHJUhCCyhAo4YrggxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=RvgaOfKUg6Yub7XMeLm2VmIkoa7CUzSlSi7XJvBzpJln26S2E9EIAOcnqXVvbaodeQ+HMoOn2TXMxCH3G7BOjEHYva834h/OEJBi+2BXAFGnP2WHZSIHR3fAFpN1grlEu5WWvn4XBmlHFwJRxwv2aZdgdD8ccPyupa56OB9MtDI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN8PR04MB6305.namprd04.prod.outlook.com (2603:10b6:408:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 09:32:31 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.014; Fri, 4 Mar 2022
 09:32:31 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 11/14] scsi: sd: Implement support for NDOB flag in WRITE
 SAME(16)
Thread-Topic: [PATCH 11/14] scsi: sd: Implement support for NDOB flag in WRITE
 SAME(16)
Thread-Index: AQHYLfeF4XAnTgqY1k+30UJ4qCN6JA==
Date:   Fri, 4 Mar 2022 09:32:31 +0000
Message-ID: <PH0PR04MB7416CD86BC68DCC5E3C4679F9B059@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-12-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f832081c-32aa-47d5-fdfa-08d9fdc1e848
x-ms-traffictypediagnostic: BN8PR04MB6305:EE_
x-microsoft-antispam-prvs: <BN8PR04MB6305A2EC9E21B6DADC4D5CD79B059@BN8PR04MB6305.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uVobDkIcMMgKK5EY7ovpsCTgw8V8PVpPTB2xGq/bLG9iLLmxX5/AC3yNrOGS7Zg6d78qnPZcxq2is7nb7cLdjnXi1CezvMj8mkElC27RxoU1xKVIB+ji8YZoEyIRHb8PnS8b4oiOpLESyg1lXOykwTghFDq+PQsRRuYGNUt36wQlcQN8P9b9Y0st5uIr4tYdQB/OOMzOkjMC8GmciN7EGRuYASeR2J4uBhl62Dqdwq/jImXAluBP1Fc8dr5d06QBLyWBOfaxC8P6ChOFGx1pedlHLw0OZNrDaoeu7HBQHDFGdYL/Q24ENIezB76NAvz3CyVp+9CQt8eI/FrAXLg8bhZ8ixCOx8mOuPMJ2qFfhq3xPB6X7OzD/2KLBexppdTjFpFv9w2CRcLmfWSeOQrEANMT9u9NzJyf30/tOCi+SyfPxn8XudOeeeCeRM818BzDnI7DYlKxcfH5uRHLtLyDTNkGb+JksnJQvJ5bRq858FaJWTBEuM7qGZ0WWMFW+EFeU2tJcKVOp30traid4hgn2AEfP61AyUVBqO3rETG7wGjy9KlRQbgyj+gsb5TuZUSBjuOW/9IsyS5liabYSMljgt8grQL0Oged842VfJHQUnpHebkFnzyBsagfloitq55aee91JYAiGPNU/xrMy5VH00KZuv5rdURNUXKE6R/algVIjVvpCTXmb3j5LX1anbvZclZ/kBjKPNxEAJT4eC+p5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(5660300002)(4270600006)(66476007)(6506007)(8676002)(64756008)(52536014)(122000001)(7696005)(33656002)(66446008)(8936002)(110136005)(38100700002)(82960400001)(508600001)(186003)(558084003)(71200400001)(76116006)(316002)(91956017)(86362001)(66556008)(66946007)(19618925003)(38070700005)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3U8lZ6CVlByQTOqRrnW1Cpp16LkGnrddiS46PWH6DvIk8525JN+zZRRSvDjB?=
 =?us-ascii?Q?kAac5bsUMIOptuOzRb9sCsbvmOhG3K8XZdn/qI0JrZQXPlqzOx1o7+mMX/Sl?=
 =?us-ascii?Q?ow32JtlcJ1DhHz4bmTROoXeJ4RZm9BIZ9VD6TUYTSYokJJX3lzn2kvlHuJjn?=
 =?us-ascii?Q?Ii0VPLU/znQrqQqL010PtEKBfCXfqklLZGW4EpVIOkbamDfxSkouv1Y5AXdn?=
 =?us-ascii?Q?92FCfTePS+f7V3BYDiD3aTx9FFH2/fV90FkOzeuEM1lqiEwXkgsoZppiVqlN?=
 =?us-ascii?Q?Z01jFonzNC5ljpk/T1bT9JpWyucAFW7hz8TMsnKKrV3wUV39eA4X5kR8YU8E?=
 =?us-ascii?Q?dgsGdC57foygUBYFmyCJnIbAfnwd9YzfQZloK2GdN7uOt4RHLfO7oEXnNVvV?=
 =?us-ascii?Q?CLE3Ix5VQQF9aVQBhLzlNYofUXoEjmTtHHEdO+TqKsLk0Sw1XNRN5SWY1Ed9?=
 =?us-ascii?Q?FxRI26q695UjPCk5OyhfNWzwkunpuNwh0/PBLvSJTuhbgDTnNIQSSRCg+DJO?=
 =?us-ascii?Q?QcK4DLwMV4sx8zSpqpfZ/IEgd9ROJ1pVIqY1VX4Wwuq8yl3vlMLIF9Cbw1Sn?=
 =?us-ascii?Q?hOaCry6nangyvqFNe4svCH+Gv1Rkh5f4bjspQcFleB0mMyd7iaktR5QrCqaV?=
 =?us-ascii?Q?U25o89vTWJQJy0WUxluoui5Hls+yqJ8EvrT3HRNeo7qAALSBQ0Qs0ZXKwl26?=
 =?us-ascii?Q?oEbZMgpn2iB7yw1cUAZkJRgxliFludwfe8JQyk/CkONP4LRCZ7B1BTGQxpmC?=
 =?us-ascii?Q?ncExdrH4ak65S1vrZdvO964uIEPzeQQ4F518UM3MT9zwgbKQ71ckWJYSbhWn?=
 =?us-ascii?Q?+bTrZIJ98LevwtOtYoz3NQjHf7ZeGGAaXJe3vLys99fX80tehs+nYlleLTP+?=
 =?us-ascii?Q?9b5mPfgwZ7Cm5gMqFnk7/nb+9IY7IVyvCTw6vKPCIuFUEK5M+Y3OYPkHG9QH?=
 =?us-ascii?Q?Iq0RFkgFEif5GfyKK5bTdmTVsV+Ltuvw8kKHq/BHjYQeyrWJKhd8oQxU2gsC?=
 =?us-ascii?Q?wmx/c3JowTtEh4DUJoIIwKsHvthjDvMKqT4KAYZ836h7VNDb3JnW8dfo+mwO?=
 =?us-ascii?Q?TqSuyvUT0q9uvHaS2x4ILD9I3PpR4HAWY7H/bT46YmTYKr0qkcmmJqiB/lkm?=
 =?us-ascii?Q?EKvfWcgOyjyrE+ESFH70rUO7oFv9axI7qiq6TgLBBJ3sJBNq0xeG76xeLrNF?=
 =?us-ascii?Q?GI+B1YBhanWBnHxD3/6HUrM87an4hi7XV/CptcZGomXAMLeX1cbdOfe55O3w?=
 =?us-ascii?Q?F3z6/5thTaY8UWWHYUsaqD/kTdo444o9qDNMidZpPoTldb+3Jy4euGC+1T5U?=
 =?us-ascii?Q?YTQUtvIC9EeM6xmtwpzb8vfvnMkcqXVnfFvllGpd72n7DDKOqfSorQkiGK0s?=
 =?us-ascii?Q?uHRPEGQU3f4ZJHGrZWvT5HalPrDMFLRsVdVSrLb/yg2ce22wbnQS3RMaO5Dd?=
 =?us-ascii?Q?c0fcBChDDTJPpqbQdACH6KF2hNxnXjz0f7gFoRQBxwAiSpRwmALZgPKTIKWB?=
 =?us-ascii?Q?9kDwS6/THG5qx7MgLon3NnVi5XhTTytozsKYKjuOaGMyXTCQkEh80HUFtbSq?=
 =?us-ascii?Q?neDamBHUQlbxliGkjyrAkAljDs4a9+N2+VU3mCniIpS8eT4cyiloj+wrOraq?=
 =?us-ascii?Q?SDeSltoPWc7EgVryuotErux6ONg8SwHARGNm/vKMBlquPE3eWTxkfc7+DKBW?=
 =?us-ascii?Q?QoasKYY0AK399na6lkufsPu6iJUh4KU/P+TnniKJliYAFdOxLGvZ+rT9a8DF?=
 =?us-ascii?Q?DauqnBiAdiMnDZdwphRssaEnIcfClGU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f832081c-32aa-47d5-fdfa-08d9fdc1e848
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 09:32:31.5843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sUYCHOu6DsGj5LoN5MqvIN03wbpvuBl8ER5dB+sWu1UFViqluQdi/XArIS5ZxITT+WZK65nRbBt1d1VVafHQXjnF1nmBcEQjtzAkcyrT3Bw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6305
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
