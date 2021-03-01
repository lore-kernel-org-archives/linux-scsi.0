Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC40AC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DB9364E01
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbhCAM5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:57:39 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:33752 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbhCAM5i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:57:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603457; x=1646139457;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=kjtNP21Zy0aefK4ZBzOsHiyFZUswF/3EqPrBolmJCvJKIeZxLaoZjMQp
   S7hzyJJcef+kbIPCN2Q0fon3qBQFW0NSLiFgniPgkXjtQO8eoa6vFCRdo
   iQgXVCpW9JMi+jZLMOf7a2nTIJfd7w0fUbhpVz/4TQ50CSTR8lZ2NsSKC
   Ztf1+4GmhJuBbL28+Y7CDUZVWV4BfpfJH9CwJPRwRHkgR9UP6d4qS77KR
   ABEapeHbT2Yyf02vNTTYisKhHQUYJXv/4rVmbuDtU79QicW/Gd9tKBAr4
   IprkbS7I0ZGLxV9QioJzRX0qmvVsse2ZzjdnVq2u2ijzQwLNvgqY5FGC0
   g==;
IronPort-SDR: rV8bEeyvP+zdiOiOaYCagFYI8Ph8Hmsu2p3fd0ZfX1kTcq30BVvG+gk29PdFX6zwQGGQG6Gajm
 6N4TURs86zmrh12jRUh7CQ6dsnst2tZI7MObsLAquXfWgCZ3o/hrtA3WyjPBdfE8LILLdlRElq
 EMvgWiM6477uRHFu8RRfa1m2fD61d04o39fodYaWrsFCiG1/jIZuUP7nETgRVp7ScJzOuZbjBj
 RYffITItsgi677xiOWRA9ipqr3yspguUDEARTjPVUIRKXR/Ui7QITjJr5yI9Zt9IeNayr/KjFn
 Cmo=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="161079739"
Received: from mail-sn1nam02lp2058.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.58])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:56:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1Z0qVl1jbu/wM7kQBrIVaOuU1pxE5xh0t3S276Hr52up79/yvvT0LwLHsO1mrGC+G81AnAh8byISJ2+pQNy3Wcw8aulIEJqXv0ppgo7WfaYKUDBANyb7u/X6le6Xy9am0OWcZh/XyOFaeM2eWNUaKGELFwLLloszITF91nBgJVDVWhBbjHyaT51t1/7URbXhHw51MnTYzTs1XjsMZBmQP5egBrrsdBaitC/al9fSzgZkvZ1BQG6rlMIPLI/dCoJGaGEHmGNN45dmEqiG66v/liJ00GBkIM32He+5bz4zRhzCCM1b8wTlhIKUIHksopSQEd+OJ1BogHLMGBGRCDx/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=n/BgAfHs2CBOiSwswXDc/VAmtwHK2QZp5ksupCo0lrQ+2qyeo1qrdczGulTe65lCy2rlb8kX+GFdTOwdiP/gSyH6/XtcS398x6HT1FtmSyUsJyaPxxBlGNN5AeSWoHXyAvS+Zq1J7g9JoBFCNbeOuhFgEXTfgBWbvPaZ0n2V2a3OLQD/1izyCUpea1dgXJ0l2tbsWE0OkSiqJmCb51Kq0mMgKpuXN6BLeV5iH0G/wLW3NOyG96rN1A9vLww2B2fSCNDU84X0cKVjg9z9vEel67vEunuWhi5LXYZ0IQVfRV+VaohhYEdXPY0kRQAKoLKPrXKLOEg7dvBXVzhgfMvKyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=DjBuG8kjNa1WKzacuDlrz47uEel44feFJkd1AVY4vCEjCsQOsFyL8X73xp8l21FOO6e+ec5Do6rXznJ6iqQuMwNRTxgA2BFeMmxlyEbK1BvUN1n5gh4wTK6s0xv2Eg/RJpTGe4nywNhczWJ2XUZVeO+IzmrwSLf9cdzrIFuOtTU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7192.namprd04.prod.outlook.com (2603:10b6:510:1d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Mon, 1 Mar
 2021 12:56:30 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:56:30 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 06/23] target/pscsi: remove unsed macro ISPRINT
