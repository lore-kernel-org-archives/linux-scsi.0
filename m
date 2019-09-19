Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB205C3A5A6
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 09:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C91D218AF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 09:09:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="V2bLJK2b";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oAktFBln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388436AbfISJJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:09:36 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:29753 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730632AbfISJJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 05:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568884175; x=1600420175;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=OeO9T1baDIRy48vItZg+vNIbLQj0GHzaUl8+3UB1UC4=;
  b=V2bLJK2bMO6pAaNDQRYl0rv8QZx1BA2YdbQXV+W+472IW+Ux6LjZkkjE
   nf20kJOQUF58x+c/ZsmghqMeT0fGL8MZB/3z0K6gaFdATElqhIf4FWdN+
   KtPZ9uFlDm9S+7rAWFU8UF/R+jIZ58+W/3bR+Xi6ZzWjAw+iPe0kJF08N
   Uas2qzbGQtfcb6ls83UgCA1LMn67vKupb4vk5k2umCahtnE1pn23Yr2TB
   Sz+EB/74eKGknJsxiePEZmcrV/XFNMeBHJxHz1L/BzXD60gEC78M3aBq3
   Iimtza2BjBRADj6khzY+KHTE+jGiTNHBvvS0ONRwuWpU0dc13E153i0K4
   Q==;
IronPort-SDR: 9cPuQXr8we0pFJ9mNgVT4V7liwWqDpxK6cQmSfExJVg+xboQb7RF2BD9sZ1bqjkbLP0LALRwv/
 A59Hgo6PkXF/C4lsYK/7Zpktu/YFx4yPlMzV6cIlxW/kOeoE855cBUhuPPF2VzE5m0cBH+jwqh
 v6EcgjzSOyf6gSEzBK4VdCb5Dl70uL5tmBtceD7DAQ+t9jy76Ekc4R0GoDqxQzpPBIMkUJXvPm
 DB6c0AQTnMcVgkQvdKAXr/fimJWSZjfz8FJUOICTl3CIlcpUl97QqcVim0zecZeHGvr6AJMv76
 5+E=
X-IronPort-AV: E=Sophos;i="5.64,523,1559491200"; 
   d="scan'208";a="118627825"
Received: from mail-by2nam05lp2055.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.55])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2019 17:09:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NY55F3InqDGx1FtJMYN/CYoA8J/jS154evFjkRSMdluGgZGSu5RL9z656Hz2+O/2WS/5fJT6z2XmRr1MoLp1P7MiYINWisXZvYH1T9vuid7hEmdK0CiJFpAjYwdzCli8ihyjRrH/vBtUAj5Vm1qmv/LueIf5qGvzynbpV3VdnJUTyPSVBPTugFL3vUsucqckBGb0lXg+VH5myTKzdS4n5UqvoHEpjyGR9w4/KA0TFcJG92nEsj3+yOS+Clztnys0zDvv0VNEA/JhpF0xpVJBhM3uw4YrEYJFUjd470fj3GnOEsBPwDFQe5PVtyi+82gFjDx5u9Ac6AyJ0PwI1oZYHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skj7mJvYBbNxFLoRhs9heMVUx7HUw08cjW3EzasP1T4=;
 b=ZuweSnU+3DQK2+mFmgUkvNnH1wKLLSfhwRw3+Ku1ms8sUSFXY0IolCUiQLTVyS7od5aO7gzc9+RVUipXx/92QG4/FDQrRq9kFYp1Ef37PxXNYFoGmprco4NrQuJ3fIRxORpGsC0KmqMC/1z/a5+OOHAHFoC0Q0kio/krwq0XhP67cswG6TVu18xRsvG5PLfJizMrIfRB+UJAHz8QjvkJag/2Cn3tNk36+gNyLWLmGv6MXh+Tpt1zAhOneEilna7f5QYWlxDmrxUXMTFjK9AgO1Bz0LNsk/O/120WENaM8KmwFhzCfPjzDFusUW+9Fb+blndvxCBconnYH+zmvn2+cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skj7mJvYBbNxFLoRhs9heMVUx7HUw08cjW3EzasP1T4=;
 b=oAktFBlnM8ZW/R7RbA6nC3l1W55hAeGbvPZZQB3v51lJRKRtaZ5aME/p4CsYDJc2kUAD/qWxB8VC6zXiPLtTzi3UI8+Rdk9ZDkNekOC9nVbais4Rs1Vj6tvQ+Y4XgKQJSOp+/STXTOAhyGE2SNyqwsqCoex9pVPMGDtqosjqb9Y=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4952.namprd04.prod.outlook.com (52.135.234.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Thu, 19 Sep 2019 09:09:33 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117%3]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 09:09:33 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     Alan Stern <stern@rowland.harvard.edu>,
        Andrea Vai <andrea.vai@unipv.it>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Topic: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Index: AQHVV3qbTKYWY4pSG0OtJLbZzV/0bg==
