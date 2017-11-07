From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] sd: Fix a disk probing hang
Date: Tue, 07 Nov 2017 10:09:00 -0800
Message-ID: <1510078140.3118.18.camel@linux.vnet.ibm.com>
References: <20171107173807.14396-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753208AbdKGSJI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 13:09:08 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vA7I8bcn004006
        for <linux-scsi@vger.kernel.org>; Tue, 7 Nov 2017 13:09:08 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2e3h6nsuey-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2017 13:09:07 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 7 Nov 2017 11:09:06 -0700
In-Reply-To: <20171107173807.14396-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On Tue, 2017-11-07 at 09:38 -0800, Bart Van Assche wrote:
> Avoid that disk probing hangs as follows if a SCSI host is removed
> after disk scanning started and before it completed:
> 
> Call Trace:
>  __schedule+0x2fa/0xbb0
>  schedule+0x36/0x90
>  schedule_timeout+0x22c/0x570
>  io_schedule_timeout+0x1e/0x50
>  wait_for_completion_io_timeout+0x11f/0x180
>  blk_execute_rq+0x86/0xc0
>  scsi_execute+0xdb/0x1f0
>  sd_revalidate_disk+0xed/0x1c70 [sd_mod]
>  sd_probe_async+0xc3/0x1d0 [sd_mod]
>  async_run_entry_fn+0x38/0x160
>  process_one_work+0x20a/0x660
>  worker_thread+0x3d/0x3b0
>  kthread+0x13a/0x150
>  ret_from_fork+0x27/0x40
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/sd.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 0313486d85c8..d5e2b73c02ea 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3225,11 +3225,13 @@ static void sd_probe_async(void *data,
> async_cookie_t cookie)
>  {
>  	struct scsi_disk *sdkp = data;
>  	struct scsi_device *sdp;
> +	struct Scsi_Host *host;
>  	struct gendisk *gd;
>  	u32 index;
>  	struct device *dev;
>  
>  	sdp = sdkp->device;
> +	host = sdp->host;
>  	gd = sdkp->disk;
>  	index = sdkp->index;
>  	dev = &sdp->sdev_gendev;
> @@ -3253,6 +3255,13 @@ static void sd_probe_async(void *data,
> async_cookie_t cookie)
>  	sdkp->first_scan = 1;
>  	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
>  
> +	mutex_lock(&host->scan_mutex);

I really don't like this: by taking the scan mutex here, you
synchronize this with everything else and make this routine single
threaded with every other host scan operation.  That would make the
name sd_probe_async() a complete lie.

Additionally, any reference to the disk should *automatically* hold the
host, because the last reference to the host is in the disk release
routine, so this explicit taking of a reference should be completely
unnecessary (and if it isn't, we need to fix the bug at source, not
hide it like this).

The whole point about our async routines is that they're supposed to
rely on refcounting.  So, the host cannot be freed until the last
device reference is gone.  However, the host and its devices can go
into DEL state, which means the mid-layer replies error for them and
the async scan is supposed to take that error and pass it up.  The hang
you're getting may be the result of a missing scsi_device_online()
check, or it could be some premature failure of the underlying device
driver (going into SHOST_DEL with outstanding commands causes them to
get frozen) but can you investigate the root cause rather than trying
this bandaid?

Thanks,

James
