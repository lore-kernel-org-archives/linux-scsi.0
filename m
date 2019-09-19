Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4372FC3A5A6
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 08:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03A7021929
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 08:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FtPL6y3o";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Yw4H40ir"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388264AbfISI0g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 04:26:36 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:54040 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387637AbfISI0f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 04:26:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568881595; x=1600417595;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=047hdgp18dnq1yYFoiclxX8VdDT0SO/j1Fii7cL1Wwk=;
  b=FtPL6y3olUyYbncOGhjk7w0Bs1t7cEHnOcCIbzmgplXf10JxnkOEg0qx
   SF5TomsRq572yBOlgtybE5fC1ukpu6XvW4bo4+JCypbTw3szwIeU+cAfD
   kzodSLTSjLC7JL2SxagIGteyTuEF8HdMAYxFzFg2+uNGPFX2N4p487bNO
   nwfqNKls34VFGA02itcHNs8VBeOdzeBd1sMiw1rSXM8izKwmGE+dlWRD9
   CSULMyNQTuoRHcI/ayFyip6/BiCFbzI1BMndZUKWxkh/XIbyQPQE8ivqj
   ZQJV1SMyBeFtk9Zh644SFqHDzLjQATHCukJyR+MJ4FRZiSIl8Y8EqsyVw
   Q==;
IronPort-SDR: /icRuGclKrRlHnC9TkvCzJrEAGQGbRSORiHQxChdXTZXI1bhQSBoV47NYYXSLFi1/8U3iAYnQd
 /9F9OG3r9AAfczVR9xsRJ5xuJg4LGKZrM9IBuHu92jYtWAAaINEekEwO/ApTAC0QF7/kBXHtLb
 if1xTfeOL14X0SL+rZJu5FEK9+fLQNdNQnCunXlSS0BYDiYxb04a4oQ3i5OlZ2arrx1EBEXzCf
 j38X7ibYAiASsPue0455uSbF8NxRx28U7UhCmio3X/Tu8d0IHyw0IVPiF8gTTdGW/Fwx2X4HdV
 98A=
X-IronPort-AV: E=Sophos;i="5.64,522,1559491200"; 
   d="scan'208";a="120198343"
Received: from mail-sn1nam02lp2057.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.57])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2019 16:26:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioFOUWh6DWX2ktMhQ4biZ3fIgZ8gGAgeGLvOsovXvvD7jUeJUMWXYNG2/o66rb5EiCCdAKcpdKDKuYIPq9lYGM+xbcFLfTxB7OUPAvTyjb0QhzAuXnOZcEO4A6Ees723T2UiARutUvJHnRQp2iqEOTdxLs3WGzQ3kdpyw+jS60G5+kHMBOaBUo1iQKNF4V+Jyt2c/5VEPT42KSroV/2GqUosMaSAAda7yStNCCvj+H0ECAGveBulhrUVJ1rWk5n52W08IaQEpkZ8uHJnvqOAi3TlUklC9gFcGTdc7mhE8i0jle02YbMznuICLykb6fiTDe5vFajvOoI+WLaRZDIpCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4woCGkGQ4Ipax5AeIFDfF8aoKw7XQBA3zV8MCCzz3E=;
 b=R96LSv/XdbSC6GGV24RFdkVDkRPDO9I0EUG1aBxI60jV6xqAtaagGhQc+8F/S7Ffc+1ncjxtAqr/bsbsDpGOebd2UVicxREz/EStL/UXj8P7v6AgxEIVYDNgIrNNHO6d7SMd2ExdzgWh3E0AaiWh2K6m6O3XoJawPnJRkk1pRQi06Oe8aDSFMhyJLt5gsypQ6y+ZIKyXouEFd4qn9ukbc2YcdTlkKlD+Gc+Qt2YHjuRD8DVwDEkRzsHvGQkcvIT71K3oqHJURuTchBDsa94nuu2i09ae7+knTRJ4UfGDQT5DGUB2lSsF6xSKwA4BiK+aUZTkwAFqzYKGARcDbg9XNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4woCGkGQ4Ipax5AeIFDfF8aoKw7XQBA3zV8MCCzz3E=;
 b=Yw4H40ir9DgohCfGMfaddTgkF8xLnq/XF2KIe2Tjxx5wU0xekht7YGePr09oHO+Qd/o7e9gIe9wTcQLEoBCwted2V6tBww3ROHfPoozy/Ia4DJlAHC3+sysvHXlWdCWJs0lVz+X5xSXpoBGpA4P66p/xLxtnmnU6XbUQYrNAiiw=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYASPR01MB0043.namprd04.prod.outlook.com (20.178.207.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Thu, 19 Sep 2019 08:26:32 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117%3]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 08:26:32 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Andrea Vai <andrea.vai@unipv.it>
