Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D4DECAAD4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 00:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiIAAZB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Aug 2022 20:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiIAAY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2022 20:24:56 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4E518B3B
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 17:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661991894; x=1693527894;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ooxA17H90r4EJBbz/H4WAry0ZgcsiZQD5fz0PPvFxIs=;
  b=gDG7io/KQCQUIvFDnjlaROER3QEXzb2lW/iN0bnIi+hTfzeMfjXtCBkf
   wx/PJ54ynS6KeByChXxJmFjGyxMWJICByVeNWPA7tAqt+ly2dYyhbuYn4
   BJXOk0+ZN1oTY9MJ/fieZjNXKfFgUvgK6/ukPbWU74lqEgiPxN25HVLO3
   1utrznlbGf+OXK5px5G1QKKwOR15pqkFNV61lbxVTu+NIqCkAR7D5KtKA
   uG9HwWbxvayOMKaF6+tcPQirCRAG7zT/YbUkTu/z1GCMtMT4X3GcOGvff
   f4fpANUKNz7+bMPIhpv7oPf2iKFlmeLLAdcJsXWAJUX/QAcWPi47SFBQ9
   w==;
X-IronPort-AV: E=Sophos;i="5.93,279,1654531200"; 
   d="scan'208";a="210170854"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Sep 2022 08:24:50 +0800
IronPort-SDR: PXYWlCerEt5sbOONEPV0sGc3r9j45koWaXjz4Zqv028SscVL0zHZh2p9Mx0wUJ0DTIJyJpVSFh
 k5yXM7OFVxCIrcjR7ScyvrLqEWBg3fI1XJAI6kpdgmHOMOopl8laFRlrZ9Sw7rIat8V0CmsXHe
 ZvPBSkkoi0Hw+K8kzHm69KVz22uFwaRyu6+c59wrDsJa0fROvKtK6VYJNMUXQlol1Rq/jfYBUl
 tQR3cZMpVTnfHYsly50LUxDzriIOjBwamG+e5IHHhgN5d3ivcvxkxnND0WYSGfNKxhC1YA+NEs
 jM+Kvt0hpm85ntxC+/YsFleo
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Aug 2022 16:45:21 -0700
IronPort-SDR: fPtupGXV4K2Fuuk6aWyVoo6cKaigTwBqoC1NNgTNEY2RSVjzxL2YtGdAdMeoH0BE+t6cH+JOzD
 JDmqV/57FdC7ckUbsdyFl87Rq9X5FVdcufXdoJ2+nij+Lujdgk2C326zyW+9/m6m+vPkR83UrJ
 LDcfz9tE6gM233EZGJrwoXXCTd0MBiwOv5jrionCi4nmEKfHENLTmDQpzM4x90/oL5d8RV1Xpj
 avxqEK1uc5Q5yEHUIEsclHDMDgpvZmb6BtNlStA6hkof8LnngDjyyf34mA3ZBpZjd1g+uQVl3S
 kyE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Aug 2022 17:24:52 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MJ1yW2DSMz1RwvT
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 17:24:51 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1661991890; x=1664583891; bh=ooxA17H90r4EJBbz/H4WAry0ZgcsiZQD5fz
        0PPvFxIs=; b=sm28BkyJoQu2n/DP7jG1tYAQzBzENRq2rbMtWbMtT9u0tjKbVHg
        xZ0mNNRQgboxwzmIzm7RRWP1g9+xKjxDd5KI0XG8Ic6qs1daIZeT9y8PLK+e2C1H
        EGhZKRQhg7dNBJvNaY+5uSNjYqHbuZYBXv9gLY+zFy8WP3ngddfinR0uKCugEgZH
        giVD5RjYgCPlVFgdQz9YYHd2BAhQPFRrfmcEcDrZcmNZiJleFFy5N1gzeWnFDHbT
        6I4IbHFwYp/5NorqHFZr+H2tVysbxYBBEzU0V+3MYU3ermRweU/QxGUXbL6VTRmk
        JGkjBp1qMVXesiHFCmn3cz3WXFyA4sEQHIQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Pw_i5QxVoTJr for <linux-scsi@vger.kernel.org>;
        Wed, 31 Aug 2022 17:24:50 -0700 (PDT)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MJ1yT0sCjz1RvLy;
        Wed, 31 Aug 2022 17:24:48 -0700 (PDT)
Message-ID: <a4a486b3-7acc-090f-d9c5-bac7a2239482@opensource.wdc.com>
Date:   Thu, 1 Sep 2022 09:24:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] scsi: megaraid: convert sysfs snprintf to sysfs_emit
Content-Language: en-US
To:     Xuezhi Zhang <zhangxuezhi3@gmail.com>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xuezhi Zhang <zhangxuezhi1@coolpad.com>
References: <20220831140325.396295-1-zhangxuezhi3@gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220831140325.396295-1-zhangxuezhi3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/31/22 23:03, Xuezhi Zhang wrote:
> From: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
> 
> Fix up all sysfs show entries to use sysfs_emit
> 
> Signed-off-by: Xuezhi Zhang <zhangxuezhi1@coolpad.com>

Looks OK.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/megaraid/megaraid_mbox.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> index 157c3bdb50be..132de68c14e9 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -3979,7 +3979,7 @@ megaraid_mbox_app_hndl_show(struct device *dev, struct device_attribute *attr, c
>  
>  	app_hndl = mraid_mm_adapter_app_handle(adapter->unique_id);
>  
> -	return snprintf(buf, 8, "%u\n", app_hndl);
> +	return sysfs_emit(buf, "%u\n", app_hndl);
>  }
>  
>  
> @@ -4048,7 +4048,7 @@ megaraid_mbox_ld_show(struct device *dev, struct device_attribute *attr, char *b
>  		}
>  	}
>  
> -	return snprintf(buf, 36, "%d %d %d %d\n", scsi_id, logical_drv,
> +	return sysfs_emit(buf, "%d %d %d %d\n", scsi_id, logical_drv,
>  			ldid_map, app_hndl);
>  }
>  

-- 
Damien Le Moal
Western Digital Research

