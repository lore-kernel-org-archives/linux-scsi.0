Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6B62DC32C
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 09:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787304756; cv=none; b=CfqCStT2/GyEjHHxbjP1lkqroKcKIECjM+FmO02ph5cf9Leo6PoKLRFXESkh4UwyJJ2PwZ0Bc0X8Rb69Eli0JT3VJsDatlmy5W0EQ6pcrUdhVxe2Z7m8ZxfiMjIE6lEl+6JTlDGne4pD45O/HnSm7Vglmz4WS1eb7X6HLsEV3vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787304756; c=relaxed/simple;
	bh=e/JyF43nrqavF+lLQe/bTDPM4997fqJm4Cu9uB/n3KY=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=s917X93HxidWec5HtsebbEDz5/LdgxKhIPnUrOtWgCAciqMbZLDzDiCepXM9sJx54nZ7Ne/RTq8WXjHcYEVA95yfOUItvvUrDvpg3Nf0A4+lIODIcsAsWYoEkHqA6O3jSLYgmGa4Z8nK2ae9uh4vWVag72QpNdDJvm1tfJtU7OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Bp4oJirR; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Bp4oJirR"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Bbe11uCihv9GTB874+m++IYl3uZ8KyNiyzn3g+IC9OA=;
	b=Bp4oJirRjx58otDTUv1iyttl+Yk3lZYWzt9yYY3Lepmw7TW8xmvreNU7Z0thCC0cQjU5ontYt
	sDrB8CUq4LlArPSjBY/9mpbq00/k8TXD8MbifMzrxpBp8Fpy0mZu5MYOOqWqwv3ymIZnIIZp/Np
	Hyh9O0SCo2VuR0yT1hVTN7s=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hRFDd0Y8qz1prQt;
	Fri, 21 Aug 2026 17:21:37 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A7A640537;
	Fri, 21 Aug 2026 17:32:21 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 21 Aug 2026 17:32:21 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 21 Aug 2026 17:32:20 +0800
Subject: Re: [PATCH] scsi: iscsi: fix NULL pointer dereference in
 iscsi_sw_tcp_release_conn()
To: <sashiko-reviews@lists.linux.dev>, Ye Bin <yebin@huaweicloud.com>
References: <20260820020321.1537641-1-yebin@huaweicloud.com>
 <20260820022614.CAEDD1F000E9@smtp.kernel.org>
CC: <linux-scsi@vger.kernel.org>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <6A881B1B.9010306@huawei.com>
Date: Fri, 21 Aug 2026 17:32:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260820022614.CAEDD1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500016.china.huawei.com (7.202.194.202)



On 2026/8/20 10:26, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>
> Pre-existing issues:
> - [High] Use-after-free of `iscsi_cls_conn` due to missing cancellation of `cleanup_work` on release.
> --
>
> --- Patch [1]: [PATCH] scsi: iscsi: fix NULL pointer dereference in iscsi_sw_tcp_release_conn() ---
> commit bdfb05c9a6c008e559f81d0c3e5ffb712699e0cc
> Author: Ye Bin <yebin10@huawei.com>
>
> scsi: iscsi: fix NULL pointer dereference in iscsi_sw_tcp_release_conn()
>
> This commit fixes a NULL pointer dereference by setting the
> ISCSI_CLS_CONN_BIT_CLEANUP bit when userspace delivers STOP_CONN_TERM.
> This prevents concurrent execution of iscsi_stop_conn() and cancels or
> flushes the kernel connection cleanup work as needed.
>
> Fixes: 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
>
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -2266,6 +2266,8 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
>>
>>   static int iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
>>   {
>> +	bool cleanup;
>> +
>>   	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
>>   	/*
>>   	 * For offload, iscsid may not know about the ep like when iscsid is
> [ ... ]
>> -	if (flag == STOP_CONN_TERM) {
>> -		cancel_work_sync(&conn->cleanup_work);
>> -		iscsi_stop_conn(conn, flag);
>> -	} else {
>> +	spin_lock_irq(&conn->lock);
>> +	cleanup = test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
>> +	spin_unlock_irq(&conn->lock);
>> +
>> +	if (cleanup) {
>>   		/*
>> -		 * Figure out if it was the kernel or userspace initiating this.
>> +		 * If this is a termination we have to call stop_conn with
>> +		 * that flag so the correct states get set. If we haven't
>> +		 * run the work yet try to avoid the extra run.
>>   		 */
>> -		spin_lock_irq(&conn->lock);
>> -		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
>> -			spin_unlock_irq(&conn->lock);
>> +		if (flag == STOP_CONN_TERM) {
>> +			ISCSI_DBG_TRANS_CONN(conn,
>> +					"cancel kernel conn cleanup.\n");
>> +			cancel_work_sync(&conn->cleanup_work);
>
> [Severity: High]
> This is a pre-existing issue, but since we are modifying cleanup_work
> handling here, is there a risk of a use-after-free if the connection is
> destroyed before the work executes?
>
> Looking at iscsi_conn_error_event(), it queues conn->cleanup_work without
> taking a reference to the connection. If a session is torn down before the
> work executes (e.g. via device removal calling iscsi_remove_session()),
> iscsi_iter_destroy_conn_fn() drops the references:
>
Indeed, this issue does exist, although it is unrelated to this revision.
I will fix this issue and send another version.

> drivers/scsi/scsi_transport_iscsi.c:iscsi_iter_destroy_conn_fn()
>      ...
>      iscsi_remove_conn(iscsi_dev_to_conn(dev));
>      iscsi_put_conn(iscsi_dev_to_conn(dev));
>
> This final reference drop triggers iscsi_conn_release(), which frees the
> connection memory:
>
> drivers/scsi/scsi_transport_iscsi.c:iscsi_conn_release()
>      ...
>      kfree(conn);
>
> Since iscsi_conn_release() does not call cancel_work_sync(&conn->cleanup_work),
> could iscsi_cleanup_conn_work_fn() execute and dereference the already freed
> conn struct? Should we be cancelling or flushing the work during
> iscsi_conn_release() to prevent this?
>
>>   			iscsi_stop_conn(conn, flag);
>>   		} else {
>> -			spin_unlock_irq(&conn->lock);
>>   			ISCSI_DBG_TRANS_CONN(conn,
>> -					     "flush kernel conn cleanup.\n");
>> +					"flush kernel conn cleanup.\n");
>>   			flush_work(&conn->cleanup_work);
>>   		}
>
