Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3566C25B08
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Aug 2022 08:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344646AbiHTIfq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Aug 2022 04:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344673AbiHTIfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Aug 2022 04:35:36 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E685BABD5D
        for <linux-scsi@vger.kernel.org>; Sat, 20 Aug 2022 01:35:34 -0700 (PDT)
Received: from canpemm500008.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M8sLc3lQ9zlWL8;
        Sat, 20 Aug 2022 16:32:24 +0800 (CST)
Received: from [10.174.179.2] (10.174.179.2) by canpemm500008.china.huawei.com
 (7.192.105.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 20 Aug
 2022 16:35:32 +0800
Message-ID: <3e7bb57f-320c-2635-42eb-ec6850a69923@huawei.com>
Date:   Sat, 20 Aug 2022 16:35:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.1
Subject: Re: [PATCH] scsi: iscsi_tcp: Fix null-ptr-deref while calling
 getpeername
To:     Mike Christie <michael.christie@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>
References: <20220807165804.8628-1-michael.christie@oracle.com>
From:   Li Jinlin <lijinlin3@huawei.com>
In-Reply-To: <20220807165804.8628-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.2]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500008.china.huawei.com (7.192.105.151)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2022/8/8 0:58, Mike Christie wrote:

> @@ -763,8 +768,15 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
>  		break;
>  	case ISCSI_PARAM_DATADGST_EN:
>  		iscsi_set_param(cls_conn, param, buf, buflen);
> +
> +		mutex_lock(&tcp_sw_conn->sock_lock);
> +		if (!tcp_sw_conn->sock) {
> +			mutex_unlock(&tcp_sw_conn->sock_lock);
> +			return -ENOTCONN;
> +		}
>  		tcp_sw_conn->sendpage = conn->datadgst_en ?
>  			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
> +		mutex_unlock(&tcp_sw_conn->sock_lock);
>  		break;
>  	case ISCSI_PARAM_MAX_R2T:
>  		return iscsi_tcp_set_max_r2t(conn, buf);
> @@ -789,14 +801,12 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
>  	case ISCSI_PARAM_CONN_PORT:
>  	case ISCSI_PARAM_CONN_ADDRESS:
>  	case ISCSI_PARAM_LOCAL_PORT:
> -		spin_lock_bh(&conn->session->frwd_lock);
> -		if (!tcp_sw_conn || !tcp_sw_conn->sock) {
> -			spin_unlock_bh(&conn->session->frwd_lock);
> +		mutex_lock(&tcp_sw_conn->sock_lock);

In iscsi_tcp_conn_setup(), cls_conn was setup before initializing
tcp_sw_conn. So tcp_sw_conn may be NULL in here, need to add a check.

Thanks,
JinLin

> +		sock = tcp_sw_conn->sock;
> +		if (!sock) {
> +			mutex_unlock(&tcp_sw_conn->sock_lock);
>  			return -ENOTCONN;
>  		}
> -		sock = tcp_sw_conn->sock;
> -		sock_hold(sock->sk);
> -		spin_unlock_bh(&conn->session->frwd_lock);
>  
>  		if (param == ISCSI_PARAM_LOCAL_PORT)
>  			rc = kernel_getsockname(sock,

