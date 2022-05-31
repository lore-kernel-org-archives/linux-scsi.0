Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F26C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 07:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244630AbiEaH6E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 03:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237514AbiEaH6D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 03:58:03 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503C154681
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 00:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653983882; x=1685519882;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=IlX/dQXfEmYpTWNx38b8GHRnPSs/x7pMaJBMcyXU6iLHpU9AGT5mvo9K
   t2E79ICpTWhF7ld/13PsnkHdwjqcXUld8vctQxdYD2qcMKMa4MIyiB1hw
   GA8V05UThkaHvQ3iMmb346/Ux6P20VmI7SRjo/zHLfrX8Ppt5DvQm7CFH
   64F5fiKCEGtfrwZ/r2xmIHyYGS7jO0NQo/djilAGNoLtETQhClHX1CYik
   rsG/YXXYcPMOeZvYu+Li3/qNI/xoN/rMLOn/BhY/LUcZgp6qHHrS2hvVC
   s7Q0wTMtqklv1UodL2iy5pYmw3bjcOpkUTLToZbNDUKu+GWikwkXmd/aA
   w==;
X-IronPort-AV: E=Sophos;i="5.91,264,1647273600"; 
   d="scan'208";a="306104204"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 31 May 2022 15:57:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjUCBDp+q+LUx6VOFMM/INhM6o6iZBNbs2AuREsO10dmF4ZB6efvjPmvgUfdLPWhlfqhgzarXWZnN2Q06adP7+EHr0U/UJLdfU4YCOfMSlPiMXhiI559HnOO8kLrxfYNM3bx+K1+y5rsE7tvmGj2/MaPQzxHsZuR92agpUarYMQJm1abqqDkYvUAlM+hImaJG4ZlrnDILEOYcSUQLL2YnghjY/KG1Rucepq+1uQvEQ8U/OyyNnInWpGLp/d0nTCiNibtQxi5HicOV/D9JRKOUn6EYUJPP+eSlehy3llrb/Cfph9UqWlUjfENoMnwLiXbnlvkmmyn/2SNuJy56RYIHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=D8Fdx4cWHzahxIWpeGyzG+CEYBATlmVLbpalOIsL47G7KdMQszH/2JTMUhDw1Nqz4iJKVl/DSU0C30XHQFmHmkg9dGLS3lUbPYYBVIO7BQvuhoKS0qhQBA5m0h4lDbiUjaYJLGdiFheWjwK4HTj49cWSMEAZBHFTds8w+kUDe5YywhD68wVeOQvc7C1kgOZ8972GzSIc37JD9LdKrlKhtUOdKWmP5h7Cl8Dpzvpv5sSuccyuTSZ4+oDoywmv+UnTPU0bLMwdNR2x/pE9bt2iPZ6LzHNop8pKu4gK+k/6ivgD6+i1CYDw/2aFzKOZ8xALU9bs5qMzbkWrXkAeGiV+9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=awP+uU0QY28p7dUrZy5Cgc/tYHIKu+oKLb2+/LgDq5kpEPXiEQHYVKMAYxkLu0Ft0IN/n84mYe2ZshbFNY711Z7MCQ0KPeW60+xgiwWxidiHNIEEziemayQgiCKeMrnsjI04kizKlaxbBz3ae2ZktRQ5wIP4P26f+vQhD5hPp/s=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB5884.namprd04.prod.outlook.com (2603:10b6:5:163::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Tue, 31 May
 2022 07:57:36 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38%4]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 07:57:36 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH v2 2/2] scsi: sd_zbc: prevent zone information memory leak
Thread-Topic: [PATCH v2 2/2] scsi: sd_zbc: prevent zone information memory
 leak
Thread-Index: AQHYdIVccbC4BUNflECNs0aJ1nktKA==
Date:   Tue, 31 May 2022 07:57:36 +0000
Message-ID: <PH0PR04MB741680C12F4AD51CBEA125E99BDC9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220531002812.527368-1-damien.lemoal@opensource.wdc.com>
 <20220531002812.527368-3-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88334fa2-f449-4e44-057a-08da42db39cf
