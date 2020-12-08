Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6FBC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 07:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B96523A51
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 07:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgLHHyu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 02:54:50 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51441 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgLHHyu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 02:54:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607414090; x=1638950090;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4ad5cGzT8QzM0pMsjbawY7yd5r5HJDtKuzrKBzpztRI=;
  b=epYb8vwYMLqT9YKLvBWdT9ZUSZbmTYpngBrRDlSFMmGlzfwmL4waTOyk
   Q9i+4VOEuod+HkkzvYJYJpi2y8/0ue5NdS8IRA8Pw1soR2uJZRSj1YjV2
   L5gV5ShTh8BeQNGBppONeFlyGrLD00KqipiHI+CNEGwqWqnlKkMgXQDdW
   VxkIB+Ve4tBB4YP74jo6SKysAZxh3kc66e48867YbOuuyP1aAzetUAI7O
   ki+6Fo/CWldIqlJryhIjH7pq22denIPX7yRS6B/KH2Dkx8tjBQGzuUF2a
   uns6wa6lzELCHrJYf/QH66X2BvQhy8LAHUcq3OXWmcdd0nTiX61WRzeKm
   w==;
IronPort-SDR: c3FXbp5qS/GpeDk5lA72M0/slte1XHg72uWtGrOqfoQnCcfzcZct1F3/4qZFTF5ritxwtv7ngR
 aJWlm5707ttExZJXWtQcCwBw22PZy9/mbeXFU1Nufo2x6sjWX92vzxgBSfTURppygt8EcjmwZB
 lAoERR8VR6AJYPsYecyBPuhXc4SU9d3A1XqQtl/RhUe0QTmWqWDl5Vv+ZDGXI9E/BkQmIlikWC
 Zs3izzDWez5wRGLeOVvAaSZunrhcgOHDTGfh9S7+asdHx5ToiaGsu70Md/1WuqxwrrCIlnbwop
 6vs=
