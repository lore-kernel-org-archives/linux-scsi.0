From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [RFC 4/9] zfcp: decouple FSF request setup of TMF from scsi_cmnd
Date: Fri, 4 Aug 2017 12:33:32 +0200
Message-ID: <078a8205-625b-6030-d6fc-955df930a9aa@linux.vnet.ibm.com>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
 <20170725141427.35258-5-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751290AbdHDKdk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 06:33:40 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v74AWT1q108361
        for <linux-scsi@vger.kernel.org>; Fri, 4 Aug 2017 06:33:40 -0400
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2c4dbwd42w-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 06:33:40 -0400
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Fri, 4 Aug 2017 11:33:36 +0100
In-Reply-To: <20170725141427.35258-5-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc: linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

Just for the records: There's another bug below.

On 07/25/2017 04:14 PM, Steffen Maier wrote:
> The scsi_device argument of zfcp_fc_fcp_tm() can now be NULL.
> 
> In zfcp_fsf_fcp_task_mgmt() resolve the still old argument scsi_cmnd
> into scsi_device very early and only depend on scsi_device and derived
> objects in the function body.
> 
> Scsi_device and derived zfcp_scsi_dev can later be NULL for the
> target reset case, so do not depend on them unconditionally.
> For the generic case, rather change to using zfcp_port directly.
> 
> This prepares to later change the function signature replacing the
> scsi_cmnd argument with zfcp_port and an
> optional scsi_device which can be NULL.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> ---
>   drivers/s390/scsi/zfcp_fc.h  |  6 ++++--
>   drivers/s390/scsi/zfcp_fsf.c | 25 +++++++++++++++++--------
>   2 files changed, 21 insertions(+), 10 deletions(-)

> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index f221a34c26df..2dc7d2a6f6ea 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
> @@ -2339,13 +2339,19 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
>   {
>   	struct zfcp_fsf_req *req = NULL;
>   	struct fcp_cmnd *fcp_cmnd;
> -	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scmnd->device);
> -	struct zfcp_qdio *qdio = zfcp_sdev->port->adapter->qdio;
> +	struct scsi_device *sdev = scmnd->device;
> +	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);

BUG: must not unconditionally dereference sdev which can be NULL later 
on in the patch set!

Fix: +	struct zfcp_scsi_dev *zfcp_sdev = sdev ? sdev_to_zfcp(sdev) : NULL;

Fix is no longer necessary in my reworked v2 (always having a non-NULL 
sdev) to be sent when I successfully completed function test.

> +	struct zfcp_port *port = zfcp_sdev->port;

This line was removed in the subsequent patch 5/9, so here the 
unconditional deref is OK because here in this patch we still get a 
non-NULL sdev. (The line is just argument lifting preparing for the 
function argument replacement in 5/9.)

Other accesses to sdev or zfcp_sdev were properly guarded with this patch.

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
