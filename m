Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01AF7C4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 00:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C16902313E
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 00:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730114AbgLJAu0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 19:50:26 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:49580 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730135AbgLJAuZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 19:50:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607561399; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ki6qhk9beKgLh7vMubeDeIa2ozDU3ovfEqX88UQeOsU=;
 b=WaPIH5a8AV9OsItQCvambQWqpGb6N0/a0Thx4A1n4nR+b1n6HhlFpE92QIfAg1xFhV9Ri0I2
 ygayGOOzqOXlxZPha+pQeqiZSeTT6aI6mhp7GgKJVZvIq/fWFjmaa81ELRFJkpRo1HwDsgCS
 s3ohxRHgfE6S9emRboY9DV2EK4s=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fd170b77e7202f9bc6016aa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 10 Dec 2020 00:49:59
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D732EC43464; Thu, 10 Dec 2020 00:49:58 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CFE47C433CA;
        Thu, 10 Dec 2020 00:49:57 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 10 Dec 2020 08:49:57 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] scsi: ufs: Clean up some lines from
 ufshcd_hba_exit()
In-Reply-To: <48c1f368d7ce23abee32dce052d8e2a724a94d01.camel@gmail.com>
References: <1607497100-27570-1-git-send-email-cang@codeaurora.org>
 <1607497100-27570-3-git-send-email-cang@codeaurora.org>
 <48c1f368d7ce23abee32dce052d8e2a724a94d01.camel@gmail.com>
Message-ID: <f24787e727921e9e2bce5a2e7015eff1@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-10 06:17, Bean Huo wrote:
> On Tue, 2020-12-08 at 22:58 -0800, Can Guo wrote:
>> ufshcd_hba_exit() is always called after ufshcd_exit_clk_scaling()
>> and
>> ufshcd_exit_clk_gating(), so no need to suspend clock scaling again
>> in
>> ufshcd_hba_exit().
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Bean Huo <beanhuo@micron.com>

Hi Bean,

Thanks for you review. But I sent V2 yesterday,
in which this patch is slightly updated.

Thanks,

Can Guo.
