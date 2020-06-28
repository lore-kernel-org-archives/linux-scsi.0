Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F18EC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 23:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C74920771
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 23:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kanZEeAa";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oXfnvxjI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgF1XB5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 19:01:57 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:1999 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgF1XB4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 19:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593385317; x=1624921317;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=eWfT3WOZaejtipb81F0rq6NWO4DhT+utaXJNSn89f4w=;
  b=kanZEeAaazDTtIOHntywELN3MiZw9rqwmblt3Rjgu2g9j+N5Mqf6rN+B
   nhHBFSZbI319MrEnppTGxOfoqflPfPLRqWw/b0gMx9ch6IVwt5S2I9bVR
   lKyxRfpvOPiGXno6mlyyGKBklSmQ7m2WIZmpWvIoTSNu5VSyLAfOoXrSm
   0AnP7JLGPKlnVALIrvc4fNPMCXwHBmLckh+RGJD81vfagMaoe9zIu/AFj
   e5BLdFmGGsWYrFawI7QRgtJG8EfhQzoBK5GX3/QMT7E6zjsF2EH21oHOY
   TTksJb52o5eY8qN3DdP0y6pJclCndtTqtVz0UQIamyh9EtRoFqtgH8Dv8
   w==;
IronPort-SDR: th0m4QlF6z6S+PlHXBFY8dUbiQbzq7ol0/aIyAi5/oqLQ4WvKss4FeGNKbx3ves2riVx6Adgyn
 zHfSbyOUyXlsSAtTrbGgvh2DVgjrllxwtC5ewsyywuTuC1AS6qI5R8UheT4vZZQ4ooH8iOWJNH
 POuRdzcdET5lQIaydLs5o19NAeM1mRvG72qFPPyJWBH4EnYrPZ7oj0gvmMhImaA6KqRsms/OT5
 iEREDQC6aFEFQwRbj5+hRfoN+GV4GZmHNUxrf8HouhBI7AhK3rTrJTnTpIuKQSo35NC+f3EleE
 uxk=
X-IronPort-AV: E=Sophos;i="5.75,293,1589212800"; 
   d="scan'208";a="145457400"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 07:01:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhgDoFbBVnKDq3GF93xOWVQgqdCEpKU0U9BeeNma8gZYiYgG+HTyPPG2AqQnNVHcFgT1Nq+4XzZd0DV08TX9RfXToYEiSphZMH4kWnKtGG/q0JQacZCZmXbUcOXit4HinchBflKt9Uy+vJsL2doRqaD8rBOXMSUGA9e+IInjH7yZGwHuJtKBU0KLhfgzDIZgvf7BNaKGEFaHW2kFhutAOkDxPO4PMG9DO7ZKxVP0pty/AxD5SR3dDJBOm00BPQAlfm8I+qTIjMQxbwXLAJTCUmYdpSInht/5H6M1Ok9mH3WedO9CxKrnTnmfGmDOepx+q4G5879kCwX1LbGr7uAOeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CkSDJ7KwwF+oN9ZzuGiHuZDgEQy5jsvqNWVlXQjn70=;
 b=KXMC1+4S3mnvFk0G1tXOISYjex+jjx5XJGY3Nb94RYwbI0RzE19KVJ7cihjXaEYZO0/foHkAlIwDR0IfrnvCBhWh13kickYlEpGyPTDnH0iLIocPn9NxS22oJ0r5yqNvJtGICkDrjMjDlwc3Kq1sUky/QBExNKtpJTpzlmjGtpfGeHOrJT+7lmg8b7sauBP7kCcuw27chshMtc6c2Gje/SumF9yIrZjqueX50v3Ia9yLLureKFVRO+FSP3KyF8JzwZN5dY71sXVGNg9AnO931QCxlJD/uLOK3FI9TwxnF6yzeCXD25khx5ftTgz1LVwK8U1Q8M1k9we2Qa/ZmXXBBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CkSDJ7KwwF+oN9ZzuGiHuZDgEQy5jsvqNWVlXQjn70=;
 b=oXfnvxjIFJDIrVTJ31WozYr1I9/7xvg8cteVaM/Jm58k17nnEcYhoXyWiYAevsGRrh9a89l16HkFJiYJ6GE9MctT/DdeZjo9pNXqa4uMTjwuwPGINoLR7owS9/AViPjWer9vqAFSTHPWhaSvxBLuHLb5mCsi6UY9xYQS62l+Akc=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
