Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 727F9CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FE9020830
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfJ1UiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:38:04 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36806 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfJ1UiE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:38:04 -0400
Received: by mail-pf1-f196.google.com with SMTP id v19so7721457pfm.3;
        Mon, 28 Oct 2019 13:38:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O/b/6mghHgpstK0O5SxbK8ykdy2XcpdcIv0f+yaSsWg=;
        b=JF5Fd/5pDVAMFWfq94wKFOmYZVHVGhorjBzZP0xDgKRVL52NipRHWlADXJb0VJbeeU
         AnZo1z1WqSqgzgQU9GatrQJzM1CF2ykZFic35arCLReV0dbOO/mhUb1/gT/Q9pim57q5
         ZT/DS5I5Rmj5u23VeNb4U7T3eA/UfZhEO9cdcEziHZSm0wlhsUlWK18Xoin+9nRupSdS
         cJRzaRO+Y1vmrQow1mfwvBvNf4RJM2dNriISPRz0sX2VUIyBPP+83R4FVySSrWOc/wf8
         tdWAxAYhoIfncF7KEd5JmiEkjJ/Yl3dDlA5OrDpc1cY+mf4svVzLgz8oqCdEpyTiklG5
         0BtQ==
X-Gm-Message-State: APjAAAX6n3WcRB90oNyo7R3lsNpPdQAJs0PTZdODDU/BVMMYLhKbeS+9
        uquhzSJZdfZM6UmGpZ3SHCqqfU0eeKE=
X-Google-Smtp-Source: APXvYqxSgRD0ux8H6DeP+FzTh+T2WeyJlMIO7/sWjeGqsxFWOUS69N6OE09X19aQc/0TurdqYqk6MA==
X-Received: by 2002:a17:90a:8c14:: with SMTP id a20mr1497653pjo.77.1572295083533;
        Mon, 28 Oct 2019 13:38:03 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 129sm12561232pfg.38.2019.10.28.13.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2019 13:38:02 -0700 (PDT)
Subject: Re: [PATCH] scsi: Fix scsi_get/set_resid() interface
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
References: <20191028105732.29913-1-damien.lemoal@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <eb8f6e3e-0350-9688-58c8-9d777ba93298@acm.org>
Date:   Mon, 28 Oct 2019 13:38:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028105732.29913-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/19 3:57 AM, Damien Le Moal wrote:
> struct scsi_cmnd cmd->req.resid_len which is returned and set
> respectively by the helper functions scsi_get_resid() and
> scsi_set_resid() is an unsigned int. Reflect this fact in the interface
> of these helper functions.
> [ ... ]
> -static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
> +static inline void scsi_set_resid(struct scsi_cmnd *cmd, unsigned int resid)
>   {
>   	cmd->req.resid_len = resid;
>   }
>   
> -static inline int scsi_get_resid(struct scsi_cmnd *cmd)
> +static inline unsigned int scsi_get_resid(struct scsi_cmnd *cmd)
>   {
>   	return cmd->req.resid_len;
>   }

 From the iSCSI RFC:

    SCSI-Presented Data Transfer Length (SPDTL) is the term this document
    uses (see Section 1.1 for definition) to represent the aggregate data
    length that the target SCSI layer attempts to transfer using the
    local iSCSI layer for a task.  Expected Data Transfer Length (EDTL)
    is the iSCSI term that represents the length of data that the iSCSI
    layer expects to transfer for a task.  EDTL is specified in the SCSI
    Command PDU.

    When SPDTL = EDTL for a task, the target iSCSI layer completes the
    task with no residuals.  Whenever SPDTL differs from EDTL for a task,
    that task is said to have a residual.

    If SPDTL > EDTL for a task, iSCSI Overflow MUST be signaled in the
    SCSI Response PDU as specified in [RFC3720].  The Residual Count MUST
    be set to the numerical value of (SPDTL - EDTL).

    If SPDTL < EDTL for a task, iSCSI Underflow MUST be signaled in the
    SCSI Response PDU as specified in [RFC3720].  The Residual Count MUST
    be set to the numerical value of (EDTL - SPDTL).

    Note that the Overflow and Underflow scenarios are independent of
    Data-In and Data-Out.  Either scenario is logically possible in
    either direction of data transfer.

If the residual is changed from signed into unsigned, how is a SCSI LLD 
expected to report the difference between residual overflow and residual 
underflow to the SCSI core?

Thanks,

Bart.
