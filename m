Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5F0ECAAD1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 00:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiIAAYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Aug 2022 20:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIAAYS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2022 20:24:18 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9308BDFB47
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 17:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661991857; x=1693527857;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b+nLJgpn28rI8XB+tceCDIqsNDOgTwY8YQFEJt059HM=;
  b=QuUTM9AWkodRqriyNgDRCII5rTgOStr4Gh2r8o2MQFKzDEGLD7Vh8vlp
   98FTdLD8xH1LbMXEXgt6oV0HrJl2mxYCvSDbztaQw9Y1w7JnqSpxtbI1h
   9Pbjz4zwPF4ka0emrhKXgfnH/k11EGHJOSv4OWg33mwdMXlSCnaF4+rkq
   lMzyLTztrFM/uWKumGSJDKaQcGoseQr1lWelv93Zlpjhdx6IaevKNP3zR
   46YeB9KmxSNz+q9DzHYhvh4c4CZLXYtPIFVlEaGHl/BUWV96gFmWHNp6U
   a5guYmGrWQoluuHZubErNhNFgrLBDoeQAR9kscbhPfIRZsyt1E7/VT4mq
   w==;
X-IronPort-AV: E=Sophos;i="5.93,279,1654531200"; 
   d="scan'208";a="322283316"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Sep 2022 08:24:03 +0800
IronPort-SDR: 2y5KDUkCX4HD04oTqLmLhUQ3q2lb3sgTJEzX5MtVWzwF+tVtJILCfbP1kombuWiAXtex1Xrrq+
 wotdVU1izdhI8guzGDTzBEX/CvFtg5aNYMmSjQYqX7wS3X6ah2+TQe+2LvRDtCg4UWhGVx6iZe
 /bbOuzqZEWwVB6R+u+TPvXKO3Vn9g3JsIuEdiRGxkhLVnouKlF6WbYDIoa1DeWrxFjU0O1S7Pn
 G0QQqV94be6k8AuImC7hM2CtT6bZ+I7/k2vdzJaXGEZ8ylVhCz+vhfWsKmGLotZnSday3GjC3I
 Fhol0mDVHUiY1zmt4BO4JrKv
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Aug 2022 16:44:32 -0700
IronPort-SDR: j5VPXSQX8jtYiPuEI1SPf1Xnj2P3iahf1kN2v8mEC3WD7dixy1kpvSBzCq1CbGJQeTtU1mrA5E
 lE9vweXpL9WNmdJy3Jt6iyNVDntaJ2QkK5eDe29vInvl/P8TEVbKCQBpMY2NQC5Cqwapx65Gi+
 b9SjtVNvYxXOr/gQ7GKGU3T006Te+L4rCoj8j+VJa1ZYqOvNcQAKn6mHytOos55aVn76tAxHGV
 UC9X6yhCV1PMQs41axXAW5cuJTlN5HYAzXWwemmofDGH552wdvROtRSdbprvS3cnGtG5Mo3iz/
 C7o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Aug 2022 17:24:03 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MJ1xZ3ncpz1RwtC
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 17:24:02 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1661991841; x=1664583842; bh=b+nLJgpn28rI8XB+tceCDIqsNDOgTwY8YQF
        EJt059HM=; b=JTtFZkmw3v192aUDwLFkhQq3NUpdFAX9T6Tkbf6SytEuCZljEm0
        0tdUyXI9KCRsrvUkH8MUnhWFEDYuntoSdItWs5IO43ThROrLE0RslYLWhRueFKwh
        URGER98smDL4qW9BPDGBP9delJtcMgX6mJ6LvR5bRDz2WDXTnZKdzEpi6h+S6Z1L
        MYhFhXqAE+xFbynyGtZavdV3lpN7LIaff7I7a5FxhRjNi7oWemdlhLpCD9pVYYr6
        QribCWlWQujm+0XaHJIp1Bh8TGF9qXEAyQRKFi3SoG1tpoPgOJ8ZP2zwZFYuSLyv
        3J2gu02nPatjI+INajmjSbwuRsWNN6Npsfg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AwG7V-2MYx99 for <linux-scsi@vger.kernel.org>;
        Wed, 31 Aug 2022 17:24:01 -0700 (PDT)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MJ1xX1klHz1RvLy;
        Wed, 31 Aug 2022 17:24:00 -0700 (PDT)
Message-ID: <b2a4ba8c-c67b-3041-9b81-783611de0763@opensource.wdc.com>
Date:   Thu, 1 Sep 2022 09:23:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] scsi: csiostor: convert sysfs snprintf to sysfs_emit
To:     Xuezhi Zhang <zhangxuezhi3@gmail.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, bvanassche@acm.org,
        johannes.thumshirn@wdc.com, himanshu.madhani@oracle.com,
        zhangxuezhi1@coolpad.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220831141046.406837-1-zhangxuezhi3@gmail.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220831141046.406837-1-zhangxuezhi3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/31/22 23:10, Xuezhi Zhang wrote:
> From: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
> 
> Fix up all sysfs show entries to use sysfs_emit
> 
> Signed-off-by: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
> ---
>  drivers/scsi/csiostor/csio_scsi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
> index 9aafe0002ab1..39e8c3c26a19 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -1366,9 +1366,9 @@ csio_show_hw_state(struct device *dev,
>  	struct csio_hw *hw = csio_lnode_to_hw(ln);
>  
>  	if (csio_is_hw_ready(hw))
> -		return snprintf(buf, PAGE_SIZE, "ready\n");
> +		return sysfs_emit(buf, "ready\n");
>  	else

While at it, you could remove this useless else here.

> -		return snprintf(buf, PAGE_SIZE, "not ready\n");
> +		return sysfs_emit(buf,  "not ready\n");

Extra space after the ",".

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

-- 
Damien Le Moal
Western Digital Research

