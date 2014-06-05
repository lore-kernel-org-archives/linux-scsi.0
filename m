From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v5] sg: relax 16 byte cdb restriction
Date: Thu, 05 Jun 2014 18:21:31 -0400
Message-ID: <5390ED6B.3000904@interlog.com>
References: <538E035A.10703@interlog.com> <53908F6A.5090309@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48364 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaFEWVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2014 18:21:38 -0400
In-Reply-To: <53908F6A.5090309@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, Christian Franke <Christian.Franke@t-online.de>, James Bottomley <james.bottomley@hansenpartnership.com>

On 14-06-05 11:40 AM, Boaz Harrosh wrote:
> On 06/03/2014 08:18 PM, Douglas Gilbert wrote:
>> v4 of this patch was sent 20131201.
>>
>> ChangeLog:
>>           - remove the 16 byte CDB (SCSI command) length limit
>>             from the sg driver by handling longer CDBs the same
>>             way as the bsg driver. Remove comment from sg.h
>>             public interface about the cmd_len field being
>>             limited to 16 bytes.
>>           - remove some dead code caused by this change
>>           - cleanup comment block at the top of sg.h, fix urls
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>>
>>
>> sg_cdb_dg5.patch
>>
>>
> <>
>>
>> +/* SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type
>> + * of sg_io_hdr::cmd_len can only represent 255
>> + */
>> +#define SG_MAX_CDB_SIZE 255
>> +
>
> Just a nit on above comment (code is all good). CDB bigger then 16 is 8 bytes aligned
> So the maximum for sg is 252 not 255 as above.
> (As you said theoretical max is 260 but since it would not fit then the
>   next allowed size is 252)

Yes, "a multiple of four" so 252 would be better.

Doug Gilbert

>>   /*
>>    * Suppose you want to calculate the formula muldiv(x,m,d)=int(x * m / d)
>>    * Then when using 32 bit integers x * m may overflow during the calculation.
>> @@ -161,7 +164,7 @@ typedef struct sg_fd {		/* holds the state of a file descriptor */
>>   	char low_dma;		/* as in parent but possibly overridden to 1 */
>>   	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
>>   	char cmd_q;		/* 1 -> allow command queuing, 0 -> don't */
>> -	char next_cmd_len;	/* 0 -> automatic (def), >0 -> use on next write() */
>> +	unsigned char next_cmd_len; /* 0: automatic, >0: use on next write() */
>>   	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
>>   	char mmap_called;	/* 0 -> mmap() never called on this fd */
>>   	struct kref f_ref;
>> @@ -566,7 +569,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
>>   	Sg_request *srp;
>>   	struct sg_header old_hdr;
>>   	sg_io_hdr_t *hp;
>> -	unsigned char cmnd[MAX_COMMAND_SIZE];
>> +	unsigned char cmnd[SG_MAX_CDB_SIZE];
>>
>>   	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
>>   		return -ENXIO;
>> @@ -598,12 +601,6 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
>>   	buf += SZ_SG_HEADER;
>>   	__get_user(opcode, buf);
>>   	if (sfp->next_cmd_len > 0) {
>> -		if (sfp->next_cmd_len > MAX_COMMAND_SIZE) {
>> -			SCSI_LOG_TIMEOUT(1, printk("sg_write: command length too long\n"));
>> -			sfp->next_cmd_len = 0;
>> -			sg_remove_request(sfp, srp);
>> -			return -EIO;
>> -		}
>>   		cmd_size = sfp->next_cmd_len;
>>   		sfp->next_cmd_len = 0;	/* reset so only this write() effected */
>>   	} else {
>> @@ -675,7 +672,7 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
>>   	int k;
>>   	Sg_request *srp;
>>   	sg_io_hdr_t *hp;
>> -	unsigned char cmnd[MAX_COMMAND_SIZE];
>> +	unsigned char cmnd[SG_MAX_CDB_SIZE];
>>   	int timeout;
>>   	unsigned long ul_timeout;
>>
>> @@ -1645,14 +1642,24 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
>>   	struct request_queue *q = sfp->parentdp->device->request_queue;
>>   	struct rq_map_data *md, map_data;
>>   	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
>> +	unsigned char *long_cmdp = NULL;
>>
>>   	SCSI_LOG_TIMEOUT(4, printk(KERN_INFO "sg_start_req: dxfer_len=%d\n",
>>   				   dxfer_len));
>> +	if (hp->cmd_len > BLK_MAX_CDB) {
>> +		long_cmdp = kzalloc(hp->cmd_len, GFP_KERNEL);
>> +		if (!long_cmdp)
>> +			return -ENOMEM;
>> +	}
>>
>>   	rq = blk_get_request(q, rw, GFP_ATOMIC);
>> -	if (!rq)
>> +	if (!rq) {
>> +		kfree(long_cmdp);
>>   		return -ENOMEM;
>> +	}
>>
>> +	if (hp->cmd_len > BLK_MAX_CDB)
>> +		rq->cmd = long_cmdp;
>>   	memcpy(rq->cmd, cmd, hp->cmd_len);
>>
>>   	rq->cmd_len = hp->cmd_len;
>> @@ -1739,6 +1746,8 @@ static int sg_finish_rem_req(Sg_request * srp)
>>   		if (srp->bio)
>>   			ret = blk_rq_unmap_user(srp->bio);
>>
>> +		if (srp->rq->cmd != srp->rq->__cmd)
>> +			kfree(srp->rq->cmd);
>>   		blk_put_request(srp->rq);
>>   	}
>>
>> diff --git a/include/scsi/sg.h b/include/scsi/sg.h
>> index a9f3c6f..d8c0c43 100644
>> --- a/include/scsi/sg.h
>> +++ b/include/scsi/sg.h
>> @@ -4,77 +4,34 @@
>>   #include <linux/compiler.h>
>>
>>   /*
>> -   History:
>> -    Started: Aug 9 by Lawrence Foard (entropy@world.std.com), to allow user
>> -     process control of SCSI devices.
>> -    Development Sponsored by Killy Corp. NY NY
>> -Original driver (sg.h):
>> -*       Copyright (C) 1992 Lawrence Foard
>> -Version 2 and 3 extensions to driver:
>> -*       Copyright (C) 1998 - 2006 Douglas Gilbert
>> -
>> -    Version: 3.5.34 (20060920)
>> -    This version is for 2.6 series kernels.
>> -
>> -    For a full changelog see http://www.torque.net/sg
>> -
>> -Map of SG verions to the Linux kernels in which they appear:
>> -       ----------        ----------------------------------
>> -       original          all kernels < 2.2.6
>> -       2.1.40            2.2.20
>> -       3.0.x             optional version 3 sg driver for 2.2 series
>> -       3.1.17++          2.4.0++
>> -       3.5.30++          2.6.0++
>> -
>> -Major new features in SG 3.x driver (cf SG 2.x drivers)
>> -	- SG_IO ioctl() combines function if write() and read()
>> -	- new interface (sg_io_hdr_t) but still supports old interface
>> -	- scatter/gather in user space, direct IO, and mmap supported
>> -
>> - The normal action of this driver is to use the adapter (HBA) driver to DMA
>> - data into kernel buffers and then use the CPU to copy the data into the
>> - user space (vice versa for writes). That is called "indirect" IO due to
>> - the double handling of data. There are two methods offered to remove the
>> - redundant copy: 1) direct IO and 2) using the mmap() system call to map
>> - the reserve buffer (this driver has one reserve buffer per fd) into the
>> - user space. Both have their advantages.
>> - In terms of absolute speed mmap() is faster. If speed is not a concern,
>> - indirect IO should be fine. Read the documentation for more information.
>> -
>> - ** N.B. To use direct IO 'echo 1 > /proc/scsi/sg/allow_dio' or
>> -         'echo 1 > /sys/module/sg/parameters/allow_dio' is needed.
>> -         That attribute is 0 by default. **
>> -
>> - Historical note: this SCSI pass-through driver has been known as "sg" for
>> - a decade. In broader kernel discussions "sg" is used to refer to scatter
>> - gather techniques. The context should clarify which "sg" is referred to.
>> -
>> - Documentation
>> - =============
>> - A web site for the SG device driver can be found at:
>> -	http://www.torque.net/sg  [alternatively check the MAINTAINERS file]
>> - The documentation for the sg version 3 driver can be found at:
>> - 	http://www.torque.net/sg/p/sg_v3_ho.html
>> - This is a rendering from DocBook source [change the extension to "sgml"
>> - or "xml"]. There are renderings in "ps", "pdf", "rtf" and "txt" (soon).
>> - The SG_IO ioctl is now found in other parts kernel (e.g. the block layer).
>> - For more information see http://www.torque.net/sg/sg_io.html
>> -
>> - The older, version 2 documents discuss the original sg interface in detail:
>> -	http://www.torque.net/sg/p/scsi-generic.txt
>> -	http://www.torque.net/sg/p/scsi-generic_long.txt
>> - Also available: <kernel_source>/Documentation/scsi/scsi-generic.txt
>> -
>> - Utility and test programs are available at the sg web site. They are
>> - packaged as sg3_utils (for the lk 2.4 and 2.6 series) and sg_utils
>> - (for the lk 2.2 series).
>> -*/
>> + * History:
>> + *  Started: Aug 9 by Lawrence Foard (entropy@world.std.com), to allow user
>> + *   process control of SCSI devices.
>> + *  Development Sponsored by Killy Corp. NY NY
>> + *
>> + * Original driver (sg.h):
>> + *       Copyright (C) 1992 Lawrence Foard
>> + * Version 2 and 3 extensions to driver:
>> + *	Copyright (C) 1998 - 2014 Douglas Gilbert
>> + *
>> + *  Version: 3.5.36 (20140603)
>> + *  This version is for 2.6 and 3 series kernels.
>> + *
>> + * Documentation
>> + * =============
>> + * A web site for the SG device driver can be found at:
>> + *	http://sg.danny.cz/sg  [alternatively check the MAINTAINERS file]
>> + * The documentation for the sg version 3 driver can be found at:
>> + *	http://sg.danny.cz/sg/p/sg_v3_ho.html
>> + * Also see: <kernel_source>/Documentation/scsi/scsi-generic.txt
>> + *
>> + * For utility and test programs see: http://sg.danny.cz/sg/sg3_utils.html
>> + */
>>
>>   #ifdef __KERNEL__
>>   extern int sg_big_buff; /* for sysctl */
>>   #endif
>>
>> -/* New interface introduced in the 3.x SG drivers follows */
>>
>>   typedef struct sg_iovec /* same structure as used by readv() Linux system */
>>   {                       /* call. It defines one scatter-gather element. */
>> @@ -87,7 +44,7 @@ typedef struct sg_io_hdr
>>   {
>>       int interface_id;           /* [i] 'S' for SCSI generic (required) */
>>       int dxfer_direction;        /* [i] data transfer direction  */
>> -    unsigned char cmd_len;      /* [i] SCSI command length ( <= 16 bytes) */
>> +    unsigned char cmd_len;      /* [i] SCSI command length */
>>       unsigned char mx_sb_len;    /* [i] max length to write to sbp */
>>       unsigned short iovec_count; /* [i] 0 implies no scatter gather */
>>       unsigned int dxfer_len;     /* [i] byte count of data transfer */
>
> Reviewed-by: Boaz Harrosh <boaz@electrozaur.com>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

