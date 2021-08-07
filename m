Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A615C4338F
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 18:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53B0261057
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 18:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhHGSJw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 14:09:52 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:46719 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhHGSJw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 14:09:52 -0400
Received: by mail-pl1-f177.google.com with SMTP id k2so11620679plk.13
        for <linux-scsi@vger.kernel.org>; Sat, 07 Aug 2021 11:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tZzmRxzt0VE6W84i4AswQkTsmvNClx5onOdSgeCGFiA=;
        b=WOXn93kFAXBNXk3obtbO8JKA5ailEBOi7Bp7DCyszODvNBwkhmWS/zk17KAog6x1SX
         HWUyAxgwO69AZUtpA5nL3/DxwTmsp+IiD27cIng33bLQYQZUNkJjf60w28Zma3pToy3i
         m9VKILrW6tvgOmsHA1bTHVa+Qa2nhZIWl8nIhNZi81C/eQMPa2CkcnnceZxGzksXo6Qs
         KE0+MoO56dyeZJp3/8PTbMdSXW8IZ4Byircb0uNZNl1meMo7QPpTbYYcbzXMGjtojQ6s
         1C7bDze0KQJlNWeU3W8zeMnvRA5Qe8U4zNd/MbsGL7E/oJJhOuRXp+kJ2+StGE4VfVIw
         a4+w==
X-Gm-Message-State: AOAM531ySPUPMifsU5vmwQ1UB2Z1Q/FUKRNj9uUl5cgwf9quTKAqAB7A
        ZlueL9111kpDczkmuN1qoo12tjM3hSg=
X-Google-Smtp-Source: ABdhPJz2fhrUpCX7voB/gD/SWUhOkS3rxH/5sZPKAS5GEKlrOGKTVV27UWN0xl9wUQBvOSGxJ1G0GA==
X-Received: by 2002:a63:f050:: with SMTP id s16mr276001pgj.258.1628359774177;
        Sat, 07 Aug 2021 11:09:34 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:e0e1:c61c:7863:f2a1? ([2601:647:4000:d7:e0e1:c61c:7863:f2a1])
        by smtp.gmail.com with ESMTPSA id p21sm10682973pfo.8.2021.08.07.11.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Aug 2021 11:09:33 -0700 (PDT)
Subject: Re: [PATCH v4 12/52] NCR5380: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@linux-m68k.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210805191828.3559897-1-bvanassche@acm.org>
 <20210805191828.3559897-13-bvanassche@acm.org>
 <b2ff95ac-49b2-6967-799-66bf23d3b7e@linux-m68k.org>
 <041a2d03-c37e-288c-c042-95b825bf2fbc@acm.org>
 <5ec19a0b-d49c-8f6d-9452-f8b1a43f2a22@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <db7a1272-d36b-2556-cbe8-a62dd0a6d3d2@acm.org>
Date:   Sat, 7 Aug 2021 11:09:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <5ec19a0b-d49c-8f6d-9452-f8b1a43f2a22@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/6/21 1:24 PM, Michael Schmitz wrote:
> Am 07.08.2021 um 03:56 schrieb Bart Van Assche:
>> On 8/6/21 2:24 AM, Finn Thain wrote:
>>> On Thu, 5 Aug 2021, Bart Van Assche wrote:
>>>
>>>> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
>>>> instead. This patch does not change any functionality.
>>>>
>>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>>
>>> Acked-by: Finn Thain <fthain@linux-m68k.org>
>>>
>>> Did you consider replacing rq_data_dir(cmd->request) with
>>> cmd->sc_data_direction for this driver?
>>
>> That's an interesting suggestion but I prefer to minimize the number of
>> changes I make in NCR5380 drivers since I do not have access to a setup
>> on which I can test any of these drivers.
> 
> The NCR5380 driver gets frequent testing on my Atari, so unless it's
> something integration specific, we ought to see any regressions there.

How about replacing patch 12/52 with the (totally untested) patch below?

Thanks,

Bart.


Subject: [PATCH] NCR5380: Use sc_data_direction instead of rq_data_dir()

This patch prepares for the removal of the request pointer from struct
scsi_cmnd and does not change any functionality.

Suggested-by: Finn Thain <fthain@linux-m68k.org>
Cc: Finn Thain <fthain@linux-m68k.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/NCR5380.c   | 6 +++---
 drivers/scsi/sun3_scsi.c | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 3baadd068768..a85589a2a8af 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -778,7 +778,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
 	}

 #ifdef CONFIG_SUN3
-	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request)))) {
+	if (sun3scsi_dma_finish(hostdata->connected->sc_data_direction)) {
 		pr_err("scsi%d: overrun in UDC counter -- not prepared to deal with this!\n",
 		       instance->host_no);
 		BUG();
@@ -1710,7 +1710,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				count = sun3scsi_dma_xfer_len(hostdata, cmd);

 				if (count > 0) {
-					if (rq_data_dir(cmd->request))
+					if (cmd->sc_data_direction == DMA_TO_DEVICE)
 						sun3scsi_dma_send_setup(hostdata,
 						                        cmd->SCp.ptr, count);
 					else
@@ -2158,7 +2158,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		count = sun3scsi_dma_xfer_len(hostdata, tmp);

 		if (count > 0) {
-			if (rq_data_dir(tmp->request))
+			if (tmp->sc_data_direction == DMA_TO_DEVICE)
 				sun3scsi_dma_send_setup(hostdata,
 				                        tmp->SCp.ptr, count);
 			else
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 2e3fbc2fae97..af71ab112a84 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -366,10 +366,11 @@ static inline int sun3scsi_dma_start(unsigned long count, unsigned char *data)
 }

 /* clean up after our dma is done */
-static int sun3scsi_dma_finish(int write_flag)
+static int sun3scsi_dma_finish(enum dma_data_direction data_dir)
 {
 	unsigned short __maybe_unused count;
 	unsigned short fifo;
+	const bool write_flag = data_dir == DMA_TO_DEVICE;
 	int ret = 0;
 	
 	sun3_dma_active = 0;
