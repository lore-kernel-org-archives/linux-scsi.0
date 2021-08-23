Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62D2C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 11:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F066136F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 11:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbhHWLcp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 07:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbhHWLcp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 07:32:45 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0E1C061575;
        Mon, 23 Aug 2021 04:32:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id oa17so11767538pjb.1;
        Mon, 23 Aug 2021 04:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=fpst6WuiQvBEVS+61khIq6Qn59v3bAx5r84xd9neoMk=;
        b=ZXFZtnmlRbRNWTqvikszENKBieQd35ESzS9296CIGG2zWnHk3BOBuc1+xL4HEDrYcD
         EeRCMwimMOt0yiiACpgUh1cNb9wnSoFjf6YD+HufOuBxpFGn1w+P/NKuF35uJIsQ9voJ
         RlhQjnuEEKgs3Q2YiFz6Bfh2wcnl2WoVqu2tWwgIht4ygvn4zaf7VlglnNVJphqXXG22
         zjVgBMokhcYAqoDJRakUaH5HDuTtF68MLKFNP8br+IZsKjlpxvOsnIQda0Y/qX/VYaQj
         fngsPFhAiRqUtiz+dQllgjCXHJnEzGYkt5i9W2GJAReNIBSatkdELmm2Fc1iNSgQyN0C
         fIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=fpst6WuiQvBEVS+61khIq6Qn59v3bAx5r84xd9neoMk=;
        b=t1b47HXdLBVBH0uFPLv6swT/6/CJ2jSJu9Ej8ghO/4C0WC+ZZpPnR/KdyNXFkGYEL6
         hpHejw9vQ10OricdpjO/vZZtqMXTONca2i7icj0K4gewbBtYwxNiEIr6C3uiVraNkzHb
         UBH7NVWipGgNpVmazRfg3r9BeuMLV6uarOhDM7b4BZOt4lN1+sPzb5Ut3h4kv0BnPWFz
         N7hCyhfG+bUYsK+/nmi6I6OTfqlbMjQMJcGdEEGLezk2uylUWM3AZrVnpjjV7nBZTdZp
         r8p7tbsts4TDhvWV/3ul9bDgoB3A+HiU3g7cJoe4cuIsxyQV7I5ChrgRg0yobYJkq1VV
         rgIA==
X-Gm-Message-State: AOAM531VNpIoHRCYc/TTzfm/HvTJRVig8CAZOQMCZdlbYafmVBRibKsE
        qDPHfbazchq81dd2lZTgNNrXiphweS0=
X-Google-Smtp-Source: ABdhPJwT6uVwEp9Yshmg5oZSqg1c0Grxk4iqgeSykqU8fgbSWW+ByTwDeFMm2hlAeheMspfcWEfclg==
X-Received: by 2002:a17:902:8c83:b029:129:17e5:a1cc with SMTP id t3-20020a1709028c83b029012917e5a1ccmr28041269plo.49.1629718319649;
        Mon, 23 Aug 2021 04:31:59 -0700 (PDT)
Received: from [10.18.0.46] ([85.203.23.7])
        by smtp.gmail.com with ESMTPSA id k25sm15741438pfa.213.2021.08.23.04.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 04:31:59 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] scsi: lpfc: possible ABBCCA deadlock involving three threads
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <af74e7e6-13dc-0695-e9e2-7dcd758d92f0@gmail.com>
Date:   Mon, 23 Aug 2021 19:31:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

My static analysis tool reports a possible ABBCCA deadlock in the lpfc 
driver in Linux 5.10:

lpfc_els_flush_cmd()
   spin_lock(&pring->ring_lock); --> line 8124 (Lock A)
   lpfc_sli_cancel_iocbs()
     lpfc_sli_release_iocbq()
       spin_lock_irqsave(&phba->hbalock, iflags); --> line 1384 (Lock B)

lpfc_sli_abort_taskmgmt()
   spin_lock_irqsave(&phba->hbalock, iflags); --> line 11812 (Lock B)
   spin_lock(&lpfc_cmd->buf_lock); --> line 11830 (Lock C)

lpfc_abort_handler()
   spin_lock(&lpfc_cmd->buf_lock); --> line 4760 (Lock C)
   spin_lock(&pring_s4->ring_lock); --> line 4777 (Lock A)

When lpfc_els_flush_cmd(), lpfc_sli_abort_taskmgmt() and 
lpfc_abort_handler() are concurrently executed, the deadlock can occur.

I am not quite sure whether this possible deadlock is real and how to 
fix it if it is real.
Any feedback would be appreciated, thanks :)

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>


Best wishes,
Jia-Ju Bai
