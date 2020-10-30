Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3682C5517A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 07:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82F0F20731
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 07:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgJ3HQ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 03:16:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:41010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3HQ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 03:16:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 07FE0ACDF;
        Fri, 30 Oct 2020 07:16:56 +0000 (UTC)
Subject: Re: [PATCH 1/2] scsi: scsi_vpd_lun_id(): fix designator priorities
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>
References: <20201029170846.14786-1-mwilck@suse.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4ae40060-2e28-09b0-ec90-d110e919267a@suse.de>
Date:   Fri, 30 Oct 2020 08:16:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201029170846.14786-1-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/29/20 6:08 PM, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The current implementation of scsi_vpd_lun_id() uses the designator
> length as an implicit measure of priority. This works most of the
> time, but not always. For example, some Hitachi storage arrays return
> this in VPD 0x83:
> 
> VPD INQUIRY: Device Identification page
>    Designation descriptor number 1, descriptor length: 24
>      designator_type: T10 vendor identification,  code_set: ASCII
>      associated with the Addressed logical unit
>        vendor id: HITACHI
>        vendor specific: 5030C3502025
>    Designation descriptor number 2, descriptor length: 6
>      designator_type: vendor specific [0x0],  code_set: Binary
>      associated with the Target port
>        vendor specific: 08 03
>    Designation descriptor number 3, descriptor length: 20
>      designator_type: NAA,  code_set: Binary
>      associated with the Addressed logical unit
>        NAA 6, IEEE Company_id: 0x60e8
>        Vendor Specific Identifier: 0x7c35000
>        Vendor Specific Identifier Extension: 0x30c35000002025
>        [0x60060e8007c350000030c35000002025]
> 
> The current code would use the first descriptor, because it's longer
> than the NAA descriptor. But this is wrong, the kernel is supposed
> to prefer NAA descriptors over T10 vendor ID. Designator length
> should only be used to compare designators of the same type.
> 
> This patch addresses the issue by separating designator priority and
> length.
> 
> Fixes: 9983bed3907c ("scsi: Add scsi_vpd_lun_id()")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/scsi/scsi_lib.c | 126 +++++++++++++++++++++++++++-------------
>   1 file changed, 86 insertions(+), 40 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
