From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH ver2 24/24] ide-scsi.c: convert to data accessors and
 !use_sg cleanup
Date: Tue, 18 Sep 2007 12:24:50 +0200
Message-ID: <46EFA772.9090804@panasas.com>
References: <46E6F92D.2090409@panasas.com> <46E72F13.3090200@panasas.com> <46EF9459.7070102@panasas.com> <20070918091438.GA1198@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:2175 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbXIRKY5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 06:24:57 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1397112nfb
        for <linux-scsi@vger.kernel.org>; Tue, 18 Sep 2007 03:24:55 -0700 (PDT)
In-Reply-To: <20070918091438.GA1198@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>

On Tue, Sep 18 2007 at 11:14 +0200, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Sep 18, 2007 at 11:03:21AM +0200, Boaz Harrosh wrote:
>>  - Convert ide-scsi to the new data accessors and cleanup
>>    the !use_sg code paths.
>>
>>   In old code the MODE_SENSE or MODE_SELECT code paths still
>>   assumed scsi_cmnd->request_buffer is a linear char pointer.
>>   This means that this driver was broken since 2.6.17. Though
>>   I admit this assumption is hidden behind a flag:
>>   test_bit(PC_TRANSFORM, &pc->flags).
>>
>>   I have hacked these code paths to properly handle an sg_count==1,
>>   which is true in todays implementation of MODE_SENSE or
>>   MODE_SELECT.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/scsi/ide-scsi.c |   85 +++++++++++++++++++++++++++--------------------
>>  1 files changed, 49 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
>> index 1cc01ac..5c9a444 100644
>> --- a/drivers/scsi/ide-scsi.c
>> +++ b/drivers/scsi/ide-scsi.c
>> @@ -63,7 +63,7 @@
>>  
>>  typedef struct idescsi_pc_s {
>>  	u8 c[12];				/* Actual packet bytes */
>> -	int request_transfer;			/* Bytes to transfer */
>> +	unsigned int request_transfer;		/* Bytes to transfer */
>>  	int actually_transferred;		/* Bytes actually transferred */
>>  	int buffer_size;			/* Size of our data buffer */
>>  	struct request *rq;			/* The corresponding request */
>> @@ -175,7 +175,8 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
>>  	char *buf;
>>  
>>  	while (bcount) {
>> -		if (pc->sg - (struct scatterlist *) pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
>> +		if (pc->sg - scsi_sglist(pc->scsi_cmd) >
>> +		                                 scsi_sg_count(pc->scsi_cmd)) {
>>  			printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
>>  			idescsi_discard_data (drive, bcount);
>>  			return;
>>  static inline void idescsi_transform_pc1 (ide_drive_t *drive, idescsi_pc_t *pc)
>>  {
>> -	u8 *c = pc->c, *scsi_buf = pc->buffer, *sc = pc->scsi_cmd->cmnd;
>> -	char *atapi_buf;
>> -
>>  	if (!test_bit(PC_TRANSFORM, &pc->flags))
>>  		return;
>>  	if (drive->media == ide_cdrom || drive->media == ide_optical) {
>> +		u8 *c = pc->c;
>> +
>>  		if (c[0] == READ_6 || c[0] == WRITE_6) {
>>  			c[8] = c[4];		c[5] = c[3];		c[4] = c[2];
>>  			c[3] = c[1] & 0x1f;	c[2] = 0;		c[1] &= 0xe0;
>>  			c[0] += (READ_10 - READ_6);
>>  		}
>>  		if (c[0] == MODE_SENSE || c[0] == MODE_SELECT) {
>> +			u8 *sc = pc->scsi_cmd->cmnd;
>> +			char *atapi_buf;
>>  			unsigned short new_len;
>> -			if (!scsi_buf)
>> -				return;
> 
> Please just kill the translations.  Once we set use_10_for_rw and
> use_10_for_ms in the host template the upper layers won't send it anymore,
> and we should just reject these when coming from SG_IO.
> 

Thank you Christoph This is what I needed. I have set these 2 bits
and killed the translation. I will let the Device deal with SG_IO.
So I will not do any filtering of these commands. If SG_IO sends
the wrong commands to the wrong Devices it can deal with the
errors, right?

I will post a new ver3 patch.

Thanks
Boaz

