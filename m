Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D54C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 18:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 958EB64DE1
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 18:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhBCS2G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 13:28:06 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2493 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhBCS2E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 13:28:04 -0500
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DW96t6ZJHz67kg4;
        Thu,  4 Feb 2021 02:23:50 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 19:27:21 +0100
Received: from [10.210.171.46] (10.210.171.46) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 18:27:20 +0000
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     <Don.Brace@microchip.com>, <mwilck@suse.com>,
        <buczek@molgen.mpg.de>, <martin.petersen@oracle.com>,
        <ming.lei@redhat.com>
CC:     <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>,
        <hare@suse.de>, <Kevin.Barnett@microchip.com>,
        <pmenzel@molgen.mpg.de>, <hare@suse.com>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
 <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
 <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
 <SN6PR11MB28482D89B75197B742459063E1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <73a25a53-db3d-c59e-b247-6533664673a4@huawei.com>
Date:   Wed, 3 Feb 2021 18:25:50 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB28482D89B75197B742459063E1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.46]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/02/2021 15:56, Don.Brace@microchip.com wrote:
> True. However this is 5.12 material, so we shouldn't be bothered by that here. For 5.5 up to 5.9, you need a workaround. But I'm unsure whether smartpqi_fix_host_qdepth_limit would be the solution.
> You could simply divide can_queue by nr_hw_queues, as suggested before, or even simpler, set nr_hw_queues = 1.
> 
> How much performance would that cost you?
> 
> Don: For my HBA disk tests...
> 
> Dividing can_queue / nr_hw_queues is about a 40% drop.
> ~380K - 400K IOPS
> Setting nr_hw_queues = 1 results in a 1.5 X gain in performance.
> ~980K IOPS

So do you just set shost.nr_hw_queues = 1, yet leave the rest of the 
driver as is?

Please note that when changing from nr_hw_queues many -> 1, then the 
default IO scheduler changes from none -> mq-deadline, but I would hope 
that would not make such a big difference.

> Setting host_tagset = 1

For this, v5.11-rc6 has a fix which may affect you (2569063c7140), so 
please include it

> ~640K IOPS
> 
> So, it seem that setting nr_hw_queues = 1 results in the best performance.
> 
> Is this expected? Would this also be true for the future?

Not expected by me

> 
> Thanks,
> Don Brace
> 
> Below is my setup.
> ---
> [3:0:0:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdd
> [3:0:1:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sde
> [3:0:2:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdf
> [3:0:3:0]    disk    HP       EH0300FBQDD      HPD5  /dev/sdg
> [3:0:4:0]    disk    HP       EG0900FDJYR      HPD4  /dev/sdh
> [3:0:5:0]    disk    HP       EG0300FCVBF      HPD9  /dev/sdi
> [3:0:6:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdj
> [3:0:7:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdk
> [3:0:8:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdl
> [3:0:9:0]    disk    HP       MO0200FBRWB      HPD9  /dev/sdm
> [3:0:10:0]   disk    HP       MM0500FBFVQ      HPD8  /dev/sdn
> [3:0:11:0]   disk    ATA      MM0500GBKAK      HPGC  /dev/sdo
> [3:0:12:0]   disk    HP       EG0900FBVFQ      HPDC  /dev/sdp
> [3:0:13:0]   disk    HP       VO006400JWZJT    HP00  /dev/sdq
> [3:0:14:0]   disk    HP       VO015360JWZJN    HP00  /dev/sdr
> [3:0:15:0]   enclosu HP       D3700            5.04  -
> [3:0:16:0]   enclosu HP       D3700            5.04  -
> [3:0:17:0]   enclosu HPE      Smart Adapter    3.00  -
> [3:1:0:0]    disk    HPE      LOGICAL VOLUME   3.00  /dev/sds
> [3:2:0:0]    storage HPE      P408e-p SR Gen10 3.00  -
> -----
> [global]
> ioengine=libaio
> ; rw=randwrite
> ; percentage_random=40
> rw=write
> size=100g
> bs=4k
> direct=1
> ramp_time=15
> ; filename=/mnt/fio_test
> ; cpus_allowed=0-27
> iodepth=4096

I normally use iodepth circa 40 to 128, but then I normally just do 
rw=read for performance testing

> 
> [/dev/sdd]
> [/dev/sde]
> [/dev/sdf]
> [/dev/sdg]
> [/dev/sdh]
> [/dev/sdi]
> [/dev/sdj]
> [/dev/sdk]
> [/dev/sdl]
> [/dev/sdm]
> [/dev/sdn]
> [/dev/sdo]
> [/dev/sdp]
> [/dev/sdq]
> [/dev/sdr]

