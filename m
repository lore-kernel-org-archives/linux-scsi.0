Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7650BC2B9F4
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EDD761378
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFWCHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 22:07:19 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:45407 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhFWCHR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 22:07:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624413901; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=BWE4cJP9A5iMFs64pOQ4hiJd/MsZBADGs5e5FvhncRA=;
 b=Wye0EUVDUmnAbYgOZsfBC2mpoquDZStDd5PblpKG4F2WT5E0pnZsI8auhOL2d/l3l6tNxH/4
 kgJZj+BRHkIAYW9PnNVD22N5isg4ER3dWcGUXZ5HZM5P4rfXOoc4SWTpfkJtBCFUDWNtqJvN
 AozDkae43Gu4yWN8pSkHPqnjF1Y=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60d296b8638039e9978f46ff (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Jun 2021 02:04:40
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5A329C43148; Wed, 23 Jun 2021 02:04:40 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1753FC4338A;
        Wed, 23 Jun 2021 02:04:39 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Jun 2021 10:04:39 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
In-Reply-To: <a29164e1-ab7d-6dbc-0fb9-029f203de735@acm.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-3-git-send-email-cang@codeaurora.org>
 <a29164e1-ab7d-6dbc-0fb9-029f203de735@acm.org>
Message-ID: <e8de57b920c9246f5a41aa44c5a4fc36@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-06-17 10:49, Bart Van Assche wrote:
> On 5/24/21 1:36 AM, Can Guo wrote:
>> @@ -2688,6 +2705,43 @@ static int ufshcd_queuecommand(struct Scsi_Host 
>> *host, struct scsi_cmnd *cmd)
>> +	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
>> +		/*
>> +		 * pm_runtime_get_sync() is used at error handling preparation
>> +		 * stage. If a scsi cmd, e.g. the SSU cmd, is sent from hba's
>> +		 * PM ops, it can never be finished if we let SCSI layer keep
>> +		 * retrying it, which gets err handler stuck forever. Neither
>> +		 * can we let the scsi cmd pass through, because UFS is in bad
>> +		 * state, the scsi cmd may eventually time out, which will get
>> +		 * err handler blocked for too long. So, just fail the scsi cmd
>> +		 * sent from PM ops, err handler can recover PM error anyways.
>> +		 */
>> +		if (hba->pm_op_in_progress) {
>> +			hba->force_reset = true;
>> +			set_host_byte(cmd, DID_BAD_TARGET);
>> +			cmd->scsi_done(cmd);
>> +			goto out;
>> +		}
>> +		fallthrough;
> 
> Hi Can,
> 
> I know that this patch only moves the above code and that the above 
> code
> has not been introduced by this patch. Anyway, is my understanding
> correct that ufshcd_err_handler() can change the host controller state
> from UFSHCD_STATE_EH_SCHEDULED_FATAL into UFSHCD_STATE_RESET and next
> into UFSHCD_STATE_OPERATIONAL? If so, if the above code completes a 
> READ
> with status DID_BAD_TARGET and if recovery by the error handler
> succeeds, will that cause the filesystem above the UFS driver to change
> into read-only mode? If the above code completes a WRITE with status
> DID_BAD_TARGET, will that cause data corruption? Is there any other
> solution to prevent data corruption than merging the
> UFSHCD_STATE_EH_SCHEDULED_FATAL and UFSHCD_STATE_EH_SCHEDULED_NON_FATAL
> back into a single state and changing the ufshcd_rpm_get_sync(hba) call
> in ufshcd_err_handling_prepare() into a pm_runtime_get_noresume() call?
> 

Here, when hba->pm_op_in_progress is true, there cannot be READ or WRITE
command since hba is resuming or suspending. When fatal erorr happens, 
the
DID_BAD_TARGET above is intend to let the SSU (or whatever PM requests
blocking suspend/resume) fail fast (neither returning HOST_BUSY nor 
letting
the cmd pass through can achieve such purpose), so that error handling 
prepare
won't get stuck [1] when it calls

lock_system_sleep()
runtime_pm_get_sync()

The reason why I split UFSHCD_STATE_EH_SCHEDULED to 
UFSHCD_STATE_EH_SCHEDULED_FATAL
and UFSHCD_STATE_EH_SCHEDULED_NON_FATAL is that

1. For non-fatal errors, HW can recover by itself, so when host state is
UFSHCD_STATE_EH_SCHEDULED_NON_FATAL, cmd can still passthrough.

2. When non-fatal error (LINE-RESET for example) happens, error handler 
only
needs to do a power mode transition without a full reset. If we only 
have one
state, returning HOST_BUSY will get error handling prepare stuck [1], 
while
fast failing SSU cmds shall make error handler do a full reset (which 
goes
too far for non-fatal errors).

Thanks,

Can Guo.

> Thanks,
> 
> Bart.
