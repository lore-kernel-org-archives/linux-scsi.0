Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16219C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 17:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E30BD613B4
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 17:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhFPR5N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 13:57:13 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:36697 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhFPR5N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 13:57:13 -0400
Received: by mail-pf1-f177.google.com with SMTP id d62so839144pfd.3;
        Wed, 16 Jun 2021 10:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jnKj0HBwxlH/ulf+iZejWPSvpBbaHdsnZF9n9H/9ifA=;
        b=CyBYdsYWL8J/isWXcd9fE+aPlg73GodoC1NPkumtPcQef0CZGjUCn3ZRuEniK8mVWw
         l0brqNytiM0PQcR9sK1hho1OoRmv3i7tl0FpBTg5kmhpD1Bi9sGyIxzzP9ADf/f1S8NG
         LnEoArGk8YMC2/xfUfifZlI4Bh4YKENsYTpNNoFRn/g6x6loOFACOeDZWxliIxpomefT
         uGbIbASXQ13UlR/xQvtWD5cVDYR0TprSb8jTbOsoDm5+d7/WTHJP7yc+ZUJ14GbX+GH2
         i8liiZslP04giigHEWhqe+oGSeumoQAFd6LK5tTM8dP9BNklycvliJiBWRRAvPwBKZVq
         Qp0w==
X-Gm-Message-State: AOAM532N8iGxhbkLc4850rdEvSTSQ+IQwX5Sm5ONu3KvZ4m6If5OtUNy
        6smEiThCaIgHyArVNOjNrit9CDfXI0c=
X-Google-Smtp-Source: ABdhPJznn/vGaY7gAHJU0FR2g3wY0tI/TjhNgwHGP5q9o+wMhjlrDPfhsmswD1zUPqIRoCtGvtcS9A==
X-Received: by 2002:a63:1a5b:: with SMTP id a27mr746650pgm.427.1623866105692;
        Wed, 16 Jun 2021 10:55:05 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 1sm6210506pjm.8.2021.06.16.10.55.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 10:55:05 -0700 (PDT)
Subject: Re: [PATCH v3 8/9] scsi: ufs: Update the fast abort path in
 ufshcd_abort() for PM requests
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-9-git-send-email-cang@codeaurora.org>
 <fa37645b-3c1e-2272-d492-0c2b563131b1@acm.org>
 <16f5bd448c7ae1a45fcb23133391aa3f@codeaurora.org>
 <926d8c4a-0fbf-a973-188a-b10c9acaa444@acm.org>
 <75527f0ba5d315d6edbf800a2ddcf8c7@codeaurora.org>
 <8b27b0cc-ae16-173a-bd6f-0321a6aba01c@acm.org>
 <3fce15502c2742a4388817538eb4db97@codeaurora.org>
 <fabc70f8-6bb8-4b62-3311-f6e0ce9eb2c3@acm.org>
 <8aae95071b9ab3c0a3cab91d1ae138e1@codeaurora.org>
 <0081ad7c-8a15-62bb-0e6a-82552aab5309@acm.org>
 <8eadb2f2e30804faf23c9c71e5724d08@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2fa53602-8968-09e4-60f4-28462d85ae08@acm.org>
Date:   Wed, 16 Jun 2021 10:55:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8eadb2f2e30804faf23c9c71e5724d08@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/21 1:47 AM, Can Guo wrote:
> On 2021-06-16 12:40, Bart Van Assche wrote:
>> On 6/15/21 9:00 PM, Can Guo wrote:
>>> 2. And say we want SCSI layer to resubmit PM requests to prevent 
>>> suspend/resume fail, we should keep retrying the PM requests (so 
>>> long as error handler can recover everything successfully),
>>> meaning we should give them unlimited retries (which I think is a
>>> bad idea), otherwise (if they have zero retries or limited
>>> retries), in extreme conditions, what may happen is that error
>>> handler can recover everything successfully every time, but all
>>> these retries (say 3) still time out, which block the power
>>> management for too long (retries * 60 seconds) and, most
>>> important, when the last retry times out, scsi layer will
>>> anyways complete the PM request (even we return DID_IMM_RETRY),
>>> then we end up same - suspend/resume shall run concurrently with
>>> error handler and we couldn't recover saved PM errors.
>> 
>> Hmm ... it is not clear to me why this behavior is considered a
>> problem?
> 
> To me, task abort to PM requests does not worth being treated so 
> differently, after all suspend/resume may fail due to any kinds of
> UFS errors (as I've explained so many times). My idea is to let PM
> requests fast fail (60 seconds has passed, a broken device maybe, we
> have reason to fail it since it is just a passthrough req) and
> schedule UFS error handler, UFS error handler shall proceed after
> suspend/resume fails out then start to recover everything in a safe
> environment. Is this way not working?
Hi Can,

Thank you for the clarification. As you probably know the power
management subsystem serializes runtime power management (RPM) and
system suspend callbacks. I was concerned about the consequences of a
failed RPM transition on system suspend and resume. Having taken a
closer look at the UFS driver, I see that failed RPM transitions do not
require special handling in the system suspend or resume callbacks. In
other words, I'm fine with the approach of failing PM requests fast.

Bart.
