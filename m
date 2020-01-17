Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AC0C33CB3
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 01:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B1A52077C
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 01:46:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C2siFIFM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgAQBq0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 20:46:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42384 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgAQBq0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 20:46:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H1i3rt009058;
        Fri, 17 Jan 2020 01:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=T4SKvmpTep1+qbnJtmrMWMHMbVyk5YW9j4BNwvKbNOs=;
 b=C2siFIFMrI5zM63utFvQrfdD8GXN7s3fcFugXBiK45D8U8IKFwSkNwWVjs9INyrlMrq8
 olhQ/S7e6yMLzO027ViPBfIGCcJnDYxUmb3xm4SmECRFkEGimz0XHcNqiWzyIbnFa5b+
 gJvpf6ORrF0uR8hjHH2lOocBdT7Rqk4z3Vj9TcRG/yDpqxKRx7LDwTfeQHpfd+x+LxZs
 qzvVQ9v+uTGt/YaSH3EfdhjmPsEjjAMZlt10UiILsmncEzlsEJ18BOaQ0oy/A03eE4WY
 ZiiapUXGACxfqJYBAMUzhgkqGYAyCInjZrWMNvB6qbqj0Pjs12ErW3YOw7HS0Yp+yWEp VQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74sp0g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 01:44:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H1iYx4131526;
        Fri, 17 Jan 2020 01:44:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xk22xy5b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 01:44:46 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00H1hI0f009269;
        Fri, 17 Jan 2020 01:43:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 17:43:17 -0800
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191215174509.1847-1-linux@roeck-us.net>
        <20191215174509.1847-2-linux@roeck-us.net>
        <yq1r211dvck.fsf@oracle.com>
        <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
        <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net>
        <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net>
        <yq1r202spr9.fsf@oracle.com>
        <403cfbf8-79da-94f1-509f-e90d1a165722@roeck-us.net>
        <yq14kwwnioo.fsf@oracle.com> <20200116174703.GA7850@roeck-us.net>
Date:   Thu, 16 Jan 2020 20:43:14 -0500
In-Reply-To: <20200116174703.GA7850@roeck-us.net> (Guenter Roeck's message of
        "Thu, 16 Jan 2020 09:47:03 -0800")
Message-ID: <yq18sm6n9hp.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

> Can you by any chance provide a full traceback ?

My test machines are tied up with something else right now. This is from
a few days ago (pristine hwmon-next, I believe):

[ 1055.611912] ------------[ cut here ]------------
[ 1055.611922] WARNING: CPU: 3 PID: 3233 at drivers/base/dd.c:519 really_probe+0x436/0x4f0
[ 1055.611925] Modules linked in: sd_mod sg ahci libahci libata drivetemp scsi_mod crc32c_intel igb i2c_algo_bit i2c_core dca hwmon ipv6 nf_defrag_ipv6 crc_ccitt
[ 1055.611955] CPU: 3 PID: 3233 Comm: kworker/u17:1 Tainted: G        W         5.5.0-rc1+ #21
[ 1055.611965] Workqueue: events_unbound async_run_entry_fn
[ 1055.611973] RIP: 0010:really_probe+0x436/0x4f0
[ 1055.611979] Code: c7 30 69 f8 82 e8 ba 94 e5 ff e9 60 ff ff ff 48 8d 7b 38 e8 cc d9 b4 ff 48 8b 43 38 48 85 c0 0f 85 41 fd ff ff e9 4f fd ff ff <0f> 0b e9 66 fc ff ff 48 8d 7d 50 e8 aa d9 b4 ff 4c 8b 6d 50 4d 85
[ 1055.611983] RSP: 0018:ffff8881edb77c98 EFLAGS: 00010287
[ 1055.611989] RAX: ffff8881e1f8fb80 RBX: ffffffffa033a000 RCX: ffffffff8182e583
[ 1055.611993] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffff8881dec506a8
[ 1055.611997] RBP: ffff8881dec50238 R08: 0000000000000001 R09: fffffbfff09629ed
[ 1055.612000] R10: fffffbfff09629ec R11: 0000000000000003 R12: 0000000000000000
[ 1055.612004] R13: ffff8881dec506a8 R14: ffffffff8182eca0 R15: 000000000000000b
[ 1055.612009] FS:  0000000000000000(0000) GS:ffff8881f8900000(0000) knlGS:0000000000000000
[ 1055.612013] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1055.612017] CR2: 00007f957884a000 CR3: 00000001df5ec003 CR4: 00000000000606e0
[ 1055.612020] Call Trace:
[ 1055.612038]  ? driver_probe_device+0x170/0x170
[ 1055.612045]  driver_probe_device+0x82/0x170
[ 1055.612058]  ? driver_probe_device+0x170/0x170
[ 1055.612064]  __driver_attach_async_helper+0xa3/0xe0
[ 1055.612076]  async_run_entry_fn+0x68/0x2a0
[ 1055.612094]  process_one_work+0x4df/0x990
[ 1055.612121]  ? pwq_dec_nr_in_flight+0x110/0x110
[ 1055.612127]  ? do_raw_spin_lock+0x113/0x1d0
[ 1055.612161]  worker_thread+0x78/0x5c0
[ 1055.612190]  ? process_one_work+0x990/0x990
[ 1055.612195]  kthread+0x1be/0x1e0
[ 1055.612202]  ? kthread_create_worker_on_cpu+0xd0/0xd0
[ 1055.612215]  ret_from_fork+0x3a/0x50
[ 1055.612251] irq event stamp: 3512
[ 1055.612259] hardirqs last  enabled at (3511): [<ffffffff81d2b874>] _raw_spin_unlock_irq+0x24/0x30
[ 1055.612265] hardirqs last disabled at (3512): [<ffffffff810029c9>] trace_hardirqs_off_thunk+0x1a/0x1c
[ 1055.612272] softirqs last  enabled at (3500): [<ffffffff820003a5>] __do_softirq+0x3a5/0x5a8
[ 1055.612281] softirqs last disabled at (3489): [<ffffffff810cec7b>] irq_exit+0xfb/0x100
[ 1055.612284] ---[ end trace f0a8dd9a37bea031 ]---

> Either case, I would like to track down how the warning happens, so any
> information you can provide that lets me reproduce the problem would be
> very helpful.

The three systems that exhibit the problem are stock (2010/2012/2014
vintage) x86_64 servers with onboard AHCI and a variety of 4-6 SATA
drives each.

For the qemu test I didn't have ahci configured but I had my SCSI temp
patch on top of yours and ran modprobe drivetemp; modprobe scsi_debug to
trigger the warnings.

-- 
Martin K. Petersen	Oracle Linux Engineering
