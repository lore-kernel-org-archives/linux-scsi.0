Return-Path: <SRS0=RKta=WM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6250C3A59C
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Aug 2019 17:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83A4620665
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Aug 2019 17:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfHPRJT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Aug 2019 13:09:19 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44960 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfHPRJT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Aug 2019 13:09:19 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so3230652pgl.11
        for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2019 10:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rByv84a+4PjjzkMpiZltvXrXDCIfYmPU18APbRvVWdo=;
        b=EiiM7Kuk6kpT7JOrkl6M3UQU9xVwRKq2HiTYH2udkPnoOkqBeMFEu6rKfZBlh8eAPv
         ADK2+fe2OA5GATRxSWXnLfpn5vftwJR9WRl0Obfs908WN39CZfALK4blR2vwzaHHAO0y
         +FBxS8gp0ZKlomlzVm3eI9Q77DymO6eOINbOkaJrql4dTYVonUssaXxafKv1D4JDgLgC
         Ey84X90hjUWTAx4dBCYU5alttYruw9xoDC0pZF+ZW6RxvA1vuMH/JE78kS9WUiKc5Jt5
         XzXumoAQj2nRKp+n2TMZyiNyQcCdLkXbMHggrAUOgHFjm9aWKueGyCEI8FQ2KZC94iv7
         9YyQ==
X-Gm-Message-State: APjAAAWWbFU7wUlVhFmKEclWyqvveMX9OXliOwPZDnfZaqBNQwo2uLzg
        uic4tLXNqdiNxFwnDCe8ciE=
X-Google-Smtp-Source: APXvYqzRLvMBzpHjqFo4S17Xbbau+n7TUMs07ZYeOI3tBgGBDKJJapE0rxKp6UDYnj7q62VnV5dt7w==
X-Received: by 2002:a62:642:: with SMTP id 63mr11826742pfg.257.1565975358375;
        Fri, 16 Aug 2019 10:09:18 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id e9sm5545795pja.17.2019.08.16.10.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2019 10:09:17 -0700 (PDT)
Subject: Re: [PATCH v4] SCSI: fix queue cleanup race before
 scsi_requeue_run_queue is done
To:     zhengbin <zhengbin13@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org
Cc:     houtao1@huawei.com, yanaijie@huawei.com
References: <1565667334-22071-1-git-send-email-zhengbin13@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ae7561d6-e61d-c7a1-590b-2071598c0f49@acm.org>
Date:   Fri, 16 Aug 2019 10:09:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565667334-22071-1-git-send-email-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/19 8:35 PM, zhengbin wrote:
> KASAN reports a use-after-free in 4.19-stable,
> which won't happen after commit 47cdee29ef9d
> ("block: move blk_exit_queue into __blk_release_queue").

This patch doesn't apply on top of kernel v4.19.67:

$ git am ~/\[PATCH\ v4\]\ SCSI\:\ fix\ queue\ cleanup\ race\ before\ 
scsi_requeue_run_queue\ is\ done.eml
Applying: SCSI: fix queue cleanup race before scsi_requeue_run_queue is done
error: patch failed: drivers/scsi/scsi_lib.c:531
error: drivers/scsi/scsi_lib.c: patch does not apply
Patch failed at 0001 SCSI: fix queue cleanup race before 
scsi_requeue_run_queue is done

$ patch -p1 < ~/\[PATCH\ v4\]\ SCSI\:\ fix\ queue\ cleanup\ race\ 
before\ scsi_requeue_run_queue\ is\ done.eml
(Stripping trailing CRs from patch; use --binary to disable.)
patching file drivers/scsi/scsi_lib.c
Hunk #1 succeeded at 548 with fuzz 1 (offset 17 lines).
Hunk #2 FAILED at 618.
1 out of 2 hunks FAILED -- saving rejects to file 
drivers/scsi/scsi_lib.c.rej
(Stripping trailing CRs from patch; use --binary to disable.)
patching file drivers/scsi/scsi_sysfs.c
Hunk #1 succeeded at 1392 (offset -18 lines).

Bart.
