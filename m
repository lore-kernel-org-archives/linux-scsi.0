Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3E6C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 03:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5654E60FED
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 03:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240958AbhIRDKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 23:10:12 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:42723 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbhIRDKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 23:10:11 -0400
Received: by mail-pj1-f52.google.com with SMTP id p12-20020a17090adf8c00b0019c959bc795so3125398pjv.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 20:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OVAPmJq/QKLFpO7jIJExDhsLqi/sMtM/QdQdGrccb5I=;
        b=nJbw8KreEFvVuwhQja1kD8WNJAGhT+rh0RR/4w9o3VXzWYl45WSs+2JiCjJ+wbhLI4
         yEIcmi47Lfl9f+T3mEriqdvSvsukL0gRB4nvLKUa9Son7zDpe8Nxn7YXULf7d+7gs/f2
         5S2cy3whSNQptD6B4VPWyVjhmGE3fnUtYj/Q3NypOyIUCM19Av2/KGKKkOxx4uX8YpPX
         ZlydVkA1WesrakeISsOfnODxIkr/FIDS/YxNQU3xVaS1x4vWONalCYsgRGeuvWhtyJIK
         AuY8ziMz9kck04oVKhSjzJgCpjDYlZjfSTDxIRFdiuGxL1SY2lLT+dC5pnNkiZ6CCkn6
         IvWg==
X-Gm-Message-State: AOAM532sGm2tWH4B/vF4RXKyD7KpBQ0NXe/QLFMbyzTNUSD8/HrEQm+k
        gcEnURh2YV+naljkLlQnquc=
X-Google-Smtp-Source: ABdhPJy+MVuDqubbZvpb9dxt49K40FLJ2VwAN2Az8KS92Y7jQF66xUpVIQG7Z985F9l/9LYjDF45+g==
X-Received: by 2002:a17:90a:fd85:: with SMTP id cx5mr24948234pjb.168.1631934528712;
        Fri, 17 Sep 2021 20:08:48 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:eb4a:447e:487f:caa3? ([2601:647:4000:d7:eb4a:447e:487f:caa3])
        by smtp.gmail.com with ESMTPSA id e13sm3245912pfn.212.2021.09.17.20.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 20:08:48 -0700 (PDT)
Message-ID: <ef2aed91-83de-c199-1aac-e7f0bcb49d9e@acm.org>
Date:   Fri, 17 Sep 2021 20:08:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH 57/84] nsp32: Call scsi_done() directly
Content-Language: en-US
To:     Masanori Goto <gotom@debian.or.jp>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-58-bvanassche@acm.org>
 <CALZLnaE3CPKxm5+VtmRxRjG2FZ3hD3UDOg4e_axLuU4gX4Yd0g@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CALZLnaE3CPKxm5+VtmRxRjG2FZ3hD3UDOg4e_axLuU4gX4Yd0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/17/21 18:10, Masanori Goto wrote:
> I'm not sure this is a safe approach in general, but any background of
> this change?

This patch series realizes two improvements:
- It improves performance for SCSI drivers that can provide high performance
   (millions of IOPS).
- It reduces the size of struct scsi_cmnd.

Thanks,

Bart.
