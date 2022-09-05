Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6870ECAAD3
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Sep 2022 17:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiIERkx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Sep 2022 13:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiIERkw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Sep 2022 13:40:52 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C4828704
        for <linux-scsi@vger.kernel.org>; Mon,  5 Sep 2022 10:40:51 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id q15so9115711pfn.11
        for <linux-scsi@vger.kernel.org>; Mon, 05 Sep 2022 10:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=rPEqF/kCJ1Ce5s+YMC4wzaNAHEIxIfz6CvorWqdp7RA=;
        b=WdkmDL+IC+SkCs7mujG+hRn45TN29/qwzchq5zX/YXf8GtaSCNwjehbRZmxO426TIg
         KAfgS69Z7tVFuWzcSpD8u8bb0/VimovAHu9mj9PXbWamaZrigA4J4Fs7GbFzFfKoHk19
         O9zSsl5N+PN6jA12dir7gmDyMA1rDx2IiEaWNInMzG1WhacmUrQJL3pnt5QOX8AGbhk7
         7nkM/oAH0TbJT90Ow2pe5WfBlYiTaFZQpRC9NcEtq95vOGJe0ngpgXBiHEWRBPYyfhJs
         JuZZNA74Am3me23ef/M4hY5FyTY20CyRxu0vOgiPOHEfXHUx4ATtw07VdPw2vD7xIwgk
         tkIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=rPEqF/kCJ1Ce5s+YMC4wzaNAHEIxIfz6CvorWqdp7RA=;
        b=j6d3FDnrWig0iBj1OQWIPLCFMqv6kN5qT/6N6KxI91mf5ltmvE7s3PNWg5V556iN2Q
         FLp3/TRS6ZHHifcIQMf90rjZQ6l5i51Z6YWhG7GdKCpE7zWdi+ZIMWI8E7eAiFPqUp6t
         2h61J80NbN0V28TKMUUcMnU49T13a6hTXmYZduONlgK1KKWsoSJXFcCSpiAUBWs8OvvR
         nMTQl3NOTsomoc6o1s25rgo5xgjc3KGmZBfPicWKv7g14QD7TOPdnUPb9E0D/PLeDuo2
         BZlkMuZ3zJx7O0le7Mphh/RyKrD6WPjorp6wXa+M0sHT8pHvCSFFaXw9SVRwgP/m5X8C
         G4uA==
X-Gm-Message-State: ACgBeo0zethFkpZMwY0fevGwEdQxliOZfsuZxP37mENy1QeJzZ5o5Tev
        nbDTas78KfJVz1HkeuF+F5E=
X-Google-Smtp-Source: AA6agR4kxW+YBcBeY7g1Py6WZQVR4yhIY1nlkESKtJFWHhfTvFSyXTv2QkXv4K2A+H2ascHC2oI1XA==
X-Received: by 2002:a05:6a00:c96:b0:52e:979c:dd63 with SMTP id a22-20020a056a000c9600b0052e979cdd63mr51824766pfv.50.1662399650741;
        Mon, 05 Sep 2022 10:40:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902c08600b0016d1f474653sm7843455pld.52.2022.09.05.10.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 10:40:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Sep 2022 10:40:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v5 2/4] scsi: core: Make sure that hosts outlive targets
Message-ID: <20220905173905.GA3405134@roeck-us.net>
References: <20220728221851.1822295-1-bvanassche@acm.org>
 <20220728221851.1822295-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728221851.1822295-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 28, 2022 at 03:18:49PM -0700, Bart Van Assche wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> Fix the race conditions between SCSI LLD kernel module unloading and SCSI
