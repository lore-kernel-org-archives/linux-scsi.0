Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9139AC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 18:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F6AB2178F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 18:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbfKGSBS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:01:18 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35627 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfKGSBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 13:01:18 -0500
Received: by mail-pg1-f193.google.com with SMTP id q22so2541731pgk.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2019 10:01:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ryOlOzuRsyNymmnK7/0dg4GDh9+8AxgOIu5KcNKTrms=;
        b=ZJjXKag4V7lDPUZ/CQbVpeUB2nl6CbzfrRD5BpbtQK+xk71eTid+x8dVn+MMZT2pgj
         yKJyZhwCtHnQNwUEStZdQdGv1zMwVtVY8yrMAPFooM/qj3chdoyN6GM0wZM4wbJtH3kE
         YJZFff5L/RkcakztmY7jZBdXOA7/zJTqpW/WyxbNAIcgw1VwP54F1W7pi48kUqBGOtPj
         JEhHHNqC69SnuEDSmE0+obITD09I2TqUMdZyjsz8HB+E5yMVbFBmLeO9M9m0SbCl+rK6
         MU6vWtZxOsRN1D2hv2cK9x5qFaLzV2kcxjdFPTI3TUDZFkm0w7rtG5m3vDEA3ATxJbog
         92uw==
X-Gm-Message-State: APjAAAVb6ErYz1G2e+ZvutTQzLQ95KS0aEp0tmfkTHipLB+VDeieDz3b
        MDZJ44tZmBV+62I5UFeipqqpJGk4
X-Google-Smtp-Source: APXvYqzpIcNvinbRXIhnCtMheni3Y4vxH9WW6b+EfjVsC3k8xOe1DSAGRBMHge0x+J85HPW8IEBVEw==
X-Received: by 2002:a63:db15:: with SMTP id e21mr5988659pgg.21.1573149676786;
        Thu, 07 Nov 2019 10:01:16 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:fb9c:664d:d2ad:c9b5? ([2620:15c:2c1:200:fb9c:664d:d2ad:c9b5])
        by smtp.gmail.com with ESMTPSA id w62sm3729779pfb.15.2019.11.07.10.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 10:01:16 -0800 (PST)
Subject: Re: [PATCH 5/8] qla2xxx: Fix double scsi_done for abort path
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20191105150657.8092-1-hmadhani@marvell.com>
 <20191105150657.8092-6-hmadhani@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <01424d66-03c0-99e5-7ace-396b3a77799d@acm.org>
Date:   Thu, 7 Nov 2019 10:01:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105150657.8092-6-hmadhani@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/19 7:06 AM, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Current code assume abort will remove the original command from the
> active list where scsi_done will not be call. Instead, the eh_abort
> thread will do the scsi_done. That is not the case.  Instead, we
> have a double scsi_done calls triggering use after free.
> 
> Abort will tell FW to release the command from FW possesion. The
> original command will return to ULP with error in its normal fashion via
> scsi_done.  eh_abort path would wait for the original command
> completion before returning.  eh_abort path will not perform the
> scsi_done call.
> 
> Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")

The intent of commit 219d27d7147e0 was only to fix race conditions and
not to change when scsi_done() is called. Are the double scsi_done()
calls perhaps the result of a recent firmware change? If so, does this
patch break compatibility with firmware versions that do not report an
error status for aborted commands?

Thanks,

Bart.

