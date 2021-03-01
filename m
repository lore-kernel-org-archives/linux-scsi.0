Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE140C28CFB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3D0D64F07
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245542AbhCBSmg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:42:36 -0500
Received: from z11.mailgun.us ([104.130.96.11]:56648 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237954AbhCBAYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 19:24:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614644635; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=1TtZfr/Nw56aZE04sSwSvp/ypG0PsW6ImngAxZkqIkU=; b=ArYT+PWeLdE0ZOfTLCXPgPauG4mAov0seXB/vhXh+z/Doj8LFlIKawWwp8w58wHsPUBJliMa
 IBR7SNpkahkqB9yerej96mbU7OcDnvq1dkbD1dKhPtmwTBjQlL9o8ZA2ouk8sgkcqlySrvaI
 hFaftjcYQO1fYA2SmNdQALE7qmc=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 603d7eca1d4da3b75d1975ed (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 01 Mar 2021 23:54:50
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C4D9CC43465; Mon,  1 Mar 2021 23:54:49 +0000 (UTC)
Received: from stor-presley.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4F9DFC433C6;
        Mon,  1 Mar 2021 23:54:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4F9DFC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Date:   Mon, 1 Mar 2021 15:54:45 -0800
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH] scsi: ufs: Fix incorrect ufshcd_state after
 ufshcd_reset_and_restore()
Message-ID: <20210301235444.GG12147@stor-presley.qualcomm.com>
References: <20210301191940.15247-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210301191940.15247-1-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 01 2021 at 11:19 -0800, Adrian Hunter wrote:
>If ufshcd_probe_hba() fails it sets ufshcd_state to UFSHCD_STATE_ERROR,
>however, if it is called again, as it is within a loop in
>ufshcd_reset_and_restore(), and succeeds, then it will not set the state
>back to UFSHCD_STATE_OPERATIONAL unless the state was
>UFSHCD_STATE_RESET.
>
>That can result in the state being UFSHCD_STATE_ERROR even though
>ufshcd_reset_and_restore() is successful and returns zero.
>
>Fix by initializing the state to UFSHCD_STATE_RESET in the start of each
>loop in ufshcd_reset_and_restore().  If there is an error,
>ufshcd_reset_and_restore() will change the state to UFSHCD_STATE_ERROR,
>otherwise ufshcd_probe_hba() will have set the state appropriately.
>
>Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other error recovery paths")
>Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

> drivers/scsi/ufs/ufshcd.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>index 77161750c9fb..91a403afe038 100644
>--- a/drivers/scsi/ufs/ufshcd.c
>+++ b/drivers/scsi/ufs/ufshcd.c
>@@ -7031,6 +7031,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
> 	spin_unlock_irqrestore(hba->host->host_lock, flags);
>
> 	do {
>+		hba->ufshcd_state = UFSHCD_STATE_RESET;
>+
> 		/* Reset the attached device */
> 		ufshcd_device_reset(hba);
>
>-- 
>2.17.1
>
