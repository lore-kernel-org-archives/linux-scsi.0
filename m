Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CA9EB64DA
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Jul 2023 07:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbjGGH1q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Jul 2023 03:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjGGH1n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2023 03:27:43 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1F3AF;
        Fri,  7 Jul 2023 00:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688714862; x=1720250862;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=kIacr6PJZzzz0RD2Kb6INj0IrPcdVT71Q9mfwF6Ahc4=;
  b=JEjQSsbqp8Y2FpY0641tP9A1IwfOBCBp7WDqfQ/t0GdZErDRLcyVq+UT
   yikeZizMig9n2uR252Uh2UlmkYkTlDhYqCoPRQVz8wlCayC9CZ0EC/I5g
   oH7UAVAALRgpoyS9PyY3E0mcQAHWw0Hyrq6x9jvRDJjG/nc8yslpOe5hD
   WvYmAqNxAL2e31h8pK7OfDIKY9BOhSAPtM19Iq5/74gGxDOe5TPaUXMci
   1DOBiu5rp1UTvUxP5YfnlZnQp7VkNpMq2tjcb24Wm/8eH3vHDPPYyYbH/
   nwiiSS7Nsx/t84WDRWioSd/ngydv0BcRt9TNfpIBKGlkxkR38mXKTt/0m
   A==;
X-IronPort-AV: E=Sophos;i="6.01,187,1684771200"; 
   d="scan'208";a="342482792"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2023 15:27:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGt+s5vw7IIhQosA3SS8ki609sQyRIdy25kh4sF6sQcgGdnfjxZyGJS/l4KzT+Mm1oZd8bFgp7DEXSnC+W4Yh58kKAiUjMYG4RI9+v6uojRzSrZlY0y8GVkkBHwgy5npuGNHx3KlgkJfCRjoUFNkXoWcA4ThOaD+UxHgt2AolbEVNkUP/98y3cbMubZ65T7pwrUj2Fx0isu0K8W6s12yLAF8eC/9/V3XsvYnDMtESW8oW9VoDUgQoeV8rLs+FJyPnNSOKt4iltLC2hTKJpMROOpU0LjSM5LVZmjzcoskq4l5lclrCd1goUqFko9cn8p4MWEs+a9BnXm9Pa6iJoAUew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVtUa9shn2y4q9WmnRjY8i96OVmUZN0LjjKfTKZHeoA=;
 b=lq8kG9bIsDF4uwvL3Jb4jZ+Vqcg2g22R1qn/Ju+0aL4OoTStf9O2MgznU14VnoErzavzgg4jawg1I8xkanOUXPU+mMfq6RwEi6x/4k9OeOxe2zPND4N6Z+TyknQC0eh9BheijehEMIXc7GkbvxxMsc5PwaNSEGOTB+14pqz9rtvFCu0nf84xTcjpoRP8/WHAntoSpORgaYPuAO5XnL5z/KfGKmq+oUJaK81mouQJ+qU3My/8mVCYT5IQyU7JKy1CubDEzVbbaC+SWuR9LNinu9nDj+f/gu5BgGqBFDbkaTuu0xABjNH8RlCtIYuYuselLFAmiWKRGoHUTlTwiPW1Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVtUa9shn2y4q9WmnRjY8i96OVmUZN0LjjKfTKZHeoA=;
 b=MntLK7L4HtR8vNfxZc/pmKyipyWyb5m7T1J+LSbi81kq0iedtTBIOW8ju3bt+81yf1aPNUNntD3PHlI4YsUwz7oOJsBApubTJbRqfIzur9ZgLShm0dyQhAxsAQXLiC2uwHL9Crno8LTlmbHMaozbTsZUTfB3FzfM9hjTXgGdDdw=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CO6PR04MB7843.namprd04.prod.outlook.com (2603:10b6:5:35f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.24; Fri, 7 Jul 2023 07:27:38 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::bfa:d453:e7e9:8f98]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::bfa:d453:e7e9:8f98%7]) with mapi id 15.20.6565.025; Fri, 7 Jul 2023
 07:27:37 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.4
