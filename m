Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5988C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 01:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0FA0206F4
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 01:15:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y0tvtNCG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgGLBP3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 21:15:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57466 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgGLBP2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 21:15:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06C1Ck2B145523;
        Sun, 12 Jul 2020 01:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=g9CdSaCmPNgHXb5GZcaHKEyxIt74/n3tXJ8/0dco1nE=;
 b=Y0tvtNCGeYmAI7b9q3ay5l76jcgPo39mMC5uaAeIp4hDpJOBx6psBkQwd4MUfYZXfO0S
 M6qAJA+mqXV/9T/DGOLdeEXamc6Q59mDTh/GcYOr3gz5hANYzz6FPp1j2E9NFW6XBd3o
 S/yF0mlFCHJJjaGkHhCd/pPbIw4oOfQCEz2Bj102Eh0a3PlUYbgmvPoGSxjW/dSco4ep
 Af1qwIX5HNVxw8tbgFGogwnWzc9qajvFW498M/R7SczT6jMLMcRGPKmFObuzbnI7W26f
 7USfj2FmO+Hd8SQYRtZOZfEjk3ehXtyLNMVB5KPIQlomCf3m557BkO0IDvOze7T8kKoh 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274uqtc45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 12 Jul 2020 01:15:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06C18SvR027013;
        Sun, 12 Jul 2020 01:15:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 327qbtjwwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Jul 2020 01:15:23 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06C1FMVO030560;
        Sun, 12 Jul 2020 01:15:22 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 11 Jul 2020 18:15:22 -0700
