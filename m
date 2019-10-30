Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6ED9CA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BDEB2087E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfJ3PSn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 11:18:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:55204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726596AbfJ3PSn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Oct 2019 11:18:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7EFEFAB9B;
        Wed, 30 Oct 2019 15:18:41 +0000 (UTC)
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
 <4ee551d0-27a6-b516-ade0-d477fd93bad8@suse.de>
 <d0899d02-ecb2-7f0b-3d0a-c818a0ec6ceb@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <571b5f9a-f151-30fb-5720-d7d47a4ef1d7@suse.de>
Date:   Wed, 30 Oct 2019 16:18:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <d0899d02-ecb2-7f0b-3d0a-c818a0ec6ceb@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/19 4:12 PM, Bart Van Assche wrote:
> On 10/30/19 1:30 AM, Hannes Reinecke wrote:
>> On 10/28/19 9:38 PM, Bart Van Assche wrote:
>>> If the residual is changed from signed into unsigned, how is a SCSI 
>>> LLD expected to report the difference between residual overflow and 
>>> residual underflow to the SCSI core?
>>
>> You don't have to. To quote RFC 3720 page 122:
>>
>>       bit 5 - (O) set for Residual Overflow.  In this case, the Residual
>>         Count indicates the number of bytes that were not transferred
>>         because the initiator's Expected Data Transfer Length was not
>>         sufficient.  For a bidirectional operation, the Residual Count
>>         contains the residual for the write operation.
>>
>> IE the 'overflow' setting in the iSCSI command response is an 
>> indicator that there _would_ be more data if the command request 
>> _would_ have specified a larger buffer.
>> But as it didn't, the entire buffer was filled, and the overflow 
>> counter is set.
>> Which, of course, is then ignored by the linux SCSI stack as the 
>> request got all data, and the residual is set to zero.
>> Then it's left to the caller to re-send with a larger buffer if 
>> required. But it's nothing the SCSI stack can nor should be attempting 
>> on its own.
> 
> Hi Hannes,
> 
> I do not agree that reporting a residual overflow by calling 
> scsi_set_resid(..., 0) is acceptable. For reads a residual overflow 
> means that the length specified in the CDB (scsi_bufflen()) exceeds the 
> data buffer size (length of scsi_sglist()). I think it's dangerous to 
> report to the block layer that such requests completed successfully and 
> with residual zero.
> 
But that is an error on submission, and should be aborted before it even 
got send to the drive.

However, this does not relate to the residual, which is handled after 
the command completes (and which sparked this entire thread ...).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