X-IronPort-AV: E=Sophos;i="5.78,401,1599494400"; 
   d="scan'208";a="155877826"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 15:53:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcK3e5sYOhVdIvP6mkHMMMGS4vseANn0qfZaVhWukQ03ta/xdZxGbNEHrH3FTCfukDj+dB7OWpVvi/bNfHZdV/adFaXAoA0Lh1Zi/kjGYuEppjzN7p1bFdOis4BxemrJ3BgNH7rLLDD0KKhSeCW7PvkYwZ5ov+phkgmUJSihCzuvbt2SmOFx72NJQluC7FNfDhmVWYlFodzmslbFLzkO6d8qfhKP+E7Km0xpNo/6VtvHXE3FjIFIWDFoGms0TT/n4Jt6kfBeq1x57zeZx9Pmcj2DZuaAOfwz7lErYZDITailVp5bCW2bxbg/l2FJu33Ap7/yJtpw0CXHTpTfCH+LYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ad5cGzT8QzM0pMsjbawY7yd5r5HJDtKuzrKBzpztRI=;
 b=dTziYwP41pMYYPtMrhdCYAxgiQv8vevm9x4oRLhViHDIGljnp8RL/B5pbBpTqUPmK/fRV0bidCbNvke1QzChzvw3257++KgwUuM23CFSTr76VIzKnDK8xjra3vllUFjcmKdq+0gzJg1jm6EcARyp1jj24nbuTp9GOxmFYr50AYBxeuN9qZCduEptDLvF4ZI7IQy4Q+ko+H9X6ZoF3SeX7Vy62z7SeF7qeKGwIGVYVNoLAdFStcFnr162SwHJrQBxuxFLkuVbZeJOf6F5iQOUEH2ME7w6EMUgJ0sabTqBONlrZjRWBoMOGB61I+/aPqZIDDYZcUIJ3DBA775kmd68QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ad5cGzT8QzM0pMsjbawY7yd5r5HJDtKuzrKBzpztRI=;
 b=o88QpJJ7FjwdYyQzM/diOUOzHjoDGWdyEPuZz8DOMjVoG/Za99xkmhtm12bAk3IywVhSQ7N7iGJwtrZBdirq1dOqRkCPyaT97WyE4qxVhPKLiePQz0GvUj1bh+DToZ5Wn61txFpRy7tfjRxqvhEwz6tn7lJYKM83InUv1sp1EGA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0538.namprd04.prod.outlook.com (2603:10b6:3:9f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.21; Tue, 8 Dec 2020 07:53:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 07:53:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: ufs: Fix wrong print message in dev_err()
Thread-Topic: [PATCH 2/2] scsi: ufs: Fix wrong print message in dev_err()
Thread-Index: AQHWzMtuS+PgTXOBdUOHwvhHmi+fg6ns1Lng
Date:   Tue, 8 Dec 2020 07:53:41 +0000
Message-ID: <DM6PR04MB65750A4923359135E3F50340FCCD0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201207190137.6858-1-huobean@gmail.com>
 <20201207190137.6858-3-huobean@gmail.com>
In-Reply-To: <20201207190137.6858-3-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2f55c4f6-2ebf-426c-b335-08d89b4e617b
x-ms-traffictypediagnostic: DM5PR04MB0538:
x-microsoft-antispam-prvs: <DM5PR04MB053824E7E9CA9944190B2178FCCD0@DM5PR04MB0538.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n5jJMTmY+mG8x++Awj+uWQZo6hK0SU94Mhu48ZVFOq/kPo5L0iBu9AhAiyfBM3DFX2XhP7NycrOsv68c4hhOGyA7ryZzbOdSixKGBXz6JGSXZJnMsynKZjStCGMOmcR4ylF6XS1X21+2/RZ5NMCzZToOIRxfIVWUcnrkvB9Ug2uQAaV4R0KcVc7J5xzAHuCjM3KkubPIZiQz3LbDsKIAVPum03cOn7otyofLXNvIb6PVBxjBbdjoOagZtgo4aRgzzpCDQn2rO8+/cYjm3D5dzDokc4N8z2C46Tiv8ficg5Z0K2kKC19TZhx/MPXWxg8BMm76gqeQ2Ylu3+3HhB9qrHbuaj0Y5kKqAiBZ4/s/Fno186u5cSlCb+WQ+1M5h6zZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(9686003)(86362001)(71200400001)(55016002)(54906003)(33656002)(921005)(2906002)(66946007)(76116006)(66446008)(478600001)(5660300002)(316002)(110136005)(558084003)(26005)(4326008)(8676002)(66556008)(6506007)(83380400001)(52536014)(15650500001)(7416002)(8936002)(64756008)(66476007)(186003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Lp8yohqlFl5ZEIlCDIaheOpWbBdzHgZ7Sl0cufvFXuT9rjSuo/Psyz0A7W93?=
 =?us-ascii?Q?E7a9UeEeaHQCx49LG+1y2ull3pr0cZ8lpBLbMw+4ui3Gvc6qQV+ryUclX/ac?=
 =?us-ascii?Q?PlLd2AHQ7vSI32U96HjpMA+jZkPvBt0t49awJkMM2M8M99s5r3VbSkh7cxoy?=
 =?us-ascii?Q?brHVA9ZjMYXVo3BH8+qrA1YjoXa1YXCJc7dkbawJlUpXZyJw2RtKHcBdvUiV?=
 =?us-ascii?Q?CwDVg5789lWmYfZbdR9jfFN0YWNYFJkI+0xL/fdFqp9PqJPzFrFW9S7WOdjG?=
 =?us-ascii?Q?a20F2oWXJQ0a/Jxpo/OI2uePy6bzvVx8aaEDGPOdrXnU/KyB/rGIvzDTiq6H?=
 =?us-ascii?Q?GjewSYZb4Xk6PL4cLibXzFlttACl0opcXKM7bKIvNJA5rk2g39f1wjQoN9Lf?=
 =?us-ascii?Q?gOsbNV7NuSaSQEkbjw7KGQxBz9R1Rapsataei3Rw1BbVZPTvsgrf77Nr2OsV?=
 =?us-ascii?Q?2rCBXOxhJEf8C0Jr6yRHZDKJYXsfrmkZwb0U73P2j6snbjo6ReXWRE1Naw6i?=
 =?us-ascii?Q?KiAnEd5hhxzHCtIa9uYBM12AVQ/59oakPMF8nRjwhp8PjI8g0WH4MjyP5bjv?=
 =?us-ascii?Q?+XRVdFXRG/X9yWuwH5HCY4WY5N9Vac7hfgYCvKLFbvRVQmq5+LnRjvWi8DsE?=
 =?us-ascii?Q?6aoTHgS+6qYytGnOmyKAzH/fmz0RCMAgkl1hP9WxtHK9BEiHabxgJkb6ndHy?=
 =?us-ascii?Q?8S4vdTleDJGUEPOjgB7gpEAxxf+7Lwi5gw98KmP+DpfaRFMT+AIoluqlLmuS?=
 =?us-ascii?Q?zKDmFQLnPKOOV88HCP/LBHtEYUTwyqfU21ysc2lp/kJV2jeoTd3hCFnksWLy?=
 =?us-ascii?Q?+FpU691T2gR/aGI8EFMohN6Dx+fTgmkSENAhMbb7iNLbVS2WaEs9pt40SRy2?=
 =?us-ascii?Q?0/J0f65gDPZq6fk415oTI8Txt1+SG9jnECtjo8/uFH5Oe1lr5BZqCuaw+9Vo?=
 =?us-ascii?Q?e0Q+24ebb8htJckmtOsyIlJUEDKrK6mikUJXI+BByi4=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f55c4f6-2ebf-426c-b335-08d89b4e617b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 07:53:41.6553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Er/cuKfdyUtm5nxENiZannD13fprP9ZJThlHh4pJner3Xk3ntmfpDY1NILiRXA8F9AlKvgQyhb9Vf5U1Vm2EUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0538
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Bean Huo <beanhuo@micron.com>
>=20
> Change dev_err() print message from "dme-reset" to "dme_enable" in
> function
> ufshcd_dme_enable().
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com?
