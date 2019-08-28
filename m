Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AF6C3A5A3
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 00:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 346DE217F5
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 00:10:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aidYJHA2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfH1AKU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 20:10:20 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40106 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfH1AKU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 20:10:20 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so357134pgj.7
        for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2019 17:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=n6tlfORT7FZz0EVLMrbgpLwevfePKJ9X09+gq+V7YSM=;
        b=aidYJHA2R8UgYN6o4K7MNa16LDbvA/nkUxtlQkWAhckFZ56F7s+Gu8XtioSGtQGfZm
         uUf1AN6kPO0mXodgYGj9bMvJufJTAUJAj1e+AIBFyWSXWxf7IGbYZnDPOakO9m2llpno
         Q4kMYkQ/vlMIKwAYWgsgJsWSQ0Bg+QbE5fXFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=n6tlfORT7FZz0EVLMrbgpLwevfePKJ9X09+gq+V7YSM=;
        b=KwC7e9TKQow37ZkXWHz6dNh/1mWv42qYFwqovEzbo+YADM+vCKSxqeLKmDiGO3ZWJ1
         8RV3062/x2M6Jz0vCMsAwWNYfE1Df2V28ewdZlEOXzyO72kosQjGgC0BV/LDkOtAox9w
         eSXlWGraD6z9niAeGszJByCZ6Crzjh4i+8yWFDt2TZFT/ZvmTlGahm6fdWTanvY9ju7P
         +B3Ec/lqAPAlHigWXcEQ0WvmSpswQnIk3C/dqqDm4h4JxtrkranMb5k0G5rIytiSbNpj
         5co2LJbNgpxxLgx2UNFeInz10hbCw798dzrcMpIZgXmbkxr20A+1PTHtynTgtf4vowqn
         ELKg==
X-Gm-Message-State: APjAAAW08ope90skZBnbaK+maT82vbYHHzdGO4c6NNQETszixRqVrcvd
        jiDdRUR8QBg//j/spw9/JONXpoPb5J7yeNKTBHqeNqW+2Fhga4sMjuaKT9VDKuo6f9D3u+rWwYU
        VJgEb3g7RCwolUQI5mZAs8/CH+EiBC0h16fTEe00cT891riul8gBfNkDHhfxiHYMVm/zBTTKzt/
        10
X-Google-Smtp-Source: APXvYqwyRA8qNAgxZXefu9eYuHTqojJKJApqluGc3WGYiBsBfkTpoiIeN92BtUHSMVH/cHiaJFloxw==
X-Received: by 2002:a17:90a:24cc:: with SMTP id i70mr1497069pje.12.1566951019438;
        Tue, 27 Aug 2019 17:10:19 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a16sm482468pfk.5.2019.08.27.17.10.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 17:10:18 -0700 (PDT)
Subject: Re: [PATCH 00/42] lpfc: Update lpfc to revision 12.4.0.0
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
References: <20190814235712.4487-1-jsmart2021@gmail.com>
 <yq1r25gy1ra.fsf@oracle.com> <878898d7-14ef-ce1b-0d55-8a6da72ecf7e@suse.de>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <fea7b80f-1701-092f-71d7-a4cebe997c23@broadcom.com>
Date:   Tue, 27 Aug 2019 17:10:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <878898d7-14ef-ce1b-0d55-8a6da72ecf7e@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 8/27/2019 6:31 AM, Hannes Reinecke wrote:
> On 8/20/19 5:06 AM, Martin K. Petersen wrote:
>> James,
>>
>>> Update lpfc to revision 12.4.0.0
>> Applied to 5.4/scsi-queue, thanks!
>>
> This update is crashing on my server:
>
> [   33.178690] general protection fault: 0000 [#1] SMP PTI
> [   33.226638] CPU: 0 PID: 297 Comm: kworker/0:5 Tainted: G            E
>      5.3.0-rc1-default+ #311
> [   33.303342] Hardware name: HP ProLiant DL80 Gen9/ProLiant DL80 Gen9,
> BIOS U15 05/21/2018
> [   33.373381] Workqueue: events work_for_cpu_fn
> [   33.410073] RIP: 0010:lpfc_sli4_if6_write_cq_db+0x17/0x40 [lpfc]
>

Hannes,

try this patch.  It appears there was an issue in patch  41:
scsi: lpfc: Merge per-protocol WQ/CQ pairs into single per-cpu pair
commit    c00f62e6c5468ed0673c583f1ff284274e817410

-- james


--- a/drivers/scsi/lpfc/lpfc_sli.c    2019-08-23 13:55:18.253546775 -0700
+++ b/drivers/scsi/lpfc_sli.c    2019-08-27 17:04:51.095330056 -0700
@@ -5553,7 +5553,7 @@ lpfc_sli4_arm_cqeq_intr(struct lpfc_hba
          for (qidx = 0; qidx < phba->cfg_hdw_queue; qidx++) {
              qp = &sli4_hba->hdwq[qidx];
              /* ARM the corresponding CQ */
-            sli4_hba->sli4_write_cq_db(phba, qp[qidx].io_cq, 0,
+            sli4_hba->sli4_write_cq_db(phba, qp->io_cq, 0,
                          LPFC_QUEUE_REARM);
          }

