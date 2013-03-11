From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] [SCSI] Wake blockdev queue in scsi_internal_device_unblock()
 for SDEV_RUNNING
Date: Mon, 11 Mar 2013 10:50:45 -0700
Message-ID: <CAL1RGDU_9q03HWaEMGhFQf0jhgv48o1wMS6bBTvaYmgg7KTz8Q@mail.gmail.com>
References: <1361814905-7201-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:57195 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751181Ab3CKRvH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Mar 2013 13:51:07 -0400
Received: by mail-ee0-f69.google.com with SMTP id e49so7141266eek.4
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 10:51:05 -0700 (PDT)
In-Reply-To: <1361814905-7201-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

> With the old scsi_lib code, scsi_internal_device_unblock() will return
> an error at this point because the sdev state is already SDEV_RUNNING.
> This means we skip the call to blk_start_queue() and never actually
> start executing commands again.
>
> Fix this by still going ahead and finishing scsi_internal_device_unblock()
> even if the sdev state is already SDEV_RUNNING.

Any thoughts on this patch?  Without this patch, on a moderate size
system (a couple of mpt2sas adapters and 50 or so SAS devices) we seem
to hit the bug and get stuck every 20 boots or so.  The only way to
recover is to reboot.

 - R.
