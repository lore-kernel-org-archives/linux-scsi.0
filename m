From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 6/24][RFC] gdth: Use of scsi_eh API and sense accessors
Date: Mon, 04 Feb 2008 18:22:03 +0200
Message-ID: <47A73BAB.7020906@panasas.com>
References: 47A72A7F.1050301@panasas.com <1202141236-4722-1-git-send-email-bharrosh@panasas.com> <47A7392F.2050606@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:36781 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYBDQXM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 11:23:12 -0500
In-Reply-To: <47A7392F.2050606@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Feb 04 2008 at 18:11 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> Boaz Harrosh wrote:
>>   Use of new scsi_eh API for setting sense information into
>>   the scsi command.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/scsi/gdth.c |   47 ++++++++++++++++++++++++++---------------------
>>  drivers/scsi/gdth.h |    1 +
>>  2 files changed, 27 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
>> index c825239..9fdd5ef 100644
>> --- a/drivers/scsi/gdth.c
>> +++ b/drivers/scsi/gdth.c
>> @@ -2098,6 +2098,16 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
>>  #endif
>>  }
>>  
>> +static void gdth_set_4byte_sense(struct scsi_cmnd *scp, u8 sense_code)
>> +{
>> +	u8 sense[4];
>> +
>> +	memset(sense, 0, sizeof(sense));
>> +	sense[0] = 0x70;
>> +	sense[2] = sense_code;
>> +	scsi_eh_cpy_sense(scp, sense, sizeof(sense));
>> +}
> 
> IMO, setting 0x70 and 0x72 is highly common, and worthy of some simple 
> helper functions.  See ata_scsi_set_sense() in libata-scsi.c or 
> stex_set_sense() in stex.c, which is a copy of the former.
> 
> 	Jeff
> 
Thanks, Yes I was thinking of a more general sense-formating helper but
I'm not yet sure of it's API. If you also thinks so, it motivates me
to define one and use it in a lot of places that do such formating.

Boaz
