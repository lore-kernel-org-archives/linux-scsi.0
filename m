Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5F1C433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 14:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1192064DEF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 14:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhCAOwx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 09:52:53 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:33655 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236572AbhCAOw0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 09:52:26 -0500
Received: from [192.168.0.7] (ip5f5aea9e.dynamic.kabel-deutschland.de [95.90.234.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D8D4820647913;
        Mon,  1 Mar 2021 15:51:41 +0100 (CET)
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     Roger Willcocks <roger@filmlight.ltd.uk>, Don.Brace@microchip.com
Cc:     mwilck@suse.com, john.garry@huawei.com, buczek@molgen.mpg.de,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, hare@suse.de,
        Kevin.Barnett@microchip.com, hare@suse.com,
        linux-scsi@vger.kernel.org
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
 <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
 <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
 <SN6PR11MB28482D89B75197B742459063E1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
 <0DB85ADC-B962-4AF9-B106-3F3B412CE4DB@filmlight.ltd.uk>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <19037a33-da34-3a4b-c326-f97a26e251b1@molgen.mpg.de>
Date:   Mon, 1 Mar 2021 15:51:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <0DB85ADC-B962-4AF9-B106-3F3B412CE4DB@filmlight.ltd.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dear Roger,


Am 22.02.21 um 15:23 schrieb Roger Willcocks:
> FYI we have exactly this issue on a machine here running CentOS 8.3
> (kernel 4.18.0-240.1.1) (so presumably this happens in RHEL 8 too.)

What driver version do you use?

> Controller is MSCC / Adaptec 3154-8i16e driving 60 x 12TB HGST drives
> configured as five x twelve-drive raid-6, software striped using md,
> and formatted with xfs.
> 
> Test software writes to the array using multiple threads in
> parallel.
> 
> The smartpqi driver would report controller offline within ten
> minutes or so, with status code 0x6100c
> 
> Changed the driver to set 'nr_hw_queues = 1’ and then tested by
> filling the array with random files (which took a couple of days),
> which completed fine, so it looks like that one-line change fixes
> it.
> 
> Would, of course, be helpful if this was back-ported.
We only noticed the issue starting with Linux 5.5 (commit 6eb045e092ef 
("scsi: core: avoid host-wide host_busy counter for scsi_mq").

So I am curious how this problem can be in CentOS 8.3 (Linux kernel 4.18.x).

> —
> Roger

Apple Mail mangled your signature delimiter (-- ).


Kind regards,

Paul
