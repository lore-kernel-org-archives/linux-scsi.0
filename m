Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C39BC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 16:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJCQXl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 12:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJCQXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 12:23:32 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233F91DA57
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 09:23:32 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id 3so10099760pga.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Oct 2022 09:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Vupukdl3405ARaMn5EQWDVKDATOUKY3TB+HxVyByscQ=;
        b=dS8/0tWHzJe8PMj4Lb8kuRydrQqRzD8V+qYmDz3ddPaTWNliX+HSsED13sCALaHW/1
         7nP8a/u0Ydx23VOyQBX4pJACEkZDmcPOiaNs8kYIFE3dlN7f4V+/3QwIiXzjdno0FzYP
         LYHSp11XbhiL+klvSC7CeBDKkOv44rp7LhOzCkXDzu6H7CUZFl8NnwIwp4+zeYqAn6QQ
         pm+JzpMK1VZL+VRmmL7a+juynXW1Q3nsEXKAP2axX7HDTrXub5WNWEzbncLoDLsB0Wx7
         YcwQ0yJAuKFzpd+DS/ddt2MqY1079BsnLzpWrnF3N2wU4HkOJselyzJbfx0DtSwamdYK
         91EQ==
X-Gm-Message-State: ACrzQf3jtrho7eCX98BxTNr6NcVN//kXPS2hlQe+yrW4SFVgXyC3TX4x
        udfYzPp6kRFf7xQrp21OOlU=
X-Google-Smtp-Source: AMsMyM6V0kdf9s9j+JupEUdY7rB6+pEEml9+OygkXdIGyAmSNBj+2z6RCSoVIITVjz8EuVpCYGfxuw==
X-Received: by 2002:a63:2b85:0:b0:451:45f5:7223 with SMTP id r127-20020a632b85000000b0045145f57223mr3070441pgr.168.1664814211526;
        Mon, 03 Oct 2022 09:23:31 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id i13-20020a17090a2acd00b0020a8f44e52csm2798615pjg.38.2022.10.03.09.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 09:23:30 -0700 (PDT)
Message-ID: <16a48f60-c754-5924-114b-c23c4f217374@acm.org>
Date:   Mon, 3 Oct 2022 09:23:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v6 6/8] scsi: ufs: Simplify ufshcd_set_dev_pwr_mode()
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220929224421.587465-1-bvanassche@acm.org>
 <20220929224421.587465-7-bvanassche@acm.org>
 <eb9eae96-f9fc-2c5b-4caf-6b5efc00d931@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <eb9eae96-f9fc-2c5b-4caf-6b5efc00d931@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/22 23:28, Adrian Hunter wrote:
> On 30/09/22 01:44, Bart Van Assche wrote:
>> Simplify the code for incrementing the SCSI device reference count in
>> ufshcd_set_dev_pwr_mode(). This patch removes one scsi_device_put() call
>> that happens from atomic context.
>>
>> Cc: Adrian Hunter <adrian.hunter@intel.com>
>> Cc: Avri Altman <avri.altman@wdc.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Not sure what patch set "v6 6/8" refers to, nevertheless:
> 
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

Hi Adrian,

That means that this is the sixth patch of eight in version 6 of the 
patch series that prepares for constifying the SCSI host template. The 
entire patch series is available here: 
https://lore.kernel.org/linux-scsi/20220929224421.587465-1-bvanassche@acm.org/

Anyway, thanks for the review.

Bart.
