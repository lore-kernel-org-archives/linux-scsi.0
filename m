Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC85C47E49
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 08:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E230208E3
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 08:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfJaI2M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 04:28:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:38842 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726747AbfJaI2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Oct 2019 04:28:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7CF89AB89;
        Thu, 31 Oct 2019 08:28:09 +0000 (UTC)
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
Message-ID: <825182ee-98ce-1905-1839-239a6a950db7@suse.de>
Date:   Thu, 31 Oct 2019 09:28:06 +0100
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
Dangerous how?

fcp3:
For read operations and write operations, if the FCP_RESID_OVER bit is 
set to one, the FCP_RESID field contains the excess of the number of 
bytes required by the SCSI command to be transferred over the number of 
bytes specified by the FCP_DL field.

SAS doesn't even have the notion of residuals

srp04:
DOOVER , when set to one, indicates that the DATA-OUT RESIDUAL COUNT 
field is valid and contains the count of data bytes that could not be 
transferred from the data-out buffer because the length of the data-out 
buffer was not sufficient. The application client should examine the 
DATA-OUT RESIDUAL COUNT field in the context of the command to determine 
whether or not an error condition occurred.

iSCSI we've already covered.

In all cases, the overflow value is an _indicator_ that additional data 
is available, but was not transferred due to the lack of space.
So we will not have any buffer overflow as data is never transferred.

And in most cases an overflow is actually desired; it is a pretty common 
use pattern to send a SCSI command with a small enough buffer to return 
the length of available data, and then send the actual command knowing 
how large the buffer needs to be.
See for example scsi_report_lun_scan() or the VPD handling code.

So again, I don't think it's something we need to worry about.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
