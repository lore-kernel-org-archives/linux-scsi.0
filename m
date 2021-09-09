Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B73C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 16:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CAB66023D
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 16:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238789AbhIIQzo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 12:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhIIQzn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 12:55:43 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB7BC061574;
        Thu,  9 Sep 2021 09:54:34 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id q26-20020a4adc5a000000b002918a69c8eeso747186oov.13;
        Thu, 09 Sep 2021 09:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=koo56xDEDJfNlkz6/wICLDEQvftY5giDkHhB/R6R2jk=;
        b=U61AkWk+xSU8f6zbscu3oIlqmTpD/yfgNsdYMpS+23LKGfOQ3pEXfWs94f0Ia6NqY1
         eWia1nIi1IDPxfSVpfjmfrRRLN1aqFaxkd3/mPMnarLkH7pfGWx3UbhyvP89it5tQv7S
         7udXbhqZC+u+ToEzEtUMn5Bu8i/59myyK1LWM6OhLcba82Jbv+CESSZmlTCX+eo269H4
         8pD9fomrDm9Em7OogC5FUYMZoqQCipJCEQ5Ztohf5rYWojsuLpCtJJg6dCigb6zgXJoT
         Z38WwZ4gZwEQlcd8rtiwmquJnYQuza3HhD8PcHMBuVjRyYIEnSZ7kYVi6VsvXUY8TWoo
         3OJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=koo56xDEDJfNlkz6/wICLDEQvftY5giDkHhB/R6R2jk=;
        b=nN1byXNF/+XTuhBq5ziC9A3lnSSZpTrPGo3+0tRiNaAzDtPsB9rrjOhMobq01MPucM
         SD0YOLkkuCmJBykEoRydHFoHurFg38KzByO83JGrQexE5CN+Vaw3VnM0jq4QhkDZQeQv
         GBGmTKz1RjBrcQZV7/tCfUN5HVz9OitXAPil2nJZzBSEXicZttKVDoPrHFgbgYiQ6qJ5
         bgPc4gKdTlmWoFGbqa7A2VWFMEt0RLayRKf2myQUYUW7oG6fULvvZ7gx4FrbBlxI14RW
         NQoGwmHJbNqKbcFpAcIff+Xuu6yQEnevaGGYkCuatvBjxvJsZ7ZnO2/ywC24GyGqeOyE
         xJfg==
X-Gm-Message-State: AOAM532Lgrxks5Xi/2Ydx0j/Uj7hBRma+20LAPxBoBxTi1Xlo6Zl0/bc
        jvkkwfGPRXdh8w3zw8ntBTY=
X-Google-Smtp-Source: ABdhPJzzwDrlhiSYvL1PGW+EwbIuIHwyD1RqcvBgT45XUCxbV4sFkpqNfgffUR2swqnAWR0qS+E9uQ==
X-Received: by 2002:a4a:bd17:: with SMTP id n23mr682036oop.54.1631206473539;
        Thu, 09 Sep 2021 09:54:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n73sm569093oig.9.2021.09.09.09.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 09:54:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 9 Sep 2021 09:54:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: Add temperature notification exception
 handling
Message-ID: <20210909165431.GB3973437@roeck-us.net>
References: <20210909063444.22407-1-avri.altman@wdc.com>
 <20210909063444.22407-3-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210909063444.22407-3-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 09, 2021 at 09:34:44AM +0300, Avri Altman wrote:
> The device may notify the host of an extreme temperature by using the
> exception event mechanism. The exception can be raised when the device’s
> Tcase temperature is either too high or too low.
> 
> It is essentially up to the platform to decide what further actions need
> to be taken. leave a placeholder for a designated vop for that.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufs.h    |  2 ++
>  drivers/scsi/ufs/ufshcd.c | 19 +++++++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 171b27be7b1d..d9bc048c2a71 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -377,6 +377,8 @@ enum {
>  	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
>  };
>  
> +#define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
> +
>  /* Background operation status */
>  enum bkops_status {
>  	BKOPS_STATUS_NO_OP               = 0x0,
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index fc995bf1f296..1f61e8090220 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5642,6 +5642,22 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
>  				__func__, err);
>  }
>  
> +static void ufshcd_temp_exception_event_handler(struct ufs_hba *hba, u16 status)
> +{
> +	u32 value;
> +
> +	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			      QUERY_ATTR_IDN_CASE_ROUGH_TEMP, 0, 0, &value))
> +		return;
> +
> +	dev_info(hba->dev, "exception Tcase %d\n", value - 80);
> +

It would probably make sense to call hwmon_notify_event() here.

Guenter

> +	/*
> +	 * A placeholder for the platform vendors to add whatever additional
> +	 * steps required
> +	 */
> +}
> +
>  static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
>  {
>  	u8 index;
> @@ -5821,6 +5837,9 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
>  	if (status & hba->ee_drv_mask & MASK_EE_URGENT_BKOPS)
>  		ufshcd_bkops_exception_event_handler(hba);
>  
> +	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
> +		ufshcd_temp_exception_event_handler(hba, status);
> +
>  	ufs_debugfs_exception_event(hba, status);
>  out:
>  	ufshcd_scsi_unblock_requests(hba);
> -- 
> 2.17.1
> 
