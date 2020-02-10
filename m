Return-Path: <SRS0=AJIY=36=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3480BC352A4
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 22:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1314120838
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 22:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgBJWho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Feb 2020 17:37:44 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53668 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbgBJWhn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2020 17:37:43 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so405062pjc.3;
        Mon, 10 Feb 2020 14:37:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+NKc2eqBvuM0AeetM6q1NWqQqln7AMJ5LoTTPZHP820=;
        b=qdjLcA5Mi1iPbfEtr8DsWVQbxt0mKewfHjp1rTyQ6v0wtqlO3FdCwcQnbYdL3UNLuf
         f0EcVrC84xF4Y6oGmbIYPlnL2PQPH3BzXkCsiz7iJyUWjMcgRRvos7rOdWCJ2ocbOjWs
         mfDarWxj6d0gAO3/sA1AoaKOgbLZ8w8lUmL9MlF2BTpGnhlYmeUpcWIGJh8lzCwvjau0
         CMFqIbQ2zV4m9UvWFPOA5GtvZTyWYLeiqvdxC8Gcijraz98zlfvV1IiY2Qd74KJpZH+x
         7iIwQrHBhj3KM5ARQDb42G3B2+2Sph8zL6jYB2As97OaxfJNp88uXoo1LYN3U66v7uX+
         bUnQ==
X-Gm-Message-State: APjAAAXIPCmtcb3JwOWui634mlfZr4Ymje/dpChuKGcDzb3ginwHyh7p
        04XR1WtYjBZAEAOWWUV72YmG1JB4
X-Google-Smtp-Source: APXvYqxd6U2nCAMk2DIweZJkaPO//4UyStk4BkoI2Itm+aqAEEv2B43CrzANn658jVPQ3EGxpqUKVA==
X-Received: by 2002:a17:90a:a881:: with SMTP id h1mr106612pjq.50.1581374260913;
        Mon, 10 Feb 2020 14:37:40 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id l7sm1197876pga.27.2020.02.10.14.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2020 14:37:40 -0800 (PST)
Subject: Re: [PATCH] scsi: Delete scsi_use_blk_mq
To:     John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1581355992-139274-1-git-send-email-john.garry@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3795ab1d-5282-458b-6199-91e3def32463@acm.org>
Date:   Mon, 10 Feb 2020 14:37:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1581355992-139274-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/10/20 9:33 AM, John Garry wrote:
> -module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);

Will this change cause trouble to shell scripts that set or read this 
parameter (/sys/module/scsi_mod/parameters/use_blk_mq)? What will the 
impact be on systems where scsi_mod.use_blk_mq=Y is passed by GRUB to 
the kernel at boot time, e.g. because it has been set in the 
GRUB_CMDLINE_LINUX variable in /etc/default/grub?

Thanks,

Bart.