Subject: Re: [PATCH 7/8] scsi: target: tcmu: Implement tmr_notify callback
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-8-bstroesser@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <24d9afb0-3ea9-e83b-acf0-b44f04583a6e@oracle.com>
Date:   Sat, 11 Jul 2020 20:15:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200710104817.19462-8-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9679 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007120005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9679 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=2 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007120006
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/10/20 5:48 AM, Bodo Stroesser wrote:
> This patch implements the tmr_notify callback for tcmu.
> When the callback is called, tcmu checks the list of aborted
> commands it received as parameter:
>   - aborted commands in the qfull_queue are removed from
>     the queue and target_complete_command is called
>   - from the cmd_ids of aborted commands currently uncompleted
>     in cmd ring it creates a list of aborted cmd_ids.
> Finally a TMR notification is written to cmd ring containing
> TMR type and cmd_id list. If there is no space in ring, the
> TMR notification is queued on a TMR specific queue.
> 
> The TMR specific queue 'tmr_queue' can be seen as a extension
> of the cmd ring. At the end of each iexecution of
> tcmu_complete_commands() we check, whether tmr_queue contains
> TMRs and try to move them onto the ring. If tmr_queue is not
> empty after that, we don't call run_qfull_queue() because
> commands must not overtake TMRs.
> 
> Operating that way we guarantee that cmd_ids in TMR notification
> received by userspace either match an active, not yet completed
> command or are no longer valid due to userspace having complete
> some cmd_ids meanwhile.
> 
> New commands that were assigned to an aborted cmd_id will always
> appear on the cmd ring _after_ the TMR.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>   drivers/target/target_core_user.c     | 226 ++++++++++++++++++++++++++++++++--
>   include/uapi/linux/target_core_user.h |  25 ++++
>   2 files changed, 242 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 6adf4e7cc00b..e864706de977 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -137,6 +137,7 @@ struct tcmu_dev {
>   
>   	struct mutex cmdr_lock;
>   	struct list_head qfull_queue;
> +	struct list_head tmr_queue;
>   
>   	uint32_t dbi_max;
>   	uint32_t dbi_thresh;
> @@ -183,6 +184,15 @@ struct tcmu_cmd {
>   #define TCMU_CMD_BIT_EXPIRED 0
>   	unsigned long flags;
>   };
> +
> +struct tcmu_tmr {
> +	struct list_head queue_entry;
> +
> +	uint8_t tmr_type;
> +	uint32_t tmr_cmd_cnt;
> +	int16_t tmr_cmd_ids[0];
> +};
> +
>   /*
>    * To avoid dead lock the mutex lock order should always be:
>    *
> @@ -844,6 +854,9 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>   		return false;
>   	}
>   
> +	if (!data_needed)
> +		return true;
> +
>   	/* try to check and get the data blocks as needed */
>   	space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
>   	if ((space * DATA_BLOCK_SIZE) < data_needed) {
> @@ -1106,6 +1119,61 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>   	return 1;
>   }
>   
> +/*

We do 2 stars for this type of comment:

/**

> + * queue_tmr_ring - queue tmr info to ring or internally
> + *

No extra newline.

> + * @dev: related tcmu_dev
> + * @tmr: tcmu_tmr containing tmr info to queue
> + *
> + * Returns:
> + *  0 success
> + *  1 internally queued to wait for ring memory to free.
> + */
> +static int
> +queue_tmr_ring(struct tcmu_dev *dev, struct tcmu_tmr *tmr)
> +{
> +	struct tcmu_tmr_entry *entry;
> +	int cmd_size;
> +	int id_list_sz;
> +	struct tcmu_mailbox *mb = dev->mb_addr;
> +	uint32_t cmd_head;
> +
> +	if (test_bit(TCMU_DEV_BIT_BROKEN, &dev->flags))
> +		goto out_free;
> +
> +	id_list_sz = sizeof(tmr->tmr_cmd_ids[0]) * tmr->tmr_cmd_cnt;
> +	cmd_size = round_up(sizeof(*entry) + id_list_sz, TCMU_OP_ALIGN_SIZE);
> +
> +	if (!list_empty(&dev->tmr_queue) ||
> +	    !is_ring_space_avail(dev, NULL, cmd_size, 0)) {
> +		list_add_tail(&tmr->queue_entry, &dev->tmr_queue);
> +		pr_debug("adding tmr %p on dev %s to TMR ring space wait queue\n",
> +			 tmr, dev->name);
> +		return 1;
> +	}
> +
> +	cmd_head = ring_insert_padding(dev, cmd_size);
> +
> +	entry = (void *)mb + CMDR_OFF + cmd_head;
> +	memset(entry, 0, cmd_size);
> +	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_TMR);
> +	tcmu_hdr_set_len(&entry->hdr.len_op, cmd_size);
> +	entry->tmr_type = tmr->tmr_type;
> +	entry->cmd_cnt = tmr->tmr_cmd_cnt;
> +	memcpy(&entry->cmd_ids[0], &tmr->tmr_cmd_ids[0], id_list_sz);
> +	tcmu_flush_dcache_range(entry, cmd_size);
> +
> +	UPDATE_HEAD(mb->cmd_head, cmd_size, dev->cmdr_size);
> +	tcmu_flush_dcache_range(mb, sizeof(*mb));
> +
> +	uio_event_notify(&dev->uio_info);
> +
> +out_free:
> +	kfree(tmr);
> +
> +	return 0;
> +}
> +
>   static sense_reason_t
>   tcmu_queue_cmd(struct se_cmd *se_cmd)
>   {
> @@ -1141,6 +1209,85 @@ static void tcmu_set_next_deadline(struct list_head *queue,
>   		del_timer(timer);
>   }
>   
> +static int
> +tcmu_tmr_type(enum tcm_tmreq_table tmf)
> +{
> +	switch (tmf) {
> +	case TMR_ABORT_TASK:		return TCMU_TMR_ABORT_TASK;
> +	case TMR_ABORT_TASK_SET:	return TCMU_TMR_ABORT_TASK_SET;
> +	case TMR_CLEAR_ACA:		return TCMU_TMR_CLEAR_ACA;
> +	case TMR_CLEAR_TASK_SET:	return TCMU_TMR_CLEAR_TASK_SET;
> +	case TMR_LUN_RESET:		return TCMU_TMR_LUN_RESET;
> +	case TMR_TARGET_WARM_RESET:	return TCMU_TMR_TARGET_WARM_RESET;
> +	case TMR_TARGET_COLD_RESET:	return TCMU_TMR_TARGET_COLD_RESET;
> +	case TMR_LUN_RESET_PRO:		return TCMU_TMR_LUN_RESET_PRO;
> +	default:			return TCMU_TMR_UNKNOWN;
> +	}
> +}
> +
> +static void
> +tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
> +		struct list_head *cmd_list)
> +{
> +	int i = 0, cmd_cnt = 0;
> +	bool unqueued = false;
> +	uint16_t *cmd_ids = NULL;
> +	struct tcmu_cmd *cmd;
> +	struct se_cmd *se_cmd;
> +	struct tcmu_tmr *tmr;
> +	struct tcmu_dev *dev = TCMU_DEV(se_dev);
> +
> +	mutex_lock(&dev->cmdr_lock);
> +
> +	// First we check for aborted commands in qfull_queue

I know the coding style doc does not say to never use // anymore, but 
just use the same style we have already in the rest of the code for 
single line comments:

/* comment */


>   
> +struct tcmu_tmr_entry {
> +	struct tcmu_cmd_entry_hdr hdr;
> +
> +#define TCMU_TMR_UNKNOWN		0
> +#define TCMU_TMR_ABORT_TASK		1
> +#define TCMU_TMR_ABORT_TASK_SET		2
> +#define TCMU_TMR_CLEAR_ACA		3
> +#define TCMU_TMR_CLEAR_TASK_SET		4
> +#define TCMU_TMR_LUN_RESET		5
> +#define TCMU_TMR_TARGET_WARM_RESET	6
> +#define TCMU_TMR_TARGET_COLD_RESET	7
> +/* Pseudo reset due to received PR OUT */
> +#define TCMU_TMR_LUN_RESET_PRO		128
> +	__u8 tmr_type;
> +
> +	__u8 __pad1;
> +	__u16 __pad2;
> +	__u32 cmd_cnt;
> +	__u64 __pad3;
> +	__u64 __pad4;
> +	__u16 cmd_ids[0];
> +} __packed;
> +

Is this new request and the tmr_notify callback just supposed to clean 
up the requested commands or is it supposed to perform the actions of 
the task management function defined in the specs?

The callback name makes it feel like it's just a notification, but the 
names above make it seem like we are supposed to execute the TMF in 
userspace. But if the latter, then how do we notify the kernel if the 
TMF was successful or failed?