x-ms-traffictypediagnostic: DM6PR04MB5884:EE_
x-microsoft-antispam-prvs: <DM6PR04MB58842AD34144C3911AD50A309BDC9@DM6PR04MB5884.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r1Nppv8JJU5rZuV1BchaVFFMildjeW+BzLqzFwXWWutKAdmZU2IEUjtonvqyjBEXLczqLtkduO+mWM2T6yueNFPuSNHprw0LZ/E72lyN1jDefuXaKkHzU6SuMQaxHhXuZDYh9I1vZJnaDJsuZm3sYegkITqvW3w1cnrmhqkljgGOdoH0BypV83+UxxH7g4CvE/6+aAvjpuqKdpb6CXX1JgYAxd9wEOgSZ1LVL2SVTIc0whK83NYcbthGB9UFMmNZw3H4/gBzCc46MimWy5N81zezBePKu2I2iq2DAR5gHyfcBVDDAV9dM+PJfjPEbEzrBPovtaKIl5VkIlPJr0EDJI0mKLj6Tmuj6+aYzYV3X64rPATfCmb2QHrplLW9j11m5JODRdb3KwN/P0mWMJ/4Q+LGti8ZZ/bPS5E90AaIyUVf+QOWyiTu0uV4ezduVCBz0gCMUQGlArmcSBT/g8ZWmdXv3l2rSFh/PEGRhFCWh3ZjAIRx8UOoxJdGxh89T9KYXikhA9KeKxYyItmLFpiTZ/zsdIkOAdW8XDwDfx+fEynFZHNQGOmdKNsFbe3i9zBzAc7DeJGoXl8VHXcV3Ex1dQstT5DxHpsPmzEFm3qWEUMhHfyK7kIJQiMtcPCNzADa6F2iAU/h0j3GLaiXp9BrXGQ/1zo5oD/aL6VRICQZlYqe0Tis6pXfmAF9VB1Ypxg5JiSAIPS5RPvGPLvW+yLkQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(316002)(82960400001)(186003)(19618925003)(5660300002)(33656002)(9686003)(7696005)(8676002)(110136005)(122000001)(558084003)(38070700005)(6506007)(8936002)(71200400001)(66446008)(64756008)(66556008)(52536014)(66476007)(4326008)(66946007)(91956017)(76116006)(86362001)(2906002)(55016003)(508600001)(4270600006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UAi7sl1gW+jT3hvnE/hIyT6WB9vKAd0G8rEAall+Jod5/wXsv0oyhK0PYyqm?=
 =?us-ascii?Q?hXiP7IG/slNj850smKtsKSS8djS563zkaKDiz3Oc66ygFZW26wK1jSgCsbSS?=
 =?us-ascii?Q?qOdwO/RMroIdUUj15IjPtGNk983Imi3B58rD50Kht1q9mW0+RNjzBaaw++3l?=
 =?us-ascii?Q?pwvQH1cDC6rr/riA4p4aU85m6Z/H7G8v43lPJc3sHLRwXDiImbEfGzxBVZrg?=
 =?us-ascii?Q?CskNvBlQ+4G7hUnt/vmBPheI59Ls2JDexyIeL8EmGbnJv8gtlGaqBnX6kN8h?=
 =?us-ascii?Q?EsDmOm+lFUclhIw5uTMP7bFm7YdXr/fTaoHOrE1AslIT+7thGXiZoxHExYUx?=
 =?us-ascii?Q?4Zmc+VisV7DFHQ69XnzPDUNwezNT2/nrQTgO/JyDUVQSRnc88gA0e1O7mtkK?=
 =?us-ascii?Q?BOkBFINFK+Qd4qXC6fV5wUxZX4JjBvjrcDivifMRXZhM6U7aufimZQRJU4Vl?=
 =?us-ascii?Q?ErPFiuVJeerXs8yPYCplFqOmfAFpR9ue6F/uMHDgJiMog/94jzE/t628VF+L?=
 =?us-ascii?Q?Zy+n8z1Uz+qVrI1pa+UbKL+MzHMwMcinOiE63Dh8RPr83bIAa/mxjh8Zkvln?=
 =?us-ascii?Q?HAxywEb4fqjZ5cV/oDLOKcEYvcuIaAmnUh5XzLkKqDJ/6RPrWFdXYWXxjIvB?=
 =?us-ascii?Q?zZNlC4wukouN7008XLnp4D59UO4oc1N+yYE4Cj1GheQWRf7XmoTIiUVx19od?=
 =?us-ascii?Q?VIXRzxYA5RcQ9MAPHk1MHEb7xqBdCxYZ4q2xidXZU3fA0ENQ5rrVm4eA/AJD?=
 =?us-ascii?Q?OisCREZVIMKwFAoOmvB+m3N1Uy75hQTdd6NIdJByTR4z2OhaOJ7VDecF8JXo?=
 =?us-ascii?Q?pYDCKmtN9S1XZuNaqhDpVhILvO0mSfw+gFl3Xddy/XWb4IngkV54sLlpoM4c?=
 =?us-ascii?Q?gnIuOhAUqnb8qRANYBWN77fu6k4txo3ummzTLovamkPYp7IUNB9NgT0OKn1h?=
 =?us-ascii?Q?XLQTv8K83UaGyaIt6TU74iAgW1M9eZWM0qBgXiShSavfZ82ZghDEprG03IzX?=
 =?us-ascii?Q?OBglByscSN6vnXcodH4JB4ZSmim82NwaBPD7msdnexbCwGPaNZmKDVQbhSeZ?=
 =?us-ascii?Q?WwOpvLRdSfgx7fgZqF3KCbYj/QAz0qOX2UdK6V5nPkVnqC8KjijbHIuxtSKb?=
 =?us-ascii?Q?l9rjpz41tzNFoXpfgE2tCYfHYCHDRovMm2jgucDywYk4HH28Qa89vZXyRfHQ?=
 =?us-ascii?Q?ss1Mth3uPBsg8izUt+N/o7AoGuhKeY9/t2uNZ7T/qoVZrivZIxQQ+Ynr4uNf?=
 =?us-ascii?Q?B2X9Kuscd2ks5x0bYsfTEFo6aaZXJOwSoiLXYsqnrDhd0Q31XtRdRnQGWDLv?=
 =?us-ascii?Q?zMrRo66PhrbYm/FnaVZCZX2dItJn0KpqoVrD14sRx4RecBS+7HVne19C48Q4?=
 =?us-ascii?Q?kxzABf98OFZg4CSAQ4thXXQh6A0WzAbl/rnraUXl1+tLukjGxp78l1gEHnp3?=
 =?us-ascii?Q?GMxAzfxaO/LXuZNh0L33QAc63McoUveUlEJcgshPRHdhi/AUOFexqdUgp2Fv?=
 =?us-ascii?Q?HCpL3lG6klcptzm5jU6ctiGf/ZmNqWXbEUjZLnVnr5mcJsAB1/LsYw8FaycH?=
 =?us-ascii?Q?HAyK3M8Kr9lcVjrWS6VyoghIvqA8vyqsZ1uP1eDZ/x0UTcnTYIX7RRELibzH?=
 =?us-ascii?Q?wIIVqtjc78fOlI3DtaG1JC1kIhyuw/XH9eZWlGFpFtLeCdayt+3X9cb118OL?=
 =?us-ascii?Q?zyNeQFnFl+s23OhYZuVT6yxA8MzNaTzw1zb+lAYdBYU8hW/9+cod5yggsT44?=
 =?us-ascii?Q?KaV8X6LeWSOP+pwT6Ic+eeoz/+435Z2sZPCefoEDdVsdikG4iu2ulSlqWkW4?=
x-ms-exchange-antispam-messagedata-1: FNn9vWvjQXtY5xT39eJ9hDFUUqRSyjnZIJJPrFMcFmnlgvprWitX5LHA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88334fa2-f449-4e44-057a-08da42db39cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2022 07:57:36.1329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B3rnR/BwskLqSjLoGwsyvpNTEcGYrOfrMHNQ9UYxDc8a4z07GjuOBYwpkUb1cYV3yLXce1SsHqGzzXZj0USBdd5uHYW6Hkwj77No9vGofFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5884
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
