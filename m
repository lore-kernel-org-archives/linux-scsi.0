Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BAECCA473
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jun 2022 21:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350205AbiFOV74 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jun 2022 17:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350023AbiFOV7o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2022 17:59:44 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-cy1gcc01bn2022.outbound.protection.outlook.com [52.100.19.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C76C54F8E
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 14:59:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUABctZL3FcGbzJtM09lvPgzKMSpTOuHk8WqWYxawsq5YqRnpTDIX2NQEBH2Veh/7j9RrY4xUcvq4mj/ZFHQioxSmo1XgbbyDP2elu6X6Fp0Sw273AjDEgCkOWcrjp3e4hAKFwkAesv3lq8nuJ9r2AcKaylaGdUkSInYzwdDI+2viMy9FU0qMb0HQ/rWkCFuWID6x6mTAuKH4sZYidjoHfndKOoCFSDLhtbByikfQn2FTUjjmnvdDLcaDW/UU7AQQOJFlScltCbMj4hZA+uWwGLapJMHFBmMzFCFp7cYrnXRmpaO7DwKn2i+HQw4fdviC5K2C8iq2ST4KON4jC3kFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQsm62DnO3DRMaTO7/AWxijWtNxIrL/VW/Qe6xhipJU=;
 b=bkwYR7P/ehr6M0zYbvqmQLFNosrySVitXyhFwkOUvEvS5xgVOteERemNGktWHksNEwFbcCDqwxonfhpTYbX0ZXZ0f3NJFQmlzoyvu7lFWveHRg+iX+rTk36/cLfL55DwS6Rb355gY5agsK8ZFFsBBo0bgbb7BDr1pv6kE5Z/4ypw562AilIP8WR3fV7fpKtY0NhVwqNAmroCk9U0+CX9vU5RwwiJ0RwoDuGbcdmesdJsuIKQL30rFoX8ncZiWFFG9aQk72g4dCanGJ9rgF1nU4dMuNPmZR76eDCSd4gC5Nsa1IzzeO48b4v89fEtD8sQkCq1m5fED5gxwZQT8WQefQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=permerror (sender ip
 is 91.151.71.70) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=solairedirect.co.za; dmarc=none action=none
 header.from=solairedirect.co.za; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solairdirect.onmicrosoft.com; s=selector1-solairdirect-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQsm62DnO3DRMaTO7/AWxijWtNxIrL/VW/Qe6xhipJU=;
 b=pksg9Zt8IOQa3hJ7sTVisov2gav7HtA+gDhd7YuFqa70skjqVdSvf2aXTiAqsautLLcQSrc9nc4DDFETqlM49x7hqWKkl994XNOHnCM1cxnu38bYwsWkSsWV7uRJsI23D4AsEgI74URsW5Xj1jFsc6IiNUCKwMIWDypvKEEdj9Q=
Received: from DB6PR0601CA0014.eurprd06.prod.outlook.com (2603:10a6:4:7b::24)
 by DB9PR06MB7481.eurprd06.prod.outlook.com (2603:10a6:10:260::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Wed, 15 Jun
 2022 21:59:42 +0000
Received: from DB5EUR01FT086.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:4:7b:cafe::e4) by DB6PR0601CA0014.outlook.office365.com
 (2603:10a6:4:7b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Wed, 15 Jun 2022 21:59:42 +0000
X-MS-Exchange-Authentication-Results: spf=permerror (sender IP is
 91.151.71.70) smtp.mailfrom=solairedirect.co.za; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=solairedirect.co.za;
Received-SPF: PermError (protection.outlook.com: domain of solairedirect.co.za
 used an invalid SPF mechanism)
Received: from SDSV152-VM.solairedirect.lan (91.151.71.70) by
 DB5EUR01FT086.mail.protection.outlook.com (10.152.5.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Wed, 15 Jun 2022 21:59:41 +0000
Received: from [206.72.197.122] ([206.72.197.122] unverified) by SDSV152-VM.solairedirect.lan with Microsoft SMTPSVC(8.5.9600.16384);
         Thu, 16 Jun 2022 00:00:12 +0200
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Hi
To:     linux-scsi@vger.kernel.org
From:   "Emerald Johansson" <marketing@solairedirect.co.za>
Date:   Wed, 15 Jun 2022 17:59:34 -0400
Reply-To: emjo680@gmail.com
Message-ID: <SDSV152-VMRcKlda1sn0004701c@SDSV152-VM.solairedirect.lan>
X-OriginalArrivalTime: 15 Jun 2022 22:00:12.0558 (UTC) FILETIME=[498222E0:01D88103]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e881a66-1f74-4d20-6ae8-08da4f1a599b
X-MS-TrafficTypeDiagnostic: DB9PR06MB7481:EE_
X-Microsoft-Antispam-PRVS: <DB9PR06MB7481EFE9A97F291D5D64CCF8EBAD9@DB9PR06MB7481.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?tl+NQyUoebq9eDUzO0JwWKIzEBFDzUmSXb6YO0doIDLVQw904qktv/bOxm?=
 =?iso-8859-1?Q?aSl21S8+lbv9BI7IgeUKsLe1rO3DhMr04XBGw+wuRA+RkHJEBWUYkv+sOZ?=
 =?iso-8859-1?Q?x5zu2+AtCpccMlm48bQKUksQHyqYppG+UAeOh4Fvl+4ntcew6Ed5FEj0nO?=
 =?iso-8859-1?Q?Zf9BOAQ0D6fEojrvNa3rHzHLOQWqAd7KzMoIlTE8pwhdyeh4yBVe/UrGdW?=
 =?iso-8859-1?Q?f6KdCSkFlwj/5cTiTmI/KPGThPXDx/+KkPdL6oAMRMO90pnn0yJ5/O6Qtw?=
 =?iso-8859-1?Q?xk9vDXC9Zg8ieQgrmQ4Qon7xb0KAiSPxhIL8ceOzm2fF//z9DyNc2IYnlw?=
 =?iso-8859-1?Q?GB7AgR802jnVtAwRGZdiBDGlRqamUHt9Lc3CPho/WZdNAGa8ohUX8Hym1u?=
 =?iso-8859-1?Q?laHKaeFw9CwFSR967qF+cl2GkS4aotCFN28KHKwJ/cSb3CDmSmdn3G0Xhl?=
 =?iso-8859-1?Q?DS7cH2OqKqwOGHp/vc6lNG4AZdi03nfpyD6I1805z0/NqlYbWJJnuA2r+p?=
 =?iso-8859-1?Q?VB8wSq14G43Ux94xtMelMosauOGNvvmndrjZURIGUuJAY3qMDgtv3KvpSG?=
 =?iso-8859-1?Q?oxv065DGNLlwMMBx9Z8V7Vywcl/Q7Hhek8ApzpfGSQZRO2Cc1hm+WSZS3J?=
 =?iso-8859-1?Q?lmUPvoKEq56EzQBY+pi4sX2SQq7MTH196oWEch7rtGdV91FTIbMm/LGLvO?=
 =?iso-8859-1?Q?JY+zjvzxEnmAnQWr0/IoQhaIzpfr/Qq2BJnEReLE/vUNiLrZqPPNy8YfTk?=
 =?iso-8859-1?Q?HDHH4LJh8EZkjhamk7IOzh5eNsALmej9pcj4toVs2q6kRfvjqd0QfgFxs5?=
 =?iso-8859-1?Q?+GRPgMkueHlxvpgKW9waMNVzHHYWPmi1tnwr+3IL4K1qXIy2MK3QYq8PTZ?=
 =?iso-8859-1?Q?S2XsMAdgIb5wcr56R25FN9I4C8QbDUdrgQ+gZ4uXNxPdV9N5Dhxko2wG3c?=
 =?iso-8859-1?Q?MuQQ1o9iYqY+oqVludyE4j4x5LOn7uIu85h/js6C0awNmOhNLociv1E2yV?=
 =?iso-8859-1?Q?xk7S54dmtqU4maFF4CuMZdmj2hT1W16CwLMFLIo+EeuXi+WNsllq+q++pe?=
 =?iso-8859-1?Q?90owODLaVhZybZTmIddWtZc=3D?=
X-Forefront-Antispam-Report: CIP:91.151.71.70;CTRY:FR;LANG:en;SCL:5;SRV:;IPV:CAL;SFV:SPM;H:SDSV152-VM.solairedirect.lan;PTR:undef-71-70.c-si.fr;CAT:OSPM;SFS:(13230016)(396003)(39860400002)(346002)(136003)(36840700001)(46966006)(40470700004)(9686003)(8936002)(186003)(336012)(82310400005)(6666004)(47076005)(26005)(41300700001)(956004)(7116003)(3480700007)(316002)(40480700001)(4744005)(2906002)(2860700004)(36860700001)(356005)(86362001)(70206006)(70586007)(8676002)(40460700003)(5660300002)(508600001)(81166007)(6916009)(16900700008);DIR:OUT;SFP:1501;
X-OriginatorOrg: solairedirect.co.za
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 21:59:41.6354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e881a66-1f74-4d20-6ae8-08da4f1a599b
X-MS-Exchange-CrossTenant-Id: 1c138fa9-0b91-4473-baea-5be5feac0f7e
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1c138fa9-0b91-4473-baea-5be5feac0f7e;Ip=[91.151.71.70];Helo=[SDSV152-VM.solairedirect.lan]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT086.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR06MB7481
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I hope that you are at your best and doing well. The purpose of this letter=
 is seeking for a pen pal like friendship and I'd love to and be honored to=
 be friends with you if you do not mind.. If the Idea sounds OK with you, j=
ust say yes and we can take it on from there. I look forward to hear hearin=
g from you.. My name is Emerald From Sweden 36 years , this will mean a lot=
 to me to hear back from you.

Warm Regards.

Emerald
