Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB65C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Sep 2021 02:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E6B361103
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Sep 2021 02:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbhISC10 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Sep 2021 22:27:26 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:42875 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbhISC1Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Sep 2021 22:27:25 -0400
Received: by mail-pf1-f179.google.com with SMTP id q23so10802329pfs.9
        for <linux-scsi@vger.kernel.org>; Sat, 18 Sep 2021 19:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TckyFdFsXhDjL8SVYh4ORhMvCvTGSUGiXz9jz3hd4DE=;
        b=PHe//R80NMsiVrw+Ljb5DYkSwKgsnvA4W6IBeNDHjtFL6foR+70ZWK+m9Kf7k7rFra
         eUvkG1u048ZUUY1ktOdi09R20B/MSKgB/qFNvgaLWzCVWvFsZyfpZueyUQ+nHY0Tfwbx
         4kWfEXSdVGxAy3D87UPN7xhMmxdWB2KvErCUjR7jozMHBKl2eVKqBcJbtD7oQ6HwplZJ
         7pWTdrbUGxZZL/NOIyQZcQ97yRW/KbI8qupAm3gH3hv519Grr2SCfMx8vCLP+XxmNHSl
         wb060Wx+J+NXTdOBXNiNXWw7IOFNxZTBI9YMpswhNRMh+J4X9EpO9uz/E5xXfPWk2Q2M
         FB7Q==
X-Gm-Message-State: AOAM530swfslWnGa4+ExStmjYRvfqQNsZto5uR+SeghbEWdDxygP4MJd
        rEXAfNmr1s2ygMiTld/fwNmQTw27Kjo=
X-Google-Smtp-Source: ABdhPJz/sAimdmU4vOuEBA2LsLfAKdQKP/kvEkZse3Q0dM6JifI2h4DuZk6UWCcMoWBEB0wsK4wKLg==
X-Received: by 2002:a63:914a:: with SMTP id l71mr6451559pge.463.1632018360465;
        Sat, 18 Sep 2021 19:26:00 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:8557:823d:34a5:4f8c? ([2601:647:4000:d7:8557:823d:34a5:4f8c])
        by smtp.gmail.com with ESMTPSA id j16sm10765668pfi.165.2021.09.18.19.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 19:25:59 -0700 (PDT)
Message-ID: <9f68887b-e499-ec29-9ebe-207c6c515cd3@acm.org>
Date:   Sat, 18 Sep 2021 19:25:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH 33/84] fas216: Call scsi_done() directly
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-34-bvanassche@acm.org>
 <YUUx47L7W9qGGOwz@shell.armlinux.org.uk>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YUUx47L7W9qGGOwz@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/17/21 17:25, Russell King (Oracle) wrote:
> NAK. I don't think you've bothered to read the driver code to check
> that your change is safe to make.
> 
> SCpnt->scsi_done is not always "scsi_done" but may also be
> fas216_internal_done().

Thanks for the quick feedback. How about replacing this patch by the
two patches below?

[PATCH 1/2] fas216: Introduce struct fas216_cmd_priv

Introduce a structure with driver-private data per SCSI command. This data
structure will be used by the next patch to store a function pointer.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/arm/arxescsi.c |  1 +
  drivers/scsi/arm/cumana_2.c |  1 +
  drivers/scsi/arm/eesox.c    |  1 +
  drivers/scsi/arm/fas216.h   | 10 ++++++++++
  drivers/scsi/arm/powertec.c |  2 +-
  5 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 591414120754..7f667c198f6d 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -243,6 +243,7 @@ static struct scsi_host_template arxescsi_template = {
  	.eh_bus_reset_handler		= fas216_eh_bus_reset,
  	.eh_device_reset_handler	= fas216_eh_device_reset,
  	.eh_abort_handler		= fas216_eh_abort,
+	.cmd_size			= sizeof(struct fas216_cmd_priv),
  	.can_queue			= 0,
  	.this_id			= 7,
  	.sg_tablesize			= SG_ALL,
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 9dcd912267e6..3c00d7773876 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -363,6 +363,7 @@ static struct scsi_host_template cumanascsi2_template = {
  	.eh_bus_reset_handler		= fas216_eh_bus_reset,
  	.eh_device_reset_handler	= fas216_eh_device_reset,
  	.eh_abort_handler		= fas216_eh_abort,
+	.cmd_size			= sizeof(struct fas216_cmd_priv),
  	.can_queue			= 1,
  	.this_id			= 7,
  	.sg_tablesize			= SG_MAX_SEGMENTS,
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 5eb2415dda9d..1394590eecea 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -480,6 +480,7 @@ static struct scsi_host_template eesox_template = {
  	.eh_bus_reset_handler		= fas216_eh_bus_reset,
  	.eh_device_reset_handler	= fas216_eh_device_reset,
  	.eh_abort_handler		= fas216_eh_abort,
+	.cmd_size			= sizeof(struct fas216_cmd_priv),
  	.can_queue			= 1,
  	.this_id			= 7,
  	.sg_tablesize			= SG_MAX_SEGMENTS,
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index 847413ce14cf..abf960487314 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -310,6 +310,16 @@ typedef struct {
  	unsigned long		magic_end;
  } FAS216_Info;

+/* driver-private data per SCSI command. */
+struct fas216_cmd_priv {
+	void (*scsi_done)(struct scsi_cmnd *cmd);
+};
+
+static inline struct fas216_cmd_priv *fas216_cmd_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
  /* Function: int fas216_init (struct Scsi_Host *instance)
   * Purpose : initialise FAS/NCR/AMD SCSI structures.
   * Params  : instance - a driver-specific filled-out structure
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 9cc73da4e876..8fec435cee18 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -286,7 +286,7 @@ static struct scsi_host_template powertecscsi_template = {
  	.eh_bus_reset_handler		= fas216_eh_bus_reset,
  	.eh_device_reset_handler	= fas216_eh_device_reset,
  	.eh_abort_handler		= fas216_eh_abort,
-
+	.cmd_size			= sizeof(struct fas216_cmd_priv),
  	.can_queue			= 8,
  	.this_id			= 7,
  	.sg_tablesize			= SG_MAX_SEGMENTS,






[PATCH 2/2] fas216: Stop using scsi_cmnd.scsi_done

Store the completion callback pointer in struct fas216_cmd_priv instead of in
struct scsi_cmnd. This patch prepares for removal of the scsi_done member
from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/arm/fas216.c | 8 ++++----
  1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index bbb8635782b1..9926383f79ea 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2017,7 +2017,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
  	 * correctly by fas216_std_done.
  	 */
  	scsi_eh_restore_cmnd(SCpnt, &info->ses);
-	SCpnt->scsi_done(SCpnt);
+	fas216_cmd_priv(SCpnt)->scsi_done(SCpnt);
  }

  /**
@@ -2088,8 +2088,8 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
  	}

  done:
-	if (SCpnt->scsi_done) {
-		SCpnt->scsi_done(SCpnt);
+	if (fas216_cmd_priv(SCpnt)->scsi_done) {
+		fas216_cmd_priv(SCpnt)->scsi_done(SCpnt);
  		return;
  	}

@@ -2205,7 +2205,7 @@ static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
  	fas216_log_command(info, LOG_CONNECT, SCpnt,
  			   "received command (%p)", SCpnt);

-	SCpnt->scsi_done = done;
+	fas216_cmd_priv(SCpnt)->scsi_done = done;
  	SCpnt->host_scribble = (void *)fas216_std_done;
  	SCpnt->result = 0;

