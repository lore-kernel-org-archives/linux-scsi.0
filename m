Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F05CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 14:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C26722B43
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 14:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgLUOca (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 09:32:30 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:32803 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726841AbgLUOca (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Dec 2020 09:32:30 -0500
Received: from [192.168.0.8] (ip5f5aef0c.dynamic.kabel-deutschland.de [95.90.239.12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 8D3FC20647873;
        Mon, 21 Dec 2020 15:31:45 +0100 (CET)
Subject: Re: [PATCH V3 00/25] smartpqi updates
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org, it+linux@molgen.mpg.de
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <788f6ba0-2584-5109-0532-868e37e8f666@molgen.mpg.de>
Date:   Mon, 21 Dec 2020 15:31:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Don,

just wanted to let you know that I've tested this series (plus the three Depends-on patches you mentioned) on top of Linux v5.10.1 with an Adaptec 1100-8e with fw 3.21.

After three hours of heavy operation (including raid scrubbing!) the driver seems to have lost some requests for the md0 member disks

This is the static picture after all activity has ceased:

     root:deadbird:/scratch/local/# for f in /sys/devices/virtual/block/md?/md/rd*/block/inflight;do echo $f: $(cat $f);done
     /sys/devices/virtual/block/md0/md/rd0/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd1/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd10/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd11/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd12/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd13/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd14/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd15/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd2/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd3/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd4/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd5/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd6/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd7/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd8/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd9/block/inflight: 1 0
     /sys/devices/virtual/block/md1/md/rd0/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd1/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd10/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd11/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd12/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd13/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd14/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd15/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd2/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd3/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd4/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd5/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd6/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd7/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd8/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd9/block/inflight: 0 0

Best
   Donald

On 10.12.20 21:34, Don Brace wrote:
> These patches are based on Martin Peterson's 5.11/scsi-queue tree
> 
> Note that these patches depend on the following three patches
> applied to Martin Peterson's tree:
>    https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>    5.11/scsi-queue
> Depends-on: 5443bdc4cc77 scsi: smartpqi: Update version to 1.2.16-012
> Depends-on: 408bdd7e5845 scsi: smartpqi: Correct pqi_sas_smp_handler busy condition
> Depends-on: 1bdf6e934387 scsi: smartpqi: Correct driver removal with HBA disks
> 
> This set of changes consist of:
>    * Add support for newer controller hardware.
>      * Refactor AIO and s/g processing code. (No functional changes)
>      * Add write support for RAID 5/6/1 Raid bypass path (or accelerated I/O path).
>      * Add check for sequential streaming.
>      * Add in new PCI-IDs.
>    * Format changes to re-align with our in-house driver. (No functional changes.)
>    * Correct some issues relating to suspend/hibernation/OFA/shutdown.
>      * Block I/O requests during these conditions.
>    * Add in qdepth limit check to limit outstanding commands.
>      to the max values supported by the controller.
>    * Correct some minor issues found during regression testing.
>    * Update the driver version.
> 
> Changes since V1:
>    * Re-added 32bit calculations to correct i386 compile issues
>      to patch smartpqi-refactor-aio-submission-code
>      Reported-by: kernel test robot <lkp@intel.com>
>      https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/VMBBGGGE5446SVEOQBRCKBTRRWTSH4AB/
> 
> Changes since V2:
>    * Added 32bit division to correct i386 compile issues
>      to patch smartpqi-add-support-for-raid5-and-raid6-writes
>      Reported-by: kernel test robot <lkp@intel.com>
>      https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/ZCXJJDGPPTTXLZCSCGWEY6VXPRB3IFOQ/
> 
> ---
> 
> Don Brace (7):
>        smartpqi: refactor aio submission code
>        smartpqi: refactor build sg list code
>        smartpqi: add support for raid5 and raid6 writes
>        smartpqi: add support for raid1 writes
>        smartpqi: add stream detection
>        smartpqi: add host level stream detection enable
>        smartpqi: update version to 2.1.6-005
> 
> Kevin Barnett (14):
>        smartpqi: add support for product id
>        smartpqi: add support for BMIC sense feature cmd and feature bits
>        smartpqi: update AIO Sub Page 0x02 support
>        smartpqi: add support for long firmware version
>        smartpqi: align code with oob driver
>        smartpqi: enable support for NVMe encryption
>        smartpqi: disable write_same for nvme hba disks
>        smartpqi: fix driver synchronization issues
>        smartpqi: convert snprintf to scnprintf
>        smartpqi: change timing of release of QRM memory during OFA
>        smartpqi: return busy indication for IOCTLs when ofa is active
>        smartpqi: add additional logging for LUN resets
>        smartpqi: correct system hangs when resuming from hibernation
>        smartpqi: add new pci ids
> 
> Mahesh Rajashekhara (1):
>        smartpqi: fix host qdepth limit
> 
> Murthy Bhat (3):
>        smartpqi: add phy id support for the physical drives
>        smartpqi: update sas initiator_port_protocols and target_port_protocols
>        smartpqi: update enclosure identifier in sysf
> 
> 
>   drivers/scsi/smartpqi/smartpqi.h              |  301 +-
>   drivers/scsi/smartpqi/smartpqi_init.c         | 3123 ++++++++++-------
>   .../scsi/smartpqi/smartpqi_sas_transport.c    |   39 +-
>   drivers/scsi/smartpqi/smartpqi_sis.c          |    4 +-
>   4 files changed, 2189 insertions(+), 1278 deletions(-)
> 

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
