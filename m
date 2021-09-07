Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C8BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 22:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1723E6103D
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 22:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346790AbhIGWh0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 18:37:26 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:37503 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhIGWhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 18:37:22 -0400
Received: by mail-pg1-f169.google.com with SMTP id 17so387946pgp.4
        for <linux-scsi@vger.kernel.org>; Tue, 07 Sep 2021 15:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tH4uLiBwjWFT/CMWRtQO2giF6cX3aITMqdtL+QrcFVU=;
        b=APXPTjcTpLzh8+0nFUVBUHU0tdIAh1gjefygfuS6Jh6IqQVAsICGWgv3wgnfDI3Hvf
         ni3B5vj3ANKpqOGOywnl7MgV7EQdq6T0lf4pwUUcsBoB9NqHYV/boZjL489IS6J505eq
         GPiFWUptgVsNW4M1skUFt60jSov125EnPK6XzJcKvUQpxSXqeFnWcBdlpYgbxzV1D3Zx
         nv9eQYVAdtF5WVRQEH3r42ovvi1BHLnOhxZF988cbnJzPTcuPmcGzaGkFXA27OpiE265
         QMNCcBACPb4MeqZosKnmlV5B2vnPSuQht2MJcSEqxZWcbbEQeloeEoVZ9V84DkLjZBJd
         5dfg==
X-Gm-Message-State: AOAM532pE7HZ2t0ddniUoyS5DgjKP99NcZzDGqB5EnuN/OAZ9FOoh00T
        vYIQ8KKHAK24tiTnz6YidB+iZwIlOsQ=
X-Google-Smtp-Source: ABdhPJyKedqgc8qjGXjjGS57qolptCo6vdc2/2sLf8OyJ+LaxUNL+s/6kezGo+HwDCH00k5kfoUDag==
X-Received: by 2002:a65:664f:: with SMTP id z15mr589214pgv.252.1631054174944;
        Tue, 07 Sep 2021 15:36:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:afb7:8aef:79df:4ec5])
        by smtp.gmail.com with ESMTPSA id ml5sm103808pjb.4.2021.09.07.15.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 15:36:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V3 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210905095153.6217-1-adrian.hunter@intel.com>
 <20210905095153.6217-2-adrian.hunter@intel.com>
 <a12d88b3-8402-34bb-fe97-90b7aa2c2c39@acm.org>
 <835c5eab-5a7b-269d-7483-227978b80cd7@intel.com>
 <d9656961-4abb-aff0-e34d-d8082a1f4eaa@acm.org>
Message-ID: <e5307bbe-1cda-fdd2-a666-ae57cd90de07@acm.org>
Date:   Tue, 7 Sep 2021 15:36:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <d9656961-4abb-aff0-e34d-d8082a1f4eaa@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/7/21 9:56 AM, Bart Van Assche wrote:
> On 9/7/21 8:43 AM, Adrian Hunter wrote:
>> No.  Requests cannot make progress when ufshcd_state is
>> UFSHCD_STATE_EH_SCHEDULED_FATAL, and only the error handler can change 
>> that,
>> so if the error handler is waiting to enter the queue and 
>> blk_mq_freeze_queue()
>> is waiting for outstanding requests, they will deadlock.
> 
> How about adding the above text as a comment above 
> ufshcd_clear_ua_wluns() such
> that this information becomes available to those who have not followed this
> conversation?

After having given patch 1/3 some further thought: an unfortunate
effect of this patch is that unit attention clearing is skipped for
the states UFSHCD_STATE_EH_SCHEDULED_FATAL and UFSHCD_STATE_RESET.
How about replacing patch 1/3 with the untested patch below since that
patch does not have the disadvantage of sometimes skipping clearing UA?

Thanks,

Bart.

[PATCH] scsi: ufs: Fix a recently introduced deadlock

Completing pending commands with DID_IMM_RETRY triggers the following
code paths:

   scsi_complete()
   -> scsi_queue_insert()
     -> __scsi_queue_insert()
       -> scsi_device_unbusy()
         -> scsi_dec_host_busy()
	  -> scsi_eh_wakeup()
       -> blk_mq_requeue_request()

   scsi_queue_rq()
   -> scsi_host_queue_ready()
     -> scsi_host_in_recovery()

Fixes: a113eaaf8637 ("scsi: ufs: Synchronize SCSI and UFS error handling")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/ufs/ufshcd.c | 8 ++++++++
  1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c2c614da1fb8..9560f34f3d27 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2707,6 +2707,14 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
  		}
  		fallthrough;
  	case UFSHCD_STATE_RESET:
+		/*
+		 * The SCSI error handler only starts after all pending commands
+		 * have failed or timed out. Complete commands with
+		 * DID_IMM_RETRY to allow the error handler to start
+		 * if it has been scheduled.
+		 */
+		set_host_byte(cmd, DID_IMM_RETRY);
+		cmd->scsi_done(cmd);
  		err = SCSI_MLQUEUE_HOST_BUSY;
  		goto out;
  	case UFSHCD_STATE_ERROR:
