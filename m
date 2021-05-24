Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFA8C2B9F7
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 20:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7AAE613EA
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 20:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhEXUM0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 16:12:26 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:44630 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbhEXUM0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 16:12:26 -0400
Received: by mail-pg1-f173.google.com with SMTP id 29so9825853pgu.11;
        Mon, 24 May 2021 13:10:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cZcmrRKl8MZj6EByHFj+TpMs1Z1/LuL5LS/wikT3fk4=;
        b=rvq1lpXbXok9aDhT19RncQHuVnr6owjZ/maJaGE4OhJ0yfJ8D4kUAb7o54bh4OfDzH
         Y9YFhpt0hMDHUQ3oJWYggkwavwqQtEVTTy7jWP/LBD5t0DFOty6CrQes0VIsF9+Zj9Fv
         H5R+0Fge0hX/8gv/6Nci5RLBOWOQZ4guTEw1cD8K0AMYUYR4iNuFTPVlvtvQd3I9lP3f
         PeGJ8QBqqyfviUXlpGNYfpSsWTm/r3gLSmzOGOxd6Nx/fsmemD44fkOTrYJJsIeIrJaW
         QIeYIi7xyP7pJzbUo+2XmnfqVTw5++PwWNN2Kt/qiX71nZmG1IkgCG6GwNkePhA2DNUD
         Lb+w==
X-Gm-Message-State: AOAM532pf1qk8tHz8O1RqRiXXtXdIL6pkqqtcfMHnc9JpeoaSmywkOhm
        R8adyZYco3h53jcUONvgMzs=
X-Google-Smtp-Source: ABdhPJxD4+pUlQXbF50GPoHknO4liqzl56WqMATugX+MXNqgIs5tXgBUmR5SEERjMs7Ux8i4dGIotQ==
X-Received: by 2002:aa7:9aed:0:b029:2e1:fdad:ac11 with SMTP id y13-20020aa79aed0000b02902e1fdadac11mr24869896pfp.58.1621887056093;
        Mon, 24 May 2021 13:10:56 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w125sm11621528pfw.214.2021.05.24.13.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 13:10:55 -0700 (PDT)
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-3-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <41a08b3e-122d-4f1a-abbd-4b5730f880b2@acm.org>
Date:   Mon, 24 May 2021 13:10:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1621845419-14194-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/21 1:36 AM, Can Guo wrote:
> Current UFS IRQ handler is completely wrapped by host lock, and because
> ufshcd_send_command() is also protected by host lock, when IRQ handler
> fires, not only the CPU running the IRQ handler cannot send new requests,
> the rest CPUs can neither. Move the host lock wrapping the IRQ handler into
> specific branches, i.e., ufshcd_uic_cmd_compl(), ufshcd_check_errors(),
> ufshcd_tmc_handler() and ufshcd_transfer_req_compl(). Meanwhile, to further
> reduce occpuation of host lock in ufshcd_transfer_req_compl(), host lock is
> no longer required to call __ufshcd_transfer_req_compl(). As per test, the
> optimization can bring considerable gain to random read/write performance.

Hi Can,

Using the host lock to serialize the completion path against the
submission path was a common practice 11 years ago, before the host lock
push-down (see also
https://linux-scsi.vger.kernel.narkive.com/UEmGgwAc/rfc-patch-scsi-host-lock-push-down).
Modern SCSI LLDs should not use the SCSI host lock. Please consider
introducing one or more new synchronization objects in struct ufs_hba
and to use these instead of the SCSI host lock. That will save multiple
pointer dereferences in the hot path since hba->host->host_lock will
become hba->new_spin_lock.

An additional question is whether it is necessary for v3.0 UFS devices
to serialize the submission path against the completion path? Multiple
high-performance SCSI LLDs support hardware with separate submission and
completion queues and hence do not need any serialization between the
submission and the completion path. I'm asking this because it is likely
that sooner or later multiqueue support will be added in the UFS
specification. Benefiting from multiqueue support will require to rework
locking in the UFS driver anyway.

Thanks,

Bart.
