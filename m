Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F410CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 15:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EBA621479
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 15:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbfJ1PBa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 11:01:30 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38145 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbfJ1PBa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 11:01:30 -0400
Received: by mail-pg1-f194.google.com with SMTP id w3so7049154pgt.5;
        Mon, 28 Oct 2019 08:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Iot0ZBgc0Dj0tS3PUsk54zTN8OnhvTPdFLbjQIjDxSA=;
        b=DOnlLJ6llSRlEV4B657Ghd7LUncAmLYfPfkksQch0nfH1Iy/co2bd6F43XmZPsl5bE
         Wf2aTbX8hxITJHg3XDPxIzuOejWyPKEcKvX2xugNTTLN+v1FjQZzfaZl830Tj/0wBfkK
         OqmxB3hSJu54QuE8KtG2iMG5HwRXRgydiBh2k0RlcOQtgiq/N4KR2z3Qg14D5dulydAH
         PzkGRX8ayMRcOvwNBwdA7wiy/uK/yWSJXleH+Ll+S3FCxc0zFc5jKwONtWkiaVW+RI9/
         ZiRN4AL2R3ODUmZMTJUY92slQ66k3uf6IiS/jaFLkZjhpuxvhg2KYSr7q/VVE3+MqoRl
         E+ng==
X-Gm-Message-State: APjAAAUqRAp4hs8/wjRHSJ2GDbduRmWvHbSNsEfo6XgTRmkXNqkrG2xh
        TGHJT57OGHseSh+wg7aG9mw1naLp
X-Google-Smtp-Source: APXvYqy8StxS7nh8ZwoKurzwZllHjIj28dUR8kSWsBGP/OebrjsJNEBkXoxDu3GWvS4/2G0GRVvhEA==
X-Received: by 2002:a63:5422:: with SMTP id i34mr5587188pgb.142.1572274888793;
        Mon, 28 Oct 2019 08:01:28 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id x12sm10758449pfm.130.2019.10.28.08.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2019 08:01:27 -0700 (PDT)
Subject: Re: [PATCH v1 1/5] scsi: Adjust DBD setting in mode sense for caching
 mode page per LLD
From:   Bart Van Assche <bvanassche@acm.org>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1572234608-32654-1-git-send-email-cang@codeaurora.org>
 <1572234608-32654-2-git-send-email-cang@codeaurora.org>
 <0ca52845-10ec-3310-83f7-81bdb635ec12@acm.org>
Message-ID: <119bbf38-da2b-b928-fb4e-a43891a988c4@acm.org>
Date:   Mon, 28 Oct 2019 08:01:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0ca52845-10ec-3310-83f7-81bdb635ec12@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/19 7:58 AM, Bart Van Assche wrote:
> Since this patch by itself has no effect, please resubmit this patch 
> together with the LLD patch that sets set_dbd_for_caching.

Please ignore this part of my email. Patch 1/5 showed up in my inbox 
before the rest of this patch series.

Bart.
