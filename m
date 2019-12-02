Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146ACC432C0
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC9F4215F1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BLSnN7Gp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yvPs3yY8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfLBHm3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 02:42:29 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:56503 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfLBHm3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 02:42:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575272548; x=1606808548;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TM7mKDa2Sc/9hBg7mKLakDMx/I/eZFhUKUg/BbqUEGs=;
  b=BLSnN7Gpp+uSOnuwZ86SIxhz9wa5y+DTxtf0msfVCObu2D+vUtV0NWaw
   z2TuyW5H6g8wauBn68Lp/c+HZH9yZLO0Lj2AiLKc3Itw4gwInoHkMf2H/
   pjup+7d8T0pInAqfsPIkCFm4j+bNkcOOsoddU9mTbjtBgZHFNwZREr59e
   zggTUhiXXFpM8udFXsZpepLQ3liMHkNNi1GVpscMYDMpqjatorca0Yxnz
   C9RfdEfZSabpGmLeuApFZ4StTdvITEswh+tsLm5FbHwcl0rxJyWLj9cZM
   za7rC+DrCfSMwyPDhA53PdV0w1gkgj3gd2Af2YuSXhHbp1eG8Kbx+EALX
   Q==;
IronPort-SDR: 2OOgFbU9t/RkbATxgeQsghe0OfBadKjqmP09GDrF0p/b9j1dQFnNCCBDY4T4TPc1T+cLQSqpzw
 OCPQ30pE1Vki7KINqGnp+JLzGU7YSnzS0SpophJDzFm75i7yem0ZMjK+itdiHVnEP5h8az+qgR
 lN2gR0KGGQRDA6RiYkkIGf5IJzMuhr/vQHKOX9f2hR0EkbEvW+8vHhP3bzNmKvJE9xxqfaJQm4
 pu9sUXqG92mLr3nUcEyYYCMz5OOux/bF0GFgVl00TW5kOpAhW+qSBYgT9r1xi/lmqR+Ax93YN0
 d7Y=
X-IronPort-AV: E=Sophos;i="5.69,268,1571673600"; 
   d="scan'208";a="231871101"
Received: from mail-dm3nam05lp2050.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.50])
  by ob1.hgst.iphmx.com with ESMTP; 02 Dec 2019 15:42:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bb4XW7JX5+CdWis2EBokLFUdUVZYKCS+tIBT5qUZBzHXBr3CHAzbYm/SFJtJ3B+t5GxLSRwjzF7V+x5PF94GAxmumnO3NwfayAhu0eDFU1M+yRQlgOlWd2hguHW7RZ5+16itOTey4oeDxhhqyRN3JisFfj8pCkBotRHGmwk5Hk4PzC2ckXfoOrvk41OyRq6Nl30hTGioyTkU0B0Oc9ffAumx0OFGyJK7PFcwNyxdu84G2AwscaqfXIDrFONuO/KOFvZREz9B7seJQXdhgBVv5phczn5E64ydd16kdvq8eMGMUR3UFS0ITNq2fX0w6eQo7TLsOGrumO1ApC6yMEwaXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TM7mKDa2Sc/9hBg7mKLakDMx/I/eZFhUKUg/BbqUEGs=;
 b=ddeVe7cl8JGXqSUqhd3oJLR7Nx8rN2swih/tyogK5MD0xQG3VPCUfrqq7/hvSFbeYbLp8WJPCtzhImrsV+ZkwJ1imzyhvVAlTFYU6TSIo05ZB+CFtrghrLYkHXS8qj99O8pVJq2WPupL21u+KdWkqTMFG7KPFj673kavXAlYPWYAkDSJ4iDNwxjWv4lD2hyKtJNz9X9ilNL4f3hqngys7ehgTc8MS9680XPTOR+yrkD+3qu8MgHut5nhSBqgjCObCqrBbvkKGrLQeQeXe4c4KJJc6mpjo0Nqhbv/T6Ixh47399wwt1DxXmujX6qT7tvfWMxXwED6v7WI0JbSK/E6qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TM7mKDa2Sc/9hBg7mKLakDMx/I/eZFhUKUg/BbqUEGs=;
 b=yvPs3yY8zkA7Mjw3/v1+dsv/TWtEsxWcKnJwg3z06ff6jdsscB2200l/Xp8Qh609XKYwTzQjyD0FbAPN6C80dh1jCxgCZwiXNRWaKeRfYcU459fZ9I/0CG8ifLgyIiw4FDoYKdViQkqkwpclpOkDhBb5Sz/r3nqkSgj+xYUz9qc=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5744.namprd04.prod.outlook.com (20.179.20.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Mon, 2 Dec 2019 07:42:01 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2495.014; Mon, 2 Dec 2019
 07:42:01 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 4/5] scsi: ufs: Do not clear the DL layer timers
