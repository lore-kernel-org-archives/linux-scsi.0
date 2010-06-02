From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: fix scsi_get_lba helper function for pc command
Date: Wed, 02 Jun 2010 10:55:17 -0400
Message-ID: <4C0670D5.3050409@interlog.com>
References: <20100602163313S.fujita.tomonori@lab.ntt.co.jp> <1275487628.2799.18.camel@mulgrave.site>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53539 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757693Ab0FBOz1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jun 2010 10:55:27 -0400
In-Reply-To: <1275487628.2799.18.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jaxboe@fusionio.com, linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com

On 10-06-02 10:07 AM, James Bottomley wrote:
> On Wed, 2010-06-02 at 16:33 +0900, FUJITA Tomonori wrote:
>> This fixes scsi_get_lba() helper function for PC commands.
>>
>> Only the block layer is supposed to touch rq->__sector. We could
>> create a new accessor for it. But it seems overdoing a bit? Jens?
>>
>> =
>> From: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
>> Subject: [PATCH] scsi: fix scsi_get_lba helper function for pc command
>>
>> scsi_get_lba() can be used to get the lba info from
>> scsi_cmnd. scsi_get_lba() gets the lba info from rq->__sector so
>> scsi_get_lba() returns a bogus value for PC commands (we don't use
>> rq->__sector for PC commands).
>>
>> This patch sets rq->__sector in scsi_setup_blk_pc_cmnd() so that
>> scsi_get_lba() works with PC commands.
>>
>> scsi_get_data_transfer_info() is taken from
>> scsi_debug. scsi_get_data_transfer_info() looks useful for some
>> (scsi_debug, scsi_trace, libata, etc). So I export it. I'll convert
>> them to use scsi_get_data_transfer_info().
>>
>> Signed-off-by: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
>> ---
>>   drivers/scsi/scsi_lib.c  |   54 +++++++++++++++++++++++++++++++++++++++++++++-
>>   include/scsi/scsi_cmnd.h |    4 +++
>>   2 files changed, 57 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 1646fe7..b9b7f40 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -19,6 +19,7 @@
>>   #include<linux/delay.h>
>>   #include<linux/hardirq.h>
>>   #include<linux/scatterlist.h>
>> +#include<asm/unaligned.h>
>>
>>   #include<scsi/scsi.h>
>>   #include<scsi/scsi_cmnd.h>
>> @@ -69,6 +70,52 @@ struct kmem_cache *scsi_sdb_cache;
>>
>>   static void scsi_run_queue(struct request_queue *q);
>>
>> +int scsi_get_data_transfer_info(unsigned char *cmd, unsigned long long *lba,
>> +				unsigned int *num, unsigned int *ei_lba)
>> +{
>> +	int ret = 0;
>> +
>> +	switch (*cmd) {
>> +	case VARIABLE_LENGTH_CMD:
>> +		*lba = get_unaligned_be64(&cmd[12]);
>> +		*num = get_unaligned_be32(&cmd[28]);
>> +		*ei_lba = get_unaligned_be32(&cmd[20]);
>> +		break;
>
> You can't do this ... unless you know the format of the command.  For
> instance, if you knew this was a 32 byte CDB, then SPC does define where
> the LBA is.
>
>> +	case WRITE_16:
>> +	case READ_16:
>> +	case VERIFY_16:
>> +	case WRITE_SAME_16:
>> +		*lba = get_unaligned_be64(&cmd[2]);
>> +		*num = get_unaligned_be32(&cmd[10]);
>> +		break;
>> +	case WRITE_12:
>> +	case READ_12:
>> +	case VERIFY_12:
>> +		*lba = get_unaligned_be32(&cmd[2]);
>> +		*num = get_unaligned_be32(&cmd[6]);
>> +		break;
>> +	case WRITE_10:
>> +	case READ_10:
>> +	case XDWRITEREAD_10:
>> +	case VERIFY:
>> +	case WRITE_SAME:
>> +		*lba = get_unaligned_be32(&cmd[2]);
>> +		*num = get_unaligned_be16(&cmd[7]);
>> +		break;
>> +	case WRITE_6:
>> +	case READ_6:
>> +		*lba = (u32)cmd[3] | (u32)cmd[2]<<  8 |
>> +			(u32)(cmd[1]&  0x1f)<<  16;
>> +		*num = (0 == cmd[4]) ? 256 : cmd[4];
>> +		break;
>
> I really wouldn't do it like this because there are going to be
> unexpected gaps.  What about using the CDB groups instead?  Each CDB
> group has a well defined location for the LBA.  The only problem is the
> 16 byte commands group because they have two forms: ordinary and long
> LBA.

The 16 byte SCSI command might be ATA PASS THROUGH (16)!

Is it so important to have scsi_get_lba() for "PC" commands?
Why not just return 0 or MAX_UINT and be done with it.

A "PC" command might be lots of things. For example:
   - a tunnelled ATA command
   - a non SCSI protocol
   - a SCSI vendor specific or obsolete command
     (e.g. some SCSI PRINTER commands share opcodes with
      READ and WRITE)
   - from a lesser used command set (e.g. OSD or SSC)

A LLD may well be able to narrow the field if it has a
reason to decode the command to find a LBA or other info.

Doug Gilbert
