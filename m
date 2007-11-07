From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [SCSI] iscsi: return data transfer residual for data-out
 commands
Date: Wed, 07 Nov 2007 14:42:50 -0600
Message-ID: <4732234A.1040100@cs.wisc.edu>
References: <4731FEA4.5040206@cybernetics.com> <47320F4B.2040503@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46333 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbXKGUpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Nov 2007 15:45:12 -0500
In-Reply-To: <47320F4B.2040503@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

Boaz Harrosh wrote:
> On Wed, Nov 07 2007 at 20:06 +0200, Tony Battersby <tonyb@cybernetics.com> wrote:
>> Currently, the iSCSI driver returns the data transfer residual for
>> data-in commands (e.g. read) but not data-out commands (e.g. write).
>> This patch makes it return the data transfer residual for both types of
>> commands.
> All types of commands, also good for BIDI ;)
> 
>> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
>> ---
>> --- linux-2.6.24-rc2/drivers/scsi/libiscsi.c.orig	2007-11-07 12:52:20.000000000 -0500
>> +++ linux-2.6.24-rc2/drivers/scsi/libiscsi.c	2007-11-07 12:52:27.000000000 -0500
>> @@ -291,9 +291,6 @@ invalid_datalen:
>>  			   min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
>>  	}
>>  
>> -	if (sc->sc_data_direction == DMA_TO_DEVICE)
>> -		goto out;
>> -
>>  	if (rhdr->flags & ISCSI_FLAG_CMD_UNDERFLOW) {
>>  		int res_count = be32_to_cpu(rhdr->residual_count);
>>  
>>
>>
> Thanks, this looks right to me. (And good catch)
> I have went through the code and it looks like the right thing to do.
> "svn blame" annotates this code to the patch (r527) that libiscsi was 
> cut out of iscsi_tcp so perhaps then it made sense

Actually I think we always had it in one way or another. Maybe because 
of the code moves svn blame goofed.

I think it was originally done because we probably thought we could not 
get underflow or overflow on a write. I do not know for sure though, but 
it may have been a workaround for some old firmware on another target 
that was fixed a long time ago.


The patch looks ok. Thanks.

James please apply with his other patch

http://marc.info/?l=linux-scsi&m=119334187619290&w=2

for scsi-rc-fixes when you get a chance. Thanks.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
