Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5B2C43215
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F291020815
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ls+60amK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="E0/8+Fq6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbfKYHWl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 02:22:41 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:14510 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfKYHWk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 02:22:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574666560; x=1606202560;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4ZA87POlBpYu1pzt8aumD7gQ6OQaYuAqDkdP1Ec0R68=;
  b=ls+60amKQpApXtgUxu8HG/yiYRN2Y3E1bMAO5n6jiV/5zkE5IGO0gGsy
   0fN/hP0C3tkf/M4bYL6fWKBbYGLcBdhjmM6wY5Tb/bVosWaRu/WSiKnYF
   qO3AtA5hzXUvxPCAQZVgBFFrZgHc+HBHNX9i+u3lBrAWGdmVAYCBO1yk5
   SYwZqJK1F4LbPs+iRNTfJ4UxwW0emixdDZZGIoPAWsPPR3z/T4nOIxv8r
   aDud24cQEKZT3dIjpoN+1uUA4bCx2Pe8CHnLWOCr952B8xEVerGtCVfh1
   OM7ziDz+wR/CX+euFrIzH7+qmIAIDQGKf2HqUHOV6yks6hnEINOsdNm02
   g==;
IronPort-SDR: grS0I4rgSjvEjTxPy+Di8L8rcOXD0VkqLYTaRnHWGHbSvyTvqM1JxuGbdlHtJbBsvAO4ND7aWp
 dro1QcEbG8rJk95CkgTP9WA/BrYM9CcTJDzMQxk5uS27sn1d4feotjVFkdWP8zrRY06/7pgk4W
 7W6UI1xrN9737TC6MziKV9ZJL3OqeeihDUMkRCzsKEl0IjJU7dEuDGynpaY7a/550Ho01MlO2a
 4FMjKgrRmGuUXEp01cMrZhL9C1audtxKhIXI0LwFg+9/4voFolc3rP9ofnLPOVAP5DH190Oazq
 T+Q=
X-IronPort-AV: E=Sophos;i="5.69,240,1571673600"; 
   d="scan'208";a="124683004"
Received: from mail-bn3nam01lp2056.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.56])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2019 15:22:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSnw8VK8rd08DbGb2yo/yANP+b/CHoFAde6haLxI1xTh2X6Qg98IAlr/qkMTPFZ/H13MH6igGOXaOgpGqYTVnpWYle8LTMuOYjnVY4xDaiYN3+ELV8CTM1/A4ng7PP+CEGEuwfzT1JBdQT+tkepsp/UpiqluGQ1DfdBz9uyHM5SX/QXcnSfC0miv6+MIXU+4UhfoGQ8M0SZsiTDmp4TI0Xl8YktZisPK8yAba8ouXIXcY3/Tz0+8O59WkSyNX8iUsdRUx0KKQmLZob3pTkzHrZvNEalKG473wU3KjsQ6WLdmezKWMt8D35oc7cyGs7RGBVzxDzBEYxJYdpyKnqk1pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZA87POlBpYu1pzt8aumD7gQ6OQaYuAqDkdP1Ec0R68=;
 b=cuMSTLdQP395WQjcdlFJj7Yw31ZwmU+3af+dB610Ym/HtQYe1+THXA2BQ8DcerW6Qj5FYZU2JYUwAf4Gop1UQcw+LWtf38eGiwvcrKfa5Nf2+JNXl6HHQlDfHiKVJO4iWAOhQOyPUjJEynbtEs/qtk4C2lneb4rEUC7Zc/u4PFc25OsjaMUcTlnAtNpKP2XY1VPoNaocugpcoU1phXrV+RddjnJiErHdBCe39ohEZrWDrvuYwI77B4hmqcQ/u2A6ACKnjeFq7CWmQubbez2f+1ZcKwmKGfy5Z9GEbeC39hpqzuvcRAKkqANe+eymZPArA46P4ucZ0+AGALlUPc6uQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZA87POlBpYu1pzt8aumD7gQ6OQaYuAqDkdP1Ec0R68=;
 b=E0/8+Fq6OEwOb4jNI8YtETO0MOBSa6WB6MGYivshqk73i2sTQyuKonpoV7ekjrrM49OM89aXSZDoaA6RppzaYRSqS7yyyQVEuM8TnXzLZ/JBWLrqnxwNbovvlHd9XvGzBe3wIZM6XsWK3KypkLXM8TJMrFrNxs3EofGmbtlN7sA=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6127.namprd04.prod.outlook.com (20.178.248.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Mon, 25 Nov 2019 07:22:35 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 07:22:35 +0000
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
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 4/5] scsi: ufs: Do not clear the DL layer timers
Thread-Topic: [PATCH v4 4/5] scsi: ufs: Do not clear the DL layer timers
Thread-Index: AQHVmee89Uj0xO4g1EKSBfsTmVIai6eUMy8AgAda3iA=
Date:   Mon, 25 Nov 2019 07:22:35 +0000
Message-ID: <MN2PR04MB6991FAA95F79EFB1EE030D13FC4A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
 <1573624824-671-5-git-send-email-cang@codeaurora.org>
 <MN2PR04MB6991C35EC2DBBEA17A611755FC4F0@MN2PR04MB6991.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB6991C35EC2DBBEA17A611755FC4F0@MN2PR04MB6991.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8cab56c2-f2d1-468b-8081-08d771783e7c
