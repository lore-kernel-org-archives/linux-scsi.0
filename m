Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AFEC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 23:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B71342087C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 23:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OseyjA4o";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="H76GDn1w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgIHXRk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 19:17:40 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48848 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgIHXRi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 19:17:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599607055; x=1631143055;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=eCNONmCiKxsPIjVDAKS0pNJkQMZK3m/1t8wRN0k7woY=;
  b=OseyjA4o9rGJTkAdo2Kqhjo6V1Q+/RsshhgGpEJdjjN/Ohvs9VwUogAU
   EGAWs9mepz8xAMVJytGbs4y0EI5+9lrS2Of5Hrgi4QARtRxoj2BXOgJmh
   C3X+XBJ4cCI+uBvmv4ca0NzgUNUsJ8CWIsxk1bXOhcjp7dFFQAhBHIXy7
   +A0Clo1G68TMwXEAW5bb9Dsi06wFx7gMPDBmQhCjvkUZoisvNNfQeRm+y
   h54O7YpWODzFl1ViSnUC2oWaDDF5DYTf0njnkmi78Hkhgv2lXavADzkQq
   SJEkJh2T0Ib7alLUe4819ZiZj694GRkzSpfS6KD9uVQxtYJGMJyU4Xamd
   w==;
IronPort-SDR: ZkawbdeRPef77zRK5rXOoBzEII9B5jRQlFueMXxjcBCuIFczWjBxPmo0hZb/dU5bMcOLFUzwT/
 P2oz70HQzs9Lw/KcPBG95aKV0tCaUKMkghS1zoJG5Odn3PQy25y++s6m1brTWEqBS7b0sftjPa
 ClCV1Xoahty3wZWdFKNjcB0gV9eNQ7ElDoSBaV9qyQ9IPKCttCLG6w61LWn53pquZD4DvVcMoZ
 pWM7zu+cwfx5FitSpfxQzrDzaCx2F/bWhIQUoQPAjtqdV3jf3MwZED3rYU+wpskrG1OezP5Kup
 yqE=
