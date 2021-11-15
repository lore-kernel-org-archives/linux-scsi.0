Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACEDC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 18:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A81906339E
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 18:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242622AbhKOSuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:50:14 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:36553 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242435AbhKOSsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 13:48:01 -0500
Received: by mail-pf1-f176.google.com with SMTP id n26so11214213pff.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 10:45:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uiT/vs9z+DUShfw3eHPESY5K31JkU6zBXFWnb7NL9w8=;
        b=I0HvNLMasheKssTdK5l3SdurtI/BdudNYNL3xgMY9dfWnleadW3lZWLZbedKgLBIJF
         9MHnPYLWAdI3E/1ZcQoKwp6hNbso+rFGb9YqK/RhAivHBcfodAcrI9h8xlbeWagTua6H
         S2zqLOi6RdJlJ2dBKp4HHepsvfHY8MnpaBwdesjQI9QUYutPTUT8bSr0MGc/mShAqV+6
         k6OWzorz7HmOzYxWes0WIlFUonl2ZJzbbJ/q8Uwz1QWIRx6aPKnXr5Hq8UEqwfLwQJNp
         N09h9caZX5kVDF+F9at9cIotl/7kxSUPMrPh2L9gqkcZDdAZheQsKkDRDHavWmvHpBw4
         7USw==
X-Gm-Message-State: AOAM530cvong6bzBqU9FJUq0A9O659aTn9GWHAtaaBl+SBqc/3cayjiL
        62Pe3WYZl8tBIWNor7zNDmE=
X-Google-Smtp-Source: ABdhPJynuJPzJVNSw3SJs8OIJy3a5wbyeFDUxA5Fy+c8YXXo0TL4houiBjZaiebP5H03t8Ep38dGoQ==
X-Received: by 2002:a05:6a00:2313:b0:49f:d9ec:7492 with SMTP id h19-20020a056a00231300b0049fd9ec7492mr35308398pfh.25.1637001905991;
        Mon, 15 Nov 2021 10:45:05 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c779:caf7:7b7f:3ecd])
        by smtp.gmail.com with ESMTPSA id p15sm82641pjh.1.2021.11.15.10.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 10:45:05 -0800 (PST)
Subject: Re: [PATCH 09/11] scsi: ufs: Fix a kernel crash during shutdown
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-10-bvanassche@acm.org>
 <DM6PR04MB6575527579A03182E4AA8F0AFC949@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f5539015-0a56-64cc-1b2e-a94e49559f3c@acm.org>
Date:   Mon, 15 Nov 2021 10:45:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575527579A03182E4AA8F0AFC949@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/21 11:48 PM, Avri Altman wrote:
>> @@ -1961,11 +1962,15 @@ static void ufshcd_exit_clk_gating(struct ufs_hba
>> *hba)  {
>>          if (!hba->clk_gating.is_initialized)
>>                  return;
>> +
>>          ufshcd_remove_clk_gating_sysfs(hba);
>> -       cancel_work_sync(&hba->clk_gating.ungate_work);
>> -       cancel_delayed_work_sync(&hba->clk_gating.gate_work);
>> -       destroy_workqueue(hba->clk_gating.clk_gating_workq);
>> +
>> +       /* Ungate the clock if necessary. */
>> +       ufshcd_hold(hba, false);
>>          hba->clk_gating.is_initialized = false;
>> +       ufshcd_release(hba);
 >
> Not sure that the symmetry in calling ufshcd_release() is meaningful here?
> You don't really want to queue a new gate work, this is why you added !.is_initialized to release(),
> Or did I get it wrong?

Hi Avri,

The purpose of the above changes is as follows:
* Call ufshcd_hold() to ungate the clock and also to wait for any 
pending work.
* Change hba->clk_gating.is_initialized from true to false to make sure 
that the clock remains ungated and also that no new work is queued.
* Call ufshcd_release() to decrement hba->clk_gating.active_reqs.

Thanks,

Bart.
