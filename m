Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F804C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 17:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CC81613B2
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 17:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbhDTRM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:12:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:53886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhDTRM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 13:12:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 00A41AE5C;
        Tue, 20 Apr 2021 17:11:54 +0000 (UTC)
Subject: Re: [PATCH 000/117] Make better use of static type checking
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <7eaf77e8-ca4f-c0db-e94a-5fa3e16e3b51@suse.de>
 <5c194446-e145-9d6d-3bc2-23254f0058b9@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e230eb1f-172f-c18e-61dd-f9601e30d127@suse.de>
Date:   Tue, 20 Apr 2021 19:11:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <5c194446-e145-9d6d-3bc2-23254f0058b9@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/21 6:12 PM, Bart Van Assche wrote:
> On 4/19/21 11:04 PM, Hannes Reinecke wrote:
>> We should not try to preserve the split SCSI result value with its four
>> distinct fields.
> 
> I don't think that we have the freedom to drop the four byte SCSI result
> entirely since multiple user space APIs use that data structure. The
> four-byte SCSI result value is embedded in the following user space API
> data structures (there may be others):
> * struct sg_io_v4, the SG_IO header includes the driver_status
> (driver_byte()), transport_status (host_byte()) and device_status
> (scsi_status & 0xff) (the message byte is not included).
> * struct fc_bsg_reply.
> * struct iscsi_bsg_reply.
> * struct ufs_bsg_reply.
> 
Yes, I know. But that's the user-space API; there is nothing forcing us 
to continue using it internally as long as we keep the userspace API intact.

>> I'd rather have the message byte handling moved into the SCSI parallel
>> drivers (where really it should've been in the first place).
>> The driver byte can go entirely as the DRIVER_SENSE flag can be replaced
>> with a check for valid sense code, DRIVER_TIMEOUT is pretty much
>> identical to DID_TIMEOUT (with the semantic difference _who_ set the
>> timeout), and DRIVER_ERROR can be folded back into the caller.
>> All other values are unused, allowing us to drop driver error completely.
>>
>> With that we're only having two fields (host byte and status byte) left,
>> which should be treated as two distinct values.
>>
>> As it so happens I do have a patchset for this; guess I'll be posting it
>> to demonstrate the idea.
> 
> This patch series does not prevent the conversion described above.
> Although I think that the changes described above would help, I have a
> few concerns:
> - Some drivers use the result member of struct scsi_cmnd for another
> purpose than storing SCSI result values. See e.g. the CAM_* values
> defined in drivers/scsi/aic7xxx/cam.h and the use of these values in
> drivers/scsi/aic7xxx/aic79xx_osm.c. From the master branch:
> 
>          [ ... ]
> 	cmd->scsi_done = scsi_done;
> 	cmd->result = CAM_REQ_INPROG << 16;
> 	rtn = ahd_linux_run_command(ahd, dev, cmd);
>          [ ... ]
> 
>          [ ... ]
> 	if ((cmd->result & (CAM_DEV_QFRZN << 16)) != 0) {
> 		cmd->result &= ~(CAM_DEV_QFRZN << 16);
> 		dev->qfrozen--;
> 	}
>          [ ... ]
> 
> Converting this driver could be challenging and may end up in rewriting
> this driver.

No, not really. I've got a patch for that; we should have separated the 
CAM values from the SAM status values a long time ago.

> - The SCSI drivers that do something meaningful with the message byte
> are parallel SCSI drivers. Parallel SCSI is a technology that was
> popular 20-30 years ago but that is no longer popular today. Finding
> test hardware may be a big challenge.

Indeed, the _drivers_ do.
But the SCSI midlayer does not; is just checks for a non-zero value here.
So we can easily map a non-zero message byte to DID_ERROR before calling 
->scsi_done(), allowing us to keep the message byte handling within the 
SCSI parallel drivers.

I got patches for that ...

> - The parallel SCSI technology is no longer commercially relevant. It
> may be challenging to motivate people (including yourself) to convert a
> significant number of parallel SCSI drivers that each have a small user
> base.
> 
... true, but then your patchset suffers from the same issue, no?

> Although I appreciate it that you have shared this proposal and also
> that you have proposed to lead this effort, I'm not convinced that this
> proposal will be implemented soon. So I propose to proceed with this
> patch series.
> 
I'm currently porting the patchset to 5.13/scsi-queue, and hope to have 
it published soon.

Don't get me wrong; I like your idea with introducing enums for stricter 
type-checking in the SCSI stack.
My point is simply that if we were converting the SCSI result (for 
whatever reason) we should drop those bits which are pointless (like 
DRIVER_SENSE), or never have been used at all (like DRIVER_HARD).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
