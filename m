Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EAFC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 12:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE1B7239FD
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 12:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbhAUMrP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 07:47:15 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:34961 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731322AbhAUMpg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 07:45:36 -0500
Received: from [192.168.0.5] (ip5f5aed2c.dynamic.kabel-deutschland.de [95.90.237.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7545A20645D5D;
        Thu, 21 Jan 2021 13:44:52 +0100 (CET)
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     John Garry <john.garry@huawei.com>,
        "mwilck@suse.com" <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Don Brace <Don.Brace@microchip.com>,
        Kevin Barnett <Kevin.Barnett@microchip.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Hannes Reinecke <hare@suse.com>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
Date:   Thu, 21 Jan 2021 13:44:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21.01.21 13:35, John Garry wrote:
> On 21/01/2021 12:01, Donald Buczek wrote:
>>>> pts to fix it by moving setting the SCMD_STATE_INFLIGHT before
>>>> the host_blocked test again. It also inserts barriers to make sure
>>>> scsi_host_busy() on once CPU will notice the increase of the count from another.
>>>>
>>>> [1]:https://marc.info/?l=linux-scsi&m=160271263114829&w=2
>>>> [2]:https://marc.info/?l=linux-scsi&m=161116163722099&w=2
>>>>
>>>> Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
>>> For failing test, it would be good to know:
>>> - host .can_queue
>>> - host .nr_hw_queues
>>> - number of LUNs in test and their queue dept>> All can be got from lsscsi, apart from nr_hw_queues, which can be got from scsi_host sysfs for kernel >= 5.10
>> The last test was on 6eb045e092ef + Martins experimental patch, which technically is 5.4.0-rc1
>>
>> I'm not 100% sure about which data you need and where to find  nr_hw_queues exposed. 
> 
> nr_hw_queues is not available on 5.4 kernel via sysfs
> 
> it's prob same as count of CPUs in the system
> 
> or you can check number of hctxX folders in /sys/kernel/debug/block/sdX (need to be root, and debugfs enabled)

root@deadbird:~# ls -d /sys/kernel/debug/block/sdz/hc*
/sys/kernel/debug/block/sdz/hctx0   /sys/kernel/debug/block/sdz/hctx16	/sys/kernel/debug/block/sdz/hctx23  /sys/kernel/debug/block/sdz/hctx30	/sys/kernel/debug/block/sdz/hctx38
/sys/kernel/debug/block/sdz/hctx1   /sys/kernel/debug/block/sdz/hctx17	/sys/kernel/debug/block/sdz/hctx24  /sys/kernel/debug/block/sdz/hctx31	/sys/kernel/debug/block/sdz/hctx39
/sys/kernel/debug/block/sdz/hctx10  /sys/kernel/debug/block/sdz/hctx18	/sys/kernel/debug/block/sdz/hctx25  /sys/kernel/debug/block/sdz/hctx32	/sys/kernel/debug/block/sdz/hctx4
/sys/kernel/debug/block/sdz/hctx11  /sys/kernel/debug/block/sdz/hctx19	/sys/kernel/debug/block/sdz/hctx26  /sys/kernel/debug/block/sdz/hctx33	/sys/kernel/debug/block/sdz/hctx5
/sys/kernel/debug/block/sdz/hctx12  /sys/kernel/debug/block/sdz/hctx2	/sys/kernel/debug/block/sdz/hctx27  /sys/kernel/debug/block/sdz/hctx34	/sys/kernel/debug/block/sdz/hctx6
/sys/kernel/debug/block/sdz/hctx13  /sys/kernel/debug/block/sdz/hctx20	/sys/kernel/debug/block/sdz/hctx28  /sys/kernel/debug/block/sdz/hctx35	/sys/kernel/debug/block/sdz/hctx7
/sys/kernel/debug/block/sdz/hctx14  /sys/kernel/debug/block/sdz/hctx21	/sys/kernel/debug/block/sdz/hctx29  /sys/kernel/debug/block/sdz/hctx36	/sys/kernel/debug/block/sdz/hctx8
/sys/kernel/debug/block/sdz/hctx15  /sys/kernel/debug/block/sdz/hctx22	/sys/kernel/debug/block/sdz/hctx3   /sys/kernel/debug/block/sdz/hctx37	/sys/kernel/debug/block/sdz/hctx9
root@deadbird:~# ls -d /sys/kernel/debug/block/sdz/hc*|wc
      40      40    1390
root@deadbird:~# nproc
40


> Please ask, if you need more data.
>>
>> + lsscsi
>> [0:0:0:0]    disk    ATA      ST500NM0011      PA09  /dev/sda
>> [0:0:32:0]   enclosu DP       BP13G+           2.23  -
>> [12:0:0:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdb
>> [12:0:1:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdc
>> [12:0:2:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdd
>> [12:0:3:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sde
>> [12:0:4:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdf
>> [12:0:5:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdg
>> [12:0:6:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdh
>> [12:0:7:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdi
>> [12:0:8:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdj
>> [12:0:9:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdk
>> [12:0:10:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdl
>> [12:0:11:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdm
>> [12:0:12:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdn
>> [12:0:13:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdo
>> [12:0:14:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdp
>> [12:0:15:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdq
>> [12:0:16:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdr
>> [12:0:17:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sds
>> [12:0:18:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdt
>> [12:0:19:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdu
>> [12:0:20:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdv
>> [12:0:21:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdw
>> [12:0:22:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdx
>> [12:0:23:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdy
>> [12:0:24:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdz
>> [12:0:25:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdaa
>> [12:0:26:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdab
>> [12:0:27:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdac
>> [12:0:28:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdad
>> [12:0:29:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdae
>> [12:0:30:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdaf
>> [12:0:31:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdag
>> [12:0:32:0]  enclosu AIC 12G  3U16SAS3swap     0c01  -
>> [12:0:33:0]  enclosu AIC 12G  3U16SAS3swap     0c01  -
>> [12:0:34:0]  enclosu Adaptec  Smart Adapter    3.21  -
>> [12:2:0:0]   storage Adaptec  1100-8e          3.21  -
>> + for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0
> 
> I figure sdev queue depth is 64 for all disks, like /dev/sdag, below.

Yes, I send an example (one of two enclosures, 1 of 32 disks) but verified, that they are the same.

Best
   Donald

> 
> lsscsi -l would give that
> 
> But, as said here:
> https://lore.kernel.org/linux-scsi/20200714104437.GB602708@T590/
> 
> Looks like block layer can send too many commands to SCSI host if trying to achieve highest datarates with all those 32x disks. Before 6eb045e092ef, that would be avoided. That's how I see it.
> 
>> + lsscsi -L 12:2:0:0
>> [12:2:0:0]   storage Adaptec  1100-8e          3.21  -
>>     device_blocked=0
>>     iocounterbits=32
>>     iodone_cnt=0x1e
>>     ioerr_cnt=0x0
>>     iorequest_cnt=0x1e
>>     queue_depth=1013
>>     queue_type=simple
>>     scsi_level=6
>>     state=running
>>     timeout=30
>>     type=12
>> + for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0
>> + lsscsi -L 12:0:34:0
>> [12:0:34:0]  enclosu Adaptec  Smart Adapter    3.21  -
>>     device_blocked=0
>>     iocounterbits=32
>>     iodone_cnt=0x12
>>     ioerr_cnt=0x0
>>     iorequest_cnt=0x12
>>     queue_depth=1
>>     queue_type=none
>>     scsi_level=6
>>     state=running
>>     timeout=30
>>     type=13
>> + for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0
>> + lsscsi -L 12:0:33:0
>> [12:0:33:0]  enclosu AIC 12G  3U16SAS3swap     0c01  -
>>     device_blocked=0
>>     iocounterbits=32
>>     iodone_cnt=0x12
>>     ioerr_cnt=0x0
>>     iorequest_cnt=0x12
>>     queue_depth=1
>>     queue_type=simple
>>     scsi_level=6
>>     state=running
>>     timeout=30
>>     type=13
>> + for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0
>> + lsscsi -L 12:0:31:0
>> [12:0:31:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdag
>>     device_blocked=0
>>     iocounterbits=32
>>     iodone_cnt=0x19b94
>>     ioerr_cnt=0x0
>>     iorequest_cnt=0x19bba
>>     queue_depth=64
>>     queue_type=simple
>>     scsi_level=8
>>     state=running
>>     timeout=30
>>     type=0
>> + cat /sys/bus/scsi/devices/host12/scsi_host/host12/can_queue
>> 1013
>>
> 
> Thanks,
> John
> 