> device and target removal by making sure that SCSI hosts are destroyed after
> all associated target and device objects have been freed.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> [ bvanassche: Reworked Ming's patch and split it ]

I know this has been reported before, but it is still seen in the
upstream kernel, so:

This patch results in a deadlock if a USB storage device is removed.

[   29.291148] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   29.300064] ci_hdrc ci_hdrc.1: remove, state 4
[   29.300317] usb usb2: USB disconnect, device number 1
[   29.305090] ci_hdrc ci_hdrc.1: USB bus 2 deregistered
[   29.307052] ci_hdrc ci_hdrc.0: remove, state 1
[   29.307214] usb usb1: USB disconnect, device number 1
[   29.307321] usb 1-1: USB disconnect, device number 2
[   29.344575] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   29.345323] sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[   63.358569] INFO: task init:347 blocked for more than 30 seconds.
[   63.358928]       Tainted: G        W        N 6.0.0-rc4-00017-gcec18aa4b63a #1
[   63.359200] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   63.359600] task:init            state:D stack:    0 pid:  347 ppid:     1 flags:0x00000000
[   63.360104]  __schedule from schedule+0x60/0xbc
[   63.360368]  schedule from scsi_remove_host+0x154/0x1c0
[   63.360602]  scsi_remove_host from usb_stor_disconnect+0x4c/0xac
[   63.360852]  usb_stor_disconnect from usb_unbind_interface+0x74/0x268
[   63.361100]  usb_unbind_interface from device_release_driver_internal+0x1a0/0x22c
[   63.361383]  device_release_driver_internal from bus_remove_device+0xcc/0xfc
[   63.361651]  bus_remove_device from device_del+0x16c/0x3f8
[   63.361877]  device_del from usb_disable_device+0xcc/0x178
[   63.362097]  usb_disable_device from usb_disconnect+0xd0/0x230
[   63.362325]  usb_disconnect from usb_disconnect+0x9c/0x230
[   63.362536]  usb_disconnect from usb_remove_hcd+0xd0/0x16c
[   63.362741]  usb_remove_hcd from host_stop+0x38/0xa8
[   63.362946]  host_stop from ci_hdrc_remove+0x44/0x120
[   63.363148]  ci_hdrc_remove from platform_remove+0x20/0x4c
[   63.363367]  platform_remove from device_release_driver_internal+0x1a0/0x22c
[   63.363635]  device_release_driver_internal from bus_remove_device+0xcc/0xfc
[   63.363897]  bus_remove_device from device_del+0x16c/0x3f8
[   63.364117]  device_del from platform_device_del.part.0+0x10/0x74
[   63.364353]  platform_device_del.part.0 from platform_device_unregister+0x18/0x24
[   63.364623]  platform_device_unregister from ci_hdrc_remove_device+0xc/0x20
[   63.364886]  ci_hdrc_remove_device from ci_hdrc_imx_remove+0x28/0x110
[   63.365131]  ci_hdrc_imx_remove from device_shutdown+0x174/0x250
[   63.365372]  device_shutdown from __do_sys_reboot+0x124/0x270
[   63.365616]  __do_sys_reboot from ret_fast_syscall+0x0/0x1c
[   63.365849] Exception stack(0xd1859fa8 to 0xd1859ff0)
[   63.366054] 9fa0:                   01234567 000c623f fee1dead 28121969 01234567 00000000
[   63.366343] 9fc0: 01234567 000c623f 00000001 00000058 000d85c0 00000000 00000000 00000000
[   63.366620] 9fe0: 000d8298 bef49de4 000918bc b6e8cedc
[   63.366881] INFO: lockdep is turned off.
[   63.367069] Kernel panic - not syncing: hung_task: blocked tasks

I understand that it looks like the problem is caused by the shutdown
function in the imx driver calling remove_device, but that is not really
the problem.

As can be seen in the backtrace, usb_stor_disconnect() calls
scsi_remove_host(). Thanks to this patch, scsi_remove_host() now
waits for the scsi release function to be called. However,
usb_stor_disconnect() only calls release_everything() and with it
scsi_host_put() _after_ scsi_remove_host() has returned. Since
scsi_remove_host() now waits for the resource which is released
by calling scsi_host_put(), this causes a deadlock.

If my analysis is correct, any USB storage device removal should
result in the deadlock. My analysis may of course be wrong. If so,
please let me know what I missed.

Thanks,
Guenter
