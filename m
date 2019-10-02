Return-Path: <SRS0=821a=X3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8725C10F14
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 17:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9EBF21848
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 17:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfJBRUO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Oct 2019 13:20:14 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42707 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfJBRUN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2019 13:20:13 -0400
Received: by mail-pl1-f193.google.com with SMTP id e5so8927pls.9;
        Wed, 02 Oct 2019 10:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+b87VPN3ehCNTTZtrXC4S7AEpOpBZmJhjs1RLuGgjKM=;
        b=g/WTqkvMgecdgcwm7f/Q/1CsZOwkhkWvvqcdWEyIFyCSsjvQTR9aQXjITxpPnLdARI
         VwYq7Y8FpF6xT2EG+AR282T6o2WZBEYUpmRJ7YxD2Rnik6n42ZBWr13lHbAWPVaIl0+h
         D75hOn6avSCvrnvMBQDoAu+0dhtCXfkvmaLBdrsq2zbkpEPYMiIz9hOKx3Q8RfeOHANW
         zmw7+8Qwx4O1pHxcEkooA+kmaNNz6VhMc/mOc7S0cfJE5tte5/4CG9cPC+O7+vnldrVV
         eUm22uLb325YhuYFEDHSKt45PTfB7X9mQvelyvZV4xSur7454ZiVJapqtOZlZVJT8wzx
         UtNA==
X-Gm-Message-State: APjAAAXjAOrKFCURU57DGEL88rfu/rci2POwur4q9r2nifBLxmqULpkz
        9w3OgawMD0zrzOV3lJ7J1So=
X-Google-Smtp-Source: APXvYqxH/i8Olb5WpZCpWnoi4BFxK1p9+PpGVwVtyLVe7wOXUCqIkvIHfPLe1KU3QZNgwG31n5HaHg==
X-Received: by 2002:a17:902:169:: with SMTP id 96mr5046016plb.166.1570036812965;
        Wed, 02 Oct 2019 10:20:12 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id q71sm6742509pjb.26.2019.10.02.10.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 10:20:11 -0700 (PDT)
Subject: Re: [PATCH V3] scsi: save/restore command resid for error handling
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
References: <20191001074839.1994-1-damien.lemoal@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b2f4bf11-4d35-ba46-99d9-f6241be6c982@acm.org>
Date:   Wed, 2 Oct 2019 10:20:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191001074839.1994-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/1/19 12:48 AM, Damien Le Moal wrote:
> When a non-passthrough command is terminated with CHECK CONDITION,
> request sense is executed by hijacking the command descriptor. Since
> scsi_eh_prep_cmnd() and scsi_eh_restore_cmnd() do not save/restore the
> original command resid, the value returned on failure of the original
> command is lost and replaced with the value set by the execution of the
> request sense command. This value may in many instances be unaligned to
> the device sector size, causing sd_done() to print a warning message
> about the incorrect unaligned resid before the command is retried.
> 
> Fix this problem by saving the original command residual in struct
> scsi_eh_save using scsi_eh_prep_cmnd() and restoring it in
> scsi_eh_restore_cmnd(). In addition, to make sure that the request sense
> command is executed with a correctly initialized command structure, also
> reset the residual to 0 in scsi_eh_prep_cmnd() after saving the original
> command value in struct scsi_eh_save.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
