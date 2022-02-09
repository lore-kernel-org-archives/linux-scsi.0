Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E38C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 12:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiBIMBZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 07:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiBIMBG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 07:01:06 -0500
X-Greylist: delayed 335 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 03:53:54 PST
Received: from mail-m2836.qiye.163.com (mail-m2836.qiye.163.com [103.74.28.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9233FDF4989B;
        Wed,  9 Feb 2022 03:53:54 -0800 (PST)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id 3D41FC0433;
        Wed,  9 Feb 2022 19:48:17 +0800 (CST)
Subject: Re: [PATCH] target: add iscsi/cpus_allowed_list in configfs
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20220125083821.18225-1-mingzhe.zou@easystack.cn>
 <7234209a-d308-622b-700e-e72907246ff4@oracle.com>
From:   Zou Mingzhe <mingzhe.zou@easystack.cn>
Message-ID: <7ff3a449-980e-ab44-42cf-7520a0796483@easystack.cn>
Date:   Wed, 9 Feb 2022 19:48:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7234209a-d308-622b-700e-e72907246ff4@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRlKSUlWQkhDTUwYGkkfQ0
        lLVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBQ6Phw6HDI2GRYXMT0dL0o2
        QxNPC1ZVSlVKTU9PT0tMSUJMTUlMVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSkpOS0s3Bg++
X-HM-Tid: 0a7ede50156d841ekuqw3d41fc0433
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


在 2022/2/9 上午1:50, Mike Christie 写道:
> On 1/25/22 2:38 AM, mingzhe.zou@easystack.cn wrote:
>> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>
>> The RX/TX threads for iSCSI connection can be scheduled to
>> any online cpus, and will not be rescheduled.
>>
>> If bind other heavy load threads with iSCSI connection
>> RX/TX thread to the same cpu, the iSCSI performance will
>> be worse.
>>
>> This patch add iscsi/cpus_allowed_list in configfs. The
>> available cpus set of iSCSI connection RX/TX threads is
>> allowed_cpus & online_cpus. If it is modified, all RX/TX
>> threads will be rescheduled.
>>
>> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
>> ---
>>   drivers/target/iscsi/iscsi_target.c          | 21 ++++++++++--
>>   drivers/target/iscsi/iscsi_target.h          | 17 ++++++++++
>>   drivers/target/iscsi/iscsi_target_configfs.c | 34 ++++++++++++++++++++
>>   drivers/target/iscsi/iscsi_target_login.c    |  7 ++++
>>   include/target/iscsi/iscsi_target_core.h     |  1 +
>>   5 files changed, 78 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index 2c54c5d8412d..a18d3fc3cfd1 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -693,6 +693,11 @@ static int __init iscsi_target_init_module(void)
>>   	mutex_init(&auth_id_lock);
>>   	idr_init(&tiqn_idr);
>>   
>> +	/*
>> +	 * allow all cpus run iscsi_ttx and iscsi_trx
> I would just drop the comment. The "setall" in the function name
> is pretty clear already.
I will remove it.
>
>
>> +	 */
>> +	cpumask_setall(&__iscsi_allowed_cpumask);
>> +
>>   	ret = target_register_template(&iscsi_ops);
>>   	if (ret)
>>   		goto out;
>> @@ -3587,6 +3592,15 @@ static int iscsit_send_reject(
>>   void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>>   {
>>   	int ord, cpu;
>> +	cpumask_t conn_allowed_cpumask;
>> +
>> +	/*
>> +	 * The available cpus set of iSCSI connection's RX/TX threads
>> +	 */
> Probably can drop the comment too since the variable names make it
> known what we are doing.
I will remove it.
>
>
>> +	cpumask_and(&conn_allowed_cpumask,
>> +		&__iscsi_allowed_cpumask,
>> +		cpu_online_mask);
> The formatting needs some fix ups. I think __iscsi_allowed_cpumask can fit on the
> line above it and then cpu_online_mask should be moved over a couple spaces to
> align with the opening "(".

I will reformat.

>
>
>> +
>>   	/*
>>   	 * bitmap_id is assigned from iscsit_global->ts_bitmap from
>>   	 * within iscsit_start_kthreads()
>> @@ -3595,8 +3609,9 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>>   	 * iSCSI connection's RX/TX threads will be scheduled to
>>   	 * execute upon.
>>   	 */
>> -	ord = conn->bitmap_id % cpumask_weight(cpu_online_mask);
>> -	for_each_online_cpu(cpu) {
>> +	cpumask_clear(conn->conn_cpumask);
>> +	ord = conn->bitmap_id % cpumask_weight(&conn_allowed_cpumask);
>> +	for_each_cpu(cpu, &conn_allowed_cpumask) {
>>   		if (ord-- == 0) {
>>   			cpumask_set_cpu(cpu, conn->conn_cpumask);
>>   			return;
>> @@ -3821,6 +3836,7 @@ int iscsi_target_tx_thread(void *arg)
>>   		 * Ensure that both TX and RX per connection kthreads
>>   		 * are scheduled to run on the same CPU.
>>   		 */
>> +		iscsit_thread_reschedule(conn);
>
> If we have multiple sessions to the same portal, could we end up racing
> where session0's tx/rx threads call iscsit_thread_reschedule and
> iscsit_thread_check_cpumask at the same time as session1's threads and
> they end up taking the same cpus. They both could be running
> iscsit_thread_get_cpumask at the same time, see he same masks values
> and in the for_each_cpu loop think the same cpu is free.

Simply, this patch just adds a config item to skip some CPUs that are 
bound to other threads,

not to change the calculation method of cpumask.

When the cpus_allowed_list in sysfs is modified, the tx/rx threads of 
all sessions will clear current

cpumask and call iscsit_thread_reschedule and 
iscsit_thread_check_cpumask to get a new value.

Because each session is allocated a unique bitmap_id in advance, then 
calculate the cpumask

via bitmap_id. So the tx/rx threads of different sessions will be 
scheduled to different CPUs (when

the number of CPUs is sufficient).

>
>
>>   		iscsit_thread_check_cpumask(conn, current, 1);
>>   
>>   		wait_event_interruptible(conn->queues_wq,
>> @@ -3966,6 +3982,7 @@ static void iscsit_get_rx_pdu(struct iscsi_conn *conn)
>>   		 * Ensure that both TX and RX per connection kthreads
>>   		 * are scheduled to run on the same CPU.
>>   		 */
>> +		iscsit_thread_reschedule(conn);
>>   		iscsit_thread_check_cpumask(conn, current, 0);
>>   
>>   		memset(&iov, 0, sizeof(struct kvec));
>> diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
>> index b35a96ded9c1..cb97a316d76d 100644
>> --- a/drivers/target/iscsi/iscsi_target.h
>> +++ b/drivers/target/iscsi/iscsi_target.h
>> @@ -57,4 +57,21 @@ extern struct kmem_cache *lio_r2t_cache;
>>   extern struct ida sess_ida;
>>   extern struct mutex auth_id_lock;
>>   
>> +extern cpumask_t __iscsi_allowed_cpumask;
> I would rename to:
>
> iscsit_allowed_cpumask
>
I will rename to iscsit_allowed_cpumas.
>> +
>> +static inline void iscsit_thread_reschedule(struct iscsi_conn *conn)
>> +{
>> +	/*
>> +	 * If __iscsi_allowed_cpumask modified, reschedule iSCSI connection's
>> +	 * RX/TX threads update conn->allowed_cpumask.
>> +	 */
>> +	if (!cpumask_equal(&__iscsi_allowed_cpumask, conn->allowed_cpumask)) {
>> +		iscsit_thread_get_cpumask(conn);
>> +		conn->conn_tx_reset_cpumask = 1;
>> +		conn->conn_rx_reset_cpumask = 1;
>> +		cpumask_copy(conn->allowed_cpumask,
>> +			&__iscsi_allowed_cpumask);
> Fix up formatting like above.
I will reformat.
>
>> +	}
>> +}
>> +
>>   #endif   /*** ISCSI_TARGET_H ***/
>> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
>> index 2a9de24a8bbe..dc12b1695838 100644
>> --- a/drivers/target/iscsi/iscsi_target_configfs.c
>> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
>> @@ -1127,8 +1127,42 @@ static ssize_t lio_target_wwn_lio_version_show(struct config_item *item,
>>   
>>   CONFIGFS_ATTR_RO(lio_target_wwn_, lio_version);
>>   
>> +cpumask_t __iscsi_allowed_cpumask;
> Maybe better to put this in iscsi_target.c with the other vars like
> it.

Originally I wanted to put it in struct iscsit_global and use it in 
iscsit_thread_check_cpumask.

However iscsit_thread_check_cpumask is also called in cxgbit_target.c. I 
don't know if I also

need to modify cxgbit at the same time, and I only modified two calls in 
iscsi_target.c. I would

like to know how to handle in cxgbit_target.c?

I want to move 'static inline void iscsit_thread_check_cpumask' from 
iscsi_target_core.h to

iscsi_target.c and EXPORT_SYMBOL(iscsit_thread_check_cpumask). Do you 
agree it?

>
>> +
>> +static ssize_t lio_target_wwn_cpus_allowed_list_show(
>> +		struct config_item *item, char *page)
>> +{
>> +	return sprintf(page, "%*pbl\n",
>> +		cpumask_pr_args(&__iscsi_allowed_cpumask));
> Formatting like above.
I will reformat.
>
>> +}
>> +
>> +static ssize_t lio_target_wwn_cpus_allowed_list_store(
>> +		struct config_item *item, const char *page, size_t count)
>> +{
>> +	int ret;
>> +	char *orig;
>> +	cpumask_t new_allowed_cpumask;
>> +
>> +	orig = kstrdup(page, GFP_KERNEL);
>> +	if (!orig)
>> +		return -ENOMEM;
>> +
>> +	cpumask_clear(&new_allowed_cpumask);
>> +	ret = cpulist_parse(orig, &new_allowed_cpumask);
> Are you supposed to do a  before
> using new_allowed_cpumask? It looks like other callers are doing it.

Other callers used cpumask_var_t, but the new_allowed_cpumask is cpumask_t.

I think just call cpumask_clear(&new_allowed_cpumask).


typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;

typedef struct cpumask cpumask_var_t[1];

>
>> +
>> +	kfree(orig);
>> +	if (ret != 0)
>> +		return ret;
>> +
>> +	cpumask_copy(&__iscsi_allowed_cpumask, &new_allowed_cpumask);
>> +	return count;
>> +}
>> +
>> +CONFIGFS_ATTR(lio_target_wwn_, cpus_allowed_list);
>> +
>>   static struct configfs_attribute *lio_target_wwn_attrs[] = {
>>   	&lio_target_wwn_attr_lio_version,
>> +	&lio_target_wwn_attr_cpus_allowed_list,
>>   	NULL,
>>   };
>>   
>> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
>> index 1a9c50401bdb..910f35e4648a 100644
>> --- a/drivers/target/iscsi/iscsi_target_login.c
>> +++ b/drivers/target/iscsi/iscsi_target_login.c
>> @@ -1129,8 +1129,15 @@ static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
>>   		goto free_conn_ops;
>>   	}
>>   
>> +	if (!zalloc_cpumask_var(&conn->allowed_cpumask, GFP_KERNEL)) {
>> +		pr_err("Unable to allocate conn->allowed_cpumask\n");
>> +		goto free_conn_cpumask;
>> +	}
> I think in iscsit_free_conn you need a:
>
> free_cpumask_var(conn->allowed_cpumask);
>
> to go with this allocation.
This is bug. I will fix up in v2.
>
>> +
>>   	return conn;
>>   
>> +free_conn_cpumask:
>> +	free_cpumask_var(conn->allowed_cpumask);
> I think you wanted conn->conn_cpumask here.
This is bug. I will fix up in v2.
>>   free_conn_ops:
>>   	kfree(conn->conn_ops);
>>   put_transport:
>> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
>> index 1eccb2ac7d02..c5e9cad187cf 100644
>> --- a/include/target/iscsi/iscsi_target_core.h
>> +++ b/include/target/iscsi/iscsi_target_core.h
>> @@ -580,6 +580,7 @@ struct iscsi_conn {
>>   	struct ahash_request	*conn_tx_hash;
>>   	/* Used for scheduling TX and RX connection kthreads */
>>   	cpumask_var_t		conn_cpumask;
>> +	cpumask_var_t		allowed_cpumask;
>>   	unsigned int		conn_rx_reset_cpumask:1;
>>   	unsigned int		conn_tx_reset_cpumask:1;
>>   	/* list_head of struct iscsi_cmd for this connection */
>
