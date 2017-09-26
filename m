From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: ioctl reset should wait for IOs to complete
Date: Tue, 26 Sep 2017 11:33:47 -0700
Message-ID: <1506450827.3345.2.camel@linux.vnet.ibm.com>
References: <20170926172235.29530-1-lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1031149AbdIZSdz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Sep 2017 14:33:55 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8QIT90i036175
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2017 14:33:55 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2d7u0tcfbw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2017 14:33:54 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 26 Sep 2017 12:33:54 -0600
In-Reply-To: <20170926172235.29530-1-lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>

On Tue, 2017-09-26 at 10:22 -0700, Lee Duncan wrote:
> The SCSI ioctl reset path is smart enough to set the
> flag tmf_in_progress when a user-requested reset is
> processed, but it does not wait for IO that is in
> flight. This can result in lost IOs and hung
> processes. We should wait for a reasonable amount
> of time for either the IOs to complete or to fail
> the request.

The idea of the SCSI ioctl was to be async: issue reset and return.  Do
we have nothing in userspace that expects async behaviour? (if we have,
you could still add a flag or a new ioctl).

However:

> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/scsi/scsi_error.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 38942050b265..b964152611c3 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -57,6 +57,14 @@
>  #define BUS_RESET_SETTLE_TIME   (10)
>  #define HOST_RESET_SETTLE_TIME  (10)
>  
> +/*
> + * Time to wait for outstanding IOs when about to send
> + * a device reset, e.g. sg_reset. The msecs to wait must
> + * be an multiple of the msecs to wait per try.
> + */
> +#define MSECS_PER_TRY_FOR_IO_ON_RESET	500
> +#define MSECS_TO_WAIT_FOR_IO_ON_RESET	(MSECS_PER_TRY_FOR_IO_O
> N_RESET * 10)
> +
>  static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
>  static int scsi_try_to_abort_cmd(struct scsi_host_template *,
>  				 struct scsi_cmnd *);
> @@ -2269,6 +2277,7 @@ void scsi_report_device_reset(struct Scsi_Host
> *shost, int channel, int target)
>  	struct request *rq;
>  	unsigned long flags;
>  	int error = 0, rtn, val;
> +	unsigned int msecs_to_wait = MSECS_TO_WAIT_FOR_IO_ON_RESET;

scsi_report_device_reset is the wrong place to do the wait: that's used
by low level device drivers to report that they've detected a bus reset
and is expected to return immediately.

James
