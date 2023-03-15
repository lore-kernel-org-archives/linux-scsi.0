Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDE1C61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 12:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjCOMMw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 08:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCOMMu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 08:12:50 -0400
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (mail-gv0che01on2111.outbound.protection.outlook.com [40.107.23.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C443B8090C
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 05:12:33 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=U9mDfA2nwqa/0BWsDIP92V10dgI2YPT52VbfRjXb5lI1R7MwudSnoBHLbuTGb/e2EX30+GKzYr1Ro/o7u1cNXgcLDFiEOIt62tM9skrApkpBulwVUAb6CXRURku15Wn1CrET+Z+q/a9Q5qtzOKGPHJbh5vdvXN+iSIIyicPC4lwPIySvDwAAoJBN0qdhy/HZKS+DzmR3PgHHynX5Qo7Yr1ALiS6Hcay7IL7ZJJDDxvapuHLh+5SjFbTydUARHmel/uPQPbfpbMfbfIzMo98doL9dN08XHUbABQXqOjqTAyk+TEcI3VahOQHL+aasm6Uxn4xqBZ4DUno0leqTw/Ks0Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJWMysPl36audKpPjWIG/TOl/JVGuKuq1l4/HEAjxb8=;
 b=CxIvyHSuMV5OwWOvnQCYq2BspmMUSKJaDUKfQYWeEwvBaGTNZyQ0vHDlck4kQk/aQplRXuGCg6Yqi0jH6j2oc9KCLpSpLg2b9d6DpNJNOs+X/g7FZCfxfd6QvY/vazszrErp3Y34kSonekqrM0pDfLyhTWLN+WVEwFbVo1vPD7RRw5sX1wFaqTVdU8PFfY1jeFUA5FLgwPwDlB0XZDJ3FXenNFd1CTs/hKshlodzYhLj4IGg87J50qFdlPFm803KlIRto4h3RGCDEDMEteL1JvXsDRGZB8sssi7l6U7keL2tYK0/Fk9ycIBqXAba50rKuFGVi8g2/98xd6ZxhRvBKw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 104.47.22.106) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=duagon.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=duagon.com;
 dkim=pass (signature was verified) header.d=duagon.com; arc=pass (0 oda=1
 ltdi=1 spf=[1,1,smtp.mailfrom=duagon.com] dkim=[1,1,header.d=duagon.com]
 dmarc=[1,1,header.from=duagon.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=duagon.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJWMysPl36audKpPjWIG/TOl/JVGuKuq1l4/HEAjxb8=;
 b=IeWoaJ/MqkHTcRLjTxQmV3iewIHIWYDApZPqWsxI9gjYmCy5U9Vyx5mbCT2diYXhA9wss2z8bOL6LQ8F12BOlE8DsM5z1C5wzy72umrJllD4MMyGvmfFRqesfXE7xLATxmGclcE26SbdvmNos7tFDKvrg3I/0fGccOLbhLvsPqM=
Received: from OL1P279CA0058.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:15::9) by
 GVAP278MB0040.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:21::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Wed, 15 Mar 2023 12:12:31 +0000
Received: from HE1EUR01FT064.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:e10:15:cafe::ce) by OL1P279CA0058.outlook.office365.com
 (2603:10a6:e10:15::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Wed, 15 Mar 2023 12:12:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 104.47.22.106)
 smtp.mailfrom=duagon.com; dkim=pass (signature was verified)
 header.d=duagon.com;dmarc=pass action=none header.from=duagon.com;
Received-SPF: Pass (protection.outlook.com: domain of duagon.com designates
 104.47.22.106 as permitted sender) receiver=protection.outlook.com;
 client-ip=104.47.22.106; helo=CHE01-ZR0-obe.outbound.protection.outlook.com;
 pr=C
Received: from securemail.duagon.com (46.140.231.196) by
 HE1EUR01FT064.mail.protection.outlook.com (10.152.1.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.11 via Frontend Transport; Wed, 15 Mar 2023 12:12:30 +0000
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (mail-zr0che01lp2106.outbound.protection.outlook.com [104.47.22.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by securemail.duagon.com (Postfix) with ESMTPS
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 13:12:29 +0100 (CET)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nu/Cmu1vbhnV4XnLbZHJrNOAQwUkuwv92icZitZqUTYzDQS7vX7m3MXb1ET10cVlrFBbUOf6jbkAyQ1HEmv0v/0ONsgOxP8DeeVqC60l4gSWDpBRziXVPX2OHOQU5quYMU8gh0MeaRaOFb//d8GozQIaHrVWA6bFhuhmtBXWe3lbFdwPKFfwOAhFw1z7n2gJeMxWJ6b7E0YFwiz/R13zubgP/tu8RsDpPu5EyYv0JTsvJG+7OUPSv1vjL60uJe3wNq0jt2l1QRQfXrAMdqlR7blzSgkRIuAM5noNPhEODnj36tIQj43wl6IcyuT4z+2ZWnTxts9RfR+qgSmSS7w23g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJWMysPl36audKpPjWIG/TOl/JVGuKuq1l4/HEAjxb8=;
 b=Oofr2kFlyTHwgQ1J1g7XiX4zHsWlZAinYtMFmB0TegNjR8TE0XkcrGAZQELael6ACzkiH4OlLxvEP4EsVLZFNl1XSI4U4+We83BleXZCFaP9LiIwEtSgRBjHOF4qqEOUFLYPO+fNzANzMy5LdlFOTwa4fL2PL8yld3CTmibnm9mAL3BW/0504DXbOHGMO7gHGAAvLSHtFfSfEmMsZycSvU0oXrV5Vt3KNhLk6yGz+eVcZzpph6ArVetw7Nhzumhrb8NUY4AOYbC+zbmU43EvOzIKZ6Ri/kx0iW/DkQO8hCltxWtcM+qDmC9xcgfAgBVAfYihDpQsbcESK1EM8VfGBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=duagon.com; dmarc=pass action=none header.from=duagon.com;
 dkim=pass header.d=duagon.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=duagon.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJWMysPl36audKpPjWIG/TOl/JVGuKuq1l4/HEAjxb8=;
 b=IeWoaJ/MqkHTcRLjTxQmV3iewIHIWYDApZPqWsxI9gjYmCy5U9Vyx5mbCT2diYXhA9wss2z8bOL6LQ8F12BOlE8DsM5z1C5wzy72umrJllD4MMyGvmfFRqesfXE7xLATxmGclcE26SbdvmNos7tFDKvrg3I/0fGccOLbhLvsPqM=
Received: from GVAP278MB0487.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:3a::8) by
 GVAP278MB0905.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:46::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Wed, 15 Mar 2023 12:12:27 +0000
Received: from GVAP278MB0487.CHEP278.PROD.OUTLOOK.COM
 ([fe80::50c7:41b1:43b8:504f]) by GVAP278MB0487.CHEP278.PROD.OUTLOOK.COM
 ([fe80::50c7:41b1:43b8:504f%9]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 12:12:27 +0000
From:   "Heller, Marc" <Marc.Heller@duagon.com>
To:     "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
CC:     "Heller, Marc" <Marc.Heller@duagon.com>
Subject: signature test
Thread-Topic: signature test
Thread-Index: AdlXN102mnr95E9oQ2+AZKsoWarlog==
Date:   Wed, 15 Mar 2023 12:12:27 +0000
Message-ID: <GVAP278MB04876B9264B789FC969C676B8ABF9@GVAP278MB0487.CHEP278.PROD.OUTLOOK.COM>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-codetwo-clientsignature-inserted: true
x-codetwoprocessed: true
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=duagon.com;
x-ms-traffictypediagnostic: GVAP278MB0487:EE_|GVAP278MB0905:EE_|HE1EUR01FT064:EE_|GVAP278MB0040:EE_
X-MS-Office365-Filtering-Correlation-Id: 062e3d18-0ec2-455e-f7c1-08db254e8d3a
x-seppmail-processed: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: jFORmddCHs8aleAgOi9xmzSI07Ntda0e8pESPkVvE7sYmW/p0aQUgAEyoEcdYCaVGraP+i8kW0bZApT8beUNLg96H9XjA46a84gHC+K4gCMIzC51TjKoTG5dUD7D/FUuJLw6UfWBNCyxMaVWMPviFLBhx+JyDPKhSQmSeBiZvFuYeHViWRLpJkWQgInWMLnnKEykhnWnBs0Y6GIDu5HqljQ2CZEXIzAzs9HT/YElzPAofnxoHjL7k1FxBZP0yH/h6tDOUN1rpzswfo5vXaLYIgGUSfdTrpMUzIHO7agaiQZw4hka+Y/UOpPfUG6yuky0kB0XX4m6Mphwc9vNYitDNhwy33jvYOB/sKl4J421raLCQ0JgxWHO1VtA9I9ptehtl30b2o0WkVLsZXaqid8mKkB9Y+GRYCNLJExAFTPrswm3JcYNGh1BXYa3DRwx7GVzpHHXMmyu/K4Pvgfd7jfBfqZlXnmOwhWbmWs3yC9FAk69GXe4+CXuOhcWYAy02IC6j7uzMhEKjQ6lq1uZF50m1YCJNOSNik66YSHVoWrNS/+8riQF2mHkFbTWfhUvWX4J5wdO4dlNRPioliYL31x0PIbfZy45aRm2qU7w2MmQpBE=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVAP278MB0487.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(346002)(39850400004)(396003)(136003)(366004)(376002)(451199018)(38100700002)(38070700005)(86362001)(3480700007)(33656002)(122000001)(558084003)(2906002)(19618925003)(52536014)(7116003)(8936002)(41300700001)(55016003)(6916009)(4326008)(9686003)(186003)(6506007)(26005)(316002)(64756008)(66446008)(76116006)(8676002)(66476007)(66946007)(107886003)(7696005)(478600001)(71200400001)(66556008)(491001)(338634005)(558944008)(1903315002)(15288005002)(19559445001);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0905
X-SM-outgoing: yes
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender: ip=[104.47.22.106];domain=CHE01-ZR0-obe.outbound.protection.outlook.com
X-MS-Exchange-ExternalOriginalInternetSender: ip=[104.47.22.106];domain=CHE01-ZR0-obe.outbound.protection.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped: HE1EUR01FT064.eop-EUR01.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: bc8bffec-6a9a-4162-0240-08db254e8b5e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uRPUWrQfaJprE8D+w1N0Br3RAokL1kinjyWLtL8elfjJe1Bd8JV304rskiF3pGSTP1urcRTy84mzkxtG037BVEJ4AJL9pmN3ijpplxgpgZrNj6qfQzOTziPdJX3ZH5lPYBj1dqRW+xTOdZ7u2DwmQqBhTtFID7cCjW1yM7tucPGYKOda9eLMEe9bqBHNuA/sg+CNIVICAMMRTmwrzAUesbaS+5Mkl5aHmiiAoCaK9c/hJCmXtsDO/dfj6u/y26rS/RCgAHdnw6HB4ZuVoCecOeGKcdodNZqOufbegDcKxvHr2zAxgJ3n+LWhFOSe6bCpysxDBBdr1CETGhK1m46Bc3p6tEynFiDNuugDZjL5hhsviRR40ndjZ5E8IMOydUlBvUmyNxbMdrjYqwY4f+w9/4sRwxWXHMuPUzBdUtxo7RG9pxW68ZyD87jNqGbaEQXgSdgJu+ES22zvPLsIJps1/riCbGLNTRS++CXXP9nggfyy9SDmv3VDi/zH30YOFUQJho7YxYtS3vX3eW8FrHSdsH5rvVBLieYl+YXNxALcGVzOtdS6x9whOtRfcfq/bP6O0NOoKEFUuGNQ5PyIvmR7BpQHCPgxoY43CCWaxXGM7BhcRTyasxCIS7xKsnTWzbAzgvfh/7AoAcj+H+7jCp4NnVAo4I8ell939OAGvhs1EOxPxJEmE3HdX8dkiWuD6eVJzRJhbzyIjaWcn9pzMyg37lluYX/uh0/LInvfGW38n94+n/Voz5MqtfKi6j7v64bRgwGpL34/rhG57Rmo1VOqTQ==
X-Forefront-Antispam-Report: CIP:46.140.231.196;CTRY:CH;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHE01-ZR0-obe.outbound.protection.outlook.com;PTR:mail-zr0che01lp2106.outbound.protection.outlook.com;CAT:NONE;SFS:(13230025)(376002)(396003)(39850400004)(136003)(346002)(451199018)(46966006)(36840700001)(40470700004)(40460700003)(47076005)(3480700007)(478600001)(82310400005)(7696005)(107886003)(9686003)(6506007)(26005)(336012)(186003)(70586007)(70206006)(52536014)(8676002)(41300700001)(55016003)(40480700001)(6916009)(558084003)(7116003)(4326008)(8936002)(33656002)(86362001)(316002)(32850700003)(34070700002)(82740400003)(36860700001)(156005)(7636003)(19618925003)(2906002)(491001)(338634005)(558944008)(1903315002)(15288005002)(19559445001);DIR:OUT;SFP:1102;
X-OriginatorOrg: duagon.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:12:30.7217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 062e3d18-0ec2-455e-f7c1-08db254e8d3a
X-MS-Exchange-CrossTenant-Id: e5e7e96e-8a28-45d6-9093-a40dd5b51a57
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5e7e96e-8a28-45d6-9093-a40dd5b51a57;Ip=[46.140.231.196];Helo=[securemail.duagon.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT064.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0040
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

asdf

