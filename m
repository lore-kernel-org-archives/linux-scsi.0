Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCAB4C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 15:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8638C20672
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 15:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIIPkN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 11:40:13 -0400
Received: from mga12.intel.com ([192.55.52.136]:54861 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbgIIPik (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Sep 2020 11:38:40 -0400
IronPort-SDR: d1GsyPyiZwWl4ulR8RjseG6zBdSS6PjRyZuDHyuknB86r0CQoMEqmk0pBLDgeZQVDq6Q59/8V3
 Ryo2CoYYBR5w==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="137847942"
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="137847942"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 07:06:32 -0700
IronPort-SDR: oEEFyWNbpQPRngTVKDuAJbpVTYcGsbTmtgnm2tPuu4g6/whgj+UfS89DoVGczN9funvDt7PqXc
 WIPiKHHJT1Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="328919425"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.190]) ([10.237.72.190])
  by fmsmga004.fm.intel.com with ESMTP; 09 Sep 2020 07:06:29 -0700
Subject: Re: [PATCH V2] scsi: ufs-pci: Add LTR support for Intel controllers
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20200827072030.24655-1-adrian.hunter@intel.com>
 <yq14kohexka.fsf@ca-mkp.ca.oracle.com>
 <dc615e02-18a3-334d-dbc4-8aba94e4be6b@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <a27fa387-356c-82e1-a49f-62602336589e@intel.com>
Date:   Wed, 9 Sep 2020 17:06:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <dc615e02-18a3-334d-dbc4-8aba94e4be6b@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/09/20 12:27 pm, Adrian Hunter wrote:
> On 2/09/20 5:12 am, Martin K. Petersen wrote:
>>
>> Adrian,
>>
>>> Intel host controllers support the setting of latency tolerance.
>>> Accordingly, implement the PM QoS ->set_latency_tolerance() callback. The
>>> raw register values are also exposed via debugfs.
>>
>> Does not apply to 5.10/scsi-queue. Please rebase. Thanks!
>>
> 
> Hi
> 
> Thanks for processing this.
> 
> The 5.10/scsi-queue branch seems to be missing the following fix.  If you cherry
> pick that, then it applies.

Now there seem to be conflicts between 5.10/scsi-queue and v5.9-rc4.
I am not sure what I can do?


~/git/scsi-mkp$ git branch -v --list 5.10/scsi-queue
* 5.10/scsi-queue 2e9defc7e918 [ahead 427, behind 97] scsi: ufs: Fix a race condition between error handler and runtime PM ops
~/git/scsi-mkp$ git rebase --onto v5.9-rc4 v5.9-rc1
First, rewinding head to replay your work on top of it...
Applying: scsi: ufs: Add checks before setting clk-gating states
Applying: scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()
Applying: scsi: ufs-qcom: Remove testbus dump in ufs_qcom_dump_dbg_regs
Applying: scsi: ufs: Add some debug information to ufshcd_print_host_state()
Applying: scsi: ufs: Fix concurrency of error handler and other error recovery paths
Applying: scsi: ufs: Recover HBA runtime PM error in error handler
Applying: scsi: ufs: Move dumps in IRQ handler to error handler
Applying: scsi: ufs: Fix a race condition between error handler and runtime PM ops
Applying: scsi: ufs: Properly release resources if a task is aborted successfully
Using index info to reconstruct a base tree...
M       drivers/scsi/ufs/ufshcd.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/scsi/ufs/ufshcd.c
CONFLICT (content): Merge conflict in drivers/scsi/ufs/ufshcd.c
error: Failed to merge in the changes.
Patch failed at 0009 scsi: ufs: Properly release resources if a task is aborted successfully
Use 'git am --show-current-patch' to see the failed patch

Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".

~/git/scsi-mkp$ git diff
diff --cc drivers/scsi/ufs/ufshcd.c
index d9386f85c255,efb40b1b95b4..000000000000
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@@ -6640,12 -6636,8 +6640,14 @@@ static int ufshcd_abort(struct scsi_cmn
                goto out;
        }
  
++<<<<<<< HEAD
 +cleanup:
 +      scsi_dma_unmap(cmd);
 +
++=======
++>>>>>>> scsi: ufs: Properly release resources if a task is aborted successfully
        spin_lock_irqsave(host->host_lock, flags);
-       ufshcd_outstanding_req_clear(hba, tag);
-       hba->lrb[tag].cmd = NULL;
+       __ufshcd_transfer_req_compl(hba, (1UL << tag));
        spin_unlock_irqrestore(host->host_lock, flags);
  
  out:

~/git/scsi-mkp$ git am --show-current-patch | head -25
commit 8bb2dde069d860e7ea379862a7d0e8ee01cec5e9
Author: Can Guo <cang@codeaurora.org>
Date:   Sun Aug 9 05:15:55 2020 -0700

    scsi: ufs: Properly release resources if a task is aborted successfully
    
    In current UFS task abort hook, namely ufshcd_abort(), if one task is
    aborted successfully, clk_gating.active_reqs held by this task is not
    decreased, which makes clk_gating.active_reqs stay above zero forever, thus
    clock gating would never happen. Instead of releasing resources of one task
    "manually", use the existing func __ufshcd_transfer_req_compl().  This
    change also eliminates a possible race of scsi_dma_unmap() from the real
    completion in IRQ handler path.
    
    Link: https://lore.kernel.org/r/1596975355-39813-10-git-send-email-cang@codeaurora.org
    Fixes: 1ab27c9cf8b6 ("ufs: Add support for clock gating")
    CC: Stanley Chu <stanley.chu@mediatek.com>
    Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
    Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
    Signed-off-by: Can Guo <cang@codeaurora.org>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

