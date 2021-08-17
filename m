Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC80BC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 15:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4D7861029
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 15:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbhHQPza (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 11:55:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240626AbhHQPyi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 11:54:38 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HFkZJ9141203;
        Tue, 17 Aug 2021 11:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=lmXDfuJ5kck9vTBIqd3sPvjF+WXxYu14sjKvaXOuf0U=;
 b=dO7fYIWFSoi/JCKr1ysoJXJ/d7Vl3BQfRwYc/BHB+idbsRQJKWF8EqooUfFTiJRFq9HT
 ZM4HylmNJur3p7B8QZIYIOnv56tu621Tn3xxqJYRuF5a1waVearaGHav0Zd6ArmBbgyy
 QBo82cdg2mN4kDDIM+3Im/Vzp8JEetL0GsmhumGfSLvIBbQ+nv+hm1c+7zyvtKgZ6K1I
 JHKV+Xn+kkEEDfdYQtAb/fnAmS4HYXJQ2ctkxypzv8TzViOgH1dWJXAO3o83UWMmK58T
 vNWHMQJgM9n05ZOOV8NxTxgZebgw9UKDm4KNKCBunydx+cj9GD5wnzifLaRUuGn4F+bf Gg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ag7bs096u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 11:53:53 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17HFrI5q000975;
        Tue, 17 Aug 2021 15:53:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ae53hw5n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 15:53:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17HFoOVC50987390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 15:50:24 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6998DAE051;
        Tue, 17 Aug 2021 15:53:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B130EAE04D;
        Tue, 17 Aug 2021 15:53:48 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com (unknown [9.145.34.10])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Aug 2021 15:53:48 +0000 (GMT)
Subject: Re: [PATCH 36/51] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-37-hare@suse.de>
From:   Steffen Maier <maier@linux.ibm.com>
Message-ID: <b5aa4bb3-628e-e05f-448b-a5e1ecae66e2@linux.ibm.com>
Date:   Tue, 17 Aug 2021 17:53:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210817091456.73342-37-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SIGmCo3kILwTvhCRbAv7m3DM2SsHKfaM
X-Proofpoint-GUID: SIGmCo3kILwTvhCRbAv7m3DM2SsHKfaM
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_05:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 adultscore=0 mlxscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108170095
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 11:14 AM, Hannes Reinecke wrote:
> The target reset function should only depend on the scsi target,
> not the scsi command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com> > ---
>   Documentation/scsi/scsi_eh.rst              | 10 ++++
>   Documentation/scsi/scsi_mid_low_api.rst     | 18 +++++++

>   drivers/s390/scsi/zfcp_scsi.c               |  7 ++-

>   drivers/scsi/scsi_error.c                   |  5 +-

>   include/scsi/scsi_host.h                    |  2 +-
>   34 files changed, 226 insertions(+), 192 deletions(-)
> 
> diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
> index cf0649e0c3a9..e09c81a54702 100644
> --- a/Documentation/scsi/scsi_eh.rst
> +++ b/Documentation/scsi/scsi_eh.rst
> @@ -215,6 +215,7 @@ considered to fail always.
> 
>       int (* eh_abort_handler)(struct scsi_cmnd *);
>       int (* eh_device_reset_handler)(struct scsi_cmnd *);
> +    int (* eh_target_reset_handler)(struct scsi_target *);
>       int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
>       int (* eh_host_reset_handler)(struct Scsi_Host *);
> 
> @@ -410,6 +411,15 @@ scmd->allowed.

> 	2. If !list_empty(&eh_work_q), invoke scsi_eh_bus_device_reset().
> 
> 	``scsi_eh_bus_device_reset``
> 
> 	    This action is very similar to scsi_eh_stu() except that,
> 	    instead of issuing STU, hostt->eh_device_reset_handler()
> 	    is used.  Also, as we're not issuing SCSI commands and

>   	    resetting clears all scmds on the sdev, there is no need
>   	    to choose error-completed scmds.
> 
> +	2. If !list_empty(&eh_work_q), invoke scsi_eh_target_reset().

I think we have item 2 twice now, as this is preded by BDR as step 2.
Should target reset be the newly inserted step 3 and subsequent ones be 
incremented by 1?

> +
> +	``scsi_eh_target_reset``
> +
> +	    hostt->eh_target_reset_handler() is invoked for each target
> +	    with failed scmds.  If bus reset succeeds, all failed

bus reset => target reset

(I reckon you copy&pasted from scsi_eh_bus_reset ;-))

> +	    scmds on all ready or offline sdevs on the target are
> +	    EH-finished.
> +
>   	3. If !list_empty(&eh_work_q), invoke scsi_eh_bus_reset()
> 
>   	``scsi_eh_bus_reset``

> 
> 	    hostt->eh_bus_reset_handler() is invoked for each channel
> 	    with failed scmds.  If bus reset succeeds, all failed
> 	    scmds on all ready or offline sdevs on the channel are
> 	    EH-finished.
> 
> 	4. If !list_empty(&eh_work_q), invoke scsi_eh_host_reset()
> 
> 	``scsi_eh_host_reset``
> 
> 	    This is the last resort.  hostt->eh_host_reset_handler()
> 	    is invoked.  If host reset succeeds, all failed scmds on
> 	    all ready or offline sdevs on the host are EH-finished.
> 
> 	5. If !list_empty(&eh_work_q), invoke scsi_eh_offline_sdevs()
> 
> 	``scsi_eh_offline_sdevs``
> 
> 	    Take all sdevs which still have unrecovered scmds offline
> 	    and EH-finish the scmds.


> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 1b1c37445580..0afc1b4f89af 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst

Missing an entry in the Summary section preceding the Details?:

> Summary:
> 
>   - bios_param - fetch head, sector, cylinder info for a disk
>   - eh_timed_out - notify the host that a command timer expired
>   - eh_abort_handler - abort given command
>   - eh_bus_reset_handler - issue SCSI bus reset
>   - eh_device_reset_handler - issue SCSI device reset
>   - eh_host_reset_handler - reset host (host bus adapter)

+  - eh_target_reset_handler - issue SCSI target reset

> @@ -758,6 +758,24 @@ Details::
>   	int eh_bus_reset_handler(struct Scsi_Host * host, int channel)
> 
> 
> +    /**
> +    *      eh_target_reset_handler - issue SCSI target reset
> +    *      @starget: identifies SCSI target to be reset
> +    *
> +    *      Returns SUCCESS if command aborted else FAILED
> +    *
> +    *      Locks: None held
> +    *
> +    *      Calling context: kernel thread
> +    *
> +    *      Notes: Invoked from scsi_eh thread. No other commands will be
> +    *      queued on current host during eh.
> +    *
> +    *      Optionally defined in: LLD
> +    **/
> +	int eh_target_reset_handler(struct scsi_target * starget)
> +
> +

nit-picky: It looks like this file had the reset_handlers sorted alphabetically 
(rather than semantically in order of eh escalation) both in its sections 
"Summary" and "Details". So the eh_target_reset_handler would go after 
eh_host_reset_handler? (also to match order in Summary)

>       /**
>       *      eh_device_reset_handler - issue SCSI device reset
>       *      @scp: identifies SCSI device to be reset

In fact, the Documentation changes look like a different patch to me, namely 
adding missing information about the target reset escalation step. That seems 
independent of this patch which changes the callback signature.


> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 8bfa8ffd9ff6..6492c3b1b12f 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -340,9 +340,12 @@ static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
>   	return zfcp_scsi_task_mgmt_function(sdev, FCP_TMF_LUN_RESET);
>   }
> 
> -static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)

> +/*
> + * Note: We need to select a LUN as the storage array doesn't
> + * necessarily supports LUN 0 and might refuse the target reset.
> + */

While the storage itself might be another condition, there is the following 
necessary pre-condition about the FCP channel:

v4.18 commit 674595d8519f ("scsi: zfcp: decouple our scsi_eh callbacks from 
scsi_cmnd")
> zfcp_scsi_eh_target_reset_handler() is special: The FCP channel requires a
> valid LUN handle so we try to find ourselves a stand-in scsi_device as
> suggested by Hannes Reinecke. If it cannot find a stand-in scsi device,
> trace a record

(cf. v4.10 commit 6f2ce1c6af37 ("scsi: zfcp: fix rport unblock race with LUN 
recovery") I mentioned in the reply to patch 08/51)

If you think that commit description is insufficient, you could borrow text 
from there for the code comment.

> +static int zfcp_scsi_eh_target_reset_handler(struct scsi_target *starget)
>   {
> -	struct scsi_target *starget = scsi_target(scpnt->device);
>   	struct fc_rport *rport = starget_to_rport(starget);
>   	struct Scsi_Host *shost = rport_to_shost(rport);
>   	struct scsi_device *sdev = NULL, *tmp_sdev;

The code change looks good.


> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index d5e36488c87b..1d8e2f655833 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -876,14 +876,15 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
>   	enum scsi_disposition rtn;
>   	struct Scsi_Host *host = scmd->device->host;
>   	struct scsi_host_template *hostt = host->hostt;
> +	struct scsi_target *starget = scsi_target(scmd->device);
> 
>   	if (!hostt->eh_target_reset_handler)
>   		return FAILED;
> 
> -	rtn = hostt->eh_target_reset_handler(scmd);
> +	rtn = hostt->eh_target_reset_handler(starget);
>   	if (rtn == SUCCESS) {
>   		spin_lock_irqsave(host->host_lock, flags);
> -		__starget_for_each_device(scsi_target(scmd->device), NULL,
> +		__starget_for_each_device(starget, NULL,
>   					  __scsi_report_device_reset);
>   		spin_unlock_irqrestore(host->host_lock, flags);
>   	}

> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index e0a102339317..8fcced0d98bd 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -140,7 +140,7 @@ struct scsi_host_template {
>   	 */
>   	int (* eh_abort_handler)(struct scsi_cmnd *);
>   	int (* eh_device_reset_handler)(struct scsi_cmnd *);
> -	int (* eh_target_reset_handler)(struct scsi_cmnd *);
> +	int (* eh_target_reset_handler)(struct scsi_target *);
>   	int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
>   	int (* eh_host_reset_handler)(struct Scsi_Host *);
> 


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
