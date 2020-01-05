Return-Path: <SRS0=U1jj=22=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57F9C33C99
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 05:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BE1E21775
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jan 2020 05:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BPVma7bz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vXHysYsl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgAEFvT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jan 2020 00:51:19 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:56260 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgAEFvT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2020 00:51:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578203479; x=1609739479;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sUi6wqPs0k5OylI8see6LJEBZgAlUFkPWvvnsOXUXCg=;
  b=BPVma7bzPtSS+WxrOQ6gWSfGNXyzDVbsX7cyU91d2Zpdf1LeCSEx0mSD
   VsMdY1fkIEqh3bLg0uG/eoI4ifVV4ktSI9BJOxx7eTFFP34Hqc2woD6+u
   sa97nH85rOO/2CHUcVMhO9vVexSiPzpr+SkuUtP3ThHu0AE3MImNsLJzG
   wogtkMjUEjZgwh8/25pbzcEUamD2VT3X9G9Sfu3hN4zBHpJT4KxCktzTK
   EBxKL+vrndmHg9MlBQyb5uuFfbnKamlGLr/zBfsUzu9jMjNFdnxY7C0Iu
   34DUGpBUkDTTYeYSY62Qizdpg69Ol6DJW2QAI3vTBr2F1Ac3X/Dt8HCWp
   g==;
IronPort-SDR: /13JGtN/SW/pw/adJNi177onl1MVcztl6kR2y/z/A/SwR/9w/v7a22Vz2aWPqhcmQvV1JmEzcu
 iN/RCraTOsQVVs/xp+7O32NQBQKfQCzYIh+hdDgcL5n561INN16AHpbcggXMngDd09rmhSyEVL
 0KW8yHMwvbl2vX2LXKWXd4tVYo0K9ae8WgFhbKqTBdgAuULCo2tUZiWEYkZdQSKtWFm2PYwEdS
 SUvu2EFhyh2G8eaFXxLvroDmspQoyY98yq3hKSRoKLuWxoxz/rEVAt2avXYPGuddyEiczgx2kv
 sIQ=
X-IronPort-AV: E=Sophos;i="5.69,397,1571673600"; 
   d="scan'208";a="131203882"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jan 2020 13:51:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZ/h5++j6Sfe+82LBbKrEd+w/RrHsAwxlz7OvE8UPj4bkDNYob2pR9P9tgtE7bp18Ad4qsVhG3u8rZNUo1mdIFeQwKz+5EocJzUyONSwNfmqQeFWsXa2LS4KPWi7pGWieD9Vr65kP6x17GHRr+UV3JLXhbaQd+nwDCRM7UmrXEvfMsxusbrKBkIxRBhlBvrLbN9YuJvK0A5/sbGDt2Vr6yx/6p/63874D2AfhDuAaJfoDANGh2zmEIfKfXmEBgzJs0ScPcj6pgXL0deau9tTueS6GiKvae/M4ubrJiF7B1Sj5R4ThBWUFYmaInl/PuxHI3aani/g/qioOJMh5Mn2gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDSICHiA4AGENjnEKDQBWkghDmxnzSI6AoxJ9CmWG38=;
 b=X80A4i/GQ/4scB44S+yDoMmJyb9usaQDA0c2iEUXuVLL4+LuZI4xUAt17yZRLc+MAMWdo9QVza7F3N1OkIWhe5tnVtxiwm76cMFXEhrJWk6cP0e0VwhuZIZ1PAg/UCxAczdD+zGYCWOszMrtqS7sguqXah4wTzVSCpgi8UKL2WUR9Bzk91DL5nA9DX8ZrRqRNjVK/bsdFE6sLBu4jSGM1ovaFVFFf1QprcJ59vVEWUi37t16ayCtGpfj4UNIbTkA7cwgiKydAocwIVYKohiJMCckgBvntA4r1t5Ts720vCxwwSxkkLoJIcRbkryQRvmk5UTm3seeGU3nvgmRpG2VhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDSICHiA4AGENjnEKDQBWkghDmxnzSI6AoxJ9CmWG38=;
 b=vXHysYslCli3dd2oj1jq6DZqD1r7iQwrnXvar4ZMsHhpKnscdZrr/mJO8fUIZfdnLpr95QHxdkMRqzqPuf6m5vSVXeZ4zTtJqkfMj075yNPrG489jx/VTeN8bvGx2AVVNHMpE5w852w3dVhI/dzg6ue8M8TxM9Ya54Sfo+xJcb0=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5935.namprd04.prod.outlook.com (20.178.255.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.13; Sun, 5 Jan 2020 05:51:15 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45%4]) with mapi id 15.20.2602.015; Sun, 5 Jan 2020
 05:51:15 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
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
Subject: Re: [PATCH v1 0/3] scsi: ufs: pass device information to
 apply_dev_quirks
