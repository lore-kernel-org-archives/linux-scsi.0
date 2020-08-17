Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A5EC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC6320758
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgHQIDH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:03:07 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2609 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbgHQIC6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Aug 2020 04:02:58 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 69E37DA4AFECB53059E5;
        Mon, 17 Aug 2020 09:02:55 +0100 (IST)
Received: from [127.0.0.1] (10.47.8.102) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 17 Aug
 2020 09:02:53 +0100
Subject: Re: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
To:     <Don.Brace@microchip.com>, <hare@suse.de>,
        <don.brace@microsemi.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <3b3ead84-5d2f-dcf2-33d5-6aa12d5d9f7e@suse.de>
 <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
 <SN6PR11MB28489516D2F4E7631A921BD9E14D0@SN6PR11MB2848.namprd11.prod.outlook.com>
 <ccc119c8-4774-2603-fb79-e8c31a1476c6@huawei.com>
 <SN6PR11MB2848F0DD0CB3357541DBDAA9E14A0@SN6PR11MB2848.namprd11.prod.outlook.com>
 <013d4ba6-9173-e791-8e36-8393bde73588@huawei.com>
 <SN6PR11MB2848E10B3322C7186B82F1BCE1400@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6c5c4da7-9fd3-82b0-681f-c113e7fe85b8@huawei.com>
Date:   Mon, 17 Aug 2020 09:00:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848E10B3322C7186B82F1BCE1400@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.8.102]
X-ClientProxiedBy: lhreml744-chm.china.huawei.com (10.201.108.194) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/08/2020 22:04, Don.Brace@microchip.com wrote:

Hi Don,

> I cloned your branch fromhttps://github.com/hisilicon/kernel-dev
>    and checkout branch: origin/private-topic-blk-mq-shared-tags-rfc-v7
> 
> By themselves, the branch compiled but the driver did not load.
> 
> I cherry-picked the following patches from Hannes:
>    git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
>    branch: reserved-tags.v6
> 
> 6a9d1a96ea41 hpsa: move hpsa_hba_inquiry after scsi_add_host()
> eeb5cd1fca58 hpsa: use reserved commands
> 	confict: removal of function hpsa_get_cmd_index,
>                 non-functional issue.
> 7df7d8382902 hpsa: use scsi_host_busy_iter() to traverse outstanding commands
> 485881d6d8dc hpsa: drop refcount field from CommandList
> c4980ad5e5cb scsi: implement reserved command handling
> 	conflict: drivers/scsi/scsi_lib.c
>                 minor context issue adding comment,
>                 non-functional issue.
> 34d03fa945c0 scsi: add scsi_{get,put}_internal_cmd() helper
> 	conflict: drivers/scsi/scsi_lib.c
>                 minor context issue around scsi_get_internal_cmd
>                 when adding new comment,
>                 non-functional issue
> 4556e50450c8 block: add flag for internal commands
> 138125f74b25 scsi: hpsa: Lift {BIG_,}IOCTL_Command_struct copy{in,out} into hpsa_ioctl()
> cb17c1b69b17 scsi: hpsa: Don't bother with vmalloc for BIG_IOCTL_Command_struct
> 10100ffd5f65 scsi: hpsa: Get rid of compat_alloc_user_space()
> 06b43f968db5 scsi: hpsa: hpsa_ioctl(): Tidy up a bit
> a381637f8a6e scsi: use real inquiry data when initialising devices
> 6e9884aefe66 scsi: Use dummy inquiry data for the host device
> 77dcb92c31ae scsi: revamp host device handling
> 
> After the above patches were applied, the driver loaded and I ran the following tests:
> insmod/rmmod
> reboot
> Ran an I/O stress test consisting of:
> 	6 SATA HBA disks
> 	2 SAS HBA disks
> 	2 RAID 5 volumes using 3 SAS HDDs
> 	2 RAID 5 volumes using 3 SAS SSDs (ioaccel enabled)
> 
> 	1) fio tests to raw disks.
> 	2) mke2fs tests
> 	3) mount
> 	4) fio to file systems
> 	5) umount
> 	6) fsck
> 
> 	And running reset tests in parallel to the above 6 tests using sg_reset
> 
> I ran some performance tests to HBA and LOGICAL VOLUMES and did not find a performance regression.
> 

ok, thanks for this info. I appreciate it.

> We are also reconsidering changing smartpqi over to use host tags but in some preliminary performance tests, I found a performance regression.
> Note: I only used your V7 patches for smartpqi.
>        I have not had time to determine what is causing this, but wanted to make note of this.

Thanks. Please note that we have been looking at many performances 
improvements since v7, and these will be included in v8, so maybe I can 
still include smartpqi in the v8 series and you can retest if you want.

> 
> For hpsa:
> 
> With all of the patches noted above,
> Tested-by: Don Brace<don.brace@microsemi.com>
> 
> For hpsa specific patches:
> Reviewed-by: Don Brace<don.brace@microsemi.com>

Thanks. Please also note that I want to drop the RFC tag for v8 series, 
so I will just have to note that we still depend on Hannes' work for 
hpsa. We could also change the patch, but let's see how we go.

Cheers,
John

