From: Ani Sinha <ani@aristanetworks.com>
Subject: scsi_requeue_command and dropping reference to sdev_gendev
Date: Mon, 23 Jul 2012 21:13:07 -0700
Message-ID: <CAOxq_8N=t0ramZXQ2O49MbQ2KC3k7D-3Uya93nTo3PY3HhF7Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55694 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2GXENI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2012 00:13:08 -0400
Received: by ghrr11 with SMTP id r11so6244220ghr.19
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jul 2012 21:13:07 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Francesco Ruggeri <fruggeri@aristanetworks.com>

Hi :

I am looking at the latest upstream code and I see a potential issue :

- scsi_requeue_command() drops reference to scsi_device->sdev_gendev in
scsi_unprep_request->scsi_put_command()->__scsi_put_command(). This can
trigger the cleanup routine scsi_device_dev_release_usercontext() that
will deallocate the sdev->request_queue in blk_put_queue() call. This can
cause potential problems in scsi_requeue_command() when it calls
scsi_run_queue().

Am I missing something here?

Any suggestion will be greatly appreciated.

Thanks,
Ani
