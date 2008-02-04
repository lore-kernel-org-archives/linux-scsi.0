From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/24][RFC] firewire & ieee1394: Simple convert to new
 scsi_eh_cpy_sense.
Date: Mon, 04 Feb 2008 19:04:56 +0200
Message-ID: <47A745B8.8090806@panasas.com>
References: 47A72A7F.1050301@panasas.com <1202140606-4629-1-git-send-email-bharrosh@panasas.com> <47A73F37.7090704@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:36256 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbYBDRGT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:06:19 -0500
In-Reply-To: <47A73F37.7090704@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Feb 04 2008 at 18:37 +0200, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Boaz Harrosh wrote:
>> --- a/drivers/ieee1394/sbp2.c
>> +++ b/drivers/ieee1394/sbp2.c
>> @@ -1672,8 +1673,11 @@ static int sbp2_send_command(struct sbp2_lu *lu, struct scsi_cmnd *SCpnt,
>>   * Translates SBP-2 status into SCSI sense data for check conditions
>>   */
>>  static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status,
>> -					      unchar *sense_data)
>> +					      struct scsi_cmnd *SCpnt)
>>  {
>> +	u8 sense_data[16];
>> +
>> +	memset(sense_data, 0, sizeof(sense_data));
>>  	/* OK, it's pretty ugly... ;-) */
>>  	sense_data[0] = 0x70;
>>  	sense_data[1] = 0x0;
>> @@ -1691,6 +1695,7 @@ static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status,
>>  	sense_data[13] = sbp2_status[11];
>>  	sense_data[14] = sbp2_status[20];
>>  	sense_data[15] = sbp2_status[21];
>> +	scsi_eh_cpy_sense(SCpnt, sense_data, sizeof(sense_data));
>>  
>>  	return sbp2_status[8] & 0x3f;
>>  }
> 
> You don't need the memset.
> 
OK I see what you mean now, they are all used. Thanks.

> Also, here and in drivers/firewire/fw-sbp2.c, the SCSI sense data could
> AFAICS be rewritten in-place in sbp2_status.  But I don't know if this
> is a worthwhile optimization; it would reduce readability.
Right, it's a very unlikely code path. readability is more important
here.

I will fix both places. Maybe I can use also here what Jeff suggested in the
other mail. We'll see how it goes.

Boaz

