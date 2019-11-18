Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EABFC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 22:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEC3620692
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 22:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfKRWyU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 17:54:20 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37696 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKRWyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 17:54:20 -0500
Received: by mail-pl1-f196.google.com with SMTP id bb5so10604284plb.4
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 14:54:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QBKLKFd9yLScR96DRr20PdO4YcofdJ1TokqHMDLM3S4=;
        b=YRzh+4iInDkgj9rsLue4TzGO0BWFSK0wUAJ0CaTtTyh0TVozBtwrn8k/FyH5boZRn5
         qaZfOK/JjfJ5tzytqrnRzL+J67UT6ufVL0IZ4VoAtsmPEvrpjWpI7wh6bAzSz5f06JBw
         UnKGWvj1VHHqWsQBS0PPXQ2mzMZ9k9yy4BEyXKja4JrKWQLuiUZK604VkVWQouFteFrW
         bs9W4fte6d0dzS4W6xHrMJtblYQiF/Frpvqgky47MDk0TLlx3dZlYv2oAZasMO98keLi
         lUene1ZvryOB3pMEM5F2HGd11H2gbbPXa3oXBubXXqMkSOUNDHo28r7Os6OfqV2jFobu
         VitQ==
X-Gm-Message-State: APjAAAX73kstBGRNsUH23Du++bUb4I0hOuYAgTSK3y9FaEzZBF5CZjWR
        mrdBYxtOviCxZvlPzqV6GWeMkGHZ
X-Google-Smtp-Source: APXvYqwr3Sasg7NRCGeveRaivYz7N/ymXvrFbPMUfhbVOUyS8CcCmA+HH6bivipH0LmXZoJPXZ0IOA==
X-Received: by 2002:a17:902:126:: with SMTP id 35mr32616997plb.105.1574117657703;
        Mon, 18 Nov 2019 14:54:17 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id b137sm21220582pga.91.2019.11.18.14.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 14:54:16 -0800 (PST)
Subject: Re: [PATCH 1/9] dpt_i2o: rename adpt_i2o_to_scsi() to
 adpt_i2o_scsi_complete()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
References: <20191118092208.54521-1-hare@suse.de>
 <20191118092208.54521-2-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <90a006d5-0b47-9e72-0f2a-09c081e0f7f5@acm.org>
Date:   Mon, 18 Nov 2019 14:54:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191118092208.54521-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/19 1:22 AM, Hannes Reinecke wrote:
> Rename the badly named function into adpt_i2o_scsi_complete(),
> and make it a void function as the return value is never used.
> This also fixes a potential use-after free as the return value
> might be evaluated from the command result after the command
> has been freed.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
