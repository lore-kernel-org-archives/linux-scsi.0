Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039EDC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 16:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A82E464FA7
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 16:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhCKQhC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 11:37:02 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:48909 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229530AbhCKQgq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 11:36:46 -0500
Received: from [192.168.0.5] (ip5f5aea7c.dynamic.kabel-deutschland.de [95.90.234.124])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 8A91920647933;
        Thu, 11 Mar 2021 17:36:38 +0100 (CET)
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
To:     Martin Wilck <mwilck@suse.com>, John Garry <john.garry@huawei.com>,
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
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
 <5724da4acbad312e8824ee097ca4d8eb831360e5.camel@suse.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <fe54200d-e3dc-1ab3-da38-55145e0e76c2@molgen.mpg.de>
Date:   Thu, 11 Mar 2021 17:36:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5724da4acbad312e8824ee097ca4d8eb831360e5.camel@suse.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22.01.21 00:32, Martin Wilck wrote:
> On Thu, 2021-01-21 at 13:05 +0000, John Garry wrote:
>>>>
>>
>> Confirmed my suspicions - it looks like the host is sent more
>> commands
>> than it can handle. We would need many disks to see this issue
>> though,
>> which you have.
>>
>> So for stable kernels, 6eb045e092ef is not in 5.4 . Next is 5.10, and
>> I
>> suppose it could be simply fixed by setting .host_tagset in scsi host
>> template there.
> 
> If it's really just that, it should be easy enough to verify.
> 
> @Donald, you'd need to test with a 5.10 kernel, and after reproducing
> the issue, add
> 
>          .host_tagset            = 1,
> 
> to the definition of pqi_driver_template in
> drivers/scsi/smartpqi/smartpqi_init.c.
> 
> You don't need a patch to test that, I believe. Would you able to do
> this test?

Sorry, I had overlooked this request. I reviewed this thread now, because I want to switch our production systems to 5.10 LTS.

I could reproduce the problem with Linux 5.10.22. When setting `host_tagset = 1`, the problem disappeared. Additionally, we have 5.10.22 with the patch running on two previously affected production systems for over 24 hours now. Statistics suggest, that these systems were very likely to trigger the problem in that time frame if the patch didn't work.
    
So I think this is a working fix which should go to 5.10 stable.

Best
   Donald


diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 9d0229656681f..be429a7cb1512 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6571,6 +6571,7 @@ static struct scsi_host_template pqi_driver_template = {
         .map_queues = pqi_map_queues,
         .sdev_attrs = pqi_sdev_attrs,
         .shost_attrs = pqi_shost_attrs,
+       .host_tagset = 1,
  };
  
  static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
