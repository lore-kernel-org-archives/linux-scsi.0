Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC39C3404D
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 01:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E9224656
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 01:53:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kMQXFD6a";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fhHfbZQD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgBSBx5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 20:53:57 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:30716 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgBSBx5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 20:53:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582077236; x=1613613236;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=C4b5MbHB+/G8AHIkSZVnnaiTZrkK6rScfUNtJNqV0rk=;
  b=kMQXFD6aQZUaKHfPtSZMN5Vr52z53Exqso/flakpQFBl02wojVRL4FFN
   wA8U1wwmd6sFkE9JGXllI78teymw7kvIpU3UepMGR1ffVv+teuX5a/OWW
   14MkyFS9ugSc89VuL0MprzM1hiSpoTL8NyCfTaKbbRRtxj44UFKOfsvwj
   ER0YD7LMbCwfrKm9m+Re8CHxvppKk8auK4BJeeE3itOk1RHBuTBh4FasG
   l2DaKqV52HsXEcd/JnSZYbEHJbcpYvUFUzi4DdKxfiIHtzFsnQqWHhbRr
   Qeak1IAqfXeSnda5QJYYjD9Uacp63F1glcyAxaLtNatTUdX3+qHnvosu3
   w==;
IronPort-SDR: ZXDjF0MMVF9XmbsubOVkwHNV7d3eP2ycJz+QFBOoEgue1tsXg+RKWVoxz6wRL6SVJIWZDgc68b
 pBUCenHHVsDgayGZ3iO5RjzVqf69e4r9QoKxNwkmyLIpoYRx1PzIwTm4e66+hga+ibDoEdjV+G
 8C66MoNJmRmOB1/KoiLaRHBFVyLVg0RI+YZ3zdaYOpyhJUtO07GxBiJtBnGUBS4Mhqug3Vvua5
 L8pArMMrSwav+L1xU4gfRhgtSqHWw+uXGaCNsXtCgLX2H75VVqLo8sc9Lcdk9pk2h8WvAs1Nig
 mcw=
X-IronPort-AV: E=Sophos;i="5.70,458,1574092800"; 
   d="scan'208";a="130137500"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 19 Feb 2020 09:53:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wdqjo3xp+IyNSAcOmlU4QZN0RLRHM5BnVnG3Via9jFKUDLWGgLLvrht0oHnr38gZsE7YAB5Waac/FAAagSRki6Xa29iN80l4RY0d7nJF49m6NT+OlU341BxegpiWoi49UMQ2sAf0GBnG1IuFT2tj+y2fKyTob0J8JJlzBc8PGAulDQtV/mRsxllGHS2azduE7VmdJ3RwKRfGXb2HDYT04I8hNfrJdk0fM0W9OFCCc4XCKu4jmolAStfJ9vbXCvBGB3JYkRg9QVYzZ3LNqotjWJeJIve++9nQf1jIs9kq7OPZzZhiF/kNSv+cRcUXHzt6u1cLff86gl5jqvH7q9wFaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvxZxGHWq3pe705JX0ZYr7NqUDqcD3Lx5P/PsvXP0gg=;
 b=nFx2CL19+oOzuxYBnUlqb/9TwkxOcOBke8S91Wb3zsP1gaNblz0kvo4S/lEDk+N+I1EYpp+5xUJYKnfkvArvBrHL9FkuceopXaCKjxjM3EamuoGANQg+tdCMzXfs2+or3VEMPsICHy7ywXEiQCnk7aTPR7YcXEZLr0X++0KRl8vYejZuwXRNLZyIbKNg2J+jpG+NJz/jEK8od/PcEBxsZLtqmdEuRxA9DLmhlV9X73MUjEB7L5WoTA19B3Iz6Edazf9Mhg/tq+OLQJK7t/gtlPf1srOtS6Mtp2ultslkyClE+VO/DJxO5tCUCziAvLx38WMTn17HZuvRhMUCFpPVrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvxZxGHWq3pe705JX0ZYr7NqUDqcD3Lx5P/PsvXP0gg=;
 b=fhHfbZQDHsydXP6IMg1yZz4khxZLuAB0oMyoAWwyZPwq5gJFZxfkiNgdfuLS5IaR2bXusYqUk5fKz+FALbJ5AHX2JSfKETV7a85DatrJwj5+6H0rpew2GLGVdYW7Fjsi57jrwvZlvMbzooXY0yBBKgjZi9Rt8y7i77j0D2YZTg8=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4760.namprd04.prod.outlook.com (52.135.239.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Wed, 19 Feb 2020 01:53:54 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2%6]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 01:53:54 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>
CC:     Tim Walker <tim.t.walker@seagate.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Thread-Topic: [LSF/MM/BPF TOPIC] NVMe HDD
Thread-Index: AQHV4EctI/0h/tDOq0WOdKN0iYUQSA==
Date:   Wed, 19 Feb 2020 01:53:53 +0000
Message-ID: <BYAPR04MB58165C6B400AE30986F988D5E7100@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <yq1blq3rxzj.fsf@oracle.com>
 <CANo=J16cDBUDWdV7tdY33UO0UT0t-g7jRfMVTxZpePvLew7Mxg@mail.gmail.com>
 <yq1r1yzqfyb.fsf@oracle.com> <2d66bb0b-29ca-6888-79ce-9e3518ee4b61@suse.de>
 <20200214144007.GD9819@redsun51.ssa.fujisawa.hgst.com>
 <d043a58d-6584-1792-4433-ac2cc39526ca@suse.de>
 <20200214170514.GA10757@redsun51.ssa.fujisawa.hgst.com>
 <CANo=J17Rve2mMLb_yJNFK5m8wt5Wi4c+b=-a5BJ5kW3RaWuQVg@mail.gmail.com>
 <20200218174114.GA17609@redsun51.ssa.fujisawa.hgst.com>
 <20200219013137.GA31488@ming.t460p>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 033d0c78-a9cc-484a-a91e-08d7b4de9322
