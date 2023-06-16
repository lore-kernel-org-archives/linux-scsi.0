Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81BBEB64DA
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jun 2023 05:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240464AbjFPFZq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jun 2023 01:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbjFPFZm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2023 01:25:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56AD295C;
        Thu, 15 Jun 2023 22:25:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62FB761B32;
        Fri, 16 Jun 2023 05:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9324C433C0;
        Fri, 16 Jun 2023 05:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686893140;
        bh=0P0wrasrCgXZzrKHXlA06kDu5VKwPjFjqvwNI9f6Wz0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kLN2n8cNZGLxkLMsrpQ8gODYNWnEMpMmepoSOezoy0XSkSM+YwQ14iREoh6zHQ3PB
         k3ee27a0ct6yNL+ggl21kvKxcMQf3RPY+UPvNEzrvyVQzY1VVxpDzPg6azNj67QqL2
         AUXoBoCN/CpEPKbttc4xZctjirbwaaywez9skdL3MMnWdHyheive6lRwCZGaPxexMG
         EJrDgggVm3k2TjwT4OzQdactNfTZ/SWcUUSi3pUFgXRvubhtlGHqrF72K/XZsSel/o
         LNu1ZV83mZh65kQ0Vk3NIRFfwY1H3SRlPm6Q1WxpYvN1UzGn0ah0OmQAHFNY1rpvsv
         sGbh9Sv8aIKFg==
Message-ID: <766f0f86-7b2e-51a7-6cc1-b670631105a4@kernel.org>
Date:   Fri, 16 Jun 2023 14:25:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] ata: libata-scsi: Avoid deadlock on rescan after device
 resume
Content-Language: en-US
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hannes Reinecke <hare@suse.de>,
        "Rafael J . Wysocki" <rafael@kernel.org>
References: <20230615083326.161875-1-dlemoal@kernel.org>
 <b35c2137-6469-4d30-a25c-096e4932fe1b@rowland.harvard.edu>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <b35c2137-6469-4d30-a25c-096e4932fe1b@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/15/23 23:50, Alan Stern wrote:
> On Thu, Jun 15, 2023 at 05:33:26PM +0900, Damien Le Moal wrote:
>> When an ATA port is resumed from sleep, the port is reset and a power
>> management request issued to libata EH to reset the port and rescanning
>> the device(s) attached to the port. Device rescanning is done by
>> scheduling an ata_scsi_dev_rescan() work, which will execute
>> scsi_rescan_device().
>>
>> However, scsi_rescan_device() takes the generic device lock, which is
>> also taken by dpm_resume() when the SCSI device is resumed as well. If
>> a device rescan execution starts before the completion of the SCSI
>> device resume, the rcu locking used to refresh the cached VPD pages of
>> the device, combined with the generic device locking from
>> scsi_rescan_device() and from dpm_resume() can cause a deadlock.
>>
>> Avoid this situation by changing struct ata_port scsi_rescan_task to be
>> a delayed work instead of a simple work_struct. ata_scsi_dev_rescan() is
>> modified to check if the SCSI device associated with the ATA device that
>> must be rescanned is not suspended. If the SCSI device is still
>> suspended, ata_scsi_dev_rescan() returns early and reschedule itself for
>> execution after an arbitrary delay of 5ms.
> 
> I don't understand the nature of the relationship between the ATA port
> and the corresponding SCSI device.  Maybe you could explain it more
> fully, if you have time.

For ata devices, the parent -> child relationship is:

ata_host (the adapter) -> ata_port -> ata_link -> ata_device (HDD, SSD or ATAPI
CD/DVD)

For scsi devices representing ATA devices, it is:

ata_port -> scsi_host -> scsi_target -> scsi_device -> scsi_disk (or gendisk for
a CD/DVD)

When devices are scanned, libata will create ports and create a scsi_host for
each port, and a scsi device for each ata_device found on the link(s) for the
port. There is no direct relationship between an ata_device (the HDD or SSD) and
its scsi_device/scsi_disk (the device used to issue commands). The PM operations
we have are for ata_port and scsi_device. For the scsi device, the operations
are actually defined per device type, so in the scsi_disk driver (sd) for HDDs
and SSDs.

> But in any case, this approach seems like a layering violation.  Why not 

The layering violation is I think only with the direct reference to the scsi
device power.is_suspended field, which is definitely not pretty. But there are
some other drivers doing something similar:

$ git grep "power\.is_suspended" | grep -v drivers/base/power/main.c
drivers/gpu/drm/i915/display/intel_display_power_well.c:	if
(!dev_priv->drm.dev->power.is_suspended)
drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c:	if
(!dwmac->dev->power.is_suspended) {
drivers/platform/surface/surface_acpi_notify.c:	if (d->dev->power.is_suspended) {

All the other code (ata calling scsi) is normal per the SCSI-to-ata translation
needed (all ata devices are represented as scsi devices in Linux, following the
SAT=scsi ATA translation specifications).

> instead call a SCSI utility routine to set a "needs_rescan" flag in the 
> scsi_device structure?  Then scsi_device_resume() could automatically 
> call scsi_rescan_device() -- or rather an internal version that assumes 
> the device lock is already held -- if the flag is set.  Or it could 

Yes, ideally, that is what we should do. Such fix is however more involved, and
so I prefer not to push for this right now as a fix for the regression at hand.
But I will definitively look into this.

> queue a non-delayed work routine to do this.  (Is it important to have 
> the rescan finish before userspace starts up and tries to access the ATA 
> device again?)
> 
> That, combined with a guaranteed order of resuming, would do what you 
> want, right?

Yes. But again more fixes needed:
1) libata uses its error handling path to reset a port on resume and probe the
links again. The devices found are then revalidated (IDENTIFY command, reading
log pages etc). This call to EH is triggered in the pm->resume operation, but EH
runs as an asynchronous task. So the port->resume may complete before EH is
done. We need to change the EH call to be synchronous in ->resume
2) We need to remove triggering the task that does scsi_rescan_device() in EH
and move that trigger to scsi_device ->resume.
3) Modify scsi_device ->resume() to call scsi_rescan_device()

Safely doing (3) requires synchronization between ata_port->resume and
scsi_device->resume. We can do that by adding a device link between ata_device
and scsi_device. Doing so, the scsi device becomes the grandchild of the
ata_port and we are guaranteed that its ->resume will happen only once the ata
port ->resume is done.

That will also improve things as we will be able to rescan the scsi device (and
thus catch any change to the device) *before* the device ->resume operation
re-enables issuing user commands by un-quiescing the device request queue.

As you can see, that is all beyond a quick fix for a regression... Will work on
this.

Cheers.

> 
> Alan Stern

-- 
Damien Le Moal
Western Digital Research

