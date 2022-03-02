Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0748EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 14:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243120AbiCBOcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 09:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243193AbiCBOcF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 09:32:05 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42425CD5FD
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 06:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646231429; x=1677767429;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=hzJr/3RvW39hIGA+2zrSwVAJWp4u+Qpf4tCy4BBzd5HY+DMlsk5DsASH
   yO00y+3ApjFC7v1oC1PNc8uoZG1rFvFcDZZcpnYqMrGT0ITW7b0LCXlEl
   F1hHzaJ2lg6Y2Q5b8Jr+JpzNrQl0SuzvtFvVvUyAnxtKfc5Zaaavg3IPE
   NOAuoyPKFkeH5FlOeHjPZkrHZnCyl5ZnI9LM87m7npZtcRiDEBwijDCGZ
   /qsvC7b8W4pZdwAuD1rEGf0l7GnyS96Wi0H1nMSuyNSqxJNVHardswYO2
   a9D4UzkYDPZpdFJPQNLjdtxOXy3mVBvxlbv7hoeHqjQx/LSh2eTyClK4a
   g==;
X-IronPort-AV: E=Sophos;i="5.90,149,1643644800"; 
   d="scan'208";a="306200289"
Received: from mail-bn8nam08lp2046.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.46])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2022 22:30:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFIxNWafcfpTa/JCKpB32Vs80JavnY9cewi/XEHqiEqFMopM7gNwDWdB6lKfiQNMT4YWbZ329M7E132WThCH4nYtpJKJANz9B0vn0+/Ks+UwBmKc5dxsG10n4iIMHb+fhjtY0pHzFNInglEUEgiDD4qUPtkPoZSexwtaCjMfhOzD5buMcjy1ngCXq0NP5vM3nmF0S92+GH/kc9PRtPNP/bRb4SpEMFYshx4yYLPzWfG7quMDYD8XfNwjfEMhjt6RDybg/g8pTx4NXFx3E8M/28RpCzxDdMu2FXaUPU8ibbkvAYIWsiE15Ugs9VvHKYnkxyaOLiMMbPJup+95CqjCOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=T7w+5dGfzBtr+Tg5Bb0ZLGdTvfbD72HRNI4NUm9sJWme6PkfMSUhCBraykNu6IspGWFdtkw8QA/UBmPXYo5ij0CxHRAIBSNlxDW3hJAUcr6EfWurLT3GybfGIeTpiXfV0sUmKect/ya4XxsH9taBlufbF/piCngJ0J2DIZmiEVcYqEttoN67nCVS9M6+JvKZKxDGTuWikXvU6mM+BifhnjhZxkJaoAShFxgDqmL6atrkqaT95N0cSQOZNeznVaCCISkc2I5Lde4TCwU2/AtoO76OlnXgwJ4xIZCuEpiGTZIF7eyDutZCa/n+2dM1QAtb/FL79t2bdUgYbAdNkvFUeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Mk1/o42ObU2vuIg5J93IybXqGzPZnG1A0c35WQ75HCi40tFLwHFJH7Vw/eDFvCBhGWesg1JgPb+rVWRFrhfbJg46sbfDs+vLgL5ovT7JurMfWQZHUow3bWGN3wR+p3vvFZfBuPNzlVRIdVQ4/7vQ+wcBL+tC30LRbEvg9n1IBsA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB6637.namprd04.prod.outlook.com (2603:10b6:208:1ef::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 14:30:27 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 14:30:27 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 05/14] scsi: core: Cache VPD pages b0, b1, b2
Thread-Topic: [PATCH 05/14] scsi: core: Cache VPD pages b0, b1, b2
Thread-Index: AQHYLfeBKtTuBIzbi0CjfAgoY20w5Q==
Date:   Wed, 2 Mar 2022 14:30:26 +0000
Message-ID: <PH0PR04MB74168E7A0B38C38D5B2371689B039@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-6-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83785f16-37a4-4cd5-8dcf-08d9fc59320a
x-ms-traffictypediagnostic: MN2PR04MB6637:EE_
x-microsoft-antispam-prvs: <MN2PR04MB663744C83DF23578F6E96F259B039@MN2PR04MB6637.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /khkrFxQiGTB9jrzWmcvdCWfLnrCG3oYBwApGVYMckgnw/7iluXNFy29hcN8+yqrCLlfUZyJMB88enQfOHjk5+OifycEshFuh4+LqFndSeZtGMRSN51bFrjV1jPqwCsu+HtYuZ0/InrVTmWerDJJEjjkLne6Xm6rgcRapDsStuLZ6BmeoDBc9OCsDiksQ8G9/7xdJqXsI1bLYtfJ41SAOxgNKDMTaeL43Z19AfbfQqYpW7/wyBmknfmCOoUBeJR5Hzrh/Wr8Pq5MvMFR6tRuPWFTPGcrlsGChpzupx3SbAdtnRQqV+VZ1ncLwiYoynwEMJ6i0D/ElKQ6XqlGYMRF6N2yBKRSf5v+ZnyJGGBFmHD+dwdTlpw05iKHxzNR57P7To757jqFrKkqO6lknydtw6YQQdPhO+qH8jUjQM1/gHcfkc7jnIbOj43dGjNAe50XPipqtB3NFubptyk+s0+T5oNYhHvopExwRlvKzZDH2AxeB0yFBTZKxkAGW7oNgGlJEmvKSiqSuMCejAmELEoMv8SBQXB69RRk7BSWx+CEPCa7Ev4Z/qctaAy2ICJ1wnfWlgLhwdmiZSErJvy5568EhiApyg00uWfjdqcDcb/t1Y/hDG3DmGEOaWyg2saqtX9ohCUUpyDurxI2ZH3KKuSz9gFbLxiTGl7kgy/eAqBb5F6gwEH0nGClLjb7aWe0SnEG0UIDmFUNc5GwA+aqOIV2vA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(558084003)(316002)(19618925003)(2906002)(71200400001)(186003)(110136005)(55016003)(7696005)(6506007)(66946007)(66476007)(66556008)(64756008)(66446008)(8676002)(76116006)(38100700002)(82960400001)(9686003)(122000001)(5660300002)(52536014)(86362001)(33656002)(508600001)(8936002)(91956017)(4270600006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tk3oeIGo0q9UOsB+quZTEvQn5YHpdWQhy+dmV0i1T9Q9onjVDgpoA8DXoStZ?=
 =?us-ascii?Q?Mwqjp1bNuz+CKLnAnFxfE85b+HMR7NHdnJlyGNVQy37vK5v17CwOePGmSHOv?=
 =?us-ascii?Q?INMaHb7KtB5mlZsc899McDI6Qz3yTHefQZSORsXY0gV/dfM8C0MscpSX8nFr?=
 =?us-ascii?Q?65GuaYmHQC6MMDuiOe4MW+Rw1FXAPLAhRGGdw329ZriJ/9rhIZLQo9VHhqle?=
 =?us-ascii?Q?5hAJAhJeG/i6uNsRd+fBkOd69bCJB83BoniyX4AEfhavgRww8gbjWIVoXMeB?=
 =?us-ascii?Q?wzGZAYQZZcDNMSqwsTQ1xwbH0DbIuUjPoVfcaRDnuOi/+235VuyEUd8wYazH?=
 =?us-ascii?Q?4hVOvkQ7WxbOI86bPsK4sdGzcZS9v/CNnPk8Kgk7lNCYdQM5ujpyIC8auguS?=
 =?us-ascii?Q?BxuWjt+O7ILceA5tP/QbeKGn5rZgXgnMSv99l8Lsc1Sp9rSxXKZ+rHXXY/nm?=
 =?us-ascii?Q?eexfCRcscbiqmYHDNQMgEkEnGDTgWZNwmmucA0eiJmhiU2eRBA7TURVbO/yu?=
 =?us-ascii?Q?VYehQvWWhVRxPeno04dDJjsQginlz8QYZTqgOoW7Zfwj9Qk1Z0yEEDZJ2w84?=
 =?us-ascii?Q?XJjIKtaLJ0PPg3nHVzB4lbY62XRF5uMoj3t+fvL4EklJ6F7VyruRe11U3c+J?=
 =?us-ascii?Q?H+/W4H0zXR83RuJl/YfkCRJHxU/DRsLtn/3GrjDJnryfiQi0R9FQi72zZeKM?=
 =?us-ascii?Q?u00IIA8xtVuXIoO7W1hfP4+iuEpC5OCccg/MGbMDxeF0ELiZ/wmeGhmy8Bmm?=
 =?us-ascii?Q?kyr4tWs7iLv1ryMQApSu0HdutXJjShFVhekKDnYDvYNPOtLVCZEO379YXuN4?=
 =?us-ascii?Q?KRXHVz+IhJXnMMlZDCCQ9SVX9ICm7dChEnkdA95NhzrtOSRAISy4mZ2OpXsy?=
 =?us-ascii?Q?hUCpI3QP1oEe2KkTlJUfZYExq7c8Czj7CucH/7MIuDSYHbpJfs4AFkVdjpJm?=
 =?us-ascii?Q?p6LojBboTycIqPwbY+e2PUGuAI4HFg3T1GzSgpSe7daadcrkPcAbpNqCed5v?=
 =?us-ascii?Q?ggf76AJIfJbZ4fLSAq97wxKWfZjK5aKbdBnQJ9VCBIn7OiipZe5vTzDFh32b?=
 =?us-ascii?Q?PaK3oYHcmH+OVUBKxbH6Q0weeGPmrFfIsbVpDRGkWaQ6WZ6o0wZcxMOgz9gq?=
 =?us-ascii?Q?BqXWXHjzhAjmlaI41DClfrE8tsC+GrE6/2xVNu78S14G0UYL4Ea/iVrR3mfP?=
 =?us-ascii?Q?XQdwlEcI2LfMtck/bgQ/9pvkQ8DYwBFE6BDrRuxPJC+659zdXMDB6BRYq7HI?=
 =?us-ascii?Q?oSR5SOeYATAxzpQLCCBt1zIKmaxeKJVhiWVlD4T4tQFTst8zDfa0G63LcQxg?=
 =?us-ascii?Q?qm1sTU2fIB6qYpjvqoaubu5qd98cSzBbl+dPnYmW6NAyQVwkCKVEzfGP1x6r?=
 =?us-ascii?Q?3uIUDJymk8bwYKG+g7LIyF4z1HEy0V/Ewgfp0YCL5yAAzu8ll+eB4L9GmlLe?=
 =?us-ascii?Q?Y1JkLjk21rEStMjEBdcOpe8YBWZ4SduUu+mjV0bTGUNunFtUxdfi1a3fr+SB?=
 =?us-ascii?Q?l9q/56BUUAoxvWvMDQ4H//rVTdgkuocpuZgWi+OZqF+aUeVUf3iMAWfrsaUC?=
 =?us-ascii?Q?ZKyn2lGe21DirLv2Fh3k3P5HAYB33aWUAGbcorqC7pkjV2q9nNZiY5HJFh1/?=
 =?us-ascii?Q?9NUiF6xU7vtqQ8PkpCTC6ljqFAMng3Gg4xweKPK4PRv/E+/pm4JEQ9xTBVO7?=
 =?us-ascii?Q?npTDLisvXeGpq8EBjINknnfcAHYosNaN458fpd+KhiKK28mDmQ/g95TWFSvU?=
 =?us-ascii?Q?xzWnEzLiJ0cKPbctwnlJ1opAFr6MiXE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83785f16-37a4-4cd5-8dcf-08d9fc59320a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 14:30:26.9914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W6yREBt4vfNzuTVowLGxEJVeSdHkMaLnsAuONoskWkVYeQu21DM0EhH7w2fpzV83hEm4ydmSbXOoIkvK2R+CIZJuFWU/QkhIIVAVMSeOuTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6637
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