Received: from MN2PR04MB6223.namprd04.prod.outlook.com (2603:10b6:208:db::14)
 by MN2PR04MB5965.namprd04.prod.outlook.com (2603:10b6:208:d9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Sun, 28 Jun
 2020 23:01:52 +0000
Received: from MN2PR04MB6223.namprd04.prod.outlook.com
 ([fe80::899f:1d14:ad80:400e]) by MN2PR04MB6223.namprd04.prod.outlook.com
 ([fe80::899f:1d14:ad80:400e%4]) with mapi id 15.20.3131.026; Sun, 28 Jun 2020
 23:01:52 +0000
From:   =?UTF-8?q?Matias=20Bj=C3=B8rling?= <matias.bjorling@wdc.com>
To:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, damien.lemoal@wdc.com,
        niklas.cassel@wdc.com, hans.holmberg@wdc.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <matias.bjorling@wdc.com>
Subject: [PATCH 0/2] Zone Descriptor Extension for Zoned Block Devices
Date:   Sun, 28 Jun 2020 23:01:00 +0000
Message-Id: <20200628230102.26990-1-matias.bjorling@wdc.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM5PR0202CA0018.eurprd02.prod.outlook.com
 (2603:10a6:203:69::28) To MN2PR04MB6223.namprd04.prod.outlook.com
 (2603:10b6:208:db::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ninja.localdomain (87.116.37.42) by AM5PR0202CA0018.eurprd02.prod.outlook.com (2603:10a6:203:69::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sun, 28 Jun 2020 23:01:51 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [87.116.37.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9d270660-418f-4034-fc11-08d81bb73f17
X-MS-TrafficTypeDiagnostic: MN2PR04MB5965:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB5965214E5F4ECE0D61847E69F1910@MN2PR04MB5965.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0448A97BF2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kg5jVarZPSc4/o895pX1IxaDiFe0+1xJLv3HaNC0BuyC7x5V3Lo4rQ0r2MmOAvtcMfN6BSsuVMsY/fVnpjCyNPH04jPshoKmItAD8tQVgFzvly7IMvk3+idbrsk4w16aEUXTTESs8kV19rqxeB0AKvfQA7YxagJK1b1nY1rS9OMkE3/s7m1mhbpIqK//Si1kbHjpTorHO/aoYxZMq+LiBIwpQ2az6CP7cnSIzrO/L4gGdDsWdIljxdV9uBr//nhNWTju7wUUnSQuNEgzq/jOGjwuNefIwXdywi0UzNyqnQeL3TAvTInD5stzuadGQ2ghnpIdr78XMP8KmTPKVW472g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6223.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(39850400004)(376002)(6486002)(4326008)(2616005)(956004)(1076003)(86362001)(6636002)(66946007)(316002)(66556008)(66476007)(186003)(6512007)(26005)(6666004)(6506007)(8936002)(2906002)(83380400001)(36756003)(5660300002)(52116002)(16526019)(478600001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8x587tP970/H9DphPl93p7wVz3gLamVYr2svlL8/h9QuPCpcOFsQGd2W2QwdtCutKRPLvG4LGp1awNLYuK+F77mxSkz+j4D4SnGcTXXb52LgMfJrYxCVA28ibpWT7WmalGdPWJe3VXW2AuZgYE1wfXpDGWzwqkAotBt76xNuoOmV3dkg8AjupM9aXgybYmrjSs1q5uHMS5MIGhbReCce9lkFs8Lj11oH74hU9u7C4I70O587fAM7Caw+7uYdcNNFV3R6VeI5jAbNDfEf7YeBPkVAt1AgF43+V8cJLTjoPPiXPUwGrMi1RdNVzzjZ7qHI0RKoVVNs6CCAB8h/VKZyTmiQr8lymzgFt2TNL+5GHA6u5/E2EA2gpXhOcNa3iqa9kyU3AGoWM2p91Wv503Jcm27hYSa4GNI4uuh3zqtO5PaQfFvhioHTVlMsVXUSxNg0uCSVkb6jh81X+maKo6WrlpyztTcrQTnXQPQwTkZCKXQ=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d270660-418f-4034-fc11-08d81bb73f17
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6223.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2020 23:01:52.7425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r1CWSVQLbBSqIKAtdMqnkvTK4lLxKVhsagb88dmmVsgiDPhWPnb61XEpXy2mJZ64hh+7fIuUtmwETPODyazSSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5965
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

This patchset adds support for the Zone Descriptor Extension feature
that is defined in the NVMe Zoned Namespace Command Set.

The feature adds support for associating data to a zone that is in
the Empty state. Upon successful completion, the specified zone
transitions to the Closed state and further writes can be issued
to the zone. The data is lost when the zone at some point transitions
to the Empty state, the Read Only state, or the Offline state. For
example, the lifetime of the data is valid until a zone reset is
issued on the specific zone.

The first patch adds support for the zone_desc_ext_bytes queue sysfs
entry, and the second patch adds a ioctl to allow user-space to
associate data to a specific zone.

Support for the feature can be detected through the zone_desc_ext_bytes
queue sysfs. A value larger than zero indicates support, and zero value
indicates no support.

Best, Matias

Matias Bjørling (2):
  block: add zone_desc_ext_bytes to sysfs
  block: add BLKSETDESCZONE ioctl for Zoned Block Devices

 Documentation/block/queue-sysfs.rst |   6 ++
 block/blk-sysfs.c                   |  15 +++-
 block/blk-zoned.c                   | 108 ++++++++++++++++++++++++++++
 block/ioctl.c                       |   2 +
 drivers/nvme/host/core.c            |   3 +
 drivers/nvme/host/nvme.h            |   9 +++
 drivers/nvme/host/zns.c             |  12 ++++
 drivers/scsi/sd_zbc.c               |   1 +
 include/linux/blk_types.h           |   2 +
 include/linux/blkdev.h              |  31 +++++++-
 include/uapi/linux/blkzoned.h       |  20 +++++-
 11 files changed, 206 insertions(+), 3 deletions(-)

-- 
2.17.1

