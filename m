Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373E9C48BCF
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 07:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 146CC610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 07:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhFLHPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Jun 2021 03:15:30 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:45950 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhFLHP3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jun 2021 03:15:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623482010; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=dSTq7/FJmXNvVcUhDXUN+9uGuplltG1LiEo4dgdMqR8=;
 b=RsPz1YvV/G6JfthiA5KpvBqN6Uw6EH4GZ1R9tW1vh6B1spWZWaYR1TnOSimy4SKnw/yjmp8u
 KSI5eocHFCSizwrs4+u/R0GHjImg7wGyn/K7CKkUljhIKW8aH+juq/amjp7NZiNemdwzs3Ui
 FCaq3sB6awrrwhPAh3e6vmVMT1g=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60c45e99e570c05619a7a79a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 12 Jun 2021 07:13:29
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 744ECC43145; Sat, 12 Jun 2021 07:13:29 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A143DC4338A;
        Sat, 12 Jun 2021 07:13:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 12 Jun 2021 15:13:28 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 9/9] scsi: ufs: Apply more limitations to user access
In-Reply-To: <b1e555c2-a59a-2a63-79e0-7c22d5b7b698@acm.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-10-git-send-email-cang@codeaurora.org>
 <b1e555c2-a59a-2a63-79e0-7c22d5b7b698@acm.org>
Message-ID: <f41c45d5b151ca98da1e41848c067f89@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-12 05:03, Bart Van Assche wrote:
> On 6/9/21 9:43 PM, Can Guo wrote:
>> Do not let user access HW if hba resume fails or hba is not in good 
>> state,
>> otherwise it may lead to various stability issues.
> 
> Just like for the previous patch, I'm wondering whether or not such a
> failure perhaps indicates a hardware bug?
> 

Indeed yes, but user access happens when power/clock is not ready will
lead to system stability issues, e.g., OCP or unclocked register access.

Nowadays, customers are heavily using UFS sysfs nodes during runtime,
so our test teams added quite a lot test scripts to simulate user access
to UFS sysfs nodes during their test.

Thanks,

Can Guo.

> Thanks,
> 
> Bart.
