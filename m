Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617F2C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 00:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266236143B
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 00:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhEKAQs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 20:16:48 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:52354 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhEKAQr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 20:16:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620692141; x=1652228141;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=lsRBcCZb99blwbcaHk8vD6wtXm96ZnH1SfxDstR/BSc=;
  b=Ng1rMOrENdHe4bBxo2ybPAgrdKX0FdvDqj1EXoTteT6G8Zl96j/H00Qn
   Mw1leU+rzAjI4B9t3eN3cYJG1bqZvyPkbcwSd+I3vTzJsRTDnzqcT0vGe
   5ORbvzcGKisgq4C8Uixud+CNlF0SbVujimvvseG2n+MPNR4mowuoV4uh2
   Khddf3RPpaEgKOA45BI4p3pKihQG53MNC4+TidAm/vHQ2zgs0GkGvaAjB
   gXrMfNB6GinHoA/afFxEuQmQuzCCts3OdUEiL5MfSISk/uKbJVvj44FV4
   gBqhYPQPcke7N4OdjmjJisYlFe6HtAuZlNsuEZYKq2u5TEsaPB7iVa0dD
   Q==;
IronPort-SDR: hKACrQiB/ODSzwU0IkVnaOF5ZGwDwhIIG0YGg3kF8iA3k3SzfF3aa1n6g7Ab7j9YFXrZPe9387
 Dr+a/HpAMvsr/zT+b06NhfChdWzUdn26HWCKK1jNq4uLk4xxCw/e25pSpjl27Ofe6US5z2y+Ip
 9vo4Xpojv48E66YI+/Fih1TRqGbbo7y65Fw9uN4bmseV6+hzN5DSHJ+Fl71bOlQysosVoM1M+v
 7E+rKReNrcDQTEpfiaLpTpoqifl0Kg7Q7w2DBOkR45V/aktLeb5CS4BGQuTVerP4YGKn0hAVs6
 BNE=
X-IronPort-AV: E=Sophos;i="5.82,288,1613404800"; 
   d="scan'208";a="167685163"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 11 May 2021 08:15:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBkKEV/D1XqpWXXnQ47xRyBzlpVhZ/lumFvLhJKLyPyx9TpP300vxoauPXQHtsxaBcEArYXgtYBeX/Ic/8o6ENYEXcoRzcJ6O3g7kjUrnH6WzsOVzNxL2KZJ7vYMgTECcL1pTkdr8v4yfcRA2QdRSTcJ8xmX6OCFX+q0IlO163O6nj64gGCQd4vE3QfKKQbBn83UWcw4MpCuHezX6Xn7D9iHdvVPhVbhRf35dZr3icgAppNdSCZld2gm2pY4eluRSNomY+UJp3fosx79vpQv8/tAxFrF+I+p3PwvHTakeH/LiRvBCynTl+M3p1BY9p87c48b6DyobTQSdj2Dx9MSxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjM8ujsvXp7jHvSFmqPSg/Z1HfYFtO93xJbVMe8YOf0=;
 b=IeCHcU0XYG1wCNt6j6AMUvtRznLXDhLfZMt8tUggi/htYZ2mFml9GBXVuoV22swGG4347BH6ZFv+xqT1B/298HeDtfgplTg/DB0SQVrtWWLdrIysW+izq2I2dq0gd9MrUp1/F2Uw+a4EJFDugZDXC/393dfsegO05U2D+JnmWO4Cb+FY9kgoRGaU7DZVAsEgNwpe6ZhwLOawbuflgUZGn77nMJsgOvTf+1IMFtCglyvpXwMiBajgwNGgjQKnCsP/YGQhd/ZuhiWLt076oqzQX5MV2VDHOqeefozbF22z5t9kxxGfiO6LsnoBJnlGmRcreBW37bD3CI5kBSvMKaUKBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjM8ujsvXp7jHvSFmqPSg/Z1HfYFtO93xJbVMe8YOf0=;
 b=fAPbUzMG6pdjW0kecdzUfiJFjqTAyB8MywxMw9pxloAlAzRKiE0OborW3AU7Aj2hU5FNYb1V6ximuBB6Y/kCBT0bcHqoXjPwTjO5DpQuvK3fDOlXhuFugeDSjUDb5E4qhc6e/+Bv17W9QWCQ+KiB/4qiLvnx4p/ZPQQ2KLrSMYI=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB6088.namprd04.prod.outlook.com (2603:10b6:a03:eb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Tue, 11 May
 2021 00:15:37 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::6873:3d64:8f9f:faf0]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 00:15:37 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>
