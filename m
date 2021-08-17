Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E34C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 16:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFC9160FD7
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 16:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhHQQOb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 12:14:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229696AbhHQQOa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 12:14:30 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HG2wq4028886;
        Tue, 17 Aug 2021 12:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=X/57yWrGOG+lUEBowcGHek472Ou+sXnGr4otrQOcev8=;
 b=tejF6c5eV6hYqla3EQPBSLl1fGOJ/bqG35ss8cMY31pR6mGlrOuYOyrP+9I3ylmMvg6X
 /rmF/ntRQp922WKn1qsDuEYZ2Atbot9iCSsRhUQaiYH+O0zzJ7xKw29CIEl1ECZGm7MQ
 pVtY8tFPnpPg4QOsn7YLNoJnS2fGnp8utePytOEyIXW/J6PA2tnLsZLqTJ06fOa4Kj3q
 Z1xbAc8Lv5a2uRuaZslegbhj5936p6yfuYUMU0navp1hqZw+cZ9u0/80YfqbTUBpT2ag
 v9wfJ7o12Btp/p3gkyX5dvtjYYmhrGiKRtYktnTwrSWleLANWMeT4Esjfrmk+nHimpUa nA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agfds9xey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 12:13:45 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17HG8ofM021479;
        Tue, 17 Aug 2021 16:13:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3ae53hcgs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 16:13:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17HGDeJh55902524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 16:13:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6808AE06C;
        Tue, 17 Aug 2021 16:13:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E6F8AE053;
        Tue, 17 Aug 2021 16:13:40 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com (unknown [9.145.34.10])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Aug 2021 16:13:40 +0000 (GMT)
Subject: Re: [PATCH 49/51] scsi: Move eh_device_reset_handler() to use
 scsi_device as argument
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-50-hare@suse.de>
From:   Steffen Maier <maier@linux.ibm.com>
Message-ID: <0a09a529-7e28-1b56-3ca3-7b172956f3a5@linux.ibm.com>
Date:   Tue, 17 Aug 2021 18:13:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210817091456.73342-50-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7QGQCFAf4vBCCW_Q_AYwRtiCqtA8t_8f
X-Proofpoint-ORIG-GUID: 7QGQCFAf4vBCCW_Q_AYwRtiCqtA8t_8f
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_05:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108170099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 11:14 AM, Hannes Reinecke wrote:
> When resetting a device we shouldn't depend on an existing SCSI
> command, as this might be completed at any time.
> Rather we should use 'struct scsi_device' as argument for
> eh_device_reset_handler().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Acked-by: Steffen Maier <maier@linux.ibm.com> # for zfcp

However, independent review comments for common code below...

> ---
>   Documentation/scsi/scsi_eh.rst                |  2 +-
>   Documentation/scsi/scsi_mid_low_api.rst       |  4 +--

>   drivers/s390/scsi/zfcp_scsi.c                 |  4 +--

>   drivers/scsi/scsi_error.c                     | 35 +++++++++++++------

>   include/scsi/scsi_host.h                      |  2 +-
>   62 files changed, 314 insertions(+), 329 deletions(-)
> 
> diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
> index e09c81a54702..23f0d09668d9 100644
> --- a/Documentation/scsi/scsi_eh.rst
> +++ b/Documentation/scsi/scsi_eh.rst
> @@ -214,7 +214,7 @@ considered to fail always.
>   ::
> 
>       int (* eh_abort_handler)(struct scsi_cmnd *);
> -    int (* eh_device_reset_handler)(struct scsi_cmnd *);
> +    int (* eh_device_reset_handler)(struct scsi_device *);
>       int (* eh_target_reset_handler)(struct scsi_target *);
>       int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
>       int (* eh_host_reset_handler)(struct Scsi_Host *);
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 0afc1b4f89af..4650c0c6a22a 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -778,7 +778,7 @@ Details::
> 
>       /**
>       *      eh_device_reset_handler - issue SCSI device reset
> -    *      @scp: identifies SCSI device to be reset
> +    *      @sdev: identifies SCSI device to be reset
>       *
>       *      Returns SUCCESS if command aborted else FAILED
>       *
> @@ -791,7 +791,7 @@ Details::
>       *
>       *      Optionally defined in: LLD
>       **/
> -	int eh_device_reset_handler(struct scsi_cmnd * scp)
> +	int eh_device_reset_handler(struct scsi_device * sdev)
> 
> 
>       /**


> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 6492c3b1b12f..4fa626763bb6 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -333,10 +333,8 @@ static int zfcp_scsi_task_mgmt_function(struct scsi_device *sdev, u8 tm_flags)
>   	return retval;
>   }
> 
> -static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
> +static int zfcp_scsi_eh_device_reset_handler(struct scsi_device *sdev)
>   {
> -	struct scsi_device *sdev = scpnt->device;
> -
>   	return zfcp_scsi_task_mgmt_function(sdev, FCP_TMF_LUN_RESET);
>   }
> 


> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 1d8e2f655833..44e29558b068 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -910,7 +910,7 @@ static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_cmnd *scmd)

> 	struct scsi_host_template *hostt = scmd->device->host->hostt;

>   	if (!hostt->eh_device_reset_handler)
>   		return FAILED;
> 
> -	rtn = hostt->eh_device_reset_handler(scmd);
> +	rtn = hostt->eh_device_reset_handler(scmd->device);
>   	if (rtn == SUCCESS)
>   		__scsi_report_device_reset(scmd->device, NULL);
>   	return rtn;

ok
(now that we use scmd->device 3 times in this function we could introduce a 
local variable sdev, similarly as starget in patch 36; but that would be more 
changed lines)


> @@ -1195,6 +1195,7 @@ scsi_eh_action(struct scsi_cmnd *scmd, enum scsi_disposition rtn)
>    * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.

That old comment seems now in front of the new internal __scsi_eh_finish_cmd 
rathern than scsi_eh_finish_cmd ?

>    * @scmd:	Original SCSI cmd that eh has finished.
>    * @done_q:	Queue for processed commands.
> + * @result:	Final command status to be set

You introduce a 3rd argument named "host_byte" (not "result") below?

>    *
>    * Notes:
>    *    We don't want to use the normal command completion while we are are

>  *    still handling errors - it may cause other commands to be queued,
>  *    and that would disturb what we are doing.  Thus we really want to

> @@ -1203,10 +1204,18 @@ scsi_eh_action(struct scsi_cmnd *scmd, enum scsi_disposition rtn)
>    *    keep a list of pending commands for final completion, and once we
>    *    are ready to leave error handling we handle completion for real.
>    */
> -void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
> +void __scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q,

