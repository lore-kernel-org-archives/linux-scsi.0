Return-Path: <SRS0=fvsq=YM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3D3CA9EAB
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Oct 2019 15:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2567721744
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Oct 2019 15:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfJSP4A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Oct 2019 11:56:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:59438 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725924AbfJSP4A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Oct 2019 11:56:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF5A5AC59;
        Sat, 19 Oct 2019 15:55:58 +0000 (UTC)
Subject: Re: [RFC PATCH 0/3] lpfc: nodelist pointer cleanup
To:     James Smart <james.smart@broadcom.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191018075010.55653-1-hare@suse.de>
 <ced4e239-40b2-508a-f52a-1b7baf674f04@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6decf1ca-0cbb-3d86-8500-78ae36c69012@suse.de>
Date:   Sat, 19 Oct 2019 17:55:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <ced4e239-40b2-508a-f52a-1b7baf674f04@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/18/19 11:45 PM, James Smart wrote:
> On 10/18/2019 12:50 AM, Hannes Reinecke wrote:
>> Hi James,
>>
>> trying to figure this annoying lpfc_set_rrq_active() bug
>> I've found the nodelist pointer handling in the lpfc io buffers
>> a bit strange; there's a 'ndlp' pointer, but for scsi the nodelist
>> is primarily accessed via the 'rdata' pointer (although not everywhere).
>> For NVMe it's primarily the 'ndlp' pointer, apparently, but the
>> usage is quite confusing.
>> So here's a patchset to straighten things up; it primarily moves
>> the anonymous protocol-specific structure in the io buffer to a named
>> one, and always accesses the nodelist through the protocol-specific
>> rport data structure.
>>
>> It also has the nice side-effect that the protocol-specific areas are
>> aligned now, so clearing the 'rdata' pointer on the scsi side will
>> be equivalent to clearing the 'rport' pointer on the nvme side.
>> And it reduces the size of the io buffer.
>>
>> Let me know what you think.
>>
>> Hannes Reinecke (3):
>>    lpfc: use named structure for combined I/O buffer
>>    lpfc: access nodelist through scsi-specific rdata pointer
>>    lpfc: access nvme nodelist through nvme rport structure
>>
>>   drivers/scsi/lpfc/lpfc_init.c |   2 +-
>>   drivers/scsi/lpfc/lpfc_nvme.c |  56 ++++++------
>>   drivers/scsi/lpfc/lpfc_scsi.c | 196 
>> +++++++++++++++++++++---------------------
>>   drivers/scsi/lpfc/lpfc_sli.c  |  26 +++---
>>   drivers/scsi/lpfc/lpfc_sli.h  |   6 +-
>>   5 files changed, 143 insertions(+), 143 deletions(-)
>>
> 
> Well, the problem I think you are trying to solve is ultimately the root 
> issue that is solved by this patch in the just-posted 12.6.0.0 patch set:
> [PATCH 05/16] lpfc: Fix bad ndlp ptr in xri aborted handling
> 
> As such, I'd like to see if the 12.6.0.0 patch resolves the issue before 
> going through all the shifting in your patches.
> Note: the failing routine can change as it's totally dependent on where 
> the bogus pointer value takes you.  The key is the 
> lpfc_sli4_sp_handle_abort_xri_wcqe() routine on the stack.
> 
Fair enough.

I'll be giving your patchset a spin once submitted.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
