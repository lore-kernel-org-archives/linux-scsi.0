Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0979EC43217
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 01:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiCIBOM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 20:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiCIBMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 20:12:49 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED90310D5
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 16:55:17 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KCtsH2ll6zbcBg;
        Wed,  9 Mar 2022 08:50:27 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 08:55:15 +0800
Received: from [10.174.179.189] (10.174.179.189) by
 dggpeml500019.china.huawei.com (7.185.36.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 08:55:15 +0800
Subject: Re: [PATCH 02/12] scsi: iscsi: Rename iscsi_conn_queue_work
To:     Mike Christie <michael.christie@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-3-michael.christie@oracle.com>
From:   Wu Bo <wubo40@huawei.com>
Message-ID: <cb9af0ab-56fd-9bfd-1251-8a55ad7487e7@huawei.com>
Date:   Wed, 9 Mar 2022 08:55:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20220308002747.122682-3-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.189]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/3/8 8:27, Mike Christie wrote:
> Rename iscsi_conn_queue_work to iscsi_conn_queue_xmit to reflect it
> handles queueing of xmits only.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/cxgbi/libcxgbi.c |  2 +-
>   drivers/scsi/iscsi_tcp.c      |  2 +-
>   drivers/scsi/libiscsi.c       | 12 ++++++------
>   include/scsi/libiscsi.h       |  2 +-
>   4 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index 4365d52c6430..411b0d386fad 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -1455,7 +1455,7 @@ void cxgbi_conn_tx_open(struct cxgbi_sock *csk)
>   	if (conn) {
>   		log_debug(1 << CXGBI_DBG_SOCK,
>   			"csk 0x%p, cid %d.\n", csk, conn->id);
> -		iscsi_conn_queue_work(conn);
> +		iscsi_conn_queue_xmit(conn);
>   	}
>   }
>   EXPORT_SYMBOL_GPL(cxgbi_conn_tx_open);
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 1bc37593c88f..f274a86d2ec0 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -205,7 +205,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
>   	old_write_space(sk);
>   
>   	ISCSI_SW_TCP_DBG(conn, "iscsi_write_space\n");
> -	iscsi_conn_queue_work(conn);
> +	iscsi_conn_queue_xmit(conn);
>   }
>   
>   static void iscsi_sw_tcp_conn_set_callbacks(struct iscsi_conn *conn)
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 14f5737429cf..fa44445dc75f 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -83,7 +83,7 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
>   				"%s " dbg_fmt, __func__, ##arg);	\
>   	} while (0);
>   
> -inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
> +inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
>   {
>   	struct Scsi_Host *shost = conn->session->host;
>   	struct iscsi_host *ihost = shost_priv(shost);
> @@ -91,7 +91,7 @@ inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
>   	if (ihost->workq)
>   		queue_work(ihost->workq, &conn->xmitwork);
>   }
> -EXPORT_SYMBOL_GPL(iscsi_conn_queue_work);
> +EXPORT_SYMBOL_GPL(iscsi_conn_queue_xmit);
>   
>   static void __iscsi_update_cmdsn(struct iscsi_session *session,
>   				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
> @@ -764,7 +764,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>   			goto free_task;
>   	} else {
>   		list_add_tail(&task->running, &conn->mgmtqueue);
> -		iscsi_conn_queue_work(conn);
> +		iscsi_conn_queue_xmit(conn);
>   	}
>   
>   	return task;
> @@ -1512,7 +1512,7 @@ void iscsi_requeue_task(struct iscsi_task *task)
>   		 */
>   		iscsi_put_task(task);
>   	}
> -	iscsi_conn_queue_work(conn);
> +	iscsi_conn_queue_xmit(conn);
>   	spin_unlock_bh(&conn->session->frwd_lock);
>   }
>   EXPORT_SYMBOL_GPL(iscsi_requeue_task);
> @@ -1781,7 +1781,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>   		}
>   	} else {
>   		list_add_tail(&task->running, &conn->cmdqueue);
> -		iscsi_conn_queue_work(conn);
> +		iscsi_conn_queue_xmit(conn);
>   	}
>   
>   	session->queued_cmdsn++;
> @@ -1962,7 +1962,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
>   static void iscsi_start_tx(struct iscsi_conn *conn)
>   {
>   	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
> -	iscsi_conn_queue_work(conn);
> +	iscsi_conn_queue_xmit(conn);
>   }
>   
>   /*
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 10a9b89b7448..b567ea4700e5 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -441,7 +441,7 @@ extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
>   				     enum iscsi_param param, char *buf);
>   extern void iscsi_suspend_tx(struct iscsi_conn *conn);
>   extern void iscsi_suspend_queue(struct iscsi_conn *conn);
> -extern void iscsi_conn_queue_work(struct iscsi_conn *conn);
> +extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
>   
>   #define iscsi_conn_printk(prefix, _c, fmt, a...) \
>   	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
> 

Reviewed-by: Wu Bo <wubo40@huawei.com>

.
