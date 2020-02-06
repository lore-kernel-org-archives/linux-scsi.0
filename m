Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4769AC2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 03:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AB63214AF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 03:43:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="IqIgKERY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgBFDmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Feb 2020 22:42:49 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:25441 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727307AbgBFDms (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2020 22:42:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580960568; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=4+cz2Wd6BRjl/2klKhe4XJ41Ph8D75H9lUOHkMUlZCk=;
 b=IqIgKERYCjTylIzin8vmJZcuFlLL5mxPGEooyjwmLg9jglweCf4Y+flBUBW2EeMtYNaqliqy
 tx7RTKI89eeZeozvlcofkqtGiy++JVA8L1NRcuG2c67mgvrw5WgB7ImL2/bnEcRwc6COk7yU
 nzOqZmwWWpnM38+hk+Fh+AVwnHQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3b8b36.7f0940795458-smtp-out-n03;
 Thu, 06 Feb 2020 03:42:46 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0B04AC447AB; Thu,  6 Feb 2020 03:42:45 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 384A1C43383;
        Thu,  6 Feb 2020 03:42:45 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 Feb 2020 11:42:45 +0800
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: Fix registers dump vops caused scheduling
 while atomic
In-Reply-To: <1580886875-31967-1-git-send-email-cang@codeaurora.org>
References: <1580886875-31967-1-git-send-email-cang@codeaurora.org>
Message-ID: <e932a4129b6e6a957b33d3435069172d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-05 15:14, Can Guo wrote:
> Reigsters dump intiated from atomic context should not sleep. To fix 
> it,
> add one boolean parameter to register dump vops to inform vendor driver 
> if
> sleep is allowed or not.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> 

Hi,

Sorry for bothering, I will just drop this patch as of now :)

Thanks,
Can Guo.
