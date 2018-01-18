From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] sd: succeed check_event if device is not removable
Date: Thu, 18 Jan 2018 08:32:52 -0800
Message-ID: <1516293172.3014.11.camel@linux.vnet.ibm.com>
References: <1516292559-26649-1-git-send-email-jinpu.wangl@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752746AbeARQdA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jan 2018 11:33:00 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0IGUDC1119073
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2018 11:33:00 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2fjxs69cdw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2018 11:32:59 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Thu, 18 Jan 2018 09:32:58 -0700
In-Reply-To: <1516292559-26649-1-git-send-email-jinpu.wangl@profitbricks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, gi-oh.kim@profitbricks.com

On Thu, 2018-01-18 at 17:22 +0100, Jack Wang wrote:
> From: Jack Wang <jinpu.wang@profitbricks.com>
> 
> The check_events interface was added for check if device changes,
> mainly for device is removable eg. CDROM
> 
> In sd_open, it checks if device is removable then check_disk_change.
> 
> when the device is not removable, we can simple succeeds the call
> without send TUR.
> 
> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> ---
>  drivers/scsi/sd.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ab75ebd..773ce81 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1576,6 +1576,10 @@ static unsigned int sd_check_events(struct
> gendisk *disk, unsigned int clearing)
>  	sdp = sdkp->device;
>  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
> "sd_check_events\n"));
>  
> +	if (!sdp->removable) {
> +		retval = 0;
> +		goto out;
> +	}

This looks like very much the wrong place to fix whatever problem
you're seeing is.  We could simply avoid setting up the events work
function in genhd.c:device_add_disk(), which would be way more
efficient.  However, I think some devices do require being probed
occasionally with a TUR because its the only way SCSI gets AENs (not
that we make much use of them).

So first of all, what's the actual problem?

James
