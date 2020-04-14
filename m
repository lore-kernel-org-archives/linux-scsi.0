Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD916C2BBC7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 01:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9704320732
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 01:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390706AbgDNBRq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:17:46 -0400
Received: from smtp.infotech.no ([82.134.31.41]:42625 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728669AbgDNBRq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Apr 2020 21:17:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id A5BA920425A;
        Tue, 14 Apr 2020 03:17:44 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xdIwwtOfRiW2; Tue, 14 Apr 2020 03:17:38 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id BEA6E20414B;
        Tue, 14 Apr 2020 03:17:37 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: sg: add sg_remove_request in sg_common_write
To:     Li Bin <huawei.libin@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiexiuqi@huawei.com
References: <1586777361-17339-1-git-send-email-huawei.libin@huawei.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <8a19ba1a-1afe-2938-daea-96b1f14570cf@interlog.com>
Date:   Mon, 13 Apr 2020 21:17:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1586777361-17339-1-git-send-email-huawei.libin@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-13 7:29 a.m., Li Bin wrote:
> If the dxfer_len is greater than 256M that the request is invalid,
s/that/then/
> it should call sg_remove_request in sg_common_write.
> 
> Fixes: f930c7043663 ("scsi: sg: only check for dxfer_len greater than 256M")

Code fix is fine, please replace the "that" in the first comment line
above with "then".

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> Signed-off-by: Li Bin <huawei.libin@huawei.com>
> ---
>   drivers/scsi/sg.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 4e6af592..9c0ee19 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -793,8 +793,10 @@ static int get_sg_io_pack_id(int *pack_id, void __user *buf, size_t count)
>   			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
>   			(int) cmnd[0], (int) hp->cmd_len));
>   
> -	if (hp->dxfer_len >= SZ_256M)
> +	if (hp->dxfer_len >= SZ_256M) {
> +		sg_remove_request(sfp, srp);
>   		return -EINVAL;
> +	}
>   
>   	k = sg_start_req(srp, cmnd);
>   	if (k) {
> 