CC:     Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Topic: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Index: AQHVV3qbTKYWY4pSG0OtJLbZzV/0bg==
Date:   Thu, 19 Sep 2019 08:26:32 +0000
Message-ID: <BYAPR04MB58160E6FEBD92D04ECA7D303E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <Pine.LNX.4.44L0.1909181213141.1507-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [193.86.95.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6efa0dbd-437e-4535-2be9-08d73cdb13f4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYASPR01MB0043;
x-ms-traffictypediagnostic: BYASPR01MB0043:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYASPR01MB00431061193D0A3E7AD3A96CE7890@BYASPR01MB0043.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(54094003)(6436002)(8936002)(54906003)(66946007)(110136005)(5660300002)(478600001)(446003)(71200400001)(316002)(33656002)(7416002)(8676002)(14454004)(74316002)(7736002)(81156014)(71190400001)(305945005)(81166006)(66446008)(25786009)(4326008)(86362001)(64756008)(256004)(99286004)(2906002)(2171002)(229853002)(66556008)(91956017)(76116006)(476003)(6246003)(102836004)(19627235002)(55016002)(53546011)(6506007)(66066001)(26005)(9686003)(7696005)(486006)(52536014)(14444005)(186003)(55236004)(6116002)(76176011)(3846002)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYASPR01MB0043;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: x/NVd3frIFZe5e3el1lcI70AY0RWHH5bHUhrcI04d5KTXTsdiqXibJSgA+dq5TpXxTs/+8i3XQj5tvCv7vzPGSKlwejGOJrdcqSHFx13U25j5Q6S62VSs5rXyLSqVZytxFVnvFGfRRj/yr80Db52KkKaz4jGZYko5zdMCa4XOiEytPqJh2Tse4E0U8OqsUmA8BROiWaGRsNiFCY4ARJ9i/6FGplx0hGqGKG53oXE/4C3g2zsdiWUVWBEyhr/Ij8VVaE9JQc+b9h9s0Ki1xt3WobECT2CODtW2jp5VvDKIxZtxCZeqEMTWWV58M3j5lwzlQLSEcbUSBD4ri39hqmcSfkg/2gDjJMPobPQH2RJitp9Pc3KyKS0wlIH7qgioz+Zuhenni5QZ3m50xqD2xwXQUdxzWRfujGZ5Mz3ALHh61s=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6efa0dbd-437e-4535-2be9-08d73cdb13f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 08:26:32.4529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UDUB0YH68Jrp6Kjv2PE3Hu/OFQan6DHmTW4aKety0vUQAcmNqiKicuVpnS6m+5okf2ujIpCpS/7Ce9f2n4Wfag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYASPR01MB0043
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/18 18:30, Alan Stern wrote:=0A=
> On Wed, 18 Sep 2019, Andrea Vai wrote:=0A=
> =0A=
>>> Also, I wonder if the changing the size of the data transfers would=0A=
>>> make any difference.  This is easy to try; just write "64" to=0A=
>>> /sys/block/sd?/queue/max_sectors_kb (where the ? is the appropriate=0A=
>>> drive letter) after the drive is plugged in but before the test=0A=
>>> starts.=0A=
>>=0A=
>> ok, so I duplicated the tests above for the "64" case (it was=0A=
>> initially set as "120", if it is relevant to know), leading to 40 tests =
named as=0A=
>>=0A=
>> bad.mon.out_50000000_64_TIMESTAMP=0A=
>> bad.mon.out_50000000_non64_TIMESTAMP=0A=
>> good.mon.out_50000000_64_TIMESTAMP=0A=
>> good.mon.out_50000000_non64_TIMESTAMP=0A=
>>=0A=
>> where "64" denotes the ones done with that value in max_sectors_kb,=0A=
>> and "not64" the ones without it (as far as I can tell, it has been=0A=
>> always "120").=0A=
>>=0A=
>> So, we have 40 traces total. Each set of 10 trials is identified by=0A=
>> a text file, which contains the output log of the test script (and the=
=0A=
>> timestamps), also available in the download zipfile.=0A=
>>=0A=
>> Just to summarize here the times, they are respectively (number=0A=
>> expressed  in seconds):=0A=
>>=0A=
>> BAD:=0A=
>>   Logs: log_10trials_50MB_BAD_NonCanc_64.txt,=0A=
>> log_10trials_50MB_BAD_NonCanc_non64.txt=0A=
>>   64: 34, 34, 35, 39, 37, 32, 42, 44, 43, 40=0A=
>>   not64: 61, 71, 59, 71, 62, 75, 62, 70, 62, 68=0A=
>> GOOD:=0A=
>>   Logs: log_10trials_50MB_GOOD_NonCanc_64.txt,=0A=
>> log_10trials_50MB_GOOD_NonCanc_non64.txt=0A=
>>   64: 34, 32, 35, 34, 35, 33, 34, 33, 33, 33=0A=
>>   not64: 32, 30, 32, 31, 31, 30, 32, 30, 32, 31=0A=
> =0A=
> The improvement from using "64" with the bad kernel is quite large.  =0A=
> That alone would be a big help for you.=0A=
> =0A=
> However, I did see what appears to be a very significant difference =0A=
> between the bad and good kernel traces.  It has to do with the order in =
=0A=
> which the blocks are accessed.=0A=
> =0A=
> Here is an extract from one of the bad traces.  I have erased all the =0A=
> information except for the columns containing the block numbers to be =0A=
> written:=0A=
> =0A=
> 00019628 00=0A=
> 00019667 00=0A=
> 00019628 80=0A=
> 00019667 80=0A=
> 00019629 00=0A=
> 00019668 00=0A=
> 00019629 80=0A=
> 00019668 80=0A=
> =0A=
> Here is the equivalent portion from one of the good traces:=0A=
> =0A=
> 00019628 00=0A=
> 00019628 80=0A=
> 00019629 00=0A=
> 00019629 80=0A=
> 0001962a 00=0A=
> 0001962a 80=0A=
> 0001962b 00=0A=
> 0001962b 80=0A=
> =0A=
> Notice that under the good kernel, the block numbers increase=0A=
> monotonically in a single sequence.  But under the bad kernel, the=0A=
> block numbers are not monotonic -- it looks like there are two separate=
=0A=
> threads each with its own strictly increasing sequence.=0A=
> =0A=
> This is exactly the sort of difference one might expect to see from=0A=
> the commit f664a3cc17b7 ("scsi: kill off the legacy IO path") you=0A=
> identified as the cause of the problem.  With multiqueue I/O, it's not =
=0A=
> surprising to see multiple sequences of block numbers.=0A=
> =0A=
> Add it's not at all surprising that a consumer-grade USB storage device =
=0A=
> might do a much worse job of handling non-sequential writes than =0A=
> sequential ones.=0A=
> =0A=
> Which leads to a simple question for the SCSI or block-layer =0A=
> maintainers:  Is there a sysfs setting Andrea can tweak which will =0A=
> effectively restrict a particular disk device down to a single I/O=0A=
> queue, forcing sequential access?=0A=
=0A=
The scheduling inefficiency you are seeing may be coming from the fact that=
 the=0A=
block layer does a direct issue of requests, bypassing the elevator, under =
some=0A=
conditions. One of these is sync requests on a multiqueue device. We hit th=
is=0A=
problem on Zoned disks which can easily return an error for write requests=
=0A=
without the elevator throttling writes per zones (zone write locking). This=
=0A=
problem was discovered by Hans (on CC).=0A=
=0A=
I discussed this with Hannes yesterday and we think we have a fix, but we'l=
l=0A=
need to do a lot of testing as all block devices are potentially impacted b=
y the=0A=
change, including stacked drivers (DM). Performance regression is scary wit=
h any=0A=
change in that area (see blk_mq_make_request() and use of=0A=
blk_mq_try_issue_directly() vs blk_mq_sched_insert_request()).=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