x-ms-traffictypediagnostic: BYAPR04MB4760:
x-microsoft-antispam-prvs: <BYAPR04MB4760EB1B70F5A1BB8FEDD76FE7100@BYAPR04MB4760.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(199004)(189003)(71200400001)(81166006)(52536014)(81156014)(478600001)(66476007)(8936002)(66446008)(55016002)(33656002)(8676002)(7696005)(64756008)(66946007)(66556008)(5660300002)(9686003)(4326008)(86362001)(186003)(91956017)(76116006)(6506007)(53546011)(2906002)(26005)(316002)(110136005)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4760;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eXp7Few2syXh/r5sKhOljXJKTPslk5L5GoR42Mwa25AzsviJ1QTdYxCDS0O8m1mYD9FPNGg/m8zrDSska49hrjyOdfG8hB1A1nYD6Q+NtuqaLtMwTMeowL8fX8WnWRJwKYqIoLbQR+4mV6PQW3O3487DXnJdStJDOlZrv4c+p2nTElHbRVTdr01mKYxeque39xinkxjFe1aOHg6Td1PDhkEXHRqRN+c/XlT6DONLqTV7kq897c7vRBD4cZDHktc26yC/HEkG+gGlSIIGmngH2h+AY0eWqye+bc8eBxNw2dFHqJzYZDGW5bNvabcLm7tttUy/M9d6hHhNbDrZfPK8I4764GKp8k/QuCyAr2l1PL8zJC4PsCI3z7900XBmylYhY+OXBmEARmFlGLZUWcel+D3l3bPTlEYWFlnBI9fFG+gf+NeaWsZeg44e7vAo7yaE
x-ms-exchange-antispam-messagedata: ZFZ3SS4ip2+WF1Q3SBOG1sLsxVQGdypxOPPXTK6sjTi4tD9YFoNmJ4hIxNNsgIn/n9LzXThHDRpbOFTzi9b/GkWoYqwmnR686GMrOhMHZm9eeB0VMT9RBPkHKfDa6ZBciKg9knPAbMOPIjfSq0+vXw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 033d0c78-a9cc-484a-a91e-08d7b4de9322
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 01:53:53.9007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4xloStyw3MJ6IVVc9SddOgSeOwXaPjl+obzIjbHc/opHu7pvqy7ZCD/gb+VDPaMJ87WDOB0bi/+v8EjhONb+5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4760
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/02/19 10:32, Ming Lei wrote:=0A=
> On Wed, Feb 19, 2020 at 02:41:14AM +0900, Keith Busch wrote:=0A=
>> On Tue, Feb 18, 2020 at 10:54:54AM -0500, Tim Walker wrote:=0A=
>>> With regards to our discussion on queue depths, it's common knowledge=
=0A=
>>> that an HDD choses commands from its internal command queue to=0A=
>>> optimize performance. The HDD looks at things like the current=0A=
>>> actuator position, current media rotational position, power=0A=
>>> constraints, command age, etc to choose the best next command to=0A=
>>> service. A large number of commands in the queue gives the HDD a=0A=
>>> better selection of commands from which to choose to maximize=0A=
>>> throughput/IOPS/etc but at the expense of the added latency due to=0A=
>>> commands sitting in the queue.=0A=
>>>=0A=
>>> NVMe doesn't allow us to pull commands randomly from the SQ, so the=0A=
>>> HDD should attempt to fill its internal queue from the various SQs,=0A=
>>> according to the SQ servicing policy, so it can have a large number of=
=0A=
>>> commands to choose from for its internal command processing=0A=
>>> optimization.=0A=
>>=0A=
>> You don't need multiple queues for that. While the device has to fifo=0A=
>> fetch commands from a host's submission queue, it may reorder their=0A=
>> executuion and completion however it wants, which you can do with a=0A=
>> single queue.=0A=
>>  =0A=
>>> It seems to me that the host would want to limit the total number of=0A=
>>> outstanding commands to an NVMe HDD=0A=
>>=0A=
>> The host shouldn't have to decide on limits. NVMe lets the device report=
=0A=
>> it's queue count and depth. It should the device's responsibility to=0A=
> =0A=
> Will NVMe HDD support multiple NS? If yes, this queue depth isn't=0A=
> enough, given all NSs share this single host queue depth.=0A=
> =0A=
>> report appropriate values that maximize iops within your latency limits,=
=0A=
>> and the host will react accordingly.=0A=
> =0A=
> Suppose NVMe HDD just wants to support single NS and there is single queu=
e,=0A=
> if the device just reports one host queue depth, block layer IO sort/merg=
e=0A=
> can only be done when there is device saturation feedback provided.=0A=
> =0A=
> So, looks either NS queue depth or per-NS device saturation feedback=0A=
> mechanism is needed, otherwise NVMe HDD may have to do internal IO=0A=
> sort/merge.=0A=
=0A=
SAS and SATA HDDs today already do internal IO reordering and merging, a=0A=
lot. That is partly why even with "none" set as the scheduler, you can see=
=0A=
iops increasing with QD used.=0A=
=0A=
But yes, I think you do have a point with the saturation feedback. This may=
=0A=
be necessary for better scheduling host-side.=0A=
=0A=
> =0A=
> =0A=
> Thanks,=0A=
> Ming=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
