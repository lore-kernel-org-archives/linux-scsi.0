Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E59C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D00DD610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhDBDu4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:50:56 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:46789 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbhDBDuz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:50:55 -0400
Received: by mail-pf1-f178.google.com with SMTP id x126so2812222pfc.13
        for <linux-scsi@vger.kernel.org>; Thu, 01 Apr 2021 20:50:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QUb/FmmYUQcls2AlSeeNxNu28IZbwQI8YIrAtqcRurQ=;
        b=dt8WOarVpawTAaH5gwD6quLI+C51b5Y+AGraP1EaONBNQShRJ8SIO1yLtjKlx+gWsO
         AvxOqAN/aDqo40GT9LFqWMeUzC0SJpz+7NOmI0xdPCCt0V1iFR5I2FbkUqnI2Kcc2Nst
         di+WCvqOmKcO9gQ009AhXJ+33VqvcIfp8oVJDSW8M26nZODRDCPdj2XcAcX9PObe6F0v
         7ytD4+axr3RNPjkh+9TGbxnpbdXp1HMBQAkDitdV7f5Mwb78jJM2+/IyL1BNXs0a7eow
         /+MYqcvMRT5FQ9g3mNJ1t6XZHM8TEByXuO6QwBOofQB/rD71119vg+cWuQQuIXYBAVZH
         fcFw==
X-Gm-Message-State: AOAM530FnExYBndXGl7/CxCm+vXKERz/rdqIBkbdTmA+OpePI9IEV6Gy
        j3p9rUkxi30yLxEnvNTpyMI=
X-Google-Smtp-Source: ABdhPJxB4sU40QWvQuj9wDtcm6F12eyKccegsKVGVQyu5+b1659ekAwDcoMDDqbQwxuvibKokb9dcQ==
X-Received: by 2002:a63:6fc1:: with SMTP id k184mr10567389pgc.292.1617335455216;
        Thu, 01 Apr 2021 20:50:55 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:2046:e611:bcdf:eb50? ([2601:647:4000:d7:2046:e611:bcdf:eb50])
        by smtp.gmail.com with ESMTPSA id l10sm6191723pfc.125.2021.04.01.20.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 20:50:54 -0700 (PDT)
Subject: Re: [PATCH v3 2/7] pm80xx: Add sysfs attribute to track RAAE count
To:     Viswas G <Viswas.G@microchip.com>, linux-scsi@vger.kernel.org
Cc:     Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar.devadi@microchip.com, vishakhavc@google.com,
        radha@google.com, jinpu.wang@cloud.ionos.com,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        John Garry <john.garry@huawei.com>
References: <20210330064008.9666-1-Viswas.G@microchip.com>
 <20210330064008.9666-3-Viswas.G@microchip.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <29fe3ddd-83c0-75fd-585c-3d33bd8fd723@acm.org>
Date:   Thu, 1 Apr 2021 20:50:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210330064008.9666-3-Viswas.G@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/21 11:40 PM, Viswas G wrote:
> +static ssize_t ctl_raae_count_show(struct device *cdev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(cdev);
> +	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +	unsigned int raaecnt;
> +	int c;
> +
> +	raaecnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 12);
> +	c = sysfs_emit(buf, "0x%08x\n", raaecnt);
> +	return c;
> +}

Please remove the variable 'c' from this patch and also from subsequent
patches.

Thanks,

Bart.