Thread-Topic: [PATCH 06/23] target/pscsi: remove unsed macro ISPRINT
Thread-Index: AQHXDZbmu8UIDiGdnkyVywRR1KdfRw==
Date:   Mon, 1 Mar 2021 12:56:30 +0000
Message-ID: <PH0PR04MB7416897711DFE6C7ADDC2E579B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-7-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f98a2cfb-6e10-457c-3d60-08d8dcb16f30
x-ms-traffictypediagnostic: PH0PR04MB7192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7192B061B9EA3799A0874DC19B9A9@PH0PR04MB7192.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x4p7c3ojwy74EEMd5zHbG1irFvzAYUJFtvftsJ5dzMhv96Kkep44IhCOfZ8ikeYQDe9/ILQ/rjM6eytpFO1ejDYwRPi5g/p4UMqYPab057N3Ba83bioJSje4Su8Ah21N0RdCBzpcTWAmNegdc6IeblaYTRRs1u7z+rxL7lblTrct74qKDBfhoj8gtYd65gkWOAIj0cxjRpaX+viUzVKzVCKy6GbijNa8UUZO7/Vd7fmJ538p5ZoH9rM0T/40O4ninAQyjxMCfAzbvV4ibxMthUbmSBqkY7r8Z7qlpCEv5Ksg54gGHP4jyj43ul1d1sgk4PDcEE8XQxJwDTM5d+cRRJ0F+hpiAM+lq72bZhCic4nbqHIERuXZUuT0NL2LzNIJbtMcPKLTndlkiNe/SvaUyTrEnTPr+Vy13RUYM5Afte80AUq0WkdLWB2/GAFBLQ2IaVjPtV54Mf2fKHrVQeaCKx0/+vXB7F2Vkzrb5dBtCZaOrAxMPaH2iiMVBg/RY72oVHDGzGxJHl3/QFjYbNcoQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(66946007)(54906003)(110136005)(66446008)(76116006)(64756008)(33656002)(66556008)(4270600006)(91956017)(316002)(55016002)(8676002)(66476007)(9686003)(5660300002)(26005)(86362001)(8936002)(478600001)(52536014)(4326008)(558084003)(71200400001)(2906002)(19618925003)(6506007)(7696005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Ve9Dkz4XbM5Q2DiEbBImozydz06xyBwni3oN5iMJ+ZjBEvs0VeSlTuLeFTQU?=
 =?us-ascii?Q?FVD5VhyzDcNGhXydGDojSenN09KK6cBqc7Ps9FLaVptmvcCG99iUNS6NPjYp?=
 =?us-ascii?Q?+iVxH2bofb8wZwpjSab07D3B2Sk5hOanMO7Wj3sREc3UVkusKkWbmG0WQHrD?=
 =?us-ascii?Q?cEYXkyIkBp0Pm6mdkUGwze8pTlIcP8gabSjmkrnJMOntuHgMsImcViqHWOJj?=
 =?us-ascii?Q?F8Y3jhoLnl46xHjqhHyCO10gKPvjeCnbPPmBel6b0rmxzk2jdHMDEZUU2rCJ?=
 =?us-ascii?Q?Gl1KlK5MGmlecTMO1QMS92oWHj64QegbHDMu+mn7pWI8LEIj+66M5uavE8JL?=
 =?us-ascii?Q?6eED5d3IzAcPnK2MnDKykkPq83pGwyeoEkC3IDSBY94UW2yMtsw+svFQ0YLY?=
 =?us-ascii?Q?+uQAv9nKUOuZ3zNxqjFDfNuFqZ4VAwdBahTd6GVPMkdFOgkLqattXIE06drh?=
 =?us-ascii?Q?7c9sDNWIxiTXoYk2tR2X9AFyAkNGxIajgcXzEcAiZlQ0283exSD51tya49B0?=
 =?us-ascii?Q?FBx7yj7dxZhrcx7s1lNeAJ5zqSVGYsB1oqEdDpUt/7r3MRy8RXuDsQccfXV5?=
 =?us-ascii?Q?urZ+0x7ypQ8nxRC/7vNzua9Y/iMj4lVDTszGgenpHENIOOni/ljHPupp8/Am?=
 =?us-ascii?Q?zf/AZAZ2ifRepxl5T1FNCaai4UeP/GUB2J0cmzRjr8CSbuA6/KGFwfZETYWp?=
 =?us-ascii?Q?1O2oQnl9O3jonb+8HKxjiqC6JJZwbrJfeS3FjYeGKHn66O94FyH4z/MybWjb?=
 =?us-ascii?Q?gCnIs9NA66Zr6LEo+26TpcX+eMJv+BQ57rna3rwrWN9yPH8W1m5om/WuMjI+?=
 =?us-ascii?Q?eX7+fRwXdO+HKxXdabD68PmRXpi1VN/uquRKU4cie2K9s/uYHim0HNwnsPCF?=
 =?us-ascii?Q?QCttWmeQDLj8tIMpw+NNSI/Yr8PkMXWAIu86KPlNppRRR9JXqsRNFaIVcaH/?=
 =?us-ascii?Q?oW2OBJG0lBuGsqTqwixi1w+eQg6IJSXEyOIydnM7VnoEMH5PnkPkRVJT0kk4?=
 =?us-ascii?Q?17P+LS9ITR+zwZ9mm2gZr5f8gUzGwigfbtY5eXrJMhuWbaVH5EG+GU7c44mq?=
 =?us-ascii?Q?VUu1arR6dhLje2JJODoZJEjFvWyGXEGbP/0R/j8Xg8lH1HjiZEasSDFO13+g?=
 =?us-ascii?Q?iLNr8lmv1ulhrwi4cSjbycThn5Vt+qNwRIRQqtTtati8WFVArgw1T9GTCNdr?=
 =?us-ascii?Q?CaJy0PTwbfhA5D+t5caKO89JmOcg270//HRcVYni4kKnaSb6JFnNlIO+bEny?=
 =?us-ascii?Q?J4RK6TkDBEF77ABeEinX6Q6vlL5OH4R0a/Y3ovlW33UXS3vjqPnmxYmInAES?=
 =?us-ascii?Q?quKq8JfTC3Aj0PJggXg/GIqLguPJczDrVFAuHB2dkLYb2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f98a2cfb-6e10-457c-3d60-08d8dcb16f30
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:56:30.4723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gmY0VpKgQVQhP7nQCPKXTTZwa/E3RAsu33jVCeysEBLeSuisqNRwG2RQ7HtnlTS8WKIr40pTXolBjuPzOErJ2K2Gyy0nblVXKSQ+E4uLk7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7192
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
