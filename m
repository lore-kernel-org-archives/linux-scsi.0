Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6190AC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 418382075E
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfKRKoR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 05:44:17 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:43442 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726562AbfKRKoR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 05:44:17 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 598624DE7922C2C9B17A;
        Mon, 18 Nov 2019 18:44:08 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Mon, 18 Nov 2019
 18:44:04 +0800
Subject: Re: [PATCH -next v2] scsi: qla2xxx: Use PTR_ERR_OR_ZERO() to simplify
 code
To:     <hmadhani@marvell.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
References: <1574073792-26475-1-git-send-email-zhengbin13@huawei.com>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <0c2f858d-4447-a43d-9693-51b9f33ca20c@huawei.com>
Date:   Mon, 18 Nov 2019 18:44:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1574073792-26475-1-git-send-email-zhengbin13@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Actually it is v1, not v2 patch. my mistake...sorry for the confuse

On 2019/11/18 18:43, zhengbin wrote:
> Fixes coccicheck warning:
>
> drivers/scsi/qla2xxx/tcm_qla2xxx.c:1462:1-3: WARNING: PTR_ERR_OR_ZERO can be used
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 042a2431..a82ad17 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1459,10 +1459,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
>  				       sizeof(struct qla_tgt_cmd),
>  				       TARGET_PROT_ALL, port_name,
>  				       qlat_sess, tcm_qla2xxx_session_cb);
> -	if (IS_ERR(se_sess))
> -		return PTR_ERR(se_sess);
> -
> -	return 0;
> +	return PTR_ERR_OR_ZERO(se_sess);
>  }
>
>  static void tcm_qla2xxx_update_sess(struct fc_port *sess, port_id_t s_id,
> --
> 2.7.4
>
>
> .
>

