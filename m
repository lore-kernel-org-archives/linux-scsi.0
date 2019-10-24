Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671A9CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 04:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37A022166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 04:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406596AbfJXEYX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 00:24:23 -0400
Received: from smtp.infotech.no ([82.134.31.41]:53761 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfJXEYX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 00:24:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1A5F8204193;
        Thu, 24 Oct 2019 06:24:21 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jqXoGdAOfiwH; Thu, 24 Oct 2019 06:24:14 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 284EA20415B;
        Thu, 24 Oct 2019 06:24:12 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v5 20/23] sg: introduce request state machine
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20191008075022.30055-1-dgilbert@interlog.com>
 <20191008075022.30055-21-dgilbert@interlog.com>
 <c222a727-eebb-ebc0-9df4-efa694c9989c@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <9360e6da-39da-15bb-d9e8-cf881b936e8d@interlog.com>
Date:   Thu, 24 Oct 2019 00:24:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c222a727-eebb-ebc0-9df4-efa694c9989c@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-18 6:25 a.m., Hannes Reinecke wrote:
> On 10/8/19 9:50 AM, Douglas Gilbert wrote:
>> The introduced request state machine is not wired in so that
>> the size of one of the following patches is reduced. Bit
>> operation defines for the request and file descriptor level
>> are also introduced. Minor rework og sg_rd_append() function.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/sg.c | 237 ++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 175 insertions(+), 62 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 5b560f720993..4e6f6fb2a54e 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -75,7 +75,43 @@ static char *sg_version_date = "20190606";
>>   #define uptr64(val) ((void __user *)(uintptr_t)(val))
>>   #define cuptr64(val) ((const void __user *)(uintptr_t)(val))
>>   
>> +/* Following enum contains the states of sg_request::rq_st */
>> +enum sg_rq_state {
>> +	SG_RS_INACTIVE = 0,	/* request not in use (e.g. on fl) */
>> +	SG_RS_INFLIGHT,		/* active: cmd/req issued, no response yet */
>> +	SG_RS_AWAIT_RD,		/* response received, awaiting read */
>> +	SG_RS_DONE_RD,		/* read is ongoing or done */
>> +	SG_RS_BUSY,		/* temporary state should rarely be seen */
>> +};
>> +
>> +#define SG_TIME_UNIT_MS 0	/* milliseconds */
>> +#define SG_DEF_TIME_UNIT SG_TIME_UNIT_MS
>>   #define SG_DEFAULT_TIMEOUT mult_frac(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
>> +#define SG_FD_Q_AT_HEAD 0
>> +#define SG_DEFAULT_Q_AT SG_FD_Q_AT_HEAD /* for backward compatibility */
>> +#define SG_FL_MMAP_DIRECT (SG_FLAG_MMAP_IO | SG_FLAG_DIRECT_IO)
>> +
>> +/* Only take lower 4 bits of driver byte, all host byte and sense byte */
>> +#define SG_ML_RESULT_MSK 0x0fff00ff	/* mid-level's 32 bit result value */
>> +
>> +#define SG_PACK_ID_WILDCARD (-1)
>> +
>> +#define SG_ADD_RQ_MAX_RETRIES 40	/* to stop infinite _trylock(s) */
>> +
>> +/* Bit positions (flags) for sg_request::frq_bm bitmask follow */
>> +#define SG_FRQ_IS_ORPHAN	1	/* owner of request gone */
>> +#define SG_FRQ_SYNC_INVOC	2	/* synchronous (blocking) invocation */
>> +#define SG_FRQ_DIO_IN_USE	3	/* false->indirect_IO,mmap; 1->dio */
>> +#define SG_FRQ_NO_US_XFER	4	/* no user space transfer of data */
>> +#define SG_FRQ_DEACT_ORPHAN	7	/* not keeping orphan so de-activate */
>> +#define SG_FRQ_BLK_PUT_REQ	9	/* set when blk_put_request() called */
>> +
>> +/* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
>> +#define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
>> +#define SG_FFD_CMD_Q		1	/* clear: only 1 active req per fd */
>> +#define SG_FFD_KEEP_ORPHAN	2	/* policy for this fd */
>> +#define SG_FFD_MMAP_CALLED	3	/* mmap(2) system call made on fd */
>> +#define SG_FFD_Q_AT_TAIL	5	/* set: queue reqs at tail of blk q */
>>   
>>   /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
>>   #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
>> @@ -83,12 +119,11 @@ static char *sg_version_date = "20190606";
>>   #define SG_FDEV_LOG_SENSE	2	/* set by ioctl(SG_SET_DEBUG) */
>>   
>>   int sg_big_buff = SG_DEF_RESERVED_SIZE;
>> -/* N.B. This variable is readable and writeable via
>> -   /proc/scsi/sg/def_reserved_size . Each time sg_open() is called a buffer
>> -   of this size (or less if there is not enough memory) will be reserved
>> -   for use by this file descriptor. [Deprecated usage: this variable is also
>> -   readable via /proc/sys/kernel/sg-big-buff if the sg driver is built into
>> -   the kernel (i.e. it is not a module).] */
>> +/*
>> + * This variable is accessible via /proc/scsi/sg/def_reserved_size . Each
>> + * time sg_open() is called a sg_request of this size (or less if there is
>> + * not enough memory) will be reserved for use by this file descriptor.
>> + */
>>   static int def_reserved_size = -1;	/* picks up init parameter */
>>   static int sg_allow_dio = SG_ALLOW_DIO_DEF;
>>   
>> @@ -132,6 +167,7 @@ struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
>>   	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
>>   	/* done protected by rq_list_lock */
>>   	char done;		/* 0->before bh, 1->before read, 2->read */
>> +	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */
>>   	struct request *rq;	/* released in sg_rq_end_io(), bio kept */
>>   	struct bio *bio;	/* kept until this req -->SG_RS_INACTIVE */
>>   	struct execute_work ew_orph;	/* harvest orphan request */
>> @@ -208,10 +244,15 @@ static void sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp);
>>   static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
>>   static void sg_remove_sfp(struct kref *);
>>   static struct sg_request *sg_add_request(struct sg_fd *sfp);
>> -static int sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
>> +static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
>>   static struct sg_device *sg_get_dev(int dev);
>>   static void sg_device_destroy(struct kref *kref);
>>   static void sg_calc_sgat_param(struct sg_device *sdp);
>> +static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
>> +static void sg_rep_rq_state_fail(struct sg_fd *sfp,
>> +				 enum sg_rq_state exp_old_st,
>> +				 enum sg_rq_state want_st,
>> +				 enum sg_rq_state act_old_st);
>>   
>>   #define SZ_SG_HEADER ((int)sizeof(struct sg_header))	/* v1 and v2 header */
>>   #define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))	/* v3 header */
>> @@ -219,6 +260,8 @@ static void sg_calc_sgat_param(struct sg_device *sdp);
>>   
>>   #define SG_IS_DETACHING(sdp) test_bit(SG_FDEV_DETACHING, (sdp)->fdev_bm)
>>   #define SG_HAVE_EXCLUDE(sdp) test_bit(SG_FDEV_EXCLUDE, (sdp)->fdev_bm)
>> +#define SG_RS_ACTIVE(srp) (atomic_read(&(srp)->rq_st) != SG_RS_INACTIVE)
>> +#define SG_RS_AWAIT_READ(srp) (atomic_read(&(srp)->rq_st) == SG_RS_AWAIT_RD)
>>   
>>   /*
>>    * Kernel needs to be built with CONFIG_SCSI_LOGGING to see log messages.
>> @@ -382,15 +425,6 @@ sg_open(struct inode *inode, struct file *filp)
>>   	res = sg_allow_if_err_recovery(sdp, non_block);
>>   	if (res)
>>   		goto error_out;
>> -	/* scsi_block_when_processing_errors() may block so bypass
>> -	 * check if O_NONBLOCK. Permits SCSI commands to be issued
>> -	 * during error recovery. Tread carefully. */
>> -	if (!((op_flags & O_NONBLOCK) ||
>> -	      scsi_block_when_processing_errors(sdp->device))) {
>> -		res = -ENXIO;
>> -		/* we are in error recovery for this device */
>> -		goto error_out;
>> -	}
>>   
>>   	mutex_lock(&sdp->open_rel_lock);
>>   	if (op_flags & O_NONBLOCK) {
>> @@ -494,12 +528,12 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
>>   	struct sg_device *sdp;
>>   	struct sg_fd *sfp;
>>   	struct sg_request *srp;
>> +	u8 cmnd[SG_MAX_CDB_SIZE];
>>   	struct sg_header ov2hdr;
>>   	struct sg_io_hdr v3hdr;
>>   	struct sg_header *ohp = &ov2hdr;
>>   	struct sg_io_hdr *h3p = &v3hdr;
>>   	struct sg_comm_wr_t cwr;
>> -	u8 cmnd[SG_MAX_CDB_SIZE];
>>   
>>   	res = sg_check_file_access(filp, __func__);
>>   	if (res)
>> @@ -748,11 +782,25 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
>>   	return 0;
>>   }
>>   
>> +static inline int
>> +sg_rstate_chg(struct sg_request *srp, enum sg_rq_state old_st,
>> +	      enum sg_rq_state new_st)
>> +{
>> +	enum sg_rq_state act_old_st = (enum sg_rq_state)
>> +				atomic_cmpxchg(&srp->rq_st, old_st, new_st);
>> +
>> +	if (act_old_st == old_st)
>> +		return 0;       /* implies new_st --> srp->rq_st */
>> +	else if (IS_ENABLED(CONFIG_SCSI_LOGGING))
>> +		sg_rep_rq_state_fail(srp->parentfp, old_st, new_st,
>> +				     act_old_st);
>> +	return -EPROTOTYPE;
>> +}
>>   
> -EPROTOTYPE?
> Now there someone has read POSIX ... why not simply -EINVAL as one would
> expect?

I expect EINVAL from very shallow errors, like sanity checks by
ioctl(SG_IOSUBMIT) or write(2) before they issue a command/request to the
lower levels.

This however is a lot more interesting. It is potentially two readers in
a race, and if the race is close, the loser gets this error. Depending on
the context, the user will either see this error, or EBUSY. There is an
inherent race in the read/receive side of all AIO designs, as far as I
can determine. Such a race is advised against in my documentation, but
if a user, accidentally or otherwise, generates that race, then IMO
the driver needs to handle it. By "handle it" I don't mean trying to help
such users, I mean to protect the driver and the kernel behind it.

A later patch (46/62 currently) adds a 28 entry table of errno values
with their meaning if returned by this driver:
....
    EPROTOTYPE    atomic state change failed unexpectedly
....


Doug Gilbert