Should that new internal helper be static?

> +			int host_byte)
>   {
> +	if (host_byte)
> +		set_host_byte(scmd, host_byte);
>   	list_move_tail(&scmd->eh_entry, done_q);
>   }
> +

I whish we still had a kdoc for the actual API function scsi_eh_finish_cmd().

> +void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
> +{
> +	__scsi_eh_finish_cmd(scmd, done_q, 0);
> +}
>   EXPORT_SYMBOL(scsi_eh_finish_cmd);
> 
>   /**
> @@ -1381,7 +1390,8 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
>   				if (finish_cmds &&
>   				    (try_stu ||
>   				     scsi_eh_action(scmd, SUCCESS) == SUCCESS))
> -					scsi_eh_finish_cmd(scmd, done_q);
> +					__scsi_eh_finish_cmd(scmd, done_q,
> +							     DID_RESET);
>   				else
>   					list_move_tail(&scmd->eh_entry, work_q);
>   			}
> @@ -1529,8 +1539,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
>   							 work_q, eh_entry) {
>   					if (scmd->device == sdev &&
>   					    scsi_eh_action(scmd, rtn) != FAILED)
> -						scsi_eh_finish_cmd(scmd,
> -								   done_q);
> +						__scsi_eh_finish_cmd(scmd,
> +								     done_q,
> +								     DID_RESET);
>   				}
>   			}
>   		} else {
> @@ -1598,7 +1609,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
>   			if (rtn == SUCCESS)
>   				list_move_tail(&scmd->eh_entry, &check_list);
>   			else if (rtn == FAST_IO_FAIL)
> -				scsi_eh_finish_cmd(scmd, done_q);
> +				__scsi_eh_finish_cmd(scmd, done_q,
> +						     DID_TRANSPORT_DISRUPTED);
>   			else
>   				/* push back on work queue for further processing */
>   				list_move(&scmd->eh_entry, work_q);
> @@ -1663,8 +1675,9 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
>   			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>   				if (channel == scmd_channel(scmd)) {
>   					if (rtn == FAST_IO_FAIL)
> -						scsi_eh_finish_cmd(scmd,
> -								   done_q);
> +						__scsi_eh_finish_cmd(scmd,
> +								     done_q,
> +								     DID_TRANSPORT_DISRUPTED);
>   					else
>   						list_move_tail(&scmd->eh_entry,
>   							       &check_list);
> @@ -1707,9 +1720,9 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
>   		if (rtn == SUCCESS) {
>   			list_splice_init(work_q, &check_list);
>   		} else if (rtn == FAST_IO_FAIL) {
> -			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
> -					scsi_eh_finish_cmd(scmd, done_q);
> -			}
> +			list_for_each_entry_safe(scmd, next, work_q, eh_entry)
> +				__scsi_eh_finish_cmd(scmd, done_q,
> +						     DID_TRANSPORT_DISRUPTED);
>   		} else {
>   			SCSI_LOG_ERROR_RECOVERY(3,
>   				shost_printk(KERN_INFO, shost,

I don't understand the RESET vs. DISRUPTED depending on escalation level.
Care to explain in the patch description (or even code comment)?
Is there any functional change compared to today and if so which?


> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 8fcced0d98bd..3f016915d87d 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -139,7 +139,7 @@ struct scsi_host_template {
>   	 * Status: REQUIRED	(at least one of them)
>   	 */
>   	int (* eh_abort_handler)(struct scsi_cmnd *);
> -	int (* eh_device_reset_handler)(struct scsi_cmnd *);
> +	int (* eh_device_reset_handler)(struct scsi_device *);
>   	int (* eh_target_reset_handler)(struct scsi_target *);
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
