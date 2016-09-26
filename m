From: Iago Abal <mail@iagoabal.eu>
Subject: Potential double spin_lock_irqsave BUG in Linux 4.8's drivers/scsi/megaraid/megaraid_mbox.c
Date: Mon, 26 Sep 2016 16:20:25 +0200
Message-ID: <CAGbDTvr8_az+uJA1_5giN3hHSL_B-tt-_+b3e350jc3Jn9xd4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33848 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034290AbcIZOVH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 10:21:07 -0400
Received: by mail-wm0-f68.google.com with SMTP id l132so14330609wmf.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2016 07:21:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

Hi,

Using a static bug finder (EBA - https://github.com/models-team/eba) I
may have found a double spin_lock_irqsave bug in Linux 4.8's
drivers/scsi/megaraid/megaraid_mbox.c.

The forward trace is as follows:

1. Starting in function `megaraid_reset_handler' at 2571;
   (see https://github.com/torvalds/linux/blob/v4.8-rc8/drivers/scsi/megaraid/megaraid_mbox.c#L2571)
2. take `&adapter->pend_list_lock' for the first time at 2602:

       spin_lock_irqsave(PENDING_LIST_LOCK(adapter), flags);

3. enter the `list_for_each_entry_safe' loop at 2603;
4. if (scb->sno >= MBOX_MAX_SCSI_CMDS) evaluates to `true' at 2606;
5. call `megaraid_mbox_mm_done' passing `adapter' at 2616 (go to line 3752);
   (see https://github.com/torvalds/linux/blob/v4.8-rc8/drivers/scsi/megaraid/megaraid_mbox.c#L3752)
6. if (raw_mbox[0] == FC_DEL_LOGDRV && raw_mbox[2] == OP_DEL_LOGDRV)
evaluates to `true' at 3778;
7. call `megaraid_mbox_runpendq' at 3782 (go to line 1886);
   (see https://github.com/torvalds/linux/blob/v4.8-rc8/drivers/scsi/megaraid/megaraid_mbox.c#L1886)
8. take `&adapter->pend_list_lock' for the second time at 1892:

       spin_lock_irqsave(PENDING_LIST_LOCK(adapter), flags);

If that's a bug then I am willing to help with a patch.

Thank you for your time,

-- iago
