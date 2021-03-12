Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD438C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 12:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FE806500C
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 12:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhCLMCy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 07:02:54 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:57485 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhCLMCt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 07:02:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615550569; x=1647086569;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=62d68jSoq2T2pAel+l1bFcbu4B42qKBBTtKJVoa9jPw=;
  b=lHKr2nJDUTP3WIUHbHveEieLZwL8KjFkWom8EhxXMddI6AWSmXQbLE1s
   9e22nwzck9JRFJqNnnye/Q04Q0+XfA6VjWkoKvZJicCv2LPj2YpTygkZs
   5RKDIAs1cQkGDgSKHD1CAFc1wOA4EU9Ilc3uMOVSAujGXab0ZFy3l9L4e
   7f8yaKnauW9SJ2Jnld9VR34ad9Jms+1pCn/bsa2hE0AHvAsV/1Bt3bryD
   EQ72jfnT80v+zesGp9oaKJiBWEdIaVGAp6vtgnppMRSlLZhPBkvJ/vOGO
   9hthe2aDHLkLgB+hJfOxKLY4ue4fPUefICkizJ4BWbDVFbfb11WnQc3j5
   w==;
IronPort-SDR: teef0ODJx2LkpVNV3ljftxr1XyUQ8K6d4M6H32WHY7Ud/e9+Hplzloq3gLjyV0ZatXch+wt2GV
 oXhfyDoYenl/GfL3NmA+dkkQcMrhtv+YG/owpSSc7YaIOJp+/58uoSoMm/3RBpl/an+wg7EDK4
 eZ92dWW21kJggPYZyKFu/hyDKLM66fhjxWbPiWQESTkbydgO3voW+O8zzArSAIWzA4AS1BgE/b
 t1VnipZwflG0UQKyqTfM980HtKWg8ev3An7EY5c4MIvBCE/IldAzD5TLauR4jEkEnpOiMwC73g
 yck=
