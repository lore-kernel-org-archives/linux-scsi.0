Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DC6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Mar 2022 20:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiCYUgZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiCYUgY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2022 16:36:24 -0400
X-Greylist: delayed 1844 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Mar 2022 13:34:47 PDT
Received: from mx.dolansoft.org (s2.dolansoft.org [212.51.146.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F1C20F40
        for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2022 13:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=brun.one;
        s=s1; h=Sender:Content-Type:MIME-Version:Message-Id:To:Subject:From:Date:
        Content-Transfer-Encoding:Reply-To:Cc:Content-ID:Content-Description:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xIYbi2PR3tW4fgA7n/eIUY9ac2uNUhwY9UZQOH/Jqp8=; b=JANpw1Op5xD8n1PUbgvbaM1d8z
        k/ybgoT/+CmtHOZ8A8N6IP0GYvV0FhNcuo8oTdTrUs3hKuiDF9hi8FBazmyOzlYYPq6yxUsnmfO/V
        AuKTb1yh5SSygcQXtKPFZsXrPInaTS8TK4Eo158A7MZPjtjlJEgX8SS8NQznuv0QhZLGPNU4YcJ0V
        81wBD0FKFvLUflBelkqR4O8WqGZbL4XG+BmYujaCBj9zNcQpu2NAabWAw2RaaMyi7SmjZYqfODtnJ
        nNAlbME1WyX2OwTfCIHy57mGPNOPRMpdwm3qHW4jyt21skzTMEbp/86vjJJuaTLYO6FFMf/ReU5uN
        Wyt4AaKA==;
Received: from [212.51.153.77] (helo=[192.168.12.14])
        by mx.dolansoft.org with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lorenz@dolansoft.org>)
        id 1nXqAB-0003nE-Q7
        for linux-scsi@vger.kernel.org; Fri, 25 Mar 2022 20:03:59 +0000
Date:   Fri, 25 Mar 2022 21:03:53 +0100
From:   Lorenz Brun <lorenz@brun.one>
Subject: Hang in __scsi_execute / scsi_block_when_processing_errors
To:     linux-scsi@vger.kernel.org
Message-Id: <H2HB9R.P272FLOBSW633@brun.one>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: lorenz@dolansoft.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi linux-scsi list,

I recently encountered the following kernel hang (i.e. all accessing 
processes got stuck in interruptible IO wait) when an SSD attached to 
an AHCI controller failed catastrophically. That disk was part of a 
software RAID which got taken down by that and only recovered after a 
reboot. I captured all kernel call stacks of the stuck threads and the 
only ones I think are related to disk access are these two:

[15311630.338000] task:smart-exporter state:D stack: 0 pid:1519832 
ppid: 1 flags:0x00000080
[15311630.347127] Call Trace:
[15311630.350345] __schedule+0x457/0x860
[15311630.354722] schedule+0x46/0xb0
[15311630.358740] scsi_block_when_processing_errors+0xb7/0xc0 [scsi_mod]
[15311630.365882] ? wait_woken+0x70/0x70
[15311630.370267] sd_print_result+0x2b18/0x3500 [sd_mod]
[15311630.376034] __blkdev_get+0x22c/0x620
[15311630.380580] blkdev_get+0x40/0xb0
[15311630.384753] ? bd_acquire+0xc0/0xc0
[15311630.389103] do_dentry_open+0x14b/0x360
[15311630.393796] path_openat+0xa57/0x1010
[15311630.398327] ? perf_mux_hrtimer_restart+0x3f/0xb0
[15311630.403912] ? perf_event_update_userpage+0xd8/0x120
[15311630.409696] do_filp_open+0x91/0x100
[15311630.413872] ? perf_mux_hrtimer_handler+0x130/0x370
[15311630.419367] ? perf_event_addr_filters_sync+0x80/0x80
[15311630.425006] ? __check_object_size+0x136/0x150
[15311630.430035] do_sys_openat2+0x222/0x2e0
[15311630.434675] do_sys_open+0x44/0x80
[15311630.438665] do_syscall_64+0x33/0x40
[15311630.442814] entry_SYSCALL_64_after_hwframe+0x44/0xa9

That is smart-exporter (https://github.com/lorenz/smart-exporter) 
getting stuck even though it sets a timeout of 2s on its SCSI operation.

[15311639.315986] task:bash state:D stack: 0 pid:809422 ppid:809421 
flags:0x00004084
[15311639.325262] Call Trace:
[15311639.328583] __schedule+0x457/0x860
[15311639.332880] ? lock_timer_base+0x61/0x80
[15311639.337625] schedule+0x46/0xb0
[15311639.341372] schedule_timeout+0x199/0x2a0
[15311639.345979] ? __next_timer_interrupt+0x110/0x110
[15311639.351275] io_schedule_timeout+0x19/0x40
[15311639.355990] wait_for_completion_io_timeout+0x8b/0x100
[15311639.361724] blk_execute_rq+0x69/0xa0
[15311639.365982] __scsi_execute+0xe8/0x250 [scsi_mod]
[15311639.371286] sd_print_result+0x2f6b/0x3500 [sd_mod]
[15311639.376764] sd_print_result+0x33c7/0x3500 [sd_mod]
[15311639.382235] sd_print_result+0x34aa/0x3500 [sd_mod]
[15311639.387718] device_release_driver_internal+0xf6/0x1d0
[15311639.393454] bus_remove_device+0xdb/0x140
[15311639.398049] device_del+0x18b/0x420
[15311639.402128] ? ata_std_error_handler+0xd0/0x720 [libata]
[15311639.408030] ? attribute_container_device_trigger+0xb4/0xf0
[15311639.414206] __scsi_remove_device+0x118/0x150 [scsi_mod]
[15311639.420164] scsi_remove_device+0x22/0xc0 [scsi_mod]
[15311639.425731] scsi_remove_device+0x7f/0xc0 [scsi_mod]
[15311639.431307] kernfs_fop_write_iter+0x128/0x1c0
[15311639.436360] new_sync_write+0x11f/0x1b0
[15311639.440835] vfs_write+0x1c0/0x280
[15311639.444823] ksys_write+0x5f/0xe0
[15311639.448770] do_syscall_64+0x33/0x40
[15311639.452926] entry_SYSCALL_64_after_hwframe+0x44/0xa9

This is me trying to manually release the SCSI device (i.e. echo 1 > 
/sys/.../scsi_device/.../delete). I sadly don't have call stacks from 
before trying to do this.

Kernel log excerpt (tons of those in a very short time):
[15307375.115712] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 
0x0
[15307375.122465] ata3.00: irq_stat 0x40000001
[15307375.126716] ata3.00: failed command: FLUSH CACHE
[15307375.131628] ata3.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 
23
                           res 51/04:00:00:00:00/00:00:00:00:00/a0 
Emask 0x1 (device error)
[15307375.146278] ata3.00: status: { DRDY ERR }
[15307375.150596] ata3.00: error: { ABRT }
[15307375.154691] ata3.00: failed to read native max address 
(err_mask=0x1)
[15307375.161442] ata3.00: HPA support seems broken, skipping HPA 
handling
[15307375.168099] ata3.00: supports DRM functions and may not be fully 
accessible
[15307375.175377] ata3.00: failed to enable AA (error_mask=0x1)
[15307375.181122] ata3.00: NCQ Send/Recv Log not supported
[15307375.186435] ata3.00: failed to get Identify Device Data, Emask 0x1
[15307375.186467] ata3.00: ATA Identify Device Log not supported
[15307375.192273] ata3.00: Security Log not supported
[15307375.197244] ata3.00: supports DRM functions and may not be fully 
accessible
[15307375.204513] ata3.00: failed to enable AA (error_mask=0x1)
[15307375.210227] ata3.00: NCQ Send/Recv Log not supported
[15307375.215504] ata3.00: failed to get Identify Device Data, Emask 0x1
[15307375.215521] ata3.00: ATA Identify Device Log not supported
[15307375.221311] ata3.00: Security Log not supported
[15307375.226131] ata3.00: configured for UDMA/133 (device error 
ignored)
[15307375.233011] ata3.00: device reported invalid CHS sector 0
[15307375.239165] ata3: EH complete

[15307375.912022] sd 3:0:0:0: [sdc] tag#18 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[15307375.922363] sd 3:0:0:0: [sdc] tag#18 Sense Key : Illegal Request 
[current]
[15307375.930014] sd 3:0:0:0: [sdc] tag#18 Add. Sense: Unaligned write 
command
[15307375.937707] sd 3:0:0:0: [sdc] tag#18 CDB: Synchronize Cache(10) 
35 00 00 00 00 00 00 00 00 00
[15307375.946906] blk_update_request: I/O error, dev sdc, sector 0 op 
0x0:(READ) flags 0x800 phys_seg 0 prio class 0
[15307375.957992] zio pool=hdd8x3 
vdev=/dev/disk/by-id/ata-Samsung_SSD_850_EVO_120GB_S21UNXAGC03019B-part1 
error=5 type=5 offset=0 size=0 flags=100480
[15307375.972083] ata3: EH complete
[15307376.742718] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 
0x0
[15307376.749882] ata3.00: irq_stat 0x40000001
[15307376.754518] ata3.00: failed command: WRITE DMA
[15307376.759749] ata3.00: cmd ca/00:08:e0:5b:17/00:00:00:00:00/e0 tag 
2 dma 4096 out
                           res 51/04:08:e0:5b:17/00:00:00:00:00/e0 
Emask 0x1 (device error)
[15307376.776310] ata3.00: status: { DRDY ERR }
[15307376.781371] ata3.00: error: { ABRT }
[15307376.785817] ata3.00: supports DRM functions and may not be fully 
accessible
[15307376.793544] ata3.00: failed to enable AA (error_mask=0x1)
[15307376.799834] ata3.00: NCQ Send/Recv Log not supported
[15307376.805610] ata3.00: failed to get Identify Device Data, Emask 0x1
[15307376.805630] ata3.00: ATA Identify Device Log not supported
[15307376.811841] ata3.00: Security Log not supported
[15307376.817221] ata3.00: supports DRM functions and may not be fully 
accessible
[15307376.824942] ata3.00: failed to enable AA (error_mask=0x1)
[15307376.831139] ata3.00: NCQ Send/Recv Log not supported
[15307376.836839] ata3.00: failed to get Identify Device Data, Emask 0x1
[15307376.836859] ata3.00: ATA Identify Device Log not supported
[15307376.843070] ata3.00: Security Log not supported
[15307376.848308] ata3.00: configured for UDMA/133 (device error 
ignored)

Any idea why and where this locked up instead of either dropping the 
disk entirely (it could no longer be identified after all) or just 
rejected all IO (then the software RAID would've just thrown it out 
instead of hanging)?

Regards,
Lorenz


