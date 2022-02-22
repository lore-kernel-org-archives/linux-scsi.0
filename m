Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232A1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbiBVOtg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbiBVOtf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:49:35 -0500
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9202739
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:49:10 -0800 (PST)
Received: by mail-pg1-f171.google.com with SMTP id 139so17227293pge.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:49:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R4dYWKRYzXxYGjdWDLdpCweyTDlvaaecQRxApktmJe8=;
        b=Mzi+iViUWYp5fC/Ip9sbDqXqdpr8YoTyPX510LoeqBwnUHoD376ZcUaA/IgbYhjs+J
         Me9xkaX2PLSL2f/pS2a4EGXuhQKpTEsfUfdntsPRWRB+ydhDQSg7fs5KOZnRV6Z60KIU
         wJWdTvY8EVoDy37w2A3rUIp/OlQHMTjRKpykfg2Orve3K2BIIbcrfc+dIvR8++wl13T6
         W3g+W1adK9Ahb2ZIKhgUHpXTqXVpe1XhatJZ9z/Qma6aKggoOdp7oht6qnJWadLfgZq9
         NbERiIoDiwnl2Mkc2p+5fBFvllzLZve0eXLVi0yh8xwJf0xApMgsR96wPwUd8VlkCZZm
         Oi3A==
X-Gm-Message-State: AOAM530DdMDSV+gcyjO7tBDLMKGBRKMhYPny2HgKzPnPZDx7iQTPRRGe
        iGy6ZhOjX+L/xsly6hAFmLQ=
X-Google-Smtp-Source: ABdhPJyFT7v1ldvF0lMfmh3KBDoGOWekogom+PBYYkOzKAfjhJegVkZpAx6zAJcIw8FENL97zXbuLQ==
X-Received: by 2002:a65:52cc:0:b0:374:3ee6:c632 with SMTP id z12-20020a6552cc000000b003743ee6c632mr8377915pgp.91.1645541349481;
        Tue, 22 Feb 2022 06:49:09 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k15sm3125641pff.36.2022.02.22.06.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 06:49:08 -0800 (PST)
Message-ID: <7e4b8b8a-f6fe-159a-03d7-e7b847704274@acm.org>
Date:   Tue, 22 Feb 2022 06:49:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH V3] scsi: ufs: Fix runtime PM messages never-ending cycle
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20220216075122.370532-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220216075122.370532-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/22 23:51, Adrian Hunter wrote:
>   drivers/scsi/scsi_error.c  |  9 +++++++--
>   drivers/scsi/sd.c          |  7 +++++--
>   drivers/scsi/ufs/ufshcd.c  | 21 +++++++++++++++++++--
>   include/scsi/scsi_device.h |  1 +
>   4 files changed, 32 insertions(+), 6 deletions(-)

For future patch submissions, please separate SCSI core changes from 
SCSI driver changes. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
