Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE2CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 05:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbiDMFU7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Apr 2022 01:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiDMFU5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2022 01:20:57 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A7E31DC4
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 22:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649827117; x=1681363117;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eGUv47ZAsQ8+KGT7xLNPijj3vL6J+fMrX9D/+oa1e+M=;
  b=CaO/6e1jhaO6QtDgN64rJubVsnKv9xBvQihzDyOHz3qho9uvwuexxuFW
   WsF+zcR19wlie4D12G66/KnYPmNyHA+NGWqmUnnG04RyHZkB4ERnX5vD4
   YpZIhUKnJmZN3oCn8hVsJCE4fYuiXLq4NeGaQ5PkQbngw8NnlO4kgYQTR
   JJQBEXqAj2zBoafQSYxQJNJHaJO5A5bhpeAyNkt+Ehi17EufvyU8dNsVh
   LgoqPoay+QLUBQbFM7N3uvXFrmYITZehpHft8E0cO+IfMzOSxwW4meuwj
   xmbH4Gei4nPyYtk3lYH60PtVvKuY4dXAQ9cR5A0fc2wJDkLCXcDsM7l5H
   w==;
X-IronPort-AV: E=Sophos;i="5.90,255,1643644800"; 
   d="scan'208";a="301976714"
Received: from mail-sn1anam02lp2047.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.47])
  by ob1.hgst.iphmx.com with ESMTP; 13 Apr 2022 13:18:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfWcGKYgjvgtZzz4jSiTlCTZ/NGqmD65Z645iymBdNTK1MVFbWXBO6vy2V0ZtOb62XQI0ytn5Y/U+5dmZj7jqfera7DQwGto7ENH4MDw8MDl2VfAbY7rqNzPZ1yVilNdli0GWL580jPzw/5keEW1XhHAB0fMvV0g9e9cAOgdGRtMp6OreFTACj6mlmFnm7HqWj3ZXwx5LiRGWsmReMl2bWOjHIWFgIkQuGg0Ql34c08yKrBhAynXhuUnVOzTqDdpzMoI1zLsvkPXQCqvM7bAnE+BXcpZrAhRDhpjLZrYwVMDMv3eTl7Ctmf1vr4imuC+DFmott77DXTl4VAbf+XKMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eGUv47ZAsQ8+KGT7xLNPijj3vL6J+fMrX9D/+oa1e+M=;
 b=adKey2PuYeASeyN8AMuOmf9K75ZrDm/f39MYMGqVBqzkFMSnFBg8pKWPHq0I0oESKOJ60JQnECR9xKfd3lN3kxOA076iqiTopsdLOlCTTFpLiDyNYU7WvAhEdfcK5zn5QUm3AOkEAjzD+MUaamRjAYi94oFYQQHAEjEHJsCtu/Q2I0V4WgdDuxxuMEUKoTMSOhnX3m6NGHs3eyFpOcc0iY55zy9hh+MzShn2b7JaSerTL/lVYf4SsuuDYMHo1W6FPn+83Qa/IqCKfT80YF2HHUoaoGGyno72jSl4AJ69BrFsqJtQ6kIdkuE+eTRBeVMSbsktldKuMMdimUgfZcsTAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGUv47ZAsQ8+KGT7xLNPijj3vL6J+fMrX9D/+oa1e+M=;
 b=tMcyauRXVdXze+RdD4xS5GBVkFc9qbjzdxTEvcWRt2u5hDIwgyb3NMIHPzoBbG/VxQoVA11y87Tj/hhQdJc8zaodKzHO3CUOnfc3QWUfvQwFRRpfrTWLuKnbqa0KvJccd7pZdMfcJg6ixmRHWe/+hokz5oIDm/3JPqlUbUHk6UU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA2PR04MB7707.namprd04.prod.outlook.com (2603:10b6:806:143::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 05:18:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3%3]) with mapi id 15.20.5164.018; Wed, 13 Apr 2022
 05:18:34 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: RE: [PATCH v2 01/29] scsi: ufs: Fix a spelling error in a source code
 comment
Thread-Topic: [PATCH v2 01/29] scsi: ufs: Fix a spelling error in a source
 code comment