X-IronPort-AV: E=Sophos;i="5.81,243,1610380800"; 
   d="scan'208";a="161994484"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2021 20:02:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hi9Ifq2b/7ZdF3WAdNCgxxy1Zfh3cnlhtVJxWrWR1jSKLLaHbJGcoJu4lVsED9HyRA9la+/REMLKLlGzwiDfEEWYKO4YKq/lWYn2jstXKE7VaJbUhURRGrTKZaDzRO++rXtLZNv/m0N8wv0VbbLCP/nskX2fpqPCjGK9DywkjW5jQvAh6EtHoxaOX/Z9vV6HTlDsoEUmgeLVP1ZpPML/3PApLwe5tA1h9R/QMHE1IeboQhM8MuaY2qJkof1ttQZ6SOMMOpKyKIjKqoWmkZZFmlKhsZ8P84A2gmz0RVTd+ys+p76qpzuzABOYPvhy61W7D+XB02YD3/119kDJ7WcblQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62d68jSoq2T2pAel+l1bFcbu4B42qKBBTtKJVoa9jPw=;
 b=WCnmpImxqBJpT6+LlLA5O21ET3mBgrzoIytUxDP/FB6bcLbrFYHXNNfeFrfWP+aMyuAqxSLzZk/WdXoCm/ViV3HqLYni1GBuBGVBqUWuYfakxpa/sCKkYvC89P/gHB0kP4h0M1M4xQuM69Hhs4eFXD6/FvjG6mIA64Uj8P9kjzP7S9f34nVJ0Nha4FybjI8JfAyuDev0fLMB1aoQ3kn2v5DHxgYDw5YsOnt2dcnvYAVmZG0wgoMqfUKCk+rv7QV2gkBCYplpsdw2pG9NNvpIdtl7omhSUCcdHrXj8ga5g6gOs5tpaHJjAHDFeA2PXEQFSs3KBrLDE/DdR2C8kuzi9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62d68jSoq2T2pAel+l1bFcbu4B42qKBBTtKJVoa9jPw=;
 b=xTKwBCL0FvpblkbFWjD5B6imOg5MvvwVsksgJE45iLRJZ0PreNLePlBJaqoSEEtuj7ByqNhHa/8xrMH30vHBAbuU8t4qPazNyl+CP87sG8pb8A48J1s7hfEQc96Uz5mhKWdrXozwuaef28eCybnFh5b7ax8LhEmvut59BwTh1Ms=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7734.namprd04.prod.outlook.com (2603:10b6:510:5b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Fri, 12 Mar
 2021 12:02:45 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 12:02:45 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Ugg++iEKb0KOzcBTGpFywA==
Date:   Fri, 12 Mar 2021 12:02:45 +0000
Message-ID: <PH0PR04MB7416C8330459E92D8AA21A889B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
 <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312043828.kl2olk2d7awfsi7j@shindev.dhcp.fujisawa.hgst.com>
 <BL0PR04MB651449ABC126A9FEA02CCB08E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <PH0PR04MB7416C8F6506400FECB7207AC9B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <BL0PR04MB6514879C187E6C81593F41B7E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
 <PH0PR04MB7416C0E44B45C3FCDA7127989B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312100545.cf5m7yd22prkbdx6@shindev.dhcp.fujisawa.hgst.com>
 <PH0PR04MB741654F7E0919E8416F072559B6F9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20210312114856.iqeguiup5lrzgeha@shindev.dhcp.fujisawa.hgst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8a1b0676-759e-4828-92d8-08d8e54ebfa6
x-ms-traffictypediagnostic: PH0PR04MB7734:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB77345EE0D7EA4E5EBD68D39B9B6F9@PH0PR04MB7734.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y7qchEWNXJpFzdcXShqlwlk+HgVvX3Iz9Y+vu/YUxW93JihuGcMcjn0X/BHMh7azinbqoNfCGvhUFicQtpFhAMOpEE7cWS9NpNjWSvjx0AUm+RL55wUoQp7Me3Y9GHjUwJK6tF+r1w7Ay2diTHYlvVGDg3St19mC172rjSPH+N7M0g2qdG2BhhAZt6Y4Sr7MkrZFuG4B9XvwEz08MW6dpfQ3cZ0FAPeG7eQUZe4Ddqm7HhFS0aGcY8+n5jiFjJ94aJ4fOqfsgLwu6sGDIMeRP7mVvHp0wc7rQdMVtRFyTXXB/bU6c2Bo1dE2y7iVV51AaxZc/mBqybbfPEdw3akCATKCrBLozM7pfpoRzUKgKAosrixJFWr2C+b9oZCr2JFpKDTRZ8krVTnAPXFzH6nkCTdK8gbfjo/ZFMW2REGJtY6hKgHpXcUULrrs4gJNxzyx7uPMtLgZr4mxcBSi0yUnHKitI1yTZTrnjBSKqQ4h6DU3pyKBG/0nOJ6Ux8jOIKW4g+KGIAi84gCiQBBa8ZUeuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(66946007)(54906003)(66446008)(55016002)(64756008)(66476007)(478600001)(186003)(66556008)(86362001)(316002)(4326008)(5660300002)(52536014)(9686003)(33656002)(71200400001)(76116006)(53546011)(558084003)(2906002)(26005)(6636002)(6506007)(8676002)(6862004)(8936002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0J+1Dd6m08bf1TTNvWQ9kQdrmwUvWl2wKXBDu3JFS6nADhUOCeMIGmFQGZOk?=
 =?us-ascii?Q?DgHzdVOYeYtYRmjf7+ONFSSMacR7GUAyiq181Yo4x92zvaraaui9NusO84Gr?=
 =?us-ascii?Q?PKHkYvRLVmL/jeyB3Rw+7EiOsyz/J8RI62Cgts0hlMn3vQ+teAHhBGKbog9Z?=
 =?us-ascii?Q?L7A8ZHwN41qPGinUoE0LjJIyteu3GU3YlQexcrBD7IyKemrz6dfMxLCtodXT?=
 =?us-ascii?Q?/46lYvTsDK/lcJzGaJAO0vDkY/Ikzna+3QZ3ySOwb5jFNerw7R9Zdyj4R5cj?=
 =?us-ascii?Q?x8PQHvn86CUlPxrIkEDqugXlvSGp4s/A9JiNdQp/4aWaCSj6Zm/HDkhMJJfE?=
 =?us-ascii?Q?RVKnwvyhXDiVkE+7eNTs685F10xSbnZPhFOo5ILX5ePTLi1nqfmiHfNua0aC?=
 =?us-ascii?Q?5yxz2bO9BhH2sM7Q/Hco1iRfkxV9kJ3iDEYXs9XpfIMwfEJvDvg3p/Sw10hb?=
 =?us-ascii?Q?rlFE36JRRzZu/MkLuPqn+u98y50arj41Es69cYZGSlQu9HCDpC/kr6480fY4?=
 =?us-ascii?Q?3PGqZqsAeWAemX/eKUdq3SoS3Q5pTotDABbc4Xjgh9M3flOFlRvFpnE7bdmT?=
 =?us-ascii?Q?a7jJcoCNZf3TW6TRusUmKB3yWjz5MlTVdldHbVsJteUvpWB4EIawFk4SwbQh?=
 =?us-ascii?Q?Aeu2Ne9HvvXlo5Zdg7990P1L7MW4dgBohSJWi97x0BJDf3wpUFAx9scEyyXr?=
 =?us-ascii?Q?H/dRXQg3DpR8nwd6UhYvpvIw+VHyEziiNg5r98YxlUKrl7uczSMqA5eGXFWk?=
 =?us-ascii?Q?M6ZkMbiAcoBgYgNKkHYgwj7exzcXOfDOxZgg9/eD7fI4EOqP46yuc4jz6rmr?=
 =?us-ascii?Q?7UxR+NkPmbfdOzlOC/5UqkqsYIiNMZjJPDNopiJUwTlxMwuGSx4wlarfMAf8?=
 =?us-ascii?Q?j+gBS7nNRdBeNX4vfqy2vll5y5NQuJ3f3ZfP1Dh7j1FWeU5oqkXCLIB8hfP+?=
 =?us-ascii?Q?1EugeMwqoxQQXZYGYgOGye+DeIUc9j9ibwuddjpOqrzLFuk4BQ2ODNR33NsO?=
 =?us-ascii?Q?X++MN1fuR9UTEg6MGbi38cdtQ5LJBZ9D2xChMRGXLt2alhZWKsQaK6eaGXjs?=
 =?us-ascii?Q?6k4vfaYrrkNB9wv9+rPZBL+NV9B5Qr1JR/XP+XdUj4/nISgAXIqEOzj58L0a?=
 =?us-ascii?Q?337Kr8+4aGRBn8G/DL3RNXWp/TezqVW7pL6t9N4EgqOLZtAbfCsum5ljxz+l?=
 =?us-ascii?Q?alRYqNG91gYbWqGQSTrdkNmVJrEX3YvOML6qqmeA/nFo8/cUnnH8FuhDeGke?=
 =?us-ascii?Q?MEalCwE/Dcz5lF4G3h4phGuxP2dRT0yd61J0JqA+9Iy1IOf5Sh1x18TVVrkf?=
 =?us-ascii?Q?0hTFrXgG0OqaMjJyDUxUOXFSFJ210DDFJBHLbhjSGx2SQQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a1b0676-759e-4828-92d8-08d8e54ebfa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 12:02:45.6956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h0lquObcKcYQhMGqDW8OEgGkw0ubG9o7Fud/bdMhBZG9KDisjtE0TNPB23Y6EfOg7hHo1SLEbv4TQWZV1T8yeHxIlSmcLjAXLPwLPwq34sY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7734
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/03/2021 12:48, Shinichiro Kawasaki wrote:=0A=
> So now I believe the commit 664f0dce2058 changed scsi_finish_command()=0A=
> context from soft-IRQ to IRQ.=0A=
=0A=
That would fit you examination that a revert of 664f0dce2058 fixes the WARN=
.=0A=
