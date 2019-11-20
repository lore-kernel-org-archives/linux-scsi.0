Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5698DC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 15:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F1E12071F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 15:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WWt0qC1x";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YTKci9hY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfKTPhD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 10:37:03 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:15794 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbfKTPhD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 10:37:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574264222; x=1605800222;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zhi7OPPz04NXRrxY67F7WDSlQ5RvMPEPZ8yIwHKevb8=;
  b=WWt0qC1xdewea6cziTY5zFm2NAh529pI7FS6qPg0Q4JGCAAnMTB45ad1
   x3yy31K+U+XnaZ8/oKO1rW7gRbE3JsRcanHsjZT2XkpYBzdOWKbY1bXcS
   eg7j7msTvBemLEPpVfv5OWxZePIjYlTSrHb0WCdo57V4lrBm+ObbRUOhm
   jQLF1qWZvnWr+0nJpuOiJNxb3PtftcmVKfZzVl+JS6jrtBcDNPHJ5fr1z
   339KYoXkm8JwnLa6HFwfvRHZmDnfvhmNzbSd5DpQo5mJcKbYQbsmiYAZd
   fgxotS1tiQvh5FgcVn1yUFYA9BlC+rACdwlpWRgGAJZ2epvdaGzGfIN/z
   w==;
IronPort-SDR: 1Kik3GJrkoMtYr02KcjWRL22AdZcuVDXh1SC2sKl6ihrofnJP0ulIqLl6RS/qMvrPEspU4FJM7
 1iwDlrrQlT2VGHJtt5i3PG/5gtusfeJxPiZVk9GORWsVvWFycBN9ffEdtnLnjCHEYMcqMZ0Kpq
 4Z+JmsZd5wCHkKRynOpaDEY7ixUIy43OJ2NtfrUaAgnZXsPM0gMyV61gBScUML3rPHuXdwFSQN
 PkyovxqkMupeD4R0c/Pd+Rx0k77QdygmFOdwqXP86ZPyVUAIrcYVfg6AvWwDklNbgVnjr2p5/V
 IoM=
X-IronPort-AV: E=Sophos;i="5.69,222,1571673600"; 
   d="scan'208";a="127973499"
Received: from mail-co1nam03lp2058.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.58])
  by ob1.hgst.iphmx.com with ESMTP; 20 Nov 2019 23:37:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6nJ+P3wrC5eydvFxxz28S1ksBMXtnp6oW1xPAcoso9bwWDOm+HO9hUAkOAjcf6m0ZsgOU8FW3lus4C5g6xVRo7r7EGdGs4CCbn+oC/o29XRV3cRh/Kw08XFuF/RYgVp+cKlmTyFbDATYcQ7s/J92q9RnexHzfGK0u3tzjAlkAJzVVPtS4uSjDgjzfDAeNvl94rZkoKb2+RUf2O+19u1kQBrJlOHdT8YzvvbLId5wNiVSkmhNKFPmcOg8HjqsnLlXF2nQb39ifqnQ9qQEcy4oXScAO/NxcCYPvz4NqZZrAoYfL9ipIHU843D5gsyjc1AkBDQZd4e59YnEySUADkGiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zhi7OPPz04NXRrxY67F7WDSlQ5RvMPEPZ8yIwHKevb8=;
 b=Hx2wHLsWxmW9VjYCgfvq+9i8/qaXtumofpVViDfVvYUzWwmQf6+W78Iw9AIYJnGqSqDR1KIsZNiNLo8BiA5pnf6i8QeVT7ySi9/Y7om0qnSSYlC/+2Fm5NWhLES4PtTCLg6P2/njJiXc8Hasof331H9hTuYLaAB8OIXmCSVOwHiW0HKxkaGKhnR+sM6jpu51z+V48hoP7atyBcs/4LBP2KjH0coUJVHec9UEJSJqDdijb5DhQ2xY39sXNOFDp1QU9OMsTRQdtT5N55MA7ku4up3iuQJbhZXtRKrWIElQxxjEqOYpRBwspkOeLPiJHqyDcCV/JHN3V6ozCZG7TIMIqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zhi7OPPz04NXRrxY67F7WDSlQ5RvMPEPZ8yIwHKevb8=;
 b=YTKci9hYusn35hctImWdbBDTkzGRHikgxLpZ1XtjEyfxFi/+4D9+mwcIxz/AIct5XQMS0l+b/r2FQ3YEd/Pd4oPOW5YjmnXWSTIDrsOu55iRa4V/8072bqI7lgKZd6UrBf0iNVe7GJaao5P3x6PPPtdgKY/47SFEES602qYx0O0=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5965.namprd04.prod.outlook.com (20.178.246.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 15:36:59 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 15:36:59 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 5/5] scsi: ufs: Do not free irq in suspend