Thread-Index: AQHYTpnQrPBWyoRej0eEMYFLlxY0ZaztTnRw
Date:   Wed, 13 Apr 2022 05:18:34 +0000
Message-ID: <DM6PR04MB65751790A61E5E8A056D2BF4FCEC9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220412181853.3715080-1-bvanassche@acm.org>
 <20220412181853.3715080-2-bvanassche@acm.org>
In-Reply-To: <20220412181853.3715080-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a305424-c23e-4b1b-6f5e-08da1d0d0ec3
x-ms-traffictypediagnostic: SA2PR04MB7707:EE_
x-microsoft-antispam-prvs: <SA2PR04MB770741FD1510746CC032A309FCEC9@SA2PR04MB7707.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oAg5oDg+F4nYzI9Dbt6JPM+6s5iSR5rqPKZohfCXaK0pW2fgzYRegJX8SOEWuCCt3Tb7UHzIdDYurRgXAfSPOpBNOs7ObLlTHFf8R+AO3oklfZiMvePy6P8y8U5UkMjSEk0fr2T54gt5GaUeGC9kBv37Fh9BwqFOW6p6HBunhAjsQirsYcbd+hjPPYkojjBjn71Vjb1LKR9VN25oGteMOb+wUM5WzCzBA3CmE4rseOUld4O8n8EA7UC/TWioGjijd1zdFGRCyBBWihO52qwGtmi3mJH/Nd70k2dqTK4Ic3d+6rxQkJAClP1MYS6SZlQUSeEW2TWxCkBfIATNohSH8P8Jb9tqxIFW41JF9/hnrswl+EbuJP96P1PZQo2wAftPwjy9lGPOcV7zQ7MY6IJTGRUJbBRcxjcf8ZhuUFpFCVJS2nktxIt6vFK/Q6g6fz5Hkb60m204nz+9HVhOKqprWv0my14agAP/3TgD+4VdsLSPuSK2p70+L+66q27x4HZ/xdS9ZELGAsngWrNYNajrFzqQzOYriIpWTdxZ8FfecrPRotvuxm9XeRUqKcyBY0tbGTLkYzW5eiDDWWp6uAb0yUH0ow0z+MH1djKRa4KhIVJ/q5idtSm2ZQigHB9rngT0UsAPN2slqkvrywVitKc0u61105isyDlbLId6cOo82DXk6XfKLm0xlzNEzb1/ItDvGDqi6tLPYfq7yshpb255lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(38070700005)(55016003)(82960400001)(33656002)(38100700002)(122000001)(54906003)(8676002)(558084003)(186003)(8936002)(110136005)(9686003)(7696005)(6506007)(5660300002)(316002)(86362001)(4326008)(2906002)(508600001)(52536014)(66946007)(66446008)(66556008)(66476007)(64756008)(26005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OMDgLBim02CpRRHEaPpS+WNmv79FluGUyC1yPl8nf1L/5AhbjbTxTENTEI5J?=
 =?us-ascii?Q?5fLnAlGhUAToUEWjQfmtRLrSnb0dc6WDrOlhdk69AIhn6L0qiLVXzy5NXIFq?=
 =?us-ascii?Q?g1tDUZXX5ozaKyMICnofrzt4jbm/4yNpQUR700UM+Zr5RTf2zJwlok9yS6Nu?=
 =?us-ascii?Q?lGKUq3r40IoC+LzU5AKZZFE5u4mpDC4v+ffwl6zdiEb3DOLE80OlpoKY20st?=
 =?us-ascii?Q?QGlPs+5A2Jo0RpF1Ieb5cjaU3r6lDvUzw/HHRXD7lsCNuNMBaT+Llu52NpH8?=
 =?us-ascii?Q?5GdsJm/Wnw7lqdo/Zl9yIgnIbkEYQNj0qZGZ7kFVs5tgsl19x0MxYbs2CTG3?=
 =?us-ascii?Q?AYDWRR6JDMdzMZj060VkXLtWBTMzKSryHT7jxLuaRmDL7bNCBzK2Se/Nwl+m?=
 =?us-ascii?Q?SQ4Bm19ZDRrCJ5ZYcY1LkKiaZeg0iYw8S8f5c5b/Di1GP6jRFt2qJmxB/pPN?=
 =?us-ascii?Q?JLioZFS4bAygTioQmdunJuwbZsEsoAKszYh8mCmWISHKV3NVAc2CJBaddYfC?=
 =?us-ascii?Q?l3VfNA8z81mV8olvh+IsVn1GgF9mLuRgbITgQoM1hcr0TSeTzC2un5GKC3GT?=
 =?us-ascii?Q?4Ly9Pfycr9IDqmgeb7DRAEcXhUjjp3Wprdsh3fLz9YekvS7t8hC19amJxT5y?=
 =?us-ascii?Q?FZ5LiGfcWPzA68vh0q3EljTbtFebEfpJYSlqL1toBlemX4Ecno/y66VZvBxm?=
 =?us-ascii?Q?MQPT5kl6rao3a8NGzTO8ec5NMntT/WWwY33lP8GeTmEXYXumIclRuuoBukRZ?=
 =?us-ascii?Q?l7M2CHMKrVqg838AbdP9Xbg8No65trhcsqIp3Gl5MBZ11G2jxkfvrsv/l0qt?=
 =?us-ascii?Q?1pgboGeqoqsi3W38UQXgH75Qy5lywoj3ZfsL/xrEjbcKem8NcEnakqzpXJyU?=
 =?us-ascii?Q?ahjaD6rsC0yXvUUWyDmaJewe+h8vwZZu21vK2ssm6UiTh/iWAH8w1+6ScyYi?=
 =?us-ascii?Q?txJN28JAOne0fIlx0NsJCyxI4WyEhOjJYC72TET8rRuhIH5FHlauU7ZcbDAg?=
 =?us-ascii?Q?NtL6bLprRbtICFiPjad8+GWHw+vrPzjLHJ0XF61fLIoAhG7chMb7Jg/A3A6P?=
 =?us-ascii?Q?L4QaykDEELXciay4+xbaFldfSTVkqDe4vTGDWj6vpPZAhtJR4dvZIjurYM1k?=
 =?us-ascii?Q?9m/NqR4fpmqy5QTG12SK4lYOC7tlwxK9YidI7nAR3qcVanRBh+h/cSyYUZ8d?=
 =?us-ascii?Q?sZ6f1h/TYvX5B5Iwf7+TZYmkieen6oplzFf8YClXt0OBVaw2ora91FbTnHNz?=
 =?us-ascii?Q?mjWzohqUKippUfvxIJLkZYdB/7AT3nUyt+/xu6LLVPFFrIUIJg/BtIv1OhJu?=
 =?us-ascii?Q?GOl7PAdc4tgE184OlvOWtHV2EruShaBpa01128dNXMZoMY1xQPVbMyQLONCb?=
 =?us-ascii?Q?dD69gMsoeN+LjFQ1zjnru8/2GE0r5CPknWs3gv0MvgzIyzDiSQvgLnoQb2at?=
 =?us-ascii?Q?ONYk5TOKYOp2AJT5CFzRnFm8WehWRlT5ec0GeOhHbar3QDyge3cK/ThGHVOl?=
 =?us-ascii?Q?fWHT8tCT6mPXVwA933A32mAEFfZ978eOJRGMTUiNp0wQXTo/4aGTGSntAjbb?=
 =?us-ascii?Q?4dYCDpvAHk9qMhK/v8XaKzUz9aLZf/ovKdY74KH41eu2KzTcOx8slXhBcJr+?=
 =?us-ascii?Q?H0r/RJ8rhCS255bVr+h5oUZW8ckCyPPZWPsLyaxsjOE+lDsKrx/o07ujhG4X?=
 =?us-ascii?Q?k1uQ72kbJ1MODNjvUpLpR+Ov0CQsw7mkIG647jrbhi7kS2ZHt75q67XeFFlr?=
 =?us-ascii?Q?+m49ITR3tg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a305424-c23e-4b1b-6f5e-08da1d0d0ec3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 05:18:34.4722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RPkOwc4HQtdXT+u1LsxioFq3zqJXPibIRLyFdvzMTOHBOZ9iAWBnDx/ibcjPgCzf1c2Ox2PBcMlRZ+5uhtrW2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7707
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Change one occurrence of "adpater" into "adapter".
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
