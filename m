Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EF5CA9ECB
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 12:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 702782087E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 12:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfJ3MW5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 08:22:57 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:42268 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbfJ3MW5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Oct 2019 08:22:57 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id EC1363EBEB1E57610E20;
        Wed, 30 Oct 2019 20:22:46 +0800 (CST)
Received: from DGGEML505-MBS.china.huawei.com ([169.254.11.138]) by
 DGGEML402-HUB.china.huawei.com ([fe80::fca6:7568:4ee3:c776%31]) with mapi id
 14.03.0439.000; Wed, 30 Oct 2019 20:22:37 +0800
From:   "wubo (T)" <wubo40@huawei.com>
To:     Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        open-iscsi <open-iscsi@googlegroups.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>
Subject: Antw: [PATCH v2] scsi: avoid potential deadloop in iscsi_if_rx func
Thread-Topic: Antw: [PATCH v2] scsi: avoid potential deadloop in iscsi_if_rx
 func
Thread-Index: AdWO9lESg1/320hTRWyI93hubYXiRQAAM+TA//+AUID//1OToA==
Date:   Wed, 30 Oct 2019 12:22:37 +0000
Message-ID: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DFA4D6@dggeml505-mbs.china.huawei.com>
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DFA0FE@dggeml505-mbs.china.huawei.com>
 <5DB946E1020000A100034B9C@gwsmtp.uni-regensburg.de>
In-Reply-To: <5DB946E1020000A100034B9C@gwsmtp.uni-regensburg.de>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.252]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >>> "wubo (T)" <wubo40@huawei.com> schrieb am 30.10.2019 um 08:56 in
> Nachricht
> <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DFA0FE@dggeml505-mbs.china.
> huawei.com>:
> > From: Bo Wu <wubo40@huawei.com>
> 
> ...
> > +			if (--retries < 0) {
> > +				printk(KERN_ERR "Send reply failed too many times. "
> > +				       "Max supported retries %u\n",
> ISCSI_SEND_MAX_ALLOWED);
> 
> Just for "personal taste": Why not simplify the message to:?
> +				printk(KERN_ERR "Send reply failed too many times
> (%u)\n",
>                                ISCSI_SEND_MAX_ALLOWED);
> 
> > +				break;
> > +			}
> > +
> 
> Maybe place the number after "many" as an alternative. I think as the
> message is expected to be rare, a short variant is justified.

Thanks for your suggestion. This problem occured when iscsi_if_send_reply returns -EAGAIN.
Consider possible other anomalies scenes. In order to get diagnostic information, it is better to replace "many" with error code.

Modify as follow:
if (--retries < 0) {
	printk(KERN_WARNING "Send reply failed, error %d\n", err);
	break;
}

> Also one could discuss wether the problem that originates "from external"
> should be KERN_ERR, or maybe just a warning, because the kernel itself can do
> little against that problem, and it's not a "kernel error" after all ;-)

You are right, This problem scene rarely appears .it is friendly to replace the error with warning.

> 
> Regards,
> Ulrich
> 
> 
> 

Thanks,
Bo Wu
