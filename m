Return-Path: <SRS0=/6u/=WU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A2CC3A5A2
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 00:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 236B2206E0
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 00:27:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="hWLcDWrA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfHXA1X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 20:27:23 -0400
Received: from mail-eopbgr770104.outbound.protection.outlook.com ([40.107.77.104]:14284
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbfHXA1X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 20:27:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuA/90yxYFiClXOKsAOjn1sdaGEkptEUzq/qDtlzsiQPRnzhcsSmrXEQ1wkQYX2cnZm1Bgdult7c3wqmYJiz1Mtmw0McwCMefqedD0N7F18JKLzpt0OiSfAafztHIiN51H4XUj/h2k1CMXD2MJXksGwaLagtdyLfIAmxnmY0hYE2+fGtmcmAc0fpslJeDBZbWjYUkpyYStuq/Vax6rcfeSTdsiG7cfu2uzrXgBT4fs1KIg1SbU1/0n/iCpuHczFsc0ZdeWaUGg+bTpK+GyI7W4JtjZhoAJmqsdgAzonCGSoa5TqO8aLjXQXc4Rl7bi+FGESgI9ABaKKthCGz6131DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8aWe/RoV649/6UucnkCgtOVg7cMYEFGNnE/2asnmwmM=;
 b=N4GMeOlraElj552ciy1eHGQvvLr4CmLnyIqN4KzT3hIcgok2Mq1sDqEnclL5HWBgJPsyC7SC7ljwdKjXZ1jSEJnB8AmkecpAdbtN2UNEes/K56GWmr6lgkNP+xQ6/5Qf6a2UCrlfYXG9tfGHTggcSPusyWHB/scVgVCII2TD5j1kUGK7Q4yR1BjS7HU312O5GuNyeK0Hxdf3yhL1hVJoSjDxd0VUhWFavwHeXdjuW2bbBkmLfD3yqOw9LcDsrI6r4NF6Vw+NcuM4EoxJrWXdvGZcYCvFlEkd2vC+Lp7ORPoDiNr0E4SLUlv8Gi0kEiYWkljb+rQvtRne6+AjxQzfZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8aWe/RoV649/6UucnkCgtOVg7cMYEFGNnE/2asnmwmM=;
 b=hWLcDWrA+eUVxV3GcyTgJyDwNB+5TXBkzYNsLZT8iPrYg/sDDC0QRdx5dvAW1In0ZqGFU2heirPt1MW8wNwf/BfqnFfQzWOsD/fICDpPbdJ0pXwx4m67AtmeppjIcse7UAnt+eO8c/cNe4IHIdX9QOcZ1zZ2KHbGSaSl21X97AM=
Received: from CY4PR21MB0741.namprd21.prod.outlook.com (10.173.189.7) by
 CY4PR21MB0824.namprd21.prod.outlook.com (10.173.192.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.3; Sat, 24 Aug 2019 00:27:19 +0000
Received: from CY4PR21MB0741.namprd21.prod.outlook.com
 ([fe80::2c62:5380:9ed8:496d]) by CY4PR21MB0741.namprd21.prod.outlook.com
 ([fe80::2c62:5380:9ed8:496d%11]) with mapi id 15.20.2220.000; Sat, 24 Aug
 2019 00:27:19 +0000
From:   Long Li <longli@microsoft.com>
To:     Ming Lei <ming.lei@redhat.com>, Sagi Grimberg <sagi@grimberg.me>
CC:     "longli@linuxonhyperv.com" <longli@linuxonhyperv.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: RE: [PATCH 3/3] nvme: complete request in work queue on CPU with
 flooded interrupts
Thread-Topic: [PATCH 3/3] nvme: complete request in work queue on CPU with
 flooded interrupts
Thread-Index: AQHVVx6V8EslWtuw80WR9kecrOlyh6cETI8AgAPI6gCAAV8FUA==
Date:   Sat, 24 Aug 2019 00:27:18 +0000
Message-ID: <CY4PR21MB074173E79C7FC3AC13C69CB3CEA70@CY4PR21MB0741.namprd21.prod.outlook.com>
References: <1566281669-48212-1-git-send-email-longli@linuxonhyperv.com>
 <1566281669-48212-4-git-send-email-longli@linuxonhyperv.com>
 <2a30a07f-982c-c291-e263-0cf72ec61235@grimberg.me>
 <20190823032129.GA18680@ming.t460p>
In-Reply-To: <20190823032129.GA18680@ming.t460p>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-originating-ip: [2001:4898:80e8:7:ede6:db5c:c6fe:798]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3a2f6ab-77c2-4b54-e716-08d72829d2dc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:CY4PR21MB0824;
x-ms-traffictypediagnostic: CY4PR21MB0824:
x-microsoft-antispam-prvs: <CY4PR21MB08245699B01D5F1F5BA531D1CEA70@CY4PR21MB0824.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(189003)(199004)(66556008)(305945005)(64756008)(66446008)(66476007)(74316002)(54906003)(7736002)(110136005)(76176011)(8676002)(10090500001)(8990500004)(22452003)(55016002)(6436002)(6246003)(229853002)(99286004)(71190400001)(102836004)(6506007)(81166006)(33656002)(316002)(9686003)(53936002)(7416002)(66946007)(8936002)(5660300002)(486006)(446003)(478600001)(46003)(25786009)(86362001)(14454004)(7696005)(476003)(81156014)(14444005)(2906002)(71200400001)(11346002)(6116002)(256004)(10290500003)(4326008)(76116006)(186003)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0824;H:CY4PR21MB0741.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: i344YVK29nPgLQLBQAcBW9WIo13v/WsLspKPZt7R+SRlpi17Zc+hDgBwmF7TUy2AbtYm5mldpBIf7hRCPSVlIJHvGkb2Evu5iFaBHX3ztghR+ETVmuq0WGATPv8BTLXFuMzE5wyr31jaKrBT8wdwEsfz5EW+rqnQTkkixnYX/2eE6EjX9PJgOquVlMqPTcr0tnYR/gWkt7qVCNFqcDWRWE0GhVbWqDRoaOLNHYaG3QjYxXuoCU2lHHEeBIvJhZ3oGSoB2CvjnGKrW/lElpG2KUI06TsLPxBhZvgerybE/E4NYFV0B/qnW4O+oXQJRPJSm6MwNG0AOqxFaUm2ZFOP89ch7aoHI7rcCOnVMYxyMxiPvWI4C8pI+m172n3HK1iwtfqIHTPDMSwyvyVjVACX+4WlfRnGQ9LEXQUXFq9YcTg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a2f6ab-77c2-4b54-e716-08d72829d2dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2019 00:27:18.9758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /tM5YJtWn7icaPxiZ7U4XrBu2H3KnTaGuuSnWV6Lb8I8n91i7WcFY8SeqO66x8BoKyTQCM5D1fC2PNmvHN2ASA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0824
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>>Subject: Re: [PATCH 3/3] nvme: complete request in work queue on CPU
>>>with flooded interrupts
>>>
>>>On Tue, Aug 20, 2019 at 10:33:38AM -0700, Sagi Grimberg wrote:
>>>>
>>>> > From: Long Li <longli@microsoft.com>
>>>> >
>>>> > When a NVMe hardware queue is mapped to several CPU queues, it is
>>>> > possible that the CPU this hardware queue is bound to is flooded by
>>>> > returning I/O for other CPUs.
>>>> >
>>>> > For example, consider the following scenario:
>>>> > 1. CPU 0, 1, 2 and 3 share the same hardware queue 2. the hardware
>>>> > queue interrupts CPU 0 for I/O response 3. processes from CPU 1, 2
>>>> > and 3 keep sending I/Os
>>>> >
>>>> > CPU 0 may be flooded with interrupts from NVMe device that are I/O
>>>> > responses for CPU 1, 2 and 3. Under heavy I/O load, it is possible
>>>> > that CPU 0 spends all the time serving NVMe and other system
>>>> > interrupts, but doesn't have a chance to run in process context.
>>>> >
>>>> > To fix this, CPU 0 can schedule a work to complete the I/O request
>>>> > when it detects the scheduler is not making progress. This serves
>>>multiple purposes:
>>>> >
>>>> > 1. This CPU has to be scheduled to complete the request. The other
>>>> > CPUs can't issue more I/Os until some previous I/Os are completed.
>>>> > This helps this CPU get out of NVMe interrupts.
>>>> >
>>>> > 2. This acts a throttling mechanisum for NVMe devices, in that it
>>>> > can not starve a CPU while servicing I/Os from other CPUs.
>>>> >
>>>> > 3. This CPU can make progress on RCU and other work items on its
>>>queue.
>>>>
>>>> The problem is indeed real, but this is the wrong approach in my mind.
>>>>
>>>> We already have irqpoll which takes care proper budgeting polling
>>>> cycles and not hogging the cpu.
>>>
>>>The issue isn't unique to NVMe, and can be any fast devices which
>>>interrupts CPU too frequently, meantime the interrupt/softirq handler ma=
y
>>>take a bit much time, then CPU is easy to be lockup by the interrupt/sof=
irq
>>>handler, especially in case that multiple submission CPUs vs. single
>>>completion CPU.
>>>
>>>Some SCSI devices has the same problem too.
>>>
>>>Could we consider to add one generic mechanism to cover this kind of
>>>problem?
>>>
>>>One approach I thought of is to allocate one backup thread for handling =
such
>>>interrupt, which can be marked as IRQF_BACKUP_THREAD by drivers.
>>>
>>>Inside do_IRQ(), irqtime is accounted, before calling action->handler(),
>>>check if this CPU has taken too long time for handling IRQ(interrupt or
>>>softirq) and see if this CPU could be lock up. If yes, wakeup the backup

How do you know if this CPU is spending all the time in do_IRQ()?

Is it something like:
If (IRQ_time /elapsed_time > a threshold value)
	wake up the backup thread

>>>thread to handle the interrupt for avoiding lockup this CPU.
>>>
>>>The threaded interrupt framework is there, and this way could be easier =
to
>>>implement. Meantime most time the handler is run in interrupt context an=
d
>>>we may avoid the performance loss when CPU isn't busy enough.
>>>
>>>Any comment on this approach?
>>>
>>>Thanks,
>>>Ming
