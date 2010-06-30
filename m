From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Length and alignment in scsi_execute_async and blk_rq_map_user
Date: Wed, 30 Jun 2010 13:39:59 +0300
Message-ID: <4C2B1EFF.5010606@panasas.com>
References: <AANLkTim3BamYYWtoVAhSvJDmD9-37BPcpthZIbI-FJ8y@mail.gmail.com> <4C2B1CD6.1000007@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:43789 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751758Ab0F3KkB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2010 06:40:01 -0400
In-Reply-To: <4C2B1CD6.1000007@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brett Dennis <brettldennis@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 06/30/2010 01:30 PM, Boaz Harrosh wrote:
> On 06/30/2010 12:23 AM, Brett Dennis wrote:
>> Hello,
>>
>> Apologies for posting twice (messed up on the subject line of the first post...)
>>
>> In kernel 2.6.26, the implementation of __blk_rq_map_user changed and
>> now includes a call to bio_copy_user:
>>
>> uaddr = (unsigned long) ubuf;
>> alignment = queue_dma_alignment(q) | q->dma_pad_mask;
>> if (!(uaddr & alignment) && !(len & alignment))
>>
>>      bio = bio_map_user(q, NULL, uaddr, len, reading);
>>
>> else
>>
>>      bio = bio_copy_user(q, uaddr, len, reading);
>>
>>
>> bio_copy_user uses the HBA's scatter-gather pages for the copy.  The
>> problem I face is that if the data is not aligned properly, or the len
>> parameter does not divide properly, and the transfer is greater than
>> the number of scatter-gather pages, the IO operation will fail.  I am
>> considering increasing the size of my data buffer to meet the
>> length-alignment requirement and changing the 'len' parameter passed
>> into blk_rq_map_user to include a larger size than my CDB transfer
>> length.  This way it will hit the bio_map_user branch instead of the
>> bio_copy_user branch and I won't have to worry about insufficient
>> sg-pages.  The tape device should still honor the CDB write length, so
>> unless there are other limitations imposed by the Linux kernel or SCSI
>> subsystem, I think this is a workable solution.  Does anyone in this
>> list know if there are requirements against sending a larger buffer
>> length than CDB transfer length?
>>
> 
> It depends. If you are issuing BLOCK_PC commands then you are in the clear.
> If an FS_PC commands then your ULD must take proper care at completion.
> What ULD are you using?
> 

Sorry I missed the scsi_execute_async() part in the title. So yes it is
BLOCK_PC. I think it should be fine, unless some LLD would break because
LLDs and HW do funny things. I'd try it out. If you have problems with
particular HW, perhaps keep a black-list flag. You might expect some
residual returns from some LLDs.

>> Thanks in advance.
>>
>> Brett Dennis
>> IBM tape device driver developer
> 
> Boaz
