Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448DCC4742C
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 06:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0849E20665
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 06:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgKKGyT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 01:54:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:56152 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgKKGyS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Nov 2020 01:54:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D5D32ABD1;
        Wed, 11 Nov 2020 06:54:16 +0000 (UTC)
Subject: Re: [PATCH 1/2] scsi: scsi_vpd_lun_id(): fix designator priorities
To:     "Martin K. Petersen" <martin.petersen@oracle.com>, mwilck@suse.com
Cc:     linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>
References: <20201029170846.14786-1-mwilck@suse.com>
 <yq1eel0ha2c.fsf@ca-mkp.ca.oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <64c0efe0-e6dd-d706-4e50-f21bcbc58e23@suse.de>
Date:   Wed, 11 Nov 2020 07:54:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <yq1eel0ha2c.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/20 4:05 AM, Martin K. Petersen wrote:
> 
> Martin,
> 
>> The current code would use the first descriptor, because it's longer
>> than the NAA descriptor. But this is wrong, the kernel is supposed to
>> prefer NAA descriptors over T10 vendor ID. Designator length should
>> only be used to compare designators of the same type.
>>
>> This patch addresses the issue by separating designator priority and
>> length.
> 
> I am concerned that we're going to break existing systems since their
> /dev/disk/by-* names might change as a result of this. Thoughts?
> 
No, this shouldn't happen. With the standard udev rules we're creating 
symlinks for all possible VPD designators, so they don't change.
The patch really is just for multipath to handle error cases better; 
we've had this situation when reading the vpd page hit an I/O error.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
