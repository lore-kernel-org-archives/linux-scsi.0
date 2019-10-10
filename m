Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349DAC4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 17:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1093121835
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 17:49:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dP7TS4M2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfJJRty (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Oct 2019 13:49:54 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43345 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfJJRty (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2019 13:49:54 -0400
Received: by mail-pg1-f193.google.com with SMTP id i32so4121991pgl.10
        for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2019 10:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LApmN2EK3uLlyTq9P9EB8Aq1G4SEX1zZlU6ES0o1nJo=;
        b=dP7TS4M2TEHNoGLCTTGDuieQZzssBfVoCe8Pzat71EQyXDEdflnETlFy4xJyMemCha
         bWrCOyY4txjJ0PkdSBfrTsNcAZPn8f+F6B0GU+fAkD83h5/xYDa53PJLELTtOl3VEbsS
         x1xWm1ZHEh1ZcGxKXSzbUdnpMiFjD7BMC25oWft6SE53AmhPt5KpV7w1Z5aJENXjHM40
         CiTJ3ugCwebE/N0zFY4uBvjGrT5gnckOB8VudAaABUbyWODGcS8Une6G9plib2Xv1dTR
         34UCmIWe9vRiFvqYC9j2TblBI9kM3G6Ht1t8JB3m3D7GtZ9luqf4UNhHiF0Iu3QEam2u
         zeBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LApmN2EK3uLlyTq9P9EB8Aq1G4SEX1zZlU6ES0o1nJo=;
        b=Q+o4k5r4LMAKYGPsXgdHynpKlyTzs8tgqzQEiQdo7VKOtBlJjD5kn/+6ZTTPq7G49j
         +/dNZwZR22R7RBlhCcYbQ+1exDqo6yk11+W5isPjMCtTTABDtdwjIOAxtu+vg0tWYHsm
         r3s3GIUtwRum5trbkaS7Y0ZoRsxH0pawKz0yrFoJNnQKTkanfFDKbAlcqt+77YYV0icg
         rYhQQ1oEBVD6epELDKlPFz4JZeUjUmtJnh1p4IvK+vw5KLXrkzXXpCx0Q0RocQgYJh3P
         /vwfwhHaQsMdI6qJ9kfcQ6DDtJf4Asq+14aB7/69amO6bY/9/x0VoO7SE0p+AWFXe80H
         xw6A==
X-Gm-Message-State: APjAAAWuChWY5eCkwnLbrXIhuJK/cWUkP9gWyn/AH1aBDYyXL62CdE6L
        VhizxfoCakJNypj2mOpdHCBxzeZJ
X-Google-Smtp-Source: APXvYqxRkuEoFuMGtm9QPX22D4Met6MZTkSeVGGwvsxT1sqcGc45Q5FGbGebOvfJh94BtegCpfLunw==
X-Received: by 2002:aa7:956a:: with SMTP id x10mr11912711pfq.114.1570729792677;
        Thu, 10 Oct 2019 10:49:52 -0700 (PDT)
Received: from [10.230.29.90] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n3sm8553650pff.102.2019.10.10.10.49.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 10:49:52 -0700 (PDT)
Subject: Re: scsi: lpfc: Fix hardlockup in lpfc_abort_handler
To:     Zhangguanghui <zhang.guanghui@h3c.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        James Smart <jsmart2021@gmail.com>
References: <d06924929def46d2bfca19a5cf2e7b55@h3c.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <834b8a8d-8c08-0903-852d-7387e2331533@gmail.com>
Date:   Thu, 10 Oct 2019 10:49:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d06924929def46d2bfca19a5cf2e7b55@h3c.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/10/2019 1:59 AM, Zhangguanghui wrote:
> Hi everyone
> 
> Please refer to the latest patch.
> 
> There is a race deadlock in the function lpfc_abort_handler
> 
> potential deadlocks arising from lock ordering problems.
> 
> It’s the correct order
> 
> spin_unlock(&lpfc_cmd->buf_lock)
> 
> spin_unlock_irqrestore(&phba->hbalock, flags);
> 
> How to solve it ? I think that the patch is reasonable,
> 
> can you help me review and commit this patch, Best regards
> 
> diff --git a/src/lpfc-12.2.0.0/lpfc_scsi.c b/src/lpfc-12.2.0.0/lpfc_scsi.c
> 
> index 3f1375a..19c8505 100644
> 
> --- a/src/lpfc-12.2.0.0/lpfc_scsi.c
> 
> +++ b/src/lpfc-12.2.0.0/lpfc_scsi.c
> 

We confirmed the issue you stated.  We are looking at what you proposed 
and will be adding a patch that will be posted in our next
patch set after we've put it through some regression testing.

-- james

