From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH 0/17] Clear up bidi command confusion
Date: Thu, 29 Jan 2015 16:43:18 +0200
Message-ID: <54CA4706.8040608@plexistor.com>
References: <54C2390A.3000700@sandisk.com> <20150123131249.GA8045@infradead.org> <54C60FCC.4060601@sandisk.com> <54CA30A8.5020101@plexistor.com> <54CA33A1.2020104@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:41951 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbbA2OnX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 09:43:23 -0500
Received: by mail-wi0-f176.google.com with SMTP id bs8so18427423wib.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2015 06:43:20 -0800 (PST)
In-Reply-To: <54CA33A1.2020104@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/29/2015 03:20 PM, Bart Van Assche wrote:
> On 01/29/15 14:07, Boaz Harrosh wrote:
>> On 01/26/2015 11:58 AM, Bart Van Assche wrote:
>>
>>> Hello Christoph,
>>>
>>> This makes sense to me. I will rework this patch series as you proposed.
>>
>> Do you have a bidi setup to test against?
>>
>> Sending xor command to scsi_dbg is only half the test for me because, yes
>> there are two buffers, but they are of same size so bugs might be masked.
>> (From experience)
> 
> Hello Boaz,
> 
> If anyone would like to submit a scsi_debug patch that adds support to
> that kernel driver for a bidi command for which the input and output
> buffers have different sizes I think that would be helpful.
> 

Hi Bart.

scsi_dbg is a scsi-blk-device type device (forgot the exact name).
I do not think there is such a command defined by the STD for this command
set.

its only for other device types like osd, printer and so on.

But sending XOR commands to scsi_dbg is a good start.

> Bart.
> 

Please Note: I do not agree for the use of the constant DMA_BIDIRECTIONAL
to denote scsi_bidi_cmnd(cmd). This is wrong and takes us back not
forward.

If anything at all is done, cmd->sc_data_direction should be just removed
all together. It is not needed and denotes nothing more than what is already
available at the request level. Please do not add any more new code on top
of cmd->sc_data_direction. (At minimum just remove the all DMA_BIDIRECTIONAL
checks and you are done)

Cheers
Boaz