Thread-Topic: [PATCH v1 0/3] scsi: ufs: pass device information to
 apply_dev_quirks
Thread-Index: AQHVw4RnKOmg85o31Eufk/ca9N3SIafbkG15
Date:   Sun, 5 Jan 2020 05:51:14 +0000
Message-ID: <MN2PR04MB69913F0B671032A388747CF7FC3D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1578200118-29547-1-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1578200118-29547-1-git-send-email-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [2a00:a040:19b:4327:8ce4:162b:4d1a:a5c4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 74e89c91-07e5-47ef-08ce-08d791a346d4
x-ms-traffictypediagnostic: MN2PR04MB5935:
x-microsoft-antispam-prvs: <MN2PR04MB593536076E2F47BB7B3C27E3FC3D0@MN2PR04MB5935.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 027367F73D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(396003)(39850400004)(136003)(346002)(189003)(199004)(33656002)(86362001)(4326008)(5660300002)(9686003)(52536014)(55016002)(110136005)(54906003)(316002)(7416002)(186003)(478600001)(66946007)(53546011)(6506007)(7696005)(81156014)(76116006)(81166006)(91956017)(8676002)(8936002)(66476007)(71200400001)(66556008)(2906002)(66446008)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5935;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OAxoApTYCf9zIMe5rRCaDTQDZ3z8VzjA01UxIne1th02OWsG1eBPznrT51AWfqgRuqTMoazeqdgDXVPC6NEZ/7/9tdX3OxeBNmOci3DwTwwC00MVGQmttax/mcgoe8mTFi7mKAByGXfVmRD4ewDZ9mSdKey5ElJtGLrYTBtIvwUqc5JKx0FB3YAofjYRhz4Wh3wCFRSlPQBEXynQqse8wvQ1uslPsHTpzglmrR+T0W/f/dYng+KAawGJE1Zv01EHtB2v/fita80CJEQtHpS+zqH07/1FXkEdmFlr2lMEdrN1nE1VDxmPD6mU6i+iscZF1B4qjCSr7AcvKUbOL3Bxsl0gfVnxF51bYptp2Kjh6RwdoiZEqat03VIZPPOHZ8BvojqZxE980hrJq81d5sanmBu0SoFqFupRosOHMkNvUAqwBYi7nKP/Udgmw84ygeVG
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74e89c91-07e5-47ef-08ce-08d791a346d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2020 05:51:14.8908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VDv9xT4o0CzRiZjH0fngfu4XF/bFBUDvh7T3fIXBqb08ToobuO5HZJ5sTEwaHfe1ZGtFxZWGDnuO3d0mXqLA6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5935
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

You have to squash patch 1 & 2, otherwise your patch 1 won't compile.
Other than that: looks good to me.
Thanks,
Avri



________________________________________
From: Stanley Chu <stanley.chu@mediatek.com>
Sent: Sunday, January 5, 2020 6:55:15 AM
To: linux-scsi@vger.kernel.org; martin.petersen@oracle.com; Avri Altman; al=
im.akhtar@samsung.com; jejb@linux.ibm.com
Cc: beanhuo@micron.com; asutoshd@codeaurora.org; cang@codeaurora.org; matth=
ias.bgg@gmail.com; bvanassche@acm.org; linux-mediatek@lists.infradead.org; =
linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; kuohong=
.wang@mediatek.com; peter.wang@mediatek.com; chun-hung.wu@mediatek.com; and=
y.teng@mediatek.com; Stanley Chu
Subject: [PATCH v1 0/3] scsi: ufs: pass device information to apply_dev_qui=
rks

CAUTION: This email originated from outside of Western Digital. Do not clic=
k on links or open attachments unless you recognize the sender and know tha=
t the content is safe.


Currently UFS driver has "global" device quirk scheme to allow driver apply=
ing
special handling for certain UFS devive models.

However some special device handlings are required for specific UFS hosts o=
nly
so it is better to make it happen in vendor's callbacks only to not "pollut=
e"
common driver and common device quirks.

We already have apply_dev_quirks variant callback for vendors but lack of d=
evice
information for handling specific UFS device models. This series provides s=
uch
information to apply_dev_quirks callbacks, and applies related modification=
s.

Stanley Chu (3):
  scsi: ufs: pass device information to apply_dev_quirks
  scsi: ufs-qcom: modify apply_dev_quirks interface
  scsi: ufs-mediatek: add apply_dev_quirks variant operation

 drivers/scsi/ufs/ufs-mediatek.c | 11 +++++++++++
 drivers/scsi/ufs/ufs-qcom.c     |  3 ++-
 drivers/scsi/ufs/ufshcd.c       |  5 +++--
 drivers/scsi/ufs/ufshcd.h       |  7 ++++---
 4 files changed, 20 insertions(+), 6 deletions(-)

--
2.18.0
