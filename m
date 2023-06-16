Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00DDEB64DA
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jun 2023 05:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240557AbjFPF3E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jun 2023 01:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjFPF3C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2023 01:29:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BFB2943;
        Thu, 15 Jun 2023 22:29:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A1E961D26;
        Fri, 16 Jun 2023 05:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69279C433C0;
        Fri, 16 Jun 2023 05:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686893340;
        bh=+LFbEsDoKkaZ3ud3/Y+KfAea0y40S8PTqFqGPdC1SEY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IxGEpi3xImEaXgRZ0396LAhIUnuZ1EljdGdyzrbywmNUhNimr/H153QXy8uy/GTnB
         bsao2OAj5dJ96DEjaMo1Ml1Cddzg9jGLuxbKd9xBsR80G5ae6F15H7Y2rnMaBu524r
         QQPBpDalo2JV55Xl4YxQY4Uf00oX+TLrXnMdjVOplYbMDBTJ8H6HXD6iH/rcjDAPA9
         2OsvwilIu1RpmJuez5PKrlVLz9yP8uUxQQSTiASB1piqS8xaeZFdpMX0Fc2jqsWAjX
         qMJlLZG7oTVn9/wqOaiIP1UQfdzhztVognOHI/soTw5rdAW0oO0bsoPlHxVu2ZDKuE
         2KkeCNddKr3aQ==
Message-ID: <d2b07c31-fa2b-017d-6aeb-ad263881771f@kernel.org>
Date:   Fri, 16 Jun 2023 14:28:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] ata: libata-scsi: Avoid deadlock on rescan after device
 resume
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Hannes Reinecke <hare@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J . Wysocki" <rafael@kernel.org>
References: <20230615083326.161875-1-dlemoal@kernel.org>
 <CAAd53p6PMhNO8PynWAw5xz_gEOp+NQv18XKkW-M-r=JfHWT6FQ@mail.gmail.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CAAd53p6PMhNO8PynWAw5xz_gEOp+NQv18XKkW-M-r=JfHWT6FQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/23 12:31, Kai-Heng Feng wrote:
> On Thu, Jun 15, 2023 at 4:33 PM Damien Le Moal <dlemoal@kernel.org> wrote:
>>
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
>>
>> Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> Reported-by: Joe Breuer <linux-kernel@jmbreuer.net>
>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217530
>> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> 
> Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Thanks !

Joe,

Did you have a chance to test ?

-- 
Damien Le Moal
Western Digital Research

