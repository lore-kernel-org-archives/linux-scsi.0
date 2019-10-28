Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96713CA9EBD
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 08:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67DE020717
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 08:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LmCVWJ5P";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="X0Vio+hZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731611AbfJ1IhV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 04:37:21 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:33110 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbfJ1IhV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 04:37:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572251839; x=1603787839;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=9pdK8Jr2WaWREdNkygw/hgHrgPzOcH5R3qYvjzfgex4=;
  b=LmCVWJ5PaQ70PTnYHFeVXReQEeP9csQn0p5yTumHUmHOWyzJGvCx/+SW
   zIYy5zhQ8c/F7DbwrFQFiCORet5EtdIjaZVfrRVxvE3b3+jESq9GYL0KM
   e9e+OpuKUtNx82NCYR8RJdchofb25xJGEm9cfjXWA3g71OdjHVQqDnN6/
   h4DFhLtwhc3ClnN/mBre2dYQjTw3g5vSO8UUaOlrhd+AQzzIREBXKw5Jh
   rNA0kFDOwkC4hpJCZn9KyXTUvS1oNrBrm2xsbth8kDiUy4+hU3yDSZoBY
   auN/rLb7OH7B665vET/E0OmQFLlJEotVxAw6DaXgMJfv7Cfa5OYWabnQ9
   w==;
IronPort-SDR: vP2huSyLzmL9SBOzCZwGBvjUIwsLHDqnIrgfKkXmgfod8WbgMlUXhg/pkoOKBDfrlRc18F5M3e
 v+u8Xb4irs2AtFOeMFiXy0WpHh/1rlFAA2PnFZKQ57qwMZouSRwdcZUxajqgGlJHFx07BeXm8R
 QawPMRn0Wi0lUStH7sc1ucuESYxjhjoQkvEMjQlrYwFGvuxrlCblKNd01Wg/sPEV2GZ4ibEC0f
 7iUCCRPxIY/PfYDKjgMnfH93hjsP9wRiQJ6L/V8cyZCjkjm/cLAUc4o+3Ar8A3+6qx9iIyBz/0
 AOE=
X-IronPort-AV: E=Sophos;i="5.68,239,1569254400"; 
   d="scan'208";a="121475485"
Received: from mail-sn1nam01lp2056.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.56])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2019 16:37:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnsti05kWVfPuTFYZrFOt7Y7lIoLoHsSgizejQcSuOmT9k8JHgTqPn8n/cBVabwkSV8NGY5kiR7181NjINN3WEXcWBQr1nfiPppp82qSQsScU9LkUh86HfOYl/GgGHds/i39Qm/WjVB06bomBrukGGYzCIyvMlNCFU9F40Inh++wsquKP7mAlHhRiuUTLwHrKQsaJXFJ0dL0b5NJIwZ1XPQ6MQZ10rT7kwqd1BcLLtTH9epu1608Z9YwbCMmVFdALmw6n6mreyAnZ0+trHuy0wRQXn74a0GqMpviRf5ViZq7vys0YVzeJypPAqdyQQQJNJmyUKJnGbukdEQrHQ1QCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kF5ytKXf+nfALUb1Z+1xM6JY649ZfGyWfvaT8rmMiP4=;
 b=l5cDqiK48zkREzpHGXClgsya+k9uj7tRz6UyTmvtkx973Eix5ERc8wwwVzur1DTW9d5091sV6UmmdMGnZjrEKQ1rz4qbn4ECtQFQg9qVaFBvKmgBkotm7BKAMBIHWL1M18/Z7qfjkNV2BZhDx2WiqQhiUCpOLnih6n4Dq7aQIDNBqkIL+zoARIH1YjP1OUI09xvwBRfcX0q8PBP0DejB9+TD7R0r1c4fPG3WWaTBGO0Pptsnv/qVTD7VUF5S4lqVh/9ChREuruvhImn42N4BPrHjSswgaPb33f6N4/Zi0f9rwJ3oKjaEWObevCe3eYCXKrqVR3G0zSdn608VK3AVAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kF5ytKXf+nfALUb1Z+1xM6JY649ZfGyWfvaT8rmMiP4=;
 b=X0Vio+hZrs0prmTfxfHW+fpkJJdqbvefd3hCdIFrLcUv+bJiin3v+sX5/JW3YI7xTJMlD22tGbBPComT+xeYDvdGLmqM+Fsb7yNe3zgzkA3z55fhu7ABgwlVeg23YIFGf2Zo069AYXMBG/CnQO4A/TOVpm/8DjkqUrRkkUyN7dY=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB3813.namprd04.prod.outlook.com (52.135.215.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Mon, 28 Oct 2019 08:37:17 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::34a1:afd2:e5c1:77c7]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::34a1:afd2:e5c1:77c7%6]) with mapi id 15.20.2387.023; Mon, 28 Oct 2019
 08:37:17 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
CC:     Ajay Joshi <Ajay.Joshi@wdc.com>,
        Matias Bjorling <Matias.Bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 2/8] block: Simplify REQ_OP_ZONE_RESET_ALL handling
