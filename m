Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12142C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2155D22C9F
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgHDJ3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 05:29:53 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2564 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725832AbgHDJ3w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Aug 2020 05:29:52 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 1112C3719F5ED8C1DEA8;
        Tue,  4 Aug 2020 10:29:51 +0100 (IST)
Received: from [127.0.0.1] (10.47.11.189) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 4 Aug 2020
 10:29:49 +0100
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
From:   John Garry <john.garry@huawei.com>
Message-ID: <ccc119c8-4774-2603-fb79-e8c31a1476c6@huawei.com>
Date:   Tue, 4 Aug 2020 10:27:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB28489516D2F4E7631A921BD9E14D0@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.11.189]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/08/2020 21:39, Don.Brace@microchip.com wrote:

Hi Don,

>>> at should be good to test with for now.
> clonedhttps://github.com/hisilicon/kernel-dev
> 	branch origin/private-topic-blk-mq-shared-tags-rfc-v7
> 
> The driver did not load, so I cherry-picked from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
> 	branch origin/reserved-tags.v6
> 
> the following patches:
> 6a9d1a96ea41 hpsa: move hpsa_hba_inquiry after scsi_add_host()
> eeb5cd1fca58 hpsa: use reserved commands
> 7df7d8382902 hpsa: use scsi_host_busy_iter() to traverse outstanding commands
> 485881d6d8dc hpsa: drop refcount field from CommandList
> c4980ad5e5cb scsi: implement reserved command handling
> 34d03fa945c0 scsi: add scsi_{get,put}_internal_cmd() helper
> 4556e50450c8 block: add flag for internal commands
> 138125f74b25 scsi: hpsa: Lift {BIG_,}IOCTL_Command_struct copy{in,out} into hpsa_ioctl()
> cb17c1b69b17 scsi: hpsa: Don't bother with vmalloc for BIG_IOCTL_Command_struct
> 10100ffd5f65 scsi: hpsa: Get rid of compat_alloc_user_space()
> 06b43f968db5 scsi: hpsa: hpsa_ioctl(): Tidy up a bit
> 
> The driver loads and I ran some mke2fs, mount/umount tests,

ok, great

> but I am getting an extra devices in the list which does not
> seem to be coming from hpsa driver.
> 
> I have not yet had time to diagnose this issue.
> 
> lsscsi
> [1:0:0:0]    disk    ASMT     2105             0     /dev/sdi
> [14:0:-1:0]  type??? nullnull nullnullnullnull null  -
> [14:0:0:0]   storage HP       H240             7.19  -
> [14:0:1:0]   disk    ATA      MB002000GWFGH    HPG0  /dev/sda
> [14:0:2:0]   disk    ATA      MB002000GWFGH    HPG0  /dev/sdb
> [14:0:3:0]   disk    HP       EF0450FARMV      HPD5  /dev/sdc
> [14:0:4:0]   disk    ATA      MB002000GWFGH    HPG0  /dev/sdd
> [14:0:5:0]   disk    ATA      MB002000GWFGH    HPG0  /dev/sde
> [14:0:6:0]   disk    HP       EF0450FARMV      HPD5  /dev/sdf
> [14:0:7:0]   disk    ATA      VB0250EAVER      HPG7  /dev/sdg
> [14:0:8:0]   disk    ATA      MB0500GCEHF      HPGC  /dev/sdh
> [14:0:9:0]   enclosu HP       H240             7.19  -
> [15:0:-1:0]  type??? nullnull nullnullnullnull null  -
> [15:0:0:0]   storage HP       P440             7.19  -
> [15:1:0:0]   disk    HP       LOGICAL VOLUME   7.19  /dev/sdj
> [15:1:0:1]   disk    HP       LOGICAL VOLUME   7.19  /dev/sdk
> [15:1:0:2]   disk    HP       LOGICAL VOLUME   7.19  /dev/sdl
> [15:1:0:3]   disk    HP       LOGICAL VOLUME   7.19  /dev/sdm
> [16:0:-1:0]  type??? nullnull nullnullnullnull null  -
> [16:0:0:0]   storage HP       P441             7.19  -
> 
> 

I assume that you are missing some other patches from that branch, like 
these:

77dcb92c31ae scsi: revamp host device handling
6e9884aefe66 scsi: Use dummy inquiry data for the host device
a381637f8a6e scsi: use real inquiry data when initialising devices

@Hannes, Any plans to get this series going again?

Thanks,
John
