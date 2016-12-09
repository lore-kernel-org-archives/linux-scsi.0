From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] scsi: avoid a permanent stop of the scsi device's
 request queue
Date: Fri, 09 Dec 2016 07:24:52 -0800
Message-ID: <1481297092.2403.2.camel@linux.vnet.ibm.com>
References: <1481276138-570-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60051 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933206AbcLIPZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2016 10:25:02 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB9FMEFm078204
        for <linux-scsi@vger.kernel.org>; Fri, 9 Dec 2016 10:24:59 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 277wcj71h5-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 09 Dec 2016 10:24:59 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Fri, 9 Dec 2016 08:24:58 -0700
In-Reply-To: <1481276138-570-1-git-send-email-fangwei1@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com, emilne@redhat.com

On Fri, 2016-12-09 at 17:35 +0800, Wei Fang wrote:
	
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 8990e58..5c53cf5 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -31,7 +31,7 @@ struct scsi_mode_data {
>  enum scsi_device_state {
>  	SDEV_CREATED = 1,	/* device created but not added to
> sysfs
>  				 * Only internal commands allowed
> (for inq) */
> -	SDEV_RUNNING,		/* device properly configured
> +	SDEV_RUNNING,		/* device properly initialized
>  				 * All commands allowed */
>  	SDEV_CANCEL,		/* beginning to delete device
>  				 * Only error handler commands
> allowed */

This hunk is still pointless.  What even is the difference between
initialized and configured to someone reading the comments?

The reason for not having pointless changes is to make this as clean as
possible for a backport to stable.

James

