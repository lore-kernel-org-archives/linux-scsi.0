Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B0AEB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 14:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344926AbjFOOu4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jun 2023 10:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240656AbjFOOux (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jun 2023 10:50:53 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 6DCFA273C
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2023 07:50:51 -0700 (PDT)
Received: (qmail 497970 invoked by uid 1000); 15 Jun 2023 10:50:50 -0400
Date:   Thu, 15 Jun 2023 10:50:50 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hannes Reinecke <hare@suse.de>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH] ata: libata-scsi: Avoid deadlock on rescan after device
 resume
Message-ID: <b35c2137-6469-4d30-a25c-096e4932fe1b@rowland.harvard.edu>
References: <20230615083326.161875-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615083326.161875-1-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 15, 2023 at 05:33:26PM +0900, Damien Le Moal wrote:
> When an ATA port is resumed from sleep, the port is reset and a power
> management request issued to libata EH to reset the port and rescanning
> the device(s) attached to the port. Device rescanning is done by
> scheduling an ata_scsi_dev_rescan() work, which will execute
> scsi_rescan_device().
> 
> However, scsi_rescan_device() takes the generic device lock, which is
> also taken by dpm_resume() when the SCSI device is resumed as well. If
> a device rescan execution starts before the completion of the SCSI
> device resume, the rcu locking used to refresh the cached VPD pages of
> the device, combined with the generic device locking from
> scsi_rescan_device() and from dpm_resume() can cause a deadlock.
> 
> Avoid this situation by changing struct ata_port scsi_rescan_task to be
> a delayed work instead of a simple work_struct. ata_scsi_dev_rescan() is
> modified to check if the SCSI device associated with the ATA device that
> must be rescanned is not suspended. If the SCSI device is still
> suspended, ata_scsi_dev_rescan() returns early and reschedule itself for
> execution after an arbitrary delay of 5ms.

I don't understand the nature of the relationship between the ATA port
and the corresponding SCSI device.  Maybe you could explain it more
fully, if you have time.

But in any case, this approach seems like a layering violation.  Why not 
instead call a SCSI utility routine to set a "needs_rescan" flag in the 
scsi_device structure?  Then scsi_device_resume() could automatically 
call scsi_rescan_device() -- or rather an internal version that assumes 
the device lock is already held -- if the flag is set.  Or it could 
queue a non-delayed work routine to do this.  (Is it important to have 
the rescan finish before userspace starts up and tries to access the ATA 
device again?)

That, combined with a guaranteed order of resuming, would do what you 
want, right?

Alan Stern
