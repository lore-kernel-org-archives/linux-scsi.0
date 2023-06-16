Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814C8EB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jun 2023 05:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240492AbjFPF2X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jun 2023 01:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjFPF2W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2023 01:28:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47E22943;
        Thu, 15 Jun 2023 22:28:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E13160B81;
        Fri, 16 Jun 2023 05:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7652C433C0;
        Fri, 16 Jun 2023 05:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686893300;
        bh=TbYDGoCESiqz1VBcvSqczQ3cVCI9+UJuL++SA85o+aw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ocgyFg9EMzAd/dzQfs+y6JfG3P0B+V6x6XZ07a8ld5k7W03oc0Hl6Fl+qkTp2XfnL
         DgIQf2e+Ej0xdeNWzhdmu/RpRP23AnP36L+e0Egg9yqMCzYGzgyml+zV09TPGv9Abw
         caW34cKoLx69UFRQikB/a9EbzZqOHj36VdSQ7Gq1O/wOxqsYB5lj38tdHNK1GIw0tP
         0ZUIkRe3U7bU8xjGgbTDpdmhBzIll/p7Vyhf9/zvY2s4egD6DllUR1M3I4pDZhoYEy
         XzTNQ/ZLSbQucPemWGaXQdVwnqP9W9x1YxPWNFWhK9PmZC8jihQAVShJyEGzwd0DC0
         E+rJ9O4RoVLEQ==
Message-ID: <a0b41e35-0955-1e8f-6654-9a0c8559e9a4@kernel.org>
Date:   Fri, 16 Jun 2023 14:28:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] ata: libata-scsi: Avoid deadlock on rescan after device
 resume
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Hannes Reinecke <hare@suse.de>,
        "Rafael J . Wysocki" <rafael@kernel.org>
References: <20230615083326.161875-1-dlemoal@kernel.org>
 <b35c2137-6469-4d30-a25c-096e4932fe1b@rowland.harvard.edu>
 <CAAd53p7+-uXf+wiZkAxSPnjSY7oC6crtfKURptuWCuM7vDAMZw@mail.gmail.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CAAd53p7+-uXf+wiZkAxSPnjSY7oC6crtfKURptuWCuM7vDAMZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/23 12:32, Kai-Heng Feng wrote:
> On Thu, Jun 15, 2023 at 10:50 PM Alan Stern <stern@rowland.harvard.edu> wrote:
>>
>> On Thu, Jun 15, 2023 at 05:33:26PM +0900, Damien Le Moal wrote:
>>> When an ATA port is resumed from sleep, the port is reset and a power
>>> management request issued to libata EH to reset the port and rescanning
>>> the device(s) attached to the port. Device rescanning is done by
>>> scheduling an ata_scsi_dev_rescan() work, which will execute
>>> scsi_rescan_device().
>>>
>>> However, scsi_rescan_device() takes the generic device lock, which is
>>> also taken by dpm_resume() when the SCSI device is resumed as well. If
>>> a device rescan execution starts before the completion of the SCSI
>>> device resume, the rcu locking used to refresh the cached VPD pages of
>>> the device, combined with the generic device locking from
>>> scsi_rescan_device() and from dpm_resume() can cause a deadlock.
>>>
>>> Avoid this situation by changing struct ata_port scsi_rescan_task to be
>>> a delayed work instead of a simple work_struct. ata_scsi_dev_rescan() is
>>> modified to check if the SCSI device associated with the ATA device that
>>> must be rescanned is not suspended. If the SCSI device is still
>>> suspended, ata_scsi_dev_rescan() returns early and reschedule itself for
>>> execution after an arbitrary delay of 5ms.
>>
>> I don't understand the nature of the relationship between the ATA port
>> and the corresponding SCSI device.  Maybe you could explain it more
>> fully, if you have time.
>>
>> But in any case, this approach seems like a layering violation.  Why not
>> instead call a SCSI utility routine to set a "needs_rescan" flag in the
>> scsi_device structure?  Then scsi_device_resume() could automatically
>> call scsi_rescan_device() -- or rather an internal version that assumes
>> the device lock is already held -- if the flag is set.  Or it could
>> queue a non-delayed work routine to do this.  (Is it important to have
>> the rescan finish before userspace starts up and tries to access the ATA
>> device again?)
>>
>> That, combined with a guaranteed order of resuming, would do what you
>> want, right?
> 
> What you are suggesting is pretty much like my previous approach:
> https://lore.kernel.org/all/20230502150435.423770-2-kai.heng.feng@canonical.com/

Not really. We need more than what you did. See my reply to Alan.
Your solution is rather similar to what I did but it was delaying the rescan
after the entire system is resumed (pm_suspend_target_state != PM_SUSPEND_ON),
which is really a heavy hammer and would significantly slow down resuming.

> 
> Kai-Heng
> 
>>
>> Alan Stern

-- 
Damien Le Moal
Western Digital Research