Thread-Topic: blktests failures with v6.4
Thread-Index: AQHZsKSBQcb4sCyybku6gR7M5LNTuw==
Date:   Fri, 7 Jul 2023 07:27:37 +0000
Message-ID: <lkmloyrqpebispffur5udxdiubmevvodtsvnap3jz7tv5ihstr@jg7ejye3bein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CO6PR04MB7843:EE_
x-ms-office365-filtering-correlation-id: ee6b69f8-59f2-4ce5-ea4f-08db7ebba402
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gw8nMROnRRYiBScV0n7dUoFvD/94TO+0CHpu+zgZHKAEtXdJnqDzWvDzj3pAILy1PZhly7j6Y9kJymIA13cokD2HyNyubqBcmnNIbVAhuloIMG2GOdqeLOP/MGdOSVBdAffLKaDzTNF4WCbS+JBVWoofTK4R5fh4yDYR0sARMuqusdbUzfd0P34gP2OsvHHpsgoKIYQAhKGiAFTutd8VVhT5X1a4adrMxq4NWNj8D3Ey5T/qKT/WyA9TtMGETxEeUi+2NcnRVI/ZTWp0jzgr44eyXWe3dzypylTD0jrW9HrknlxNRFnUNtMX/BtDLdGSCZ3pCTjPPzlycFlqPbtixEEk1kp2EEBWpp9x4nkn0ag3KnmPvVGFTlP/NiCnTlLMkugbpfmSd3sACtv0Px3s1JuJZ8hvgbePAOKnSbzj8XCJA15WhLzyd11/80HOI5nIiX/ffJP0KpkJJey2vJpDaoSRYzPGnf/cAXPUiLvfs2Ar6zWSJZOn0OVasc1YuhWKMjNCKJcW9RIrWoPvgv5PF/WQ2fc714Rjqt46iCJcsyiiHzWhiM7Wq/77jK1NsyC0pfgdYorhgMdKnyT46ecTqSy9w6M03fLgbWD4sg7T2BNNfHSZQYiIc2si8BMFFMXwU1wmR5EkOA4pC4kpO5UN0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199021)(478600001)(83380400001)(82960400001)(122000001)(38100700002)(86362001)(38070700005)(33716001)(110136005)(91956017)(6512007)(966005)(6486002)(71200400001)(8676002)(8936002)(5660300002)(44832011)(316002)(41300700001)(64756008)(2906002)(66446008)(76116006)(66946007)(66476007)(66556008)(186003)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?seifQ4QiHICmfoJjOSgTaRF5AIc4bB3JuBtRTCbTSdydy+0Y0+Kt5f9/dovk?=
 =?us-ascii?Q?YxXyizUtLmYVxtXqIWa4qAtlrk0cu1Elwi1/hK+odX5tUDhkfELYrA6pR7nY?=
 =?us-ascii?Q?lgvEttNjqMNIm/ajvK9zYVomP/Bfg5NU7EFJPoPeQPz9MulohHlN+9NkLWQN?=
 =?us-ascii?Q?1CNfanc4rYgToivvwPNmIIXF4YQW9ucOWyzOkI+/tI6B/UMSngKfkGR7jVWj?=
 =?us-ascii?Q?YFxjjZd2mJGxbl4B0XK70D1napvdrxMwSshsQ6nMnfl1dGnK+WZNxBUhosE8?=
 =?us-ascii?Q?2sEBffrl3vSJUzY9KNg5Fs8WwrAdH8XW4z+tUghkUen2aipm36KYxwX7tFqL?=
 =?us-ascii?Q?TVafPoODx85lucBxKRkgC/AQOyUQLs/inQ53M9t+l14ZYJmURsdXg5Y9q60s?=
 =?us-ascii?Q?tlypg2aYp1oQcLD6k85Cry/rfdeMDvpqjnKSBg4BrKgTvn2k9TDwNgDJxsbH?=
 =?us-ascii?Q?Cf5P6w84+/6tlxTw9Di/Wp6F7QPuWhVUQK/EjaU+1NwqV8pYTPkjJAhEpwc8?=
 =?us-ascii?Q?10EwXxd6zCfVgh71kRgsvcbQZIPlNomfvXtOqGk3HnZHr2jDIR06ZjcfO35C?=
 =?us-ascii?Q?p3dgkMgg44RtFpd01w8zM40C0MMhw4gj8xTPLRpHLkM6QUXJAL3A4l01Th20?=
 =?us-ascii?Q?4ICzOzTKiOCp0s8uA7aZxYJCgBYo5aHitzXUw7xCe7uvWMxUH6VPJ9q+L1CS?=
 =?us-ascii?Q?eVwtN4ZtCXEUwKhZDBLktBzaNuSj5MnfRMe+HZ5Tl28rhT20HrEzBK2YF2S2?=
 =?us-ascii?Q?dhRKQ2Mez94/z9WgOxP0Yc5ol1kyUmMcUCs1GIpwJ0wxKQTEvnZB/EcsQiKE?=
 =?us-ascii?Q?I2F/PeZv4NBPRTfhkWPkE9NN/KilxRf4TV+zYJaHIspLEpZLQrECzDv/ISnm?=
 =?us-ascii?Q?9LAGhsb3jtXtXjWQfxTa8aLPc2QzE/pa0CFcj2NrLkYzeIQVVSTvrBjV55uP?=
 =?us-ascii?Q?HewdNH/msKAEkFxs7O7dKc2tU4CnQnnxHn8Yfj1ejgCF854B/pJjl0SYWpuo?=
 =?us-ascii?Q?Dkxf+cpIvmJvm3u08L8u9RJ3d/9QYgjwxjSqsZnZS4nl0m5ytdBzURKxvb7t?=
 =?us-ascii?Q?+ebwi0v8Tkz+QbfiGXryVRaJ/zFJjX/3R9RruDITULaZmrxiwlcUrWjK9rpe?=
 =?us-ascii?Q?b8Q0b8YIMEqMI0SpuMS8iM/sclaIr03wE8xNycuwY21dnbW/RO3tPVFRlFgt?=
 =?us-ascii?Q?HfkxGkjRaPNtvEK8OFN78CWUdwzuw74fJYBFqkhJJ1LXeWOyaL01AzCrbNIh?=
 =?us-ascii?Q?zAfYOWrXkQCVhimUAqvnT51SDvn9pAkRO2LvN3FGGyBnLpBkpxpd0Jm1VKFm?=
 =?us-ascii?Q?VbY19EEI54eElm/1JjHpx1U1KTGKvbHQmwP0NUYOq38nzzaNU0BxFSRdGnKb?=
 =?us-ascii?Q?K61yDy2bHarXO2DzcPpqAXB2Vxt/coQCUDev3A5TgC7ZMuk7mekFuGLHFv/Z?=
 =?us-ascii?Q?4GSXLksP7i/3DGHX6/raflEylZaMwQZewWjnKZ/dASF/7clT2EMpr37YQKGK?=
 =?us-ascii?Q?AZ8P9tfDxuiEGuMsZm9BluNtnOjXSJR252xZ9T/HXmkT4nN+fA/AE/aTJi6R?=
 =?us-ascii?Q?hQXjnNc5x0uofAQqo8MklUNgs0BIUMlpxk17g3+iYhd49EbysmKUmt6P0cJf?=
 =?us-ascii?Q?jLm8sK9t6zXKXbXstfWD/xk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FCE44F56CEAD63449D59456898BFEB8F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 71vlcP5vsegm6M23mpk8uy30T3pm7DKQRJETf+Mo9IPZrZhyRM0LxecEFuFKxYBA1hVf/wZP1RV6btVADxHiXm1vGihN4hZuxhTIqtcTD4eo0v3Ezsbs0E+uK1YOevnr4YA9I8+ycsGR1F2/HZUSjIkTLKs4jfDbU7PwsbQ7eCMq8WbLUx8j/aAaCGo5lbGHuCPf1EP+Qun3uortBUhVsGJTLufuutKbEIwCgf2RjtlxGnYVwPFzNLENfYo8lzyiS0xT4c0hvUjA4i/quaW55RE52+gQL1BmoP+mxjXszJYnE2BLBKKCFuAz/YoOxFsJPfBNv61ppjEnYmXjdRGjEvc9F18QreFdw7RRCvl0SGvGLrkQSlwIUvGnJd0OSli2Rgi/SdRG9rndHl6dXWXJSFMrYfvoGw1QAgE0dpe0Ph5NYRQIcMqX40CJ7RfbUfOR2zHSB/9jk/yrhgP2GZYNq2DAzCnl+YBkP10vaZ3cohdKtwovGLfkFqCIwghnVG3Du9It7K7Iu75LJaF/++m8HrQYqXw4ArDcUYZO8C7XVEozWOfUsOT8KuQxI9VE+a2Wvs/8yUCqDUkYXGMT10RIrTIjTz4lO32vCvUGk2Wyn1w0SILRa9WQis5Ysm1uyxlbOcoJT/F7VRdDjvT4d9AU+sQYr7P75JYRKnNLCx47jjoyTlK7wTCn0b0L/547zATAZwl6Ffsi8ExR5JSOPl4jMaDBjX1YnznI88dSYCF8bULUOlfWc28FNMucg6AgKrd0NtgrVy83aDfaTW3A0PApPmjj1rU6KFkfsWWwrul5JGRxVZGfem2kySrJm1jBWrtV96T5QyW+XUxjXCkT0U3eaw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee6b69f8-59f2-4ce5-ea4f-08db7ebba402
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2023 07:27:37.8316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uSJ5DCZZdyeh29oB1ao1kThBEUVeDAgq385E3NV4kI46iNPq3Alq/Al5XBAltQDM21NI+aUhgP0Q/ZS7ih3+4lbssV1nWLQE8mjgkYKtBSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7843
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I ran the latest blktests (git hash: 30bdcb72ad99) with v6.4 kernel and obs=
erved
test case failures listed below. I call for support to fix them. The list o=
f
failures are same as the report for v6.3 kernel [1].

  [1] https://lore.kernel.org/linux-block/rsmmxrchy6voi5qhl4irss5sprna3f5ow=
