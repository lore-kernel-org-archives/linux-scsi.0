Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2E5C48BCF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B350C613D2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhFJDkA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 23:40:00 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:41721 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFJDkA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 23:40:00 -0400
Received: by mail-pg1-f179.google.com with SMTP id l184so5918743pgd.8;
        Wed, 09 Jun 2021 20:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U2fzF+FH8NHU0kJqF6vs1aTBHFiGo2VBWqy5QQXaPiw=;
        b=eOqYHc64PJiAf7qr+OOqUYbofs7fyTc+dosM2e5oZgTJHgtYVMa8NUtVZQxjNNwOSR
         24h1pccffbIajol6Vx/LVk5b0qmB6g67XVsU4bmZPOvsG6Zd1EE+cyqbq94PInry/ZK4
         gWkz+vpK0N0Ljzj/xlYE98qp9Os+TypM7GQZPrL6he1nRBSyAu+KfiKQNQtXvYyT9m9G
         lN8nQ5S5gLsXHNvypqWUd6L4IU/ROb6yiH9p6RwkhIydCJRPR/0V5E9ksKZ+d+SnqopJ
         o//RL8rupzCEXH+pxX7X3mivCIyTOmblTWumeqr0JjZL8IPfaWx5PwzES+czba54p1qx
         D5iw==
X-Gm-Message-State: AOAM533ThbwTg0RRg2QJH36Lmdo7HZRDs36w+Gw+H6U9tCivKhmtSOIi
        9OrZe+T8eDYLtwhDckP41as=
X-Google-Smtp-Source: ABdhPJxLe5QhX2GKhgyMGvYBeKCpCByDq25oMinjn1y9oASMGORKPFFQRmniwdFqCvQHmW22pej05g==
X-Received: by 2002:a05:6a00:189e:b029:2f0:94d6:78c5 with SMTP id x30-20020a056a00189eb02902f094d678c5mr974475pfh.46.1623296272543;
        Wed, 09 Jun 2021 20:37:52 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v67sm816445pfb.193.2021.06.09.20.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 20:37:52 -0700 (PDT)
Subject: Re: [PATCH v36 4/4] scsi: ufs: Add HPB 2.0 support
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
References: <20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p2>
 <CGME20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p7>
 <20210607041927epcms2p707781de1678af1e1d0f4d88782125f7b@epcms2p7>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <25912c0a-7f52-8b04-2ac1-6686aee01f87@acm.org>
Date:   Wed, 9 Jun 2021 20:37:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210607041927epcms2p707781de1678af1e1d0f4d88782125f7b@epcms2p7>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/6/21 9:19 PM, Daejun Park wrote:
> -What:		/sys/class/scsi_device/*/device/hpb_sysfs/hit_cnt
> +What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/hit_cnt
>  Date:		June 2021
>  Contact:	Daejun Park <daejun7.park@samsung.com>
>  Description:	This entry shows the number of reads that changed to HPB read.
>  
>  		The file is read only.

Is it really useful to have a suffix "_sysfs" for a directory that
occurs in sysfs? If not, please leave it out.

Should "hpb_stat" perhaps be renamed into "hpb_stats"? An example of
another directory with statistics is /sys/power/suspend_stats. The name
of that directory also ends in "stats" (plural form).

> +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_size_hpb_single_cmd
> +Date:		June 2021
> +Contact:	Daejun Park <daejun7.park@samsung.com>
> +Description:	This entry shows the maximum HPB data size for using single HPB
> +		command.
> +
> +		===  ========
> +		00h  4KB
> +		01h  8KB
> +		02h  12KB
> +		...
> +		FFh  1024KB
> +		===  ========
> +
> +		The file is read only.

This is not clear enough. What are the values reported through this
sysfs attribute? Are that perhaps the values 00h .. FFh? Is the software
that reads this attribute perhaps expected to convert this attribute
from hex to int and next convert the int into a size in KB by using the
above lookup table? That seems awkward to me. Please report the maximum
data size directly, either in KB or in bytes.

> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index f99059b31e0a..d902414e4a6f 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -652,6 +652,8 @@ struct ufs_hba_variant_params {
>   * @srgn_size: device reported HPB sub-region size
>   * @slave_conf_cnt: counter to check all lu finished initialization
>   * @hpb_disabled: flag to check if HPB is disabled
> + * @max_hpb_single_cmd: maximum size of single HPB command
> + * @is_legacy: flag to check HPB 1.0
>   */
>  struct ufshpb_dev_info {
>  	int num_lu;
> @@ -659,6 +661,8 @@ struct ufshpb_dev_info {
>  	int srgn_size;
>  	atomic_t slave_conf_cnt;
>  	bool hpb_disabled;
> +	int max_hpb_single_cmd;
> +	bool is_legacy;
>  };
>  #endif

Elsewhere in this patch I see that max_hpb_single_cmd is the value read
from the bMAX_DATA_SIZE_FOR_SINGLE_CMD descriptor (one byte). Does this
mean that the type of 'max_hpb_single_cmd' should be changed into
uint8_t? Additionally, please make it clear in the comment block above
struct ufshpb_dev_info that max_hpb_single_cmd is not a size in bytes.

> +bool ufshpb_is_legacy(struct ufs_hba *hba)
> +{
> +	return hba->ufshpb_dev.is_legacy;
> +}

Please add a comment above this function that explains what 'legacy'
means in the context of HPB.

> +static int ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
> +				   struct ufshpb_req *umap_req,
> +				   struct ufshpb_region *rgn)
> +{
> +	struct request *req;
> +	struct scsi_request *rq;
> +
> +	req = umap_req->req;
> +	req->timeout = 0;
> +	req->end_io_data = (void *)umap_req;
> +	rq = scsi_req(req);
> +	ufshpb_set_unmap_cmd(rq->cmd, rgn);
> +	rq->cmd_len = HPB_WRITE_BUFFER_CMD_LENGTH;
> +
> +	blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
> +
> +	return 0;
> +}

This function always returns 0. Please change the return type from 'int'
into 'void'.

> +/* SYSFS functions */
> +#define ufshpb_sysfs_param_show_func(__name)				\
> +static ssize_t __name##_show(struct device *dev,			\
> +	struct device_attribute *attr, char *buf)			\
> +{									\
> +	struct scsi_device *sdev = to_scsi_device(dev);			\
> +	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);		\
> +	if (!hpb)							\
> +		return -ENODEV;						\
> +									\
> +	return sysfs_emit(buf, "%d\n", hpb->params.__name);		\
> +}

Please leave a blank line between variable declarations and code.

Thanks,

Bart.