Thread-Topic: [PATCH v4 5/5] scsi: ufs: Do not free irq in suspend
Thread-Index: AQHVmee9U/BswetsqkSHgDuGmRZmjqeUO0QQ
Date:   Wed, 20 Nov 2019 15:36:59 +0000
Message-ID: <MN2PR04MB69913C6C9ED425F99302D870FC4F0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
 <1573624824-671-6-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573624824-671-6-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 43a1e46c-c6da-4c31-b534-08d76dcf7b93
x-ms-traffictypediagnostic: MN2PR04MB5965:
x-microsoft-antispam-prvs: <MN2PR04MB5965203119D88B0FD57E1972FC4F0@MN2PR04MB5965.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(199004)(189003)(256004)(3846002)(86362001)(6506007)(11346002)(2906002)(33656002)(15650500001)(14454004)(5660300002)(99286004)(76116006)(486006)(110136005)(14444005)(76176011)(4326008)(316002)(54906003)(6436002)(9686003)(6246003)(476003)(55016002)(4744005)(71190400001)(229853002)(446003)(8936002)(71200400001)(478600001)(74316002)(102836004)(26005)(25786009)(7696005)(66066001)(2201001)(186003)(66446008)(305945005)(8676002)(7416002)(52536014)(2501003)(81156014)(81166006)(7736002)(64756008)(66946007)(66476007)(66556008)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5965;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: imdPebxp/J1mPIH3LHRNJQmAgHMInOAsbku2ZEvi7z+0NgMPxAtWlIj83H6vQcl3q48MXfL/k9vaUjiGhWBULrkolOxIcgEpM0MoPGQw51vtUffSYSvCybxtY4iXM/Mx57iZABEorNwFnZuZM6e7P0ZyI345JlCg4vJYYi1aYFjCC1pC6qQ+J4fixtunLrnbgbo30fVpMkVT8On0rHZgqbZBenv8d4GyGBEmJU0h1r0rEauzoTO7R4QrXH3J4kt4oWQDvpRFReVCbvyvLomC9YwiCgrIVIPzi6cI4JNLiRlnh8b6h0+c2Q3+fpn6B2lJzh0xpJQ0hIN4Onh6M2TJx/psHjtwWDFbX9e965JJY08u/ReoncAtO2c/ichUFmWDZDcs0DZqsuQYNxdMcRRfro9ZOEGZodf6ZjZ+UXUpotvyo3IRCo3kmLM0HsKj2YZZ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a1e46c-c6da-4c31-b534-08d76dcf7b93
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 15:36:59.3358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2T9DGfK2dVQ7pdgaDkSAzFyvwI9HAJgPKbXnmFn3ZHsk0Z/WxTMfU66R+3oSbH7Ju8A9gl29ZiVc5K6daX3umA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5965
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> If PM QoS is enabled and we set request type to PM_QOS_REQ_AFFINE_IRQ
> then freeing up the irq makes the free_irq() print out warning with call =
stack.
> We don't really need to free up irq during suspend, disabling it during s=
uspend
> and reenabling it during resume should be good enough.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Your approach seems reasonable,
However I failed to locate in the kernel PM_QOS_REQ_AFFINE_IRQ,
Just in codeaurora.

Is the WARN_ON in free_irq still applies?

Thanks,
Avri