Subject: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXRfrE+mT6pvaiwEOWn89Dsv4XaA==
Date:   Tue, 11 May 2021 00:15:37 +0000
Message-ID: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d3141c5-56b0-4b6e-0e1e-08d91411e710
x-ms-traffictypediagnostic: BYAPR04MB6088:
x-microsoft-antispam-prvs: <BYAPR04MB6088839B9CE235B2E05EF16886539@BYAPR04MB6088.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dVR08EHLBMBVndjSSzCM9Fbf0NQJBDNh11xCLBpRGyYoWb8qefYJQcGgdwrh04/AULruZJgyvczISwoPuHN++xKyqkuYpDIl24us0i7HtWVh9OsZwIjBoHi4NiujkVuC7cAQuOljCYGeA40I9Af3YGVIK6OWmy8a/1vLwkQb3twazbSjXo5YAxfrwIeRPxZa94BtPX5GyPX5X8lNHuM4MDcZFxlTqqPzmb4U9LxAUn7xlXIR5RrwK60iaoqW/Dopn29XsWz2XHRH/hiQGU9T2dvw8ckT2MnbptKo12BvSSNjZutoAezFKRq7o/rMe4UK0CPu1ACIThHKVEuslvGFoEx4WaaZkP7JN3b5y8VIR/64Mtk6F0i1pKDZoiVLNJXN0+YRPL46yRSMTZz/jPqHrAfIUO0BErZBGiJhz8ineMWx5p7pU77pw99uiTq5nNhB8BmyYYv3/tHDH/lhDp0C7hxTKeG9+WJQ3Atfs+FUXUAzV/rgJsCGT5cdIrD2AqL9pz1wpTkgzxQQrc0MHBBIaI8jVuBYwgiVFylxWgAzsCHPfqr7Va06pf8BJiShyjD3aUpTzl9FV3pOIMBXPEcvojZG+kavU5gMS3SmhpVh5RwC8jpj1yZsIvbEC8JWpCJUdvrQFRnCCE22we/g8kMaPb950lT7D7ZoK4kkiWfmxF3sPML7RPHmdBdVjXeovkhja5oF8o63+iC1PBlo8F2qOYQ2rbro8uvp7yGNkG4rMl94EYSLY6VURTkgOeoocJpYdjuIZcLkg6Xr1ms5BBp+XA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(39850400004)(396003)(346002)(2906002)(64756008)(186003)(66446008)(83380400001)(66556008)(66946007)(52536014)(66476007)(316002)(966005)(110136005)(6506007)(54906003)(8936002)(7416002)(4326008)(71200400001)(86362001)(5660300002)(38100700002)(122000001)(55016002)(7696005)(9686003)(33656002)(76116006)(478600001)(26005)(8676002)(15398625002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IFSN04bQCjnysLzidHAS4sFGBWQqehrif1DABUkifaOaiwocMi1jsF7KyeFX?=
 =?us-ascii?Q?QjFw8c/EX4hG2oKUnnNdMpG0ogDVL6lrULLlWM84s/qI55yohcDB0VyKGQzV?=
 =?us-ascii?Q?giqXk0Lc8P8n85UNTm0Ypy6VsmsoJDhGCZ/02/7GmOOtGKV4gInSvRMA2wa/?=
 =?us-ascii?Q?fxnpFP8+w6rBBZQWd2SvzlMktcyOPdNYDvw6Z1QZvQlQ0SZFnSGrjTQxNDoN?=
 =?us-ascii?Q?EFsQzavdQILKamCxL65OphBWbHl0yjsiR/4WefZuP1evg/QloACPiHLlXOl6?=
 =?us-ascii?Q?kj05tWVbqYP49wbdqZQ+Jm0qEAq8Hs2NxqjIME2pA5/FOSxoSDKk3iW9jCl2?=
 =?us-ascii?Q?dls1LljJKppfm2tbz2C6WMaZ2lqzkNUiVSJbRitUmWDzk3D41PdWar5iPqm3?=
 =?us-ascii?Q?6ww5untp8yOf1zTAptV1uQ5K2LSHzx0gE1j4NRwvGcRgoUZMDRpuO/4ylwfa?=
 =?us-ascii?Q?xtjKdxRnUsbRdeHsjcYbzNQPIZQUpBrUAcvBkHrpHgIouHQRmahnJJ1duOvB?=
 =?us-ascii?Q?Ta+T0QPGo76pcfAu9nzU68ES6H80U5hkPgUsrFiz3z4hhCtcHHw2cSahZnvQ?=
 =?us-ascii?Q?ZrUhx9c2b2yuCYptDwKoH1sJrHoPQvUGw1Nm4f38RCgmNiAqtejJG4v7mS2Z?=
 =?us-ascii?Q?dZZGQ2VeBvwIfvr30C6K9gXystOYor23XeiaAkq7GCOhdlYtYxoEUk15yzx2?=
 =?us-ascii?Q?W+lkFvmDyc0k4kciqUvcueBHV1Ll+p45QS0CM6iiwcxJGiSXm2o2ng9oBBnJ?=
 =?us-ascii?Q?yQ4Z9P+2vK/VMW2zwf9XoXAtfsfssKGUuiwPFtyxnC9PLWuGEUiXs11MrKel?=
 =?us-ascii?Q?ZURk4/REPYhKBbZmYMNeMcCjwIafeth852711nEjSTdhBNCP+teSR36/zhBB?=
 =?us-ascii?Q?t2aNAPuRU95ZlplmGXEED4uSjnTJbhRfekbJRQFS1HP+qx55WLJKK5TpoDqO?=
 =?us-ascii?Q?/Yzg46jNWCwtxb//+SgwMFsys1fULSB7OBJGYWXnWpBRCe5d9XZx251jrFn5?=
 =?us-ascii?Q?/phBmdkNXHxRW1Lea4NA2bGi8+HWAFZ2FCh0VgStXKBQHc746WZRsRtoBld6?=
 =?us-ascii?Q?CIDJNSVCPqZRgsbzp555yWlaweVDKkeBrOLM05TyvR33rl2MSpk4yqghc4GS?=
 =?us-ascii?Q?FS4G5/RzZWk5KeW5hUd8Ph6+I61cLwVfBLxmfij6+XKl8FreJeFruhigc4kc?=
 =?us-ascii?Q?KGHtRtUydW9exMIsiVQBqNaQ9zmY2Yv+EiLYZOPdXmxwVlxrIlqlXkAkSpjC?=
 =?us-ascii?Q?ZaoK5Wv8MS3+dCavCUt1PayenEF4Z4ba0gHDhNMWDS3eIPvr3LWv5kQIdy7D?=
 =?us-ascii?Q?J5WKGriqQLP7S+XqzdKCkPUt?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3141c5-56b0-4b6e-0e1e-08d91411e710
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2021 00:15:37.1555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mSYtTpSKo4aEFK1FYZvnXxoXH4xilMS7ALiBTuBvFXlvcXxVrm7s0R279gvGbFC8oCZOefXk5don8hAha2WSBNome6k4qfJymuiXgFxu9Bo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB6088
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,=0A=
=0A=
* Background :-=0A=
-----------------------------------------------------------------------=0A=
=0A=
Copy offload is a feature that allows file-systems or storage devices=0A=
to be instructed to copy files/logical blocks without requiring=0A=
involvement of the local CPU.=0A=
=0A=
With reference to the RISC-V summit keynote [1] single threaded=0A=
performance is limiting due to Denard scaling and multi-threaded=0A=
performance is slowing down due Moore's law limitations. With the rise=0A=
of SNIA Computation Technical Storage Working Group (TWG) [2],=0A=
offloading computations to the device or over the fabrics is becoming=0A=
popular as there are several solutions available [2]. One of the common=0A=
operation which is popular in the kernel and is not merged yet is Copy=0A=
offload over the fabrics or on to the device.=0A=
=0A=
* Problem :-=0A=
-----------------------------------------------------------------------=0A=
=0A=
The original work which is done by Martin is present here [3]. The=0A=
latest work which is posted by Mikulas [4] is not merged yet. These two=0A=
approaches are totally different from each other. Several storage=0A=
vendors discourage mixing copy offload requests with regular READ/WRITE=0A=
I/O. Also, the fact that the operation fails if a copy request ever=0A=
needs to be split as it traverses the stack it has the unfortunate=0A=
side-effect of preventing copy offload from working in pretty much=0A=
every common deployment configuration out there.=0A=
=0A=
* Current state of the work :-=0A=
-----------------------------------------------------------------------=0A=
=0A=
With [3] being hard to handle arbitrary DM/MD stacking without=0A=
splitting the command in two, one for copying IN and one for copying=0A=
OUT. Which is then demonstrated by the [4] why [3] it is not a suitable=0A=
candidate. Also, with [4] there is an unresolved problem with the=0A=
two-command approach about how to handle changes to the DM layout=0A=
between an IN and OUT operations.=0A=
=0A=
* Why Linux Kernel Storage System needs Copy Offload support now ?=0A=
-----------------------------------------------------------------------=0A=
=0A=
With the rise of the SNIA Computational Storage TWG and solutions [2],=0A=
existing SCSI XCopy support in the protocol, recent advancement in the=0A=
Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer=0A=
DMA support in the Linux Kernel mainly for NVMe devices [7] and=0A=
eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit=0A=
from Copy offload operation.=0A=
=0A=
With this background we have significant number of use-cases which are=0A=
strong candidates waiting for outstanding Linux Kernel Block Layer Copy=0A=
Offload support, so that Linux Kernel Storage subsystem can to address=0A=
previously mentioned problems [1] and allow efficient offloading of the=0A=
data related operations. (Such as move/copy etc.)=0A=
=0A=
For reference following is the list of the use-cases/candidates waiting=0A=
for Copy Offload support :-=0A=
=0A=
1. SCSI-attached storage arrays.=0A=
2. Stacking drivers supporting XCopy DM/MD.=0A=
3. Computational Storage solutions.=0A=
7. File systems :- Local, NFS and Zonefs.=0A=
4. Block devices :- Distributed, local, and Zoned devices.=0A=
5. Peer to Peer DMA support solutions.=0A=
6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.=0A=
=0A=
* What we will discuss in the proposed session ?=0A=
-----------------------------------------------------------------------=0A=
=0A=
I'd like to propose a session to go over this topic to understand :-=0A=
=0A=
1. What are the blockers for Copy Offload implementation ?=0A=
2. Discussion about having a file system interface.=0A=
3. Discussion about having right system call for user-space.=0A=
4. What is the right way to move this work forward ?=0A=
5. How can we help to contribute and move this work forward ?=0A=
=0A=
* Required Participants :-=0A=
-----------------------------------------------------------------------=0A=
=0A=
I'd like to invite file system, block layer, and device drivers=0A=
developers to:-=0A=
=0A=
1. Share their opinion on the topic.=0A=
2. Share their experience and any other issues with [4].=0A=
3. Uncover additional details that are missing from this proposal.=0A=
=0A=
Required attendees :-=0A=
=0A=
Martin K. Petersen=0A=
Jens Axboe=0A=
Christoph Hellwig=0A=
Bart Van Assche=0A=
Zach Brown=0A=
Roland Dreier=0A=
Ric Wheeler=0A=
Trond Myklebust=0A=
Mike Snitzer=0A=
Keith Busch=0A=
Sagi Grimberg=0A=
Hannes Reinecke=0A=
Frederick Knight=0A=
Mikulas Patocka=0A=
Keith Busch=0A=
=0A=
Regards,=0A=
Chaitanya=0A=
=0A=
[1]https://content.riscv.org/wp-content/uploads/2018/12/A-New-Golden-Age-fo=
r-Computer-Architecture-History-Challenges-and-Opportunities-David-Patterso=
n-.pdf=0A=
[2] https://www.snia.org/computational=0A=
https://www.napatech.com/support/resources/solution-descriptions/napatech-s=
martnic-solution-for-hardware-offload/=0A=
      https://www.eideticom.com/products.html=0A=
https://www.xilinx.com/applications/data-center/computational-storage.html=
=0A=
[3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy=0A=
[4] https://www.spinics.net/lists/linux-block/msg00599.html=0A=
[5] https://lwn.net/Articles/793585/=0A=
[6] https://nvmexpress.org/new-nvmetm-specification-defines-zoned-=0A=
namespaces-zns-as-go-to-industry-technology/=0A=
[7] https://github.com/sbates130272/linux-p2pmem=0A=
[8] https://kernel.dk/io_uring.pdf=0A=
=0A=