x-ms-traffictypediagnostic: MN2PR04MB6127:
x-microsoft-antispam-prvs: <MN2PR04MB61278B3A712B283A5470C1A7FC4A0@MN2PR04MB6127.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(189003)(199004)(8676002)(81156014)(229853002)(305945005)(81166006)(7736002)(86362001)(8936002)(9686003)(66066001)(6436002)(5660300002)(2201001)(76176011)(7696005)(256004)(26005)(7416002)(102836004)(54906003)(74316002)(2501003)(6506007)(25786009)(6246003)(71200400001)(71190400001)(6116002)(14454004)(33656002)(478600001)(446003)(11346002)(4744005)(99286004)(66946007)(66556008)(52536014)(76116006)(66446008)(55016002)(64756008)(3846002)(4326008)(66476007)(186003)(316002)(110136005)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6127;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?6+Shg7HIcXoYogDkwL7z6xS5nty5XHqnc3kqsA/VLyX3V+t4tYx2KZZtK3ZB?=
 =?us-ascii?Q?XGjuQhmrZQghlypGypKodvZfqyuHTazTqxKpm1Twbct6vO656QMiHu+R+8Sv?=
 =?us-ascii?Q?Z9J/m8JF5gyXWfQBA2TesazlYMNmLtaAFy36K8PHSBf+jD4U2TsscKfK1DGQ?=
 =?us-ascii?Q?Q5V1+m7Ww1ZjL/nvXUMNJS2ervQ8RANiIdwW9DNicHILOsMlzGQDVEHtySno?=
 =?us-ascii?Q?yIr5+0EfML6LDdssU9U1gCaMO1Jyb1/wu6tXAu3u7a1quIaHA/nGHFGftawp?=
 =?us-ascii?Q?gWhjpDwlNp6eO5yFIrBwPe7CiLzvw9FfPLwmWkqW2nBlwkoxfpGQ+GMJEaq9?=
 =?us-ascii?Q?A/Bj5IO/LicDk5k1ZbnMPCDsz4nt8OjaxOVYhFXdsaFfCdv6MgVGofKu91Sx?=
 =?us-ascii?Q?P4GGkn/fT573conLgU+lvfbmCRKpp8i3sO3lkoihdxRCaXLudSi62T2NawIX?=
 =?us-ascii?Q?NKpHeq/CZ/SxXhbXF/AK036wUY2k0fo/7/JFWIevbpWFddKy1FjvznrIhcwK?=
 =?us-ascii?Q?fsk8X/NLCKUJhl7n0DsbJAo+BiuT3zlrQ3pSdcYbiJsYetnNfV1M5tIfPQ+6?=
 =?us-ascii?Q?LecJWOWhWRgfEhDrrGpJIR2bKt+MSiwd6Fjp6l6cpVfYJMKQdrTT7TPNMTPJ?=
 =?us-ascii?Q?by84zZVKGTmif/F9+cHpdwVKmq4MviFPaSqBETsZGyl7Kk3AU8ZRJewMNFqh?=
 =?us-ascii?Q?gf+6J+g6+6HeQAvPknCpWKfngc7wpfEumyq76n6wLPyUS9DyWN0bx4FHa4Hs?=
 =?us-ascii?Q?Ksz+0KtK9y+H5vDISqe/YRQ0aReVN5MLqU0aTPTSnW2ENWhvZfzG53NERIG3?=
 =?us-ascii?Q?0UqxLk6mIy0IXd8YhIW9VjJ1X1f8W4HhKOJA4hf5CFQZDdIYKf04UI2dTizY?=
 =?us-ascii?Q?goMN35NZk8i7VxKnGpAMO1gvg2M2UcAJJXHfa7cVLu2dTO5QJZUt6HoBeNPh?=
 =?us-ascii?Q?f9ErTvdJmgsdFjvIq7zAUmxaUBQYohV1ZmTu27zCflJ9Zr+NZMUHfYJEnzF8?=
 =?us-ascii?Q?qZ9jxiq9hHcFYZo9UEXsIKDm0QjzOycDxU3Ps5vvOZaRubLs76OU9DYgNrog?=
 =?us-ascii?Q?KYIZTCzFzDPxtYC9fg4J1pST1QPGCnlqzwjM1NKaJ2ukDwo63apCgFjV+iHo?=
 =?us-ascii?Q?tKjCNiUzBJmqZWnx0h+Z05oJ36zFCIGmlBv9luftyjypAWWlQvvf0q6IfjBJ?=
 =?us-ascii?Q?tP2cI1BWUYVOfcjRa4tLdXWK2kOrFeH6LLiF39KKiFaZV7WJVlMYQWat+mH8?=
 =?us-ascii?Q?fh/i61wV4g4vxKmN+GtO+71LvsTn2liq7sHF9i/7AKFrLGYUlgOFE2Q5qxvO?=
 =?us-ascii?Q?2yfL34+/2kiNP+ZpmR7KSMML/6HtTD817dojcOPm4jgQJYOi0DXeELxMw4vj?=
 =?us-ascii?Q?RUZLWntosF+yO/cCRu8our/pvR9ACZ53FyAo1ApC8IagmnscfDaYvnlq6EaY?=
 =?us-ascii?Q?uq5BASuI6ovkPafLR5fLb0y4qLpeaYNUapK/b4I/+K2sEGJRWhss56DBZx5m?=
 =?us-ascii?Q?sh0t3666F2MlTxRGIXy/7k6IiHi3TVmXoddbLcy5w8KkiDyre5UGv3hFkKai?=
 =?us-ascii?Q?7CLvpgUVT3nhF9KI0P2xSIMBhOH8fSqiHT9cmj/OQmxZCAcjkaannDlH/Chl?=
 =?us-ascii?Q?fQyvpO19Ym5+LAOpSt/8NmqXShPtGkdmoW4tyjm3zsx/861Vc2B61RCWoMnr?=
 =?us-ascii?Q?E2CqooQ4q2MsapQ40rNu4glejN9LuRHABu+cRgDmwl7m99GygPNW/wrqtlaO?=
 =?us-ascii?Q?UP7+WugLeN2Q7oJTlzn3A0wk3CO3LyAaPzb8a0d+ecHF7NUmpzoM?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cab56c2-f2d1-468b-8081-08d771783e7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 07:22:35.3251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skEctqBh1O0vfYhheqcCvH14Rn+fG+0QI16j13VydEjS9IE96jZ4FUt3hkydydpTXHR3hG035WZ2l5SonZaG5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6127
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >
> > During power mode change, PACP_PWR_Req frame sends
> PAPowerModeUserData
> > parameters (and they are considered valid by device if Flags[4] -
> > UserDataValid bit is set in the same frame).
> > Currently we don't set these PAPowerModeUserData parameters and
> > hardware always sets UserDataValid bit which would clear all the DL
> > layer timeout values of the peer device after the power mode change.
> >
> > This change sets the PAPowerModeUserData[0..5] to UniPro specification
> > recommended default values, in addition we are also setting the
> > relevant
> > DME_LOCAL_* timer attributes as required by UFS HCI specification.
> >
> > Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by Avri Altman <avri.altman@wdc.com>
BTW, I noticed that you are only updating the TC0 registers.
Why not setting the TC1 registers as well?

Thanks,
Avri
