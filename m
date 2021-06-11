Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C38C4743D
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 04:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE22760232
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 04:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhFKEwU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 00:52:20 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:38441 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhFKEwT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 00:52:19 -0400
Received: by mail-wr1-f51.google.com with SMTP id c9so4544798wrt.5
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2021 21:50:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XGJFwXnydBzv6K7wp4D0uxMtsZrhJSyPVBDq90r+N80=;
        b=fmXD4leba0P2NYL8n33gRBD+47/26YwdCh9cXxKV7m41LtYFWsq39BDJK7q/qKy3+I
         eKJDVV9Uliy/IR1U4qMhDYe7U2MxqHc6Di+s3PreebSLKs8WqbOBGVIa6OU2me6h1qre
         Sr9phE+Wf/+Wcg0PlBKQ+1SXkM8TtTXguijyrrVAJBKP1V+fMYIlrIiRNTJ2D3qoEeZP
         aM+6qxZWszSzipoDKaHD5ko6ZnJikYyvOvH0AEtxsFEFmEAcyEBDCJOo3a4KLgXTCmaq
         MgBXmsqQy7RcTD7W0rK+lhfBNk9lFaOW+C82DH0FaOYY4jfFraeOhAq+LLg7OG1uJffD
         EOLA==
X-Gm-Message-State: AOAM531BXNJIsqp8Ueduw5C5nEBgbVmth9TFgTFIno5TU6NtmvBc4qHJ
        GQ9eVa8TtzP2dBFddQwARF4AS//FPCU=
X-Google-Smtp-Source: ABdhPJxOImQ7aSDz6qfhhlXWv+7wPe+BnMci8bnD6jYU1dAjEQ8by8toA7QcEnWK6jvf9gFKDfS06w==
X-Received: by 2002:a5d:4692:: with SMTP id u18mr1674361wrq.318.1623387021570;
        Thu, 10 Jun 2021 21:50:21 -0700 (PDT)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id q3sm5648782wrr.43.2021.06.10.21.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 21:50:20 -0700 (PDT)
Subject: Re: [PATCH 13/24] scsi: Kill DRIVER_SENSE
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-14-hare@suse.de>
 <a5551d37-8303-2cbb-f82a-17fea785adad@kernel.org>
 <c48e74e9-4bbb-d892-4976-06bb448f5f6c@suse.de>
 <yq1bl8hn9py.fsf@ca-mkp.ca.oracle.com>
 <e2c75feb-cd87-1681-a5ee-6aed7ee82e11@suse.de>
 <6d5c893d-61c1-fad9-78f5-17b41f19706d@kernel.org>
 <723d9d8b-5dde-839f-efe6-164177f5c1ce@suse.de>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <b91a17a7-3bfd-b882-ce15-fa9991315293@kernel.org>
Date:   Fri, 11 Jun 2021 06:50:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <723d9d8b-5dde-839f-efe6-164177f5c1ce@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10. 06. 21, 16:01, Hannes Reinecke wrote:
>>> Can you test with this patch?
>>
>> Yes, that boots, but is somehow sloooow (hard to tell what is causing
>> this).
>>
>> Anyway, the new print is still there with the patch:
>> [   11.549986] sd 0:0:0:0: Power-on or device reset occurred
>>
>> Cool; one step further.
> Can you check if the attached patch helps, too?

No, this doesn't boot:
[   20.293526] scsi host0: Virtio SCSI HBA
[   22.236517] scsi 0:0:0:0: Power-on or device reset occurred
[   22.237986] scsi 0:0:0:0: Power-on or device reset occurred

thanks,
-- 
js
suse labs
