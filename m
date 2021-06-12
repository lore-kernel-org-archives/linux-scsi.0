Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A81BC48BCF
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 06:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E58561019
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 06:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFLGWd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Jun 2021 02:22:33 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:35094 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhFLGWc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 12 Jun 2021 02:22:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623478833; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=jFsckA0yGeSVWnv5qUXKF1pxjXigefzOQ4QCAiw+cNI=;
 b=tMlvLX+Ka5Zt6NXENSaoojTTZkTlDTL6hkT4LHScw6KvytZoHg1SQQyOs5SCQSqd6+Da8WH+
 0qutxNDlueR2tnfrnq6zuqRsK24gSZGBC/+6AS1VSEeX4epdoeDrDUcBsp07fqYZ5Ov9pUuQ
 PgtxmhlXMs9ygWDU96RDvRpuuTM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60c4522be27c0cc77faa5a2e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 12 Jun 2021 06:20:27
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CE474C43148; Sat, 12 Jun 2021 06:20:25 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 045C0C433F1;
        Sat, 12 Jun 2021 06:20:24 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 12 Jun 2021 14:20:24 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/9] scsi: ufs: Differentiate status between hba pm ops
 and wl pm ops
In-Reply-To: <1b581673-a5f7-f2a8-787c-f055082dc9d2@acm.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-2-git-send-email-cang@codeaurora.org>
 <1b581673-a5f7-f2a8-787c-f055082dc9d2@acm.org>
Message-ID: <b01ed2e8c00152f8fc7f6a7e1238328c@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-12 04:40, Bart Van Assche wrote:
> On 6/9/21 9:43 PM, Can Guo wrote:
>> Put pm_op_in_progress and is_sys_suspend flags back to ufshcd hba pm 
>> ops,
>> add two new flags, namely wl_pm_op_in_progress and 
>> is_wl_sys_suspended, to
>> track the UFS device W-LU pm ops. This helps us differentiate the 
>> status of
>> hba and wl pm ops when we need to do troubleshooting.
> 
> Since "WL" is an uncommon abbreviation, please add a comment above the
> definition of struct ufs_hba that explains the meaning of the new 
> member
> variables.

Sure, will add in next version.

Thanks,
Can Guo.

> 
> Thanks,
> 
> Bart.
