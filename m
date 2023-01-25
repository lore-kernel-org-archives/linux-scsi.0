Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97E4C54EED
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 21:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbjAYVXl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 16:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjAYVXj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 16:23:39 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF1246D59;
        Wed, 25 Jan 2023 13:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674681818; x=1706217818;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RYqgM/RFTQIEJh6LZX5yD+m5PN121bY+E2MPDpJtrLI=;
  b=Drm+9FtOTM6/rEB9ki8v9AlwXmLuFfYL2D1ELOe6K2AdtD+e5D1qHajN
   vR1PKCICt4vBJRs56Z3XP53dIh1G5oUBDtgdiMzc3Fvg+PAcYTfJmunih
   wYp8Yi/YoiBxkZoJeYB3/i+LYdkCC6JeR4g69TQdsJe+ambB6wCHe+8wJ
   d6BPmG5Od1thO6BYXImw0BaKfc4LD44QbXtcQK722IZ/GB+SFDkJi/1vN
   UNgOkh1VsGXizwKjHaGfPYGyO5il+2ZfYtGGFA1p97Na6jGr4xYq2Ezsm
   ux78ANrxh9nXAxrw+FqTCBImxO7Uc5TSGHMyDtcxjWKeeh7eBgYIxgisT
   A==;
X-IronPort-AV: E=Sophos;i="5.97,246,1669046400"; 
   d="scan'208";a="326057286"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jan 2023 05:23:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J109eEFjLn227NR8LSwyBhfqkmNFBmHwsZcgvB3p8ZT4aXGX30aTuhmI0AnW/epsgKzjmhzhb7Tkjcvp6Et22v7zUJIUnwtzTXhoaA1wwl/ZFIew/ee8E9uDrXLUtQNjjud86IFTe6sDhHnr6CbTc20yx8FJmfnkrEGDJE69mfGgd5hUVKChR3dgUvsyuwlUUdqXIrPLLqPcPczth+VG1qp+SF1hzgD6Axwyvs6Fq1B6c5AAb0JSdaPnM+9pjUwAL4J897aw0bcWNBA1InjG04JJg4dds0SFZb8pkeKv2OxRoIH/5AgXjtyTI3QN+MIoY720gnSJsiP/nGBAMkPMsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYqgM/RFTQIEJh6LZX5yD+m5PN121bY+E2MPDpJtrLI=;
 b=iluAYCS/07H0Cz5LLBXxpRPBLsZ328nJO/AqbHIn8uaqJ/DhSCUdgedVITWT/w6qDiHCuW3H3oTynzumNNbgR+BTDX52eyQGXqDUDBLUXq/+nItK5sVwDcmMOM2nMUbMsbHAfP8e2T9vbVDHfZTC2hGSIM//CMrJoio0GWvKDhd4m0tb5fD5tig/bC3LXRtPF14YNC7H2tYfQawu9IMH3ahZrqoTekODed/JS2SG/wHeO7PMJTYxhLR/hXtm1uh3Apt+KF5D6mnTw1oOhykSq9BbgSwlHUAdfCmZ+QXVvQ/Tkzm9zAYvWL9iYplAsGTvmBrccb6MH6GCP49kwbY49A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYqgM/RFTQIEJh6LZX5yD+m5PN121bY+E2MPDpJtrLI=;
 b=Muw8fN1odFTBkwHJEluOyyZy+nwhIURu9Vm6IKhtoedxyAgKZwc1A6/qbibv381ip4fGUcsgP85XSC78n0LHtHM5cGZN+BmNsf354GmDoUUQUwetEiBZrCSx5JEIy8de8wSh4XgSnm9OMFbE2Y6z7/B7+mQV3uOlCs/9SpiqMTk=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BYAPR04MB4312.namprd04.prod.outlook.com (2603:10b6:a02:fe::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 21:23:30 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 21:23:30 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Thread-Topic: [PATCH v3 01/18] block: introduce duration-limits priority class
Thread-Index: AQHZMCaLXQP7EDNJ90KbuyJrXRgwUa6t83MAgAAiHQCAABSrAIAABJMAgAASfYCAABSfgIABIgwAgAAuRoA=
Date:   Wed, 25 Jan 2023 21:23:30 +0000
Message-ID: <Y9Gd0eI1t8V61yzO@x1-carbon>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
 <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
 <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
 <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
 <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
 <e8324901-7c18-153f-b47f-112a394832bd@acm.org>
In-Reply-To: <e8324901-7c18-153f-b47f-112a394832bd@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BYAPR04MB4312:EE_
x-ms-office365-filtering-correlation-id: 222cae59-0a34-4d0e-8048-08daff1a681f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SchGHZ+heLXysuNRUEJ6JZv04deAbOeAf5q/L2RruTgfOCOcZT1knM0HFml3WcfIcN1WJhi9OjeNr+z/r01ZL/ofe/R6SEV6e12jepR+ecMGSPx98S/8aWP2UG64iHsJXBOceOqhohxM4ZP0pMDfec6Ut/9WPcTn3p6/z3/IeoXnCSRqp8GfH82qoxhXQlNWY6Au2E8IQeMcqgiJ/GmDb0ew0RJSRepxvH7fDHkrQv94R8YNkioQy+UuSResOSlLzspuLUeh5f857hPyyZ2NpxCq9Mx31YyX95waSea0iu5pMNrw/1T80sGDKpIBK8ASapZArE85VJQT4VJe5Cb7OJ9679wgUC33EUDQk/ynYiir5bSiPoCbfpiabeQY44Tj0ia/vywFSHnVOQrhgsAMMRfKY8zhGTE1NCZUZpKGKq6+SX7Ns17iXZKbEovlZjG7S6UwU9VBLcE7P1DeI8o8y21cREjHhGUc3HkcxdCcfynNYaJC/FoSlYhUpN4UGHm8Lek4FwJf+mjjaUX+ErYRIYNNS2jcJAd4Hka8AKmRzR83pP39FlO8U8SlUaNoNQUZ/KUFAVSHCn2U7TpGr2BlMJUDotvWsZSII1UECXPMPgv8csay/X2aAPmb7coeDyJJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(346002)(366004)(376002)(396003)(39860400002)(451199018)(86362001)(66446008)(6916009)(8676002)(76116006)(66476007)(66946007)(6486002)(66556008)(316002)(33716001)(38100700002)(122000001)(54906003)(64756008)(38070700005)(478600001)(83380400001)(6512007)(41300700001)(26005)(9686003)(8936002)(71200400001)(91956017)(6506007)(5660300002)(2906002)(4326008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: YL61dxGUIq9JPnJQuZHNMl/tIsJFwVBKvk/l7f25fGp3LBitmkL3UDNbBGIXH7/IoFrPQOOCKER07l+WlQda+pYoEGNhiPs8ETQXFhxhxIz+RLIOXrtgsmwy3JwiBTR4J8fwjoW4gr2lexZmFgsj7lm1lUzZtUaHN8qdRuXY68GYuY0bCe+p1xJHL/tGKN6FsKngiKik7UXhZ51DCBbKvxIHoIyTX2Lz97/8arSuVtATBBlkU8NxsFy54tBankZKWNHBFZImcOYik9I7fCWk0Sbisyxyx3n6Zf91LPblwzW7fkmlxLntD+DDUaX+77xYkIyNMPc64Nh1L5zn0kMTSpcDEEARzF15d4IGDCzsUF1AzgofNO1K2RulRqq3IHjdMQLZuo0P5WOFOGNQPTPrDfeT7vOPf7dDNo+8J2g2Ffs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4116D590927AE46AEDC75AEE2C433D6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JdXqIWlqPl/QKQHLz2eUpvMlbi9xSuuHjx6XpHGaFUOg3JHF1rxm76rm9yrFqu0yHRvazVzelbTehOqWnTKmKa+x9OuXDyhEEH2JZLHHaz98nJUBqqOYxf6hoHEGdIkbQxUpf7j4ylpp04p6aQiLkLL9WOhG9fqbVoefWbJW4Gx1oJKtdVphh8kLfqtcSFU4Qmx1WnKnztxEJADWluPwjv48tpn53sp+MrJ4FP/yy78rXY1ho7QsuGlbtn+ezsZJAA0oPfIEpX9Q8cdlhdZzQuFTSKyQ7xE7Pa/erTyBX85M4mb/yuAG0jwolESGnDy3aFWj+IxRcu72S7p44q2Zb1C/uABulz3DxeOgKbOsyaJmIHg5rBFr67mdIN074cilpt7VTd8AQCuZy41yOFyg7BHT0AtUbOC3lfc44O+4jyLZNy8Bul4AEGsBis3fnFz+2PhPiB4TkvlbXcwustJmwnJ19XlGNRd+tsZP1DSiWhmGw3WKsA3T+Yb4D0jGucZx/r5CZVv+Hqj1m1XRelzGsA7lJhk3L/kl7VUMxxlFtEUmSA7xBGH1YHLnGBLHo2aatQxUfAmg8xsxM0Q/nTOi10Kxxh1k+Jj4D0Wd18VGI2GetS/2U665P/bQUklPJwQlgqP7Bjw1A1DEmEUVvKXWq69cj4DKWbY0NRZ/l2m6RFGUbLc3j0TSklhGGp2EKRqGtGrsYiyX+3G2ZnfVk/zkZJuGBN14RWki6LDeE6I9piuq7/wkMTROgMVuMbHLO3DtgE/ol5xC0fKyxJTL/NtEGSFzUTbsMwLgoGBUynLHBbWH6T+z2Uyrax4OlzTpljBK6OM3UO4oMGvCzs+vHyQ0Rj+lPM/JxrABTf6jFs2c7TajpVktlgEO5yNSdstxrszUaGFhuHi0lhDS2XYG9RmgHw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 222cae59-0a34-4d0e-8048-08daff1a681f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 21:23:30.6849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0wnDkhU0hIW1Hi9jsQrztLXyCCWWaaazGY22fkxNwHCH0VYf4kJg2jRal2OVOgzDfXeOBHApd40wHHOLEKuQug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4312
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 25, 2023 at 10:37:52AM -0800, Bart Van Assche wrote:

(snip)

> Hi Damien,
>=20
> The more I think about this, the more I'm convinced that it would be wron=
g
> to introduce IOPRIO_CLASS_DL. Datacenters will have a mix of drives that
> support CDL and drives that do not support CDL. It seems wrong to me to
> make user space software responsible for figuring out whether or not the
> drive supports CDL before it can be decided which I/O priority class shou=
ld
> be used. This is something the kernel should do instead of user space
> software.

Well, if we take e.g. NCQ priority as an example, as that is probably
the only device side I/O priority feature currently supported by the
kernel.

If you want to use of NCQ priority, you need to first enable
/sys/block/sdX/device/ncq_prio_enable
and then submit I/O using IOPRIO_CLASS_RT, so I would argue the user
already needs to know that a device supports device side I/O priority,
if he wants to make use of it.


For CDL there are 7 different limits for reads and 7 different
limits for writes, these limits can be configured by the user.
So the users that want to get most performance out of their drive
will most likely analyze their workloads, and set the limits depending
on how their workload actually looks like.

Bottom line is that heavy users of CDL will absolutely know how the CDL
limits are configured in user space, as they will pick the correct CDL
index (prio level) for the descriptor that they want to use for the
specific I/O that they are doing. An ioscheduler will most likely be
disabled.

(For CDL, the limit is from the time the command is submitted to the device=
,
so from the device's PoV, it does not really matter if a command is queued
for a long time in a scheduler or not, but from an application PoV, it does
not make sense to hold back a command for long if it e.g. has a short limit=
.)


If we were to reuse IOPRIO_CLASS_RT, then I guess the best option would be
to have something like:

$ cat /sys/block/sdX/device/rt_prio_backend
[none] ncq-prio cdl

Devices that does not support ncq-prio or cdl,
e.g. currently NVMe, would just have none
(i.e. RT simply means higher host side priority (if a scheduler is used)).

SCSI would then have none and cdl
(for SCSI devices supporting CDL.)

ATA would have none, ncq-prio and cdl.
(for ATA devices supporting CDL.)

That would theoretically avoid another ioprio class, but like I've just
explained, a user space application making use of CDL would for sure know
how the descriptors look like anyway, so I'm not sure if there is an actual
benefit of doing it this way over simply having a IOPRIO_CLASS_DL.

I guess the only benefit would be that we would avoid introducing another
I/O priority class (at the expense of additional complexity elsewhere).


Kind regards,
Niklas=
