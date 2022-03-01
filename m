Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C27C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 07:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiCAHfs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 02:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbiCAHfp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 02:35:45 -0500
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0413C7E090;
        Mon, 28 Feb 2022 23:35:04 -0800 (PST)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id 806258A0435;
        Tue,  1 Mar 2022 15:35:02 +0800 (CST)
Message-ID: <a9ce2a8d-1d63-b887-42bd-8e7137c2a877@easystack.cn>
Date:   Tue, 1 Mar 2022 15:35:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] target: add iscsi/cpus_allowed_list in configfs
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     zoumingzhe@qq.com
References: <20220125083821.18225-1-mingzhe.zou@easystack.cn>
 <20220217074511.9696-1-mingzhe.zou@easystack.cn>
 <2f65d5dd-f2d8-3279-5a71-691614e65ae0@oracle.com>
From:   Zou Mingzhe <mingzhe.zou@easystack.cn>
In-Reply-To: <2f65d5dd-f2d8-3279-5a71-691614e65ae0@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRoaGEtWHR5PGRgfShoaQ0
        lLVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktITk9VS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pwg6NAw5KjI4TkgIKQwiTRMP
        KiEwFDFVSlVKTU9NSklLSktJQkJKVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTE9CTTcG
X-HM-Tid: 0a7f44676b5a841dkuqw806258a0435
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


在 2022/3/1 01:58, Mike Christie 写道:
> On 2/17/22 1:45 AM, mingzhe.zou@easystack.cn wrote:
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
>>   drivers/target/iscsi/iscsi_target.c          | 66 +++++++++++++++++++-
>>   drivers/target/iscsi/iscsi_target_configfs.c | 32 ++++++++++
>>   drivers/target/iscsi/iscsi_target_login.c    |  8 +++
>>   include/target/iscsi/iscsi_target_core.h     | 31 ++-------
>>   4 files changed, 109 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index 2c54c5d8412d..82f54b59996d 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -702,13 +702,19 @@ static int __init iscsi_target_init_module(void)
>>   	if (!iscsit_global->ts_bitmap)
>>   		goto configfs_out;
>>   
>> +	if (!zalloc_cpumask_var(&iscsit_global->allowed_cpumask, GFP_KERNEL)) {
>> +		pr_err("Unable to allocate iscsit_global->allowed_cpumask\n");
>> +		goto bitmap_out;
>> +	}
>> +	cpumask_setall(iscsit_global->allowed_cpumask);
>> +
>>   	lio_qr_cache = kmem_cache_create("lio_qr_cache",
>>   			sizeof(struct iscsi_queue_req),
>>   			__alignof__(struct iscsi_queue_req), 0, NULL);
>>   	if (!lio_qr_cache) {
>>   		pr_err("Unable to kmem_cache_create() for"
>>   				" lio_qr_cache\n");
>> -		goto bitmap_out;
>> +		goto cpumask_out;
>>   	}
>>   
>>   	lio_dr_cache = kmem_cache_create("lio_dr_cache",
>> @@ -753,6 +759,8 @@ static int __init iscsi_target_init_module(void)
>>   	kmem_cache_destroy(lio_dr_cache);
>>   qr_out:
>>   	kmem_cache_destroy(lio_qr_cache);
>> +cpumask_out:
>> +	free_cpumask_var(iscsit_global->allowed_cpumask);
>>   bitmap_out:
>>   	vfree(iscsit_global->ts_bitmap);
>>   configfs_out:
>> @@ -782,6 +790,7 @@ static void __exit iscsi_target_cleanup_module(void)
>>   
>>   	target_unregister_template(&iscsi_ops);
>>   
>> +	free_cpumask_var(iscsit_global->allowed_cpumask);
>>   	vfree(iscsit_global->ts_bitmap);
>>   	kfree(iscsit_global);
>>   }
>> @@ -3587,6 +3596,11 @@ static int iscsit_send_reject(
>>   void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>>   {
>>   	int ord, cpu;
>> +	cpumask_t conn_allowed_cpumask;
>> +
>> +	cpumask_and(&conn_allowed_cpumask, iscsit_global->allowed_cpumask,
>> +		    cpu_online_mask);
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
>> @@ -3609,6 +3624,51 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>>   	cpumask_setall(conn->conn_cpumask);
>>   }
>>   
>> +static void iscsit_thread_reschedule(struct iscsi_conn *conn)
>> +{
>> +	/*
>> +	 * If iscsit_global->allowed_cpumask modified, reschedule iSCSI
>> +	 * connection's RX/TX threads update conn->allowed_cpumask.
>> +	 */
>> +	if (!cpumask_equal(iscsit_global->allowed_cpumask,
>> +			   conn->allowed_cpumask)) {
>> +		iscsit_thread_get_cpumask(conn);
>> +		conn->conn_tx_reset_cpumask = 1;
>> +		conn->conn_rx_reset_cpumask = 1;
>> +		cpumask_copy(conn->allowed_cpumask,
>> +			     iscsit_global->allowed_cpumask);
>> +	}
>> +}
>> +
>> +void iscsit_thread_check_cpumask(
>> +	struct iscsi_conn *conn,
>> +	struct task_struct *p,
>> +	int mode)
>> +{
>> +	iscsit_thread_reschedule(conn);
>> +
>> +	/*
>> +	 * mode == 1 signals iscsi_target_tx_thread() usage.
>> +	 * mode == 0 signals iscsi_target_rx_thread() usage.
>> +	 */
>> +	if (mode == 1) {
>> +		if (!conn->conn_tx_reset_cpumask)
>> +			return;
>> +		conn->conn_tx_reset_cpumask = 0;
>> +	} else {
>> +		if (!conn->conn_rx_reset_cpumask)
>> +			return;
>> +		conn->conn_rx_reset_cpumask = 0;
>> +	}
>> +	/*
>> +	 * Update the CPU mask for this single kthread so that
>> +	 * both TX and RX kthreads are scheduled to run on the
>> +	 * same CPU.
>> +	 */
>> +	set_cpus_allowed_ptr(p, conn->conn_cpumask);
>> +}
> We can hit a race where we call this twice for the same CPU right?
Yes, it should be safe to call twice set_cpus_allowed_ptr() with the 
same CPU for the same task.
>
> The rx and tx thread both call iscsit_thread_reschedule and cpumask_equal
> and it returns false for them. The rx thread might be faster and return
> from iscsit_thread_reschedule and is setting conn_rx_reset_cpumask to 0.
> Then the tx thread is sets it back to 1. The next time the rx thread loops
> it sees conn_rx_reset_cpumask set to 1 and calls set_cpus_allowed_ptr.

You are right. But we can call set_cpus_allowed_ptr() first, then set 
conn_rx_reset_cpumask to 1.

This will reduce such problems. I will modify it in v3.

>
> Is that the only possible race? If so it seems ok. Maybe just add a comment,
> so later when someone else is looking at the code they don't waste time
> and think it's broken and know it was intentional or at least we didn't care.
OK. I will add a comment in v3.
>
