From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: how to enlarge value of max_sectors_kb
Date: Wed, 17 Jan 2018 01:10:40 -0500
Message-ID: <yq1mv1dt3q7.fsf@oracle.com>
References: <1515830004-5476-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33896 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbeAQGKt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 01:10:49 -0500
In-Reply-To: <1515830004-5476-1-git-send-email-tang.junhui@zte.com.cn> (tang
        junhui's message of "Sat, 13 Jan 2018 15:53:24 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: hare@suse.de, kartilak@cisco.com, sebaddel@cisco.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org


Tang,

> There is a machine with very little max_sectors_kb size:
> [root@ceph151 queue]# pwd
> /sys/block/sdd/queue
> [root@ceph151 queue]# cat max_hw_sectors_kb 
> 256
> [root@ceph151 queue]# cat max_sectors_kb 
> 256
>
> The performance is very low when I run big I/Os.
> I can not modify it directly, I need a little bigger,
> so how can I enlarge it?

max_hw_sectors_kb is set based on the DMA transfer capabilities of the
SCSI controller.

max_sectors_kb is a soft limit for regular filesystem I/O. It can not
exceed max_hw_sectors_kb since that would violate the hardware
constraints.

You need to figure out why your controller is limiting the transfer
size.

-- 
Martin K. Petersen	Oracle Linux Engineering
