Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02346C43381
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 23:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D11442222A
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 23:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbgL1Wz4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Dec 2020 17:55:56 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:53285 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729644AbgL1Wgv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Dec 2020 17:36:51 -0500
Received: from [192.168.0.8] (ip5f5aef2f.dynamic.kabel-deutschland.de [95.90.239.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9871D2064622D;
        Mon, 28 Dec 2020 23:36:06 +0100 (CET)
Subject: Re: [PATCH V3 00/25] smartpqi updates
To:     Don.Brace@microchip.com, Kevin.Barnett@microchip.com,
        Scott.Teel@microchip.com, Justin.Lindley@microchip.com,
        Scott.Benesh@microchip.com, Gerry.Morong@microchip.com,
        Mahesh.Rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org, it+linux@molgen.mpg.de
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
 <788f6ba0-2584-5109-0532-868e37e8f666@molgen.mpg.de>
 <SN6PR11MB2848D8C9DF9856A2B7AA69ACE1C00@SN6PR11MB2848.namprd11.prod.outlook.com>
 <6436abc3-7200-fb06-bd79-cb71f1fd1037@molgen.mpg.de>
 <SN6PR11MB2848F95706C20BFBBCCADFACE1D90@SN6PR11MB2848.namprd11.prod.outlook.com>
 <SN6PR11MB2848240CF95B791352737DEDE1D90@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <c1cb2c8b-2e38-f6a6-9644-4c34f2d12ca4@molgen.mpg.de>
Date:   Mon, 28 Dec 2020 23:36:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848240CF95B791352737DEDE1D90@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28.12.20 20:25, Don.Brace@microchip.com wrote:

> Can you provide the base OS that you used to build the kernel.org kernel?

GNU/Linux build form scratch, no distribution. gcc-7.5.0

However, after more testing, I'm no longer convinced that deadlock is caused by the block layer.

I've original posted this as an xfs bug "v5.10.1 xfs deadlock" ( https://lkml.org/lkml/2020/12/17/608 )

In that thread it was suggested, that this might be caused by the block layer dropping I/Os. The non-zero inflight counters, I observed, seemed to confirm that, so I posted the same problem to linux-scsi and the relevant maintainers. However, since then I did a lot more tests and while I am now able to reproduce the original deadlock, I am not able to reproduce the non-zero inflight counters and haven't seen them since then.

It is quite clear now, that the deadlock is in the xfs layer and although, I don't fully understand it, I can patch it away now.

I was very eager to test smartpqi 2.1.6-005, which you submitted for linux-next. As you know, we have severe problems with the in-tree 1.2.8-026 smartpqi driver, while the 2.1.8-005 OOT driver, you provided us, did work. However, smartpqi 2.1.6-005 on Linux 5.10 failed for us on the production system, too, and I couldn't continue the tests on this system, so we set up the test system to identify the (potential) problem.

Unfortunately, on this test system, two other problems got in our way, which could be related to the smartpqi driver, but probably aren't. The first one was "md_raid: mdX_raid6 looping after sync_action "check" to "idle" transition" ( https://lkml.org/lkml/2020/11/28/165 ). When I tried to isolate that problem, the xfs problem "v5.10.1 xfs deadlock" ( https://lkml.org/lkml/2020/12/17/608 ) brought itself into the foreground and needed to be resolved first. My original goal of testing the smartpqi 2.1.6-005 driver and trying to reproduce the problem, we've seen on the production system, didn't make progress because of that.

On the other hand, all this time smartpqi 2.1.6-005 was used on the test system with high simulated load and didn't fail on me. So I kind of tested it without bad results. I'd appreciate, if it would go into the next Linux release, anyway.

Best
   Donald

> 
> Thanks,
> Don
> 
> -----Original Message-----
> From: Don.Brace@microchip.com [mailto:Don.Brace@microchip.com]
> Sent: Monday, December 28, 2020 9:58 AM
> To: buczek@molgen.mpg.de; Kevin Barnett - C33748 <Kevin.Barnett@microchip.com>; Scott Teel - C33730 <Scott.Teel@microchip.com>; Justin Lindley - C33718 <Justin.Lindley@microchip.com>; Scott Benesh - C33703 <Scott.Benesh@microchip.com>; Gerry Morong - C33720 <Gerry.Morong@microchip.com>; Mahesh Rajashekhara - I30583 <Mahesh.Rajashekhara@microchip.com>; hch@infradead.org; jejb@linux.vnet.ibm.com; joseph.szczypek@hpe.com; POSWALD@suse.com
> Cc: linux-scsi@vger.kernel.org; it+linux@molgen.mpg.de
> Subject: RE: [PATCH V3 00/25] smartpqi updates
> 
> 
> Subject: Re: [PATCH V3 00/25] smartpqi updates
> 
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 22.12.20 00:30, Don.Brace@microchip.com wrote:
>> Can you please post your hw configuration and the stress load that you used? Was it fio?
> 
> Testsystem is a Dell PowerEdge R730. with two 10 core Intel® Xeon® Processor E5-2687W v3  and 200 GB memory.
> Adapter is Adaptec HBA 1100-8e, Firmware 3.21 On it two AIC J3016-01 Enclosures with 16 8TB disks each The disks of each jbod are a combined into a raid6 software raid with xfs on it.
> So I have two filesystems with ~100 TB ( 14 * 7.3 TB)
> 
> Unfortunately, for the time being, I was only able to reproduce this with a very complex load setup with both, file system activity (two parallel `cp -a` of big directory trees on each filesystem) and switching on and of raid scrubbing at the same time. I'm currently trigger the issue with less complex setups.
> 
> I'm not sure at all, whether this is really a problem of the smartpqi driver. Its just the frozen inflight counter seem to hint in the direction of the block layer.
> 
> Donald
> 
>>> Thanks for sharing your HW setup.
>>> I will also setup a similar system. I have two scripts that I run against the driver before I feel satisfied that it will hold up against extreme conditions. One script performs a list of I/O stress tests (to all presented disks (LVs and HBAs): 1) mkfs {xfs, ext4}, 2) mount, 3) test using rsync, 4) fio using file system, 5) umount, 6) fsck, 7) fio to raw disk.
> 
>>> The other script continuously issues resets to all of the disks in parallel. Normally any issues will show up within 20 iterations of my scripts. I wait for 50K before I'm happy.
> 
>>> I have not tried layering in the dm driver, but that will be added to my tests. There have been a few patches added to both the block layer and dm driver recently.
> 
>>> Thanks again,
>>> Don.
> 
> 
> 
>>
>> Dear Don,
>>
>> just wanted to let you know that I've tested this series (plus the three Depends-on patches you mentioned) on top of Linux v5.10.1 with an Adaptec 1100-8e with fw 3.21.
>>
>> After three hours of heavy operation (including raid scrubbing!) the
>> driver seems to have lost some requests for the md0 member disks
>>
>> This is the static picture after all activity has ceased:
>>
>>        root:deadbird:/scratch/local/# for f in /sys/devices/virtual/block/md?/md/rd*/block/inflight;do echo $f: $(cat $f);done
>>        /sys/devices/virtual/block/md0/md/rd0/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd1/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd10/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd11/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd12/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd13/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd14/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd15/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd2/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd3/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd4/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd5/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd6/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd7/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd8/block/inflight: 1 0
>>        /sys/devices/virtual/block/md0/md/rd9/block/inflight: 1 0
>>        /sys/devices/virtual/block/md1/md/rd0/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd1/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd10/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd11/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd12/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd13/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd14/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd15/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd2/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd3/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd4/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd5/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd6/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd7/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd8/block/inflight: 0 0
>>        /sys/devices/virtual/block/md1/md/rd9/block/inflight: 0 0
>>
>> Best
>>      Donald
>>
>> On 10.12.20 21:34, Don Brace wrote:
>>> These patches are based on Martin Peterson's 5.11/scsi-queue tree
>>>
>>> Note that these patches depend on the following three patches applied
>>> to Martin Peterson's tree:
>>>     https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>>>      5.11/scsi-queue
>>> Depends-on: 5443bdc4cc77 scsi: smartpqi: Update version to 1.2.16-012
>>> Depends-on: 408bdd7e5845 scsi: smartpqi: Correct pqi_sas_smp_handler
>>> busy condition
>>> Depends-on: 1bdf6e934387 scsi: smartpqi: Correct driver removal with
>>> HBA disks
>>>
>>> This set of changes consist of:
>>>      * Add support for newer controller hardware.
>>>        * Refactor AIO and s/g processing code. (No functional changes)
>>>        * Add write support for RAID 5/6/1 Raid bypass path (or accelerated I/O path).
>>>        * Add check for sequential streaming.
>>>        * Add in new PCI-IDs.
>>>      * Format changes to re-align with our in-house driver. (No
>>> functional changes.)
>>>      * Correct some issues relating to suspend/hibernation/OFA/shutdown.
>>>        * Block I/O requests during these conditions.
>>>      * Add in qdepth limit check to limit outstanding commands.
>>>        to the max values supported by the controller.
>>>      * Correct some minor issues found during regression testing.
>>>      * Update the driver version.
>>>
>>> Changes since V1:
>>>      * Re-added 32bit calculations to correct i386 compile issues
>>>        to patch smartpqi-refactor-aio-submission-code
>>>        Reported-by: kernel test robot <lkp@intel.com>
>>>       
>>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/VM
>>> BBGGGE5446SVEOQBRCKBTRRWTSH4AB/
>>>
>>> Changes since V2:
>>>      * Added 32bit division to correct i386 compile issues
>>>        to patch smartpqi-add-support-for-raid5-and-raid6-writes
>>>        Reported-by: kernel test robot <lkp@intel.com>
>>>       
>>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/ZC
>>> XJJDGPPTTXLZCSCGWEY6VXPRB3IFOQ/
>>>
>>> ---
>>>
>>> Don Brace (7):
>>>          smartpqi: refactor aio submission code
>>>          smartpqi: refactor build sg list code
>>>          smartpqi: add support for raid5 and raid6 writes
>>>          smartpqi: add support for raid1 writes
>>>          smartpqi: add stream detection
>>>          smartpqi: add host level stream detection enable
>>>          smartpqi: update version to 2.1.6-005
>>>
>>> Kevin Barnett (14):
>>>          smartpqi: add support for product id
>>>          smartpqi: add support for BMIC sense feature cmd and feature
>>> bits
>>>          smartpqi: update AIO Sub Page 0x02 support
>>>          smartpqi: add support for long firmware version
>>>          smartpqi: align code with oob driver
>>>          smartpqi: enable support for NVMe encryption
>>>          smartpqi: disable write_same for nvme hba disks
>>>          smartpqi: fix driver synchronization issues
>>>          smartpqi: convert snprintf to scnprintf
>>>          smartpqi: change timing of release of QRM memory during OFA
>>>          smartpqi: return busy indication for IOCTLs when ofa is active
>>>          smartpqi: add additional logging for LUN resets
>>>          smartpqi: correct system hangs when resuming from hibernation
>>>          smartpqi: add new pci ids
>>>
>>> Mahesh Rajashekhara (1):
>>>          smartpqi: fix host qdepth limit
>>>
>>> Murthy Bhat (3):
>>>          smartpqi: add phy id support for the physical drives
>>>          smartpqi: update sas initiator_port_protocols and
>>> target_port_protocols
>>>          smartpqi: update enclosure identifier in sysf
>>>
>>>
>>>     drivers/scsi/smartpqi/smartpqi.h              |  301 +-
>>>     drivers/scsi/smartpqi/smartpqi_init.c         | 3123 ++++++++++-------
>>>     .../scsi/smartpqi/smartpqi_sas_transport.c    |   39 +-
>>>     drivers/scsi/smartpqi/smartpqi_sis.c          |    4 +-
>>>     4 files changed, 2189 insertions(+), 1278 deletions(-)
>>>
>>
>> --
>> Donald Buczek
>> buczek@molgen.mpg.de
>> Tel: +49 30 8413 1433
> 
> --
> Donald Buczek
> buczek@molgen.mpg.de
> Tel: +49 30 8413 1433
> 

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
