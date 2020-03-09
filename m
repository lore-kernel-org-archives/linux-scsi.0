Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5911C10F28
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 09:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96BC020727
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 09:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgCIJXx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 05:23:53 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2518 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725956AbgCIJXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Mar 2020 05:23:53 -0400
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id DA1F5627232FA6AA24A9;
        Mon,  9 Mar 2020 09:23:51 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml709-cah.china.huawei.com (10.201.108.32) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 9 Mar 2020 09:23:51 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 9 Mar 2020
 09:23:51 +0000
Subject: Re: [PATCH v2] scsi: aacraid: fix -Wcast-function-type
To:     Phong Tran <tranmanphong@gmail.com>, <aacraid@microsemi.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <keescook@chromium.org>
References: <20200307132103.4687-1-tranmanphong@gmail.com>
 <20200308020143.9351-1-tranmanphong@gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9a0e6373-b4a3-0822-3b65-e3b326266832@huawei.com>
Date:   Mon, 9 Mar 2020 09:23:50 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200308020143.9351-1-tranmanphong@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/03/2020 02:01, Phong Tran wrote:
> correct usage prototype of callback scsi_cmnd.scsi_done()
> Report by: https://github.com/KSPP/linux/issues/20
> 

no harm to add:

drivers/scsi/aacraid/aachba.c:813:23: warning: cast between incompatible 
function types from ‘int (*)(struct scsi_cmnd *)’ to ‘void (*)(struct 
scsi_cmnd *)’ [-Wcast-function-type]


> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>   drivers/scsi/aacraid/aachba.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index 33dbc051bff9..20ca3647d211 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -798,6 +798,11 @@ static int aac_probe_container_callback1(struct scsi_cmnd * scsicmd)
>   	return 0;
>   }
>   
> +static void  aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)

supernit: double whitespace

> +{
> +	aac_probe_container_callback1(scsi_cmnd);
> +}
> +
>   int aac_probe_container(struct aac_dev *dev, int cid)
>   {
>   	struct scsi_cmnd *scsicmd = kmalloc(sizeof(*scsicmd), GFP_KERNEL);
> @@ -810,7 +815,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
>   		return -ENOMEM;
>   	}
>   	scsicmd->list.next = NULL;
> -	scsicmd->scsi_done = (void (*)(struct scsi_cmnd*))aac_probe_container_callback1;
> +	scsicmd->scsi_done = aac_probe_container_scsi_done;
>   
>   	scsicmd->device = scsidev;
>   	scsidev->sdev_state = 0;
> 

