Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AFCC47087
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 21:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 459BC613E3
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 21:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhE1VZi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 17:25:38 -0400
Received: from gateway20.websitewelcome.com ([192.185.50.28]:49109 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229481AbhE1VZh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 May 2021 17:25:37 -0400
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2021 17:25:37 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 12772400DC332
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 15:15:57 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id mj6EltxHwx8Dpmj6ElftYc; Fri, 28 May 2021 15:28:54 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=L3zwx02/a4qpuCrv9Ng4KVesaQf7X0hbM+48SL7llOw=; b=BXiFY5HalugiWU9BTfssC7wnet
        kLkPs6B0zXCSMe5NRtPgkGtGzAk1YnInlYGzLbgWUZIQdRv161BcZJxn85KtCVRuK4J0l5z26e7VB
        6jfy7MlnGhyhPzFH0R6qUkGqWcllxR7/Je5vqmVw/sQ0EKVdRk/WBgwuxedo8ngYHZaNfM2pc4n7u
        O6B4cNG/QgZ9UpQLnzu5MPAYEhKsXwkSY6d4LKVf90acuNJPu3TUk9inxU0lmN3lQgrq/f1GsuzNx
        8wYoRRsFGbcM4aJEy9AzE5ldF09UryO6pcWHo15B85Z27agBNorK5+w233Wbwo/5Ns1jgbXeELtSG
        SzEXm2yA==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:38342 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lmj6A-003lbU-Ig; Fri, 28 May 2021 15:28:50 -0500
Subject: Re: [PATCH 3/3] scsi: isci: Use correctly sized target buffer for
 memcpy()
To:     Kees Cook <keescook@chromium.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210528181337.792268-1-keescook@chromium.org>
 <20210528181337.792268-4-keescook@chromium.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <5741ac53-81ef-5106-0b58-51ddf5f65851@embeddedor.com>
Date:   Fri, 28 May 2021 15:29:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210528181337.792268-4-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lmj6A-003lbU-Ig
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:38342
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 24
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/28/21 13:13, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), avoid intentionally writing across
> neighboring array fields.
> 
> Switch from rsp_ui to resp_buf, since resp_ui isn't SSP_RESP_IU_MAX_SIZE
> bytes in length. This avoids future compile-time warnings.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  drivers/scsi/isci/task.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
> index 62062ed6cd9a..eeaec26ac324 100644
> --- a/drivers/scsi/isci/task.c
> +++ b/drivers/scsi/isci/task.c
> @@ -709,8 +709,8 @@ isci_task_request_complete(struct isci_host *ihost,
>  		tmf->status = completion_status;
>  
>  		if (tmf->proto == SAS_PROTOCOL_SSP) {
> -			memcpy(&tmf->resp.resp_iu,
> -			       &ireq->ssp.rsp,
> +			memcpy(tmf->resp.rsp_buf,
> +			       ireq->ssp.rsp_buf,
>  			       SSP_RESP_IU_MAX_SIZE);
>  		} else if (tmf->proto == SAS_PROTOCOL_SATA) {
>  			memcpy(&tmf->resp.d2h_fis,
> 
