Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F926C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 02:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244035AbiF1CtM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 22:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245546AbiF1Csm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 22:48:42 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0D7E16
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 19:46:55 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id m2so9845915plx.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 19:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ybo9+eOX1/dVu56Gt4+0mMO2I93E6ds+uTo6Bw9B8NY=;
        b=Ox7Ye9Ck+/IM/8Oap1nV9FTAuFXHC094yP5rTJ/e4rGIG80y5VbRDp1vmE7ZH3LrCo
         KKAC/83biRtf8jxFFe8BR76iVZ14RbghlsoiLB546GE5Jyj0rUSU5P/uQF8qYL0em9K5
         6DQSBJCn5AuCc5LXd4PuroHvfolA/5klB9in3Hu4oQswnciKNKjO6n+AtbVpeBCsJNiI
         HZQZo/76h5WNR0Qu8wzYGv5RRTtdWdZe1RImBLrMRSVpZa7gl4iSiSyRaUIog/2Jclo3
         kvdyf1VmU4s6WrjpRACbQ69Dr/waPtlmjbURnYJg2fyYPkSorInb7dfNWiMakNdZP4m1
         7eWQ==
X-Gm-Message-State: AJIora8x+kND3x99NjbuMiqofQOlvRG1MAS1hiYTvVehO6hsQvilKXIN
        8ZxpODlTklSE71k7BrPpFS85jRt9Fqo=
X-Google-Smtp-Source: AGRyM1v2O/UIq69Sanaz8WtX0tYkh9M59ZTxexODUyxlVNaW2V2Wg2ATwYMVAPNJ3xE/RIU+T0Wnjg==
X-Received: by 2002:a17:902:d384:b0:16a:6622:de87 with SMTP id e4-20020a170902d38400b0016a6622de87mr2683401pld.132.1656384413556;
        Mon, 27 Jun 2022 19:46:53 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s17-20020a170903215100b0016a4ca6516dsm7206962ple.278.2022.06.27.19.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 19:46:52 -0700 (PDT)
Message-ID: <10ea898a-3963-8286-c3a2-eeb9bd230912@acm.org>
Date:   Mon, 27 Jun 2022 19:46:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: ufs-qcom: Remove unneeded code
Content-Language: en-US
To:     Chanwoo Lee <cw9316.lee@samsung.com>, agross@kernel.org,
        bjorn.andersson@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        dh0421.hwang@samsung.com, sh043.lee@samsung.com
References: <CGME20220627235926epcas1p22a6327d6c47f48012e853aec3c8b2fe3@epcas1p2.samsung.com>
 <20220627235545.16943-1-cw9316.lee@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220627235545.16943-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/27/22 16:55, Chanwoo Lee wrote:
> From: ChanWoo Lee <cw9316.lee@samsung.com>
> 
> Checks information about tx_lanes, but is not used.
> 
> Since the commit below is applied, tx_lanes is deprecated.
>   'commit 1e1e465c6d23
>    ("scsi/ufs: qcom: Remove ufs_qcom_phy_*() calls from host")'
> 
> As a result,
> ufs_qcom_link_startup_notify -> POST_CHANGE action does nothing.
> If it is not going to be updated, it looks like it can be removed.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
