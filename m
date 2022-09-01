Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887B9ECAAD4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 01:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbiIAB3M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Aug 2022 21:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbiIAB2u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2022 21:28:50 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4688A155A42
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 18:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661995721; x=1693531721;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=icU2K6t7QUTC4ZFl028n9Bj57lT6StOkRAYSsEDFFF8=;
  b=Q0CYsKPAr1c8JhKZYoCBVD9FrVSYOu3Hw444k/F7P7FCExnEn6sPsJE6
   Md3f3zpOiTDI6KTwjMDuC+4uyq0AIjXUf8yq6mlCuHXR3opwL926hpKZA
   3ZK0JxLepp9EFBSq3TWfv4M8aJoJEG/izbrRHOt2mbP6Zaj9zsOTMtXe1
   REUWuG1AiAy3DrRp5I7+V5NKYfyW9mFgr3L98Q0o98sOadetfAUIobzRY
   yV3tygCtqB7M7tdVd0YoBhAly45Orgty0xwFPvniFzkQxENc3Oa+orlK9
   Jhj+hWtCnKjzWUnfy3davVxSJjwRPCM9bJz9cT06RQs0EQ0r7o8pXqhSx
   A==;
X-IronPort-AV: E=Sophos;i="5.93,279,1654531200"; 
   d="scan'208";a="215341587"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Sep 2022 09:28:34 +0800
IronPort-SDR: HKD4Bw9vdv5+rEvi5ST0lpq7QdlelejANGl5vQCFbACIMyjiGqsqARyYuj/80CtNvh4zGdAaae
 nMJM4NlCH+HzRQXgZU1UTow8ArXgCAw2NrfZJXAwH20HegGa4dPaeWytxpL54tE06AKQ/V9e79
 5+hyoOeMsQb8IeEaouV8VJxhrWsIHKT2ZFQVLk72rtsyBzVcOe1esoyr+u7wSCdPAYavIJ31lf
 NGbb/+ZLkcLtDPoPrqQI5fO3iIwSyo/rjwnEffs1qtuobVB/V8ptW+kzzZrv56qgpbhvhSYqWw
 dhlibhX+G5WMKh+9YkkCi+Bf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Aug 2022 17:49:03 -0700
IronPort-SDR: QvIm8TTZDnLmb4bPRbJkhjNq3ASoaV10wk7cwh09qo8FZBrRuP3xkrKdBx/PkSJ9TOhjwa60eA
 IgaJv1AcyJGrrEbahPKABURkvzr+sabHnBVs/kgc/xMzCk3JrZOhYdRhQ0WDx07q+Qyr5R1HPA
 8O2xOOzQlG5SRrcHBN1PUz+Ej7IaLMkRMSZZY4PyAlGG3JFlfPoLJGL78NtnyXGp5IkhA7JYhw
 JrTILHBBZ3o2YonSMKY/g+qlDYWKF6mdm33vSRVWHQUTmqHHI7IELl7eVfQIguuNbH8xDXPqgZ
 Xeg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Aug 2022 18:28:34 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MJ3N16KtWz1RwtC
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 18:28:33 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1661995713; x=1664587714; bh=icU2K6t7QUTC4ZFl028n9Bj57lT6StOkRAY
        SsEDFFF8=; b=g5Rh75KhttA1kCHsxhyYAocHkDqpMQ7KfdnjXXiQujmHS4i6WV+
        RhrW2KVVMV9/uhdt5uL1N0Ff7e9ecDo+Uk07KcV65GBRclk2Xn4B10OGTy2fGph4
        aWYWBeZAZsv/g+eX3MqOppKG5g6b3v6gKcSwDtJnTdZ2528zvrYaKvKrNUhZ8mUS
        p2o3sUIA5hNrfoSBEFf09UCy1iVlIRRBVB+f8zZM5HjNiskAzHevhEMo0GPMtlrk
        vVpvzin7VQ+9K1XHhkILy4alDYMju56+RcwJ/gJThD6pt/TbsRq2HPmpCvu2tUuu
        Gvi8d2073rYT+5QU40fwpEZ6vXEL9iIZ9ag==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LzuS-LwzM8v9 for <linux-scsi@vger.kernel.org>;
        Wed, 31 Aug 2022 18:28:33 -0700 (PDT)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MJ3Mz5WSVz1RvLy;
        Wed, 31 Aug 2022 18:28:31 -0700 (PDT)
Message-ID: <ed952992-8c6f-48db-8d53-ad662da1ea81@opensource.wdc.com>
Date:   Thu, 1 Sep 2022 10:28:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2] scsi: csiostor: convert sysfs snprintf to sysfs_emit
Content-Language: en-US
To:     Xuezhi Zhang <zhangxuezhi3@gmail.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, bvanassche@acm.org,
        johannes.thumshirn@wdc.com, himanshu.madhani@oracle.com,
        zhangxuezhi1@coolpad.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220901005554.417043-1-zhangxuezhi3@gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220901005554.417043-1-zhangxuezhi3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/22 09:55, Xuezhi Zhang wrote:
> From: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
> 
> Fix up all sysfs show entries to use sysfs_emit
> 
> Signed-off-by: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
> ---
> v2: delete 'else' and extra space.
> ---
>  arch/arm64/configs/defconfig      |  2 ++
>  drivers/scsi/csiostor/csio_scsi.c | 10 +++++-----
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> index 91e58cf59c99..6a0af8a5a8b2 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -1328,3 +1328,5 @@ CONFIG_DEBUG_FS=y
>  # CONFIG_DEBUG_PREEMPT is not set
>  # CONFIG_FTRACE is not set
>  CONFIG_MEMTEST=y
> +CONFIG_SCSI_CHELSIO_FCOE=y
> +CONFIG_MEGARAID_MAILBOX=y

This hunk is new in the patch and not explained in the commit message.
This likely needs to be a different patch if this is a valid change.

> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
> index 9aafe0002ab1..05e1a63e00c3 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -1366,9 +1366,9 @@ csio_show_hw_state(struct device *dev,
>  	struct csio_hw *hw = csio_lnode_to_hw(ln);
>  
>  	if (csio_is_hw_ready(hw))
> -		return snprintf(buf, PAGE_SIZE, "ready\n");
> -	else
> -		return snprintf(buf, PAGE_SIZE, "not ready\n");
> +		return sysfs_emit(buf, "ready\n");
> +
> +	return sysfs_emit(buf, "not ready\n");
>  }
>  
>  /* Device reset */
> @@ -1430,7 +1430,7 @@ csio_show_dbg_level(struct device *dev,
>  {
>  	struct csio_lnode *ln = shost_priv(class_to_shost(dev));
>  
> -	return snprintf(buf, PAGE_SIZE, "%x\n", ln->params.log_level);
> +	return sysfs_emit(buf, "%x\n", ln->params.log_level);
>  }
>  
>  /* Store debug level */
> @@ -1476,7 +1476,7 @@ csio_show_num_reg_rnodes(struct device *dev,
>  {
>  	struct csio_lnode *ln = shost_priv(class_to_shost(dev));
>  
> -	return snprintf(buf, PAGE_SIZE, "%d\n", ln->num_reg_rnodes);
> +	return sysfs_emit(buf, "%d\n", ln->num_reg_rnodes);
>  }
>  
>  static DEVICE_ATTR(num_reg_rnodes, S_IRUGO, csio_show_num_reg_rnodes, NULL);

This part looks OK.

-- 
Damien Le Moal
Western Digital Research

