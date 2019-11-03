Return-Path: <SRS0=nNaJ=Y3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C05CA9EB0
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Nov 2019 23:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1863921D71
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Nov 2019 23:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="P6C93TEv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="F35nGXR5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbfKCXlV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Nov 2019 18:41:21 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64478 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728100AbfKCXlV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Nov 2019 18:41:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572824480; x=1604360480;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=FjbMQJA+PDaoGe1ecwD7f+W6g1PYMWWc8dgTsvNMU6I=;
  b=P6C93TEva8R94+JKqvojHR5vzENDUiuVuHxoT3dU4EnP1cle6AcVN3mO
   LC5MrJTCb4P1uIYMnhIvDU6tIpBrNDRzUswDKXWhqxbzKdqj+SQs5wqvR
   h5sLAGO/jPGHdBT6QsrwaDB+UaGR431k3pkqQW99QjJd4ogZkEpVEAQtI
   V+Q4fwx0pdQK3dFtCwj8YNWkkF0dOH4YknfXSzrKXAXzObMtMdzUB5DWO
   GOUssSz7pkMIlox3ZEb7Ww22/fg/c23leE/5Pg2DO7SX52mZ48AheXlEs
   4icQCbI48/V95LY/PpA83oFheprgtnQCjfFfTG3ViRSOdIWVN7SmY+HhQ
   Q==;
IronPort-SDR: 3RA3metdOtbRAnQPpBez5/glnU7eC9ZYTCaImobvQtRz1ziPNnvGGMEskqMRL07Tkx0rqyrEYz
 SsuTFatMW7TZzyfWBMtXcmJeFjoJKI26GcRIPknpj5v9KmI+f/qULA4RGDoH+RpeBkUs3/58Po
 uZpG3oxXVDWEQTYRWXH64Oi1hZgs2OPOmU5hXlTnRjYAY+xKLiSYfbK3/fvQvui6iuYnPz+Ju/
 MCPcmyZ0TeEpBhN2pxwFvJskxonjcoEGEnXxMgkGQew8/fbT/WMZyBcOda/c2W97S6NCZ5Rx/b
 GW0=
X-IronPort-AV: E=Sophos;i="5.68,265,1569254400"; 
   d="scan'208";a="123601446"
Received: from mail-sn1nam01lp2050.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.50])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2019 07:41:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3FfZiUEwR0ikCYf1/fB/Ur7sM09YP4F1yR2ZinEkcn2q2y1RMtlfQ0Y1n39OZOReADne1ChvfWOWW1ff/fhdnJqyB5OVn8/TD1hq5UNIAdNV/bJS2NIe27BcKBojSiJgxNc3auC1g8+688xuTYHRyJQ1LaTa34es59u7vm6bqv7Q6W+TlDXd0G+csVsZGjptd7FyKjl5SYjrEW9dqZRRA2/eJyZH4ODOJQrcXuWjfckVpTTZ27mbNvU56RgrTF6oddEnhygZQ62x9rgfnqOY1to8aaIiKYSGh5VSHRAbekstS7RVKzFOCD6Qp1gyTOvRePMKJJI9DIUPWVRcQshTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjbMQJA+PDaoGe1ecwD7f+W6g1PYMWWc8dgTsvNMU6I=;
 b=Da5Aw1UFci6rzsPdmTLmQohBPn7hrBvn22R0RJoxIugADW+kACC31T/jjmMlJouTaF6hRrtO2NcVMtDe/vUz1Ep0qdH20keSw5CN3oaR1a0yU+7fCDsKLJb0GVaqBSoLuQJe2PVg4CIuGsdUaZOakSSoB8w84n5RDHqjt8QlvffS1uxwLWnoj3horifTU6FFxO5NNEXn44t8DUKEAKoPPcAp3AXC7G52cXyFSvZ4ieGsyMPKvhSnqtuDkwHB4h9NjNDwqFFIVaqOLM7m+urgbAD+Z2VAUHeu/99pHBHJTdpwq0ABSZgwzFFxS01T4FiSHjebqk0BjWhkieRF8f3DEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjbMQJA+PDaoGe1ecwD7f+W6g1PYMWWc8dgTsvNMU6I=;
 b=F35nGXR5QBrAfdxTQAwazlN4Q6DKGmNTmyjPlvGBe5uRS+ytEX7hru3BBIpI+a+e45lpucGMsFY7/mgIGB952SXJ1yA2XoCPfxmW73QqRGV5vJVbRbWWPEgk5xuOxg5QuW1qVFNC85AaWQ/KjLbfVkzy9gWRY2PkuDOYwyBGUGU=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5734.namprd04.prod.outlook.com (20.179.57.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Sun, 3 Nov 2019 23:41:11 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2408.024; Sun, 3 Nov 2019
 23:41:11 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
CC:     Ajay Joshi <Ajay.Joshi@wdc.com>,
        Matias Bjorling <Matias.Bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 0/8] Zone management commands support