kqtvybxglcv2pnylm@xmrnpfu3tfpe/

List of failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/011
#2: block/024
#3: nvme/003 (fabrics transport)
#4: nvme/030 or nvme/031 (rdma transport with siw)
#5: nvme/* (fc transport)

Failure description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#1: block/011

   This test case shows two failure symptoms.

   Symptom A:

     The test case fails with NVME devices due to lockdep WARNING "possible
     circular locking dependency detected". Reported in Sep/2022 [2] and
     solution was discussed. Waiting a fix.

     [2] https://lore.kernel.org/linux-block/20220930001943.zdbvolc3gkekfmc=
v@shindev/

   Symptom B:

     The test case occasionally fail with fio assert messages. Fio bug is
     suspected. I'm preparing a fix patch [3].

     block/011 =3D> nvme0n1 (disable PCI device while doing I/O)    [failed=
]
        runtime  32.250s  ...  1684.324s
        --- tests/block/011.out     2023-04-06 10:11:07.920670529 +0900
        +++ /home/shin/Blktests/blktests/results/nvme0n1/block/011.out.bad =
 2023-07-07 14:34:26.123295632 +0900
        @@ -1,2 +1,11 @@
         Running block/011
        +fio: ioengines.c:335: td_io_queue: Assertion `(io_u->flags & IO_U_=
F_FLIGHT) =3D=3D 0' failed.
        +fio: ioengines.c:335: td_io_queue: Assertion `(io_u->flags & IO_U_=
F_FLIGHT) =3D=3D 0' failed.
        +fio: ioengines.c:335: td_io_queue: Assertion `(io_u->flags & IO_U_=
F_FLIGHT) =3D=3D 0' failed.
        +fio: ioengines.c:335: td_io_queue: Assertion `(io_u->flags & IO_U_=
F_FLIGHT) =3D=3D 0' failed.
        +fio: pid=3D1492, got signal=3D6
        +fio: pid=3D1493, got signal=3D6
        ...
        (Run 'diff -u tests/block/011.out /home/shin/Blktests/blktests/resu=
lts/nvme0n1/block/011.out.bad' to see the entire diff)

     [3] https://github.com/kawasaki/fio/commit/f4b68b90c6780a73d4eb0174494=
00a7891443e3b

#2: block/024

   Fails on slow machines. Reported in Dec/2022. Test case side issue is
   suspected. Still needs further investigation.

   block/024 (do I/O faster than a jiffy and check iostats times) [failed]
    runtime    ...  4.347s
    --- tests/block/024.out     2022-12-06 20:51:41.525066605 +0900
    +++ /home/shin/kts/kernel-test-suite/sets/blktests/log/runlog/nodev/blo=
ck/024.out.bad       2022-12-07 12:51:03.610924521 +0900
    @@ -6,5 +6,5 @@
     read 1 s
     write 1 s
     read 2 s
    -write 3 s
    +write 4 s
     Test complete

#3: nvme/003 (fabrics transport)

   When nvme test group is run with trtype=3Drdma or tcp, the test case fai=
ls
   due to lockdep WARNING "possible circular locking dependency detected".
   Reported in May/2023. Bart suggested a fix for trytpe=3Drdma [4] but it
   needs more discussion.

   [4] https://lore.kernel.org/linux-nvme/20230511150321.103172-1-bvanassch=
e@acm.org/

#4: nvme/030 or nvme/031 (rdma transport with siw)

   When nvme test group is run with trtype=3Drdma and use_siw=3D1 configura=
tions,
   nvme/030 or nvme/031 fail occasionally due to "BUG: KASAN: slab-use-afte=
r-
   free in __mutex_lock". Reported to linux-rdma in May/2023. A fix was
   suggested but it did not fix the root cause in rdma iwarp cm [5]. Waitin=
g
   for a good fix.

   [5] https://lore.kernel.org/linux-rdma/20230612054237.1855292-1-shinichi=
ro.kawasaki@wdc.com/

#5: nvme/* (fc transport)

   With trtype=3Dfc configuration, test run on nvme test group hangs. Danie=
l is
   driving fix work [6].

   [6] https://lore.kernel.org/linux-nvme/20230620133711.22840-1-dwagner@su=
se.de/
