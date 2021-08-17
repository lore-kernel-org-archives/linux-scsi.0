Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C41DC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 04:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 033C960E09
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 04:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhHQEGw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 00:06:52 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:18859 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhHQEGv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 00:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629173179; x=1660709179;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=KiqH/Qinp5KMuz7OTGFCcjnfbalJkougbn4Hh0JLtic=;
  b=cdEdQPU7w5g6e9vG9JNAwRknTHU9kRU/L5zS5ltCYybLdOUUw7V2Iu/4
   iUUzYyxrnU7brJhuDIp8UiHxzpm8584MX8jdjA3l47uMMMUyazVUROmgt
   bASqb9SfLTAIEWLY1WmxvRBiDQ1NBz1Jg1gR9/xCuL1zOyn5N6FfI4n0G
   D3SiTipvyPc7ldx7vI0AcJTUcKdHJ1BPMLu8dn30kH2Kb4oQycR+6ZL3o
   Zrc5yGh95bwCMFz+uMSB2vrwyjyjJnVmHrrV7wcGpBLA7bVTfnA8kALxz
   VAqoFwi8TqKb9vwMkqruqt/JYZjvIULd1/+3Z12CpJCfTuitlVn3vhvAb
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,327,1620662400"; 
   d="scan'208";a="289048709"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 17 Aug 2021 12:06:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDfaAFW+CmmRYpdKl7dBHTlmHn9P7B/TWkllOq8fWVV+BiQyVAyeu/eMdkFi1HaWowUJh1FAHLmx/MHy3GHD5LVbFH6SkcxL7XT6AUktHhEgURrKcsqAFSK+NzU2agcPxi5CB6kXTUqwj4d1gv9jOnCkOBXr1lD570j2NBUPSBZqWa8BeJW96g3K+nhYiCvFe6JtpD2ObamgaZ5Bj8WZIFeGz88bS7MJf8mNoQ7S7q+ptSOgtHibmmQwUPdsT4toCLW5gmDhhHVeMczQcz3Da0+hboWmkTrNAmpsPCDwqCBE4T+QM7NubWw5AhUjFoeKmHVfx0uB9UvV/T6J8A/LoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiqH/Qinp5KMuz7OTGFCcjnfbalJkougbn4Hh0JLtic=;
 b=jJzCWT9T2PmMSrScqLrURwc81ZfdogBy73ZIDTynAEQm5R2sml2qqjEiY+n0Yd3DmzDqwDxM8WgvdhC4zrOs17zGeBRV4Qn9Nt0vy8xOsQgAgj97L39c0zkXbtE+ZnhsYPstFMNxtpNPbObbShL6/sgILdkV9hDQBVGOSe3O8R3YXGZdiGT2GVej6HHrIEpp9IkoJjFLYGYL4T3TORNa/S1aqVWfPCiDrCyui8t2IL/ejDXtpo5BVpBbnzPDhe/G84Ba2nERzlogdIUt218qAzZPJ6jiA2ciDt8nSmLSiv7TmFSc0ZSJlCHXB+OYaDscXRsB+WF19mXBXectE/FxwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiqH/Qinp5KMuz7OTGFCcjnfbalJkougbn4Hh0JLtic=;
 b=OE+xdajuDRGi285IuvItQlV4WTvLPc/ECJJZgtuv1uJYMthOjiUeNVas3fqI4TyBbX1H3ESNvaJEold0vh55UQ3nKGYLKtnGKpZ0mXj9XSekS5B0hi4vyHiuyBkhf6Xv+oefQJeF0yxhC+tsyL/OF9jFTWS9LIgN39mYBJM4tR8=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5564.namprd04.prod.outlook.com (2603:10b6:5:12a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 04:06:16 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 04:06:16 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXj060+x8p8fG9EkmgObG6vBUOOw==
Date:   Tue, 17 Aug 2021 04:06:16 +0000
Message-ID: <DM6PR04MB7081F31C7933E6C50E10CBB3E7FE9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
 <yq18s11qqfk.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4aaa0aa-7132-4e9f-e4ec-08d961345c80
x-ms-traffictypediagnostic: DM6PR04MB5564:
x-microsoft-antispam-prvs: <DM6PR04MB556419F73CC92AB85F27BEE2E7FE9@DM6PR04MB5564.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y15JdS1KcxjTp9/SUgJkNOBxF42pygtTO1zjiAygrhREsUnLDZB7m8r5fv+E3i40YA2i3S/y8cN2HmCxSfVG4p0UbpXnqevu972aJ3HCDWoyoN5BTPR5dQsJQkWFp4g9nEI9WVPIxerfAZF3igCQWYtJPJQemmXtIhUNbglX72wt+73VWzfqZEInuJPZXyVbODvwGsXABg/zd6ygXxdzmlBcl80gxsufHd5jy9Qr3rnAecu8dLKL1wVkNr19bed9VS5slZCgk0tz46KzsSdna+/p4cZk1N70Dc52JTXZn1haEKfgZPrE3Fq+fmspg/O/Vw1kT2QSNYgIISooPhwUwu9yaNEw16qWrXh7xr6i1KbZcojIKkaNjq18dfUU/iotnWjaxmS8ss8n4Cp9vGxNiJDk6g4y7wEyrjfiB3gsE3y/YmDT+LxZwxHJ6aTjXzrnyD2CFWYwP5gKm3/6J8TXL8WIi1Exs1nZ979S8laPXbc3HFVEcRg9hw3X386Ebzs9TmSpIXuAv9RO4KT9t8fqBKEOJ+0oq7TLtTKZt7t9yzYOZPGzAEkFazRpu3EvrjjKEe/PXy1khvPgFsl5S2r7dA13D6eTtol31fYua/L0Ur55497lpXbZmK+v0qly0swJDA/5lC4EZ1Xm9lGgHdpQoaAIXuurKAz2Jjm2m9wXe2ZUhM+zzTvRV6gCGczv6K38RaTlHZXyCiI+FCkMsdsmnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(52536014)(6506007)(2906002)(9686003)(86362001)(7696005)(55016002)(54906003)(53546011)(6916009)(5660300002)(66446008)(64756008)(66556008)(66476007)(66946007)(316002)(478600001)(71200400001)(38100700002)(4326008)(186003)(122000001)(91956017)(76116006)(33656002)(83380400001)(8936002)(38070700005)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8VEjYF06/AjcqCMOVJVmaK2BR8A7MDiCqHjiyWtBGRjzMT/sYt0wCXxxhtQO?=
 =?us-ascii?Q?irlsSBYA+wyOLO8ll2924vBnoLuqgg3BClUDDxZ7/3/o6UQHlOReKH2WsMts?=
 =?us-ascii?Q?BSaU3XF3y82mH3Z8Z0kwT1Dyn257+ntnLmB/WHxvAkBhuVLoQ4MPFK5wtg9N?=
 =?us-ascii?Q?66fO3IsQgMLp7GH8CBgv2fspYFOdGk5YPFnObAAp7OHyheAqngd1pVINNw2Y?=
 =?us-ascii?Q?6UqJsp82FGP2iVGAE25yAGoqjE61ScN4p6GcZX5sVvqMzIMFr1aDhVpfhhN9?=
 =?us-ascii?Q?xt5GKHrcucf/NSH3c6qDkBsy1G598zWOVJA2+3SNUo1GkOyrqOrlwb1o9Jud?=
 =?us-ascii?Q?sDOjHzM0rfEY5Opo4JIcvCVRM/ki2E4GxQFY2/h6+1nex2F7YrdUXmA+GDBm?=
 =?us-ascii?Q?41UN1M7Eaa/YuN0Gi1olLUppC06HnanN4+fXlIrQt2A8EF36gaQ/jjgvCZig?=
 =?us-ascii?Q?YkyaknpweHrLyQc2MeEU6Lnqp3vtvX0RXlaNpm3vaoDHffarVvNYYJM4qHMY?=
 =?us-ascii?Q?QCc4hgG8WOlIW8NldKMdTAx0Cy3dHrRWBK+ZF8ven3VyFCX3e4SgiPZavMZ9?=
 =?us-ascii?Q?ULnUzK0BjGzg9W2Fp+5QXv3eSmYgiKnSa36cLHHopRITAQvr+1In7vHZ+9A+?=
 =?us-ascii?Q?DvtmMBnE89Eo4+gbgef8ApfS1ezdyRX+flu7QDT+fnqvJchpKOsq67nEXFkL?=
 =?us-ascii?Q?ER+palTTusgoSPseBcJH3n067tsq3lSP70kYWvJ0l+yApZQJj8+8G9evKySh?=
 =?us-ascii?Q?Lkg5RY+2q1z5bNSV1LWLRZYwoGyB8u8I6mabe2kujQwOljJY+IEFUi5mBkNa?=
 =?us-ascii?Q?b1JD7RDW4OrcLVYGPAePQPXSfZ61Wg5Me7w2yYwa01PUJAOERrfz0SBxukVL?=
 =?us-ascii?Q?BwF5YRDDiYDHun67Co1ZnUVRlZVcRCke7ja+cPi+pUGbuBSjwjQWmaEZYpb3?=
 =?us-ascii?Q?I17lALghIp2wU9UGxgu0cfk9eBhaM8RPn2Lufz3iGfDML1DMXyiVU1UUFSXn?=
 =?us-ascii?Q?hvbdCB4rcvin14JtyYZ2b6g8lEoL8loJbXPXy2fP3XuW3Zf12AXX+BKY5roC?=
 =?us-ascii?Q?mohQhlxjN4uhbPEw1k1xQ7JNLjUB5h/SGIu5wEqKjEqxbknYhNUuHu1pzvEP?=
 =?us-ascii?Q?VsDTIE096ThGdH0cihE+L2pKqzPcjgk4h0in5Z3ov336wHODPxoEgzqEf9Jx?=
 =?us-ascii?Q?sWXpVTPQQps+tQWSS+2WOQfw1zuiQUxs/kxd3CD1ZxTS6d79UiDZbfF0sfd9?=
 =?us-ascii?Q?LbXZ6tpIkzDha0kTCCQ0ztwlMJR2dIwF7THmdtSjT6EqofIry22yQi14b28t?=
 =?us-ascii?Q?XPMM4MWrOm2Nptq8qYryQ/AWVvnS9hsqAHBGTFM0MMI4kPXUFIfXuzlITDJO?=
 =?us-ascii?Q?sahhSxEDWfe1LvIngMiHKdVLedK8zWCanV1C5IPOOWea2gX9Nw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4aaa0aa-7132-4e9f-e4ec-08d961345c80
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 04:06:16.6456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sshqbujE70G9cCzHr5Tw/+33JIaVeRkZMvfsimgpRPxbuuR6lOCFDOcyxbvLfB5SPdOwjZkAGlbAT1AirZeVYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5564
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/17 2:10, Martin K. Petersen wrote:=0A=
> =0A=
> Hi Damien!=0A=
> =0A=
>> Single LUN multi-actuator hard-disks are cappable to seek and execute=0A=
>> multiple commands in parallel. This capability is exposed to the host=0A=
>> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).=
=0A=
>> Each positioning range describes the contiguous set of LBAs that an=0A=
>> actuator serves.=0A=
> =0A=
> I am not a big fan of the Concurrent Positioning Range terminology since=
=0A=
> it is very specific to the implementation of multi-actuator disk drives.=
=0A=
> With other types of media, "positioning" doesn't any sense. It is=0A=
> unfortunate that CPR is the term that ended up in a spec that covers a=0A=
> wide variety of devices and media types.=0A=
> =0A=
> I also think that the "concurrent positioning" emphasizes the=0A=
> performance aspect but not so much the fault domain which in many ways=0A=
> is the more interesting part.=0A=
> =0A=
> The purpose of exposing this information to the filesystems must be to=0A=
> encourage them to use it. And therefore I think it is important that the=
=0A=
> semantics and information conveyed is applicable outside of the=0A=
> multi-actuator use case. It would be easy to expose this kind of=0A=
> information for concatenated LVM devices, etc.=0A=
> =0A=
> Anyway. I don't really have any objections to the series from an=0A=
> implementation perspective. I do think "cpr" as you used in patch #2 is=
=0A=
> a better name than "crange". But again, I wish we could come up with a=0A=
> more accurate and less disk actuator centric terminology for the block=0A=
> layer plumbing.=0A=
> =0A=
> I would have voted for "fault_domain" but that ignores the performance=0A=
> aspect. "independent_block_range", maybe? Why is naming always so hard?=
=0A=
> :(=0A=
=0A=
I did struggle with the naming too and crange was the best I could come up =
with=0A=
given the specs wording.=0A=
=0A=
With the single LUN approach, the fault domain does not really change from =
a=0A=
regular device. The typical use in case of bad heads would be to replace th=
e=0A=
drive or reformat it at lower capacity with head depop. That could be avoid=
ed=0A=
with dm-linear on top (one DM per actuator) though.=0A=
=0A=
As for the independent_block_range idea, I thought of that too, but the pro=
blem=0A=
is that the tags are still shared between the 2 actuators, so the ranges ar=
e not=0A=
really independent at all. One can starve the other depending on the host=
=0A=
workload without FS and/or IO scheduler optimization distributing the comma=
nds=0A=
between the actuators.=0A=
=0A=
The above point led me to this informational only implementation. Without=
=0A=
optimization, we get the same as today. No changes in performance and use.=
=0A=
Better IOPS is gain for lucky workloads (typically random ones). Going forw=
ard,=0A=
more reliable IOPS & throughput gains are possible with some additional cha=
nges.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