Thread-Topic: [PATCH 0/8] Zone management commands support
Thread-Index: AQHVjM+oAfCMB+wY1ka3IBKYRZIZ0Q==
Date:   Sun, 3 Nov 2019 23:41:10 +0000
Message-ID: <BYAPR04MB5816539DCBED2D2C93254D36E77C0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <926948c1-d9a0-4156-4639-bbac1d0ba10b@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a88d0958-bd26-4d7e-b958-08d760b74e98
x-ms-traffictypediagnostic: BYAPR04MB5734:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB573452863D7844CA4245D21DE77C0@BYAPR04MB5734.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0210479ED8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(189003)(199004)(3846002)(186003)(86362001)(25786009)(14444005)(6116002)(256004)(2201001)(99286004)(81166006)(2906002)(9686003)(305945005)(486006)(66446008)(66556008)(66476007)(476003)(64756008)(66946007)(33656002)(8936002)(76116006)(26005)(52536014)(4326008)(5660300002)(8676002)(81156014)(74316002)(446003)(6246003)(6506007)(7696005)(76176011)(2501003)(66066001)(316002)(110136005)(14454004)(54906003)(71200400001)(229853002)(71190400001)(102836004)(6436002)(478600001)(7736002)(55016002)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5734;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eOzYf57toL1AKGCDZx++mIWl7VMjC/ZgcK5/bZtLQ9oCKJMHWpiFbqYc/mUwywpIHosKzKzaYWJKa83J1nTgNL2BNqkNtZ7vIGmZ3GEDg2jgr3UY51gbxguXRldTbEBEW5RyXSGpC/HT/3xlS3bRo7djhMTZj9wRvyrsS4dBnLsCPXoN9r193AsJhqOvc2eD08BovH6exUnTkstkHJY5Sdn3/zaoxvkccNoO3zKCwWMLjyNzMm9jx0VNQi+LDsHCPa46wG+57gpdhFbTkxSqbRgN9q6odvZFMdRmbpG0avN4eczSpg4G5QjzYjOLSWbwQSUe6yJmYkxkt0oMljbpbH9z+XySF+QllfVNnX14enRI0QpLoVRiRbT9NDk7fnb/Tajet90uQc/NdASDQTtHEKn3y/7MymEzI3/Wg2QQtwp3W7I7H2p0VaXTskPo29gn
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a88d0958-bd26-4d7e-b958-08d760b74e98
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2019 23:41:10.7099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Ijp9lkpOM5w+1pqWaDL1i+EX2fnRSsxfdicJk18jQVvihj6bN6kpCR+bx/naevzyCPgZxzudncBy31lw0t4Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5734
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/02 4:01, Jens Axboe wrote:=0A=
> On 10/27/19 8:05 AM, Damien Le Moal wrote:=0A=
>> This series implements a few improvements and cleanups to zone block=0A=
>> device zone reset operations with the first three patches.=0A=
>>=0A=
>> The remaining of the series patches introduce zone open, close and=0A=
>> finish support, allowing users of zoned block devices to explicitly=0A=
>> control the condition (state) of zones.=0A=
>>=0A=
>> While these operations are not stricktly necessary for the correct=0A=
>> operation of zoned block devices, the open and close operations can=0A=
>> improve performance for some device implementations of the ZBC and ZAC=
=0A=
>> standards under write workloads. The finish zone operation, which=0A=
>> transition a zone to the full state, can also be useful to protect a=0A=
>> zone data by preventing further zone writes.=0A=
>>=0A=
>> These operations are implemented by introducing the new=0A=
>> REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH request codes=
=0A=
>> and the function blkdev_zone_mgmt() to issue these requests. This new=0A=
>> function also replaces the former blkdev_reset_zones() function to reset=
=0A=
>> zones write pointer.=0A=
>>=0A=
>> The new ioctls BLKOPENZONE, BLKCLOSEZONE and BLKFINISHZONE are also=0A=
>> defined to allow applications to issue these new requests without=0A=
>> resorting to a device passthrough interface (e.g. SG_IO).=0A=
>>=0A=
>> Support for these operations is added to the SCSI sd driver, to the dm=
=0A=
>> infrastructure (dm-linear and dm-flakey targets) and to the null_blk=0A=
>> driver.=0A=
> =0A=
> Can patch 3 go in separately, doesn't look like we need it in this=0A=
> series?=0A=
=0A=
Yes, I think it can go in now in 5.4-rc if Martin is willing to take it.=0A=
That will create a small conflict in your tree for patch 6 though.=0A=
=0A=
Martin,=0A=
=0A=
Can you take patch 3 now ?=0A=
=0A=
> =0A=
> Also need the DM folks to review/sign off on patch 7. Mike?=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