Thread-Topic: [PATCH v4 4/5] scsi: ufs: Do not clear the DL layer timers
Thread-Index: AQHVqOJi9Uj0xO4g1EKSBfsTmVIai6emdJLA
Date:   Mon, 2 Dec 2019 07:42:00 +0000
Message-ID: <MN2PR04MB69916189C31D58EB6DCB71E9FC430@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
 <1573624824-671-5-git-send-email-cang@codeaurora.org>
 <0101016ec584a776-2140a805-4b1d-4a3d-af0a-f073425be2d6-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ec584a776-2140a805-4b1d-4a3d-af0a-f073425be2d6-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5a684202-ea10-49cd-07ef-08d776fb1e21
x-ms-traffictypediagnostic: MN2PR04MB5744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5744FB3411CD86BCF0F9007AFC430@MN2PR04MB5744.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0239D46DB6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(189003)(199004)(6916009)(186003)(86362001)(478600001)(229853002)(6246003)(14454004)(6436002)(33656002)(71190400001)(71200400001)(9686003)(7416002)(5660300002)(52536014)(55016002)(76176011)(7696005)(66946007)(4744005)(66476007)(66556008)(66446008)(64756008)(5640700003)(102836004)(76116006)(6506007)(25786009)(7736002)(74316002)(81156014)(305945005)(8936002)(2906002)(54906003)(1730700003)(81166006)(316002)(2501003)(4326008)(446003)(11346002)(256004)(3846002)(66066001)(8676002)(26005)(99286004)(2351001)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5744;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NjSTlZ9YqxBN/D7mxw7rcu9eAqPO6qkRMts2darDa9DBKjzbVdF0OOwD8UibMOnKWBoF/bO22GpkhWH6Hu0d/qnnozmJETgdvp4SBVp1O2SRdStkdct5Ld6cmcpGyrB0cOPAZ8r8Kc6Xxp3VDfU9qRBiRAsod2269nnEQg5DZfCpMTIcRsZ0gvOhJY3fPKD9n1fuoyvZcyUtQ9C1YSD7PIZJwI/SgYL5ku4ZzCDh11SXSpWuGD0rO3mknMiqtmn3a/8NefHMxLA91SBfsCAqg+Gqoq0nvGMtkJbjmCkHJSUAHFnFaOB/NZrTCZ+lGOkCup4kPmNJkLsv6rKkQfgFqeLxdcKAoDm2IE83Oomr53Qf2Scw8WaYu2BBBJBtnrwFq51By/5w4xY/XcMcWd7qzMANwD/NKPR2KMa68WNTIunbSUhlJarBIOIwoFZ3zUiN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a684202-ea10-49cd-07ef-08d776fb1e21
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2019 07:42:00.8732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xjDX6PoljUH3G0lmbNWDywsuhHnavCHCcaQqUcJgsfgbQQEQ8/BEl8DdhJH0tiat2rKf9vAW6XICeBsw5u5PsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5744
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> During power mode change, PACP_PWR_Req frame sends
> PAPowerModeUserData parameters (and they are considered valid by device i=
f
> Flags[4] - UserDataValid bit is set in the same frame).
> Currently we don't set these PAPowerModeUserData parameters and hardware
> always sets UserDataValid bit which would clear all the DL layer timeout =
values
> of the peer device after the power mode change.
>=20
> This change sets the PAPowerModeUserData[0..5] to UniPro specification
> recommended default values, in addition we are also setting the relevant
> DME_LOCAL_* timer attributes as required by UFS HCI specification.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
