Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30566C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2D6F21D81
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405550AbhALQCv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 11:02:51 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2320 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405500AbhALQCu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 11:02:50 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DFZvg048rz67Z23;
        Tue, 12 Jan 2021 23:57:03 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 17:02:08 +0100
Received: from [10.210.171.61] (10.210.171.61) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 16:02:05 +0000
Subject: Re: [PATCH v2 00/19] scsi: libsas: Remove in_interrupt() check
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <8683f401-29b6-4067-af51-7b518ad3a10f@huawei.com> <X/2h0yNqtmgoLIb+@lx-t490>
From:   John Garry <john.garry@huawei.com>
Message-ID: <e9bc0c89-a4d6-1e5b-793d-3c246882210e@huawei.com>
Date:   Tue, 12 Jan 2021 16:00:57 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <X/2h0yNqtmgoLIb+@lx-t490>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.61]
X-ClientProxiedBy: lhreml744-chm.china.huawei.com (10.201.108.194) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- intel-linux-scu@intel.com

On 12/01/2021 13:19, Ahmed S. Darwish wrote:
> On Tue, Jan 12, 2021 at 11:53:50AM +0000, John Garry wrote:
>> On 12/01/2021 11:06, Ahmed S. Darwish wrote:
>>> Hi,
>>>
>>> Changelog v2
>>> ------------
> ...
>>
>> I'll give this a spin today and help review also then.
>>

I boot-tested on my machines which have hisi_sas v2 and v3 hw, and it's 
ok. I will ask some guys to test a bit more.

And generally the changes look ok. But I just have a slight concern that 
we don't pass the gfp_flags all the way from the origin caller.

So we have some really long callchains, for example:

host.c: sci_controller_error_handler(): atomic, irq handler     (*)
OR host.c: sci_controller_completion_handler(), atomic, tasklet (*)
   -> sci_controller_process_completions()
     -> sci_controller_unsolicited_frame()
       -> phy.c: sci_phy_frame_handler()
         -> sci_change_state(SCI_PHY_SUB_AWAIT_SAS_POWER)
           -> sci_phy_starting_await_sas_power_substate_enter()
             -> host.c: sci_controller_power_control_queue_insert()
               -> phy.c: sci_phy_consume_power_handler()
                 -> sci_change_state(SCI_PHY_SUB_FINAL)
         -> sci_change_state(SCI_PHY_SUB_FINAL)
     -> sci_controller_event_completion()
       -> phy.c: sci_phy_event_handler()
         -> sci_phy_start_sata_link_training()
           -> sci_change_state(SCI_PHY_SUB_AWAIT_SATA_POWER)
             -> sci_phy_starting_await_sata_power_substate_enter
               -> host.c: sci_controller_power_control_queue_insert()
                 -> phy.c: sci_phy_consume_power_handler()
                   -> sci_change_state(SCI_PHY_SUB_FINAL)

So if someone rearranges the code later, adds new callchains, etc., it 
could be missed that the context may have changed than what we assume at 
the bottom. But then passing the flags everywhere is cumbersome, and all 
the libsas users see little or no significant changes anyway, apart from 
a couple.

Thanks,
John

