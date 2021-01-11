Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4538FC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 02:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04D5822483
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 02:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbhAKCtz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 21:49:55 -0500
Received: from mail-pg1-f177.google.com ([209.85.215.177]:36346 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbhAKCtz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 21:49:55 -0500
Received: by mail-pg1-f177.google.com with SMTP id c132so11678801pga.3;
        Sun, 10 Jan 2021 18:49:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mBjywu/JytUrPm5jEBE65SGQ7hTVgYgPqE4uJPglmZg=;
        b=KhA2vXQQH5jO+40bakLl5SUkhCqvheJwZjwQmo68aEF+vJJT0UPEJ7wDrGYLaDHuCq
         kLShdFmj2SzjfN0DfGK1IYcI7gVRAn5npqUHSUf0UXCdlIWiJV5liBwg77X4deF0eZ8+
         JAMXsWRg81UJZRP3SKDgZQ8BCJiyuTxp/riD0+nHLjlAzUv2GGwwJopSjVC5RWdkPNDz
         nGMOc3lZLscB+BVFeRnQ7bUHmmnb0civkEfQnkbrWKK6YhrdAWRQd1kBkUjJcJ7EDASt
         QIA7T00KsUkNa/FNrARhBGOolM2tVGbTh9k1laj9lOk6WqxdO+uFF6qhtYLWp17Uf8Lw
         xn3g==
X-Gm-Message-State: AOAM533FwjnCNLOHdH5XBS5E2MeGmVmMMwpWq3lpmmAqzPXwqW3iEjFx
        XugpWb4WTQ6ZGJqnAsPVBd2bLXnrkDA=
X-Google-Smtp-Source: ABdhPJwx7hHoRkvykENMFtJARWFXfDuoe21ONMt3g8QlDBGcFe9Zq3QEWxncW7AGikPR4S7xLtD+9A==
X-Received: by 2002:a62:ca:0:b029:19e:67a9:f0f2 with SMTP id 193-20020a6200ca0000b029019e67a9f0f2mr14291608pfa.60.1610333353639;
        Sun, 10 Jan 2021 18:49:13 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p17sm16378472pfn.52.2021.01.10.18.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 18:49:12 -0800 (PST)
Subject: Re: [PATCH] target/file: don't zero iter before iov_iter_bvec
To:     Pavel Begunkov <asml.silence@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <488fa4ff-3e08-28cc-60f1-b8c5172e1f79@acm.org>
Date:   Sun, 10 Jan 2021 18:49:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/9/21 7:53 AM, Pavel Begunkov wrote:
> iov_iter_bvec() initialises iterators well, no need to pre-zero it
> beforehand as done in fd_execute_rw_aio(). Compilers can't optimise it
> out and generate extra code for that (confirmed with assembly).

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
