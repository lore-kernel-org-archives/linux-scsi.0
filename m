Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF24C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 17:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 647ED611C4
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 17:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240611AbhKHRgP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 12:36:15 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:38526 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhKHRgO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 12:36:14 -0500
Received: by mail-pg1-f174.google.com with SMTP id e65so15771697pgc.5
        for <linux-scsi@vger.kernel.org>; Mon, 08 Nov 2021 09:33:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R7q8KfsebRwXOASev/NCR30rhLTihizwEcNJChv4TzU=;
        b=HGrf+/kvvpGsGuq5DzLPpCIIv0zpHbiOsQLOR9AGKuRKHj1id5A6v9TugPrzEnYeoE
         QpJ8huD5IyfoHW+oAEzmA1BECIyUAkKjpq6JwfAlEArLUz+YyxiCpY+PAo6db2uLPW0+
         IlRYpCJYvv+iZ0dhgMg1lFZEMOMWbX3bqVv+kNOiriX0SjODrFPpozBcKpvO7PFJ9jnS
         gNiaA8daa7832MAniWbi4MlSrzqNpWcz0FPmlYDvEJkJLBLApYG2dAx9t+8IlUcx9zQx
         7NGU3tkjNHi6WU8iFIzhtLYsdPBak3ecda+xJ6HDz+z3/dx6s3RTY8a2KDGwzJr1N8JG
         GkEA==
X-Gm-Message-State: AOAM530upPw6l/ogsXz/m1tfbo28Mld7eYgtK8JK+9IrxkyFW2rAOW1W
        QUZC0a7M1FbTA7sRhdAOmj5pg+gupnB/jg==
X-Google-Smtp-Source: ABdhPJyi6vPIuUJ/eLCzpt2OBf12Su83o9I/0AdOUUu4c9hHjSfKebFqrKR7gQuKOvGCz+tKI0h33g==
X-Received: by 2002:a65:6187:: with SMTP id c7mr797162pgv.317.1636392809306;
        Mon, 08 Nov 2021 09:33:29 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4ca8:59a2:ad3c:1580])
        by smtp.gmail.com with ESMTPSA id s7sm17394871pfu.139.2021.11.08.09.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 09:33:28 -0800 (PST)
Subject: Re: [PATCH V2 2/2] scsi: ufs: core: Fix another task management
 completion race
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20211108064815.569494-1-adrian.hunter@intel.com>
 <20211108064815.569494-3-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ce0ef241-3273-ad7d-4c7f-d596a18f1fa7@acm.org>
Date:   Mon, 8 Nov 2021 09:33:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211108064815.569494-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/7/21 10:48 PM, Adrian Hunter wrote:
> hba->outstanding_tasks, which is read under host_lock spinlock, tells
> the interrupt handler what task management tags are in use by the driver.
> The doorbell register bits indicate which tags are in use by the hardware.
> A doorbell bit that is 0 is because the bit has yet to be set by the
> driver, or because the task is complete. It is only possible to
> disambiguate the 2 cases, if reading/writing the doorbell register is
> synchronized with reading/writing hba->outstanding_tasks.
> 
> For that reason, reading REG_UTP_TASK_REQ_DOOR_BELL must be done under
> spinlock.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
