Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB680CDB46E
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Oct 2023 07:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343700AbjJLHsU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Oct 2023 03:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343626AbjJLHsU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2023 03:48:20 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E0190
        for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2023 00:48:18 -0700 (PDT)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4S5hTN5L37zvQ12;
        Thu, 12 Oct 2023 15:43:36 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 12 Oct 2023 15:48:12 +0800
Message-ID: <12f27bee-eb09-b51c-a844-45d6397e06f1@huawei.com>
Date:   Thu, 12 Oct 2023 15:48:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 7/7] scsi_error: streamline scsi_eh_bus_device_reset()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-8-hare@suse.de>
From:   Wenchao Hao <haowenchao2@huawei.com>
In-Reply-To: <20231002155915.109359-8-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/10/2 23:59, Hannes Reinecke wrote:
> Streamline to use a similar code flow as the other reset functions.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/scsi_error.c | 26 +++++++++++---------------
>   1 file changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 21d84940c9cb..81b38f5da3b6 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1581,6 +1581,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
>   {
>   	struct scsi_cmnd *scmd, *bdr_scmd, *next;
>   	struct scsi_device *sdev;
> +	LIST_HEAD(check_list);
>   	enum scsi_disposition rtn;
>   
>   	shost_for_each_device(sdev, shost) {
> @@ -1606,27 +1607,22 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
>   			sdev_printk(KERN_INFO, sdev,
>   				     "%s: Sending BDR\n", current->comm));
>   		rtn = scsi_try_bus_device_reset(sdev);
> -		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
> -			if (!scsi_device_online(sdev) ||
> -			    rtn == FAST_IO_FAIL ||
> -			    !scsi_eh_tur(bdr_scmd)) {
> -				list_for_each_entry_safe(scmd, next,
> -							 work_q, eh_entry) {
> -					if (scmd->device == sdev &&
> -					    scsi_eh_action(scmd, rtn) != FAILED)
> -						__scsi_eh_finish_cmd(scmd,
> -								     done_q,
> -								     DID_RESET);
> -				}
> -			}
> -		} else {
> +		if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
>   			SCSI_LOG_ERROR_RECOVERY(3,
>   				sdev_printk(KERN_INFO, sdev,
>   					    "%s: BDR failed\n", current->comm));
> +		list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
> +			if (scmd->device != sdev)
> +				continue;
> +			if (rtn == SUCCESS)
> +				list_move_tail(&scmd->eh_entry, &check_list);
> +			else if (rtn == FAST_IO_FAIL)
> +				__scsi_eh_finish_cmd(scmd, done_q,
> +						     DID_TRANSPORT_DISRUPTED);
>   		}
>   	}
>   
> -	return list_empty(work_q);
> +	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
>   }
>   
>   /**

I think the bdr_scmd related lines should also be removed like following:

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 81b38f5da3b6..e3b0ac270dd9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1579,7 +1579,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
                                     struct list_head *work_q,
                                     struct list_head *done_q)
  {
-       struct scsi_cmnd *scmd, *bdr_scmd, *next;
+       struct scsi_cmnd *scmd, *next;
         struct scsi_device *sdev;
         LIST_HEAD(check_list);
         enum scsi_disposition rtn;
@@ -1593,15 +1593,6 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
                         scsi_device_put(sdev);
                         break;
                 }
-               bdr_scmd = NULL;
-               list_for_each_entry(scmd, work_q, eh_entry)
-                       if (scmd->device == sdev) {
-                               bdr_scmd = scmd;
-                               break;
-                       }
-
-               if (!bdr_scmd)
-                       continue;
  
                 SCSI_LOG_ERROR_RECOVERY(3,
                         sdev_printk(KERN_INFO, sdev,




