Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B86E7D0A7
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 20:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjIUUKl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjIUUJ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 16:09:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71327A12C;
        Thu, 21 Sep 2023 12:53:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A149C433C8;
        Thu, 21 Sep 2023 19:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695326032;
        bh=9tegRpBn0T7ZwEv7hvddeZlERiRItKLoI9ZsE/YWkMc=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=dtp/wudWE0lRsa0DaxQrOfkAlSIv3LkFgy6iGkBu4WdM841oiUQyuZbTFih40t3Bx
         pFPYLYHirDkUoLTwt51ztuI9sl5jnxr8iJqC2/Y5WrqChzEhG3KtxPq/WXUZM0FfGm
         FtUEZma+wgVj/wrcvF49dLIGfqc+rZaSScij7CgehEEY1Jbst3gHnUjRYNNE8gb7nk
         eBvbG0hdZO9/vq+NqjJl3m1EuGyMrm2RBAlO7RqH1r2lTNqZk0rX+RIUjfxpNTS+vr
         b+8ITHxZ2oCFByIsaHp+SU3xEzi7sCC7o/0fJtKEuYr8QtsVdRXVX2x9Yek/Uyo7sS
         OBzwA2BOcKzPA==
Message-ID: <09688c78-6708-fa1e-1447-3105b69ccb49@kernel.org>
Date:   Thu, 21 Sep 2023 12:53:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v4 00/23] Fix libata suspend/resume handling and code
 cleanup
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org
References: <20230920135439.929695-1-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20230920135439.929695-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/20 6:54, Damien Le Moal wrote:
> The first 9 patches of this series fix several issues with suspend/resume
> power management operations in scsi and libata. The most significant
> changes introduced are in patch 4 and 5, where the manage_start_stop
> flag of scsi devices is split into the manage_system_start_stop and
> manage_runtime_start_stop flags to allow keeping scsi runtime power
> operations for spining up/down ATA devices but have libata do its own
> system suspend/resume device power state management using EH.
> 
> The remaining patches are code cleanup that do not introduce any
> significant functional change.

Martin,

Could you please review and Ack (if appropriate) the scsi bits of this series ?
I would like to send out the first 9 patches ASAP to address regressions.
Thanks !

> 
> This series was tested on qemu and on various PCs and servers. I am
> CC-ing people who recently reported issues with suspend/resume.
> Additional testing would be much appreciated.
> 
> Changes from v3:
>  * Corrected pathc 1 (typo in commit message and WARN_ON() removal)
>  * Changed path 3 as suggested by Niklas (moved definition of
>    ->slave_alloc)
>  * Rebased on rc2
>  * Added review tags
> 
> Changes from v2:
>  * Added patch 4 as simply disabling manage_start_stop from libata was
>    breaking individual disk runtime suspend/autosuspend. Patch 5 was
>    reworked accordingly to the changes in patch 4.
>  * Fixed patch 3: applying the link creation was missing and the link
>    creation itself was also incorrect, preventing sd probe to execute
>    correctly. Thanks to Geert for testing and reporting this issue.
>  * Split the "Fix delayed scsi_rescan_device() execution" patch into
>    patch 6 (scsi part) and patch 7 (ata part).
>  * Modified patch 9 to not call sd_shutdown() from sd_remove() for
>    devices that are not running.
>  * Added Chia-Lin Tested tag to unchanged patches
> 
> Changes from v1:
>  * Added patch 8 and 9 to fix compilation warnings with W=1
>  * Addressed John comment in patch 19
>  * Fixed patch 20 commit message (Sergei)
>  * Added Hannes Review tag
> 
> Damien Le Moal (23):
>   ata: libata-core: Fix ata_port_request_pm() locking
>   ata: libata-core: Fix port and device removal
>   ata: libata-scsi: link ata port and scsi device
>   scsi: sd: Differentiate system and runtime start/stop management
>   ata: libata-scsi: Disable scsi device manage_system_start_stop
>   scsi: Do not attempt to rescan suspended devices
>   ata: libata-scsi: Fix delayed scsi_rescan_device() execution
>   ata: libata-core: Do not register PM operations for SAS ports
>   scsi: sd: Do not issue commands to suspended disks on shutdown
>   ata: libata-core: Fix compilation warning in ata_dev_config_ncq()
>   ata: libata-eh: Fix compilation warning in ata_eh_link_report()
>   scsi: Remove scsi device no_start_on_resume flag
>   ata: libata-scsi: Cleanup ata_scsi_start_stop_xlat()
>   ata: libata-core: Synchronize ata_port_detach() with hotplug
>   ata: libata-core: Detach a port devices on shutdown
>   ata: libata-core: Remove ata_port_suspend_async()
>   ata: libata-core: Remove ata_port_resume_async()
>   ata: libata-core: Do not poweroff runtime suspended ports
>   ata: libata-core: Do not resume runtime suspended ports
>   ata: libata-sata: Improve ata_sas_slave_configure()
>   ata: libata-eh: Improve reset error messages
>   ata: libata-eh: Reduce "disable device" message verbosity
>   ata: libata: Cleanup inline DMA helper functions
> 
>  drivers/ata/libata-core.c      | 242 +++++++++++++++++++++++++--------
>  drivers/ata/libata-eh.c        |  76 +++++++++--
>  drivers/ata/libata-sata.c      |   5 +-
>  drivers/ata/libata-scsi.c      | 146 ++++++++++----------
>  drivers/ata/libata-transport.c |   9 +-
>  drivers/ata/libata.h           |   7 +
>  drivers/firewire/sbp2.c        |   9 +-
>  drivers/scsi/scsi_scan.c       |  18 ++-
>  drivers/scsi/sd.c              |  88 ++++++++----
>  include/linux/libata.h         |  26 ++--
>  include/scsi/scsi_device.h     |   4 +-
>  include/scsi/scsi_host.h       |   2 +-
>  12 files changed, 444 insertions(+), 188 deletions(-)
> 

-- 
Damien Le Moal
Western Digital Research

