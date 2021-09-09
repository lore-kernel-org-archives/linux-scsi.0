Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034F6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 16:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4B036113A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 16:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbhIIQ2M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 12:28:12 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:37744 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhIIQ2L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 12:28:11 -0400
Received: by mail-pj1-f48.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so1908519pjw.2;
        Thu, 09 Sep 2021 09:27:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mHxgSdrIJAa0qMMddKjvFInLCgU+LaequQmYcgG9LcM=;
        b=KHtvG6mso8l4tcyFkk/idyZTJdmzyt1ZnoZmyt7XPRSiE8i/1UtlTn+N9IvzGJTYL2
         ZObEtZNYW3yGpTxiwjKnG/I3oxRnvUXa8YBuXvp9krQ6HpMOgJ6vpIRPl5E9uDDMN1UL
         cwV6L+uAWiflM9s4wRLJGd4yvGwWYtqIxcEIoMO6/X06YzQzeT8IXnN8fWhbchx93cCS
         Y2oqeUS+9zCZW6fBn17F0ZmIoZ22r0myS+CxmIOeFpPfA26jO6FmxglIcPT5iuw7sUcW
         O3V+UBSygWGZmneuFl+tOqqfnm23dd5tGJ4c2AuckcvEd5EBXKswiltMk8yw4xg1HQKA
         zjoQ==
X-Gm-Message-State: AOAM530p440dOEl8FXj1I33/3np89zyfgfQAC2jvWTd4DvlqzZT1D0V/
        oRpi4q0yJIFpR+NNOGH3UHE=
X-Google-Smtp-Source: ABdhPJzbvq42xmCq6hF5sKwnDS7kKkI1BiIzLYZT6hdWYRQFXe1Rr6YvTDxqEQfKppyySrpaXgRqtw==
X-Received: by 2002:a17:902:ea0a:b0:13a:6d2d:d2f with SMTP id s10-20020a170902ea0a00b0013a6d2d0d2fmr3400182plg.76.1631204821859;
        Thu, 09 Sep 2021 09:27:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8de:4ad3:a912:b8c9])
        by smtp.gmail.com with ESMTPSA id o16sm3051779pgv.29.2021.09.09.09.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 09:27:01 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] scsi: ufs: Probe for temperature notification
 support
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>
References: <20210909063444.22407-1-avri.altman@wdc.com>
 <20210909063444.22407-2-avri.altman@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1b31a30a-cf2d-240c-78c1-ff348178f259@acm.org>
Date:   Thu, 9 Sep 2021 09:26:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210909063444.22407-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/8/21 11:34 PM, Avri Altman wrote:
> +static bool ufs_temp_enabled(struct ufs_hba *hba, struct ufs_hwmon_data *data)
> +{
> +	u32 ee_mask;
> +
> +	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			      QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &ee_mask))
> +		return false;
> +
> +	return (data->mask & ee_mask & MASK_EE_TOO_HIGH_TEMP) ||
> +		(data->mask & ee_mask & MASK_EE_TOO_LOW_TEMP);
> +}

The above function uses data->mask but not data so it's probably better to pass
data->mask directly as the second argument.

> +static bool ufs_temp_valid(struct ufs_hba *hba, struct ufs_hwmon_data *data,
> +			   enum attr_idn idn, u32 value)
> +{
> +	return (idn == QUERY_ATTR_IDN_CASE_ROUGH_TEMP && value >= 1 &&
> +		value <= 250 && ufs_temp_enabled(hba, data)) ||
> +	      (idn == QUERY_ATTR_IDN_HIGH_TEMP_BOUND && value >= 100 &&
> +	       value <= 250) ||
> +	      (idn == QUERY_ATTR_IDN_LOW_TEMP_BOUND && value >= 1 &&
> +	       value <= 80);
> +}

Same comment for this function - if the above comment is addressed 'mask' can be
passed as an argument instead of 'data'.

> +static int ufs_get_temp(struct ufs_hba *hba, struct ufs_hwmon_data *data,
> +			enum attr_idn idn)
> +{
> +	u32 value;
> +
> +	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR, idn, 0, 0,
> +	    &value))
> +		return 0;
> +
> +	if (ufs_temp_valid(hba, data, idn, value))
> +		return value - 80;
> +
> +	return 0;
> +}

Same comment here.

> +void ufs_hwmon_remove(struct ufs_hba *hba)
> +{
> +	if (hba->hwmon_device) {
> +		struct ufs_hwmon_data *data =
> +			dev_get_drvdata(hba->hwmon_device);
> +
> +		hwmon_device_unregister(hba->hwmon_device);
> +		hba->hwmon_device = NULL;
> +		kfree(data);
> +	}
> +}

Please use the "early return" style since that is the most widely used style
in the Linux kernel (if (!hba->hwmon_device) return).

Thanks,

Bart.
