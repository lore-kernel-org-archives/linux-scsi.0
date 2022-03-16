Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09F4C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Mar 2022 08:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354445AbiCPIRc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Mar 2022 04:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245093AbiCPIR3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2022 04:17:29 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC3563506
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 01:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1647418574; x=1678954574;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fPJ6hHEJzoDaCoTA5ecrXRsYAOW7Qy6Jj7z+3mSGxSs=;
  b=kde27VRkK88S5dQ8XaIzAWyCdYn2aP65dmMpN+XAOf5RV9ryL5ozViDq
   q0oTIQnDLnMB2F4+ZOVHgfEJ22tmXHbpcSnuDVTnLkwzh3Qa5R7b14wSX
   lQ6rbUWY4J5eKbrn8PASxnD/twlR0G0mfudorHSBVzsC3bUqP5xWnIpcg
   WTMrbv1OqmCf+mym8Nth9hlfxY7kdx1mQ8M+RDl60+cqC1Xgh6TjrLjDR
   Lx49tpqzQaAyePk5xRuqqQYs/WVcaJyQoPZupzPEiZ6svB1qy+YtrLpdo
   /PKm9EFPQXSTAhpjRqZ2c28FxTEhM3uK35xhVQcei/2nQVkEUnpeRG/6u
   g==;
X-IronPort-AV: E=Sophos;i="5.90,186,1643644800"; 
   d="scan'208";a="194405217"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2022 16:16:13 +0800
IronPort-SDR: 4u7bkcHVu/s6lEP+c5HygKrduQSm5QkHwSzK+n5eiEpoVPVpYJNA/srFsYQBN/qVyTn3coV8Gj
 rD8pQZSBpLpVlblC6Y02SiNXXtreQt6tz0bUHWLDT01gSW1KyQCG8f2FE4T/N+T6UA9rCcwKjB
 u93FcEzuX4W1mBSYXS+puTxqpuuy+H+b7f1nK09pgs+Adn998qTO5bMzJXSoxDSKv+qKqZOnAj
 V1ndiJtlpd99ani8udJpbuWHByQud6PAwVfXH4qR+j2BK7407Y6+Eg5zoEZoathYhtl9wB0hmh
 dApdqKOfIRiIV3PdjBv91jjN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 00:48:18 -0700
IronPort-SDR: 7aF/3EOPTI4fdhBFH000ViSNfDYFUyCSUjd9+e3N8gTWqfCY68I2m+w4W1hRw05A5w+yZJYgOw
 G8RgJFrrgOcqwNTxz4rRTfxHmTT8P2VKE6/b6tOaXEpSNC4m9LcrUG0bW0Q5+h8OrU8ffPghXg
 n4hjgC0iapBAq/Xh8SfQ9JRKI7ylT3KCTAnRzOt1TnajTyVBMzgNWDRZ2ZFV7cjnwqrb4i4fDE
 /S0emLQd2AD1hYItsCqZjT7EPjrXDrWOBjMXmZm2xtOANUqQbqSorGmA4j8qakmB9i7qq7oppG
 aS0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 01:16:14 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KJNQP5MZnz1SVp0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 01:16:13 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1647418573; x=1650010574; bh=fPJ6hHEJzoDaCoTA5ecrXRsYAOW7Qy6Jj7z
        +3mSGxSs=; b=s0hHYjeJLY7DrKVq1+vDiUiukLC6iETbqRLM7Ok/RFev9EEFm0w
        oNmysrM5Z4mUG3jjoIkMvMkHt64vqZW6GcqccqpbeE3BqlFtm6hPdTVgE+XW0aJ6
        LDPFBaFMXonGGCY6TVoJExyw/G+FXkFbYHtnmC/H2F5tdB7GMrjO0fjDA9r1UKNp
        iyMKZRAzY48UNSCUAT9sAl7LEe3qM2mS7jHWCn5yV2qq7hkIGelfWUNzNz60gBvl
        SwSlpvIiufDTscV2o7X33NqWLzO8IXCWJzZ4B9sIrNDNKMMWN55tLEZsb4DRPeTX
        AYeKNmUNmqq0v//YjpO605NgBdRWiSmaYFA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ueg9-TO7EBvQ for <linux-scsi@vger.kernel.org>;
        Wed, 16 Mar 2022 01:16:13 -0700 (PDT)
Received: from [10.225.163.101] (unknown [10.225.163.101])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KJNQN2hlHz1Rvlx;
        Wed, 16 Mar 2022 01:16:12 -0700 (PDT)
Message-ID: <0055498d-054f-10cd-96d3-a92eaaf790b1@opensource.wdc.com>
Date:   Wed, 16 Mar 2022 17:16:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] scsi:target:tcmu: make sure dev blocked before resetting
 ring
Content-Language: en-US
To:     Guixin Liu <kanie@linux.alibaba.com>, bostroesser@gmail.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <1647417702-129883-1-git-send-email-kanie@linux.alibaba.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1647417702-129883-1-git-send-email-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/22 17:01, Guixin Liu wrote:
> If dev is not blocked when resetting ring, then there could be new
> commands coming in after resetting ring, this will make cmd ring broken,
> because tcmu can not find tcmu_cmd when tcmu-runner handled these
> newcome commands.
> 
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
> ---
>  drivers/target/target_core_user.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 7b2a89a..548ad94 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -2333,7 +2333,7 @@ static void tcmu_block_dev(struct tcmu_dev *udev)
>  	mutex_unlock(&udev->cmdr_lock);
>  }
>  
> -static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
> +static int tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>  {
>  	struct tcmu_mailbox *mb;
>  	struct tcmu_cmd *cmd;
> @@ -2341,6 +2341,12 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>  
>  	mutex_lock(&udev->cmdr_lock);
>  
> +	if (!test_bit(TCMU_DEV_BIT_BLOCKED, &udev->flags)) {
> +		pr_err("The dev should be blocked before resetting ring.\n");

This looks like a bug... So I think this should at least be a WARN_ON(). E.g.

	if (WARN_ON(!test_bit(TCMU_DEV_BIT_BLOCKED, &udev->flags))) {
		mutex_unlock(&udev->cmdr_lock);
		return -EINVAL;
	}

But why is the ring reset even allowed without the device being blocked in
the first place ? What is the root cause ?

> +		mutex_unlock(&udev->cmdr_lock);
> +		return -EINVAL;
> +	}
> +
>  	xa_for_each(&udev->commands, i, cmd) {
>  		pr_debug("removing cmd %u on dev %s from ring %s\n",
>  			 cmd->cmd_id, udev->name,
> @@ -2396,6 +2402,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>  	run_qfull_queue(udev, false);
>  
>  	mutex_unlock(&udev->cmdr_lock);
> +	return 0;
>  }
>  
>  enum {
> @@ -2995,7 +3002,10 @@ static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
>  		return -EINVAL;
>  	}
>  
> -	tcmu_reset_ring(udev, val);
> +	ret = tcmu_reset_ring(udev, val);
> +	if (ret < 0)
> +		return ret;
> +
>  	return count;
>  }
>  CONFIGFS_ATTR_WO(tcmu_, reset_ring);


-- 
Damien Le Moal
Western Digital Research