Thread-Topic: [PATCH 2/8] block: Simplify REQ_OP_ZONE_RESET_ALL handling
Thread-Index: AQHVjM+qshxVC7ah2EOUEKAVKMXumA==
Date:   Mon, 28 Oct 2019 08:37:17 +0000
Message-ID: <BYAPR04MB57490F22E67DC5B172A3A9FE86660@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <20191027140549.26272-3-damien.lemoal@wdc.com>
 <BYAPR04MB5749C25A8558C0ED9AB3EA6786660@BYAPR04MB5749.namprd04.prod.outlook.com>
 <BYAPR04MB58160668CEB54919B22AC2FBE7660@BYAPR04MB5816.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.44.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3578688b-6dfb-4220-a1df-08d75b820ab2
x-ms-traffictypediagnostic: BYAPR04MB3813:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB3813BB24733CC3D2A9C850B386660@BYAPR04MB3813.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:632;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(199004)(189003)(486006)(476003)(6506007)(14454004)(446003)(53546011)(966005)(7736002)(6436002)(66946007)(55016002)(9686003)(6306002)(66066001)(54906003)(76176011)(66476007)(25786009)(316002)(305945005)(45080400002)(76116006)(74316002)(110136005)(64756008)(66446008)(66556008)(478600001)(26005)(186003)(8676002)(81166006)(81156014)(8936002)(102836004)(7696005)(99286004)(33656002)(256004)(71200400001)(71190400001)(6116002)(3846002)(6246003)(86362001)(5660300002)(2906002)(4326008)(14444005)(52536014)(2501003)(229853002)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB3813;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MxJG7Pfm9HUStjoBxW14XdyAP90l31fy8mCVtWRDlRcAejRKcJKA7Gc7zRq4jnpU6WrsXsNOdmqsXa3+5V+N8WgLk0WEGaVG2kel5XfrcPXt40l4qAuByiPR0MpWVXiTEDGo+HkYfq/vM4GfVeSoB0Z+wAXvFnnpY1XvfFAn8VdMFq+jryY9bUlWOyEUCx3u4zsqT5I+KzQR1KnzFfsUBjiM/f3ian9aluG65zZaSBtOjVsGJIoGw56QHZf689sQTouIBCDem3M+QJmpcWJo1KHZvzRp8Uu2C5CMYYykilpFQwk+hw/j3hCP3Udg1aGBHniXJCRDyyDGAS3UnrR/ZoN/DhRpZoQb1wWtMbb90Sjhd+xJjY+w5HrhTjvsUQNdUPQKIEdemFTB8twwASGpAPbVNCxj0SZfygPPBOLO1UvvXDDZvLngkSFan1iMFrea
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3578688b-6dfb-4220-a1df-08d75b820ab2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 08:37:17.8300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zcL8v2F7n4I/z678V+XQ4pT2tpvrKSB/KRGbHEzkB9Ye2mwMuA84vGeLh0FTnvz2nDgkpgGZyr/Ea9CW93x+BMiNnQcZ0clqK8bMhMqzqYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3813
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/19 12:54 AM, Damien Le Moal wrote:=0A=
> Isn't the trace point under submit_bio() in=0A=
> generic_make_request_checks() ? So removing the function is not a=0A=
> problem for tracing as far as I can tell. Am I missing something ?=0A=
=0A=
Yes you are right, I completely missed that.=0A=
=0A=
Sorry I've created confusion with block_dump and tracepoint.=0A=
=0A=
Block trace code is fine.=0A=
=0A=
The block_dump code under the submit_bio() is only dumps the bios with=0A=
the data:-=0A=
=0A=
=0A=
1171                 if (unlikely(block_dump)) {=0A=
1172                         char b[BDEVNAME_SIZE];=0A=
1173                         printk(KERN_DEBUG "%s(%d): %s block %Lu on =0A=
%s (%u sectors)\n",=0A=
1174                         current->comm, task_pid_nr(current),=0A=
1175                                 op_is_write(bio_op(bio)) ? "WRITE" =0A=
: "READ",=0A=
1176                                 (unsigned long =0A=
long)bio->bi_iter.bi_sector,=0A=
1177                                 bio_devname(bio, b), count);=0A=
1178                 }=0A=
=0A=
=0A=
I've posted patch-series [1] in the past to move that code out but it =0A=
didn't go anywhere in anticipation of more data less requests.=0A=
=0A=
Since it is taking longer to have blktrace extensions RFC to move =0A=
forward and [1] didn't go anywhere I wanted to use block_dump=0A=
parameter in the blk-zoned.c (not an ideal situation) so that we can =0A=
have atleast minimal debug support for the new REQ_OP_ZONE_XXX =0A=
operations until we get block trace extensions in the kernel.=0A=
=0A=
Nonetheless, I'll just a send a patch on the top of this which will=0A=
make discussion much easier.=0A=
=0A=
=0A=
[1] :- =0A=
https://lore.kernel.org/linux-block/DM6PR04MB57546ECC4CFDDB5535E3382586FB0@=
DM6PR04MB5754.namprd04.prod.outlook.com/T/=0A=