Date:   Thu, 19 Sep 2019 09:09:33 +0000
Message-ID: <BYAPR04MB58163D3C66FEA00A754CF7C7E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <Pine.LNX.4.44L0.1909181213141.1507-100000@iolanthe.rowland.org>
 <BYAPR04MB58160E6FEBD92D04ECA7D303E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20190919085555.GA4541@ming.t460p>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [193.86.95.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd4ce2b2-d5e5-4acc-8289-08d73ce11667
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4952;
x-ms-traffictypediagnostic: BYAPR04MB4952:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4952BA618A3A9450BB415D70E7890@BYAPR04MB4952.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(199004)(189003)(54094003)(33656002)(446003)(305945005)(5660300002)(186003)(76116006)(6246003)(74316002)(7696005)(66476007)(66946007)(7416002)(6916009)(25786009)(66446008)(76176011)(256004)(14444005)(7736002)(99286004)(52536014)(64756008)(6116002)(66556008)(86362001)(8936002)(3846002)(14454004)(91956017)(229853002)(66066001)(476003)(81166006)(9686003)(81156014)(6436002)(55016002)(486006)(478600001)(54906003)(2906002)(19627235002)(55236004)(316002)(26005)(71200400001)(4326008)(102836004)(6506007)(53546011)(71190400001)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4952;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ArB77K299mbmjAVniCYI4a2E8DKe91a16nQ7L1MyIkPfbTyJdh4E73aIHiQTePXRtU7AtK672JHCxd/oL8jaylFHuw2XFLFUvBEOSkQBnPe6dfWOECUnRsLuzPUXTSg82dae++N9sxtscEd8D413g8ZbWhSa0tRBEY1qpcfFLdk6e7CRIdlz4BXne9hWFBABgEBzlWcUollKAsW6wtC5cMQHGb0UJYCAfrOBMWjrUhk5AOhMVXGoTWORWV1D1tLx28bJvsbjiH2p3WLRzYCyZhu1gz96ubTVycjXSVMsRBBNppjnQAjthetStR5SDdMkbgs3lVfj/pKILDuFMS03OKu3oMfxNrMsCBq4tNZ3V0z0hnqF95NllijiU6pxlTypn2X9pJyt7ghRoUKaS7TO3KSgeJzoc2np2RR1SRtKHKk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd4ce2b2-d5e5-4acc-8289-08d73ce11667
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 09:09:33.6935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HOICZXiXthk5XtcqPnmZ9jIhgLcxlvMQoh2L0a8BqHQwDWaHDfjOYyp8VTFPAzZjxwSN2ppvIks6bC5bIjjZRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4952
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/19 10:56, Ming Lei wrote:=0A=
> On Thu, Sep 19, 2019 at 08:26:32AM +0000, Damien Le Moal wrote:=0A=
>> On 2019/09/18 18:30, Alan Stern wrote:=0A=
>>> On Wed, 18 Sep 2019, Andrea Vai wrote:=0A=
>>>=0A=
>>>>> Also, I wonder if the changing the size of the data transfers would=
=0A=
>>>>> make any difference.  This is easy to try; just write "64" to=0A=
>>>>> /sys/block/sd?/queue/max_sectors_kb (where the ? is the appropriate=
=0A=
>>>>> drive letter) after the drive is plugged in but before the test=0A=
>>>>> starts.=0A=
>>>>=0A=
>>>> ok, so I duplicated the tests above for the "64" case (it was=0A=
>>>> initially set as "120", if it is relevant to know), leading to 40 test=
s named as=0A=
>>>>=0A=
>>>> bad.mon.out_50000000_64_TIMESTAMP=0A=
>>>> bad.mon.out_50000000_non64_TIMESTAMP=0A=
>>>> good.mon.out_50000000_64_TIMESTAMP=0A=
>>>> good.mon.out_50000000_non64_TIMESTAMP=0A=
>>>>=0A=
>>>> where "64" denotes the ones done with that value in max_sectors_kb,=0A=
>>>> and "not64" the ones without it (as far as I can tell, it has been=0A=
>>>> always "120").=0A=
>>>>=0A=
>>>> So, we have 40 traces total. Each set of 10 trials is identified by=0A=
>>>> a text file, which contains the output log of the test script (and the=
=0A=
>>>> timestamps), also available in the download zipfile.=0A=
>>>>=0A=
>>>> Just to summarize here the times, they are respectively (number=0A=
>>>> expressed  in seconds):=0A=
>>>>=0A=
>>>> BAD:=0A=
>>>>   Logs: log_10trials_50MB_BAD_NonCanc_64.txt,=0A=
>>>> log_10trials_50MB_BAD_NonCanc_non64.txt=0A=
>>>>   64: 34, 34, 35, 39, 37, 32, 42, 44, 43, 40=0A=
>>>>   not64: 61, 71, 59, 71, 62, 75, 62, 70, 62, 68=0A=
>>>> GOOD:=0A=
>>>>   Logs: log_10trials_50MB_GOOD_NonCanc_64.txt,=0A=
>>>> log_10trials_50MB_GOOD_NonCanc_non64.txt=0A=
>>>>   64: 34, 32, 35, 34, 35, 33, 34, 33, 33, 33=0A=
>>>>   not64: 32, 30, 32, 31, 31, 30, 32, 30, 32, 31=0A=
>>>=0A=
>>> The improvement from using "64" with the bad kernel is quite large.  =
=0A=
>>> That alone would be a big help for you.=0A=
>>>=0A=
>>> However, I did see what appears to be a very significant difference =0A=
>>> between the bad and good kernel traces.  It has to do with the order in=
 =0A=
>>> which the blocks are accessed.=0A=
>>>=0A=
>>> Here is an extract from one of the bad traces.  I have erased all the =
=0A=
>>> information except for the columns containing the block numbers to be =
=0A=
>>> written:=0A=
>>>=0A=
>>> 00019628 00=0A=
>>> 00019667 00=0A=
>>> 00019628 80=0A=
>>> 00019667 80=0A=
>>> 00019629 00=0A=
>>> 00019668 00=0A=
>>> 00019629 80=0A=
>>> 00019668 80=0A=
>>>=0A=
>>> Here is the equivalent portion from one of the good traces:=0A=
>>>=0A=
>>> 00019628 00=0A=
>>> 00019628 80=0A=
>>> 00019629 00=0A=
>>> 00019629 80=0A=
>>> 0001962a 00=0A=
>>> 0001962a 80=0A=
>>> 0001962b 00=0A=
>>> 0001962b 80=0A=
>>>=0A=
>>> Notice that under the good kernel, the block numbers increase=0A=
>>> monotonically in a single sequence.  But under the bad kernel, the=0A=
>>> block numbers are not monotonic -- it looks like there are two separate=
=0A=
>>> threads each with its own strictly increasing sequence.=0A=
>>>=0A=
>>> This is exactly the sort of difference one might expect to see from=0A=
>>> the commit f664a3cc17b7 ("scsi: kill off the legacy IO path") you=0A=
>>> identified as the cause of the problem.  With multiqueue I/O, it's not =
=0A=
>>> surprising to see multiple sequences of block numbers.=0A=
>>>=0A=
>>> Add it's not at all surprising that a consumer-grade USB storage device=
 =0A=
>>> might do a much worse job of handling non-sequential writes than =0A=
>>> sequential ones.=0A=
>>>=0A=
>>> Which leads to a simple question for the SCSI or block-layer =0A=
>>> maintainers:  Is there a sysfs setting Andrea can tweak which will =0A=
>>> effectively restrict a particular disk device down to a single I/O=0A=
>>> queue, forcing sequential access?=0A=
>>=0A=
>> The scheduling inefficiency you are seeing may be coming from the fact t=
hat the=0A=
>> block layer does a direct issue of requests, bypassing the elevator, und=
er some=0A=
>> conditions. One of these is sync requests on a multiqueue device. We hit=
 this=0A=
>> problem on Zoned disks which can easily return an error for write reques=
ts=0A=
>> without the elevator throttling writes per zones (zone write locking). T=
his=0A=
>> problem was discovered by Hans (on CC).=0A=
>>=0A=
>> I discussed this with Hannes yesterday and we think we have a fix, but w=
e'll=0A=
>> need to do a lot of testing as all block devices are potentially impacte=
d by the=0A=
>> change, including stacked drivers (DM). Performance regression is scary =
with any=0A=
>> change in that area (see blk_mq_make_request() and use of=0A=
>> blk_mq_try_issue_directly() vs blk_mq_sched_insert_request()).=0A=
> =0A=
> Not sure this one is same with yours, for USB, mq-deadline is used at=0A=
> default, and direct issue won't be possible. Direct issue is only used=0A=
> in case of none or underlying queues of DM multipath.=0A=
=0A=
For a multi-queue zoned disk, mq-deadline is also set, but we have observed=
=0A=
unaligned write IO errors for sync writes because of mq-deadline being bypa=
ssed=0A=
and as a result zones not being write-locked.=0A=
=0A=
In blk_mq_make_request(), at the end, you have:=0A=
=0A=
	} else if ((q->nr_hw_queues > 1 && is_sync) || (!q->elevator &&=0A=
			!data.hctx->dispatch_busy)) {=0A=
		blk_mq_try_issue_directly(data.hctx, rq, &cookie);=0A=
	} else {=0A=
		blk_mq_sched_insert_request(rq, false, true, true);=0A=
	}=0A=
=0A=
Which I read as "for a sync req on a multi-queue device, direct issue",=0A=
regardless of the elevator being none or something else.=0A=
=0A=
The correct test should probably be:=0A=
=0A=
	} else if (!q->elevator &&=0A=
		   ((q->nr_hw_queues > 1 && is_sync) || 	=0A=
		     !data.hctx->dispatch_busy))) {=0A=
		blk_mq_try_issue_directly(data.hctx, rq, &cookie);=0A=
	} else {=0A=
		blk_mq_sched_insert_request(rq, false, true, true);=0A=
	}=0A=
=0A=
That is, never bypass the elevator if one is set. Thoughts ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
