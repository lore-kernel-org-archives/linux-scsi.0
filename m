Return-Path: <SRS0=Owrj=3T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE0EC2D0DB
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jan 2020 17:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A58AF20661
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jan 2020 17:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="1Aig8YxP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgA3RqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jan 2020 12:46:08 -0500
Received: from mail-mw2nam10on2087.outbound.protection.outlook.com ([40.107.94.87]:6061
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727338AbgA3RqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Jan 2020 12:46:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRrlY1zG5s7x78fiaCiKIz+ls5WNUkvFAbori0mKn8sj/n++x5v/tbGXaJIn+Ac/GvSDNxeTa04TxexHvzlCCfrIiP55NBiwqY0XNBpYMmUFq9Y2w6EVUIb0JKhhGOdthymqaWCQ/Lrxba0Vu9nwdWrY0TW72aiGKJq+apldqTJefMj9YTXLha4FgtImeDqy2J5DWelyaYMM1I67I+TOCXb8JagTb2VVAeqeH+eSGRSiosy0X1UPvhqhhREvDREzFmL0/+sWXE7XgFXyZUICZIbafzY7xTaYKS9ienHoYjh5X2IMU1D1G2DNjgbAbcuXCmfQRu/g8N5JBd78LsdjCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1Ebke6eveyxao7m6TM2J+k5u29xj8tTIql2r8ll4bY=;
 b=ofonCxqqAuxhHlYNzKyGZ7d44hx73i4PPHivZntjcXue/zc+S0INDYG8gU1+YpY3qJhVkTWAnGLwr6qviQH4r5H6j1KOWJNnwK+kSSD8mFm9ZYVK5oJct7pfw6CAzcw2OySWmdVbzmgVFZCDTJ5ZyfQCs6Wb3UGXoZshYw4r+xPYAiT7zNpvjcWVQxBrG7n499ZXGp81hr8YGRtvUP+Nxu/nCajePmSumQyZ7M2erxtHZEiK3IdjuORoSUzY4A6g6Qt5DPLw1asmrN8+O1Utkj8X7tVtgGlCWuZ2fOsY64xUGDNkdZkVK9oJTmzQi99CrgRu1yvpm/ZgdmCpdbNp7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1Ebke6eveyxao7m6TM2J+k5u29xj8tTIql2r8ll4bY=;
 b=1Aig8YxPWekCS8BjEr6yLyouoqfYw9mckSrL4iQo8vkMw2drJj4yWxp2VRUFY+O4pLWxjDhlY5IXiuHNsGm6t/no4f0S3Ockxa9abh+xY8ivTe5CkrqOqYNXzwvaS804pVx4LqJtuqJ2U+yfSsPgAc03kSGQX0XoHylzNBYj3LI=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB3841.namprd08.prod.outlook.com (52.132.216.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Thu, 30 Jan 2020 17:46:05 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2686.025; Thu, 30 Jan 2020
 17:46:05 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [EXT] [PATCH RESEND v3 2/4] scsi: ufs-mediatek: support linkoff
 state during suspend
Thread-Topic: [EXT] [PATCH RESEND v3 2/4] scsi: ufs-mediatek: support linkoff
 state during suspend
Thread-Index: AQHV1pJMWKnB7DLGlkiU4SPnMyvo26gDfRdQ
Date:   Thu, 30 Jan 2020 17:46:04 +0000
Message-ID: <BN7PR08MB56840B670971FE050CE9DB70DB040@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200129105251.12466-1-stanley.chu@mediatek.com>
 <20200129105251.12466-3-stanley.chu@mediatek.com>
In-Reply-To: <20200129105251.12466-3-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.80.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ffe53b24-ccc2-4661-6b20-08d7a5ac47df
x-ms-traffictypediagnostic: BN7PR08MB3841:|BN7PR08MB3841:|BN7PR08MB3841:
x-microsoft-antispam-prvs: <BN7PR08MB384115D7986DBAD698787AB8DB040@BN7PR08MB3841.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 02981BE340
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(189003)(199004)(7416002)(4326008)(2906002)(5660300002)(66446008)(66556008)(71200400001)(86362001)(478600001)(81156014)(81166006)(9686003)(76116006)(64756008)(66476007)(558084003)(66946007)(54906003)(186003)(26005)(8676002)(52536014)(8936002)(6506007)(316002)(55236004)(110136005)(55016002)(33656002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3841;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sbKKokZ3a/tOylTA7wl1uWWHEx0FZGvdEzhovf++bXjqOaiDgfrEMOmH4NtqgdBeK68X1xC0EKx5Jv6F5bv4HesOn1AgA0j1mP8jGs1XXYtKplvJeQHrc9+0Cn25ufXrt3ONG+LSp7aiYanOCy0+UfV5sVKfe4Q5cp4ndDwxTqO/6usblBXZzpjUYoFbgW/W+CfFTQ4YA63+ZHr/lakdz1KwnMExtIXAIjwPLsvtU45+2iL8rsAGlgFG85ejIPmOVAnLR5zAk5bqLmU3GDn4k/JPOngPTO5zddB8DaxiTy1iXzl6kcu/yauORwun85RffUxo9NUZbL+Idn2pqgAUXy2gdYWWdN0HVliFyGDxG2Bsb+yqMcGcvMhmE6ByzMly0y7GvuDZ4JTiaOFnBWP22VpVRH7/E0trm3SR/PTyQ/bpEI0Vc9N/FGbQpIHnrIM4
x-ms-exchange-antispam-messagedata: Vy6GKIhU4NQ6dmkva4Y2t4rWPZlSIWxjvW67lRqANDn732aiowyJfWm02dJor4OxURkd9qU/Uynf1lL1/caSC1hGoMEcN8Een6pzEZL9vvL+/wq+jp8beuaocLGklLoWDApblSpP4x3DmIpfHDGf5Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe53b24-ccc2-4661-6b20-08d7a5ac47df
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2020 17:46:05.2885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CHUe1uhm1/8joz3afoVlNpW8u23bqd5lDxLC0g0O5Yzf1WnwAn4fkL0eeVTiCUJ0E2ilU0J8BvpzYlO9EOPBcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3841
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
