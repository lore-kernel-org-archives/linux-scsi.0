Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 606F6C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 12:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EFED239EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 12:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbhAUMht (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 07:37:49 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2389 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731242AbhAUMhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2021 07:37:22 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DM1xL2b7Fz67bhf;
        Thu, 21 Jan 2021 20:32:22 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 21 Jan 2021 13:36:33 +0100
Received: from [10.210.167.120] (10.210.167.120) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Thu, 21 Jan 2021 12:36:32 +0000
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     Donald Buczek <buczek@molgen.mpg.de>,
        "mwilck@suse.com" <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>
CC:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Don Brace <Don.Brace@microchip.com>,
        Kevin Barnett <Kevin.Barnett@microchip.com>,
        "Paul Menzel" <pmenzel@molgen.mpg.de>,
        Hannes Reinecke <hare@suse.com>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
Date:   Thu, 21 Jan 2021 12:35:16 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.167.120]
X-ClientProxiedBy: lhreml704-chm.china.huawei.com (10.201.108.53) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/01/2021 12:01, Donald Buczek wrote:
>>> pts to fix it by moving setting the SCMD_STATE_INFLIGHT before
>>> the host_blocked test again. It also inserts barriers to make sure
>>> scsi_host_busy() on once CPU will notice the increase of the count from another.
>>>
>>> [1]:https://marc.info/?l=linux-scsi&m=160271263114829&w=2
>>> [2]:https://marc.info/?l=linux-scsi&m=161116163722099&w=2
>>>
>>> Fixes: 6eb045e092ef ("scsi: core: avoid host-wide host_busy counter for scsi_mq")
>> For failing test, it would be good to know:
>> - host .can_queue
>> - host .nr_hw_queues
>> - number of LUNs in test and their queue dept>> All can be got from lsscsi, apart from nr_hw_queues, which can be got from scsi_host sysfs for kernel >= 5.10
> The last test was on 6eb045e092ef + Martins experimental patch, which technically is 5.4.0-rc1
> 
> I'm not 100% sure about which data you need and where to find  nr_hw_queues exposed. 

nr_hw_queues is not available on 5.4 kernel via sysfs

it's prob same as count of CPUs in the system

or you can check number of hctxX folders in /sys/kernel/debug/block/sdX 
(need to be root, and debugfs enabled)

Please ask, if you need more data.
> 
> + lsscsi
> [0:0:0:0]    disk    ATA      ST500NM0011      PA09  /dev/sda
> [0:0:32:0]   enclosu DP       BP13G+           2.23  -
> [12:0:0:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdb
> [12:0:1:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdc
> [12:0:2:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdd
> [12:0:3:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sde
> [12:0:4:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdf
> [12:0:5:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdg
> [12:0:6:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdh
> [12:0:7:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdi
> [12:0:8:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdj
> [12:0:9:0]   disk    SEAGATE  ST8000NM001A     E002  /dev/sdk
> [12:0:10:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdl
> [12:0:11:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdm
> [12:0:12:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdn
> [12:0:13:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdo
> [12:0:14:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdp
> [12:0:15:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdq
> [12:0:16:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdr
> [12:0:17:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sds
> [12:0:18:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdt
> [12:0:19:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdu
> [12:0:20:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdv
> [12:0:21:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdw
> [12:0:22:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdx
> [12:0:23:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdy
> [12:0:24:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdz
> [12:0:25:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdaa
> [12:0:26:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdab
> [12:0:27:0]  disk    SEAGATE  ST8000NM001A     E002  /dev/sdac
> [12:0:28:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdad
> [12:0:29:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdae
> [12:0:30:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdaf
> [12:0:31:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdag
> [12:0:32:0]  enclosu AIC 12G  3U16SAS3swap     0c01  -
> [12:0:33:0]  enclosu AIC 12G  3U16SAS3swap     0c01  -
> [12:0:34:0]  enclosu Adaptec  Smart Adapter    3.21  -
> [12:2:0:0]   storage Adaptec  1100-8e          3.21  -
> + for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0

I figure sdev queue depth is 64 for all disks, like /dev/sdag, below.

lsscsi -l would give that

But, as said here:
https://lore.kernel.org/linux-scsi/20200714104437.GB602708@T590/

Looks like block layer can send too many commands to SCSI host if trying 
to achieve highest datarates with all those 32x disks. Before 
6eb045e092ef, that would be avoided. That's how I see it.

> + lsscsi -L 12:2:0:0
> [12:2:0:0]   storage Adaptec  1100-8e          3.21  -
>     device_blocked=0
>     iocounterbits=32
>     iodone_cnt=0x1e
>     ioerr_cnt=0x0
>     iorequest_cnt=0x1e
>     queue_depth=1013
>     queue_type=simple
>     scsi_level=6
>     state=running
>     timeout=30
>     type=12
> + for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0
> + lsscsi -L 12:0:34:0
> [12:0:34:0]  enclosu Adaptec  Smart Adapter    3.21  -
>     device_blocked=0
>     iocounterbits=32
>     iodone_cnt=0x12
>     ioerr_cnt=0x0
>     iorequest_cnt=0x12
>     queue_depth=1
>     queue_type=none
>     scsi_level=6
>     state=running
>     timeout=30
>     type=13
> + for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0
> + lsscsi -L 12:0:33:0
> [12:0:33:0]  enclosu AIC 12G  3U16SAS3swap     0c01  -
>     device_blocked=0
>     iocounterbits=32
>     iodone_cnt=0x12
>     ioerr_cnt=0x0
>     iorequest_cnt=0x12
>     queue_depth=1
>     queue_type=simple
>     scsi_level=6
>     state=running
>     timeout=30
>     type=13
> + for i in 12:2:0:0 12:0:34:0 12:0:33:0 12:0:31:0
> + lsscsi -L 12:0:31:0
> [12:0:31:0]  disk    SEAGATE  ST8000NM001A     E001  /dev/sdag
>     device_blocked=0
>     iocounterbits=32
>     iodone_cnt=0x19b94
>     ioerr_cnt=0x0
>     iorequest_cnt=0x19bba
>     queue_depth=64
>     queue_type=simple
>     scsi_level=8
>     state=running
>     timeout=30
>     type=0
> + cat /sys/bus/scsi/devices/host12/scsi_host/host12/can_queue
> 1013
> 

Thanks,
John