X-IronPort-AV: E=Sophos;i="5.76,407,1592841600"; 
   d="scan'208";a="148095725"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 09 Sep 2020 07:17:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6BHQBBBu/M0YukWZ6b0/nHMqHFVtQxEin9iq1lwOxZPrmwvExeXrYIhbz/xSpVVut7Dt81agFH13lTpAB2QOWz81exQJmsYaJrnf6AY9pCaxqgPRvjHfqRyztJLeoqzQXs1LU4hJ3M7bF571HI9nDGNPrK8zGa8qKSw45MHNFrpwbgS68mcFdEu9C+ZwecV70ck5N01i9vvj2ynE24bn2xECN++4o8wsbV3cNGYzVJfJGZu9Xek220/AHVbXB8Qds7lvP8LNS1s89sNkdqLZ/eJcx0+KkYOUd27ChQ87nRmI9FgVgw1b9MlEK+En83TgD6AQIcU9cSjcu3q9uS4nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvPmtDtpQYOt3em7Uxy2oTbEvHve4afxxQ2hc7B+i8s=;
 b=D3XyjCSkz78VvnW3g3mXmIgbtbBiNa8ljWuoCF5L1JU2NaufBawqQ3eiuMqkCNmw6TA8IZTt3c8L4JhDzHCLKVSFaQUkANpPll3OlhoXeECxaqL1M6mVp588bhip/v+YVUPKTBNSOa2qpRDMu385K1dtBeHsMtBmcByVkzhO4owQ4dBy68Vhc03K6Npv/JYR38YjrXLdwvQRlhJqyS30Zcmk1qO6T6V4EXPuOYh9zVj49fYrGt3fB+O/fWLHAqR5BxNVp/nzLO9aanZkH7rqIPIR3Jovj9Lcliko8nls3lCqC84NdxkepHEx7FJX0Vc2c6A7O5VnQAxUidiS8GkZ7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvPmtDtpQYOt3em7Uxy2oTbEvHve4afxxQ2hc7B+i8s=;
 b=H76GDn1wVFZZ6JGW5MyFUEjhxXksx92TtB0nlM9WrrcW8g8kmkIp41t/MgY7s7/NHBRDeHLP8R7XTlF3s/g+N8ll8nnBtZMlSywQ4cm5G24TwhJvdk8efk9p3Jclfy03JVOYtoTFO4Qi5QdpBR+5Px79PeTPJ1tf0IBcfGAPGRg=
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
 DM6PR04MB5737.namprd04.prod.outlook.com (2603:10b6:5:16c::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.19; Tue, 8 Sep 2020 23:17:32 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
 ([fe80::19b2:3454:ba26:9963]) by DM6PR04MB4972.namprd04.prod.outlook.com
 ([fe80::19b2:3454:ba26:9963%7]) with mapi id 15.20.3370.016; Tue, 8 Sep 2020
 23:17:32 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Fwd: [RFC PATCH 00/39] blktrace: add block trace extension support
Thread-Topic: [RFC PATCH 00/39] blktrace: add block trace extension support
Thread-Index: AQHWeyyKCYpNC/SBZEqbAGFNbyFWNw==
Date:   Tue, 8 Sep 2020 23:17:32 +0000
Message-ID: <DM6PR04MB49729F21E30C5A25BAEECB1986290@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20200825221009.6457-1-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ccb6514a-f27a-4fac-297e-08d8544d5d1e
x-ms-traffictypediagnostic: DM6PR04MB5737:
x-microsoft-antispam-prvs: <DM6PR04MB573753EF4A9DA47916DF4CC386290@DM6PR04MB5737.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 96AVr1TKi6jrGdPzzut06u6GQMKGMNo0Pl5ivql9vzfT/sP+prF1zCem1uPxG6w8HiZsdlxjUB81S4dyzu74zwf4fK6Bk1j2iYFqA1jaofdQUo/Kl42lNuUXHwnr3sOu8OCFufl6nUiA17EF4CTSXFpF92ywByVNvsFhNNokRHd54z+0/+xm+cZwCLQzDCwwCkeLLVbFIEA1RQBwaFk97agY25iVXYtBJ730Rfpzk2JiIBEUwV5e9cojzqWyHOHcgTUwvaR95wuS8qagCTeZFCBsNr70LyjExylMaI44UyKkg8bZLs6xwniiRYdZIfyqKUQ5C8pNoA7RQTJ8KK1w4PLact9PdJ3OUCeUGABLrTZy2GVEEs+TcZzXwtaOtmgA25rhQ+610XBvWgZQgPaMig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4972.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(30864003)(55016002)(110136005)(83380400001)(2906002)(186003)(316002)(71200400001)(9686003)(6506007)(64756008)(66946007)(66556008)(66476007)(66446008)(26005)(52536014)(8676002)(76116006)(478600001)(91956017)(33656002)(86362001)(7696005)(8936002)(5660300002)(21314003)(569008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UKizAwRMlQKhSgbEPTHY3lSVDWikpp2xPnlL/K3M3Ah9tgKgcmHuxgd/pbwVFQr0iUXOGs3ZtArjL+ETXKCwEoOc/Le2Ki4Hdh6FpeJOcDvIWGOGWM7DG0eahZVn9lf/AuThrp5CldNYF/BnnCnaHNUIbUchCXo2BTJCYD/eSPbDiS2pPH2Yw5oZz99YhICZcoHgn99DPwQcxU8XFRvUozK0Hm0RKp7i6r5Wzlay4n2ILTtvX9Rj4EGnWF40Pl2xQFK/wVIpm562YnHHqPPISmpTm4Exepv7cGnIicP4RY8evmCgrbhk3FWtyZj3EKhUEeJL3SizbUNnk6qJEvY85kkpFyi/hIPNMXR06fiXkPfj1VmbBHjYSX3llqQ0AYaFOSISIdpMGZ1OPoKzFr0+JuVQqV0KU9RuktZ/gcszleyoBlMHYDUCoOc0a/HihGVfHzXqGZ7tQdx/FpMTu2Vw1GqSKbXsjUY2CvHUfuc76/kJ969yPhNd6VR7FqNbd3LdDkXwtsSTQmrW3IfmmS0DhHtdOl6khW3isS0ZUwzz1G9rT9Z+BDLKiZV9z2tD7mSHOzOrdMebK/Y/mCKlX+w6V502zYYlpcB9ph3rJA584GeXaQEg/thGYpaXYG+yl+jlx78jPOqhIeV68Zg669kOlQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb6514a-f27a-4fac-297e-08d8544d5d1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2020 23:17:32.2548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rjULl4oqDngLY05Zpdif1F+M/tuIHNBK8P63yO4paAwPbVZPcu13T06eDjFCoZ9Nbgugn2nJEOwxgRrvxR+mVKFGBZsvjak9ejP0lo3y8QA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5737
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I've posted block trace extension with all the new REQ_OP_XXX support,=0A=
it will be nice to get some feedback.=0A=
=0A=
-------- Forwarded Message --------=0A=
Subject: [RFC PATCH 00/39] blktrace: add block trace extension support=0A=
Date: Tue, 25 Aug 2020 15:10:28 -0700=0A=
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
To: linux-btrace@vger.kernel.org <linux-btrace@vger.kernel.org>=0A=
CC: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>=0A=
=0A=
Hi,=0A=
=0A=
This is an updated RFC which adds support for newly introduced=0A=
request operations REQ_OP_ZONE_APPEND along with rest of the =0A=
REQ_OP_ZONE_XXX. Please find the test log at the end of this patch.=0A=
=0A=
The new strings "ZA" -> Zone APPEND, I do have userspace code changes=0A=
for this if anyone is interested I'll post them.=0A=
=0A=
Original Cover letter stays the same :-=0A=
=0A=
This patch series adds support to track more request based flags and=0A=
different request fields to the blktrace infrastructure.=0A=
=0A=
In this series, we increase the action, action mask field and add =0A=
priority and priority mask field to existing infrastructure.=0A=
=0A=
We add new structures to hold the trace where we increase the size of=0A=
the action field and add a new member to track the priority of the I/O.=0A=
For the trace management side we add new IOCTLs so that user can =0A=
configure trace extensions from the blktrace user-space tools.=0A=
=0A=
The RFC is still light on the details but with new IOCTLs I was able to=0A=
get the code running with user-space tools. There is still some more=0A=
scope to optimize the code and reduce the duplicate code, but I kept=0A=
it simple for now so that it is easy to review. I'm aware of some=0A=
checkpatch.pl warnings mostly about 80 col, I'll fix that in the=0A=
next version.=0A=
=0A=
It will be great if someone can review this code and provide some=0A=
feedback.=0A=
=0A=
Regards,=0A=
Chaitanya=0A=
=0A=
Chaitanya Kulkarni (39):=0A=
   blktrace_api: add new trace definitions=0A=
   blktrace_api: add new trace definition=0A=
   blkdev.h: add new trace ext as a queue member=0A=
   blktrace: add a new global list=0A=
   blktrace: add trace note APIs=0A=
   blktrace: add act and prio check helpers=0A=
   blktrace: add core trace API=0A=
   blktrace: update blk_add_trace_rq()=0A=
   blktrace: update blk_add_trace_rq_insert()=0A=
   blktrace: update blk_add_trace_rq_issue()=0A=
   blktrace: update blk_add_trace_rq_requeue()=0A=
   blktrace: update blk_add_trace_rq_complete()=0A=
   blktrace: update blk_add_trace_bio()=0A=
   blktrace: update blk_add_trace_bio_bounce()=0A=
   blktrace: update blk_add_trace_bio_complete()=0A=
   blktrace: update blk_add_trace_bio_backmerge()=0A=
   blktrace: update blk_add_trace_bio_frontmerge()=0A=
   blktrace: update blk_add_trace_bio_queue()=0A=
   blktrace: update blk_add_trace_getrq()=0A=
   blktrace: update blk_add_trace_sleeprq()=0A=
   blktrace: update blk_add_trace_plug()=0A=
   blktrace: update blk_add_trace_unplug()=0A=
   blktrace: update blk_add_trace_split()=0A=
   blktrace: update blk_add_trace_bio_remap()=0A=
   blktrace: update blk_add_trace_rq_remap()=0A=
   blktrace: update blk_add_driver_data()=0A=
   blktrace: add trace entry & pdu helpers=0A=
   blktrace: add a new formatting routine=0A=
   blktrace: add blk_log_xxx helpers()=0A=
   blktrace: link blk_log_xxx() to trace action=0A=
   blktrace: add trace event print helper=0A=
   blktrace: add trace_synthesize helper=0A=
   blktrace: add trace print helpers=0A=
   blktrace: add blkext tracer=0A=
   blktrace: implement setup-start-stop ioclts=0A=
   block: update blkdev_ioctl with new trace ioctls=0A=
   blktrace: add integrity tracking support=0A=
   blktrace: update blk_fill_rwbs() with new requests=0A=
   blktrace: track zone appaend completion sector=0A=
=0A=
  block/ioctl.c                     |    4 +=0A=
  include/linux/blkdev.h            |    1 +=0A=
  include/linux/blktrace_api.h      |   18 +=0A=
  include/uapi/linux/blktrace_api.h |  113 ++-=0A=
  include/uapi/linux/fs.h           |    4 +=0A=
  kernel/trace/blktrace.c           | 1471 +++++++++++++++++++++++++++--=0A=
  kernel/trace/trace.h              |    1 +=0A=
  7 files changed, 1537 insertions(+), 75 deletions(-)=0A=
=0A=
Test log for Zone Append :-=0A=
=0A=
Zone Append execution with all the possible priority mask vales 1 .. 0xF.=
=0A=
=0A=
---------------------------------------------=0A=
Using Priority mask 0x1=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x1=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x1=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x1=0A=
---------------------------------------------=0A=
252,0    9        1     2.912317366 18682  Q ZAS N 262144 + 8 [dd]=0A=
252,0    9        2     2.912345379 18682  G ZAS N 262144 + 8 [dd]=0A=
252,0    9        3     2.912362210 18682  I ZAS N 262144 + 8 [dd]=0A=
252,0    9        4     2.912397887   809  D ZAS N 262144 + 8 [kworker/9:1H=
]=0A=
252,0    9        5     2.912440397    56  C ZAS N 262144 + 8 [0] <262144>=
=0A=
252,0    9        6     2.912481735 18682  Q ZAS N 262144 + 8 [dd]=0A=
252,0    9        7     2.912496803 18682  G ZAS N 262144 + 8 [dd]=0A=
252,0    9        8     2.912511591 18682  I ZAS N 262144 + 8 [dd]=0A=
252,0    9        9     2.912540094   809  D ZAS N 262144 + 8 [kworker/9:1H=
]=0A=
252,0    9       10     2.912620134    56  C ZAS N 262144 + 8 [0] <262152>=
=0A=
252,0    9       11     2.912661281 18682  Q ZAS N 262144 + 8 [dd]=0A=
252,0    9       12     2.912676400 18682  G ZAS N 262144 + 8 [dd]=0A=
252,0    9       13     2.912691197 18682  I ZAS N 262144 + 8 [dd]=0A=
252,0    9       14     2.912721624   809  D ZAS N 262144 + 8 [kworker/9:1H=
]=0A=
252,0    9       15     2.912754767    56  C ZAS N 262144 + 8 [0] <262160>=
=0A=
252,0    9       16     2.912804029 18682  Q ZAS N 262144 + 8 [dd]=0A=
252,0    9       17     2.912818686 18682  G ZAS N 262144 + 8 [dd]=0A=
252,0    9       18     2.912833735 18682  I ZAS N 262144 + 8 [dd]=0A=
252,0    9       19     2.912864593   809  D ZAS N 262144 + 8 [kworker/9:1H=
]=0A=
252,0    9       20     2.912896963    56  C ZAS N 262144 + 8 [0] <262168>=
=0A=
252,0    9       21     2.912987814 18682  Q ZAS N 262144 + 8 [dd]=0A=
252,0    9       22     2.913004976 18682  G ZAS N 262144 + 8 [dd]=0A=
252,0    9       23     2.913025114 18682  I ZAS N 262144 + 8 [dd]=0A=
252,0    9       24     2.913056643   809  D ZAS N 262144 + 8 [kworker/9:1H=
]=0A=
252,0    9       25     2.913089394    56  C ZAS N 262144 + 8 [0] <262176>=
=0A=
CPU5 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU9 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 0KiB/s / 0KiB/s=0A=
Events (252,0): 25 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0x2=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x2=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x2=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x2=0A=
---------------------------------------------=0A=
252,0    8        1     2.927271199 18782  Q ZAS R 262144 + 8 [dd]=0A=
252,0    8        2     2.927279605 18782  G ZAS R 262144 + 8 [dd]=0A=
252,0    8        3     2.927287901 18782  I ZAS R 262144 + 8 [dd]=0A=
252,0    8        4     2.927305293  1429  D ZAS R 262144 + 8 [kworker/8:1H=
]=0A=
252,0    8        5     2.927326583    51  C ZAS R 262144 + 8 [0] <262144>=
=0A=
252,0    8        6     2.927346360 18782  Q ZAS R 262144 + 8 [dd]=0A=
252,0    8        7     2.927353384 18782  G ZAS R 262144 + 8 [dd]=0A=
252,0    8        8     2.927360317 18782  I ZAS R 262144 + 8 [dd]=0A=
252,0    8        9     2.927375385  1429  D ZAS R 262144 + 8 [kworker/8:1H=
]=0A=
252,0    8       10     2.927391074    51  C ZAS R 262144 + 8 [0] <262152>=
=0A=
252,0    8       11     2.927409379 18782  Q ZAS R 262144 + 8 [dd]=0A=
252,0    8       12     2.927416231 18782  G ZAS R 262144 + 8 [dd]=0A=
252,0    8       13     2.927423044 18782  I ZAS R 262144 + 8 [dd]=0A=
252,0    8       14     2.927436319  1429  D ZAS R 262144 + 8 [kworker/8:1H=
]=0A=
252,0    8       15     2.927451908    51  C ZAS R 262144 + 8 [0] <262160>=
=0A=
252,0    8       16     2.927470022 18782  Q ZAS R 262144 + 8 [dd]=0A=
252,0    8       17     2.927476985 18782  G ZAS R 262144 + 8 [dd]=0A=
252,0    8       18     2.927483888 18782  I ZAS R 262144 + 8 [dd]=0A=
252,0    8       19     2.927497283  1429  D ZAS R 262144 + 8 [kworker/8:1H=
]=0A=
252,0    8       20     2.927513273    51  C ZAS R 262144 + 8 [0] <262168>=
=0A=
252,0    8       21     2.927531277 18782  Q ZAS R 262144 + 8 [dd]=0A=
252,0    8       22     2.927538100 18782  G ZAS R 262144 + 8 [dd]=0A=
252,0    8       23     2.927544803 18782  I ZAS R 262144 + 8 [dd]=0A=
252,0    8       24     2.927557757  1429  D ZAS R 262144 + 8 [kworker/8:1H=
]=0A=
252,0    8       25     2.927572995    51  C ZAS R 262144 + 8 [0] <262176>=
=0A=
CPU8 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU15 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 0KiB/s / 0KiB/s=0A=
Events (252,0): 25 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0x3=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x3=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x3=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x3=0A=
---------------------------------------------=0A=
252,0   18        1     2.917773077 18871  Q ZAS N 262144 + 8 [dd]=0A=
252,0   18        2     2.917780340 18871  G ZAS N 262144 + 8 [dd]=0A=
252,0   18        3     2.917787774 18871  I ZAS N 262144 + 8 [dd]=0A=
252,0   18        4     2.917803935   795  D ZAS N 262144 + 8 =0A=
[kworker/18:1H]=0A=
252,0   18        5     2.917824964   101  C ZAS N 262144 + 8 [0] <262144>=
=0A=
252,0   18        6     2.917843759 18871  Q ZAS N 262144 + 8 [dd]=0A=
252,0   18        7     2.917850272 18871  G ZAS N 262144 + 8 [dd]=0A=
252,0   18        8     2.917856664 18871  I ZAS N 262144 + 8 [dd]=0A=
252,0   18        9     2.917870960   795  D ZAS N 262144 + 8 =0A=
[kworker/18:1H]=0A=
252,0   18       10     2.917885648   101  C ZAS N 262144 + 8 [0] <262152>=
=0A=
252,0   18       11     2.917902630 18871  Q ZAS N 262144 + 8 [dd]=0A=
252,0   18       12     2.917909142 18871  G ZAS N 262144 + 8 [dd]=0A=
252,0   18       13     2.917915414 18871  I ZAS N 262144 + 8 [dd]=0A=
252,0   18       14     2.917927697   795  D ZAS N 262144 + 8 =0A=
[kworker/18:1H]=0A=
252,0   18       15     2.917942194   101  C ZAS N 262144 + 8 [0] <262160>=
=0A=
252,0   18       16     2.917958775 18871  Q ZAS N 262144 + 8 [dd]=0A=
252,0   18       17     2.917965077 18871  G ZAS N 262144 + 8 [dd]=0A=
252,0   18       18     2.917971329 18871  I ZAS N 262144 + 8 [dd]=0A=
252,0   18       19     2.917983431   795  D ZAS N 262144 + 8 =0A=
[kworker/18:1H]=0A=
252,0   18       20     2.917997678   101  C ZAS N 262144 + 8 [0] <262168>=
=0A=
252,0   18       21     2.918014139 18871  Q ZAS N 262144 + 8 [dd]=0A=
252,0   18       22     2.918020741 18871  G ZAS N 262144 + 8 [dd]=0A=
252,0   18       23     2.918026973 18871  I ZAS N 262144 + 8 [dd]=0A=
252,0   18       24     2.918039096   795  D ZAS N 262144 + 8 =0A=
[kworker/18:1H]=0A=
252,0   18       25     2.918053142   101  C ZAS N 262144 + 8 [0] <262176>=
=0A=
252,0   28        1     2.925446367 18874  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28        2     2.925456927 18874  G ZAS R 262144 + 8 [dd]=0A=
252,0   28        3     2.925464651 18874  I ZAS R 262144 + 8 [dd]=0A=
252,0   28        4     2.925484719  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28        5     2.925507261   151  C ZAS R 262144 + 8 [0] <262144>=
=0A=
252,0   28        6     2.925532078 18874  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28        7     2.925539552 18874  G ZAS R 262144 + 8 [dd]=0A=
252,0   28        8     2.925549510 18874  I ZAS R 262144 + 8 [dd]=0A=
252,0   28        9     2.925563977  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       10     2.925582532   151  C ZAS R 262144 + 8 [0] <262152>=
=0A=
252,0   28       11     2.925602510 18874  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28       12     2.925612428 18874  G ZAS R 262144 + 8 [dd]=0A=
252,0   28       13     2.925619702 18874  I ZAS R 262144 + 8 [dd]=0A=
252,0   28       14     2.925634991  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       15     2.925651481   151  C ZAS R 262144 + 8 [0] <262160>=
=0A=
252,0   28       16     2.925672912 18874  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28       17     2.925680586 18874  G ZAS R 262144 + 8 [dd]=0A=
252,0   28       18     2.925688862 18874  I ZAS R 262144 + 8 [dd]=0A=
252,0   28       19     2.925704731  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       20     2.925722685   151  C ZAS R 262144 + 8 [0] <262168>=
=0A=
252,0   28       21     2.925742833 18874  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28       22     2.925750477 18874  G ZAS R 262144 + 8 [dd]=0A=
252,0   28       23     2.925757110 18874  I ZAS R 262144 + 8 [dd]=0A=
252,0   28       24     2.925771346  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       25     2.925789871   151  C ZAS R 262144 + 8 [0] <262176>=
=0A=
CPU15 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU18 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU28 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:          10,       40KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:       10,       40KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:       10,       40KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 5,000KiB/s / 0KiB/s=0A=
Events (252,0): 50 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0x4=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x4=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x4=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x4=0A=
---------------------------------------------=0A=
252,0   18        1     2.931782309 18957  Q ZAS B 262144 + 8 [dd]=0A=
252,0   18        2     2.931790113 18957  G ZAS B 262144 + 8 [dd]=0A=
252,0   18        3     2.931797988 18957  I ZAS B 262144 + 8 [dd]=0A=
252,0   18        4     2.931814619   795  D ZAS B 262144 + 8 =0A=
[kworker/18:1H]=0A=
252,0   18        5     2.931835549   101  C ZAS B 262144 + 8 [0] <262144>=
=0A=
252,0   18        6     2.931854975 18957  Q ZAS B 262144 + 8 [dd]=0A=
252,0   18        7     2.931861968 18957  G ZAS B 262144 + 8 [dd]=0A=
252,0   18        8     2.931868801 18957  I ZAS B 262144 + 8 [dd]=0A=
252,0   18        9     2.931882266   795  D ZAS B 262144 + 8 =0A=
[kworker/18:1H]=0A=
252,0   18       10     2.931897956   101  C ZAS B 262144 + 8 [0] <262152>=
=0A=
252,0   18       11     2.931916070 18957  Q ZAS B 262144 + 8 [dd]=0A=
252,0   18       12     2.931922872 18957  G ZAS B 262144 + 8 [dd]=0A=
252,0   18       13     2.931929615 18957  I ZAS B 262144 + 8 [dd]=0A=
252,0   18       14     2.931942780   795  D ZAS B 262144 + 8 =0A=
[kworker/18:1H]=0A=
252,0   18       15     2.931958319   101  C ZAS B 262144 + 8 [0] <262160>=
=0A=
252,0   18       16     2.931975992 18957  Q ZAS B 262144 + 8 [dd]=0A=
252,0   18       17     2.931983676 18957  G ZAS B 262144 + 8 [dd]=0A=
252,0   18       18     2.931990469 18957  I ZAS B 262144 + 8 [dd]=0A=
252,0   18       19     2.932003383   795  D ZAS B 262144 + 8 =0A=
[kworker/18:1H]=0A=
252,0   18       20     2.932018882   101  C ZAS B 262144 + 8 [0] <262168>=
=0A=
252,0   18       21     2.932036566 18957  Q ZAS B 262144 + 8 [dd]=0A=
252,0   18       22     2.932043308 18957  G ZAS B 262144 + 8 [dd]=0A=
252,0   18       23     2.932049931 18957  I ZAS B 262144 + 8 [dd]=0A=
252,0   18       24     2.932062725   795  D ZAS B 262144 + 8 =0A=
[kworker/18:1H]=0A=
252,0   18       25     2.932077973   101  C ZAS B 262144 + 8 [0] <262176>=
=0A=
CPU15 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU18 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 0KiB/s / 0KiB/s=0A=
Events (252,0): 25 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0x5=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x5=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x5=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x5=0A=
---------------------------------------------=0A=
252,0   20        1     2.917568763 19033  Q ZAS N 262144 + 8 [dd]=0A=
252,0   20        2     2.917584162 19033  G ZAS N 262144 + 8 [dd]=0A=
252,0   20        3     2.917598820 19033  I ZAS N 262144 + 8 [dd]=0A=
252,0   20        4     2.917631150   793  D ZAS N 262144 + 8 =0A=
[kworker/20:1H]=0A=
252,0   20        5     2.917668891   111  C ZAS N 262144 + 8 [0] <262144>=
=0A=
252,0   20        6     2.917710920 19033  Q ZAS N 262144 + 8 [dd]=0A=
252,0   20        7     2.917726189 19033  G ZAS N 262144 + 8 [dd]=0A=
252,0   20        8     2.917740926 19033  I ZAS N 262144 + 8 [dd]=0A=
252,0   20        9     2.917766725   793  D ZAS N 262144 + 8 =0A=
[kworker/20:1H]=0A=
252,0   20       10     2.917796200   111  C ZAS N 262144 + 8 [0] <262152>=
=0A=
252,0   20       11     2.917830665 19033  Q ZAS N 262144 + 8 [dd]=0A=
252,0   20       12     2.917843559 19033  G ZAS N 262144 + 8 [dd]=0A=
252,0   20       13     2.917856463 19033  I ZAS N 262144 + 8 [dd]=0A=
252,0   20       14     2.917882091   793  D ZAS N 262144 + 8 =0A=
[kworker/20:1H]=0A=
252,0   20       15     2.917910935   111  C ZAS N 262144 + 8 [0] <262160>=
=0A=
252,0   20       16     2.917944698 19033  Q ZAS N 262144 + 8 [dd]=0A=
252,0   20       17     2.917957522 19033  G ZAS N 262144 + 8 [dd]=0A=
252,0   20       18     2.917970387 19033  I ZAS N 262144 + 8 [dd]=0A=
252,0   20       19     2.917995053   793  D ZAS N 262144 + 8 =0A=
[kworker/20:1H]=0A=
252,0   20       20     2.918023747   111  C ZAS N 262144 + 8 [0] <262168>=
=0A=
252,0   20       21     2.918057199 19033  Q ZAS N 262144 + 8 [dd]=0A=
252,0   20       22     2.918069823 19033  G ZAS N 262144 + 8 [dd]=0A=
252,0   20       23     2.918082617 19033  I ZAS N 262144 + 8 [dd]=0A=
252,0   20       24     2.918107023   793  D ZAS N 262144 + 8 =0A=
[kworker/20:1H]=0A=
252,0   20       25     2.918135126   111  C ZAS N 262144 + 8 [0] <262176>=
=0A=
252,0   16        1     2.933916441 19038  Q ZAS B 262144 + 8 [dd]=0A=
252,0   16        2     2.933924616 19038  G ZAS B 262144 + 8 [dd]=0A=
252,0   16        3     2.933932791 19038  I ZAS B 262144 + 8 [dd]=0A=
252,0   16        4     2.933949383   802  D ZAS B 262144 + 8 =0A=
[kworker/16:1H]=0A=
252,0   16        5     2.933971564    91  C ZAS B 262144 + 8 [0] <262144>=
=0A=
252,0   16        6     2.933992634 19038  Q ZAS B 262144 + 8 [dd]=0A=
252,0   16        7     2.933999777 19038  G ZAS B 262144 + 8 [dd]=0A=
252,0   16        8     2.934006750 19038  I ZAS B 262144 + 8 [dd]=0A=
252,0   16        9     2.934020546   802  D ZAS B 262144 + 8 =0A=
[kworker/16:1H]=0A=
252,0   16       10     2.934036406    91  C ZAS B 262144 + 8 [0] <262152>=
=0A=
252,0   16       11     2.934055351 19038  Q ZAS B 262144 + 8 [dd]=0A=
252,0   16       12     2.934062244 19038  G ZAS B 262144 + 8 [dd]=0A=
252,0   16       13     2.934069217 19038  I ZAS B 262144 + 8 [dd]=0A=
252,0   16       14     2.934082612   802  D ZAS B 262144 + 8 =0A=
[kworker/16:1H]=0A=
252,0   16       15     2.934098382    91  C ZAS B 262144 + 8 [0] <262160>=
=0A=
252,0   16       16     2.934116416 19038  Q ZAS B 262144 + 8 [dd]=0A=
252,0   16       17     2.934123309 19038  G ZAS B 262144 + 8 [dd]=0A=
252,0   16       18     2.934130152 19038  I ZAS B 262144 + 8 [dd]=0A=
252,0   16       19     2.934143446   802  D ZAS B 262144 + 8 =0A=
[kworker/16:1H]=0A=
252,0   16       20     2.934158795    91  C ZAS B 262144 + 8 [0] <262168>=
=0A=
252,0   16       21     2.934176609 19038  Q ZAS B 262144 + 8 [dd]=0A=
252,0   16       22     2.934183411 19038  G ZAS B 262144 + 8 [dd]=0A=
252,0   16       23     2.934190164 19038  I ZAS B 262144 + 8 [dd]=0A=
252,0   16       24     2.934203529   802  D ZAS B 262144 + 8 =0A=
[kworker/16:1H]=0A=
252,0   16       25     2.934218718    91  C ZAS B 262144 + 8 [0] <262176>=
=0A=
CPU13 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU16 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU20 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:          10,       40KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:       10,       40KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:       10,       40KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 2,500KiB/s / 0KiB/s=0A=
Events (252,0): 50 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0x6=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x6=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x6=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x6=0A=
---------------------------------------------=0A=
252,0   25        1     2.932779650 19140  Q ZAS B 262144 + 8 [dd]=0A=
252,0   25        2     2.932787374 19140  G ZAS B 262144 + 8 [dd]=0A=
252,0   25        3     2.932795189 19140  I ZAS B 262144 + 8 [dd]=0A=
252,0   25        4     2.932812281  1115  D ZAS B 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25        5     2.932834503   136  C ZAS B 262144 + 8 [0] <262144>=
=0A=
252,0   25        6     2.932884005 19140  Q ZAS B 262144 + 8 [dd]=0A=
252,0   25        7     2.932891439 19140  G ZAS B 262144 + 8 [dd]=0A=
252,0   25        8     2.932898242 19140  I ZAS B 262144 + 8 [dd]=0A=
252,0   25        9     2.932913491  1115  D ZAS B 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25       10     2.932929160   136  C ZAS B 262144 + 8 [0] <262152>=
=0A=
252,0   25       11     2.932952975 19140  Q ZAS B 262144 + 8 [dd]=0A=
252,0   25       12     2.932960288 19140  G ZAS B 262144 + 8 [dd]=0A=
252,0   25       13     2.932970087 19140  I ZAS B 262144 + 8 [dd]=0A=
252,0   25       14     2.932984414  1115  D ZAS B 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25       15     2.932999903   136  C ZAS B 262144 + 8 [0] <262160>=
=0A=
252,0   25       16     2.933017466 19140  Q ZAS B 262144 + 8 [dd]=0A=
252,0   25       17     2.933024028 19140  G ZAS B 262144 + 8 [dd]=0A=
252,0   25       18     2.933030560 19140  I ZAS B 262144 + 8 [dd]=0A=
252,0   25       19     2.933046009  1115  D ZAS B 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25       20     2.933067530   136  C ZAS B 262144 + 8 [0] <262168>=
=0A=
252,0   25       21     2.933086615 19140  Q ZAS B 262144 + 8 [dd]=0A=
252,0   25       22     2.933093158 19140  G ZAS B 262144 + 8 [dd]=0A=
252,0   25       23     2.933100111 19140  I ZAS B 262144 + 8 [dd]=0A=
252,0   25       24     2.933116311  1115  D ZAS B 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25       25     2.933133553   136  C ZAS B 262144 + 8 [0] <262176>=
=0A=
252,0   12        1     2.925302778 19138  Q ZAS R 262144 + 8 [dd]=0A=
252,0   12        2     2.925311775 19138  G ZAS R 262144 + 8 [dd]=0A=
252,0   12        3     2.925322295 19138  I ZAS R 262144 + 8 [dd]=0A=
252,0   12        4     2.925341952   792  D ZAS R 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12        5     2.925369133    71  C ZAS R 262144 + 8 [0] <262144>=
=0A=
252,0   12        6     2.925396013 19138  Q ZAS R 262144 + 8 [dd]=0A=
252,0   12        7     2.925403828 19138  G ZAS R 262144 + 8 [dd]=0A=
252,0   12        8     2.925411552 19138  I ZAS R 262144 + 8 [dd]=0A=
252,0   12        9     2.925428564   792  D ZAS R 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       10     2.925446247    71  C ZAS R 262144 + 8 [0] <262152>=
=0A=
252,0   12       11     2.925466655 19138  Q ZAS R 262144 + 8 [dd]=0A=
252,0   12       12     2.925475502 19138  G ZAS R 262144 + 8 [dd]=0A=
252,0   12       13     2.925483146 19138  I ZAS R 262144 + 8 [dd]=0A=
252,0   12       14     2.925499387   792  D ZAS R 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       15     2.925517150    71  C ZAS R 262144 + 8 [0] <262160>=
=0A=
252,0   12       16     2.925538420 19138  Q ZAS R 262144 + 8 [dd]=0A=
252,0   12       17     2.925546635 19138  G ZAS R 262144 + 8 [dd]=0A=
252,0   12       18     2.925554240 19138  I ZAS R 262144 + 8 [dd]=0A=
252,0   12       19     2.925569779   792  D ZAS R 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       20     2.925590608    71  C ZAS R 262144 + 8 [0] <262168>=
=0A=
252,0   12       21     2.925611437 19138  Q ZAS R 262144 + 8 [dd]=0A=
252,0   12       22     2.925619081 19138  G ZAS R 262144 + 8 [dd]=0A=
252,0   12       23     2.925626666 19138  I ZAS R 262144 + 8 [dd]=0A=
252,0   12       24     2.925641573   792  D ZAS R 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       25     2.925658635    71  C ZAS R 262144 + 8 [0] <262176>=
=0A=
CPU12 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU15 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU25 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:          10,       40KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:       10,       40KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:       10,       40KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 0KiB/s / 0KiB/s=0A=
Events (252,0): 50 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0x7=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x7=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x7=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x7=0A=
---------------------------------------------=0A=
252,0   11        1     2.934623607 19247  Q ZAS B 262144 + 8 [dd]=0A=
252,0   11        2     2.934631903 19247  G ZAS B 262144 + 8 [dd]=0A=
252,0   11        3     2.934639948 19247  I ZAS B 262144 + 8 [dd]=0A=
252,0   11        4     2.934658923   800  D ZAS B 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11        5     2.934816920    66  C ZAS B 262144 + 8 [0] <262144>=
=0A=
252,0   11        6     2.934926495 19247  Q ZAS B 262144 + 8 [dd]=0A=
252,0   11        7     2.934957193 19247  G ZAS B 262144 + 8 [dd]=0A=
252,0   11        8     2.934989363 19247  I ZAS B 262144 + 8 [dd]=0A=
252,0   11        9     2.935049606   800  D ZAS B 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       10     2.935097947    66  C ZAS B 262144 + 8 [0] <262152>=
=0A=
252,0   11       11     2.935152208 19247  Q ZAS B 262144 + 8 [dd]=0A=
252,0   11       12     2.935173629 19247  G ZAS B 262144 + 8 [dd]=0A=
252,0   11       13     2.935199667 19247  I ZAS B 262144 + 8 [dd]=0A=
252,0   11       14     2.935248950   800  D ZAS B 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       15     2.935309053    66  C ZAS B 262144 + 8 [0] <262160>=
=0A=
252,0   11       16     2.935380857 19247  Q ZAS B 262144 + 8 [dd]=0A=
252,0   11       17     2.935404361 19247  G ZAS B 262144 + 8 [dd]=0A=
252,0   11       18     2.935423357 19247  I ZAS B 262144 + 8 [dd]=0A=
252,0   11       19     2.935463522   800  D ZAS B 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       20     2.935503938    66  C ZAS B 262144 + 8 [0] <262168>=
=0A=
252,0   11       21     2.935579279 19247  Q ZAS B 262144 + 8 [dd]=0A=
252,0   11       22     2.935600659 19247  G ZAS B 262144 + 8 [dd]=0A=
252,0   11       23     2.935623302 19247  I ZAS B 262144 + 8 [dd]=0A=
252,0   11       24     2.935652236   800  D ZAS B 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       25     2.935684126    66  C ZAS B 262144 + 8 [0] <262176>=
=0A=
252,0   28        1     2.926285591 19244  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28        2     2.926293626 19244  G ZAS R 262144 + 8 [dd]=0A=
252,0   28        3     2.926301921 19244  I ZAS R 262144 + 8 [dd]=0A=
252,0   28        4     2.926319935  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28        5     2.926342628   151  C ZAS R 262144 + 8 [0] <262144>=
=0A=
252,0   28        6     2.926362645 19244  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28        7     2.926369538 19244  G ZAS R 262144 + 8 [dd]=0A=
252,0   28        8     2.926376381 19244  I ZAS R 262144 + 8 [dd]=0A=
252,0   28        9     2.926389856  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       10     2.926405576   151  C ZAS R 262144 + 8 [0] <262152>=
=0A=
252,0   28       11     2.926423700 19244  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28       12     2.926430522 19244  G ZAS R 262144 + 8 [dd]=0A=
252,0   28       13     2.926437185 19244  I ZAS R 262144 + 8 [dd]=0A=
252,0   28       14     2.926450309  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       15     2.926478703   151  C ZAS R 262144 + 8 [0] <262160>=
=0A=
252,0   28       16     2.926498149 19244  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28       17     2.926505333 19244  G ZAS R 262144 + 8 [dd]=0A=
252,0   28       18     2.926512135 19244  I ZAS R 262144 + 8 [dd]=0A=
252,0   28       19     2.926562951  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       20     2.926582998   151  C ZAS R 262144 + 8 [0] <262168>=
=0A=
252,0   28       21     2.926603256 19244  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28       22     2.926611993 19244  G ZAS R 262144 + 8 [dd]=0A=
252,0   28       23     2.926620639 19244  I ZAS R 262144 + 8 [dd]=0A=
252,0   28       24     2.926637661  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       25     2.926653851   151  C ZAS R 262144 + 8 [0] <262176>=
=0A=
252,0   15        1     2.917139969 19242  Q ZAS N 262144 + 8 [dd]=0A=
252,0   15        2     2.917148015 19242  G ZAS N 262144 + 8 [dd]=0A=
252,0   15        3     2.917156340 19242  I ZAS N 262144 + 8 [dd]=0A=
252,0   15        4     2.917173803  1323  D ZAS N 262144 + 8 =0A=
[kworker/15:1H]=0A=
252,0   15        5     2.917195554    86  C ZAS N 262144 + 8 [0] <262144>=
=0A=
252,0   15        6     2.917216303 19242  Q ZAS N 262144 + 8 [dd]=0A=
252,0   15        7     2.917233655 19242  G ZAS N 262144 + 8 [dd]=0A=
252,0   15        8     2.917241029 19242  I ZAS N 262144 + 8 [dd]=0A=
252,0   15        9     2.917257370  1323  D ZAS N 262144 + 8 =0A=
[kworker/15:1H]=0A=
252,0   15       10     2.917273770    86  C ZAS N 262144 + 8 [0] <262152>=
=0A=
252,0   15       11     2.917293598 19242  Q ZAS N 262144 + 8 [dd]=0A=
252,0   15       12     2.917300731 19242  G ZAS N 262144 + 8 [dd]=0A=
252,0   15       13     2.917307644 19242  I ZAS N 262144 + 8 [dd]=0A=
252,0   15       14     2.917321570  1323  D ZAS N 262144 + 8 =0A=
[kworker/15:1H]=0A=
252,0   15       15     2.917337720    86  C ZAS N 262144 + 8 [0] <262160>=
=0A=
252,0   15       16     2.917356285 19242  Q ZAS N 262144 + 8 [dd]=0A=
252,0   15       17     2.917363178 19242  G ZAS N 262144 + 8 [dd]=0A=
252,0   15       18     2.917370051 19242  I ZAS N 262144 + 8 [dd]=0A=
252,0   15       19     2.917383476  1323  D ZAS N 262144 + 8 =0A=
[kworker/15:1H]=0A=
252,0   15       20     2.917399005    86  C ZAS N 262144 + 8 [0] <262168>=
=0A=
252,0   15       21     2.917417330 19242  Q ZAS N 262144 + 8 [dd]=0A=
252,0   15       22     2.917424463 19242  G ZAS N 262144 + 8 [dd]=0A=
252,0   15       23     2.917431346 19242  I ZAS N 262144 + 8 [dd]=0A=
252,0   15       24     2.917444561  1323  D ZAS N 262144 + 8 =0A=
[kworker/15:1H]=0A=
252,0   15       25     2.917464969    86  C ZAS N 262144 + 8 [0] <262176>=
=0A=
CPU3 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU11 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU15 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU28 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:          15,       60KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:       15,       60KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:       15,       60KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 0KiB/s / 0KiB/s=0A=
Events (252,0): 75 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0x8=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x8=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x8=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x8=0A=
---------------------------------------------=0A=
252,0    7        1     2.940929774 19330  Q ZAS I 262144 + 8 [dd]=0A=
252,0    7        2     2.940937589 19330  G ZAS I 262144 + 8 [dd]=0A=
252,0    7        3     2.940945363 19330  I ZAS I 262144 + 8 [dd]=0A=
252,0    7        4     2.940962105   799  D ZAS I 262144 + 8 [kworker/7:1H=
]=0A=
252,0    7        5     2.940982563    46  C ZAS I 262144 + 8 [0] <262144>=
=0A=
252,0    7        6     2.941002901 19330  Q ZAS I 262144 + 8 [dd]=0A=
252,0    7        7     2.941009924 19330  G ZAS I 262144 + 8 [dd]=0A=
252,0    7        8     2.941017068 19330  I ZAS I 262144 + 8 [dd]=0A=
252,0    7        9     2.941030503   799  D ZAS I 262144 + 8 [kworker/7:1H=
]=0A=
252,0    7       10     2.941046202    46  C ZAS I 262144 + 8 [0] <262152>=
=0A=
252,0    7       11     2.941064096 19330  Q ZAS I 262144 + 8 [dd]=0A=
252,0    7       12     2.941070829 19330  G ZAS I 262144 + 8 [dd]=0A=
252,0    7       13     2.941077441 19330  I ZAS I 262144 + 8 [dd]=0A=
252,0    7       14     2.941091487   799  D ZAS I 262144 + 8 [kworker/7:1H=
]=0A=
252,0    7       15     2.941114871    46  C ZAS I 262144 + 8 [0] <262160>=
=0A=
252,0    7       16     2.941133566 19330  Q ZAS I 262144 + 8 [dd]=0A=
252,0    7       17     2.941140309 19330  G ZAS I 262144 + 8 [dd]=0A=
252,0    7       18     2.941146911 19330  I ZAS I 262144 + 8 [dd]=0A=
252,0    7       19     2.941160006   799  D ZAS I 262144 + 8 [kworker/7:1H=
]=0A=
252,0    7       20     2.941175214    46  C ZAS I 262144 + 8 [0] <262168>=
=0A=
252,0    7       21     2.941192637 19330  Q ZAS I 262144 + 8 [dd]=0A=
252,0    7       22     2.941200021 19330  G ZAS I 262144 + 8 [dd]=0A=
252,0    7       23     2.941206583 19330  I ZAS I 262144 + 8 [dd]=0A=
252,0    7       24     2.941219107   799  D ZAS I 262144 + 8 [kworker/7:1H=
]=0A=
252,0    7       25     2.941234125    46  C ZAS I 262144 + 8 [0] <262176>=
=0A=
CPU7 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU16 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 0KiB/s / 0KiB/s=0A=
Events (252,0): 25 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0x9=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x9=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x9=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0x9=0A=
---------------------------------------------=0A=
252,0   11        1     2.941571777 19411  Q ZAS I 262144 + 8 [dd]=0A=
252,0   11        2     2.941579953 19411  G ZAS I 262144 + 8 [dd]=0A=
252,0   11        3     2.941587647 19411  I ZAS I 262144 + 8 [dd]=0A=
252,0   11        4     2.941605110   800  D ZAS I 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11        5     2.941627101    66  C ZAS I 262144 + 8 [0] <262144>=
=0A=
252,0   11        6     2.941647189 19411  Q ZAS I 262144 + 8 [dd]=0A=
252,0   11        7     2.941653871 19411  G ZAS I 262144 + 8 [dd]=0A=
252,0   11        8     2.941660464 19411  I ZAS I 262144 + 8 [dd]=0A=
252,0   11        9     2.941673959   800  D ZAS I 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       10     2.941689358    66  C ZAS I 262144 + 8 [0] <262152>=
=0A=
252,0   11       11     2.941707252 19411  Q ZAS I 262144 + 8 [dd]=0A=
252,0   11       12     2.941713894 19411  G ZAS I 262144 + 8 [dd]=0A=
252,0   11       13     2.941720466 19411  I ZAS I 262144 + 8 [dd]=0A=
252,0   11       14     2.941733240   800  D ZAS I 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       15     2.941748599    66  C ZAS I 262144 + 8 [0] <262160>=
=0A=
252,0   11       16     2.941766272 19411  Q ZAS I 262144 + 8 [dd]=0A=
252,0   11       17     2.941772835 19411  G ZAS I 262144 + 8 [dd]=0A=
252,0   11       18     2.941779417 19411  I ZAS I 262144 + 8 [dd]=0A=
252,0   11       19     2.941833027   800  D ZAS I 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       20     2.941851372    66  C ZAS I 262144 + 8 [0] <262168>=
=0A=
252,0   11       21     2.941873413 19411  Q ZAS I 262144 + 8 [dd]=0A=
252,0   11       22     2.941880557 19411  G ZAS I 262144 + 8 [dd]=0A=
252,0   11       23     2.941890986 19411  I ZAS I 262144 + 8 [dd]=0A=
252,0   11       24     2.941906145   800  D ZAS I 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       25     2.941921463    66  C ZAS I 262144 + 8 [0] <262176>=
=0A=
252,0   12        1     2.917547784 19404  Q ZAS N 262144 + 8 [dd]=0A=
252,0   12        2     2.917555729 19404  G ZAS N 262144 + 8 [dd]=0A=
252,0   12        3     2.917563754 19404  I ZAS N 262144 + 8 [dd]=0A=
252,0   12        4     2.917580947   792  D ZAS N 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12        5     2.917601796    71  C ZAS N 262144 + 8 [0] <262144>=
=0A=
252,0   12        6     2.917622044 19404  Q ZAS N 262144 + 8 [dd]=0A=
252,0   12        7     2.917629167 19404  G ZAS N 262144 + 8 [dd]=0A=
252,0   12        8     2.917636100 19404  I ZAS N 262144 + 8 [dd]=0A=
252,0   12        9     2.917649996   792  D ZAS N 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       10     2.917665986    71  C ZAS N 262144 + 8 [0] <262152>=
=0A=
252,0   12       11     2.917684631 19404  Q ZAS N 262144 + 8 [dd]=0A=
252,0   12       12     2.917691574 19404  G ZAS N 262144 + 8 [dd]=0A=
252,0   12       13     2.917698417 19404  I ZAS N 262144 + 8 [dd]=0A=
252,0   12       14     2.917711892   792  D ZAS N 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       15     2.917727832    71  C ZAS N 262144 + 8 [0] <262160>=
=0A=
252,0   12       16     2.917756626 19404  Q ZAS N 262144 + 8 [dd]=0A=
252,0   12       17     2.917763890 19404  G ZAS N 262144 + 8 [dd]=0A=
252,0   12       18     2.917770913 19404  I ZAS N 262144 + 8 [dd]=0A=
252,0   12       19     2.917816649   792  D ZAS N 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       20     2.917834452    71  C ZAS N 262144 + 8 [0] <262168>=
=0A=
252,0   12       21     2.917855371 19404  Q ZAS N 262144 + 8 [dd]=0A=
252,0   12       22     2.917863897 19404  G ZAS N 262144 + 8 [dd]=0A=
252,0   12       23     2.917871892 19404  I ZAS N 262144 + 8 [dd]=0A=
252,0   12       24     2.917893783   792  D ZAS N 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       25     2.917909232    71  C ZAS N 262144 + 8 [0] <262176>=
=0A=
CPU8 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU11 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU12 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:          10,       40KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:       10,       40KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:       10,       40KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 0KiB/s / 0KiB/s=0A=
Events (252,0): 50 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0xA=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xA=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xA=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xA=0A=
---------------------------------------------=0A=
252,0   25        1     2.926320406 19496  Q ZAS R 262144 + 8 [dd]=0A=
252,0   25        2     2.926328411 19496  G ZAS R 262144 + 8 [dd]=0A=
252,0   25        3     2.926336346 19496  I ZAS R 262144 + 8 [dd]=0A=
252,0   25        4     2.926353819  1115  D ZAS R 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25        5     2.926376131   136  C ZAS R 262144 + 8 [0] <262144>=
=0A=
252,0   25        6     2.926396729 19496  Q ZAS R 262144 + 8 [dd]=0A=
252,0   25        7     2.926403713 19496  G ZAS R 262144 + 8 [dd]=0A=
252,0   25        8     2.926410636 19496  I ZAS R 262144 + 8 [dd]=0A=
252,0   25        9     2.926424341  1115  D ZAS R 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25       10     2.926440291   136  C ZAS R 262144 + 8 [0] <262152>=
=0A=
252,0   25       11     2.926459547 19496  Q ZAS R 262144 + 8 [dd]=0A=
252,0   25       12     2.926467402 19496  G ZAS R 262144 + 8 [dd]=0A=
252,0   25       13     2.926474255 19496  I ZAS R 262144 + 8 [dd]=0A=
252,0   25       14     2.926600792     0  C ZAS R 262144 + 8 [0] <262160>=
=0A=
252,0   25       15     2.926630558 19496  Q ZAS R 262144 + 8 [dd]=0A=
252,0   25       16     2.926638583 19496  G ZAS R 262144 + 8 [dd]=0A=
252,0   25       17     2.926646618 19496  I ZAS R 262144 + 8 [dd]=0A=
252,0   25       18     2.926723863     0  C ZAS R 262144 + 8 [0] <262168>=
=0A=
252,0   25       19     2.926750813 19496  Q ZAS R 262144 + 8 [dd]=0A=
252,0   25       20     2.926759820 19496  G ZAS R 262144 + 8 [dd]=0A=
252,0   25       21     2.926767284 19496  I ZAS R 262144 + 8 [dd]=0A=
252,0   25       22     2.926783525  1115  D ZAS R 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25       23     2.926803322   136  C ZAS R 262144 + 8 [0] <262176>=
=0A=
252,0   24        1     2.926510673  1960  D ZAS R 262144 + 8 =0A=
[kworker/24:1H]=0A=
252,0   24        2     2.926695390  1960  D ZAS R 262144 + 8 =0A=
[kworker/24:1H]=0A=
252,0   14        1     2.940693811 19500  Q ZAS I 262144 + 8 [dd]=0A=
252,0   14        2     2.940701876 19500  G ZAS I 262144 + 8 [dd]=0A=
252,0   14        3     2.940710042 19500  I ZAS I 262144 + 8 [dd]=0A=
252,0   14        4     2.940728386   801  D ZAS I 262144 + 8 =0A=
[kworker/14:1H]=0A=
252,0   14        5     2.940749095    81  C ZAS I 262144 + 8 [0] <262144>=
=0A=
252,0   14        6     2.940786004 19500  Q ZAS I 262144 + 8 [dd]=0A=
252,0   14        7     2.940793208 19500  G ZAS I 262144 + 8 [dd]=0A=
252,0   14        8     2.940800311 19500  I ZAS I 262144 + 8 [dd]=0A=
252,0   14        9     2.940815109   801  D ZAS I 262144 + 8 =0A=
[kworker/14:1H]=0A=
252,0   14       10     2.940831469    81  C ZAS I 262144 + 8 [0] <262152>=
=0A=
252,0   14       11     2.940887585 19500  Q ZAS I 262144 + 8 [dd]=0A=
252,0   14       12     2.940895740 19500  G ZAS I 262144 + 8 [dd]=0A=
252,0   14       13     2.940902873 19500  I ZAS I 262144 + 8 [dd]=0A=
252,0   14       14     2.940918022   801  D ZAS I 262144 + 8 =0A=
[kworker/14:1H]=0A=
252,0   14       15     2.940935094    81  C ZAS I 262144 + 8 [0] <262160>=
=0A=
252,0   14       16     2.940960201 19500  Q ZAS I 262144 + 8 [dd]=0A=
252,0   14       17     2.940967565 19500  G ZAS I 262144 + 8 [dd]=0A=
252,0   14       18     2.940975249 19500  I ZAS I 262144 + 8 [dd]=0A=
252,0   14       19     2.940989005   801  D ZAS I 262144 + 8 =0A=
[kworker/14:1H]=0A=
252,0   14       20     2.941004885    81  C ZAS I 262144 + 8 [0] <262168>=
=0A=
252,0   14       21     2.941023970 19500  Q ZAS I 262144 + 8 [dd]=0A=
252,0   14       22     2.941030943 19500  G ZAS I 262144 + 8 [dd]=0A=
252,0   14       23     2.941042976 19500  I ZAS I 262144 + 8 [dd]=0A=
252,0   14       24     2.941062823   801  D ZAS I 262144 + 8 =0A=
[kworker/14:1H]=0A=
252,0   14       25     2.941082871    81  C ZAS I 262144 + 8 [0] <262176>=
=0A=
CPU7 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             3        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU14 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             3        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU24 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        2,        8KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             3        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU25 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        3,       12KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             3        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:          10,       40KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:       10,       40KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:       10,       40KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 2,857KiB/s / 0KiB/s=0A=
Events (252,0): 50 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0xB=0A=
---------------------------------------------=0A=
252,0   12        1     2.913364760 19585  Q ZAS N 262144 + 8 [dd]=0A=
252,0   12        2     2.913376993 19585  G ZAS N 262144 + 8 [dd]=0A=
252,0   12        3     2.913389546 19585  I ZAS N 262144 + 8 [dd]=0A=
252,0   12        4     2.913417178   792  D ZAS N 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12        5     2.913447725    71  C ZAS N 262144 + 8 [0] <262144>=
=0A=
252,0   12        6     2.913478503 19585  Q ZAS N 262144 + 8 [dd]=0A=
252,0   12        7     2.913489263 19585  G ZAS N 262144 + 8 [dd]=0A=
252,0   12        8     2.913528146 19585  I ZAS N 262144 + 8 [dd]=0A=
252,0   12        9     2.913552372   792  D ZAS N 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       10     2.913578621    71  C ZAS N 262144 + 8 [0] <262152>=
=0A=
---------------------------------------------=0A=
Using Priority mask 0xB=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xB=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xB=0A=
---------------------------------------------=0A=
252,0    5        1     2.921686376  1065  D ZAS R 262144 + 8 [kworker/5:1H=
]=0A=
252,0   11        1     2.936552955 19592  Q ZAS I 262144 + 8 [dd]=0A=
252,0   11        2     2.936562063 19592  G ZAS I 262144 + 8 [dd]=0A=
252,0   11        3     2.936587380 19592  I ZAS I 262144 + 8 [dd]=0A=
252,0   11        4     2.936605103   800  D ZAS I 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11        5     2.936628157    66  C ZAS I 262144 + 8 [0] <262144>=
=0A=
252,0   11        6     2.936649066 19592  Q ZAS I 262144 + 8 [dd]=0A=
252,0   11        7     2.936656199 19592  G ZAS I 262144 + 8 [dd]=0A=
252,0   11        8     2.936663052 19592  I ZAS I 262144 + 8 [dd]=0A=
252,0   11        9     2.936676678   800  D ZAS I 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       10     2.936692457    66  C ZAS I 262144 + 8 [0] <262152>=
=0A=
252,0   11       11     2.936710691 19592  Q ZAS I 262144 + 8 [dd]=0A=
252,0   11       12     2.936717594 19592  G ZAS I 262144 + 8 [dd]=0A=
252,0   11       13     2.936724387 19592  I ZAS I 262144 + 8 [dd]=0A=
252,0   11       14     2.936770664   800  D ZAS I 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       15     2.936787696    66  C ZAS I 262144 + 8 [0] <262160>=
=0A=
252,0   11       16     2.936810579 19592  Q ZAS I 262144 + 8 [dd]=0A=
252,0   11       17     2.936817732 19592  G ZAS I 262144 + 8 [dd]=0A=
252,0   11       18     2.936824655 19592  I ZAS I 262144 + 8 [dd]=0A=
252,0   11       19     2.936839022   800  D ZAS I 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       20     2.936861194    66  C ZAS I 262144 + 8 [0] <262168>=
=0A=
252,0   11       21     2.936881221 19592  Q ZAS I 262144 + 8 [dd]=0A=
252,0   11       22     2.936888144 19592  G ZAS I 262144 + 8 [dd]=0A=
252,0   11       23     2.936897732 19592  I ZAS I 262144 + 8 [dd]=0A=
252,0   11       24     2.936914073   800  D ZAS I 262144 + 8 =0A=
[kworker/11:1H]=0A=
252,0   11       25     2.936931816    66  C ZAS I 262144 + 8 [0] <262176>=
=0A=
252,0   12       11     2.913665534 19585  Q ZAS N 262144 + 8 [dd]=0A=
252,0   12       12     2.913676945 19585  G ZAS N 262144 + 8 [dd]=0A=
252,0   12       13     2.913688337 19585  I ZAS N 262144 + 8 [dd]=0A=
252,0   12       14     2.913713674   792  D ZAS N 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       15     2.913773727    71  C ZAS N 262144 + 8 [0] <262160>=
=0A=
252,0   12       16     2.913818000 19585  Q ZAS N 262144 + 8 [dd]=0A=
252,0   12       17     2.913830283 19585  G ZAS N 262144 + 8 [dd]=0A=
252,0   12       18     2.913842356 19585  I ZAS N 262144 + 8 [dd]=0A=
252,0   12       19     2.913868424   792  D ZAS N 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       20     2.913895666    71  C ZAS N 262144 + 8 [0] <262168>=
=0A=
252,0   12       21     2.913927726 19585  Q ZAS N 262144 + 8 [dd]=0A=
252,0   12       22     2.913940520 19585  G ZAS N 262144 + 8 [dd]=0A=
252,0   12       23     2.913953384 19585  I ZAS N 262144 + 8 [dd]=0A=
252,0   12       24     2.913978451   792  D ZAS N 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       25     2.914013987    71  C ZAS N 262144 + 8 [0] <262176>=
=0A=
252,0   27        1     2.921549739 19588  Q ZAS R 262144 + 8 [dd]=0A=
252,0   27        2     2.921558376 19588  G ZAS R 262144 + 8 [dd]=0A=
252,0   27        3     2.921566962 19588  I ZAS R 262144 + 8 [dd]=0A=
252,0   27        4     2.921585977  1602  D ZAS R 262144 + 8 =0A=
[kworker/27:1H]=0A=
252,0   27        5     2.921610684   146  C ZAS R 262144 + 8 [0] <262144>=
=0A=
252,0   27        6     2.921631353 19588  Q ZAS R 262144 + 8 [dd]=0A=
252,0   27        7     2.921639688 19588  G ZAS R 262144 + 8 [dd]=0A=
252,0   27        8     2.921647403 19588  I ZAS R 262144 + 8 [dd]=0A=
252,0   27        9     2.921831468     0  C ZAS R 262144 + 8 [0] <262152>=
=0A=
252,0   27       10     2.921873627 19588  Q ZAS R 262144 + 8 [dd]=0A=
252,0   27       11     2.921884107 19588  G ZAS R 262144 + 8 [dd]=0A=
252,0   27       12     2.921892693 19588  I ZAS R 262144 + 8 [dd]=0A=
252,0   27       13     2.921914604  1602  D ZAS R 262144 + 8 =0A=
[kworker/27:1H]=0A=
252,0   27       14     2.921957434   146  C ZAS R 262144 + 8 [0] <262160>=
=0A=
252,0   27       15     2.921978954 19588  Q ZAS R 262144 + 8 [dd]=0A=
252,0   27       16     2.921986178 19588  G ZAS R 262144 + 8 [dd]=0A=
252,0   27       17     2.921993492 19588  I ZAS R 262144 + 8 [dd]=0A=
252,0   27       18     2.922013018  1602  D ZAS R 262144 + 8 =0A=
[kworker/27:1H]=0A=
252,0   27       19     2.922032294   146  C ZAS R 262144 + 8 [0] <262168>=
=0A=
252,0   27       20     2.922053945 19588  Q ZAS R 262144 + 8 [dd]=0A=
252,0   27       21     2.922062311 19588  G ZAS R 262144 + 8 [dd]=0A=
252,0   27       22     2.922071438 19588  I ZAS R 262144 + 8 [dd]=0A=
252,0   27       23     2.922086095  1602  D ZAS R 262144 + 8 =0A=
[kworker/27:1H]=0A=
252,0   27       24     2.922103608   146  C ZAS R 262144 + 8 [0] <262176>=
=0A=
CPU5 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        1,        4KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             2        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU11 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             2        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU12 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             2        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU27 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        4,       16KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             2        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:          15,       60KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:       15,       60KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:       15,       60KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 7,500KiB/s / 0KiB/s=0A=
Events (252,0): 75 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0xC=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xC=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xC=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xC=0A=
---------------------------------------------=0A=
252,0   49        1     2.935068562 19673  Q ZAS I 262144 + 8 [dd]=0A=
252,0   49        2     2.935078049 19673  G ZAS I 262144 + 8 [dd]=0A=
252,0   49        3     2.935085894 19673  I ZAS I 262144 + 8 [dd]=0A=
252,0   49        4     2.935104309   788  D ZAS I 262144 + 8 =0A=
[kworker/49:1H]=0A=
252,0   49        5     2.935135467   256  C ZAS I 262144 + 8 [0] <262144>=
=0A=
252,0   49        6     2.935155735 19673  Q ZAS I 262144 + 8 [dd]=0A=
252,0   49        7     2.935172156 19673  G ZAS I 262144 + 8 [dd]=0A=
252,0   49        8     2.935179660 19673  I ZAS I 262144 + 8 [dd]=0A=
252,0   49        9     2.935195940   788  D ZAS I 262144 + 8 =0A=
[kworker/49:1H]=0A=
252,0   49       10     2.935214185   256  C ZAS I 262144 + 8 [0] <262152>=
=0A=
252,0   49       11     2.935233431 19673  Q ZAS I 262144 + 8 [dd]=0A=
252,0   49       12     2.935243299 19673  G ZAS I 262144 + 8 [dd]=0A=
252,0   49       13     2.935253088 19673  I ZAS I 262144 + 8 [dd]=0A=
252,0   49       14     2.935268857   788  D ZAS I 262144 + 8 =0A=
[kworker/49:1H]=0A=
252,0   49       15     2.935286220   256  C ZAS I 262144 + 8 [0] <262160>=
=0A=
252,0   49       16     2.935304975 19673  Q ZAS I 262144 + 8 [dd]=0A=
252,0   49       17     2.935312880 19673  G ZAS I 262144 + 8 [dd]=0A=
252,0   49       18     2.935319322 19673  I ZAS I 262144 + 8 [dd]=0A=
252,0   49       19     2.935332687   788  D ZAS I 262144 + 8 =0A=
[kworker/49:1H]=0A=
252,0   49       20     2.935348206   256  C ZAS I 262144 + 8 [0] <262168>=
=0A=
252,0   49       21     2.935369907 19673  Q ZAS I 262144 + 8 [dd]=0A=
252,0   49       22     2.935376469 19673  G ZAS I 262144 + 8 [dd]=0A=
252,0   49       23     2.935384604 19673  I ZAS I 262144 + 8 [dd]=0A=
252,0   49       24     2.935400434   788  D ZAS I 262144 + 8 =0A=
[kworker/49:1H]=0A=
252,0   49       25     2.935424239   256  C ZAS I 262144 + 8 [0] <262176>=
=0A=
252,0   12        1     2.928022237 19671  Q ZAS B 262144 + 8 [dd]=0A=
252,0   12        2     2.928036184 19671  G ZAS B 262144 + 8 [dd]=0A=
252,0   12        3     2.928048747 19671  I ZAS B 262144 + 8 [dd]=0A=
252,0   12        4     2.928075417   792  D ZAS B 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12        5     2.928100985    71  C ZAS B 262144 + 8 [0] <262144>=
=0A=
252,0   12        6     2.928126623 19671  Q ZAS B 262144 + 8 [dd]=0A=
252,0   12        7     2.928135630 19671  G ZAS B 262144 + 8 [dd]=0A=
252,0   12        8     2.928143495 19671  I ZAS B 262144 + 8 [dd]=0A=
252,0   12        9     2.928161188   792  D ZAS B 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       10     2.928179122    71  C ZAS B 262144 + 8 [0] <262152>=
=0A=
252,0   12       11     2.928203517 19671  Q ZAS B 262144 + 8 [dd]=0A=
252,0   12       12     2.928211262 19671  G ZAS B 262144 + 8 [dd]=0A=
252,0   12       13     2.928220659 19671  I ZAS B 262144 + 8 [dd]=0A=
252,0   12       14     2.928237902   792  D ZAS B 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       15     2.928258350    71  C ZAS B 262144 + 8 [0] <262160>=
=0A=
252,0   12       16     2.928281614 19671  Q ZAS B 262144 + 8 [dd]=0A=
252,0   12       17     2.928289278 19671  G ZAS B 262144 + 8 [dd]=0A=
252,0   12       18     2.928303775 19671  I ZAS B 262144 + 8 [dd]=0A=
252,0   12       19     2.928321188   792  D ZAS B 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       20     2.928339112    71  C ZAS B 262144 + 8 [0] <262168>=
=0A=
252,0   12       21     2.928360592 19671  Q ZAS B 262144 + 8 [dd]=0A=
252,0   12       22     2.928369469 19671  G ZAS B 262144 + 8 [dd]=0A=
252,0   12       23     2.928376963 19671  I ZAS B 262144 + 8 [dd]=0A=
252,0   12       24     2.928391991   792  D ZAS B 262144 + 8 =0A=
[kworker/12:1H]=0A=
252,0   12       25     2.928410726    71  C ZAS B 262144 + 8 [0] <262176>=
=0A=
CPU5 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU12 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU49 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:          10,       40KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:       10,       40KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:       10,       40KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 0KiB/s / 0KiB/s=0A=
Events (252,0): 50 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0xD=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xD=0A=
---------------------------------------------=0A=
252,0   14        1     2.913885897 19747  Q ZAS N 262144 + 8 [dd]=0A=
252,0   14        2     2.913893982 19747  G ZAS N 262144 + 8 [dd]=0A=
252,0   14        3     2.913902148 19747  I ZAS N 262144 + 8 [dd]=0A=
252,0   14        4     2.913919700   801  D ZAS N 262144 + 8 =0A=
[kworker/14:1H]=0A=
252,0   14        5     2.913941020    81  C ZAS N 262144 + 8 [0] <262144>=
=0A=
252,0   14        6     2.913960577 19747  Q ZAS N 262144 + 8 [dd]=0A=
252,0   14        7     2.913967340 19747  G ZAS N 262144 + 8 [dd]=0A=
252,0   14        8     2.913976307 19747  I ZAS N 262144 + 8 [dd]=0A=
252,0   14        9     2.913989782   801  D ZAS N 262144 + 8 =0A=
[kworker/14:1H]=0A=
252,0   14       10     2.914020489    81  C ZAS N 262144 + 8 [0] <262152>=
=0A=
252,0   14       11     2.914039475 19747  Q ZAS N 262144 + 8 [dd]=0A=
252,0   14       12     2.914048843 19747  G ZAS N 262144 + 8 [dd]=0A=
252,0   14       13     2.914055796 19747  I ZAS N 262144 + 8 [dd]=0A=
252,0   14       14     2.914070303   801  D ZAS N 262144 + 8 =0A=
[kworker/14:1H]=0A=
252,0   14       15     2.914085381    81  C ZAS N 262144 + 8 [0] <262160>=
=0A=
252,0   14       16     2.914103064 19747  Q ZAS N 262144 + 8 [dd]=0A=
252,0   14       17     2.914109617 19747  G ZAS N 262144 + 8 [dd]=0A=
252,0   14       18     2.914117151 19747  I ZAS N 262144 + 8 [dd]=0A=
252,0   14       19     2.914131798   801  D ZAS N 262144 + 8 =0A=
[kworker/14:1H]=0A=
252,0   14       20     2.914147918    81  C ZAS N 262144 + 8 [0] <262168>=
=0A=
252,0   14       21     2.914171733 19747  Q ZAS N 262144 + 8 [dd]=0A=
252,0   14       22     2.914178265 19747  G ZAS N 262144 + 8 [dd]=0A=
252,0   14       23     2.914185609 19747  I ZAS N 262144 + 8 [dd]=0A=
252,0   14       24     2.914198874   801  D ZAS N 262144 + 8 =0A=
[kworker/14:1H]=0A=
252,0   14       25     2.914226085    81  C ZAS N 262144 + 8 [0] <262176>=
=0A=
---------------------------------------------=0A=
Using Priority mask 0xD=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xD=0A=
---------------------------------------------=0A=
252,0   17        1     2.936625451 19754  Q ZAS I 262144 + 8 [dd]=0A=
252,0   17        2     2.936634889 19754  G ZAS I 262144 + 8 [dd]=0A=
252,0   17        3     2.936643976 19754  I ZAS I 262144 + 8 [dd]=0A=
252,0   17        4     2.936663663   796  D ZAS I 262144 + 8 =0A=
[kworker/17:1H]=0A=
252,0   17        5     2.936694300    96  C ZAS I 262144 + 8 [0] <262144>=
=0A=
252,0   17        6     2.936717173 19754  Q ZAS I 262144 + 8 [dd]=0A=
252,0   17        7     2.936725569 19754  G ZAS I 262144 + 8 [dd]=0A=
252,0   17        8     2.936733354 19754  I ZAS I 262144 + 8 [dd]=0A=
252,0   17        9     2.936749274   796  D ZAS I 262144 + 8 =0A=
[kworker/17:1H]=0A=
252,0   17       10     2.936799357    96  C ZAS I 262144 + 8 [0] <262152>=
=0A=
252,0   17       11     2.936826528 19754  Q ZAS I 262144 + 8 [dd]=0A=
252,0   17       12     2.936835335 19754  G ZAS I 262144 + 8 [dd]=0A=
252,0   17       13     2.936843360 19754  I ZAS I 262144 + 8 [dd]=0A=
252,0   17       14     2.936860843   796  D ZAS I 262144 + 8 =0A=
[kworker/17:1H]=0A=
252,0   17       15     2.936882403    96  C ZAS I 262144 + 8 [0] <262160>=
=0A=
252,0   17       16     2.936903423 19754  Q ZAS I 262144 + 8 [dd]=0A=
252,0   17       17     2.936911307 19754  G ZAS I 262144 + 8 [dd]=0A=
252,0   17       18     2.936919012 19754  I ZAS I 262144 + 8 [dd]=0A=
252,0   17       19     2.936934661   796  D ZAS I 262144 + 8 =0A=
[kworker/17:1H]=0A=
252,0   17       20     2.936953577    96  C ZAS I 262144 + 8 [0] <262168>=
=0A=
252,0   17       21     2.936981078 19754  Q ZAS I 262144 + 8 [dd]=0A=
252,0   17       22     2.936988963 19754  G ZAS I 262144 + 8 [dd]=0A=
252,0   17       23     2.936997419 19754  I ZAS I 262144 + 8 [dd]=0A=
252,0   17       24     2.937014561   796  D ZAS I 262144 + 8 =0A=
[kworker/17:1H]=0A=
252,0   17       25     2.937034418    96  C ZAS I 262144 + 8 [0] <262176>=
=0A=
252,0   24        1     2.929414508 19752  Q ZAS B 262144 + 8 [dd]=0A=
252,0   24        2     2.929423175 19752  G ZAS B 262144 + 8 [dd]=0A=
252,0   24        3     2.929431741 19752  I ZAS B 262144 + 8 [dd]=0A=
252,0   24        4     2.929451307  1960  D ZAS B 262144 + 8 =0A=
[kworker/24:1H]=0A=
252,0   24        5     2.929475793   131  C ZAS B 262144 + 8 [0] <262144>=
=0A=
252,0   24        6     2.929497424 19752  Q ZAS B 262144 + 8 [dd]=0A=
252,0   24        7     2.929504858 19752  G ZAS B 262144 + 8 [dd]=0A=
252,0   24        8     2.929512121 19752  I ZAS B 262144 + 8 [dd]=0A=
252,0   24        9     2.929526549  1960  D ZAS B 262144 + 8 =0A=
[kworker/24:1H]=0A=
252,0   24       10     2.929543200   131  C ZAS B 262144 + 8 [0] <262152>=
=0A=
252,0   24       11     2.929562967 19752  Q ZAS B 262144 + 8 [dd]=0A=
252,0   24       12     2.929570331 19752  G ZAS B 262144 + 8 [dd]=0A=
252,0   24       13     2.929577574 19752  I ZAS B 262144 + 8 [dd]=0A=
252,0   24       14     2.929591731  1960  D ZAS B 262144 + 8 =0A=
[kworker/24:1H]=0A=
252,0   24       15     2.929618621   131  C ZAS B 262144 + 8 [0] <262160>=
=0A=
252,0   24       16     2.929639140 19752  Q ZAS B 262144 + 8 [dd]=0A=
252,0   24       17     2.929646513 19752  G ZAS B 262144 + 8 [dd]=0A=
252,0   24       18     2.929653747 19752  I ZAS B 262144 + 8 [dd]=0A=
252,0   24       19     2.929668034  1960  D ZAS B 262144 + 8 =0A=
[kworker/24:1H]=0A=
252,0   24       20     2.929684745   131  C ZAS B 262144 + 8 [0] <262168>=
=0A=
252,0   24       21     2.929703971 19752  Q ZAS B 262144 + 8 [dd]=0A=
252,0   24       22     2.929711145 19752  G ZAS B 262144 + 8 [dd]=0A=
252,0   24       23     2.929718328 19752  I ZAS B 262144 + 8 [dd]=0A=
252,0   24       24     2.929732224  1960  D ZAS B 262144 + 8 =0A=
[kworker/24:1H]=0A=
252,0   24       25     2.929748455   131  C ZAS B 262144 + 8 [0] <262176>=
=0A=
CPU14 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU17 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU24 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU48 (252,0):=0A=
  Reads Queued:           0,        0KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        0,        0KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        0,        0KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:          15,       60KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:       15,       60KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:       15,       60KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 4,000KiB/s / 0KiB/s=0A=
Events (252,0): 75 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0xE=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xE=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xE=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xE=0A=
---------------------------------------------=0A=
252,0   28        1     2.924839719 19832  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28        2     2.924847874 19832  G ZAS R 262144 + 8 [dd]=0A=
252,0   28        3     2.924855639 19832  I ZAS R 262144 + 8 [dd]=0A=
252,0   28        4     2.924882269  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28        5     2.924907346   151  C ZAS R 262144 + 8 [0] <262144>=
=0A=
252,0   28        6     2.924928776 19832  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28        7     2.924935669 19832  G ZAS R 262144 + 8 [dd]=0A=
252,0   28        8     2.924942752 19832  I ZAS R 262144 + 8 [dd]=0A=
252,0   28        9     2.924956729  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       10     2.924971636   151  C ZAS R 262144 + 8 [0] <262152>=
=0A=
252,0   28       11     2.924989179 19832  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28       12     2.924995732 19832  G ZAS R 262144 + 8 [dd]=0A=
252,0   28       13     2.925002144 19832  I ZAS R 262144 + 8 [dd]=0A=
252,0   28       14     2.925014777  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       15     2.925029635   151  C ZAS R 262144 + 8 [0] <262160>=
=0A=
252,0   28       16     2.925046757 19832  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28       17     2.925053199 19832  G ZAS R 262144 + 8 [dd]=0A=
252,0   28       18     2.925059652 19832  I ZAS R 262144 + 8 [dd]=0A=
252,0   28       19     2.925072115  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       20     2.925086592   151  C ZAS R 262144 + 8 [0] <262168>=
=0A=
252,0   28       21     2.925107882 19832  Q ZAS R 262144 + 8 [dd]=0A=
252,0   28       22     2.925114504 19832  G ZAS R 262144 + 8 [dd]=0A=
252,0   28       23     2.925121037 19832  I ZAS R 262144 + 8 [dd]=0A=
252,0   28       24     2.925133901  1428  D ZAS R 262144 + 8 =0A=
[kworker/28:1H]=0A=
252,0   28       25     2.925148518   151  C ZAS R 262144 + 8 [0] <262176>=
=0A=
252,0   25        1     2.939754519 19836  Q ZAS I 262144 + 8 [dd]=0A=
252,0   25        2     2.939763576 19836  G ZAS I 262144 + 8 [dd]=0A=
252,0   25        3     2.939772623 19836  I ZAS I 262144 + 8 [dd]=0A=
252,0   25        4     2.939792501  1115  D ZAS I 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25        5     2.939817477   136  C ZAS I 262144 + 8 [0] <262144>=
=0A=
252,0   25        6     2.939841623 19836  Q ZAS I 262144 + 8 [dd]=0A=
252,0   25        7     2.939849437 19836  G ZAS I 262144 + 8 [dd]=0A=
252,0   25        8     2.939857522 19836  I ZAS I 262144 + 8 [dd]=0A=
252,0   25        9     2.939873162  1115  D ZAS I 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25       10     2.939891326   136  C ZAS I 262144 + 8 [0] <262152>=
=0A=
252,0   25       11     2.939911925 19836  Q ZAS I 262144 + 8 [dd]=0A=
252,0   25       12     2.939919629 19836  G ZAS I 262144 + 8 [dd]=0A=
252,0   25       13     2.939927303 19836  I ZAS I 262144 + 8 [dd]=0A=
252,0   25       14     2.939942452  1115  D ZAS I 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25       15     2.939960035   136  C ZAS I 262144 + 8 [0] <262160>=
=0A=
252,0   25       16     2.939980152 19836  Q ZAS I 262144 + 8 [dd]=0A=
252,0   25       17     2.939987867 19836  G ZAS I 262144 + 8 [dd]=0A=
252,0   25       18     2.939995521 19836  I ZAS I 262144 + 8 [dd]=0A=
252,0   25       19     2.940017312  1115  D ZAS I 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25       20     2.940034935   136  C ZAS I 262144 + 8 [0] <262168>=
=0A=
252,0   25       21     2.940055584 19836  Q ZAS I 262144 + 8 [dd]=0A=
252,0   25       22     2.940064701 19836  G ZAS I 262144 + 8 [dd]=0A=
252,0   25       23     2.940072325 19836  I ZAS I 262144 + 8 [dd]=0A=
252,0   25       24     2.940087804  1115  D ZAS I 262144 + 8 =0A=
[kworker/25:1H]=0A=
252,0   25       25     2.940105277   136  C ZAS I 262144 + 8 [0] <262176>=
=0A=
252,0   31        1     2.932395198 19834  Q ZAS B 262144 + 8 [dd]=0A=
252,0   31        2     2.932403614 19834  G ZAS B 262144 + 8 [dd]=0A=
252,0   31        3     2.932411719 19834  I ZAS B 262144 + 8 [dd]=0A=
252,0   31        4     2.932429162  1553  D ZAS B 262144 + 8 =0A=
[kworker/31:1H]=0A=
252,0   31        5     2.932452456   166  C ZAS B 262144 + 8 [0] <262144>=
=0A=
252,0   31        6     2.932472653 19834  Q ZAS B 262144 + 8 [dd]=0A=
252,0   31        7     2.932479657 19834  G ZAS B 262144 + 8 [dd]=0A=
252,0   31        8     2.932486650 19834  I ZAS B 262144 + 8 [dd]=0A=
252,0   31        9     2.932500546  1553  D ZAS B 262144 + 8 =0A=
[kworker/31:1H]=0A=
252,0   31       10     2.932516796   166  C ZAS B 262144 + 8 [0] <262152>=
=0A=
252,0   31       11     2.932584403 19834  Q ZAS B 262144 + 8 [dd]=0A=
252,0   31       12     2.932592909 19834  G ZAS B 262144 + 8 [dd]=0A=
252,0   31       13     2.932600483 19834  I ZAS B 262144 + 8 [dd]=0A=
252,0   31       14     2.932616082  1553  D ZAS B 262144 + 8 =0A=
[kworker/31:1H]=0A=
252,0   31       15     2.932636250   166  C ZAS B 262144 + 8 [0] <262160>=
=0A=
252,0   31       16     2.932662870 19834  Q ZAS B 262144 + 8 [dd]=0A=
252,0   31       17     2.932670084 19834  G ZAS B 262144 + 8 [dd]=0A=
252,0   31       18     2.932677107 19834  I ZAS B 262144 + 8 [dd]=0A=
252,0   31       19     2.932691323  1553  D ZAS B 262144 + 8 =0A=
[kworker/31:1H]=0A=
252,0   31       20     2.932707434   166  C ZAS B 262144 + 8 [0] <262168>=
=0A=
252,0   31       21     2.932725858 19834  Q ZAS B 262144 + 8 [dd]=0A=
252,0   31       22     2.932733442 19834  G ZAS B 262144 + 8 [dd]=0A=
252,0   31       23     2.932740325 19834  I ZAS B 262144 + 8 [dd]=0A=
252,0   31       24     2.932753640  1553  D ZAS B 262144 + 8 =0A=
[kworker/31:1H]=0A=
252,0   31       25     2.932769961   166  C ZAS B 262144 + 8 [0] <262176>=
=0A=
CPU25 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU28 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU31 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:          15,       60KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:       15,       60KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:       15,       60KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 8,571KiB/s / 0KiB/s=0A=
Events (252,0): 75 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
---------------------------------------------=0A=
Using Priority mask 0xF=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xF=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xF=0A=
---------------------------------------------=0A=
---------------------------------------------=0A=
Using Priority mask 0xF=0A=
---------------------------------------------=0A=
252,0   31        1     2.941088912 19936  Q ZAS I 262144 + 8 [dd]=0A=
252,0   31        2     2.941096927 19936  G ZAS I 262144 + 8 [dd]=0A=
252,0   31        3     2.941104912 19936  I ZAS I 262144 + 8 [dd]=0A=
252,0   31        4     2.941122315  1553  D ZAS I 262144 + 8 =0A=
[kworker/31:1H]=0A=
252,0   31        5     2.941143735   166  C ZAS I 262144 + 8 [0] <262144>=
=0A=
252,0   31        6     2.941164033 19936  Q ZAS I 262144 + 8 [dd]=0A=
252,0   31        7     2.941171657 19936  G ZAS I 262144 + 8 [dd]=0A=
252,0   31        8     2.941190533 19936  I ZAS I 262144 + 8 [dd]=0A=
252,0   31        9     2.941205220  1553  D ZAS I 262144 + 8 =0A=
[kworker/31:1H]=0A=
252,0   31       10     2.941221821   166  C ZAS I 262144 + 8 [0] <262152>=
=0A=
252,0   31       11     2.941274931 19936  Q ZAS I 262144 + 8 [dd]=0A=
252,0   31       12     2.941284559 19936  G ZAS I 262144 + 8 [dd]=0A=
252,0   31       13     2.941292243 19936  I ZAS I 262144 + 8 [dd]=0A=
252,0   31       14     2.941308594  1553  D ZAS I 262144 + 8 =0A=
[kworker/31:1H]=0A=
252,0   31       15     2.941328351   166  C ZAS I 262144 + 8 [0] <262160>=
=0A=
252,0   31       16     2.941351434 19936  Q ZAS I 262144 + 8 [dd]=0A=
252,0   31       17     2.941360020 19936  G ZAS I 262144 + 8 [dd]=0A=
252,0   31       18     2.941370640 19936  I ZAS I 262144 + 8 [dd]=0A=
252,0   31       19     2.941386370  1553  D ZAS I 262144 + 8 =0A=
[kworker/31:1H]=0A=
252,0   31       20     2.941406147   166  C ZAS I 262144 + 8 [0] <262168>=
=0A=
252,0   31       21     2.941429591 19936  Q ZAS I 262144 + 8 [dd]=0A=
252,0   31       22     2.941437416 19936  G ZAS I 262144 + 8 [dd]=0A=
252,0   31       23     2.941445801 19936  I ZAS I 262144 + 8 [dd]=0A=
252,0   31       24     2.941460499  1553  D ZAS I 262144 + 8 =0A=
[kworker/31:1H]=0A=
252,0   31       25     2.941485346   166  C ZAS I 262144 + 8 [0] <262176>=
=0A=
252,0   32        1     2.927340209 19932  Q ZAS R 262144 + 8 [dd]=0A=
252,0   32        2     2.927348945 19932  G ZAS R 262144 + 8 [dd]=0A=
252,0   32        3     2.927357281 19932  I ZAS R 262144 + 8 [dd]=0A=
252,0   32        4     2.927381246  1119  D ZAS R 262144 + 8 =0A=
[kworker/32:1H]=0A=
252,0   32        5     2.927430909   171  C ZAS R 262144 + 8 [0] <262144>=
=0A=
252,0   32        6     2.927453140 19932  Q ZAS R 262144 + 8 [dd]=0A=
252,0   32        7     2.927462578 19932  G ZAS R 262144 + 8 [dd]=0A=
252,0   32        8     2.927472467 19932  I ZAS R 262144 + 8 [dd]=0A=
252,0   32        9     2.927487284  1119  D ZAS R 262144 + 8 =0A=
[kworker/32:1H]=0A=
252,0   32       10     2.927520737   171  C ZAS R 262144 + 8 [0] <262152>=
=0A=
252,0   32       11     2.927541626 19932  Q ZAS R 262144 + 8 [dd]=0A=
252,0   32       12     2.927549401 19932  G ZAS R 262144 + 8 [dd]=0A=
252,0   32       13     2.927556554 19932  I ZAS R 262144 + 8 [dd]=0A=
252,0   32       14     2.927576301  1119  D ZAS R 262144 + 8 =0A=
[kworker/32:1H]=0A=
252,0   32       15     2.927593634   171  C ZAS R 262144 + 8 [0] <262160>=
=0A=
252,0   32       16     2.927614583 19932  Q ZAS R 262144 + 8 [dd]=0A=
252,0   32       17     2.927622248 19932  G ZAS R 262144 + 8 [dd]=0A=
252,0   32       18     2.927629251 19932  I ZAS R 262144 + 8 [dd]=0A=
252,0   32       19     2.927643618  1119  D ZAS R 262144 + 8 =0A=
[kworker/32:1H]=0A=
252,0   32       20     2.927664667   171  C ZAS R 262144 + 8 [0] <262168>=
=0A=
252,0   32       21     2.927683573 19932  Q ZAS R 262144 + 8 [dd]=0A=
252,0   32       22     2.927690876 19932  G ZAS R 262144 + 8 [dd]=0A=
252,0   32       23     2.927698561 19932  I ZAS R 262144 + 8 [dd]=0A=
252,0   32       24     2.927715162  1119  D ZAS R 262144 + 8 =0A=
[kworker/32:1H]=0A=
252,0   32       25     2.927730992   171  C ZAS R 262144 + 8 [0] <262176>=
=0A=
252,0   29        1     2.933437283 19934  Q ZAS B 262144 + 8 [dd]=0A=
252,0   29        2     2.933445398 19934  G ZAS B 262144 + 8 [dd]=0A=
252,0   29        3     2.933453253 19934  I ZAS B 262144 + 8 [dd]=0A=
252,0   29        4     2.933470745  1124  D ZAS B 262144 + 8 =0A=
[kworker/29:1H]=0A=
252,0   29        5     2.933493168   156  C ZAS B 262144 + 8 [0] <262144>=
=0A=
252,0   29        6     2.933512594 19934  Q ZAS B 262144 + 8 [dd]=0A=
252,0   29        7     2.933519908 19934  G ZAS B 262144 + 8 [dd]=0A=
252,0   29        8     2.933526550 19934  I ZAS B 262144 + 8 [dd]=0A=
252,0   29        9     2.933539865  1124  D ZAS B 262144 + 8 =0A=
[kworker/29:1H]=0A=
252,0   29       10     2.933555044   156  C ZAS B 262144 + 8 [0] <262152>=
=0A=
252,0   29       11     2.933573368 19934  Q ZAS B 262144 + 8 [dd]=0A=
252,0   29       12     2.933580351 19934  G ZAS B 262144 + 8 [dd]=0A=
252,0   29       13     2.933586873 19934  I ZAS B 262144 + 8 [dd]=0A=
252,0   29       14     2.933599597  1124  D ZAS B 262144 + 8 =0A=
[kworker/29:1H]=0A=
252,0   29       15     2.933614916   156  C ZAS B 262144 + 8 [0] <262160>=
=0A=
252,0   29       16     2.933632138 19934  Q ZAS B 262144 + 8 [dd]=0A=
252,0   29       17     2.933639051 19934  G ZAS B 262144 + 8 [dd]=0A=
252,0   29       18     2.933650843 19934  I ZAS B 262144 + 8 [dd]=0A=
252,0   29       19     2.933664228  1124  D ZAS B 262144 + 8 =0A=
[kworker/29:1H]=0A=
252,0   29       20     2.933679246   156  C ZAS B 262144 + 8 [0] <262168>=
=0A=
252,0   29       21     2.933697190 19934  Q ZAS B 262144 + 8 [dd]=0A=
252,0   29       22     2.933703953 19934  G ZAS B 262144 + 8 [dd]=0A=
252,0   29       23     2.933710455 19934  I ZAS B 262144 + 8 [dd]=0A=
252,0   29       24     2.933723009  1124  D ZAS B 262144 + 8 =0A=
[kworker/29:1H]=0A=
252,0   29       25     2.933737927   156  C ZAS B 262144 + 8 [0] <262176>=
=0A=
252,0   47        1     2.919810588 19929  Q ZAS N 262144 + 8 [dd]=0A=
252,0   47        2     2.919819325 19929  G ZAS N 262144 + 8 [dd]=0A=
252,0   47        3     2.919834523 19929  I ZAS N 262144 + 8 [dd]=0A=
252,0   47        4     2.919853479  1013  D ZAS N 262144 + 8 =0A=
[kworker/47:1H]=0A=
252,0   47        5     2.919875971   246  C ZAS N 262144 + 8 [0] <262144>=
=0A=
252,0   47        6     2.919897591 19929  Q ZAS N 262144 + 8 [dd]=0A=
252,0   47        7     2.919906237 19929  G ZAS N 262144 + 8 [dd]=0A=
252,0   47        8     2.919913401 19929  I ZAS N 262144 + 8 [dd]=0A=
252,0   47        9     2.919927648  1013  D ZAS N 262144 + 8 =0A=
[kworker/47:1H]=0A=
252,0   47       10     2.919943948   246  C ZAS N 262144 + 8 [0] <262152>=
=0A=
252,0   47       11     2.919963094 19929  Q ZAS N 262144 + 8 [dd]=0A=
252,0   47       12     2.919970137 19929  G ZAS N 262144 + 8 [dd]=0A=
252,0   47       13     2.919977161 19929  I ZAS N 262144 + 8 [dd]=0A=
252,0   47       14     2.919990746  1013  D ZAS N 262144 + 8 =0A=
[kworker/47:1H]=0A=
252,0   47       15     2.920006696   246  C ZAS N 262144 + 8 [0] <262160>=
=0A=
252,0   47       16     2.920025451 19929  Q ZAS N 262144 + 8 [dd]=0A=
252,0   47       17     2.920032564 19929  G ZAS N 262144 + 8 [dd]=0A=
252,0   47       18     2.920039497 19929  I ZAS N 262144 + 8 [dd]=0A=
252,0   47       19     2.920053023  1013  D ZAS N 262144 + 8 =0A=
[kworker/47:1H]=0A=
252,0   47       20     2.920073171   246  C ZAS N 262144 + 8 [0] <262168>=
=0A=
252,0   47       21     2.920092757 19929  Q ZAS N 262144 + 8 [dd]=0A=
252,0   47       22     2.920099911 19929  G ZAS N 262144 + 8 [dd]=0A=
252,0   47       23     2.920106834 19929  I ZAS N 262144 + 8 [dd]=0A=
252,0   47       24     2.920121471  1013  D ZAS N 262144 + 8 =0A=
[kworker/47:1H]=0A=
252,0   47       25     2.920137231   246  C ZAS N 262144 + 8 [0] <262176>=
=0A=
CPU29 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU31 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU32 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
CPU47 (252,0):=0A=
  Reads Queued:           5,       20KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:        5,       20KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:        5,       20KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  Read depth:             1        	 Write depth:             0=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Total (252,0):=0A=
  Reads Queued:          20,       80KiB	 Writes Queued:           0, =0A=
     0KiB=0A=
  Read Dispatches:       20,       80KiB	 Write Dispatches:        0, =0A=
     0KiB=0A=
  Reads Requeued:         0		 Writes Requeued:         0=0A=
  Reads Completed:       20,       80KiB	 Writes Completed:        0, =0A=
     0KiB=0A=
  Read Merges:            0,        0KiB	 Write Merges:            0, =0A=
     0KiB=0A=
  IO unplugs:             0        	 Timer unplugs:           0=0A=
=0A=
Throughput (R/W): 0KiB/s / 0KiB/s=0A=
Events (252,0): 100 entries=0A=
Skips: 0 forward (0 -   0.0%)=0A=
=0A=
-- =0A=
2.22.1=0A=
=0A=
=0A=
