Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A91CA9EAF
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 08:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D79A420679
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 08:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfJ3IbA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 04:31:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:34916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbfJ3IbA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Oct 2019 04:31:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B53EB2C6;
        Wed, 30 Oct 2019 08:30:57 +0000 (UTC)
Subject: Re: [PATCH] scsi: Fix scsi_get/set_resid() interface
To:     Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
References: <20191028105732.29913-1-damien.lemoal@wdc.com>
 <eb8f6e3e-0350-9688-58c8-9d777ba93298@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4ee551d0-27a6-b516-ade0-d477fd93bad8@suse.de>
Date:   Wed, 30 Oct 2019 09:30:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <eb8f6e3e-0350-9688-58c8-9d777ba93298@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/19 9:38 PM, Bart Van Assche wrote:
> On 10/28/19 3:57 AM, Damien Le Moal wrote:
>> struct scsi_cmnd cmd->req.resid_len which is returned and set
>> respectively by the helper functions scsi_get_resid() and
>> scsi_set_resid() is an unsigned int. Reflect this fact in the interface
>> of these helper functions.
>> [ ... ]
>> -static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
>> +static inline void scsi_set_resid(struct scsi_cmnd *cmd, unsigned int 
>> resid)
>>   {
>>       cmd->req.resid_len = resid;
>>   }
>> -static inline int scsi_get_resid(struct scsi_cmnd *cmd)
>> +static inline unsigned int scsi_get_resid(struct scsi_cmnd *cmd)
>>   {
>>       return cmd->req.resid_len;
>>   }
> 
>  From the iSCSI RFC:
> 
>     SCSI-Presented Data Transfer Length (SPDTL) is the term this document
>     uses (see Section 1.1 for definition) to represent the aggregate data
>     length that the target SCSI layer attempts to transfer using the
>     local iSCSI layer for a task.  Expected Data Transfer Length (EDTL)
>     is the iSCSI term that represents the length of data that the iSCSI
>     layer expects to transfer for a task.  EDTL is specified in the SCSI
>     Command PDU.
> 
>     When SPDTL = EDTL for a task, the target iSCSI layer completes the
>     task with no residuals.  Whenever SPDTL differs from EDTL for a task,
>     that task is said to have a residual.
> 
>     If SPDTL > EDTL for a task, iSCSI Overflow MUST be signaled in the
>     SCSI Response PDU as specified in [RFC3720].  The Residual Count MUST
>     be set to the numerical value of (SPDTL - EDTL).
> 
>     If SPDTL < EDTL for a task, iSCSI Underflow MUST be signaled in the
>     SCSI Response PDU as specified in [RFC3720].  The Residual Count MUST
>     be set to the numerical value of (EDTL - SPDTL).
> 
>     Note that the Overflow and Underflow scenarios are independent of
>     Data-In and Data-Out.  Either scenario is logically possible in
>     either direction of data transfer.
> 
> If the residual is changed from signed into unsigned, how is a SCSI LLD 
> expected to report the difference between residual overflow and residual 
> underflow to the SCSI core?
> 
You don't have to. To quote RFC 3720 page 122:

      bit 5 - (O) set for Residual Overflow.  In this case, the Residual
        Count indicates the number of bytes that were not transferred
        because the initiator's Expected Data Transfer Length was not
        sufficient.  For a bidirectional operation, the Residual Count
        contains the residual for the write operation.

IE the 'overflow' setting in the iSCSI command response is an indicator 
that there _would_ be more data if the command request _would_ have 
specified a larger buffer.
But as it didn't, the entire buffer was filled, and the overflow counter 
is set.
Which, of course, is then ignored by the linux SCSI stack as the request 
got all data, and the residual is set to zero.
Then it's left to the caller to re-send with a larger buffer if 
required. But it's nothing the SCSI stack can nor should be attempting 
on its own.

As such I think the patch is correct.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
