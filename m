From: jiangyiwen <jiangyiwen@huawei.com>
Subject: scsi: Adding lock to protect variables of bit-field in struct
 scsi_device
Date: Mon, 5 Dec 2016 14:37:52 +0800
Message-ID: <58450B40.2080205@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:6553 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbcLEGnW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 01:43:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>
Cc: wangyibin@huawei.com, "Subo (A)" <subo7@huawei.com>, "xuejiufei@huawei.com" <xuejiufei@huawei.com>

Hi guys,

I'm sorry if someone else has already asked the same question before,
but here's what we are facing with scsi mid-level.

Variables of bit-field in struct scsi_device are not protected by
lock, such as no_report_opcodes, is_visible and so on. I guess
everyone think these variable can't be accessed by multi-processes,
but unfortunately, I came across one problem as follows:

Assuming there is a process A which is executing the operation of
adding device, so it will call scsi_sysfs_add_sdev, and eventually
it will start an async kworker B to execute sd_probe_async.
In this way, process A will set "sdev->is_visible = 1" in the function
of scsi_sysfs_add_sdev, in the meantime, aysnc kworker B may set
"sdev->no_report_opcodes = 1" in the function of sd_read_write_same.
Neither of the variables are protected by any lock, setting the value
of no_report_opcodes may change value of is_visible from 1 to 0, which
alters the bit field unexpectedly. Did I miss anything?

So I'd like to know whether these variable of bit-field should
be protected by lock or not.

Please advise. Thanks in advance!

Best regards,
Yiwen

