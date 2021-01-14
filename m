Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689EDC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 09:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19307239EB
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 09:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbhANJx2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 04:53:28 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2342 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbhANJx2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 04:53:28 -0500
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DGffy30TCz67ZsW;
        Thu, 14 Jan 2021 17:49:46 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 14 Jan 2021 10:52:46 +0100
Received: from [10.210.171.141] (10.210.171.141) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 14 Jan 2021 09:52:45 +0000
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
 <e9bc0c89-a4d6-1e5b-793d-3c246882210e@huawei.com> <X/3dUkPCC1SrLT4m@lx-t490>
From:   John Garry <john.garry@huawei.com>
Message-ID: <20e1034c-98af-a000-65ed-ae5f0e7a758f@huawei.com>
Date:   Thu, 14 Jan 2021 09:51:35 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <X/3dUkPCC1SrLT4m@lx-t490>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.141]
X-ClientProxiedBy: lhreml714-chm.china.huawei.com (10.201.108.65) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/01/2021 17:33, Ahmed S. Darwish wrote:
> On Tue, Jan 12, 2021 at 04:00:57PM +0000, John Garry wrote:
> ...
>> I boot-tested on my machines which have hisi_sas v2 and v3 hw, and it's ok.
>> I will ask some guys to test a bit more.
>>
> Thanks a lot!
> 
>> And generally the changes look ok. But I just have a slight concern that we
>> don't pass the gfp_flags all the way from the origin caller.
>>
>> So we have some really long callchains, for example:
>>
>> host.c: sci_controller_error_handler(): atomic, irq handler     (*)
>> OR host.c: sci_controller_completion_handler(), atomic, tasklet (*)
>>    -> sci_controller_process_completions()
>>      -> sci_controller_unsolicited_frame()
>>        -> phy.c: sci_phy_frame_handler()
>>          -> sci_change_state(SCI_PHY_SUB_AWAIT_SAS_POWER)
>>            -> sci_phy_starting_await_sas_power_substate_enter()
>>              -> host.c: sci_controller_power_control_queue_insert()
>>                -> phy.c: sci_phy_consume_power_handler()
>>                  -> sci_change_state(SCI_PHY_SUB_FINAL)
>>          -> sci_change_state(SCI_PHY_SUB_FINAL)
>>      -> sci_controller_event_completion()
>>        -> phy.c: sci_phy_event_handler()
>>          -> sci_phy_start_sata_link_training()
>>            -> sci_change_state(SCI_PHY_SUB_AWAIT_SATA_POWER)
>>              -> sci_phy_starting_await_sata_power_substate_enter
>>                -> host.c: sci_controller_power_control_queue_insert()
>>                  -> phy.c: sci_phy_consume_power_handler()
>>                    -> sci_change_state(SCI_PHY_SUB_FINAL)
>>
>> So if someone rearranges the code later, adds new callchains, etc., it could
>> be missed that the context may have changed than what we assume at the
>> bottom. But then passing the flags everywhere is cumbersome, and all the
>> libsas users see little or no significant changes anyway, apart from a
>> couple.
>>
> The deep call chains like the one you've quoted are all within the isci
> Intel driver (patches #5 => #7), due to the*massive*  state transitions
> that driver has. But as the commit logs of these three patches show,
> almost all of such transitions happened under atomic context anyway and
> GFP_ATOMIC was thus used.
> 
> The GFP_KERNEL call-chains were all very simple: a workqueue, functions
> already calling msleep() or wait_event_timeout() two or three lines
> nearby, and so on.
> 
> All the other libsas clients (that is, except isci) also had normal call
> chains that were IMHO easy to follow.

To me, the series looks fine. Well, the end result - I didn't go through 
patch by patch. So:

Reviewed-by: John Garry <john.garry@huawei.com>

I'm still hoping some guys are testing a bit for me, but I'll let you 
know if any problem.

As an aside, your analysis showed some quite poor usage of spinlocks in 
some drivers, specifically grabbing a lock and then calling into a depth 
of 3 or 4 functions.

Thanks,
John
