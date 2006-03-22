From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 01/15] libata: Setup nbytes in ata_sg_init_one
Date: Wed, 22 Mar 2006 08:36:48 -0600
Message-ID: <44216100.6050107@us.ibm.com>
References: <200603172303.k2HN3voJ028508@d01av02.pok.ibm.com> <4420AC91.4070007@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:20882 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751260AbWCVOhM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 09:37:12 -0500
In-Reply-To: <4420AC91.4070007@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Brian King wrote:
>> Setup nbytes in ata_sg_init_one to the total transfer length
>> of the command.
>>
>> Signed-off-by: Brian King <brking@us.ibm.com>
>> ---
>>
>>  libata-dev-bjking1/drivers/scsi/libata-core.c |    1 +
>>  1 files changed, 1 insertion(+)
>>
>> diff -puN drivers/scsi/libata-core.c~libata_setup_nbytes drivers/scsi/libata-core.c
>> --- libata-dev/drivers/scsi/libata-core.c~libata_setup_nbytes	2006-03-17 15:35:26.000000000 -0600
>> +++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-03-17 15:35:26.000000000 -0600
>> @@ -2887,6 +2887,7 @@ void ata_sg_init_one(struct ata_queued_c
>>  	qc->n_elem = 1;
>>  	qc->orig_n_elem = 1;
>>  	qc->buf_virt = buf;
>> +	qc->nbytes = buflen;
> 
> Why?
> 
> This is largely an internal variable used by the ATAPI code.

The ipr driver needs to know the total transfer length of the command
in bytes to setup the command to the adapter properly, since the adapter
firmware interface requires it. I didn't see anywhere else to get this
information, the only other option would be to compute it based on the
scatterlist.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
