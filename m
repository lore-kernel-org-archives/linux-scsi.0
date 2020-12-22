Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A68FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 18:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C82BD22512
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 18:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgLVSTQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 13:19:16 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:38650 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgLVSTP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 13:19:15 -0500
Received: by mail-pl1-f180.google.com with SMTP id 4so7841561plk.5
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 10:19:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YIFTVXzPRlrUbj5sDNW1xJ0TuTZ5w2i1yKpgCUvDWpY=;
        b=KZKa8N04wuoR9KtcphKtMKX918E0w6XKtrwBCaMi/8uCjYNDPlwE/4RRToXFSJzZr8
         kfQWv9e3H98xGvx3kQOMzcbiqm6432C8aSmsVdTC4jwYtNQERxf0CdN1gz7eyGTqPXMn
         ypgI9Nzhm9zjjNrFFzgICGWT1ZUMarIEyth5p2Ey25d5PtuN1sA+zWwJHE2YAreDNGEe
         PpR7uosBr0uKmA7SrQ4jZypve9RoKQicoeVaVrEIbWkfVbN1R2A8ghElL5/kV032QNKb
         OVg6Hl1HcrGy/AWtR1gsx++6KoFoNDY2k9SpM0VTc9aWVw4YBMZbNKiC5zf7RMBJZ22Q
         I7KA==
X-Gm-Message-State: AOAM532JKUdR6FBXO1+n1A0lCY6WBjRbypifEkSWJu+i5kr8UEJ7Us/2
        kMXg8Z8ILGAbPY4sgAoNMe4=
X-Google-Smtp-Source: ABdhPJxLttvYEfrmW3cYXLGxH3HZP5zLfYy9sLbDMTNKBN6pcDnqYwjeEx06OlSQ24LqUptDCEPi9w==
X-Received: by 2002:a17:902:52a:b029:da:989f:6c01 with SMTP id 39-20020a170902052ab02900da989f6c01mr21773552plf.45.1608661114859;
        Tue, 22 Dec 2020 10:18:34 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id nk11sm19747607pjb.26.2020.12.22.10.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 10:18:34 -0800 (PST)
Subject: Re: [PATCH 03/24] mpi3mr: create operational request and reply queue
 pair
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-4-kashyap.desai@broadcom.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2e819f1f-802f-7d00-6206-fbfe8e9f2aea@acm.org>
Date:   Tue, 22 Dec 2020 10:18:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-4-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 2:11 AM, Kashyap Desai wrote:
> This electronic communication and the information and any files
> transmitted with it, or attached to it, are confidential and are
> intended solely for the use of the individual or entity to whom it is
> addressed and may contain information that is confidential, legally
> privileged, protected by privacy laws, or otherwise restricted from
> disclosure to anyone else. If you are not the intended recipient or
> the person responsible for delivering the e-mail to the intended
> recipient, you are hereby notified that any use, copying,
> distributing, dissemination, forwarding, printing, or copying of
> this e-mail is strictly prohibited. If you received this e-mail in
> error, please return the e-mail to the sender, delete it from your
> computer, and destroy any printed copy of it.

Please make sure that no confidentiality footers are added when posting
to a public mailing list.

Thanks,

Bart.
